1 pragma solidity ^0.4.11;
2 
3 
4 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution
5 /// @author Stefan George - <stefan@gnosis.pm>
6 contract MultiSigWallet {
7 
8   /*
9    *  Events
10    */
11   event Confirmation(address indexed sender, uint indexed transactionId);
12   event Revocation(address indexed sender, uint indexed transactionId);
13   event Submission(uint indexed transactionId);
14   event Execution(uint indexed transactionId);
15   event ExecutionFailure(uint indexed transactionId);
16   event Deposit(address indexed sender, uint value);
17   event OwnerAddition(address indexed owner);
18   event OwnerRemoval(address indexed owner);
19   event RequirementChange(uint required);
20 
21   /*
22    *  Constants
23    */
24   uint public constant MAX_OWNER_COUNT = 50;
25 
26   /*
27    *  Storage
28    */
29   mapping (uint => Transaction) public transactions;
30   mapping (uint => mapping (address => bool)) public confirmations;
31   mapping (address => bool) public isOwner;
32   address[] public owners;
33   uint public required;
34   uint public transactionCount;
35 
36   struct Transaction {
37   address destination;
38   uint value;
39   bytes data;
40   bool executed;
41   }
42 
43   /*
44    *  Modifiers
45    */
46   modifier onlyWallet() {
47     if (msg.sender != address(this))
48     revert();
49     _;
50   }
51 
52   modifier ownerDoesNotExist(address owner) {
53     if (isOwner[owner])
54     revert();
55     _;
56   }
57 
58   modifier ownerExists(address owner) {
59     if (!isOwner[owner])
60     revert();
61     _;
62   }
63 
64   modifier transactionExists(uint transactionId) {
65     if (transactions[transactionId].destination == 0)
66     revert();
67     _;
68   }
69 
70   modifier confirmed(uint transactionId, address owner) {
71     if (!confirmations[transactionId][owner])
72     revert();
73     _;
74   }
75 
76   modifier notConfirmed(uint transactionId, address owner) {
77     if (confirmations[transactionId][owner])
78     revert();
79     _;
80   }
81 
82   modifier executable(uint transactionId) {
83     if (!isConfirmed(transactionId))
84     revert();
85     _;
86   }
87 
88   modifier notExecuted(uint transactionId) {
89     if (transactions[transactionId].executed)
90     revert();
91     _;
92   }
93 
94   modifier notNull(address _address) {
95     if (_address == 0)
96     revert();
97     _;
98   }
99 
100   modifier validRequirement(uint ownerCount, uint _required) {
101     if (   ownerCount > MAX_OWNER_COUNT
102     || _required > ownerCount
103     || _required == 0
104     || ownerCount == 0)
105     revert();
106     _;
107   }
108 
109   /// @dev Fallback function allows to deposit ether
110   function()
111   public
112   payable
113   {
114     if (msg.value > 0)
115     Deposit(msg.sender, msg.value);
116   }
117 
118   /*
119    * Public functions
120    */
121   /// @dev Contract constructor sets initial owners and required number of confirmations
122   /// @param _owners List of initial owners
123   /// @param _required Number of required confirmations
124   function MultiSigWallet(address[] _owners, uint _required)
125   public
126   validRequirement(_owners.length, _required)
127   {
128     for (uint i=0; i<_owners.length; i++) {
129       if (isOwner[_owners[i]] || _owners[i] == 0)
130       revert();
131       isOwner[_owners[i]] = true;
132     }
133     owners = _owners;
134     required = _required;
135   }
136 
137   /// @dev Allows to add a new owner. Transaction has to be sent by wallet
138   /// @param owner Address of new owner
139   function addOwner(address owner)
140   public
141   onlyWallet
142   ownerDoesNotExist(owner)
143   notNull(owner)
144   validRequirement(owners.length + 1, required)
145   {
146     isOwner[owner] = true;
147     owners.push(owner);
148     OwnerAddition(owner);
149   }
150 
151   /// @dev Allows to remove an owner. Transaction has to be sent by wallet
152   /// @param owner Address of owner
153   function removeOwner(address owner)
154   public
155   onlyWallet
156   ownerExists(owner)
157   {
158     isOwner[owner] = false;
159     for (uint i=0; i<owners.length - 1; i++)
160     if (owners[i] == owner) {
161       owners[i] = owners[owners.length - 1];
162       break;
163     }
164     owners.length -= 1;
165     if (required > owners.length)
166     changeRequirement(owners.length);
167     OwnerRemoval(owner);
168   }
169 
170   /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet
171   /// @param owner Address of owner to be replaced
172   /// @param newOwner Address of new owner
173   function replaceOwner(address owner, address newOwner)
174   public
175   onlyWallet
176   ownerExists(owner)
177   ownerDoesNotExist(newOwner)
178   {
179     for (uint i=0; i<owners.length; i++)
180     if (owners[i] == owner) {
181       owners[i] = newOwner;
182       break;
183     }
184     isOwner[owner] = false;
185     isOwner[newOwner] = true;
186     OwnerRemoval(owner);
187     OwnerAddition(newOwner);
188   }
189 
190   /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet
191   /// @param _required Number of required confirmations
192   function changeRequirement(uint _required)
193   public
194   onlyWallet
195   validRequirement(owners.length, _required)
196   {
197     required = _required;
198     RequirementChange(_required);
199   }
200 
201   /// @dev Allows an owner to submit and confirm a transaction
202   /// @param destination Transaction target address
203   /// @param value Transaction ether value
204   /// @param data Transaction data payload
205   /// @return Returns transaction ID
206   function submitTransaction(address destination, uint value, bytes data)
207   public
208   returns (uint transactionId)
209   {
210     transactionId = addTransaction(destination, value, data);
211     confirmTransaction(transactionId);
212   }
213 
214   /// @dev Allows an owner to confirm a transaction
215   /// @param transactionId Transaction ID
216   function confirmTransaction(uint transactionId)
217   public
218   ownerExists(msg.sender)
219   transactionExists(transactionId)
220   notConfirmed(transactionId, msg.sender)
221   {
222     confirmations[transactionId][msg.sender] = true;
223     Confirmation(msg.sender, transactionId);
224     if (isConfirmed(transactionId))
225     executeTransaction(transactionId);
226   }
227 
228   /// @dev Allows an owner to revoke a confirmation for a transaction
229   /// @param transactionId Transaction ID
230   function revokeConfirmation(uint transactionId)
231   public
232   ownerExists(msg.sender)
233   confirmed(transactionId, msg.sender)
234   notExecuted(transactionId)
235   {
236     confirmations[transactionId][msg.sender] = false;
237     Revocation(msg.sender, transactionId);
238   }
239 
240   /// @dev Allows anyone to execute a confirmed transaction
241   /// @param transactionId Transaction ID
242   function executeTransaction(uint transactionId)
243   public
244   ownerExists(msg.sender)
245   confirmed(transactionId, msg.sender)
246   notExecuted(transactionId)
247   executable(transactionId)
248   {
249     Transaction txToExecute = transactions[transactionId];
250     txToExecute.executed = true;
251     if (txToExecute.destination.call.value(txToExecute.value)(txToExecute.data))
252     Execution(transactionId);
253     else {
254       ExecutionFailure(transactionId);
255       txToExecute.executed = false;
256     }
257   }
258 
259   /// @dev Returns the confirmation status of a transaction
260   /// @param transactionId Transaction ID
261   /// @return Confirmation status
262   function isConfirmed(uint transactionId)
263   public
264   constant
265   returns (bool)
266   {
267     uint count = 0;
268     for (uint i=0; i<owners.length; i++) {
269       if (confirmations[transactionId][owners[i]])
270       count += 1;
271       if (count == required)
272       return true;
273     }
274   }
275 
276   /*
277    * Internal functions
278    */
279   /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet
280   /// @param destination Transaction target address
281   /// @param value Transaction ether value
282   /// @param data Transaction data payload
283   /// @return Returns transaction ID
284   function addTransaction(address destination, uint value, bytes data)
285   internal
286   notNull(destination)
287   returns (uint transactionId)
288   {
289     transactionId = transactionCount;
290     transactions[transactionId] = Transaction({
291     destination: destination,
292     value: value,
293     data: data,
294     executed: false
295     });
296     transactionCount += 1;
297     Submission(transactionId);
298   }
299 
300   /*
301    * Web3 call functions
302    */
303   /// @dev Returns number of confirmations of a transaction
304   /// @param transactionId Transaction ID
305   /// @return Number of confirmations
306   function getConfirmationCount(uint transactionId)
307   public
308   constant
309   returns (uint count)
310   {
311     for (uint i=0; i<owners.length; i++)
312     if (confirmations[transactionId][owners[i]])
313     count += 1;
314   }
315 
316   /// @dev Returns total number of transactions after filers are applied
317   /// @param pending Include pending transactions
318   /// @param executed Include executed transactions
319   /// @return Total number of transactions after filters are applied
320   function getTransactionCount(bool pending, bool executed)
321   public
322   constant
323   returns (uint count)
324   {
325     for (uint i=0; i<transactionCount; i++)
326     if (   pending && !transactions[i].executed
327     || executed && transactions[i].executed)
328     count += 1;
329   }
330 
331   /// @dev Returns list of owners
332   /// @return List of owner addresses
333   function getOwners()
334   public
335   constant
336   returns (address[])
337   {
338     return owners;
339   }
340 
341   /// @dev Returns array with owner addresses, which confirmed transaction
342   /// @param transactionId Transaction ID
343   /// @return Returns array of owner addresses
344   function getConfirmations(uint transactionId)
345   public
346   constant
347   returns (address[] _confirmations)
348   {
349     address[] memory confirmationsTemp = new address[](owners.length);
350     uint count = 0;
351     uint i;
352     for (i=0; i<owners.length; i++)
353     if (confirmations[transactionId][owners[i]]) {
354       confirmationsTemp[count] = owners[i];
355       count += 1;
356     }
357     _confirmations = new address[](count);
358     for (i=0; i<count; i++)
359     _confirmations[i] = confirmationsTemp[i];
360   }
361 
362   /// @dev Returns list of transaction IDs in defined range
363   /// @param from Index start position of transaction array
364   /// @param to Index end position of transaction array
365   /// @param pending Include pending transactions
366   /// @param executed Include executed transactions
367   /// @return Returns array of transaction IDs
368   function getTransactionIds(uint from, uint to, bool pending, bool executed)
369   public
370   constant
371   returns (uint[] _transactionIds)
372   {
373     uint[] memory transactionIdsTemp = new uint[](transactionCount);
374     uint count = 0;
375     uint i;
376     for (i=0; i<transactionCount; i++)
377     if (   pending && !transactions[i].executed
378     || executed && transactions[i].executed)
379     {
380       transactionIdsTemp[count] = i;
381       count += 1;
382     }
383     _transactionIds = new uint[](to - from);
384     for (i=from; i<to; i++)
385     _transactionIds[i - from] = transactionIdsTemp[i];
386   }
387 }