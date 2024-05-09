1 pragma solidity ^0.4.17;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a / b;
16         return c;
17     }
18 
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20         assert(b <= a);
21         return a - b;
22     }
23 
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         assert(c >= a);
27         return c;
28     }
29 }
30 
31 contract ERC20Token {
32     function balanceOf(address who) public view returns (uint256);
33     function transfer(address to, uint256 value) public returns (bool);
34 }
35 
36 contract GroupBuy {
37     using SafeMath for uint256;
38 
39     enum Phase { Init, Contribute, Wait, Claim, Lock }
40     uint256 private constant MAX_TOTAL = 500 ether;
41     uint256 private constant MAX_EACH = 2 ether;
42 
43     address private tokenAddr;
44     address private owner;
45     mapping(address => uint256) private amounts;
46     uint256 private totalEth;
47     uint256 private totalToken;
48     Phase private currentPhase;
49 
50     function GroupBuy() public {
51         owner = msg.sender;
52         currentPhase = Phase.Init;
53     }
54 
55     modifier isOwner() {
56         assert(msg.sender == owner);
57         _;
58     }
59 
60     // admin function
61     function beginContrib() isOwner public {
62         require(currentPhase == Phase.Init || currentPhase == Phase.Wait);
63         currentPhase = Phase.Contribute;
64     }
65 
66     function endContrib() isOwner public {
67         require(currentPhase == Phase.Contribute);
68         currentPhase = Phase.Wait;
69         owner.transfer(address(this).balance); // collect eth to buy token
70     }
71 
72     function allowClaim(address _addr) isOwner public returns (uint256) {
73         require(currentPhase == Phase.Wait);
74         currentPhase = Phase.Claim;
75         tokenAddr = _addr;
76         
77         ERC20Token tok = ERC20Token(tokenAddr);
78         totalToken = tok.balanceOf(this);
79         require(totalToken > 0);
80         return totalToken;
81     }
82 
83     // rescue function
84     function lock() isOwner public {
85         require(currentPhase == Phase.Claim);
86         currentPhase = Phase.Lock;
87     }
88 
89     function unlock() isOwner public {
90         require(currentPhase == Phase.Lock);
91         currentPhase = Phase.Claim;
92     }
93 
94     function collectEth() isOwner public {
95         owner.transfer(address(this).balance);
96     }
97 
98     function setTotalToken(uint _total) isOwner public {
99         require(_total > 0);
100         totalToken = _total;
101     }
102 
103     function setTokenAddr(address _addr) isOwner public {
104         tokenAddr = _addr;
105     }
106 
107     function withdrawToken(address _erc20, uint _amount) isOwner public returns (bool success) {
108         return ERC20Token(_erc20).transfer(owner, _amount);
109     } 
110 
111     // user function
112     function() public payable {
113         revert();
114     }
115 
116     function info() public view returns (uint phase, uint userEth, uint userToken, uint allEth, uint allToken) {
117         phase = uint(currentPhase);
118         userEth = amounts[msg.sender];
119         userToken = totalEth > 0 ? totalToken.mul(userEth).div(totalEth) : 0;
120         allEth = totalEth;
121         allToken = totalToken;
122     }
123 
124     function contribute() public payable returns (uint _value) {
125         require(msg.value > 0);
126         require(currentPhase == Phase.Contribute);
127         uint cur = amounts[msg.sender];
128         require(cur < MAX_EACH && totalEth < MAX_TOTAL);
129 
130         _value = msg.value > MAX_EACH.sub(cur) ? MAX_EACH.sub(cur) : msg.value;
131         _value = _value > MAX_TOTAL.sub(totalEth) ? MAX_TOTAL.sub(totalEth) : _value;
132         amounts[msg.sender] = cur.add(_value);
133         totalEth = totalEth.add(_value);
134 
135         // return redundant eth to user
136         if (msg.value.sub(_value) > 0) {
137             msg.sender.transfer(msg.value.sub(_value));
138         }
139     }
140 
141     function claim() public returns (uint amountToken) {
142         require(currentPhase == Phase.Claim);
143         uint contributed = amounts[msg.sender];
144         amountToken = totalEth > 0 ? totalToken.mul(contributed).div(totalEth) : 0;
145 
146         require(amountToken > 0);
147         require(ERC20Token(tokenAddr).transfer(msg.sender, amountToken));
148         amounts[msg.sender] = 0;
149     }
150 }