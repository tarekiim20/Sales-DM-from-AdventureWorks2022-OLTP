# Sales DM from AdventureWorks2022 OLTP

An ETL Project that creates a small Star Schema Data Mart for Sales from the AdventureWorks2022 OLTP Dataset.

## Index

1. [Introduction](#introduction)
2. [Project Stages](#project-stages)
3. [Project Workflow](#project-workflow)
4. [Replacing Null and Orphan Data Handling](#replacing-null-and-orphan-data-handling)
5. [Fact Table Loading](#fact-table-loading)
6. [Incremental Loading of Data](#incremental-loading-of-data)
7. [Star Schema](#star-schema)
8. [Conclusion](#conclusion)

## Introduction

Having data stored in a database is great for _running_ the business, but how to actually look at how the company is doing and performing requires more than an OLTP database. In this project, I have converted the AdventureWorks2022 dataset from OLTP data to a data mart that is ready for analysis and visualizations.

## Project Stages

1. **Data Source Selection**
   The data here is extracted from Microsoft's AdventureWorks2022 OLTP dataset. This dataset represents a virtual bike company with many departments like production, HR, and sales. The source file is found in the repo.

2. **Creation and Dimensional Modeling of the Data Mart**
   After determining which process I will create the data mart for (Sales), I looked at the level of granularity of the data. Since AdventureWorks is a retail company, each transaction could mean a story. So the level of granularity of my fact table will be transactional. Also, I discovered which dimensions could describe the process of selling, and I found that Products, Customer, Territories, and Date are helpful for such a process.

3. **ETL Process**
   In this stage, multiple tables are joined together to form the final dimensional model of the data mart (These will be shown in the next section).

4. **Data Cleansing and Preprocessing**
   Due to the usage of many joins of tables which result in many NULL values. Although these NULL values could be associated with other helpful columns that we can extract insights from, dealing with NULL values is mandatory for more efficiency and better manageability of data.

5. **Populating the Fact Table and Relationships Creation**
   In the final stage of the project comes the fact table which carries all the measures that will be the center of our analysis. In this stage, all records that represent a transaction made by a customer are populated to have a holistic view of the sales. Finally, we establish the relationships with the dimensions.

## Project Workflow

First, we have to look at the shape and structure of the data we are working with to be able to know what attributes and measures we will need and how the project will start. As mentioned in the Project Stages section, in this project I am trying to model the sales process, so let's start by looking at the sales details from AdventureWorks2022

![alt text](image.png)

We can see that the sales in AdventureWorks2022 have some important dimensions that could describe the process like:

1. Products
   ![alt text](Screenshots\Products_ERD.png)

2. Customers
   ![alt text](Screenshots\Customers_ERD.png)

3. Territory
   ![alt text](Screenshots\Territory_ERD.png)

4. Date

After having a general idea of what we are going to do, now it is time for using SSIS (SQL Server Integration Service) to do the extraction, transformation, and loading (ETL) of these tables to reach at the end this model

![alt text](Screenshots\Star_Schema.png)

_I have chosen to model the data mart as a star schema for the efficiency and fast retrieval of data to meet the customer needs._

### SSIS Packages

My solution is composed of 6 Packages (5 for the normal ETL process for each dimension and 1 for incremental load of the fact table which will be discussed later).

![alt text](Screenshots\SSIS_Packages.png)

### DimProducts

In the ETL Process of the DimProducts, I have used the SCD (Slowly Changing Dimension) Package to capture the change if done to any of the products and here is a photo for the initial load.

![alt text](Screenshots\DimProducts_ETL.png)

With a total of 504 products. But what if some attributes have changed like here?

![alt text](Screenshots\Products_Query_to_Show_SCD.png)

We see here that

- 51 rows have undergone type 2 change (replacing a record without adding a row)
- 50 rows have undergone type 3 change (adding a new row for historical records)
- 50 rows have been deleted.

So how would the solution respond to such changes?

![alt text](Screenshots\DimProduct_After_Justification_of_SDC.png)

We see that the DimProducts ETL process didn't load the full table again and have done the changes accordingly.

### DimCustomers

By the same concept as the DimProducts, I have joined multiple tables to reach the customers' dimension. And here is the full initial load of the dimension table.

![alt text](Screenshots\DimCustomers_Initial_Load.png)

We can see that we have 19,111 customers in our dimension. So what if one of the customers has changed their phone number or address?

![alt text](Screenshots\DimCustomers_SDC_Check_Query.png)

We see that we have updated and deleted some data related to our customers dimension and here is how the package will respond to these changes.

![alt text](Screenshots\DimCustomers_after_Justification.png)

The package has added the deleted observations and has dealt with the updated records depending on the chosen change type. And here is how a historical record will look like.

![alt text](Screenshots\Customers_SDC_screenshot.png)

### DimTerritory

![alt text](Screenshots\DimTerritory_Initial_Load.png)

Here is how the table looks after initial load

![alt text](Screenshots\Dim_Territory_After_Load.png)

Do you realize something here? There is a -1 Surrogate key with an 'Unknown' observation. We will discuss this part in the next section.

### DimDate

For the date dimension, I have loaded it from a CSV file.

![alt text](Screenshots\DimDate_Loading_from_CSV.png)

## Replacing Null and Orphan Data Handling

Due to multiple joins from the dimensions and fact table, you will notice NULL values a lot. So I have added in each dimension (except the date dimension because it is not allowed to have a NULL date) an observation with the -1 Surrogate key. This observation will be referenced each and every time a null value occurs in the fact table. Now we can handle the NULL values by grouping them into one observation and actually have some insights from data just being NULL!

## Fact Table Loading

For the fact table, I have chosen some measures from the ERD of the sales.

![alt text](Screenshots\Sales_Order_ERD.png)

The measures in the fact table are numeric like qty, cost, price, tax amount, or a flag like OnlineOrderFlag which represents whether an order is online or not. Also, I have created a column in the fact table (CreatedAt) to tell when this data was loaded. Here is the initial load of the fact table.

![alt text](Screenshots\Full_Load_Fact_Table.png)

_121317 rows have been loaded_. But we can wait and ask here what will happen when this data grows? This is supposed to be a data mart for sales, so the data will grow rapidly. How do we deal with that?

### Incremental loading of data

I have created a Meta Data control table to record the last time an ETL process was done. This meta data table helps in querying the data that is only AFTER the last ETL process. So after adding new records to the source like this:

![alt text](Screenshots\Inserting_Into_Source_table.png)

Using this package to load the data:
![alt text](Screenshots\Task_Flow_Incremental_Load.png)

![alt text](Screenshots\Incremental_Load_of_Fact_Sales.png)

## Star Schema

In the final part of the project, I have modeled the data mart and created the star schema.

![alt text](Screenshots\Star_Schema.png)

## Conclusion

This project resembled a scenario in which I was responsible for creating a sales data mart for a company. I have used technologies like _SSIS and SSMS_ to handle the data. I also have used some of the intelligence tools like orphan handling and data warehousing standards to build the data mart which is ready for analysis and insights. This project is designed to be built upon. With the data mart now established, you can start extracting insights and building dashboards to visualize the sales data. Utilize tools like Power BI, Tableau, or any other BI tools to create compelling reports and dashboards that provide valuable business insights.
