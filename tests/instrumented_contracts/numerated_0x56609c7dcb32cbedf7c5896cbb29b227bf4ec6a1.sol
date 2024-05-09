1 pragma solidity ^0.4.16;
2 
3 interface Token {
4     function transfer(address _to, uint256 _value) public;
5 }
6 
7 contract EFTCrowdsale {
8     
9     Token public tokenReward;
10     address public creator;
11     address public owner = 0x515C1c5bA34880Bc00937B4a483E026b0956B364;
12 
13     uint256 public price;
14     uint256 public startDate;
15     uint256 public endDate;
16 
17     modifier isCreator() {
18         require(msg.sender == creator);
19         _;
20     }
21 
22     event FundTransfer(address backer, uint amount, bool isContribution);
23 
24     function EFTCrowdsale() public {
25         creator = msg.sender;
26         startDate = 1518307200;
27         endDate = 1530399600;
28         price = 100;
29         tokenReward = Token(0x21929a10fB3D093bbd1042626Be5bf34d401bAbc);
30     }
31 
32     function setOwner(address _owner) isCreator public {
33         owner = _owner;      
34     }
35 
36     function setCreator(address _creator) isCreator public {
37         creator = _creator;      
38     }
39 
40     function setStartDate(uint256 _startDate) isCreator public {
41         startDate = _startDate;      
42     }
43 
44     function setEndtDate(uint256 _endDate) isCreator public {
45         endDate = _endDate;      
46     }
47     
48     function setPrice(uint256 _price) isCreator public {
49         price = _price;      
50     }
51 
52     function setToken(address _token) isCreator public {
53         tokenReward = Token(_token);      
54     }
55 
56     function sendToken(address _to, uint256 _value) isCreator public {
57         tokenReward.transfer(_to, _value);      
58     }
59 
60     function kill() isCreator public {
61         selfdestruct(owner);
62     }
63 
64     function () payable public {
65         require(msg.value > 0);
66         require(now > startDate);
67         require(now < endDate);
68 	    uint amount = msg.value * price;
69         uint _amount = amount / 5;
70 
71         // period 1 : 100%
72         if(now > 1518307200 && now < 1519862401) {
73             amount += amount;
74         }
75         
76         // period 2 : 75%
77         if(now > 1519862400 && now < 1522537201) {
78             amount += _amount * 15;
79         }
80 
81         // Pperiod 3 : 50%
82         if(now > 1522537200 && now < 1525129201) {
83             amount += _amount * 10;
84         }
85 
86         // Pperiod 4 : 25%
87         if(now > 1525129200 && now < 1527807601) { 
88             amount += _amount * 5;
89         }
90 
91         // Pperiod 5 : 10%
92         if(now > 1527807600 && now < 1530399600) {
93             amount += _amount * 2;
94         }
95 
96         tokenReward.transfer(msg.sender, amount);
97         FundTransfer(msg.sender, amount, true);
98         owner.transfer(msg.value);
99     }
100 }