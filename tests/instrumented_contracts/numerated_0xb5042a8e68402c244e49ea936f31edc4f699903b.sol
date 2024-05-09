1 pragma solidity ^0.4.16;
2 
3 interface Token {
4     function transfer(address receiver, uint amount) public;
5 }
6 
7 contract WEACrowdsale {
8     
9     Token public token;
10     address creator;
11     address owner = 0x0;
12 
13     uint256 public startDate;
14     uint256 public endDate;
15     uint256 public price;
16     
17     bool active = false;
18 
19     event FundTransfer(address backer, uint amount, bool isContribution);
20 
21     function WEACrowdsale() public {
22         creator = msg.sender;
23         startDate = 1515970800;     // 15/01/2018
24         endDate = 1518735600;       // 15/02/2018
25         price = 30;
26         token = Token(0x1dD0497C6a7E90d4e88cBB0aDF9c8326B83097D9);
27         active = true;
28     }
29 
30     function setOwner(address _owner) public {
31         require(msg.sender == creator);
32         owner = _owner;      
33     }
34 
35     function setCreator(address _creator) public {
36         require(msg.sender == creator);
37         creator = _creator;      
38     }    
39 
40     function setStartDate(uint256 _startDate) public {
41         require(msg.sender == creator);
42         startDate = _startDate;      
43     }
44 
45     function setEndDate(uint256 _endDate) public {
46         require(msg.sender == creator);
47         endDate = _endDate;      
48     }
49 
50     function setPrice(uint256 _price) public {
51         require(msg.sender == creator);
52         price = _price;      
53     }
54 
55     function setToken(address _address) public {
56         require(msg.sender == creator);
57         token = Token(_address);      
58     }
59 
60     function sendToken(address receiver, uint amount) public {
61         require(msg.sender == creator);
62         token.transfer(receiver, amount);
63         FundTransfer(receiver, amount, true);    
64     }
65 
66     function start() public {
67         require(msg.sender == creator);
68         active = true;      
69     }
70     
71     function stop() public {
72         require(msg.sender == creator);
73         active = false;      
74     }
75 
76     function () payable public {
77         require(active);
78         require(msg.value > 0);
79         require(now > startDate);
80         require(now < endDate);
81         uint amount = msg.value * price;
82         amount = amount / 1 ether;
83         require(amount > 0);
84         token.transfer(msg.sender, amount);
85         FundTransfer(msg.sender, amount, true);
86         owner.transfer(msg.value);
87     }
88 }