1 pragma solidity ^0.4.11;
2 
3 contract ERC20Interface {
4     // Get the total token supply
5     function totalSupply() constant returns (uint256);
6  
7     // Get the account balance of another account with address _owner
8     function balanceOf(address _owner) constant returns (uint256 balance);
9  
10     // Send _value amount of tokens to address _to
11     function transfer(address _to, uint256 _value) returns (bool success);
12  
13     // Send _value amount of tokens from address _from to address _to
14     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
15  
16     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
17     // If this function is called again it overwrites the current allowance with _value.
18     // this function is required for some DEX functionality
19     function approve(address _spender, uint256 _value) returns (bool success);
20  
21     // Returns the amount which _spender is still allowed to withdraw from _owner
22     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
23  
24     // Triggered when tokens are transferred.
25     event Transfer(address indexed _from, address indexed _to, uint256 _value);
26  
27     // Triggered whenever approve(address _spender, uint256 _value) is called.
28     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
29 }
30  
31 contract RoseCoin is ERC20Interface {
32     uint8 public constant decimals = 5;
33     string public constant symbol = "RSC";
34     string public constant name = "RoseCoin";
35 
36     uint public _level = 0;
37     bool public _selling = true;
38     uint public _totalSupply = 10 ** 14;
39     uint public _originalBuyPrice = 10 ** 10;
40     uint public _minimumBuyAmount = 10 ** 17;
41    
42     // Owner of this contract
43     address public owner;
44  
45     // Balances for each account
46     mapping(address => uint256) balances;
47  
48     // Owner of account approves the transfer of an amount to another account
49     mapping(address => mapping (address => uint256)) allowed;
50     
51     uint public _icoSupply = _totalSupply;
52     uint[4] public ratio = [12, 10, 10, 13];
53     uint[4] public threshold = [95000000000000, 85000000000000, 0, 80000000000000];
54 
55     // Functions with this modifier can only be executed by the owner
56     modifier onlyOwner() {
57         if (msg.sender != owner) {
58             revert();
59         }
60         _;
61     }
62 
63     modifier onlyNotOwner() {
64         if (msg.sender == owner) {
65             revert();
66         }
67         _;
68     }
69 
70     modifier thresholdAll() {
71         if (!_selling || msg.value < _minimumBuyAmount || _icoSupply <= threshold[3]) { //
72             revert();
73         }
74         _;
75     }
76  
77     // Constructor
78     function RoseCoin() {
79         owner = msg.sender;
80         balances[owner] = _totalSupply;
81     }
82  
83     function totalSupply() constant returns (uint256) {
84         return _totalSupply;
85     }
86  
87     // What is the balance of a particular account?
88     function balanceOf(address _owner) constant returns (uint256) {
89         return balances[_owner];
90     }
91  
92     // Transfer the balance from sender's account to another account
93     function transfer(address _to, uint256 _amount) returns (bool) {
94         if (balances[msg.sender] >= _amount
95             && _amount > 0
96             && balances[_to] + _amount > balances[_to]) {
97             balances[msg.sender] -= _amount;
98             balances[_to] += _amount;
99             Transfer(msg.sender, _to, _amount);
100             return true;
101         } else {
102             return false;
103         }
104     }
105  
106     // Send _value amount of tokens from address _from to address _to
107     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
108     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
109     // fees in sub-currencies; the command should fail unless the _from account has
110     // deliberately authorized the sender of the message via some mechanism; we propose
111     // these standardized APIs for approval:
112     function transferFrom(
113         address _from,
114         address _to,
115         uint256 _amount
116     ) returns (bool) {
117         if (balances[_from] >= _amount
118             && allowed[_from][msg.sender] >= _amount
119             && _amount > 0
120             && balances[_to] + _amount > balances[_to]) {
121             balances[_from] -= _amount;
122             allowed[_from][msg.sender] -= _amount;
123             balances[_to] += _amount;
124             Transfer(_from, _to, _amount);
125             return true;
126         } else {
127             return false;
128         }
129     }
130  
131     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
132     // If this function is called again it overwrites the current allowance with _value.
133     function approve(address _spender, uint256 _amount) returns (bool) {
134         allowed[msg.sender][_spender] = _amount;
135         Approval(msg.sender, _spender, _amount);
136         return true;
137     }
138  
139     function allowance(address _owner, address _spender) constant returns (uint256) {
140         return allowed[_owner][_spender];
141     }
142 
143 
144     function toggleSale() onlyOwner {
145         _selling = !_selling;
146     }
147 
148     function setBuyPrice(uint newBuyPrice) onlyOwner {
149         _originalBuyPrice = newBuyPrice;
150     }
151     
152     // Buy RoseCoin by sending Ether    
153     function buy() payable onlyNotOwner thresholdAll returns (uint256 amount) {
154         amount = 0;
155         uint remain = msg.value / _originalBuyPrice;
156         
157         while (remain > 0 && _level < 3) { //
158             remain = remain * ratio[_level] / ratio[_level+1];
159             if (_icoSupply <= remain + threshold[_level]) {
160                 remain = (remain + threshold[_level] - _icoSupply) * ratio[_level+1] / ratio[_level];
161                 amount += _icoSupply - threshold[_level];
162                 _icoSupply = threshold[_level];
163                 _level += 1;
164             }
165             else {
166                 _icoSupply -= remain;
167                 amount += remain;
168                 remain = 0;
169                 break;
170             }
171         }
172         
173         if (balances[owner] < amount)
174             revert();
175         
176         if (remain > 0) {
177             remain *= _originalBuyPrice;
178             msg.sender.transfer(remain);
179         }
180         
181         balances[owner] -= amount;
182         balances[msg.sender] += amount;
183         owner.transfer(msg.value - remain);
184         Transfer(owner, msg.sender, amount);
185         return amount;
186     }
187     
188     // Owner withdraws Ether in contract
189     function withdraw() onlyOwner returns (bool) {
190         return owner.send(this.balance);
191     }
192 }
193 
194 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
195 /// @author Stefan George - <stefan.george@consensys.net>
196 contract MultiSigWallet {
197 
198     event Confirmation(address sender, bytes32 transactionHash);
199     event Revocation(address sender, bytes32 transactionHash);
200     event Submission(bytes32 transactionHash);
201     event Execution(bytes32 transactionHash);
202     event Deposit(address sender, uint value);
203     event OwnerAddition(address owner);
204     event OwnerRemoval(address owner);
205     event RequiredUpdate(uint required);
206     event CoinCreation(address coin);
207 
208     mapping (bytes32 => Transaction) public transactions;
209     mapping (bytes32 => mapping (address => bool)) public confirmations;
210     mapping (address => bool) public isOwner;
211     address[] owners;
212     bytes32[] transactionList;
213     uint public required;
214 
215     struct Transaction {
216         address destination;
217         uint value;
218         bytes data;
219         uint nonce;
220         bool executed;
221     }
222 
223     modifier onlyWallet() {
224         if (msg.sender != address(this))
225             revert();
226         _;
227     }
228 
229     modifier signaturesFromOwners(bytes32 transactionHash, uint8[] v, bytes32[] rs) {
230         for (uint i=0; i<v.length; i++)
231             if (!isOwner[ecrecover(transactionHash, v[i], rs[i], rs[v.length + i])])
232                 revert();
233         _;
234     }
235 
236     modifier ownerDoesNotExist(address owner) {
237         if (isOwner[owner])
238             revert();
239         _;
240     }
241 
242     modifier ownerExists(address owner) {
243         if (!isOwner[owner])
244             revert();
245         _;
246     }
247 
248     modifier confirmed(bytes32 transactionHash, address owner) {
249         if (!confirmations[transactionHash][owner])
250             revert();
251         _;
252     }
253 
254     modifier notConfirmed(bytes32 transactionHash, address owner) {
255         if (confirmations[transactionHash][owner])
256             revert();
257         _;
258     }
259 
260     modifier notExecuted(bytes32 transactionHash) {
261         if (transactions[transactionHash].executed)
262             revert();
263         _;
264     }
265 
266     modifier notNull(address destination) {
267         if (destination == 0)
268             revert();
269         _;
270     }
271 
272     modifier validRequired(uint _ownerCount, uint _required) {
273         if (   _required > _ownerCount
274             || _required == 0
275             || _ownerCount == 0)
276             revert();
277         _;
278     }
279 
280     function addOwner(address owner)
281         external
282         onlyWallet
283         ownerDoesNotExist(owner)
284     {
285         isOwner[owner] = true;
286         owners.push(owner);
287         OwnerAddition(owner);
288     }
289 
290     function removeOwner(address owner)
291         external
292         onlyWallet
293         ownerExists(owner)
294     {
295         isOwner[owner] = false;
296         for (uint i=0; i<owners.length - 1; i++)
297             if (owners[i] == owner) {
298                 owners[i] = owners[owners.length - 1];
299                 break;
300             }
301         owners.length -= 1;
302         if (required > owners.length)
303             updateRequired(owners.length);
304         OwnerRemoval(owner);
305     }
306 
307     function updateRequired(uint _required)
308         public
309         onlyWallet
310         validRequired(owners.length, _required)
311     {
312         required = _required;
313         RequiredUpdate(_required);
314     }
315 
316     function addTransaction(address destination, uint value, bytes data, uint nonce)
317         private
318         notNull(destination)
319         returns (bytes32 transactionHash)
320     {
321         transactionHash = sha3(destination, value, data, nonce);
322         if (transactions[transactionHash].destination == 0) {
323             transactions[transactionHash] = Transaction({
324                 destination: destination,
325                 value: value,
326                 data: data,
327                 nonce: nonce,
328                 executed: false
329             });
330             transactionList.push(transactionHash);
331             Submission(transactionHash);
332         }
333     }
334 
335     function submitTransaction(address destination, uint value, bytes data, uint nonce)
336         external
337         ownerExists(msg.sender)
338         returns (bytes32 transactionHash)
339     {
340         transactionHash = addTransaction(destination, value, data, nonce);
341         confirmTransaction(transactionHash);
342     }
343 
344     function submitTransactionWithSignatures(address destination, uint value, bytes data, uint nonce, uint8[] v, bytes32[] rs)
345         external
346         ownerExists(msg.sender)
347         returns (bytes32 transactionHash)
348     {
349         transactionHash = addTransaction(destination, value, data, nonce);
350         confirmTransactionWithSignatures(transactionHash, v, rs);
351     }
352 
353     function addConfirmation(bytes32 transactionHash, address owner)
354         private
355         notConfirmed(transactionHash, owner)
356     {
357         confirmations[transactionHash][owner] = true;
358         Confirmation(owner, transactionHash);
359     }
360 
361     function confirmTransaction(bytes32 transactionHash)
362         public
363         ownerExists(msg.sender)
364     {
365         addConfirmation(transactionHash, msg.sender);
366         executeTransaction(transactionHash);
367     }
368 
369     function confirmTransactionWithSignatures(bytes32 transactionHash, uint8[] v, bytes32[] rs)
370         public
371         signaturesFromOwners(transactionHash, v, rs)
372     {
373         for (uint i=0; i<v.length; i++)
374             addConfirmation(transactionHash, ecrecover(transactionHash, v[i], rs[i], rs[i + v.length]));
375         executeTransaction(transactionHash);
376     }
377 
378     function executeTransaction(bytes32 transactionHash)
379         public
380         notExecuted(transactionHash)
381     {
382         if (isConfirmed(transactionHash)) {
383             Transaction storage txn = transactions[transactionHash]; //
384             txn.executed = true;
385             if (!txn.destination.call.value(txn.value)(txn.data))
386                 revert();
387             Execution(transactionHash);
388         }
389     }
390 
391     function revokeConfirmation(bytes32 transactionHash)
392         external
393         ownerExists(msg.sender)
394         confirmed(transactionHash, msg.sender)
395         notExecuted(transactionHash)
396     {
397         confirmations[transactionHash][msg.sender] = false;
398         Revocation(msg.sender, transactionHash);
399     }
400 
401     function MultiSigWallet(address[] _owners, uint _required)
402         validRequired(_owners.length, _required)
403     {
404         for (uint i=0; i<_owners.length; i++)
405             isOwner[_owners[i]] = true;
406         owners = _owners;
407         required = _required;
408     }
409 
410     function()
411         payable
412     {
413         if (msg.value > 0)
414             Deposit(msg.sender, msg.value);
415     }
416 
417     function isConfirmed(bytes32 transactionHash)
418         public
419         constant
420         returns (bool)
421     {
422         uint count = 0;
423         for (uint i=0; i<owners.length; i++)
424             if (confirmations[transactionHash][owners[i]])
425                 count += 1;
426             if (count == required)
427                 return true;
428     }
429 
430     function confirmationCount(bytes32 transactionHash)
431         external
432         constant
433         returns (uint count)
434     {
435         for (uint i=0; i<owners.length; i++)
436             if (confirmations[transactionHash][owners[i]])
437                 count += 1;
438     }
439 
440     function filterTransactions(bool isPending)
441         private
442         constant
443         returns (bytes32[] _transactionList)
444     {
445         bytes32[] memory _transactionListTemp = new bytes32[](transactionList.length);
446         uint count = 0;
447         for (uint i=0; i<transactionList.length; i++)
448             if (   isPending && !transactions[transactionList[i]].executed
449                 || !isPending && transactions[transactionList[i]].executed)
450             {
451                 _transactionListTemp[count] = transactionList[i];
452                 count += 1;
453             }
454         _transactionList = new bytes32[](count);
455         for (i=0; i<count; i++)
456             if (_transactionListTemp[i] > 0)
457                 _transactionList[i] = _transactionListTemp[i];
458     }
459 
460     function getPendingTransactions()
461         external
462         constant
463         returns (bytes32[])
464     {
465         return filterTransactions(true);
466     }
467 
468     function getExecutedTransactions()
469         external
470         constant
471         returns (bytes32[])
472     {
473         return filterTransactions(false);
474     }
475     
476     function createCoin()
477         external
478         onlyWallet
479     {
480         CoinCreation(new RoseCoin());
481     }
482 }