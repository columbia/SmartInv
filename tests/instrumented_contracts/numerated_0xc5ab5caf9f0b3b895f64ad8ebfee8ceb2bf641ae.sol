1 pragma solidity ^0.4.18;
2 
3 // File: contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 contract SafeMath {
10   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
11     uint256 c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal constant returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal constant returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 
34   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
35     return a >= b ? a : b;
36   }
37 
38   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
39     return a < b ? a : b;
40   }
41 
42   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
43     return a >= b ? a : b;
44   }
45 
46   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
47     return a < b ? a : b;
48   }
49 }
50 
51 // File: contracts/ownership/Ownable.sol
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   /**
63    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64    * account.
65    */
66   function Ownable() {
67     owner = msg.sender;
68   }
69 
70 
71   /**
72    * @dev Throws if called by any account other than the owner.
73    */
74   modifier onlyOwner() {
75     require(msg.sender == owner);
76     _;
77   }
78 
79 
80   /**
81    * @dev Allows the current owner to transfer control of the contract to a newOwner.
82    * @param newOwner The address to transfer ownership to.
83    */
84   function transferOwnership(address newOwner) onlyOwner {
85     require(newOwner != address(0));
86     owner = newOwner;
87   }
88 
89 }
90 
91 // File: contracts/token/ERC20Basic.sol
92 
93 /**
94  * @title ERC20Basic
95  * @dev Simpler version of ERC20 interface
96  * @dev see https://github.com/ethereum/EIPs/issues/179
97  */
98 contract ERC20Basic {
99   uint256 public totalSupply;
100   function balanceOf(address who) public view returns (uint256);
101   function transfer(address to, uint256 value) public returns (bool);
102   event Transfer(address indexed from, address indexed to, uint256 value);
103 }
104 
105 // File: contracts/token/ERC20.sol
106 
107 /**
108  * @title ERC20 interface
109  * @dev see https://github.com/ethereum/EIPs/issues/20
110  */
111 contract ERC20 is ERC20Basic {
112   function allowance(address owner, address spender) public view returns (uint256);
113   function transferFrom(address from, address to, uint256 value) public returns (bool);
114   function approve(address spender, uint256 value) public returns (bool);
115   event Approval(address indexed owner, address indexed spender, uint256 value);
116 }
117 
118 // File: contracts/token/SafeERC20.sol
119 
120 /**
121  * @title SafeERC20
122  * @dev Wrappers around ERC20 operations that throw on failure.
123  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
124  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
125  */
126 library SafeERC20 {
127   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
128     assert(token.transfer(to, value));
129   }
130 
131   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
132     assert(token.transferFrom(from, to, value));
133   }
134 
135   function safeApprove(ERC20 token, address spender, uint256 value) internal {
136     assert(token.approve(spender, value));
137   }
138 }
139 
140 // File: contracts/TeamLocker.sol
141 
142 /**
143  * @title TokenTimelock
144  * @dev TokenTimelock is a token holder contract that will allow a
145  * beneficiary to extract the tokens after a given release time
146  */
147 contract TeamLocker is SafeMath, Ownable {
148     using SafeERC20 for ERC20Basic;
149 
150     ERC20Basic public token;
151 
152     address[] public beneficiaries;
153     uint256[] public ratios;
154     uint256 public genTime;
155     
156     uint256 public collectedTokens;
157 
158     function TeamLocker(address _token, address[] _beneficiaries, uint256[] _ratios, uint256 _genTime) {
159 
160         require(_token != 0x00);
161         require(_beneficiaries.length > 0 && _beneficiaries.length == _ratios.length);
162         require(_genTime > 0);
163 
164         for (uint i = 0; i < _beneficiaries.length; i++) {
165             require(_beneficiaries[i] != 0x00);
166         }
167 
168         token = ERC20Basic(_token);
169         beneficiaries = _beneficiaries;
170         ratios = _ratios;
171         genTime = _genTime;
172     }
173 
174     /**
175      * @notice Transfers tokens held by timelock to beneficiary.
176      */
177     function release() public {
178 
179         uint256 balance = token.balanceOf(address(this));
180         uint256 total = add(balance, collectedTokens);
181 
182         uint256 lockTime1 = add(genTime, 183 days); // 6 months
183         uint256 lockTime2 = add(genTime, 1 years); // 1 year
184 
185         uint256 currentRatio = 20;
186 
187         if (now >= lockTime1) {
188             currentRatio = 50;
189         }
190 
191         if (now >= lockTime2) {
192             currentRatio = 100;
193         }
194 
195         uint256 releasedAmount = div(mul(total, currentRatio), 100);
196         uint256 grantAmount = sub(releasedAmount, collectedTokens);
197         require(grantAmount > 0);
198         collectedTokens = add(collectedTokens, grantAmount);
199 
200 
201         uint256 grantAmountForEach; // = div(grantAmount, 3);
202 
203         for (uint i = 0; i < beneficiaries.length; i++) {
204             grantAmountForEach = div(mul(grantAmount, ratios[i]), 100);
205             token.safeTransfer(beneficiaries[i], grantAmountForEach);
206         }
207     }
208 
209 
210     function setGenTime(uint256 _genTime) public onlyOwner {
211         require(_genTime > 0);
212         genTime = _genTime;
213     }
214 
215     function setToken(address newToken) public onlyOwner {
216         require(newToken != 0x00);
217         token = ERC20Basic(newToken);
218     }
219     
220     function destruct(address to) public onlyOwner {
221         require(to != 0x00);
222         selfdestruct(to);
223     }
224 }