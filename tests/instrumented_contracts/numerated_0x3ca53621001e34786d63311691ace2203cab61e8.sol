1 pragma solidity ^0.4.18;
2 
3 /*
4   Copyright 2017, Anton Egorov (Mothership Foundation)
5   Copyright 2017, An Hoang Phan Ngo (Mothership Foundation)
6 
7   This program is free software: you can redistribute it and/or modify
8   it under the terms of the GNU General Public License as published by
9   the Free Software Foundation, either version 3 of the License, or
10   (at your option) any later version.
11 
12   This program is distributed in the hope that it will be useful,
13   but WITHOUT ANY WARRANTY; without even the implied warranty of
14   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
15   GNU General Public License for more details.
16 
17   You should have received a copy of the GNU General Public License
18   along with this program.  If not, see <http://www.gnu.org/licenses/>.
19 */
20 
21 // File: contracts/interface/Controlled.sol
22 
23 contract Controlled {
24   /// @notice The address of the controller is the only address that can call
25   ///  a function with this modifier
26   modifier onlyController {
27     require(msg.sender == controller);
28     _;
29   }
30 
31   address public controller;
32 
33   function Controlled() public { controller = msg.sender; }
34 
35   /// @notice Changes the controller of the contract
36   /// @param _newController The new controller of the contract
37   function changeController(address _newController) public onlyController {
38     controller = _newController;
39   }
40 }
41 
42 // File: contracts/interface/Burnable.sol
43 
44 /// @dev Burnable introduces a burner role, which could be used to destroy
45 ///  tokens. The burner address could be changed by himself.
46 contract Burnable is Controlled {
47   address public burner;
48 
49   /// @notice The function with this modifier could be called by a controller
50   /// as well as by a burner. But burner could use the onlt his/her address as
51   /// a target.
52   modifier onlyControllerOrBurner(address target) {
53     assert(msg.sender == controller || (msg.sender == burner && msg.sender == target));
54     _;
55   }
56 
57   modifier onlyBurner {
58     assert(msg.sender == burner);
59     _;
60   }
61 
62   /// Contract creator become a burner by default
63   function Burnable() public { burner = msg.sender;}
64 
65   /// @notice Change a burner address
66   /// @param _newBurner The new burner address
67   function changeBurner(address _newBurner) public onlyBurner {
68     burner = _newBurner;
69   }
70 }
71 
72 // File: contracts/interface/ERC20Token.sol
73 
74 // @dev Abstract contract for the full ERC 20 Token standard
75 //  https://github.com/ethereum/EIPs/issues/20
76 contract ERC20Token {
77   /// total amount of tokens
78   function totalSupply() public view returns (uint256 balance);
79 
80   /// @param _owner The address from which the balance will be retrieved
81   /// @return The balance
82   function balanceOf(address _owner) public view returns (uint256 balance);
83 
84   /// @notice send `_value` token to `_to` from `msg.sender`
85   /// @param _to The address of the recipient
86   /// @param _value The amount of token to be transferred
87   /// @return Whether the transfer was successful or not
88   function transfer(address _to, uint256 _value) public returns (bool success);
89 
90   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
91   /// @param _from The address of the sender
92   /// @param _to The address of the recipient
93   /// @param _value The amount of token to be transferred
94   /// @return Whether the transfer was successful or not
95   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
96 
97   /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
98   /// @param _spender The address of the account able to transfer the tokens
99   /// @param _value The amount of tokens to be approved for transfer
100   /// @return Whether the approval was successful or not
101   function approve(address _spender, uint256 _value) public returns (bool success);
102 
103   /// @param _owner The address of the account owning tokens
104   /// @param _spender The address of the account able to transfer the tokens
105   /// @return Amount of remaining tokens allowed to spent
106   function allowance(address _owner, address _spender) public view returns (uint256 remaining);
107 
108   event Transfer(address indexed _from, address indexed _to, uint256 _value);
109   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
110 }
111 
112 // File: contracts/interface/MiniMeTokenI.sol
113 
114 /// @dev MiniMeToken interface. Using this interface instead of whole contracts
115 ///  will reduce contract sise and gas cost
116 contract MiniMeTokenI is ERC20Token, Burnable {
117 
118   string public name;                //The Token's name: e.g. DigixDAO Tokens
119   uint8 public decimals;             //Number of decimals of the smallest unit
120   string public symbol;              //An identifier: e.g. REP
121   string public version = "MMT_0.1"; //An arbitrary versioning scheme
122 
123 ///////////////////
124 // ERC20 Methods
125 ///////////////////
126 
127   /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
128   ///  its behalf, and then a function is triggered in the contract that is
129   ///  being approved, `_spender`. This allows users to use their tokens to
130   ///  interact with contracts in one function call instead of two
131   /// @param _spender The address of the contract able to transfer the tokens
132   /// @param _amount The amount of tokens to be approved for transfer
133   /// @return True if the function call was successful
134   function approveAndCall(
135     address _spender,
136     uint256 _amount,
137     bytes _extraData) public returns (bool success);
138 
139 ////////////////
140 // Query balance and totalSupply in History
141 ////////////////
142 
143   /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
144   /// @param _owner The address from which the balance will be retrieved
145   /// @param _blockNumber The block number when the balance is queried
146   /// @return The balance at `_blockNumber`
147   function balanceOfAt(
148     address _owner,
149     uint _blockNumber) public constant returns (uint);
150 
151   /// @notice Total amount of tokens at a specific `_blockNumber`.
152   /// @param _blockNumber The block number when the totalSupply is queried
153   /// @return The total amount of tokens at `_blockNumber`
154   function totalSupplyAt(uint _blockNumber) public constant returns(uint);
155 
156 ////////////////
157 // Generate and destroy tokens
158 ////////////////
159 
160   /// @notice Generates `_amount` tokens that are assigned to `_owner`
161   /// @param _owner The address that will be assigned the new tokens
162   /// @param _amount The quantity of tokens generated
163   /// @return True if the tokens are generated correctly
164   function mintTokens(address _owner, uint _amount) public returns (bool);
165 
166 
167   /// @notice Burns `_amount` tokens from `_owner`
168   /// @param _owner The address that will lose the tokens
169   /// @param _amount The quantity of tokens to burn
170   /// @return True if the tokens are burned correctly
171   function destroyTokens(address _owner, uint _amount) public returns (bool);
172 
173 /////////////////
174 // Finalize 
175 ////////////////
176   function finalize() public;
177 
178 //////////
179 // Safety Methods
180 //////////
181 
182   /// @notice This method can be used by the controller to extract mistakenly
183   ///  sent tokens to this contract.
184   /// @param _token The address of the token contract that you want to recover
185   ///  set to 0 in case you want to extract ether.
186   function claimTokens(address _token) public;
187 
188 ////////////////
189 // Events
190 ////////////////
191 
192   event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
193 }
194 
195 // File: contracts/interface/TokenController.sol
196 
197 /// @dev The token controller contract must implement these functions
198 contract TokenController {
199     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
200     /// @param _owner The address that sent the ether to create tokens
201     /// @return True if the ether is accepted, false if it throws
202   function proxyMintTokens(
203     address _owner, 
204     uint _amount,
205     bytes32 _paidTxID) public returns(bool);
206 
207     /// @notice Notifies the controller about a token transfer allowing the
208     ///  controller to react if desired
209     /// @param _from The origin of the transfer
210     /// @param _to The destination of the transfer
211     /// @param _amount The amount of the transfer
212     /// @return False if the controller does not authorize the transfer
213   function onTransfer(address _from, address _to, uint _amount) public returns(bool);
214 
215     /// @notice Notifies the controller about an approval allowing the
216     ///  controller to react if desired
217     /// @param _owner The address that calls `approve()`
218     /// @param _spender The spender in the `approve()` call
219     /// @param _amount The amount in the `approve()` call
220     /// @return False if the controller does not authorize the approval
221   function onApprove(address _owner, address _spender, uint _amount) public
222     returns(bool);
223 }
224 
225 // File: contracts/Distribution.sol
226 
227 contract Distribution is Controlled, TokenController {
228 
229   /// Record tx details for each minting operation
230   struct Transaction {
231     uint256 amount;
232     bytes32 paidTxID;
233   }
234 
235   MiniMeTokenI public token;
236 
237   address public reserveWallet; // Team's wallet address
238 
239   uint256 public totalSupplyCap; // Total Token supply to be generated
240   uint256 public totalReserve; // A number of tokens to reserve for the team/bonuses
241 
242   uint256 public finalizedBlock;
243 
244   /// Record all transaction details for all minting operations
245   mapping (address => Transaction[]) allTransactions;
246 
247   /// @param _token Address of the SEN token contract
248   ///  the contribution finalizes.
249   /// @param _reserveWallet Team's wallet address to distribute reserved pool
250   /// @param _totalSupplyCap Maximum amount of tokens to generate during the contribution
251   /// @param _totalReserve A number of tokens to reserve for the team/bonuses
252   function Distribution(
253     address _token,
254     address _reserveWallet,
255     uint256 _totalSupplyCap,
256     uint256 _totalReserve
257   ) public onlyController
258   {
259     // Initialize only once
260     assert(address(token) == 0x0);
261 
262     token = MiniMeTokenI(_token);
263     reserveWallet = _reserveWallet;
264 
265     require(_totalReserve < _totalSupplyCap);
266     totalSupplyCap = _totalSupplyCap;
267     totalReserve = _totalReserve;
268 
269     assert(token.totalSupply() == 0);
270     assert(token.decimals() == 18); // Same amount of decimals as ETH
271   }
272 
273   function distributionCap() public constant returns (uint256) {
274     return totalSupplyCap - totalReserve;
275   }
276 
277   /// @notice This method can be called the distribution cap is reached only
278   function finalize() public onlyController {
279     assert(token.totalSupply() >= distributionCap());
280 
281     // Mint reserve pool
282     doMint(reserveWallet, totalReserve);
283 
284     finalizedBlock = getBlockNumber();
285     token.finalize(); // Token becomes unmintable after this
286 
287     // Distribution controller becomes a Token controller
288     token.changeController(controller);
289 
290     Finalized();
291   }
292 
293 //////////
294 // TokenController functions
295 //////////
296 
297   function proxyMintTokens(
298     address _th,
299     uint256 _amount,
300     bytes32 _paidTxID
301   ) public onlyController returns (bool)
302   {
303     require(_th != 0x0);
304 
305     require(_amount + token.totalSupply() <= distributionCap());
306 
307     doMint(_th, _amount);
308     addTransaction(
309       allTransactions[_th],
310       _amount,
311       _paidTxID);
312 
313     Purchase(
314       _th,
315       _amount,
316       _paidTxID);
317 
318     return true;
319   }
320 
321   function onTransfer(address, address, uint256) public returns (bool) {
322     return false;
323   }
324 
325   function onApprove(address, address, uint256) public returns (bool) {
326     return false;
327   }
328 
329   //////////
330   // Safety Methods
331   //////////
332 
333   /// @notice This method can be used by the controller to extract mistakenly
334   ///  sent tokens to this contract.
335   /// @param _token The address of the token contract that you want to recover
336   ///  set to 0 in case you want to extract ether.
337   function claimTokens(address _token) public onlyController {
338     if (token.controller() == address(this)) {
339       token.claimTokens(_token);
340     }
341     if (_token == 0x0) {
342       controller.transfer(this.balance);
343       return;
344     }
345 
346     ERC20Token otherToken = ERC20Token(_token);
347     uint256 balance = otherToken.balanceOf(this);
348     otherToken.transfer(controller, balance);
349     ClaimedTokens(_token, controller, balance);
350   }
351 
352   //////////////////////////////////
353   // Minting tokens and oraclization
354   //////////////////////////////////
355 
356   /// Total transaction count belong to an address
357   function totalTransactionCount(address _owner) public constant returns(uint) {
358     return allTransactions[_owner].length;
359   }
360 
361   /// Query a transaction details by address and its index in transactions array
362   function getTransactionAtIndex(address _owner, uint index) public constant returns(
363     uint256 _amount,
364     bytes32 _paidTxID
365   ) {
366     _amount = allTransactions[_owner][index].amount;
367     _paidTxID = allTransactions[_owner][index].paidTxID;
368   }
369 
370   /// Save transaction details belong to an address
371   /// @param  transactions all transactions belong to an address
372   /// @param _amount amount of tokens issued in the transaction
373   /// @param _paidTxID blockchain tx_hash
374   function addTransaction(
375     Transaction[] storage transactions,
376     uint _amount,
377     bytes32 _paidTxID
378     ) internal
379   {
380     Transaction storage newTx = transactions[transactions.length++];
381     newTx.amount = _amount;
382     newTx.paidTxID = _paidTxID;
383   }
384 
385   function doMint(address _th, uint256 _amount) internal {
386     assert(token.mintTokens(_th, _amount));
387   }
388 
389 //////////
390 // Testing specific methods
391 //////////
392 
393   /// @notice This function is overridden by the test Mocks.
394   function getBlockNumber() internal constant returns (uint256) { return block.number; }
395 
396 
397 ////////////////
398 // Events
399 ////////////////
400   event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
401   event Purchase(
402     address indexed _owner,
403     uint256 _amount,
404     bytes32 _paidTxID
405   );
406   event Finalized();
407 }