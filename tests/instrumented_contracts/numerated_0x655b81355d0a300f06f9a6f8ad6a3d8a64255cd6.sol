1 pragma solidity ^0.4.24;
2 
3 interface Token {
4     function transfer(address _to, uint256 _value) external;
5 }
6 
7 contract AENCrowdsale {
8     
9     Token public tokenReward;
10     address public creator;
11     address public owner;
12     uint256 public totalSold;
13 
14     event FundTransfer(address beneficiaire, uint amount);
15 
16     constructor() public {
17         creator = msg.sender;
18         owner = 0xF82C31E4df853ff36F2Fc6F61F93B4CAda46E306;
19         tokenReward = Token(0xBd11eaE443eF0E96C1CC565Db5c0b51f6c829C0b);
20     }
21 
22     function setOwner(address _owner) public {
23         require(msg.sender == creator);
24         owner = _owner;      
25     }
26 
27     function setCreator(address _creator) public {
28         require(msg.sender == creator);
29         creator = _creator;      
30     }
31 
32     function setToken(address _token) public {
33         require(msg.sender == creator);
34         tokenReward = Token(_token);      
35     }
36     
37     function sendToken(address _to, uint256 _value) public {
38         require(msg.sender == creator);
39         tokenReward.transfer(_to, _value);      
40     }
41     
42     function kill() public {
43         require(msg.sender == creator);
44         selfdestruct(owner);
45     }
46 
47     function () payable public {
48         require(msg.value > 0 && msg.value < 5.1 ether);
49 	    uint amount = msg.value * 5000;
50 	    amount = amount / 20;
51         
52         // 28 september 2018 - 4 October 2018: 30% bonus
53         if(now > 1538089200 && now < 1538694000) {
54             amount = amount * 26;
55         }
56         
57         // 5 October 2018 - 11 October 2018: 25% bonus
58         if(now > 1538694000 && now < 1539298800) {
59             amount = amount * 25;
60         }
61         
62         // 12 October 2018 - 18 October 2018: 20% bonus
63         if(now > 1539298800 && now < 1539903600) {
64             amount = amount * 24;
65         }
66         
67         // 19 October 2018 - 25 October 2018: 15% bonus
68         if(now > 1539903600 && now < 1540508400) {
69             amount = amount * 23;
70         }
71 
72         // 26 October 2018 - 09 November 2018: 10% bonus
73         if(now > 1540508400 && now < 1541808000) {
74             amount = amount * 22;
75         }
76 
77         // 09 November 2018
78         if(now > 1541808000) {
79             amount = amount * 20;
80         }
81         
82         totalSold += amount / 1 ether;
83         tokenReward.transfer(msg.sender, amount);
84         emit FundTransfer(msg.sender, amount);
85         owner.transfer(msg.value);
86     }
87 }