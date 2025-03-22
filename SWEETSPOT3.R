# === 📚 Load required libraries ===
library(ggplot2)    # From the 'ggplot2' package - for creating beautiful plots
library(ggthemes)   # From the 'ggthemes' package - adds extra themes to style your plots
library(ggrepel)    # From the 'ggrepel' package - prevents text labels from overlapping
library(dplyr)      # From the 'dplyr' package - makes data manipulation easier
library(scales)     # From the 'scales' package - used for nice axis tick formatting

# === 🗂️ Set your working directory ===
# This is where your data file is saved. Change the path if needed.
setwd("C:\\Users\\5030\\Documents\\RSCRIPTS\\SWEETCOUNT")

# === 📄 Load the data from a tab-separated text file ===
file_path <- "DATASTUDENTS.TXT"
guess_data <- read.table(
  file_path,
  header = TRUE,              # The first row contains column names
  sep = "\t",                 # Columns are separated by tabs
  stringsAsFactors = FALSE,   # Keep text as character, not factors
  fill = TRUE,                # Fill in rows with missing values
  quote = ""                  # Don’t treat quotation marks specially
)

# Rename the columns for easier access
colnames(guess_data) <- c("Name", "Guess")

# Convert guesses to numeric values (in case some are read as text)
guess_data$Guess <- as.numeric(guess_data$Guess)

# Remove rows with missing or non-positive guesses
guess_data <- guess_data[!is.na(guess_data$Guess) & guess_data$Guess > 0, ]

# === 🧮 Calculate basic statistics ===
mean_guess   <- mean(guess_data$Guess)    # Average (mean)
median_guess <- median(guess_data$Guess)  # Median (middle value)
num_guesses  <- nrow(guess_data)          # Total number of guesses
min_guess    <- min(guess_data$Guess)     # Smallest guess
max_guess    <- max(guess_data$Guess)     # Largest guess

# === 📏 Define x-axis limits for the plots ===
x_max_cut  <- quantile(guess_data$Guess, 0.95) * 1.5  # 1.5 times the 95th percentile
x_min_plot <- 0  # Start axis at 0

# === 🚨 Identify outliers (guesses above the 95th percentile) ===
pos_outliers <- guess_data %>% filter(Guess > quantile(Guess, 0.95))  # uses dplyr
pos_outlier_text <- if (nrow(pos_outliers) > 0) {
  paste("Outliers: ", paste(pos_outliers$Guess, collapse = ", "))
} else {
  ""
}

# === 📐 Set Y positions for plot 1 (just for layout) ===
guess_data$Ypos <- seq(from = 1, to = 200, length.out = nrow(guess_data))

# === 🧊 Add an information box for plot 1 ===
info_box_p0 <- data.frame(
  x = max(guess_data$Guess) * 0.95,  # Position on the right
  y = max(guess_data$Ypos),          # Position at the top
  label = paste("Guesses:", num_guesses,
                "\nMin:", min_guess,
                "\nMax:", max_guess)
)

# === 🎨 Common plot theme (from ggplot2) ===
common_theme <- theme_minimal() +  # from ggplot2
  theme(
    plot.title = element_text(size = 18, face = "bold", hjust = 0.5),
    axis.title.x = element_text(size = 16),
    axis.text.x = element_text(size = 12)
  )

# === 📊 Plot p0: Raw guesses on a log scale ===
p0 <- ggplot(guess_data, aes(x = Guess, y = Ypos, label = paste(Name, Guess))) +
  geom_text_repel(  # from ggrepel
    size = 1.5, color = "black", box.padding = 0.15, point.padding = 0.1,
    segment.color = NA, force = 1, max.overlaps = Inf
  ) +
  geom_label(  # Adds the info box
    data = info_box_p0, aes(x = x, y = y, label = label),
    fill = "blue", color = "white", size = 4, hjust = 1, vjust = 1
  ) +
  labs(
    title = "Raw Guesses",
    x = "Number of Sweets Guessed (log scale)",
    y = NULL
  ) +
  scale_x_log10(  # from ggplot2 - applies a log scale to x-axis
    breaks = c(10, 20, 50, 100, 200, 500, 1000, 2000)
  ) +
  common_theme

# === 🎯 Plot p1: Dot plot with mean & median lines ===
set.seed(42)  # Makes jitter reproducible
guess_data$Y_jitter <- jitter(rep(1, nrow(guess_data)), amount = 0.5)  # from base R
outlier_y_center_p1 <- mean(range(guess_data$Y_jitter))

p1 <- ggplot(guess_data, aes(x = Guess, y = Y_jitter)) +
  geom_point(color = "orchid", size = 2, alpha = 0.7) +
  geom_vline(xintercept = mean_guess, color = "red", linetype = "dashed", linewidth = 1) +
  geom_vline(xintercept = median_guess, color = "blue", linetype = "dashed", linewidth = 1) +
  scale_x_continuous(  # from ggplot2
    breaks = pretty_breaks(n = 10),  # pretty_breaks is from the scales package
    limits = c(x_min_plot, x_max_cut)
  ) +
  labs(title = "Exact Guesses (Each Dot = 1 Person)", x = "Number of Sweets Guessed", y = NULL) +
  common_theme +
  theme(axis.text.y = element_blank(), axis.ticks.y = element_blank(), axis.title.y = element_blank()) +
  geom_text(  # Show outlier values on the right
    data = data.frame(x = x_max_cut, y = outlier_y_center_p1, label = pos_outlier_text),
    aes(x = x, y = y, label = label),
    color = "red", size = 3, angle = 90, hjust = 0.5, fontface = "bold"
  ) +
  geom_text(aes(x = x_max_cut*0.9, y = Inf), label = paste("Mean:", round(mean_guess, 1)),
            color = "red", vjust = 2, hjust = 1, size = 4, fontface = "bold") +
  geom_text(aes(x = x_max_cut*0.9, y = Inf), label = paste("Median:", round(median_guess, 1)),
            color = "blue", vjust = 4, hjust = 1, size = 4, fontface = "bold") +
  theme(legend.position = "none")

# === 📦 Plot p2: Histogram with labeled bins ===
binwidth <- 50

# Build histogram and extract bin info (from ggplot2 internals)
bin_data <- ggplot_build(
  ggplot(guess_data %>% filter(Guess >= x_min_plot & Guess <= x_max_cut), aes(x = Guess)) +
    geom_histogram(binwidth = binwidth)
)$data[[1]]

# Create text labels like "100–150"
bin_data$label <- paste0(bin_data$xmin, "-", bin_data$xmax)
outlier_y_center_p2 <- max(bin_data$count) / 2

p2 <- ggplot(guess_data, aes(x = Guess)) +
  geom_histogram(binwidth = binwidth, fill = "lightseagreen", color = "black", alpha = 0.7) +
  geom_vline(xintercept = mean_guess, color = "red", linetype = "dashed", linewidth = 1) +
  geom_vline(xintercept = median_guess, color = "blue", linetype = "dashed", linewidth = 1) +
  scale_x_continuous(
    breaks = seq(100, ceiling(x_max_cut), by = 50),
    limits = c(x_min_plot, x_max_cut)
  ) +
  scale_y_continuous(
    name = "Number of Choices",
    limits = c(-1, NA),
    expand = expansion(mult = c(0.3, 0.05))  # Adds space below for labels
  ) +
  labs(title = "Histogram of Guesses (Grouped by Range)", x = NULL) +
  common_theme +
  theme(
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    axis.text.y = element_text(size = 10)
  ) +
  geom_text(data = bin_data %>% filter(!is.na(xmin) & !is.na(xmax)),
            aes(x = (xmin + xmax)/2, y = -1, label = label),
            size = 3, vjust = 1, hjust = 1, angle = 45, inherit.aes = FALSE) +
  geom_text(data = data.frame(x = x_max_cut, y = outlier_y_center_p2, label = pos_outlier_text),
            aes(x = x, y = y, label = label), color = "red", size = 3, angle = 90, hjust = 0.5, fontface = "bold") +
  geom_text(aes(x = x_max_cut*0.9, y = Inf), label = paste("Mean:", round(mean_guess, 1)),
            color = "red", vjust = 2, hjust = 1, size = 4, fontface = "bold") +
  geom_text(aes(x = x_max_cut*0.9, y = Inf), label = paste("Median:", round(median_guess, 1)),
            color = "blue", vjust = 4, hjust = 1, size = 4, fontface = "bold") +
  theme(legend.position = "none")

# === 🖼️ Finally, display all three plots ===
print(p0)
print(p1)
print(p2)
