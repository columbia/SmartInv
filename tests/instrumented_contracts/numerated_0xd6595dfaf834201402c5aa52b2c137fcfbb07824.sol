1 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address who) external view returns (uint256);
19 
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
28 
29 pragma solidity ^0.5.0;
30 
31 /**
32  * @title Ownable
33  * @dev The Ownable contract has an owner address, and provides basic authorization control
34  * functions, this simplifies the implementation of "user permissions".
35  */
36 contract Ownable {
37     address private _owner;
38 
39     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40 
41     /**
42      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
43      * account.
44      */
45     constructor () internal {
46         _owner = msg.sender;
47         emit OwnershipTransferred(address(0), _owner);
48     }
49 
50     /**
51      * @return the address of the owner.
52      */
53     function owner() public view returns (address) {
54         return _owner;
55     }
56 
57     /**
58      * @dev Throws if called by any account other than the owner.
59      */
60     modifier onlyOwner() {
61         require(isOwner());
62         _;
63     }
64 
65     /**
66      * @return true if `msg.sender` is the owner of the contract.
67      */
68     function isOwner() public view returns (bool) {
69         return msg.sender == _owner;
70     }
71 
72     /**
73      * @dev Allows the current owner to relinquish control of the contract.
74      * @notice Renouncing to ownership will leave the contract without an owner.
75      * It will not be possible to call the functions with the `onlyOwner`
76      * modifier anymore.
77      */
78     function renounceOwnership() public onlyOwner {
79         emit OwnershipTransferred(_owner, address(0));
80         _owner = address(0);
81     }
82 
83     /**
84      * @dev Allows the current owner to transfer control of the contract to a newOwner.
85      * @param newOwner The address to transfer ownership to.
86      */
87     function transferOwnership(address newOwner) public onlyOwner {
88         _transferOwnership(newOwner);
89     }
90 
91     /**
92      * @dev Transfers control of the contract to a newOwner.
93      * @param newOwner The address to transfer ownership to.
94      */
95     function _transferOwnership(address newOwner) internal {
96         require(newOwner != address(0));
97         emit OwnershipTransferred(_owner, newOwner);
98         _owner = newOwner;
99     }
100 }
101 
102 // File: lib/CanReclaimToken.sol
103 
104 pragma solidity ^0.5.0;
105 
106 
107 
108 /**
109  * @title Contracts that should be able to recover tokens
110  * @author SylTi
111  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
112  * This will prevent any accidental loss of tokens.
113  */
114 contract CanReclaimToken is Ownable {
115 
116   /**
117    * @dev Reclaim all ERC20 compatible tokens
118    * @param token ERC20 The address of the token contract
119    */
120   function reclaimToken(IERC20 token) external onlyOwner {
121     address payable owner = address(uint160(owner()));
122 
123     if (address(token) == address(0)) {
124       owner.transfer(address(this).balance);
125       return;
126     }
127     uint256 balance = token.balanceOf(address(this));
128     token.transfer(owner, balance);
129   }
130 
131 }
132 
133 // File: contracts/CHDT_TRON.sol
134 
135 pragma solidity ^0.5.0;
136 
137 /// @title DividendToken Contract
138 /// @dev It is ERC20 compliant, but still needs to under go further testing.
139 
140 
141 
142 /// @dev The actual token contract, the default owner is the msg.sender
143 contract DividendToken is IERC20, CanReclaimToken {
144 
145     string public name;                //The Token's name: e.g. DigixDAO Tokens
146     uint8 public decimals;             //Number of decimals of the smallest unit
147     string public symbol;              //An identifier: e.g. REP
148 
149     /// @dev `Checkpoint` is the structure that attaches a block number to a
150     ///  given value, the block number attached is the one that last changed the
151     ///  value
152     struct  Checkpoint {
153 
154         // `fromBlock` is the block number that the value was generated from
155         uint128 fromBlock;
156 
157         // `value` is the amount of tokens at a specific block number
158         uint128 value;
159     }
160 
161     // `parentToken` is the Token address that was cloned to produce this token;
162     //  it will be 0x0 for a token that was not cloned
163     DividendToken public parentToken;
164 
165     // `parentSnapShotBlock` is the block number from the Parent Token that was
166     //  used to determine the initial distribution of the Clone Token
167     uint public parentSnapShotBlock;
168 
169     // `creationBlock` is the block number that the Clone Token was created
170     uint public creationBlock;
171 
172     // `balances` is the map that tracks the balance of each address, in this
173     //  contract when the balance changes the block number that the change
174     //  occurred is also included in the map
175     mapping (address => Checkpoint[]) balances;
176 
177     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
178     mapping (address => mapping (address => uint256)) allowed;
179 
180     // Tracks the history of the `totalSupply` of the token
181     Checkpoint[] totalSupplyHistory;
182 
183 
184     ////////////////
185     // Constructor
186     ////////////////
187 
188     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
189     ///  new token
190     /// @param _parentSnapShotBlock Block of the parent token that will
191     ///  determine the initial distribution of the clone token, set to 0 if it
192     ///  is a new token
193     constructor (address _parentToken, uint _parentSnapShotBlock) public {
194         name = "CH Dividend Token TRON";
195         symbol = "CHDT TRON";
196         decimals = 18;
197         parentToken = DividendToken(_parentToken);
198         parentSnapShotBlock = _parentSnapShotBlock == 0 ? block.number : _parentSnapShotBlock;
199         creationBlock = block.number;
200 
201         //initial emission
202         uint _amount = 7000000 * (10 ** uint256(decimals));
203         updateValueAtNow(totalSupplyHistory, _amount);
204         updateValueAtNow(balances[msg.sender], _amount);
205         emit Transfer(address(0), msg.sender, _amount);
206     }
207 
208     /// @notice The fallback function
209     function () external {}
210 
211 
212     ///////////////////
213     // ERC20 Methods
214     ///////////////////
215 
216     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
217     /// @param _to The address of the recipient
218     /// @param _amount The amount of tokens to be transferred
219     /// @return Whether the transfer was successful or not
220     function transfer(address _to, uint256 _amount) external returns (bool success) {
221         doTransfer(msg.sender, _to, _amount);
222         return true;
223     }
224 
225     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
226     ///  is approved by `_from`
227     /// @param _from The address holding the tokens being transferred
228     /// @param _to The address of the recipient
229     /// @param _amount The amount of tokens to be transferred
230     /// @return True if the transfer was successful
231     function transferFrom(address _from, address _to, uint256 _amount) external returns (bool success) {
232         // The standard ERC 20 transferFrom functionality
233         require(allowed[_from][msg.sender] >= _amount);
234         allowed[_from][msg.sender] -= _amount;
235         doTransfer(_from, _to, _amount);
236         return true;
237     }
238 
239     /// @dev This is the actual transfer function in the token contract, it can
240     ///  only be called by other functions in this contract.
241     /// @param _from The address holding the tokens being transferred
242     /// @param _to The address of the recipient
243     /// @param _amount The amount of tokens to be transferred
244     /// @return True if the transfer was successful
245     function doTransfer(address _from, address _to, uint _amount) internal {
246 
247         if (_amount == 0) {
248             emit Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
249             return;
250         }
251 
252         require(parentSnapShotBlock < block.number);
253 
254         // Do not allow transfer to 0x0 or the token contract itself
255         require((_to != address(0)) && (_to != address(this)));
256 
257         // If the amount being transfered is more than the balance of the
258         //  account the transfer throws
259         uint previousBalanceFrom = balanceOfAt(_from, block.number);
260 
261         require(previousBalanceFrom >= _amount);
262 
263         // First update the balance array with the new value for the address
264         //  sending the tokens
265         updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
266 
267         // Then update the balance array with the new value for the address
268         //  receiving the tokens
269         uint previousBalanceTo = balanceOfAt(_to, block.number);
270         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
271         updateValueAtNow(balances[_to], previousBalanceTo + _amount);
272 
273         // An event to make the transfer easy to find on the blockchain
274         emit Transfer(_from, _to, _amount);
275 
276     }
277 
278     /// @param _owner The address that's balance is being requested
279     /// @return The balance of `_owner` at the current block
280     function balanceOf(address _owner) public view returns (uint256 balance) {
281         return balanceOfAt(_owner, block.number);
282     }
283 
284     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
285     ///  its behalf. This is a modified version of the ERC20 approve function
286     ///  to be a little bit safer
287     /// @param _spender The address of the account able to transfer the tokens
288     /// @param _amount The amount of tokens to be approved for transfer
289     /// @return True if the approval was successful
290     function approve(address _spender, uint256 _amount) public returns (bool success) {
291         // To change the approve amount you first have to reduce the addresses`
292         //  allowance to zero by calling `approve(_spender,0)` if it is not
293         //  already 0 to mitigate the race condition described here:
294         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
295         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
296 
297         allowed[msg.sender][_spender] = _amount;
298         emit Approval(msg.sender, _spender, _amount);
299         return true;
300     }
301 
302     /**
303      * @dev Increase the amount of tokens that an owner allowed to a spender.
304      *
305      * approve should be called when allowance[_spender] == 0. To increment
306      * allowed value is better to use this function to avoid 2 calls (and wait until
307      * the first transaction is mined)
308      * From MonolithDAO Token.sol
309      * @param _spender The address which will spend the funds.
310      * @param _addedAmount The amount of tokens to increase the allowance by.
311      */
312     function increaseApproval(address _spender, uint _addedAmount) external returns (bool) {
313         require(allowed[msg.sender][_spender] + _addedAmount >= allowed[msg.sender][_spender]); // Check for overflow
314         allowed[msg.sender][_spender] = allowed[msg.sender][_spender] + _addedAmount;
315         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
316         return true;
317     }
318 
319     /**
320      * @dev Decrease the amount of tokens that an owner allowed to a spender.
321      *
322      * approve should be called when allowance[_spender] == 0. To decrement
323      * allowed value is better to use this function to avoid 2 calls (and wait until
324      * the first transaction is mined)
325      * From MonolithDAO Token.sol
326      * @param _spender The address which will spend the funds.
327      * @param _subtractedAmount The amount of tokens to decrease the allowance by.
328      */
329     function decreaseApproval(address _spender, uint _subtractedAmount) external returns (bool)
330     {
331         uint oldValue = allowed[msg.sender][_spender];
332         if (_subtractedAmount >= oldValue) {
333             allowed[msg.sender][_spender] = 0;
334         } else {
335             allowed[msg.sender][_spender] = oldValue - _subtractedAmount;
336         }
337         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
338         return true;
339     }
340 
341 
342     /// @dev This function makes it easy to read the `allowed[]` map
343     /// @param _owner The address of the account that owns the token
344     /// @param _spender The address of the account able to transfer the tokens
345     /// @return Amount of remaining tokens of _owner that _spender is allowed
346     ///  to spend
347     function allowance(address _owner, address _spender) external view returns (uint256 remaining) {
348         return allowed[_owner][_spender];
349     }
350 
351 
352     /// @dev This function makes it easy to get the total number of tokens
353     /// @return The total number of tokens
354     function totalSupply() public view returns (uint) {
355         return totalSupplyAt(block.number);
356     }
357 
358 
359     ////////////////
360     // Query balance and totalSupply in History
361     ////////////////
362 
363     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
364     /// @param _owner The address from which the balance will be retrieved
365     /// @param _blockNumber The block number when the balance is queried
366     /// @return The balance at `_blockNumber`
367     function balanceOfAt(address _owner, uint _blockNumber) public view returns (uint) {
368 
369         // These next few lines are used when the balance of the token is
370         //  requested before a check point was ever created for this token, it
371         //  requires that the `parentToken.balanceOfAt` be queried at the
372         //  genesis block for that token as this contains initial balance of
373         //  this token
374         if ((balances[_owner].length == 0)
375             || (balances[_owner][0].fromBlock > _blockNumber)) {
376             if (address(parentToken) != address(0)) {
377                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
378             } else {
379                 // Has no parent
380                 return 0;
381             }
382 
383             // This will return the expected balance during normal situations
384         } else {
385             return getValueAt(balances[_owner], _blockNumber);
386         }
387     }
388 
389     /// @notice Total amount of tokens at a specific `_blockNumber`.
390     /// @param _blockNumber The block number when the totalSupply is queried
391     /// @return The total amount of tokens at `_blockNumber`
392     function totalSupplyAt(uint _blockNumber) public view returns(uint) {
393 
394         // These next few lines are used when the totalSupply of the token is
395         //  requested before a check point was ever created for this token, it
396         //  requires that the `parentToken.totalSupplyAt` be queried at the
397         //  genesis block for this token as that contains totalSupply of this
398         //  token at this block number.
399         if ((totalSupplyHistory.length == 0)
400             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
401             if (address(parentToken) != address(0)) {
402                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
403             } else {
404                 return 0;
405             }
406 
407             // This will return the expected totalSupply during normal situations
408         } else {
409             return getValueAt(totalSupplyHistory, _blockNumber);
410         }
411     }
412 
413 
414     ////////////////
415     // Mint and burn tokens
416     ////////////////
417 
418     /// @notice Mints `_amount` tokens that are assigned to `_owner`
419     /// @param _owner The address that will be assigned the new tokens
420     /// @param _amount The quantity of tokens generated
421     /// @return True if the tokens are generated correctly
422     function mint(address _owner, uint _amount) external onlyOwner returns (bool) {
423         uint curTotalSupply = totalSupply();
424         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
425         uint previousBalanceTo = balanceOf(_owner);
426         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
427         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
428         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
429         emit Transfer(address(0), _owner, _amount);
430         return true;
431     }
432 
433 
434     /// @notice Burns `_amount` tokens from `_owner`
435     /// @param _owner The address that will lose the tokens
436     /// @param _amount The quantity of tokens to burn
437     /// @return True if the tokens are burned correctly
438     function burn(address _owner, uint _amount) external onlyOwner returns (bool) {
439         uint curTotalSupply = totalSupply();
440         require(curTotalSupply >= _amount);
441         uint previousBalanceFrom = balanceOf(_owner);
442         require(previousBalanceFrom >= _amount);
443         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
444         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
445         emit Transfer(_owner, address(0), _amount);
446         return true;
447     }
448 
449 
450     ////////////////
451     // Internal helper functions to query and set a value in a snapshot array
452     ////////////////
453 
454     /// @dev `getValueAt` retrieves the number of tokens at a given block number
455     /// @param checkpoints The history of values being queried
456     /// @param _block The block number to retrieve the value at
457     /// @return The number of tokens being queried
458     function getValueAt(Checkpoint[] storage checkpoints, uint _block) view internal returns (uint) {
459         if (checkpoints.length == 0) return 0;
460 
461         // Shortcut for the actual value
462         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
463             return checkpoints[checkpoints.length-1].value;
464         if (_block < checkpoints[0].fromBlock) return 0;
465 
466         // Binary search of the value in the array
467         uint min = 0;
468         uint max = checkpoints.length-1;
469         while (max > min) {
470             uint mid = (max + min + 1)/ 2;
471             if (checkpoints[mid].fromBlock<=_block) {
472                 min = mid;
473             } else {
474                 max = mid-1;
475             }
476         }
477         return checkpoints[min].value;
478     }
479 
480     /// @dev `updateValueAtNow` used to update the `balances` map and the
481     ///  `totalSupplyHistory`
482     /// @param checkpoints The history of data being updated
483     /// @param _value The new number of tokens
484     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value) internal  {
485         if ((checkpoints.length == 0)
486             || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
487             Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
488             newCheckPoint.fromBlock =  uint128(block.number);
489             newCheckPoint.value = uint128(_value);
490         } else {
491             Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
492             oldCheckPoint.value = uint128(_value);
493         }
494     }
495 
496 
497     /// @dev Helper function to return a min betwen the two uints
498     function min(uint a, uint b) pure internal returns (uint) {
499         return a < b ? a : b;
500     }
501 
502 
503 }