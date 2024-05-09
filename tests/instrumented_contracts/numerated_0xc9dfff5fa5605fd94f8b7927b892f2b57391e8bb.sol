1 /* ===============================================
2 * Flattened with Solidifier by Coinage
3 * 
4 * https://solidifier.coina.ge
5 * ===============================================
6 */
7 
8 
9 /*
10 -----------------------------------------------------------------
11 FILE INFORMATION
12 -----------------------------------------------------------------
13 
14 file:       LimitedSetup.sol
15 version:    1.1
16 author:     Anton Jurisevic
17 
18 date:       2018-05-15
19 
20 -----------------------------------------------------------------
21 MODULE DESCRIPTION
22 -----------------------------------------------------------------
23 
24 A contract with a limited setup period. Any function modified
25 with the setup modifier will cease to work after the
26 conclusion of the configurable-length post-construction setup period.
27 
28 -----------------------------------------------------------------
29 */
30 
31 
32 pragma solidity 0.4.25;
33 
34 /**
35  * @title Any function decorated with the modifier this contract provides
36  * deactivates after a specified setup period.
37  */
38 contract LimitedSetup {
39 
40     uint setupExpiryTime;
41 
42     /**
43      * @dev LimitedSetup Constructor.
44      * @param setupDuration The time the setup period will last for.
45      */
46     constructor(uint setupDuration)
47         public
48     {
49         setupExpiryTime = now + setupDuration;
50     }
51 
52     modifier onlyDuringSetup
53     {
54         require(now < setupExpiryTime, "Can only perform this action during setup");
55         _;
56     }
57 }
58 
59 
60 /*
61 -----------------------------------------------------------------
62 FILE INFORMATION
63 -----------------------------------------------------------------
64 
65 file:       Owned.sol
66 version:    1.1
67 author:     Anton Jurisevic
68             Dominic Romanowski
69 
70 date:       2018-2-26
71 
72 -----------------------------------------------------------------
73 MODULE DESCRIPTION
74 -----------------------------------------------------------------
75 
76 An Owned contract, to be inherited by other contracts.
77 Requires its owner to be explicitly set in the constructor.
78 Provides an onlyOwner access modifier.
79 
80 To change owner, the current owner must nominate the next owner,
81 who then has to accept the nomination. The nomination can be
82 cancelled before it is accepted by the new owner by having the
83 previous owner change the nomination (setting it to 0).
84 
85 -----------------------------------------------------------------
86 */
87 
88 
89 /**
90  * @title A contract with an owner.
91  * @notice Contract ownership can be transferred by first nominating the new owner,
92  * who must then accept the ownership, which prevents accidental incorrect ownership transfers.
93  */
94 contract Owned {
95     address public owner;
96     address public nominatedOwner;
97 
98     /**
99      * @dev Owned Constructor
100      */
101     constructor(address _owner)
102         public
103     {
104         require(_owner != address(0), "Owner address cannot be 0");
105         owner = _owner;
106         emit OwnerChanged(address(0), _owner);
107     }
108 
109     /**
110      * @notice Nominate a new owner of this contract.
111      * @dev Only the current owner may nominate a new owner.
112      */
113     function nominateNewOwner(address _owner)
114         external
115         onlyOwner
116     {
117         nominatedOwner = _owner;
118         emit OwnerNominated(_owner);
119     }
120 
121     /**
122      * @notice Accept the nomination to be owner.
123      */
124     function acceptOwnership()
125         external
126     {
127         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
128         emit OwnerChanged(owner, nominatedOwner);
129         owner = nominatedOwner;
130         nominatedOwner = address(0);
131     }
132 
133     modifier onlyOwner
134     {
135         require(msg.sender == owner, "Only the contract owner may perform this action");
136         _;
137     }
138 
139     event OwnerNominated(address newOwner);
140     event OwnerChanged(address oldOwner, address newOwner);
141 }
142 
143 /*
144 -----------------------------------------------------------------
145 FILE INFORMATION
146 -----------------------------------------------------------------
147 
148 file:       State.sol
149 version:    1.1
150 author:     Dominic Romanowski
151             Anton Jurisevic
152 
153 date:       2018-05-15
154 
155 -----------------------------------------------------------------
156 MODULE DESCRIPTION
157 -----------------------------------------------------------------
158 
159 This contract is used side by side with external state token
160 contracts, such as Synthetix and Synth.
161 It provides an easy way to upgrade contract logic while
162 maintaining all user balances and allowances. This is designed
163 to make the changeover as easy as possible, since mappings
164 are not so cheap or straightforward to migrate.
165 
166 The first deployed contract would create this state contract,
167 using it as its store of balances.
168 When a new contract is deployed, it links to the existing
169 state contract, whose owner would then change its associated
170 contract to the new one.
171 
172 -----------------------------------------------------------------
173 */
174 
175 
176 contract State is Owned {
177     // the address of the contract that can modify variables
178     // this can only be changed by the owner of this contract
179     address public associatedContract;
180 
181 
182     constructor(address _owner, address _associatedContract)
183         Owned(_owner)
184         public
185     {
186         associatedContract = _associatedContract;
187         emit AssociatedContractUpdated(_associatedContract);
188     }
189 
190     /* ========== SETTERS ========== */
191 
192     // Change the associated contract to a new address
193     function setAssociatedContract(address _associatedContract)
194         external
195         onlyOwner
196     {
197         associatedContract = _associatedContract;
198         emit AssociatedContractUpdated(_associatedContract);
199     }
200 
201     /* ========== MODIFIERS ========== */
202 
203     modifier onlyAssociatedContract
204     {
205         require(msg.sender == associatedContract, "Only the associated contract can perform this action");
206         _;
207     }
208 
209     /* ========== EVENTS ========== */
210 
211     event AssociatedContractUpdated(address associatedContract);
212 }
213 
214 
215 /*
216 -----------------------------------------------------------------
217 FILE INFORMATION
218 -----------------------------------------------------------------
219 
220 file:       EternalStorage.sol
221 version:    1.0
222 author:     Clinton Ennise
223             Jackson Chan
224 
225 date:       2019-02-01
226 
227 -----------------------------------------------------------------
228 MODULE DESCRIPTION
229 -----------------------------------------------------------------
230 
231 This contract is used with external state storage contracts for
232 decoupled data storage.
233 
234 Implements support for storing a keccak256 key and value pairs. It is
235 the more flexible and extensible option. This ensures data schema
236 changes can be implemented without requiring upgrades to the
237 storage contract
238 
239 The first deployed storage contract would create this eternal storage.
240 Favour use of keccak256 key over sha3 as future version of solidity
241 > 0.5.0 will be deprecated.
242 
243 -----------------------------------------------------------------
244 */
245 
246 
247 /**
248  * @notice  This contract is based on the code available from this blog
249  * https://blog.colony.io/writing-upgradeable-contracts-in-solidity-6743f0eecc88/
250  * Implements support for storing a keccak256 key and value pairs. It is the more flexible
251  * and extensible option. This ensures data schema changes can be implemented without
252  * requiring upgrades to the storage contract.
253  */
254 contract EternalStorage is State {
255 
256     constructor(address _owner, address _associatedContract)
257         State(_owner, _associatedContract)
258         public
259     {
260     }
261 
262     /* ========== DATA TYPES ========== */
263     mapping(bytes32 => uint) UIntStorage;
264     mapping(bytes32 => string) StringStorage;
265     mapping(bytes32 => address) AddressStorage;
266     mapping(bytes32 => bytes) BytesStorage;
267     mapping(bytes32 => bytes32) Bytes32Storage;
268     mapping(bytes32 => bool) BooleanStorage;
269     mapping(bytes32 => int) IntStorage;
270 
271     // UIntStorage;
272     function getUIntValue(bytes32 record) external view returns (uint){
273         return UIntStorage[record];
274     }
275 
276     function setUIntValue(bytes32 record, uint value) external
277         onlyAssociatedContract
278     {
279         UIntStorage[record] = value;
280     }
281 
282     function deleteUIntValue(bytes32 record) external
283         onlyAssociatedContract
284     {
285         delete UIntStorage[record];
286     }
287 
288     // StringStorage
289     function getStringValue(bytes32 record) external view returns (string memory){
290         return StringStorage[record];
291     }
292 
293     function setStringValue(bytes32 record, string value) external
294         onlyAssociatedContract
295     {
296         StringStorage[record] = value;
297     }
298 
299     function deleteStringValue(bytes32 record) external
300         onlyAssociatedContract
301     {
302         delete StringStorage[record];
303     }
304 
305     // AddressStorage
306     function getAddressValue(bytes32 record) external view returns (address){
307         return AddressStorage[record];
308     }
309 
310     function setAddressValue(bytes32 record, address value) external
311         onlyAssociatedContract
312     {
313         AddressStorage[record] = value;
314     }
315 
316     function deleteAddressValue(bytes32 record) external
317         onlyAssociatedContract
318     {
319         delete AddressStorage[record];
320     }
321 
322 
323     // BytesStorage
324     function getBytesValue(bytes32 record) external view returns
325     (bytes memory){
326         return BytesStorage[record];
327     }
328 
329     function setBytesValue(bytes32 record, bytes value) external
330         onlyAssociatedContract
331     {
332         BytesStorage[record] = value;
333     }
334 
335     function deleteBytesValue(bytes32 record) external
336         onlyAssociatedContract
337     {
338         delete BytesStorage[record];
339     }
340 
341     // Bytes32Storage
342     function getBytes32Value(bytes32 record) external view returns (bytes32)
343     {
344         return Bytes32Storage[record];
345     }
346 
347     function setBytes32Value(bytes32 record, bytes32 value) external
348         onlyAssociatedContract
349     {
350         Bytes32Storage[record] = value;
351     }
352 
353     function deleteBytes32Value(bytes32 record) external
354         onlyAssociatedContract
355     {
356         delete Bytes32Storage[record];
357     }
358 
359     // BooleanStorage
360     function getBooleanValue(bytes32 record) external view returns (bool)
361     {
362         return BooleanStorage[record];
363     }
364 
365     function setBooleanValue(bytes32 record, bool value) external
366         onlyAssociatedContract
367     {
368         BooleanStorage[record] = value;
369     }
370 
371     function deleteBooleanValue(bytes32 record) external
372         onlyAssociatedContract
373     {
374         delete BooleanStorage[record];
375     }
376 
377     // IntStorage
378     function getIntValue(bytes32 record) external view returns (int){
379         return IntStorage[record];
380     }
381 
382     function setIntValue(bytes32 record, int value) external
383         onlyAssociatedContract
384     {
385         IntStorage[record] = value;
386     }
387 
388     function deleteIntValue(bytes32 record) external
389         onlyAssociatedContract
390     {
391         delete IntStorage[record];
392     }
393 }
394 
395 /*
396 -----------------------------------------------------------------
397 FILE INFORMATION
398 -----------------------------------------------------------------
399 
400 file:       FeePoolEternalStorage.sol
401 version:    1.0
402 author:     Clinton Ennis
403             Jackson Chan
404 date:       2019-04-05
405 
406 -----------------------------------------------------------------
407 MODULE DESCRIPTION
408 -----------------------------------------------------------------
409 
410 The FeePoolEternalStorage is for any state the FeePool contract
411 needs to persist between upgrades to the FeePool logic.
412 
413 Please see EternalStorage.sol
414 
415 -----------------------------------------------------------------
416 */
417 
418 
419 contract FeePoolEternalStorage is EternalStorage, LimitedSetup {
420 
421     bytes32 constant LAST_FEE_WITHDRAWAL = "last_fee_withdrawal";
422 
423     /**
424      * @dev Constructor.
425      * @param _owner The owner of this contract.
426      */
427     constructor(address _owner, address _feePool)
428         EternalStorage(_owner, _feePool)
429         LimitedSetup(6 weeks)
430         public
431     {
432     }
433 
434     /**
435      * @notice Import data from FeePool.lastFeeWithdrawal
436      * @dev Only callable by the contract owner, and only for 6 weeks after deployment.
437      * @param accounts Array of addresses that have claimed
438      * @param feePeriodIDs Array feePeriodIDs with the accounts last claim
439      */
440     function importFeeWithdrawalData(address[] accounts, uint[] feePeriodIDs)
441         external
442         onlyOwner
443         onlyDuringSetup
444     {
445         require(accounts.length == feePeriodIDs.length, "Length mismatch");
446 
447         for (uint8 i = 0; i < accounts.length; i++) {
448             this.setUIntValue(keccak256(abi.encodePacked(LAST_FEE_WITHDRAWAL, accounts[i])), feePeriodIDs[i]);
449         }
450     }
451 }
