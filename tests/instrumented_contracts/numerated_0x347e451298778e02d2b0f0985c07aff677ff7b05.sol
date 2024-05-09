1 pragma solidity ^0.4.16;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5     if (a == 0) {
6       return 0;
7     }
8 
9     c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     return a / b;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
24     c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 interface Token {
31     function transfer(address _to, uint256 _value) external;
32 }
33 
34 contract CLVRCrowdsale {
35 
36     using SafeMath for uint256;
37     
38     Token public tokenReward;
39     address public creator;
40     address public owner = 0x93a68484936E235e167729a4a1AB6f0d1897106F;
41 
42     uint256 public price;
43     uint256 public startDate;
44     uint256 public endDate;
45 
46     modifier isCreator() {
47         require(msg.sender == creator);
48         _;
49     }
50 
51     event FundTransfer(address backer, uint amount, bool isContribution);
52 
53     constructor() public {
54         creator = msg.sender;
55         startDate = 1531958400;
56         endDate = 1534636799;
57         price = 5000;
58         tokenReward = Token(0x92f10796da1f6fab1544cF64682Cb8c15C71d5E7);
59     }
60 
61     function setOwner(address _owner) isCreator public {
62         owner = _owner;      
63     }
64 
65     function setCreator(address _creator) isCreator public {
66         creator = _creator;      
67     }
68 
69     function setStartDate(uint256 _startDate) isCreator public {
70         startDate = _startDate;      
71     }
72 
73     function setEndtDate(uint256 _endDate) isCreator public {
74         endDate = _endDate;      
75     }
76     
77     function setPrice(uint256 _price) isCreator public {
78         price = _price;      
79     }
80 
81     function setToken(address _token) isCreator public {
82         tokenReward = Token(_token);      
83     }
84 
85     function sendToken(address _to, uint256 _value) isCreator public {
86         tokenReward.transfer(_to, _value);      
87     }
88 
89     function kill() isCreator public {
90         selfdestruct(owner);
91     }
92 
93     function () public payable {
94         require(msg.value > 0);
95         require(now > startDate);
96         require(now < endDate);
97         uint256 amount = msg.value.mul(price);
98         uint256 _diff;
99 
100         // period 1 : 25%
101         if (now > startDate && now < startDate + 2 days) {
102             _diff = amount.div(4);
103             amount = amount.add(_diff);
104         }
105         
106         // period 2 : 15%
107         if (now > startDate + 2 days && now < startDate + 16 days) {
108             uint256 _amount = amount.div(20);
109             _diff = _amount.mul(3);
110             amount = amount.add(_diff);
111         }
112 
113         // period 3 : 10%
114         if (now > startDate + 16 days && now < startDate + 30 days) {
115             _diff = amount.div(10);
116             amount = amount.add(_diff);
117         }
118 
119         tokenReward.transfer(msg.sender, amount);
120         emit FundTransfer(msg.sender, amount, true);
121         owner.transfer(msg.value);
122     }
123 }