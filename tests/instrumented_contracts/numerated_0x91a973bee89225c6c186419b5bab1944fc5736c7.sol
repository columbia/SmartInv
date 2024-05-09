1 //File: node_modules/giveth-common-contracts/contracts/Owned.sol
2 pragma solidity ^0.4.15;
3 
4 
5 /// @title Owned
6 /// @author Adrià Massanet <adria@codecontext.io>
7 /// @notice The Owned contract has an owner address, and provides basic 
8 ///  authorization control functions, this simplifies & the implementation of
9 ///  user permissions; this contract has three work flows for a change in
10 ///  ownership, the first requires the new owner to validate that they have the
11 ///  ability to accept ownership, the second allows the ownership to be
12 ///  directly transfered without requiring acceptance, and the third allows for
13 ///  the ownership to be removed to allow for decentralization 
14 contract Owned {
15 
16     address public owner;
17     address public newOwnerCandidate;
18 
19     event OwnershipRequested(address indexed by, address indexed to);
20     event OwnershipTransferred(address indexed from, address indexed to);
21     event OwnershipRemoved();
22 
23     /// @dev The constructor sets the `msg.sender` as the`owner` of the contract
24     function Owned() public {
25         owner = msg.sender;
26     }
27 
28     /// @dev `owner` is the only address that can call a function with this
29     /// modifier
30     modifier onlyOwner() {
31         require (msg.sender == owner);
32         _;
33     }
34     
35     /// @dev In this 1st option for ownership transfer `proposeOwnership()` must
36     ///  be called first by the current `owner` then `acceptOwnership()` must be
37     ///  called by the `newOwnerCandidate`
38     /// @notice `onlyOwner` Proposes to transfer control of the contract to a
39     ///  new owner
40     /// @param _newOwnerCandidate The address being proposed as the new owner
41     function proposeOwnership(address _newOwnerCandidate) public onlyOwner {
42         newOwnerCandidate = _newOwnerCandidate;
43         OwnershipRequested(msg.sender, newOwnerCandidate);
44     }
45 
46     /// @notice Can only be called by the `newOwnerCandidate`, accepts the
47     ///  transfer of ownership
48     function acceptOwnership() public {
49         require(msg.sender == newOwnerCandidate);
50 
51         address oldOwner = owner;
52         owner = newOwnerCandidate;
53         newOwnerCandidate = 0x0;
54 
55         OwnershipTransferred(oldOwner, owner);
56     }
57 
58     /// @dev In this 2nd option for ownership transfer `changeOwnership()` can
59     ///  be called and it will immediately assign ownership to the `newOwner`
60     /// @notice `owner` can step down and assign some other address to this role
61     /// @param _newOwner The address of the new owner
62     function changeOwnership(address _newOwner) public onlyOwner {
63         require(_newOwner != 0x0);
64 
65         address oldOwner = owner;
66         owner = _newOwner;
67         newOwnerCandidate = 0x0;
68 
69         OwnershipTransferred(oldOwner, owner);
70     }
71 
72     /// @dev In this 3rd option for ownership transfer `removeOwnership()` can
73     ///  be called and it will immediately assign ownership to the 0x0 address;
74     ///  it requires a 0xdece be input as a parameter to prevent accidental use
75     /// @notice Decentralizes the contract, this operation cannot be undone 
76     /// @param _dac `0xdac` has to be entered for this function to work
77     function removeOwnership(address _dac) public onlyOwner {
78         require(_dac == 0xdac);
79         owner = 0x0;
80         newOwnerCandidate = 0x0;
81         OwnershipRemoved();     
82     }
83 } 
84 
85 //File: node_modules/giveth-common-contracts/contracts/ERC20.sol
86 pragma solidity ^0.4.15;
87 
88 
89 /**
90  * @title ERC20
91  * @dev A standard interface for tokens.
92  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
93  */
94 contract ERC20 {
95   
96     /// @dev Returns the total token supply
97     function totalSupply() public constant returns (uint256 supply);
98 
99     /// @dev Returns the account balance of the account with address _owner
100     function balanceOf(address _owner) public constant returns (uint256 balance);
101 
102     /// @dev Transfers _value number of tokens to address _to
103     function transfer(address _to, uint256 _value) public returns (bool success);
104 
105     /// @dev Transfers _value number of tokens from address _from to address _to
106     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
107 
108     /// @dev Allows _spender to withdraw from the msg.sender's account up to the _value amount
109     function approve(address _spender, uint256 _value) public returns (bool success);
110 
111     /// @dev Returns the amount which _spender is still allowed to withdraw from _owner
112     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
113 
114     event Transfer(address indexed _from, address indexed _to, uint256 _value);
115     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
116 
117 }
118 
119 //File: node_modules/giveth-common-contracts/contracts/Escapable.sol
120 pragma solidity ^0.4.15;
121 /*
122     Copyright 2016, Jordi Baylina
123     Contributor: Adrià Massanet <adria@codecontext.io>
124 
125     This program is free software: you can redistribute it and/or modify
126     it under the terms of the GNU General Public License as published by
127     the Free Software Foundation, either version 3 of the License, or
128     (at your option) any later version.
129 
130     This program is distributed in the hope that it will be useful,
131     but WITHOUT ANY WARRANTY; without even the implied warranty of
132     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
133     GNU General Public License for more details.
134 
135     You should have received a copy of the GNU General Public License
136     along with this program.  If not, see <http://www.gnu.org/licenses/>.
137 */
138 
139 
140 
141 
142 
143 /// @dev `Escapable` is a base level contract built off of the `Owned`
144 ///  contract; it creates an escape hatch function that can be called in an
145 ///  emergency that will allow designated addresses to send any ether or tokens
146 ///  held in the contract to an `escapeHatchDestination` as long as they were
147 ///  not blacklisted
148 contract Escapable is Owned {
149     address public escapeHatchCaller;
150     address public escapeHatchDestination;
151     mapping (address=>bool) private escapeBlacklist; // Token contract addresses
152 
153     /// @notice The Constructor assigns the `escapeHatchDestination` and the
154     ///  `escapeHatchCaller`
155     /// @param _escapeHatchCaller The address of a trusted account or contract
156     ///  to call `escapeHatch()` to send the ether in this contract to the
157     ///  `escapeHatchDestination` it would be ideal that `escapeHatchCaller`
158     ///  cannot move funds out of `escapeHatchDestination`
159     /// @param _escapeHatchDestination The address of a safe location (usu a
160     ///  Multisig) to send the ether held in this contract; if a neutral address
161     ///  is required, the WHG Multisig is an option:
162     ///  0x8Ff920020c8AD673661c8117f2855C384758C572 
163     function Escapable(address _escapeHatchCaller, address _escapeHatchDestination) public {
164         escapeHatchCaller = _escapeHatchCaller;
165         escapeHatchDestination = _escapeHatchDestination;
166     }
167 
168     /// @dev The addresses preassigned as `escapeHatchCaller` or `owner`
169     ///  are the only addresses that can call a function with this modifier
170     modifier onlyEscapeHatchCallerOrOwner {
171         require ((msg.sender == escapeHatchCaller)||(msg.sender == owner));
172         _;
173     }
174 
175     /// @notice Creates the blacklist of tokens that are not able to be taken
176     ///  out of the contract; can only be done at the deployment, and the logic
177     ///  to add to the blacklist will be in the constructor of a child contract
178     /// @param _token the token contract address that is to be blacklisted 
179     function blacklistEscapeToken(address _token) internal {
180         escapeBlacklist[_token] = true;
181         EscapeHatchBlackistedToken(_token);
182     }
183 
184     /// @notice Checks to see if `_token` is in the blacklist of tokens
185     /// @param _token the token address being queried
186     /// @return False if `_token` is in the blacklist and can't be taken out of
187     ///  the contract via the `escapeHatch()`
188     function isTokenEscapable(address _token) constant public returns (bool) {
189         return !escapeBlacklist[_token];
190     }
191 
192     /// @notice The `escapeHatch()` should only be called as a last resort if a
193     /// security issue is uncovered or something unexpected happened
194     /// @param _token to transfer, use 0x0 for ether
195     function escapeHatch(address _token) public onlyEscapeHatchCallerOrOwner {   
196         require(escapeBlacklist[_token]==false);
197 
198         uint256 balance;
199 
200         /// @dev Logic for ether
201         if (_token == 0x0) {
202             balance = this.balance;
203             escapeHatchDestination.transfer(balance);
204             EscapeHatchCalled(_token, balance);
205             return;
206         }
207         /// @dev Logic for tokens
208         ERC20 token = ERC20(_token);
209         balance = token.balanceOf(this);
210         require(token.transfer(escapeHatchDestination, balance));
211         EscapeHatchCalled(_token, balance);
212     }
213 
214     /// @notice Changes the address assigned to call `escapeHatch()`
215     /// @param _newEscapeHatchCaller The address of a trusted account or
216     ///  contract to call `escapeHatch()` to send the value in this contract to
217     ///  the `escapeHatchDestination`; it would be ideal that `escapeHatchCaller`
218     ///  cannot move funds out of `escapeHatchDestination`
219     function changeHatchEscapeCaller(address _newEscapeHatchCaller) public onlyEscapeHatchCallerOrOwner {
220         escapeHatchCaller = _newEscapeHatchCaller;
221     }
222 
223     event EscapeHatchBlackistedToken(address token);
224     event EscapeHatchCalled(address token, uint amount);
225 }
226 
227 //File: contracts/LPVault.sol
228 pragma solidity ^0.4.11;
229 
230 /*
231     Copyright 2017, Jordi Baylina
232     Contributors: RJ Ewing, Griff Green, Arthur Lunn
233 
234     This program is free software: you can redistribute it and/or modify
235     it under the terms of the GNU General Public License as published by
236     the Free Software Foundation, either version 3 of the License, or
237     (at your option) any later version.
238 
239     This program is distributed in the hope that it will be useful,
240     but WITHOUT ANY WARRANTY; without even the implied warranty of
241     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
242     GNU General Public License for more details.
243 
244     You should have received a copy of the GNU General Public License
245     along with this program.  If not, see <http://www.gnu.org/licenses/>.
246 */
247 
248 /// @title LPVault
249 /// @author Jordi Baylina
250 
251 /// @dev This contract holds ether securely for liquid pledging systems; for
252 ///  this iteration the funds will come often be escaped to the Giveth Multisig
253 ///  (safety precaution), but once fully tested and optimized this contract will
254 ///  be a safe place to store funds equipped with optional variable time delays
255 ///  to allow for an optional escapeHatch to be implemented in case of issues;
256 ///  future versions of this contract will be enabled for tokens
257 
258 
259 /// @dev `LiquidPledging` is a basic interface to allow the `LPVault` contract
260 ///  to confirm and cancel payments in the `LiquidPledging` contract.
261 contract LiquidPledging {
262     function confirmPayment(uint64 idPledge, uint amount) public;
263     function cancelPayment(uint64 idPledge, uint amount) public;
264 }
265 
266 
267 /// @dev `LPVault` is a higher level contract built off of the `Escapable`
268 ///  contract that holds funds for the liquid pledging system.
269 contract LPVault is Escapable {
270 
271     LiquidPledging public liquidPledging; // LiquidPledging contract's address
272     bool public autoPay; // If false, payments will take 2 txs to be completed
273 
274     enum PaymentStatus {
275         Pending, // When the payment is awaiting confirmation
276         Paid,    // When the payment has been sent
277         Canceled // When the payment will never be sent
278     }
279     /// @dev `Payment` is a public structure that describes the details of
280     ///  each payment the `ref` param makes it easy to track the movements of
281     ///  funds transparently by its connection to other `Payment` structs
282     struct Payment {
283         PaymentStatus state; // Pending, Paid or Canceled
284         bytes32 ref; // an input that references details from other contracts
285         address dest; // recipient of the ETH
286         uint amount; // amount of ETH (in wei) to be sent
287     }
288 
289     // @dev An array that contains all the payments for this LPVault
290     Payment[] public payments;
291 
292     function LPVault(address _escapeHatchCaller, address _escapeHatchDestination)
293         Escapable(_escapeHatchCaller, _escapeHatchDestination) public
294     {
295     }
296 
297     /// @dev The attached `LiquidPledging` contract is the only address that can
298     ///  call a function with this modifier
299     modifier onlyLiquidPledging() {
300         require(msg.sender == address(liquidPledging));
301         _;
302     }
303 
304     /// @dev The fall back function allows ETH to be deposited into the LPVault
305     ///  through a simple send
306     function () public payable {}
307 
308     /// @notice `onlyOwner` used to attach a specific liquidPledging instance
309     ///  to this LPvault; keep in mind that once a liquidPledging contract is 
310     ///  attached it cannot be undone, this vault will be forever connected
311     /// @param _newLiquidPledging A full liquid pledging contract
312     function setLiquidPledging(address _newLiquidPledging) public onlyOwner {
313         require(address(liquidPledging) == 0x0);
314         liquidPledging = LiquidPledging(_newLiquidPledging);
315     }
316 
317     /// @notice Used to decentralize, toggles whether the LPVault will
318     ///  automatically confirm a payment after the payment has been authorized
319     /// @param _automatic If true, payments will confirm instantly, if false
320     ///  the training wheels are put on and the owner must manually approve 
321     ///  every payment
322     function setAutopay(bool _automatic) public onlyOwner {
323         autoPay = _automatic;
324         AutoPaySet();
325     }
326 
327     /// @notice `onlyLiquidPledging` authorizes payments from this contract, if 
328     ///  `autoPay == true` the transfer happens automatically `else` the `owner`
329     ///  must call `confirmPayment()` for a transfer to occur (training wheels);
330     ///  either way, a new payment is added to `payments[]` 
331     /// @param _ref References the payment will normally be the pledgeID
332     /// @param _dest The address that payments will be sent to
333     /// @param _amount The amount that the payment is being authorized for
334     /// @return idPayment The id of the payment (needed by the owner to confirm)
335     function authorizePayment(
336         bytes32 _ref,
337         address _dest,
338         uint _amount
339     ) public onlyLiquidPledging returns (uint)
340     {
341         uint idPayment = payments.length;
342         payments.length ++;
343         payments[idPayment].state = PaymentStatus.Pending;
344         payments[idPayment].ref = _ref;
345         payments[idPayment].dest = _dest;
346         payments[idPayment].amount = _amount;
347 
348         AuthorizePayment(idPayment, _ref, _dest, _amount);
349 
350         if (autoPay) {
351             doConfirmPayment(idPayment);
352         }
353 
354         return idPayment;
355     }
356 
357     /// @notice Allows the owner to confirm payments;  since 
358     ///  `authorizePayment` is the only way to populate the `payments[]` array
359     ///  this is generally used when `autopay` is `false` after a payment has
360     ///  has been authorized
361     /// @param _idPayment Array lookup for the payment.
362     function confirmPayment(uint _idPayment) public onlyOwner {
363         doConfirmPayment(_idPayment);
364     }
365 
366     /// @notice Transfers ETH according to the data held within the specified
367     ///  payment id (internal function)
368     /// @param _idPayment id number for the payment about to be fulfilled 
369     function doConfirmPayment(uint _idPayment) internal {
370         require(_idPayment < payments.length);
371         Payment storage p = payments[_idPayment];
372         require(p.state == PaymentStatus.Pending);
373 
374         p.state = PaymentStatus.Paid;
375         liquidPledging.confirmPayment(uint64(p.ref), p.amount);
376 
377         p.dest.transfer(p.amount);  // Transfers ETH denominated in wei
378 
379         ConfirmPayment(_idPayment, p.ref);
380     }
381 
382     /// @notice When `autopay` is `false` and after a payment has been authorized
383     ///  to allow the owner to cancel a payment instead of confirming it.
384     /// @param _idPayment Array lookup for the payment.
385     function cancelPayment(uint _idPayment) public onlyOwner {
386         doCancelPayment(_idPayment);
387     }
388 
389     /// @notice Cancels a pending payment (internal function)
390     /// @param _idPayment id number for the payment    
391     function doCancelPayment(uint _idPayment) internal {
392         require(_idPayment < payments.length);
393         Payment storage p = payments[_idPayment];
394         require(p.state == PaymentStatus.Pending);
395 
396         p.state = PaymentStatus.Canceled;
397 
398         liquidPledging.cancelPayment(uint64(p.ref), p.amount);
399 
400         CancelPayment(_idPayment, p.ref);
401 
402     }
403 
404     /// @notice `onlyOwner` An efficient way to confirm multiple payments
405     /// @param _idPayments An array of multiple payment ids
406     function multiConfirm(uint[] _idPayments) public onlyOwner {
407         for (uint i = 0; i < _idPayments.length; i++) {
408             doConfirmPayment(_idPayments[i]);
409         }
410     }
411 
412     /// @notice `onlyOwner` An efficient way to cancel multiple payments
413     /// @param _idPayments An array of multiple payment ids
414     function multiCancel(uint[] _idPayments) public onlyOwner {
415         for (uint i = 0; i < _idPayments.length; i++) {
416             doCancelPayment(_idPayments[i]);
417         }
418     }
419 
420     /// @return The total number of payments that have ever been authorized
421     function nPayments() constant public returns (uint) {
422         return payments.length;
423     }
424 
425     /// Transfer eth or tokens to the escapeHatchDestination.
426     /// Used as a safety mechanism to prevent the vault from holding too much value
427     /// before being thoroughly battle-tested.
428     /// @param _token to transfer, use 0x0 for ether
429     /// @param _amount to transfer
430     function escapeFunds(address _token, uint _amount) public onlyOwner {
431         /// @dev Logic for ether
432         if (_token == 0x0) {
433             require(this.balance >= _amount);
434             escapeHatchDestination.transfer(_amount);
435             EscapeHatchCalled(_token, _amount);
436             return;
437         }
438         /// @dev Logic for tokens
439         ERC20 token = ERC20(_token);
440         uint balance = token.balanceOf(this);
441         require(balance >= _amount);
442         require(token.transfer(escapeHatchDestination, _amount));
443         EscapeFundsCalled(_token, _amount);
444     }
445 
446     event AutoPaySet();
447     event EscapeFundsCalled(address token, uint amount);
448     event ConfirmPayment(uint indexed idPayment, bytes32 indexed ref);
449     event CancelPayment(uint indexed idPayment, bytes32 indexed ref);
450     event AuthorizePayment(
451         uint indexed idPayment,
452         bytes32 indexed ref,
453         address indexed dest,
454         uint amount
455         );
456 }