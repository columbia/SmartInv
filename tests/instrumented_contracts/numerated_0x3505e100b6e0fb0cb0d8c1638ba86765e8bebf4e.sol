1 pragma solidity 0.4.24;
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
48             revert();
49         _;
50     }
51 
52     modifier ownerDoesNotExist(address owner) {
53         if (isOwner[owner])
54             revert();
55         _;
56     }
57 
58     modifier ownerExists(address owner) {
59         if (!isOwner[owner])
60             revert();
61         _;
62     }
63 
64     modifier transactionExists(uint transactionId) {
65         if (transactions[transactionId].destination == 0)
66             revert();
67         _;
68     }
69 
70     modifier confirmed(uint transactionId, address owner) {
71         if (!confirmations[transactionId][owner])
72             revert();
73         _;
74     }
75 
76     modifier notConfirmed(uint transactionId, address owner) {
77         if (confirmations[transactionId][owner])
78             revert();
79         _;
80     }
81 
82     modifier notExecuted(uint transactionId) {
83         if (transactions[transactionId].executed)
84             revert();
85         _;
86     }
87 
88     modifier notNull(address _address) {
89         if (_address == 0)
90             revert();
91         _;
92     }
93 
94     modifier validRequirement(uint ownerCount, uint _required) {
95         if (   ownerCount > MAX_OWNER_COUNT
96             || _required > ownerCount
97             || _required == 0
98             || ownerCount == 0)
99             revert();
100         _;
101     }
102 
103     /// @dev Fallback function allows to deposit ether.
104     function()
105         public
106         payable
107     {
108         if (msg.value > 0)
109             emit Deposit(msg.sender, msg.value);
110     }
111 
112     /*
113      * Public functions
114      */
115     /// @dev Contract constructor sets initial owners and required number of confirmations.
116     /// @param _owners List of initial owners.
117     /// @param _required Number of required confirmations.
118     constructor(address[] _owners, uint _required)
119         public
120         validRequirement(_owners.length, _required)
121     {
122         for (uint i=0; i<_owners.length; i++) {
123             if (isOwner[_owners[i]] || _owners[i] == 0)
124                 revert();
125             isOwner[_owners[i]] = true;
126         }
127         owners = _owners;
128         required = _required;
129     }
130 
131     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
132     /// @param owner Address of new owner.
133     function addOwner(address owner)
134         public
135         onlyWallet
136         ownerDoesNotExist(owner)
137         notNull(owner)
138         validRequirement(owners.length + 1, required)
139     {
140         isOwner[owner] = true;
141         owners.push(owner);
142         emit OwnerAddition(owner);
143     }
144 
145     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
146     /// @param owner Address of owner.
147     function removeOwner(address owner)
148         public
149         onlyWallet
150         ownerExists(owner)
151     {
152         isOwner[owner] = false;
153         for (uint i=0; i<owners.length - 1; i++)
154             if (owners[i] == owner) {
155                 owners[i] = owners[owners.length - 1];
156                 break;
157             }
158         owners.length -= 1;
159         if (required > owners.length)
160             changeRequirement(owners.length);
161         emit OwnerRemoval(owner);
162     }
163 
164     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
165     /// @param owner Address of owner to be replaced.
166     /// @param newOwner Address of new owner.
167     function replaceOwner(address owner, address newOwner)
168         public
169         onlyWallet
170         ownerExists(owner)
171         ownerDoesNotExist(newOwner)
172     {
173         for (uint i=0; i<owners.length; i++)
174             if (owners[i] == owner) {
175                 owners[i] = newOwner;
176                 break;
177             }
178         isOwner[owner] = false;
179         isOwner[newOwner] = true;
180         emit OwnerRemoval(owner);
181         emit OwnerAddition(newOwner);
182     }
183 
184     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
185     /// @param _required Number of required confirmations.
186     function changeRequirement(uint _required)
187         public
188         onlyWallet
189         validRequirement(owners.length, _required)
190     {
191         required = _required;
192         emit RequirementChange(_required);
193     }
194 
195     /// @dev Allows an owner to submit and confirm a transaction.
196     /// @param destination Transaction target address.
197     /// @param value Transaction ether value.
198     /// @param data Transaction data payload.
199     /// @return Returns transaction ID.
200     function submitTransaction(address destination, uint value, bytes data)
201         public
202         returns (uint transactionId)
203     {
204         transactionId = addTransaction(destination, value, data);
205         confirmTransaction(transactionId);
206     }
207 
208     /// @dev Allows an owner to confirm a transaction.
209     /// @param transactionId Transaction ID.
210     function confirmTransaction(uint transactionId)
211         public
212         ownerExists(msg.sender)
213         transactionExists(transactionId)
214         notConfirmed(transactionId, msg.sender)
215     {
216         confirmations[transactionId][msg.sender] = true;
217         emit Confirmation(msg.sender, transactionId);
218         executeTransaction(transactionId);
219     }
220 
221     /// @dev Allows an owner to revoke a confirmation for a transaction.
222     /// @param transactionId Transaction ID.
223     function revokeConfirmation(uint transactionId)
224         public
225         ownerExists(msg.sender)
226         confirmed(transactionId, msg.sender)
227         notExecuted(transactionId)
228     {
229         confirmations[transactionId][msg.sender] = false;
230         emit Revocation(msg.sender, transactionId);
231     }
232 
233     /// @dev Allows anyone to execute a confirmed transaction.
234     /// @param transactionId Transaction ID.
235     function executeTransaction(uint transactionId)
236         public
237         ownerExists(msg.sender)
238         confirmed(transactionId, msg.sender)
239         notExecuted(transactionId)
240     {
241         if (isConfirmed(transactionId)) {
242             Transaction storage transaction = transactions[transactionId];
243             transaction.executed = true;
244             if (transaction.destination.call.value(transaction.value)(transaction.data))
245                 emit Execution(transactionId);
246             else {
247                 emit ExecutionFailure(transactionId);
248                 transaction.executed = false;
249             }
250         }
251     }
252 
253     /// @dev Returns the confirmation status of a transaction.
254     /// @param transactionId Transaction ID.
255     /// @return Confirmation status.
256     function isConfirmed(uint transactionId)
257         public
258         constant
259         returns (bool)
260     {
261         uint count = 0;
262         for (uint i=0; i<owners.length; i++) {
263             if (confirmations[transactionId][owners[i]])
264                 count += 1;
265             if (count == required)
266                 return true;
267         }
268     }
269 
270     /*
271      * Internal functions
272      */
273     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
274     /// @param destination Transaction target address.
275     /// @param value Transaction ether value.
276     /// @param data Transaction data payload.
277     /// @return Returns transaction ID.
278     function addTransaction(address destination, uint value, bytes data)
279         internal
280         notNull(destination)
281         returns (uint transactionId)
282     {
283         transactionId = transactionCount;
284         transactions[transactionId] = Transaction({
285             destination: destination,
286             value: value,
287             data: data,
288             executed: false
289         });
290         transactionCount += 1;
291         emit Submission(transactionId);
292     }
293 
294     /*
295      * Web3 call functions
296      */
297     /// @dev Returns number of confirmations of a transaction.
298     /// @param transactionId Transaction ID.
299     /// @return Number of confirmations.
300     function getConfirmationCount(uint transactionId)
301         public
302         constant
303         returns (uint count)
304     {
305         for (uint i=0; i<owners.length; i++)
306             if (confirmations[transactionId][owners[i]])
307                 count += 1;
308     }
309 
310     /// @dev Returns total number of transactions after filers are applied.
311     /// @param pending Include pending transactions.
312     /// @param executed Include executed transactions.
313     /// @return Total number of transactions after filters are applied.
314     function getTransactionCount(bool pending, bool executed)
315         public
316         constant
317         returns (uint count)
318     {
319         for (uint i=0; i<transactionCount; i++)
320             if (   pending && !transactions[i].executed
321                 || executed && transactions[i].executed)
322                 count += 1;
323     }
324 
325     /// @dev Returns list of owners.
326     /// @return List of owner addresses.
327     function getOwners()
328         public
329         constant
330         returns (address[])
331     {
332         return owners;
333     }
334 
335     /// @dev Returns array with owner addresses, which confirmed transaction.
336     /// @param transactionId Transaction ID.
337     /// @return Returns array of owner addresses.
338     function getConfirmations(uint transactionId)
339         public
340         constant
341         returns (address[] _confirmations)
342     {
343         address[] memory confirmationsTemp = new address[](owners.length);
344         uint count = 0;
345         uint i;
346         for (i=0; i<owners.length; i++)
347             if (confirmations[transactionId][owners[i]]) {
348                 confirmationsTemp[count] = owners[i];
349                 count += 1;
350             }
351         _confirmations = new address[](count);
352         for (i=0; i<count; i++)
353             _confirmations[i] = confirmationsTemp[i];
354     }
355 
356     /// @dev Returns list of transaction IDs in defined range.
357     /// @param from Index start position of transaction array.
358     /// @param to Index end position of transaction array.
359     /// @param pending Include pending transactions.
360     /// @param executed Include executed transactions.
361     /// @return Returns array of transaction IDs.
362     function getTransactionIds(uint from, uint to, bool pending, bool executed)
363         public
364         constant
365         returns (uint[] _transactionIds)
366     {
367         uint[] memory transactionIdsTemp = new uint[](transactionCount);
368         uint count = 0;
369         uint i;
370         for (i=0; i<transactionCount; i++)
371             if (   pending && !transactions[i].executed
372                 || executed && transactions[i].executed)
373             {
374                 transactionIdsTemp[count] = i;
375                 count += 1;
376             }
377         _transactionIds = new uint[](to - from);
378         for (i=from; i<to; i++)
379             _transactionIds[i - from] = transactionIdsTemp[i];
380     }
381 }