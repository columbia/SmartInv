1 pragma solidity ^0.4.11;
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
91     /// @dev Fallback function allows to deposit ether.
92     function()
93         payable
94         public
95     {
96         if (msg.value > 0)
97             Deposit(msg.sender, msg.value);
98     }
99 
100     /*
101      * Public functions
102      */
103     /// @dev Contract constructor sets initial owners and required number of confirmations.
104     /// @param _owners List of initial owners.
105     /// @param _required Number of required confirmations.
106     function MultiSigWallet(address[] _owners, uint _required)
107         public
108         validRequirement(_owners.length, _required)
109     {
110         for (uint i=0; i<_owners.length; i++) {
111             if (isOwner[_owners[i]] || _owners[i] == 0)
112                 revert();
113             isOwner[_owners[i]] = true;
114         }
115         owners = _owners;
116         required = _required;
117     }
118 
119     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
120     /// @param owner Address of new owner.
121     function addOwner(address owner)
122         public
123         onlyWallet
124         ownerDoesNotExist(owner)
125         notNull(owner)
126         validRequirement(owners.length + 1, required)
127     {
128         isOwner[owner] = true;
129         owners.push(owner);
130         OwnerAddition(owner);
131     }
132 
133     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
134     /// @param owner Address of owner.
135     function removeOwner(address owner)
136         public
137         onlyWallet
138         ownerExists(owner)
139     {
140         isOwner[owner] = false;
141         for (uint i=0; i<owners.length - 1; i++)
142             if (owners[i] == owner) {
143                 owners[i] = owners[owners.length - 1];
144                 break;
145             }
146         owners.length -= 1;
147         if (required > owners.length)
148             changeRequirement(owners.length);
149         OwnerRemoval(owner);
150     }
151 
152     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
153     /// @param owner Address of owner to be replaced.
154     /// @param owner Address of new owner.
155     function replaceOwner(address owner, address newOwner)
156         public
157         onlyWallet
158         ownerExists(owner)
159         ownerDoesNotExist(newOwner)
160     {
161         for (uint i=0; i<owners.length; i++)
162             if (owners[i] == owner) {
163                 owners[i] = newOwner;
164                 break;
165             }
166         isOwner[owner] = false;
167         isOwner[newOwner] = true;
168         OwnerRemoval(owner);
169         OwnerAddition(newOwner);
170     }
171 
172     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
173     /// @param _required Number of required confirmations.
174     function changeRequirement(uint _required)
175         public
176         onlyWallet
177         validRequirement(owners.length, _required)
178     {
179         required = _required;
180         RequirementChange(_required);
181     }
182 
183     /// @dev Allows an owner to submit and confirm a transaction.
184     /// @param destination Transaction target address.
185     /// @param value Transaction ether value.
186     /// @param data Transaction data payload.
187     /// @return Returns transaction ID.
188     function submitTransaction(address destination, uint value, bytes data)
189         public
190         returns (uint transactionId)
191     {
192         transactionId = addTransaction(destination, value, data);
193         confirmTransaction(transactionId);
194     }
195 
196     /// @dev Allows an owner to confirm a transaction.
197     /// @param transactionId Transaction ID.
198     function confirmTransaction(uint transactionId)
199         public
200         ownerExists(msg.sender)
201         transactionExists(transactionId)
202         notConfirmed(transactionId, msg.sender)
203     {
204         confirmations[transactionId][msg.sender] = true;
205         Confirmation(msg.sender, transactionId);
206         executeTransaction(transactionId);
207     }
208 
209     /// @dev Allows an owner to revoke a confirmation for a transaction.
210     /// @param transactionId Transaction ID.
211     function revokeConfirmation(uint transactionId)
212         public
213         ownerExists(msg.sender)
214         confirmed(transactionId, msg.sender)
215         notExecuted(transactionId)
216     {
217         confirmations[transactionId][msg.sender] = false;
218         Revocation(msg.sender, transactionId);
219     }
220 
221     /// @dev Allows anyone to execute a confirmed transaction.
222     /// @param transactionId Transaction ID.
223     function executeTransaction(uint transactionId)
224         public
225         notExecuted(transactionId)
226     {
227         if (isConfirmed(transactionId)) {
228             Transaction tx = transactions[transactionId];
229             tx.executed = true;
230             if (tx.destination.call.value(tx.value)(tx.data))
231                 Execution(transactionId);
232             else {
233                 ExecutionFailure(transactionId);
234                 tx.executed = false;
235             }
236         }
237     }
238 
239     /// @dev Returns the confirmation status of a transaction.
240     /// @param transactionId Transaction ID.
241     /// @return Confirmation status.
242     function isConfirmed(uint transactionId)
243         public
244         constant
245         returns (bool)
246     {
247         uint count = 0;
248         for (uint i=0; i<owners.length; i++) {
249             if (confirmations[transactionId][owners[i]])
250                 count += 1;
251             if (count == required)
252                 return true;
253         }
254     }
255 
256     /*
257      * Internal functions
258      */
259     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
260     /// @param destination Transaction target address.
261     /// @param value Transaction ether value.
262     /// @param data Transaction data payload.
263     /// @return Returns transaction ID.
264     function addTransaction(address destination, uint value, bytes data)
265         internal
266         notNull(destination)
267         returns (uint transactionId)
268     {
269         transactionId = transactionCount;
270         transactions[transactionId] = Transaction({
271             destination: destination,
272             value: value,
273             data: data,
274             executed: false
275         });
276         transactionCount += 1;
277         Submission(transactionId);
278     }
279 
280     /*
281      * Web3 call functions
282      */
283     /// @dev Returns number of confirmations of a transaction.
284     /// @param transactionId Transaction ID.
285     /// @return Number of confirmations.
286     function getConfirmationCount(uint transactionId)
287         public
288         constant
289         returns (uint count)
290     {
291         for (uint i=0; i<owners.length; i++)
292             if (confirmations[transactionId][owners[i]])
293                 count += 1;
294     }
295 
296     /// @dev Returns total number of transactions after filers are applied.
297     /// @param pending Include pending transactions.
298     /// @param executed Include executed transactions.
299     /// @return Total number of transactions after filters are applied.
300     function getTransactionCount(bool pending, bool executed)
301         public
302         constant
303         returns (uint count)
304     {
305         for (uint i=0; i<transactionCount; i++)
306             if (   pending && !transactions[i].executed
307                 || executed && transactions[i].executed)
308                 count += 1;
309     }
310 
311     /// @dev Returns list of owners.
312     /// @return List of owner addresses.
313     function getOwners()
314         public
315         constant
316         returns (address[])
317     {
318         return owners;
319     }
320 
321     /// @dev Returns array with owner addresses, which confirmed transaction.
322     /// @param transactionId Transaction ID.
323     /// @return Returns array of owner addresses.
324     function getConfirmations(uint transactionId)
325         public
326         constant
327         returns (address[] _confirmations)
328     {
329         address[] memory confirmationsTemp = new address[](owners.length);
330         uint count = 0;
331         uint i;
332         for (i=0; i<owners.length; i++)
333             if (confirmations[transactionId][owners[i]]) {
334                 confirmationsTemp[count] = owners[i];
335                 count += 1;
336             }
337         _confirmations = new address[](count);
338         for (i=0; i<count; i++)
339             _confirmations[i] = confirmationsTemp[i];
340     }
341 
342     /// @dev Returns list of transaction IDs in defined range.
343     /// @param from Index start position of transaction array.
344     /// @param to Index end position of transaction array.
345     /// @param pending Include pending transactions.
346     /// @param executed Include executed transactions.
347     /// @return Returns array of transaction IDs.
348     function getTransactionIds(uint from, uint to, bool pending, bool executed)
349         public
350         constant
351         returns (uint[] _transactionIds)
352     {
353         uint[] memory transactionIdsTemp = new uint[](transactionCount);
354         uint count = 0;
355         uint i;
356         for (i=0; i<transactionCount; i++)
357             if (   pending && !transactions[i].executed
358                 || executed && transactions[i].executed)
359             {
360                 transactionIdsTemp[count] = i;
361                 count += 1;
362             }
363         _transactionIds = new uint[](to - from);
364         for (i=from; i<to; i++)
365             _transactionIds[i - from] = transactionIdsTemp[i];
366     }
367 }