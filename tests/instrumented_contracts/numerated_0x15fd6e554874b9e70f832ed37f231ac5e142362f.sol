1 /*
2    ____            __   __        __   _
3   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
4  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
5 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
6      /___/
7 
8 * Synthetix: DelegateApprovals.sol
9 *
10 * Latest source (may be newer): https://github.com/Synthetixio/synthetix/blob/master/contracts/DelegateApprovals.sol
11 * Docs: https://docs.synthetix.io/contracts/DelegateApprovals
12 *
13 * Contract Dependencies: 
14 *	- Owned
15 *	- State
16 * Libraries: (none)
17 *
18 * MIT License
19 * ===========
20 *
21 * Copyright (c) 2020 Synthetix
22 *
23 * Permission is hereby granted, free of charge, to any person obtaining a copy
24 * of this software and associated documentation files (the "Software"), to deal
25 * in the Software without restriction, including without limitation the rights
26 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
27 * copies of the Software, and to permit persons to whom the Software is
28 * furnished to do so, subject to the following conditions:
29 *
30 * The above copyright notice and this permission notice shall be included in all
31 * copies or substantial portions of the Software.
32 *
33 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
34 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
35 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
36 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
37 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
38 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
39 */
40 
41 /* ===============================================
42 * Flattened with Solidifier by Coinage
43 * 
44 * https://solidifier.coina.ge
45 * ===============================================
46 */
47 
48 
49 pragma solidity 0.4.25;
50 
51 
52 // https://docs.synthetix.io/contracts/Owned
53 contract Owned {
54     address public owner;
55     address public nominatedOwner;
56 
57     /**
58      * @dev Owned Constructor
59      */
60     constructor(address _owner) public {
61         require(_owner != address(0), "Owner address cannot be 0");
62         owner = _owner;
63         emit OwnerChanged(address(0), _owner);
64     }
65 
66     /**
67      * @notice Nominate a new owner of this contract.
68      * @dev Only the current owner may nominate a new owner.
69      */
70     function nominateNewOwner(address _owner) external onlyOwner {
71         nominatedOwner = _owner;
72         emit OwnerNominated(_owner);
73     }
74 
75     /**
76      * @notice Accept the nomination to be owner.
77      */
78     function acceptOwnership() external {
79         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
80         emit OwnerChanged(owner, nominatedOwner);
81         owner = nominatedOwner;
82         nominatedOwner = address(0);
83     }
84 
85     modifier onlyOwner {
86         require(msg.sender == owner, "Only the contract owner may perform this action");
87         _;
88     }
89 
90     event OwnerNominated(address newOwner);
91     event OwnerChanged(address oldOwner, address newOwner);
92 }
93 
94 
95 // https://docs.synthetix.io/contracts/State
96 contract State is Owned {
97     // the address of the contract that can modify variables
98     // this can only be changed by the owner of this contract
99     address public associatedContract;
100 
101     constructor(address _owner, address _associatedContract) public Owned(_owner) {
102         associatedContract = _associatedContract;
103         emit AssociatedContractUpdated(_associatedContract);
104     }
105 
106     /* ========== SETTERS ========== */
107 
108     // Change the associated contract to a new address
109     function setAssociatedContract(address _associatedContract) external onlyOwner {
110         associatedContract = _associatedContract;
111         emit AssociatedContractUpdated(_associatedContract);
112     }
113 
114     /* ========== MODIFIERS ========== */
115 
116     modifier onlyAssociatedContract {
117         require(msg.sender == associatedContract, "Only the associated contract can perform this action");
118         _;
119     }
120 
121     /* ========== EVENTS ========== */
122 
123     event AssociatedContractUpdated(address associatedContract);
124 }
125 
126 
127 /**
128  * @notice  This contract is based on the code available from this blog
129  * https://blog.colony.io/writing-upgradeable-contracts-in-solidity-6743f0eecc88/
130  * Implements support for storing a keccak256 key and value pairs. It is the more flexible
131  * and extensible option. This ensures data schema changes can be implemented without
132  * requiring upgrades to the storage contract.
133  */
134 // https://docs.synthetix.io/contracts/EternalStorage
135 contract EternalStorage is State {
136     constructor(address _owner, address _associatedContract) public State(_owner, _associatedContract) {}
137 
138     /* ========== DATA TYPES ========== */
139     mapping(bytes32 => uint) UIntStorage;
140     mapping(bytes32 => string) StringStorage;
141     mapping(bytes32 => address) AddressStorage;
142     mapping(bytes32 => bytes) BytesStorage;
143     mapping(bytes32 => bytes32) Bytes32Storage;
144     mapping(bytes32 => bool) BooleanStorage;
145     mapping(bytes32 => int) IntStorage;
146 
147     // UIntStorage;
148     function getUIntValue(bytes32 record) external view returns (uint) {
149         return UIntStorage[record];
150     }
151 
152     function setUIntValue(bytes32 record, uint value) external onlyAssociatedContract {
153         UIntStorage[record] = value;
154     }
155 
156     function deleteUIntValue(bytes32 record) external onlyAssociatedContract {
157         delete UIntStorage[record];
158     }
159 
160     // StringStorage
161     function getStringValue(bytes32 record) external view returns (string memory) {
162         return StringStorage[record];
163     }
164 
165     function setStringValue(bytes32 record, string value) external onlyAssociatedContract {
166         StringStorage[record] = value;
167     }
168 
169     function deleteStringValue(bytes32 record) external onlyAssociatedContract {
170         delete StringStorage[record];
171     }
172 
173     // AddressStorage
174     function getAddressValue(bytes32 record) external view returns (address) {
175         return AddressStorage[record];
176     }
177 
178     function setAddressValue(bytes32 record, address value) external onlyAssociatedContract {
179         AddressStorage[record] = value;
180     }
181 
182     function deleteAddressValue(bytes32 record) external onlyAssociatedContract {
183         delete AddressStorage[record];
184     }
185 
186     // BytesStorage
187     function getBytesValue(bytes32 record) external view returns (bytes memory) {
188         return BytesStorage[record];
189     }
190 
191     function setBytesValue(bytes32 record, bytes value) external onlyAssociatedContract {
192         BytesStorage[record] = value;
193     }
194 
195     function deleteBytesValue(bytes32 record) external onlyAssociatedContract {
196         delete BytesStorage[record];
197     }
198 
199     // Bytes32Storage
200     function getBytes32Value(bytes32 record) external view returns (bytes32) {
201         return Bytes32Storage[record];
202     }
203 
204     function setBytes32Value(bytes32 record, bytes32 value) external onlyAssociatedContract {
205         Bytes32Storage[record] = value;
206     }
207 
208     function deleteBytes32Value(bytes32 record) external onlyAssociatedContract {
209         delete Bytes32Storage[record];
210     }
211 
212     // BooleanStorage
213     function getBooleanValue(bytes32 record) external view returns (bool) {
214         return BooleanStorage[record];
215     }
216 
217     function setBooleanValue(bytes32 record, bool value) external onlyAssociatedContract {
218         BooleanStorage[record] = value;
219     }
220 
221     function deleteBooleanValue(bytes32 record) external onlyAssociatedContract {
222         delete BooleanStorage[record];
223     }
224 
225     // IntStorage
226     function getIntValue(bytes32 record) external view returns (int) {
227         return IntStorage[record];
228     }
229 
230     function setIntValue(bytes32 record, int value) external onlyAssociatedContract {
231         IntStorage[record] = value;
232     }
233 
234     function deleteIntValue(bytes32 record) external onlyAssociatedContract {
235         delete IntStorage[record];
236     }
237 }
238 
239 
240 // https://docs.synthetix.io/contracts/DelegateApprovals
241 contract DelegateApprovals is Owned {
242     bytes32 public constant BURN_FOR_ADDRESS = "BurnForAddress";
243     bytes32 public constant ISSUE_FOR_ADDRESS = "IssueForAddress";
244     bytes32 public constant CLAIM_FOR_ADDRESS = "ClaimForAddress";
245     bytes32 public constant EXCHANGE_FOR_ADDRESS = "ExchangeForAddress";
246     bytes32 public constant APPROVE_ALL = "ApproveAll";
247 
248     bytes32[5] private _delegatableFunctions = [
249         APPROVE_ALL,
250         BURN_FOR_ADDRESS,
251         ISSUE_FOR_ADDRESS,
252         CLAIM_FOR_ADDRESS,
253         EXCHANGE_FOR_ADDRESS
254     ];
255 
256     /* ========== STATE VARIABLES ========== */
257     EternalStorage public eternalStorage;
258 
259     /**
260      * @dev Constructor
261      * @param _owner The address which controls this contract.
262      * @param _eternalStorage The eternalStorage address.
263      */
264     constructor(address _owner, EternalStorage _eternalStorage) public Owned(_owner) {
265         eternalStorage = _eternalStorage;
266     }
267 
268     /* ========== VIEWS ========== */
269 
270     // Move it to setter and associatedState
271 
272     // util to get key based on action name + address of authoriser + address for delegate
273     function _getKey(bytes32 _action, address _authoriser, address _delegate) internal pure returns (bytes32) {
274         return keccak256(abi.encodePacked(_action, _authoriser, _delegate));
275     }
276 
277     // hash of actionName + address of authoriser + address for the delegate
278     function canBurnFor(address authoriser, address delegate) external view returns (bool) {
279         return _checkApproval(BURN_FOR_ADDRESS, authoriser, delegate);
280     }
281 
282     function canIssueFor(address authoriser, address delegate) external view returns (bool) {
283         return _checkApproval(ISSUE_FOR_ADDRESS, authoriser, delegate);
284     }
285 
286     function canClaimFor(address authoriser, address delegate) external view returns (bool) {
287         return _checkApproval(CLAIM_FOR_ADDRESS, authoriser, delegate);
288     }
289 
290     function canExchangeFor(address authoriser, address delegate) external view returns (bool) {
291         return _checkApproval(EXCHANGE_FOR_ADDRESS, authoriser, delegate);
292     }
293 
294     function approvedAll(address authoriser, address delegate) public view returns (bool) {
295         return eternalStorage.getBooleanValue(_getKey(APPROVE_ALL, authoriser, delegate));
296     }
297 
298     // internal function to check approval based on action
299     // if approved for all actions then will return true
300     // before checking specific approvals
301     function _checkApproval(bytes32 action, address authoriser, address delegate) internal view returns (bool) {
302         if (approvedAll(authoriser, delegate)) return true;
303 
304         return eternalStorage.getBooleanValue(_getKey(action, authoriser, delegate));
305     }
306 
307     /* ========== SETTERS ========== */
308 
309     // Approve All
310     function approveAllDelegatePowers(address delegate) external {
311         _setApproval(APPROVE_ALL, msg.sender, delegate);
312     }
313 
314     // Removes all delegate approvals
315     function removeAllDelegatePowers(address delegate) external {
316         for (uint i = 0; i < _delegatableFunctions.length; i++) {
317             _withdrawApproval(_delegatableFunctions[i], msg.sender, delegate);
318         }
319     }
320 
321     // Burn on behalf
322     function approveBurnOnBehalf(address delegate) external {
323         _setApproval(BURN_FOR_ADDRESS, msg.sender, delegate);
324     }
325 
326     function removeBurnOnBehalf(address delegate) external {
327         _withdrawApproval(BURN_FOR_ADDRESS, msg.sender, delegate);
328     }
329 
330     // Issue on behalf
331     function approveIssueOnBehalf(address delegate) external {
332         _setApproval(ISSUE_FOR_ADDRESS, msg.sender, delegate);
333     }
334 
335     function removeIssueOnBehalf(address delegate) external {
336         _withdrawApproval(ISSUE_FOR_ADDRESS, msg.sender, delegate);
337     }
338 
339     // Claim on behalf
340     function approveClaimOnBehalf(address delegate) external {
341         _setApproval(CLAIM_FOR_ADDRESS, msg.sender, delegate);
342     }
343 
344     function removeClaimOnBehalf(address delegate) external {
345         _withdrawApproval(CLAIM_FOR_ADDRESS, msg.sender, delegate);
346     }
347 
348     // Exchange on behalf
349     function approveExchangeOnBehalf(address delegate) external {
350         _setApproval(EXCHANGE_FOR_ADDRESS, msg.sender, delegate);
351     }
352 
353     function removeExchangeOnBehalf(address delegate) external {
354         _withdrawApproval(EXCHANGE_FOR_ADDRESS, msg.sender, delegate);
355     }
356 
357     function _setApproval(bytes32 action, address authoriser, address delegate) internal {
358         require(delegate != address(0), "Can't delegate to address(0)");
359         eternalStorage.setBooleanValue(_getKey(action, authoriser, delegate), true);
360         emit Approval(authoriser, delegate, action);
361     }
362 
363     function _withdrawApproval(bytes32 action, address authoriser, address delegate) internal {
364         // Check approval is set otherwise skip deleting approval
365         if (eternalStorage.getBooleanValue(_getKey(action, authoriser, delegate))) {
366             eternalStorage.deleteBooleanValue(_getKey(action, authoriser, delegate));
367             emit WithdrawApproval(authoriser, delegate, action);
368         }
369     }
370 
371     function setEternalStorage(EternalStorage _eternalStorage) external onlyOwner {
372         require(_eternalStorage != address(0), "Can't set eternalStorage to address(0)");
373         eternalStorage = _eternalStorage;
374         emit EternalStorageUpdated(eternalStorage);
375     }
376 
377     /* ========== EVENTS ========== */
378     event Approval(address indexed authoriser, address delegate, bytes32 action);
379     event WithdrawApproval(address indexed authoriser, address delegate, bytes32 action);
380     event EternalStorageUpdated(address newEternalStorage);
381 }
382 
383 
384     