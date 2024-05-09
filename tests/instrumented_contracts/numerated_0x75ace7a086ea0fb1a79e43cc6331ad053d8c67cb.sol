1 /**
2  *Submitted for verification at Etherscan.io on 2019-11-13
3 */
4 
5 // File: contracts/common/Validating.sol
6 
7 pragma solidity 0.5.12;
8 
9 
10 interface Validating {
11   modifier notZero(uint number) { require(number > 0, "invalid 0 value"); _; }
12   modifier notEmpty(string memory text) { require(bytes(text).length > 0, "invalid empty string"); _; }
13   modifier validAddress(address value) { require(value != address(0x0), "invalid address"); _; }
14 }
15 
16 // File: contracts/common/Versioned.sol
17 
18 pragma solidity 0.5.12;
19 
20 
21 contract Versioned {
22 
23   string public version;
24 
25   constructor(string memory version_) public { version = version_; }
26 
27 }
28 
29 // File: contracts/external/SafeMath.sol
30 
31 pragma solidity 0.5.12;
32 
33 
34 /**
35  * @title Math provides arithmetic functions for uint type pairs.
36  * You can safely `plus`, `minus`, `times`, and `divide` uint numbers without fear of integer overflow.
37  * You can also find the `min` and `max` of two numbers.
38  */
39 library SafeMath {
40 
41   function min(uint x, uint y) internal pure returns (uint) { return x <= y ? x : y; }
42   function max(uint x, uint y) internal pure returns (uint) { return x >= y ? x : y; }
43 
44 
45   /** @dev adds two numbers, reverts on overflow */
46   function plus(uint x, uint y) internal pure returns (uint z) { require((z = x + y) >= x, "bad addition"); }
47 
48   /** @dev subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend) */
49   function minus(uint x, uint y) internal pure returns (uint z) { require((z = x - y) <= x, "bad subtraction"); }
50 
51 
52   /** @dev multiplies two numbers, reverts on overflow */
53   function times(uint x, uint y) internal pure returns (uint z) { require(y == 0 || (z = x * y) / y == x, "bad multiplication"); }
54 
55   /** @dev divides two numbers and returns the remainder (unsigned integer modulo), reverts when dividing by zero */
56   function mod(uint x, uint y) internal pure returns (uint z) {
57     require(y != 0, "bad modulo; using 0 as divisor");
58     z = x % y;
59   }
60 
61   /** @dev Integer division of two numbers truncating the quotient, reverts on division by zero */
62   function div(uint a, uint b) internal pure returns (uint c) {
63     // assert(b > 0); // Solidity automatically throws when dividing by 0
64     c = a / b;
65     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66   }
67 
68 }
69 
70 // File: contracts/external/Token.sol
71 
72 pragma solidity 0.5.12;
73 
74 
75 /*
76  * Abstract contract for the full ERC 20 Token standard
77  * https://github.com/ethereum/EIPs/issues/20
78  */
79 contract Token {
80   /** This is a slight change to the ERC20 base standard.
81   function totalSupply() view returns (uint supply);
82   is replaced map:
83   uint public totalSupply;
84   This automatically creates a getter function for the totalSupply.
85   This is moved to the base contract since public getter functions are not
86   currently recognised as an implementation of the matching abstract
87   function by the compiler.
88   */
89   /// total amount of tokens
90   uint public totalSupply;
91 
92   /// @param _owner The address from which the balance will be retrieved
93   /// @return The balance
94   function balanceOf(address _owner) public view returns (uint balance);
95 
96   /// @notice send `_value` token to `_to` from `msg.sender`
97   /// @param _to The address of the recipient
98   /// @param _value The amount of token to be transferred
99   /// @return Whether the transfer was successful or not
100   function transfer(address _to, uint _value) public returns (bool success);
101 
102   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
103   /// @param _from The address of the sender
104   /// @param _to The address of the recipient
105   /// @param _value The amount of token to be transferred
106   /// @return Whether the transfer was successful or not
107   function transferFrom(address _from, address _to, uint _value) public returns (bool success);
108 
109   /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
110   /// @param _spender The address of the account able to transfer the tokens
111   /// @param _value The amount of tokens to be approved for transfer
112   /// @return Whether the approval was successful or not
113   function approve(address _spender, uint _value) public returns (bool success);
114 
115   /// @param _owner The address of the account owning tokens
116   /// @param _spender The address of the account able to transfer the tokens
117   /// @return Amount of remaining tokens allowed to spent
118   function allowance(address _owner, address _spender) public view returns (uint remaining);
119 
120   event Transfer(address indexed _from, address indexed _to, uint _value);
121   event Approval(address indexed _owner, address indexed _spender, uint _value);
122 }
123 
124 // File: contracts/gluon/AppGovernance.sol
125 
126 pragma solidity 0.5.12;
127 
128 
129 interface AppGovernance {
130   function approve(uint32 id) external;
131   function disapprove(uint32 id) external;
132   function activate(uint32 id) external;
133 }
134 
135 // File: contracts/gluon/AppLogic.sol
136 
137 pragma solidity 0.5.12;
138 
139 
140 interface AppLogic {
141   function upgrade() external;
142   function credit(address account, address asset, uint quantity) external;
143   function debit(address account, bytes calldata parameters) external returns (address asset, uint quantity);
144 }
145 
146 // File: contracts/gluon/GluonView.sol
147 
148 pragma solidity 0.5.12;
149 
150 
151 interface GluonView {
152   function app(uint32 id) external view returns (address current, address proposal, uint activationBlock);
153   function current(uint32 id) external view returns (address);
154   function history(uint32 id) external view returns (address[] memory);
155   function getBalance(uint32 id, address asset) external view returns (uint);
156   function isAnyLogic(uint32 id, address logic) external view returns (bool);
157   function isAppOwner(uint32 id, address appOwner) external view returns (bool);
158   function proposals(address logic) external view returns (bool);
159   function totalAppsCount() external view returns(uint32);
160 }
161 
162 // File: contracts/gluon/GluonWallet.sol
163 
164 pragma solidity 0.5.12;
165 
166 
167 interface GluonWallet {
168   function depositEther(uint32 id) external payable;
169   function depositToken(uint32 id, address token, uint quantity) external;
170   function withdraw(uint32 id, bytes calldata parameters) external;
171   function transfer(uint32 from, uint32 to, bytes calldata parameters) external;
172 }
173 
174 // File: contracts/gluon/Governing.sol
175 
176 pragma solidity 0.5.12;
177 
178 
179 interface Governing {
180   function deleteVoteTally(address proposal) external;
181   function activationInterval() external view returns (uint);
182 }
183 
184 // File: contracts/common/HasOwners.sol
185 
186 pragma solidity 0.5.12;
187 
188 
189 
190 contract HasOwners is Validating {
191 
192   address[] public owners;
193   mapping(address => bool) public isOwner;
194 
195   event OwnerAdded(address indexed owner);
196   event OwnerRemoved(address indexed owner);
197 
198   constructor(address[] memory owners_) public {
199     for (uint i = 0; i < owners_.length; i++) addOwner_(owners_[i]);
200   }
201 
202   modifier onlyOwner { require(isOwner[msg.sender], "invalid sender; must be owner"); _; }
203 
204   function getOwners() public view returns (address[] memory) { return owners; }
205 
206   function addOwner(address owner) external onlyOwner { addOwner_(owner); }
207 
208   function addOwner_(address owner) private validAddress(owner) {
209     if (!isOwner[owner]) {
210       isOwner[owner] = true;
211       owners.push(owner);
212       emit OwnerAdded(owner);
213     }
214   }
215 
216   function removeOwner(address owner) external onlyOwner {
217     require(isOwner[owner], 'only owners can be removed');
218     require(owners.length > 1, 'can not remove last owner');
219     isOwner[owner] = false;
220     for (uint i = 0; i < owners.length; i++) {
221       if (owners[i] == owner) {
222         owners[i] = owners[owners.length - 1];
223         owners.pop();
224         emit OwnerRemoved(owner);
225         break;
226       }
227     }
228   }
229 
230 }
231 
232 // File: contracts/gluon/HasAppOwners.sol
233 
234 pragma solidity 0.5.12;
235 
236 
237 
238 contract HasAppOwners is HasOwners {
239 
240   mapping(uint32 => address[]) public appOwners;
241 
242   event AppOwnerAdded (uint32 appId, address appOwner);
243   event AppOwnerRemoved (uint32 appId, address appOwner);
244 
245   constructor(address[] memory owners) HasOwners(owners) public { }
246 
247   modifier onlyAppOwner(uint32 appId) { require(isAppOwner(appId, msg.sender), "invalid sender; must be app owner"); _; }
248 
249   function isAppOwner(uint32 appId, address appOwner) public view returns (bool) {
250     address[] memory currentOwners = appOwners[appId];
251     for (uint i = 0; i < currentOwners.length; i++) {
252       if (currentOwners[i] == appOwner) return true;
253     }
254     return false;
255   }
256 
257   function getAppOwners(uint32 appId) public view returns (address[] memory) { return appOwners[appId]; }
258 
259   function addAppOwners(uint32 appId, address[] calldata toBeAdded) external onlyAppOwner(appId) {
260     addAppOwners_(appId, toBeAdded);
261   }
262 
263   function addAppOwners_(uint32 appId, address[] memory toBeAdded) internal {
264     for (uint i = 0; i < toBeAdded.length; i++) {
265       if (!isAppOwner(appId, toBeAdded[i])) {
266         appOwners[appId].push(toBeAdded[i]);
267         emit AppOwnerAdded(appId, toBeAdded[i]);
268       }
269     }
270   }
271 
272 
273   function removeAppOwners(uint32 appId, address[] calldata toBeRemoved) external onlyAppOwner(appId) {
274     address[] storage currentOwners = appOwners[appId];
275     require(currentOwners.length > toBeRemoved.length, "can not remove last owner");
276     for (uint i = 0; i < toBeRemoved.length; i++) {
277       for (uint j = 0; j < currentOwners.length; j++) {
278         if (currentOwners[j] == toBeRemoved[i]) {
279           currentOwners[j] = currentOwners[currentOwners.length - 1];
280           currentOwners.pop();
281           emit AppOwnerRemoved(appId, toBeRemoved[i]);
282           break;
283         }
284       }
285     }
286   }
287 
288 }
289 
290 // File: contracts/gluon/Gluon.sol
291 
292 pragma solidity 0.5.12;
293 
294 
295 
296 
297 
298 
299 
300 
301 
302 
303 
304 
305 contract Gluon is Validating, Versioned, AppGovernance, GluonView, GluonWallet, HasAppOwners {
306   using SafeMath for uint;
307 
308   struct App {
309     address[] history;
310     address proposal;
311     uint activationBlock;
312     mapping(address => uint) balances;
313   }
314 
315   address private constant ETH = address(0x0);
316   uint32 private constant REGISTRY_INDEX = 0;
317   uint32 private constant STAKE_INDEX = 1;
318 
319   mapping(uint32 => App) public apps;
320   mapping(address => bool) public proposals;
321   uint32 public totalAppsCount = 0;
322 
323   event AppRegistered (uint32 appId);
324   event AppProvisioned(uint32 indexed appId, uint8 version, address logic);
325   event ProposalAdded(uint32 indexed appId, uint8 version, address logic, uint activationBlock);
326   event ProposalRemoved(uint32 indexed appId, uint8 version, address logic);
327   event Activated(uint32 indexed appId, uint8 version, address logic);
328 
329   constructor(address[] memory owners, string memory version) Versioned(version) public HasAppOwners(owners) {
330     registerApp_(REGISTRY_INDEX, owners);
331     registerApp_(STAKE_INDEX, owners);
332   }
333 
334   modifier onlyCurrentLogic(uint32 appId) { require(msg.sender == current(appId), "invalid sender; must be latest logic contract"); _; }
335   modifier provisioned(uint32 appId) { require(apps[appId].history.length > 0, "App is not yet provisioned"); _; }
336 
337   function registerApp(uint32 appId, address[] calldata appOwners_) external onlyOwner { registerApp_(appId, appOwners_); }
338 
339   function registerApp_(uint32 appId, address[] memory appOwners_) private {
340     require(appOwners[appId].length == 0, "App already has app owner");
341     require(totalAppsCount == appId, "app ids are incremented by 1");
342     totalAppsCount++;
343     emit AppRegistered(appId);
344     addAppOwners_(appId, appOwners_);
345   }
346 
347   function provisionApp(uint32 appId, address logic) external onlyAppOwner(appId) validAddress(logic) {
348     App storage app = apps[appId];
349     require(app.history.length == 0, "App is already provisioned");
350     app.history.push(logic);
351     emit AppProvisioned(appId, uint8(app.history.length - 1), logic);
352   }
353 
354   function addProposal(uint32 appId, address logic) external onlyAppOwner(appId) provisioned(appId) validAddress(logic) {
355     App storage app = apps[appId];
356     require(app.proposal == address(0), "Proposal already exists. remove proposal before adding new one");
357     app.proposal = logic;
358     app.activationBlock = block.number + Governing(current(STAKE_INDEX)).activationInterval();
359     proposals[logic] = true;
360     emit ProposalAdded(appId, uint8(app.history.length - 1), app.proposal, app.activationBlock);
361   }
362 
363   function removeProposal(uint32 appId) external onlyAppOwner(appId) provisioned(appId) {
364     App storage app = apps[appId];
365     emit ProposalRemoved(appId, uint8(app.history.length - 1), app.proposal);
366     deleteProposal(app);
367   }
368 
369   function deleteProposal(App storage app) private {
370     Governing(current(STAKE_INDEX)).deleteVoteTally(app.proposal);
371     delete proposals[app.proposal];
372     delete app.proposal;
373     app.activationBlock = 0;
374   }
375 
376   /************************************************* AppGovernance ************************************************/
377 
378   function approve(uint32 appId) external onlyCurrentLogic(STAKE_INDEX) {
379     apps[appId].activationBlock = block.number;
380   }
381 
382   function disapprove(uint32 appId) external onlyCurrentLogic(STAKE_INDEX) {
383     App storage app = apps[appId];
384     emit ProposalRemoved(appId, uint8(app.history.length - 1), app.proposal);
385     deleteProposal(app);
386   }
387 
388   function activate(uint32 appId) external onlyCurrentLogic(appId) provisioned(appId) {
389     App storage app = apps[appId];
390     require(app.activationBlock > 0, "nothing to activate");
391     require(app.activationBlock < block.number, "new app can not be activated before activation block");
392     app.history.push(app.proposal); // now make it the current
393     deleteProposal(app);
394     emit Activated(appId, uint8(app.history.length - 1), current(appId));
395   }
396 
397   /**************************************************** GluonWallet ****************************************************/
398 
399   function depositEther(uint32 appId) external payable provisioned(appId) {
400     App storage app = apps[appId];
401     app.balances[ETH] = app.balances[ETH].plus(msg.value);
402     AppLogic(current(appId)).credit(msg.sender, ETH, msg.value);
403   }
404 
405   /// @notice an account must call token.approve(logic, quantity) beforehand
406   function depositToken(uint32 appId, address token, uint quantity) external provisioned(appId) {
407     transferTokensToGluonSecurely(appId, Token(token), quantity);
408     AppLogic(current(appId)).credit(msg.sender, token, quantity);
409   }
410 
411   function transferTokensToGluonSecurely(uint32 appId, Token token, uint quantity) private {
412     uint balanceBefore = token.balanceOf(address(this));
413     require(token.transferFrom(msg.sender, address(this), quantity), "failure to transfer quantity from token");
414     uint balanceAfter = token.balanceOf(address(this));
415     require(balanceAfter.minus(balanceBefore) == quantity, "bad Token; transferFrom erroneously reported of successful transfer");
416     App storage app = apps[appId];
417     app.balances[address(token)] = app.balances[address(token)].plus(quantity);
418   }
419 
420   function withdraw(uint32 appId, bytes calldata parameters) external provisioned(appId) {
421     (address asset, uint quantity) = AppLogic(current(appId)).debit(msg.sender, parameters);
422     if (quantity > 0) {
423       App storage app = apps[appId];
424       require(app.balances[asset] >= quantity, "not enough funds to transfer");
425       app.balances[asset] = apps[appId].balances[asset].minus(quantity);
426       asset == ETH ?
427         require(address(uint160(msg.sender)).send(quantity), "failed to transfer ether") : // explicit casting to `address payable`
428         transferTokensToAccountSecurely(Token(asset), quantity, msg.sender);
429     }
430   }
431 
432   function transferTokensToAccountSecurely(Token token, uint quantity, address to) private {
433     uint balanceBefore = token.balanceOf(to);
434     require(token.transfer(to, quantity), "failure to transfer quantity from token");
435     uint balanceAfter = token.balanceOf(to);
436     require(balanceAfter.minus(balanceBefore) == quantity, "bad Token; transferFrom erroneously reported of successful transfer");
437   }
438 
439   function transfer(uint32 from, uint32 to, bytes calldata parameters) external provisioned(from) provisioned(to) {
440     (address asset, uint quantity) = AppLogic(current(from)).debit(msg.sender, parameters);
441     if (quantity > 0) {
442       if (from != to) {
443         require(apps[from].balances[asset] >= quantity, "not enough balance in logic to transfer");
444         apps[from].balances[asset] = apps[from].balances[asset].minus(quantity);
445         apps[to].balances[asset] = apps[to].balances[asset].plus(quantity);
446       }
447       AppLogic(current(to)).credit(msg.sender, asset, quantity);
448     }
449   }
450 
451   /**************************************************** GluonView  ****************************************************/
452 
453   function app(uint32 appId) external view returns (address current, address proposal, uint activationBlock) {
454     App memory app_ = apps[appId];
455     current = app_.history[app_.history.length - 1];
456     proposal = app_.proposal;
457     activationBlock = app_.activationBlock;
458   }
459 
460   function current(uint32 appId) public view returns (address) { return apps[appId].history[apps[appId].history.length - 1]; }
461 
462   function history(uint32 appId) external view returns (address[] memory) { return apps[appId].history; }
463 
464   function isAnyLogic(uint32 appId, address logic) public view returns (bool) {
465     address[] memory history_ = apps[appId].history;
466     for (uint i = history_.length; i > 0; i--) {
467       if (history_[i - 1] == logic) return true;
468     }
469     return false;
470   }
471 
472   function getBalance(uint32 appId, address asset) external view returns (uint) { return apps[appId].balances[asset]; }
473 
474 }