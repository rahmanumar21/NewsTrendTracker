### NewsTrendTracker

#### Summary
NewsTrendTracker is an R package designed for automatic analysis of trending topics on the internet. 
It facilitates web scraping of news data from multiple English-language news websites, text data preprocessing, 
and analysis of keyword trends using the TF-IDF (Term Frequency-Inverse Document Frequency) method. 
The package aims to simplify the process of gathering, processing, and visualizing news data to identify trending topics and insights from online news sources.

#### Description
NewsTrendTracker provides a set of functions for scraping data from various English-language news websites, 
aggregating the scraped data, preprocessing text data, calculating TF-IDF scores, analyzing keyword trends, 
and visualizing the results. It includes utilities to streamline the scraping process, combine data from multiple websites, 
and generate informative visualizations.

#### Key Features
- Web scraping of news data from multiple websites.
- Preprocessing of text data for analysis.
- Calculation of TF-IDF scores to identify keyword trends.
- Visualization of keyword trends through bar plots.
- Simplified workflow for analyzing and visualizing trending topics in online news sources.

#### Usage
1. **Data Scraping**
   - Utilize functions to scrape news data from English-language news websites.

2. **Text Preprocessing**
   - Preprocess text data to remove stopwords, punctuation, and convert to lowercase.

3. **TF-IDF Calculation**
   - Calculate TF-IDF scores to identify the importance of keywords in the corpus.

4. **Keyword Trends Analysis**
   - Analyze keyword trends and visualize the top keywords using TF-IDF scores.

#### Installation
To install NewsTrendTracker, you can use the `devtools` package:
```R
devtools::install_github("your_username/NewsTrendTracker")
```

#### Additional Notes
- Ensure that required packages (`rvest`, `dplyr`, `ggplot2`, `tm`, `lubridate`) are installed.
- Configure the list of websites and CSS selectors for scraping data accordingly.
- Check the file naming convention for scraped data files to match the required pattern.

#### Author
A. Rahman
