1 pragma solidity 0.5.7;
2 
3 // ----------------------------------------------------------------------------
4 // 'GENES' CrowdsaleFiatBTC contract
5 //
6 // Symbol           : GENES
7 // Name             : Genesis Smart Coin
8 // Total supply     : 70,000,000,000.000000000000000000
9 // Contract supply  : 20,000,000,000.000000000000000000
10 // Decimals         : 18
11 //
12 // (c) ViktorZidenyk / Ltd Genesis World 2019. The MIT Licence.
13 // ----------------------------------------------------------------------------
14 
15 // ----------------------------------------------------------------------------
16 // Safe maths
17 // ----------------------------------------------------------------------------
18 library SafeMath {
19     function add(uint a, uint b) internal pure returns (uint c) {
20         c = a + b;
21         require(c >= a);
22     }
23     function sub(uint a, uint b) internal pure returns (uint c) {
24         require(b <= a);
25         c = a - b;
26     }
27     function mul(uint a, uint b) internal pure returns (uint c) {
28         c = a * b;
29         require(a == 0 || c / a == b);
30     }
31     function div(uint a, uint b) internal pure returns (uint c) {
32         require(b > 0);
33         c = a / b;
34     }
35 }
36 
37 // ----------------------------------------------------------------------------
38 // Address
39 // ----------------------------------------------------------------------------
40 library Address {
41   function toAddress(bytes memory source) internal pure returns(address addr) {
42     assembly { addr := mload(add(source,0x14)) }
43     return addr;
44   }
45 
46   function isNotContract(address addr) internal view returns(bool) {
47     uint length;
48     assembly { length := extcodesize(addr) }
49     return length == 0;
50   }
51 }
52 
53 // ----------------------------------------------------------------------------
54 // Zero
55 // ----------------------------------------------------------------------------
56 library Zero {
57   function requireNotZero(address addr) internal pure {
58     require(addr != address(0), "require not zero address");
59   }
60 
61   function requireNotZero(uint val) internal pure {
62     require(val != 0, "require not zero value");
63   }
64 
65   function notZero(address addr) internal pure returns(bool) {
66     return !(addr == address(0));
67   }
68 
69   function isZero(address addr) internal pure returns(bool) {
70     return addr == address(0);
71   }
72 
73   function isZero(uint a) internal pure returns(bool) {
74     return a == 0;
75   }
76 
77   function notZero(uint a) internal pure returns(bool) {
78     return a != 0;
79   }
80 }
81 
82 // ----------------------------------------------------------------------------
83 // Owned contract
84 // ----------------------------------------------------------------------------
85 
86 contract owned {
87     address public owner;
88     address public newOwner;
89 
90     event OwnershipTransferred(address indexed _from, address indexed _to);
91 
92     constructor() public {
93         owner = msg.sender;
94     }
95 
96     modifier onlyOwner {
97         require(msg.sender == owner);
98         _;
99     }
100 
101     function transferOwnership(address _newOwner) public onlyOwner {
102         newOwner = _newOwner;
103     }
104 	
105     function acceptOwnership() public {
106         require(msg.sender == newOwner);
107         emit OwnershipTransferred(owner, newOwner);
108         owner = newOwner;
109         newOwner = address(0);
110     }
111 }
112 
113 interface token {
114     function transfer(address receiver, uint256 amount) external;
115 }
116 
117 contract preCrowdsaleFiatBTC is owned {
118     
119     // Library
120     using SafeMath for uint;
121     
122     address public saleAgent;
123     token public tokenReward;
124     uint256 public totalSalesTokens;
125     
126     mapping(address => uint256) public balanceTokens;
127     mapping(address => uint256) public buyTokens;
128     mapping(address => uint256) public buyTokensBonus;
129     mapping(address => uint256) public bountyTokens;
130     mapping(address => uint256) public refTokens;
131     
132     bool fundingGoalReached = false;
133     bool crowdsaleClosed = false;
134     
135     using Address for *;
136     using Zero for *;
137 
138     event GoalReached(address recipient, uint256 totalAmountRaised);
139     event FundTransfer(address backer, uint256 amount, bool isContribution);
140 
141     /**
142      * Constructor
143      *
144      * Setup the owner
145      */
146     constructor(address _addressOfTokenUsedAsReward) public {
147         tokenReward = token(_addressOfTokenUsedAsReward);
148     }
149 
150 	
151 	function setSaleAgent(address newSeleAgent) public onlyOwner {
152         saleAgent = newSeleAgent;
153     }
154 	
155 	function addTokens(address to, uint256 tokens) public {
156         require(msg.sender == owner || msg.sender == saleAgent);
157         require(!crowdsaleClosed);
158         balanceTokens[to] = balanceTokens[to].add(tokens);
159         buyTokens[to] = buyTokens[to].add(tokens);
160         totalSalesTokens = totalSalesTokens.add(tokens);
161         tokenReward.transfer(to, tokens);
162     }
163     
164     function addTokensBonus(address to, uint256 buyToken, uint256 buyBonus) public {
165         require(msg.sender == owner || msg.sender == saleAgent);
166         require(!crowdsaleClosed);
167         balanceTokens[to] = balanceTokens[to].add(buyToken).add(buyBonus);
168         buyTokens[to] = buyTokens[to].add(buyToken);
169         buyTokensBonus[to] = buyTokensBonus[to].add(buyBonus);
170         totalSalesTokens = totalSalesTokens.add(buyToken).add(buyBonus);
171         tokenReward.transfer(to, buyToken.add(buyBonus));
172     }
173     
174     function addBountyTokens(address to, uint256 bountyToken) public {
175         require(msg.sender == owner || msg.sender == saleAgent);
176         require(!crowdsaleClosed);
177         balanceTokens[to] = balanceTokens[to].add(bountyToken);
178         bountyTokens[to] = bountyTokens[to].add(bountyToken);
179         totalSalesTokens = totalSalesTokens.add(bountyToken);
180         tokenReward.transfer(to, bountyToken);
181     }
182     
183     function addTokensBonusRef(address to, uint256 buyToken, uint256 buyBonus, address referrerAddr, uint256 refToken) public {
184         require(msg.sender == owner || msg.sender == saleAgent);
185         require(!crowdsaleClosed);
186         balanceTokens[to] = balanceTokens[to].add(buyToken).add(buyBonus);
187         buyTokens[to] = buyTokens[to].add(buyToken);
188         buyTokensBonus[to] = buyTokensBonus[to].add(buyBonus);
189         totalSalesTokens = totalSalesTokens.add(buyToken).add(buyBonus);
190         tokenReward.transfer(to, buyToken.add(buyBonus));
191         
192         // Referral bonus
193         balanceTokens[referrerAddr] = balanceTokens[referrerAddr].add(refToken);
194         refTokens[referrerAddr] = refTokens[referrerAddr].add(refToken);
195         totalSalesTokens = totalSalesTokens.add(refToken);
196         tokenReward.transfer(referrerAddr, refToken);
197     }
198     
199     /// @notice Send all tokens to Owner after ICO
200     function sendAllTokensToOwner(uint256 _revardTokens) onlyOwner public {
201         tokenReward.transfer(owner, _revardTokens);
202     }
203 }