1 pragma solidity ^0.4.0;
2 
3 contract Ownable {
4   address public owner;
5   function Ownable() public {
6     owner = msg.sender;
7   }
8 
9   modifier onlyOwner() {
10     if (msg.sender != owner)
11         throw;
12     _;
13   }
14   
15   modifier protected() {
16       if(msg.sender != address(this))
17         throw;
18       _;
19   }
20 
21   function transferOwnership(address newOwner) public onlyOwner {
22     if (newOwner == address(0))
23         throw;
24     owner = newOwner;
25   }
26 }
27 
28 contract DividendDistributor is Ownable{
29     event Transfer(
30         uint amount,
31         bytes32 message,
32         address target,
33         address currentOwner
34     );
35     
36     struct Investor {
37         uint investment;
38         uint lastDividend;
39     }
40 
41     mapping(address => Investor) investors;
42 
43     uint public minInvestment;
44     uint public sumInvested;
45     uint public sumDividend;
46     
47     function PrivateInvestment() public{ 
48         minInvestment = 0.4 ether;
49     }
50     
51     function loggedTransfer(uint amount, bytes32 message, address target, address currentOwner) protected
52     {
53         if(! target.call.value(amount)() )
54             throw;
55         Transfer(amount, message, target, currentOwner);
56     }
57     
58     function invest() public payable {
59         if (msg.value >= minInvestment)
60         {
61             investors[msg.sender].investment += msg.value;
62             sumInvested += msg.value;
63             // manually call payDividend() before reinvesting, because this resets dividend payments!
64             investors[msg.sender].lastDividend = sumDividend;
65         }
66     }
67 
68     function divest(uint amount) public {
69         if ( investors[msg.sender].investment == 0 || amount == 0)
70             throw;
71         // no need to test, this will throw if amount > investment
72         investors[msg.sender].investment -= amount;
73         sumInvested -= amount; 
74         this.loggedTransfer(amount, "", msg.sender, owner);
75     }
76 
77     function calculateDividend() constant public returns(uint dividend) {
78         uint lastDividend = investors[msg.sender].lastDividend;
79         if (sumDividend > lastDividend)
80             throw;
81         // no overflows here, because not that much money will be handled
82         dividend = (sumDividend - lastDividend) * investors[msg.sender].investment / sumInvested;
83     }
84     
85     function getInvestment() constant public returns(uint investment) {
86         investment = investors[msg.sender].investment;
87     }
88     
89     function payDividend() public {
90         uint dividend = calculateDividend();
91         if (dividend == 0)
92             throw;
93         investors[msg.sender].lastDividend = sumDividend;
94         this.loggedTransfer(dividend, "Dividend payment", msg.sender, owner);
95     }
96     
97     // OWNER FUNCTIONS TO DO BUSINESS
98     function distributeDividends() public payable onlyOwner {
99         sumDividend += msg.value;
100     }
101     
102     function doTransfer(address target, uint amount) public onlyOwner {
103         this.loggedTransfer(amount, "Owner transfer", target, owner);
104     }
105     
106     function setMinInvestment(uint amount) public onlyOwner {
107         minInvestment = amount;
108     }
109     
110     function () public payable onlyOwner {
111     }
112 
113     function destroy() public onlyOwner {
114         selfdestruct(msg.sender);
115     }
116 }