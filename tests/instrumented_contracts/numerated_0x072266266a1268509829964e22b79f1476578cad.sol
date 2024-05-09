1 pragma solidity ^0.4.18;
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
48            revert();
49         _;
50     }
51 
52     modifier ownerDoesNotExist(address owner) {
53         if (isOwner[owner])
54            revert();
55         _;
56     }
57 
58     modifier ownerExists(address owner) {
59         if (!isOwner[owner])
60            revert();
61         _;
62     }
63 
64     modifier transactionExists(uint transactionId) {
65         if (transactions[transactionId].destination == 0)
66            revert();
67         _;
68     }
69 
70     modifier confirmed(uint transactionId, address owner) {
71         if (!confirmations[transactionId][owner])
72            revert();
73         _;
74     }
75 
76     modifier notConfirmed(uint transactionId, address owner) {
77         if (confirmations[transactionId][owner])
78            revert();
79         _;
80     }
81 
82     modifier notExecuted(uint transactionId) {
83         if (transactions[transactionId].executed)
84            revert();
85         _;
86     }
87 
88     modifier notNull(address _address) {
89         if (_address == 0)
90            revert();
91         _;
92     }
93 
94     modifier validRequirement(uint ownerCount, uint _required) {
95         if (   ownerCount > MAX_OWNER_COUNT
96             || _required > ownerCount
97             || _required == 0
98             || ownerCount == 0)
99            revert();
100         _;
101     }
102 
103     /// @dev Fallback function allows to deposit ether.
104     function() external payable {
105         if (msg.value > 0)
106             Deposit(msg.sender, msg.value);
107     }
108 
109     /*
110      * Public functions
111      */
112     /// @dev Contract constructor sets initial owners and required number of confirmations.
113     /// @param _owners List of initial owners.
114     /// @param _required Number of required confirmations.
115     function MultiSigWallet(address[] _owners, uint _required)
116         public
117         validRequirement(_owners.length, _required)
118     {
119         for (uint i=0; i<_owners.length; i++) {
120             if (isOwner[_owners[i]] || _owners[i] == 0)
121                revert();
122             isOwner[_owners[i]] = true;
123         }
124         owners = _owners;
125         required = _required;
126     }
127 
128     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
129     /// @param owner Address of new owner.
130     function addOwner(address owner)
131         public
132         onlyWallet
133         ownerDoesNotExist(owner)
134         notNull(owner)
135         validRequirement(owners.length + 1, required)
136     {
137         isOwner[owner] = true;
138         owners.push(owner);
139         OwnerAddition(owner);
140     }
141 
142     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
143     /// @param owner Address of owner.
144     function removeOwner(address owner)
145         public
146         onlyWallet
147         ownerExists(owner)
148     {
149         isOwner[owner] = false;
150         for (uint i=0; i<owners.length - 1; i++)
151             if (owners[i] == owner) {
152                 owners[i] = owners[owners.length - 1];
153                 break;
154             }
155         owners.length -= 1;
156         if (required > owners.length)
157             changeRequirement(owners.length);
158         OwnerRemoval(owner);
159     }
160 
161     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
162     /// @param owner Address of owner to be replaced.
163     /// @param newOwner Address of new owner.
164     function replaceOwner(address owner, address newOwner)
165         public
166         onlyWallet
167         ownerExists(owner)
168         ownerDoesNotExist(newOwner)
169     {
170         for (uint i=0; i<owners.length; i++)
171             if (owners[i] == owner) {
172                 owners[i] = newOwner;
173                 break;
174             }
175         isOwner[owner] = false;
176         isOwner[newOwner] = true;
177         OwnerRemoval(owner);
178         OwnerAddition(newOwner);
179     }
180 
181     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
182     /// @param _required Number of required confirmations.
183     function changeRequirement(uint _required)
184         public
185         onlyWallet
186         validRequirement(owners.length, _required)
187     {
188         required = _required;
189         RequirementChange(_required);
190     }
191 
192     /// @dev Allows an owner to submit and confirm a transaction.
193     /// @param destination Transaction target address.
194     /// @param value Transaction ether value.
195     /// @param data Transaction data payload.
196     /// @return Returns transaction ID.
197     function submitTransaction(address destination, uint value, bytes data)
198         public
199         returns (uint transactionId)
200     {
201         transactionId = addTransaction(destination, value, data);
202         confirmTransaction(transactionId);
203     }
204 
205     /// @dev Allows an owner to confirm a transaction.
206     /// @param transactionId Transaction ID.
207     function confirmTransaction(uint transactionId)
208         public
209         ownerExists(msg.sender)
210         transactionExists(transactionId)
211         notConfirmed(transactionId, msg.sender)
212     {
213         confirmations[transactionId][msg.sender] = true;
214         Confirmation(msg.sender, transactionId);
215         executeTransaction(transactionId);
216     }
217 
218     /// @dev Allows an owner to revoke a confirmation for a transaction.
219     /// @param transactionId Transaction ID.
220     function revokeConfirmation(uint transactionId)
221         public
222         ownerExists(msg.sender)
223         confirmed(transactionId, msg.sender)
224         notExecuted(transactionId)
225     {
226         confirmations[transactionId][msg.sender] = false;
227         Revocation(msg.sender, transactionId);
228     }
229 
230     /// @dev Allows anyone to execute a confirmed transaction.
231     /// @param transactionId Transaction ID.
232     function executeTransaction(uint transactionId)
233         public
234         ownerExists(msg.sender)
235         confirmed(transactionId, msg.sender)
236         notExecuted(transactionId)
237     {
238         if (isConfirmed(transactionId)) {
239             Transaction storage _tx = transactions[transactionId];
240             _tx.executed = true;
241             if (_tx.destination.call.value(_tx.value)(_tx.data)) {
242                 Execution(transactionId);
243             } else {
244                 ExecutionFailure(transactionId);
245                 _tx.executed = false;
246             }
247         }
248     }
249 
250     /// @dev Returns the confirmation status of a transaction.
251     /// @param transactionId Transaction ID.
252     /// @return Confirmation status.
253     function isConfirmed(uint transactionId)
254         public
255         constant
256         returns (bool)
257     {
258         uint count = 0;
259         for (uint i=0; i<owners.length; i++) {
260             if (confirmations[transactionId][owners[i]])
261                 count += 1;
262             if (count == required)
263                 return true;
264         }
265     }
266 
267     /*
268      * Internal functions
269      */
270     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
271     /// @param destination Transaction target address.
272     /// @param value Transaction ether value.
273     /// @param data Transaction data payload.
274     /// @return Returns transaction ID.
275     function addTransaction(address destination, uint value, bytes data)
276         internal
277         notNull(destination)
278         returns (uint transactionId)
279     {
280         transactionId = transactionCount;
281         transactions[transactionId] = Transaction({
282             destination: destination,
283             value: value,
284             data: data,
285             executed: false
286         });
287         transactionCount += 1;
288         Submission(transactionId);
289     }
290 
291     /*
292      * Web3 call functions
293      */
294     /// @dev Returns number of confirmations of a transaction.
295     /// @param transactionId Transaction ID.
296     /// @return Number of confirmations.
297     function getConfirmationCount(uint transactionId)
298         public
299         constant
300         returns (uint count)
301     {
302         for (uint i=0; i<owners.length; i++)
303             if (confirmations[transactionId][owners[i]])
304                 count += 1;
305     }
306 
307     /// @dev Returns total number of transactions after filers are applied.
308     /// @param pending Include pending transactions.
309     /// @param executed Include executed transactions.
310     /// @return Total number of transactions after filters are applied.
311     function getTransactionCount(bool pending, bool executed)
312         public
313         constant
314         returns (uint count)
315     {
316         for (uint i=0; i<transactionCount; i++)
317             if (   pending && !transactions[i].executed
318                 || executed && transactions[i].executed)
319                 count += 1;
320     }
321 
322     /// @dev Returns list of owners.
323     /// @return List of owner addresses.
324     function getOwners()
325         public
326         constant
327         returns (address[])
328     {
329         return owners;
330     }
331 
332     /// @dev Returns array with owner addresses, which confirmed transaction.
333     /// @param transactionId Transaction ID.
334     /// @return Returns array of owner addresses.
335     function getConfirmations(uint transactionId)
336         public
337         constant
338         returns (address[] _confirmations)
339     {
340         address[] memory confirmationsTemp = new address[](owners.length);
341         uint count = 0;
342         uint i;
343         for (i=0; i<owners.length; i++)
344             if (confirmations[transactionId][owners[i]]) {
345                 confirmationsTemp[count] = owners[i];
346                 count += 1;
347             }
348         _confirmations = new address[](count);
349         for (i=0; i<count; i++)
350             _confirmations[i] = confirmationsTemp[i];
351     }
352 
353     /// @dev Returns list of transaction IDs in defined range.
354     /// @param from Index start position of transaction array.
355     /// @param to Index end position of transaction array.
356     /// @param pending Include pending transactions.
357     /// @param executed Include executed transactions.
358     /// @return Returns array of transaction IDs.
359     function getTransactionIds(uint from, uint to, bool pending, bool executed)
360         public
361         constant
362         returns (uint[] _transactionIds)
363     {
364         uint[] memory transactionIdsTemp = new uint[](transactionCount);
365         uint count = 0;
366         uint i;
367         for (i=0; i<transactionCount; i++)
368             if (   pending && !transactions[i].executed
369                 || executed && transactions[i].executed)
370             {
371                 transactionIdsTemp[count] = i;
372                 count += 1;
373             }
374         _transactionIds = new uint[](to - from);
375         for (i=from; i<to; i++)
376             _transactionIds[i - from] = transactionIdsTemp[i];
377     }
378 }