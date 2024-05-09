1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @notice Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @notice Multiplies two numbers, throws on overflow.
12   * @param a Multiplier
13   * @param b Multiplicand
14   * @return {"result" : "Returns product"}
15   */
16   function mul(uint256 a, uint256 b) internal pure returns (uint256 result) {
17     if (a == 0) {
18       return 0;
19     }
20     uint256 c = a * b;
21     require(c / a == b, "Error: Unsafe multiplication operation!");
22     return c;
23   }
24 
25   /**
26   * @notice Integer division of two numbers, truncating the quotient.
27   * @param a Dividend
28   * @param b Divisor
29   * @return {"result" : "Returns quotient"}
30   */
31   function div(uint256 a, uint256 b) internal pure returns (uint256 result) {
32     // @dev require(b > 0); // Solidity automatically throws when dividing by 0
33     uint256 c = a / b;
34     // @dev require(a == b * c + a % b); // There is no case in which this doesn't hold
35     return c;
36   }
37 
38   /**
39   * @notice Subtracts two numbers, throws on underflow.
40   * @param a Subtrahend
41   * @param b Minuend
42   * @return {"result" : "Returns difference"}
43   */
44   function sub(uint256 a, uint256 b) internal pure returns (uint256 result) {
45     // @dev throws on overflow (i.e. if subtrahend is greater than minuend)
46     require(b <= a, "Error: Unsafe subtraction operation!");
47     return a - b;
48   }
49 
50   /**
51   * @notice Adds two numbers, throws on overflow.
52   * @param a First addend
53   * @param b Second addend
54   * @return {"result" : "Returns summation"}
55   */
56   function add(uint256 a, uint256 b) internal pure returns (uint256 result) {
57     uint256 c = a + b;
58     require(c >= a, "Error: Unsafe addition operation!");
59     return c;
60   }
61 }
62 
63 
64 /**
65 
66 COPYRIGHT 2018 Token, Inc.
67 
68 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
69 INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
70 PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
71 COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
72 IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
73 WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
74 
75 
76 @title Ownable
77 @dev The Ownable contract has an owner address, and provides basic authorization control
78 functions, this simplifies the implementation of "user permissions".
79 
80 
81  */
82 contract Ownable {
83 
84   mapping(address => bool) public owner;
85 
86   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
87   event AllowOwnership(address indexed allowedAddress);
88   event RevokeOwnership(address indexed allowedAddress);
89 
90   /**
91    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
92    * account.
93    */
94   constructor() public {
95     owner[msg.sender] = true;
96   }
97 
98   /**
99    * @dev Throws if called by any account other than the owner.
100    */
101   modifier onlyOwner() {
102     require(owner[msg.sender], "Error: Transaction sender is not allowed by the contract.");
103     _;
104   }
105 
106   /**
107    * @dev Allows the current owner to transfer control of the contract to a newOwner.
108    * @param newOwner The address to transfer ownership to.
109    * @return {"success" : "Returns true when successfully transferred ownership"}
110    */
111   function transferOwnership(address newOwner) public onlyOwner returns (bool success) {
112     require(newOwner != address(0), "Error: newOwner cannot be null!");
113     emit OwnershipTransferred(msg.sender, newOwner);
114     owner[newOwner] = true;
115     owner[msg.sender] = false;
116     return true;
117   }
118 
119   /**
120    * @dev Allows interface contracts and accounts to access contract methods (e.g. Storage contract)
121    * @param allowedAddress The address of new owner
122    * @return {"success" : "Returns true when successfully allowed ownership"}
123    */
124   function allowOwnership(address allowedAddress) public onlyOwner returns (bool success) {
125     owner[allowedAddress] = true;
126     emit AllowOwnership(allowedAddress);
127     return true;
128   }
129 
130   /**
131    * @dev Disallows interface contracts and accounts to access contract methods (e.g. Storage contract)
132    * @param allowedAddress The address to disallow ownership
133    * @return {"success" : "Returns true when successfully allowed ownership"}
134    */
135   function removeOwnership(address allowedAddress) public onlyOwner returns (bool success) {
136     owner[allowedAddress] = false;
137     emit RevokeOwnership(allowedAddress);
138     return true;
139   }
140 
141 }
142 
143 /**
144 
145 COPYRIGHT 2018 Token, Inc.
146 
147 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
148 INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
149 PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
150 COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
151 IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
152 WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
153 
154 
155 @title TokenIOStorage - Serves as derived contract for TokenIO contract and
156 is used to upgrade interfaces in the event of deprecating the main contract.
157 
158 @author Ryan Tate <ryan.tate@token.io>, Sean Pollock <sean.pollock@token.io>
159 
160 @notice Storage contract
161 
162 @dev In the event that the main contract becomes deprecated, the upgraded contract
163 will be set as the owner of this contract, and use this contract's storage to
164 maintain data consistency between contract.
165 
166 @notice NOTE: This contract is based on the RocketPool Storage Contract,
167 found here: https://github.com/rocket-pool/rocketpool/blob/master/contracts/RocketStorage.sol
168 And this medium article: https://medium.com/rocket-pool/upgradable-solidity-contract-design-54789205276d
169 
170 Changes:
171  - setting primitive mapping view to internal;
172  - setting method views to public;
173 
174  @dev NOTE: When deprecating the main TokenIO contract, the upgraded contract
175  must take ownership of the TokenIO contract, it will require using the public methods
176  to update changes to the underlying data. The updated contract must use a
177  standard call to original TokenIO contract such that the  request is made from
178  the upgraded contract and not the transaction origin (tx.origin) of the signing
179  account.
180 
181 
182  @dev NOTE: The reasoning for using the storage contract is to abstract the interface
183  from the data of the contract on chain, limiting the need to migrate data to
184  new contracts.
185 
186 */
187 contract TokenIOStorage is Ownable {
188 
189 
190     /// @dev mapping for Primitive Data Types;
191 		/// @notice primitive data mappings have `internal` view;
192 		/// @dev only the derived contract can use the internal methods;
193 		/// @dev key == `keccak256(param1, param2...)`
194 		/// @dev Nested mapping can be achieved using multiple params in keccak256 hash;
195     mapping(bytes32 => uint256)    internal uIntStorage;
196     mapping(bytes32 => string)     internal stringStorage;
197     mapping(bytes32 => address)    internal addressStorage;
198     mapping(bytes32 => bytes)      internal bytesStorage;
199     mapping(bytes32 => bool)       internal boolStorage;
200     mapping(bytes32 => int256)     internal intStorage;
201 
202     constructor() public {
203 				/// @notice owner is set to msg.sender by default
204 				/// @dev consider removing in favor of setting ownership in inherited
205 				/// contract
206         owner[msg.sender] = true;
207     }
208 
209     /// @dev Set Key Methods
210 
211     /**
212      * @notice Set value for Address associated with bytes32 id key
213      * @param _key Pointer identifier for value in storage
214      * @param _value The Address value to be set
215      * @return { "success" : "Returns true when successfully called from another contract" }
216      */
217     function setAddress(bytes32 _key, address _value) public onlyOwner returns (bool success) {
218         addressStorage[_key] = _value;
219         return true;
220     }
221 
222     /**
223      * @notice Set value for Uint associated with bytes32 id key
224      * @param _key Pointer identifier for value in storage
225      * @param _value The Uint value to be set
226      * @return { "success" : "Returns true when successfully called from another contract" }
227      */
228     function setUint(bytes32 _key, uint _value) public onlyOwner returns (bool success) {
229         uIntStorage[_key] = _value;
230         return true;
231     }
232 
233     /**
234      * @notice Set value for String associated with bytes32 id key
235      * @param _key Pointer identifier for value in storage
236      * @param _value The String value to be set
237      * @return { "success" : "Returns true when successfully called from another contract" }
238      */
239     function setString(bytes32 _key, string _value) public onlyOwner returns (bool success) {
240         stringStorage[_key] = _value;
241         return true;
242     }
243 
244     /**
245      * @notice Set value for Bytes associated with bytes32 id key
246      * @param _key Pointer identifier for value in storage
247      * @param _value The Bytes value to be set
248      * @return { "success" : "Returns true when successfully called from another contract" }
249      */
250     function setBytes(bytes32 _key, bytes _value) public onlyOwner returns (bool success) {
251         bytesStorage[_key] = _value;
252         return true;
253     }
254 
255     /**
256      * @notice Set value for Bool associated with bytes32 id key
257      * @param _key Pointer identifier for value in storage
258      * @param _value The Bool value to be set
259      * @return { "success" : "Returns true when successfully called from another contract" }
260      */
261     function setBool(bytes32 _key, bool _value) public onlyOwner returns (bool success) {
262         boolStorage[_key] = _value;
263         return true;
264     }
265 
266     /**
267      * @notice Set value for Int associated with bytes32 id key
268      * @param _key Pointer identifier for value in storage
269      * @param _value The Int value to be set
270      * @return { "success" : "Returns true when successfully called from another contract" }
271      */
272     function setInt(bytes32 _key, int _value) public onlyOwner returns (bool success) {
273         intStorage[_key] = _value;
274         return true;
275     }
276 
277     /// @dev Delete Key Methods
278 		/// @dev delete methods may be unnecessary; Use set methods to set values
279 		/// to default?
280 
281     /**
282      * @notice Delete value for Address associated with bytes32 id key
283      * @param _key Pointer identifier for value in storage
284      * @return { "success" : "Returns true when successfully called from another contract" }
285      */
286     function deleteAddress(bytes32 _key) public onlyOwner returns (bool success) {
287         delete addressStorage[_key];
288         return true;
289     }
290 
291     /**
292      * @notice Delete value for Uint associated with bytes32 id key
293      * @param _key Pointer identifier for value in storage
294      * @return { "success" : "Returns true when successfully called from another contract" }
295      */
296     function deleteUint(bytes32 _key) public onlyOwner returns (bool success) {
297         delete uIntStorage[_key];
298         return true;
299     }
300 
301     /**
302      * @notice Delete value for String associated with bytes32 id key
303      * @param _key Pointer identifier for value in storage
304      * @return { "success" : "Returns true when successfully called from another contract" }
305      */
306     function deleteString(bytes32 _key) public onlyOwner returns (bool success) {
307         delete stringStorage[_key];
308         return true;
309     }
310 
311     /**
312      * @notice Delete value for Bytes associated with bytes32 id key
313      * @param _key Pointer identifier for value in storage
314      * @return { "success" : "Returns true when successfully called from another contract" }
315      */
316     function deleteBytes(bytes32 _key) public onlyOwner returns (bool success) {
317         delete bytesStorage[_key];
318         return true;
319     }
320 
321     /**
322      * @notice Delete value for Bool associated with bytes32 id key
323      * @param _key Pointer identifier for value in storage
324      * @return { "success" : "Returns true when successfully called from another contract" }
325      */
326     function deleteBool(bytes32 _key) public onlyOwner returns (bool success) {
327         delete boolStorage[_key];
328         return true;
329     }
330 
331     /**
332      * @notice Delete value for Int associated with bytes32 id key
333      * @param _key Pointer identifier for value in storage
334      * @return { "success" : "Returns true when successfully called from another contract" }
335      */
336     function deleteInt(bytes32 _key) public onlyOwner returns (bool success) {
337         delete intStorage[_key];
338         return true;
339     }
340 
341     /// @dev Get Key Methods
342 
343     /**
344      * @notice Get value for Address associated with bytes32 id key
345      * @param _key Pointer identifier for value in storage
346      * @return { "_value" : "Returns the Address value associated with the id key" }
347      */
348     function getAddress(bytes32 _key) public view returns (address _value) {
349         return addressStorage[_key];
350     }
351 
352     /**
353      * @notice Get value for Uint associated with bytes32 id key
354      * @param _key Pointer identifier for value in storage
355      * @return { "_value" : "Returns the Uint value associated with the id key" }
356      */
357     function getUint(bytes32 _key) public view returns (uint _value) {
358         return uIntStorage[_key];
359     }
360 
361     /**
362      * @notice Get value for String associated with bytes32 id key
363      * @param _key Pointer identifier for value in storage
364      * @return { "_value" : "Returns the String value associated with the id key" }
365      */
366     function getString(bytes32 _key) public view returns (string _value) {
367         return stringStorage[_key];
368     }
369 
370     /**
371      * @notice Get value for Bytes associated with bytes32 id key
372      * @param _key Pointer identifier for value in storage
373      * @return { "_value" : "Returns the Bytes value associated with the id key" }
374      */
375     function getBytes(bytes32 _key) public view returns (bytes _value) {
376         return bytesStorage[_key];
377     }
378 
379     /**
380      * @notice Get value for Bool associated with bytes32 id key
381      * @param _key Pointer identifier for value in storage
382      * @return { "_value" : "Returns the Bool value associated with the id key" }
383      */
384     function getBool(bytes32 _key) public view returns (bool _value) {
385         return boolStorage[_key];
386     }
387 
388     /**
389      * @notice Get value for Int associated with bytes32 id key
390      * @param _key Pointer identifier for value in storage
391      * @return { "_value" : "Returns the Int value associated with the id key" }
392      */
393     function getInt(bytes32 _key) public view returns (int _value) {
394         return intStorage[_key];
395     }
396 
397 }
398 
399 /**
400 COPYRIGHT 2018 Token, Inc.
401 
402 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
403 INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
404 PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
405 COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
406 IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
407 WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
408 
409 
410 @title TokenIOLib
411 
412 @author Ryan Tate <ryan.tate@token.io>, Sean Pollock <sean.pollock@token.io>
413 
414 @notice This library proxies the TokenIOStorage contract for the interface contract,
415 allowing the library and the interfaces to remain stateless, and share a universally
416 available storage contract between interfaces.
417 
418 
419 */
420 
421 
422 library TokenIOLib {
423 
424   /// @dev all math operating are using SafeMath methods to check for overflow/underflows
425   using SafeMath for uint;
426 
427   /// @dev the Data struct uses the Storage contract for stateful setters
428   struct Data {
429     TokenIOStorage Storage;
430   }
431 
432   /// @notice Not using `Log` prefix for events to be consistent with ERC20 named events;
433   event Approval(address indexed owner, address indexed spender, uint amount);
434   event Deposit(string currency, address indexed account, uint amount, string issuerFirm);
435   event Withdraw(string currency, address indexed account, uint amount, string issuerFirm);
436   event Transfer(string currency, address indexed from, address indexed to, uint amount, bytes data);
437   event KYCApproval(address indexed account, bool status, string issuerFirm);
438   event AccountStatus(address indexed account, bool status, string issuerFirm);
439   event FxSwap(string tokenASymbol,string tokenBSymbol,uint tokenAValue,uint tokenBValue, uint expiration, bytes32 transactionHash);
440   event AccountForward(address indexed originalAccount, address indexed forwardedAccount);
441   event NewAuthority(address indexed authority, string issuerFirm);
442 
443   /**
444    * @notice Set the token name for Token interfaces
445    * @dev This method must be set by the token interface's setParams() method
446    * @dev | This method has an `internal` view
447    * @param self Internal storage proxying TokenIOStorage contract
448    * @param tokenName Name of the token contract
449    * @return {"success" : "Returns true when successfully called from another contract"}
450    */
451   function setTokenName(Data storage self, string tokenName) internal returns (bool success) {
452     bytes32 id = keccak256(abi.encodePacked('token.name', address(this)));
453     require(
454       self.Storage.setString(id, tokenName),
455       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract."
456     );
457     return true;
458   }
459 
460   /**
461    * @notice Set the token symbol for Token interfaces
462    * @dev This method must be set by the token interface's setParams() method
463    * @dev | This method has an `internal` view
464    * @param self Internal storage proxying TokenIOStorage contract
465    * @param tokenSymbol Symbol of the token contract
466    * @return {"success" : "Returns true when successfully called from another contract"}
467    */
468   function setTokenSymbol(Data storage self, string tokenSymbol) internal returns (bool success) {
469     bytes32 id = keccak256(abi.encodePacked('token.symbol', address(this)));
470     require(
471       self.Storage.setString(id, tokenSymbol),
472       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract."
473     );
474     return true;
475   }
476 
477   /**
478    * @notice Set the token three letter abreviation (TLA) for Token interfaces
479    * @dev This method must be set by the token interface's setParams() method
480    * @dev | This method has an `internal` view
481    * @param self Internal storage proxying TokenIOStorage contract
482    * @param tokenTLA TLA of the token contract
483    * @return {"success" : "Returns true when successfully called from another contract"}
484    */
485   function setTokenTLA(Data storage self, string tokenTLA) internal returns (bool success) {
486     bytes32 id = keccak256(abi.encodePacked('token.tla', address(this)));
487     require(
488       self.Storage.setString(id, tokenTLA),
489       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract."
490     );
491     return true;
492   }
493 
494   /**
495    * @notice Set the token version for Token interfaces
496    * @dev This method must be set by the token interface's setParams() method
497    * @dev | This method has an `internal` view
498    * @param self Internal storage proxying TokenIOStorage contract
499    * @param tokenVersion Semantic (vMAJOR.MINOR.PATCH | e.g. v0.1.0) version of the token contract
500    * @return {"success" : "Returns true when successfully called from another contract"}
501    */
502   function setTokenVersion(Data storage self, string tokenVersion) internal returns (bool success) {
503     bytes32 id = keccak256(abi.encodePacked('token.version', address(this)));
504     require(
505       self.Storage.setString(id, tokenVersion),
506       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract."
507     );
508     return true;
509   }
510 
511   /**
512    * @notice Set the token decimals for Token interfaces
513    * @dev This method must be set by the token interface's setParams() method
514    * @dev | This method has an `internal` view
515    * @dev This method is not set to the address of the contract, rather is maped to currency
516    * @dev To derive decimal value, divide amount by 10^decimal representation (e.g. 10132 / 10**2 == 101.32)
517    * @param self Internal storage proxying TokenIOStorage contract
518    * @param  currency Currency symbol of the token (e.g. USDx, JYPx, GBPx)
519    * @param tokenDecimals Decimal representation of the token contract unit amount
520    * @return {"success" : "Returns true when successfully called from another contract"}
521    */
522   function setTokenDecimals(Data storage self, string currency, uint tokenDecimals) internal returns (bool success) {
523     bytes32 id = keccak256(abi.encodePacked('token.decimals', currency));
524     require(
525       self.Storage.setUint(id, tokenDecimals),
526       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract."
527     );
528     return true;
529   }
530 
531   /**
532    * @notice Set basis point fee for contract interface
533    * @dev Transaction fees can be set by the TokenIOFeeContract
534    * @dev Fees vary by contract interface specified `feeContract`
535    * @dev | This method has an `internal` view
536    * @param self Internal storage proxying TokenIOStorage contract
537    * @param feeBPS Basis points fee for interface contract transactions
538    * @return {"success" : "Returns true when successfully called from another contract"}
539    */
540   function setFeeBPS(Data storage self, uint feeBPS) internal returns (bool success) {
541     bytes32 id = keccak256(abi.encodePacked('fee.bps', address(this)));
542     require(
543       self.Storage.setUint(id, feeBPS),
544       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract."
545     );
546     return true;
547   }
548 
549   /**
550    * @notice Set minimum fee for contract interface
551    * @dev Transaction fees can be set by the TokenIOFeeContract
552    * @dev Fees vary by contract interface specified `feeContract`
553    * @dev | This method has an `internal` view
554    * @param self Internal storage proxying TokenIOStorage contract
555    * @param feeMin Minimum fee for interface contract transactions
556    * @return {"success" : "Returns true when successfully called from another contract"}
557    */
558   function setFeeMin(Data storage self, uint feeMin) internal returns (bool success) {
559     bytes32 id = keccak256(abi.encodePacked('fee.min', address(this)));
560     require(
561       self.Storage.setUint(id, feeMin),
562       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract."
563     );
564     return true;
565   }
566 
567   /**
568    * @notice Set maximum fee for contract interface
569    * @dev Transaction fees can be set by the TokenIOFeeContract
570    * @dev Fees vary by contract interface specified `feeContract`
571    * @dev | This method has an `internal` view
572    * @param self Internal storage proxying TokenIOStorage contract
573    * @param feeMax Maximum fee for interface contract transactions
574    * @return {"success" : "Returns true when successfully called from another contract"}
575    */
576   function setFeeMax(Data storage self, uint feeMax) internal returns (bool success) {
577     bytes32 id = keccak256(abi.encodePacked('fee.max', address(this)));
578     require(
579       self.Storage.setUint(id, feeMax),
580       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract."
581     );
582     return true;
583   }
584 
585   /**
586    * @notice Set flat fee for contract interface
587    * @dev Transaction fees can be set by the TokenIOFeeContract
588    * @dev Fees vary by contract interface specified `feeContract`
589    * @dev | This method has an `internal` view
590    * @param self Internal storage proxying TokenIOStorage contract
591    * @param feeFlat Flat fee for interface contract transactions
592    * @return {"success" : "Returns true when successfully called from another contract"}
593    */
594   function setFeeFlat(Data storage self, uint feeFlat) internal returns (bool success) {
595     bytes32 id = keccak256(abi.encodePacked('fee.flat', address(this)));
596     require(
597       self.Storage.setUint(id, feeFlat),
598       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract."
599     );
600     return true;
601   }
602 
603   /**
604    * @notice Set fee message for contract interface
605    * @dev Default fee messages can be set by the TokenIOFeeContract (e.g. "tx_fees")
606    * @dev Fee messages vary by contract interface specified `feeContract`
607    * @dev | This method has an `internal` view
608    * @param self Internal storage proxying TokenIOStorage contract
609    * @param feeMsg Fee message included in a transaction with fees
610    * @return {"success" : "Returns true when successfully called from another contract"}
611    */
612   function setFeeMsg(Data storage self, bytes feeMsg) internal returns (bool success) {
613     bytes32 id = keccak256(abi.encodePacked('fee.msg', address(this)));
614     require(
615       self.Storage.setBytes(id, feeMsg),
616       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract."
617     );
618     return true;
619   }
620 
621   /**
622    * @notice Set fee contract for a contract interface
623    * @dev feeContract must be a TokenIOFeeContract storage approved contract
624    * @dev Fees vary by contract interface specified `feeContract`
625    * @dev | This method has an `internal` view
626    * @dev | This must be called directly from the interface contract
627    * @param self Internal storage proxying TokenIOStorage contract
628    * @param feeContract Set the fee contract for `this` contract address interface
629    * @return {"success" : "Returns true when successfully called from another contract"}
630    */
631   function setFeeContract(Data storage self, address feeContract) internal returns (bool success) {
632     bytes32 id = keccak256(abi.encodePacked('fee.account', address(this)));
633     require(
634       self.Storage.setAddress(id, feeContract),
635       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract."
636     );
637     return true;
638   }
639 
640   /**
641    * @notice Set contract interface associated with a given TokenIO currency symbol (e.g. USDx)
642    * @dev | This should only be called once from a token interface contract;
643    * @dev | This method has an `internal` view
644    * @dev | This method is experimental and may be deprecated/refactored
645    * @param self Internal storage proxying TokenIOStorage contract
646    * @param  currency Currency symbol of the token (e.g. USDx, JYPx, GBPx)
647    * @return {"success" : "Returns true when successfully called from another contract"}
648    */
649   function setTokenNameSpace(Data storage self, string currency) internal returns (bool success) {
650     bytes32 id = keccak256(abi.encodePacked('token.namespace', currency));
651     require(
652       self.Storage.setAddress(id, address(this)),
653       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract."
654     );
655     return true;
656   }
657 
658   /**
659    * @notice Set the KYC approval status (true/false) for a given account
660    * @dev | This method has an `internal` view
661    * @dev | Every account must be KYC'd to be able to use transfer() & transferFrom() methods
662    * @dev | To gain approval for an account, register at https://tsm.token.io/sign-up
663    * @param self Internal storage proxying TokenIOStorage contract
664    * @param account Ethereum address of account holder
665    * @param isApproved Boolean (true/false) KYC approval status for a given account
666    * @param issuerFirm Firm name for issuing KYC approval
667    * @return {"success" : "Returns true when successfully called from another contract"}
668    */
669   function setKYCApproval(Data storage self, address account, bool isApproved, string issuerFirm) internal returns (bool success) {
670       bytes32 id = keccak256(abi.encodePacked('account.kyc', getForwardedAccount(self, account)));
671       require(
672         self.Storage.setBool(id, isApproved),
673         "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract."
674       );
675 
676       /// @dev NOTE: Issuer is logged for setting account KYC status
677       emit KYCApproval(account, isApproved, issuerFirm);
678       return true;
679   }
680 
681   /**
682    * @notice Set the global approval status (true/false) for a given account
683    * @dev | This method has an `internal` view
684    * @dev | Every account must be permitted to be able to use transfer() & transferFrom() methods
685    * @dev | To gain approval for an account, register at https://tsm.token.io/sign-up
686    * @param self Internal storage proxying TokenIOStorage contract
687    * @param account Ethereum address of account holder
688    * @param isAllowed Boolean (true/false) global status for a given account
689    * @param issuerFirm Firm name for issuing approval
690    * @return {"success" : "Returns true when successfully called from another contract"}
691    */
692   function setAccountStatus(Data storage self, address account, bool isAllowed, string issuerFirm) internal returns (bool success) {
693     bytes32 id = keccak256(abi.encodePacked('account.allowed', getForwardedAccount(self, account)));
694     require(
695       self.Storage.setBool(id, isAllowed),
696       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract."
697     );
698 
699     /// @dev NOTE: Issuer is logged for setting account status
700     emit AccountStatus(account, isAllowed, issuerFirm);
701     return true;
702   }
703 
704 
705   /**
706    * @notice Set a forwarded address for an account.
707    * @dev | This method has an `internal` view
708    * @dev | Forwarded accounts must be set by an authority in case of account recovery;
709    * @dev | Additionally, the original owner can set a forwarded account (e.g. add a new device, spouse, dependent, etc)
710    * @dev | All transactions will be logged under the same KYC information as the original account holder;
711    * @param self Internal storage proxying TokenIOStorage contract
712    * @param originalAccount Original registered Ethereum address of the account holder
713    * @param forwardedAccount Forwarded Ethereum address of the account holder
714    * @return {"success" : "Returns true when successfully called from another contract"}
715    */
716   function setForwardedAccount(Data storage self, address originalAccount, address forwardedAccount) internal returns (bool success) {
717     bytes32 id = keccak256(abi.encodePacked('master.account', forwardedAccount));
718     require(
719       self.Storage.setAddress(id, originalAccount),
720       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract."
721     );
722     return true;
723   }
724 
725   /**
726    * @notice Get the original address for a forwarded account
727    * @dev | This method has an `internal` view
728    * @dev | Will return the registered account for the given forwarded account
729    * @param self Internal storage proxying TokenIOStorage contract
730    * @param account Ethereum address of account holder
731    * @return { "registeredAccount" : "Will return the original account of a forwarded account or the account itself if no account found"}
732    */
733   function getForwardedAccount(Data storage self, address account) internal view returns (address registeredAccount) {
734     bytes32 id = keccak256(abi.encodePacked('master.account', account));
735     address originalAccount = self.Storage.getAddress(id);
736     if (originalAccount != 0x0) {
737       return originalAccount;
738     } else {
739       return account;
740     }
741   }
742 
743   /**
744    * @notice Get KYC approval status for the account holder
745    * @dev | This method has an `internal` view
746    * @dev | All forwarded accounts will use the original account's status
747    * @param self Internal storage proxying TokenIOStorage contract
748    * @param account Ethereum address of account holder
749    * @return { "status" : "Returns the KYC approval status for an account holder" }
750    */
751   function getKYCApproval(Data storage self, address account) internal view returns (bool status) {
752       bytes32 id = keccak256(abi.encodePacked('account.kyc', getForwardedAccount(self, account)));
753       return self.Storage.getBool(id);
754   }
755 
756   /**
757    * @notice Get global approval status for the account holder
758    * @dev | This method has an `internal` view
759    * @dev | All forwarded accounts will use the original account's status
760    * @param self Internal storage proxying TokenIOStorage contract
761    * @param account Ethereum address of account holder
762    * @return { "status" : "Returns the global approval status for an account holder" }
763    */
764   function getAccountStatus(Data storage self, address account) internal view returns (bool status) {
765     bytes32 id = keccak256(abi.encodePacked('account.allowed', getForwardedAccount(self, account)));
766     return self.Storage.getBool(id);
767   }
768 
769   /**
770    * @notice Get the contract interface address associated with token symbol
771    * @dev | This method has an `internal` view
772    * @param self Internal storage proxying TokenIOStorage contract
773    * @param  currency Currency symbol of the token (e.g. USDx, JYPx, GBPx)
774    * @return { "contractAddress" : "Returns the contract interface address for a symbol" }
775    */
776   function getTokenNameSpace(Data storage self, string currency) internal view returns (address contractAddress) {
777     bytes32 id = keccak256(abi.encodePacked('token.namespace', currency));
778     return self.Storage.getAddress(id);
779   }
780 
781   /**
782    * @notice Get the token name for Token interfaces
783    * @dev This method must be set by the token interface's setParams() method
784    * @dev | This method has an `internal` view
785    * @param self Internal storage proxying TokenIOStorage contract
786    * @param contractAddress Contract address of the queryable interface
787    * @return {"tokenName" : "Name of the token contract"}
788    */
789   function getTokenName(Data storage self, address contractAddress) internal view returns (string tokenName) {
790     bytes32 id = keccak256(abi.encodePacked('token.name', contractAddress));
791     return self.Storage.getString(id);
792   }
793 
794   /**
795    * @notice Get the token symbol for Token interfaces
796    * @dev This method must be set by the token interface's setParams() method
797    * @dev | This method has an `internal` view
798    * @param self Internal storage proxying TokenIOStorage contract
799    * @param contractAddress Contract address of the queryable interface
800    * @return {"tokenSymbol" : "Symbol of the token contract"}
801    */
802   function getTokenSymbol(Data storage self, address contractAddress) internal view returns (string tokenSymbol) {
803     bytes32 id = keccak256(abi.encodePacked('token.symbol', contractAddress));
804     return self.Storage.getString(id);
805   }
806 
807   /**
808    * @notice Get the token Three letter abbreviation (TLA) for Token interfaces
809    * @dev This method must be set by the token interface's setParams() method
810    * @dev | This method has an `internal` view
811    * @param self Internal storage proxying TokenIOStorage contract
812    * @param contractAddress Contract address of the queryable interface
813    * @return {"tokenTLA" : "TLA of the token contract"}
814    */
815   function getTokenTLA(Data storage self, address contractAddress) internal view returns (string tokenTLA) {
816     bytes32 id = keccak256(abi.encodePacked('token.tla', contractAddress));
817     return self.Storage.getString(id);
818   }
819 
820   /**
821    * @notice Get the token version for Token interfaces
822    * @dev This method must be set by the token interface's setParams() method
823    * @dev | This method has an `internal` view
824    * @param self Internal storage proxying TokenIOStorage contract
825    * @param contractAddress Contract address of the queryable interface
826    * @return {"tokenVersion" : "Semantic version of the token contract"}
827    */
828   function getTokenVersion(Data storage self, address contractAddress) internal view returns (string) {
829     bytes32 id = keccak256(abi.encodePacked('token.version', contractAddress));
830     return self.Storage.getString(id);
831   }
832 
833   /**
834    * @notice Get the token decimals for Token interfaces
835    * @dev This method must be set by the token interface's setParams() method
836    * @dev | This method has an `internal` view
837    * @param self Internal storage proxying TokenIOStorage contract
838    * @param  currency Currency symbol of the token (e.g. USDx, JYPx, GBPx)
839    * @return {"tokenDecimals" : "Decimals of the token contract"}
840    */
841   function getTokenDecimals(Data storage self, string currency) internal view returns (uint tokenDecimals) {
842     bytes32 id = keccak256(abi.encodePacked('token.decimals', currency));
843     return self.Storage.getUint(id);
844   }
845 
846   /**
847    * @notice Get the basis points fee of the contract address; typically TokenIOFeeContract
848    * @dev | This method has an `internal` view
849    * @param self Internal storage proxying TokenIOStorage contract
850    * @param contractAddress Contract address of the queryable interface
851    * @return { "feeBps" : "Returns the basis points fees associated with the contract address"}
852    */
853   function getFeeBPS(Data storage self, address contractAddress) internal view returns (uint feeBps) {
854     bytes32 id = keccak256(abi.encodePacked('fee.bps', contractAddress));
855     return self.Storage.getUint(id);
856   }
857 
858   /**
859    * @notice Get the minimum fee of the contract address; typically TokenIOFeeContract
860    * @dev | This method has an `internal` view
861    * @param self Internal storage proxying TokenIOStorage contract
862    * @param contractAddress Contract address of the queryable interface
863    * @return { "feeMin" : "Returns the minimum fees associated with the contract address"}
864    */
865   function getFeeMin(Data storage self, address contractAddress) internal view returns (uint feeMin) {
866     bytes32 id = keccak256(abi.encodePacked('fee.min', contractAddress));
867     return self.Storage.getUint(id);
868   }
869 
870   /**
871    * @notice Get the maximum fee of the contract address; typically TokenIOFeeContract
872    * @dev | This method has an `internal` view
873    * @param self Internal storage proxying TokenIOStorage contract
874    * @param contractAddress Contract address of the queryable interface
875    * @return { "feeMax" : "Returns the maximum fees associated with the contract address"}
876    */
877   function getFeeMax(Data storage self, address contractAddress) internal view returns (uint feeMax) {
878     bytes32 id = keccak256(abi.encodePacked('fee.max', contractAddress));
879     return self.Storage.getUint(id);
880   }
881 
882   /**
883    * @notice Get the flat fee of the contract address; typically TokenIOFeeContract
884    * @dev | This method has an `internal` view
885    * @param self Internal storage proxying TokenIOStorage contract
886    * @param contractAddress Contract address of the queryable interface
887    * @return { "feeFlat" : "Returns the flat fees associated with the contract address"}
888    */
889   function getFeeFlat(Data storage self, address contractAddress) internal view returns (uint feeFlat) {
890     bytes32 id = keccak256(abi.encodePacked('fee.flat', contractAddress));
891     return self.Storage.getUint(id);
892   }
893 
894   /**
895    * @notice Get the flat message of the contract address; typically TokenIOFeeContract
896    * @dev | This method has an `internal` view
897    * @param self Internal storage proxying TokenIOStorage contract
898    * @param contractAddress Contract address of the queryable interface
899    * @return { "feeMsg" : "Returns the fee message (bytes) associated with the contract address"}
900    */
901   function getFeeMsg(Data storage self, address contractAddress) internal view returns (bytes feeMsg) {
902     bytes32 id = keccak256(abi.encodePacked('fee.msg', contractAddress));
903     return self.Storage.getBytes(id);
904   }
905 
906   /**
907    * @notice Set the master fee contract used as the default fee contract when none is provided
908    * @dev | This method has an `internal` view
909    * @dev | This value is set in the TokenIOAuthority contract
910    * @param self Internal storage proxying TokenIOStorage contract
911    * @param contractAddress Contract address of the queryable interface
912    * @return { "success" : "Returns true when successfully called from another contract"}
913    */
914   function setMasterFeeContract(Data storage self, address contractAddress) internal returns (bool success) {
915     bytes32 id = keccak256(abi.encodePacked('fee.contract.master'));
916     require(
917       self.Storage.setAddress(id, contractAddress),
918       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract."
919     );
920     return true;
921   }
922 
923   /**
924    * @notice Get the master fee contract set via the TokenIOAuthority contract
925    * @dev | This method has an `internal` view
926    * @param self Internal storage proxying TokenIOStorage contract
927    * @return { "masterFeeContract" : "Returns the master fee contract set for TSM."}
928    */
929   function getMasterFeeContract(Data storage self) internal view returns (address masterFeeContract) {
930     bytes32 id = keccak256(abi.encodePacked('fee.contract.master'));
931     return self.Storage.getAddress(id);
932   }
933 
934   /**
935    * @notice Get the fee contract set for a contract interface
936    * @dev | This method has an `internal` view
937    * @dev | Custom fee pricing can be set by assigning a fee contract to transactional contract interfaces
938    * @dev | If a fee contract has not been set by an interface contract, then the master fee contract will be returned
939    * @param self Internal storage proxying TokenIOStorage contract
940    * @param contractAddress Contract address of the queryable interface
941    * @return { "feeContract" : "Returns the fee contract associated with a contract interface"}
942    */
943   function getFeeContract(Data storage self, address contractAddress) internal view returns (address feeContract) {
944     bytes32 id = keccak256(abi.encodePacked('fee.account', contractAddress));
945 
946     address feeAccount = self.Storage.getAddress(id);
947     if (feeAccount == 0x0) {
948       return getMasterFeeContract(self);
949     } else {
950       return feeAccount;
951     }
952   }
953 
954   /**
955    * @notice Get the token supply for a given TokenIO TSM currency symbol (e.g. USDx)
956    * @dev | This method has an `internal` view
957    * @param self Internal storage proxying TokenIOStorage contract
958    * @param  currency Currency symbol of the token (e.g. USDx, JYPx, GBPx)
959    * @return { "supply" : "Returns the token supply of the given currency"}
960    */
961   function getTokenSupply(Data storage self, string currency) internal view returns (uint supply) {
962     bytes32 id = keccak256(abi.encodePacked('token.supply', currency));
963     return self.Storage.getUint(id);
964   }
965 
966   /**
967    * @notice Get the token spender allowance for a given account
968    * @dev | This method has an `internal` view
969    * @param self Internal storage proxying TokenIOStorage contract
970    * @param account Ethereum address of account holder
971    * @param spender Ethereum address of spender
972    * @return { "allowance" : "Returns the allowance of a given spender for a given account"}
973    */
974   function getTokenAllowance(Data storage self, string currency, address account, address spender) internal view returns (uint allowance) {
975     bytes32 id = keccak256(abi.encodePacked('token.allowance', currency, getForwardedAccount(self, account), getForwardedAccount(self, spender)));
976     return self.Storage.getUint(id);
977   }
978 
979   /**
980    * @notice Get the token balance for a given account
981    * @dev | This method has an `internal` view
982    * @param self Internal storage proxying TokenIOStorage contract
983    * @param  currency Currency symbol of the token (e.g. USDx, JYPx, GBPx)
984    * @param account Ethereum address of account holder
985    * @return { "balance" : "Return the balance of a given account for a specified currency"}
986    */
987   function getTokenBalance(Data storage self, string currency, address account) internal view returns (uint balance) {
988     bytes32 id = keccak256(abi.encodePacked('token.balance', currency, getForwardedAccount(self, account)));
989     return self.Storage.getUint(id);
990   }
991 
992   /**
993    * @notice Get the frozen token balance for a given account
994    * @dev | This method has an `internal` view
995    * @param self Internal storage proxying TokenIOStorage contract
996    * @param  currency Currency symbol of the token (e.g. USDx, JYPx, GBPx)
997    * @param account Ethereum address of account holder
998    * @return { "frozenBalance" : "Return the frozen balance of a given account for a specified currency"}
999    */
1000   function getTokenFrozenBalance(Data storage self, string currency, address account) internal view returns (uint frozenBalance) {
1001     bytes32 id = keccak256(abi.encodePacked('token.frozen', currency, getForwardedAccount(self, account)));
1002     return self.Storage.getUint(id);
1003   }
1004 
1005   /**
1006    * @notice Set the frozen token balance for a given account
1007    * @dev | This method has an `internal` view
1008    * @param self Internal storage proxying TokenIOStorage contract
1009    * @param  currency Currency symbol of the token (e.g. USDx, JYPx, GBPx)
1010    * @param account Ethereum address of account holder
1011    * @param amount Amount of tokens to freeze for account
1012    * @return { "success" : "Return true if successfully called from another contract"}
1013    */
1014   function setTokenFrozenBalance(Data storage self, string currency, address account, uint amount) internal returns (bool success) {
1015     bytes32 id = keccak256(abi.encodePacked('token.frozen', currency, getForwardedAccount(self, account)));
1016     require(
1017       self.Storage.setUint(id, amount),
1018       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract."
1019     );
1020     return true;
1021   }
1022 
1023   /**
1024    * @notice Set the frozen token balance for a given account
1025    * @dev | This method has an `internal` view
1026    * @param self Internal storage proxying TokenIOStorage contract
1027    * @param contractAddress Contract address of the fee contract
1028    * @param amount Transaction value
1029    * @return { "calculatedFees" : "Return the calculated transaction fees for a given amount and fee contract" }
1030    */
1031   function calculateFees(Data storage self, address contractAddress, uint amount) internal view returns (uint calculatedFees) {
1032 
1033     uint maxFee = self.Storage.getUint(keccak256(abi.encodePacked('fee.max', contractAddress)));
1034     uint minFee = self.Storage.getUint(keccak256(abi.encodePacked('fee.min', contractAddress)));
1035     uint bpsFee = self.Storage.getUint(keccak256(abi.encodePacked('fee.bps', contractAddress)));
1036     uint flatFee = self.Storage.getUint(keccak256(abi.encodePacked('fee.flat', contractAddress)));
1037     uint fees = ((amount.mul(bpsFee)).div(10000)).add(flatFee);
1038 
1039     if (fees > maxFee) {
1040       return maxFee;
1041     } else if (fees < minFee) {
1042       return minFee;
1043     } else {
1044       return fees;
1045     }
1046   }
1047 
1048   /**
1049    * @notice Verified KYC and global status for two accounts and return true or throw if either account is not verified
1050    * @dev | This method has an `internal` view
1051    * @param self Internal storage proxying TokenIOStorage contract
1052    * @param accountA Ethereum address of first account holder to verify
1053    * @param accountB Ethereum address of second account holder to verify
1054    * @return { "verified" : "Returns true if both accounts are successfully verified" }
1055    */
1056   function verifyAccounts(Data storage self, address accountA, address accountB) internal view returns (bool verified) {
1057     require(
1058       verifyAccount(self, accountA),
1059       "Error: Account is not verified for operation. Please ensure account has been KYC approved."
1060     );
1061     require(
1062       verifyAccount(self, accountB),
1063       "Error: Account is not verified for operation. Please ensure account has been KYC approved."
1064     );
1065     return true;
1066   }
1067 
1068   /**
1069    * @notice Verified KYC and global status for a single account and return true or throw if account is not verified
1070    * @dev | This method has an `internal` view
1071    * @param self Internal storage proxying TokenIOStorage contract
1072    * @param account Ethereum address of account holder to verify
1073    * @return { "verified" : "Returns true if account is successfully verified" }
1074    */
1075   function verifyAccount(Data storage self, address account) internal view returns (bool verified) {
1076     require(
1077       getKYCApproval(self, account),
1078       "Error: Account does not have KYC approval."
1079     );
1080     require(
1081       getAccountStatus(self, account),
1082       "Error: Account status is `false`. Account status must be `true`."
1083     );
1084     return true;
1085   }
1086 
1087 
1088   /**
1089    * @notice Transfer an amount of currency token from msg.sender account to another specified account
1090    * @dev This function is called by an interface that is accessible directly to the account holder
1091    * @dev | This method has an `internal` view
1092    * @dev | This method uses `forceTransfer()` low-level api
1093    * @param self Internal storage proxying TokenIOStorage contract
1094    * @param  currency Currency symbol of the token (e.g. USDx, JYPx, GBPx)
1095    * @param to Ethereum address of account to send currency amount to
1096    * @param amount Value of currency to transfer
1097    * @param data Arbitrary bytes data to include with the transaction
1098    * @return { "success" : "Return true if successfully called from another contract" }
1099    */
1100   function transfer(Data storage self, string currency, address to, uint amount, bytes data) internal returns (bool success) {
1101     require(address(to) != 0x0, "Error: `to` address cannot be null." );
1102     require(amount > 0, "Error: `amount` must be greater than zero");
1103 
1104     address feeContract = getFeeContract(self, address(this));
1105     uint fees = calculateFees(self, feeContract, amount);
1106 
1107     require(
1108       setAccountSpendingAmount(self, msg.sender, getFxUSDAmount(self, currency, amount)),
1109       "Error: Unable to set spending amount for account.");
1110 
1111     require(
1112       forceTransfer(self, currency, msg.sender, to, amount, data),
1113       "Error: Unable to transfer funds to account.");
1114 
1115     // @dev transfer fees to fee contract
1116     require(
1117       forceTransfer(self, currency, msg.sender, feeContract, fees, getFeeMsg(self, feeContract)),
1118       "Error: Unable to transfer fees to fee contract.");
1119 
1120     return true;
1121   }
1122 
1123   /**
1124    * @notice Transfer an amount of currency token from account to another specified account via an approved spender account
1125    * @dev This function is called by an interface that is accessible directly to the account spender
1126    * @dev | This method has an `internal` view
1127    * @dev | Transactions will fail if the spending amount exceeds the daily limit
1128    * @dev | This method uses `forceTransfer()` low-level api
1129    * @dev | This method implements ERC20 transferFrom() method with approved spender behavior
1130    * @dev | msg.sender == spender; `updateAllowance()` reduces approved limit for account spender
1131    * @param self Internal storage proxying TokenIOStorage contract
1132    * @param  currency Currency symbol of the token (e.g. USDx, JYPx, GBPx)
1133    * @param from Ethereum address of account to send currency amount from
1134    * @param to Ethereum address of account to send currency amount to
1135    * @param amount Value of currency to transfer
1136    * @param data Arbitrary bytes data to include with the transaction
1137    * @return { "success" : "Return true if successfully called from another contract" }
1138    */
1139   function transferFrom(Data storage self, string currency, address from, address to, uint amount, bytes data) internal returns (bool success) {
1140     require(
1141       address(to) != 0x0,
1142       "Error: `to` address must not be null."
1143     );
1144 
1145     address feeContract = getFeeContract(self, address(this));
1146     uint fees = calculateFees(self, feeContract, amount);
1147 
1148     /// @dev NOTE: This transaction will fail if the spending amount exceeds the daily limit
1149     require(
1150       setAccountSpendingAmount(self, from, getFxUSDAmount(self, currency, amount)),
1151       "Error: Unable to set account spending amount."
1152     );
1153 
1154     /// @dev Attempt to transfer the amount
1155     require(
1156       forceTransfer(self, currency, from, to, amount, data),
1157       "Error: Unable to transfer funds to account."
1158     );
1159 
1160     // @dev transfer fees to fee contract
1161     require(
1162       forceTransfer(self, currency, from, feeContract, fees, getFeeMsg(self, feeContract)),
1163       "Error: Unable to transfer fees to fee contract."
1164     );
1165 
1166     /// @dev Attempt to update the spender allowance
1167     /// @notice this will throw if the allowance has not been set.
1168     require(
1169       updateAllowance(self, currency, from, amount),
1170       "Error: Unable to update allowance for spender."
1171     );
1172 
1173     return true;
1174   }
1175 
1176   /**
1177    * @notice Low-level transfer method
1178    * @dev | This method has an `internal` view
1179    * @dev | This method does not include fees or approved allowances.
1180    * @dev | This method is only for authorized interfaces to use (e.g. TokenIOFX)
1181    * @param self Internal storage proxying TokenIOStorage contract
1182    * @param  currency Currency symbol of the token (e.g. USDx, JYPx, GBPx)
1183    * @param from Ethereum address of account to send currency amount from
1184    * @param to Ethereum address of account to send currency amount to
1185    * @param amount Value of currency to transfer
1186    * @param data Arbitrary bytes data to include with the transaction
1187    * @return { "success" : "Return true if successfully called from another contract" }
1188    */
1189   function forceTransfer(Data storage self, string currency, address from, address to, uint amount, bytes data) internal returns (bool success) {
1190     require(
1191       address(to) != 0x0,
1192       "Error: `to` address must not be null."
1193     );
1194 
1195     bytes32 id_a = keccak256(abi.encodePacked('token.balance', currency, getForwardedAccount(self, from)));
1196     bytes32 id_b = keccak256(abi.encodePacked('token.balance', currency, getForwardedAccount(self, to)));
1197 
1198     require(
1199       self.Storage.setUint(id_a, self.Storage.getUint(id_a).sub(amount)),
1200       "Error: Unable to set storage value. Please ensure contract has allowed permissions with storage contract."
1201     );
1202     require(
1203       self.Storage.setUint(id_b, self.Storage.getUint(id_b).add(amount)),
1204       "Error: Unable to set storage value. Please ensure contract has allowed permissions with storage contract."
1205     );
1206 
1207     emit Transfer(currency, from, to, amount, data);
1208 
1209     return true;
1210   }
1211 
1212   /**
1213    * @notice Low-level method to update spender allowance for account
1214    * @dev | This method is called inside the `transferFrom()` method
1215    * @dev | msg.sender == spender address
1216    * @param self Internal storage proxying TokenIOStorage contract
1217    * @param  currency Currency symbol of the token (e.g. USDx, JYPx, GBPx)
1218    * @param account Ethereum address of account holder
1219    * @param amount Value to reduce allowance by (i.e. the amount spent)
1220    * @return { "success" : "Return true if successfully called from another contract" }
1221    */
1222   function updateAllowance(Data storage self, string currency, address account, uint amount) internal returns (bool success) {
1223     bytes32 id = keccak256(abi.encodePacked('token.allowance', currency, getForwardedAccount(self, account), getForwardedAccount(self, msg.sender)));
1224     require(
1225       self.Storage.setUint(id, self.Storage.getUint(id).sub(amount)),
1226       "Error: Unable to set storage value. Please ensure contract has allowed permissions with storage contract."
1227     );
1228     return true;
1229   }
1230 
1231   /**
1232    * @notice Low-level method to set the allowance for a spender
1233    * @dev | This method is called inside the `approve()` ERC20 method
1234    * @dev | msg.sender == account holder
1235    * @param self Internal storage proxying TokenIOStorage contract
1236    * @param spender Ethereum address of account spender
1237    * @param amount Value to set for spender allowance
1238    * @return { "success" : "Return true if successfully called from another contract" }
1239    */
1240   function approveAllowance(Data storage self, address spender, uint amount) internal returns (bool success) {
1241     require(spender != 0x0,
1242         "Error: `spender` address cannot be null.");
1243 
1244     string memory currency = getTokenSymbol(self, address(this));
1245 
1246     require(
1247       getTokenFrozenBalance(self, currency, getForwardedAccount(self, spender)) == 0,
1248       "Error: Spender must not have a frozen balance directly");
1249 
1250     bytes32 id_a = keccak256(abi.encodePacked('token.allowance', currency, getForwardedAccount(self, msg.sender), getForwardedAccount(self, spender)));
1251     bytes32 id_b = keccak256(abi.encodePacked('token.balance', currency, getForwardedAccount(self, msg.sender)));
1252 
1253     require(
1254       self.Storage.getUint(id_a) == 0 || amount == 0,
1255       "Error: Allowance must be zero (0) before setting an updated allowance for spender.");
1256 
1257     require(
1258       self.Storage.getUint(id_b) >= amount,
1259       "Error: Allowance cannot exceed msg.sender token balance.");
1260 
1261     require(
1262       self.Storage.setUint(id_a, amount),
1263       "Error: Unable to set storage value. Please ensure contract has allowed permissions with storage contract.");
1264 
1265     emit Approval(msg.sender, spender, amount);
1266 
1267     return true;
1268   }
1269 
1270   /**
1271    * @notice Deposit an amount of currency into the Ethereum account holder
1272    * @dev | The total supply of the token increases only when new funds are deposited 1:1
1273    * @dev | This method should only be called by authorized issuer firms
1274    * @param self Internal storage proxying TokenIOStorage contract
1275    * @param  currency Currency symbol of the token (e.g. USDx, JYPx, GBPx)
1276    * @param account Ethereum address of account holder to deposit funds for
1277    * @param amount Value of currency to deposit for account
1278    * @param issuerFirm Name of the issuing firm authorizing the deposit
1279    * @return { "success" : "Return true if successfully called from another contract" }
1280    */
1281   function deposit(Data storage self, string currency, address account, uint amount, string issuerFirm) internal returns (bool success) {
1282     bytes32 id_a = keccak256(abi.encodePacked('token.balance', currency, getForwardedAccount(self, account)));
1283     bytes32 id_b = keccak256(abi.encodePacked('token.issued', currency, issuerFirm));
1284     bytes32 id_c = keccak256(abi.encodePacked('token.supply', currency));
1285 
1286 
1287     require(self.Storage.setUint(id_a, self.Storage.getUint(id_a).add(amount)),
1288       "Error: Unable to set storage value. Please ensure contract has allowed permissions with storage contract.");
1289     require(self.Storage.setUint(id_b, self.Storage.getUint(id_b).add(amount)),
1290       "Error: Unable to set storage value. Please ensure contract has allowed permissions with storage contract.");
1291     require(self.Storage.setUint(id_c, self.Storage.getUint(id_c).add(amount)),
1292       "Error: Unable to set storage value. Please ensure contract has allowed permissions with storage contract.");
1293 
1294     emit Deposit(currency, account, amount, issuerFirm);
1295 
1296     return true;
1297 
1298   }
1299 
1300   /**
1301    * @notice Withdraw an amount of currency from the Ethereum account holder
1302    * @dev | The total supply of the token decreases only when new funds are withdrawn 1:1
1303    * @dev | This method should only be called by authorized issuer firms
1304    * @param self Internal storage proxying TokenIOStorage contract
1305    * @param  currency Currency symbol of the token (e.g. USDx, JYPx, GBPx)
1306    * @param account Ethereum address of account holder to deposit funds for
1307    * @param amount Value of currency to withdraw for account
1308    * @param issuerFirm Name of the issuing firm authorizing the withdraw
1309    * @return { "success" : "Return true if successfully called from another contract" }
1310    */
1311   function withdraw(Data storage self, string currency, address account, uint amount, string issuerFirm) internal returns (bool success) {
1312     bytes32 id_a = keccak256(abi.encodePacked('token.balance', currency, getForwardedAccount(self, account)));
1313     bytes32 id_b = keccak256(abi.encodePacked('token.issued', currency, issuerFirm)); // possible for issuer to go negative
1314     bytes32 id_c = keccak256(abi.encodePacked('token.supply', currency));
1315 
1316     require(
1317       self.Storage.setUint(id_a, self.Storage.getUint(id_a).sub(amount)),
1318       "Error: Unable to set storage value. Please ensure contract has allowed permissions with storage contract.");
1319     require(
1320       self.Storage.setUint(id_b, self.Storage.getUint(id_b).sub(amount)),
1321       "Error: Unable to set storage value. Please ensure contract has allowed permissions with storage contract.");
1322     require(
1323       self.Storage.setUint(id_c, self.Storage.getUint(id_c).sub(amount)),
1324       "Error: Unable to set storage value. Please ensure contract has allowed permissions with storage contract.");
1325 
1326     emit Withdraw(currency, account, amount, issuerFirm);
1327 
1328     return true;
1329 
1330   }
1331 
1332   /**
1333    * @notice Method for setting a registered issuer firm
1334    * @dev | Only Token, Inc. and other authorized institutions may set a registered firm
1335    * @dev | The TokenIOAuthority.sol interface wraps this method
1336    * @dev | If the registered firm is unapproved; all authorized addresses of that firm will also be unapproved
1337    * @param self Internal storage proxying TokenIOStorage contract
1338    * @param issuerFirm Name of the firm to be registered
1339    * @param approved Approval status to set for the firm (true/false)
1340    * @return { "success" : "Return true if successfully called from another contract" }
1341    */
1342   function setRegisteredFirm(Data storage self, string issuerFirm, bool approved) internal returns (bool success) {
1343     bytes32 id = keccak256(abi.encodePacked('registered.firm', issuerFirm));
1344     require(
1345       self.Storage.setBool(id, approved),
1346       "Error: Unable to set storage value. Please ensure contract has allowed permissions with storage contract."
1347     );
1348     return true;
1349   }
1350 
1351   /**
1352    * @notice Method for setting a registered issuer firm authority
1353    * @dev | Only Token, Inc. and other approved institutions may set a registered firm
1354    * @dev | The TokenIOAuthority.sol interface wraps this method
1355    * @dev | Authority can only be set for a registered issuer firm
1356    * @param self Internal storage proxying TokenIOStorage contract
1357    * @param issuerFirm Name of the firm to be registered to authority
1358    * @param authorityAddress Ethereum address of the firm authority to be approved
1359    * @param approved Approval status to set for the firm authority (true/false)
1360    * @return { "success" : "Return true if successfully called from another contract" }
1361    */
1362   function setRegisteredAuthority(Data storage self, string issuerFirm, address authorityAddress, bool approved) internal returns (bool success) {
1363     require(
1364       isRegisteredFirm(self, issuerFirm),
1365       "Error: `issuerFirm` must be registered.");
1366 
1367     bytes32 id_a = keccak256(abi.encodePacked('registered.authority', issuerFirm, authorityAddress));
1368     bytes32 id_b = keccak256(abi.encodePacked('registered.authority.firm', authorityAddress));
1369 
1370     require(
1371       self.Storage.setBool(id_a, approved),
1372       "Error: Unable to set storage value. Please ensure contract has allowed permissions with storage contract.");
1373 
1374     require(
1375       self.Storage.setString(id_b, issuerFirm),
1376       "Error: Unable to set storage value. Please ensure contract has allowed permissions with storage contract.");
1377 
1378 
1379     return true;
1380   }
1381 
1382   /**
1383    * @notice Get the issuer firm registered to the authority Ethereum address
1384    * @dev | Only one firm can be registered per authority
1385    * @param self Internal storage proxying TokenIOStorage contract
1386    * @param authorityAddress Ethereum address of the firm authority to query
1387    * @return { "issuerFirm" : "Name of the firm registered to authority" }
1388    */
1389   function getFirmFromAuthority(Data storage self, address authorityAddress) internal view returns (string issuerFirm) {
1390     bytes32 id = keccak256(abi.encodePacked('registered.authority.firm', getForwardedAccount(self, authorityAddress)));
1391     return self.Storage.getString(id);
1392   }
1393 
1394   /**
1395    * @notice Return the boolean (true/false) registration status for an issuer firm
1396    * @param self Internal storage proxying TokenIOStorage contract
1397    * @param issuerFirm Name of the issuer firm
1398    * @return { "registered" : "Return if the issuer firm has been registered" }
1399    */
1400   function isRegisteredFirm(Data storage self, string issuerFirm) internal view returns (bool registered) {
1401     bytes32 id = keccak256(abi.encodePacked('registered.firm', issuerFirm));
1402     return self.Storage.getBool(id);
1403   }
1404 
1405   /**
1406    * @notice Return the boolean (true/false) status if an authority is registered to an issuer firm
1407    * @param self Internal storage proxying TokenIOStorage contract
1408    * @param issuerFirm Name of the issuer firm
1409    * @param authorityAddress Ethereum address of the firm authority to query
1410    * @return { "registered" : "Return if the authority is registered with the issuer firm" }
1411    */
1412   function isRegisteredToFirm(Data storage self, string issuerFirm, address authorityAddress) internal view returns (bool registered) {
1413     bytes32 id = keccak256(abi.encodePacked('registered.authority', issuerFirm, getForwardedAccount(self, authorityAddress)));
1414     return self.Storage.getBool(id);
1415   }
1416 
1417   /**
1418    * @notice Return if an authority address is registered
1419    * @dev | This also checks the status of the registered issuer firm
1420    * @param self Internal storage proxying TokenIOStorage contract
1421    * @param authorityAddress Ethereum address of the firm authority to query
1422    * @return { "registered" : "Return if the authority is registered" }
1423    */
1424   function isRegisteredAuthority(Data storage self, address authorityAddress) internal view returns (bool registered) {
1425     bytes32 id = keccak256(abi.encodePacked('registered.authority', getFirmFromAuthority(self, getForwardedAccount(self, authorityAddress)), getForwardedAccount(self, authorityAddress)));
1426     return self.Storage.getBool(id);
1427   }
1428 
1429   /**
1430    * @notice Return boolean transaction status if the transaction has been used
1431    * @param self Internal storage proxying TokenIOStorage contract
1432    * @param txHash keccak256 ABI tightly packed encoded hash digest of tx params
1433    * @return {"txStatus": "Returns true if the tx hash has already been set using `setTxStatus()` method"}
1434    */
1435   function getTxStatus(Data storage self, bytes32 txHash) internal view returns (bool txStatus) {
1436     bytes32 id = keccak256(abi.encodePacked('tx.status', txHash));
1437     return self.Storage.getBool(id);
1438   }
1439 
1440   /**
1441    * @notice Set transaction status if the transaction has been used
1442    * @param self Internal storage proxying TokenIOStorage contract
1443    * @param txHash keccak256 ABI tightly packed encoded hash digest of tx params
1444    * @return { "success" : "Return true if successfully called from another contract" }
1445    */
1446   function setTxStatus(Data storage self, bytes32 txHash) internal returns (bool success) {
1447     bytes32 id = keccak256(abi.encodePacked('tx.status', txHash));
1448     /// @dev Ensure transaction has not yet been used;
1449     require(!getTxStatus(self, txHash),
1450       "Error: Transaction status must be false before setting the transaction status.");
1451 
1452     /// @dev Update the status of the transaction;
1453     require(self.Storage.setBool(id, true),
1454       "Error: Unable to set storage value. Please ensure contract has allowed permissions with storage contract.");
1455 
1456     return true;
1457   }
1458 
1459   /**
1460    * @notice Accepts a signed fx request to swap currency pairs at a given amount;
1461    * @dev | This method can be called directly between peers
1462    * @dev | This method does not take transaction fees from the swap
1463    * @param self Internal storage proxying TokenIOStorage contract
1464    * @param  requester address Requester is the orginator of the offer and must
1465    * match the signature of the payload submitted by the fulfiller
1466    * @param  symbolA    Symbol of the currency desired
1467    * @param  symbolB    Symbol of the currency offered
1468    * @param  valueA     Amount of the currency desired
1469    * @param  valueB     Amount of the currency offered
1470    * @param  sigV       Ethereum secp256k1 signature V value; used by ecrecover()
1471    * @param  sigR       Ethereum secp256k1 signature R value; used by ecrecover()
1472    * @param  sigS       Ethereum secp256k1 signature S value; used by ecrecover()
1473    * @param  expiration Expiration of the offer; Offer is good until expired
1474    * @return {"success" : "Returns true if successfully called from another contract"}
1475    */
1476   function execSwap(
1477     Data storage self,
1478     address requester,
1479     string symbolA,
1480     string symbolB,
1481     uint valueA,
1482     uint valueB,
1483     uint8 sigV,
1484     bytes32 sigR,
1485     bytes32 sigS,
1486     uint expiration
1487   ) internal returns (bool success) {
1488 
1489     bytes32 fxTxHash = keccak256(abi.encodePacked(requester, symbolA, symbolB, valueA, valueB, expiration));
1490 
1491     /// @notice check that sender and requester accounts are verified
1492     /// @notice Only verified accounts can perform currency swaps
1493     require(
1494       verifyAccounts(self, msg.sender, requester),
1495       "Error: Only verified accounts can perform currency swaps.");
1496 
1497     /// @dev Immediately set this transaction to be confirmed before updating any params;
1498     require(
1499       setTxStatus(self, fxTxHash),
1500       "Error: Failed to set transaction status to fulfilled.");
1501 
1502     /// @dev Ensure contract has not yet expired;
1503     require(expiration >= now, "Error: Transaction has expired!");
1504 
1505     /// @dev Recover the address of the signature from the hashed digest;
1506     /// @dev Ensure it equals the requester's address
1507     require(
1508       ecrecover(fxTxHash, sigV, sigR, sigS) == requester,
1509       "Error: Address derived from transaction signature does not match the requester address");
1510 
1511     /// @dev Transfer funds from each account to another.
1512     require(
1513       forceTransfer(self, symbolA, msg.sender, requester, valueA, "0x0"),
1514       "Error: Unable to transfer funds to account.");
1515 
1516     require(
1517       forceTransfer(self, symbolB, requester, msg.sender, valueB, "0x0"),
1518       "Error: Unable to transfer funds to account.");
1519 
1520     emit FxSwap(symbolA, symbolB, valueA, valueB, expiration, fxTxHash);
1521 
1522     return true;
1523   }
1524 
1525   /**
1526    * @notice Deprecate a contract interface
1527    * @dev | This is a low-level method to deprecate a contract interface.
1528    * @dev | This is useful if the interface needs to be updated or becomes out of date
1529    * @param self Internal storage proxying TokenIOStorage contract
1530    * @param contractAddress Ethereum address of the contract interface
1531    * @return {"success" : "Returns true if successfully called from another contract"}
1532    */
1533   function setDeprecatedContract(Data storage self, address contractAddress) internal returns (bool success) {
1534     require(contractAddress != 0x0,
1535         "Error: cannot deprecate a null address.");
1536 
1537     bytes32 id = keccak256(abi.encodePacked('depcrecated', contractAddress));
1538 
1539     require(self.Storage.setBool(id, true),
1540       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract.");
1541 
1542     return true;
1543   }
1544 
1545   /**
1546    * @notice Return the deprecation status of a contract
1547    * @param self Internal storage proxying TokenIOStorage contract
1548    * @param contractAddress Ethereum address of the contract interface
1549    * @return {"status" : "Return deprecation status (true/false) of the contract interface"}
1550    */
1551   function isContractDeprecated(Data storage self, address contractAddress) internal view returns (bool status) {
1552     bytes32 id = keccak256(abi.encodePacked('depcrecated', contractAddress));
1553     return self.Storage.getBool(id);
1554   }
1555 
1556   /**
1557    * @notice Set the Account Spending Period Limit as UNIX timestamp
1558    * @dev | Each account has it's own daily spending limit
1559    * @param self Internal storage proxying TokenIOStorage contract
1560    * @param account Ethereum address of the account holder
1561    * @param period Unix timestamp of the spending period
1562    * @return {"success" : "Returns true is successfully called from a contract"}
1563    */
1564   function setAccountSpendingPeriod(Data storage self, address account, uint period) internal returns (bool success) {
1565     bytes32 id = keccak256(abi.encodePacked('limit.spending.period', account));
1566     require(self.Storage.setUint(id, period),
1567       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract.");
1568 
1569     return true;
1570   }
1571 
1572   /**
1573    * @notice Get the Account Spending Period Limit as UNIX timestamp
1574    * @dev | Each account has it's own daily spending limit
1575    * @dev | If the current spending period has expired, it will be set upon next `transfer()`
1576    * or `transferFrom()` request
1577    * @param self Internal storage proxying TokenIOStorage contract
1578    * @param account Ethereum address of the account holder
1579    * @return {"period" : "Returns Unix timestamp of the current spending period"}
1580    */
1581   function getAccountSpendingPeriod(Data storage self, address account) internal view returns (uint period) {
1582     bytes32 id = keccak256(abi.encodePacked('limit.spending.period', account));
1583     return self.Storage.getUint(id);
1584   }
1585 
1586   /**
1587    * @notice Set the account spending limit amount
1588    * @dev | Each account has it's own daily spending limit
1589    * @param self Internal storage proxying TokenIOStorage contract
1590    * @param account Ethereum address of the account holder
1591    * @param limit Spending limit amount
1592    * @return {"success" : "Returns true is successfully called from a contract"}
1593    */
1594   function setAccountSpendingLimit(Data storage self, address account, uint limit) internal returns (bool success) {
1595     bytes32 id = keccak256(abi.encodePacked('account.spending.limit', account));
1596     require(self.Storage.setUint(id, limit),
1597       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract.");
1598 
1599     return true;
1600   }
1601 
1602   /**
1603    * @notice Get the account spending limit amount
1604    * @dev | Each account has it's own daily spending limit
1605    * @param self Internal storage proxying TokenIOStorage contract
1606    * @param account Ethereum address of the account holder
1607    * @return {"limit" : "Returns the account spending limit amount"}
1608    */
1609   function getAccountSpendingLimit(Data storage self, address account) internal view returns (uint limit) {
1610     bytes32 id = keccak256(abi.encodePacked('account.spending.limit', account));
1611     return self.Storage.getUint(id);
1612   }
1613 
1614   /**
1615    * @notice Set the account spending amount for the daily period
1616    * @dev | Each account has it's own daily spending limit
1617    * @dev | This transaction will throw if the new spending amount is greater than the limit
1618    * @dev | This method is called in the `transfer()` and `transferFrom()` methods
1619    * @param self Internal storage proxying TokenIOStorage contract
1620    * @param account Ethereum address of the account holder
1621    * @param amount Set the amount spent for the daily period
1622    * @return {"success" : "Returns true is successfully called from a contract"}
1623    */
1624   function setAccountSpendingAmount(Data storage self, address account, uint amount) internal returns (bool success) {
1625 
1626     /// @dev NOTE: Always ensure the period is current when checking the daily spend limit
1627     require(updateAccountSpendingPeriod(self, account),
1628       "Error: Unable to update account spending period.");
1629 
1630     uint updatedAmount = getAccountSpendingAmount(self, account).add(amount);
1631 
1632     /// @dev Ensure the spend limit is greater than the amount spend for the period
1633     require(
1634       getAccountSpendingLimit(self, account) >= updatedAmount,
1635       "Error: Account cannot exceed its daily spend limit.");
1636 
1637     /// @dev Update the spending period amount if within limit
1638     bytes32 id = keccak256(abi.encodePacked('account.spending.amount', account, getAccountSpendingPeriod(self, account)));
1639     require(self.Storage.setUint(id, updatedAmount),
1640       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract.");
1641 
1642     return true;
1643   }
1644 
1645   /**
1646    * @notice Low-level API to ensure the account spending period is always current
1647    * @dev | This method is internally called by `setAccountSpendingAmount()` to ensure
1648    * spending period is always the most current daily period.
1649    * @param self Internal storage proxying TokenIOStorage contract
1650    * @param account Ethereum address of the account holder
1651    * @return {"success" : "Returns true is successfully called from a contract"}
1652    */
1653   function updateAccountSpendingPeriod(Data storage self, address account) internal returns (bool success) {
1654     uint begDate = getAccountSpendingPeriod(self, account);
1655     if (begDate > now) {
1656       return true;
1657     } else {
1658       uint duration = 86400; // 86400 seconds in a day
1659       require(
1660         setAccountSpendingPeriod(self, account, begDate.add(((now.sub(begDate)).div(duration).add(1)).mul(duration))),
1661         "Error: Unable to update account spending period.");
1662 
1663       return true;
1664     }
1665   }
1666 
1667   /**
1668    * @notice Return the amount spent during the current period
1669    * @dev | Each account has it's own daily spending limit
1670    * @param self Internal storage proxying TokenIOStorage contract
1671    * @param account Ethereum address of the account holder
1672    * @return {"amount" : "Returns the amount spent by the account during the current period"}
1673    */
1674   function getAccountSpendingAmount(Data storage self, address account) internal view returns (uint amount) {
1675     bytes32 id = keccak256(abi.encodePacked('account.spending.amount', account, getAccountSpendingPeriod(self, account)));
1676     return self.Storage.getUint(id);
1677   }
1678 
1679   /**
1680    * @notice Return the amount remaining during the current period
1681    * @dev | Each account has it's own daily spending limit
1682    * @param self Internal storage proxying TokenIOStorage contract
1683    * @param account Ethereum address of the account holder
1684    * @return {"amount" : "Returns the amount remaining by the account during the current period"}
1685    */
1686   function getAccountSpendingRemaining(Data storage self, address account) internal view returns (uint remainingLimit) {
1687     return getAccountSpendingLimit(self, account).sub(getAccountSpendingAmount(self, account));
1688   }
1689 
1690   /**
1691    * @notice Set the foreign currency exchange rate to USD in basis points
1692    * @dev | This value should always be relative to USD pair; e.g. JPY/USD, GBP/USD, etc.
1693    * @param self Internal storage proxying TokenIOStorage contract
1694    * @param currency The TokenIO currency symbol (e.g. USDx, JPYx, GBPx)
1695    * @param bpsRate Basis point rate of foreign currency exchange rate to USD
1696    * @return { "success": "Returns true if successfully called from another contract"}
1697    */
1698   function setFxUSDBPSRate(Data storage self, string currency, uint bpsRate) internal returns (bool success) {
1699     bytes32 id = keccak256(abi.encodePacked('fx.usd.rate', currency));
1700     require(
1701       self.Storage.setUint(id, bpsRate),
1702       "Error: Unable to update account spending period.");
1703 
1704     return true;
1705   }
1706 
1707   /**
1708    * @notice Return the foreign currency USD exchanged amount in basis points
1709    * @param self Internal storage proxying TokenIOStorage contract
1710    * @param currency The TokenIO currency symbol (e.g. USDx, JPYx, GBPx)
1711    * @return {"usdAmount" : "Returns the foreign currency amount in USD"}
1712    */
1713   function getFxUSDBPSRate(Data storage self, string currency) internal view returns (uint bpsRate) {
1714     bytes32 id = keccak256(abi.encodePacked('fx.usd.rate', currency));
1715     return self.Storage.getUint(id);
1716   }
1717 
1718   /**
1719    * @notice Return the foreign currency USD exchanged amount
1720    * @param self Internal storage proxying TokenIOStorage contract
1721    * @param currency The TokenIO currency symbol (e.g. USDx, JPYx, GBPx)
1722    * @param fxAmount Amount of foreign currency to exchange into USD
1723    * @return {"amount" : "Returns the foreign currency amount in USD"}
1724    */
1725   function getFxUSDAmount(Data storage self, string currency, uint fxAmount) internal view returns (uint amount) {
1726     uint usdDecimals = getTokenDecimals(self, 'USDx');
1727     uint fxDecimals = getTokenDecimals(self, currency);
1728     /// @dev ensure decimal precision is normalized to USD decimals
1729     uint usdAmount = ((fxAmount.mul(getFxUSDBPSRate(self, currency)).div(10000)).mul(10**usdDecimals)).div(10**fxDecimals);
1730     return usdAmount;
1731   }
1732 
1733 
1734 }
1735 
1736 /**
1737  * @title ERC20 interface
1738  * @dev see https://github.com/ethereum/EIPs/issues/20
1739  * @notice interface contract from Zeppelin token erc20;
1740  */
1741 interface ERC20Interface {
1742   function totalSupply() external view returns (uint256);
1743 
1744   function decimals() external view returns (uint256);
1745 
1746   function balanceOf(address who) external view returns (uint256);
1747 
1748   function allowance(address owner, address spender)
1749     external view returns (uint256);
1750 
1751   function transfer(address to, uint256 value) external returns (bool);
1752 
1753   function approve(address spender, uint256 value)
1754     external returns (bool);
1755 
1756   function transferFrom(address from, address to, uint256 value)
1757     external returns (bool);
1758 
1759   event Transfer(
1760     address indexed from,
1761     address indexed to,
1762     uint256 value
1763   );
1764 
1765   event Approval(
1766     address indexed owner,
1767     address indexed spender,
1768     uint256 value
1769   );
1770 }
1771 
1772 /*
1773 COPYRIGHT 2018 Token, Inc.
1774 
1775 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
1776 INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
1777 PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
1778 COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
1779 IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
1780 WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
1781 
1782 @title ERC20 Compliant StableCoin Swap Smart Contract for Token, Inc.
1783 
1784 @author Ryan Tate <ryan.tate@token.io>, Sean Pollock <sean.pollock@token.io>
1785 
1786 @notice Contract uses generalized storage contract, `TokenIOStorage`, for
1787 upgradeability of interface contract.
1788 
1789 @dev In the event that the main contract becomes deprecated, the upgraded contract
1790 will be set as the owner of this contract, and use this contract's storage to
1791 maintain data consistency between contract.
1792 */
1793 
1794 
1795 
1796 contract TokenIOStableSwap is Ownable {
1797   /// @dev use safe math operations
1798   using SafeMath for uint;
1799 
1800   //// @dev Set reference to TokenIOLib interface which proxies to TokenIOStorage
1801   using TokenIOLib for TokenIOLib.Data;
1802   TokenIOLib.Data lib;
1803 
1804   event StableSwap(address fromAsset, address toAsset, address requestedBy, uint amount, string currency);
1805   event TransferredHoldings(address asset, address to, uint amount);
1806   event AllowedERC20Asset(address asset, string currency);
1807   event RemovedERC20Asset(address asset, string currency);
1808 
1809   /**
1810   * @notice Constructor method for TokenIOStableSwap contract
1811   * @param _storageContract     address of TokenIOStorage contract
1812   */
1813   constructor(address _storageContract) public {
1814     //// @dev Set the storage contract for the interface
1815     //// @dev This contract will be unable to use the storage constract until
1816     //// @dev contract address is authorized with the storage contract
1817     //// @dev Once authorized, Use the `setParams` method to set storage values
1818     lib.Storage = TokenIOStorage(_storageContract);
1819 
1820     //// @dev set owner to contract initiator
1821     owner[msg.sender] = true;
1822   }
1823 
1824 	/**
1825 	 * @notice Allows the address of the asset to be accepted by this contract by the currency type. This method is only called by admins.
1826 	 * @notice This method may be deprecated or refactored to allow for multiple interfaces
1827 	 * @param  asset Ethereum address of the ERC20 compliant smart contract to allow the swap
1828 	 * @param  currency string Currency symbol of the token (e.g. `USD`, `EUR`, `GBP`, `JPY`, `AUD`, `CAD`, `CHF`, `NOK`, `NZD`, `SEK`)
1829    * @param feeBps Basis points Swap Fee
1830 	 * @param feeMin Minimum Swap Fees
1831 	 * @param feeMax Maximum Swap Fee
1832 	 * @param feeFlat Flat Swap Fee
1833 	 * @return { "success" : "Returns true if successfully called from another contract"}
1834 	 */
1835 	function allowAsset(address asset, string currency, uint feeBps, uint feeMin, uint feeMax, uint feeFlat) public onlyOwner notDeprecated returns (bool success) {
1836 		bytes32 id = keccak256(abi.encodePacked('allowed.stable.asset', asset, currency));
1837     require(
1838       lib.Storage.setBool(id, true),
1839       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract."
1840     );
1841 
1842     /// @notice set Currency for the asset;
1843     require(setAssetCurrency(asset, currency), 'Error: Unable to set Currency for asset');
1844 
1845     /// @notice set the Fee Params for the asset
1846     require(setAssetFeeParams(asset, feeBps, feeMin, feeMax, feeFlat), 'Error: Unable to set fee params for asset');
1847 
1848     /// @dev Log Allow ERC20 Asset
1849     emit AllowedERC20Asset(asset, currency);
1850 		return true;
1851 	}
1852 
1853   function removeAsset(address asset) public onlyOwner notDeprecated returns (bool success) {
1854     string memory currency = getAssetCurrency(asset);
1855     bytes32 id = keccak256(abi.encodePacked('allowed.stable.asset', asset, currency));
1856     require(
1857       lib.Storage.setBool(id, false),
1858       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract."
1859     );
1860     emit RemovedERC20Asset(asset, currency);
1861     return true;
1862   }
1863 
1864 	/**
1865 	 * @notice Return boolean if the asset is an allowed stable asset for the corresponding currency
1866 	 * @param  asset Ethereum address of the ERC20 compliant smart contract to check allowed status of
1867 	 * @param  currency string Currency symbol of the token (e.g. `USD`, `EUR`, `GBP`, `JPY`, `AUD`, `CAD`, `CHF`, `NOK`, `NZD`, `SEK`)
1868 	 * @return {"allowed": "Returns true if the asset is allowed"}
1869 	 */
1870 	function isAllowedAsset(address asset, string currency) public view returns (bool allowed) {
1871 		if (isTokenXContract(asset, currency)) {
1872 			return true;
1873 		} else {
1874 			bytes32 id = keccak256(abi.encodePacked('allowed.stable.asset', asset, currency));
1875 			return lib.Storage.getBool(id);
1876 		}
1877 	}
1878 
1879   /**
1880    * Set the Three Letter Abbrevation for the currency associated to the asset
1881    * @param asset Ethereum address of the asset to set the currency for
1882    * @param currency string Currency of the asset (NOTE: This is the currency for the asset)
1883    * @return { "success" : "Returns true if successfully called from another contract"}
1884    */
1885   function setAssetCurrency(address asset, string currency) public onlyOwner returns (bool success) {
1886     bytes32 id = keccak256(abi.encodePacked('asset.currency', asset));
1887     require(
1888       lib.Storage.setString(id, currency),
1889       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract."
1890     );
1891     return true;
1892   }
1893 
1894   /**
1895    * Get the Currency for an associated asset;
1896    * @param asset Ethereum address of the asset to get the currency for
1897    * @return {"currency": "Returns the Currency of the asset if the asset has been allowed."}
1898    */
1899   function getAssetCurrency(address asset) public view returns (string currency) {
1900     bytes32 id = keccak256(abi.encodePacked('asset.currency', asset));
1901     return lib.Storage.getString(id);
1902   }
1903 
1904   /**
1905 	 * @notice Register the address of the asset as a Token X asset for a specific currency
1906 	 * @notice This method may be deprecated or refactored to allow for multiple interfaces
1907 	 * @param  asset Ethereum address of the ERC20 compliant Token X asset
1908 	 * @param  currency string Currency symbol of the token (e.g. `USD`, `EUR`, `GBP`, `JPY`, `AUD`, `CAD`, `CHF`, `NOK`, `NZD`, `SEK`)
1909 	 * @return { "success" : "Returns true if successfully called from another contract"}
1910 	 */
1911 	function setTokenXCurrency(address asset, string currency) public onlyOwner notDeprecated returns (bool success) {
1912     bytes32 id = keccak256(abi.encodePacked('tokenx', asset, currency));
1913     require(
1914       lib.Storage.setBool(id, true),
1915       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract."
1916     );
1917 
1918     /// @notice set Currency for the asset;
1919     require(setAssetCurrency(asset, currency));
1920 
1921     return true;
1922 	}
1923 
1924   /**
1925     * @notice Return boolean if the asset is a registered Token X asset for the corresponding currency
1926     * @param  asset Ethereum address of the asset to check if is a registered Token X stable coin asset
1927     * @param  currency string Currency symbol of the token (e.g. `USD`, `EUR`, `GBP`, `JPY`, `AUD`, `CAD`, `CHF`, `NOK`, `NZD`, `SEK`)
1928     * @return {"allowed": "Returns true if the asset is allowed"}
1929    */
1930 	function isTokenXContract(address asset, string currency) public view returns (bool isX) {
1931 		bytes32 id = keccak256(abi.encodePacked('tokenx', asset, currency));
1932 		return lib.Storage.getBool(id);
1933 	}
1934 
1935   /**
1936    * @notice Set BPS, Min, Max, and Flat fee params for asset
1937    * @param asset Ethereum address of the asset to set fees for.
1938    * @param feeBps Basis points Swap Fee
1939 	 * @param feeMin Minimum Swap Fees
1940 	 * @param feeMax Maximum Swap Fee
1941 	 * @param feeFlat Flat Swap Fee
1942 	 * @return { "success" : "Returns true if successfully called from another contract"}
1943    */
1944   function setAssetFeeParams(address asset, uint feeBps, uint feeMin, uint feeMax, uint feeFlat) public onlyOwner notDeprecated returns (bool success) {
1945     /// @dev This method bypasses the setFee library methods and directly sets the fee params for a requested asset.
1946     /// @notice Fees can be different per asset. Some assets may have different liquidity requirements.
1947     require(lib.Storage.setUint(keccak256(abi.encodePacked('fee.max', asset)), feeMax),
1948       'Error: Failed to set fee parameters with storage contract. Please check permissions.');
1949 
1950     require(lib.Storage.setUint(keccak256(abi.encodePacked('fee.min', asset)), feeMin),
1951       'Error: Failed to set fee parameters with storage contract. Please check permissions.');
1952 
1953     require(lib.Storage.setUint(keccak256(abi.encodePacked('fee.bps', asset)), feeBps),
1954       'Error: Failed to set fee parameters with storage contract. Please check permissions.');
1955 
1956     require(lib.Storage.setUint(keccak256(abi.encodePacked('fee.flat', asset)), feeFlat),
1957       'Error: Failed to set fee parameters with storage contract. Please check permissions.');
1958 
1959     return true;
1960   }
1961 
1962   /**
1963    * [calcAssetFees description]
1964    * @param  asset Ethereum address of the asset to calculate fees based on
1965    * @param  amount Amount to calculate fees on
1966    * @return { "fees" : "Returns the fees for the amount associated with the asset contract"}
1967    */
1968   function calcAssetFees(address asset, uint amount) public view returns (uint fees) {
1969     return lib.calculateFees(asset, amount);
1970   }
1971 
1972   /**
1973     * @notice Return boolean if the asset is a registered Token X asset for the corresponding currency
1974     * @notice Amounts will always be passed in according to the decimal representation of the `fromAsset` token;
1975     * @param  fromAsset Ethereum address of the asset with allowance for this contract to transfer and
1976     * @param  toAsset Ethereum address of the asset to check if is a registered Token X stable coin asset
1977     * @param  amount Amount of fromAsset to be transferred.
1978     * @return { "success" : "Returns true if successfully called from another contract"}
1979    */
1980 	function convert(address fromAsset, address toAsset, uint amount) public notDeprecated returns (bool success) {
1981     /// @notice lookup currency from one of the assets, check if allowed by both assets.
1982     string memory currency = getAssetCurrency(fromAsset);
1983     uint fromDecimals = ERC20Interface(fromAsset).decimals();
1984     uint toDecimals = ERC20Interface(toAsset).decimals();
1985 
1986     /// @dev Ensure assets are allowed to be swapped;
1987 		require(isAllowedAsset(fromAsset, currency), 'Error: Unsupported asset requested. Asset must be supported by this contract and have a currency of `USD`, `EUR`, `GBP`, `JPY`, `AUD`, `CAD`, `CHF`, `NOK`, `NZD`, `SEK` .');
1988 		require(isAllowedAsset(toAsset, currency), 'Error: Unsupported asset requested. Asset must be supported by this contract and have a currency of `USD`, `EUR`, `GBP`, `JPY`, `AUD`, `CAD`, `CHF`, `NOK`, `NZD`, `SEK` .');
1989 
1990 
1991 		/// @dev require one of the assets be equal to Token X asset;
1992 		if (isTokenXContract(toAsset, currency)) {
1993       /// @notice This requires the erc20 transfer function to return a boolean result of true;
1994       /// @dev the amount being transferred must be in the same decimal representation of the asset
1995       /// e.g. If decimals = 6 and want to transfer $100.00 the amount passed to this contract should be 100e6 (100 * 10 ** 6)
1996       require(
1997         ERC20Interface(fromAsset).transferFrom(msg.sender, address(this), amount),
1998         'Error: Unable to transferFrom your asset holdings. Please ensure this contract has an approved allowance equal to or greater than the amount called in transferFrom method.'
1999       );
2000 
2001       /// @dev Deposit TokenX asset to the user;
2002       /// @notice Amount received from deposit is net of fees.
2003       uint netAmountFrom = amount.sub(calcAssetFees(fromAsset, amount));
2004       /// @dev Ensure amount is converted for the correct decimal representation;
2005       uint convertedAmountFrom = (netAmountFrom.mul(10**toDecimals)).div(10**fromDecimals);
2006       require(
2007         lib.deposit(lib.getTokenSymbol(toAsset), msg.sender, convertedAmountFrom, 'Token, Inc.'),
2008         "Error: Unable to deposit funds. Please check issuerFirm and firm authority are registered"
2009       );
2010 		} else if(isTokenXContract(fromAsset, currency)) {
2011       ///@dev Transfer the asset to the user;
2012       /// @notice Amount received from withdraw is net of fees.
2013       uint convertedAmount = (amount.mul(10**toDecimals)).div(10**fromDecimals);
2014       uint fees = calcAssetFees(toAsset, convertedAmount);
2015       uint netAmountTo = convertedAmount.sub(fees);
2016       /// @dev Ensure amount is converted for the correct decimal representation;
2017       require(
2018       	ERC20Interface(toAsset).transfer(msg.sender, netAmountTo),
2019       	'Unable to call the requested erc20 contract.'
2020       );
2021 
2022       /// @dev Withdraw TokenX asset from the user
2023       require(
2024       	lib.withdraw(lib.getTokenSymbol(fromAsset), msg.sender, amount, 'Token, Inc.'),
2025       	"Error: Unable to withdraw funds. Please check issuerFirm and firm authority are registered and have issued funds that can be withdrawn"
2026       );
2027 		} else {
2028         revert('Error: At least one asset must be issued by Token, Inc. (Token X).');
2029 		}
2030 
2031     /// @dev Log the swap event for event listeners
2032     emit StableSwap(fromAsset, toAsset, msg.sender, amount, currency);
2033     return true;
2034 	}
2035 
2036   /**
2037    * Allow this contract to transfer collected fees to another contract;
2038    * @param  asset Ethereum address of asset to transfer
2039    * @param  to Transfer collected fees to the following account;
2040    * @param  amount Amount of fromAsset to be transferred.
2041    * @return { "success" : "Returns true if successfully called from another contract"}
2042    */
2043   function transferCollectedFees(address asset, address to, uint amount) public onlyOwner notDeprecated returns (bool success) {
2044 		require(
2045 			ERC20Interface(asset).transfer(to, amount),
2046 			"Error: Unable to transfer fees to account."
2047 		);
2048     emit TransferredHoldings(asset, to, amount);
2049 		return true;
2050 	}
2051 
2052 	/**
2053 	* @notice gets currency status of contract
2054 	* @return {"deprecated" : "Returns true if deprecated, false otherwise"}
2055 	*/
2056 	function deprecateInterface() public onlyOwner returns (bool deprecated) {
2057 		require(lib.setDeprecatedContract(address(this)),
2058       "Error: Unable to deprecate contract!");
2059 		return true;
2060 	}
2061 
2062 	modifier notDeprecated() {
2063 		/// @notice throws if contract is deprecated
2064 		require(!lib.isContractDeprecated(address(this)),
2065 			"Error: Contract has been deprecated, cannot perform operation!");
2066 		_;
2067 	}
2068 
2069 
2070 }