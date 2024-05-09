1 //File: node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol
2 pragma solidity ^0.4.21;
3 
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
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 //File: node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol
46 pragma solidity ^0.4.21;
47 
48 
49 /**
50  * @title SafeMath
51  * @dev Math operations with safety checks that throw on error
52  */
53 library SafeMath {
54 
55   /**
56   * @dev Multiplies two numbers, throws on overflow.
57   */
58   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
59     if (a == 0) {
60       return 0;
61     }
62     c = a * b;
63     assert(c / a == b);
64     return c;
65   }
66 
67   /**
68   * @dev Integer division of two numbers, truncating the quotient.
69   */
70   function div(uint256 a, uint256 b) internal pure returns (uint256) {
71     // assert(b > 0); // Solidity automatically throws when dividing by 0
72     // uint256 c = a / b;
73     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
74     return a / b;
75   }
76 
77   /**
78   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
79   */
80   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81     assert(b <= a);
82     return a - b;
83   }
84 
85   /**
86   * @dev Adds two numbers, throws on overflow.
87   */
88   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
89     c = a + b;
90     assert(c >= a);
91     return c;
92   }
93 }
94 
95 //File: contracts/tokens/DappsToken.sol
96 /**
97  * @title DApps Token
98  * MiniMe Token with a subset of features. ERC20 Compliant
99  * @version 1.0
100 
101  */
102 pragma solidity ^0.4.21;
103 
104 
105 
106 
107 contract ApproveAndCallFallBack {
108     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
109 }
110 
111 contract DappsToken is Ownable {
112     using SafeMath for uint256;
113 
114     string public constant name = "DApps";
115     string public constant symbol = "DApps";
116     uint8 public constant decimals = 18;
117     string public version = "Dapps_0.1";
118 
119     /**
120     * @dev `Checkpoint` is the structure that attaches a block number to a
121     * given value, the block number attached is the one that last changed the value
122     */
123     struct Checkpoint {
124         // `fromBlock` is the block number that the value was generatedsuper.mint(_to, _amount); from
125         uint128 fromBlock;
126         // `value` is the amount of tokens at a specific block number
127         uint128 value;
128     }
129     // Tracks the history of the `totalSupply` of the token
130     Checkpoint[] totalSupplyHistory;
131 
132     // `creationBlock` is the block number that the Clone Token was created
133     uint256 public creationBlock;
134 
135     // `balances` is the map that tracks the balance of each address, in this
136     //  contract when the balance changes the block number that the change
137     //  occurred is also included in the map
138     mapping (address => Checkpoint[]) balances;
139 
140     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
141     mapping (address => mapping (address => uint256)) allowed;
142 
143     // Flag that determines if the token is transferable or not.
144     bool public transfersEnabled;
145 
146     ////////////////
147     // Events
148     ////////////////
149     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
150     event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
151 
152     /**
153      * @dev Constructor of DappsToken that instantiates a new MiniMe inspired ERC20 token
154      */
155     function DappsToken() public {
156         // token should not be transferrable until after all tokens have been issued
157         transfersEnabled = false;
158         creationBlock = block.number;
159     }
160 
161     ///////////////////
162     // ERC20 Methods
163     ///////////////////
164 
165     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
166     /// @param _to The address of the recipient
167     /// @param _amount The amount of tokens to be transferred
168     /// @return Whether the transfer was successful or not
169     function transfer(address _to, uint256 _amount) public returns (bool success) {
170         require(transfersEnabled);
171         doTransfer(msg.sender, _to, _amount);
172         return true;
173     }
174 
175     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
176     ///  is approved by `_from`
177     /// @param _from The address holding the tokens being transferred
178     /// @param _to The address of the recipient
179     /// @param _amount The amount of tokens to be transferred
180     /// @return True if the transfer was successful
181     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
182 
183         // The controller of this contract can move tokens around at will,
184         //  this is important to recognize! Confirm that you trust the
185         //  controller of this contract, which in most situations should be
186         //  another open source smart contract or 0x0
187         if (msg.sender != owner) {
188             require(transfersEnabled);
189 
190             // The standard ERC 20 transferFrom functionality
191             require(allowed[_from][msg.sender] >= _amount);
192             allowed[_from][msg.sender] -= _amount;
193         }
194         doTransfer(_from, _to, _amount);
195         return true;
196     }
197 
198     /// @dev This is the actual transfer function in the token contract, it can
199     ///  only be called by other functions in this contract.
200     /// @param _from The address holding the tokens being transferred
201     /// @param _to The address of the recipient
202     /// @param _amount The amount of tokens to be transferred
203     /// @return True if the transfer was successful
204     function doTransfer(address _from, address _to, uint256 _amount) internal {
205         if (_amount == 0) {
206             emit Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
207             return;
208         }
209 
210         // Do not allow transfer to the token contract itself - Matt: modified to allow sending to to address(0)
211         require((_to != address(this)));
212 
213         // If the amount being transfered is more than the balance of the
214         //  account the transfer throws
215         uint256 previousBalanceFrom = balanceOfAt(_from, block.number);
216 
217         require(previousBalanceFrom >= _amount);
218 
219         // First update the balance array with the new value for the address
220         //  sending the tokens
221         updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
222 
223         // Then update the balance array with the new value for the address
224         //  receiving the tokens
225         uint256 previousBalanceTo = balanceOfAt(_to, block.number);
226         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
227         updateValueAtNow(balances[_to], previousBalanceTo + _amount);
228 
229         // An event to make the transfer easy to find on the blockchain
230         emit Transfer(_from, _to, _amount);
231     }
232 
233     /// @param _owner The address that's balance is being requested
234     /// @return The balance of `_owner` at the current block
235     function balanceOf(address _owner) public constant returns (uint256 balance) {
236         return balanceOfAt(_owner, block.number);
237     }
238 
239     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
240     ///  its behalf. This is a modified version of the ERC20 approve function
241     ///  to be a little bit safer
242     /// @param _spender The address of the account able to transfer the tokens
243     /// @param _amount The amount of tokens to be approved for transfer
244     /// @return True if the approval was successful
245     function approve(address _spender, uint256 _amount) public returns (bool success) {
246         require(transfersEnabled);
247 
248         // To change the approve amount you first have to reduce the addresses`
249         //  allowance to zero by calling `approve(_spender,0)` if it is not
250         //  already 0 to mitigate the race condition described here:
251         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
252         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
253 
254         allowed[msg.sender][_spender] = _amount;
255         emit Approval(msg.sender, _spender, _amount);
256         return true;
257     }
258 
259     /// @dev This function makes it easy to read the `allowed[]` map
260     /// @param _owner The address of the account that owns the token
261     /// @param _spender The address of the account able to transfer the tokens
262     /// @return Amount of remaining tokens of _owner that _spender is allowed
263     ///  to spend
264     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
265         return allowed[_owner][_spender];
266     }
267 
268     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
269     ///  its behalf, and then a function is triggered in the contract that is
270     ///  being approved, `_spender`. This allows users to use their tokens to
271     ///  interact with contracts in one function call instead of two
272     /// @param _spender The address of the contract able to transfer the tokens
273     /// @param _amount The amount of tokens to be approved for transfer
274     /// @return True if the function call was successful
275     function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool success) {
276         require(approve(_spender, _amount));
277 
278         ApproveAndCallFallBack(_spender).receiveApproval(
279             msg.sender,
280             _amount,
281             this,
282             _extraData
283         );
284 
285         return true;
286     }
287 
288     /// @dev This function makes it easy to get the total number of tokens
289     /// @return The total number of tokens
290     function totalSupply() public constant returns (uint256) {
291         return totalSupplyAt(block.number);
292     }
293 
294     ////////////////
295     // Query balance and totalSupply in History
296     ////////////////
297 
298     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
299     /// @param _owner The address from which the balance will be retrieved
300     /// @param _blockNumber The block number when the balance is queried
301     /// @return The balance at `_blockNumber`
302     function balanceOfAt(address _owner, uint256 _blockNumber) public constant returns (uint256) {
303 
304         // These next few lines are used when the balance of the token is
305         //  requested before a check point was ever created for this token, it
306         //  requires that the `parentToken.balanceOfAt` be queried at the
307         //  genesis block for that token as this contains initial balance of
308         //  this token
309         if ((balances[_owner].length == 0)|| (balances[_owner][0].fromBlock > _blockNumber)) {
310             return 0;
311         // This will return the expected balance during normal situations
312         } else {
313             return getValueAt(balances[_owner], _blockNumber);
314         }
315     }
316 
317     /// @notice Total amount of tokens at a specific `_blockNumber`.
318     /// @param _blockNumber The block number when the totalSupply is queried
319     /// @return The total amount of tokens at `_blockNumber`
320     function totalSupplyAt(uint256 _blockNumber) public constant returns(uint256) {
321 
322         // These next few lines are used when the totalSupply of the token is
323         //  requested before a check point was ever created for this token, it
324         //  requires that the `parentToken.totalSupplyAt` be queried at the
325         //  genesis block for this token as that contains totalSupply of this
326         //  token at this block number.
327         if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
328             return 0;
329         // This will return the expected totalSupply during normal situations
330         } else {
331             return getValueAt(totalSupplyHistory, _blockNumber);
332         }
333     }
334 
335     ////////////////
336     // Generate and destroy tokens
337     ////////////////
338 
339     /**
340     * @dev Generates `_amount` tokens that are assigned to `_owner`
341     * @param _owner The address that will be assigned the new tokens
342     * @param _amount The quantity of tokens generated
343     * @return True if the tokens are generated correctly
344     */
345     function generateTokens(address _owner, uint256 _amount) public onlyOwner returns (bool) {
346         uint256 curTotalSupply = totalSupply();
347         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
348         uint256 previousBalanceTo = balanceOf(_owner);
349         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
350         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
351         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
352         emit Transfer(0, _owner, _amount);
353         return true;
354     }
355 
356     /// @notice Burns `_amount` tokens from `_owner`
357     /// @param _owner The address that will lose the tokens
358     /// @param _amount The quantity of tokens to burn
359     /// @return True if the tokens are burned correctly
360     function destroyTokens(address _owner, uint256 _amount) onlyOwner public returns (bool) {
361         uint256 curTotalSupply = totalSupply();
362         require(curTotalSupply >= _amount);
363         uint256 previousBalanceFrom = balanceOf(_owner);
364         require(previousBalanceFrom >= _amount);
365         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
366         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
367         emit Transfer(_owner, 0, _amount);
368         return true;
369     }
370 
371     ////////////////
372     // Enable tokens transfers
373     ////////////////
374 
375     /// @notice Enables token holders to transfer their tokens freely if true
376     /// @param _transfersEnabled True if transfers are allowed in the clone
377     function enableTransfers(bool _transfersEnabled) public onlyOwner {
378         transfersEnabled = _transfersEnabled;
379     }
380 
381     ////////////////
382     // Internal helper functions to query and set a value in a snapshot array
383     ////////////////
384 
385     /**
386     * @dev `getValueAt` retrieves the number of tokens at a given block number
387     * @param checkpoints The history of values being queried
388     * @param _block The block number to retrieve the value at
389     * @return The number of tokens being queried
390     */
391     function getValueAt(Checkpoint[] storage checkpoints, uint256 _block) constant internal returns (uint256) {
392         if (checkpoints.length == 0) return 0;
393 
394         // Shortcut for the actual value
395         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
396             return checkpoints[checkpoints.length-1].value;
397         if (_block < checkpoints[0].fromBlock) return 0;
398 
399         // Binary search of the value in the array
400         uint256 min = 0;
401         uint256 max = checkpoints.length-1;
402         while (max > min) {
403             uint256 mid = (max + min + 1)/ 2;
404             if (checkpoints[mid].fromBlock<=_block) {
405                 min = mid;
406             } else {
407                 max = mid-1;
408             }
409         }
410         return checkpoints[min].value;
411     }
412 
413     /// @dev `updateValueAtNow` used to update the `balances` map and the
414     ///  `totalSupplyHistory`
415     /// @param checkpoints The history of data being updated
416     /// @param _value The new number of tokens
417     function updateValueAtNow(Checkpoint[] storage checkpoints, uint256 _value
418     ) internal  {
419         if ((checkpoints.length == 0)
420         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
421                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
422                newCheckPoint.fromBlock =  uint128(block.number);
423                newCheckPoint.value = uint128(_value);
424            } else {
425                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
426                oldCheckPoint.value = uint128(_value);
427            }
428     }
429 }