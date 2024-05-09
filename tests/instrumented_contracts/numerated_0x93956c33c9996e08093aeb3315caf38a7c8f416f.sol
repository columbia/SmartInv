1 pragma solidity "0.4.25";
2 /**
3  * Originally from https://github.com/ConsenSys/MultiSigWallet
4  */
5 
6 
7 
8 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
9 /// @author Stefan George - <stefan.george@consensys.net>
10 contract MultiSigWallet {
11 
12     uint constant public MAX_OWNER_COUNT = 50;
13 
14     event Confirmation(address indexed sender, uint indexed transactionId);
15     event Revocation(address indexed sender, uint indexed transactionId);
16     event Submission(uint indexed transactionId);
17     event Execution(uint indexed transactionId);
18     event ExecutionFailure(uint indexed transactionId);
19     event Deposit(address indexed sender, uint value);
20     event OwnerAddition(address indexed owner);
21     event OwnerRemoval(address indexed owner);
22     event RequirementChange(uint required);
23 
24     mapping (uint => Transaction) public transactions;
25     mapping (uint => mapping (address => bool)) public confirmations;
26     mapping (address => bool) public isOwner;
27     address[] public owners;
28     uint public required;
29     uint public transactionCount;
30 
31     struct Transaction {
32         address destination;
33         uint value;
34         bytes data;
35         bool executed;
36     }
37 
38     modifier onlyWallet() {
39         if (msg.sender != address(this))
40             throw;
41         _;
42     }
43 
44     modifier ownerDoesNotExist(address owner) {
45         if (isOwner[owner])
46             throw;
47         _;
48     }
49 
50     modifier ownerExists(address owner) {
51         if (!isOwner[owner])
52             throw;
53         _;
54     }
55 
56     modifier transactionExists(uint transactionId) {
57         if (transactions[transactionId].destination == 0)
58             throw;
59         _;
60     }
61 
62     modifier confirmed(uint transactionId, address owner) {
63         if (!confirmations[transactionId][owner])
64             throw;
65         _;
66     }
67 
68     modifier notConfirmed(uint transactionId, address owner) {
69         if (confirmations[transactionId][owner])
70             throw;
71         _;
72     }
73 
74     modifier notExecuted(uint transactionId) {
75         if (transactions[transactionId].executed)
76             throw;
77         _;
78     }
79 
80     modifier notNull(address _address) {
81         if (_address == 0)
82             throw;
83         _;
84     }
85 
86     modifier validRequirement(uint ownerCount, uint _required) {
87         if (   ownerCount > MAX_OWNER_COUNT
88             || _required > ownerCount
89             || _required == 0
90             || ownerCount == 0)
91             throw;
92         _;
93     }
94 
95     /// @dev Fallback function allows to deposit ether.
96     function()
97         payable
98     {
99         if (msg.value > 0)
100             Deposit(msg.sender, msg.value);
101     }
102 
103     /*
104      * Public functions
105      */
106     /// @dev Contract constructor sets initial owners and required number of confirmations.
107     /// @param _owners List of initial owners.
108     /// @param _required Number of required confirmations.
109     function MultiSigWallet(address[] _owners, uint _required)
110         public
111         validRequirement(_owners.length, _required)
112     {
113         for (uint i=0; i<_owners.length; i++) {
114             if (isOwner[_owners[i]] || _owners[i] == 0)
115                 throw;
116             isOwner[_owners[i]] = true;
117         }
118         owners = _owners;
119         required = _required;
120     }
121 
122     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
123     /// @param owner Address of new owner.
124     function addOwner(address owner)
125         public
126         onlyWallet
127         ownerDoesNotExist(owner)
128         notNull(owner)
129         validRequirement(owners.length + 1, required)
130     {
131         isOwner[owner] = true;
132         owners.push(owner);
133         OwnerAddition(owner);
134     }
135 
136     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
137     /// @param owner Address of owner.
138     function removeOwner(address owner)
139         public
140         onlyWallet
141         ownerExists(owner)
142     {
143         isOwner[owner] = false;
144         for (uint i=0; i<owners.length - 1; i++)
145             if (owners[i] == owner) {
146                 owners[i] = owners[owners.length - 1];
147                 break;
148             }
149         owners.length -= 1;
150         if (required > owners.length)
151             changeRequirement(owners.length);
152         OwnerRemoval(owner);
153     }
154 
155     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
156     /// @param owner Address of owner to be replaced.
157     /// @param owner Address of new owner.
158     function replaceOwner(address owner, address newOwner)
159         public
160         onlyWallet
161         ownerExists(owner)
162         ownerDoesNotExist(newOwner)
163     {
164         for (uint i=0; i<owners.length; i++)
165             if (owners[i] == owner) {
166                 owners[i] = newOwner;
167                 break;
168             }
169         isOwner[owner] = false;
170         isOwner[newOwner] = true;
171         OwnerRemoval(owner);
172         OwnerAddition(newOwner);
173     }
174 
175     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
176     /// @param _required Number of required confirmations.
177     function changeRequirement(uint _required)
178         public
179         onlyWallet
180         validRequirement(owners.length, _required)
181     {
182         required = _required;
183         RequirementChange(_required);
184     }
185 
186     /// @dev Allows an owner to submit and confirm a transaction.
187     /// @param destination Transaction target address.
188     /// @param value Transaction ether value.
189     /// @param data Transaction data payload.
190     /// @return Returns transaction ID.
191     function submitTransaction(address destination, uint value, bytes data)
192         public
193         returns (uint transactionId)
194     {
195         transactionId = addTransaction(destination, value, data);
196         confirmTransaction(transactionId);
197     }
198 
199     /// @dev Allows an owner to confirm a transaction.
200     /// @param transactionId Transaction ID.
201     function confirmTransaction(uint transactionId)
202         public
203         ownerExists(msg.sender)
204         transactionExists(transactionId)
205         notConfirmed(transactionId, msg.sender)
206     {
207         confirmations[transactionId][msg.sender] = true;
208         Confirmation(msg.sender, transactionId);
209         executeTransaction(transactionId);
210     }
211 
212     /// @dev Allows an owner to revoke a confirmation for a transaction.
213     /// @param transactionId Transaction ID.
214     function revokeConfirmation(uint transactionId)
215         public
216         ownerExists(msg.sender)
217         confirmed(transactionId, msg.sender)
218         notExecuted(transactionId)
219     {
220         confirmations[transactionId][msg.sender] = false;
221         Revocation(msg.sender, transactionId);
222     }
223 
224     /// @dev Allows anyone to execute a confirmed transaction.
225     /// @param transactionId Transaction ID.
226     function executeTransaction(uint transactionId)
227         public
228         notExecuted(transactionId)
229     {
230         if (isConfirmed(transactionId)) {
231             Transaction tx = transactions[transactionId];
232             tx.executed = true;
233             if (tx.destination.call.value(tx.value)(tx.data))
234                 Execution(transactionId);
235             else {
236                 ExecutionFailure(transactionId);
237                 tx.executed = false;
238             }
239         }
240     }
241 
242     /// @dev Returns the confirmation status of a transaction.
243     /// @param transactionId Transaction ID.
244     /// @return Confirmation status.
245     function isConfirmed(uint transactionId)
246         public
247         constant
248         returns (bool)
249     {
250         uint count = 0;
251         for (uint i=0; i<owners.length; i++) {
252             if (confirmations[transactionId][owners[i]])
253                 count += 1;
254             if (count == required)
255                 return true;
256         }
257     }
258 
259     /*
260      * Internal functions
261      */
262     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
263     /// @param destination Transaction target address.
264     /// @param value Transaction ether value.
265     /// @param data Transaction data payload.
266     /// @return Returns transaction ID.
267     function addTransaction(address destination, uint value, bytes data)
268         internal
269         notNull(destination)
270         returns (uint transactionId)
271     {
272         transactionId = transactionCount;
273         transactions[transactionId] = Transaction({
274             destination: destination,
275             value: value,
276             data: data,
277             executed: false
278         });
279         transactionCount += 1;
280         Submission(transactionId);
281     }
282 
283     /*
284      * Web3 call functions
285      */
286     /// @dev Returns number of confirmations of a transaction.
287     /// @param transactionId Transaction ID.
288     /// @return Number of confirmations.
289     function getConfirmationCount(uint transactionId)
290         public
291         constant
292         returns (uint count)
293     {
294         for (uint i=0; i<owners.length; i++)
295             if (confirmations[transactionId][owners[i]])
296                 count += 1;
297     }
298 
299     /// @dev Returns total number of transactions after filers are applied.
300     /// @param pending Include pending transactions.
301     /// @param executed Include executed transactions.
302     /// @return Total number of transactions after filters are applied.
303     function getTransactionCount(bool pending, bool executed)
304         public
305         constant
306         returns (uint count)
307     {
308         for (uint i=0; i<transactionCount; i++)
309             if (   pending && !transactions[i].executed
310                 || executed && transactions[i].executed)
311                 count += 1;
312     }
313 
314     /// @dev Returns list of owners.
315     /// @return List of owner addresses.
316     function getOwners()
317         public
318         constant
319         returns (address[])
320     {
321         return owners;
322     }
323 
324     /// @dev Returns array with owner addresses, which confirmed transaction.
325     /// @param transactionId Transaction ID.
326     /// @return Returns array of owner addresses.
327     function getConfirmations(uint transactionId)
328         public
329         constant
330         returns (address[] _confirmations)
331     {
332         address[] memory confirmationsTemp = new address[](owners.length);
333         uint count = 0;
334         uint i;
335         for (i=0; i<owners.length; i++)
336             if (confirmations[transactionId][owners[i]]) {
337                 confirmationsTemp[count] = owners[i];
338                 count += 1;
339             }
340         _confirmations = new address[](count);
341         for (i=0; i<count; i++)
342             _confirmations[i] = confirmationsTemp[i];
343     }
344 
345     /// @dev Returns list of transaction IDs in defined range.
346     /// @param from Index start position of transaction array.
347     /// @param to Index end position of transaction array.
348     /// @param pending Include pending transactions.
349     /// @param executed Include executed transactions.
350     /// @return Returns array of transaction IDs.
351     function getTransactionIds(uint from, uint to, bool pending, bool executed)
352         public
353         constant
354         returns (uint[] _transactionIds)
355     {
356         uint[] memory transactionIdsTemp = new uint[](transactionCount);
357         uint count = 0;
358         uint i;
359         for (i=0; i<transactionCount; i++)
360             if (   pending && !transactions[i].executed
361                 || executed && transactions[i].executed)
362             {
363                 transactionIdsTemp[count] = i;
364                 count += 1;
365             }
366         _transactionIds = new uint[](to - from);
367         for (i=from; i<to; i++)
368             _transactionIds[i - from] = transactionIdsTemp[i];
369     }
370 }