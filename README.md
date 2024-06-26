# Beekeeping Management App

[![Beekeeping CI](https://github.com/mihael10/beekeeping/actions/workflows/dart.yml/badge.svg)](https://github.com/mihael10/beekeeping/actions/workflows/dart.yml)


## Overview

The Beekeeping Management App is designed to help beekeepers efficiently manage their hives, tasks, and tags. This application allows users to keep track of hive details, schedule and monitor tasks, and categorize activities for better organization.

## Features

- **Hive Management**: Add, edit, and delete hives. View detailed information about each hive.
- **Task Management**: Create, update, complete, and reopen tasks. Tasks are associated with specific hives and can be categorized with tags.
- **Tag Management**: Create and manage tags to categorize tasks.
- **Dashboard**: View a summary of hives with tasks due today or overdue.
- **Data Persistence**: All data is saved locally in JSON files, ensuring that your data is preserved between app sessions.

## Screenshots

<!-- Add screenshots of your app here -->


## Installation

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) installed on your development machine.
- A code editor like [VS Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio).

### Steps

1. **Clone the repository**

    ```sh
    git clone https://github.com/yourusername/beekeeping-management.git
    cd beekeeping-management
    ```

2. **Install dependencies**

    ```sh
    flutter pub get
    ```

3. **Run the app**

    ```sh
    flutter run
    ```

## Usage

### Adding a Hive

1. Navigate to the Hives screen.
2. Click on the "Add Hive" button.
3. Fill in the hive details and click "Save".

### Managing Tasks

1. Navigate to the Tasks screen.
2. Click on the "Add Task" button.
3. Select the hive and tag, fill in the task details, and click "Save".

### Managing Tags

1. Navigate to the Tags screen.
2. Click on the "Add Tag" button.
3. Enter the tag name and click "Save".

### Dashboard

- The dashboard displays hives with tasks that are due today or overdue.
- Click on a hive to view and manage its tasks.

## Contributing

We welcome contributions to the Beekeeping Management App! To contribute:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Commit your changes.
4. Push to your branch.
5. Create a pull request.

Please read our [CONTRIBUTING.md](CONTRIBUTING.md) for more details.

## License

This project is licensed under the GNU General Public License v3.0. See the [LICENSE](LICENSE.md) file for details.
