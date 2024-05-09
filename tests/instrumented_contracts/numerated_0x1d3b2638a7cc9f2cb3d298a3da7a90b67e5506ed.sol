1 /*
2   Copyright (c) 2015-2016 Oraclize SRL
3   Copyright (c) 2016 Oraclize LTD
4 */
5 
6 contract OraclizeAddrResolver {
7 
8     address public addr;
9 
10     address owner;
11 
12     function OraclizeAddrResolver(){
13         owner = msg.sender;
14     }
15 
16     function changeOwner(address newowner){
17         if (msg.sender != owner) throw;
18         owner = newowner;
19     }
20 
21     function getAddress() returns (address oaddr){
22         return addr;
23     }
24 
25     function setAddr(address newaddr){
26         if (msg.sender != owner) throw;
27         addr = newaddr;
28     }
29 
30 }