1 /*
2 Copyright (c) 2015-2016 Oraclize srl, Thomas Bertani
3 */
4 
5 contract OraclizeAddrResolver {
6 
7     address public addr;
8     
9     address owner;
10     
11     function OraclizeAddrResolver(){
12         owner = msg.sender;
13     }
14     
15     
16     function getAddress() returns (address oaddr){
17         return addr;
18     }
19     
20     function setAddr(address newaddr){
21         if (msg.sender != owner) throw;
22         addr = newaddr;
23     }
24     
25 }