1 //File: node_modules/giveth-common-contracts/contracts/ERC20.sol
2 pragma solidity ^0.4.15;
3 
4 
5 /**
6  * @title ERC20
7  * @dev A standard interface for tokens.
8  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
9  */
10 contract ERC20 {
11   
12     /// @dev Returns the total token supply.
13     function totalSupply() public constant returns (uint256 supply);
14 
15     /// @dev Returns the account balance of another account with address _owner.
16     function balanceOf(address _owner) public constant returns (uint256 balance);
17 
18     /// @dev Transfers _value amount of tokens to address _to
19     function transfer(address _to, uint256 _value) public returns (bool success);
20 
21     /// @dev Transfers _value amount of tokens from address _from to address _to
22     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
23 
24     /// @dev Allows _spender to withdraw from your account multiple times, up to the _value amount
25     function approve(address _spender, uint256 _value) public returns (bool success);
26 
27     /// @dev Returns the amount which _spender is still allowed to withdraw from _owner.
28     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
29 
30     event Transfer(address indexed _from, address indexed _to, uint256 _value);
31     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
32 
33 }
34 //File: node_modules/giveth-common-contracts/contracts/Owned.sol
35 pragma solidity ^0.4.15;
36 
37 
38 /// @title Owned
39 /// @author Adrià Massanet <adria@codecontext.io>
40 /// @notice The Owned contract has an owner address, and provides basic 
41 ///  authorization control functions, this simplifies & the implementation of
42 ///  "user permissions"
43 contract Owned {
44 
45     address public owner;
46     address public newOwnerCandidate;
47 
48     event OwnershipRequested(address indexed by, address indexed to);
49     event OwnershipTransferred(address indexed from, address indexed to);
50     event OwnershipRemoved();
51 
52     /// @dev The constructor sets the `msg.sender` as the`owner` of the contract
53     function Owned() {
54         owner = msg.sender;
55     }
56 
57     /// @dev `owner` is the only address that can call a function with this
58     /// modifier
59     modifier onlyOwner() {
60         require (msg.sender == owner);
61         _;
62     }
63 
64     /// @notice `owner` can step down and assign some other address to this role
65     /// @param _newOwner The address of the new owner.
66     function changeOwnership(address _newOwner) onlyOwner {
67         require(_newOwner != 0x0);
68 
69         address oldOwner = owner;
70         owner = _newOwner;
71         newOwnerCandidate = 0x0;
72 
73         OwnershipTransferred(oldOwner, owner);
74     }
75 
76     /// @notice `onlyOwner` Proposes to transfer control of the contract to a
77     ///  new owner
78     /// @param _newOwnerCandidate The address being proposed as the new owner
79     function proposeOwnership(address _newOwnerCandidate) onlyOwner {
80         newOwnerCandidate = _newOwnerCandidate;
81         OwnershipRequested(msg.sender, newOwnerCandidate);
82     }
83 
84     /// @notice Can only be called by the `newOwnerCandidate`, accepts the
85     ///  transfer of ownership
86     function acceptOwnership() {
87         require(msg.sender == newOwnerCandidate);
88 
89         address oldOwner = owner;
90         owner = newOwnerCandidate;
91         newOwnerCandidate = 0x0;
92 
93         OwnershipTransferred(oldOwner, owner);
94     }
95 
96     /// @notice Decentralizes the contract, this operation cannot be undone 
97     /// @param _dac `0xdac` has to be entered for this function to work
98     function removeOwnership(address _dac) onlyOwner {
99         require(_dac == 0xdac);
100         owner = 0x0;
101         newOwnerCandidate = 0x0;
102         OwnershipRemoved();     
103     }
104 
105 } 
106 
107 //File: node_modules/giveth-common-contracts/contracts/Escapable.sol
108 /*
109     Copyright 2016, Jordi Baylina
110     Contributor: Adrià Massanet <adria@codecontext.io>
111 
112     This program is free software: you can redistribute it and/or modify
113     it under the terms of the GNU General Public License as published by
114     the Free Software Foundation, either version 3 of the License, or
115     (at your option) any later version.
116 
117     This program is distributed in the hope that it will be useful,
118     but WITHOUT ANY WARRANTY; without even the implied warranty of
119     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
120     GNU General Public License for more details.
121 
122     You should have received a copy of the GNU General Public License
123     along with this program.  If not, see <http://www.gnu.org/licenses/>.
124 */
125 
126 pragma solidity ^0.4.15;
127 
128 
129 
130 
131 
132 /// @dev `Escapable` is a base level contract built off of the `Owned`
133 ///  contract that creates an escape hatch function to send its ether to
134 ///  `escapeHatchDestination` when called by the `escapeHatchCaller` in the case that
135 ///  something unexpected happens
136 contract Escapable is Owned {
137     address public escapeHatchCaller;
138     address public escapeHatchDestination;
139     mapping (address=>bool) private escapeBlacklist;
140 
141     /// @notice The Constructor assigns the `escapeHatchDestination` and the
142     ///  `escapeHatchCaller`
143     /// @param _escapeHatchDestination The address of a safe location (usu a
144     ///  Multisig) to send the ether held in this contract
145     /// @param _escapeHatchCaller The address of a trusted account or contract to
146     ///  call `escapeHatch()` to send the ether in this contract to the
147     ///  `escapeHatchDestination` it would be ideal that `escapeHatchCaller` cannot move
148     ///  funds out of `escapeHatchDestination`
149     function Escapable(address _escapeHatchCaller, address _escapeHatchDestination) {
150         escapeHatchCaller = _escapeHatchCaller;
151         escapeHatchDestination = _escapeHatchDestination;
152     }
153 
154     modifier onlyEscapeHatchCallerOrOwner {
155         require ((msg.sender == escapeHatchCaller)||(msg.sender == owner));
156         _;
157     }
158 
159     /// @notice The `blacklistEscapeTokens()` marks a token in a whitelist to be
160     ///   escaped. The proupose is to be done at construction time.
161     /// @param _token the be bloacklisted for escape
162     function blacklistEscapeToken(address _token) internal {
163         escapeBlacklist[_token] = true;
164         EscapeHatchBlackistedToken(_token);
165     }
166 
167     function isTokenEscapable(address _token) constant public returns (bool) {
168         return !escapeBlacklist[_token];
169     }
170 
171     /// @notice The `escapeHatch()` should only be called as a last resort if a
172     /// security issue is uncovered or something unexpected happened
173     /// @param _token to transfer, use 0x0 for ethers
174     function escapeHatch(address _token) public onlyEscapeHatchCallerOrOwner {   
175         require(escapeBlacklist[_token]==false);
176 
177         uint256 balance;
178 
179         if (_token == 0x0) {
180             balance = this.balance;
181             escapeHatchDestination.transfer(balance);
182             EscapeHatchCalled(_token, balance);
183             return;
184         }
185 
186         ERC20 token = ERC20(_token);
187         balance = token.balanceOf(this);
188         token.transfer(escapeHatchDestination, balance);
189         EscapeHatchCalled(_token, balance);
190     }
191 
192     /// @notice Changes the address assigned to call `escapeHatch()`
193     /// @param _newEscapeHatchCaller The address of a trusted account or contract to
194     ///  call `escapeHatch()` to send the ether in this contract to the
195     ///  `escapeHatchDestination` it would be ideal that `escapeHatchCaller` cannot
196     ///  move funds out of `escapeHatchDestination`
197     function changeHatchEscapeCaller(address _newEscapeHatchCaller) onlyEscapeHatchCallerOrOwner {
198         escapeHatchCaller = _newEscapeHatchCaller;
199     }
200 
201     event EscapeHatchBlackistedToken(address token);
202     event EscapeHatchCalled(address token, uint amount);
203 }
204 
205 //File: ./contracts/WithdrawContract.sol
206 pragma solidity ^0.4.18;
207 /*
208     Copyright 2017, Jordi Baylina
209 
210     This program is free software: you can redistribute it and/or modify
211     it under the terms of the GNU General Public License as published by
212     the Free Software Foundation, either version 3 of the License, or
213     (at your option) any later version.
214 
215     This program is distributed in the hope that it will be useful,
216     but WITHOUT ANY WARRANTY; without even the implied warranty of
217     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
218     GNU General Public License for more details.
219 
220     You should have received a copy of the GNU General Public License
221     along with this program.  If not, see <http://www.gnu.org/licenses/>.
222 */
223 
224 
225 /// @dev This declares a few functions from `MiniMeToken` so that the
226 ///  `WithdrawContract` can interface with the `MiniMeToken`
227 contract MiniMeToken {
228     function balanceOfAt(address _owner, uint _blockNumber) public constant returns (uint);
229     function totalSupplyAt(uint _blockNumber) public constant returns(uint);
230 }
231 
232 
233 
234 
235 /// @dev This is the main contract, it is intended to distribute deposited funds
236 ///  from a TRUSTED `owner` to token holders of a MiniMe style ERC-20 Token;
237 ///  only deposits from the `owner` using the functions `newTokenPayment()` &
238 ///  `newEtherPayment()` will be distributed, any other funds sent to this
239 ///  contract can only be removed via the `escapeHatch()`
240 contract WithdrawContract is Escapable {
241 
242     /// @dev Tracks the deposits made to this contract
243     struct Deposit {
244         uint block;    // Determines which token holders are able to collect
245         ERC20 token;   // The token address (0x0 if ether)
246         uint amount;   // The amount deposited in the smallest unit (wei if ETH)
247         bool canceled; // True if canceled by the `owner`
248     }
249 
250     Deposit[] public deposits; // Array of deposits to this contract
251     MiniMeToken rewardToken;     // Token that is used for withdraws
252 
253     mapping (address => uint) public nextDepositToPayout; // Tracks Payouts
254     mapping (address => mapping(uint => bool)) skipDeposits;
255 
256 /////////
257 // Constructor
258 /////////
259 
260     /// @notice The Constructor creates the `WithdrawContract` on the blockchain
261     ///  the `owner` role is assigned to the address that deploys this contract
262     /// @param _rewardToken The address of the token that is used to determine the
263     ///  distribution of the deposits according to the balance held at the
264     ///  deposit's specified `block`
265     /// @param _escapeHatchCaller The address of a trusted account or contract
266     ///  to call `escapeHatch()` to send the specified token (or ether) held in
267     ///  this contract to the `escapeHatchDestination`
268     /// @param _escapeHatchDestination The address of a safe location (usu a
269     ///  Multisig) to send the ether and tokens held in this contract when the
270     ///  `escapeHatch()` is called
271     function WithdrawContract(
272         MiniMeToken _rewardToken,
273         address _escapeHatchCaller,
274         address _escapeHatchDestination)
275         Escapable(_escapeHatchCaller, _escapeHatchDestination)
276         public
277     {
278         rewardToken = _rewardToken;
279     }
280 
281     /// @dev When ether is sent to this contract `newEtherDeposit()` is called
282     function () payable public {
283         newEtherDeposit(0);
284     }
285 /////////
286 // Owner Functions
287 /////////
288 
289     /// @notice Adds an ether deposit to `deposits[]`; only the `owner` can
290     ///  deposit into this contract
291     /// @param _block The block height that determines the snapshot of token
292     ///  holders that will be able to withdraw their share of this deposit; this
293     ///  block must be set in the past, if 0 it defaults to one block before the
294     ///  transaction
295     /// @return _idDeposit The id number for the deposit
296     function newEtherDeposit(uint _block)
297         public onlyOwner payable
298         returns (uint _idDeposit)
299     {
300         require(msg.value>0);
301         require(_block < block.number);
302         _idDeposit = deposits.length ++;
303 
304         // Record the deposit
305         Deposit storage d = deposits[_idDeposit];
306         d.block = _block == 0 ? block.number -1 : _block;
307         d.token = ERC20(0);
308         d.amount = msg.value;
309         NewDeposit(_idDeposit, ERC20(0), msg.value);
310     }
311 
312     /// @notice Adds a token deposit to `deposits[]`; only the `owner` can
313     ///  call this function and it will only work if the account sending the
314     ///  tokens has called `approve()` so that this contract can call
315     ///  `transferFrom()` and take the tokens
316     /// @param _token The address for the ERC20 that is being deposited
317     /// @param _amount The quantity of tokens that is deposited into the
318     ///  contract in the smallest unit of tokens (if a token has its decimals
319     ///  set to 18 and 1 token is sent, the `_amount` would be 10^18)
320     /// @param _block The block height that determines the snapshot of token
321     ///  holders that will be able to withdraw their share of this deposit; this
322     ///  block must be set in the past, if 0 it defaults to one block before the
323     ///  transaction
324     /// @return _idDeposit The id number for the deposit
325     function newTokenDeposit(ERC20 _token, uint _amount, uint _block)
326         public onlyOwner
327         returns (uint _idDeposit)
328     {
329         require(_amount > 0);
330         require(_block < block.number);
331 
332         // Must `approve()` this contract in a previous transaction
333         require( _token.transferFrom(msg.sender, address(this), _amount) );
334         _idDeposit = deposits.length ++;
335 
336         // Record the deposit
337         Deposit storage d = deposits[_idDeposit];
338         d.block = _block == 0 ? block.number -1 : _block;
339         d.token = _token;
340         d.amount = _amount;
341         NewDeposit(_idDeposit, _token, _amount);
342     }
343 
344     /// @notice This function is a failsafe function in case a token is
345     ///  deposited that has an issue that could prevent it's withdraw loop break
346     ///  (e.g. transfers are disabled), can only be called by the `owner`
347     /// @param _idDeposit The id number for the deposit being canceled
348     function cancelPaymentGlobally(uint _idDeposit) public onlyOwner {
349         require(_idDeposit < deposits.length);
350         deposits[_idDeposit].canceled = true;
351         CancelPaymentGlobally(_idDeposit);
352     }
353 
354 /////////
355 // Public Functions
356 /////////
357     /// @notice Sends all the tokens and ether to the token holder by looping
358     ///  through all the deposits, determining the appropriate amount by
359     ///  dividing the `totalSupply` by the number of tokens the token holder had
360     ///  at `deposit.block` for each deposit; this function may have to be
361     ///  called multiple times if their are many deposits
362     function withdraw() public {
363         uint acc = 0; // Accumulates the amount of tokens/ether to be sent
364         uint i = nextDepositToPayout[msg.sender]; // Iterates through the deposits
365         require(i<deposits.length);
366         ERC20 currentToken = deposits[i].token; // Sets the `currentToken` to ether
367 
368         require(msg.gas>149000); // Throws if there is no gas to do at least a single transfer.
369         while (( i< deposits.length) && ( msg.gas > 148000)) {
370             Deposit storage d = deposits[i];
371 
372             // Make sure `deposit[i]` shouldn't be skipped
373             if ((!d.canceled)&&(!isDepositSkiped(msg.sender, i))) {
374 
375                 // The current diposti is different of the accumulated until now,
376                 // so we return the accumulated tokens until now and resset the
377                 // accumulator.
378                 if (currentToken != d.token) {
379                     nextDepositToPayout[msg.sender] = i;
380                     require(doPayment(i-1, msg.sender, currentToken, acc));
381                     assert(nextDepositToPayout[msg.sender] == i);
382                     currentToken = d.token;
383                     acc =0;
384                 }
385 
386                 // Accumulate the amount to send for the `currentToken`
387                 acc +=  d.amount *
388                         rewardToken.balanceOfAt(msg.sender, d.block) /
389                             rewardToken.totalSupplyAt(d.block);
390             }
391 
392             i++; // Next deposit :-D
393         }
394         // Return the accumulated tokens.
395         nextDepositToPayout[msg.sender] = i;
396         require(doPayment(i-1, msg.sender, currentToken, acc));
397         assert(nextDepositToPayout[msg.sender] == i);
398     }
399 
400     /// @notice This function is a failsafe function in case a token holder
401     ///  wants to skip a payment, can only be applied to one deposit at a time
402     ///  and only affects the payment for the `msg.sender` calling the function;
403     ///  can be undone by calling again with `skip == false`
404     /// @param _idDeposit The id number for the deposit being canceled
405     /// @param _skip True if the caller wants to skip the payment for `idDeposit`
406     function skipPayment(uint _idDeposit, bool _skip) public {
407         require(_idDeposit < deposits.length);
408         skipDeposits[msg.sender][_idDeposit] = _skip;
409         SkipPayment(_idDeposit, _skip);
410     }
411 
412 /////////
413 // Constant Functions
414 /////////
415 
416     /// @notice Calculates the amount of a given token (or ether) the holder can
417     ///  receive
418     /// @param _token The address of the token being queried, 0x0 = ether
419     /// @param _holder The address being checked
420     /// @return The amount of `token` able to be collected in the smallest
421     ///  unit of the `token` (wei for ether)
422     function getPendingReward(ERC20 _token, address _holder) public constant returns(uint) {
423         uint acc =0;
424         for (uint i=nextDepositToPayout[msg.sender]; i<deposits.length; i++) {
425             Deposit storage d = deposits[i];
426             if ((d.token == _token)&&(!d.canceled) && (!isDepositSkiped(_holder, i))) {
427                 acc +=  d.amount *
428                     rewardToken.balanceOfAt(_holder, d.block) /
429                         rewardToken.totalSupplyAt(d.block);
430             }
431         }
432         return acc;
433     }
434 
435     /// @notice A check to see if a specific address has anything to collect
436     /// @param _holder The address being checked for available deposits
437     /// @return True if there are payments to be collected
438     function canWithdraw(address _holder) public constant returns (bool) {
439         if (nextDepositToPayout[_holder] == deposits.length) return false;
440         for (uint i=nextDepositToPayout[msg.sender]; i<deposits.length; i++) {
441             Deposit storage d = deposits[i];
442             if ((!d.canceled) && (!isDepositSkiped(_holder, i))) {
443                 uint amount =  d.amount *
444                     rewardToken.balanceOfAt(_holder, d.block) /
445                         rewardToken.totalSupplyAt(d.block);
446                 if (amount>0) return true;
447             }
448         }
449         return false;
450     }
451 
452     /// @notice Checks how many deposits have been made
453     /// @return The number of deposits
454     function nDeposits() public constant returns (uint) {
455         return deposits.length;
456     }
457 
458     /// @notice Checks to see if a specific deposit has been skipped
459     /// @param _holder The address being checked for available deposits
460     /// @param _idDeposit The id number for the deposit being canceled
461     /// @return True if the specified deposit has been skipped
462     function isDepositSkiped(address _holder, uint _idDeposit) public constant returns(bool) {
463         return skipDeposits[_holder][_idDeposit];
464     }
465 
466 /////////
467 // Internal Functions
468 /////////
469 
470     /// @notice Transfers `amount` of `token` to `dest`, only used internally,
471     ///  and does not throw, will always return `true` or `false`
472     /// @param _token The address for the ERC20 that is being transferred
473     /// @param _dest The destination address of the transfer
474     /// @param _amount The quantity of tokens that is being transferred
475     ///  denominated in the smallest unit of tokens (if a token has its decimals
476     ///  set to 18 and 1 token is being transferred the `amount` would be 10^18)
477     /// @return True if the payment succeeded
478     function doPayment(uint _idDeposit,  address _dest, ERC20 _token, uint _amount) internal returns (bool) {
479         if (_amount == 0) return true;
480         if (address(_token) == 0) {
481             if (!_dest.send(_amount)) return false;   // If we can't send, we continue...
482         } else {
483             if (!_token.transfer(_dest, _amount)) return false;
484         }
485         Withdraw(_idDeposit, _dest, _token, _amount);
486         return true;
487     }
488 
489     function getBalance(ERC20 _token, address _holder) internal constant returns (uint) {
490         if (address(_token) == 0) {
491             return _holder.balance;
492         } else {
493             return _token.balanceOf(_holder);
494         }
495     }
496 
497 /////////
498 // Events
499 /////////
500 
501     event Withdraw(uint indexed lastIdPayment, address indexed holder, ERC20 indexed tokenContract, uint amount);
502     event NewDeposit(uint indexed idDeposit, ERC20 indexed tokenContract, uint amount);
503     event CancelPaymentGlobally(uint indexed idDeposit);
504     event SkipPayment(uint indexed idDeposit, bool skip);
505 }