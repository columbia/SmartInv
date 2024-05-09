1 pragma solidity ^0.4.15;
2 
3 
4 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
5 /// @author Stefan George - <stefan.george@consensys.net>
6 contract MultiSigWallet {
7 
8     /*
9      *  Events
10      */
11     event Confirmation(address indexed sender, uint indexed transactionId);
12     event Revocation(address indexed sender, uint indexed transactionId);
13     event Submission(uint indexed transactionId);
14     event Execution(uint indexed transactionId);
15     event ExecutionFailure(uint indexed transactionId);
16     event Deposit(address indexed sender, uint value);
17     event OwnerAddition(address indexed owner);
18     event OwnerRemoval(address indexed owner);
19     event RequirementChange(uint required);
20 
21     /*
22      *  Constants
23      */
24     uint constant public MAX_OWNER_COUNT = 50;
25 
26     /*
27      *  Storage
28      */
29     mapping (uint => Transaction) public transactions;
30     mapping (uint => mapping (address => bool)) public confirmations;
31     mapping (address => bool) public isOwner;
32     address[] public owners;
33     uint public required;
34     uint public transactionCount;
35 
36     struct Transaction {
37         address destination;
38         uint value;
39         bytes data;
40         bool executed;
41     }
42 
43     /*
44      *  Modifiers
45      */
46     modifier onlyWallet() {
47         if (msg.sender != address(this))
48             throw;
49         _;
50     }
51 
52     modifier ownerDoesNotExist(address owner) {
53         if (isOwner[owner])
54             throw;
55         _;
56     }
57 
58     modifier ownerExists(address owner) {
59         if (!isOwner[owner])
60             throw;
61         _;
62     }
63 
64     modifier transactionExists(uint transactionId) {
65         if (transactions[transactionId].destination == 0)
66             throw;
67         _;
68     }
69 
70     modifier confirmed(uint transactionId, address owner) {
71         if (!confirmations[transactionId][owner])
72             throw;
73         _;
74     }
75 
76     modifier notConfirmed(uint transactionId, address owner) {
77         if (confirmations[transactionId][owner])
78             throw;
79         _;
80     }
81 
82     modifier notExecuted(uint transactionId) {
83         if (transactions[transactionId].executed)
84             throw;
85         _;
86     }
87 
88     modifier notNull(address _address) {
89         if (_address == 0)
90             throw;
91         _;
92     }
93 
94     modifier validRequirement(uint ownerCount, uint _required) {
95         if (   ownerCount > MAX_OWNER_COUNT
96             || _required > ownerCount
97             || _required == 0
98             || ownerCount == 0)
99             throw;
100         _;
101     }
102 
103     /// @dev Fallback function allows to deposit ether.
104     function()
105         payable
106     {
107         if (msg.value > 0)
108             Deposit(msg.sender, msg.value);
109     }
110 
111     /*
112      * Public functions
113      */
114     /// @dev Contract constructor sets initial owners and required number of confirmations.
115     /// @param _owners List of initial owners.
116     /// @param _required Number of required confirmations.
117     function MultiSigWallet(address[] _owners, uint _required)
118         public
119         validRequirement(_owners.length, _required)
120     {
121         for (uint i=0; i<_owners.length; i++) {
122             if (isOwner[_owners[i]] || _owners[i] == 0)
123                 throw;
124             isOwner[_owners[i]] = true;
125         }
126         owners = _owners;
127         required = _required;
128     }
129 
130     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
131     /// @param owner Address of new owner.
132     function addOwner(address owner)
133         public
134         onlyWallet
135         ownerDoesNotExist(owner)
136         notNull(owner)
137         validRequirement(owners.length + 1, required)
138     {
139         isOwner[owner] = true;
140         owners.push(owner);
141         OwnerAddition(owner);
142     }
143 
144     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
145     /// @param owner Address of owner.
146     function removeOwner(address owner)
147         public
148         onlyWallet
149         ownerExists(owner)
150     {
151         isOwner[owner] = false;
152         for (uint i=0; i<owners.length - 1; i++)
153             if (owners[i] == owner) {
154                 owners[i] = owners[owners.length - 1];
155                 break;
156             }
157         owners.length -= 1;
158         if (required > owners.length)
159             changeRequirement(owners.length);
160         OwnerRemoval(owner);
161     }
162 
163     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
164     /// @param owner Address of owner to be replaced.
165     /// @param newOwner Address of new owner.
166     function replaceOwner(address owner, address newOwner)
167         public
168         onlyWallet
169         ownerExists(owner)
170         ownerDoesNotExist(newOwner)
171     {
172         for (uint i=0; i<owners.length; i++)
173             if (owners[i] == owner) {
174                 owners[i] = newOwner;
175                 break;
176             }
177         isOwner[owner] = false;
178         isOwner[newOwner] = true;
179         OwnerRemoval(owner);
180         OwnerAddition(newOwner);
181     }
182 
183     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
184     /// @param _required Number of required confirmations.
185     function changeRequirement(uint _required)
186         public
187         onlyWallet
188         validRequirement(owners.length, _required)
189     {
190         required = _required;
191         RequirementChange(_required);
192     }
193 
194     /// @dev Allows an owner to submit and confirm a transaction.
195     /// @param destination Transaction target address.
196     /// @param value Transaction ether value.
197     /// @param data Transaction data payload.
198     /// @return Returns transaction ID.
199     function submitTransaction(address destination, uint value, bytes data)
200         public
201         returns (uint transactionId)
202     {
203         transactionId = addTransaction(destination, value, data);
204         confirmTransaction(transactionId);
205     }
206 
207     /// @dev Allows an owner to confirm a transaction.
208     /// @param transactionId Transaction ID.
209     function confirmTransaction(uint transactionId)
210         public
211         ownerExists(msg.sender)
212         transactionExists(transactionId)
213         notConfirmed(transactionId, msg.sender)
214     {
215         confirmations[transactionId][msg.sender] = true;
216         Confirmation(msg.sender, transactionId);
217         executeTransaction(transactionId);
218     }
219 
220     /// @dev Allows an owner to revoke a confirmation for a transaction.
221     /// @param transactionId Transaction ID.
222     function revokeConfirmation(uint transactionId)
223         public
224         ownerExists(msg.sender)
225         confirmed(transactionId, msg.sender)
226         notExecuted(transactionId)
227     {
228         confirmations[transactionId][msg.sender] = false;
229         Revocation(msg.sender, transactionId);
230     }
231 
232     /// @dev Allows anyone to execute a confirmed transaction.
233     /// @param transactionId Transaction ID.
234     function executeTransaction(uint transactionId)
235         public
236         ownerExists(msg.sender)
237         confirmed(transactionId, msg.sender)
238         notExecuted(transactionId)
239     {
240         if (isConfirmed(transactionId)) {
241             Transaction tx = transactions[transactionId];
242             tx.executed = true;
243             if (tx.destination.call.value(tx.value)(tx.data))
244                 Execution(transactionId);
245             else {
246                 ExecutionFailure(transactionId);
247                 tx.executed = false;
248             }
249         }
250     }
251 
252     /// @dev Returns the confirmation status of a transaction.
253     /// @param transactionId Transaction ID.
254     /// @return Confirmation status.
255     function isConfirmed(uint transactionId)
256         public
257         constant
258         returns (bool)
259     {
260         uint count = 0;
261         for (uint i=0; i<owners.length; i++) {
262             if (confirmations[transactionId][owners[i]])
263                 count += 1;
264             if (count == required)
265                 return true;
266         }
267     }
268 
269     /*
270      * Internal functions
271      */
272     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
273     /// @param destination Transaction target address.
274     /// @param value Transaction ether value.
275     /// @param data Transaction data payload.
276     /// @return Returns transaction ID.
277     function addTransaction(address destination, uint value, bytes data)
278         internal
279         notNull(destination)
280         returns (uint transactionId)
281     {
282         transactionId = transactionCount;
283         transactions[transactionId] = Transaction({
284             destination: destination,
285             value: value,
286             data: data,
287             executed: false
288         });
289         transactionCount += 1;
290         Submission(transactionId);
291     }
292 
293     /*
294      * Web3 call functions
295      */
296     /// @dev Returns number of confirmations of a transaction.
297     /// @param transactionId Transaction ID.
298     /// @return Number of confirmations.
299     function getConfirmationCount(uint transactionId)
300         public
301         constant
302         returns (uint count)
303     {
304         for (uint i=0; i<owners.length; i++)
305             if (confirmations[transactionId][owners[i]])
306                 count += 1;
307     }
308 
309     /// @dev Returns total number of transactions after filers are applied.
310     /// @param pending Include pending transactions.
311     /// @param executed Include executed transactions.
312     /// @return Total number of transactions after filters are applied.
313     function getTransactionCount(bool pending, bool executed)
314         public
315         constant
316         returns (uint count)
317     {
318         for (uint i=0; i<transactionCount; i++)
319             if (   pending && !transactions[i].executed
320                 || executed && transactions[i].executed)
321                 count += 1;
322     }
323 
324     /// @dev Returns list of owners.
325     /// @return List of owner addresses.
326     function getOwners()
327         public
328         constant
329         returns (address[])
330     {
331         return owners;
332     }
333 
334     /// @dev Returns array with owner addresses, which confirmed transaction.
335     /// @param transactionId Transaction ID.
336     /// @return Returns array of owner addresses.
337     function getConfirmations(uint transactionId)
338         public
339         constant
340         returns (address[] _confirmations)
341     {
342         address[] memory confirmationsTemp = new address[](owners.length);
343         uint count = 0;
344         uint i;
345         for (i=0; i<owners.length; i++)
346             if (confirmations[transactionId][owners[i]]) {
347                 confirmationsTemp[count] = owners[i];
348                 count += 1;
349             }
350         _confirmations = new address[](count);
351         for (i=0; i<count; i++)
352             _confirmations[i] = confirmationsTemp[i];
353     }
354 
355     /// @dev Returns list of transaction IDs in defined range.
356     /// @param from Index start position of transaction array.
357     /// @param to Index end position of transaction array.
358     /// @param pending Include pending transactions.
359     /// @param executed Include executed transactions.
360     /// @return Returns array of transaction IDs.
361     function getTransactionIds(uint from, uint to, bool pending, bool executed)
362         public
363         constant
364         returns (uint[] _transactionIds)
365     {
366         uint[] memory transactionIdsTemp = new uint[](transactionCount);
367         uint count = 0;
368         uint i;
369         for (i=0; i<transactionCount; i++)
370             if (   pending && !transactions[i].executed
371                 || executed && transactions[i].executed)
372             {
373                 transactionIdsTemp[count] = i;
374                 count += 1;
375             }
376         _transactionIds = new uint[](to - from);
377         for (i=from; i<to; i++)
378             _transactionIds[i - from] = transactionIdsTemp[i];
379     }
380 }