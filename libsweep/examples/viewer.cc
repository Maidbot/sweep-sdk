// Make use of the CMake build system or compile manually, e.g. with:
// g++ -std=c++11 viewer.cc -lsweep -lsfml-graphics -lsfml-window -lsfml-system

#include <cmath>

#include <iostream>
#include <mutex>
#include <utility>

#include <sweep/sweep.hpp>

#include <SFML/Graphics.hpp>
#include <SFML/System.hpp>
#include <SFML/Window.hpp>

// Zoom into 5x5 meter area
const constexpr auto kMaxLaserDistance = 5 * 100.;

// Use cream for the background and denim for points
static const sf::Color kColorCream{250, 240, 230};
static const sf::Color kColorDenim{80, 102, 127};

// One circle per angle / distance measurement
using PointCloud = std::vector<sf::CircleShape>;
using PointCloudMutex = std::mutex;

int main() try {
  sf::RenderWindow window(sf::VideoMode::getDesktopMode(), "Example Viewer for Scanse Sweep LiDAR");
  window.setFramerateLimit(30);
  window.setActive(false); // activated on render thread

  PointCloud pointCloud;
  PointCloudMutex pointCloudMutex;

  // Render thread displays the point cloud
  const auto worker = [&](sf::RenderWindow* window) {
    while (window->isOpen()) {
      sf::Event event;

      while (window->pollEvent(event)) {
        if (event.type == sf::Event::Closed)
          window->close();
      }

      window->clear(kColorCream);

      {
        std::lock_guard<PointCloudMutex> sentry{pointCloudMutex};

        for (auto point : pointCloud)
          window->draw(point);
      }

      window->display();
    }
  };

  sf::Thread thread(worker, &window);
  thread.launch();

  // Now start scanning in the second thread, swapping in new points for every scan
  sweep::sweep device;
  device.start_scanning();

  sweep::scan scan;

  while (window.isOpen()) {
    scan = device.get_scan();

    // 40m max radius => display as 80m x 80m square
    const auto windowSize = window.getSize();
    const auto windowMinSize = std::min(windowSize.x, windowSize.y);

    PointCloud localPointCloud;

    for (auto sample : scan.samples) {
      const constexpr auto kDegreeToRadian = 0.017453292519943295;

      const auto distance = static_cast<double>(sample.distance);

      // Discard samples above our we zoomed-in view box
      if (distance > kMaxLaserDistance)
        continue;

      // From milli degree to degree and adjust to device orientation
      const auto degree = std::fmod((static_cast<double>(sample.angle) / 1000. + 90.), 360.);
      const auto radian = degree * kDegreeToRadian;

      // From angle / distance to to Cartesian
      auto x = std::cos(radian) * distance;
      auto y = std::sin(radian) * distance;

      // Make positive
      x = x + kMaxLaserDistance;
      y = y + kMaxLaserDistance;

      // Scale to window size
      x = (x / (2 * kMaxLaserDistance)) * windowMinSize;
      y = (y / (2 * kMaxLaserDistance)) * windowMinSize;

      sf::CircleShape point{2.0f, 4};
      point.setPosition(x, windowMinSize - y);

      // Base transparency on signal strength
      auto color = kColorDenim;
      color.a = (sample.signal_strength / 100.0f) * 255.0f;
      point.setFillColor(color);

      localPointCloud.push_back(std::move(point));
    }

    {
      // Now swap in the new point cloud
      std::lock_guard<PointCloudMutex> sentry{pointCloudMutex};
      pointCloud = std::move(localPointCloud);
    }
  }

  device.stop_scanning();

} catch (const sweep::device_error& e) {
  std::cerr << "Error: " << e.what() << std::endl;
}
