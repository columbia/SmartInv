1 pragma solidity ^0.5.0;
2 
3 /// @title DividendToken Contract
4 
5 
6 /**
7  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
8  * the optional functions; to access them see `ERC20Detailed`.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a `Transfer` event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through `transferFrom`. This is
33      * zero by default.
34      *
35      * This value changes when `approve` or `transferFrom` are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * > Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an `Approval` event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a `Transfer` event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to `approve`. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 /**
82  * @dev Contract module which provides a basic access control mechanism, where
83  * there is an account (an owner) that can be granted exclusive access to
84  * specific functions.
85  *
86  * This module is used through inheritance. It will make available the modifier
87  * `onlyOwner`, which can be aplied to your functions to restrict their use to
88  * the owner.
89  */
90 contract Ownable {
91     address private _owner;
92 
93     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
94 
95     /**
96      * @dev Initializes the contract setting the deployer as the initial owner.
97      */
98     constructor () internal {
99         _owner = msg.sender;
100         emit OwnershipTransferred(address(0), _owner);
101     }
102 
103     /**
104      * @dev Returns the address of the current owner.
105      */
106     function owner() public view returns (address) {
107         return _owner;
108     }
109 
110     /**
111      * @dev Throws if called by any account other than the owner.
112      */
113     modifier onlyOwner() {
114         require(isOwner(), "Ownable: caller is not the owner");
115         _;
116     }
117 
118     /**
119      * @dev Returns true if the caller is the current owner.
120      */
121     function isOwner() public view returns (bool) {
122         return msg.sender == _owner;
123     }
124 
125     /**
126      * @dev Leaves the contract without owner. It will not be possible to call
127      * `onlyOwner` functions anymore. Can only be called by the current owner.
128      *
129      * > Note: Renouncing ownership will leave the contract without an owner,
130      * thereby removing any functionality that is only available to the owner.
131      */
132     function renounceOwnership() public onlyOwner {
133         emit OwnershipTransferred(_owner, address(0));
134         _owner = address(0);
135     }
136 
137     /**
138      * @dev Transfers ownership of the contract to a new account (`newOwner`).
139      * Can only be called by the current owner.
140      */
141     function transferOwnership(address newOwner) public onlyOwner {
142         _transferOwnership(newOwner);
143     }
144 
145     /**
146      * @dev Transfers ownership of the contract to a new account (`newOwner`).
147      */
148     function _transferOwnership(address newOwner) internal {
149         require(newOwner != address(0), "Ownable: new owner is the zero address");
150         emit OwnershipTransferred(_owner, newOwner);
151         _owner = newOwner;
152     }
153 }
154 
155 
156 /**
157  * @title Contracts that should be able to recover tokens
158  * @author SylTi
159  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
160  * This will prevent any accidental loss of tokens.
161  */
162 contract CanReclaimToken is Ownable {
163 
164   /**
165    * @dev Reclaim all ERC20 compatible tokens
166    * @param token ERC20 The address of the token contract
167    */
168   function reclaimToken(IERC20 token) external onlyOwner {
169     address payable owner = address(uint160(owner()));
170 
171     if (address(token) == address(0)) {
172       owner.transfer(address(this).balance);
173       return;
174     }
175     uint256 balance = token.balanceOf(address(this));
176     token.transfer(owner, balance);
177   }
178 
179 }
180 
181 
182 /// @dev The actual token contract, the default owner is the msg.sender
183 contract DividendToken is IERC20, CanReclaimToken {
184 
185     string public name;                //The Token's name: e.g. DigixDAO Tokens
186     uint8 public decimals;             //Number of decimals of the smallest unit
187     string public symbol;              //An identifier: e.g. REP
188 
189     /// @dev `Checkpoint` is the structure that attaches a block number to a
190     ///  given value, the block number attached is the one that last changed the
191     ///  value
192     struct  Checkpoint {
193 
194         // `fromBlock` is the block number that the value was generated from
195         uint128 fromBlock;
196 
197         // `value` is the amount of tokens at a specific block number
198         uint128 value;
199     }
200 
201     // `parentToken` is the Token address that was cloned to produce this token;
202     //  it will be 0x0 for a token that was not cloned
203     DividendToken public parentToken;
204 
205     // `parentSnapShotBlock` is the block number from the Parent Token that was
206     //  used to determine the initial distribution of the Clone Token
207     uint public parentSnapShotBlock;
208 
209     // `creationBlock` is the block number that the Clone Token was created
210     uint public creationBlock;
211 
212     // `balances` is the map that tracks the balance of each address, in this
213     //  contract when the balance changes the block number that the change
214     //  occurred is also included in the map
215     mapping (address => Checkpoint[]) balances;
216 
217     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
218     mapping (address => mapping (address => uint256)) allowed;
219 
220     // Tracks the history of the `totalSupply` of the token
221     Checkpoint[] totalSupplyHistory;
222 
223 
224     ////////////////
225     // Constructor
226     ////////////////
227 
228     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
229     ///  new token
230     /// @param _parentSnapShotBlock Block of the parent token that will
231     ///  determine the initial distribution of the clone token, set to 0 if it
232     ///  is a new token
233     constructor (address _parentToken, uint _parentSnapShotBlock) public {
234         name = "Holddapp Dividend Token";
235         symbol = "HDT";
236         decimals = 6;
237         parentToken = DividendToken(_parentToken);
238         parentSnapShotBlock = _parentSnapShotBlock == 0 ? block.number : _parentSnapShotBlock;
239         creationBlock = block.number;
240 
241         //initial emission
242         uint _amount = 380000 * (10 ** uint256(decimals));
243         updateValueAtNow(totalSupplyHistory, _amount);
244         updateValueAtNow(balances[msg.sender], _amount);
245         emit Transfer(address(0), msg.sender, _amount);
246     }
247 
248     /// @notice The fallback function
249     function () external {}
250 
251 
252     ///////////////////
253     // ERC20 Methods
254     ///////////////////
255 
256     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
257     /// @param _to The address of the recipient
258     /// @param _amount The amount of tokens to be transferred
259     /// @return Whether the transfer was successful or not
260     function transfer(address _to, uint256 _amount) external returns (bool success) {
261         doTransfer(msg.sender, _to, _amount);
262         return true;
263     }
264 
265     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
266     ///  is approved by `_from`
267     /// @param _from The address holding the tokens being transferred
268     /// @param _to The address of the recipient
269     /// @param _amount The amount of tokens to be transferred
270     /// @return True if the transfer was successful
271     function transferFrom(address _from, address _to, uint256 _amount) external returns (bool success) {
272         // The standard ERC 20 transferFrom functionality
273         require(allowed[_from][msg.sender] >= _amount);
274         allowed[_from][msg.sender] -= _amount;
275         doTransfer(_from, _to, _amount);
276         return true;
277     }
278 
279     /// @dev This is the actual transfer function in the token contract, it can
280     ///  only be called by other functions in this contract.
281     /// @param _from The address holding the tokens being transferred
282     /// @param _to The address of the recipient
283     /// @param _amount The amount of tokens to be transferred
284     /// @return True if the transfer was successful
285     function doTransfer(address _from, address _to, uint _amount) internal {
286 
287         if (_amount == 0) {
288             emit Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
289             return;
290         }
291 
292         require(parentSnapShotBlock < block.number);
293 
294         // Do not allow transfer to 0x0 or the token contract itself
295         require((_to != address(0)) && (_to != address(this)));
296 
297         // If the amount being transfered is more than the balance of the
298         //  account the transfer throws
299         uint previousBalanceFrom = balanceOfAt(_from, block.number);
300 
301         require(previousBalanceFrom >= _amount);
302 
303         // First update the balance array with the new value for the address
304         //  sending the tokens
305         updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
306 
307         // Then update the balance array with the new value for the address
308         //  receiving the tokens
309         uint previousBalanceTo = balanceOfAt(_to, block.number);
310         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
311         updateValueAtNow(balances[_to], previousBalanceTo + _amount);
312 
313         // An event to make the transfer easy to find on the blockchain
314         emit Transfer(_from, _to, _amount);
315 
316     }
317 
318     /// @param _owner The address that's balance is being requested
319     /// @return The balance of `_owner` at the current block
320     function balanceOf(address _owner) public view returns (uint256 balance) {
321         return balanceOfAt(_owner, block.number);
322     }
323 
324     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
325     ///  its behalf. This is a modified version of the ERC20 approve function
326     ///  to be a little bit safer
327     /// @param _spender The address of the account able to transfer the tokens
328     /// @param _amount The amount of tokens to be approved for transfer
329     /// @return True if the approval was successful
330     function approve(address _spender, uint256 _amount) public returns (bool success) {
331         // To change the approve amount you first have to reduce the addresses`
332         //  allowance to zero by calling `approve(_spender,0)` if it is not
333         //  already 0 to mitigate the race condition described here:
334         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
335         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
336 
337         allowed[msg.sender][_spender] = _amount;
338         emit Approval(msg.sender, _spender, _amount);
339         return true;
340     }
341 
342     /**
343      * @dev Increase the amount of tokens that an owner allowed to a spender.
344      *
345      * approve should be called when allowance[_spender] == 0. To increment
346      * allowed value is better to use this function to avoid 2 calls (and wait until
347      * the first transaction is mined)
348      * From MonolithDAO Token.sol
349      * @param _spender The address which will spend the funds.
350      * @param _addedAmount The amount of tokens to increase the allowance by.
351      */
352     function increaseApproval(address _spender, uint _addedAmount) external returns (bool) {
353         require(allowed[msg.sender][_spender] + _addedAmount >= allowed[msg.sender][_spender]); // Check for overflow
354         allowed[msg.sender][_spender] = allowed[msg.sender][_spender] + _addedAmount;
355         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
356         return true;
357     }
358 
359     /**
360      * @dev Decrease the amount of tokens that an owner allowed to a spender.
361      *
362      * approve should be called when allowance[_spender] == 0. To decrement
363      * allowed value is better to use this function to avoid 2 calls (and wait until
364      * the first transaction is mined)
365      * From MonolithDAO Token.sol
366      * @param _spender The address which will spend the funds.
367      * @param _subtractedAmount The amount of tokens to decrease the allowance by.
368      */
369     function decreaseApproval(address _spender, uint _subtractedAmount) external returns (bool)
370     {
371         uint oldValue = allowed[msg.sender][_spender];
372         if (_subtractedAmount >= oldValue) {
373             allowed[msg.sender][_spender] = 0;
374         } else {
375             allowed[msg.sender][_spender] = oldValue - _subtractedAmount;
376         }
377         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
378         return true;
379     }
380 
381 
382     /// @dev This function makes it easy to read the `allowed[]` map
383     /// @param _owner The address of the account that owns the token
384     /// @param _spender The address of the account able to transfer the tokens
385     /// @return Amount of remaining tokens of _owner that _spender is allowed
386     ///  to spend
387     function allowance(address _owner, address _spender) external view returns (uint256 remaining) {
388         return allowed[_owner][_spender];
389     }
390 
391 
392     /// @dev This function makes it easy to get the total number of tokens
393     /// @return The total number of tokens
394     function totalSupply() public view returns (uint) {
395         return totalSupplyAt(block.number);
396     }
397 
398 
399     ////////////////
400     // Query balance and totalSupply in History
401     ////////////////
402 
403     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
404     /// @param _owner The address from which the balance will be retrieved
405     /// @param _blockNumber The block number when the balance is queried
406     /// @return The balance at `_blockNumber`
407     function balanceOfAt(address _owner, uint _blockNumber) public view returns (uint) {
408 
409         // These next few lines are used when the balance of the token is
410         //  requested before a check point was ever created for this token, it
411         //  requires that the `parentToken.balanceOfAt` be queried at the
412         //  genesis block for that token as this contains initial balance of
413         //  this token
414         if ((balances[_owner].length == 0)
415             || (balances[_owner][0].fromBlock > _blockNumber)) {
416             if (address(parentToken) != address(0)) {
417                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
418             } else {
419                 // Has no parent
420                 return 0;
421             }
422 
423             // This will return the expected balance during normal situations
424         } else {
425             return getValueAt(balances[_owner], _blockNumber);
426         }
427     }
428 
429     /// @notice Total amount of tokens at a specific `_blockNumber`.
430     /// @param _blockNumber The block number when the totalSupply is queried
431     /// @return The total amount of tokens at `_blockNumber`
432     function totalSupplyAt(uint _blockNumber) public view returns(uint) {
433 
434         // These next few lines are used when the totalSupply of the token is
435         //  requested before a check point was ever created for this token, it
436         //  requires that the `parentToken.totalSupplyAt` be queried at the
437         //  genesis block for this token as that contains totalSupply of this
438         //  token at this block number.
439         if ((totalSupplyHistory.length == 0)
440             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
441             if (address(parentToken) != address(0)) {
442                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
443             } else {
444                 return 0;
445             }
446 
447             // This will return the expected totalSupply during normal situations
448         } else {
449             return getValueAt(totalSupplyHistory, _blockNumber);
450         }
451     }
452 
453 
454    
455 
456     ////////////////
457     // Internal helper functions to query and set a value in a snapshot array
458     ////////////////
459 
460     /// @dev `getValueAt` retrieves the number of tokens at a given block number
461     /// @param checkpoints The history of values being queried
462     /// @param _block The block number to retrieve the value at
463     /// @return The number of tokens being queried
464     function getValueAt(Checkpoint[] storage checkpoints, uint _block) view internal returns (uint) {
465         if (checkpoints.length == 0) return 0;
466 
467         // Shortcut for the actual value
468         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
469             return checkpoints[checkpoints.length-1].value;
470         if (_block < checkpoints[0].fromBlock) return 0;
471 
472         // Binary search of the value in the array
473         uint min = 0;
474         uint max = checkpoints.length-1;
475         while (max > min) {
476             uint mid = (max + min + 1)/ 2;
477             if (checkpoints[mid].fromBlock<=_block) {
478                 min = mid;
479             } else {
480                 max = mid-1;
481             }
482         }
483         return checkpoints[min].value;
484     }
485 
486     /// @dev `updateValueAtNow` used to update the `balances` map and the
487     ///  `totalSupplyHistory`
488     /// @param checkpoints The history of data being updated
489     /// @param _value The new number of tokens
490     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value) internal  {
491         if ((checkpoints.length == 0)
492             || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
493             Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
494             newCheckPoint.fromBlock =  uint128(block.number);
495             newCheckPoint.value = uint128(_value);
496         } else {
497             Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
498             oldCheckPoint.value = uint128(_value);
499         }
500     }
501 
502 
503     /// @dev Helper function to return a min betwen the two uints
504     function min(uint a, uint b) pure internal returns (uint) {
505         return a < b ? a : b;
506     }
507 
508 
509 }