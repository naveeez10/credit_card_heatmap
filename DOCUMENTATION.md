## Structure and Layout

The `HeatMapWidget` organizes a year's worth of credit card transactions into a visual grid layout. This layout comprises two main components:

- **Month Labels**: Generates labels for each month displayed at the top of the heatmap. These are positioned based on the alignment of each month's start date with the first week of the month.
- **Heatmap Grid**: This grid consists of columns representing weeks, with each column containing day tiles that depict daily transactions.

## Core Functions

- **_buildMonthLabels()**: Utilizes the `DateTime` class to calculate the first day of each month within the selected year. Month labels are created for those months starting within the week, formatted with the `DateFormat` class from the `intl` package.
- **_buildHeatmap()**: Arranges daily transaction data into a format of weekly columns. Each column represents a week and includes day tiles where the color intensity signals the level of transaction activity.

## Day Tiles and Interaction

- **_createTile()**: Generates a tile for each day. The color of the tile varies based on the number of transactions, visually indicating spending levels. Tiles are interactive, enabling users to tap them to view detailed transactions for that day.
- **Tooltip Feature**: Each tile includes a tooltip that provides additional information about the transactions on that day, including the total amount spent and the number of transactions. This tooltip enhances user understanding and interaction by offering immediate insights without needing to navigate away from the heatmap.

## Data Handling

- **Mock Transaction Data**: The widget uses mock transaction data from `generateMockTransactions()` for demonstration and testing purposes. This approach allows for the visualization of spending patterns without the need for real user data.
- **Date Management**: Employs Dart’s `DateTime` and the `intl` package to handle date calculations and formatting accurately, ensuring that days and months are correctly positioned and labeled throughout the heatmap.

## User Feedback

- **Interactive Feedback**: Tapping on a day with transactions navigates the user to a detailed transactions page. For days without transactions, a snackbar message is displayed, enhancing the interactive experience.
