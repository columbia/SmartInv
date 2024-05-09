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
15 
16     mapping (address => bool) public whitelist;
17     mapping (address => bool) public categorie1;
18     mapping (address => bool) public categorie2;
19     mapping (address => uint256) public balanceOfEther;
20 
21     modifier isCreator() {
22         require(msg.sender == creator);
23         _;
24     }
25 
26     event FundTransfer(address backer, uint amount, bool isContribution);
27 
28     function TBECrowdsale() public {
29         creator = msg.sender;
30         price = 8000;
31         startDate = now;
32         endDate = startDate + 30 days;
33         tokenReward = Token(0x647972c6A5bD977Db85dC364d18cC05D3Db70378);
34     }
35 
36     function setOwner(address _owner) isCreator public {
37         owner = _owner;      
38     }
39 
40     function setCreator(address _creator) isCreator public {
41         creator = _creator;      
42     }
43 
44     function setStartDate(uint256 _startDate) isCreator public {
45         startDate = _startDate;      
46     }
47 
48     function setEndtDate(uint256 _endDate) isCreator public {
49         endDate = _endDate;      
50     }
51     
52     function setPrice(uint256 _price) isCreator public {
53         price = _price;      
54     }
55 
56     function addToWhitelist(address _address) isCreator public {
57         whitelist[_address] = true;
58     }
59 
60     function addToCategorie1(address _address) isCreator public {
61         categorie1[_address] = true;
62     }
63 
64     function addToCategorie2(address _address) isCreator public {
65         categorie2[_address] = true;
66     }
67 
68     function setToken(address _token) isCreator public {
69         tokenReward = Token(_token);      
70     }
71 
72     function sendToken(address _to, uint256 _value) isCreator public {
73         tokenReward.transfer(_to, _value);      
74     }
75 
76     function kill() isCreator public {
77         selfdestruct(owner);
78     }
79 
80     function () payable public {
81         require(msg.value > 0);
82         require(now > startDate);
83         require(now < endDate);
84         require(whitelist[msg.sender]);
85         
86         if (categorie1[msg.sender]) {
87             require(balanceOfEther[msg.sender] <= 2);
88         }
89 
90         uint256 amount = msg.value * price;
91 
92         if (now > startDate && now <= startDate + 5) {
93             uint256 _amount = amount / 10;
94             amount += _amount * 3;
95         }
96 
97         balanceOfEther[msg.sender] += msg.value / 1 ether;
98         tokenReward.transfer(msg.sender, amount);
99         FundTransfer(msg.sender, amount, true);
100         owner.transfer(msg.value);
101     }
102 }