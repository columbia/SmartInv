1 pragma solidity ^0.4.17;
2 
3 // ----------------------------------------------------------------------------------------------
4 // by EdooPAD Inc.
5 // An ERC20 standard
6 //
7 // author: EdooPAD Inc.
8 // Contact: william@edoopad.com 
9 
10 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
11 
12 contract MultiSigWallet {
13 
14     event Confirmation(address sender, bytes32 transactionId);
15     event Revocation(address sender, bytes32 transactionId);
16     event Submission(bytes32 transactionId);
17     event Execution(bytes32 transactionId);
18     event Deposit(address sender, uint value);
19     event OwnerAddition(address owner);
20     event OwnerRemoval(address owner);
21     event RequirementChange(uint required);
22     event CoinCreation(address coin);
23 
24     mapping (bytes32 => Transaction) public transactions;
25     mapping (bytes32 => mapping (address => bool)) public confirmations;
26     mapping (address => bool) public isOwner;
27     address[] owners;
28     bytes32[] transactionList;
29     uint public required;
30 
31     struct Transaction {
32         address destination;
33         uint value;
34         bytes data;
35         uint nonce;
36         bool executed;
37     }
38 
39     modifier onlyWallet() {
40         if (msg.sender != address(this))
41             revert();
42         _;
43     }
44 
45     modifier ownerDoesNotExist(address owner) {
46         if (isOwner[owner])
47             revert();
48         _;
49     }
50 
51     modifier ownerExists(address owner) {
52         if (!isOwner[owner])
53             revert();
54         _;
55     }
56 
57     modifier confirmed(bytes32 transactionId, address owner) {
58         if (!confirmations[transactionId][owner])
59             revert();
60         _;
61     }
62 
63     modifier notConfirmed(bytes32 transactionId, address owner) {
64         if (confirmations[transactionId][owner])
65             revert();
66         _;
67     }
68 
69     modifier notExecuted(bytes32 transactionId) {
70         if (transactions[transactionId].executed)
71             revert();
72         _;
73     }
74 
75     modifier notNull(address destination) {
76         if (destination == 0)
77             revert();
78         _;
79     }
80 
81     modifier validRequirement(uint _ownerCount, uint _required) {
82         if (   _required > _ownerCount
83             || _required == 0
84             || _ownerCount == 0)
85             revert();
86         _;
87     }
88 
89     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
90     /// @param owner Address of new owner.
91     function addOwner(address owner)
92         external
93         onlyWallet
94         ownerDoesNotExist(owner)
95     {
96         isOwner[owner] = true;
97         owners.push(owner);
98         OwnerAddition(owner);
99     }
100 
101     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
102     /// @param owner Address of owner.
103     function removeOwner(address owner)
104         external
105         onlyWallet
106         ownerExists(owner)
107     {
108         isOwner[owner] = false;
109         for (uint i=0; i<owners.length - 1; i++)
110             if (owners[i] == owner) {
111                 owners[i] = owners[owners.length - 1];
112                 break;
113             }
114         owners.length -= 1;
115         if (required > owners.length)
116             changeRequirement(owners.length);
117         OwnerRemoval(owner);
118     }
119 
120     /// @dev Update the minimum required owner for transaction validation
121     /// @param _required number of owners
122     function changeRequirement(uint _required)
123         public
124         onlyWallet
125         validRequirement(owners.length, _required)
126     {
127         required = _required;
128         RequirementChange(_required);
129     }
130 
131     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
132     /// @param destination Transaction target address.
133     /// @param value Transaction ether value.
134     /// @param data Transaction data payload.
135     /// @param nonce 
136     /// @return transactionId.
137     function addTransaction(address destination, uint value, bytes data, uint nonce)
138         private
139         notNull(destination)
140         returns (bytes32 transactionId)
141     {
142         // transactionId = sha3(destination, value, data, nonce);
143         transactionId = keccak256(destination, value, data, nonce);
144         if (transactions[transactionId].destination == 0) {
145             transactions[transactionId] = Transaction({
146                 destination: destination,
147                 value: value,
148                 data: data,
149                 nonce: nonce,
150                 executed: false
151             });
152             transactionList.push(transactionId);
153             Submission(transactionId);
154         }
155     }
156 
157     /// @dev Allows an owner to submit and confirm a transaction.
158     /// @param destination Transaction target address.
159     /// @param value Transaction ether value.
160     /// @param data Transaction data payload.
161     /// @param nonce 
162     /// @return transactionId.
163     function submitTransaction(address destination, uint value, bytes data, uint nonce)
164         external
165         ownerExists(msg.sender)
166         returns (bytes32 transactionId)
167     {
168         transactionId = addTransaction(destination, value, data, nonce);
169         confirmTransaction(transactionId);
170     }
171 
172     /// @dev Allows an owner to confirm a transaction.
173     /// @param transactionId transaction Id.
174     function confirmTransaction(bytes32 transactionId)
175         public
176         ownerExists(msg.sender)
177         notConfirmed(transactionId, msg.sender)
178     {
179         confirmations[transactionId][msg.sender] = true;
180         Confirmation(msg.sender, transactionId);
181         executeTransaction(transactionId);
182     }
183 
184     
185     /// @dev Allows anyone to execute a confirmed transaction.
186     /// @param transactionId transaction Id.
187     function executeTransaction(bytes32 transactionId)
188         public
189         notExecuted(transactionId)
190     {
191         if (isConfirmed(transactionId)) {
192             Transaction storage txn = transactions[transactionId]; 
193             txn.executed = true;
194             if (!txn.destination.call.value(txn.value)(txn.data))
195                 revert();
196                 // What happen with txn.executed when revert() is executed?
197             Execution(transactionId);
198         }
199     }
200 
201     /// @dev Allows an owner to revoke a confirmation for a transaction.
202     /// @param transactionId transaction Id.
203     function revokeConfirmation(bytes32 transactionId)
204         external
205         ownerExists(msg.sender)
206         confirmed(transactionId, msg.sender)
207         notExecuted(transactionId)
208     {
209         confirmations[transactionId][msg.sender] = false;
210         Revocation(msg.sender, transactionId);
211     }
212 
213     /// @dev Contract constructor sets initial owners and required number of confirmations.
214     /// @param _owners List of initial owners.
215     /// @param _required Number of required confirmations.
216     function MultiSigWallet(address[] _owners, uint _required)
217         validRequirement(_owners.length, _required)
218         public 
219     {
220         for (uint i=0; i<_owners.length; i++) {
221             // WHY Not included in this code?
222             // if (isOwner[_owners[i]] || _owners[i] == 0)
223             //     throw;
224             isOwner[_owners[i]] = true;
225         }
226         owners = _owners;
227         required = _required;
228     }
229 
230     ///  Fallback function allows to deposit ether.
231     function()
232         public
233         payable
234     {
235         if (msg.value > 0)
236             Deposit(msg.sender, msg.value);
237     }
238 
239     /// @dev Returns the confirmation status of a transaction.
240     /// @param transactionId transaction Id.
241     /// @return Confirmation status.
242     function isConfirmed(bytes32 transactionId)
243         public
244         constant
245         returns (bool)
246     {
247         uint count = 0;
248         for (uint i=0; i<owners.length; i++)
249             if (confirmations[transactionId][owners[i]])
250                 count += 1;
251             if (count == required)
252                 return true;
253     }
254 
255     /*
256      * Web3 call functions
257      */
258     /// @dev Returns number of confirmations of a transaction.
259     /// @param transactionId transaction Id.
260     /// @return Number of confirmations.
261     function confirmationCount(bytes32 transactionId)
262         external
263         constant
264         returns (uint count)
265     {
266         for (uint i=0; i<owners.length; i++)
267             if (confirmations[transactionId][owners[i]])
268                 count += 1;
269     }
270 
271     ///  @dev Return list of transactions after filters are applied
272     ///  @param isPending pending status
273     ///  @return List of transactions
274     function filterTransactions(bool isPending)
275         private
276         constant
277         returns (bytes32[] _transactionList)
278     {
279         bytes32[] memory _transactionListTemp = new bytes32[](transactionList.length);
280         uint count = 0;
281         for (uint i=0; i<transactionList.length; i++)
282             if (   isPending && !transactions[transactionList[i]].executed
283                 || !isPending && transactions[transactionList[i]].executed)
284             {
285                 _transactionListTemp[count] = transactionList[i];
286                 count += 1;
287             }
288         _transactionList = new bytes32[](count);
289         for (i=0; i<count; i++)
290             if (_transactionListTemp[i] > 0)
291                 _transactionList[i] = _transactionListTemp[i];
292     }
293 
294     /// @dev Returns list of pending transactions
295     function getPendingTransactions()
296         external
297         constant
298         returns (bytes32[])
299     {
300         return filterTransactions(true);
301     }
302 
303     /// @dev Returns list of executed transactions
304     function getExecutedTransactions()
305         external
306         constant
307         returns (bytes32[])
308     {
309         return filterTransactions(false);
310     }
311 }