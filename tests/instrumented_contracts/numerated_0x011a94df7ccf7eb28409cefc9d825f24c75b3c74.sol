1 /**
2  * Source Code first verified at https://etherscan.io on Saturday, May 18, 2019
3  (UTC) */
4 
5 /**
6  * Source Code first verified at https://etherscan.io on Wednesday, May 15, 2019
7  (UTC) */
8 
9 /**
10  * Source Code first verified at https://etherscan.io on Tuesday, May 14, 2019
11  (UTC) */
12 
13 /**
14  * Source Code first verified at https://etherscan.io on Tuesday, May 14, 2019
15  (UTC) */
16 
17 /**
18  * Source Code first verified at https://etherscan.io on Thursday, April 25, 2019
19  (UTC) */
20 
21 pragma solidity ^0.4.25;
22 contract SalaryInfo {
23     struct User {
24         string name;
25         // string horce_image;
26         // string unique_id;
27         // string sex;
28         // uint256 DOB;
29         // string country_name;
30         // string Pedigree_name;
31         // string color;
32         // string owner_name;
33         // string breed;
34         // string Pedigree_link;
35     }
36     User[] public users;
37 
38     function addUser(string name, string horce_image, string unique_id, string sex,string DOB, string country_name, string Pedigree_name,string color, string owner_name,string breed,string Pedigree_link,string Pedigree_image) public returns(uint) {
39         users.length++;
40         // users[users.length-1].salaryId = unique_id;
41         users[users.length-1].name = name;
42         // users[users.length-1].userAddress = horce_image;
43        //users[users.length-1].salary = _salary;
44         return users.length;
45     }
46       
47       
48      function add_medical_records(string record_type, string medical_date, string vaccination,string product,string details) public returns(uint) {
49     //     users.length++;
50     //     // users[users.length-1].salaryId = unique_id;
51     //     users[users.length-1].name = name;
52     //     // users[users.length-1].userAddress = horce_image;
53     //   //users[users.length-1].salary = _salary;
54     //     return users.length;
55      }
56     
57     function getUsersCount() public constant returns(uint) {
58         return users.length;
59     }
60 
61     function getUser(uint index) public constant returns(string) {
62         return (users[index].name);
63     }
64 }