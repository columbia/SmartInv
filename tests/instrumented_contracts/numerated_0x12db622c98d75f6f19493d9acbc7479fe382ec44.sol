1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 interface Token {
51     function transfer(address _to, uint256 _value) external;
52 }
53 
54 contract TBECrowdsale {
55     
56     Token public tokenReward;
57     uint256 public price;
58     address public creator;
59     address public owner = 0x700635ad386228dEBCfBb5705d2207F529af8323;
60     uint256 public startDate;
61     uint256 public endDate;
62     uint256 public bonusDate;
63     uint256 public tokenCap;
64 
65     mapping (address => bool) public whitelist;
66     mapping (address => uint256) public whitelistedMax;
67     mapping (address => bool) public categorie1;
68     mapping (address => bool) public categorie2;
69     mapping (address => bool) public tokenAddress;
70     mapping (address => uint256) public balanceOfEther;
71     mapping (address => uint256) public balanceOf;
72 
73     modifier isCreator() {
74         require(msg.sender == creator);
75         _;
76     }
77 
78     event FundTransfer(address backer, uint amount, bool isContribution);
79 
80     function TBECrowdsale() public {
81         creator = msg.sender;
82         price = 8000;
83         startDate = now;
84         endDate = startDate + 30 days;
85         bonusDate = startDate + 5 days;
86         tokenCap = 2400000000000000000000;
87         tokenReward = Token(0xf18b97b312EF48C5d2b5C21c739d499B7c65Cf96);
88     }
89 
90 
91 
92     function setOwner(address _owner) isCreator public {
93         owner = _owner;      
94     }
95 
96     function setCreator(address _creator) isCreator public {
97         creator = _creator;      
98     }
99 
100     function setStartDate(uint256 _startDate) isCreator public {
101         startDate = _startDate;      
102     }
103 
104     function setEndtDate(uint256 _endDate) isCreator public {
105         endDate = _endDate;      
106     }
107     
108     function setbonusDate(uint256 _bonusDate) isCreator public {
109         bonusDate = _bonusDate;      
110     }
111     function setPrice(uint256 _price) isCreator public {
112         price = _price;      
113     }
114      function settokenCap(uint256 _tokenCap) isCreator public {
115         tokenCap = _tokenCap;      
116     }
117 
118     function addToWhitelist(address _address) isCreator public {
119         whitelist[_address] = true;
120     }
121 
122     function addToCategorie1(address _address) isCreator public {
123         categorie1[_address] = true;
124     }
125 
126     function addToCategorie2(address _address) isCreator public {
127         categorie2[_address] = true;
128     }
129 
130     function setToken(address _token) isCreator public {
131         tokenReward = Token(_token);      
132     }
133 
134     function sendToken(address _to, uint256 _value) isCreator public {
135         tokenReward.transfer(_to, _value);      
136     }
137 
138     function kill() isCreator public {
139         selfdestruct(owner);
140     }
141 
142     function () payable public {
143         require(msg.value > 0);
144         require(now > startDate);
145         require(now < endDate);
146         require(whitelist[msg.sender]);
147         
148         if (categorie1[msg.sender] == false) {
149             require((whitelistedMax[msg.sender] +  msg.value) <= 5000000000000000000);
150         }
151 
152         uint256 amount = msg.value * price;
153 
154         if (now > startDate && now <= bonusDate) {
155             uint256 _amount = amount / 10;
156             amount += _amount * 3;
157         }
158 
159         balanceOfEther[msg.sender] += msg.value / 1 ether;
160         tokenReward.transfer(msg.sender, amount);
161         whitelistedMax[msg.sender] = whitelistedMax[msg.sender] + msg.value;
162         FundTransfer(msg.sender, amount, true);
163         owner.transfer(msg.value);
164     }
165 }