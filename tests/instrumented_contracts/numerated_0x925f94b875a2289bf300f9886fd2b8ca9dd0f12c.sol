1 pragma solidity 0.4.15;
2 
3 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
4 /// @author Stefan George - <stefan.george@consensys.net>
5 contract MultiSigWallet {
6 
7   /**
8    *  Constants
9   **/
10   uint constant public MAX_OWNER_COUNT = 50;
11 
12   /**
13    *  Storage
14   **/
15   mapping (uint => Transaction) public transactions;
16   mapping (uint => mapping (address => bool)) public confirmations;
17   mapping (address => bool) public isOwner;
18   address[] public owners;
19   uint public required;
20   uint public transactionCount;
21 
22   struct Transaction {
23     address destination;
24     uint value;
25     bytes data;
26     bool executed;
27   }
28 
29   /**
30    *  Events
31   **/
32   event Confirmation(address indexed sender, uint indexed transactionId);
33   event Revocation(address indexed sender, uint indexed transactionId);
34   event Submission(uint indexed transactionId);
35   event Execution(uint indexed transactionId);
36   event ExecutionFailure(uint indexed transactionId);
37   event Deposit(address indexed sender, uint value);
38   event OwnerAddition(address indexed owner);
39   event OwnerRemoval(address indexed owner);
40   event RequirementChange(uint required);
41 
42   /**
43    *  Modifiers
44   **/
45   modifier onlyWallet() {
46     require(msg.sender == address(this));
47     _;
48   }
49 
50   modifier ownerDoesNotExist(address owner) {
51     require(!isOwner[owner]);
52     _;
53   }
54 
55   modifier ownerExists(address owner) {
56     require(isOwner[owner]);
57     _;
58   }
59 
60   modifier transactionExists(uint transactionId) {
61     require(transactions[transactionId].destination != 0);
62     _;
63   }
64 
65   modifier confirmed(uint transactionId, address owner) {
66     require(confirmations[transactionId][owner]);
67     _;
68   }
69 
70   modifier notConfirmed(uint transactionId, address owner) {
71     require(!confirmations[transactionId][owner]);
72     _;
73   }
74 
75   modifier notExecuted(uint transactionId) {
76     require(!transactions[transactionId].executed);
77     _;
78   }
79 
80   modifier notNull(address _address) {
81     require(_address != 0);
82     _;
83   }
84 
85   modifier validRequirement(uint ownerCount, uint _required) {
86     require(ownerCount <= MAX_OWNER_COUNT && _required <= ownerCount && _required != 0 && ownerCount != 0);
87     _;
88   }
89 
90   /**
91    * Public functions
92   **/
93   /// @dev Contract constructor sets initial owners and required number of confirmations.
94   /// @param _owners List of initial owners.
95   /// @param _required Number of required confirmations.
96   function MultiSigWallet(address[] _owners, uint _required)
97     validRequirement(_owners.length, _required)
98   public {
99     for (uint i = 0; i < _owners.length; i++) {
100       require(!isOwner[_owners[i]] && _owners[i] != 0);
101       isOwner[_owners[i]] = true;
102     }
103     owners = _owners;
104     required = _required;
105   }
106 
107   /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
108   /// @param owner Address of new owner.
109   function addOwner(address owner)
110     onlyWallet
111     ownerDoesNotExist(owner)
112     notNull(owner)
113     validRequirement(owners.length + 1, required)
114   public {
115     isOwner[owner] = true;
116     owners.push(owner);
117     OwnerAddition(owner);
118   }
119 
120   /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
121   /// @param owner Address of owner.
122   function removeOwner(address owner)
123     onlyWallet
124     ownerExists(owner)
125   public {
126     isOwner[owner] = false;
127     for (uint i = 0; i < owners.length - 1; i++) {
128       if (owners[i] == owner) {
129         owners[i] = owners[owners.length - 1];
130         break;
131       }
132     }
133     owners.length -= 1;
134     if (required > owners.length) {
135       changeRequirement(owners.length);
136     }
137     OwnerRemoval(owner);
138   }
139 
140   /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
141   /// @param owner Address of owner to be replaced.
142   /// @param newOwner Address of new owner.
143   function replaceOwner(address owner, address newOwner)
144     onlyWallet
145     ownerExists(owner)
146     ownerDoesNotExist(newOwner)
147   public {
148     for (uint i=0; i<owners.length; i++) {
149       if (owners[i] == owner) {
150         owners[i] = newOwner;
151         break;
152       }
153     }
154     isOwner[owner] = false;
155     isOwner[newOwner] = true;
156     OwnerRemoval(owner);
157     OwnerAddition(newOwner);
158   }
159 
160   /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
161   /// @param _required Number of required confirmations.
162   function changeRequirement(uint _required)
163     onlyWallet
164     validRequirement(owners.length, _required)
165   public {
166     required = _required;
167     RequirementChange(_required);
168   }
169 
170   /// @dev Allows an owner to submit and confirm a transaction.
171   /// @param destination Transaction target address.
172   /// @param value Transaction ether value.
173   /// @param data Transaction data payload.
174   /// @return Returns transaction ID.
175   function submitTransaction(address destination, uint value, bytes data)
176     public
177     returns (uint transactionId)
178   {
179     transactionId = addTransaction(destination, value, data);
180     confirmTransaction(transactionId);
181   }
182 
183   /// @dev Allows an owner to confirm a transaction.
184   /// @param transactionId Transaction ID.
185   function confirmTransaction(uint transactionId)
186     ownerExists(msg.sender)
187     transactionExists(transactionId)
188     notConfirmed(transactionId, msg.sender)
189   public {
190     confirmations[transactionId][msg.sender] = true;
191     Confirmation(msg.sender, transactionId);
192     executeTransaction(transactionId);
193   }
194 
195   /// @dev Allows an owner to revoke a confirmation for a transaction.
196   /// @param transactionId Transaction ID.
197   function revokeConfirmation(uint transactionId)
198     ownerExists(msg.sender)
199     confirmed(transactionId, msg.sender)
200     notExecuted(transactionId)
201   public {
202     confirmations[transactionId][msg.sender] = false;
203     Revocation(msg.sender, transactionId);
204   }
205 
206   /// @dev Allows anyone to execute a confirmed transaction.
207   /// @param transactionId Transaction ID.
208   function executeTransaction(uint transactionId)
209     ownerExists(msg.sender)
210     confirmed(transactionId, msg.sender)
211     notExecuted(transactionId)
212   public {
213     if (isConfirmed(transactionId)) {
214       Transaction storage txn = transactions[transactionId];
215       txn.executed = true;
216       if (txn.destination.call.value(txn.value)(txn.data)) {
217         Execution(transactionId);
218       } else {
219         ExecutionFailure(transactionId);
220         txn.executed = false;
221       }
222     }
223   }
224 
225   /// @dev Returns the confirmation status of a transaction.
226   /// @param transactionId Transaction ID.
227   /// @return Confirmation status.
228   function isConfirmed(uint transactionId)
229     constant
230     public
231     returns (bool)
232   {
233     uint count = 0;
234     for (uint i = 0; i < owners.length; i++) {
235       if (confirmations[transactionId][owners[i]]) {
236         count += 1;
237       }
238       if (count == required) {
239         return true;
240       }
241     }
242   }
243 
244   /*
245    * Internal functions
246    */
247   /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
248   /// @param destination Transaction target address.
249   /// @param value Transaction ether value.
250   /// @param data Transaction data payload.
251   /// @return Returns transaction ID.
252   function addTransaction(address destination, uint value, bytes data)
253     notNull(destination)
254     internal
255     returns (uint transactionId)
256   {
257     transactionId = transactionCount;
258     transactions[transactionId] = Transaction({
259       destination: destination,
260       value: value,
261       data: data,
262       executed: false
263     });
264     transactionCount += 1;
265     Submission(transactionId);
266   }
267 
268   /*
269    * Web3 call functions
270    */
271   /// @dev Returns number of confirmations of a transaction.
272   /// @param transactionId Transaction ID.
273   /// @return Number of confirmations.
274   function getConfirmationCount(uint transactionId)
275     constant
276     public
277     returns (uint count)
278   {
279     for (uint i=0; i<owners.length; i++) {
280       if (confirmations[transactionId][owners[i]]) {
281         count += 1;
282       }
283     }
284   }
285 
286   /// @dev Returns total number of transactions after filers are applied.
287   /// @param pending Include pending transactions.
288   /// @param executed Include executed transactions.
289   /// @return Total number of transactions after filters are applied.
290   function getTransactionCount(bool pending, bool executed)
291     constant
292     public
293     returns (uint count)
294   {
295     for (uint i = 0; i < transactionCount; i++) {
296       if ((pending && !transactions[i].executed) || (executed && transactions[i].executed)) {
297         count += 1;
298       }
299     }
300   }
301 
302   /// @dev Returns list of owners.
303   /// @return List of owner addresses.
304   function getOwners()
305     constant
306     public
307     returns (address[])
308   {
309     return owners;
310   }
311 
312   /// @dev Returns array with owner addresses, which confirmed transaction.
313   /// @param transactionId Transaction ID.
314   /// @return Returns array of owner addresses.
315   function getConfirmations(uint transactionId)
316     constant
317     public
318     returns (address[] _confirmations)
319   {
320     address[] memory confirmationsTemp = new address[](owners.length);
321     uint count = 0;
322     uint i;
323     for (i=0; i<owners.length; i++) {
324       if (confirmations[transactionId][owners[i]]) {
325         confirmationsTemp[count] = owners[i];
326         count += 1;
327       }
328     }
329     _confirmations = new address[](count);
330     for (i=0; i<count; i++) {
331       _confirmations[i] = confirmationsTemp[i];
332     }
333   }
334 
335   /// @dev Returns list of transaction IDs in defined range.
336   /// @param from Index start position of transaction array.
337   /// @param to Index end position of transaction array.
338   /// @param pending Include pending transactions.
339   /// @param executed Include executed transactions.
340   /// @return Returns array of transaction IDs.
341   /// @dev Returns list of transaction IDs in defined range.
342   function getTransactionIds(uint from, uint to, bool pending, bool executed)
343     constant
344     public
345     returns (uint[] _transactionIds)
346   {
347     require(from <= to || to < transactionCount);
348     uint[] memory transactionIdsTemp = new uint[](to - from + 1);
349     uint count = 0;
350     uint i;
351     for (i = from; i <= to; i++) {
352       if ((pending && !transactions[i].executed) || (executed && transactions[i].executed)) {
353         transactionIdsTemp[count] = i;
354         count += 1;
355       }
356     }
357     _transactionIds = new uint[](count);
358     for (i=0; i<count; i++) {
359       _transactionIds[i] = transactionIdsTemp[i];
360     }
361   }
362 
363   /// @dev Fallback function allows to deposit ether.
364   function() public payable {
365     if (msg.value > 0) {
366       Deposit(msg.sender, msg.value);
367     }
368   }
369 }