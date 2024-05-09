1 pragma solidity ^0.4.11;
2 
3 contract ERC20 {
4     function transfer(address to, uint tokens) public returns (bool success);
5 }
6 
7 contract owned {
8     address public owner;
9 
10     constructor() public {
11         owner = msg.sender;
12     }
13 
14     modifier onlyOwner {
15         require(msg.sender == owner);
16         _;
17     }
18 
19     function transferOwnership(address newOwner) onlyOwner public {
20         owner = newOwner;
21     }
22 }
23 
24 
25 library SafeMath {
26     function mul(uint a, uint b) internal pure returns (uint) {
27         uint c = a * b;
28         assert(a == 0 || c / a == b);
29         return c;
30     }
31 
32     function div(uint a, uint b) internal pure returns (uint) {
33         // assert(b > 0); // Solidity automatically throws when dividing by 0
34         uint c = a / b;
35         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36         return c;
37     }
38 
39     function sub(uint a, uint b) internal pure returns (uint) {
40         assert(b <= a);
41         return a - b;
42     }
43 
44     function add(uint a, uint b) internal pure returns (uint) {
45         uint c = a + b;
46         assert(c >= a);
47         return c;
48     }
49 
50     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
51         return a >= b ? a : b;
52     }
53 
54     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
55         return a < b ? a : b;
56     }
57 
58     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
59         return a >= b ? a : b;
60     }
61 
62     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
63         return a < b ? a : b;
64     }
65 }
66 
67 
68 contract RocketsICO is owned {
69     using SafeMath for uint;
70     bool public ICOOpening = true;
71     uint256 public USD;
72     uint256 public ICORate = 1;
73     uint256 public ICOBonus = 0;
74     address public ROK = 0xca2660F10ec310DF91f3597574634A7E51d717FC;
75 
76     function updateUSD(uint256 usd) onlyOwner public {
77         USD = usd;
78     }
79 
80     function updateRate(uint256 rate, uint256 bonus) onlyOwner public {
81         ICORate = rate;
82         ICOBonus = bonus;
83     }
84 
85     function updateOpen(bool opening) onlyOwner public{
86         ICOOpening = opening;
87     }
88 
89     constructor() public {
90     }
91 
92     function() public payable {
93         buy();
94     }
95 
96     function getAmountToBuy(uint256 ethAmount) public view returns (uint256){
97         uint256 tokensToBuy;
98         tokensToBuy = ethAmount.mul(USD).mul(ICORate);
99         if(ICOBonus > 0){
100             uint256 bonusAmount;
101             bonusAmount = tokensToBuy.div(100).mul(ICOBonus);
102             tokensToBuy = tokensToBuy.add(bonusAmount);
103         }
104         return tokensToBuy;
105     }
106 
107     function buy() public payable {
108         require(ICOOpening == true);
109         uint256 tokensToBuy;
110         uint256 ethAmount = msg.value;
111         tokensToBuy = ethAmount.mul(USD).mul(ICORate);
112         if(ICOBonus > 0){
113             uint256 bonusAmount;
114             bonusAmount = tokensToBuy.div(100).mul(ICOBonus);
115             tokensToBuy = tokensToBuy.add(bonusAmount);
116         }
117         ERC20(ROK).transfer(msg.sender, tokensToBuy);
118     }
119 
120     function withdrawROK(uint256 amount, address sendTo) onlyOwner public {
121         ERC20(ROK).transfer(sendTo, amount);
122     }
123 
124     function withdrawEther(uint256 amount, address sendTo) onlyOwner public {
125         address(sendTo).transfer(amount);
126     }
127 
128     function withdrawToken(ERC20 token, uint256 amount, address sendTo) onlyOwner public {
129         require(token.transfer(sendTo, amount));
130     }
131 }