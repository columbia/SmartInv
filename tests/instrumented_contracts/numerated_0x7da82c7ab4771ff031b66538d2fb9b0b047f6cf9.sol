1 pragma solidity ^0.4.4;
2 
3 
4 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
5 /// @author Stefan George - <stefan.george@consensys.net>
6 contract MultiSigWallet {
7 
8     event Confirmation(address sender, bytes32 transactionHash);
9     event Revocation(address sender, bytes32 transactionHash);
10     event Submission(bytes32 transactionHash);
11     event Execution(bytes32 transactionHash);
12     event Deposit(address sender, uint value);
13     event OwnerAddition(address owner);
14     event OwnerRemoval(address owner);
15     event RequiredUpdate(uint required);
16 
17     mapping (bytes32 => Transaction) public transactions;
18     mapping (bytes32 => mapping (address => bool)) public confirmations;
19     mapping (address => bool) public isOwner;
20     address[] owners;
21     bytes32[] transactionList;
22     uint public required;
23 
24     struct Transaction {
25         address destination;
26         uint value;
27         bytes data;
28         uint nonce;
29         bool executed;
30     }
31 
32     modifier onlyWallet() {
33         if (msg.sender != address(this))
34             throw;
35         _;
36     }
37 
38     modifier signaturesFromOwners(bytes32 transactionHash, uint8[] v, bytes32[] rs) {
39         for (uint i=0; i<v.length; i++)
40             if (!isOwner[ecrecover(transactionHash, v[i], rs[i], rs[v.length + i])])
41                 throw;
42         _;
43     }
44 
45     modifier ownerDoesNotExist(address owner) {
46         if (isOwner[owner])
47             throw;
48         _;
49     }
50 
51     modifier ownerExists(address owner) {
52         if (!isOwner[owner])
53             throw;
54         _;
55     }
56 
57     modifier confirmed(bytes32 transactionHash, address owner) {
58         if (!confirmations[transactionHash][owner])
59             throw;
60         _;
61     }
62 
63     modifier notConfirmed(bytes32 transactionHash, address owner) {
64         if (confirmations[transactionHash][owner])
65             throw;
66         _;
67     }
68 
69     modifier notExecuted(bytes32 transactionHash) {
70         if (transactions[transactionHash].executed)
71             throw;
72         _;
73     }
74 
75     modifier notNull(address destination) {
76         if (destination == 0)
77             throw;
78         _;
79     }
80 
81     modifier validRequired(uint _ownerCount, uint _required) {
82         if (   _required > _ownerCount
83             || _required == 0
84             || _ownerCount == 0)
85             throw;
86         _;
87     }
88 
89     function addOwner(address owner)
90         external
91         onlyWallet
92         ownerDoesNotExist(owner)
93     {
94         isOwner[owner] = true;
95         owners.push(owner);
96         OwnerAddition(owner);
97     }
98 
99     function removeOwner(address owner)
100         external
101         onlyWallet
102         ownerExists(owner)
103     {
104         isOwner[owner] = false;
105         for (uint i=0; i<owners.length - 1; i++)
106             if (owners[i] == owner) {
107                 owners[i] = owners[owners.length - 1];
108                 break;
109             }
110         owners.length -= 1;
111         if (required > owners.length)
112             updateRequired(owners.length);
113         OwnerRemoval(owner);
114     }
115 
116     function updateRequired(uint _required)
117         public
118         onlyWallet
119         validRequired(owners.length, _required)
120     {
121         required = _required;
122         RequiredUpdate(_required);
123     }
124 
125     function addTransaction(address destination, uint value, bytes data, uint nonce)
126         private
127         notNull(destination)
128         returns (bytes32 transactionHash)
129     {
130         transactionHash = sha3(destination, value, data, nonce);
131         if (transactions[transactionHash].destination == 0) {
132             transactions[transactionHash] = Transaction({
133                 destination: destination,
134                 value: value,
135                 data: data,
136                 nonce: nonce,
137                 executed: false
138             });
139             transactionList.push(transactionHash);
140             Submission(transactionHash);
141         }
142     }
143 
144     function submitTransaction(address destination, uint value, bytes data, uint nonce)
145         external
146         returns (bytes32 transactionHash)
147     {
148         transactionHash = addTransaction(destination, value, data, nonce);
149         confirmTransaction(transactionHash);
150     }
151 
152     function submitTransactionWithSignatures(address destination, uint value, bytes data, uint nonce, uint8[] v, bytes32[] rs)
153         external
154         returns (bytes32 transactionHash)
155     {
156         transactionHash = addTransaction(destination, value, data, nonce);
157         confirmTransactionWithSignatures(transactionHash, v, rs);
158     }
159 
160     function addConfirmation(bytes32 transactionHash, address owner)
161         private
162         notConfirmed(transactionHash, owner)
163     {
164         confirmations[transactionHash][owner] = true;
165         Confirmation(owner, transactionHash);
166     }
167 
168     function confirmTransaction(bytes32 transactionHash)
169         public
170         ownerExists(msg.sender)
171     {
172         addConfirmation(transactionHash, msg.sender);
173         executeTransaction(transactionHash);
174     }
175 
176     function confirmTransactionWithSignatures(bytes32 transactionHash, uint8[] v, bytes32[] rs)
177         public
178         signaturesFromOwners(transactionHash, v, rs)
179     {
180         for (uint i=0; i<v.length; i++)
181             addConfirmation(transactionHash, ecrecover(transactionHash, v[i], rs[i], rs[i + v.length]));
182         executeTransaction(transactionHash);
183     }
184 
185     function executeTransaction(bytes32 transactionHash)
186         public
187         notExecuted(transactionHash)
188     {
189         if (isConfirmed(transactionHash)) {
190             Transaction tx = transactions[transactionHash];
191             tx.executed = true;
192             if (!tx.destination.call.value(tx.value)(tx.data))
193                 throw;
194             Execution(transactionHash);
195         }
196     }
197 
198     function revokeConfirmation(bytes32 transactionHash)
199         external
200         ownerExists(msg.sender)
201         confirmed(transactionHash, msg.sender)
202         notExecuted(transactionHash)
203     {
204         confirmations[transactionHash][msg.sender] = false;
205         Revocation(msg.sender, transactionHash);
206     }
207 
208     function MultiSigWallet(address[] _owners, uint _required)
209         validRequired(_owners.length, _required)
210     {
211         for (uint i=0; i<_owners.length; i++)
212             isOwner[_owners[i]] = true;
213         owners = _owners;
214         required = _required;
215     }
216 
217     function()
218         payable
219     {
220         if (msg.value > 0)
221             Deposit(msg.sender, msg.value);
222     }
223 
224     function isConfirmed(bytes32 transactionHash)
225         public
226         constant
227         returns (bool)
228     {
229         uint count = 0;
230         for (uint i=0; i<owners.length; i++)
231             if (confirmations[transactionHash][owners[i]])
232                 count += 1;
233             if (count == required)
234                 return true;
235     }
236 
237     function confirmationCount(bytes32 transactionHash)
238         external
239         constant
240         returns (uint count)
241     {
242         for (uint i=0; i<owners.length; i++)
243             if (confirmations[transactionHash][owners[i]])
244                 count += 1;
245     }
246 
247     function filterTransactions(bool isPending)
248         private
249         returns (bytes32[] _transactionList)
250     {
251         bytes32[] memory _transactionListTemp = new bytes32[](transactionList.length);
252         uint count = 0;
253         for (uint i=0; i<transactionList.length; i++)
254             if (   isPending && !transactions[transactionList[i]].executed
255                 || !isPending && transactions[transactionList[i]].executed)
256             {
257                 _transactionListTemp[count] = transactionList[i];
258                 count += 1;
259             }
260         _transactionList = new bytes32[](count);
261         for (i=0; i<count; i++)
262             if (_transactionListTemp[i] > 0)
263                 _transactionList[i] = _transactionListTemp[i];
264     }
265 
266     function getPendingTransactions()
267         external
268         constant
269         returns (bytes32[] _transactionList)
270     {
271         return filterTransactions(true);
272     }
273 
274     function getExecutedTransactions()
275         external
276         constant
277         returns (bytes32[] _transactionList)
278     {
279         return filterTransactions(false);
280     }
281 }