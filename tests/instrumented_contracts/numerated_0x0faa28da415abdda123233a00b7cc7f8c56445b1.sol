1 pragma solidity 0.4.25;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that revert on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, reverts on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     uint256 c = a * b;
23     require(c / a == b);
24 
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
30   */
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     require(b > 0); // Solidity only automatically asserts when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36     return c;
37   }
38 
39   /**
40   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41   */
42   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43     require(b <= a);
44     uint256 c = a - b;
45 
46     return c;
47   }
48 
49   /**
50   * @dev Adds two numbers, reverts on overflow.
51   */
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     require(c >= a);
55 
56     return c;
57   }
58 
59   /**
60   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
61   * reverts when dividing by zero.
62   */
63   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64     require(b != 0);
65     return a % b;
66   }
67 }
68 
69 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
70 
71 /**
72  * @title ERC20 interface
73  * @dev see https://github.com/ethereum/EIPs/issues/20
74  */
75 interface IERC20 {
76   function totalSupply() external view returns (uint256);
77 
78   function balanceOf(address who) external view returns (uint256);
79 
80   function allowance(address owner, address spender)
81     external view returns (uint256);
82 
83   function transfer(address to, uint256 value) external returns (bool);
84 
85   function approve(address spender, uint256 value)
86     external returns (bool);
87 
88   function transferFrom(address from, address to, uint256 value)
89     external returns (bool);
90 
91   event Transfer(
92     address indexed from,
93     address indexed to,
94     uint256 value
95   );
96 
97   event Approval(
98     address indexed owner,
99     address indexed spender,
100     uint256 value
101   );
102 }
103 
104 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
105 
106 /**
107  * @title SafeERC20
108  * @dev Wrappers around ERC20 operations that throw on failure.
109  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
110  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
111  */
112 library SafeERC20 {
113 
114   using SafeMath for uint256;
115 
116   function safeTransfer(
117     IERC20 token,
118     address to,
119     uint256 value
120   )
121     internal
122   {
123     require(token.transfer(to, value));
124   }
125 
126   function safeTransferFrom(
127     IERC20 token,
128     address from,
129     address to,
130     uint256 value
131   )
132     internal
133   {
134     require(token.transferFrom(from, to, value));
135   }
136 
137   function safeApprove(
138     IERC20 token,
139     address spender,
140     uint256 value
141   )
142     internal
143   {
144     // safeApprove should only be called when setting an initial allowance, 
145     // or when resetting it to zero. To increase and decrease it, use 
146     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
147     require((value == 0) || (token.allowance(msg.sender, spender) == 0));
148     require(token.approve(spender, value));
149   }
150 
151   function safeIncreaseAllowance(
152     IERC20 token,
153     address spender,
154     uint256 value
155   )
156     internal
157   {
158     uint256 newAllowance = token.allowance(address(this), spender).add(value);
159     require(token.approve(spender, newAllowance));
160   }
161 
162   function safeDecreaseAllowance(
163     IERC20 token,
164     address spender,
165     uint256 value
166   )
167     internal
168   {
169     uint256 newAllowance = token.allowance(address(this), spender).sub(value);
170     require(token.approve(spender, newAllowance));
171   }
172 }
173 
174 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
175 
176 /**
177  * @title Ownable
178  * @dev The Ownable contract has an owner address, and provides basic authorization control
179  * functions, this simplifies the implementation of "user permissions".
180  */
181 contract Ownable {
182   address private _owner;
183 
184   event OwnershipTransferred(
185     address indexed previousOwner,
186     address indexed newOwner
187   );
188 
189   /**
190    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
191    * account.
192    */
193   constructor() internal {
194     _owner = msg.sender;
195     emit OwnershipTransferred(address(0), _owner);
196   }
197 
198   /**
199    * @return the address of the owner.
200    */
201   function owner() public view returns(address) {
202     return _owner;
203   }
204 
205   /**
206    * @dev Throws if called by any account other than the owner.
207    */
208   modifier onlyOwner() {
209     require(isOwner());
210     _;
211   }
212 
213   /**
214    * @return true if `msg.sender` is the owner of the contract.
215    */
216   function isOwner() public view returns(bool) {
217     return msg.sender == _owner;
218   }
219 
220   /**
221    * @dev Allows the current owner to relinquish control of the contract.
222    * @notice Renouncing to ownership will leave the contract without an owner.
223    * It will not be possible to call the functions with the `onlyOwner`
224    * modifier anymore.
225    */
226   function renounceOwnership() public onlyOwner {
227     emit OwnershipTransferred(_owner, address(0));
228     _owner = address(0);
229   }
230 
231   /**
232    * @dev Allows the current owner to transfer control of the contract to a newOwner.
233    * @param newOwner The address to transfer ownership to.
234    */
235   function transferOwnership(address newOwner) public onlyOwner {
236     _transferOwnership(newOwner);
237   }
238 
239   /**
240    * @dev Transfers control of the contract to a newOwner.
241    * @param newOwner The address to transfer ownership to.
242    */
243   function _transferOwnership(address newOwner) internal {
244     require(newOwner != address(0));
245     emit OwnershipTransferred(_owner, newOwner);
246     _owner = newOwner;
247   }
248 }
249 
250 // File: contracts/Vesting.sol
251 
252 /**
253  * @title Vesting
254  * @dev Vesting is a token holder contract that will allow a
255  * beneficiary to extract the tokens after a given release time
256  */
257 contract Vesting is Ownable {
258     using SafeERC20 for IERC20;
259     using SafeMath for uint256;
260 
261     // ERC20 basic token contract being held
262     IERC20 private _token;
263 
264     // Info holds all the relevant information to calculate the right amount for `release`
265     struct Info {
266         bool    known;          // Logs whether or not the address is known and eligible to receive tokens
267         uint256 totalAmount;    // Total amount of tokens to receive
268         uint256 receivedAmount; // Amount of tokens already received
269         uint256 startTime;      // Starting time of vesting
270         uint256 releaseTime;    // End time of vesting
271     }
272 
273     // Mapping of an address to it's information
274     mapping(address => Info) private _info;
275 
276     constructor(
277         IERC20 token
278     )
279         public
280     {
281         _token = token;
282     }
283     
284     /**
285      * @notice Add beneficiaries to the contract, allowing them to withdraw tokens.
286      * @param beneficiary The address associated with the beneficiary.
287      * @param releaseTime The timestamp at which 100% of their allocation is freed up.
288      * @param amount The amount of tokens they can receive in total.
289      */
290     function addBeneficiary(
291         address beneficiary,
292         uint256 startTime,
293         uint256 releaseTime,
294         uint256 amount
295     )
296         external
297         onlyOwner
298     {
299         Info storage info = _info[beneficiary];
300         require(!info.known, "This address is already known to the contract.");
301         require(releaseTime > startTime, "Release time must be later than the start time.");
302         require(releaseTime > block.timestamp, "End of vesting period must be somewhere in the future.");
303 
304         info.startTime = startTime; // Set starting time
305         info.totalAmount = amount; // Set amount
306         info.releaseTime = releaseTime; // Set release time
307         info.known = true; // Prevent overwriting of address data
308     }
309 
310     /**
311      * @notice Remove a beneficiary from the contract, preventing them from 
312      * retrieving tokens in the future.
313      * @param beneficiary The address associated with the beneficiary.
314      */
315     function removeBeneficiary(address beneficiary) external onlyOwner {
316         Info storage info = _info[beneficiary];
317         require(info.known, "The address you are trying to remove is unknown to the contract");
318 
319         _release(beneficiary); // Release leftover tokens before removing the investor
320         info.known = false;
321         info.totalAmount = 0;
322         info.receivedAmount = 0;
323         info.startTime = 0;
324         info.releaseTime = 0;
325     }
326 
327     /**
328      * @notice Withdraw tokens from the contract. This function is strictly
329      * for the owner, intended to take out any leftovers if needed.
330      * @param amount The amount of tokens to take out.
331      */
332     function withdraw(uint256 amount) external onlyOwner {
333         _token.safeTransfer(owner(), amount);
334     }
335 
336     /**
337      * @notice Transfers tokens held by timelock to beneficiary.
338      * This function will check if a caller is eligible to receive tokens
339      * and if so, will then call the internal `_release` function.
340      */
341     function release() external {
342         require(_info[msg.sender].known, "You are not eligible to receive tokens from this contract.");
343         _release(msg.sender);
344     }
345 
346     /**
347      * @notice Simple function to return vesting information for a caller.
348      * Callers can then validate if their information has been properly stored,
349      * instead of trusting the contract owner.
350      */
351     function check() external view returns (uint256, uint256, uint256, uint256) {
352         return (
353             _info[msg.sender].totalAmount, 
354             _info[msg.sender].receivedAmount,
355             _info[msg.sender].startTime, 
356             _info[msg.sender].releaseTime
357         );
358     }
359 
360     /**
361      * @notice Internal function to release tokens to a beneficiary.
362      * This function has been extended from the `release` function included in
363      * `TokenTimelock.sol` included in the OpenZeppelin-solidity library, to allow
364      * for a 'second-by-second' token vesting schedule. Since block timestamps
365      * is the closest Solidity can get to reading the current time, this
366      * mechanism is used.
367      */
368     function _release(address beneficiary) internal {
369         Info storage info = _info[beneficiary];
370         if (block.timestamp >= info.releaseTime) {
371             uint256 remainingTokens = info.totalAmount.sub(info.receivedAmount);
372             require(remainingTokens > 0, "No tokens left to take out.");
373 
374             // Since `safeTransfer` will throw upon failure, we can modify the state beforehand.
375             info.receivedAmount = info.totalAmount;
376             _token.safeTransfer(beneficiary, remainingTokens);
377         } else if (block.timestamp > info.startTime) {
378             // Calculate allowance
379             uint256 diff = info.releaseTime.sub(info.startTime);
380             uint256 tokensPerTick = info.totalAmount.div(diff);
381             uint256 ticks = block.timestamp.sub(info.startTime);
382             uint256 tokens = tokensPerTick.mul(ticks);
383             uint256 receivableTokens = tokens.sub(info.receivedAmount);
384             require(receivableTokens > 0, "No tokens to take out right now.");
385 
386             // Since `safeTransfer` will throw upon failure, we can modify the state beforehand.
387             info.receivedAmount = info.receivedAmount.add(receivableTokens);
388             _token.safeTransfer(beneficiary, receivableTokens);
389         } else {
390             // We could let SafeMath revert release calls if vesting has not started yet.
391             // However, in the interest of clarity to contract callers, this error
392             // message is added instead.
393             revert("This address is not eligible to receive tokens yet.");
394         }
395     }
396 }