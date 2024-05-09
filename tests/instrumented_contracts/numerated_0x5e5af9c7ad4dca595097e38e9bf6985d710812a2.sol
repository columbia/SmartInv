1 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.4.24;
4 
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12   address public owner;
13 
14 
15   event OwnershipRenounced(address indexed previousOwner);
16   event OwnershipTransferred(
17     address indexed previousOwner,
18     address indexed newOwner
19   );
20 
21 
22   /**
23    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24    * account.
25    */
26   constructor() public {
27     owner = msg.sender;
28   }
29 
30   /**
31    * @dev Throws if called by any account other than the owner.
32    */
33   modifier onlyOwner() {
34     require(msg.sender == owner);
35     _;
36   }
37 
38   /**
39    * @dev Allows the current owner to relinquish control of the contract.
40    * @notice Renouncing to ownership will leave the contract without an owner.
41    * It will not be possible to call the functions with the `onlyOwner`
42    * modifier anymore.
43    */
44   function renounceOwnership() public onlyOwner {
45     emit OwnershipRenounced(owner);
46     owner = address(0);
47   }
48 
49   /**
50    * @dev Allows the current owner to transfer control of the contract to a newOwner.
51    * @param _newOwner The address to transfer ownership to.
52    */
53   function transferOwnership(address _newOwner) public onlyOwner {
54     _transferOwnership(_newOwner);
55   }
56 
57   /**
58    * @dev Transfers control of the contract to a newOwner.
59    * @param _newOwner The address to transfer ownership to.
60    */
61   function _transferOwnership(address _newOwner) internal {
62     require(_newOwner != address(0));
63     emit OwnershipTransferred(owner, _newOwner);
64     owner = _newOwner;
65   }
66 }
67 
68 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
69 
70 pragma solidity ^0.4.24;
71 
72 
73 /**
74  * @title ERC20Basic
75  * @dev Simpler version of ERC20 interface
76  * See https://github.com/ethereum/EIPs/issues/179
77  */
78 contract ERC20Basic {
79   function totalSupply() public view returns (uint256);
80   function balanceOf(address _who) public view returns (uint256);
81   function transfer(address _to, uint256 _value) public returns (bool);
82   event Transfer(address indexed from, address indexed to, uint256 value);
83 }
84 
85 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
86 
87 pragma solidity ^0.4.24;
88 
89 
90 
91 /**
92  * @title ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/20
94  */
95 contract ERC20 is ERC20Basic {
96   function allowance(address _owner, address _spender)
97     public view returns (uint256);
98 
99   function transferFrom(address _from, address _to, uint256 _value)
100     public returns (bool);
101 
102   function approve(address _spender, uint256 _value) public returns (bool);
103   event Approval(
104     address indexed owner,
105     address indexed spender,
106     uint256 value
107   );
108 }
109 
110 // File: zeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
111 
112 pragma solidity ^0.4.24;
113 
114 
115 
116 /**
117  * @title DetailedERC20 token
118  * @dev The decimals are only for visualization purposes.
119  * All the operations are done using the smallest and indivisible token unit,
120  * just as on Ethereum all the operations are done in wei.
121  */
122 contract DetailedERC20 is ERC20 {
123   string public name;
124   string public symbol;
125   uint8 public decimals;
126 
127   constructor(string _name, string _symbol, uint8 _decimals) public {
128     name = _name;
129     symbol = _symbol;
130     decimals = _decimals;
131   }
132 }
133 
134 // File: contracts/RegulatorServiceI.sol
135 
136 /**
137    Copyright (c) 2017 Harbor Platform, Inc.
138 
139    Licensed under the Apache License, Version 2.0 (the “License”);
140    you may not use this file except in compliance with the License.
141    You may obtain a copy of the License at
142 
143    http://www.apache.org/licenses/LICENSE-2.0
144 
145    Unless required by applicable law or agreed to in writing, software
146    distributed under the License is distributed on an “AS IS” BASIS,
147    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
148    See the License for the specific language governing permissions and
149    limitations under the License.
150 */
151 
152 pragma solidity ^0.4.24;
153 
154 /// @notice Standard interface for `RegulatorService`s
155 contract RegulatorServiceI {
156 
157   /*
158    * @notice This method *MUST* be called by `RegulatedToken`s during `transfer()` and `transferFrom()`.
159    *         The implementation *SHOULD* check whether or not a transfer can be approved.
160    *
161    * @dev    This method *MAY* call back to the token contract specified by `_token` for
162    *         more information needed to enforce trade approval.
163    *
164    * @param  _token The address of the token to be transfered
165    * @param  _spender The address of the spender of the token
166    * @param  _from The address of the sender account
167    * @param  _to The address of the receiver account
168    * @param  _amount The quantity of the token to trade
169    *
170    * @return uint8 The reason code: 0 means success.  Non-zero values are left to the implementation
171    *               to assign meaning.
172    */
173   function check(address _token, address _spender, address _from, address _to, uint256 _amount) public returns (uint8);
174 }
175 
176 // File: contracts/RegulatorService.sol
177 
178 pragma solidity ^0.4.18;
179 
180 
181 
182 
183 /**
184  * @title  On-chain RegulatorService implementation for approving trades
185  * @author Originally Bob Remeika, modified by TokenSoft Inc
186  * @dev Orignal source: https://github.com/harborhq/r-token/blob/master/contracts/TokenRegulatorService.sol
187  */
188 contract RegulatorService is RegulatorServiceI, Ownable {
189   /**
190    * @dev Throws if called by any account other than the admin
191    */
192   modifier onlyAdmins() {
193     require(msg.sender == admin || msg.sender == owner);
194     _;
195   }
196 
197   /// @dev Settings that affect token trading at a global level
198   struct Settings {
199 
200     /**
201      * @dev Toggle for locking/unlocking trades at a token level.
202      *      The default behavior of the zero memory state for locking will be unlocked.
203      */
204     bool locked;
205 
206     /**
207      * @dev Toggle for allowing/disallowing fractional token trades at a token level.
208      *      The default state when this contract is created `false` (or no partial
209      *      transfers allowed).
210      */
211     bool partialTransfers;
212 
213     /**
214      * @dev Mappning for 12 months hold up period for investors.
215      * @param  address investors wallet
216      * @param  uint256 holdingPeriod start date in unix
217      */
218     mapping(address => uint256) holdingPeriod;
219   }
220 
221   // @dev number of seconds in a year = 365 * 24 * 60 * 60
222   uint256 constant private YEAR = 1 years;
223 
224   // @dev Check success code & message
225   uint8 constant private CHECK_SUCCESS = 0;
226   string constant private SUCCESS_MESSAGE = 'Success';
227 
228   // @dev Check error reason: Token is locked
229   uint8 constant private CHECK_ELOCKED = 1;
230   string constant private ELOCKED_MESSAGE = 'Token is locked';
231 
232   // @dev Check error reason: Token can not trade partial amounts
233   uint8 constant private CHECK_EDIVIS = 2;
234   string constant private EDIVIS_MESSAGE = 'Token can not trade partial amounts';
235 
236   // @dev Check error reason: Sender is not allowed to send the token
237   uint8 constant private CHECK_ESEND = 3;
238   string constant private ESEND_MESSAGE = 'Sender is not allowed to send the token';
239 
240   // @dev Check error reason: Receiver is not allowed to receive the token
241   uint8 constant private CHECK_ERECV = 4;
242   string constant private ERECV_MESSAGE = 'Receiver is not allowed to receive the token';
243 
244   uint8 constant private CHECK_EHOLDING_PERIOD = 5;
245   string constant private EHOLDING_PERIOD_MESSAGE = 'Sender is still in 12 months holding period';
246 
247   uint8 constant private CHECK_EDECIMALS = 6;
248   string constant private EDECIMALS_MESSAGE = 'Transfer value must be bigger than MINIMAL_TRANSFER';
249 
250   uint256 constant public MINIMAL_TRANSFER = 1 wei;
251 
252   /// @dev Permission bits for allowing a participant to send tokens
253   uint8 constant private PERM_SEND = 0x1;
254 
255   /// @dev Permission bits for allowing a participant to receive tokens
256   uint8 constant private PERM_RECEIVE = 0x2;
257 
258   // @dev Address of the administrator
259   address public admin;
260 
261   /// @notice Permissions that allow/disallow token trades on a per token level
262   mapping(address => Settings) private settings;
263 
264   /// @dev Permissions that allow/disallow token trades on a per participant basis.
265   ///      The format for key based access is `participants[tokenAddress][participantAddress]`
266   ///      which returns the permission bits of a participant for a particular token.
267   mapping(address => mapping(address => uint8)) private participants;
268 
269   /// @dev Event raised when a token's locked setting is set
270   event LogLockSet(address indexed token, bool locked);
271 
272   /// @dev Event raised when a token's partial transfer setting is set
273   event LogPartialTransferSet(address indexed token, bool enabled);
274 
275   /// @dev Event raised when a participant permissions are set for a token
276   event LogPermissionSet(address indexed token, address indexed participant, uint8 permission);
277 
278   /// @dev Event raised when the admin address changes
279   event LogTransferAdmin(address indexed oldAdmin, address indexed newAdmin);
280 
281   /// @dev Event raised when holding period start date is set for participant
282   event LogHoldingPeriod(
283     address indexed _token, address indexed _participant, uint256 _startDate);
284 
285   constructor() public {
286     admin = msg.sender;
287   }
288 
289   /**
290    * @notice Locks the ability to trade a token
291    *
292    * @dev    This method can only be called by this contract's owner
293    *
294    * @param  _token The address of the token to lock
295    */
296   function setLocked(address _token, bool _locked) onlyOwner public {
297     settings[_token].locked = _locked;
298 
299     emit LogLockSet(_token, _locked);
300   }
301 
302   /**
303    * @notice Allows the ability to trade a fraction of a token
304    *
305    * @dev    This method can only be called by this contract's owner
306    *
307    * @param  _token The address of the token to allow partial transfers
308    */
309   function setPartialTransfers(address _token, bool _enabled) onlyOwner public {
310    settings[_token].partialTransfers = _enabled;
311 
312    emit LogPartialTransferSet(_token, _enabled);
313   }
314 
315   /**
316    * @notice Sets the trade permissions for a participant on a token
317    *
318    * @dev    The `_permission` bits overwrite the previous trade permissions and can
319    *         only be called by the contract's owner.  `_permissions` can be bitwise
320    *         `|`'d together to allow for more than one permission bit to be set.
321    *
322    * @param  _token The address of the token
323    * @param  _participant The address of the trade participant
324    * @param  _permission Permission bits to be set
325    */
326   function setPermission(address _token, address _participant, uint8 _permission) onlyAdmins public {
327     participants[_token][_participant] = _permission;
328 
329     emit LogPermissionSet(_token, _participant, _permission);
330   }
331 
332   /**
333    * @notice Set initial holding period for investor
334    * @param _token       token address
335    * @param _participant participant address
336    * @param _startDate   start date of holding period in UNIX format
337    */
338   function setHoldingPeriod(address _token, address _participant, uint256 _startDate) onlyAdmins public {
339     settings[_token].holdingPeriod[_participant] = _startDate;
340 
341     emit LogHoldingPeriod(_token, _participant, _startDate);
342   }
343 
344   /**
345    * @dev Allows the owner to transfer admin controls to newAdmin.
346    *
347    * @param newAdmin The address to transfer admin rights to.
348    */
349   function transferAdmin(address newAdmin) onlyOwner public {
350     require(newAdmin != address(0));
351 
352     address oldAdmin = admin;
353     admin = newAdmin;
354 
355     emit LogTransferAdmin(oldAdmin, newAdmin);
356   }
357 
358   /**
359    * @notice Checks whether or not a trade should be approved
360    *
361    * @dev    This method calls back to the token contract specified by `_token` for
362    *         information needed to enforce trade approval if needed
363    *
364    * @param  _token The address of the token to be transfered
365    * @param  _spender The address of the spender of the token (unused in this implementation)
366    * @param  _from The address of the sender account
367    * @param  _to The address of the receiver account
368    * @param  _amount The quantity of the token to trade
369    *
370    * @return `true` if the trade should be approved and `false` if the trade should not be approved
371    */
372   function check(address _token, address _spender, address _from, address _to, uint256 _amount) public returns (uint8) {
373     if (settings[_token].locked) {
374       return CHECK_ELOCKED;
375     }
376 
377     if (participants[_token][_from] & PERM_SEND == 0) {
378       return CHECK_ESEND;
379     }
380 
381     if (participants[_token][_to] & PERM_RECEIVE == 0) {
382       return CHECK_ERECV;
383     }
384 
385     if (!settings[_token].partialTransfers && _amount % _wholeToken(_token) != 0) {
386       return CHECK_EDIVIS;
387     }
388 
389     if (settings[_token].holdingPeriod[_from] + YEAR >= now) {
390       return CHECK_EHOLDING_PERIOD;
391     }
392 
393     if (_amount < MINIMAL_TRANSFER) {
394       return CHECK_EDECIMALS;
395     }
396 
397     return CHECK_SUCCESS;
398   }
399 
400   /**
401    * @notice Returns the error message for a passed failed check reason
402    *
403    * @param  _reason The reason code: 0 means success.  Non-zero values are left to the implementation
404    *                 to assign meaning.
405    *
406    * @return The human-readable mesage string
407    */
408   function messageForReason (uint8 _reason) public pure returns (string) {
409     if (_reason == CHECK_ELOCKED) {
410       return ELOCKED_MESSAGE;
411     }
412     
413     if (_reason == CHECK_ESEND) {
414       return ESEND_MESSAGE;
415     }
416 
417     if (_reason == CHECK_ERECV) {
418       return ERECV_MESSAGE;
419     }
420 
421     if (_reason == CHECK_EDIVIS) {
422       return EDIVIS_MESSAGE;
423     }
424 
425     if (_reason == CHECK_EHOLDING_PERIOD) {
426       return EHOLDING_PERIOD_MESSAGE;
427     }
428 
429     if (_reason == CHECK_EDECIMALS) {
430       return EDECIMALS_MESSAGE;
431     }
432 
433     return SUCCESS_MESSAGE;
434   }
435 
436   /**
437    * @notice Retrieves the whole token value from a token that this `RegulatorService` manages
438    *
439    * @param  _token The token address of the managed token
440    *
441    * @return The uint256 value that represents a single whole token
442    */
443   function _wholeToken(address _token) view private returns (uint256) {
444     return uint256(10)**DetailedERC20(_token).decimals();
445   }
446 }