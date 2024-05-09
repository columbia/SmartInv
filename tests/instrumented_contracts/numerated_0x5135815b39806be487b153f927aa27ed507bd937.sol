1 pragma solidity ^0.4.23;
2 
3 
4 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
5 /// @author Stefan George - <stefan.george@consensys.net>
6 /// modified by Juwita Winadwiastuti - <juwita.winadwiastuti[at]hara.ag>
7 contract MultiSigWallet {
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
23      *  Constants
24      */
25     uint constant public MAX_OWNER_COUNT = 50;
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
46     modifier ownerDoesNotExist(address owner) {
47         require(!isOwner[owner]);
48         _;
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
81     modifier validRequirement(uint ownerCount, uint _required) {
82         require(ownerCount <= MAX_OWNER_COUNT
83             && _required <= ownerCount
84             && _required != 0
85             && ownerCount != 0);
86         _;
87     }
88 
89     /// @dev Fallback function allows to deposit ether.
90     function()        
91         public
92         payable
93     {
94         if (msg.value > 0)
95             emit Deposit(msg.sender, msg.value);
96     }
97 
98     /*
99      * Public functions
100      */
101     /// @dev Contract constructor sets initial owners and required number of confirmations.
102     constructor()
103         public
104     {
105         owners = [msg.sender];
106         isOwner[msg.sender] = true;
107         required = 1;
108     }
109 
110     /// @dev Allows to add a new owner. Transaction has to be sent by owner.
111     /// @param owner Address of new owner.
112     function addOwner(address owner)
113         public
114         ownerExists(msg.sender)
115         ownerDoesNotExist(owner)
116         notNull(owner)
117         validRequirement(owners.length + 1, required)
118     {
119         isOwner[owner] = true;
120         owners.push(owner);
121         emit OwnerAddition(owner);
122         uint halfOwner = uint(owners.length)/2;
123         changeRequirement(halfOwner + 1);
124     }
125 
126     /// @dev Allows to remove an owner. Transaction has to be sent by owner.
127     /// @param owner Address of owner.
128     function removeOwner(address owner)
129         public
130         ownerExists(owner)
131         ownerExists(msg.sender)
132     {
133         isOwner[owner] = false;
134         for (uint i=0; i<owners.length - 1; i++)
135             if (owners[i] == owner) {
136                 owners[i] = owners[owners.length - 1];
137                 break;
138             }
139         owners.length -= 1;
140         uint halfOwner = uint(owners.length)/2;
141         changeRequirement(halfOwner + 1);
142         emit OwnerRemoval(owner);
143     }
144 
145     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by owner.
146     /// @param owner Address of owner to be replaced.
147     /// @param newOwner Address of new owner.
148     function replaceOwner(address owner, address newOwner)
149         public
150         ownerExists(msg.sender)
151         ownerExists(owner)
152         ownerDoesNotExist(newOwner)
153     {
154         for (uint i=0; i<owners.length; i++)
155             if (owners[i] == owner) {
156                 owners[i] = newOwner;
157                 break;
158             }
159         isOwner[owner] = false;
160         isOwner[newOwner] = true;
161         emit OwnerRemoval(owner);
162         emit OwnerAddition(newOwner);
163     }
164 
165     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by owner.
166     /// @param _required Number of required confirmations.
167     function changeRequirement(uint _required)
168         private
169         ownerExists(msg.sender)
170         validRequirement(owners.length, _required)
171     {
172         required = _required;
173         emit RequirementChange(_required);
174     }
175 
176     /// @dev Allows an owner to submit and confirm a withdraw transaction.
177     /// @param destination Withdraw destination address.
178     /// @param value Number of ether to withdraw.
179     /// @return Returns transaction ID.
180     function submitWithdrawTransaction(address destination, uint value)
181         public
182         ownerExists(msg.sender)
183         returns (uint transactionId)
184     {
185         transactionId = addTransaction(destination, value);
186         confirmTransaction(transactionId);
187     }
188 
189     /// @dev Allows an owner to confirm a transaction.
190     /// @param transactionId Transaction ID.
191     function confirmTransaction(uint transactionId)
192         public
193         ownerExists(msg.sender)
194         transactionExists(transactionId)
195         notConfirmed(transactionId, msg.sender)
196     {
197         confirmations[transactionId][msg.sender] = true;
198         emit Confirmation(msg.sender, transactionId);
199         executeTransaction(transactionId);
200     }
201 
202     /// @dev Allows an owner to revoke a confirmation for a transaction.
203     /// @param transactionId Transaction ID.
204     function revokeConfirmation(uint transactionId)
205         public
206         ownerExists(msg.sender)
207         confirmed(transactionId, msg.sender)
208         notExecuted(transactionId)
209     {
210         confirmations[transactionId][msg.sender] = false;
211         emit Revocation(msg.sender, transactionId);
212     }
213 
214     /// @dev Allows anyone to execute a confirmed transaction.
215     /// @param transactionId Transaction ID.
216     function executeTransaction(uint transactionId)
217         public
218         ownerExists(msg.sender)
219         confirmed(transactionId, msg.sender)
220         notExecuted(transactionId)
221     {
222         if (isConfirmed(transactionId)) {
223             Transaction storage txn = transactions[transactionId];
224             txn.executed = true;
225             if (withdraw(txn.destination, txn.value))
226                 emit Execution(transactionId);
227             else {
228                 emit ExecutionFailure(transactionId);
229                 txn.executed = false;
230             }
231         }
232     }
233 
234     /// @dev FUnction to send ether to address.
235     /// @param destination Address destination to send ether.
236     /// @param value Amount of ether to send.
237     /// @return Confirmation status.
238     function withdraw(address destination, uint value) 
239         ownerExists(msg.sender)
240         private 
241         returns (bool) 
242     {
243         destination.transfer(value);
244         return true;
245     }
246 
247     /// @dev Returns the confirmation status of a transaction.
248     /// @param transactionId Transaction ID.
249     /// @return Confirmation status.
250     function isConfirmed(uint transactionId)
251         public
252         constant
253         returns (bool)
254     {
255         uint count = 0;
256         for (uint i=0; i<owners.length; i++) {
257             if (confirmations[transactionId][owners[i]])
258                 count += 1;
259             if (count == required)
260                 return true;
261         }
262     }
263 
264     /*
265      * Internal functions
266      */
267     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
268     /// @param destination Transaction target address.
269     /// @param value Transaction ether value.
270     /// @return Returns transaction ID.
271     function addTransaction(address destination, uint value)
272         internal
273         notNull(destination)
274         returns (uint transactionId)
275     {
276         transactionId = transactionCount;
277         transactions[transactionId] = Transaction({
278             destination: destination,
279             value: value,
280             executed: false
281         });
282         transactionCount += 1;
283         emit Submission(transactionId);
284     }
285 
286     /*
287      * Web3 call functions
288      */
289     /// @dev Returns number of confirmations of a transaction.
290     /// @param transactionId Transaction ID.
291     /// @return Number of confirmations.
292     function getConfirmationCount(uint transactionId)
293         public
294         constant
295         returns (uint count)
296     {
297         for (uint i=0; i<owners.length; i++)
298             if (confirmations[transactionId][owners[i]])
299                 count += 1;
300     }
301 
302     /// @dev Returns total number of transactions after filers are applied.
303     /// @param pending Include pending transactions.
304     /// @param executed Include executed transactions.
305     /// @return Total number of transactions after filters are applied.
306     function getTransactionCount(bool pending, bool executed)
307         public
308         constant
309         returns (uint count)
310     {
311         for (uint i=0; i<transactionCount; i++)
312             if (   pending && !transactions[i].executed
313                 || executed && transactions[i].executed)
314                 count += 1;
315     }
316 
317     /// @dev Returns list of owners.
318     /// @return List of owner addresses.
319     function getOwners()
320         public
321         constant
322         returns (address[])
323     {
324         return owners;
325     }
326 
327     /// @dev Returns array with owner addresses, which confirmed transaction.
328     /// @param transactionId Transaction ID.
329     /// @return Returns array of owner addresses.
330     function getConfirmations(uint transactionId)
331         public
332         constant
333         returns (address[] _confirmations)
334     {
335         address[] memory confirmationsTemp = new address[](owners.length);
336         uint count = 0;
337         uint i;
338         for (i=0; i<owners.length; i++)
339             if (confirmations[transactionId][owners[i]]) {
340                 confirmationsTemp[count] = owners[i];
341                 count += 1;
342             }
343         _confirmations = new address[](count);
344         for (i=0; i<count; i++)
345             _confirmations[i] = confirmationsTemp[i];
346     }
347 
348     /// @dev Returns list of transaction IDs in defined range.
349     /// @param from Index start position of transaction array.
350     /// @param to Index end position of transaction array.
351     /// @param pending Include pending transactions.
352     /// @param executed Include executed transactions.
353     /// @return Returns array of transaction IDs.
354     function getTransactionIds(uint from, uint to, bool pending, bool executed)
355         public
356         constant
357         returns (uint[] _transactionIds)
358     {
359         uint[] memory transactionIdsTemp = new uint[](transactionCount);
360         uint count = 0;
361         uint i;
362         for (i=0; i<transactionCount; i++)
363             if (   pending && !transactions[i].executed
364                 || executed && transactions[i].executed)
365             {
366                 transactionIdsTemp[count] = i;
367                 count += 1;
368             }
369         _transactionIds = new uint[](to - from);
370         for (i=from; i<to; i++)
371             _transactionIds[i - from] = transactionIdsTemp[i];
372     }
373     
374 }