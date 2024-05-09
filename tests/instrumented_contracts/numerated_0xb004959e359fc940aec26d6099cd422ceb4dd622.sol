1 pragma solidity 0.4.16;
2 
3 
4 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
5 /// @author Stefan George, Danny Wu
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
16     event RecoveryModeActivated();
17 
18     mapping (uint => Transaction) public transactions;
19     mapping (uint => mapping (address => bool)) public confirmations;
20     mapping (address => bool) public isOwner;
21     address[] public owners;
22     uint public required;
23     uint public transactionCount;
24     uint public lastTransactionTime;
25     uint public recoveryModeTriggerTime;
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
40     modifier ownerExists(address owner) {
41         if (!isOwner[owner])
42             revert();
43         _;
44     }
45 
46     modifier transactionExists(uint transactionId) {
47         if (transactions[transactionId].destination == 0)
48             revert();
49         _;
50     }
51 
52     modifier confirmed(uint transactionId, address owner) {
53         if (!confirmations[transactionId][owner])
54             revert();
55         _;
56     }
57 
58     modifier notConfirmed(uint transactionId, address owner) {
59         if (confirmations[transactionId][owner])
60             revert();
61         _;
62     }
63 
64     modifier notExecuted(uint transactionId) {
65         if (transactions[transactionId].executed)
66             revert();
67         _;
68     }
69 
70     modifier notNull(address _address) {
71         if (_address == 0)
72             revert();
73         _;
74     }
75 
76     /// @dev Fallback function allows to deposit ether.
77     function()
78         payable
79     {
80         if (msg.value > 0)
81             Deposit(msg.sender, msg.value);
82     }
83 
84     /*
85      * Public functions
86      */
87     /// @dev Contract constructor sets owners, required number of confirmations, and recovery mode trigger.
88     /// @param _owners List of owners.
89     /// @param _required Number of required confirmations.
90     /// @param _recoveryModeTriggerTime Time (in seconds) of inactivity before recovery mode is triggerable.
91     function MultiSigWallet(address[] _owners, uint _required, uint _recoveryModeTriggerTime)
92         public
93     {
94         for (uint i=0; i<_owners.length; i++) {
95             if (isOwner[_owners[i]] || _owners[i] == 0)
96                 revert();
97             isOwner[_owners[i]] = true;
98         }
99         owners = _owners;
100         required = _required;
101         lastTransactionTime = block.timestamp;
102         recoveryModeTriggerTime = _recoveryModeTriggerTime;
103     }
104 
105     /// @dev Changes the number of required confirmations to one. Only triggerable after recoveryModeTriggerTime of inactivity.
106     function enterRecoveryMode()
107         public
108         ownerExists(msg.sender)
109     {
110         if (block.timestamp - lastTransactionTime >= recoveryModeTriggerTime) {
111             required = 1;
112             RecoveryModeActivated();
113         }
114     }
115 
116     /// @dev Allows an owner to submit and confirm a transaction.
117     /// @param destination Transaction target address.
118     /// @param value Transaction ether value.
119     /// @param data Transaction data payload.
120     /// @return Returns transaction ID.
121     function submitTransaction(address destination, uint value, bytes data)
122         public
123         returns (uint transactionId)
124     {
125         transactionId = addTransaction(destination, value, data);
126         confirmTransaction(transactionId);
127     }
128 
129     /// @dev Allows an owner to confirm a transaction.
130     /// @param transactionId Transaction ID.
131     function confirmTransaction(uint transactionId)
132         public
133         ownerExists(msg.sender)
134         transactionExists(transactionId)
135         notConfirmed(transactionId, msg.sender)
136     {
137         confirmations[transactionId][msg.sender] = true;
138         Confirmation(msg.sender, transactionId);
139         executeTransaction(transactionId);
140     }
141 
142     /// @dev Allows an owner to revoke a confirmation for a transaction.
143     /// @param transactionId Transaction ID.
144     function revokeConfirmation(uint transactionId)
145         public
146         ownerExists(msg.sender)
147         confirmed(transactionId, msg.sender)
148         notExecuted(transactionId)
149     {
150         confirmations[transactionId][msg.sender] = false;
151         Revocation(msg.sender, transactionId);
152     }
153 
154     /// @dev Allows an owner to execute a confirmed transaction.
155     /// @param transactionId Transaction ID.
156     function executeTransaction(uint transactionId)
157         public
158         ownerExists(msg.sender)
159         notExecuted(transactionId)
160     {
161         if (isConfirmed(transactionId)) {
162             Transaction storage txn = transactions[transactionId];
163             txn.executed = true;
164             lastTransactionTime = block.timestamp;
165             if (txn.destination.call.value(txn.value)(txn.data))
166                 Execution(transactionId);
167             else {
168                 ExecutionFailure(transactionId);
169                 txn.executed = false;
170             }
171         }
172     }
173 
174     /// @dev Returns the confirmation status of a transaction.
175     /// @param transactionId Transaction ID.
176     /// @return Confirmation status.
177     function isConfirmed(uint transactionId)
178         public
179         constant
180         returns (bool)
181     {
182         uint count = 0;
183         for (uint i=0; i<owners.length; i++) {
184             if (confirmations[transactionId][owners[i]])
185                 count += 1;
186             if (count == required)
187                 return true;
188         }
189     }
190 
191     /*
192      * Internal functions
193      */
194     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
195     /// @param destination Transaction target address.
196     /// @param value Transaction ether value.
197     /// @param data Transaction data payload.
198     /// @return Returns transaction ID.
199     function addTransaction(address destination, uint value, bytes data)
200         internal
201         notNull(destination)
202         returns (uint transactionId)
203     {
204         transactionId = transactionCount;
205         transactions[transactionId] = Transaction({
206             destination: destination,
207             value: value,
208             data: data,
209             executed: false
210         });
211         transactionCount += 1;
212         Submission(transactionId);
213     }
214 
215     /*
216      * Web3 call functions
217      */
218     /// @dev Returns number of confirmations of a transaction.
219     /// @param transactionId Transaction ID.
220     /// @return Number of confirmations.
221     function getConfirmationCount(uint transactionId)
222         public
223         constant
224         returns (uint count)
225     {
226         for (uint i=0; i<owners.length; i++)
227             if (confirmations[transactionId][owners[i]])
228                 count += 1;
229     }
230 
231     /// @dev Returns total number of transactions after filers are applied.
232     /// @param pending Include pending transactions.
233     /// @param executed Include executed transactions.
234     /// @return Total number of transactions after filters are applied.
235     function getTransactionCount(bool pending, bool executed)
236         public
237         constant
238         returns (uint count)
239     {
240         for (uint i=0; i<transactionCount; i++)
241             if (   pending && !transactions[i].executed
242                 || executed && transactions[i].executed)
243                 count += 1;
244     }
245 
246     /// @dev Returns list of owners.
247     /// @return List of owner addresses.
248     function getOwners()
249         public
250         constant
251         returns (address[])
252     {
253         return owners;
254     }
255 
256     /// @dev Returns array with owner addresses, which confirmed transaction.
257     /// @param transactionId Transaction ID.
258     /// @return Returns array of owner addresses.
259     function getConfirmations(uint transactionId)
260         public
261         constant
262         returns (address[] _confirmations)
263     {
264         address[] memory confirmationsTemp = new address[](owners.length);
265         uint count = 0;
266         uint i;
267         for (i=0; i<owners.length; i++)
268             if (confirmations[transactionId][owners[i]]) {
269                 confirmationsTemp[count] = owners[i];
270                 count += 1;
271             }
272         _confirmations = new address[](count);
273         for (i=0; i<count; i++)
274             _confirmations[i] = confirmationsTemp[i];
275     }
276 
277     /// @dev Returns list of transaction IDs in defined range.
278     /// @param from Index start position of transaction array.
279     /// @param to Index end position of transaction array.
280     /// @param pending Include pending transactions.
281     /// @param executed Include executed transactions.
282     /// @return Returns array of transaction IDs.
283     function getTransactionIds(uint from, uint to, bool pending, bool executed)
284         public
285         constant
286         returns (uint[] _transactionIds)
287     {
288         uint[] memory transactionIdsTemp = new uint[](transactionCount);
289         uint count = 0;
290         uint i;
291         for (i=0; i<transactionCount; i++)
292             if (   pending && !transactions[i].executed
293                 || executed && transactions[i].executed)
294             {
295                 transactionIdsTemp[count] = i;
296                 count += 1;
297             }
298         _transactionIds = new uint[](to - from);
299         for (i=from; i<to; i++)
300             _transactionIds[i - from] = transactionIdsTemp[i];
301     }
302 }