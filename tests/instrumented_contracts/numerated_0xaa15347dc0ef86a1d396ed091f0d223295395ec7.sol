1 pragma solidity ^0.4.24;
2 
3 interface Token {
4     function transfer(address _to, uint256 _value) external;
5 }
6 
7 contract ABECrowdsale {
8     
9     Token public tokenReward;
10     address public creator;
11     address public owner = 0xdc8a235Ca0D64b172a8fF89760a15A3021371c63;
12 
13     uint256 public startDate;
14     uint256 public endDate;
15 
16     event FundTransfer(address backer, uint amount);
17 
18     constructor() public {
19         creator = msg.sender;
20         startDate = 1537830000;
21         endDate = 1543017600;
22         tokenReward = Token(0xa8978f8299C3017F79c8e67312A34b9C3E51C859);
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
66         // Pre-Sale
67         if(now > 1537830000 && now < 1539126000) {
68             amount = amount * 10000;
69         }
70         
71         // Round 1
72         if(now > 1539126000 && now < 1540422000) {
73             amount = msg.value * 8333;
74         }
75         
76         // Round 2
77         if(now > 1540422000 && now < 1541721600) {
78             amount = msg.value * 7142;
79         }
80         
81         // Round 3
82         if(now > 1541721600 && now < 1543017600) {
83             amount = msg.value * 6249;
84         }
85         
86         tokenReward.transfer(msg.sender, amount);
87         emit FundTransfer(msg.sender, amount);
88         owner.transfer(msg.value);
89     }
90 }