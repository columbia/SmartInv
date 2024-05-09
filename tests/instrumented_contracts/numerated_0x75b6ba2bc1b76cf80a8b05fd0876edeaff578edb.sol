1 pragma solidity 0.4.10;
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
36             throw;
37         _;
38     }
39 
40     modifier ownerDoesNotExist(address owner) {
41         if (isOwner[owner])
42             throw;
43         _;
44     }
45 
46     modifier ownerExists(address owner) {
47         if (!isOwner[owner])
48             throw;
49         _;
50     }
51 
52     modifier transactionExists(uint transactionId) {
53         if (transactions[transactionId].destination == 0)
54             throw;
55         _;
56     }
57 
58     modifier confirmed(uint transactionId, address owner) {
59         if (!confirmations[transactionId][owner])
60             throw;
61         _;
62     }
63 
64     modifier notConfirmed(uint transactionId, address owner) {
65         if (confirmations[transactionId][owner])
66             throw;
67         _;
68     }
69 
70     modifier notExecuted(uint transactionId) {
71         if (transactions[transactionId].executed)
72             throw;
73         _;
74     }
75 
76     modifier notNull(address _address) {
77         if (_address == 0)
78             throw;
79         _;
80     }
81 
82     modifier validRequirement(uint ownerCount, uint _required) {
83         if (   ownerCount > MAX_OWNER_COUNT
84             || _required > ownerCount
85             || _required == 0
86             || ownerCount == 0)
87             throw;
88         _;
89     }
90 
91     /// @dev Fallback function allows to deposit ether.
92     function()
93         payable
94     {
95         if (msg.value > 0)
96             Deposit(msg.sender, msg.value);
97     }
98 
99     /*
100      * Public functions
101      */
102     /// @dev Contract constructor sets initial owners and required number of confirmations.
103     /// @param _owners List of initial owners.
104     /// @param _required Number of required confirmations.
105     function MultiSigWallet(address[] _owners, uint _required)
106         public
107         validRequirement(_owners.length, _required)
108     {
109         for (uint i=0; i<_owners.length; i++) {
110             if (isOwner[_owners[i]] || _owners[i] == 0)
111                 throw;
112             isOwner[_owners[i]] = true;
113         }
114         owners = _owners;
115         required = _required;
116     }
117 
118 
119     /// @dev Allows an owner to submit and confirm a transaction.
120     /// @param destination Transaction target address.
121     /// @param value Transaction ether value.
122     /// @param data Transaction data payload.
123     /// @return Returns transaction ID.
124     function submitTransaction(address destination, uint value, bytes data)
125         public
126         returns (uint transactionId)
127     {
128         transactionId = addTransaction(destination, value, data);
129         confirmTransaction(transactionId);
130     }
131 
132     /// @dev Allows an owner to confirm a transaction.
133     /// @param transactionId Transaction ID.
134     function confirmTransaction(uint transactionId)
135         public
136         ownerExists(msg.sender)
137         transactionExists(transactionId)
138         notConfirmed(transactionId, msg.sender)
139     {
140         confirmations[transactionId][msg.sender] = true;
141         Confirmation(msg.sender, transactionId);
142         executeTransaction(transactionId);
143     }
144 
145     /// @dev Allows an owner to revoke a confirmation for a transaction.
146     /// @param transactionId Transaction ID.
147     function revokeConfirmation(uint transactionId)
148         public
149         ownerExists(msg.sender)
150         confirmed(transactionId, msg.sender)
151         notExecuted(transactionId)
152     {
153         confirmations[transactionId][msg.sender] = false;
154         Revocation(msg.sender, transactionId);
155     }
156 
157     /// @dev Allows anyone to execute a confirmed transaction.
158     /// @param transactionId Transaction ID.
159     function executeTransaction(uint transactionId)
160         public
161         notExecuted(transactionId)
162     {
163         if (isConfirmed(transactionId)) {
164             Transaction tx = transactions[transactionId];
165             tx.executed = true;
166             if (tx.destination.call.value(tx.value)(tx.data))
167                 Execution(transactionId);
168             else {
169                 ExecutionFailure(transactionId);
170                 tx.executed = false;
171             }
172         }
173     }
174 
175     /// @dev Returns the confirmation status of a transaction.
176     /// @param transactionId Transaction ID.
177     /// @return Confirmation status.
178     function isConfirmed(uint transactionId)
179         public
180         constant
181         returns (bool)
182     {
183         uint count = 0;
184         for (uint i=0; i<owners.length; i++) {
185             if (confirmations[transactionId][owners[i]])
186                 count += 1;
187             if (count == required)
188                 return true;
189         }
190     }
191 
192     /*
193      * Internal functions
194      */
195     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
196     /// @param destination Transaction target address.
197     /// @param value Transaction ether value.
198     /// @param data Transaction data payload.
199     /// @return Returns transaction ID.
200     function addTransaction(address destination, uint value, bytes data)
201         internal
202         notNull(destination)
203         returns (uint transactionId)
204     {
205         transactionId = transactionCount;
206         transactions[transactionId] = Transaction({
207             destination: destination,
208             value: value,
209             data: data,
210             executed: false
211         });
212         transactionCount += 1;
213         Submission(transactionId);
214     }
215 
216     /*
217      * Web3 call functions
218      */
219     /// @dev Returns number of confirmations of a transaction.
220     /// @param transactionId Transaction ID.
221     /// @return Number of confirmations.
222     function getConfirmationCount(uint transactionId)
223         public
224         constant
225         returns (uint count)
226     {
227         for (uint i=0; i<owners.length; i++)
228             if (confirmations[transactionId][owners[i]])
229                 count += 1;
230     }
231 
232     /// @dev Returns total number of transactions after filers are applied.
233     /// @param pending Include pending transactions.
234     /// @param executed Include executed transactions.
235     /// @return Total number of transactions after filters are applied.
236     function getTransactionCount(bool pending, bool executed)
237         public
238         constant
239         returns (uint count)
240     {
241         for (uint i=0; i<transactionCount; i++)
242             if (   pending && !transactions[i].executed
243                 || executed && transactions[i].executed)
244                 count += 1;
245     }
246 
247     /// @dev Returns list of owners.
248     /// @return List of owner addresses.
249     function getOwners()
250         public
251         constant
252         returns (address[])
253     {
254         return owners;
255     }
256 
257     /// @dev Returns array with owner addresses, which confirmed transaction.
258     /// @param transactionId Transaction ID.
259     /// @return Returns array of owner addresses.
260     function getConfirmations(uint transactionId)
261         public
262         constant
263         returns (address[] _confirmations)
264     {
265         address[] memory confirmationsTemp = new address[](owners.length);
266         uint count = 0;
267         uint i;
268         for (i=0; i<owners.length; i++)
269             if (confirmations[transactionId][owners[i]]) {
270                 confirmationsTemp[count] = owners[i];
271                 count += 1;
272             }
273         _confirmations = new address[](count);
274         for (i=0; i<count; i++)
275             _confirmations[i] = confirmationsTemp[i];
276     }
277 
278     /// @dev Returns list of transaction IDs in defined range.
279     /// @param from Index start position of transaction array.
280     /// @param to Index end position of transaction array.
281     /// @param pending Include pending transactions.
282     /// @param executed Include executed transactions.
283     /// @return Returns array of transaction IDs.
284     function getTransactionIds(uint from, uint to, bool pending, bool executed)
285         public
286         constant
287         returns (uint[] _transactionIds)
288     {
289         uint[] memory transactionIdsTemp = new uint[](transactionCount);
290         uint count = 0;
291         uint i;
292         for (i=0; i<transactionCount; i++)
293             if (   pending && !transactions[i].executed
294                 || executed && transactions[i].executed)
295             {
296                 transactionIdsTemp[count] = i;
297                 count += 1;
298             }
299         _transactionIds = new uint[](to - from);
300         for (i=from; i<to; i++)
301             _transactionIds[i - from] = transactionIdsTemp[i];
302     }
303 }