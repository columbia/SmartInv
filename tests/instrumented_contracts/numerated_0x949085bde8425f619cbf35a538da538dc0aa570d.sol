1 pragma solidity ^0.4.13;
2 
3 
4 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
5 /// @author Stefan George - <stefan.george@consensys.net>
6 contract MultiSigWallet {
7 
8     uint constant public MAX_OWNER_COUNT = 50;
9 
10     event Confirmation(address indexed sender, uint indexed transactionId);
11     event Revocation(address indexed sender, uint indexed transactionId);
12     event Submission(uint indexed transactionId);
13     event Execution(uint indexed transactionId);
14     event ExecutionFailure(uint indexed transactionId);
15     event Deposit(address indexed sender, uint value);
16     event OwnerAddition(address indexed owner);
17     event OwnerRemoval(address indexed owner);
18     event RequirementChange(uint required);
19 
20     mapping (uint => Transaction) public transactions;
21     mapping (uint => mapping (address => bool)) public confirmations;
22     mapping (address => bool) public isOwner;
23     address[] public owners;
24     uint public required;
25     uint public transactionCount;
26 
27     struct Transaction {
28         address destination;
29         uint value;
30         bytes data;
31         bool executed;
32     }
33 
34     modifier onlyWallet() {
35         if (msg.sender != address(this))
36             revert();
37         _;
38     }
39 
40     modifier ownerDoesNotExist(address owner) {
41         if (isOwner[owner])
42             revert();
43         _;
44     }
45 
46     modifier ownerExists(address owner) {
47         if (!isOwner[owner])
48             revert();
49         _;
50     }
51 
52     modifier transactionExists(uint transactionId) {
53         if (transactions[transactionId].destination == 0)
54             revert();
55         _;
56     }
57 
58     modifier confirmed(uint transactionId, address owner) {
59         if (!confirmations[transactionId][owner])
60             revert();
61         _;
62     }
63 
64     modifier notConfirmed(uint transactionId, address owner) {
65         if (confirmations[transactionId][owner])
66             revert();
67         _;
68     }
69 
70     modifier notExecuted(uint transactionId) {
71         if (transactions[transactionId].executed)
72             revert();
73         _;
74     }
75 
76     modifier notNull(address _address) {
77         if (_address == 0)
78             revert();
79         _;
80     }
81 
82     modifier validRequirement(uint ownerCount, uint _required) {
83         if (   ownerCount > MAX_OWNER_COUNT
84             || _required > ownerCount
85             || _required == 0
86             || ownerCount == 0)
87             revert();
88         _;
89     }
90 
91     modifier notValidAddress(address _address)
92     {
93         if(_address == 0x0)
94             revert();
95         _;
96     }
97 
98     /// @dev Fallback function allows to deposit ether.
99     function()
100         payable
101     {
102         if (msg.value > 0)
103             Deposit(msg.sender, msg.value);
104     }
105 
106     /*
107      * Public functions
108      */
109     /// @dev Contract constructor sets initial owners and required number of confirmations.
110     /// @param _owners List of initial owners.
111     /// @param _required Number of required confirmations.
112     function MultiSigWallet(address[] _owners, uint _required)
113         public
114         validRequirement(_owners.length, _required)
115     {
116         for (uint i=0; i<_owners.length; i++) {
117             if (isOwner[_owners[i]] || _owners[i] == 0)
118                 revert();
119             isOwner[_owners[i]] = true;
120         }
121         owners = _owners;
122         required = _required;
123     }
124 
125     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
126     /// @param owner Address of new owner.
127     function addOwner(address owner)
128         public
129         onlyWallet
130         ownerDoesNotExist(owner)
131         notNull(owner)
132         validRequirement(owners.length + 1, required)
133     {
134         isOwner[owner] = true;
135         owners.push(owner);
136         OwnerAddition(owner);
137     }
138 
139     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
140     /// @param owner Address of owner.
141     function removeOwner(address owner)
142         public
143         onlyWallet
144         ownerExists(owner)
145     {
146         isOwner[owner] = false;
147         for (uint i=0; i<owners.length - 1; i++)
148             if (owners[i] == owner) {
149                 owners[i] = owners[owners.length - 1];
150                 break;
151             }
152         owners.length -= 1;
153         if (required > owners.length)
154             changeRequirement(owners.length);
155         OwnerRemoval(owner);
156     }
157 
158     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
159     /// @param owner Address of owner to be replaced.
160     /// @param owner Address of new owner.
161     function replaceOwner(address owner, address newOwner)
162         public
163         onlyWallet
164         ownerExists(owner)
165         ownerDoesNotExist(newOwner)
166     {
167         for (uint i=0; i<owners.length; i++)
168             if (owners[i] == owner) {
169                 owners[i] = newOwner;
170                 break;
171             }
172         isOwner[owner] = false;
173         isOwner[newOwner] = true;
174         OwnerRemoval(owner);
175         OwnerAddition(newOwner);
176     }
177 
178     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
179     /// @param _required Number of required confirmations.
180     function changeRequirement(uint _required)
181         public
182         onlyWallet
183         validRequirement(owners.length, _required)
184     {
185         required = _required;
186         RequirementChange(_required);
187     }
188 
189     /// @dev Allows an owner to submit and confirm a transaction.
190     /// @param destination Transaction target address.
191     /// @param value Transaction ether value.
192     /// @param data Transaction data payload.
193     /// @return Returns transaction ID.
194     function submitTransaction(address destination, uint value, bytes data)
195         public
196         returns (uint transactionId)
197     {
198         transactionId = addTransaction(destination, value, data);
199         confirmTransaction(transactionId);
200     }
201 
202     /// @dev Allows an owner to confirm a transaction.
203     /// @param transactionId Transaction ID.
204     function confirmTransaction(uint transactionId)
205         public
206         ownerExists(msg.sender)
207         transactionExists(transactionId)
208         notConfirmed(transactionId, msg.sender)
209     {
210         confirmations[transactionId][msg.sender] = true;
211         Confirmation(msg.sender, transactionId);
212         executeTransaction(transactionId);
213     }
214 
215     /// @dev Allows an owner to revoke a confirmation for a transaction.
216     /// @param transactionId Transaction ID.
217     function revokeConfirmation(uint transactionId)
218         public
219         ownerExists(msg.sender)
220         confirmed(transactionId, msg.sender)
221         notExecuted(transactionId)
222     {
223         confirmations[transactionId][msg.sender] = false;
224         Revocation(msg.sender, transactionId);
225     }
226 
227     /// @dev Allows anyone to execute a confirmed transaction.
228     /// @param transactionId Transaction ID.
229     function executeTransaction(uint transactionId)
230         public
231         notExecuted(transactionId)
232     {
233         if (isConfirmed(transactionId)) {
234             Transaction tx = transactions[transactionId];
235             tx.executed = true;
236             if (tx.destination.call.value(tx.value)(tx.data))
237                 Execution(transactionId);
238             else {
239                 ExecutionFailure(transactionId);
240                 tx.executed = false;
241             }
242         }
243     }
244 
245     /// @dev Returns the confirmation status of a transaction.
246     /// @param transactionId Transaction ID.
247     /// @return Confirmation status.
248     function isConfirmed(uint transactionId)
249         public
250         constant
251         returns (bool)
252     {
253         uint count = 0;
254         for (uint i=0; i<owners.length; i++) {
255             if (confirmations[transactionId][owners[i]])
256                 count += 1;
257             if (count == required)
258                 return true;
259         }
260     }
261 
262     /*
263      * Internal functions
264      */
265     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
266     /// @param destination Transaction target address.
267     /// @param value Transaction ether value.
268     /// @param data Transaction data payload.
269     /// @return Returns transaction ID.
270     function addTransaction(address destination, uint value, bytes data)
271         internal
272         notNull(destination)
273         returns (uint transactionId)
274     {
275         transactionId = transactionCount;
276         transactions[transactionId] = Transaction({
277             destination: destination,
278             value: value,
279             data: data,
280             executed: false
281         });
282         transactionCount += 1;
283         Submission(transactionId);
284     }
285 
286     /*
287      * Web3 call functions
288      */
289     /// @dev Returns number of confirmations of a transaction.
290     /// @param transactionId Transaction ID.
291     /// @return Number of confirmations.
292     function getConfirmationCount(uint transactionId)
293         public
294         constant
295         returns (uint count)
296     {
297         for (uint i=0; i<owners.length; i++)
298             if (confirmations[transactionId][owners[i]])
299                 count += 1;
300     }
301 
302     /// @dev Returns total number of transactions after filers are applied.
303     /// @param pending Include pending transactions.
304     /// @param executed Include executed transactions.
305     /// @return Total number of transactions after filters are applied.
306     function getTransactionCount(bool pending, bool executed)
307         public
308         constant
309         returns (uint count)
310     {
311         for (uint i=0; i<transactionCount; i++)
312             if (   pending && !transactions[i].executed
313                 || executed && transactions[i].executed)
314                 count += 1;
315     }
316 
317     /// @dev Returns list of owners.
318     /// @return List of owner addresses.
319     function getOwners()
320         public
321         constant
322         returns (address[])
323     {
324         return owners;
325     }
326 
327     /// @dev Returns array with owner addresses, which confirmed transaction.
328     /// @param transactionId Transaction ID.
329     /// @return Returns array of owner addresses.
330     function getConfirmations(uint transactionId)
331         public
332         constant
333         returns (address[] _confirmations)
334     {
335         address[] memory confirmationsTemp = new address[](owners.length);
336         uint count = 0;
337         uint i;
338         for (i=0; i<owners.length; i++)
339             if (confirmations[transactionId][owners[i]]) {
340                 confirmationsTemp[count] = owners[i];
341                 count += 1;
342             }
343         _confirmations = new address[](count);
344         for (i=0; i<count; i++)
345             _confirmations[i] = confirmationsTemp[i];
346     }
347 
348     /// @dev Returns list of transaction IDs in defined range.
349     /// @param from Index start position of transaction array.
350     /// @param to Index end position of transaction array.
351     /// @param pending Include pending transactions.
352     /// @param executed Include executed transactions.
353     /// @return Returns array of transaction IDs.
354     function getTransactionIds(uint from, uint to, bool pending, bool executed)
355         public
356         constant
357         returns (uint[] _transactionIds)
358     {
359         uint[] memory transactionIdsTemp = new uint[](transactionCount);
360         uint count = 0;
361         uint i;
362         for (i=0; i<transactionCount; i++)
363             if (   pending && !transactions[i].executed
364                 || executed && transactions[i].executed)
365             {
366                 transactionIdsTemp[count] = i;
367                 count += 1;
368             }
369         _transactionIds = new uint[](to - from);
370         for (i=from; i<to; i++)
371             _transactionIds[i - from] = transactionIdsTemp[i];
372     }
373 }