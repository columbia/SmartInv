1 //SPDX-License-Identifier: MIT
2 pragma solidity >=0.7.5;
3 
4 // Inheritance
5 import "@openzeppelin/contracts/math/SafeMath.sol";
6 
7 import "../lib/Strings.sol";
8 
9 /// @title   Multi Signature base on Power
10 /// @author  umb.network
11 /// @notice  It's based on https://github.com/gnosis/MultiSigWallet but modified in a way to support power of vote.
12 ///          It has option to assign power to owners, so we can have "super owner(s)".
13 abstract contract PowerMultiSig {
14   using Strings for string;
15   using SafeMath for uint;
16 
17   uint constant public MAX_OWNER_COUNT = 50;
18 
19   struct Transaction {
20     address destination;
21     uint value;
22     uint executed;
23     bytes data;
24   }
25 
26   mapping (uint => Transaction) public transactions;
27   mapping (uint => mapping (address => bool)) public confirmations;
28   mapping (address => uint) public ownersPowers;
29   address[] public owners;
30 
31   uint public requiredPower;
32   uint public totalCurrentPower;
33   uint public transactionCount;
34 
35   // ========== MODIFIERS ========== //
36 
37   modifier onlyWallet() {
38     require(msg.sender == address(this), "only MultiSigMinter can execute this");
39     _;
40   }
41 
42   modifier whenOwnerDoesNotExist(address _owner) {
43     require(ownersPowers[_owner] == 0, "owner already exists");
44     _;
45   }
46 
47   modifier whenOwnerExists(address _owner) {
48     require(ownersPowers[_owner] > 0, "owner do NOT exists");
49     _;
50   }
51 
52   modifier whenTransactionExists(uint _transactionId) {
53     require(transactions[_transactionId].destination != address(0),
54       string("transaction ").appendNumber(_transactionId).appendString(" does not exists"));
55     _;
56   }
57 
58   modifier whenConfirmedBy(uint _transactionId, address _owner) {
59     require(confirmations[_transactionId][_owner],
60       string("transaction ").appendNumber(_transactionId).appendString(" NOT confirmed by owner"));
61     _;
62   }
63 
64   modifier notConfirmedBy(uint _transactionId, address _owner) {
65     require(!confirmations[_transactionId][_owner],
66       string("transaction ").appendNumber(_transactionId).appendString(" already confirmed by owner"));
67     _;
68   }
69 
70   modifier whenNotExecuted(uint _transactionId) {
71     require(transactions[_transactionId].executed == 0,
72       string("transaction ").appendNumber(_transactionId).appendString(" already executed") );
73     _;
74   }
75 
76   modifier notNull(address _address) {
77     require(_address != address(0), "address is empty");
78     _;
79   }
80 
81   modifier validRequirement(uint _totalOwnersCount, uint _totalPowerSum, uint _requiredPower) {
82     require(_totalPowerSum >= _requiredPower, "owners do NOT have enough power");
83     require(_totalOwnersCount <= MAX_OWNER_COUNT, "too many owners");
84     require(_requiredPower != 0, "_requiredPower is zero");
85     require(_totalOwnersCount != 0, "_totalOwnersCount is zero");
86     _;
87   }
88 
89   // ========== CONSTRUCTOR ========== //
90 
91   constructor(address[] memory _owners, uint256[] memory _powers, uint256 _requiredPower)
92   validRequirement(_owners.length, sum(_powers), _requiredPower)
93   {
94     uint sumOfPowers = 0;
95 
96     for (uint i=0; i<_owners.length; i++) {
97       require(ownersPowers[_owners[i]] == 0, "owner already exists");
98       require(_owners[i] != address(0), "owner is empty");
99       require(_powers[i] != 0, "power is empty");
100 
101       ownersPowers[_owners[i]] = _powers[i];
102       sumOfPowers = sumOfPowers.add(_powers[i]);
103     }
104 
105     owners = _owners;
106     requiredPower = _requiredPower;
107     totalCurrentPower = sumOfPowers;
108   }
109 
110   // ========== MODIFIERS ========== //
111 
112   receive() external payable {
113     if (msg.value > 0) emit LogDeposit(msg.sender, msg.value);
114   }
115 
116   function addOwner(address _owner, uint _power)
117   public
118   onlyWallet
119   whenOwnerDoesNotExist(_owner)
120   notNull(_owner)
121   validRequirement(owners.length + 1, totalCurrentPower + _power, requiredPower)
122   {
123     require(_power != 0, "_power is empty");
124 
125     ownersPowers[_owner] = _power;
126     owners.push(_owner);
127     totalCurrentPower = totalCurrentPower.add(_power);
128 
129     emit LogOwnerAddition(_owner, _power);
130   }
131 
132   function removeOwner(address _owner) public onlyWallet whenOwnerExists(_owner)
133   {
134     uint ownerPower = ownersPowers[_owner];
135     require(
136       totalCurrentPower - ownerPower >= requiredPower,
137       "can't remove owner, because there will be not enough power left"
138     );
139 
140     ownersPowers[_owner] = 0;
141     totalCurrentPower = totalCurrentPower.sub(ownerPower);
142 
143     for (uint i=0; i<owners.length - 1; i++) {
144       if (owners[i] == _owner) {
145         owners[i] = owners[owners.length - 1];
146         break;
147       }
148     }
149 
150     owners.pop();
151 
152     // if (requiredPower > owners.length) {
153     //   changeRequiredPower(requiredPower - ownerPower);
154     // }
155 
156     emit LogOwnerRemoval(_owner);
157   }
158 
159   function replaceOwner(address _oldOwner, address _newOwner)
160   public
161   onlyWallet
162   whenOwnerExists(_oldOwner)
163   whenOwnerDoesNotExist(_newOwner)
164   {
165     for (uint i=0; i<owners.length; i++) {
166       if (owners[i] == _oldOwner) {
167         owners[i] = _newOwner;
168         break;
169       }
170     }
171 
172     uint power = ownersPowers[_oldOwner];
173     ownersPowers[_newOwner] = power;
174     ownersPowers[_oldOwner] = 0;
175 
176     emit LogOwnerRemoval(_oldOwner);
177     emit LogOwnerAddition(_newOwner, power);
178   }
179 
180   function changeRequiredPower(uint _newPower)
181   public
182   onlyWallet
183   validRequirement(owners.length, totalCurrentPower, _newPower)
184   {
185     requiredPower = _newPower;
186     emit LogPowerChange(_newPower);
187   }
188 
189   function submitTransaction(address _destination, uint _value, bytes memory _data)
190   public
191   returns (uint transactionId)
192   {
193     transactionId = _addTransaction(_destination, _value, _data);
194     confirmTransaction(transactionId);
195   }
196 
197   function confirmTransaction(uint _transactionId)
198   public
199   whenOwnerExists(msg.sender)
200   whenTransactionExists(_transactionId)
201   notConfirmedBy(_transactionId, msg.sender)
202   {
203     confirmations[_transactionId][msg.sender] = true;
204     emit LogConfirmation(msg.sender, _transactionId);
205     executeTransaction(_transactionId);
206   }
207 
208   /// @dev Allows an owner to revoke a confirmation for a transaction.
209   /// @param _transactionId Transaction ID.
210   function revokeLogConfirmation(uint _transactionId)
211   public
212   whenOwnerExists(msg.sender)
213   whenConfirmedBy(_transactionId, msg.sender)
214   whenNotExecuted(_transactionId)
215   {
216     confirmations[_transactionId][msg.sender] = false;
217     emit LogRevocation(msg.sender, _transactionId);
218   }
219 
220   /// @dev Allows anyone to execute a confirmed transaction.
221   /// @param _transactionId Transaction ID.
222   function executeTransaction(uint _transactionId)
223   public
224   whenOwnerExists(msg.sender)
225   whenConfirmedBy(_transactionId, msg.sender)
226   whenNotExecuted(_transactionId)
227   {
228     if (isConfirmed(_transactionId)) {
229       Transaction storage txn = transactions[_transactionId];
230       txn.executed = block.timestamp;
231       if (external_call(txn.destination, txn.value, txn.data.length, txn.data))
232         emit LogExecution(_transactionId);
233       else {
234         emit LogExecutionFailure(_transactionId);
235         txn.executed = 0;
236       }
237     }
238   }
239 
240   // call has been separated into its own function in order to take advantage
241   // of the Solidity's code generator to produce a loop that copies tx.data into memory.
242   function external_call(
243     address _destination,
244     uint _value,
245     uint _dataLength,
246     bytes memory _data
247   ) internal returns (bool) {
248     bool result;
249 
250     assembly {
251       let x := mload(0x40) // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
252       let d := add(_data, 32) // First 32 bytes are the padded length of data, so exclude that
253       result := call(
254         sub(gas(), 34710),   // 34710 is the value that solidity is currently emitting
255         // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
256         // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
257         _destination,
258         _value,
259         d,
260         _dataLength,        // Size of the input (in bytes) - this is what fixes the padding problem
261         x,
262         0                  // Output is ignored, therefore the output size is zero
263       )
264     }
265 
266     // hack for getting result value, for some reason wo this, it was always return false
267     // @todo why result value is not passed if I do not add require?
268     require(result, "tx failed on destination contract");
269 
270     return result;
271   }
272 
273   function _addTransaction(address _destination, uint _value, bytes memory _data)
274   internal
275   notNull(_destination)
276   returns (uint transactionId)
277   {
278     transactionId = transactionCount;
279     transactions[transactionId] = Transaction({
280     destination: _destination,
281     value: _value,
282     data: _data,
283     executed: 0
284     });
285     transactionCount += 1;
286     emit LogSubmission(transactionId);
287   }
288 
289   // ========== VIEWS ========== //
290 
291   function sum(uint[] memory _numbers) public pure returns (uint total) {
292     uint numbersCount = _numbers.length;
293 
294     for (uint i = 0; i < numbersCount; i++) {
295       total += _numbers[i];
296     }
297   }
298 
299   function isConfirmed(uint _transactionId) public view returns (bool) {
300     uint power = 0;
301 
302     for (uint i=0; i<owners.length; i++) {
303       if (confirmations[_transactionId][owners[i]]) {
304         power += ownersPowers[owners[i]];
305       }
306 
307       if (power >= requiredPower) {
308         return true;
309       }
310     }
311 
312     return false;
313   }
314 
315   function isExceuted(uint _transactionId) public view returns (bool) {
316     return transactions[_transactionId].executed != 0;
317   }
318 
319   function getTransactionShort(uint _transactionId)
320   public view returns (address destination, uint value, uint executed) {
321     Transaction memory t = transactions[_transactionId];
322     return (t.destination, t.value, t.executed);
323   }
324 
325   function getTransaction(uint _transactionId)
326   public view returns (address destination, uint value, uint executed, bytes memory data) {
327     Transaction memory t = transactions[_transactionId];
328     return (t.destination, t.value, t.executed, t.data);
329   }
330 
331   /*
332    * Web3 call functions
333    */
334   /// @dev Returns number of confirmations of a transaction.
335   /// @param _transactionId Transaction ID.
336   /// @return count Number of confirmations.
337   function getLogConfirmationCount(uint _transactionId) public view returns (uint count)
338   {
339     for (uint i=0; i<owners.length; i++) {
340       if (confirmations[_transactionId][owners[i]]) {
341         count += 1;
342       }
343     }
344   }
345 
346   /// @dev Returns total number of transactions after filers are applied.
347   /// @param _pending Include pending transactions.
348   /// @param _executed Include executed transactions.
349   /// @return count Total number of transactions after filters are applied.
350   function getTransactionCount(bool _pending, bool _executed) public view returns (uint count)
351   {
352     for (uint i=0; i<transactionCount; i++) {
353       if (_pending && transactions[i].executed == 0 || _executed && transactions[i].executed != 0) {
354         count += 1;
355       }
356     }
357   }
358 
359   /// @dev Returns array with owner addresses, which confirmed transaction.
360   /// @param _transactionId Transaction ID.
361   /// @return _confirmations Returns array of owner addresses.
362   function getLogConfirmations(uint _transactionId)
363   public
364   view
365   returns (address[] memory _confirmations)
366   {
367     address[] memory confirmationsTemp = new address[](owners.length);
368     uint count = 0;
369     uint i;
370 
371     for (i=0; i<owners.length; i++) {
372       if (confirmations[_transactionId][owners[i]]) {
373         confirmationsTemp[count] = owners[i];
374         count += 1;
375       }
376     }
377 
378     _confirmations = new address[](count);
379 
380     for (i=0; i<count; i++) {
381       _confirmations[i] = confirmationsTemp[i];
382     }
383   }
384 
385   /// @dev Returns list of transaction IDs in defined range.
386   /// @param _from Index start position of transaction array.
387   /// @param _to Index end position of transaction array.
388   /// @param _pending Include pending transactions.
389   /// @param _executed Include executed transactions.
390   /// @return _transactionIds Returns array of transaction IDs.
391   function getTransactionIds(uint _from, uint _to, bool _pending, bool _executed)
392   public
393   view
394   returns (uint[] memory _transactionIds)
395   {
396     uint[] memory transactionIdsTemp = new uint[](transactionCount);
397     uint count = 0;
398     uint i;
399 
400     for (i=0; i<transactionCount; i++) {
401       if (_pending && transactions[i].executed == 0 || _executed && transactions[i].executed != 0) {
402         transactionIdsTemp[count] = i;
403         count += 1;
404       }
405     }
406 
407     _transactionIds = new uint[](_to - _from);
408 
409     for (i= _from; i< _to; i++) {
410       _transactionIds[i - _from] = transactionIdsTemp[i];
411     }
412   }
413 
414   // ========== EVENTS ========== //
415 
416   event LogConfirmation(address indexed sender, uint indexed transactionId);
417   event LogRevocation(address indexed sender, uint indexed transactionId);
418   event LogSubmission(uint indexed transactionId);
419   event LogExecution(uint indexed transactionId);
420   event LogExecutionFailure(uint indexed transactionId);
421   event LogDeposit(address indexed sender, uint value);
422   event LogOwnerAddition(address indexed owner, uint power);
423   event LogOwnerRemoval(address indexed owner);
424   event LogPowerChange(uint power);
425 }
