1 pragma solidity ^0.4.16;
2 
3 interface Token {
4     function transfer(address _to, uint256 _value) external;
5 }
6 
7 contract AZTCrowdsale {
8     
9     Token public tokenReward;
10     address public creator;
11     address public owner = 0x0;
12 
13     uint256 private tokenSold;
14 
15     modifier isCreator() {
16         require(msg.sender == creator);
17         _;
18     }
19 
20     event FundTransfer(address backer, uint amount, bool isContribution);
21 
22     function AZTCrowdsale() public {
23         creator = msg.sender;
24         tokenReward = Token(0x2e9f2A3c66fFd47163b362987765FD8857b1f3F9);
25     }
26 
27     function setOwner(address _owner) isCreator public {
28         owner = _owner;      
29     }
30 
31     function setCreator(address _creator) isCreator public {
32         creator = _creator;      
33     }
34 
35     function setToken(address _token) isCreator public {
36         tokenReward = Token(_token);      
37     }
38 
39     function sendToken(address _to, uint256 _value) isCreator public {
40         tokenReward.transfer(_to, _value);      
41     }
42 
43     function kill() isCreator public {
44         selfdestruct(owner);
45     }
46 
47     function () payable public {
48         require(msg.value > 0);
49         uint256 amount;
50         
51         // private sale
52         if (now > 1526342400 && now < 1527811200 && tokenSold < 1250001) {
53             amount = msg.value * 10000;
54         }
55 
56         // pre-sale
57         if (now > 1527811199 && now < 1528416000 && tokenSold > 1250000 && tokenSold < 3250001) {
58             amount = msg.value * 10000;
59         }
60 
61         // stage 1
62         if (now > 1528415999 && now < 1529107200 && tokenSold > 3250000 && tokenSold < 5250001) {
63             amount = msg.value * 10000;
64         }
65 
66         // stage 2
67         if (now > 1529107199 && now < 1529622000 && tokenSold > 5250000 && tokenSold < 7250001) {
68             amount = msg.value * 2500;
69         }
70 
71         // stage 3
72         if (now > 1529621999 && now < 1530226800 && tokenSold > 7250000 && tokenSold < 9250001) {
73             amount = msg.value * 1250;
74         }
75 
76         // stage 4
77         if (now > 1530226799 && now < 1530831600 && tokenSold > 9250000 && tokenSold < 11250001) {
78             amount = msg.value * 833;
79         }
80 
81         // stage 5
82         if (now > 1530831599 && now < 1531609199 && tokenSold > 11250000 && tokenSold < 13250001) {
83             amount = msg.value * 417;
84         }
85 
86         tokenSold += amount / 1 ether;
87         tokenReward.transfer(msg.sender, amount);
88         FundTransfer(msg.sender, amount, true);
89         owner.transfer(msg.value);
90     }
91 }