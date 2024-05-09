1 pragma solidity ^0.4.16;
2 
3 interface Token {
4     function transfer(address _to, uint256 _value) external;
5 }
6 
7 contract ETHLCrowdsale {
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
22     function ETHLCrowdsale() public {
23         creator = msg.sender;
24         tokenReward = Token(0x813a823F35132D822708124e01759C565AB4331d);
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
51         // stage 1
52         if (now > 1525129200 && now < 1525734000 && tokenSold < 350001) {
53             amount = msg.value * 2500;
54         }
55 
56         // stage 2
57         if (now > 1525733999 && now < 1526252400 && tokenSold > 350000 && tokenSold < 700001) {
58             amount = msg.value * 1250;
59         }
60 
61         // stage 3
62         if (now > 1526252399 && now < 1526857200 && tokenSold > 700000 && tokenSold < 1150001) {
63             amount = msg.value * 833;
64         }
65 
66         // stage 4
67         if (now > 1526857199 && now < 1527721200 && tokenSold > 1150000 && tokenSold < 2000001) {
68             amount = msg.value * 416;
69         }
70 
71         // stage 5
72         if (now > 1527721199 && now < 1528671600 && tokenSold > 2000000 && tokenSold < 3000001) {
73             amount = msg.value * 357;
74         }
75 
76         // stage 6
77         if (now > 1528671599 && now < 1530399600 && tokenSold > 3000000 && tokenSold < 4000001) {
78             amount = msg.value * 333;
79         }
80 
81         tokenSold += amount / 1 ether;
82         tokenReward.transfer(msg.sender, amount);
83         FundTransfer(msg.sender, amount, true);
84         owner.transfer(msg.value);
85     }
86 }