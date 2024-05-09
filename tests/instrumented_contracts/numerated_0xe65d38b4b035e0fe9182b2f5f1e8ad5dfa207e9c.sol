1 pragma solidity ^0.4.24;
2 
3 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10   function totalSupply() external view returns (uint256);
11 
12   function balanceOf(address who) external view returns (uint256);
13 
14   function allowance(address owner, address spender)
15     external view returns (uint256);
16 
17   function transfer(address to, uint256 value) external returns (bool);
18 
19   function approve(address spender, uint256 value)
20     external returns (bool);
21 
22   function transferFrom(address from, address to, uint256 value)
23     external returns (bool);
24 
25   event Transfer(
26     address indexed from,
27     address indexed to,
28     uint256 value
29   );
30 
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 // File: node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol
39 
40 /**
41  * @title Ownable
42  * @dev The Ownable contract has an owner address, and provides basic authorization control
43  * functions, this simplifies the implementation of "user permissions".
44  */
45 contract Ownable {
46   address private _owner;
47 
48   event OwnershipTransferred(
49     address indexed previousOwner,
50     address indexed newOwner
51   );
52 
53   /**
54    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
55    * account.
56    */
57   constructor() internal {
58     _owner = msg.sender;
59     emit OwnershipTransferred(address(0), _owner);
60   }
61 
62   /**
63    * @return the address of the owner.
64    */
65   function owner() public view returns(address) {
66     return _owner;
67   }
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(isOwner());
74     _;
75   }
76 
77   /**
78    * @return true if `msg.sender` is the owner of the contract.
79    */
80   function isOwner() public view returns(bool) {
81     return msg.sender == _owner;
82   }
83 
84   /**
85    * @dev Allows the current owner to relinquish control of the contract.
86    * @notice Renouncing to ownership will leave the contract without an owner.
87    * It will not be possible to call the functions with the `onlyOwner`
88    * modifier anymore.
89    */
90   function renounceOwnership() public onlyOwner {
91     emit OwnershipTransferred(_owner, address(0));
92     _owner = address(0);
93   }
94 
95   /**
96    * @dev Allows the current owner to transfer control of the contract to a newOwner.
97    * @param newOwner The address to transfer ownership to.
98    */
99   function transferOwnership(address newOwner) public onlyOwner {
100     _transferOwnership(newOwner);
101   }
102 
103   /**
104    * @dev Transfers control of the contract to a newOwner.
105    * @param newOwner The address to transfer ownership to.
106    */
107   function _transferOwnership(address newOwner) internal {
108     require(newOwner != address(0));
109     emit OwnershipTransferred(_owner, newOwner);
110     _owner = newOwner;
111   }
112 }
113 
114 // File: lib/CanReclaimToken.sol
115 
116 /**
117  * @title Contracts that should be able to recover tokens
118  * @author SylTi
119  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
120  * This will prevent any accidental loss of tokens.
121  */
122 contract CanReclaimToken is Ownable {
123 
124   /**
125    * @dev Reclaim all ERC20 compatible tokens
126    * @param token ERC20 The address of the token contract
127    */
128   function reclaimToken(IERC20 token) external onlyOwner {
129     if (address(token) == address(0)) {
130       owner().transfer(address(this).balance);
131       return;
132     }
133     uint256 balance = token.balanceOf(this);
134     token.transfer(owner(), balance);
135   }
136 
137 }
138 
139 // File: contracts/CHDT.sol
140 
141 /// @title DividendToken Contract
142 /// @dev It is ERC20 compliant, but still needs to under go further testing.
143 
144 
145 
146 /// @dev The actual token contract, the default owner is the msg.sender
147 contract DividendToken is IERC20, CanReclaimToken {
148 
149     string public name;                //The Token's name: e.g. DigixDAO Tokens
150     uint8 public decimals;             //Number of decimals of the smallest unit
151     string public symbol;              //An identifier: e.g. REP
152 
153     /// @dev `Checkpoint` is the structure that attaches a block number to a
154     ///  given value, the block number attached is the one that last changed the
155     ///  value
156     struct  Checkpoint {
157 
158         // `fromBlock` is the block number that the value was generated from
159         uint128 fromBlock;
160 
161         // `value` is the amount of tokens at a specific block number
162         uint128 value;
163     }
164 
165     // `parentToken` is the Token address that was cloned to produce this token;
166     //  it will be 0x0 for a token that was not cloned
167     DividendToken public parentToken;
168 
169     // `parentSnapShotBlock` is the block number from the Parent Token that was
170     //  used to determine the initial distribution of the Clone Token
171     uint public parentSnapShotBlock;
172 
173     // `creationBlock` is the block number that the Clone Token was created
174     uint public creationBlock;
175 
176     // `balances` is the map that tracks the balance of each address, in this
177     //  contract when the balance changes the block number that the change
178     //  occurred is also included in the map
179     mapping (address => Checkpoint[]) balances;
180 
181     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
182     mapping (address => mapping (address => uint256)) allowed;
183 
184     // Tracks the history of the `totalSupply` of the token
185     Checkpoint[] totalSupplyHistory;
186 
187 
188     ////////////////
189     // Constructor
190     ////////////////
191 
192     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
193     ///  new token
194     /// @param _parentSnapShotBlock Block of the parent token that will
195     ///  determine the initial distribution of the clone token, set to 0 if it
196     ///  is a new token
197     constructor (address _parentToken, uint _parentSnapShotBlock) public {
198         name = "CH Dividend Token";
199         symbol = "CHDT";
200         decimals = 18;
201         parentToken = DividendToken(_parentToken);
202         parentSnapShotBlock = _parentSnapShotBlock == 0 ? block.number : _parentSnapShotBlock;
203         creationBlock = block.number;
204 
205         //initial emission
206         uint _amount = 7000000 * (10 ** uint256(decimals));
207         updateValueAtNow(totalSupplyHistory, _amount);
208         updateValueAtNow(balances[msg.sender], _amount);
209         emit Transfer(0, msg.sender, _amount);
210     }
211 
212     /// @notice The fallback function
213     function () public {}
214 
215 
216     ///////////////////
217     // ERC20 Methods
218     ///////////////////
219 
220     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
221     /// @param _to The address of the recipient
222     /// @param _amount The amount of tokens to be transferred
223     /// @return Whether the transfer was successful or not
224     function transfer(address _to, uint256 _amount) external returns (bool success) {
225         doTransfer(msg.sender, _to, _amount);
226         return true;
227     }
228 
229     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
230     ///  is approved by `_from`
231     /// @param _from The address holding the tokens being transferred
232     /// @param _to The address of the recipient
233     /// @param _amount The amount of tokens to be transferred
234     /// @return True if the transfer was successful
235     function transferFrom(address _from, address _to, uint256 _amount) external returns (bool success) {
236         // The standard ERC 20 transferFrom functionality
237         require(allowed[_from][msg.sender] >= _amount);
238         allowed[_from][msg.sender] -= _amount;
239         doTransfer(_from, _to, _amount);
240         return true;
241     }
242 
243     /// @dev This is the actual transfer function in the token contract, it can
244     ///  only be called by other functions in this contract.
245     /// @param _from The address holding the tokens being transferred
246     /// @param _to The address of the recipient
247     /// @param _amount The amount of tokens to be transferred
248     /// @return True if the transfer was successful
249     function doTransfer(address _from, address _to, uint _amount) internal {
250 
251         if (_amount == 0) {
252             emit Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
253             return;
254         }
255 
256         require(parentSnapShotBlock < block.number);
257 
258         // Do not allow transfer to 0x0 or the token contract itself
259         require((_to != 0) && (_to != address(this)));
260 
261         // If the amount being transfered is more than the balance of the
262         //  account the transfer throws
263         uint previousBalanceFrom = balanceOfAt(_from, block.number);
264 
265         require(previousBalanceFrom >= _amount);
266 
267         // First update the balance array with the new value for the address
268         //  sending the tokens
269         updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
270 
271         // Then update the balance array with the new value for the address
272         //  receiving the tokens
273         uint previousBalanceTo = balanceOfAt(_to, block.number);
274         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
275         updateValueAtNow(balances[_to], previousBalanceTo + _amount);
276 
277         // An event to make the transfer easy to find on the blockchain
278         emit Transfer(_from, _to, _amount);
279 
280     }
281 
282     /// @param _owner The address that's balance is being requested
283     /// @return The balance of `_owner` at the current block
284     function balanceOf(address _owner) public view returns (uint256 balance) {
285         return balanceOfAt(_owner, block.number);
286     }
287 
288     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
289     ///  its behalf. This is a modified version of the ERC20 approve function
290     ///  to be a little bit safer
291     /// @param _spender The address of the account able to transfer the tokens
292     /// @param _amount The amount of tokens to be approved for transfer
293     /// @return True if the approval was successful
294     function approve(address _spender, uint256 _amount) public returns (bool success) {
295         // To change the approve amount you first have to reduce the addresses`
296         //  allowance to zero by calling `approve(_spender,0)` if it is not
297         //  already 0 to mitigate the race condition described here:
298         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
299         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
300 
301         allowed[msg.sender][_spender] = _amount;
302         emit Approval(msg.sender, _spender, _amount);
303         return true;
304     }
305 
306     /**
307      * @dev Increase the amount of tokens that an owner allowed to a spender.
308      *
309      * approve should be called when allowance[_spender] == 0. To increment
310      * allowed value is better to use this function to avoid 2 calls (and wait until
311      * the first transaction is mined)
312      * From MonolithDAO Token.sol
313      * @param _spender The address which will spend the funds.
314      * @param _addedAmount The amount of tokens to increase the allowance by.
315      */
316     function increaseApproval(address _spender, uint _addedAmount) external returns (bool) {
317         require(allowed[msg.sender][_spender] + _addedAmount >= allowed[msg.sender][_spender]); // Check for overflow
318         allowed[msg.sender][_spender] = allowed[msg.sender][_spender] + _addedAmount;
319         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
320         return true;
321     }
322 
323     /**
324      * @dev Decrease the amount of tokens that an owner allowed to a spender.
325      *
326      * approve should be called when allowance[_spender] == 0. To decrement
327      * allowed value is better to use this function to avoid 2 calls (and wait until
328      * the first transaction is mined)
329      * From MonolithDAO Token.sol
330      * @param _spender The address which will spend the funds.
331      * @param _subtractedAmount The amount of tokens to decrease the allowance by.
332      */
333     function decreaseApproval(address _spender, uint _subtractedAmount) external returns (bool)
334     {
335         uint oldValue = allowed[msg.sender][_spender];
336         if (_subtractedAmount >= oldValue) {
337             allowed[msg.sender][_spender] = 0;
338         } else {
339             allowed[msg.sender][_spender] = oldValue - _subtractedAmount;
340         }
341         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
342         return true;
343     }
344 
345 
346     /// @dev This function makes it easy to read the `allowed[]` map
347     /// @param _owner The address of the account that owns the token
348     /// @param _spender The address of the account able to transfer the tokens
349     /// @return Amount of remaining tokens of _owner that _spender is allowed
350     ///  to spend
351     function allowance(address _owner, address _spender) external view returns (uint256 remaining) {
352         return allowed[_owner][_spender];
353     }
354 
355 
356     /// @dev This function makes it easy to get the total number of tokens
357     /// @return The total number of tokens
358     function totalSupply() public view returns (uint) {
359         return totalSupplyAt(block.number);
360     }
361 
362 
363     ////////////////
364     // Query balance and totalSupply in History
365     ////////////////
366 
367     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
368     /// @param _owner The address from which the balance will be retrieved
369     /// @param _blockNumber The block number when the balance is queried
370     /// @return The balance at `_blockNumber`
371     function balanceOfAt(address _owner, uint _blockNumber) public view returns (uint) {
372 
373         // These next few lines are used when the balance of the token is
374         //  requested before a check point was ever created for this token, it
375         //  requires that the `parentToken.balanceOfAt` be queried at the
376         //  genesis block for that token as this contains initial balance of
377         //  this token
378         if ((balances[_owner].length == 0)
379             || (balances[_owner][0].fromBlock > _blockNumber)) {
380             if (address(parentToken) != 0) {
381                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
382             } else {
383                 // Has no parent
384                 return 0;
385             }
386 
387             // This will return the expected balance during normal situations
388         } else {
389             return getValueAt(balances[_owner], _blockNumber);
390         }
391     }
392 
393     /// @notice Total amount of tokens at a specific `_blockNumber`.
394     /// @param _blockNumber The block number when the totalSupply is queried
395     /// @return The total amount of tokens at `_blockNumber`
396     function totalSupplyAt(uint _blockNumber) public view returns(uint) {
397 
398         // These next few lines are used when the totalSupply of the token is
399         //  requested before a check point was ever created for this token, it
400         //  requires that the `parentToken.totalSupplyAt` be queried at the
401         //  genesis block for this token as that contains totalSupply of this
402         //  token at this block number.
403         if ((totalSupplyHistory.length == 0)
404             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
405             if (address(parentToken) != 0) {
406                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
407             } else {
408                 return 0;
409             }
410 
411             // This will return the expected totalSupply during normal situations
412         } else {
413             return getValueAt(totalSupplyHistory, _blockNumber);
414         }
415     }
416 
417 
418     ////////////////
419     // Mint and burn tokens
420     ////////////////
421 
422     /// @notice Mints `_amount` tokens that are assigned to `_owner`
423     /// @param _owner The address that will be assigned the new tokens
424     /// @param _amount The quantity of tokens generated
425     /// @return True if the tokens are generated correctly
426     function mint(address _owner, uint _amount) external onlyOwner returns (bool) {
427         uint curTotalSupply = totalSupply();
428         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
429         uint previousBalanceTo = balanceOf(_owner);
430         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
431         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
432         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
433         emit Transfer(0, _owner, _amount);
434         return true;
435     }
436 
437 
438     /// @notice Burns `_amount` tokens from `_owner`
439     /// @param _owner The address that will lose the tokens
440     /// @param _amount The quantity of tokens to burn
441     /// @return True if the tokens are burned correctly
442     function burn(address _owner, uint _amount) external onlyOwner returns (bool) {
443         uint curTotalSupply = totalSupply();
444         require(curTotalSupply >= _amount);
445         uint previousBalanceFrom = balanceOf(_owner);
446         require(previousBalanceFrom >= _amount);
447         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
448         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
449         emit Transfer(_owner, 0, _amount);
450         return true;
451     }
452 
453 
454     ////////////////
455     // Internal helper functions to query and set a value in a snapshot array
456     ////////////////
457 
458     /// @dev `getValueAt` retrieves the number of tokens at a given block number
459     /// @param checkpoints The history of values being queried
460     /// @param _block The block number to retrieve the value at
461     /// @return The number of tokens being queried
462     function getValueAt(Checkpoint[] storage checkpoints, uint _block) view internal returns (uint) {
463         if (checkpoints.length == 0) return 0;
464 
465         // Shortcut for the actual value
466         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
467             return checkpoints[checkpoints.length-1].value;
468         if (_block < checkpoints[0].fromBlock) return 0;
469 
470         // Binary search of the value in the array
471         uint min = 0;
472         uint max = checkpoints.length-1;
473         while (max > min) {
474             uint mid = (max + min + 1)/ 2;
475             if (checkpoints[mid].fromBlock<=_block) {
476                 min = mid;
477             } else {
478                 max = mid-1;
479             }
480         }
481         return checkpoints[min].value;
482     }
483 
484     /// @dev `updateValueAtNow` used to update the `balances` map and the
485     ///  `totalSupplyHistory`
486     /// @param checkpoints The history of data being updated
487     /// @param _value The new number of tokens
488     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value) internal  {
489         if ((checkpoints.length == 0)
490             || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
491             Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
492             newCheckPoint.fromBlock =  uint128(block.number);
493             newCheckPoint.value = uint128(_value);
494         } else {
495             Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
496             oldCheckPoint.value = uint128(_value);
497         }
498     }
499 
500 
501     /// @dev Helper function to return a min betwen the two uints
502     function min(uint a, uint b) pure internal returns (uint) {
503         return a < b ? a : b;
504     }
505 
506 
507 }