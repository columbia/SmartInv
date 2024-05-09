1 pragma solidity ^0.4.24;
2 
3 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
4 /// @author Stefan George - <stefan.george@consensys.net>
5 contract MultiSigWallet {
6 
7     /*
8      *  Events
9      */
10     event Confirmation(address indexed sender, uint indexed transactionId);
11     event Submission(uint indexed transactionId);
12     event Execution(uint indexed transactionId);
13     event ExecutionFailure(uint indexed transactionId);
14     event Deposit(address indexed sender, uint value);
15     event OwnerChange(address indexed oldOwner, address indexed newOwner);
16 
17     /*
18      *  Constants
19      */
20     uint constant public REQUIRED = 3;
21 
22     /*
23      *  Storage
24      */
25     mapping (uint => Transaction) public transactions;
26     
27     mapping (uint => mapping (address => bool)) public confirmations;
28     
29     mapping (address => bool) public isOwner;
30     address[] public owners;
31 
32     address public delayedOwner;
33     // This value is the timestamp when the confirmation becomes valid.
34     mapping (uint => uint) public delayedConfirmations;
35 
36     uint public transactionCount;
37 
38     struct Transaction {
39         address destination;
40         uint value;
41         bytes data;
42         bool executed;
43     }
44 
45     /*
46      *  Modifiers
47      */
48     modifier onlyWallet() {
49         require(msg.sender == address(this));
50         _;
51     }
52 
53     modifier ownerDoesNotExist(address owner) {
54         require(!isOwner[owner] && owner != delayedOwner);
55         _;
56     }
57 
58     modifier ownerExists(address owner) {
59         require(isOwner[owner] || owner == delayedOwner);
60         _;
61     }
62 
63     modifier transactionExists(uint transactionId) {
64         require(transactions[transactionId].destination != 0);
65         _;
66     }
67 
68 // as of now this could be refactored out - there is verification in code
69     modifier confirmed(uint transactionId, address owner) {
70         require(confirmations[transactionId][owner] || (owner == delayedOwner && delayedConfirmations[transactionId] < now));
71         _;
72     }
73 
74     modifier notExecuted(uint transactionId) {
75         require(!transactions[transactionId].executed);
76         _;
77     }
78 
79     modifier notNull(address _address) {
80         require(_address != 0);
81         _;
82     }
83 
84     /// @dev Fallback function allows to deposit ether.
85     function() public
86         payable
87     {
88         if (msg.value > 0)
89             emit Deposit(msg.sender, msg.value);
90     }
91 
92     /*
93      * Public functions
94      */
95     /// @dev Contract constructor sets initial owners and required number of confirmations.
96     /// @param _owners List of initial owners.
97     /// @param _delayedOwner an additional owner whose confirmation is delayed.
98     constructor(address[] _owners, address _delayedOwner)
99         public
100     {
101         uint _length = _owners.length;
102         require(_length == REQUIRED);
103         delayedOwner = _delayedOwner;
104         
105         for (uint i = 0; i < _length; i++) {
106             require(!isOwner[_owners[i]] && _owners[i] != 0);
107             isOwner[_owners[i]] = true;
108         }
109         owners = _owners;
110     }
111 
112     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
113     /// @param owner Address of owner to be replaced.
114     /// @param newOwner Address of new owner.
115     function replaceOwner(address owner, address newOwner)
116         public
117         onlyWallet
118         ownerExists(owner)
119         ownerDoesNotExist(newOwner)
120     {
121         for (uint i=0; i<owners.length; i++)
122             if (owners[i] == owner) {
123                 owners[i] = newOwner;
124                 break;
125             }
126         isOwner[owner] = false;
127         isOwner[newOwner] = true;
128         emit OwnerChange(owner, newOwner);
129     }
130 
131     /// @dev Allows an owner to submit and confirm a transaction.
132     /// @param destination Transaction target address.
133     /// @param value Transaction ether value.
134     /// @param data Transaction data payload.
135     /// @return Returns transaction ID.
136     function submitTransaction(address destination, uint value, bytes data)
137         public
138         ownerExists(msg.sender)
139         returns (uint transactionId)
140     {
141         transactionId = addTransaction(destination, value, data);
142         confirmTransaction(transactionId);
143     }
144 
145     /// @dev Allows an owner to confirm a transaction.
146     /// @param transactionId Transaction ID.
147     function confirmTransaction(uint transactionId)
148         public
149         ownerExists(msg.sender)
150         transactionExists(transactionId)
151     {
152         if (msg.sender == delayedOwner)
153         {
154             delayedConfirmations[transactionId] = now + 2 weeks;
155             emit Confirmation(msg.sender, transactionId);
156         }
157         else
158         {
159             confirmations[transactionId][msg.sender] = true;
160             emit Confirmation(msg.sender, transactionId);
161             executeTransaction(transactionId);
162         }
163     }
164 
165     /// @dev Allows an owner to execute a confirmed transaction.
166     /// @param transactionId Transaction ID.
167     function executeTransaction(uint transactionId)
168         public
169         ownerExists(msg.sender)
170         confirmed(transactionId, msg.sender)
171         notExecuted(transactionId)
172     {
173         if (isConfirmed(transactionId)) {
174             Transaction storage txn = transactions[transactionId];
175             txn.executed = true;
176             if (txn.destination.call.value(txn.value)(txn.data))
177                 emit Execution(transactionId);
178             else {
179                 emit ExecutionFailure(transactionId);
180                 txn.executed = false;
181             }
182         }
183     }
184 
185     /// @dev Returns the confirmation status of a transaction.
186     /// @param transactionId Transaction ID.
187     /// @return Confirmation status.
188     function isConfirmed(uint transactionId)
189         public
190         constant
191         returns (bool)
192     {
193         uint count = 0;
194         for (uint i = 0; i < owners.length; i++) {
195             if (confirmations[transactionId][owners[i]])
196                 count += 1;
197             if (count == REQUIRED)
198                 return true;
199         }
200         if (delayedConfirmations[transactionId] > 0 && delayedConfirmations[transactionId] < now)
201         {
202             count += 1;
203             if (count == REQUIRED)
204                 return true;
205         }
206     }
207 
208     /*
209      * Internal functions
210      */
211     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
212     /// @param destination Transaction target address.
213     /// @param value Transaction ether value.
214     /// @param data Transaction data payload.
215     /// @return Returns transaction ID.
216     function addTransaction(address destination, uint value, bytes data)
217         internal
218         notNull(destination)
219         returns (uint transactionId)
220     {
221         transactionId = transactionCount;
222         transactions[transactionId] = Transaction({
223             destination: destination,
224             value: value,
225             data: data,
226             executed: false
227         });
228         transactionCount += 1;
229         emit Submission(transactionId);
230     }
231 
232     /// @dev Returns list of transaction IDs in defined range.
233     /// @param from Index start position of transaction array.
234     /// @param to Index end position of transaction array.
235     /// @param pending Include pending transactions.
236     /// @param executed Include executed transactions.
237     /// @return Returns array of transaction IDs.
238     function getTransactionIds(uint from, uint to, bool pending, bool executed)
239         public
240         constant
241         returns (uint[] _transactionIds)
242     {
243         uint[] memory transactionIdsTemp = new uint[](transactionCount);
244         uint count = 0;
245         uint i;
246         for (i=0; i<transactionCount; i++)
247             if (   pending && !transactions[i].executed
248                 || executed && transactions[i].executed)
249             {
250                 transactionIdsTemp[count] = i;
251                 count += 1;
252             }
253         _transactionIds = new uint[](to - from);
254         for (i=from; i<to; i++)
255             _transactionIds[i - from] = transactionIdsTemp[i];
256     }
257 }