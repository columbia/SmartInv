1 pragma solidity 0.4.15;
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
47         require(msg.sender == address(this));
48         _;
49     }
50 
51     modifier ownerDoesNotExist(address owner) {
52         require(!isOwner[owner]);
53         _;
54     }
55 
56     modifier ownerExists(address owner) {
57         require(isOwner[owner]);
58         _;
59     }
60 
61     modifier transactionExists(uint transactionId) {
62         require(transactions[transactionId].destination != 0);
63         _;
64     }
65 
66     modifier confirmed(uint transactionId, address owner) {
67         require(confirmations[transactionId][owner]);
68         _;
69     }
70 
71     modifier notConfirmed(uint transactionId, address owner) {
72         require(!confirmations[transactionId][owner]);
73         _;
74     }
75 
76     modifier notExecuted(uint transactionId) {
77         require(!transactions[transactionId].executed);
78         _;
79     }
80 
81     modifier notNull(address _address) {
82         require(_address != 0);
83         _;
84     }
85 
86     modifier validRequirement(uint ownerCount, uint _required) {
87         require(ownerCount <= MAX_OWNER_COUNT
88             && _required <= ownerCount
89             && _required != 0
90             && ownerCount != 0);
91         _;
92     }
93 
94     /// @dev Fallback function allows to deposit ether.
95     function()
96         payable
97     {
98         if (msg.value > 0)
99             Deposit(msg.sender, msg.value);
100     }
101 
102     /*
103      * Public functions
104      */
105     /// @dev Contract constructor sets initial owners and required number of confirmations.
106     /// @param _owners List of initial owners.
107     /// @param _required Number of required confirmations.
108     function MultiSigWallet(address[] _owners, uint _required)
109         public
110         validRequirement(_owners.length, _required)
111     {
112         for (uint i=0; i<_owners.length; i++) {
113             require(!isOwner[_owners[i]] && _owners[i] != 0);
114             isOwner[_owners[i]] = true;
115         }
116         owners = _owners;
117         required = _required;
118     }
119 
120     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
121     /// @param owner Address of new owner.
122     function addOwner(address owner)
123         public
124         onlyWallet
125         ownerDoesNotExist(owner)
126         notNull(owner)
127         validRequirement(owners.length + 1, required)
128     {
129         isOwner[owner] = true;
130         owners.push(owner);
131         OwnerAddition(owner);
132     }
133 
134     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
135     /// @param owner Address of owner.
136     function removeOwner(address owner)
137         public
138         onlyWallet
139         ownerExists(owner)
140     {
141         isOwner[owner] = false;
142         for (uint i=0; i<owners.length - 1; i++)
143             if (owners[i] == owner) {
144                 owners[i] = owners[owners.length - 1];
145                 break;
146             }
147         owners.length -= 1;
148         if (required > owners.length)
149             changeRequirement(owners.length);
150         OwnerRemoval(owner);
151     }
152 
153     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
154     /// @param owner Address of owner to be replaced.
155     /// @param newOwner Address of new owner.
156     function replaceOwner(address owner, address newOwner)
157         public
158         onlyWallet
159         ownerExists(owner)
160         ownerDoesNotExist(newOwner)
161     {
162         for (uint i=0; i<owners.length; i++)
163             if (owners[i] == owner) {
164                 owners[i] = newOwner;
165                 break;
166             }
167         isOwner[owner] = false;
168         isOwner[newOwner] = true;
169         OwnerRemoval(owner);
170         OwnerAddition(newOwner);
171     }
172 
173     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
174     /// @param _required Number of required confirmations.
175     function changeRequirement(uint _required)
176         public
177         onlyWallet
178         validRequirement(owners.length, _required)
179     {
180         required = _required;
181         RequirementChange(_required);
182     }
183 
184     /// @dev Allows an owner to submit and confirm a transaction.
185     /// @param destination Transaction target address.
186     /// @param value Transaction ether value.
187     /// @param data Transaction data payload.
188     /// @return Returns transaction ID.
189     function submitTransaction(address destination, uint value, bytes data) public returns (uint transactionId)
190     {
191         transactionId = addTransaction(destination, value, data);
192         confirmTransaction(transactionId);
193     }
194 
195     /// @dev Allows an owner to confirm a transaction.
196     /// @param transactionId Transaction ID.
197     function confirmTransaction(uint transactionId)
198         public
199         ownerExists(msg.sender)
200         transactionExists(transactionId)
201         notConfirmed(transactionId, msg.sender)
202     {
203         confirmations[transactionId][msg.sender] = true;
204         Confirmation(msg.sender, transactionId);
205         executeTransaction(transactionId);
206     }
207 
208     /// @dev Allows an owner to revoke a confirmation for a transaction.
209     /// @param transactionId Transaction ID.
210     function revokeConfirmation(uint transactionId)
211         public
212         ownerExists(msg.sender)
213         confirmed(transactionId, msg.sender)
214         notExecuted(transactionId)
215     {
216         confirmations[transactionId][msg.sender] = false;
217         Revocation(msg.sender, transactionId);
218     }
219 
220     /// @dev Allows anyone to execute a confirmed transaction.
221     /// @param transactionId Transaction ID.
222     function executeTransaction(uint transactionId)
223         public
224         ownerExists(msg.sender)
225         confirmed(transactionId, msg.sender)
226         notExecuted(transactionId)
227     {
228         if (isConfirmed(transactionId)) {
229             Transaction storage txn = transactions[transactionId];
230             txn.executed = true;
231             if (txn.destination.call.value(txn.value)(txn.data))
232                 Execution(transactionId);
233             else {
234                 ExecutionFailure(transactionId);
235                 txn.executed = false;
236             }
237         }
238     }
239 
240     /// @dev Returns the confirmation status of a transaction.
241     /// @param transactionId Transaction ID.
242     /// @return Confirmation status.
243     function isConfirmed(uint transactionId)
244         public
245         constant
246         returns (bool)
247     {
248         uint count = 0;
249         for (uint i=0; i<owners.length; i++) {
250             if (confirmations[transactionId][owners[i]])
251                 count += 1;
252             if (count == required)
253                 return true;
254         }
255     }
256 
257     /*
258      * Internal functions
259      */
260     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
261     /// @param destination Transaction target address.
262     /// @param value Transaction ether value.
263     /// @param data Transaction data payload.
264     /// @return Returns transaction ID.
265     function addTransaction(address destination, uint value, bytes data)
266         internal
267         notNull(destination)
268         returns (uint transactionId)
269     {
270         transactionId = transactionCount;
271         transactions[transactionId] = Transaction({
272             destination: destination,
273             value: value,
274             data: data,
275             executed: false
276         });
277         transactionCount += 1;
278         Submission(transactionId);
279     }
280 
281     /*
282      * Web3 call functions
283      */
284     /// @dev Returns number of confirmations of a transaction.
285     /// @param transactionId Transaction ID.
286     /// @return Number of confirmations.
287     function getConfirmationCount(uint transactionId)
288         public
289         constant
290         returns (uint count)
291     {
292         for (uint i=0; i<owners.length; i++)
293             if (confirmations[transactionId][owners[i]])
294                 count += 1;
295     }
296 
297     /// @dev Returns total number of transactions after filers are applied.
298     /// @param pending Include pending transactions.
299     /// @param executed Include executed transactions.
300     /// @return Total number of transactions after filters are applied.
301     function getTransactionCount(bool pending, bool executed)
302         public
303         constant
304         returns (uint count)
305     {
306         for (uint i=0; i<transactionCount; i++)
307             if (   pending && !transactions[i].executed
308                 || executed && transactions[i].executed)
309                 count += 1;
310     }
311 
312     /// @dev Returns list of owners.
313     /// @return List of owner addresses.
314     function getOwners()
315         public
316         constant
317         returns (address[])
318     {
319         return owners;
320     }
321 
322     /// @dev Returns array with owner addresses, which confirmed transaction.
323     /// @param transactionId Transaction ID.
324     /// @return Returns array of owner addresses.
325     function getConfirmations(uint transactionId)
326         public
327         constant
328         returns (address[] _confirmations)
329     {
330         address[] memory confirmationsTemp = new address[](owners.length);
331         uint count = 0;
332         uint i;
333         for (i=0; i<owners.length; i++)
334             if (confirmations[transactionId][owners[i]]) {
335                 confirmationsTemp[count] = owners[i];
336                 count += 1;
337             }
338         _confirmations = new address[](count);
339         for (i=0; i<count; i++)
340             _confirmations[i] = confirmationsTemp[i];
341     }
342 
343     /// @dev Returns list of transaction IDs in defined range.
344     /// @param from Index start position of transaction array.
345     /// @param to Index end position of transaction array.
346     /// @param pending Include pending transactions.
347     /// @param executed Include executed transactions.
348     /// @return Returns array of transaction IDs.
349     function getTransactionIds(uint from, uint to, bool pending, bool executed)
350         public
351         constant
352         returns (uint[] _transactionIds)
353     {
354         uint[] memory transactionIdsTemp = new uint[](transactionCount);
355         uint count = 0;
356         uint i;
357         for (i=0; i<transactionCount; i++)
358             if (   pending && !transactions[i].executed
359                 || executed && transactions[i].executed)
360             {
361                 transactionIdsTemp[count] = i;
362                 count += 1;
363             }
364         _transactionIds = new uint[](to - from);
365         for (i=from; i<to; i++)
366             _transactionIds[i - from] = transactionIdsTemp[i];
367     }
368 }