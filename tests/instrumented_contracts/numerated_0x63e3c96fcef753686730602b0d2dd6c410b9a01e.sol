1 pragma solidity ^0.4.21;
2 
3 /// @title Multisignature wallet - Allows multiple parties to agree on send ERC20 token transactions before execution.
4 /// @author Based on code by Stefan George - <stefan.george@consensys.net>
5 
6 /*
7  * ERC20 interface
8  * see https://github.com/ethereum/EIPs/issues/20
9  */
10 contract ERC20
11 {
12   function balanceOf(address who) public view returns (uint);
13   function transfer(address to, uint value) public returns (bool ok);
14 }
15 
16 /**
17  * @title SafeMath
18  * @dev Math operations with safety checks that throw on error
19  */
20 library SafeMath 
21 {
22   /**
23   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
24   */
25   function sub(uint a, uint b) 
26     internal 
27     pure 
28     returns (uint) 
29   {
30     assert(b <= a);
31     return a - b;
32   }
33 
34   /**
35   * @dev Adds two numbers, throws on overflow.
36   */
37   function add(uint a, uint b) 
38     internal 
39     pure 
40     returns (uint) 
41   {
42     uint c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 
48 contract MultiSigWalletTokenLimit
49 {
50   using SafeMath for uint;
51 
52   /*
53    *  Events
54    */
55   event Confirmation(address indexed sender, uint indexed transaction_id);
56   event Revocation(address indexed sender, uint indexed transaction_id);
57   event Submission(uint indexed transaction_id);
58   event Execution(uint indexed transaction_id);
59   event ExecutionFailure(uint indexed transaction_id);
60   event TokensReceived(address indexed from, uint value);
61   event Transfer(address indexed to, uint indexed value);
62   event CurrentPeriodChanged(uint indexed current_period, uint indexed current_transferred, uint indexed current_limit);
63 
64   /*
65    * Structures
66    */
67   struct Transaction
68   {
69     address to;
70     uint value;
71     bool executed;
72   }
73 
74   struct Period
75   {
76     uint timestamp;
77     uint current_limit;
78     uint limit;
79   }
80 
81   /*
82   *  Storage
83   */
84   mapping (uint => Transaction) public transactions;
85   mapping (uint => mapping (address => bool)) public confirmations;
86   mapping (address => bool) public is_owner;
87   address[] public owners;
88   uint public required;
89   uint public transaction_count;
90   ERC20 public erc20_contract;  //address of the ERC20 tokens contract
91   mapping (uint => Period) public periods;
92   uint public period_count;
93   uint public current_period;
94   uint public current_transferred;  //amount of transferred tokens in the current period
95 
96   /*
97   *  Modifiers
98   */
99   modifier ownerExists(address owner) 
100   {
101     require(is_owner[owner]);
102     _;
103   }
104 
105   modifier transactionExists(uint transaction_id) 
106   {
107     require(transactions[transaction_id].to != 0);
108     _;
109   }
110 
111   modifier confirmed(uint transaction_id, address owner)
112   {
113     require(confirmations[transaction_id][owner]);
114     _;
115   }
116 
117   modifier notConfirmed(uint transaction_id, address owner)
118   {
119     require(!confirmations[transaction_id][owner]);
120     _;
121   }
122 
123   modifier notExecuted(uint transaction_id)
124   {
125     require(!transactions[transaction_id].executed);
126     _;
127   }
128 
129   modifier ownerOrWallet(address owner)
130   {
131     require (msg.sender == address(this) || is_owner[owner]);
132     _;
133   }
134 
135   modifier notNull(address _address)
136   {
137     require(_address != 0);
138     _;
139   }
140 
141   /// @dev Fallback function: don't accept ETH
142   function()
143     public
144     payable
145   {
146     revert();
147   }
148 
149   /*
150   * Public functions
151   */
152   /// @dev Contract constructor sets initial owners, required number of confirmations, initial periods' parameters and token address.
153   /// @param _owners List of initial owners.
154   /// @param _required Number of required confirmations.
155   /// @param _timestamps Timestamps of initial periods.
156   /// @param _limits Limits of initial periods. The length of _limits must be the same as _timestamps.
157   /// @param _erc20_contract Address of the ERC20 tokens contract.
158   function MultiSigWalletTokenLimit(address[] _owners, uint _required, uint[] _timestamps, uint[] _limits, ERC20 _erc20_contract)
159     public
160   {
161     for (uint i = 0; i < _owners.length; i++)
162     {
163       require(!is_owner[_owners[i]] && _owners[i] != 0);
164       is_owner[_owners[i]] = true;
165     }
166     owners = _owners;
167     required = _required;
168 
169     periods[0].timestamp = 2**256 - 1;
170     periods[0].limit = 2**256 - 1;
171     uint total_limit = 0;
172     for (i = 0; i < _timestamps.length; i++)
173     {
174       periods[i + 1].timestamp = _timestamps[i];
175       periods[i + 1].current_limit = _limits[i];
176       total_limit = total_limit.add(_limits[i]);
177       periods[i + 1].limit = total_limit;
178     }
179     period_count = 1 + _timestamps.length;
180     current_period = 0;
181     if (_timestamps.length > 0)
182       current_period = 1;
183     current_transferred = 0;
184 
185     erc20_contract = _erc20_contract;
186   }
187 
188   /// @dev Allows an owner to submit and confirm a send tokens transaction.
189   /// @param to Address to transfer tokens.
190   /// @param value Amout of tokens to transfer.
191   /// @return Returns transaction ID.
192   function submitTransaction(address to, uint value)
193     public
194     notNull(to)
195     returns (uint transaction_id)
196   {
197     transaction_id = addTransaction(to, value);
198     confirmTransaction(transaction_id);
199   }
200 
201   /// @dev Allows an owner to confirm a transaction.
202   /// @param transaction_id Transaction ID.
203   function confirmTransaction(uint transaction_id)
204     public
205     ownerExists(msg.sender)
206     transactionExists(transaction_id)
207     notConfirmed(transaction_id, msg.sender)
208   {
209     confirmations[transaction_id][msg.sender] = true;
210     emit Confirmation(msg.sender, transaction_id);
211     executeTransaction(transaction_id);
212   }
213 
214   /// @dev Allows an owner to revoke a confirmation for a transaction.
215   /// @param transaction_id Transaction ID.
216   function revokeConfirmation(uint transaction_id)
217     public
218     ownerExists(msg.sender)
219     confirmed(transaction_id, msg.sender)
220     notExecuted(transaction_id)
221   {
222     confirmations[transaction_id][msg.sender] = false;
223     emit Revocation(msg.sender, transaction_id);
224   }
225 
226   function executeTransaction(uint transaction_id)
227     public
228     ownerExists(msg.sender)
229     confirmed(transaction_id, msg.sender)
230     notExecuted(transaction_id)
231   {
232     if (isConfirmed(transaction_id))
233     {
234       Transaction storage txn = transactions[transaction_id];
235       txn.executed = true;
236       if (transfer(txn.to, txn.value))
237         emit Execution(transaction_id);
238       else
239       {
240         emit ExecutionFailure(transaction_id);
241         txn.executed = false;
242       }
243     }
244   }
245 
246   /// @dev Returns the confirmation status of a transaction.
247   /// @param transaction_id Transaction ID.
248   /// @return Confirmation status.
249   function isConfirmed(uint transaction_id)
250     public
251     view
252     returns (bool)
253   {
254     uint count = 0;
255     for (uint i = 0; i < owners.length; i++)
256     {
257       if (confirmations[transaction_id][owners[i]])
258         ++count;
259     if (count >= required)
260       return true;
261     }
262   }
263 
264   /*
265    * Internal functions
266    */
267   /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
268   /// @param to Address to transfer tokens.
269   /// @param value Amout of tokens to transfer.
270   /// @return Returns transaction ID.
271   function addTransaction(address to, uint value)
272     internal
273     returns (uint transaction_id)
274   {
275     transaction_id = transaction_count;
276     transactions[transaction_id] = Transaction({
277       to: to,
278       value: value,
279       executed: false
280     });
281     ++transaction_count;
282     emit Submission(transaction_id);
283   }
284 
285   /*
286    * Web3 call functions
287    */
288   /// @dev Returns number of confirmations of a transaction.
289   /// @param transaction_id Transaction ID.
290   /// @return Number of confirmations.
291   function getConfirmationCount(uint transaction_id)
292     public
293     view
294     returns (uint count)
295   {
296     for (uint i = 0; i < owners.length; i++)
297       if (confirmations[transaction_id][owners[i]])
298         ++count;
299   }
300 
301   /// @dev Returns total number of transactions after filers are applied.
302   /// @param pending Include pending transactions.
303   /// @param executed Include executed transactions.
304   /// @return Total number of transactions after filters are applied.
305   function getTransactionCount(bool pending, bool executed)
306     public
307     view
308     returns (uint count)
309   {
310     for (uint i = 0; i < transaction_count; i++)
311       if (pending && !transactions[i].executed
312         || executed && transactions[i].executed)
313         ++count;
314   }
315 
316   /// @dev Returns list of owners.
317   /// @return List of owner addresses.
318   function getOwners()
319     public
320     view
321     returns (address[])
322   {
323     return owners;
324   }
325 
326   /// @dev Returns array with owner addresses, which confirmed transaction.
327   /// @param transaction_id Transaction ID.
328   /// @return Returns array of owner addresses.
329   function getConfirmations(uint transaction_id)
330     public
331     view
332     returns (address[] _confirmations)
333   {
334     address[] memory confirmations_temp = new address[](owners.length);
335     uint count = 0;
336     uint i;
337     for (i = 0; i < owners.length; i++)
338       if (confirmations[transaction_id][owners[i]])
339       {
340         confirmations_temp[count] = owners[i];
341         ++count;
342       }
343       _confirmations = new address[](count);
344       for (i = 0; i < count; i++)
345         _confirmations[i] = confirmations_temp[i];
346   }
347 
348   /// @dev Returns list of transaction IDs in defined range.
349   /// @param from Index start position of transaction array.
350   /// @param to Index end position of transaction array.
351   /// @param pending Include pending transactions.
352   /// @param executed Include executed transactions.
353   /// @return Returns array of transaction IDs.
354   function getTransactionIds(uint from, uint to, bool pending, bool executed)
355     public
356     view
357     returns (uint[] _transaction_ids)
358   {
359     uint[] memory transaction_ids_temp = new uint[](transaction_count);
360     uint count = 0;
361     uint i;
362     for (i = 0; i < transaction_count; i++)
363       if (pending && !transactions[i].executed
364         || executed && transactions[i].executed)
365       {
366         transaction_ids_temp[count] = i;
367         ++count;
368       }
369       _transaction_ids = new uint[](to - from);
370       for (i = from; i < to; i++)
371         _transaction_ids[i - from] = transaction_ids_temp[i];
372   }
373 
374   /// @dev Fallback function which is called by tokens contract after transferring tokens to this wallet.
375   /// @param from Source address of the transfer.
376   /// @param value Amount of received ERC20 tokens.
377   function tokenFallback(address from, uint value, bytes)
378     public
379   {
380     require(msg.sender == address(erc20_contract));
381     emit TokensReceived(from, value);
382   }
383 
384   /// @dev Returns balance of the wallet
385   function getWalletBalance()
386     public
387     view
388     returns(uint)
389   { 
390     return erc20_contract.balanceOf(this);
391   }
392 
393   /// @dev Updates current perriod: looking for a period with a minimmum date(timestamp) that is greater than now.
394   function updateCurrentPeriod()
395     public
396     ownerOrWallet(msg.sender)
397   {
398     uint new_period = 0;
399     for (uint i = 1; i < period_count; i++)
400       if (periods[i].timestamp > now && periods[i].timestamp < periods[new_period].timestamp)
401         new_period = i;
402     if (new_period != current_period)
403     {
404       current_period = new_period;
405       emit CurrentPeriodChanged(current_period, current_transferred, periods[current_period].limit);
406     }
407   }
408 
409   /// @dev Transfers ERC20 tokens from the wallet to a given address
410   /// @param to Address to transfer.
411   /// @param value Amount of tokens to transfer.
412   function transfer(address to, uint value) 
413     internal
414     returns (bool)
415   {
416     updateCurrentPeriod();
417     require(value <= getWalletBalance() && current_transferred.add(value) <= periods[current_period].limit);
418 
419     if (erc20_contract.transfer(to, value)) 
420     {
421       current_transferred = current_transferred.add(value);
422       emit Transfer(to, value);
423       return true;
424     }
425 
426     return false;
427   }
428 
429 }