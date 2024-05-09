1 pragma solidity 0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // ConsenSys/Gnosis MultiSig for 'UCOT' from:
5 // https://github.com/ConsenSys/MultiSigWallet/commit/359c4efb482d97f6a0c0dbea8cd4b95add13bcc4
6 //
7 // Deployed by Radek Ostrowski / http://startonchain.com
8 // Third-Party Software Disclaimer: Contract is deployed “as is”, without warranty of any kind, 
9 // either expressed or implied and such software is to be used at your own risk.
10 // ----------------------------------------------------------------------------
11 
12 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
13 /// @author Stefan George - <stefan.george@consensys.net>
14 contract MultiSigWallet {
15 
16     uint constant public MAX_OWNER_COUNT = 50;
17 
18     event Confirmation(address indexed sender, uint indexed transactionId);
19     event Revocation(address indexed sender, uint indexed transactionId);
20     event Submission(uint indexed transactionId);
21     event Execution(uint indexed transactionId);
22     event ExecutionFailure(uint indexed transactionId);
23     event Deposit(address indexed sender, uint value);
24     event OwnerAddition(address indexed owner);
25     event OwnerRemoval(address indexed owner);
26     event RequirementChange(uint required);
27 
28     mapping (uint => Transaction) public transactions;
29     mapping (uint => mapping (address => bool)) public confirmations;
30     mapping (address => bool) public isOwner;
31     address[] public owners;
32     uint public required;
33     uint public transactionCount;
34 
35     struct Transaction {
36         address destination;
37         uint value;
38         bytes data;
39         bool executed;
40     }
41 
42     modifier onlyWallet() {
43         if (msg.sender != address(this))
44             throw;
45         _;
46     }
47 
48     modifier ownerDoesNotExist(address owner) {
49         if (isOwner[owner])
50             throw;
51         _;
52     }
53 
54     modifier ownerExists(address owner) {
55         if (!isOwner[owner])
56             throw;
57         _;
58     }
59 
60     modifier transactionExists(uint transactionId) {
61         if (transactions[transactionId].destination == 0)
62             throw;
63         _;
64     }
65 
66     modifier confirmed(uint transactionId, address owner) {
67         if (!confirmations[transactionId][owner])
68             throw;
69         _;
70     }
71 
72     modifier notConfirmed(uint transactionId, address owner) {
73         if (confirmations[transactionId][owner])
74             throw;
75         _;
76     }
77 
78     modifier notExecuted(uint transactionId) {
79         if (transactions[transactionId].executed)
80             throw;
81         _;
82     }
83 
84     modifier notNull(address _address) {
85         if (_address == 0)
86             throw;
87         _;
88     }
89 
90     modifier validRequirement(uint ownerCount, uint _required) {
91         if (   ownerCount > MAX_OWNER_COUNT
92             || _required > ownerCount
93             || _required == 0
94             || ownerCount == 0)
95             throw;
96         _;
97     }
98 
99     /// @dev Fallback function allows to deposit ether.
100     function()
101         payable
102     {
103         if (msg.value > 0)
104             Deposit(msg.sender, msg.value);
105     }
106 
107     /*
108      * Public functions
109      */
110     /// @dev Contract constructor sets initial owners and required number of confirmations.
111     /// @param _owners List of initial owners.
112     /// @param _required Number of required confirmations.
113     function MultiSigWallet(address[] _owners, uint _required)
114         public
115         validRequirement(_owners.length, _required)
116     {
117         for (uint i=0; i<_owners.length; i++) {
118             if (isOwner[_owners[i]] || _owners[i] == 0)
119                 throw;
120             isOwner[_owners[i]] = true;
121         }
122         owners = _owners;
123         required = _required;
124     }
125 
126     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
127     /// @param owner Address of new owner.
128     function addOwner(address owner)
129         public
130         onlyWallet
131         ownerDoesNotExist(owner)
132         notNull(owner)
133         validRequirement(owners.length + 1, required)
134     {
135         isOwner[owner] = true;
136         owners.push(owner);
137         OwnerAddition(owner);
138     }
139 
140     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
141     /// @param owner Address of owner.
142     function removeOwner(address owner)
143         public
144         onlyWallet
145         ownerExists(owner)
146     {
147         isOwner[owner] = false;
148         for (uint i=0; i<owners.length - 1; i++)
149             if (owners[i] == owner) {
150                 owners[i] = owners[owners.length - 1];
151                 break;
152             }
153         owners.length -= 1;
154         if (required > owners.length)
155             changeRequirement(owners.length);
156         OwnerRemoval(owner);
157     }
158 
159     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
160     /// @param owner Address of owner to be replaced.
161     /// @param owner Address of new owner.
162     function replaceOwner(address owner, address newOwner)
163         public
164         onlyWallet
165         ownerExists(owner)
166         ownerDoesNotExist(newOwner)
167     {
168         for (uint i=0; i<owners.length; i++)
169             if (owners[i] == owner) {
170                 owners[i] = newOwner;
171                 break;
172             }
173         isOwner[owner] = false;
174         isOwner[newOwner] = true;
175         OwnerRemoval(owner);
176         OwnerAddition(newOwner);
177     }
178 
179     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
180     /// @param _required Number of required confirmations.
181     function changeRequirement(uint _required)
182         public
183         onlyWallet
184         validRequirement(owners.length, _required)
185     {
186         required = _required;
187         RequirementChange(_required);
188     }
189 
190     /// @dev Allows an owner to submit and confirm a transaction.
191     /// @param destination Transaction target address.
192     /// @param value Transaction ether value.
193     /// @param data Transaction data payload.
194     /// @return Returns transaction ID.
195     function submitTransaction(address destination, uint value, bytes data)
196         public
197         returns (uint transactionId)
198     {
199         transactionId = addTransaction(destination, value, data);
200         confirmTransaction(transactionId);
201     }
202 
203     /// @dev Allows an owner to confirm a transaction.
204     /// @param transactionId Transaction ID.
205     function confirmTransaction(uint transactionId)
206         public
207         ownerExists(msg.sender)
208         transactionExists(transactionId)
209         notConfirmed(transactionId, msg.sender)
210     {
211         confirmations[transactionId][msg.sender] = true;
212         Confirmation(msg.sender, transactionId);
213         executeTransaction(transactionId);
214     }
215 
216     /// @dev Allows an owner to revoke a confirmation for a transaction.
217     /// @param transactionId Transaction ID.
218     function revokeConfirmation(uint transactionId)
219         public
220         ownerExists(msg.sender)
221         confirmed(transactionId, msg.sender)
222         notExecuted(transactionId)
223     {
224         confirmations[transactionId][msg.sender] = false;
225         Revocation(msg.sender, transactionId);
226     }
227 
228     /// @dev Allows anyone to execute a confirmed transaction.
229     /// @param transactionId Transaction ID.
230     function executeTransaction(uint transactionId)
231         public
232         notExecuted(transactionId)
233     {
234         if (isConfirmed(transactionId)) {
235             Transaction tx = transactions[transactionId];
236             tx.executed = true;
237             if (tx.destination.call.value(tx.value)(tx.data))
238                 Execution(transactionId);
239             else {
240                 ExecutionFailure(transactionId);
241                 tx.executed = false;
242             }
243         }
244     }
245 
246     /// @dev Returns the confirmation status of a transaction.
247     /// @param transactionId Transaction ID.
248     /// @return Confirmation status.
249     function isConfirmed(uint transactionId)
250         public
251         constant
252         returns (bool)
253     {
254         uint count = 0;
255         for (uint i=0; i<owners.length; i++) {
256             if (confirmations[transactionId][owners[i]])
257                 count += 1;
258             if (count == required)
259                 return true;
260         }
261     }
262 
263     /*
264      * Internal functions
265      */
266     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
267     /// @param destination Transaction target address.
268     /// @param value Transaction ether value.
269     /// @param data Transaction data payload.
270     /// @return Returns transaction ID.
271     function addTransaction(address destination, uint value, bytes data)
272         internal
273         notNull(destination)
274         returns (uint transactionId)
275     {
276         transactionId = transactionCount;
277         transactions[transactionId] = Transaction({
278             destination: destination,
279             value: value,
280             data: data,
281             executed: false
282         });
283         transactionCount += 1;
284         Submission(transactionId);
285     }
286 
287     /*
288      * Web3 call functions
289      */
290     /// @dev Returns number of confirmations of a transaction.
291     /// @param transactionId Transaction ID.
292     /// @return Number of confirmations.
293     function getConfirmationCount(uint transactionId)
294         public
295         constant
296         returns (uint count)
297     {
298         for (uint i=0; i<owners.length; i++)
299             if (confirmations[transactionId][owners[i]])
300                 count += 1;
301     }
302 
303     /// @dev Returns total number of transactions after filers are applied.
304     /// @param pending Include pending transactions.
305     /// @param executed Include executed transactions.
306     /// @return Total number of transactions after filters are applied.
307     function getTransactionCount(bool pending, bool executed)
308         public
309         constant
310         returns (uint count)
311     {
312         for (uint i=0; i<transactionCount; i++)
313             if (   pending && !transactions[i].executed
314                 || executed && transactions[i].executed)
315                 count += 1;
316     }
317 
318     /// @dev Returns list of owners.
319     /// @return List of owner addresses.
320     function getOwners()
321         public
322         constant
323         returns (address[])
324     {
325         return owners;
326     }
327 
328     /// @dev Returns array with owner addresses, which confirmed transaction.
329     /// @param transactionId Transaction ID.
330     /// @return Returns array of owner addresses.
331     function getConfirmations(uint transactionId)
332         public
333         constant
334         returns (address[] _confirmations)
335     {
336         address[] memory confirmationsTemp = new address[](owners.length);
337         uint count = 0;
338         uint i;
339         for (i=0; i<owners.length; i++)
340             if (confirmations[transactionId][owners[i]]) {
341                 confirmationsTemp[count] = owners[i];
342                 count += 1;
343             }
344         _confirmations = new address[](count);
345         for (i=0; i<count; i++)
346             _confirmations[i] = confirmationsTemp[i];
347     }
348 
349     /// @dev Returns list of transaction IDs in defined range.
350     /// @param from Index start position of transaction array.
351     /// @param to Index end position of transaction array.
352     /// @param pending Include pending transactions.
353     /// @param executed Include executed transactions.
354     /// @return Returns array of transaction IDs.
355     function getTransactionIds(uint from, uint to, bool pending, bool executed)
356         public
357         constant
358         returns (uint[] _transactionIds)
359     {
360         uint[] memory transactionIdsTemp = new uint[](transactionCount);
361         uint count = 0;
362         uint i;
363         for (i=0; i<transactionCount; i++)
364             if (   pending && !transactions[i].executed
365                 || executed && transactions[i].executed)
366             {
367                 transactionIdsTemp[count] = i;
368                 count += 1;
369             }
370         _transactionIds = new uint[](to - from);
371         for (i=from; i<to; i++)
372             _transactionIds[i - from] = transactionIdsTemp[i];
373     }
374 }