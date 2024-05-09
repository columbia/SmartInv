1 pragma solidity ^0.4.15;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 
33 
34 
35 contract Ownable {
36     address public owner;
37     
38     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39   
40     function Ownable() public {
41         owner = msg.sender;
42     }
43 
44     modifier onlyOwner() {
45         require(msg.sender == owner);
46         _;
47     }
48 
49     function transferOwnership(address newOwner) public onlyOwner {
50         require(newOwner != address(0));
51         OwnershipTransferred(owner, newOwner);
52         owner = newOwner;
53     }
54 
55 }
56 
57 
58 
59 interface Token {
60     
61     function transfer(address _to, uint256 _value) public returns (bool);
62     function balanceOf(address _owner) public constant returns (uint256 balance);
63 }
64 
65 
66 
67 
68 contract Crowdsale is Ownable {
69     
70     using SafeMath for uint256;
71 
72     Token public token;
73 
74     uint256 public RATE = 50000; // Number of tokens per Ether
75     uint256 public START;
76     uint256 public minETH = 100 finney;
77 
78     uint256 public constant initialTokens =  4000000000 * 10**18; // Initial number of tokens available
79     bool public isFunding = true;
80     uint256 public raisedAmount = 0;
81 
82     event BoughtTokens(address indexed to, uint256 value);
83 
84     modifier whenSaleIsActive() {
85     // Check if sale is active
86         assert(isActive());
87         _;
88     }
89 
90     function Crowdsale(address _tokenAddr, uint256 _start) public {
91         require(_tokenAddr != 0);
92         token = Token(_tokenAddr);
93         START = _start;
94     }
95   
96     
97     function changeSaleStatus (bool _isFunding) external onlyOwner {
98        isFunding = _isFunding;
99        
100     }
101     
102     function changeRate (uint256 _RATE) external onlyOwner {
103        RATE = _RATE;
104     }
105 
106     function isActive() public constant returns (bool) {
107         return (
108             isFunding == true &&
109             now >= START && // Must be after the START date
110             now <= START.add(92 days)
111         );
112     }
113 
114     
115 
116 
117     function () public payable {
118         
119         if (now >= START && now < START.add(31 days)) {
120             RATE = 50000;  // 50,000/ETH for first month and then 40,000/ETH
121             buyTokens();
122         } 
123         else {
124             RATE = 40000;
125             buyTokens(); //40,000/ETH
126         }            
127     }
128       
129   
130     function buyTokens() public payable whenSaleIsActive {
131         
132         // Minimum ETH required to buy
133         require(msg.value >= minETH);
134         
135         // Calculate tokens to sell
136         uint256 weiAmount = msg.value;
137         uint256 tokens = weiAmount.mul(RATE);
138 
139         BoughtTokens(msg.sender, tokens);
140         raisedAmount = raisedAmount.add(msg.value);
141         token.transfer(msg.sender, tokens);
142         owner.transfer(msg.value);
143     }
144     
145     function tokensAvailable() public constant returns (uint256) {
146         return token.balanceOf(this);
147     }
148     
149     
150     function burnRemaining() public onlyOwner {
151         
152         uint256 burnThis = token.balanceOf(this);
153         token.transfer(address(0), burnThis);
154     }
155     
156 
157 
158     function destroy() public onlyOwner {
159     
160         // Transfer tokens back to owner
161         uint256 balance = token.balanceOf(this);
162         assert(balance > 0);
163         token.transfer(owner, balance);
164 
165         // There should be no ether in the contract but just in case
166         selfdestruct(owner);
167     }
168 
169 }