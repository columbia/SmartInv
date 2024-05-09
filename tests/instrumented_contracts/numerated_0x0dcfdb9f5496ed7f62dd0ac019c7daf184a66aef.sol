1 pragma solidity ^0.4.16;
2 
3 interface Token {
4     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
5 }
6 
7 contract LVRCrowdsale {
8     
9     Token public tokenReward;
10     address public creator;
11     address public owner = 0xC9167F51CDEa635634E6d92D25664379dde36484;
12 
13     uint256 public price;
14     uint256 public startDate;
15     uint256 public endDate;
16 
17     event FundTransfer(address backer, uint amount, bool isContribution);
18 
19     function LVRCrowdsale() public {
20         creator = msg.sender;
21         startDate = 1522839600;
22         endDate = 1525431600;
23         price = 1000;
24         tokenReward = Token(0x7095E151aBD19e8C99abdfB4568F675f747f97F6);
25     }
26 
27     function setOwner(address _owner) public {
28         require(msg.sender == creator);
29         owner = _owner;      
30     }
31 
32     function setCreator(address _creator) public {
33         require(msg.sender == creator);
34         creator = _creator;      
35     }
36 
37     function setStartDate(uint256 _startDate) public {
38         require(msg.sender == creator);
39         startDate = _startDate;      
40     }
41 
42     function setEndtDate(uint256 _endDate) public {
43         require(msg.sender == creator);
44         endDate = _endDate;      
45     }
46     
47     function setPrice(uint256 _price) public {
48         require(msg.sender == creator);
49         price = _price;      
50     }
51 
52     function setToken(address _token) public {
53         require(msg.sender == creator);
54         tokenReward = Token(_token);      
55     }
56     
57     function kill() public {
58         require(msg.sender == creator);
59         selfdestruct(owner);
60     }
61 
62     function () payable public {
63         require(msg.value > 0);
64         require(now > startDate);
65         require(now < endDate);
66 	    uint amount = msg.value * price;
67         uint _amount = amount / 20;
68         
69         // period 1 : 30%
70         if(now > 1522839600 && now < 1523098800) {
71             amount += _amount * 6;
72         }
73         
74         // period 2 : 20%
75         if(now > 1523098800 && now < 1523703600) {
76             amount += _amount * 4;
77         }
78 
79         // period 3 : 10%
80         if(now > 1523703600 && now < 1524913200) {
81             amount += _amount * 2;
82         }
83 
84         tokenReward.transferFrom(owner, msg.sender, amount);
85         FundTransfer(msg.sender, amount, true);
86         owner.transfer(msg.value);
87     }
88 }