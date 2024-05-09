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
12     uint public MinInvestment = 0.1 ether;
13    
14     function loggedTransfer(uint amount, bytes32 logMsg, address target, address currentOwner) 
15     payable
16     {
17        if(msg.sender != address(this))throw;
18        if(target.call.value(amount)())
19        {
20           CashMove(amount, logMsg, target, currentOwner);
21        }
22     }
23     
24     function Invest() 
25     public 
26     payable 
27     {
28         if (msg.value > MinInvestment)
29         {
30             investors[msg.sender] += msg.value;
31         }
32     }
33 
34     function Divest(uint amount) 
35     public 
36     {
37         if ( investors[msg.sender] > 0 && amount > 0)
38         {
39             this.loggedTransfer(amount, "", msg.sender, owner);
40             investors[msg.sender] -= amount;
41         }
42     }
43     
44     function SetMin(uint min)
45     public
46     {
47         if(msg.sender==owner)
48         {
49             MinInvestment = min;
50         }
51     }
52 
53     function GetInvestedAmount() 
54     constant 
55     public 
56     returns(uint)
57     {
58         return investors[msg.sender];
59     }
60 
61     function withdraw() 
62     public 
63     {
64         if(msg.sender==owner)
65         {
66             this.loggedTransfer(this.balance, "", msg.sender, owner);
67         }
68     }
69     
70     
71 }