1 pragma solidity 0.4.19;
2 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
3 /// @author Stefan George - <stefan.george@consensys.net>
4 contract MultiSigWallet {
5     /*
6      *  Events
7      */
8     event Confirmation(address indexed sender, uint indexed transactionId);
9     event Revocation(address indexed sender, uint indexed transactionId);
10     event Submission(uint indexed transactionId);
11     event Execution(uint indexed transactionId);
12     event ExecutionFailure(uint indexed transactionId);
13     event Deposit(address indexed sender, uint value);
14     event OwnerAddition(address indexed owner);
15     event OwnerRemoval(address indexed owner);
16     event RequirementChange(uint required);
17     /*
18      *  Constants
19      */
20     uint constant public MAX_OWNER_COUNT = 50;
21     /*
22      *  Storage
23      */
24     mapping (uint => Transaction) public transactions;
25     mapping (uint => mapping (address => bool)) public confirmations;
26     mapping (address => bool) public isOwner;
27     address[] public owners;
28     uint public required;
29     uint public transactionCount;
30     struct Transaction {
31         address destination;
32         uint value;
33         bytes data;
34         bool executed;
35     }
36     /*
37      *  Modifiers
38      */
39     modifier onlyWallet() {
40         require(msg.sender == address(this));
41         _;
42     }
43     modifier ownerDoesNotExist(address owner) {
44         require(!isOwner[owner]);
45         _;
46     }
47     modifier ownerExists(address owner) {
48         require(isOwner[owner]);
49         _;
50     }
51     modifier transactionExists(uint transactionId) {
52         require(transactions[transactionId].destination != 0);
53         _;
54     }
55     modifier confirmed(uint transactionId, address owner) {
56         require(confirmations[transactionId][owner]);
57         _;
58     }
59     modifier notConfirmed(uint transactionId, address owner) {
60         require(!confirmations[transactionId][owner]);
61         _;
62     }
63     modifier notExecuted(uint transactionId) {
64         require(!transactions[transactionId].executed);
65         _;
66     }
67     modifier notNull(address _address) {
68         require(_address != 0);
69         _;
70     }
71     modifier validRequirement(uint ownerCount, uint _required) {
72         require(ownerCount <= MAX_OWNER_COUNT
73             && _required <= ownerCount
74             && _required != 0
75             && ownerCount != 0);
76         _;
77     }
78     /// @dev Fallback function allows to deposit ether.
79     function()
80         payable
81     {
82         if (msg.value > 0)
83             Deposit(msg.sender, msg.value);
84     }
85     /*
86      * Public functions
87      */
88     /// @dev Contract constructor sets initial owners and required number of confirmations.
89     /// @param _owners List of initial owners.
90     /// @param _required Number of required confirmations.
91     function MultiSigWallet(address[] _owners, uint _required)
92         public
93         validRequirement(_owners.length, _required)
94     {
95         for (uint i=0; i<_owners.length; i++) {
96             require(!isOwner[_owners[i]] && _owners[i] != 0);
97             isOwner[_owners[i]] = true;
98         }
99         owners = _owners;
100         required = _required;
101     }
102     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
103     /// @param owner Address of new owner.
104     function addOwner(address owner)
105         public
106         onlyWallet
107         ownerDoesNotExist(owner)
108         notNull(owner)
109         validRequirement(owners.length + 1, required)
110     {
111         isOwner[owner] = true;
112         owners.push(owner);
113         OwnerAddition(owner);
114     }
115     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
116     /// @param owner Address of owner.
117     function removeOwner(address owner)
118         public
119         onlyWallet
120         ownerExists(owner)
121     {
122         isOwner[owner] = false;
123         for (uint i=0; i<owners.length - 1; i++)
124             if (owners[i] == owner) {
125                 owners[i] = owners[owners.length - 1];
126                 break;
127             }
128         owners.length -= 1;
129         if (required > owners.length)
130             changeRequirement(owners.length);
131         OwnerRemoval(owner);
132     }
133     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
134     /// @param owner Address of owner to be replaced.
135     /// @param newOwner Address of new owner.
136     function replaceOwner(address owner, address newOwner)
137         public
138         onlyWallet
139         ownerExists(owner)
140         ownerDoesNotExist(newOwner)
141     {
142         for (uint i=0; i<owners.length; i++)
143             if (owners[i] == owner) {
144                 owners[i] = newOwner;
145                 break;
146             }
147         isOwner[owner] = false;
148         isOwner[newOwner] = true;
149         OwnerRemoval(owner);
150         OwnerAddition(newOwner);
151     }
152     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
153     /// @param _required Number of required confirmations.
154     function changeRequirement(uint _required)
155         public
156         onlyWallet
157         validRequirement(owners.length, _required)
158     {
159         required = _required;
160         RequirementChange(_required);
161     }
162     /// @dev Allows an owner to submit and confirm a transaction.
163     /// @param destination Transaction target address.
164     /// @param value Transaction ether value.
165     /// @param data Transaction data payload.
166     /// @return Returns transaction ID.
167     function submitTransaction(address destination, uint value, bytes data)
168         public
169         returns (uint transactionId)
170     {
171         transactionId = addTransaction(destination, value, data);
172         confirmTransaction(transactionId);
173     }
174     /// @dev Allows an owner to confirm a transaction.
175     /// @param transactionId Transaction ID.
176     function confirmTransaction(uint transactionId)
177         public
178         ownerExists(msg.sender)
179         transactionExists(transactionId)
180         notConfirmed(transactionId, msg.sender)
181     {
182         confirmations[transactionId][msg.sender] = true;
183         Confirmation(msg.sender, transactionId);
184         executeTransaction(transactionId);
185     }
186     /// @dev Allows an owner to revoke a confirmation for a transaction.
187     /// @param transactionId Transaction ID.
188     function revokeConfirmation(uint transactionId)
189         public
190         ownerExists(msg.sender)
191         confirmed(transactionId, msg.sender)
192         notExecuted(transactionId)
193     {
194         confirmations[transactionId][msg.sender] = false;
195         Revocation(msg.sender, transactionId);
196     }
197     /// @dev Allows anyone to execute a confirmed transaction.
198     /// @param transactionId Transaction ID.
199     function executeTransaction(uint transactionId)
200         public
201         ownerExists(msg.sender)
202         confirmed(transactionId, msg.sender)
203         notExecuted(transactionId)
204     {
205         if (isConfirmed(transactionId)) {
206             Transaction storage txn = transactions[transactionId];
207             txn.executed = true;
208             if (txn.destination.call.value(txn.value)(txn.data))
209                 Execution(transactionId);
210             else {
211                 ExecutionFailure(transactionId);
212                 txn.executed = false;
213             }
214         }
215     }
216     /// @dev Returns the confirmation status of a transaction.
217     /// @param transactionId Transaction ID.
218     /// @return Confirmation status.
219     function isConfirmed(uint transactionId)
220         public
221         constant
222         returns (bool)
223     {
224         uint count = 0;
225         for (uint i=0; i<owners.length; i++) {
226             if (confirmations[transactionId][owners[i]])
227                 count += 1;
228             if (count == required)
229                 return true;
230         }
231     }
232     /*
233      * Internal functions
234      */
235     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
236     /// @param destination Transaction target address.
237     /// @param value Transaction ether value.
238     /// @param data Transaction data payload.
239     /// @return Returns transaction ID.
240     function addTransaction(address destination, uint value, bytes data)
241         internal
242         notNull(destination)
243         returns (uint transactionId)
244     {
245         transactionId = transactionCount;
246         transactions[transactionId] = Transaction({
247             destination: destination,
248             value: value,
249             data: data,
250             executed: false
251         });
252         transactionCount += 1;
253         Submission(transactionId);
254     }
255     /*
256      * Web3 call functions
257      */
258     /// @dev Returns number of confirmations of a transaction.
259     /// @param transactionId Transaction ID.
260     /// @return Number of confirmations.
261     function getConfirmationCount(uint transactionId)
262         public
263         constant
264         returns (uint count)
265     {
266         for (uint i=0; i<owners.length; i++)
267             if (confirmations[transactionId][owners[i]])
268                 count += 1;
269     }
270     /// @dev Returns total number of transactions after filers are applied.
271     /// @param pending Include pending transactions.
272     /// @param executed Include executed transactions.
273     /// @return Total number of transactions after filters are applied.
274     function getTransactionCount(bool pending, bool executed)
275         public
276         constant
277         returns (uint count)
278     {
279         for (uint i=0; i<transactionCount; i++)
280             if (   pending && !transactions[i].executed
281                 || executed && transactions[i].executed)
282                 count += 1;
283     }
284     /// @dev Returns list of owners.
285     /// @return List of owner addresses.
286     function getOwners()
287         public
288         constant
289         returns (address[])
290     {
291         return owners;
292     }
293     /// @dev Returns array with owner addresses, which confirmed transaction.
294     /// @param transactionId Transaction ID.
295     /// @return Returns array of owner addresses.
296     function getConfirmations(uint transactionId)
297         public
298         constant
299         returns (address[] _confirmations)
300     {
301         address[] memory confirmationsTemp = new address[](owners.length);
302         uint count = 0;
303         uint i;
304         for (i=0; i<owners.length; i++)
305             if (confirmations[transactionId][owners[i]]) {
306                 confirmationsTemp[count] = owners[i];
307                 count += 1;
308             }
309         _confirmations = new address[](count);
310         for (i=0; i<count; i++)
311             _confirmations[i] = confirmationsTemp[i];
312     }
313     /// @dev Returns list of transaction IDs in defined range.
314     /// @param from Index start position of transaction array.
315     /// @param to Index end position of transaction array.
316     /// @param pending Include pending transactions.
317     /// @param executed Include executed transactions.
318     /// @return Returns array of transaction IDs.
319     function getTransactionIds(uint from, uint to, bool pending, bool executed)
320         public
321         constant
322         returns (uint[] _transactionIds)
323     {
324         uint[] memory transactionIdsTemp = new uint[](transactionCount);
325         uint count = 0;
326         uint i;
327         for (i=0; i<transactionCount; i++)
328             if (   pending && !transactions[i].executed
329                 || executed && transactions[i].executed)
330             {
331                 transactionIdsTemp[count] = i;
332                 count += 1;
333             }
334         _transactionIds = new uint[](to - from);
335         for (i=from; i<to; i++)
336             _transactionIds[i - from] = transactionIdsTemp[i];
337     }
338 }