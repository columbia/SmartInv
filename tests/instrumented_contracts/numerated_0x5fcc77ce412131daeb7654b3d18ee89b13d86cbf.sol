1 pragma solidity ^0.4.19;
2 
3 /*
4     Copyright 2016, Jordi Baylina
5     Contributor: Adrià Massanet <adria@codecontext.io>
6 
7     This program is free software: you can redistribute it and/or modify
8     it under the terms of the GNU General Public License as published by
9     the Free Software Foundation, either version 3 of the License, or
10     (at your option) any later version.
11 
12     This program is distributed in the hope that it will be useful,
13     but WITHOUT ANY WARRANTY; without even the implied warranty of
14     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
15     GNU General Public License for more details.
16 
17     You should have received a copy of the GNU General Public License
18     along with this program.  If not, see <http://www.gnu.org/licenses/>.
19     
20     
21     This is just some extra garbage to check about comments
22 */
23 /// Add an extra comment here see if I care
24 /// @title Owned
25 /// @author Adrià Massanet <adria@codecontext.io>
26 /// @notice The Owned contract has an owner address, and provides basic 
27 ///  authorization control functions, this simplifies & the implementation of
28 ///  user permissions; this contract has three work flows for a change in
29 ///  ownership, the first requires the new owner to validate that they have the
30 ///  ability to accept ownership, the second allows the ownership to be
31 ///  directly transfered without requiring acceptance, and the third allows for
32 ///  the ownership to be removed to allow for decentralization 
33 contract Owned {
34 
35     address public owner;
36     address public newOwnerCandidate;
37 
38     event OwnershipRequested(address indexed by, address indexed to);
39     event OwnershipTransferred(address indexed from, address indexed to);
40     event OwnershipRemoved();
41 
42     /// @dev The constructor sets the `msg.sender` as the`owner` of the contract
43     function Owned() public {
44         owner = msg.sender;
45     }
46 
47     /// @dev `owner` is the only address that can call a function with this
48     /// modifier
49     modifier onlyOwner() {
50         require (msg.sender == owner);
51         _;
52     }
53     
54     /// @dev In this 1st option for ownership transfer `proposeOwnership()` must
55     ///  be called first by the current `owner` then `acceptOwnership()` must be
56     ///  called by the `newOwnerCandidate`
57     /// @notice `onlyOwner` Proposes to transfer control of the contract to a
58     ///  new owner
59     /// @param _newOwnerCandidate The address being proposed as the new owner
60     function proposeOwnership(address _newOwnerCandidate) public onlyOwner {
61         newOwnerCandidate = _newOwnerCandidate;
62         OwnershipRequested(msg.sender, newOwnerCandidate);
63     }
64 
65     /// @notice Can only be called by the `newOwnerCandidate`, accepts the
66     ///  transfer of ownership
67     function acceptOwnership() public {
68         require(msg.sender == newOwnerCandidate);
69 
70         address oldOwner = owner;
71         owner = newOwnerCandidate;
72         newOwnerCandidate = 0x0;
73 
74         OwnershipTransferred(oldOwner, owner);
75     }
76 
77     /// @dev In this 2nd option for ownership transfer `changeOwnership()` can
78     ///  be called and it will immediately assign ownership to the `newOwner`
79     /// @notice `owner` can step down and assign some other address to this role
80     /// @param _newOwner The address of the new owner
81     function changeOwnership(address _newOwner) public onlyOwner {
82         require(_newOwner != 0x0);
83 
84         address oldOwner = owner;
85         owner = _newOwner;
86         newOwnerCandidate = 0x0;
87 
88         OwnershipTransferred(oldOwner, owner);
89     }
90 
91     /// @dev In this 3rd option for ownership transfer `removeOwnership()` can
92     ///  be called and it will immediately assign ownership to the 0x0 address;
93     ///  it requires a 0xdece be input as a parameter to prevent accidental use
94     /// @notice Decentralizes the contract, this operation cannot be undone 
95     /// @param _dac `0xdac` has to be entered for this function to work
96     function removeOwnership(address _dac) public onlyOwner {
97         require(_dac == 0xdac);
98         owner = 0x0;
99         newOwnerCandidate = 0x0;
100         OwnershipRemoved();     
101     }
102 } 
103 
104 
105 
106 /**
107  * @title ERC20
108  * @dev A standard interface for tokens.
109  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
110  */
111 contract ERC20 {
112   
113     /// @dev Returns the total token supply
114     function totalSupply() public constant returns (uint256 supply);
115 
116     /// @dev Returns the account balance of the account with address _owner
117     function balanceOf(address _owner) public constant returns (uint256 balance);
118 
119     /// @dev Transfers _value number of tokens to address _to
120     function transfer(address _to, uint256 _value) public returns (bool success);
121 
122     /// @dev Transfers _value number of tokens from address _from to address _to
123     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
124 
125     /// @dev Allows _spender to withdraw from the msg.sender's account up to the _value amount
126     function approve(address _spender, uint256 _value) public returns (bool success);
127 
128     /// @dev Returns the amount which _spender is still allowed to withdraw from _owner
129     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
130 
131     event Transfer(address indexed _from, address indexed _to, uint256 _value);
132     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
133 
134 }
135 
136 
137 /// @dev `Escapable` is a base level contract built off of the `Owned`
138 ///  contract; it creates an escape hatch function that can be called in an
139 ///  emergency that will allow designated addresses to send any ether or tokens
140 ///  held in the contract to an `escapeHatchDestination` as long as they were
141 ///  not blacklisted
142 contract Escapable is Owned {
143     address public escapeHatchCaller;
144     address public escapeHatchDestination;
145     mapping (address=>bool) private escapeBlacklist; // Token contract addresses
146 
147     /// @notice The Constructor assigns the `escapeHatchDestination` and the
148     ///  `escapeHatchCaller`
149     /// @param _escapeHatchCaller The address of a trusted account or contract
150     ///  to call `escapeHatch()` to send the ether in this contract to the
151     ///  `escapeHatchDestination` it would be ideal that `escapeHatchCaller`
152     ///  cannot move funds out of `escapeHatchDestination`
153     /// @param _escapeHatchDestination The address of a safe location (usu a
154     ///  Multisig) to send the ether held in this contract; if a neutral address
155     ///  is required, the WHG Multisig is an option:
156     ///  0x8Ff920020c8AD673661c8117f2855C384758C572 
157     function Escapable(address _escapeHatchCaller, address _escapeHatchDestination) public {
158         escapeHatchCaller = _escapeHatchCaller;
159         escapeHatchDestination = _escapeHatchDestination;
160     }
161 
162     /// @dev The addresses preassigned as `escapeHatchCaller` or `owner`
163     ///  are the only addresses that can call a function with this modifier
164     modifier onlyEscapeHatchCallerOrOwner {
165         require ((msg.sender == escapeHatchCaller)||(msg.sender == owner));
166         _;
167     }
168 
169     /// @notice Creates the blacklist of tokens that are not able to be taken
170     ///  out of the contract; can only be done at the deployment, and the logic
171     ///  to add to the blacklist will be in the constructor of a child contract
172     /// @param _token the token contract address that is to be blacklisted 
173     function blacklistEscapeToken(address _token) internal {
174         escapeBlacklist[_token] = true;
175         EscapeHatchBlackistedToken(_token);
176     }
177 
178     /// @notice Checks to see if `_token` is in the blacklist of tokens
179     /// @param _token the token address being queried
180     /// @return False if `_token` is in the blacklist and can't be taken out of
181     ///  the contract via the `escapeHatch()`
182     function isTokenEscapable(address _token) constant public returns (bool) {
183         return !escapeBlacklist[_token];
184     }
185 
186     /// @notice The `escapeHatch()` should only be called as a last resort if a
187     /// security issue is uncovered or something unexpected happened
188     /// @param _token to transfer, use 0x0 for ether
189     function escapeHatch(address _token) public onlyEscapeHatchCallerOrOwner {   
190         require(escapeBlacklist[_token]==false);
191 
192         uint256 balance;
193 
194         /// @dev Logic for ether
195         if (_token == 0x0) {
196             balance = this.balance;
197             escapeHatchDestination.transfer(balance);
198             EscapeHatchCalled(_token, balance);
199             return;
200         }
201         /// @dev Logic for tokens
202         ERC20 token = ERC20(_token);
203         balance = token.balanceOf(this);
204         require(token.transfer(escapeHatchDestination, balance));
205         EscapeHatchCalled(_token, balance);
206     }
207 
208     /// @notice Changes the address assigned to call `escapeHatch()`
209     /// @param _newEscapeHatchCaller The address of a trusted account or
210     ///  contract to call `escapeHatch()` to send the value in this contract to
211     function changeHatchEscapeCaller(address _newEscapeHatchCaller) public onlyEscapeHatchCallerOrOwner {
212         escapeHatchCaller = _newEscapeHatchCaller;
213     }
214 
215     event EscapeHatchBlackistedToken(address token);
216     event EscapeHatchCalled(address token, uint amount);
217 }
218 
219 // Copyright (C) 2018 Alon Bukai This program is free software: you 
220 // can redistribute it and/or modify it under the terms of the GNU General 
221 // Public License as published by the Free Software Foundation, version. 
222 // This program is distributed in the hope that it will be useful, 
223 // but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
224 // or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
225 // more details. You should have received a copy of the GNU General Public
226 // License along with this program. If not, see http://www.gnu.org/licenses/
227 
228 /// @notice `MultiSend` is a contract for sending multiple ETH/ERC20 Tokens to
229 ///  multiple addresses. In addition this contract can call multiple contracts
230 ///  with multiple amounts. There are also TightlyPacked functions which in
231 ///  some situations allow for gas savings. TightlyPacked is cheaper if you
232 ///  need to store input data and if amount is less than 12 bytes. Normal is
233 ///  cheaper if you don't need to store input data or if amounts are greater
234 ///  than 12 bytes. Supports deterministic deployment. As explained
235 ///  here: https://github.com/ethereum/EIPs/issues/777#issuecomment-356103528
236 contract MultiSend is Escapable {
237   
238     /// @dev Hardcoded escapeHatchCaller
239     address CALLER = 0x839395e20bbB182fa440d08F850E6c7A8f6F0780;
240     /// @dev Hardcoded escapeHatchDestination
241     address DESTINATION = 0x8ff920020c8ad673661c8117f2855c384758c572;
242 
243     event MultiTransfer(
244         address indexed _from,
245         uint indexed _value,
246         address _to,
247         uint _amount
248     );
249 
250     event MultiCall(
251         address indexed _from,
252         uint indexed _value,
253         address _to,
254         uint _amount
255     );
256 
257     event MultiERC20Transfer(
258         address indexed _from,
259         uint indexed _value,
260         address _to,
261         uint _amount,
262         ERC20 _token
263     );
264 
265     /// @notice Constructor using Escapable and Hardcoded values
266     function MultiSend() Escapable(CALLER, DESTINATION) public {}
267 
268     /// @notice Send to multiple addresses using a byte32 array which
269     ///  includes the address and the amount.
270     ///  Addresses and amounts are stored in a packed bytes32 array
271     ///  Address is stored in the 20 most significant bytes
272     ///  The address is retrieved by bitshifting 96 bits to the right
273     ///  Amount is stored in the 12 least significant bytes
274     ///  The amount is retrieved by taking the 96 least significant bytes
275     ///  and converting them into an unsigned integer
276     ///  Payable
277     /// @param _addressesAndAmounts Bitwise packed array of addresses
278     ///  and amounts
279     function multiTransferTightlyPacked(bytes32[] _addressesAndAmounts)
280     payable public returns(bool)
281     {
282         uint startBalance = this.balance;
283         for (uint i = 0; i < _addressesAndAmounts.length; i++) {
284             address to = address(_addressesAndAmounts[i] >> 96);
285             uint amount = uint(uint96(_addressesAndAmounts[i]));
286             _safeTransfer(to, amount);
287             MultiTransfer(msg.sender, msg.value, to, amount);
288         }
289         require(startBalance - msg.value == this.balance);
290         return true;
291     }
292 
293     /// @notice Send to multiple addresses using two arrays which
294     ///  includes the address and the amount.
295     ///  Payable
296     /// @param _addresses Array of addresses to send to
297     /// @param _amounts Array of amounts to send
298     function multiTransfer(address[] _addresses, uint[] _amounts)
299     payable public returns(bool)
300     {
301         uint startBalance = this.balance;
302         for (uint i = 0; i < _addresses.length; i++) {
303             _safeTransfer(_addresses[i], _amounts[i]);
304             MultiTransfer(msg.sender, msg.value, _addresses[i], _amounts[i]);
305         }
306         require(startBalance - msg.value == this.balance);
307         return true;
308     }
309 
310     /// @notice Call to multiple contracts using a byte32 array which
311     ///  includes the contract address and the amount.
312     ///  Addresses and amounts are stored in a packed bytes32 array.
313     ///  Address is stored in the 20 most significant bytes.
314     ///  The address is retrieved by bitshifting 96 bits to the right
315     ///  Amount is stored in the 12 least significant bytes.
316     ///  The amount is retrieved by taking the 96 least significant bytes
317     ///  and converting them into an unsigned integer.
318     ///  Payable
319     /// @param _addressesAndAmounts Bitwise packed array of contract
320     ///  addresses and amounts
321     function multiCallTightlyPacked(bytes32[] _addressesAndAmounts)
322     payable public returns(bool)
323     {
324         uint startBalance = this.balance;
325         for (uint i = 0; i < _addressesAndAmounts.length; i++) {
326             address to = address(_addressesAndAmounts[i] >> 96);
327             uint amount = uint(uint96(_addressesAndAmounts[i]));
328             _safeCall(to, amount);
329             MultiCall(msg.sender, msg.value, to, amount);
330         }
331         require(startBalance - msg.value == this.balance);
332         return true;
333     }
334 
335     /// @notice Call to multiple contracts using two arrays which
336     ///  includes the contract address and the amount.
337     /// @param _addresses Array of contract addresses to call
338     /// @param _amounts Array of amounts to send
339     function multiCall(address[] _addresses, uint[] _amounts)
340     payable public returns(bool)
341     {
342         uint startBalance = this.balance;
343         for (uint i = 0; i < _addresses.length; i++) {
344             _safeCall(_addresses[i], _amounts[i]);
345             MultiCall(msg.sender, msg.value, _addresses[i], _amounts[i]);
346         }
347         require(startBalance - msg.value == this.balance);
348         return true;
349     }
350 
351     /// @notice Send ERC20 tokens to multiple contracts 
352     ///  using a byte32 array which includes the address and the amount.
353     ///  Addresses and amounts are stored in a packed bytes32 array.
354     ///  Address is stored in the 20 most significant bytes.
355     ///  The address is retrieved by bitshifting 96 bits to the right
356     ///  Amount is stored in the 12 least significant bytes.
357     ///  The amount is retrieved by taking the 96 least significant bytes
358     ///  and converting them into an unsigned integer.
359     /// @param _token The token to send
360     /// @param _addressesAndAmounts Bitwise packed array of addresses
361     ///  and token amounts
362     function multiERC20TransferTightlyPacked
363     (
364         ERC20 _token,
365         bytes32[] _addressesAndAmounts
366     ) public
367     {
368         for (uint i = 0; i < _addressesAndAmounts.length; i++) {
369             address to = address(_addressesAndAmounts[i] >> 96);
370             uint amount = uint(uint96(_addressesAndAmounts[i]));
371             _safeERC20Transfer(_token, to, amount);
372             MultiERC20Transfer(msg.sender, msg.value, to, amount, _token);
373         }
374     }
375 
376     /// @notice Send ERC20 tokens to multiple contracts
377     ///  using two arrays which includes the address and the amount.
378     /// @param _token The token to send
379     /// @param _addresses Array of addresses to send to
380     /// @param _amounts Array of token amounts to send
381     function multiERC20Transfer(
382         ERC20 _token,
383         address[] _addresses,
384         uint[] _amounts
385     ) public
386     {
387         for (uint i = 0; i < _addresses.length; i++) {
388             _safeERC20Transfer(_token, _addresses[i], _amounts[i]);
389             MultiERC20Transfer(
390                 msg.sender,
391                 msg.value,
392                 _addresses[i],
393                 _amounts[i],
394                 _token
395             );
396         }
397     }
398 
399     /// @notice `_safeTransfer` is used internally when transfer funds safely.
400     function _safeTransfer(address _to, uint _amount) internal {
401         require(_to != 0);
402         _to.transfer(_amount);
403     }
404 
405     /// @notice `_safeCall` is used internally when call a contract safely.
406     function _safeCall(address _to, uint _amount) internal {
407         require(_to != 0);
408         require(_to.call.value(_amount)());
409     }
410 
411     /// @notice `_safeERC20Transfer` is used internally when
412     ///  transfer a quantity of ERC20 tokens.
413     function _safeERC20Transfer(ERC20 _token, address _to, uint _amount)
414     internal
415     {
416         require(_to != 0);
417         require(_token.transferFrom(msg.sender, _to, _amount));
418     }
419 
420     /// @dev Default payable function to not allow sending to contract;
421     ///  remember this does not necesarily prevent the contract
422     ///  from accumulating funds.
423     function () public payable {
424         revert();
425     }
426 }