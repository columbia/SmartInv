1 pragma solidity ^0.4.11;
2 
3 /*
4   Copyright 2017, Stefan George (Consensys)
5 
6   This program is free software: you can redistribute it and/or modify
7   it under the terms of the GNU General Public License as published by
8   the Free Software Foundation, either version 3 of the License, or
9   (at your option) any later version.
10 
11   This program is distributed in the hope that it will be useful,
12   but WITHOUT ANY WARRANTY; without even the implied warranty of
13   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
14   GNU General Public License for more details.
15 
16   You should have received a copy of the GNU General Public License
17   along with this program.  If not, see <http://www.gnu.org/licenses/>.
18 
19 */
20 
21 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
22 /// @author Stefan George - <stefan.george@consensys.net>
23 contract MultiSigWallet {
24 
25     uint constant public MAX_OWNER_COUNT = 50;
26 
27     event Confirmation(address indexed _sender, uint indexed _transactionId);
28     event Revocation(address indexed _sender, uint indexed _transactionId);
29     event Submission(uint indexed _transactionId);
30     event Execution(uint indexed _transactionId);
31     event ExecutionFailure(uint indexed _transactionId);
32     event Deposit(address indexed _sender, uint _value);
33     event OwnerAddition(address indexed _owner);
34     event OwnerRemoval(address indexed _owner);
35     event RequirementChange(uint _required);
36 
37     mapping (uint => Transaction) public transactions;
38     mapping (uint => mapping (address => bool)) public confirmations;
39     mapping (address => bool) public isOwner;
40     address[] public owners;
41     uint public required;
42     uint public transactionCount;
43 
44     struct Transaction {
45         address destination;
46         uint value;
47         bytes data;
48         bool executed;
49     }
50 
51     modifier onlyWallet() {
52         if (msg.sender != address(this))
53             throw;
54         _;
55     }
56 
57     modifier ownerDoesNotExist(address owner) {
58         if (isOwner[owner])
59             throw;
60         _;
61     }
62 
63     modifier ownerExists(address owner) {
64         if (!isOwner[owner])
65             throw;
66         _;
67     }
68 
69     modifier transactionExists(uint transactionId) {
70         if (transactions[transactionId].destination == 0)
71             throw;
72         _;
73     }
74 
75     modifier confirmed(uint transactionId, address owner) {
76         if (!confirmations[transactionId][owner])
77             throw;
78         _;
79     }
80 
81     modifier notConfirmed(uint transactionId, address owner) {
82         if (confirmations[transactionId][owner])
83             throw;
84         _;
85     }
86 
87     modifier notExecuted(uint transactionId) {
88         if (transactions[transactionId].executed)
89             throw;
90         _;
91     }
92 
93     modifier notNull(address _address) {
94         if (_address == 0)
95             throw;
96         _;
97     }
98 
99     modifier validRequirement(uint ownerCount, uint _required) {
100         if (   ownerCount > MAX_OWNER_COUNT
101             || _required > ownerCount
102             || _required == 0
103             || ownerCount == 0)
104             throw;
105         _;
106     }
107 
108     /// @dev Fallback function allows to deposit ether.
109     function()
110         payable
111     {
112         if (msg.value > 0)
113             Deposit(msg.sender, msg.value);
114     }
115 
116     /*
117      * Public functions
118      */
119     /// @dev Contract constructor sets initial owners and required number of confirmations.
120     /// @param _owners List of initial owners.
121     /// @param _required Number of required confirmations.
122     function MultiSigWallet(address[] _owners, uint _required)
123         public
124         validRequirement(_owners.length, _required)
125     {
126         for (uint i=0; i<_owners.length; i++) {
127             if (isOwner[_owners[i]] || _owners[i] == 0)
128                 throw;
129             isOwner[_owners[i]] = true;
130         }
131         owners = _owners;
132         required = _required;
133     }
134 
135     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
136     /// @param owner Address of new owner.
137     function addOwner(address owner)
138         public
139         onlyWallet
140         ownerDoesNotExist(owner)
141         notNull(owner)
142         validRequirement(owners.length + 1, required)
143     {
144         isOwner[owner] = true;
145         owners.push(owner);
146         OwnerAddition(owner);
147     }
148 
149     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
150     /// @param owner Address of owner.
151     function removeOwner(address owner)
152         public
153         onlyWallet
154         ownerExists(owner)
155     {
156         isOwner[owner] = false;
157         for (uint i=0; i<owners.length - 1; i++)
158             if (owners[i] == owner) {
159                 owners[i] = owners[owners.length - 1];
160                 break;
161             }
162         owners.length -= 1;
163         if (required > owners.length)
164             changeRequirement(owners.length);
165         OwnerRemoval(owner);
166     }
167 
168     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
169     /// @param owner Address of owner to be replaced.
170     /// @param owner Address of new owner.
171     function replaceOwner(address owner, address newOwner)
172         public
173         onlyWallet
174         ownerExists(owner)
175         ownerDoesNotExist(newOwner)
176     {
177         for (uint i=0; i<owners.length; i++)
178             if (owners[i] == owner) {
179                 owners[i] = newOwner;
180                 break;
181             }
182         isOwner[owner] = false;
183         isOwner[newOwner] = true;
184         OwnerRemoval(owner);
185         OwnerAddition(newOwner);
186     }
187 
188     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
189     /// @param _required Number of required confirmations.
190     function changeRequirement(uint _required)
191         public
192         onlyWallet
193         validRequirement(owners.length, _required)
194     {
195         required = _required;
196         RequirementChange(_required);
197     }
198 
199     /// @dev Allows an owner to submit and confirm a transaction.
200     /// @param destination Transaction target address.
201     /// @param value Transaction ether value.
202     /// @param data Transaction data payload.
203     /// @return Returns transaction ID.
204     function submitTransaction(address destination, uint value, bytes data)
205         public
206         returns (uint transactionId)
207     {
208         transactionId = addTransaction(destination, value, data);
209         confirmTransaction(transactionId);
210     }
211 
212     /// @dev Allows an owner to confirm a transaction.
213     /// @param transactionId Transaction ID.
214     function confirmTransaction(uint transactionId)
215         public
216         ownerExists(msg.sender)
217         transactionExists(transactionId)
218         notConfirmed(transactionId, msg.sender)
219     {
220         confirmations[transactionId][msg.sender] = true;
221         Confirmation(msg.sender, transactionId);
222         executeTransaction(transactionId);
223     }
224 
225     /// @dev Allows an owner to revoke a confirmation for a transaction.
226     /// @param transactionId Transaction ID.
227     function revokeConfirmation(uint transactionId)
228         public
229         ownerExists(msg.sender)
230         confirmed(transactionId, msg.sender)
231         notExecuted(transactionId)
232     {
233         confirmations[transactionId][msg.sender] = false;
234         Revocation(msg.sender, transactionId);
235     }
236 
237     /// @dev Allows anyone to execute a confirmed transaction.
238     /// @param transactionId Transaction ID.
239     function executeTransaction(uint transactionId)
240         public
241         notExecuted(transactionId)
242     {
243         if (isConfirmed(transactionId)) {
244             Transaction tx = transactions[transactionId];
245             tx.executed = true;
246             if (tx.destination.call.value(tx.value)(tx.data))
247                 Execution(transactionId);
248             else {
249                 ExecutionFailure(transactionId);
250                 tx.executed = false;
251             }
252         }
253     }
254 
255     /// @dev Returns the confirmation status of a transaction.
256     /// @param transactionId Transaction ID.
257     /// @return Confirmation status.
258     function isConfirmed(uint transactionId)
259         public
260         constant
261         returns (bool)
262     {
263         uint count = 0;
264         for (uint i=0; i<owners.length; i++) {
265             if (confirmations[transactionId][owners[i]])
266                 count += 1;
267             if (count == required)
268                 return true;
269         }
270     }
271 
272     /*
273      * Internal functions
274      */
275     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
276     /// @param destination Transaction target address.
277     /// @param value Transaction ether value.
278     /// @param data Transaction data payload.
279     /// @return Returns transaction ID.
280     function addTransaction(address destination, uint value, bytes data)
281         internal
282         notNull(destination)
283         returns (uint transactionId)
284     {
285         transactionId = transactionCount;
286         transactions[transactionId] = Transaction({
287             destination: destination,
288             value: value,
289             data: data,
290             executed: false
291         });
292         transactionCount += 1;
293         Submission(transactionId);
294     }
295 
296     /*
297      * Web3 call functions
298      */
299     /// @dev Returns number of confirmations of a transaction.
300     /// @param transactionId Transaction ID.
301     /// @return Number of confirmations.
302     function getConfirmationCount(uint transactionId)
303         public
304         constant
305         returns (uint count)
306     {
307         for (uint i=0; i<owners.length; i++)
308             if (confirmations[transactionId][owners[i]])
309                 count += 1;
310     }
311 
312     /// @dev Returns total number of transactions after filters are applied.
313     /// @param pending Include pending transactions.
314     /// @param executed Include executed transactions.
315     /// @return Total number of transactions after filters are applied.
316     function getTransactionCount(bool pending, bool executed)
317         public
318         constant
319         returns (uint count)
320     {
321         for (uint i=0; i<transactionCount; i++)
322             if (   pending && !transactions[i].executed
323                 || executed && transactions[i].executed)
324                 count += 1;
325     }
326 
327     /// @dev Returns list of owners.
328     /// @return List of owner addresses.
329     function getOwners()
330         public
331         constant
332         returns (address[])
333     {
334         return owners;
335     }
336 
337     /// @dev Returns array with owner addresses, which confirmed transaction.
338     /// @param transactionId Transaction ID.
339     /// @return Returns array of owner addresses.
340     function getConfirmations(uint transactionId)
341         public
342         constant
343         returns (address[] _confirmations)
344     {
345         address[] memory confirmationsTemp = new address[](owners.length);
346         uint count = 0;
347         uint i;
348         for (i=0; i<owners.length; i++)
349             if (confirmations[transactionId][owners[i]]) {
350                 confirmationsTemp[count] = owners[i];
351                 count += 1;
352             }
353         _confirmations = new address[](count);
354         for (i=0; i<count; i++)
355             _confirmations[i] = confirmationsTemp[i];
356     }
357 
358     /// @dev Returns list of transaction IDs in defined range.
359     /// @param from Index start position of transaction array.
360     /// @param to Index end position of transaction array.
361     /// @param pending Include pending transactions.
362     /// @param executed Include executed transactions.
363     /// @return Returns array of transaction IDs.
364     function getTransactionIds(uint from, uint to, bool pending, bool executed)
365         public
366         constant
367         returns (uint[] _transactionIds)
368     {
369         uint[] memory transactionIdsTemp = new uint[](transactionCount);
370         uint count = 0;
371         uint i;
372         for (i=0; i<transactionCount; i++)
373             if (   pending && !transactions[i].executed
374                 || executed && transactions[i].executed)
375             {
376                 transactionIdsTemp[count] = i;
377                 count += 1;
378             }
379         _transactionIds = new uint[](to - from);
380         for (i=from; i<to; i++)
381             _transactionIds[i - from] = transactionIdsTemp[i];
382     }
383 }