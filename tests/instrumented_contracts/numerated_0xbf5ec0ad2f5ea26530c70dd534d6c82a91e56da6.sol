1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   /**
34   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
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
62   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64 
65   /**
66    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
67    * account.
68    */
69   function Ownable() public {
70     owner = msg.sender;
71   }
72 
73   /**
74    * @dev Throws if called by any account other than the owner.
75    */
76   modifier onlyOwner() {
77     require(msg.sender == owner);
78     _;
79   }
80 
81   /**
82    * @dev Allows the current owner to transfer control of the contract to a newOwner.
83    * @param newOwner The address to transfer ownership to.
84    */
85   function transferOwnership(address newOwner) public onlyOwner {
86     require(newOwner != address(0));
87     OwnershipTransferred(owner, newOwner);
88     owner = newOwner;
89   }
90 
91 }
92 
93 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
94 
95 /**
96  * @title ERC20Basic
97  * @dev Simpler version of ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/179
99  */
100 contract ERC20Basic {
101   function totalSupply() public view returns (uint256);
102   function balanceOf(address who) public view returns (uint256);
103   function transfer(address to, uint256 value) public returns (bool);
104   event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
108 
109 /**
110  * @title ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/20
112  */
113 contract ERC20 is ERC20Basic {
114   function allowance(address owner, address spender) public view returns (uint256);
115   function transferFrom(address from, address to, uint256 value) public returns (bool);
116   function approve(address spender, uint256 value) public returns (bool);
117   event Approval(address indexed owner, address indexed spender, uint256 value);
118 }
119 
120 // File: zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
121 
122 /**
123  * @title SafeERC20
124  * @dev Wrappers around ERC20 operations that throw on failure.
125  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
126  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
127  */
128 library SafeERC20 {
129   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
130     assert(token.transfer(to, value));
131   }
132 
133   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
134     assert(token.transferFrom(from, to, value));
135   }
136 
137   function safeApprove(ERC20 token, address spender, uint256 value) internal {
138     assert(token.approve(spender, value));
139   }
140 }
141 
142 // File: contracts/Timelock.sol
143 
144 /**
145  * @title TokenTimelock
146  * @dev A token holder contract that can release its token balance gradually like a
147  * typical vesting scheme with a cliff, gradual release period, and implied residue.
148  *
149  * Withdraws by an address can be paused by the owner.
150  */
151 contract Timelock is Ownable {
152   using SafeMath for uint256;
153   using SafeERC20 for ERC20Basic;
154 
155   /*
156    * @dev ERC20 token that is being timelocked
157    */
158   ERC20Basic public token;
159 
160   /**
161    * @dev timestamp at which the timelock schedule begins
162    */
163   uint256 public startTime;
164 
165   /**
166    * @dev number of seconds from startTime to cliff
167    */
168   uint256 public cliffDuration;
169 
170   /**
171    * @dev a percentage that becomes available at the cliff, expressed as a number between 0 and 100
172    */
173   uint256 public cliffReleasePercentage;
174 
175   /**
176    * @dev number of seconds from cliff to residue, over this period tokens become avialable gradually
177    */
178   uint256 public slopeDuration;
179 
180   /**
181    * @dev a percentage that becomes avilable over the gradual release period expressed as a number between 0 and 100
182    */
183   uint256 public slopeReleasePercentage;
184 
185   /**
186    * @dev boolean indicating if owner has finished allocation.
187    */
188   bool public allocationFinished;
189 
190   /**
191    * @dev variable to keep track of cliff time.
192    */
193   uint256 public cliffTime;
194 
195   /**
196    * @dev variable to keep track of when the timelock ends.
197    */
198   uint256 public timelockEndTime;
199 
200   /**
201    * @dev mapping to keep track of what amount of tokens have been allocated to what address.
202    */
203   mapping (address => uint256) public allocatedTokens;
204 
205   /**
206    * @dev mapping to keep track of what amount of tokens have been withdrawn by what address.
207    */
208   mapping (address => uint256) public withdrawnTokens;
209 
210   /**
211    * @dev mapping to keep track of if withdrawls are paused for a given address.
212    */
213   mapping (address => bool) public withdrawalPaused;
214 
215   /**
216    * @dev constructor
217    * @param _token address of ERC20 token that is being timelocked.
218    * @param _startTime timestamp indicating when the unlocking of tokens start.
219    * @param _cliffDuration number of seconds before any tokens are unlocked.
220    * @param _cliffReleasePercent percentage of tokens that become available at the cliff time.
221    * @param _slopeDuration number of seconds for gradual release of Tokens.
222    * @param _slopeReleasePercentage percentage of tokens that are released gradually.
223    */
224   function Timelock(ERC20Basic _token, uint256 _startTime, uint256 _cliffDuration, uint256 _cliffReleasePercent, uint256 _slopeDuration, uint256 _slopeReleasePercentage) public {
225 
226     // sanity checks
227     require(_cliffReleasePercent.add(_slopeReleasePercentage) <= 100);
228     require(_startTime > now);
229     require(_token != address(0));
230 
231     // defaults
232     allocationFinished = false;
233 
234     // storing constructor params
235     token = _token;
236     startTime = _startTime;
237     cliffDuration = _cliffDuration;
238     cliffReleasePercentage = _cliffReleasePercent;
239     slopeDuration = _slopeDuration;
240     slopeReleasePercentage = _slopeReleasePercentage;
241 
242     // derived variables
243     cliffTime = startTime.add(cliffDuration);
244     timelockEndTime = cliffTime.add(slopeDuration);
245   }
246 
247   /**
248    * @dev helper method that allows owner to allocate tokens to an address.
249    * @param _address beneficiary receiving the tokens.
250    * @param _amount number of tokens being received by beneficiary.
251    * @return boolean indicating function success.
252    */
253   function allocateTokens(address _address, uint256 _amount) onlyOwner external returns (bool) {
254     require(!allocationFinished);
255 
256     allocatedTokens[_address] = _amount;
257     return true;
258   }
259 
260   /**
261    * @dev helper method that allows owner to mark allocation as done.
262    * @return boolean indicating function success.
263    */
264   function finishAllocation() onlyOwner external returns (bool) {
265     allocationFinished = true;
266 
267     return true;
268   }
269 
270   /**
271    * @dev helper method that allows owner to pause withdrawls for any address.
272    * @return boolean indicating function success.
273    */
274   function pauseWithdrawal(address _address) onlyOwner external returns (bool) {
275     withdrawalPaused[_address] = true;
276     return true;
277   }
278 
279   /**
280    * @dev helper method that allows owner to unpause withdrawls for any address.
281    * @return boolean indicating function success.
282    */
283   function unpauseWithdrawal(address _address) onlyOwner external returns (bool) {
284     withdrawalPaused[_address] = false;
285     return true;
286   }
287 
288   /**
289    * @dev helper method that allows anyone to check amount that is available for withdrawl by a given address.
290    * @param _address for which the user needs to check available amount for withdrawl.
291    * @return uint256 number indicating the number of tokens available for withdrawl.
292    */
293   function availableForWithdrawal(address _address) public view returns (uint256) {
294     if (now < cliffTime) {
295       return 0;
296     } else if (now < timelockEndTime) {
297       uint256 cliffTokens = (cliffReleasePercentage.mul(allocatedTokens[_address])).div(100);
298       uint256 slopeTokens = (allocatedTokens[_address].mul(slopeReleasePercentage)).div(100);
299       uint256 timeAtSlope = now.sub(cliffTime);
300       uint256 slopeTokensByNow = (slopeTokens.mul(timeAtSlope)).div(slopeDuration);
301 
302       return (cliffTokens.add(slopeTokensByNow)).sub(withdrawnTokens[_address]);
303     } else {
304       return allocatedTokens[_address].sub(withdrawnTokens[_address]);
305     }
306   }
307 
308   /**
309    * @dev helper method that allows a beneficiary to withdraw tokens that have vested for their address.
310    * @return boolean indicating function success.
311    */
312   function withdraw() external returns (bool) {
313     require(!withdrawalPaused[msg.sender]);
314 
315     uint256 availableTokens = availableForWithdrawal(msg.sender);
316     require (availableTokens > 0);
317     withdrawnTokens[msg.sender] = withdrawnTokens[msg.sender].add(availableTokens);
318     token.safeTransfer(msg.sender, availableTokens);
319     return true;
320   }
321 
322 }