1 pragma solidity ^0.4.18;
2 
3 contract ZipperWithdrawalRight
4 {
5     address realzipper;
6 
7     function ZipperWithdrawalRight(address _realzipper) public
8     {
9         realzipper = _realzipper;
10     }
11     
12     function withdraw(MultiSigWallet _wallet, uint _value) public
13     {
14         require (_wallet.isOwner(msg.sender));
15         require (_wallet.isOwner(this));
16         
17         _wallet.submitTransaction(msg.sender, _value, "");
18     }
19 
20     function changeRealZipper(address _newRealZipper) public
21     {
22         require(msg.sender == realzipper);
23         realzipper = _newRealZipper;
24     }
25     
26     function submitTransaction(MultiSigWallet _wallet, address _destination, uint _value, bytes _data) public returns (uint transactionId)
27     {
28         require(msg.sender == realzipper);
29         return _wallet.submitTransaction(_destination, _value, _data);
30     }
31     
32     function confirmTransaction(MultiSigWallet _wallet, uint transactionId) public
33     {
34         require(msg.sender == realzipper);
35         _wallet.confirmTransaction(transactionId);
36     }
37     
38     function revokeConfirmation(MultiSigWallet _wallet, uint transactionId) public
39     {
40         require(msg.sender == realzipper);
41         _wallet.revokeConfirmation(transactionId);
42     }
43     
44     function executeTransaction(MultiSigWallet _wallet, uint transactionId) public
45     {
46         require(msg.sender == realzipper);
47         _wallet.confirmTransaction(transactionId);
48     }
49 }
50 
51 // b7f01af8bd882501f6801eb1eea8b22aa2a4979e from https://github.com/gnosis/MultiSigWallet/blob/master/contracts/MultiSigWallet.sol
52 
53 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
54 /// @author Stefan George - <stefan.george@consensys.net>
55 contract MultiSigWallet {
56 
57     /*
58      *  Events
59      */
60     event Confirmation(address indexed sender, uint indexed transactionId);
61     event Revocation(address indexed sender, uint indexed transactionId);
62     event Submission(uint indexed transactionId);
63     event Execution(uint indexed transactionId);
64     event ExecutionFailure(uint indexed transactionId);
65     event Deposit(address indexed sender, uint value);
66     event OwnerAddition(address indexed owner);
67     event OwnerRemoval(address indexed owner);
68     event RequirementChange(uint required);
69 
70     /*
71      *  Constants
72      */
73     uint constant public MAX_OWNER_COUNT = 50;
74 
75     /*
76      *  Storage
77      */
78     mapping (uint => Transaction) public transactions;
79     mapping (uint => mapping (address => bool)) public confirmations;
80     mapping (address => bool) public isOwner;
81     address[] public owners;
82     uint public required;
83     uint public transactionCount;
84 
85     struct Transaction {
86         address destination;
87         uint value;
88         bytes data;
89         bool executed;
90     }
91 
92     /*
93      *  Modifiers
94      */
95     modifier onlyWallet() {
96         if (msg.sender != address(this))
97             throw;
98         _;
99     }
100 
101     modifier ownerDoesNotExist(address owner) {
102         if (isOwner[owner])
103             throw;
104         _;
105     }
106 
107     modifier ownerExists(address owner) {
108         if (!isOwner[owner])
109             throw;
110         _;
111     }
112 
113     modifier transactionExists(uint transactionId) {
114         if (transactions[transactionId].destination == 0)
115             throw;
116         _;
117     }
118 
119     modifier confirmed(uint transactionId, address owner) {
120         if (!confirmations[transactionId][owner])
121             throw;
122         _;
123     }
124 
125     modifier notConfirmed(uint transactionId, address owner) {
126         if (confirmations[transactionId][owner])
127             throw;
128         _;
129     }
130 
131     modifier notExecuted(uint transactionId) {
132         if (transactions[transactionId].executed)
133             throw;
134         _;
135     }
136 
137     modifier notNull(address _address) {
138         if (_address == 0)
139             throw;
140         _;
141     }
142 
143     modifier validRequirement(uint ownerCount, uint _required) {
144         if (   ownerCount > MAX_OWNER_COUNT
145             || _required > ownerCount
146             || _required == 0
147             || ownerCount == 0)
148             throw;
149         _;
150     }
151 
152     /// @dev Fallback function allows to deposit ether.
153     function()
154         payable
155     {
156         if (msg.value > 0)
157             Deposit(msg.sender, msg.value);
158     }
159 
160     /*
161      * Public functions
162      */
163     /// @dev Contract constructor sets initial owners and required number of confirmations.
164     /// @param _owners List of initial owners.
165     /// @param _required Number of required confirmations.
166     function MultiSigWallet(address[] _owners, uint _required)
167         public
168         validRequirement(_owners.length, _required)
169     {
170         for (uint i=0; i<_owners.length; i++) {
171             if (isOwner[_owners[i]] || _owners[i] == 0)
172                 throw;
173             isOwner[_owners[i]] = true;
174         }
175         owners = _owners;
176         required = _required;
177     }
178 
179     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
180     /// @param owner Address of new owner.
181     function addOwner(address owner)
182         public
183         onlyWallet
184         ownerDoesNotExist(owner)
185         notNull(owner)
186         validRequirement(owners.length + 1, required)
187     {
188         isOwner[owner] = true;
189         owners.push(owner);
190         OwnerAddition(owner);
191     }
192 
193     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
194     /// @param owner Address of owner.
195     function removeOwner(address owner)
196         public
197         onlyWallet
198         ownerExists(owner)
199     {
200         isOwner[owner] = false;
201         for (uint i=0; i<owners.length - 1; i++)
202             if (owners[i] == owner) {
203                 owners[i] = owners[owners.length - 1];
204                 break;
205             }
206         owners.length -= 1;
207         if (required > owners.length)
208             changeRequirement(owners.length);
209         OwnerRemoval(owner);
210     }
211 
212     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
213     /// @param owner Address of owner to be replaced.
214     /// @param newOwner Address of new owner.
215     function replaceOwner(address owner, address newOwner)
216         public
217         onlyWallet
218         ownerExists(owner)
219         ownerDoesNotExist(newOwner)
220     {
221         for (uint i=0; i<owners.length; i++)
222             if (owners[i] == owner) {
223                 owners[i] = newOwner;
224                 break;
225             }
226         isOwner[owner] = false;
227         isOwner[newOwner] = true;
228         OwnerRemoval(owner);
229         OwnerAddition(newOwner);
230     }
231 
232     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
233     /// @param _required Number of required confirmations.
234     function changeRequirement(uint _required)
235         public
236         onlyWallet
237         validRequirement(owners.length, _required)
238     {
239         required = _required;
240         RequirementChange(_required);
241     }
242 
243     /// @dev Allows an owner to submit and confirm a transaction.
244     /// @param destination Transaction target address.
245     /// @param value Transaction ether value.
246     /// @param data Transaction data payload.
247     /// @return Returns transaction ID.
248     function submitTransaction(address destination, uint value, bytes data)
249         public
250         returns (uint transactionId)
251     {
252         transactionId = addTransaction(destination, value, data);
253         confirmTransaction(transactionId);
254     }
255 
256     /// @dev Allows an owner to confirm a transaction.
257     /// @param transactionId Transaction ID.
258     function confirmTransaction(uint transactionId)
259         public
260         ownerExists(msg.sender)
261         transactionExists(transactionId)
262         notConfirmed(transactionId, msg.sender)
263     {
264         confirmations[transactionId][msg.sender] = true;
265         Confirmation(msg.sender, transactionId);
266         executeTransaction(transactionId);
267     }
268 
269     /// @dev Allows an owner to revoke a confirmation for a transaction.
270     /// @param transactionId Transaction ID.
271     function revokeConfirmation(uint transactionId)
272         public
273         ownerExists(msg.sender)
274         confirmed(transactionId, msg.sender)
275         notExecuted(transactionId)
276     {
277         confirmations[transactionId][msg.sender] = false;
278         Revocation(msg.sender, transactionId);
279     }
280 
281     /// @dev Allows anyone to execute a confirmed transaction.
282     /// @param transactionId Transaction ID.
283     function executeTransaction(uint transactionId)
284         public
285         ownerExists(msg.sender)
286         confirmed(transactionId, msg.sender)
287         notExecuted(transactionId)
288     {
289         if (isConfirmed(transactionId)) {
290             Transaction tx = transactions[transactionId];
291             tx.executed = true;
292             if (tx.destination.call.value(tx.value)(tx.data))
293                 Execution(transactionId);
294             else {
295                 ExecutionFailure(transactionId);
296                 tx.executed = false;
297             }
298         }
299     }
300 
301     /// @dev Returns the confirmation status of a transaction.
302     /// @param transactionId Transaction ID.
303     /// @return Confirmation status.
304     function isConfirmed(uint transactionId)
305         public
306         constant
307         returns (bool)
308     {
309         uint count = 0;
310         for (uint i=0; i<owners.length; i++) {
311             if (confirmations[transactionId][owners[i]])
312                 count += 1;
313             if (count == required)
314                 return true;
315         }
316     }
317 
318     /*
319      * Internal functions
320      */
321     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
322     /// @param destination Transaction target address.
323     /// @param value Transaction ether value.
324     /// @param data Transaction data payload.
325     /// @return Returns transaction ID.
326     function addTransaction(address destination, uint value, bytes data)
327         internal
328         notNull(destination)
329         returns (uint transactionId)
330     {
331         transactionId = transactionCount;
332         transactions[transactionId] = Transaction({
333             destination: destination,
334             value: value,
335             data: data,
336             executed: false
337         });
338         transactionCount += 1;
339         Submission(transactionId);
340     }
341 
342     /*
343      * Web3 call functions
344      */
345     /// @dev Returns number of confirmations of a transaction.
346     /// @param transactionId Transaction ID.
347     /// @return Number of confirmations.
348     function getConfirmationCount(uint transactionId)
349         public
350         constant
351         returns (uint count)
352     {
353         for (uint i=0; i<owners.length; i++)
354             if (confirmations[transactionId][owners[i]])
355                 count += 1;
356     }
357 
358     /// @dev Returns total number of transactions after filers are applied.
359     /// @param pending Include pending transactions.
360     /// @param executed Include executed transactions.
361     /// @return Total number of transactions after filters are applied.
362     function getTransactionCount(bool pending, bool executed)
363         public
364         constant
365         returns (uint count)
366     {
367         for (uint i=0; i<transactionCount; i++)
368             if (   pending && !transactions[i].executed
369                 || executed && transactions[i].executed)
370                 count += 1;
371     }
372 
373     /// @dev Returns list of owners.
374     /// @return List of owner addresses.
375     function getOwners()
376         public
377         constant
378         returns (address[])
379     {
380         return owners;
381     }
382 
383     /// @dev Returns array with owner addresses, which confirmed transaction.
384     /// @param transactionId Transaction ID.
385     /// @return Returns array of owner addresses.
386     function getConfirmations(uint transactionId)
387         public
388         constant
389         returns (address[] _confirmations)
390     {
391         address[] memory confirmationsTemp = new address[](owners.length);
392         uint count = 0;
393         uint i;
394         for (i=0; i<owners.length; i++)
395             if (confirmations[transactionId][owners[i]]) {
396                 confirmationsTemp[count] = owners[i];
397                 count += 1;
398             }
399         _confirmations = new address[](count);
400         for (i=0; i<count; i++)
401             _confirmations[i] = confirmationsTemp[i];
402     }
403 
404     /// @dev Returns list of transaction IDs in defined range.
405     /// @param from Index start position of transaction array.
406     /// @param to Index end position of transaction array.
407     /// @param pending Include pending transactions.
408     /// @param executed Include executed transactions.
409     /// @return Returns array of transaction IDs.
410     function getTransactionIds(uint from, uint to, bool pending, bool executed)
411         public
412         constant
413         returns (uint[] _transactionIds)
414     {
415         uint[] memory transactionIdsTemp = new uint[](transactionCount);
416         uint count = 0;
417         uint i;
418         for (i=0; i<transactionCount; i++)
419             if (   pending && !transactions[i].executed
420                 || executed && transactions[i].executed)
421             {
422                 transactionIdsTemp[count] = i;
423                 count += 1;
424             }
425         _transactionIds = new uint[](to - from);
426         for (i=from; i<to; i++)
427             _transactionIds[i - from] = transactionIdsTemp[i];
428     }
429 }