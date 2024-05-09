1 pragma solidity ^0.4.8;
2 
3 
4 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
5 /// @author Stefan George - <stefan.george@consensys.net>
6 contract MultiSigWallet {
7 
8     // flag to determine if address is for a real contract or not
9     bool public isMultiSigWallet = false;
10 
11     uint constant public MAX_OWNER_COUNT = 50;
12 
13     event Confirmation(address indexed sender, uint indexed transactionId);
14     event Revocation(address indexed sender, uint indexed transactionId);
15     event Submission(uint indexed transactionId);
16     event Execution(uint indexed transactionId);
17     event ExecutionFailure(uint indexed transactionId);
18     event Deposit(address indexed sender, uint value);
19     event OwnerAddition(address indexed owner);
20     event OwnerRemoval(address indexed owner);
21     event RequirementChange(uint required);
22 
23     mapping (uint => Transaction) public transactions;
24     mapping (uint => mapping (address => bool)) public confirmations;
25     mapping (address => bool) public isOwner;
26     address[] public owners;
27     uint public required;
28     uint public transactionCount;
29 
30     struct Transaction {
31         address destination;
32         uint value;
33         bytes data;
34         bool executed;
35     }
36 
37     modifier onlyWallet() {
38         if (msg.sender != address(this)) throw;
39         _;
40     }
41 
42     modifier ownerDoesNotExist(address owner) {
43         if (isOwner[owner]) throw;
44         _;
45     }
46 
47     modifier ownerExists(address owner) {
48         if (!isOwner[owner]) throw;
49         _;
50     }
51 
52     modifier transactionExists(uint transactionId) {
53         if (transactions[transactionId].destination == 0) throw;
54         _;
55     }
56 
57     modifier confirmed(uint transactionId, address owner) {
58         if (!confirmations[transactionId][owner]) throw;
59         _;
60     }
61 
62     modifier notConfirmed(uint transactionId, address owner) {
63         if (confirmations[transactionId][owner]) throw;
64         _;
65     }
66 
67     modifier notExecuted(uint transactionId) {
68         if (transactions[transactionId].executed) throw;
69         _;
70     }
71 
72     modifier notNull(address _address) {
73         if (_address == 0) throw;
74         _;
75     }
76 
77     modifier validRequirement(uint ownerCount, uint _required) {
78         if (ownerCount > MAX_OWNER_COUNT) throw;
79         if (_required > ownerCount) throw;
80         if (_required == 0) throw;
81         if (ownerCount == 0) throw;
82         _;
83     }
84 
85     /// @dev Fallback function allows to deposit ether.
86     function()
87         payable
88     {
89         if (msg.value > 0)
90             Deposit(msg.sender, msg.value);
91     }
92 
93     /*
94      * Public functions
95      */
96     /// @dev Contract constructor sets initial owners and required number of confirmations.
97     /// @param _owners List of initial owners.
98     /// @param _required Number of required confirmations.
99     function MultiSigWallet(address[] _owners, uint _required)
100         public
101         validRequirement(_owners.length, _required)
102     {
103         for (uint i=0; i<_owners.length; i++) {
104             if (isOwner[_owners[i]] || _owners[i] == 0) throw;
105             isOwner[_owners[i]] = true;
106         }
107         isMultiSigWallet = true;
108         owners = _owners;
109         required = _required;
110     }
111 
112     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
113     /// @param owner Address of new owner.
114     function addOwner(address owner)
115         public
116         onlyWallet
117         ownerDoesNotExist(owner)
118         notNull(owner)
119         validRequirement(owners.length + 1, required)
120     {
121         isOwner[owner] = true;
122         owners.push(owner);
123         OwnerAddition(owner);
124     }
125 
126     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
127     /// @param owner Address of owner.
128     function removeOwner(address owner)
129         public
130         onlyWallet
131         ownerExists(owner)
132     {
133         isOwner[owner] = false;
134         for (uint i=0; i<owners.length - 1; i++)
135             if (owners[i] == owner) {
136                 owners[i] = owners[owners.length - 1];
137                 break;
138             }
139         owners.length -= 1;
140         if (required > owners.length)
141             changeRequirement(owners.length);
142         OwnerRemoval(owner);
143     }
144 
145     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
146     /// @param owner Address of owner to be replaced.
147     /// @param newOwner Address of new owner.
148     /// @param index the indx of the owner to be replaced
149     function replaceOwnerIndexed(address owner, address newOwner, uint index)
150         public
151         onlyWallet
152         ownerExists(owner)
153         ownerDoesNotExist(newOwner)
154     {
155         if (owners[index] != owner) throw;
156         owners[index] = newOwner;
157         isOwner[owner] = false;
158         isOwner[newOwner] = true;
159         OwnerRemoval(owner);
160         OwnerAddition(newOwner);
161     }
162 
163 
164     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
165     /// @param _required Number of required confirmations.
166     function changeRequirement(uint _required)
167         public
168         onlyWallet
169         validRequirement(owners.length, _required)
170     {
171         required = _required;
172         RequirementChange(_required);
173     }
174 
175     /// @dev Allows an owner to submit and confirm a transaction.
176     /// @param destination Transaction target address.
177     /// @param value Transaction ether value.
178     /// @param data Transaction data payload.
179     /// @return Returns transaction ID.
180     function submitTransaction(address destination, uint value, bytes data)
181         public
182         returns (uint transactionId)
183     {
184         transactionId = addTransaction(destination, value, data);
185         confirmTransaction(transactionId);
186     }
187 
188     /// @dev Allows an owner to confirm a transaction.
189     /// @param transactionId Transaction ID.
190     function confirmTransaction(uint transactionId)
191         public
192         ownerExists(msg.sender)
193         transactionExists(transactionId)
194         notConfirmed(transactionId, msg.sender)
195     {
196         confirmations[transactionId][msg.sender] = true;
197         Confirmation(msg.sender, transactionId);
198         executeTransaction(transactionId);
199     }
200 
201     /// @dev Allows an owner to revoke a confirmation for a transaction.
202     /// @param transactionId Transaction ID.
203     function revokeConfirmation(uint transactionId)
204         public
205         ownerExists(msg.sender)
206         confirmed(transactionId, msg.sender)
207         notExecuted(transactionId)
208     {
209         confirmations[transactionId][msg.sender] = false;
210         Revocation(msg.sender, transactionId);
211     }
212 
213     /// @dev Returns the confirmation status of a transaction.
214     /// @param transactionId Transaction ID.
215     /// @return Confirmation status.
216     function isConfirmed(uint transactionId)
217         public
218         constant
219         returns (bool)
220     {
221         uint count = 0;
222         for (uint i=0; i<owners.length; i++) {
223             if (confirmations[transactionId][owners[i]])
224                 count += 1;
225             if (count == required)
226                 return true;
227         }
228     }
229 
230     /*
231      * Internal functions
232      */
233 
234     /// @dev Allows anyone to execute a confirmed transaction.
235     /// @param transactionId Transaction ID.
236     function executeTransaction(uint transactionId)
237        internal
238        notExecuted(transactionId)
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
252     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
253     /// @param destination Transaction target address.
254     /// @param value Transaction ether value.
255     /// @param data Transaction data payload.
256     /// @return Returns transaction ID.
257     function addTransaction(address destination, uint value, bytes data)
258         internal
259         notNull(destination)
260         returns (uint transactionId)
261     {
262         transactionId = transactionCount;
263         transactions[transactionId] = Transaction({
264             destination: destination,
265             value: value,
266             data: data,
267             executed: false
268         });
269         transactionCount += 1;
270         Submission(transactionId);
271     }
272 
273     /*
274      * Web3 call functions
275      */
276     /// @dev Returns number of confirmations of a transaction.
277     /// @param transactionId Transaction ID.
278     /// @return Number of confirmations.
279     function getConfirmationCount(uint transactionId)
280         public
281         constant
282         returns (uint count)
283     {
284         for (uint i=0; i<owners.length; i++)
285             if (confirmations[transactionId][owners[i]])
286                 count += 1;
287     }
288 
289     /// @dev Returns total number of transactions after filers are applied.
290     /// @param pending Include pending transactions.
291     /// @param executed Include executed transactions.
292     /// @return Total number of transactions after filters are applied.
293     function getTransactionCount(bool pending, bool executed)
294         public
295         constant
296         returns (uint count)
297     {
298         for (uint i=0; i<transactionCount; i++)
299             if ((pending && !transactions[i].executed) ||
300                 (executed && transactions[i].executed))
301                 count += 1;
302     }
303 
304     /// @dev Returns list of owners.
305     /// @return List of owner addresses.
306     function getOwners()
307         public
308         constant
309         returns (address[])
310     {
311         return owners;
312     }
313 
314     /// @dev Returns array with owner addresses, which confirmed transaction.
315     /// @param transactionId Transaction ID.
316     /// @return Returns array of owner addresses.
317     function getConfirmations(uint transactionId)
318         public
319         constant
320         returns (address[] _confirmations)
321     {
322         address[] memory confirmationsTemp = new address[](owners.length);
323         uint count = 0;
324         uint i;
325         for (i=0; i<owners.length; i++)
326             if (confirmations[transactionId][owners[i]]) {
327                 confirmationsTemp[count] = owners[i];
328                 count += 1;
329             }
330         _confirmations = new address[](count);
331         for (i=0; i<count; i++)
332             _confirmations[i] = confirmationsTemp[i];
333     }
334 
335     /// @dev Returns list of transaction IDs in defined range.
336     /// @param from Index start position of transaction array.
337     /// @param to Index end position of transaction array.
338     /// @param pending Include pending transactions.
339     /// @param executed Include executed transactions.
340     /// @return Returns array of transaction IDs.
341     function getTransactionIds(uint from, uint to, bool pending, bool executed)
342         public
343         constant
344         returns (uint[] _transactionIds)
345     {
346         uint[] memory transactionIdsTemp = new uint[](transactionCount);
347         uint count = 0;
348         uint i;
349         for (i=0; i<transactionCount; i++)
350           if ((pending && !transactions[i].executed) ||
351               (executed && transactions[i].executed))
352             {
353                 transactionIdsTemp[count] = i;
354                 count += 1;
355             }
356         _transactionIds = new uint[](to - from);
357         for (i=from; i<to; i++)
358             _transactionIds[i - from] = transactionIdsTemp[i];
359     }
360 }