#' Load and aggregate data from CSV files
#'
#' This function loads and aggregates data from CSV files with filenames matching the pattern "scraped_data_*.csv".
#'
#' @return A data frame containing the aggregated data from all CSV files.
#' @details This function first searches for CSV files in the current directory with filenames matching the specified pattern. It then loads each CSV file using the \code{utils::read.csv} function and aggregates them into a single data frame using \code{do.call(rbind, ...)}.
#' @examples
#' \dontrun{
#' loaded_data <- load_data()
#' }
#' @export
load_data <- function() {
  files <- tryCatch({
    list.files(pattern = "scraped_data_.*\\.csv")
  }, error = function(e) {
    cat("Error in reading files: ", e$message, "\n")
    return(NULL)
  })

  if (is.null(files)) return(NULL)

  data <- tryCatch({
    do.call(rbind, lapply(files, utils::read.csv, stringsAsFactors = FALSE))
  }, error = function(e) {
    cat("Error in loading data: ", e$message, "\n")
    return(NULL)
  })

  cat("Data loading completed successfully!\n")
  return(data)
}

#' Preprocess text data
#'
#' This function preprocesses text by tokenizing, removing stopwords and punctuation, and converting to lowercase.
#'
#' @param text A character vector containing the text data to be preprocessed.
#' @return A character vector of preprocessed text.
#' @details This function converts the input text to lowercase using \code{tolower}, removes punctuation using \code{tm::removePunctuation}, removes stopwords using \code{tm::removeWords}, and trims white spaces using \code{trimws}.
#' @examples
#' \dontrun{
#' preprocess_text <- preprocess_text("this is an example text.")
#' }
#' @export
preprocess_text <- function(text) {
  tryCatch({
    text <- tolower(text)
    text <- tm::removePunctuation(text)
    text <- tm::removeWords(text, tm::stopwords("en"))
    return(trimws(text))  # Trim white spaces
  }, error = function(e) {
    cat("Error in preprocessing text: ", e$message, "\n")
    return("")
  })
}

#' Calculate TF-IDF (Term Frequency-Inverse Document Frequency)
#'
#' This function calculates TF-IDF scores for text data.
#'
#' @param data A data frame containing text data with a 'title' column.
#' @return A data frame containing TF-IDF scores.
#' @details This function preprocesses the 'title' column of the input data by converting text to lowercase, removing punctuation and stopwords, and then calculates TF-IDF scores using the \code{tm} package.
#' @examples
#' \dontrun{
#' tfidf_scores <- calculate_tfidf(data)
#' }
#' @importFrom tm Corpus VectorSource DocumentTermMatrix weightTfIdf
#' @export
calculate_tfidf <- function(data) {
  if (is.null(data)) {
    cat("Data is null, skipping TF-IDF calculation.\n")
    return(NULL)
  }

  data <- data[!is.na(data$title) & data$title != "", ]

  tryCatch({
    data$title <- sapply(data$title, preprocess_text)

    corpus <- tm::Corpus(tm::VectorSource(data$title))

    dtm <- tm::DocumentTermMatrix(corpus)
    tfidf <- tm::weightTfIdf(dtm)

    tfidf_df <- as.data.frame(as.matrix(tfidf))
    cat("TF-IDF calculation completed successfully!\n")
    return(tfidf_df)
  }, error = function(e) {
    cat("Error in calculating TF-IDF: ", e$message, "\n")
    return(NULL)
  })
}

#' Analyze keyword trends, visualize, and save to CSV
#'
#' This function analyzes keyword trends based on TF-IDF scores, visualizes the top keywords, and saves the results to CSV and PNG files.
#'
#' @param tfidf_df A data frame containing TF-IDF scores for keywords.
#' @return None
#' @details This function calculates the mean TF-IDF scores for each keyword in the input data frame, identifies the top 10 keywords with the highest TF-IDF scores, and saves them to a CSV file named 'top_keywords_tfidf.csv'. It also creates a bar plot visualizing the top keywords and saves it as a PNG file named 'tfidf_plot.png'. Finally, it prints the plot.
#' @examples
#' \dontrun{
#' analyze_trends(tfidf_scores)
#' }
#' @importFrom ggplot2 ggplot geom_bar coord_flip labs theme_minimal ggsave
#' @export
analyze_trends <- function(tfidf_df) {
  if (is.null(tfidf_df)) {
    cat("TF-IDF data frame is null, skipping trend analysis.\n")
    return(NULL)
  }

  tryCatch({
    tfidf_mean <- colMeans(tfidf_df)
    top_keywords <- sort(tfidf_mean, decreasing = TRUE)[1:10]

    df <- data.frame(keyword = names(top_keywords), tfidf = top_keywords)

    # Save top keywords to CSV
    write.csv(df, "top_keywords_tfidf.csv", row.names = FALSE)
    cat("Top keywords saved to CSV.\n")

    p <- ggplot2::ggplot(df, ggplot2::aes(x = stats::reorder(keyword, tfidf), y = tfidf)) +
      ggplot2::geom_bar(stat = "identity") +
      ggplot2::coord_flip() +
      ggplot2::labs(title = "Top 10 Keywords by TF-IDF", x = "Keyword", y = "TF-IDF") +
      ggplot2::theme_minimal()

    ggplot2::ggsave("tfidf_plot.png", plot = p, width = 8, height = 6)
    cat("Plot saved as 'tfidf_plot.png'.\n")

    print(p)
  }, error = function(e) {
    cat("Error in analyzing trends: ", e$message, "\n")
    return(NULL)
  })
  cat("Analysis completed successfully!\n")
}

# Run the analysis
data <- load_data()
tfidf_df <- calculate_tfidf(data)
analyze_trends(tfidf_df)
