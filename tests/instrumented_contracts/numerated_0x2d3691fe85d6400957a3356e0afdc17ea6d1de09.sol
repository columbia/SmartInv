1 pragma solidity 0.4.18;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) public onlyOwner {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
48 
49 /**
50  * @title Pausable
51  * @dev Base contract which allows children to implement an emergency stop mechanism.
52  */
53 contract Pausable is Ownable {
54   event Pause();
55   event Unpause();
56 
57   bool public paused = false;
58 
59 
60   /**
61    * @dev Modifier to make a function callable only when the contract is not paused.
62    */
63   modifier whenNotPaused() {
64     require(!paused);
65     _;
66   }
67 
68   /**
69    * @dev Modifier to make a function callable only when the contract is paused.
70    */
71   modifier whenPaused() {
72     require(paused);
73     _;
74   }
75 
76   /**
77    * @dev called by the owner to pause, triggers stopped state
78    */
79   function pause() onlyOwner whenNotPaused public {
80     paused = true;
81     Pause();
82   }
83 
84   /**
85    * @dev called by the owner to unpause, returns to normal state
86    */
87   function unpause() onlyOwner whenPaused public {
88     paused = false;
89     Unpause();
90   }
91 }
92 
93 // File: zeppelin-solidity/contracts/math/SafeMath.sol
94 
95 /**
96  * @title SafeMath
97  * @dev Math operations with safety checks that throw on error
98  */
99 library SafeMath {
100   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
101     if (a == 0) {
102       return 0;
103     }
104     uint256 c = a * b;
105     assert(c / a == b);
106     return c;
107   }
108 
109   function div(uint256 a, uint256 b) internal pure returns (uint256) {
110     // assert(b > 0); // Solidity automatically throws when dividing by 0
111     uint256 c = a / b;
112     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
113     return c;
114   }
115 
116   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
117     assert(b <= a);
118     return a - b;
119   }
120 
121   function add(uint256 a, uint256 b) internal pure returns (uint256) {
122     uint256 c = a + b;
123     assert(c >= a);
124     return c;
125   }
126 }
127 
128 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
129 
130 /**
131  * @title ERC20Basic
132  * @dev Simpler version of ERC20 interface
133  * @dev see https://github.com/ethereum/EIPs/issues/179
134  */
135 contract ERC20Basic {
136   uint256 public totalSupply;
137   function balanceOf(address who) public view returns (uint256);
138   function transfer(address to, uint256 value) public returns (bool);
139   event Transfer(address indexed from, address indexed to, uint256 value);
140 }
141 
142 // File: zeppelin-solidity/contracts/token/ERC20.sol
143 
144 /**
145  * @title ERC20 interface
146  * @dev see https://github.com/ethereum/EIPs/issues/20
147  */
148 contract ERC20 is ERC20Basic {
149   function allowance(address owner, address spender) public view returns (uint256);
150   function transferFrom(address from, address to, uint256 value) public returns (bool);
151   function approve(address spender, uint256 value) public returns (bool);
152   event Approval(address indexed owner, address indexed spender, uint256 value);
153 }
154 
155 // File: zeppelin-solidity/contracts/token/SafeERC20.sol
156 
157 /**
158  * @title SafeERC20
159  * @dev Wrappers around ERC20 operations that throw on failure.
160  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
161  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
162  */
163 library SafeERC20 {
164   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
165     assert(token.transfer(to, value));
166   }
167 
168   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
169     assert(token.transferFrom(from, to, value));
170   }
171 
172   function safeApprove(ERC20 token, address spender, uint256 value) internal {
173     assert(token.approve(spender, value));
174   }
175 }
176 
177 // File: contracts/Crowdsale.sol
178 
179 contract Crowdsale is Ownable, Pausable {
180   using SafeMath for uint256;
181   using SafeERC20 for ERC20;
182 
183   // token being sold
184   ERC20 public token;
185 
186   // address where funds are collected
187   address public wallet;
188 
189   // address where tokens come from
190   address public supplier;
191 
192   // rate 6/1 (6 token uints for 1 wei)
193   uint256 public purposeWeiRate = 6;
194   uint256 public etherWeiRate = 1;
195 
196   // amount of raised wei
197   uint256 public weiRaised = 0;
198 
199   // amount of tokens raised (in wei)
200   uint256 public weiTokensRaised = 0;
201 
202   /**
203    * event for token purchase logging
204    * @param purchaser who paid for the tokens
205    * @param beneficiary who got the tokens
206    * @param value weis paid for purchase
207    * @param amount amount of tokens purchased
208    */
209   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
210 
211   function Crowdsale(address _wallet, address _supplier, address _token, uint256 _purposeWeiRate, uint256 _etherWeiRate) public {
212     require(_token != address(0));
213     require(_supplier != address(0));
214 
215     changeWallet(_wallet);
216     supplier = _supplier;
217     token = ERC20(_token);
218     changeRate(_purposeWeiRate, _etherWeiRate);
219   }
220 
221   // fallback function can be used to buy tokens
222   function () external payable {
223     buyTokens(msg.sender);
224   }
225 
226   // change wallet
227   function changeWallet(address _wallet) public onlyOwner {
228     require(_wallet != address(0));
229 
230     wallet = _wallet;
231   }
232 
233   // change rate
234   function changeRate(uint256 _purposeWeiRate, uint256 _etherWeiRate) public onlyOwner {
235     require(_purposeWeiRate > 0);
236     require(_etherWeiRate > 0);
237     
238     purposeWeiRate = _purposeWeiRate;
239     etherWeiRate = _etherWeiRate;
240   }
241 
242   // low level token purchase function
243   function buyTokens(address beneficiary) public payable whenNotPaused {
244     require(beneficiary != address(0));
245     require(validPurchase());
246 
247     uint256 weiAmount = msg.value;
248 
249     // calculate token amount to be created
250     uint256 tokens = weiAmount.div(etherWeiRate).mul(purposeWeiRate);
251 
252     // update state
253     weiRaised = weiRaised.add(weiAmount);
254     weiTokensRaised = weiTokensRaised.add(tokens);
255 
256     // transfer
257     token.safeTransferFrom(supplier, beneficiary, tokens);
258 
259     // logs
260     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
261 
262     // forward funds to wallet
263     forwardFunds();
264   }
265 
266   // send ether to the fund collection wallet
267   // override to create custom fund forwarding mechanisms
268   function forwardFunds() internal {
269     wallet.transfer(msg.value);
270   }
271 
272   // @return true if the transaction can buy tokens
273   function validPurchase() internal view returns (bool) {
274     bool nonZeroPurchase = msg.value != 0;
275     return !paused && nonZeroPurchase;
276   }
277 }