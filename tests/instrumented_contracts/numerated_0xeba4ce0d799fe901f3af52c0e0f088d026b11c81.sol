1 pragma solidity ^0.4.16;
2 
3 interface Token {
4     function transfer(address _to, uint256 _value) external;
5 }
6 
7 contract CFNDCrowdsale {
8     
9     Token public tokenReward;
10     address public creator;
11     address public owner = 0x56D215183E48881f10D1FaEb9325cf02171B16B7;
12 
13     uint256 private price;
14 
15     modifier isCreator() {
16         require(msg.sender == creator);
17         _;
18     }
19 
20     event FundTransfer(address backer, uint amount, bool isContribution);
21 
22     function CFNDCrowdsale() public {
23         creator = msg.sender;
24         price = 400;
25         tokenReward = Token(0x2a7d19F2bfd99F46322B03C2d3FdC7B7756cAe1a);
26     }
27 
28     function setOwner(address _owner) isCreator public {
29         owner = _owner;      
30     }
31 
32     function setCreator(address _creator) isCreator public {
33         creator = _creator;      
34     }
35 
36     function setPrice(uint256 _price) isCreator public {
37         price = _price;      
38     }
39 
40     function setToken(address _token) isCreator public {
41         tokenReward = Token(_token);      
42     }
43 
44     function sendToken(address _to, uint256 _value) isCreator public {
45         tokenReward.transfer(_to, _value);      
46     }
47 
48     function kill() isCreator public {
49         selfdestruct(owner);
50     }
51 
52     function () payable public {
53         require(msg.value > 0);
54         require(now > 1527238800);
55         uint256 amount = msg.value * price;
56         uint256 _amount = amount / 100;
57 
58         
59         // stage 1
60         if (now > 1527238800 && now < 1527670800) {
61             amount += _amount * 15;
62         }
63 
64         // stage 2
65         if (now > 1527843600 && now < 1528189200) {
66             amount += _amount * 10;
67         }
68 
69         // stage 3
70         if (now > 1528275600 && now < 1528621200) {
71             amount += _amount * 5;
72         }
73 
74         // stage 4
75         if (now > 1528707600 && now < 1529053200) {
76             amount += _amount * 2;
77         }
78 
79         // stage 5
80         require(now < 1531123200);
81 
82         tokenReward.transfer(msg.sender, amount);
83         FundTransfer(msg.sender, amount, true);
84         owner.transfer(msg.value);
85     }
86 }