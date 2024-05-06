#' Scrape data from a given URL using CSS selectors
#'
#' This function scrapes data from a given URL using CSS selectors for title and optional summary.
#'
#' @param url The URL of the website to scrape.
#' @param title_css CSS selector for the titles of the items to scrape.
#' @param summary_css CSS selector for the summaries of the items to scrape (optional).
#' @return A data frame containing the scraped data with columns for title, summary, source, and timestamp.
#' @details If summaries are not found, they default to empty strings.
#' @examples
#' \dontrun{
#' scrape_site("https://example.com", ".title-class", ".summary-class")
#' }
#' @export
#'
#' @importFrom rvest read_html html_elements html_text
#' @importFrom base Sys.time
scrape_site <- function(url, title_css, summary_css = NULL) {
  tryCatch({
    page <- rvest::read_html(url)

    titles <- rvest::html_text(rvest::html_elements(page, css = title_css), trim = TRUE)

    summaries <- NULL
    if (!is.null(summary_css)) {
      summaries <- rvest::html_text(rvest::html_elements(page, css = summary_css), trim = TRUE)
    }

    # Adjust data to ensure they are of the same length
    if (is.null(summaries)) {
      summaries <- rep("", length(titles))  # Default to empty string if summaries are absent
    } else {
      data_length <- max(length(titles), length(summaries))
      titles <- rep(titles, length.out = data_length)
      summaries <- rep(summaries, length.out = data_length)
    }

    data.frame(
      title = titles,
      summary = summaries,
      source = url,  # Add source column with URL
      timestamp = Sys.time(),  # Use base R's Sys.time
      stringsAsFactors = FALSE
    )
  }, error = function(e) {
    # Print an informative message if there's an error
    message("An error occurred while scraping the site:", url)
    message("Error message:", e$message)
    # Return NULL to signify failure
    NULL
  })
}

#' List of websites with URLs and CSS selectors
#'
#' This list contains information about various websites including their URLs and corresponding CSS selectors
#' for scraping titles and summaries.
#'
#' @name websites
#' @rdname websites
#' @aliases websites
#' @format A list of lists with elements 'url', 'title_css', and 'summary_css'.
#' @description A list of websites along with their respective URLs and CSS selectors for scraping titles and summaries.
#'
#' @details Each list within the main list represents a website and contains the following elements:
#' \itemize{
#'   \item \code{url}: The URL of the website.
#'   \item \code{title_css}: CSS selector for the titles of the items to scrape.
#'   \item \code{summary_css}: CSS selector for the summaries of the items to scrape (optional).
#' }
#'
#' @examples
#' \dontrun{
#' websites <- list(
#'   list(url = "https://www.theguardian.com/us", title_css = ".dcr-16c50tn .dcr-1elvov .dcr-dbozpd .dcr-1ay6c8s", summary_css = ".dcr-1usp5i4"),
#'   list(url = "https://www.chinadaily.com.cn/", title_css = ".twBox .txt1"),
#'   list(url = "https://www.dailymail.co.uk/home/index.html", title_css = ".articletext > p", summary_css = ".linkro-darkred"),
#'   list(url = "https://www.thestar.com/", title_css = ".tnt-headline", summary_css = ".tnt-summary"),
#'   list(url = "https://www.smh.com.au/", title_css = "._3N1qW", summary_css = "._3XEsE")
#' )
#' }
#' @seealso \code{\link{scrape_site}}
#' @export
websites <- list(
  list(url = "https://www.theguardian.com/us", title_css = ".dcr-16c50tn .dcr-1elvov .dcr-dbozpd .dcr-1ay6c8s", summary_css = ".dcr-1usp5i4"),
  list(url = "https://www.chinadaily.com.cn/", title_css = ".twBox .txt1"),
  list(url = "https://www.dailymail.co.uk/home/index.html", title_css = ".articletext > p", summary_css = ".linkro-darkred"),
  list(url = "https://www.thestar.com/", title_css = ".tnt-headline", summary_css = ".tnt-summary"),
  list(url = "https://www.smh.com.au/", title_css = "._3N1qW", summary_css = "._3XEsE")
)

#' Combine data scraped from multiple websites
#'
#' This function combines data scraped from multiple websites into a single data frame.
#'
#' @param websites A list containing information about various websites including their URLs and corresponding CSS selectors for scraping titles and summaries.
#' @return A data frame containing the combined data with columns for title, summary, source, and timestamp.
#' @details This function utilizes the \code{\link{scrape_site}} function to scrape data from each website specified in the input list. It then combines the scraped data into a single data frame.
#' @export
all_data <- dplyr::bind_rows(lapply(websites, function(site) {
  site_data <- scrape_site(site$url, site$title_css, site$summary_css)
  if (!is.null(site_data)) {
    site_data$source <- site$url
    return(site_data)
  } else {
    return(NULL)
  }
}))

# Save data to CSV
write.csv(all_data, paste0("scraped_data_", lubridate::today(), ".csv"), row.names = FALSE)

print("Data scraping completed!")
