1 pragma solidity ^0.4.16;
2 
3 interface Token {
4     function transfer(address receiver, uint amount) public;
5 }
6 
7 contract JabcilbCrowdsale {
8     
9     Token public tokenReward;
10     address creator;
11     address owner = 0x432d2fa34DC83048AABEC5Af8dA3bfD70fbF73B6;
12 
13     uint256 public startDate;
14     uint256 public endDate;
15     uint256 public price;
16 
17     event FundTransfer(address backer, uint amount, bool isContribution);
18 
19     function JabcilbCrowdsale() public {
20         creator = msg.sender;
21         startDate = 1514761200;
22         endDate = 1517353200;
23         price = 1000;
24         tokenReward = Token(0xeC02C9fB523CB1D8F61Bd5E34dB8dE990BCEa99C);
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
63         tokenReward.transfer(msg.sender, amount);
64         FundTransfer(msg.sender, amount, true);
65         owner.transfer(msg.value);
66     }
67 }