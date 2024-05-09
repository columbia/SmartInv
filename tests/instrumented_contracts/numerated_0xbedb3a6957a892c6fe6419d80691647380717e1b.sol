1 pragma solidity ^0.4.16;
2 
3 interface Token {
4     function transfer(address _to, uint256 _value) public;
5 }
6 
7 contract HFTCrowdsale {
8     
9     Token public tokenReward;
10     address public creator;
11     address public owner = 0x5D1598EF6a8ECFa953039BCdC628F027dbf0307F;
12 
13     uint256[] public prices;
14     uint256[] public periods;
15     uint256 public price;
16     uint256 public period;
17     uint256 public amountSoldPerPeriod;
18 
19     uint256 public startDate;
20     uint256 public endDate;
21 
22     modifier isCreator() {
23         require(msg.sender == creator);
24         _;
25     }
26 
27     event FundTransfer(address backer, uint amount, bool isContribution);
28 
29     function HFTCrowdsale() public {
30         creator = msg.sender;
31         startDate = 1522018800;
32         endDate = 1527548400;
33         prices = [4000, 3000, 2500, 2000, 1750, 1500];
34         periods = [1000000, 6000000, 6000000, 6000000, 6000000, 5000000];
35         price = 0;
36         period = 0;
37         tokenReward = Token(0x1493894bF2468f08fD232c5699B1C24dd33CeC18);
38     }
39 
40     function setOwner(address _owner) isCreator public {
41         owner = _owner;      
42     }
43 
44     function setCreator(address _creator) isCreator public {
45         creator = _creator;      
46     }
47 
48     function setStartDate(uint256 _startDate) isCreator public {
49         startDate = _startDate;      
50     }
51 
52     function setEndtDate(uint256 _endDate) isCreator public {
53         endDate = _endDate;      
54     }
55     
56     function addPrice(uint256 _price) isCreator public {
57         prices.push(_price);      
58     }
59 
60     function updatePrice(uint256 index, uint256 _price) isCreator public {
61         prices[index] = _price;      
62     }
63 
64     function addPeriod(uint256 _period) isCreator public {
65         periods.push(_period);
66     }
67 
68     function updatePeriod(uint256 index, uint256 _period) isCreator public {
69         periods[index] = _period;      
70     }
71 
72     function setPrice(uint256 _price) isCreator public {
73         price = _price;      
74     }
75 
76     function setPeriod(uint256 _period) isCreator public {
77         period = _period;      
78     }
79 
80     function setAmountSoldPerPeriod(uint256 _amountSoldPerPeriod) isCreator public {
81         amountSoldPerPeriod = _amountSoldPerPeriod;      
82     }
83 
84     function setToken(address _token) isCreator public {
85         tokenReward = Token(_token);      
86     }
87 
88     function sendToken(address _to, uint256 _value) isCreator public {
89         tokenReward.transfer(_to, _value);      
90     }
91 
92     function kill() isCreator public {
93         selfdestruct(owner);
94     }
95 
96     function () payable public {
97         require(msg.value > 0);
98         require(now > startDate);
99         require(now < endDate);
100         require(period < periods.length);
101         require(price < prices.length);
102 
103         uint256 amount = msg.value * prices[price];
104         amountSoldPerPeriod += amount / 1 ether;
105 
106         if (amountSoldPerPeriod > periods[period]) {
107             price += 1;
108             period += 1;
109             require(period < periods.length);
110             require(price < prices.length);
111             amountSoldPerPeriod = 0;
112             amount = msg.value * prices[price];
113             amountSoldPerPeriod += amount / 1 ether;
114         }
115         
116         tokenReward.transfer(msg.sender, amount);
117         FundTransfer(msg.sender, amount, true);
118         owner.transfer(msg.value);
119     }
120 }