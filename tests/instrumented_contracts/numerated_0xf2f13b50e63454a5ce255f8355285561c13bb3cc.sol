1 pragma solidity ^0.4.24;
2 
3 interface Token {
4     function transfer(address _to, uint256 _value) external;
5 }
6 
7 contract BNCXCrowdsale {
8     
9     Token public tokenReward;
10     address public creator;
11     address public owner = 0x516A2F56A6a8f9A34AbF86C877d0252dC94AAA69;
12 
13     uint256 public startDate;
14     uint256 public endDate;
15 
16     event FundTransfer(address backer, uint amount);
17 
18     constructor() public {
19         creator = msg.sender;
20         startDate = 1544832000;
21         endDate = 1521331200;
22         tokenReward = Token(0x5129bdfF6B065ce57cC7E7349bA681a0aC1D00cd);
23     }
24 
25     function setOwner(address _owner) public {
26         require(msg.sender == creator);
27         owner = _owner;      
28     }
29 
30     function setCreator(address _creator) public {
31         require(msg.sender == creator);
32         creator = _creator;      
33     }
34 
35     function setStartDate(uint256 _startDate) public {
36         require(msg.sender == creator);
37         startDate = _startDate;      
38     }
39 
40     function setEndtDate(uint256 _endDate) public {
41         require(msg.sender == creator);
42         endDate = _endDate;      
43     }
44 
45     function setToken(address _token) public {
46         require(msg.sender == creator);
47         tokenReward = Token(_token);      
48     }
49     
50     function sendToken(address _to, uint256 _value) public {
51         require(msg.sender == creator);
52         tokenReward.transfer(_to, _value);      
53     }
54     
55     function kill() public {
56         require(msg.sender == creator);
57         selfdestruct(owner);
58     }
59 
60     function () payable public {
61         require(msg.value > 0);
62         require(now > startDate);
63         require(now < endDate);
64         uint256 amount = msg.value / 10000000000;
65         
66         // Stage 1
67         if(now > startDate && now < 1516060800) {
68             amount = msg.value * 625;
69         }
70         
71         // Stage 2
72         if(now > 1516060800 && now < 1518825600) {
73             amount = msg.value * 235;
74         }
75         
76         // Stage 3
77         if(now > 1518825600 && now < endDate) {
78             amount = msg.value * 118;
79         }
80         
81         tokenReward.transfer(msg.sender, amount);
82         emit FundTransfer(msg.sender, amount);
83         owner.transfer(msg.value);
84     }
85 }