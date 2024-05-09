1 pragma solidity ^0.4.16;
2 
3 interface Token {
4     function transferFrom(address _from, address _to, uint256 _value) external;
5 }
6 
7 contract RgiftTokenSale {
8 
9     Token public tokenReward;
10     address public creator;
11     address public owner = 0x829130A7Af5A4654aF6d7bC06125a1Bcf32cd8cA;
12 
13     uint256 public price;
14     uint256 public startDate;
15 
16     modifier isCreator() {
17         require(msg.sender == creator);
18         _;
19     }
20 
21     event FundTransfer(address backer, uint amount, bool isContribution);
22 
23     function RgiftTokenSale() public {
24         creator = msg.sender;
25         startDate = 1527022077;
26         price = 140000;
27         tokenReward = Token(0x2b93194d0984201aB0220A3eC6B80D9a0BD49ed7);
28     }
29 
30     function setOwner(address _owner) isCreator public {
31         owner = _owner;
32     }
33 
34     function setCreator(address _creator) isCreator public {
35         creator = _creator;
36     }
37 
38     function setStartDate(uint256 _startDate) isCreator public {
39         startDate = _startDate;
40     }
41 
42 
43     function setPrice(uint256 _price) isCreator public {
44         price = _price;
45     }
46 
47     function setToken(address _token) isCreator public {
48         tokenReward = Token(_token);
49     }
50 
51     function kill() isCreator public {
52         selfdestruct(owner);
53     }
54 
55     function () payable public {
56         require(msg.value == (1 ether / 2) || msg.value == 1 ether  || msg.value == (1 ether + (1 ether / 2)) || msg.value == 2 ether || msg.value >= 3 ether);
57         require(now > startDate);
58         uint amount = 0;
59         if (msg.value < 1 ether){ 
60             amount = msg.value * price;
61         } else if (msg.value >= 1 ether && msg.value < 2 ether){
62             amount = msg.value * price;
63             uint _amount = amount / 10;
64             amount += _amount * 3;
65         } else if (msg.value >= 2 ether && msg.value < 3 ether){
66             amount = msg.value * price;
67              _amount = amount / 5;
68             amount += _amount * 2;
69         } else if (msg.value >= 3 ether){
70             amount = msg.value * price;
71              _amount = amount / 5;
72             amount += _amount * 3;
73         }
74         
75 
76         tokenReward.transferFrom(owner, msg.sender, amount);
77         FundTransfer(msg.sender, amount, true);
78         owner.transfer(msg.value);
79     }
80 }