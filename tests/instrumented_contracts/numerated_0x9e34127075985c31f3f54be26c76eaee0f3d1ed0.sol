1 pragma solidity ^0.4.16;
2 
3 interface Token {
4     function transfer(address _to, uint256 _value) external;
5 }
6 
7 contract ETXCrowdsale {
8     
9     Token public tokenReward;
10     address public creator;
11     address public owner = 0xC745dA5e0CC68E6Ba91429Ec0F467939f4005Db6;
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
22     function ETXCrowdsale() public {
23         creator = msg.sender;
24         tokenReward = Token(0x4CFB59BDfB47396e1720F7fF1C1e37071d927112);
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
51         // period 1
52         if (now > 1519862400 && now < 1522018800 && tokenSold < 2100001) {
53             amount = msg.value * 600;
54         }
55 
56         // period 2
57         if (now > 1522537200 && now < 1524697200 && tokenSold < 6300001) {
58             amount = msg.value * 500;
59         }
60 
61         // period 3
62         if (now > 1525129200 && now < 1527721200 && tokenSold < 12600001) {
63             amount = msg.value * 400;
64         }
65 
66         tokenSold += amount / 1 ether;
67         tokenReward.transfer(msg.sender, amount);
68         FundTransfer(msg.sender, amount, true);
69         owner.transfer(msg.value);
70     }
71 }