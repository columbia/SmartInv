1 pragma solidity 0.5.0;
2 
3 
4 /** @title Solidified Vault
5     @author JG Carvalho
6  **/
7 contract SolidifiedVault {
8 
9     /*
10      *  Events
11      */
12     event Confirmation(address indexed sender, uint indexed transactionId);
13     event Revocation(address indexed sender, uint indexed transactionId);
14     event Submission(uint indexed transactionId);
15     event Execution(uint indexed transactionId);
16     event ExecutionFailure(uint indexed transactionId);
17     event Deposit(address indexed sender, uint value);
18     event OwnerAddition(address indexed owner);
19     event OwnerRemoval(address indexed owner);
20     event RequirementChange(uint required);
21 
22     /*
23      *  views
24      */
25     uint constant public MAX_OWNER_COUNT = 3;
26 
27     /*
28      *  Storage
29      */
30     mapping (uint => Transaction) public transactions;
31     mapping (uint => mapping (address => bool)) public confirmations;
32     mapping (address => bool) public isOwner;
33     address[] public owners;
34     uint public required;
35     uint public transactionCount;
36 
37     struct Transaction {
38         address destination;
39         uint value;
40         bool executed;
41     }
42 
43     /*
44      *  Modifiers
45      */
46     modifier onlyWallet() {
47         require(msg.sender == address(this), "Vault: sender should be wallet");
48         _;
49     }
50 
51     modifier ownerDoesNotExist(address owner) {
52         require(!isOwner[owner], "Vault:sender shouldn't be owner");
53         _;
54     }
55 
56     modifier ownerExists(address owner) {
57         require(isOwner[owner], "Vault:sender should be owner");
58         _;
59     }
60 
61     modifier transactionExists(uint transactionId) {
62         require(transactions[transactionId].destination != address(0),"Vault:transaction should exist");
63         _;
64     }
65 
66     modifier confirmed(uint transactionId, address owner) {
67         require(confirmations[transactionId][owner], "Vault:transaction should be confirmed");
68         _;
69     }
70 
71     modifier notConfirmed(uint transactionId, address owner) {
72         require(!confirmations[transactionId][owner], "Vault:transaction is already confirmed");
73         _;
74     }
75 
76     modifier notExecuted(uint transactionId) {
77         require(!transactions[transactionId].executed, "Vault:transaction has already executed");
78         _;
79     }
80 
81     modifier notNull(address _address) {
82         require(_address != address(0), "Vault:address shouldn't be null");
83         _;
84     }
85 
86     modifier validRequirement(uint ownerCount, uint _required) {
87         require(ownerCount <= MAX_OWNER_COUNT
88             && _required <= ownerCount
89             && _required != 0
90             && ownerCount != 0, "Vault:invalid requirement");
91         _;
92     }
93 
94     /**
95       @dev Fallback function allows to deposit ether.
96     **/
97     function()
98         external
99         payable
100     {
101         if (msg.value > 0)
102             emit Deposit(msg.sender, msg.value);
103     }
104 
105     /*
106      * Public functions
107      */
108      /**
109      @dev Contract constructor sets initial owners and required number of confirmations.
110      @param _owners List of initial owners.
111      @param _required Number of required confirmations.
112      **/
113     constructor(address[] memory _owners, uint _required)
114         public
115         validRequirement(_owners.length, _required)
116     {
117         for (uint i=0; i<_owners.length; i++) {
118             require(!isOwner[_owners[i]] && _owners[i] != address(0), "Vault:Invalid owner");
119             isOwner[_owners[i]] = true;
120         }
121         owners = _owners;
122         required = _required;
123     }
124 
125 
126     /// @dev Allows an owner to submit and confirm a transaction.
127     /// @param destination Transaction target address.
128     /// @param value Transaction ether value.
129     /// @return Returns transaction ID.
130     function submitTransaction(address destination, uint value)
131         public
132         returns (uint transactionId)
133     {
134         transactionId = addTransaction(destination, value);
135         confirmTransaction(transactionId);
136     }
137 
138     /// @dev Allows an owner to confirm a transaction.
139     /// @param transactionId Transaction ID.
140     function confirmTransaction(uint transactionId)
141         public
142         ownerExists(msg.sender)
143         transactionExists(transactionId)
144         notConfirmed(transactionId, msg.sender)
145     {
146         confirmations[transactionId][msg.sender] = true;
147         emit Confirmation(msg.sender, transactionId);
148         executeTransaction(transactionId);
149     }
150 
151     /// @dev Allows an owner to revoke a confirmation for a transaction.
152     /// @param transactionId Transaction ID.
153     function revokeConfirmation(uint transactionId)
154         public
155         ownerExists(msg.sender)
156         confirmed(transactionId, msg.sender)
157         notExecuted(transactionId)
158     {
159         confirmations[transactionId][msg.sender] = false;
160         emit Revocation(msg.sender, transactionId);
161     }
162 
163     /// @dev Allows anyone to execute a confirmed transaction.
164     /// @param transactionId Transaction ID.
165     function executeTransaction(uint transactionId)
166         public
167         ownerExists(msg.sender)
168         confirmed(transactionId, msg.sender)
169         notExecuted(transactionId)
170     {
171         if (isConfirmed(transactionId)) {
172             Transaction storage txn = transactions[transactionId];
173             txn.executed = true;
174             (bool exec, bytes memory _) = txn.destination.call.value(txn.value)("");
175             if (exec)
176                 emit Execution(transactionId);
177             else {
178                 emit ExecutionFailure(transactionId);
179                 txn.executed = false;
180             }
181         }
182     }
183 
184     /// @dev Returns the confirmation status of a transaction.
185     /// @param transactionId Transaction ID.
186     /// @return Confirmation status.
187     function isConfirmed(uint transactionId)
188         public
189         view
190         returns (bool)
191     {
192         uint count = 0;
193         for (uint i=0; i<owners.length; i++) {
194             if (confirmations[transactionId][owners[i]])
195                 count += 1;
196             if (count == required)
197                 return true;
198         }
199     }
200 
201     /*
202      * Internal functions
203      */
204     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
205     /// @param destination Transaction target address.
206     /// @param value Transaction ether value.
207     /// @return Returns transaction ID.
208     function addTransaction(address destination, uint value)
209         internal
210         notNull(destination)
211         returns (uint transactionId)
212     {
213         transactionId = transactionCount;
214         transactions[transactionId] = Transaction({
215             destination: destination,
216             value: value,
217             executed: false
218         });
219         transactionCount += 1;
220         emit Submission(transactionId);
221     }
222 
223     /*
224      * Web3 call functions
225      */
226     /// @dev Returns number of confirmations of a transaction.
227     /// @param transactionId Transaction ID.
228     /// @return Number of confirmations.
229     function getConfirmationCount(uint transactionId)
230         public
231         view
232         returns (uint count)
233     {
234         for (uint i=0; i<owners.length; i++)
235             if (confirmations[transactionId][owners[i]])
236                 count += 1;
237     }
238 
239     /// @dev Returns total number of transactions after filers are applied.
240     /// @param pending Include pending transactions.
241     /// @param executed Include executed transactions.
242     /// @return Total number of transactions after filters are applied.
243     function getTransactionCount(bool pending, bool executed)
244         public
245         view
246         returns (uint count)
247     {
248         for (uint i=0; i<transactionCount; i++)
249             if (   pending && !transactions[i].executed
250                 || executed && transactions[i].executed)
251                 count += 1;
252     }
253 
254     /// @dev Returns list of owners.
255     /// @return List of owner addresses.
256     function getOwners()
257         public
258         view
259         returns (address[] memory)
260     {
261         return owners;
262     }
263 
264     /// @dev Returns array with owner addresses, which confirmed transaction.
265     /// @param transactionId Transaction ID.
266     /// @return Returns array of owner addresses.
267     function getConfirmations(uint transactionId)
268         public
269         view
270         returns (address[] memory _confirmations)
271     {
272         address[] memory confirmationsTemp = new address[](owners.length);
273         uint count = 0;
274         uint i;
275         for (i=0; i<owners.length; i++)
276             if (confirmations[transactionId][owners[i]]) {
277                 confirmationsTemp[count] = owners[i];
278                 count += 1;
279             }
280         _confirmations = new address[](count);
281         for (i=0; i<count; i++)
282             _confirmations[i] = confirmationsTemp[i];
283     }
284 
285     /// @dev Returns list of transaction IDs in defined range.
286     /// @param from Index start position of transaction array.
287     /// @param to Index end position of transaction array.
288     /// @param pending Include pending transactions.
289     /// @param executed Include executed transactions.
290     /// @return Returns array of transaction IDs.
291     function getTransactionIds(uint from, uint to, bool pending, bool executed)
292         public
293         view
294         returns (uint[] memory _transactionIds)
295     {
296         uint[] memory transactionIdsTemp = new uint[](transactionCount);
297         uint count = 0;
298         uint i;
299         for (i=0; i<transactionCount; i++)
300             if (   pending && !transactions[i].executed
301                 || executed && transactions[i].executed)
302             {
303                 transactionIdsTemp[count] = i;
304                 count += 1;
305             }
306         _transactionIds = new uint[](to - from);
307         for (i=from; i<to; i++)
308             _transactionIds[i - from] = transactionIdsTemp[i];
309     }
310 }