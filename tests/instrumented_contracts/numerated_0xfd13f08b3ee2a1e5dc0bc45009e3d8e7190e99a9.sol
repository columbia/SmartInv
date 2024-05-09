1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (_a == 0) {
17       return 0;
18     }
19 
20     uint256 c = _a * _b;
21     require(c / _a == _b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
30     require(_b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = _a / _b;
32     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     require(_b <= _a);
42     uint256 c = _a - _b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
51     uint256 c = _a + _b;
52     require(c >= _a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 
68 /**
69  * @title ERC20 interface
70  * @dev see https://github.com/ethereum/EIPs/issues/20
71  */
72 contract ERC20 {
73   function totalSupply() public view returns (uint256);
74 
75   function balanceOf(address _who) public view returns (uint256);
76 
77   function allowance(address _owner, address _spender)
78     public view returns (uint256);
79 
80   function transfer(address _to, uint256 _value) public returns (bool);
81 
82   function approve(address _spender, uint256 _value)
83     public returns (bool);
84 
85   function transferFrom(address _from, address _to, uint256 _value)
86     public returns (bool);
87 
88   event Transfer(
89     address indexed from,
90     address indexed to,
91     uint256 value
92   );
93 
94   event Approval(
95     address indexed owner,
96     address indexed spender,
97     uint256 value
98   );
99 }
100 
101 /**
102  * @title SafeERC20
103  * @dev Wrappers around ERC20 operations that throw on failure.
104  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
105  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
106  */
107 library SafeERC20 {
108   function safeTransfer(
109     ERC20 _token,
110     address _to,
111     uint256 _value
112   )
113     internal
114   {
115     require(_token.transfer(_to, _value));
116   }
117 
118   function safeTransferFrom(
119     ERC20 _token,
120     address _from,
121     address _to,
122     uint256 _value
123   )
124     internal
125   {
126     require(_token.transferFrom(_from, _to, _value));
127   }
128 
129   function safeApprove(
130     ERC20 _token,
131     address _spender,
132     uint256 _value
133   )
134     internal
135   {
136     require(_token.approve(_spender, _value));
137   }
138 }
139 
140 /**
141  * @title Ownable
142  * @dev The Ownable contract has an owner address, and provides basic authorization control
143  * functions, this simplifies the implementation of "user permissions".
144  */
145 contract Ownable {
146   address public owner;
147 
148 
149   event OwnershipRenounced(address indexed previousOwner);
150   event OwnershipTransferred(
151     address indexed previousOwner,
152     address indexed newOwner
153   );
154 
155 
156   /**
157    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
158    * account.
159    */
160   constructor() public {
161     owner = msg.sender;
162   }
163 
164   /**
165    * @dev Throws if called by any account other than the owner.
166    */
167   modifier onlyOwner() {
168     require(msg.sender == owner);
169     _;
170   }
171 
172   /**
173    * @dev Allows the current owner to relinquish control of the contract.
174    * @notice Renouncing to ownership will leave the contract without an owner.
175    * It will not be possible to call the functions with the `onlyOwner`
176    * modifier anymore.
177    */
178   function renounceOwnership() public onlyOwner {
179     emit OwnershipRenounced(owner);
180     owner = address(0);
181   }
182 
183   /**
184    * @dev Allows the current owner to transfer control of the contract to a newOwner.
185    * @param _newOwner The address to transfer ownership to.
186    */
187   function transferOwnership(address _newOwner) public onlyOwner {
188     _transferOwnership(_newOwner);
189   }
190 
191   /**
192    * @dev Transfers control of the contract to a newOwner.
193    * @param _newOwner The address to transfer ownership to.
194    */
195   function _transferOwnership(address _newOwner) internal {
196     require(_newOwner != address(0));
197     emit OwnershipTransferred(owner, _newOwner);
198     owner = _newOwner;
199   }
200 }
201 
202 
203 /**
204  * @title Destructible
205  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
206  */
207 contract Destructible is Ownable {
208   /**
209    * @dev Transfers the current balance to the owner and terminates the contract.
210    */
211   function destroy() public onlyOwner {
212     selfdestruct(owner);
213   }
214 
215   function destroyAndSend(address _recipient) public onlyOwner {
216     selfdestruct(_recipient);
217   }
218 }
219 /**
220  * @title Pausable
221  * @dev Base contract which allows children to implement an emergency stop mechanism.
222  */
223 contract Pausable is Ownable {
224   event Pause();
225   event Unpause();
226 
227   bool public paused = false;
228 
229 
230   /**
231    * @dev Modifier to make a function callable only when the contract is not paused.
232    */
233   modifier whenNotPaused() {
234     require(!paused);
235     _;
236   }
237 
238   /**
239    * @dev Modifier to make a function callable only when the contract is paused.
240    */
241   modifier whenPaused() {
242     require(paused);
243     _;
244   }
245 
246   /**
247    * @dev called by the owner to pause, triggers stopped state
248    */
249   function pause() onlyOwner whenNotPaused public {
250     paused = true;
251     emit Pause();
252   }
253 
254   /**
255    * @dev called by the owner to unpause, returns to normal state
256    */
257   function unpause() onlyOwner whenPaused public {
258     paused = false;
259     emit Unpause();
260   }
261 }
262 
263 /**
264  * @title Claimable
265  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
266  * This allows the new owner to accept the transfer.
267  */
268 contract Claimable is Ownable {
269   address public pendingOwner;
270 
271   /**
272    * @dev Modifier throws if called by any account other than the pendingOwner.
273    */
274   modifier onlyPendingOwner() {
275     require(msg.sender == pendingOwner);
276     _;
277   }
278 
279   /**
280    * @dev Allows the current owner to set the pendingOwner address.
281    * @param newOwner The address to transfer ownership to.
282    */
283   function transferOwnership(address newOwner) public onlyOwner {
284     pendingOwner = newOwner;
285   }
286 
287   /**
288    * @dev Allows the pendingOwner address to finalize the transfer.
289    */
290   function claimOwnership() public onlyPendingOwner {
291     emit OwnershipTransferred(owner, pendingOwner);
292     owner = pendingOwner;
293     pendingOwner = address(0);
294   }
295 }
296 
297 /**
298  * @title Contracts that should not own Contracts
299  * @author Remco Bloemen <remco@2π.com>
300  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
301  * of this contract to reclaim ownership of the contracts.
302  */
303 contract HasNoContracts is Ownable {
304 
305   /**
306    * @dev Reclaim ownership of Ownable contracts
307    * @param _contractAddr The address of the Ownable to be reclaimed.
308    */
309   function reclaimContract(address _contractAddr) external onlyOwner {
310     Ownable contractInst = Ownable(_contractAddr);
311     contractInst.transferOwnership(owner);
312   }
313 }
314 
315 /**
316  * @title Contracts that should be able to recover tokens
317  * @author SylTi
318  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
319  * This will prevent any accidental loss of tokens.
320  */
321 contract CanReclaimToken is Ownable {
322   using SafeERC20 for ERC20;
323 
324   /**
325    * @dev Reclaim all ERC20 compatible tokens
326    * @param _token ERC20 The address of the token contract
327    */
328   function reclaimToken(ERC20 _token) external onlyOwner {
329     uint256 balance = _token.balanceOf(this);
330     _token.safeTransfer(owner, balance);
331   }
332 
333 }
334 
335 /**
336  * Automated buy back BOB tokens
337  */
338 contract BobBuyback is Claimable, HasNoContracts, CanReclaimToken, Destructible {
339     using SafeMath for uint256;    
340 
341     ERC20 public token;                 //Address of BOB token contract
342     uint256 public maxGasPrice;         //Highest gas price allowed for buyback transaction
343     uint256 public maxTxValue;          //Highest amount of BOB sent in one transaction
344     uint256 public roundStartTime;      //Timestamp when buyback starts (timestamp of the first block where buyback allowed)
345     uint256 public rate;                //1 ETH = rate BOB
346 
347     event Buyback(address indexed from, uint256 amountBob, uint256 amountEther);
348 
349     constructor(ERC20 _token, uint256 _maxGasPrice, uint256 _maxTxValue) public {
350         token = _token;
351         maxGasPrice = _maxGasPrice;
352         maxTxValue = _maxTxValue;
353         roundStartTime = 0;
354         rate = 0;
355     }
356 
357     /**
358      * @notice Somebody may call this to sell his tokens
359      * @param _amount How much tokens to sell
360      * Call to token.approve() required before calling this function
361      */
362     function buyback(uint256 _amount) external {
363         require(tx.gasprice <= maxGasPrice);
364         require(_amount <= maxTxValue);
365         require(isRunning());
366 
367         uint256 amount = _amount;
368         uint256 reward = calcReward(amount);
369 
370         if(address(this).balance < reward) {
371             //If not enough money to fill request, handle it partially
372             reward = address(this).balance;
373             amount = reward.mul(rate);
374         }
375 
376         require(token.transferFrom(msg.sender, address(this), amount));
377         msg.sender.transfer(reward);
378         emit Buyback(msg.sender, amount, reward);
379     }
380 
381     /**
382      * @notice Calculates how much ETH somebody can receive for selling amount BOB
383      * @param amount How much tokens to sell
384      */
385     function calcReward(uint256 amount) view public returns(uint256) {
386         if(rate == 0) return 0;     //Handle situation when no Buyback is planned
387         return amount.div(rate);    //This operation may result in rounding. Which is fine here (rounded  amount < rate / 10**18)
388     }
389 
390     /**
391      * @notice Calculates how much BOB tokens this contract can buy (during current buyback round)
392      */
393     function calcTokensAvailableToBuyback() view public returns(uint256) {
394         return address(this).balance.mul(rate);
395     }
396 
397     /**
398      * @notice Checks if Buyback round is running
399      */
400     function isRunning() view public returns(bool) {
401         return (rate > 0) && (now >= roundStartTime) && (address(this).balance > 0);
402     }
403 
404     /**
405      * @notice Changes buyback parameters
406      * @param _maxGasPrice Max gas price one ca use to sell is tokens. 
407      * @param _maxTxValue Max amount of tokens to sell in one transaction
408      */
409     function setup(uint256 _maxGasPrice, uint256 _maxTxValue) onlyOwner external {
410         maxGasPrice = _maxGasPrice;
411         maxTxValue = _maxTxValue;
412     }
413 
414     /**
415      * @notice Starts buyback at specified time, with specified rate
416      * @param _roundStartTime Time when Buyback round starts
417      * @param _rate Rate of current Buyback round (1 ETH = rate BOB). Zero means no buyback is planned.
418      */
419     function startBuyback(uint256 _roundStartTime, uint256 _rate) onlyOwner external payable {
420         require(_roundStartTime > now);
421         roundStartTime = _roundStartTime;
422         rate = _rate;   //Rate is not required to be > 0
423     }
424 
425     /**
426      * @notice Claim all BOB tokens stored on the contract and send them to owner
427      */
428     function claimTokens() onlyOwner external {
429         require(token.transfer(owner, token.balanceOf(address(this))));
430     }
431     /**
432      * @notice Claim some of tokens stored on the contract
433      * @param amount How much tokens to claim
434      * @param beneficiary Who to send this tokens
435      */
436     function claimTokens(uint256 amount, address beneficiary) onlyOwner external {
437         require(token.transfer(beneficiary, amount));
438     }
439 
440     /**
441     * @notice Transfer all Ether held by the contract to the owner.
442     */
443     function reclaimEther()  onlyOwner external {
444         owner.transfer(address(this).balance);
445     }
446 
447 }