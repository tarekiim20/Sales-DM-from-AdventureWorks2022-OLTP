# Sales DM from AdventureWorks2022 OLTP

An ETL Project that creates a small Star Schema Data Mart for Sales from the AdventureWorks2022 OLTP Dataset.

## Index

1. [Introduction](#introduction)
2. [Project Stages](#project-stages)
3. [Project Workflow](#project-workflow)
4. [Replacing Null and Orphan Data Handling](#replacing-null-and-orphan-data-handling)
5. [Fact Table Loading](#fact-table-loading)
6. [Incremental Loading of Data](#incremental-loading-of-data)
7. [Conclusion](#conclusion)

## Introduction

Having data stored in a database is great for _running_ the business, but how to actually look at how the company is doing and performing requires more than an OLTP database. In this project, I have converted the AdventureWorks2022 dataset from OLTP data to a data mart that is ready for analysis and visualizations.

## Project Stages

1. **Data Source Selection**
   The data here is extracted from Microsoft's AdventureWorks2022 OLTP dataset. This dataset represents a virtual bike company with many departments like production, HR, and sales. The source file is found in the repo.

2. **Creation and Dimensional Modeling of the Data Mart**
   After determining which process I would create the data mart for (Sales), I looked at the level of granularity of the data. Since AdventureWorks is a retail company, each transaction could mean a story. So the level of granularity of my fact table will be transactional. Also, I discovered which dimensions could describe the selling process, and I found that Products, Customers, Territories, and Date are helpful for such a process.

3. **ETL Process**
   In this stage, multiple tables are joined together to form the final dimensional model of the data mart (These will be shown in the next section).

4. **Data Cleansing and Preprocessing**
   The usage of many joins of tables results in many NULL values. Although these NULL values could be associated with other helpful columns that we can extract insights from, dealing with NULL values is mandatory for more efficiency and better data management.

5. **Populating the Fact Table and Relationships Creation**
   In the final stage of the project comes the fact table which carries all the measures that will be the center of our analysis. In this stage, all records that represent a transaction made by a customer are populated to have a holistic view of the sales. Finally, we establish the relationships with the dimensions.

## Project Workflow

First, we have to look at the shape and structure of the data we are working with to be able to know what attributes and measures we will need and how the project will start. As mentioned in the Project Stages section, in this project I am trying to model the sales process, so let's start by looking at the sales details from AdventureWorks2022

![Sales_Order_ERD](https://github.com/user-attachments/assets/7a3f43c0-2d7c-48fe-a629-3af00f458957)



We can see that the sales in AdventureWorks2022 have some important dimensions that could describe the process like:

1. Products
   
   ![Products_ERD](https://github.com/user-attachments/assets/dc682d88-3f2d-437a-9fdc-172ed9de48b5)

2. Customers

   ![Customers_ERD](https://github.com/user-attachments/assets/bbcea7cb-89c3-435a-b089-a80fb76dd444)

4. Territory

   ![Territory_ERD](https://github.com/user-attachments/assets/24fe839d-8946-4b36-ae29-ca15e1d60b65)


6. Date

After having a general idea of what we are going to do, now it is time to use SSIS (SQL Server Integration Service) to do the extraction, transformation, and loading (ETL) of these tables to reach the end of this model

![Star_Schema](https://github.com/user-attachments/assets/d4005545-5571-49b0-8920-21f1000b1383)


_I have chosen to model the data mart as a star schema for the efficiency and fast retrieval of data to meet customer needs._

### SSIS Packages

My solution is composed of 6 Packages (5 for the normal ETL process for each dimension and 1 for the incremental load of the fact table which will be discussed later).

![SSIS_Packages](https://github.com/user-attachments/assets/e3a118dd-0465-470b-8c00-4f648c3497c9)


### DimProducts

In the ETL Process of the DimProducts, I have used the SCD (Slowly Changing Dimension) Package to capture the change if done to any of the products and here is a photo for the initial load.

![DimProducts_ETL](https://github.com/user-attachments/assets/a09c28aa-42c1-4147-b461-d637f4386dd5)


With a total of 504 products. But what if some attributes have changed like here?

![Products_Query_to_Show_SCD](https://github.com/user-attachments/assets/4717911c-9bd4-41e3-b39a-c458fd936947)


We see here that

- 51 rows have undergone type 2 change (replacing a record without adding a row)
- 50 rows have undergone type 3 change (adding a new row for historical records)
- 50 rows have been deleted.

So how would the solution respond to such changes?

![DimProduct_After_Justification_of_SDC](https://github.com/user-attachments/assets/4ffac50a-3f20-448a-8db9-a4cbdecada84)


We see that the DimProducts ETL process didn't load the full table again and have done the changes accordingly.

### DimCustomers

By the same concept as the DimProducts, I have joined multiple tables to reach the customers' dimension. Here is the full initial load of the dimension table.

![DimCustomers_Initial_Load](https://github.com/user-attachments/assets/077d2a80-6185-4d73-a047-ec81ef1e6154)

We can see that we have 19,111 customers in our dimension. So what if one of the customers has changed their phone number or address?

![DimCustomers_SDC_Check_Query](https://github.com/user-attachments/assets/a08e36fb-9dec-4ea3-8ac7-85f66c6da368)


We see that we have updated and deleted some data related to our customer's dimensions and here is how the package will respond to these changes.

![DimCustomers_after_Justification](https://github.com/user-attachments/assets/e49d9fe4-373b-4339-bb7f-9c04c96945ee)


The package has added the deleted observations and has dealt with the updated records depending on the chosen change type. And here is what a historical record will look like.

![Customers_SDC_screenshot](https://github.com/user-attachments/assets/56daeeb1-7a96-4cb3-a68c-4dca293d44ee)


### DimTerritory

![DimTerritory_Inital_Load](https://github.com/user-attachments/assets/9191b8b9-168f-4e5d-bf1b-c188b24914ce)


Here is how the table looks after the initial load

![Dim_Territory_After_Load](https://github.com/user-attachments/assets/3b74664d-3148-4e59-af3c-3a8741a479e2)

**Do you realize something here? There is a -1 Surrogate key with an 'Unknown' observation. We will discuss this part in the next section.**

### DimDate

For the date dimension, I have loaded it from a CSV file.


![DimDate_Loading_from_CSV](https://github.com/user-attachments/assets/af3f195c-fea3-4deb-ad23-5725e2bf29d6)

## Replacing Null and Orphan Data Handling

Due to multiple joins from the dimensions and fact table, you will notice NULL values a lot. So I have added in each dimension (except the date dimension because it is not allowed to have a NULL date) an observation with the -1 Surrogate key. This observation will be referenced every time a null value occurs in the fact table. Now we can handle the NULL values by grouping them into one observation and have some insights from data just being NULL!

## Fact Table Loading

The measures in the fact table are numeric like qty, cost, price, tax amount, or a flag like OnlineOrderFlag which represents whether an order is online or not. Also, I have created a column in the fact table (CreatedAt) to tell when this data was loaded. Here is the initial load of the fact table.

![Full_Load_Fact_Table](https://github.com/user-attachments/assets/2729f1af-3be6-467c-9145-a9287ca1a7ef)

_121317 rows have been loaded_. But we can wait and ask here what will happen when this data grows. This is supposed to be a data mart for sales, so the data will grow rapidly. How do we deal with that?

### Incremental loading of data

I have created a Meta Data control table to record the last time an ETL process was done. This metadata table helps in querying the data that is only AFTER the last ETL process. So after adding new records to the source like this:

![Inserting_Into_Source_table](https://github.com/user-attachments/assets/ea40cf13-a3a6-44f4-89b0-065e3344efb8)


Using this package to load the data:

![Task_Flow_Incrimental_Load](https://github.com/user-attachments/assets/3250c949-ac85-4590-b0e2-43912b548980)

![Incrimental_Load_of_Fact_Sales ](https://github.com/user-attachments/assets/f655f8fb-61ee-4131-8dec-b96d99385174)


## Conclusion

This project resembled a scenario in which I was responsible for creating a sales data mart for a company. I have used technologies like _SSIS and SSMS_ to handle the data. I also have used some of the intelligence tools like orphan handling and data warehousing standards to build the data mart which is ready for analysis and insights. This project is designed to be built upon. With the data mart now established, you can start extracting insights and building dashboards to visualize the sales data. Utilize tools like Power BI, Tableau, or any other BI tools to create compelling reports and dashboards that provide valuable business insights.
