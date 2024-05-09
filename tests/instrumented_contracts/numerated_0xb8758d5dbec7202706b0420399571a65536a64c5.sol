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
1167     require(
1168       updateAllowance(self, currency, from, amount),
1169       "Error: Unable to update allowance for spender."
1170     );
1171 
1172     return true;
1173   }
1174 
1175   /**
1176    * @notice Low-level transfer method
1177    * @dev | This method has an `internal` view
1178    * @dev | This method does not include fees or approved allowances.
1179    * @dev | This method is only for authorized interfaces to use (e.g. TokenIOFX)
1180    * @param self Internal storage proxying TokenIOStorage contract
1181    * @param  currency Currency symbol of the token (e.g. USDx, JYPx, GBPx)
1182    * @param from Ethereum address of account to send currency amount from
1183    * @param to Ethereum address of account to send currency amount to
1184    * @param amount Value of currency to transfer
1185    * @param data Arbitrary bytes data to include with the transaction
1186    * @return { "success" : "Return true if successfully called from another contract" }
1187    */
1188   function forceTransfer(Data storage self, string currency, address from, address to, uint amount, bytes data) internal returns (bool success) {
1189     require(
1190       address(to) != 0x0,
1191       "Error: `to` address must not be null."
1192     );
1193 
1194     bytes32 id_a = keccak256(abi.encodePacked('token.balance', currency, getForwardedAccount(self, from)));
1195     bytes32 id_b = keccak256(abi.encodePacked('token.balance', currency, getForwardedAccount(self, to)));
1196 
1197     require(
1198       self.Storage.setUint(id_a, self.Storage.getUint(id_a).sub(amount)),
1199       "Error: Unable to set storage value. Please ensure contract has allowed permissions with storage contract."
1200     );
1201     require(
1202       self.Storage.setUint(id_b, self.Storage.getUint(id_b).add(amount)),
1203       "Error: Unable to set storage value. Please ensure contract has allowed permissions with storage contract."
1204     );
1205 
1206     emit Transfer(currency, from, to, amount, data);
1207 
1208     return true;
1209   }
1210 
1211   /**
1212    * @notice Low-level method to update spender allowance for account
1213    * @dev | This method is called inside the `transferFrom()` method
1214    * @dev | msg.sender == spender address
1215    * @param self Internal storage proxying TokenIOStorage contract
1216    * @param  currency Currency symbol of the token (e.g. USDx, JYPx, GBPx)
1217    * @param account Ethereum address of account holder
1218    * @param amount Value to reduce allowance by (i.e. the amount spent)
1219    * @return { "success" : "Return true if successfully called from another contract" }
1220    */
1221   function updateAllowance(Data storage self, string currency, address account, uint amount) internal returns (bool success) {
1222     bytes32 id = keccak256(abi.encodePacked('token.allowance', currency, getForwardedAccount(self, account), getForwardedAccount(self, msg.sender)));
1223     require(
1224       self.Storage.setUint(id, self.Storage.getUint(id).sub(amount)),
1225       "Error: Unable to set storage value. Please ensure contract has allowed permissions with storage contract."
1226     );
1227     return true;
1228   }
1229 
1230   /**
1231    * @notice Low-level method to set the allowance for a spender
1232    * @dev | This method is called inside the `approve()` ERC20 method
1233    * @dev | msg.sender == account holder
1234    * @param self Internal storage proxying TokenIOStorage contract
1235    * @param spender Ethereum address of account spender
1236    * @param amount Value to set for spender allowance
1237    * @return { "success" : "Return true if successfully called from another contract" }
1238    */
1239   function approveAllowance(Data storage self, address spender, uint amount) internal returns (bool success) {
1240     require(spender != 0x0,
1241         "Error: `spender` address cannot be null.");
1242 
1243     string memory currency = getTokenSymbol(self, address(this));
1244 
1245     require(
1246       getTokenFrozenBalance(self, currency, getForwardedAccount(self, spender)) == 0,
1247       "Error: Spender must not have a frozen balance directly");
1248 
1249     bytes32 id_a = keccak256(abi.encodePacked('token.allowance', currency, getForwardedAccount(self, msg.sender), getForwardedAccount(self, spender)));
1250     bytes32 id_b = keccak256(abi.encodePacked('token.balance', currency, getForwardedAccount(self, msg.sender)));
1251 
1252     require(
1253       self.Storage.getUint(id_a) == 0 || amount == 0,
1254       "Error: Allowance must be zero (0) before setting an updated allowance for spender.");
1255 
1256     require(
1257       self.Storage.getUint(id_b) >= amount,
1258       "Error: Allowance cannot exceed msg.sender token balance.");
1259 
1260     require(
1261       self.Storage.setUint(id_a, amount),
1262       "Error: Unable to set storage value. Please ensure contract has allowed permissions with storage contract.");
1263 
1264     emit Approval(msg.sender, spender, amount);
1265 
1266     return true;
1267   }
1268 
1269   /**
1270    * @notice Deposit an amount of currency into the Ethereum account holder
1271    * @dev | The total supply of the token increases only when new funds are deposited 1:1
1272    * @dev | This method should only be called by authorized issuer firms
1273    * @param self Internal storage proxying TokenIOStorage contract
1274    * @param  currency Currency symbol of the token (e.g. USDx, JYPx, GBPx)
1275    * @param account Ethereum address of account holder to deposit funds for
1276    * @param amount Value of currency to deposit for account
1277    * @param issuerFirm Name of the issuing firm authorizing the deposit
1278    * @return { "success" : "Return true if successfully called from another contract" }
1279    */
1280   function deposit(Data storage self, string currency, address account, uint amount, string issuerFirm) internal returns (bool success) {
1281     bytes32 id_a = keccak256(abi.encodePacked('token.balance', currency, getForwardedAccount(self, account)));
1282     bytes32 id_b = keccak256(abi.encodePacked('token.issued', currency, issuerFirm));
1283     bytes32 id_c = keccak256(abi.encodePacked('token.supply', currency));
1284 
1285 
1286     require(self.Storage.setUint(id_a, self.Storage.getUint(id_a).add(amount)),
1287       "Error: Unable to set storage value. Please ensure contract has allowed permissions with storage contract.");
1288     require(self.Storage.setUint(id_b, self.Storage.getUint(id_b).add(amount)),
1289       "Error: Unable to set storage value. Please ensure contract has allowed permissions with storage contract.");
1290     require(self.Storage.setUint(id_c, self.Storage.getUint(id_c).add(amount)),
1291       "Error: Unable to set storage value. Please ensure contract has allowed permissions with storage contract.");
1292 
1293     emit Deposit(currency, account, amount, issuerFirm);
1294 
1295     return true;
1296 
1297   }
1298 
1299   /**
1300    * @notice Withdraw an amount of currency from the Ethereum account holder
1301    * @dev | The total supply of the token decreases only when new funds are withdrawn 1:1
1302    * @dev | This method should only be called by authorized issuer firms
1303    * @param self Internal storage proxying TokenIOStorage contract
1304    * @param  currency Currency symbol of the token (e.g. USDx, JYPx, GBPx)
1305    * @param account Ethereum address of account holder to deposit funds for
1306    * @param amount Value of currency to withdraw for account
1307    * @param issuerFirm Name of the issuing firm authorizing the withdraw
1308    * @return { "success" : "Return true if successfully called from another contract" }
1309    */
1310   function withdraw(Data storage self, string currency, address account, uint amount, string issuerFirm) internal returns (bool success) {
1311     bytes32 id_a = keccak256(abi.encodePacked('token.balance', currency, getForwardedAccount(self, account)));
1312     bytes32 id_b = keccak256(abi.encodePacked('token.issued', currency, issuerFirm)); // possible for issuer to go negative
1313     bytes32 id_c = keccak256(abi.encodePacked('token.supply', currency));
1314 
1315     require(
1316       self.Storage.setUint(id_a, self.Storage.getUint(id_a).sub(amount)),
1317       "Error: Unable to set storage value. Please ensure contract has allowed permissions with storage contract.");
1318     require(
1319       self.Storage.setUint(id_b, self.Storage.getUint(id_b).sub(amount)),
1320       "Error: Unable to set storage value. Please ensure contract has allowed permissions with storage contract.");
1321     require(
1322       self.Storage.setUint(id_c, self.Storage.getUint(id_c).sub(amount)),
1323       "Error: Unable to set storage value. Please ensure contract has allowed permissions with storage contract.");
1324 
1325     emit Withdraw(currency, account, amount, issuerFirm);
1326 
1327     return true;
1328 
1329   }
1330 
1331   /**
1332    * @notice Method for setting a registered issuer firm
1333    * @dev | Only Token, Inc. and other authorized institutions may set a registered firm
1334    * @dev | The TokenIOAuthority.sol interface wraps this method
1335    * @dev | If the registered firm is unapproved; all authorized addresses of that firm will also be unapproved
1336    * @param self Internal storage proxying TokenIOStorage contract
1337    * @param issuerFirm Name of the firm to be registered
1338    * @param approved Approval status to set for the firm (true/false)
1339    * @return { "success" : "Return true if successfully called from another contract" }
1340    */
1341   function setRegisteredFirm(Data storage self, string issuerFirm, bool approved) internal returns (bool success) {
1342     bytes32 id = keccak256(abi.encodePacked('registered.firm', issuerFirm));
1343     require(
1344       self.Storage.setBool(id, approved),
1345       "Error: Unable to set storage value. Please ensure contract has allowed permissions with storage contract."
1346     );
1347     return true;
1348   }
1349 
1350   /**
1351    * @notice Method for setting a registered issuer firm authority
1352    * @dev | Only Token, Inc. and other approved institutions may set a registered firm
1353    * @dev | The TokenIOAuthority.sol interface wraps this method
1354    * @dev | Authority can only be set for a registered issuer firm
1355    * @param self Internal storage proxying TokenIOStorage contract
1356    * @param issuerFirm Name of the firm to be registered to authority
1357    * @param authorityAddress Ethereum address of the firm authority to be approved
1358    * @param approved Approval status to set for the firm authority (true/false)
1359    * @return { "success" : "Return true if successfully called from another contract" }
1360    */
1361   function setRegisteredAuthority(Data storage self, string issuerFirm, address authorityAddress, bool approved) internal returns (bool success) {
1362     require(
1363       isRegisteredFirm(self, issuerFirm),
1364       "Error: `issuerFirm` must be registered.");
1365 
1366     bytes32 id_a = keccak256(abi.encodePacked('registered.authority', issuerFirm, authorityAddress));
1367     bytes32 id_b = keccak256(abi.encodePacked('registered.authority.firm', authorityAddress));
1368 
1369     require(
1370       self.Storage.setBool(id_a, approved),
1371       "Error: Unable to set storage value. Please ensure contract has allowed permissions with storage contract.");
1372 
1373     require(
1374       self.Storage.setString(id_b, issuerFirm),
1375       "Error: Unable to set storage value. Please ensure contract has allowed permissions with storage contract.");
1376 
1377 
1378     return true;
1379   }
1380 
1381   /**
1382    * @notice Get the issuer firm registered to the authority Ethereum address
1383    * @dev | Only one firm can be registered per authority
1384    * @param self Internal storage proxying TokenIOStorage contract
1385    * @param authorityAddress Ethereum address of the firm authority to query
1386    * @return { "issuerFirm" : "Name of the firm registered to authority" }
1387    */
1388   function getFirmFromAuthority(Data storage self, address authorityAddress) internal view returns (string issuerFirm) {
1389     bytes32 id = keccak256(abi.encodePacked('registered.authority.firm', getForwardedAccount(self, authorityAddress)));
1390     return self.Storage.getString(id);
1391   }
1392 
1393   /**
1394    * @notice Return the boolean (true/false) registration status for an issuer firm
1395    * @param self Internal storage proxying TokenIOStorage contract
1396    * @param issuerFirm Name of the issuer firm
1397    * @return { "registered" : "Return if the issuer firm has been registered" }
1398    */
1399   function isRegisteredFirm(Data storage self, string issuerFirm) internal view returns (bool registered) {
1400     bytes32 id = keccak256(abi.encodePacked('registered.firm', issuerFirm));
1401     return self.Storage.getBool(id);
1402   }
1403 
1404   /**
1405    * @notice Return the boolean (true/false) status if an authority is registered to an issuer firm
1406    * @param self Internal storage proxying TokenIOStorage contract
1407    * @param issuerFirm Name of the issuer firm
1408    * @param authorityAddress Ethereum address of the firm authority to query
1409    * @return { "registered" : "Return if the authority is registered with the issuer firm" }
1410    */
1411   function isRegisteredToFirm(Data storage self, string issuerFirm, address authorityAddress) internal view returns (bool registered) {
1412     bytes32 id = keccak256(abi.encodePacked('registered.authority', issuerFirm, getForwardedAccount(self, authorityAddress)));
1413     return self.Storage.getBool(id);
1414   }
1415 
1416   /**
1417    * @notice Return if an authority address is registered
1418    * @dev | This also checks the status of the registered issuer firm
1419    * @param self Internal storage proxying TokenIOStorage contract
1420    * @param authorityAddress Ethereum address of the firm authority to query
1421    * @return { "registered" : "Return if the authority is registered" }
1422    */
1423   function isRegisteredAuthority(Data storage self, address authorityAddress) internal view returns (bool registered) {
1424     bytes32 id = keccak256(abi.encodePacked('registered.authority', getFirmFromAuthority(self, getForwardedAccount(self, authorityAddress)), getForwardedAccount(self, authorityAddress)));
1425     return self.Storage.getBool(id);
1426   }
1427 
1428   /**
1429    * @notice Return boolean transaction status if the transaction has been used
1430    * @param self Internal storage proxying TokenIOStorage contract
1431    * @param txHash keccak256 ABI tightly packed encoded hash digest of tx params
1432    * @return {"txStatus": "Returns true if the tx hash has already been set using `setTxStatus()` method"}
1433    */
1434   function getTxStatus(Data storage self, bytes32 txHash) internal view returns (bool txStatus) {
1435     bytes32 id = keccak256(abi.encodePacked('tx.status', txHash));
1436     return self.Storage.getBool(id);
1437   }
1438 
1439   /**
1440    * @notice Set transaction status if the transaction has been used
1441    * @param self Internal storage proxying TokenIOStorage contract
1442    * @param txHash keccak256 ABI tightly packed encoded hash digest of tx params
1443    * @return { "success" : "Return true if successfully called from another contract" }
1444    */
1445   function setTxStatus(Data storage self, bytes32 txHash) internal returns (bool success) {
1446     bytes32 id = keccak256(abi.encodePacked('tx.status', txHash));
1447     /// @dev Ensure transaction has not yet been used;
1448     require(!getTxStatus(self, txHash),
1449       "Error: Transaction status must be false before setting the transaction status.");
1450 
1451     /// @dev Update the status of the transaction;
1452     require(self.Storage.setBool(id, true),
1453       "Error: Unable to set storage value. Please ensure contract has allowed permissions with storage contract.");
1454 
1455     return true;
1456   }
1457 
1458   /**
1459    * @notice Accepts a signed fx request to swap currency pairs at a given amount;
1460    * @dev | This method can be called directly between peers
1461    * @dev | This method does not take transaction fees from the swap
1462    * @param self Internal storage proxying TokenIOStorage contract
1463    * @param  requester address Requester is the orginator of the offer and must
1464    * match the signature of the payload submitted by the fulfiller
1465    * @param  symbolA    Symbol of the currency desired
1466    * @param  symbolB    Symbol of the currency offered
1467    * @param  valueA     Amount of the currency desired
1468    * @param  valueB     Amount of the currency offered
1469    * @param  sigV       Ethereum secp256k1 signature V value; used by ecrecover()
1470    * @param  sigR       Ethereum secp256k1 signature R value; used by ecrecover()
1471    * @param  sigS       Ethereum secp256k1 signature S value; used by ecrecover()
1472    * @param  expiration Expiration of the offer; Offer is good until expired
1473    * @return {"success" : "Returns true if successfully called from another contract"}
1474    */
1475   function execSwap(
1476     Data storage self,
1477     address requester,
1478     string symbolA,
1479     string symbolB,
1480     uint valueA,
1481     uint valueB,
1482     uint8 sigV,
1483     bytes32 sigR,
1484     bytes32 sigS,
1485     uint expiration
1486   ) internal returns (bool success) {
1487 
1488     bytes32 fxTxHash = keccak256(abi.encodePacked(requester, symbolA, symbolB, valueA, valueB, expiration));
1489 
1490     /// @notice check that sender and requester accounts are verified
1491     /// @notice Only verified accounts can perform currency swaps
1492     require(
1493       verifyAccounts(self, msg.sender, requester),
1494       "Error: Only verified accounts can perform currency swaps.");
1495 
1496     /// @dev Immediately set this transaction to be confirmed before updating any params;
1497     require(
1498       setTxStatus(self, fxTxHash),
1499       "Error: Failed to set transaction status to fulfilled.");
1500 
1501     /// @dev Ensure contract has not yet expired;
1502     require(expiration >= now, "Error: Transaction has expired!");
1503 
1504     /// @dev Recover the address of the signature from the hashed digest;
1505     /// @dev Ensure it equals the requester's address
1506     require(
1507       ecrecover(fxTxHash, sigV, sigR, sigS) == requester,
1508       "Error: Address derived from transaction signature does not match the requester address");
1509 
1510     /// @dev Transfer funds from each account to another.
1511     require(
1512       forceTransfer(self, symbolA, msg.sender, requester, valueA, "0x0"),
1513       "Error: Unable to transfer funds to account.");
1514 
1515     require(
1516       forceTransfer(self, symbolB, requester, msg.sender, valueB, "0x0"),
1517       "Error: Unable to transfer funds to account.");
1518 
1519     emit FxSwap(symbolA, symbolB, valueA, valueB, expiration, fxTxHash);
1520 
1521     return true;
1522   }
1523 
1524   /**
1525    * @notice Deprecate a contract interface
1526    * @dev | This is a low-level method to deprecate a contract interface.
1527    * @dev | This is useful if the interface needs to be updated or becomes out of date
1528    * @param self Internal storage proxying TokenIOStorage contract
1529    * @param contractAddress Ethereum address of the contract interface
1530    * @return {"success" : "Returns true if successfully called from another contract"}
1531    */
1532   function setDeprecatedContract(Data storage self, address contractAddress) internal returns (bool success) {
1533     require(contractAddress != 0x0,
1534         "Error: cannot deprecate a null address.");
1535 
1536     bytes32 id = keccak256(abi.encodePacked('depcrecated', contractAddress));
1537 
1538     require(self.Storage.setBool(id, true),
1539       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract.");
1540 
1541     return true;
1542   }
1543 
1544   /**
1545    * @notice Return the deprecation status of a contract
1546    * @param self Internal storage proxying TokenIOStorage contract
1547    * @param contractAddress Ethereum address of the contract interface
1548    * @return {"status" : "Return deprecation status (true/false) of the contract interface"}
1549    */
1550   function isContractDeprecated(Data storage self, address contractAddress) internal view returns (bool status) {
1551     bytes32 id = keccak256(abi.encodePacked('depcrecated', contractAddress));
1552     return self.Storage.getBool(id);
1553   }
1554 
1555   /**
1556    * @notice Set the Account Spending Period Limit as UNIX timestamp
1557    * @dev | Each account has it's own daily spending limit
1558    * @param self Internal storage proxying TokenIOStorage contract
1559    * @param account Ethereum address of the account holder
1560    * @param period Unix timestamp of the spending period
1561    * @return {"success" : "Returns true is successfully called from a contract"}
1562    */
1563   function setAccountSpendingPeriod(Data storage self, address account, uint period) internal returns (bool success) {
1564     bytes32 id = keccak256(abi.encodePacked('limit.spending.period', account));
1565     require(self.Storage.setUint(id, period),
1566       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract.");
1567 
1568     return true;
1569   }
1570 
1571   /**
1572    * @notice Get the Account Spending Period Limit as UNIX timestamp
1573    * @dev | Each account has it's own daily spending limit
1574    * @dev | If the current spending period has expired, it will be set upon next `transfer()`
1575    * or `transferFrom()` request
1576    * @param self Internal storage proxying TokenIOStorage contract
1577    * @param account Ethereum address of the account holder
1578    * @return {"period" : "Returns Unix timestamp of the current spending period"}
1579    */
1580   function getAccountSpendingPeriod(Data storage self, address account) internal view returns (uint period) {
1581     bytes32 id = keccak256(abi.encodePacked('limit.spending.period', account));
1582     return self.Storage.getUint(id);
1583   }
1584 
1585   /**
1586    * @notice Set the account spending limit amount
1587    * @dev | Each account has it's own daily spending limit
1588    * @param self Internal storage proxying TokenIOStorage contract
1589    * @param account Ethereum address of the account holder
1590    * @param limit Spending limit amount
1591    * @return {"success" : "Returns true is successfully called from a contract"}
1592    */
1593   function setAccountSpendingLimit(Data storage self, address account, uint limit) internal returns (bool success) {
1594     bytes32 id = keccak256(abi.encodePacked('account.spending.limit', account));
1595     require(self.Storage.setUint(id, limit),
1596       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract.");
1597 
1598     return true;
1599   }
1600 
1601   /**
1602    * @notice Get the account spending limit amount
1603    * @dev | Each account has it's own daily spending limit
1604    * @param self Internal storage proxying TokenIOStorage contract
1605    * @param account Ethereum address of the account holder
1606    * @return {"limit" : "Returns the account spending limit amount"}
1607    */
1608   function getAccountSpendingLimit(Data storage self, address account) internal view returns (uint limit) {
1609     bytes32 id = keccak256(abi.encodePacked('account.spending.limit', account));
1610     return self.Storage.getUint(id);
1611   }
1612 
1613   /**
1614    * @notice Set the account spending amount for the daily period
1615    * @dev | Each account has it's own daily spending limit
1616    * @dev | This transaction will throw if the new spending amount is greater than the limit
1617    * @dev | This method is called in the `transfer()` and `transferFrom()` methods
1618    * @param self Internal storage proxying TokenIOStorage contract
1619    * @param account Ethereum address of the account holder
1620    * @param amount Set the amount spent for the daily period
1621    * @return {"success" : "Returns true is successfully called from a contract"}
1622    */
1623   function setAccountSpendingAmount(Data storage self, address account, uint amount) internal returns (bool success) {
1624 
1625     /// @dev NOTE: Always ensure the period is current when checking the daily spend limit
1626     require(updateAccountSpendingPeriod(self, account),
1627       "Error: Unable to update account spending period.");
1628 
1629     uint updatedAmount = getAccountSpendingAmount(self, account).add(amount);
1630 
1631     /// @dev Ensure the spend limit is greater than the amount spend for the period
1632     require(
1633       getAccountSpendingLimit(self, account) >= updatedAmount,
1634       "Error: Account cannot exceed its daily spend limit.");
1635 
1636     /// @dev Update the spending period amount if within limit
1637     bytes32 id = keccak256(abi.encodePacked('account.spending.amount', account, getAccountSpendingPeriod(self, account)));
1638     require(self.Storage.setUint(id, updatedAmount),
1639       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract.");
1640 
1641     return true;
1642   }
1643 
1644   /**
1645    * @notice Low-level API to ensure the account spending period is always current
1646    * @dev | This method is internally called by `setAccountSpendingAmount()` to ensure
1647    * spending period is always the most current daily period.
1648    * @param self Internal storage proxying TokenIOStorage contract
1649    * @param account Ethereum address of the account holder
1650    * @return {"success" : "Returns true is successfully called from a contract"}
1651    */
1652   function updateAccountSpendingPeriod(Data storage self, address account) internal returns (bool success) {
1653     uint begDate = getAccountSpendingPeriod(self, account);
1654     if (begDate > now) {
1655       return true;
1656     } else {
1657       uint duration = 86400; // 86400 seconds in a day
1658       require(
1659         setAccountSpendingPeriod(self, account, begDate.add(((now.sub(begDate)).div(duration).add(1)).mul(duration))),
1660         "Error: Unable to update account spending period.");
1661 
1662       return true;
1663     }
1664   }
1665 
1666   /**
1667    * @notice Return the amount spent during the current period
1668    * @dev | Each account has it's own daily spending limit
1669    * @param self Internal storage proxying TokenIOStorage contract
1670    * @param account Ethereum address of the account holder
1671    * @return {"amount" : "Returns the amount spent by the account during the current period"}
1672    */
1673   function getAccountSpendingAmount(Data storage self, address account) internal view returns (uint amount) {
1674     bytes32 id = keccak256(abi.encodePacked('account.spending.amount', account, getAccountSpendingPeriod(self, account)));
1675     return self.Storage.getUint(id);
1676   }
1677 
1678   /**
1679    * @notice Return the amount remaining during the current period
1680    * @dev | Each account has it's own daily spending limit
1681    * @param self Internal storage proxying TokenIOStorage contract
1682    * @param account Ethereum address of the account holder
1683    * @return {"amount" : "Returns the amount remaining by the account during the current period"}
1684    */
1685   function getAccountSpendingRemaining(Data storage self, address account) internal view returns (uint remainingLimit) {
1686     return getAccountSpendingLimit(self, account).sub(getAccountSpendingAmount(self, account));
1687   }
1688 
1689   /**
1690    * @notice Set the foreign currency exchange rate to USD in basis points
1691    * @dev | This value should always be relative to USD pair; e.g. JPY/USD, GBP/USD, etc.
1692    * @param self Internal storage proxying TokenIOStorage contract
1693    * @param currency The TokenIO currency symbol (e.g. USDx, JPYx, GBPx)
1694    * @param bpsRate Basis point rate of foreign currency exchange rate to USD
1695    * @return { "success": "Returns true if successfully called from another contract"}
1696    */
1697   function setFxUSDBPSRate(Data storage self, string currency, uint bpsRate) internal returns (bool success) {
1698     bytes32 id = keccak256(abi.encodePacked('fx.usd.rate', currency));
1699     require(
1700       self.Storage.setUint(id, bpsRate),
1701       "Error: Unable to update account spending period.");
1702 
1703     return true;
1704   }
1705 
1706   /**
1707    * @notice Return the foreign currency USD exchanged amount in basis points
1708    * @param self Internal storage proxying TokenIOStorage contract
1709    * @param currency The TokenIO currency symbol (e.g. USDx, JPYx, GBPx)
1710    * @return {"usdAmount" : "Returns the foreign currency amount in USD"}
1711    */
1712   function getFxUSDBPSRate(Data storage self, string currency) internal view returns (uint bpsRate) {
1713     bytes32 id = keccak256(abi.encodePacked('fx.usd.rate', currency));
1714     return self.Storage.getUint(id);
1715   }
1716 
1717   /**
1718    * @notice Return the foreign currency USD exchanged amount
1719    * @param self Internal storage proxying TokenIOStorage contract
1720    * @param currency The TokenIO currency symbol (e.g. USDx, JPYx, GBPx)
1721    * @param fxAmount Amount of foreign currency to exchange into USD
1722    * @return {"amount" : "Returns the foreign currency amount in USD"}
1723    */
1724   function getFxUSDAmount(Data storage self, string currency, uint fxAmount) internal view returns (uint amount) {
1725     uint usdDecimals = getTokenDecimals(self, 'USDx');
1726     uint fxDecimals = getTokenDecimals(self, currency);
1727     /// @dev ensure decimal precision is normalized to USD decimals
1728     uint usdAmount = ((fxAmount.mul(getFxUSDBPSRate(self, currency)).div(10000)).mul(10**usdDecimals)).div(10**fxDecimals);
1729     return usdAmount;
1730   }
1731 
1732 
1733 }
1734 
1735 /*
1736 COPYRIGHT 2018 Token, Inc.
1737 
1738 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
1739 INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
1740 PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
1741 COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
1742 IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
1743 WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
1744 
1745 @title ERC20 Compliant Smart Contract for Token, Inc.
1746 
1747 @author Ryan Tate <ryan.tate@token.io>, Sean Pollock <sean.pollock@token.io>
1748 
1749 @notice Contract uses generalized storage contract, `TokenIOStorage`, for
1750 upgradeability of interface contract.
1751 
1752 @dev In the event that the main contract becomes deprecated, the upgraded contract
1753 will be set as the owner of this contract, and use this contract's storage to
1754 maintain data consistency between contract.
1755 */
1756 
1757 
1758 
1759 contract TokenIOERC20 is Ownable {
1760   //// @dev Set reference to TokenIOLib interface which proxies to TokenIOStorage
1761   using TokenIOLib for TokenIOLib.Data;
1762   TokenIOLib.Data lib;
1763 
1764   /**
1765   * @notice Constructor method for ERC20 contract
1766   * @param _storageContract     address of TokenIOStorage contract
1767   */
1768   constructor(address _storageContract) public {
1769     //// @dev Set the storage contract for the interface
1770     //// @dev This contract will be unable to use the storage constract until
1771     //// @dev contract address is authorized with the storage contract
1772     //// @dev Once authorized, Use the `setParams` method to set storage values
1773     lib.Storage = TokenIOStorage(_storageContract);
1774 
1775     //// @dev set owner to contract initiator
1776     owner[msg.sender] = true;
1777   }
1778 
1779 
1780   /**
1781   @notice Sets erc20 globals and fee paramters
1782   @param _name Full token name  'USD by token.io'
1783   @param _symbol Symbol name 'USDx'
1784   @param _tla Three letter abbreviation 'USD'
1785   @param _version Release version 'v0.0.1'
1786   @param _decimals Decimal precision
1787   @param _feeContract Address of fee contract
1788   @return { "success" : "Returns true if successfully called from another contract"}
1789   */
1790   function setParams(
1791     string _name,
1792     string _symbol,
1793     string _tla,
1794     string _version,
1795     uint _decimals,
1796     address _feeContract,
1797     uint _fxUSDBPSRate
1798     ) onlyOwner public returns (bool success) {
1799       require(lib.setTokenName(_name),
1800         "Error: Unable to set token name. Please check arguments.");
1801       require(lib.setTokenSymbol(_symbol),
1802         "Error: Unable to set token symbol. Please check arguments.");
1803       require(lib.setTokenTLA(_tla),
1804         "Error: Unable to set token TLA. Please check arguments.");
1805       require(lib.setTokenVersion(_version),
1806         "Error: Unable to set token version. Please check arguments.");
1807       require(lib.setTokenDecimals(_symbol, _decimals),
1808         "Error: Unable to set token decimals. Please check arguments.");
1809       require(lib.setFeeContract(_feeContract),
1810         "Error: Unable to set fee contract. Please check arguments.");
1811       require(lib.setFxUSDBPSRate(_symbol, _fxUSDBPSRate),
1812         "Error: Unable to set fx USD basis points rate. Please check arguments.");
1813       return true;
1814     }
1815 
1816     /**
1817     * @notice Gets name of token
1818     * @return {"_name" : "Returns name of token"}
1819     */
1820     function name() public view returns (string _name) {
1821       return lib.getTokenName(address(this));
1822     }
1823 
1824     /**
1825     * @notice Gets symbol of token
1826     * @return {"_symbol" : "Returns symbol of token"}
1827     */
1828     function symbol() public view returns (string _symbol) {
1829       return lib.getTokenSymbol(address(this));
1830     }
1831 
1832     /**
1833     * @notice Gets three-letter-abbreviation of token
1834     * @return {"_tla" : "Returns three-letter-abbreviation of token"}
1835     */
1836     function tla() public view returns (string _tla) {
1837       return lib.getTokenTLA(address(this));
1838     }
1839 
1840     /**
1841     * @notice Gets version of token
1842     * @return {"_version" : "Returns version of token"}
1843     */
1844     function version() public view returns (string _version) {
1845       return lib.getTokenVersion(address(this));
1846     }
1847 
1848     /**
1849     * @notice Gets decimals of token
1850     * @return {"_decimals" : "Returns number of decimals"}
1851     */
1852     function decimals() public view returns (uint _decimals) {
1853       return lib.getTokenDecimals(lib.getTokenSymbol(address(this)));
1854     }
1855 
1856     /**
1857     * @notice Gets total supply of token
1858     * @return {"supply" : "Returns current total supply of token"}
1859     */
1860     function totalSupply() public view returns (uint supply) {
1861       return lib.getTokenSupply(lib.getTokenSymbol(address(this)));
1862     }
1863 
1864     /**
1865     * @notice Gets allowance that spender has with approver
1866     * @param account Address of approver
1867     * @param spender Address of spender
1868     * @return {"amount" : "Returns allowance of given account and spender"}
1869     */
1870     function allowance(address account, address spender) public view returns (uint amount) {
1871       return lib.getTokenAllowance(lib.getTokenSymbol(address(this)), account, spender);
1872     }
1873 
1874     /**
1875     * @notice Gets balance of account
1876     * @param account Address for balance lookup
1877     * @return {"balance" : "Returns balance amount"}
1878     */
1879     function balanceOf(address account) public view returns (uint balance) {
1880       return lib.getTokenBalance(lib.getTokenSymbol(address(this)), account);
1881     }
1882 
1883     /**
1884     * @notice Gets fee parameters
1885     * @return {
1886       "bps":"Fee amount as a mesuare of basis points",
1887       "min":"Minimum fee amount",
1888       "max":"Maximum fee amount",
1889       "flat":"Flat fee amount",
1890       "contract":"Address of fee contract"
1891       }
1892     */
1893     function getFeeParams() public view returns (uint bps, uint min, uint max, uint flat, bytes feeMsg, address feeAccount) {
1894       address feeContract = lib.getFeeContract(address(this));
1895       return (
1896         lib.getFeeBPS(feeContract),
1897         lib.getFeeMin(feeContract),
1898         lib.getFeeMax(feeContract),
1899         lib.getFeeFlat(feeContract),
1900         lib.getFeeMsg(feeContract),
1901         feeContract
1902       );
1903     }
1904 
1905     /**
1906     * @notice Calculates fee of a given transfer amount
1907     * @param amount Amount to calculcate fee value
1908     * @return {"fees": "Returns the calculated transaction fees based on the fee contract parameters"}
1909     */
1910     function calculateFees(uint amount) public view returns (uint fees) {
1911       return lib.calculateFees(lib.getFeeContract(address(this)), amount);
1912     }
1913 
1914     /**
1915     * @notice transfers 'amount' from msg.sender to a receiving account 'to'
1916     * @param to Receiving address
1917     * @param amount Transfer amount
1918     * @return {"success" : "Returns true if transfer succeeds"}
1919     */
1920     function transfer(address to, uint amount) public notDeprecated returns (bool success) {
1921       /// @notice send transfer through library
1922       /// @dev !!! mutates storage state
1923       require(
1924         lib.transfer(lib.getTokenSymbol(address(this)), to, amount, "0x0"),
1925         "Error: Unable to transfer funds. Please check your parameters."
1926       );
1927       return true;
1928     }
1929 
1930     /**
1931     * @notice spender transfers from approvers account to the reciving account
1932     * @param from Approver's address
1933     * @param to Receiving address
1934     * @param amount Transfer amount
1935     * @return {"success" : "Returns true if transferFrom succeeds"}
1936     */
1937     function transferFrom(address from, address to, uint amount) public notDeprecated returns (bool success) {
1938       /// @notice sends transferFrom through library
1939       /// @dev !!! mutates storage state
1940       require(
1941         lib.transferFrom(lib.getTokenSymbol(address(this)), from, to, amount, "0x0"),
1942         "Error: Unable to transfer funds. Please check your parameters and ensure the spender has the approved amount of funds to transfer."
1943       );
1944       return true;
1945     }
1946 
1947     /**
1948     * @notice approves spender a given amount
1949     * @param spender Spender's address
1950     * @param amount Allowance amount
1951     * @return {"success" : "Returns true if approve succeeds"}
1952     */
1953     function approve(address spender, uint amount) public notDeprecated returns (bool success) {
1954       /// @notice sends approve through library
1955       /// @dev !!! mtuates storage states
1956       require(
1957         lib.approveAllowance(spender, amount),
1958         "Error: Unable to approve allowance for spender. Please ensure spender is not null and does not have a frozen balance."
1959       );
1960       return true;
1961     }
1962 
1963     /**
1964     * @notice gets currency status of contract
1965     * @return {"deprecated" : "Returns true if deprecated, false otherwise"}
1966     */
1967     function deprecateInterface() public onlyOwner returns (bool deprecated) {
1968       require(lib.setDeprecatedContract(address(this)),
1969         "Error: Unable to deprecate contract!");
1970       return true;
1971     }
1972 
1973     modifier notDeprecated() {
1974       /// @notice throws if contract is deprecated
1975       require(!lib.isContractDeprecated(address(this)),
1976         "Error: Contract has been deprecated, cannot perform operation!");
1977       _;
1978     }
1979 
1980   }