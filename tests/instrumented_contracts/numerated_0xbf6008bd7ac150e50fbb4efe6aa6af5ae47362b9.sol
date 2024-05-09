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
31 contract DatCoin is ERC20Interface {
32     uint8 public constant decimals = 5;
33     string public constant symbol = "DTC";
34     string public constant name = "DatCoin";
35 
36     uint public _totalSupply = 10 ** 14;
37     uint public _originalBuyPrice = 10 ** 10;
38     uint public _minimumBuyAmount = 10 ** 17;
39     uint public _thresholdOne = 9 * (10 ** 13);
40     uint public _thresholdTwo = 85 * (10 ** 12);
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
51     // Functions with this modifier can only be executed by the owner
52     modifier onlyOwner() {
53         if (msg.sender != owner) {
54             revert();
55         }
56         _;
57     }
58 
59     modifier thresholdTwo() {
60         if (msg.value < _minimumBuyAmount || balances[owner] <= _thresholdTwo) {
61             revert();
62         }
63         _;
64     }
65  
66     // Constructor
67     function DatCoin() {
68         owner = msg.sender;
69         balances[owner] = _totalSupply;
70     }
71  
72     function totalSupply() constant returns (uint256) {
73         return _totalSupply;
74     }
75  
76     // What is the balance of a particular account?
77     function balanceOf(address _owner) constant returns (uint256) {
78         return balances[_owner];
79     }
80  
81     // Transfer the balance from sender's account to another account
82     function transfer(address _to, uint256 _amount) returns (bool) {
83         if (balances[msg.sender] >= _amount
84             && _amount > 0
85             && balances[_to] + _amount > balances[_to]) {
86             balances[msg.sender] -= _amount;
87             balances[_to] += _amount;
88             Transfer(msg.sender, _to, _amount);
89             return true;
90         } else {
91             return false;
92         }
93     }
94  
95     // Send _value amount of tokens from address _from to address _to
96     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
97     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
98     // fees in sub-currencies; the command should fail unless the _from account has
99     // deliberately authorized the sender of the message via some mechanism; we propose
100     // these standardized APIs for approval:
101     function transferFrom(
102         address _from,
103         address _to,
104         uint256 _amount
105     ) returns (bool) {
106         if (balances[_from] >= _amount
107             && allowed[_from][msg.sender] >= _amount
108             && _amount > 0
109             && balances[_to] + _amount > balances[_to]) {
110             balances[_from] -= _amount;
111             allowed[_from][msg.sender] -= _amount;
112             balances[_to] += _amount;
113             Transfer(_from, _to, _amount);
114             return true;
115         } else {
116             return false;
117         }
118     }
119  
120     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
121     // If this function is called again it overwrites the current allowance with _value.
122     function approve(address _spender, uint256 _amount) returns (bool) {
123         allowed[msg.sender][_spender] = _amount;
124         Approval(msg.sender, _spender, _amount);
125         return true;
126     }
127  
128     function allowance(address _owner, address _spender) constant returns (uint256) {
129         return allowed[_owner][_spender];
130     }
131     
132     // Buy DatCoin by sending Ether
133     function buy() payable thresholdTwo returns (uint256 amount) {
134         uint value = msg.value;
135         amount = value / _originalBuyPrice;
136         
137         if (balances[owner] <= _thresholdOne + amount) {
138             uint temp = 0;
139             if (balances[owner] > _thresholdOne)
140                 temp = balances[owner] - _thresholdOne;
141             amount = temp + (amount - temp) * 10 / 13;
142             if (balances[owner] < amount) {
143                 temp = (amount - balances[owner]) * (_originalBuyPrice * 13 / 10);
144                 msg.sender.transfer(temp);
145                 amount = balances[owner];
146                 value -= temp;
147             }
148         }
149 
150         owner.transfer(value);
151         balances[msg.sender] += amount;
152         balances[owner] -= amount;
153         Transfer(owner, msg.sender, amount);
154         return amount;
155     }
156     
157     // Owner withdraws Ether in contract
158     function withdraw() onlyOwner returns (bool) {
159         return owner.send(this.balance);
160     }
161 }
162 
163 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
164 /// @author Stefan George - <stefan.george@consensys.net>
165 contract MultiSigWallet {
166 
167     event Confirmation(address sender, bytes32 transactionHash);
168     event Revocation(address sender, bytes32 transactionHash);
169     event Submission(bytes32 transactionHash);
170     event Execution(bytes32 transactionHash);
171     event Deposit(address sender, uint value);
172     event OwnerAddition(address owner);
173     event OwnerRemoval(address owner);
174     event RequiredUpdate(uint required);
175     event CoinCreation(address coin);
176 
177     mapping (bytes32 => Transaction) public transactions;
178     mapping (bytes32 => mapping (address => bool)) public confirmations;
179     mapping (address => bool) public isOwner;
180     address[] owners;
181     bytes32[] transactionList;
182     uint public required;
183 
184     struct Transaction {
185         address destination;
186         uint value;
187         bytes data;
188         uint nonce;
189         bool executed;
190     }
191 
192     modifier onlyWallet() {
193         if (msg.sender != address(this))
194             revert();
195         _;
196     }
197 
198     modifier signaturesFromOwners(bytes32 transactionHash, uint8[] v, bytes32[] rs) {
199         for (uint i=0; i<v.length; i++)
200             if (!isOwner[ecrecover(transactionHash, v[i], rs[i], rs[v.length + i])])
201                 revert();
202         _;
203     }
204 
205     modifier ownerDoesNotExist(address owner) {
206         if (isOwner[owner])
207             revert();
208         _;
209     }
210 
211     modifier ownerExists(address owner) {
212         if (!isOwner[owner])
213             revert();
214         _;
215     }
216 
217     modifier confirmed(bytes32 transactionHash, address owner) {
218         if (!confirmations[transactionHash][owner])
219             revert();
220         _;
221     }
222 
223     modifier notConfirmed(bytes32 transactionHash, address owner) {
224         if (confirmations[transactionHash][owner])
225             revert();
226         _;
227     }
228 
229     modifier notExecuted(bytes32 transactionHash) {
230         if (transactions[transactionHash].executed)
231             revert();
232         _;
233     }
234 
235     modifier notNull(address destination) {
236         if (destination == 0)
237             revert();
238         _;
239     }
240 
241     modifier validRequired(uint _ownerCount, uint _required) {
242         if (   _required > _ownerCount
243             || _required == 0
244             || _ownerCount == 0)
245             revert();
246         _;
247     }
248 
249     function addOwner(address owner)
250         external
251         onlyWallet
252         ownerDoesNotExist(owner)
253     {
254         isOwner[owner] = true;
255         owners.push(owner);
256         OwnerAddition(owner);
257     }
258 
259     function removeOwner(address owner)
260         external
261         onlyWallet
262         ownerExists(owner)
263     {
264         isOwner[owner] = false;
265         for (uint i=0; i<owners.length - 1; i++)
266             if (owners[i] == owner) {
267                 owners[i] = owners[owners.length - 1];
268                 break;
269             }
270         owners.length -= 1;
271         if (required > owners.length)
272             updateRequired(owners.length);
273         OwnerRemoval(owner);
274     }
275 
276     function updateRequired(uint _required)
277         public
278         onlyWallet
279         validRequired(owners.length, _required)
280     {
281         required = _required;
282         RequiredUpdate(_required);
283     }
284 
285     function addTransaction(address destination, uint value, bytes data, uint nonce)
286         private
287         notNull(destination)
288         returns (bytes32 transactionHash)
289     {
290         transactionHash = sha3(destination, value, data, nonce);
291         if (transactions[transactionHash].destination == 0) {
292             transactions[transactionHash] = Transaction({
293                 destination: destination,
294                 value: value,
295                 data: data,
296                 nonce: nonce,
297                 executed: false
298             });
299             transactionList.push(transactionHash);
300             Submission(transactionHash);
301         }
302     }
303 
304     function submitTransaction(address destination, uint value, bytes data, uint nonce)
305         external
306         ownerExists(msg.sender)
307         returns (bytes32 transactionHash)
308     {
309         transactionHash = addTransaction(destination, value, data, nonce);
310         confirmTransaction(transactionHash);
311     }
312 
313     function submitTransactionWithSignatures(address destination, uint value, bytes data, uint nonce, uint8[] v, bytes32[] rs)
314         external
315         ownerExists(msg.sender)
316         returns (bytes32 transactionHash)
317     {
318         transactionHash = addTransaction(destination, value, data, nonce);
319         confirmTransactionWithSignatures(transactionHash, v, rs);
320     }
321 
322     function addConfirmation(bytes32 transactionHash, address owner)
323         private
324         notConfirmed(transactionHash, owner)
325     {
326         confirmations[transactionHash][owner] = true;
327         Confirmation(owner, transactionHash);
328     }
329 
330     function confirmTransaction(bytes32 transactionHash)
331         public
332         ownerExists(msg.sender)
333     {
334         addConfirmation(transactionHash, msg.sender);
335         executeTransaction(transactionHash);
336     }
337 
338     function confirmTransactionWithSignatures(bytes32 transactionHash, uint8[] v, bytes32[] rs)
339         public
340         signaturesFromOwners(transactionHash, v, rs)
341     {
342         for (uint i=0; i<v.length; i++)
343             addConfirmation(transactionHash, ecrecover(transactionHash, v[i], rs[i], rs[i + v.length]));
344         executeTransaction(transactionHash);
345     }
346 
347     function executeTransaction(bytes32 transactionHash)
348         public
349         notExecuted(transactionHash)
350     {
351         if (isConfirmed(transactionHash)) {
352             Transaction storage txn = transactions[transactionHash]; //
353             txn.executed = true;
354             if (!txn.destination.call.value(txn.value)(txn.data))
355                 revert();
356             Execution(transactionHash);
357         }
358     }
359 
360     function revokeConfirmation(bytes32 transactionHash)
361         external
362         ownerExists(msg.sender)
363         confirmed(transactionHash, msg.sender)
364         notExecuted(transactionHash)
365     {
366         confirmations[transactionHash][msg.sender] = false;
367         Revocation(msg.sender, transactionHash);
368     }
369 
370     function MultiSigWallet(address[] _owners, uint _required)
371         validRequired(_owners.length, _required)
372     {
373         for (uint i=0; i<_owners.length; i++)
374             isOwner[_owners[i]] = true;
375         owners = _owners;
376         required = _required;
377     }
378 
379     function()
380         payable
381     {
382         if (msg.value > 0)
383             Deposit(msg.sender, msg.value);
384     }
385 
386     function isConfirmed(bytes32 transactionHash)
387         public
388         constant
389         returns (bool)
390     {
391         uint count = 0;
392         for (uint i=0; i<owners.length; i++)
393             if (confirmations[transactionHash][owners[i]])
394                 count += 1;
395             if (count == required)
396                 return true;
397     }
398 
399     function confirmationCount(bytes32 transactionHash)
400         external
401         constant
402         returns (uint count)
403     {
404         for (uint i=0; i<owners.length; i++)
405             if (confirmations[transactionHash][owners[i]])
406                 count += 1;
407     }
408 
409     function filterTransactions(bool isPending)
410         private
411         constant
412         returns (bytes32[] _transactionList)
413     {
414         bytes32[] memory _transactionListTemp = new bytes32[](transactionList.length);
415         uint count = 0;
416         for (uint i=0; i<transactionList.length; i++)
417             if (   isPending && !transactions[transactionList[i]].executed
418                 || !isPending && transactions[transactionList[i]].executed)
419             {
420                 _transactionListTemp[count] = transactionList[i];
421                 count += 1;
422             }
423         _transactionList = new bytes32[](count);
424         for (i=0; i<count; i++)
425             if (_transactionListTemp[i] > 0)
426                 _transactionList[i] = _transactionListTemp[i];
427     }
428 
429     function getPendingTransactions()
430         external
431         constant
432         returns (bytes32[])
433     {
434         return filterTransactions(true);
435     }
436 
437     function getExecutedTransactions()
438         external
439         constant
440         returns (bytes32[])
441     {
442         return filterTransactions(false);
443     }
444     
445     function createCoin()
446         external
447         onlyWallet
448     {
449         CoinCreation(new DatCoin());
450     }
451 }