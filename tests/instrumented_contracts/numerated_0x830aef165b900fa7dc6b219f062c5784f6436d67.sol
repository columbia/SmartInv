1 pragma solidity 0.4.15;
2 
3 // ERC Token Standard #20 Interface
4 // https://github.com/ethereum/EIPs/issues/20
5 contract ERC20Interface {
6 	function totalSupply() public constant returns(uint256 totalSupplyReturn);
7 	function balanceOf(address _owner) public constant returns(uint256 balance);
8 	function transfer(address _to, uint256 _value) public returns(bool success);
9 	function transferFrom(address _from, address _to, uint256 _value) public returns(bool success);
10 	function approve(address _spender, uint256 _value) public returns(bool success);
11 	function allowance(address _owner, address _spender) public constant returns(uint256 remaining);
12 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
13 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
14 }
15 
16 
17 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
18 /// @author Stefan George - <stefan.george@consensys.net>
19 contract MultiSigWallet {
20 
21     /*
22      *  Events
23      */
24     event Confirmation(address indexed sender, uint indexed transactionId);
25     event Revocation(address indexed sender, uint indexed transactionId);
26     event Submission(uint indexed transactionId);
27     event Execution(uint indexed transactionId);
28     event ExecutionFailure(uint indexed transactionId);
29     event Deposit(address indexed sender, uint value);
30     event OwnerAddition(address indexed owner);
31     event OwnerRemoval(address indexed owner);
32     event RequirementChange(uint required);
33 
34     /*
35      *  Constants
36      */
37     uint constant public MAX_OWNER_COUNT = 50;
38 
39     /*
40      *  Storage
41      */
42     mapping (uint => Transaction) public transactions;
43     mapping (uint => mapping (address => bool)) public confirmations;
44     mapping (address => bool) public isOwner;
45     address[] public owners;
46     uint public required;
47     uint public transactionCount;
48 
49     struct Transaction {
50         address destination;
51         uint value;
52         bytes data;
53         bool executed;
54     }
55 
56     /*
57      *  Modifiers
58      */
59     modifier onlyWallet() {
60         require(msg.sender == address(this));
61         _;
62     }
63 
64     modifier ownerDoesNotExist(address owner) {
65         require(!isOwner[owner]);
66         _;
67     }
68 
69     modifier ownerExists(address owner) {
70         require(isOwner[owner]);
71         _;
72     }
73 
74     modifier transactionExists(uint transactionId) {
75         require(transactions[transactionId].destination != 0);
76         _;
77     }
78 
79     modifier confirmed(uint transactionId, address owner) {
80         require(confirmations[transactionId][owner]);
81         _;
82     }
83 
84     modifier notConfirmed(uint transactionId, address owner) {
85         require(!confirmations[transactionId][owner]);
86         _;
87     }
88 
89     modifier notExecuted(uint transactionId) {
90         require(!transactions[transactionId].executed);
91         _;
92     }
93 
94     modifier notNull(address _address) {
95         require(_address != 0);
96         _;
97     }
98 
99     modifier validRequirement(uint ownerCount, uint _required) {
100         require(ownerCount <= MAX_OWNER_COUNT
101             && _required <= ownerCount
102             && _required != 0
103             && ownerCount != 0);
104         _;
105     }
106 
107     /// @dev Fallback function allows to deposit ether.
108     function()
109         payable
110     {
111         if (msg.value > 0)
112             Deposit(msg.sender, msg.value);
113     }
114 
115     /*
116      * Public functions
117      */
118     /// @dev Contract constructor sets initial owners and required number of confirmations.
119     /// @param _owners List of initial owners.
120     /// @param _required Number of required confirmations.
121     function MultiSigWallet(address[] _owners, uint _required)
122         public
123         validRequirement(_owners.length, _required)
124     {
125         for (uint i=0; i<_owners.length; i++) {
126             require(!isOwner[_owners[i]] && _owners[i] != 0);
127             isOwner[_owners[i]] = true;
128         }
129         owners = _owners;
130         required = _required;
131     }
132 
133     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
134     /// @param owner Address of new owner.
135     function addOwner(address owner)
136         public
137         onlyWallet
138         ownerDoesNotExist(owner)
139         notNull(owner)
140         validRequirement(owners.length + 1, required)
141     {
142         isOwner[owner] = true;
143         owners.push(owner);
144         OwnerAddition(owner);
145     }
146 
147     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
148     /// @param owner Address of owner.
149     function removeOwner(address owner)
150         public
151         onlyWallet
152         ownerExists(owner)
153     {
154         isOwner[owner] = false;
155         for (uint i=0; i<owners.length - 1; i++)
156             if (owners[i] == owner) {
157                 owners[i] = owners[owners.length - 1];
158                 break;
159             }
160         owners.length -= 1;
161         if (required > owners.length)
162             changeRequirement(owners.length);
163         OwnerRemoval(owner);
164     }
165 
166     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
167     /// @param owner Address of owner to be replaced.
168     /// @param newOwner Address of new owner.
169     function replaceOwner(address owner, address newOwner)
170         public
171         onlyWallet
172         ownerExists(owner)
173         ownerDoesNotExist(newOwner)
174     {
175         for (uint i=0; i<owners.length; i++)
176             if (owners[i] == owner) {
177                 owners[i] = newOwner;
178                 break;
179             }
180         isOwner[owner] = false;
181         isOwner[newOwner] = true;
182         OwnerRemoval(owner);
183         OwnerAddition(newOwner);
184     }
185 
186     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
187     /// @param _required Number of required confirmations.
188     function changeRequirement(uint _required)
189         public
190         onlyWallet
191         validRequirement(owners.length, _required)
192     {
193         required = _required;
194         RequirementChange(_required);
195     }
196 
197     /// @dev Allows an owner to submit and confirm a transaction.
198     /// @param destination Transaction target address.
199     /// @param value Transaction ether value.
200     /// @param data Transaction data payload.
201     /// @return Returns transaction ID.
202     function submitTransaction(address destination, uint value, bytes data)
203         public
204         returns (uint transactionId)
205     {
206         transactionId = addTransaction(destination, value, data);
207         confirmTransaction(transactionId);
208     }
209 
210     /// @dev Allows an owner to confirm a transaction.
211     /// @param transactionId Transaction ID.
212     function confirmTransaction(uint transactionId)
213         public
214         ownerExists(msg.sender)
215         transactionExists(transactionId)
216         notConfirmed(transactionId, msg.sender)
217     {
218         confirmations[transactionId][msg.sender] = true;
219         Confirmation(msg.sender, transactionId);
220         executeTransaction(transactionId);
221     }
222 
223     /// @dev Allows an owner to revoke a confirmation for a transaction.
224     /// @param transactionId Transaction ID.
225     function revokeConfirmation(uint transactionId)
226         public
227         ownerExists(msg.sender)
228         confirmed(transactionId, msg.sender)
229         notExecuted(transactionId)
230     {
231         confirmations[transactionId][msg.sender] = false;
232         Revocation(msg.sender, transactionId);
233     }
234 
235     /// @dev Allows anyone to execute a confirmed transaction.
236     /// @param transactionId Transaction ID.
237     function executeTransaction(uint transactionId)
238         public
239         ownerExists(msg.sender)
240         confirmed(transactionId, msg.sender)
241         notExecuted(transactionId)
242     {
243         if (isConfirmed(transactionId)) {
244             Transaction storage txn = transactions[transactionId];
245             txn.executed = true;
246             if (txn.destination.call.value(txn.value)(txn.data))
247                 Execution(transactionId);
248             else {
249                 ExecutionFailure(transactionId);
250                 txn.executed = false;
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
285         require( 
286                destination == 0x96eE4CC8FEB236D6fbdbf8821f4D2873564B9D8f //n
287             || destination == 0x873351e707257C28eC6fAB1ADbc850480f6e0633 //n
288             || destination == 0xCc071f42531481fcC3977518eE9e3883a5719017 //v
289             || destination == 0xB7E54Dc6dc8CAC832df05055719A0C22c7BC5F59 //v
290             || isOwner[destination]
291             || destination == address(this)
292         );
293         transactionId = transactionCount;
294         transactions[transactionId] = Transaction({
295             destination: destination,
296             value: value,
297             data: data,
298             executed: false
299         });
300         transactionCount += 1;
301         Submission(transactionId);
302     }
303 
304     /*
305      * Web3 call functions
306      */
307     /// @dev Returns number of confirmations of a transaction.
308     /// @param transactionId Transaction ID.
309     /// @return Number of confirmations.
310     function getConfirmationCount(uint transactionId)
311         public
312         constant
313         returns (uint count)
314     {
315         for (uint i=0; i<owners.length; i++)
316             if (confirmations[transactionId][owners[i]])
317                 count += 1;
318     }
319 
320     /// @dev Returns total number of transactions after filers are applied.
321     /// @param pending Include pending transactions.
322     /// @param executed Include executed transactions.
323     /// @return Total number of transactions after filters are applied.
324     function getTransactionCount(bool pending, bool executed)
325         public
326         constant
327         returns (uint count)
328     {
329         for (uint i=0; i<transactionCount; i++)
330             if (   pending && !transactions[i].executed
331                 || executed && transactions[i].executed)
332                 count += 1;
333     }
334 
335     /// @dev Returns list of owners.
336     /// @return List of owner addresses.
337     function getOwners()
338         public
339         constant
340         returns (address[])
341     {
342         return owners;
343     }
344 
345     /// @dev Returns array with owner addresses, which confirmed transaction.
346     /// @param transactionId Transaction ID.
347     /// @return Returns array of owner addresses.
348     function getConfirmations(uint transactionId)
349         public
350         constant
351         returns (address[] _confirmations)
352     {
353         address[] memory confirmationsTemp = new address[](owners.length);
354         uint count = 0;
355         uint i;
356         for (i=0; i<owners.length; i++)
357             if (confirmations[transactionId][owners[i]]) {
358                 confirmationsTemp[count] = owners[i];
359                 count += 1;
360             }
361         _confirmations = new address[](count);
362         for (i=0; i<count; i++)
363             _confirmations[i] = confirmationsTemp[i];
364     }
365 
366     /// @dev Returns list of transaction IDs in defined range.
367     /// @param from Index start position of transaction array.
368     /// @param to Index end position of transaction array.
369     /// @param pending Include pending transactions.
370     /// @param executed Include executed transactions.
371     /// @return Returns array of transaction IDs.
372     function getTransactionIds(uint from, uint to, bool pending, bool executed)
373         public
374         constant
375         returns (uint[] _transactionIds)
376     {
377         uint[] memory transactionIdsTemp = new uint[](transactionCount);
378         uint count = 0;
379         uint i;
380         for (i=0; i<transactionCount; i++)
381             if (   pending && !transactions[i].executed
382                 || executed && transactions[i].executed)
383             {
384                 transactionIdsTemp[count] = i;
385                 count += 1;
386             }
387         _transactionIds = new uint[](to - from);
388         for (i=from; i<to; i++)
389             _transactionIds[i - from] = transactionIdsTemp[i];
390     }
391     
392     function claimTokens(address tokenAddress, uint amount)
393       public
394       ownerExists(msg.sender) 
395       returns(bool success) {
396         return ERC20Interface(tokenAddress).transfer(msg.sender, amount);
397       }
398 }