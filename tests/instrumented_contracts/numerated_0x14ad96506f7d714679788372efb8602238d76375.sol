1 pragma solidity ^0.4.24;
2 
3 interface Token {
4     function transfer(address _to, uint256 _value) external;
5 }
6 
7 contract AENCrowdsale {
8     
9     Token public tokenReward;
10     address public creator;
11     address public owner;
12     uint256 public totalSold;
13 
14     event FundTransfer(address beneficiaire, uint amount);
15 
16     constructor() public {
17         creator = msg.sender;
18         tokenReward = Token(0xBd11eaE443eF0E96C1CC565Db5c0b51f6c829C0b);
19     }
20 
21     function setOwner(address _owner) public {
22         require(msg.sender == creator);
23         owner = _owner;      
24     }
25 
26     function setCreator(address _creator) public {
27         require(msg.sender == creator);
28         creator = _creator;      
29     }
30 
31     function setToken(address _token) public {
32         require(msg.sender == creator);
33         tokenReward = Token(_token);      
34     }
35     
36     function sendToken(address _to, uint256 _value) public {
37         require(msg.sender == creator);
38         tokenReward.transfer(_to, _value);      
39     }
40     
41     function kill() public {
42         require(msg.sender == creator);
43         selfdestruct(owner);
44     }
45 
46     function () payable public {
47         require(msg.value > 0 && msg.value < 5.1 ether);
48 	    uint amount = msg.value * 5000;
49 	    amount = amount / 20;
50         
51         // 8 september 2018 - 14 september 2018: 30% bonus
52         if(now > 1536361200 && now < 1536966000) {
53             amount = amount * 26;
54         }
55         
56         // 15 september 2018 - 21 september 2018: 25% bonus
57         if(now > 1536966000 && now < 1537570800) {
58             amount = amount * 25;
59         }
60         
61         // 22 september 2018 - 28 september 2018: 20% bonus
62         if(now > 1537570800 && now < 1538175600) {
63             amount = amount * 24;
64         }
65         
66         // 29 september 2018 - 5 october 2018: 15% bonus
67         if(now > 1538175600 && now < 1538780400) {
68             amount = amount * 23;
69         }
70 
71         // 6 october 2018 - 20 october 2018: 10% bonus
72         if(now > 1538780400 && now < 1540076400) {
73             amount = amount * 22;
74         }
75 
76         // 21 october 2018
77         if(now > 1540076400) {
78             amount = amount * 20;
79         }
80         
81         totalSold += amount / 1 ether;
82         tokenReward.transfer(msg.sender, amount);
83         emit FundTransfer(msg.sender, amount);
84         owner.transfer(msg.value);
85     }
86 }