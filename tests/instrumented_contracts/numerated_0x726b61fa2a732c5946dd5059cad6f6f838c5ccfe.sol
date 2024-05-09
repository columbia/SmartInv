1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------------------------
4 // by Gifto
5 // author: Gifto Team
6 // Contact: datwhnguyen@gmail.com
7 
8 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
9 
10 contract MultiSigWallet {
11 
12     event Confirmation(address sender, bytes32 transactionId);
13     event Revocation(address sender, bytes32 transactionId);
14     event Submission(bytes32 transactionId);
15     event Execution(bytes32 transactionId);
16     event Deposit(address sender, uint value);
17     event OwnerAddition(address owner);
18     event OwnerRemoval(address owner);
19     event RequirementChange(uint required);
20     event CoinCreation(address coin);
21 
22     mapping (bytes32 => Transaction) public transactions;
23     mapping (bytes32 => mapping (address => bool)) public confirmations;
24     mapping (address => bool) public isOwner;
25     address[] owners;
26     bytes32[] transactionList;
27     uint public required;
28 
29     struct Transaction {
30         address destination;
31         uint value;
32         bytes data;
33         uint nonce;
34         bool executed;
35     }
36 
37     modifier onlyWallet() {
38         require(msg.sender == address(this));
39         _;
40     }
41 
42     modifier ownerDoesNotExist(address owner) {
43         require(!isOwner[owner]);
44         _;
45     }
46 
47     modifier ownerExists(address owner) {
48         require(isOwner[owner]);
49         _;
50     }
51 
52     modifier confirmed(bytes32 transactionId, address owner) {
53         require(confirmations[transactionId][owner]);
54         _;
55     }
56 
57     modifier notConfirmed(bytes32 transactionId, address owner) {
58         require(!confirmations[transactionId][owner]);
59         _;
60     }
61 
62     modifier notExecuted(bytes32 transactionId) {
63         require(!transactions[transactionId].executed);
64         _;
65     }
66 
67     modifier notNull(address destination) {
68         require(destination != 0);
69         _;
70     }
71 
72     modifier validRequirement(uint _ownerCount, uint _required) {
73         require(   _required <= _ownerCount
74                 && _required > 0 );
75         _;
76     }
77     
78     /// @dev Contract constructor sets initial owners and required number of confirmations.
79     /// @param _owners List of initial owners.
80     /// @param _required Number of required confirmations.
81     function MultiSigWallet(address[] _owners, uint _required)
82         validRequirement(_owners.length, _required)
83         public {
84         for (uint i=0; i<_owners.length; i++) {
85             // check duplicate owner and invalid address
86             if (isOwner[_owners[i]] || _owners[i] == 0){
87                 revert();
88             }
89             // assign new owner
90             isOwner[_owners[i]] = true;
91         }
92         owners = _owners;
93         required = _required;
94     }
95 
96     ///  Fallback function allows to deposit ether.
97     function()
98         public
99         payable {
100         if (msg.value > 0)
101             Deposit(msg.sender, msg.value);
102     }
103 
104     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
105     /// @param owner Address of new owner.
106     function addOwner(address owner)
107         public
108         onlyWallet
109         ownerDoesNotExist(owner) {
110         isOwner[owner] = true;
111         owners.push(owner);
112         OwnerAddition(owner);
113     }
114 
115     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
116     /// @param owner Address of owner.
117     function removeOwner(address owner)
118         public
119         onlyWallet
120         ownerExists(owner) {
121         // DO NOT remove last owner
122         require(owners.length > 1);
123         
124         isOwner[owner] = false;
125         for (uint i=0; i<owners.length - 1; i++)
126             if (owners[i] == owner) {
127                 owners[i] = owners[owners.length - 1];
128                 break;
129             }
130         owners.length -= 1;
131         if (required > owners.length)
132             changeRequirement(owners.length);
133         OwnerRemoval(owner);
134     }
135 
136     /// @dev Update the minimum required owner for transaction validation
137     /// @param _required number of owners
138     function changeRequirement(uint _required)
139         public
140         onlyWallet
141         validRequirement(owners.length, _required) {
142         required = _required;
143         RequirementChange(_required);
144     }
145 
146     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
147     /// @param destination Transaction target address.
148     /// @param value Transaction ether value.
149     /// @param data Transaction data payload.
150     /// @param nonce 
151     /// @return transactionId.
152     function addTransaction(address destination, uint value, bytes data, uint nonce)
153         private
154         notNull(destination)
155         returns (bytes32 transactionId) {
156         // transactionId = sha3(destination, value, data, nonce);
157         transactionId = keccak256(destination, value, data, nonce);
158         if (transactions[transactionId].destination == 0) {
159             transactions[transactionId] = Transaction({
160                 destination: destination,
161                 value: value,
162                 data: data,
163                 nonce: nonce,
164                 executed: false
165             });
166             transactionList.push(transactionId);
167             Submission(transactionId);
168         }
169     }
170 
171     /// @dev Allows an owner to submit and confirm a transaction.
172     /// @param destination Transaction target address.
173     /// @param value Transaction ether value.
174     /// @param data Transaction data payload.
175     /// @param nonce 
176     /// @return transactionId.
177     function submitTransaction(address destination, uint value, bytes data, uint nonce)
178         external
179         ownerExists(msg.sender)
180         returns (bytes32 transactionId) {
181         transactionId = addTransaction(destination, value, data, nonce);
182         confirmTransaction(transactionId);
183     }
184 
185     /// @dev Allows an owner to confirm a transaction.
186     /// @param transactionId transaction Id.
187     function confirmTransaction(bytes32 transactionId)
188         public
189         ownerExists(msg.sender)
190         notConfirmed(transactionId, msg.sender) {
191         confirmations[transactionId][msg.sender] = true;
192         Confirmation(msg.sender, transactionId);
193         executeTransaction(transactionId);
194     }
195 
196     
197     /// @dev Allows anyone to execute a confirmed transaction.
198     /// @param transactionId transaction Id.
199     function executeTransaction(bytes32 transactionId)
200         public
201         notExecuted(transactionId) {
202         if (isConfirmed(transactionId)) {
203             Transaction storage txn = transactions[transactionId]; 
204             txn.executed = true;
205             if (!txn.destination.call.value(txn.value)(txn.data))
206                 revert();
207             Execution(transactionId);
208         }
209     }
210 
211     /// @dev Allows an owner to revoke a confirmation for a transaction.
212     /// @param transactionId transaction Id.
213     function revokeConfirmation(bytes32 transactionId)
214         external
215         ownerExists(msg.sender)
216         confirmed(transactionId, msg.sender)
217         notExecuted(transactionId) {
218         confirmations[transactionId][msg.sender] = false;
219         Revocation(msg.sender, transactionId);
220     }
221 
222     /// @dev Returns the confirmation status of a transaction.
223     /// @param transactionId transaction Id.
224     /// @return Confirmation status.
225     function isConfirmed(bytes32 transactionId)
226         public
227         constant
228         returns (bool) {
229         uint count = 0;
230         for (uint i=0; i<owners.length; i++)
231             if (confirmations[transactionId][owners[i]])
232                 count += 1;
233             if (count == required)
234                 return true;
235     }
236 
237     /*
238      * Web3 call functions
239      */
240     /// @dev Returns number of confirmations of a transaction.
241     /// @param transactionId transaction Id.
242     /// @return Number of confirmations.
243     function confirmationCount(bytes32 transactionId)
244         external
245         constant
246         returns (uint count) {
247         for (uint i=0; i<owners.length; i++)
248             if (confirmations[transactionId][owners[i]])
249                 count += 1;
250     }
251 
252     ///  @dev Return list of transactions after filters are applied
253     ///  @param isPending pending status
254     ///  @return List of transactions
255     function filterTransactions(bool isPending)
256         private
257         constant
258         returns (bytes32[] _transactionList) {
259         bytes32[] memory _transactionListTemp = new bytes32[](transactionList.length);
260         uint count = 0;
261         for (uint i=0; i<transactionList.length; i++)
262             if (transactions[transactionList[i]].executed != isPending)
263             {
264                 _transactionListTemp[count] = transactionList[i];
265                 count += 1;
266             }
267         _transactionList = new bytes32[](count);
268         for (i=0; i<count; i++)
269             if (_transactionListTemp[i] > 0)
270                 _transactionList[i] = _transactionListTemp[i];
271     }
272 
273     /// @dev Returns list of pending transactions
274     function getPendingTransactions()
275         external
276         constant
277         returns (bytes32[]) {
278         return filterTransactions(true);
279     }
280 
281     /// @dev Returns list of executed transactions
282     function getExecutedTransactions()
283         external
284         constant
285         returns (bytes32[]) {
286         return filterTransactions(false);
287     }
288 }