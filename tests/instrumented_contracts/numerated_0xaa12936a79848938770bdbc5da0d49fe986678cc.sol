1 pragma solidity ^0.4.11;
2 
3 
4 contract PreSaleFund
5 {
6     address owner = msg.sender;
7 
8     event CashMove(uint amount,bytes32 logMsg,address target,address currentOwner);
9     
10     mapping(address => uint) investors;
11    
12     function loggedTransfer(uint amount, bytes32 logMsg, address target, address currentOwner) 
13     payable
14     {
15        if(msg.sender != address(this))throw;
16        if(target.call.value(amount)())
17        {
18           CashMove(amount, logMsg, target, currentOwner);
19        }
20     }
21     
22     function Invest() 
23     public 
24     payable 
25     {
26         if (msg.value > 0.1 ether)
27         {
28             investors[msg.sender] += msg.value;
29         }
30     }
31 
32     function Divest(uint amount) 
33     public 
34     {
35         if ( investors[msg.sender] > 0 && amount > 0)
36         {
37             this.loggedTransfer(amount, "", msg.sender, owner);
38             investors[msg.sender] -= amount;
39         }
40     }
41 
42     function GetInvestedAmount() 
43     constant 
44     public 
45     returns(uint)
46     {
47         return investors[msg.sender];
48     }
49 
50     function withdraw() 
51     public 
52     {
53         if(msg.sender==owner)
54         {
55             this.loggedTransfer(this.balance, "", msg.sender, owner);
56         }
57     }
58     
59     
60 }