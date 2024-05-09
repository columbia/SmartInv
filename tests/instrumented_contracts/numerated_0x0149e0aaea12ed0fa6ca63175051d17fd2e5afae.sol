1 pragma solidity 0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @notice Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @notice Multiplies two numbers, throws on overflow.
11   * @param a Multiplier
12   * @param b Multiplicand
13   * @return {"result" : "Returns product"}
14   */
15   function mul(uint256 a, uint256 b) internal pure returns (uint256 result) {
16     if (a == 0) {
17       return 0;
18     }
19     uint256 c = a * b;
20     require(c / a == b, "Error: Unsafe multiplication operation!");
21     return c;
22   }
23 
24   /**
25   * @notice Integer division of two numbers, truncating the quotient.
26   * @param a Dividend
27   * @param b Divisor
28   * @return {"result" : "Returns quotient"}
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256 result) {
31     // @dev require(b > 0); // Solidity automatically throws when dividing by 0
32     uint256 c = a / b;
33     // @dev require(a == b * c + a % b); // There is no case in which this doesn't hold
34     return c;
35   }
36 
37   /**
38   * @notice Subtracts two numbers, throws on underflow.
39   * @param a Subtrahend
40   * @param b Minuend
41   * @return {"result" : "Returns difference"}
42   */
43   function sub(uint256 a, uint256 b) internal pure returns (uint256 result) {
44     // @dev throws on overflow (i.e. if subtrahend is greater than minuend)
45     require(b <= a, "Error: Unsafe subtraction operation!");
46     return a - b;
47   }
48 
49   /**
50   * @notice Adds two numbers, throws on overflow.
51   * @param a First addend
52   * @param b Second addend
53   * @return {"result" : "Returns summation"}
54   */
55   function add(uint256 a, uint256 b) internal pure returns (uint256 result) {
56     uint256 c = a + b;
57     require(c >= a, "Error: Unsafe addition operation!");
58     return c;
59   }
60 }
61 
62 
63 /**
64 
65 COPYRIGHT 2018 Token, Inc.
66 
67 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
68 INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
69 PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
70 COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
71 IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
72 WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
73 
74 
75 @title Ownable
76 @dev The Ownable contract has an owner address, and provides basic authorization control
77 functions, this simplifies the implementation of "user permissions".
78 
79 
80  */
81 contract Ownable {
82 
83   mapping(address => bool) public owner;
84 
85   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
86   event AllowOwnership(address indexed allowedAddress);
87   event RevokeOwnership(address indexed allowedAddress);
88 
89   /**
90    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
91    * account.
92    */
93   constructor() public {
94     owner[msg.sender] = true;
95   }
96 
97   /**
98    * @dev Throws if called by any account other than the owner.
99    */
100   modifier onlyOwner() {
101     require(owner[msg.sender], "Error: Transaction sender is not allowed by the contract.");
102     _;
103   }
104 
105   /**
106    * @dev Allows the current owner to transfer control of the contract to a newOwner.
107    * @param newOwner The address to transfer ownership to.
108    * @return {"success" : "Returns true when successfully transferred ownership"}
109    */
110   function transferOwnership(address newOwner) public onlyOwner returns (bool success) {
111     require(newOwner != address(0), "Error: newOwner cannot be null!");
112     emit OwnershipTransferred(msg.sender, newOwner);
113     owner[newOwner] = true;
114     owner[msg.sender] = false;
115     return true;
116   }
117 
118   /**
119    * @dev Allows interface contracts and accounts to access contract methods (e.g. Storage contract)
120    * @param allowedAddress The address of new owner
121    * @return {"success" : "Returns true when successfully allowed ownership"}
122    */
123   function allowOwnership(address allowedAddress) public onlyOwner returns (bool success) {
124     owner[allowedAddress] = true;
125     emit AllowOwnership(allowedAddress);
126     return true;
127   }
128 
129   /**
130    * @dev Disallows interface contracts and accounts to access contract methods (e.g. Storage contract)
131    * @param allowedAddress The address to disallow ownership
132    * @return {"success" : "Returns true when successfully allowed ownership"}
133    */
134   function removeOwnership(address allowedAddress) public onlyOwner returns (bool success) {
135     owner[allowedAddress] = false;
136     emit RevokeOwnership(allowedAddress);
137     return true;
138   }
139 
140 }
141 
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
399 
400 /**
401 COPYRIGHT 2018 Token, Inc.
402 
403 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
404 INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
405 PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
406 COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
407 IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
408 WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
409 
410 
411 @title TokenIOLib
412 
413 @author Ryan Tate <ryan.tate@token.io>, Sean Pollock <sean.pollock@token.io>
414 
415 @notice This library proxies the TokenIOStorage contract for the interface contract,
416 allowing the library and the interfaces to remain stateless, and share a universally
417 available storage contract between interfaces.
418 
419 
420 */
421 
422 
423 library TokenIOLib {
424 
425   /// @dev all math operating are using SafeMath methods to check for overflow/underflows
426   using SafeMath for uint;
427 
428   /// @dev the Data struct uses the Storage contract for stateful setters
429   struct Data {
430     TokenIOStorage Storage;
431   }
432 
433   /// @notice Not using `Log` prefix for events to be consistent with ERC20 named events;
434   event Approval(address indexed owner, address indexed spender, uint amount);
435   event Deposit(string currency, address indexed account, uint amount, string issuerFirm);
436   event Withdraw(string currency, address indexed account, uint amount, string issuerFirm);
437   event Transfer(string currency, address indexed from, address indexed to, uint amount, bytes data);
438   event KYCApproval(address indexed account, bool status, string issuerFirm);
439   event AccountStatus(address indexed account, bool status, string issuerFirm);
440   event FxSwap(string tokenASymbol,string tokenBSymbol,uint tokenAValue,uint tokenBValue, uint expiration, bytes32 transactionHash);
441   event AccountForward(address indexed originalAccount, address indexed forwardedAccount);
442   event NewAuthority(address indexed authority, string issuerFirm);
443 
444   /**
445    * @notice Set the token name for Token interfaces
446    * @dev This method must be set by the token interface's setParams() method
447    * @dev | This method has an `internal` view
448    * @param self Internal storage proxying TokenIOStorage contract
449    * @param tokenName Name of the token contract
450    * @return {"success" : "Returns true when successfully called from another contract"}
451    */
452   function setTokenName(Data storage self, string tokenName) internal returns (bool success) {
453     bytes32 id = keccak256(abi.encodePacked('token.name', address(this)));
454     require(
455       self.Storage.setString(id, tokenName),
456       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract."
457     );
458     return true;
459   }
460 
461   /**
462    * @notice Set the token symbol for Token interfaces
463    * @dev This method must be set by the token interface's setParams() method
464    * @dev | This method has an `internal` view
465    * @param self Internal storage proxying TokenIOStorage contract
466    * @param tokenSymbol Symbol of the token contract
467    * @return {"success" : "Returns true when successfully called from another contract"}
468    */
469   function setTokenSymbol(Data storage self, string tokenSymbol) internal returns (bool success) {
470     bytes32 id = keccak256(abi.encodePacked('token.symbol', address(this)));
471     require(
472       self.Storage.setString(id, tokenSymbol),
473       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract."
474     );
475     return true;
476   }
477 
478   /**
479    * @notice Set the token three letter abreviation (TLA) for Token interfaces
480    * @dev This method must be set by the token interface's setParams() method
481    * @dev | This method has an `internal` view
482    * @param self Internal storage proxying TokenIOStorage contract
483    * @param tokenTLA TLA of the token contract
484    * @return {"success" : "Returns true when successfully called from another contract"}
485    */
486   function setTokenTLA(Data storage self, string tokenTLA) internal returns (bool success) {
487     bytes32 id = keccak256(abi.encodePacked('token.tla', address(this)));
488     require(
489       self.Storage.setString(id, tokenTLA),
490       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract."
491     );
492     return true;
493   }
494 
495   /**
496    * @notice Set the token version for Token interfaces
497    * @dev This method must be set by the token interface's setParams() method
498    * @dev | This method has an `internal` view
499    * @param self Internal storage proxying TokenIOStorage contract
500    * @param tokenVersion Semantic (vMAJOR.MINOR.PATCH | e.g. v0.1.0) version of the token contract
501    * @return {"success" : "Returns true when successfully called from another contract"}
502    */
503   function setTokenVersion(Data storage self, string tokenVersion) internal returns (bool success) {
504     bytes32 id = keccak256(abi.encodePacked('token.version', address(this)));
505     require(
506       self.Storage.setString(id, tokenVersion),
507       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract."
508     );
509     return true;
510   }
511 
512   /**
513    * @notice Set the token decimals for Token interfaces
514    * @dev This method must be set by the token interface's setParams() method
515    * @dev | This method has an `internal` view
516    * @dev This method is not set to the address of the contract, rather is maped to currency
517    * @dev To derive decimal value, divide amount by 10^decimal representation (e.g. 10132 / 10**2 == 101.32)
518    * @param self Internal storage proxying TokenIOStorage contract
519    * @param  currency Currency symbol of the token (e.g. USDx, JYPx, GBPx)
520    * @param tokenDecimals Decimal representation of the token contract unit amount
521    * @return {"success" : "Returns true when successfully called from another contract"}
522    */
523   function setTokenDecimals(Data storage self, string currency, uint tokenDecimals) internal returns (bool success) {
524     bytes32 id = keccak256(abi.encodePacked('token.decimals', currency));
525     require(
526       self.Storage.setUint(id, tokenDecimals),
527       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract."
528     );
529     return true;
530   }
531 
532   /**
533    * @notice Set basis point fee for contract interface
534    * @dev Transaction fees can be set by the TokenIOFeeContract
535    * @dev Fees vary by contract interface specified `feeContract`
536    * @dev | This method has an `internal` view
537    * @param self Internal storage proxying TokenIOStorage contract
538    * @param feeBPS Basis points fee for interface contract transactions
539    * @return {"success" : "Returns true when successfully called from another contract"}
540    */
541   function setFeeBPS(Data storage self, uint feeBPS) internal returns (bool success) {
542     bytes32 id = keccak256(abi.encodePacked('fee.bps', address(this)));
543     require(
544       self.Storage.setUint(id, feeBPS),
545       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract."
546     );
547     return true;
548   }
549 
550   /**
551    * @notice Set minimum fee for contract interface
552    * @dev Transaction fees can be set by the TokenIOFeeContract
553    * @dev Fees vary by contract interface specified `feeContract`
554    * @dev | This method has an `internal` view
555    * @param self Internal storage proxying TokenIOStorage contract
556    * @param feeMin Minimum fee for interface contract transactions
557    * @return {"success" : "Returns true when successfully called from another contract"}
558    */
559   function setFeeMin(Data storage self, uint feeMin) internal returns (bool success) {
560     bytes32 id = keccak256(abi.encodePacked('fee.min', address(this)));
561     require(
562       self.Storage.setUint(id, feeMin),
563       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract."
564     );
565     return true;
566   }
567 
568   /**
569    * @notice Set maximum fee for contract interface
570    * @dev Transaction fees can be set by the TokenIOFeeContract
571    * @dev Fees vary by contract interface specified `feeContract`
572    * @dev | This method has an `internal` view
573    * @param self Internal storage proxying TokenIOStorage contract
574    * @param feeMax Maximum fee for interface contract transactions
575    * @return {"success" : "Returns true when successfully called from another contract"}
576    */
577   function setFeeMax(Data storage self, uint feeMax) internal returns (bool success) {
578     bytes32 id = keccak256(abi.encodePacked('fee.max', address(this)));
579     require(
580       self.Storage.setUint(id, feeMax),
581       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract."
582     );
583     return true;
584   }
585 
586   /**
587    * @notice Set flat fee for contract interface
588    * @dev Transaction fees can be set by the TokenIOFeeContract
589    * @dev Fees vary by contract interface specified `feeContract`
590    * @dev | This method has an `internal` view
591    * @param self Internal storage proxying TokenIOStorage contract
592    * @param feeFlat Flat fee for interface contract transactions
593    * @return {"success" : "Returns true when successfully called from another contract"}
594    */
595   function setFeeFlat(Data storage self, uint feeFlat) internal returns (bool success) {
596     bytes32 id = keccak256(abi.encodePacked('fee.flat', address(this)));
597     require(
598       self.Storage.setUint(id, feeFlat),
599       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract."
600     );
601     return true;
602   }
603 
604   /**
605    * @notice Set fee message for contract interface
606    * @dev Default fee messages can be set by the TokenIOFeeContract (e.g. "tx_fees")
607    * @dev Fee messages vary by contract interface specified `feeContract`
608    * @dev | This method has an `internal` view
609    * @param self Internal storage proxying TokenIOStorage contract
610    * @param feeMsg Fee message included in a transaction with fees
611    * @return {"success" : "Returns true when successfully called from another contract"}
612    */
613   function setFeeMsg(Data storage self, bytes feeMsg) internal returns (bool success) {
614     bytes32 id = keccak256(abi.encodePacked('fee.msg', address(this)));
615     require(
616       self.Storage.setBytes(id, feeMsg),
617       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract."
618     );
619     return true;
620   }
621 
622   /**
623    * @notice Set fee contract for a contract interface
624    * @dev feeContract must be a TokenIOFeeContract storage approved contract
625    * @dev Fees vary by contract interface specified `feeContract`
626    * @dev | This method has an `internal` view
627    * @dev | This must be called directly from the interface contract
628    * @param self Internal storage proxying TokenIOStorage contract
629    * @param feeContract Set the fee contract for `this` contract address interface
630    * @return {"success" : "Returns true when successfully called from another contract"}
631    */
632   function setFeeContract(Data storage self, address feeContract) internal returns (bool success) {
633     bytes32 id = keccak256(abi.encodePacked('fee.account', address(this)));
634     require(
635       self.Storage.setAddress(id, feeContract),
636       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract."
637     );
638     return true;
639   }
640 
641   /**
642    * @notice Set contract interface associated with a given TokenIO currency symbol (e.g. USDx)
643    * @dev | This should only be called once from a token interface contract;
644    * @dev | This method has an `internal` view
645    * @dev | This method is experimental and may be deprecated/refactored
646    * @param self Internal storage proxying TokenIOStorage contract
647    * @param  currency Currency symbol of the token (e.g. USDx, JYPx, GBPx)
648    * @return {"success" : "Returns true when successfully called from another contract"}
649    */
650   function setTokenNameSpace(Data storage self, string currency) internal returns (bool success) {
651     bytes32 id = keccak256(abi.encodePacked('token.namespace', currency));
652     require(
653       self.Storage.setAddress(id, address(this)),
654       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract."
655     );
656     return true;
657   }
658 
659   /**
660    * @notice Set the KYC approval status (true/false) for a given account
661    * @dev | This method has an `internal` view
662    * @dev | Every account must be KYC'd to be able to use transfer() & transferFrom() methods
663    * @dev | To gain approval for an account, register at https://tsm.token.io/sign-up
664    * @param self Internal storage proxying TokenIOStorage contract
665    * @param account Ethereum address of account holder
666    * @param isApproved Boolean (true/false) KYC approval status for a given account
667    * @param issuerFirm Firm name for issuing KYC approval
668    * @return {"success" : "Returns true when successfully called from another contract"}
669    */
670   function setKYCApproval(Data storage self, address account, bool isApproved, string issuerFirm) internal returns (bool success) {
671       bytes32 id = keccak256(abi.encodePacked('account.kyc', getForwardedAccount(self, account)));
672       require(
673         self.Storage.setBool(id, isApproved),
674         "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract."
675       );
676 
677       /// @dev NOTE: Issuer is logged for setting account KYC status
678       emit KYCApproval(account, isApproved, issuerFirm);
679       return true;
680   }
681 
682   /**
683    * @notice Set the global approval status (true/false) for a given account
684    * @dev | This method has an `internal` view
685    * @dev | Every account must be permitted to be able to use transfer() & transferFrom() methods
686    * @dev | To gain approval for an account, register at https://tsm.token.io/sign-up
687    * @param self Internal storage proxying TokenIOStorage contract
688    * @param account Ethereum address of account holder
689    * @param isAllowed Boolean (true/false) global status for a given account
690    * @param issuerFirm Firm name for issuing approval
691    * @return {"success" : "Returns true when successfully called from another contract"}
692    */
693   function setAccountStatus(Data storage self, address account, bool isAllowed, string issuerFirm) internal returns (bool success) {
694     bytes32 id = keccak256(abi.encodePacked('account.allowed', getForwardedAccount(self, account)));
695     require(
696       self.Storage.setBool(id, isAllowed),
697       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract."
698     );
699 
700     /// @dev NOTE: Issuer is logged for setting account status
701     emit AccountStatus(account, isAllowed, issuerFirm);
702     return true;
703   }
704 
705 
706   /**
707    * @notice Set a forwarded address for an account.
708    * @dev | This method has an `internal` view
709    * @dev | Forwarded accounts must be set by an authority in case of account recovery;
710    * @dev | Additionally, the original owner can set a forwarded account (e.g. add a new device, spouse, dependent, etc)
711    * @dev | All transactions will be logged under the same KYC information as the original account holder;
712    * @param self Internal storage proxying TokenIOStorage contract
713    * @param originalAccount Original registered Ethereum address of the account holder
714    * @param forwardedAccount Forwarded Ethereum address of the account holder
715    * @return {"success" : "Returns true when successfully called from another contract"}
716    */
717   function setForwardedAccount(Data storage self, address originalAccount, address forwardedAccount) internal returns (bool success) {
718     bytes32 id = keccak256(abi.encodePacked('master.account', forwardedAccount));
719     require(
720       self.Storage.setAddress(id, originalAccount),
721       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract."
722     );
723     return true;
724   }
725 
726   /**
727    * @notice Get the original address for a forwarded account
728    * @dev | This method has an `internal` view
729    * @dev | Will return the registered account for the given forwarded account
730    * @param self Internal storage proxying TokenIOStorage contract
731    * @param account Ethereum address of account holder
732    * @return { "registeredAccount" : "Will return the original account of a forwarded account or the account itself if no account found"}
733    */
734   function getForwardedAccount(Data storage self, address account) internal view returns (address registeredAccount) {
735     bytes32 id = keccak256(abi.encodePacked('master.account', account));
736     address originalAccount = self.Storage.getAddress(id);
737     if (originalAccount != 0x0) {
738       return originalAccount;
739     } else {
740       return account;
741     }
742   }
743 
744   /**
745    * @notice Get KYC approval status for the account holder
746    * @dev | This method has an `internal` view
747    * @dev | All forwarded accounts will use the original account's status
748    * @param self Internal storage proxying TokenIOStorage contract
749    * @param account Ethereum address of account holder
750    * @return { "status" : "Returns the KYC approval status for an account holder" }
751    */
752   function getKYCApproval(Data storage self, address account) internal view returns (bool status) {
753       bytes32 id = keccak256(abi.encodePacked('account.kyc', getForwardedAccount(self, account)));
754       return self.Storage.getBool(id);
755   }
756 
757   /**
758    * @notice Get global approval status for the account holder
759    * @dev | This method has an `internal` view
760    * @dev | All forwarded accounts will use the original account's status
761    * @param self Internal storage proxying TokenIOStorage contract
762    * @param account Ethereum address of account holder
763    * @return { "status" : "Returns the global approval status for an account holder" }
764    */
765   function getAccountStatus(Data storage self, address account) internal view returns (bool status) {
766     bytes32 id = keccak256(abi.encodePacked('account.allowed', getForwardedAccount(self, account)));
767     return self.Storage.getBool(id);
768   }
769 
770   /**
771    * @notice Get the contract interface address associated with token symbol
772    * @dev | This method has an `internal` view
773    * @param self Internal storage proxying TokenIOStorage contract
774    * @param  currency Currency symbol of the token (e.g. USDx, JYPx, GBPx)
775    * @return { "contractAddress" : "Returns the contract interface address for a symbol" }
776    */
777   function getTokenNameSpace(Data storage self, string currency) internal view returns (address contractAddress) {
778     bytes32 id = keccak256(abi.encodePacked('token.namespace', currency));
779     return self.Storage.getAddress(id);
780   }
781 
782   /**
783    * @notice Get the token name for Token interfaces
784    * @dev This method must be set by the token interface's setParams() method
785    * @dev | This method has an `internal` view
786    * @param self Internal storage proxying TokenIOStorage contract
787    * @param contractAddress Contract address of the queryable interface
788    * @return {"tokenName" : "Name of the token contract"}
789    */
790   function getTokenName(Data storage self, address contractAddress) internal view returns (string tokenName) {
791     bytes32 id = keccak256(abi.encodePacked('token.name', contractAddress));
792     return self.Storage.getString(id);
793   }
794 
795   /**
796    * @notice Get the token symbol for Token interfaces
797    * @dev This method must be set by the token interface's setParams() method
798    * @dev | This method has an `internal` view
799    * @param self Internal storage proxying TokenIOStorage contract
800    * @param contractAddress Contract address of the queryable interface
801    * @return {"tokenSymbol" : "Symbol of the token contract"}
802    */
803   function getTokenSymbol(Data storage self, address contractAddress) internal view returns (string tokenSymbol) {
804     bytes32 id = keccak256(abi.encodePacked('token.symbol', contractAddress));
805     return self.Storage.getString(id);
806   }
807 
808   /**
809    * @notice Get the token Three letter abbreviation (TLA) for Token interfaces
810    * @dev This method must be set by the token interface's setParams() method
811    * @dev | This method has an `internal` view
812    * @param self Internal storage proxying TokenIOStorage contract
813    * @param contractAddress Contract address of the queryable interface
814    * @return {"tokenTLA" : "TLA of the token contract"}
815    */
816   function getTokenTLA(Data storage self, address contractAddress) internal view returns (string tokenTLA) {
817     bytes32 id = keccak256(abi.encodePacked('token.tla', contractAddress));
818     return self.Storage.getString(id);
819   }
820 
821   /**
822    * @notice Get the token version for Token interfaces
823    * @dev This method must be set by the token interface's setParams() method
824    * @dev | This method has an `internal` view
825    * @param self Internal storage proxying TokenIOStorage contract
826    * @param contractAddress Contract address of the queryable interface
827    * @return {"tokenVersion" : "Semantic version of the token contract"}
828    */
829   function getTokenVersion(Data storage self, address contractAddress) internal view returns (string) {
830     bytes32 id = keccak256(abi.encodePacked('token.version', contractAddress));
831     return self.Storage.getString(id);
832   }
833 
834   /**
835    * @notice Get the token decimals for Token interfaces
836    * @dev This method must be set by the token interface's setParams() method
837    * @dev | This method has an `internal` view
838    * @param self Internal storage proxying TokenIOStorage contract
839    * @param  currency Currency symbol of the token (e.g. USDx, JYPx, GBPx)
840    * @return {"tokenDecimals" : "Decimals of the token contract"}
841    */
842   function getTokenDecimals(Data storage self, string currency) internal view returns (uint tokenDecimals) {
843     bytes32 id = keccak256(abi.encodePacked('token.decimals', currency));
844     return self.Storage.getUint(id);
845   }
846 
847   /**
848    * @notice Get the basis points fee of the contract address; typically TokenIOFeeContract
849    * @dev | This method has an `internal` view
850    * @param self Internal storage proxying TokenIOStorage contract
851    * @param contractAddress Contract address of the queryable interface
852    * @return { "feeBps" : "Returns the basis points fees associated with the contract address"}
853    */
854   function getFeeBPS(Data storage self, address contractAddress) internal view returns (uint feeBps) {
855     bytes32 id = keccak256(abi.encodePacked('fee.bps', contractAddress));
856     return self.Storage.getUint(id);
857   }
858 
859   /**
860    * @notice Get the minimum fee of the contract address; typically TokenIOFeeContract
861    * @dev | This method has an `internal` view
862    * @param self Internal storage proxying TokenIOStorage contract
863    * @param contractAddress Contract address of the queryable interface
864    * @return { "feeMin" : "Returns the minimum fees associated with the contract address"}
865    */
866   function getFeeMin(Data storage self, address contractAddress) internal view returns (uint feeMin) {
867     bytes32 id = keccak256(abi.encodePacked('fee.min', contractAddress));
868     return self.Storage.getUint(id);
869   }
870 
871   /**
872    * @notice Get the maximum fee of the contract address; typically TokenIOFeeContract
873    * @dev | This method has an `internal` view
874    * @param self Internal storage proxying TokenIOStorage contract
875    * @param contractAddress Contract address of the queryable interface
876    * @return { "feeMax" : "Returns the maximum fees associated with the contract address"}
877    */
878   function getFeeMax(Data storage self, address contractAddress) internal view returns (uint feeMax) {
879     bytes32 id = keccak256(abi.encodePacked('fee.max', contractAddress));
880     return self.Storage.getUint(id);
881   }
882 
883   /**
884    * @notice Get the flat fee of the contract address; typically TokenIOFeeContract
885    * @dev | This method has an `internal` view
886    * @param self Internal storage proxying TokenIOStorage contract
887    * @param contractAddress Contract address of the queryable interface
888    * @return { "feeFlat" : "Returns the flat fees associated with the contract address"}
889    */
890   function getFeeFlat(Data storage self, address contractAddress) internal view returns (uint feeFlat) {
891     bytes32 id = keccak256(abi.encodePacked('fee.flat', contractAddress));
892     return self.Storage.getUint(id);
893   }
894 
895   /**
896    * @notice Get the flat message of the contract address; typically TokenIOFeeContract
897    * @dev | This method has an `internal` view
898    * @param self Internal storage proxying TokenIOStorage contract
899    * @param contractAddress Contract address of the queryable interface
900    * @return { "feeMsg" : "Returns the fee message (bytes) associated with the contract address"}
901    */
902   function getFeeMsg(Data storage self, address contractAddress) internal view returns (bytes feeMsg) {
903     bytes32 id = keccak256(abi.encodePacked('fee.msg', contractAddress));
904     return self.Storage.getBytes(id);
905   }
906 
907   /**
908    * @notice Set the master fee contract used as the default fee contract when none is provided
909    * @dev | This method has an `internal` view
910    * @dev | This value is set in the TokenIOAuthority contract
911    * @param self Internal storage proxying TokenIOStorage contract
912    * @param contractAddress Contract address of the queryable interface
913    * @return { "success" : "Returns true when successfully called from another contract"}
914    */
915   function setMasterFeeContract(Data storage self, address contractAddress) internal returns (bool success) {
916     bytes32 id = keccak256(abi.encodePacked('fee.contract.master'));
917     require(
918       self.Storage.setAddress(id, contractAddress),
919       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract."
920     );
921     return true;
922   }
923 
924   /**
925    * @notice Get the master fee contract set via the TokenIOAuthority contract
926    * @dev | This method has an `internal` view
927    * @param self Internal storage proxying TokenIOStorage contract
928    * @return { "masterFeeContract" : "Returns the master fee contract set for TSM."}
929    */
930   function getMasterFeeContract(Data storage self) internal view returns (address masterFeeContract) {
931     bytes32 id = keccak256(abi.encodePacked('fee.contract.master'));
932     return self.Storage.getAddress(id);
933   }
934 
935   /**
936    * @notice Get the fee contract set for a contract interface
937    * @dev | This method has an `internal` view
938    * @dev | Custom fee pricing can be set by assigning a fee contract to transactional contract interfaces
939    * @dev | If a fee contract has not been set by an interface contract, then the master fee contract will be returned
940    * @param self Internal storage proxying TokenIOStorage contract
941    * @param contractAddress Contract address of the queryable interface
942    * @return { "feeContract" : "Returns the fee contract associated with a contract interface"}
943    */
944   function getFeeContract(Data storage self, address contractAddress) internal view returns (address feeContract) {
945     bytes32 id = keccak256(abi.encodePacked('fee.account', contractAddress));
946 
947     address feeAccount = self.Storage.getAddress(id);
948     if (feeAccount == 0x0) {
949       return getMasterFeeContract(self);
950     } else {
951       return feeAccount;
952     }
953   }
954 
955   /**
956    * @notice Get the token supply for a given TokenIO TSM currency symbol (e.g. USDx)
957    * @dev | This method has an `internal` view
958    * @param self Internal storage proxying TokenIOStorage contract
959    * @param  currency Currency symbol of the token (e.g. USDx, JYPx, GBPx)
960    * @return { "supply" : "Returns the token supply of the given currency"}
961    */
962   function getTokenSupply(Data storage self, string currency) internal view returns (uint supply) {
963     bytes32 id = keccak256(abi.encodePacked('token.supply', currency));
964     return self.Storage.getUint(id);
965   }
966 
967   /**
968    * @notice Get the token spender allowance for a given account
969    * @dev | This method has an `internal` view
970    * @param self Internal storage proxying TokenIOStorage contract
971    * @param account Ethereum address of account holder
972    * @param spender Ethereum address of spender
973    * @return { "allowance" : "Returns the allowance of a given spender for a given account"}
974    */
975   function getTokenAllowance(Data storage self, string currency, address account, address spender) internal view returns (uint allowance) {
976     bytes32 id = keccak256(abi.encodePacked('token.allowance', currency, getForwardedAccount(self, account), getForwardedAccount(self, spender)));
977     return self.Storage.getUint(id);
978   }
979 
980   /**
981    * @notice Get the token balance for a given account
982    * @dev | This method has an `internal` view
983    * @param self Internal storage proxying TokenIOStorage contract
984    * @param  currency Currency symbol of the token (e.g. USDx, JYPx, GBPx)
985    * @param account Ethereum address of account holder
986    * @return { "balance" : "Return the balance of a given account for a specified currency"}
987    */
988   function getTokenBalance(Data storage self, string currency, address account) internal view returns (uint balance) {
989     bytes32 id = keccak256(abi.encodePacked('token.balance', currency, getForwardedAccount(self, account)));
990     return self.Storage.getUint(id);
991   }
992 
993   /**
994    * @notice Get the frozen token balance for a given account
995    * @dev | This method has an `internal` view
996    * @param self Internal storage proxying TokenIOStorage contract
997    * @param  currency Currency symbol of the token (e.g. USDx, JYPx, GBPx)
998    * @param account Ethereum address of account holder
999    * @return { "frozenBalance" : "Return the frozen balance of a given account for a specified currency"}
1000    */
1001   function getTokenFrozenBalance(Data storage self, string currency, address account) internal view returns (uint frozenBalance) {
1002     bytes32 id = keccak256(abi.encodePacked('token.frozen', currency, getForwardedAccount(self, account)));
1003     return self.Storage.getUint(id);
1004   }
1005 
1006   /**
1007    * @notice Set the frozen token balance for a given account
1008    * @dev | This method has an `internal` view
1009    * @param self Internal storage proxying TokenIOStorage contract
1010    * @param  currency Currency symbol of the token (e.g. USDx, JYPx, GBPx)
1011    * @param account Ethereum address of account holder
1012    * @param amount Amount of tokens to freeze for account
1013    * @return { "success" : "Return true if successfully called from another contract"}
1014    */
1015   function setTokenFrozenBalance(Data storage self, string currency, address account, uint amount) internal returns (bool success) {
1016     bytes32 id = keccak256(abi.encodePacked('token.frozen', currency, getForwardedAccount(self, account)));
1017     require(
1018       self.Storage.setUint(id, amount),
1019       "Error: Unable to set storage value. Please ensure contract interface is allowed by the storage contract."
1020     );
1021     return true;
1022   }
1023 
1024   /**
1025    * @notice Set the frozen token balance for a given account
1026    * @dev | This method has an `internal` view
1027    * @param self Internal storage proxying TokenIOStorage contract
1028    * @param contractAddress Contract address of the fee contract
1029    * @param amount Transaction value
1030    * @return { "calculatedFees" : "Return the calculated transaction fees for a given amount and fee contract" }
1031    */
1032   function calculateFees(Data storage self, address contractAddress, uint amount) internal view returns (uint calculatedFees) {
1033 
1034     uint maxFee = self.Storage.getUint(keccak256(abi.encodePacked('fee.max', contractAddress)));
1035     uint minFee = self.Storage.getUint(keccak256(abi.encodePacked('fee.min', contractAddress)));
1036     uint bpsFee = self.Storage.getUint(keccak256(abi.encodePacked('fee.bps', contractAddress)));
1037     uint flatFee = self.Storage.getUint(keccak256(abi.encodePacked('fee.flat', contractAddress)));
1038     uint fees = ((amount.mul(bpsFee)).div(10000)).add(flatFee);
1039 
1040     if (fees > maxFee) {
1041       return maxFee;
1042     } else if (fees < minFee) {
1043       return minFee;
1044     } else {
1045       return fees;
1046     }
1047   }
1048 
1049   /**
1050    * @notice Verified KYC and global status for two accounts and return true or throw if either account is not verified
1051    * @dev | This method has an `internal` view
1052    * @param self Internal storage proxying TokenIOStorage contract
1053    * @param accountA Ethereum address of first account holder to verify
1054    * @param accountB Ethereum address of second account holder to verify
1055    * @return { "verified" : "Returns true if both accounts are successfully verified" }
1056    */
1057   function verifyAccounts(Data storage self, address accountA, address accountB) internal view returns (bool verified) {
1058     require(
1059       verifyAccount(self, accountA),
1060       "Error: Account is not verified for operation. Please ensure account has been KYC approved."
1061     );
1062     require(
1063       verifyAccount(self, accountB),
1064       "Error: Account is not verified for operation. Please ensure account has been KYC approved."
1065     );
1066     return true;
1067   }
1068 
1069   /**
1070    * @notice Verified KYC and global status for a single account and return true or throw if account is not verified
1071    * @dev | This method has an `internal` view
1072    * @param self Internal storage proxying TokenIOStorage contract
1073    * @param account Ethereum address of account holder to verify
1074    * @return { "verified" : "Returns true if account is successfully verified" }
1075    */
1076   function verifyAccount(Data storage self, address account) internal view returns (bool verified) {
1077     require(
1078       getKYCApproval(self, account),
1079       "Error: Account does not have KYC approval."
1080     );
1081     require(
1082       getAccountStatus(self, account),
1083       "Error: Account status is `false`. Account status must be `true`."
1084     );
1085     return true;
1086   }
1087 
1088 
1089   /**
1090    * @notice Transfer an amount of currency token from msg.sender account to another specified account
1091    * @dev This function is called by an interface that is accessible directly to the account holder
1092    * @dev | This method has an `internal` view
1093    * @dev | This method uses `forceTransfer()` low-level api
1094    * @param self Internal storage proxying TokenIOStorage contract
1095    * @param  currency Currency symbol of the token (e.g. USDx, JYPx, GBPx)
1096    * @param to Ethereum address of account to send currency amount to
1097    * @param amount Value of currency to transfer
1098    * @param data Arbitrary bytes data to include with the transaction
1099    * @return { "success" : "Return true if successfully called from another contract" }
1100    */
1101   function transfer(Data storage self, string currency, address to, uint amount, bytes data) internal returns (bool success) {
1102     require(address(to) != 0x0, "Error: `to` address cannot be null." );
1103     require(amount > 0, "Error: `amount` must be greater than zero");
1104 
1105     address feeContract = getFeeContract(self, address(this));
1106     uint fees = calculateFees(self, feeContract, amount);
1107 
1108     require(
1109       setAccountSpendingAmount(self, msg.sender, getFxUSDAmount(self, currency, amount)),
1110       "Error: Unable to set spending amount for account.");
1111 
1112     require(
1113       forceTransfer(self, currency, msg.sender, to, amount, data),
1114       "Error: Unable to transfer funds to account.");
1115 
1116     // @dev transfer fees to fee contract
1117     require(
1118       forceTransfer(self, currency, msg.sender, feeContract, fees, getFeeMsg(self, feeContract)),
1119       "Error: Unable to transfer fees to fee contract.");
1120 
1121     return true;
1122   }
1123 
1124   /**
1125    * @notice Transfer an amount of currency token from account to another specified account via an approved spender account
1126    * @dev This function is called by an interface that is accessible directly to the account spender
1127    * @dev | This method has an `internal` view
1128    * @dev | Transactions will fail if the spending amount exceeds the daily limit
1129    * @dev | This method uses `forceTransfer()` low-level api
1130    * @dev | This method implements ERC20 transferFrom() method with approved spender behavior
1131    * @dev | msg.sender == spender; `updateAllowance()` reduces approved limit for account spender
1132    * @param self Internal storage proxying TokenIOStorage contract
1133    * @param  currency Currency symbol of the token (e.g. USDx, JYPx, GBPx)
1134    * @param from Ethereum address of account to send currency amount from
1135    * @param to Ethereum address of account to send currency amount to
1136    * @param amount Value of currency to transfer
1137    * @param data Arbitrary bytes data to include with the transaction
1138    * @return { "success" : "Return true if successfully called from another contract" }
1139    */
1140   function transferFrom(Data storage self, string currency, address from, address to, uint amount, bytes data) internal returns (bool success) {
1141     require(
1142       address(to) != 0x0,
1143       "Error: `to` address must not be null."
1144     );
1145 
1146     address feeContract = getFeeContract(self, address(this));
1147     uint fees = calculateFees(self, feeContract, amount);
1148 
1149     /// @dev NOTE: This transaction will fail if the spending amount exceeds the daily limit
1150     require(
1151       setAccountSpendingAmount(self, from, getFxUSDAmount(self, currency, amount)),
1152       "Error: Unable to set account spending amount."
1153     );
1154 
1155     /// @dev Attempt to transfer the amount
1156     require(
1157       forceTransfer(self, currency, from, to, amount, data),
1158       "Error: Unable to transfer funds to account."
1159     );
1160 
1161     // @dev transfer fees to fee contract
1162     require(
1163       forceTransfer(self, currency, from, feeContract, fees, getFeeMsg(self, feeContract)),
1164       "Error: Unable to transfer fees to fee contract."
1165     );
1166 
1167     /// @dev Attempt to update the spender allowance
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
1736 /*
1737 COPYRIGHT 2018 Token, Inc.
1738 
1739 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
1740 INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
1741 PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
1742 COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
1743 IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
1744 WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
1745 
1746 
1747 @title Standard Fee Contract for Token, Inc. Smart Money System
1748 
1749 @author Ryan Tate <ryan.tate@token.io>, Sean Pollock <sean.pollock@token.io>
1750 
1751 @notice Contract uses generalized storage contract, `TokenIOStorage`, for
1752 upgradeability of interface contract.
1753 
1754 @dev In the event that the main contract becomes deprecated, the upgraded contract
1755 will be set as the owner of this contract, and use this contract's storage to
1756 maintain data consistency between contract.
1757 
1758 */
1759 
1760 
1761 contract TokenIOFeeContract is Ownable {
1762 
1763 	/// @dev Set reference to TokenIOLib interface which proxies to TokenIOStorage
1764 	using TokenIOLib for TokenIOLib.Data;
1765 	TokenIOLib.Data lib;
1766 
1767 
1768 	/**
1769 	* @notice Constructor method for ERC20 contract
1770 	* @param _storageContract     address of TokenIOStorage contract
1771 	*/
1772 	constructor(address _storageContract) public {
1773 			/// @dev Set the storage contract for the interface
1774 			/// @dev NOTE: This contract will be unable to use the storage constract until
1775 			/// @dev contract address is authorized with the storage contract
1776 			/// @dev Once authorized, Use the `setParams` method to set storage values
1777 			lib.Storage = TokenIOStorage(_storageContract);
1778 
1779 			/// @dev set owner to contract initiator
1780 			owner[msg.sender] = true;
1781 	}
1782 
1783 	/**
1784 	 * @notice Set Fee Parameters for Fee Contract
1785 	 * @dev The min, max, flat transaction fees should be relative to decimal precision
1786 	 * @param feeBps Basis points transaction fee
1787 	 * @param feeMin Minimum transaction fees
1788 	 * @param feeMax Maximum transaction fee
1789 	 * @param feeFlat Flat transaction fee
1790 	 * returns {"success" : "Returns true if successfully called from another contract"}
1791 	 */
1792 	function setFeeParams(uint feeBps, uint feeMin, uint feeMax, uint feeFlat, bytes feeMsg) public onlyOwner returns (bool success) {
1793 		require(lib.setFeeBPS(feeBps), "Error: Unable to set fee contract basis points.");
1794 		require(lib.setFeeMin(feeMin), "Error: Unable to set fee contract minimum fee.");
1795 		require(lib.setFeeMax(feeMax), "Error: Unable to set fee contract maximum fee.");
1796 		require(lib.setFeeFlat(feeFlat), "Error: Unable to set fee contract flat fee.");
1797 		require(lib.setFeeMsg(feeMsg), "Error: Unable to set fee contract default message.");
1798 		return true;
1799 	}
1800 
1801 	/**
1802 	 	* @notice Gets fee parameters
1803 		* @return {
1804 		"bps":"Returns the basis points fee of the TokenIOFeeContract",
1805 		"min":"Returns the min fee of the TokenIOFeeContract",
1806 		"max":"Returns the max fee of the TokenIOFeeContract",
1807 		"flat":"Returns the flat fee of the TokenIOFeeContract",
1808 		"feeContract": "Address of this contract"
1809 	}
1810 	*/
1811 	function getFeeParams() public view returns (uint bps, uint min, uint max, uint flat, bytes feeMsg, address feeContract) {
1812 			return (
1813 					lib.getFeeBPS(address(this)),
1814 					lib.getFeeMin(address(this)),
1815 					lib.getFeeMax(address(this)),
1816 					lib.getFeeFlat(address(this)),
1817 					lib.getFeeMsg(address(this)),
1818 					address(this)
1819 			);
1820 	}
1821 
1822 	/**
1823 	 * @notice Returns balance of this contract associated with currency symbol.
1824 	 * @param  currency Currency symbol of the token (e.g. USDx, JYPx, GBPx)
1825 	 * @return {"balance": "Balance of TokenIO TSM currency account"}
1826 	 */
1827 	function getTokenBalance(string currency) public view returns(uint balance) {
1828 		return lib.getTokenBalance(currency, address(this));
1829 	}
1830 
1831 	/** @notice Calculates fee of a given transfer amount
1832 	 * @param amount transfer amount
1833 	 * @return { "fees": "Returns the fees associated with this contract"}
1834 	 */
1835 	function calculateFees(uint amount) public view returns (uint fees) {
1836 		return lib.calculateFees(address(this), amount);
1837 	}
1838 
1839 
1840 	/**
1841 	 * @notice Transfer collected fees to another account; onlyOwner
1842 	 * @param  currency Currency symbol of the token (e.g. USDx, JYPx, GBPx)
1843 	 * @param  to 			Ethereum address of account to send token amount to
1844 	 * @param  amount	  Amount of tokens to transfer
1845 	 * @param  data		  Arbitrary bytes data message to include in transfer
1846 	 * @return {"success": "Returns ture if successfully called from another contract"}
1847 	 */
1848 	function transferCollectedFees(string currency, address to, uint amount, bytes data) public onlyOwner returns (bool success) {
1849 		require(
1850 			lib.forceTransfer(currency, address(this), to, amount, data),
1851 			"Error: unable to transfer fees to account."
1852 		);
1853 		return true;
1854 	}
1855 
1856 
1857 }