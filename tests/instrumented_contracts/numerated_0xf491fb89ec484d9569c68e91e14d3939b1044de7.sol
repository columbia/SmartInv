1 //Tell the Solidity compiler what version to use
2 pragma solidity ^0.4.8;
3 
4 //Declares a new contract
5 contract SimpleStorageCleide {
6     //Storage. Persists in between transactions
7     uint price;
8 
9     //Allows the unsigned integer stored to be changed
10     function setCleide (uint newValue) 
11     public
12     {
13         price = newValue;
14     }
15     
16     //Returns the currently stored unsigned integer
17     function getCleide() 
18     public 
19     view
20     returns (uint) 
21     {
22         return price;
23     }
24 }