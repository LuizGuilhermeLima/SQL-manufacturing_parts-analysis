# MySQL - Manufacturing process alert creation from data analysis

Manufacturing processes for any product is like putting together a puzzle. Products are pieced together step by step, and keeping a close eye on the process is important.

For this project, you're supporting a team that wants to improve how they monitor and control a manufacturing process. The goal is to implement a more methodical approach known as statistical process control (SPC). SPC is an established strategy that uses data to determine whether the process works well. Processes are only adjusted if measurements fall outside of an acceptable range.

This acceptable range is defined by an upper control limit (UCL) and a lower control limit (LCL), the formulas for which are:

![image](https://github.com/LuizGuilhermeLima/SQL-manufacturing_parts-analysis/assets/105224925/ab34754c-4604-4c5d-b718-8ca26d07065a)

The UCL defines the highest acceptable height for the parts, while the LCL defines the lowest acceptable height for the parts. Ideally, parts should fall between the two limits.
Using SQL window functions and nested queries, you'll analyze historical manufacturing data to define this acceptable range and identify any points in the process that fall outside of the range and therefore require adjustments. This will ensure a smooth running manufacturing process consistently making high-quality products.
The data
The data is available in the manufacturing_parts table which has the following fields:

•	item_no: the item number

•	length: the length of the item made

•	width: the width of the item made

•	height: the height of the item made

•	operator: the operating machine


Analyze the manufacturing_parts table and determine whether a manufacturing process is working well or requires adjustment:

•	Create an alert that flags whether the height of a product is within the control limits for each operator using the formulas provided in the notebook.

The final query should return the following fields: operator, row_number, height, avg_height, stddev_height, ucl, lcl, alert, and be ordered by the the item_no.

Use a window function of length 5 considering rows before and including the current row; incomplete window rows should be removed in the final query output. 


![image](https://github.com/LuizGuilhermeLima/SQL-manufacturing_parts-analysis/assets/105224925/9e150130-2d8b-47e2-b3ff-86d40bf01ce6)

![image](https://github.com/LuizGuilhermeLima/SQL-manufacturing_parts-analysis/assets/105224925/c4b46291-4736-442d-a898-7050d82a4e0b)

![image](https://github.com/LuizGuilhermeLima/SQL-manufacturing_parts-analysis/assets/105224925/08f043e5-f823-47d2-9932-266f926395fb)

![image](https://github.com/LuizGuilhermeLima/SQL-manufacturing_parts-analysis/assets/105224925/890bc5ec-bdc7-4112-b130-84e087b7ed2a)
