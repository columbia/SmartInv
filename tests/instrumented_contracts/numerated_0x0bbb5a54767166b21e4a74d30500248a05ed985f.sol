1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title The STT Token contract.
5  * 
6  * By Nikita Fuchs
7  * Credit: Taking ideas from BAT token, NET token and Nimiq token.
8  */
9 
10 /**
11  * @title Safe math operations that throw error on overflow.
12  *
13  * Credit: Taking ideas from FirstBlood token
14  */
15 library SafeMath {
16 
17     /** 
18      * @dev Safely add two numbers.
19      *
20      * @param x First operant.
21      * @param y Second operant.
22      * @return The result of x+y.
23      */
24     function add(uint256 x, uint256 y)
25     internal pure
26     returns(uint256) {
27         uint256 z = x + y;
28         assert((z >= x) && (z >= y));
29         return z;
30     }
31 
32     /** 
33      * @dev Safely substract two numbers.
34      *
35      * @param x First operant.
36      * @param y Second operant.
37      * @return The result of x-y.
38      */
39     function sub(uint256 x, uint256 y)
40     internal pure
41     returns(uint256) {
42         assert(x >= y);
43         uint256 z = x - y;
44         return z;
45     }
46 
47     /** 
48      * @dev Safely multiply two numbers.
49      *
50      * @param x First operant.
51      * @param y Second operant.
52      * @return The result of x*y.
53      */
54     function mul(uint256 x, uint256 y)
55     internal pure
56     returns(uint256) {
57         uint256 z = x * y;
58         assert((x == 0) || (z/x == y));
59         return z;
60     }
61 }
62 
63 /**
64  * @title The abstract ERC-20 Token Standard definition.
65  *
66  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
67  */
68 contract Token {
69     /// @dev Returns the total token supply.
70     uint256 public totalSupply;
71 
72     function balanceOf(address _owner) public view returns (uint256 balance);
73     function transfer(address _to, uint256 _value) public returns (bool success);
74     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
75     function approve(address _spender, uint256 _value) public returns (bool success);
76     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
77 
78     /// @dev MUST trigger when tokens are transferred, including zero value transfers.
79     event Transfer(address indexed _from, address indexed _to, uint256 _value);
80 
81     /// @dev MUST trigger on any successful call to approve(address _spender, uint256 _value).
82     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
83 }
84 
85 /**
86  * @title Default implementation of the ERC-20 Token Standard.
87  */
88 contract StandardToken is Token {
89 
90     mapping (address => uint256) balances;
91     mapping (address => mapping (address => uint256)) allowed;
92 
93     /**
94      * @dev Transfers _value amount of tokens to address _to, and MUST fire the Transfer event. 
95      * @dev The function SHOULD throw if the _from account balance does not have enough tokens to spend.
96      *
97      * @dev A token contract which creates new tokens SHOULD trigger a Transfer event with the _from address set to 0x0 when tokens are created.
98      *
99      * Note Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event.
100      *
101      * @param _to The receiver of the tokens.
102      * @param _value The amount of tokens to send.
103      * @return True on success, false otherwise.
104      */
105     function transfer(address _to, uint256 _value)
106     public
107     returns (bool success) {
108         if (balances[msg.sender] >= _value && _value > 0 && balances[_to] + _value > balances[_to]) {
109             balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
110             balances[_to] = SafeMath.add(balances[_to], _value);
111             emit Transfer(msg.sender, _to, _value);
112             return true;
113         } else {
114             return false;
115         }
116     }
117 
118     /**
119      * @dev Transfers _value amount of tokens from address _from to address _to, and MUST fire the Transfer event.
120      *
121      * @dev The transferFrom method is used for a withdraw workflow, allowing contracts to transfer tokens on your behalf. 
122      * @dev This can be used for example to allow a contract to transfer tokens on your behalf and/or to charge fees in 
123      * @dev sub-currencies. The function SHOULD throw unless the _from account has deliberately authorized the sender of 
124      * @dev the message via some mechanism.
125      *
126      * Note Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event.
127      *
128      * @param _from The sender of the tokens.
129      * @param _to The receiver of the tokens.
130      * @param _value The amount of tokens to send.
131      * @return True on success, false otherwise.
132      */
133     function transferFrom(address _from, address _to, uint256 _value)
134     public
135     returns (bool success) {
136         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0 && balances[_to] + _value > balances[_to]) {
137             balances[_to] = SafeMath.add(balances[_to], _value);
138             balances[_from] = SafeMath.sub(balances[_from], _value);
139             allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
140             emit Transfer(_from, _to, _value);
141             return true;
142         } else {
143             return false;
144         }
145     }
146 
147     /**
148      * @dev Returns the account balance of another account with address _owner.
149      *
150      * @param _owner The address of the account to check.
151      * @return The account balance.
152      */
153     function balanceOf(address _owner)
154     public view
155     returns (uint256 balance) {
156         return balances[_owner];
157     }
158 
159     /**
160      * @dev Allows _spender to withdraw from your account multiple times, up to the _value amount. 
161      * @dev If this function is called again it overwrites the current allowance with _value.
162      *
163      * @dev NOTE: To prevent attack vectors like the one described in [1] and discussed in [2], clients 
164      * @dev SHOULD make sure to create user interfaces in such a way that they set the allowance first 
165      * @dev to 0 before setting it to another value for the same spender. THOUGH The contract itself 
166      * @dev shouldn't enforce it, to allow backwards compatilibilty with contracts deployed before.
167      * @dev [1] https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/
168      * @dev [2] https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169      *
170      * @param _spender The address which will spend the funds.
171      * @param _value The amount of tokens to be spent.
172      * @return True on success, false otherwise.
173      */
174     function approve(address _spender, uint256 _value)
175     public
176     returns (bool success) {
177         allowed[msg.sender][_spender] = _value;
178         emit Approval(msg.sender, _spender, _value);
179         return true;
180     }
181 
182     /**
183      * @dev Returns the amount which _spender is still allowed to withdraw from _owner.
184      *
185      * @param _owner The address of the sender.
186      * @param _spender The address of the receiver.
187      * @return The allowed withdrawal amount.
188      */
189     function allowance(address _owner, address _spender)
190     public view
191     returns (uint256 remaining) {
192         return allowed[_owner][_spender];
193     }
194 }
195 
196 contract RelocationToken {
197     // function of possible new contract to recieve tokenbalance to relocate - to be protected by msg.sender == StarambaToken
198     function recieveRelocation(address _creditor, uint _balance) external returns (bool);
199 }
200 
201 
202 
203  /*is StandardToken */
204 contract StarambaToken is StandardToken {
205 
206     // Token metadata
207     string public constant name = "STARAMBA.Token";
208     string public constant symbol = "STT";
209     uint256 public constant decimals = 18;
210     string public constant version = "1";
211 
212     uint256 public TOKEN_CREATION_CAP = 1000 * (10**6) * 10**decimals; // 1000 million STTs
213     uint256 public constant TOKEN_MIN = 1 * 10**decimals;              // 1 STT
214 
215     address public STTadmin1;      // First administrator for multi-sig mechanism
216     address public STTadmin2;      // Second administrator for multi-sig mechanism
217 
218     // Contracts current state (transactions still paused during sale or already publicly available)
219     bool public transactionsActive;
220 
221     // Indicate if the token is in relocation mode
222     bool public relocationActive;
223     address public newTokenContractAddress;
224 
225     // How often was the supply adjusted ? (See STT Whitepaper Version 1.0 from 23. May 2018 )
226     uint8 supplyAdjustmentCount = 0;
227 
228     // Keep track of holders and icoBuyers
229     mapping (address => bool) public isHolder; // track if a user is a known token holder to the smart contract - important for payouts later
230     address[] public holders;                  // array of all known holders - important for payouts later
231 
232     // Store the hashes of admins' msg.data
233     mapping (address => bytes32) private multiSigHashes;
234 
235     // Declare vendor keys
236     mapping (address => bool) public vendors;
237 
238     // Count amount of vendors for easier verification of correct contract deployment
239     uint8 public vendorCount;
240 
241     // Events used for logging
242     event LogDeliverSTT(address indexed _to, uint256 _value);
243     //event Log
244 
245     modifier onlyVendor() {
246         require(vendors[msg.sender] == true);
247         _;
248     }
249 
250     modifier isTransferable() {
251         require (transactionsActive == true);
252         _;
253     }
254 
255     modifier onlyOwner() {
256         // check if transaction sender is admin.
257         require (msg.sender == STTadmin1 || msg.sender == STTadmin2);
258         // if yes, store his msg.data. 
259         multiSigHashes[msg.sender] = keccak256(msg.data);
260         // check if his stored msg.data hash equals to the one of the other admin
261         if ((multiSigHashes[STTadmin1]) == (multiSigHashes[STTadmin2])) {
262             // if yes, both admins agreed - continue.
263             _;
264 
265             // Reset hashes after successful execution
266             multiSigHashes[STTadmin1] = 0x0;
267             multiSigHashes[STTadmin2] = 0x0;
268         } else {
269             // if not (yet), return.
270             return;
271         }
272     }
273 
274     /**
275      * @dev Create a new STTToken contract.
276      *
277      *  _admin1 The first admin account that owns this contract.
278      *  _admin2 The second admin account that owns this contract.
279      *  _vendors List of exactly 10 addresses that are allowed to deliver tokens.
280      */
281     constructor(address _admin1, address _admin2, address[] _vendors)
282     public
283     {
284         // Check if the parameters make sense
285 
286         // admin1 and admin2 address must be set and must be different
287         require (_admin1 != 0x0);
288         require (_admin2 != 0x0);
289         require (_admin1 != _admin2);
290 
291         // 10 vendor instances for delivering token purchases
292         require (_vendors.length == 10);
293 
294         totalSupply = 0;
295 
296         // define state
297         STTadmin1 = _admin1;
298         STTadmin2 = _admin2;
299 
300         for (uint8 i = 0; i < _vendors.length; i++){
301             vendors[_vendors[i]] = true;
302             vendorCount++;
303         }
304     }
305 
306     // Overridden method to check for end of fundraising before allowing transfer of tokens
307     function transfer(address _to, uint256 _value)
308     public
309     isTransferable // Only allow token transfer after the fundraising has ended
310     returns (bool success)
311     {
312         bool result = super.transfer(_to, _value);
313         if (result) {
314             trackHolder(_to); // track the owner for later payouts
315         }
316         return result;
317     }
318 
319     // Overridden method to check for end of fundraising before allowing transfer of tokens
320     function transferFrom(address _from, address _to, uint256 _value)
321     public
322     isTransferable // Only allow token transfer after the fundraising has ended
323     returns (bool success)
324     {
325         bool result = super.transferFrom(_from, _to, _value);
326         if (result) {
327             trackHolder(_to); // track the owner for later payouts
328         }
329         return result;
330     }
331 
332     // Allow for easier balance checking
333     function getBalanceOf(address _owner)
334     public
335     view
336     returns (uint256 _balance)
337     {
338         return balances[_owner];
339     }
340 
341     // Perform an atomic swap between two token contracts 
342     function relocate()
343     external 
344     {
345         // Check if relocation was activated
346         require (relocationActive == true);
347         
348         // Define new token contract is
349         RelocationToken newSTT = RelocationToken(newTokenContractAddress);
350 
351         // Burn the old balance
352         uint256 balance = balances[msg.sender];
353         balances[msg.sender] = 0;
354 
355         // Perform the relocation of balances to new contract
356         require(newSTT.recieveRelocation(msg.sender, balance));
357     }
358 
359     // Allows to figure out the amount of known token holders
360     function getHolderCount()
361     public
362     view
363     returns (uint256 _holderCount)
364     {
365         return holders.length;
366     }
367 
368     // Allows for easier retrieval of holder by array index
369     function getHolder(uint256 _index)
370     public
371     view
372     returns (address _holder)
373     {
374         return holders[_index];
375     }
376 
377     function trackHolder(address _to)
378     private
379     returns (bool success)
380     {
381         // Check if the recipient is a known token holder
382         if (isHolder[_to] == false) {
383             // if not, add him to the holders array and mark him as a known holder
384             holders.push(_to);
385             isHolder[_to] = true;
386         }
387         return true;
388     }
389 
390 
391     /// @dev delivers STT tokens from Leondra (Leondrino Exchange Germany)
392     function deliverTokens(address _buyer, uint256 _amount)
393     external
394     onlyVendor
395     {
396         require(_amount >= TOKEN_MIN);
397 
398         uint256 checkedSupply = SafeMath.add(totalSupply, _amount);
399         require(checkedSupply <= TOKEN_CREATION_CAP);
400 
401         // Adjust the balance
402         uint256 oldBalance = balances[_buyer];
403         balances[_buyer] = SafeMath.add(oldBalance, _amount);
404         totalSupply = checkedSupply;
405 
406         trackHolder(_buyer);
407 
408         // Log the creation of these tokens
409         emit LogDeliverSTT(_buyer, _amount);
410     }
411 
412     /// @dev Creates new STT tokens
413     function deliverTokensBatch(address[] _buyer, uint256[] _amount)
414     external
415     onlyVendor
416     {
417         require(_buyer.length == _amount.length);
418 
419         for (uint8 i = 0 ; i < _buyer.length; i++) {
420             require(_amount[i] >= TOKEN_MIN);
421             require(_buyer[i] != 0x0);
422 
423             uint256 checkedSupply = SafeMath.add(totalSupply, _amount[i]);
424             require(checkedSupply <= TOKEN_CREATION_CAP);
425 
426             // Adjust the balance
427             uint256 oldBalance = balances[_buyer[i]];
428             balances[_buyer[i]] = SafeMath.add(oldBalance, _amount[i]);
429             totalSupply = checkedSupply;
430 
431             trackHolder(_buyer[i]);
432 
433             // Log the creation of these tokens
434             emit LogDeliverSTT(_buyer[i], _amount[i]);
435         }
436     }
437 
438     // Allow / Deny transfer of tokens
439     function transactionSwitch(bool _transactionsActive) 
440     external 
441     onlyOwner
442     {
443         transactionsActive = _transactionsActive;
444     }
445 
446     // For eventual later moving to another token contract
447     function relocationSwitch(bool _relocationActive, address _newTokenContractAddress) 
448     external 
449     onlyOwner
450     {
451         if (_relocationActive) {
452             require(_newTokenContractAddress != 0x0);
453         } else {
454             require(_newTokenContractAddress == 0x0);
455         }
456         relocationActive = _relocationActive;
457         newTokenContractAddress = _newTokenContractAddress;
458     }
459 
460     // Adjust the cap according to the white paper terms (See STT Whitepaper Version 1.0 from 23. May 2018 )
461     function adjustCap()
462     external
463     onlyOwner
464     {
465         require (supplyAdjustmentCount < 4);
466         TOKEN_CREATION_CAP = SafeMath.add(TOKEN_CREATION_CAP, 50 * (10**6) * 10**decimals); // 50 million STTs
467         supplyAdjustmentCount++;
468     }
469 
470     // Burn function - name indicating the burn of ALL owner's tokens
471     function burnWholeBalance()
472     external
473     {
474         require(balances[msg.sender] > 0);
475         totalSupply = SafeMath.sub(totalSupply, balances[msg.sender]);
476         balances[msg.sender] = 0;
477     }
478 
479 }