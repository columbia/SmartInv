1 pragma solidity ^0.4.8;
2 
3 
4 contract PreICO {
5     bool public isPreIco;
6     address manager;
7 
8     uint256 maxPreOrderAmount = 500000000000000000000; //in wei
9     uint256 maxAmountSupply = 1875000000000000000000;
10 
11     struct dataHolder {
12         uint256 balance;
13         bool init;
14     }
15     mapping(address => dataHolder) holders;
16     address[] listHolders;
17 
18     function PreICO(){
19         manager = msg.sender;
20         isPreIco = false;
21     }
22 
23     modifier isManager(){
24         if (msg.sender!=manager) throw;
25         _;
26     }
27 
28     function kill() isManager {
29         suicide(manager);
30     }
31 
32     function getMoney() isManager {
33         if(manager.send(this.balance)==false) throw;
34     }
35 
36     function startPreICO() isManager {
37         isPreIco = true;
38     }
39 
40     function stopPreICO() isManager {
41         isPreIco = false;
42     }
43 
44     function countHolders() constant returns(uint256){
45         return listHolders.length;
46     }
47 
48     function getItemHolder(uint256 index) constant returns(address){
49         if(index >= listHolders.length || listHolders.length == 0) return address(0x0);
50         return listHolders[index];
51     }
52 
53     function balancsHolder(address who) constant returns(uint256){
54         return holders[who].balance;
55     }
56 
57     function() payable
58     {
59         if(isPreIco == false) throw;
60 
61         uint256 amount = msg.value;
62 
63         uint256 return_amount = 0;
64 
65         if(this.balance + msg.value > maxAmountSupply){
66             amount = maxAmountSupply - this.balance ;
67             return_amount = msg.value - amount;
68         }
69 
70         if(holders[msg.sender].init == false){
71             listHolders.push(msg.sender);
72             holders[msg.sender].init = true;
73         }
74 
75         if((amount+holders[msg.sender].balance) > maxPreOrderAmount){
76             return_amount += ((amount+holders[msg.sender].balance) - maxPreOrderAmount);
77             holders[msg.sender].balance = maxPreOrderAmount;
78         }
79         else{
80             holders[msg.sender].balance += amount;
81         }
82 
83         if(return_amount>0){
84             if(msg.sender.send(return_amount)==false) throw;
85         }
86 
87         if(this.balance == maxAmountSupply){
88             isPreIco = false;
89         }
90     }
91 }