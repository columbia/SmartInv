1 pragma solidity ^0.4.16;
2 
3 interface Token {
4     function transfer(address _to, uint256 _value) external;
5 }
6 
7 contract TBECrowdsale {
8     
9     Token public tokenReward;
10     uint256 public price;
11     address public creator;
12     address public owner = 0x0;
13     uint256 public startDate;
14     uint256 public endDate;
15     uint256 public bonusDate;
16     uint256 public tokenCap;
17 
18     mapping (address => bool) public whitelist;
19     mapping (address => bool) public categorie1;
20     mapping (address => bool) public categorie2;
21     mapping (address => bool) public tokenAddress;
22     mapping (address => uint256) public balanceOfEther;
23     mapping (address => uint256) public balanceOf;
24 
25     modifier isCreator() {
26         require(msg.sender == creator);
27         _;
28     }
29 
30     event FundTransfer(address backer, uint amount, bool isContribution);
31 
32     function TBECrowdsale() public {
33         creator = msg.sender;
34         price = 8000;
35         startDate = now;
36         endDate = startDate + 30 days;
37         bonusDate = startDate + 5 days;
38         tokenCap = 2400000000000000000000;
39         tokenReward = Token(0x647972c6A5bD977Db85dC364d18cC05D3Db70378);
40         
41     }
42 
43 
44 
45     function setOwner(address _owner) isCreator public {
46         owner = _owner;      
47     }
48 
49     function setCreator(address _creator) isCreator public {
50         creator = _creator;      
51     }
52 
53     function setStartDate(uint256 _startDate) isCreator public {
54         startDate = _startDate;      
55     }
56 
57     function setEndtDate(uint256 _endDate) isCreator public {
58         endDate = _endDate;      
59     }
60     
61     function setbonusDate(uint256 _bonusDate) isCreator public {
62         bonusDate = _bonusDate;      
63     }
64     function setPrice(uint256 _price) isCreator public {
65         price = _price;      
66     }
67      function settokenCap(uint256 _tokenCap) isCreator public {
68         tokenCap = _tokenCap;      
69     }
70 
71     function addToWhitelist(address _address) isCreator public {
72         whitelist[_address] = true;
73     }
74 
75     function addToCategorie1(address _address) isCreator public {
76         categorie1[_address] = true;
77     }
78 
79     function addToCategorie2(address _address) isCreator public {
80         categorie2[_address] = true;
81     }
82 
83     function setToken(address _token) isCreator public {
84         tokenReward = Token(_token);      
85     }
86 
87     function sendToken(address _to, uint256 _value) isCreator public {
88         tokenReward.transfer(_to, _value);      
89     }
90 
91     function kill() isCreator public {
92         selfdestruct(owner);
93     }
94 
95     function () payable public {
96         require(msg.value > 0);
97         require(now > startDate);
98         require(now < endDate);
99         require(whitelist[msg.sender]);
100         
101         if (categorie1[msg.sender] == false) {
102             // require(tokenAddress.balanceOf[msg.sender] <= tokenCap);
103         }
104 
105         uint256 amount = msg.value * price;
106 
107         if (now > startDate && now <= bonusDate) {
108             uint256 _amount = amount / 10;
109             amount += _amount * 3;
110         }
111 
112         balanceOfEther[msg.sender] += msg.value / 1 ether;
113         tokenReward.transfer(msg.sender, amount);
114         FundTransfer(msg.sender, amount, true);
115         owner.transfer(msg.value);
116     }
117 }