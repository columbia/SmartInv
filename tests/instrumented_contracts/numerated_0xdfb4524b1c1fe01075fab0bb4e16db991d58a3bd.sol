1 pragma solidity ^0.4.16;
2 
3 interface Token {
4     function transfer(address _to, uint256 _value) public;
5 }
6 
7 contract EBAYCrowdsale {
8     
9     Token public tokenReward;
10     address public creator;
11     address public owner = 0x8c3bAfE5B6352B26567D0DF259a6E35D003b7420;
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
24     function EBAYCrowdsale() public {
25         creator = msg.sender;
26         startDate = 1528365600;
27         endDate = 1533636000;
28         price = 5000;
29         tokenReward = Token(0x12110E20309491db874219613f597de587861b57);
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
69 
70         // period 1 : 25%
71         if (now > startDate && now < startDate + 2 days) {
72             amount += amount / 4;
73         }
74         
75         // period 2 : 15%
76         if (now > startDate + 2 days && now < startDate + 9 days) {
77             uint _amount = amount / 20;
78             amount += _amount * 3;
79         }
80 
81         // period 3 : 10%
82         if (now > startDate + 9 days && now < startDate + 23 days) {
83             amount += amount / 10;
84         }
85 
86         tokenReward.transfer(msg.sender, amount);
87         FundTransfer(msg.sender, amount, true);
88         owner.transfer(msg.value);
89     }
90 }