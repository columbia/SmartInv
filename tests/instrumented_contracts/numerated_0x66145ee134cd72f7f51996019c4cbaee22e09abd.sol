1 pragma solidity ^0.4.16;
2 
3 interface Token {
4     function transfer(address _to, uint256 _value) external;
5 }
6 
7 contract SBGCrowdsale {
8     
9     Token public tokenReward;
10     uint256 public price;
11     address public creator;
12     address public owner;
13     uint256 public startDate;
14     uint256 public endDate;
15 
16     modifier isCreator() {
17         require(msg.sender == creator);
18         _;
19     }
20 
21     event FundTransfer(address backer, uint amount, bool isContribution);
22 
23     function SBGCrowdsale() public {
24         creator = msg.sender;
25         owner = 0x0;
26         price = 100;
27         startDate = 1525647600;
28         endDate = 1527811200;
29         tokenReward = Token(0xb5980eB165cbBe3809e1680ef05c3878ce25dACb);
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
68         uint256 amount = msg.value * price;
69         tokenReward.transfer(msg.sender, amount);
70         FundTransfer(msg.sender, amount, true);
71         owner.transfer(msg.value);
72     }
73 }