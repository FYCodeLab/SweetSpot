# SweetSpot
![Intro to R](https://img.shields.io/badge/SweetSpot-276DC3?style=for-the-badge&logo=r&logoColor=white)\
**Language:** R  
**Purpose:** Classroom exercise — let students guess the number of sweets in a jar. This script calculates the mean, median, and removes outliers. It generates three plots in RStudio to visually illustrate key statistical concepts.

## Overview

**SweetSpot** is an engaging classroom activity designed to introduce students to basic statistics and the power of collective intelligence ("wisdom of the crowd"). Using R and a simple in-class exercise, students will submit their guesses for how many sweets are in a jar, and the teacher will use this script to process and visualize the results.

---

## What You Need

- A transparent jar filled with sweets (any kind!)
- An online form to collect guesses  
  *(Google Forms, Microsoft Forms, Framaforms, etc.)*
- RStudio displayed on screen in the classroom
- The `SWEETSPOT.R` script and a `DATASTUDENTS.TXT` file to hold the collected responses

---

## Procedure

1. **Students vote**  
   Students submit their guesses via the online form.

2. **Data is transferred**  
   The teacher copies the guesses from the form results into a simple `Data.txt` file (one number per line).

3. **Run the R script**  
   The teacher opens RStudio and runs the provided script.

4. **Visualize the results**  
   The script produces three key graphs:
   - A log-scaled plot with labels for each guess
   - A jittered dot plot showing the distribution of guesses
   - A histogram with automatic outlier detection and annotations

5. **Facilitate discussion**  
   Use the visualizations to engage students in a conversation about:
   - Mean vs. median
   - Outliers and their effect
   - Crowd wisdom and data aggregation
   - Real-world uses of such techniques in polling, forecasting, etc.

---

## Example Output

*(Replace with real screenshots if desired)*

<img src="https://github.com/FYCodeLab/SweetSpot/blob/main/assets/jar-code.png?raw=true" width="800"/>
<img src="https://github.com/FYCodeLab/SweetSpot/blob/main/assets/screenshots-sweetspot.jpg?raw=true" width="800"/>



---

## How to Use

1. Collect guesses and paste them (as one number per line) into `DATASTUDENTS.TXT`.
2. Open RStudio and run `SWEETCOUNT3.R`.
3. Plots will be displayed in the RStudio plot viewer.
4. Discuss the results in class!

---

## Educational Objectives

- Understand basic statistical concepts (mean, median, outliers)
- Visualize and interpret numerical data
- Learn about collective estimation and "wisdom of the crowd"
- Practice reproducible data science using R

---

## License

MIT License — feel free to adapt and reuse in your own classrooms!

---

## Contributions
Thanks to Julien Grimaud for his patient discussions on the gield of AI and data, and to Mae Bourgeois for stimulating my interest in R.

As always, my programming capabilities are largely supported by ChatGPT. 4.5 , DeepSeek R1 and the Amazingly fast Mistral. For once Claude wasn't in the party. 

Suggestions and improvements are welcome — especially ideas for new plots or educational enhancements. Submit a pull request or open an issue!
