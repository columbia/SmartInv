1 pragma solidity 0.4.18;
2 
3 /// Array.io founder wallet.
4 
5 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
6 /// @author Stefan George - <stefan.george@consensys.net>
7 contract MultiSigWallet {
8 
9     /*
10      *  Events
11      */
12     event Confirmation(address indexed sender, uint indexed transactionId);
13     event Revocation(address indexed sender, uint indexed transactionId);
14     event Submission(uint indexed transactionId);
15     event Execution(uint indexed transactionId);
16 
17     event ExecutionFailure(uint indexed transactionId);
18     event Deposit(address indexed sender, uint value);
19     event OwnerAddition(address indexed owner);
20     event OwnerRemoval(address indexed owner);
21     event RequirementChange(uint required);
22 
23     /*
24      *  Constants
25      */
26     uint constant public MAX_OWNER_COUNT = 10;
27 
28     /*
29      *  Storage
30      */
31     uint public required = 1;
32 
33     mapping (uint => Transaction) public transactions;
34     mapping (uint => mapping (address => bool)) public confirmations;
35     mapping (address => bool) public isOwner;
36     address[] public owners;
37     uint public transactionCount;
38 
39     struct Transaction {
40         address destination;
41         uint value;
42         bytes data;
43         bool executed;
44     }
45 
46     /*
47      *  Modifiers
48      */
49     modifier onlyWallet() {
50         if (msg.sender != address(this))
51             throw;
52         _;
53     }
54 
55     modifier ownerDoesNotExist(address owner) {
56         if (isOwner[owner])
57             throw;
58         _;
59     }
60 
61     modifier ownerExists(address owner) {
62         if (!isOwner[owner])
63             throw;
64         _;
65     }
66 
67     modifier transactionExists(uint transactionId) {
68         if (transactions[transactionId].destination == 0)
69             throw;
70         _;
71     }
72 
73     modifier confirmed(uint transactionId, address owner) {
74         if (!confirmations[transactionId][owner])
75             throw;
76         _;
77     }
78 
79     modifier notConfirmed(uint transactionId, address owner) {
80         if (confirmations[transactionId][owner])
81             throw;
82         _;
83     }
84 
85     modifier notExecuted(uint transactionId) {
86         if (transactions[transactionId].executed)
87             throw;
88         _;
89     }
90 
91     modifier notNull(address _address) {
92         if (_address == 0)
93             throw;
94         _;
95     }
96     
97     modifier validRequirement(uint ownerCount, uint _required) {
98         if (   ownerCount > MAX_OWNER_COUNT
99             || _required > ownerCount
100             || _required == 0
101             || ownerCount == 0)
102             throw;
103         _;
104     }
105     
106     /// @dev Fallback function allows to deposit ether.
107     function()
108         payable
109     {
110         if (msg.value > 0)
111             Deposit(msg.sender, msg.value);
112     }
113 
114     /*
115      * Public functions
116      */
117     /// @dev Contract constructor sets initial owners and required number of confirmations.
118 
119     function MultiSigWallet()
120         public
121     {
122         isOwner[0x160e529055D084add9634fE1c2059109c8CE044e] = true;
123         owners = [0x160e529055D084add9634fE1c2059109c8CE044e];
124 
125     }
126 
127     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
128     /// @param owner Address of new owner.
129     function addOwner(address owner)
130         public
131         onlyWallet
132         ownerDoesNotExist(owner)
133         notNull(owner)
134         validRequirement(owners.length + 1, required)
135     {
136         isOwner[owner] = true;
137         owners.push(owner);
138         OwnerAddition(owner);
139     }
140 
141     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
142     /// @param owner Address of owner.
143     function removeOwner(address owner)
144         public
145         onlyWallet
146         ownerExists(owner)
147     {
148         isOwner[owner] = false;
149         for (uint i=0; i<owners.length - 1; i++)
150             if (owners[i] == owner) {
151                 owners[i] = owners[owners.length - 1];
152                 break;
153             }
154         owners.length -= 1;
155         if (required > owners.length)
156             changeRequirement(owners.length);
157         OwnerRemoval(owner);
158     }
159 
160     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
161     /// @param owner Address of owner to be replaced.
162     /// @param newOwner Address of new owner.
163     function replaceOwner(address owner, address newOwner)
164         public
165         onlyWallet
166         ownerExists(owner)
167         ownerDoesNotExist(newOwner)
168     {
169         for (uint i=0; i<owners.length; i++)
170             if (owners[i] == owner) {
171                 owners[i] = newOwner;
172                 break;
173             }
174         isOwner[owner] = false;
175         isOwner[newOwner] = true;
176         OwnerRemoval(owner);
177         OwnerAddition(newOwner);
178     }
179 
180     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
181     /// @param _required Number of required confirmations.
182     function changeRequirement(uint _required)
183         public
184         onlyWallet
185         validRequirement(owners.length, _required)
186     {
187         required = _required;
188         RequirementChange(_required);
189     }
190 
191     /// @dev Allows an owner to submit and confirm a transaction.
192     /// @param destination Transaction target address.
193     /// @param value Transaction ether value.
194     /// @param data Transaction data payload.
195     /// @return Returns transaction ID.
196     function submitTransaction(address destination, uint value, bytes data)
197         public
198         returns (uint transactionId)
199     {
200         transactionId = addTransaction(destination, value, data);
201         confirmTransaction(transactionId);
202     }
203 
204     /// @dev Allows an owner to confirm a transaction.
205     /// @param transactionId Transaction ID.
206     function confirmTransaction(uint transactionId)
207         public
208         ownerExists(msg.sender)
209         transactionExists(transactionId)
210         notConfirmed(transactionId, msg.sender)
211     {
212         confirmations[transactionId][msg.sender] = true;
213         Confirmation(msg.sender, transactionId);
214         executeTransaction(transactionId);
215     }
216 
217     /// @dev Allows an owner to revoke a confirmation for a transaction.
218     /// @param transactionId Transaction ID.
219     function revokeConfirmation(uint transactionId)
220         public
221         ownerExists(msg.sender)
222         confirmed(transactionId, msg.sender)
223         notExecuted(transactionId)
224     {
225         confirmations[transactionId][msg.sender] = false;
226         Revocation(msg.sender, transactionId);
227     }
228 
229     /// @dev Allows anyone to execute a confirmed transaction.
230     /// @param transactionId Transaction ID.
231     function executeTransaction(uint transactionId)
232         public
233         ownerExists(msg.sender)
234         confirmed(transactionId, msg.sender)
235         notExecuted(transactionId)
236     {
237         if (isConfirmed(transactionId)) {
238             Transaction tx = transactions[transactionId];
239             tx.executed = true;
240             if (tx.destination.call.value(tx.value)(tx.data))
241                 Execution(transactionId);
242             else {
243                 ExecutionFailure(transactionId);
244                 tx.executed = false;
245             }
246         }
247     }
248 
249     /// @dev Returns the confirmation status of a transaction.
250     /// @param transactionId Transaction ID.
251     /// @return Confirmation status.
252     function isConfirmed(uint transactionId)
253         public
254         constant
255         returns (bool)
256     {
257         uint count = 0;
258         for (uint i=0; i<owners.length; i++) {
259             if (confirmations[transactionId][owners[i]])
260                 count += 1;
261             if (count == required)
262                 return true;
263         }
264     }
265 
266     /*
267      * Internal functions
268      */
269     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
270     /// @param destination Transaction target address.
271     /// @param value Transaction ether value.
272     /// @param data Transaction data payload.
273     /// @return Returns transaction ID.
274     function addTransaction(address destination, uint value, bytes data)
275         internal
276         notNull(destination)
277         returns (uint transactionId)
278     {
279         transactionId = transactionCount;
280         transactions[transactionId] = Transaction({
281             destination: destination,
282             value: value,
283             data: data,
284             executed: false
285         });
286         transactionCount += 1;
287         Submission(transactionId);
288     }
289 
290     /*
291      * Web3 call functions
292      */
293     /// @dev Returns number of confirmations of a transaction.
294     /// @param transactionId Transaction ID.
295     /// @return Number of confirmations.
296     function getConfirmationCount(uint transactionId)
297         public
298         constant
299         returns (uint count)
300     {
301         for (uint i=0; i<owners.length; i++)
302             if (confirmations[transactionId][owners[i]])
303                 count += 1;
304     }
305 
306     /// @dev Returns total number of transactions after filers are applied.
307     /// @param pending Include pending transactions.
308     /// @param executed Include executed transactions.
309     /// @return Total number of transactions after filters are applied.
310     function getTransactionCount(bool pending, bool executed)
311         public
312         constant
313         returns (uint count)
314     {
315         for (uint i=0; i<transactionCount; i++)
316             if (   pending && !transactions[i].executed
317                 || executed && transactions[i].executed)
318                 count += 1;
319     }
320 
321     /// @dev Returns list of owners.
322     /// @return List of owner addresses.
323     function getOwners()
324         public
325         constant
326         returns (address[])
327     {
328         return owners;
329     }
330 
331     /// @dev Returns array with owner addresses, which confirmed transaction.
332     /// @param transactionId Transaction ID.
333     /// @return Returns array of owner addresses.
334     function getConfirmations(uint transactionId)
335         public
336         constant
337         returns (address[] _confirmations)
338     {
339         address[] memory confirmationsTemp = new address[](owners.length);
340         uint count = 0;
341         uint i;
342         for (i=0; i<owners.length; i++)
343             if (confirmations[transactionId][owners[i]]) {
344                 confirmationsTemp[count] = owners[i];
345                 count += 1;
346             }
347         _confirmations = new address[](count);
348         for (i=0; i<count; i++)
349             _confirmations[i] = confirmationsTemp[i];
350     }
351 
352     /// @dev Returns list of transaction IDs in defined range.
353     /// @param from Index start position of transaction array.
354     /// @param to Index end position of transaction array.
355     /// @param pending Include pending transactions.
356     /// @param executed Include executed transactions.
357     /// @return Returns array of transaction IDs.
358     function getTransactionIds(uint from, uint to, bool pending, bool executed)
359         public
360         constant
361         returns (uint[] _transactionIds)
362     {
363         uint[] memory transactionIdsTemp = new uint[](transactionCount);
364         uint count = 0;
365         uint i;
366         for (i=0; i<transactionCount; i++)
367             if (   pending && !transactions[i].executed
368                 || executed && transactions[i].executed)
369             {
370                 transactionIdsTemp[count] = i;
371                 count += 1;
372             }
373         _transactionIds = new uint[](to - from);
374         for (i=from; i<to; i++)
375             _transactionIds[i - from] = transactionIdsTemp[i];
376     }
377 }