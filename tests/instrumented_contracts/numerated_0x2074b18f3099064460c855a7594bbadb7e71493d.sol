1 // solium-disable linebreak-style
2 pragma solidity ^0.5.0;
3 
4 contract CryptoTycoonsVIPLib{
5     
6     address payable public owner;
7 
8     mapping (address => uint) userExpPool;
9     mapping (address => bool) public callerMap;
10     modifier onlyOwner {
11         require(msg.sender == owner, "OnlyOwner methods called by non-owner.");
12         _;
13     }
14 
15     modifier onlyCaller {
16         bool isCaller = callerMap[msg.sender];
17         require(isCaller, "onlyCaller methods called by non-caller.");
18         _;
19     }
20 
21     constructor() public{
22         owner = msg.sender;
23         callerMap[owner] = true;
24     }
25 
26     function kill() external onlyOwner {
27         selfdestruct(owner);
28     }
29 
30     function addCaller(address caller) public onlyOwner{
31         bool isCaller = callerMap[caller];
32         if (isCaller == false){
33             callerMap[caller] = true;
34         }
35     }
36 
37     function deleteCaller(address caller) external onlyOwner {
38         bool isCaller = callerMap[caller];
39         if (isCaller == true) {
40             callerMap[caller] = false;
41         }
42     }
43 
44     function addUserExp(address addr, uint256 amount) public onlyCaller{
45         uint exp = userExpPool[addr];
46         exp = exp + amount;
47         userExpPool[addr] = exp;
48     }
49 
50     function getUserExp(address addr) public view returns(uint256 exp){
51         return userExpPool[addr];
52     }
53 
54     function getVIPLevel(address user) public view returns (uint256 level) {
55         uint exp = userExpPool[user];
56 
57         if(exp >= 30 ether && exp < 150 ether){
58             level = 1;
59         } else if(exp >= 150 ether && exp < 300 ether){
60             level = 2;
61         } else if(exp >= 300 ether && exp < 1500 ether){
62             level = 3;
63         } else if(exp >= 1500 ether && exp < 3000 ether){
64             level = 4;
65         } else if(exp >= 3000 ether && exp < 15000 ether){
66             level = 5;
67         } else if(exp >= 15000 ether && exp < 30000 ether){
68             level = 6;
69         } else if(exp >= 30000 ether && exp < 150000 ether){
70             level = 7;
71         } else if(exp >= 150000 ether){
72             level = 8;
73         } else{
74             level = 0;
75         }
76 
77         return level;
78     }
79 
80     function getVIPBounusRate(address user) public view returns (uint256 rate){
81         uint level = getVIPLevel(user);
82 
83         if(level == 1){
84             rate = 1;
85         } else if(level == 2){
86             rate = 2;
87         } else if(level == 3){
88             rate = 3;
89         } else if(level == 4){
90             rate = 4;
91         } else if(level == 5){
92             rate = 5;
93         } else if(level == 6){
94             rate = 7;
95         } else if(level == 7){
96             rate = 9;
97         } else if(level == 8){
98             rate = 11;
99         } else if(level == 9){
100             rate = 13;
101         } else if(level == 10){
102             rate = 15;
103         } else{
104             rate = 0;
105         }
106     }
107 }