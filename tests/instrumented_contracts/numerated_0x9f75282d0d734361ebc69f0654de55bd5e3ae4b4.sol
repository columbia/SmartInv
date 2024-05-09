1 pragma solidity ^0.4.23;
2 
3 
4 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
5 /// @author Stefan George, Danny Wu, Michael Kong
6 
7 
8 // ----------------------------------------------------------------------------
9 //
10 // SafeMath
11 //
12 // ----------------------------------------------------------------------------
13 
14 library SafeMath {
15 
16     function sub(uint a, uint b) internal pure returns (uint c) {
17         require(b <= a);
18         c = a - b;
19     }
20 
21 }
22 
23 
24 contract MultiSigWallet {
25 
26     using SafeMath for uint;
27 
28     event Confirmation(address indexed sender, uint indexed transactionId);
29     event Revocation(address indexed sender, uint indexed transactionId);
30     event Submission(uint indexed transactionId);
31     event Execution(uint indexed transactionId);
32     event ExecutionFailure(uint indexed transactionId);
33     event RecoveryModeActivated();
34 
35     mapping (uint => Transaction) public transactions;
36     mapping (uint => mapping (address => bool)) public confirmations;
37     mapping (address => bool) public isOwner;
38     address[] public owners;
39     uint public required;
40     uint public transactionCount;
41     uint public lastTransactionTime;
42     uint public recoveryModeTriggerTime;
43 
44     struct Transaction {
45         address destination;
46         uint value;
47         bytes data;
48         bool executed;
49     }
50 
51     modifier ownerExists(address owner) {
52         require(isOwner[owner]);
53         _;
54     }
55 
56     modifier transactionExists(uint transactionId) {
57         require(transactions[transactionId].destination != 0);
58         _;
59     }
60 
61     modifier confirmed(uint transactionId, address owner) {
62         require(confirmations[transactionId][owner]);
63         _;
64     }
65 
66     modifier notConfirmed(uint transactionId, address owner) {
67         require(!confirmations[transactionId][owner]);
68         _;
69     }
70 
71     modifier notExecuted(uint transactionId) {
72         require(!transactions[transactionId].executed);
73         _;
74     }
75 
76     modifier notNull(address _address) {
77         require(_address != 0);
78         _;
79     }
80 
81     /// @dev Fallback function allows to deposit ether.
82     function()
83         public
84         payable
85     {
86     }
87 
88     /*
89      * Public functions
90      */
91     /// @dev Contract constructor sets owners, required number of confirmations, and recovery mode trigger.
92     /// @param _owners List of owners.
93     /// @param _required Number of required confirmations.
94     /// @param _recoveryModeTriggerTime Time (in seconds) of inactivity before recovery mode is triggerable.
95     constructor(address[] _owners, uint _required, uint _recoveryModeTriggerTime)
96         public
97     {
98         // ensure at least one owner, one signature and recovery mode time is greater than zero.
99         require(_required > 0 && _owners.length > 0 && _recoveryModeTriggerTime > 0 && _owners.length >= _required);
100         for (uint i=0; i<_owners.length; i++) {
101             require(!isOwner[_owners[i]] && _owners[i] != 0);
102             isOwner[_owners[i]] = true;
103         }
104         owners = _owners;
105         required = _required;
106         lastTransactionTime = block.timestamp;
107         recoveryModeTriggerTime = _recoveryModeTriggerTime;
108     }
109 
110     /// @dev Reduces the number of required confirmations by one. Only triggerable after recoveryModeTriggerTime of inactivity.
111     //  @dev Also resets the last transaction time to be the current block timestamp.
112     function enterRecoveryMode()
113         public
114         ownerExists(msg.sender)
115     {
116         require(block.timestamp.sub(lastTransactionTime) >= recoveryModeTriggerTime && required > 1);
117         required = required.sub(1);
118         lastTransactionTime = block.timestamp;
119         emit RecoveryModeActivated();
120     }
121 
122     /// @dev Allows an owner to submit and confirm a transaction.
123     /// @param destination Transaction target address.
124     /// @param value Transaction ether value.
125     /// @param data Transaction data payload.
126     /// @return Returns transaction ID.
127     function submitTransaction(address destination, uint value, bytes data)
128         public
129         ownerExists(msg.sender)
130         returns (uint transactionId)
131     {
132         transactionId = addTransaction(destination, value, data);
133         confirmTransaction(transactionId);
134     }
135 
136     /// @dev Allows an owner to confirm a transaction.
137     /// @param transactionId Transaction ID.
138     function confirmTransaction(uint transactionId)
139         public
140         ownerExists(msg.sender)
141         transactionExists(transactionId)
142         notConfirmed(transactionId, msg.sender)
143     {
144         confirmations[transactionId][msg.sender] = true;
145         emit Confirmation(msg.sender, transactionId);
146         executeTransaction(transactionId);
147     }
148 
149     /// @dev Allows an owner to revoke a confirmation for a transaction.
150     /// @param transactionId Transaction ID.
151     function revokeConfirmation(uint transactionId)
152         public
153         ownerExists(msg.sender)
154         confirmed(transactionId, msg.sender)
155         notExecuted(transactionId)
156     {
157         confirmations[transactionId][msg.sender] = false;
158         emit Revocation(msg.sender, transactionId);
159     }
160 
161     /// @dev Allows an owner to execute a confirmed transaction.
162     /// @param transactionId Transaction ID.
163     function executeTransaction(uint transactionId)
164         public
165         ownerExists(msg.sender)
166         notExecuted(transactionId)
167     {
168         if (isConfirmed(transactionId)) {
169             Transaction storage txn = transactions[transactionId];
170             txn.executed = true;
171             lastTransactionTime = block.timestamp;
172             if (txn.destination.call.value(txn.value)(txn.data))
173                 emit Execution(transactionId);
174             else {
175                 emit ExecutionFailure(transactionId);
176                 txn.executed = false;
177             }
178         }
179     }
180 
181     /// @dev Returns the confirmation status of a transaction.
182     /// @param transactionId Transaction ID.
183     /// @return Confirmation status.
184     function isConfirmed(uint transactionId)
185         public
186         constant
187         returns (bool)
188     {
189         uint count;
190         for (uint i=0; i<owners.length; i++) {
191             if (confirmations[transactionId][owners[i]])
192                 count += 1;
193             if (count == required)
194                 return true;
195         }
196     }
197 
198     /*
199      * Internal functions
200      */
201     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
202     /// @param destination Transaction target address.
203     /// @param value Transaction ether value.
204     /// @param data Transaction data payload.
205     /// @return Returns transaction ID.
206     function addTransaction(address destination, uint value, bytes data)
207         internal
208         notNull(destination)
209         returns (uint transactionId)
210     {
211         transactionId = transactionCount;
212         transactions[transactionId] = Transaction({
213             destination: destination,
214             value: value,
215             data: data,
216             executed: false
217         });
218         transactionCount += 1;
219         emit Submission(transactionId);
220     }
221 
222     /*
223      * Web3 call functions
224      */
225     /// @dev Returns number of confirmations of a transaction.
226     /// @param transactionId Transaction ID.
227     /// @return Number of confirmations.
228     function getConfirmationCount(uint transactionId)
229         public
230         constant
231         returns (uint count)
232     {
233         for (uint i=0; i<owners.length; i++){
234           if (confirmations[transactionId][owners[i]])
235               count += 1;
236         }
237     }
238 
239     /// @dev Returns list of owners.
240     /// @return List of owner addresses.
241     function getOwners()
242         public
243         constant
244         returns (address[])
245     {
246         return owners;
247     }
248 
249     /// @dev Returns array with owner addresses, which confirmed transaction.
250     /// @param transactionId Transaction ID.
251     /// @return Returns array of owner addresses.
252     function getConfirmations(uint transactionId)
253         public
254         constant
255         returns (address[] _confirmations)
256     {
257         address[] memory confirmationsTemp = new address[](owners.length);
258         uint count;
259         uint i;
260         for (i=0; i<owners.length; i++)
261             if (confirmations[transactionId][owners[i]]) {
262                 confirmationsTemp[count] = owners[i];
263                 count += 1;
264             }
265         _confirmations = new address[](count);
266         for (i=0; i<count; i++)
267             _confirmations[i] = confirmationsTemp[i];
268     }
269 }