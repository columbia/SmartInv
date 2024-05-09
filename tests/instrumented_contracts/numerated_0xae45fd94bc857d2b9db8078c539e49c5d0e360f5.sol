1 pragma solidity ^0.4.16;
2 
3 interface Token {
4     function transfer(address receiver, uint amount) public;
5 }
6 
7 contract JOUL3SCrowdsale {
8     
9     Token public tokenReward;
10     address creator;
11     address owner = 0x825C8b603fAcB1144767D5a39C7B6AaA7Aa403f4;
12 
13     uint256 public startDate;
14     uint256 public endDate;
15     uint256 public price;
16 
17     event FundTransfer(address backer, uint amount, bool isContribution);
18 
19     function JOUL3SCrowdsale() public {
20         creator = msg.sender;
21         startDate = 1514761200;     // 01/01/2018
22         endDate = 1530396000;       // 01/07/2018
23         price = 100;
24         tokenReward = Token(0x4aae3a2dA70c499797EdF4A4139b68454eC07883);
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
42     function setEndDate(uint256 _endDate) public {
43         require(msg.sender == creator);
44         endDate = _endDate;      
45     }
46 
47     function setPrice(uint256 _price) public {
48         require(msg.sender == creator);
49         price = _price;      
50     }
51 
52     function sendToken(address receiver, uint amount) public {
53         require(msg.sender == creator);
54         tokenReward.transfer(receiver, amount);
55         FundTransfer(receiver, amount, true);    
56     }
57 
58     function () payable public {
59         require(msg.value > 0);
60         require(now > startDate);
61         require(now < endDate);
62         uint amount = msg.value * price;
63 
64         // period 1 : Early Backers 50%
65         if(now > startDate && now < 1522533600) {
66             amount += amount / 2;
67         }
68 
69         // Pperiod 2 : Presale 25%
70         if(now > 1522533600 && now < 1525384800) {
71             amount += amount / 4;
72         }
73 
74         // period 3 : Launch 20%
75         if(now > 1525384800 && now < 1526076000) {
76             amount += amount / 5;
77         }
78         
79         tokenReward.transfer(msg.sender, amount);
80         FundTransfer(msg.sender, amount, true);
81         owner.transfer(msg.value);
82     }
83 }