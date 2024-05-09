1 pragma solidity 0.4.16;
2 
3 
4 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
5 /// @author Stefan George, Danny Wu
6 contract MultiSigWallet {
7 
8     event Confirmation(address indexed sender, uint indexed transactionId);
9     event Revocation(address indexed sender, uint indexed transactionId);
10     event Submission(uint indexed transactionId);
11     event Execution(uint indexed transactionId);
12     event ExecutionFailure(uint indexed transactionId);
13     event RecoveryModeActivated();
14 
15     mapping (uint => Transaction) public transactions;
16     mapping (uint => mapping (address => bool)) public confirmations;
17     mapping (address => bool) public isOwner;
18     address[] public owners;
19     uint public required;
20     uint public transactionCount;
21     uint public lastTransactionTime;
22     uint public recoveryModeTriggerTime;
23 
24     struct Transaction {
25         address destination;
26         uint value;
27         bytes data;
28         bool executed;
29     }
30 
31     modifier onlyWallet() {
32         if (msg.sender != address(this))
33             revert();
34         _;
35     }
36 
37     modifier ownerExists(address owner) {
38         if (!isOwner[owner])
39             revert();
40         _;
41     }
42 
43     modifier transactionExists(uint transactionId) {
44         if (transactions[transactionId].destination == 0)
45             revert();
46         _;
47     }
48 
49     modifier confirmed(uint transactionId, address owner) {
50         if (!confirmations[transactionId][owner])
51             revert();
52         _;
53     }
54 
55     modifier notConfirmed(uint transactionId, address owner) {
56         if (confirmations[transactionId][owner])
57             revert();
58         _;
59     }
60 
61     modifier notExecuted(uint transactionId) {
62         if (transactions[transactionId].executed)
63             revert();
64         _;
65     }
66 
67     modifier notNull(address _address) {
68         if (_address == 0)
69             revert();
70         _;
71     }
72 
73     /// @dev Fallback function allows to deposit ether.
74     function()
75         payable
76     {
77     }
78 
79     /*
80      * Public functions
81      */
82     /// @dev Contract constructor sets owners, required number of confirmations, and recovery mode trigger.
83     /// @param _owners List of owners.
84     /// @param _required Number of required confirmations.
85     /// @param _recoveryModeTriggerTime Time (in seconds) of inactivity before recovery mode is triggerable.
86     function MultiSigWallet(address[] _owners, uint _required, uint _recoveryModeTriggerTime)
87         public
88     {
89         for (uint i=0; i<_owners.length; i++) {
90             if (isOwner[_owners[i]] || _owners[i] == 0)
91                 revert();
92             isOwner[_owners[i]] = true;
93         }
94         owners = _owners;
95         required = _required;
96         lastTransactionTime = block.timestamp;
97         recoveryModeTriggerTime = _recoveryModeTriggerTime;
98     }
99 
100     /// @dev Changes the number of required confirmations to one. Only triggerable after recoveryModeTriggerTime of inactivity.
101     function enterRecoveryMode()
102         public
103         ownerExists(msg.sender)
104     {
105         require(block.timestamp - lastTransactionTime >= recoveryModeTriggerTime);
106         required = 1;
107         RecoveryModeActivated();
108     }
109 
110     /// @dev Allows an owner to submit and confirm a transaction.
111     /// @param destination Transaction target address.
112     /// @param value Transaction ether value.
113     /// @param data Transaction data payload.
114     /// @return Returns transaction ID.
115     function submitTransaction(address destination, uint value, bytes data)
116         public
117         returns (uint transactionId)
118     {
119         transactionId = addTransaction(destination, value, data);
120         confirmTransaction(transactionId);
121     }
122 
123     /// @dev Allows an owner to confirm a transaction.
124     /// @param transactionId Transaction ID.
125     function confirmTransaction(uint transactionId)
126         public
127         ownerExists(msg.sender)
128         transactionExists(transactionId)
129         notConfirmed(transactionId, msg.sender)
130     {
131         confirmations[transactionId][msg.sender] = true;
132         Confirmation(msg.sender, transactionId);
133         executeTransaction(transactionId);
134     }
135 
136     /// @dev Allows an owner to revoke a confirmation for a transaction.
137     /// @param transactionId Transaction ID.
138     function revokeConfirmation(uint transactionId)
139         public
140         ownerExists(msg.sender)
141         confirmed(transactionId, msg.sender)
142         notExecuted(transactionId)
143     {
144         confirmations[transactionId][msg.sender] = false;
145         Revocation(msg.sender, transactionId);
146     }
147 
148     /// @dev Allows an owner to execute a confirmed transaction.
149     /// @param transactionId Transaction ID.
150     function executeTransaction(uint transactionId)
151         public
152         ownerExists(msg.sender)
153         notExecuted(transactionId)
154     {
155         if (isConfirmed(transactionId)) {
156             Transaction storage txn = transactions[transactionId];
157             txn.executed = true;
158             lastTransactionTime = block.timestamp;
159             if (txn.destination.call.value(txn.value)(txn.data))
160                 Execution(transactionId);
161             else {
162                 ExecutionFailure(transactionId);
163                 txn.executed = false;
164             }
165         }
166     }
167 
168     /// @dev Returns the confirmation status of a transaction.
169     /// @param transactionId Transaction ID.
170     /// @return Confirmation status.
171     function isConfirmed(uint transactionId)
172         public
173         constant
174         returns (bool)
175     {
176         uint count = 0;
177         for (uint i=0; i<owners.length; i++) {
178             if (confirmations[transactionId][owners[i]])
179                 count += 1;
180             if (count == required)
181                 return true;
182         }
183     }
184 
185     /*
186      * Internal functions
187      */
188     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
189     /// @param destination Transaction target address.
190     /// @param value Transaction ether value.
191     /// @param data Transaction data payload.
192     /// @return Returns transaction ID.
193     function addTransaction(address destination, uint value, bytes data)
194         internal
195         notNull(destination)
196         returns (uint transactionId)
197     {
198         transactionId = transactionCount;
199         transactions[transactionId] = Transaction({
200             destination: destination,
201             value: value,
202             data: data,
203             executed: false
204         });
205         transactionCount += 1;
206         Submission(transactionId);
207     }
208 
209     /*
210      * Web3 call functions
211      */
212     /// @dev Returns number of confirmations of a transaction.
213     /// @param transactionId Transaction ID.
214     /// @return Number of confirmations.
215     function getConfirmationCount(uint transactionId)
216         public
217         constant
218         returns (uint count)
219     {
220         for (uint i=0; i<owners.length; i++)
221             if (confirmations[transactionId][owners[i]])
222                 count += 1;
223     }
224 
225     /// @dev Returns total number of transactions after filers are applied.
226     /// @param pending Include pending transactions.
227     /// @param executed Include executed transactions.
228     /// @return Total number of transactions after filters are applied.
229     function getTransactionCount(bool pending, bool executed)
230         public
231         constant
232         returns (uint count)
233     {
234         for (uint i=0; i<transactionCount; i++)
235             if (   pending && !transactions[i].executed
236                 || executed && transactions[i].executed)
237                 count += 1;
238     }
239 
240     /// @dev Returns list of owners.
241     /// @return List of owner addresses.
242     function getOwners()
243         public
244         constant
245         returns (address[])
246     {
247         return owners;
248     }
249 
250     /// @dev Returns array with owner addresses, which confirmed transaction.
251     /// @param transactionId Transaction ID.
252     /// @return Returns array of owner addresses.
253     function getConfirmations(uint transactionId)
254         public
255         constant
256         returns (address[] _confirmations)
257     {
258         address[] memory confirmationsTemp = new address[](owners.length);
259         uint count = 0;
260         uint i;
261         for (i=0; i<owners.length; i++)
262             if (confirmations[transactionId][owners[i]]) {
263                 confirmationsTemp[count] = owners[i];
264                 count += 1;
265             }
266         _confirmations = new address[](count);
267         for (i=0; i<count; i++)
268             _confirmations[i] = confirmationsTemp[i];
269     }
270 
271     /// @dev Returns list of transaction IDs in defined range.
272     /// @param from Index start position of transaction array.
273     /// @param to Index end position of transaction array.
274     /// @param pending Include pending transactions.
275     /// @param executed Include executed transactions.
276     /// @return Returns array of transaction IDs.
277     function getTransactionIds(uint from, uint to, bool pending, bool executed)
278         public
279         constant
280         returns (uint[] _transactionIds)
281     {
282         uint[] memory transactionIdsTemp = new uint[](transactionCount);
283         uint count = 0;
284         uint i;
285         for (i=0; i<transactionCount; i++)
286             if (   pending && !transactions[i].executed
287                 || executed && transactions[i].executed)
288             {
289                 transactionIdsTemp[count] = i;
290                 count += 1;
291             }
292         _transactionIds = new uint[](to - from);
293         for (i=from; i<to; i++)
294             _transactionIds[i - from] = transactionIdsTemp[i];
295     }
296 }