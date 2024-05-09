1 /**
2  * Developed by The Flowchain Foundation
3  *
4  * The Flowchain tokens (FLC v2) smart contract
5  */
6 pragma solidity 0.5.16;
7 
8 /**
9  * @title Ownable
10  * @dev The Ownable contract has an owner address, and provides basic authorization control
11  * functions, this simplifies the implementation of "user permissions".
12  */
13 contract Ownable {
14     address public owner;
15     address public newOwner;
16 
17     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19     constructor() public {
20         owner = msg.sender;
21         newOwner = address(0);
22     }
23 
24     modifier onlyOwner() {
25         require(msg.sender == owner);
26         _;
27     }
28 
29     modifier onlyNewOwner() {
30         require(msg.sender != address(0));
31         require(msg.sender == newOwner);
32         _;
33     }
34     
35     function isOwner(address account) public view returns (bool) {
36         if( account == owner ){
37             return true;
38         }
39         else {
40             return false;
41         }
42     }
43 
44     function transferOwnership(address _newOwner) public onlyOwner {
45         require(_newOwner != address(0));
46         newOwner = _newOwner;
47     }
48 
49     function acceptOwnership() public onlyNewOwner {
50         emit OwnershipTransferred(owner, newOwner);        
51         owner = newOwner;
52         newOwner = address(0);
53     }
54 }
55 
56 /**
57  * @title Pausable
58  * @dev The Pausable can pause and unpause the token transfers.
59  */
60 contract Pausable is Ownable {
61     event Paused(address account);
62     event Unpaused(address account);
63 
64     bool private _paused;
65 
66     constructor () internal {
67         _paused = false;
68     }    
69 
70     /**
71      * @return true if the contract is paused, false otherwise.
72      */
73     function paused() public view returns (bool) {
74         return _paused;
75     }
76 
77     /**
78      * @dev Modifier to make a function callable only when the contract is not paused.
79      */
80     modifier whenNotPaused() {
81         require(!_paused);
82         _;
83     }
84 
85     /**
86      * @dev Modifier to make a function callable only when the contract is paused.
87      */
88     modifier whenPaused() {
89         require(_paused);
90         _;
91     }
92 
93     /**
94      * @dev called by the owner to pause, triggers stopped state
95      */
96     function pause() public onlyOwner whenNotPaused {
97         _paused = true;
98         emit Paused(msg.sender);
99     }
100 
101     /**
102      * @dev called by the owner to unpause, returns to normal state
103      */
104     function unpause() public onlyOwner whenPaused {
105         _paused = false;
106         emit Unpaused(msg.sender);
107     }
108 }
109 
110 /**
111  * @title The mintable FLC tokens.
112  */
113 contract Mintable {
114     /**
115      * @dev Mint a amount of tokens and the funds to the user.
116      */
117     function mintToken(address to, uint256 amount) public returns (bool success);  
118 
119     /**
120      * @dev Setup a mintable address that can mint or mine tokens.
121      */    
122     function setupMintableAddress(address _mintable) public returns (bool success);
123 }
124 
125 /**
126  * @title The off-chain issuable FLC tokens.
127  */
128 contract OffchainIssuable {
129     /**
130      * The minimal withdraw ammount.
131      */
132     uint256 public MIN_WITHDRAW_AMOUNT = 100;
133 
134     /**
135      * @dev Suspend the issuance of new tokens.
136      * Once set to false, '_isIssuable' can never be set to 'true' again.
137      */
138     function setMinWithdrawAmount(uint256 amount) public returns (bool success);
139 
140     /**
141      * @dev Resume the issuance of new tokens.
142      * Once set to false, '_isIssuable' can never be set to 'true' again.
143      */
144     function getMinWithdrawAmount() public view returns (uint256 amount);
145 
146     /**
147      * @dev Returns the amount of tokens redeemed to `_owner`.
148      * @param _owner The address from which the amount will be retrieved
149      * @return The amount
150      */
151     function amountRedeemOf(address _owner) public view returns (uint256 amount);
152 
153     /**
154      * @dev Returns the amount of tokens withdrawn by `_owner`.
155      * @param _owner The address from which the amount will be retrieved
156      * @return The amount
157      */
158     function amountWithdrawOf(address _owner) public view returns (uint256 amount);
159 
160     /**
161      * @dev Redeem the value of tokens to the address 'msg.sender'
162      * @param to The user that will receive the redeemed token.
163      * @param amount Number of tokens to redeem.
164      */
165     function redeem(address to, uint256 amount) external returns (bool success);
166 
167     /**
168      * @dev The user withdraw API.
169      * @param amount Number of tokens to redeem.
170      */
171     function withdraw(uint256 amount) public returns (bool success);   
172 }
173 
174 /**
175  * @dev The ERC20 standard as defined in the EIP.
176  */
177 contract Token {
178     /**
179      * @dev The total amount of tokens.
180      */
181     uint256 public totalSupply;
182 
183     /**
184      * @dev Returns the amount of tokens owned by `account`.
185      * @param _owner The address from which the balance will be retrieved
186      * @return The balance
187      */
188     function balanceOf(address _owner) public view returns (uint256 balance);
189 
190     /**
191      * @dev send `_value` token to `_to` from `msg.sender`
192      * @param _to The address of the recipient
193      * @param _value The amount of token to be transferred
194      * @return Whether the transfer was successful or not
195      *
196      * Emits a {Transfer} event.
197      */
198     function transfer(address _to, uint256 _value) public returns (bool success);
199 
200     /**
201      * @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
202      * @param _from The address of the sender
203      * @param _to The address of the recipient
204      * @param _value The amount of token to be transferred
205      * @return Whether the transfer was successful or not
206      */
207     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
208 
209     /**
210      * @notice `msg.sender` approves `_addr` to spend `_value` tokens
211      * @param _spender The address of the account able to transfer the tokens
212      * @param _value The amount of wei to be approved for transfer
213      * @return Whether the approval was successful or not
214      */
215     function approve(address _spender, uint256 _value) public returns (bool success);
216 
217     /**
218      * @param _owner The address of the account owning tokens
219      * @param _spender The address of the account able to transfer the tokens
220      * @return Amount of remaining tokens allowed to spent
221      */
222     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
223 
224     event Transfer(address indexed _from, address indexed _to, uint256 _value);
225     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
226 }
227 
228 /**
229  * @dev The ERC20 standard implementation of FLC. 
230  */
231 contract StandardToken is Token {
232     uint256 constant private MAX_UINT256 = 2**256 - 1;
233     mapping (address => uint256) public balances;
234     mapping (address => mapping (address => uint256)) public allowed;
235 
236     function transfer(address _to, uint256 _value) public returns (bool success) {
237         require(balances[msg.sender] >= _value);
238         
239         // Ensure not overflow
240         require(balances[_to] + _value >= balances[_to]);
241         
242         balances[msg.sender] -= _value;
243         balances[_to] += _value;
244 
245         emit Transfer(msg.sender, _to, _value);
246         return true;
247     }
248 
249     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
250         uint256 allowance = allowed[_from][msg.sender];
251         require(balances[_from] >= _value && allowance >= _value);
252         
253         // Ensure not overflow
254         require(balances[_to] + _value >= balances[_to]);          
255 
256         balances[_from] -= _value;
257         balances[_to] += _value;
258 
259         if (allowance < MAX_UINT256) {
260             allowed[_from][msg.sender] -= _value;
261         }  
262 
263         emit Transfer(_from, _to, _value);
264         return true; 
265     }
266 
267     function balanceOf(address account) public view returns (uint256) {
268         return balances[account];
269     }
270 
271     function approve(address _spender, uint256 _value) public returns (bool success) {
272         allowed[msg.sender][_spender] = _value;
273         emit Approval(msg.sender, _spender, _value);
274         return true;
275     }
276 
277     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
278       return allowed[_owner][_spender];
279     }
280 }
281 
282 
283 /**
284  * @dev Extension of ERC-20 that adds off-chain issuable and mintable tokens.
285  * It allows miners to mint (create) new FLC tokens.
286  *
287  * At construction, the contract `_mintableAddress` is the only token minter.
288  */
289 contract FlowchainToken is StandardToken, Mintable, OffchainIssuable, Ownable, Pausable {
290 
291     /* Public variables of the token */
292     string public name = "Flowchain";
293     string public symbol = "FLC";    
294     uint8 public decimals = 18;
295     string public version = "2.0";
296     address public mintableAddress;
297     address public multiSigWallet;
298 
299     bool internal _isIssuable;
300 
301     event Freeze(address indexed account);
302     event Unfreeze(address indexed account);
303 
304     mapping (address => uint256) private _amountMinted;
305     mapping (address => uint256) private _amountRedeem;
306     mapping (address => bool) public frozenAccount;
307 
308     modifier notFrozen(address _account) {
309         require(!frozenAccount[_account]);
310         _;
311     }
312 
313     constructor(address _multiSigWallet) public {
314         // 1 billion tokens + 18 decimals
315         totalSupply = 10**27;
316 
317         // The multisig wallet that holds the unissued tokens
318         multiSigWallet = _multiSigWallet;
319 
320         // Give the multisig wallet all initial tokens (unissued tokens)
321         balances[multiSigWallet] = totalSupply;  
322 
323         emit Transfer(address(0), multiSigWallet, totalSupply);
324     }
325 
326     function transfer(address to, uint256 value) public notFrozen(msg.sender) whenNotPaused returns (bool) {
327         return super.transfer(to, value);
328     }   
329 
330     function transferFrom(address from, address to, uint256 value) public notFrozen(from) whenNotPaused returns (bool) {
331         return super.transferFrom(from, to, value);
332     }
333 
334     /**
335      * @dev Suspend the issuance of new tokens.
336      * Once set to false, '_isIssuable' can never be set to 'true' again.
337      */
338     function suspendIssuance() external onlyOwner {
339         _isIssuable = false;
340     }
341 
342     /**
343      * @dev Resume the issuance of new tokens.
344      * Once set to false, '_isIssuable' can never be set to 'true' again.
345      */
346     function resumeIssuance() external onlyOwner {
347         _isIssuable = true;
348     }
349 
350     /**
351      * @return bool return 'true' if tokens can still be issued by the issuer, 
352      * 'false' if they can't anymore.
353      */
354     function isIssuable() public view returns (bool success) {
355         return _isIssuable;
356     }
357 
358     /**
359      * @dev Returns the amount of tokens redeemed to `_owner`.
360      * @param _owner The address from which the amount will be retrieved
361      * @return The amount
362      */
363     function amountRedeemOf(address _owner) public view returns (uint256 amount) {
364         return _amountRedeem[_owner];
365     }
366 
367     /**
368      * @dev Returns the amount of tokens withdrawn by `_owner`.
369      * @param _owner The address from which the amount will be retrieved
370      * @return The amount
371      */
372     function amountWithdrawOf(address _owner) public view returns (uint256 amount) {
373         return _amountMinted[_owner];
374     }
375 
376     /**
377      * @dev Redeem user mintable tokens. Only the mining contract can redeem tokens.
378      * @param to The user that will receive the redeemed token.     
379      * @param amount The amount of tokens to be withdrawn
380      * @return The result of the redeem
381      */
382     function redeem(address to, uint256 amount) external returns (bool success) {
383         require(msg.sender == mintableAddress);    
384         require(_isIssuable == true);
385         require(amount > 0);
386 
387         // The total amount of redeem tokens to the user.
388         _amountRedeem[to] += amount;
389 
390         // Mint new tokens and send the funds to the account `mintableAddress`
391         // Users can withdraw funds.
392         mintToken(mintableAddress, amount);
393 
394         return true;
395     }
396 
397     /**
398      * @dev The user can withdraw his minted tokens.
399      * @param amount The amount of tokens to be withdrawn
400      * @return The result of the withdraw
401      */
402     function withdraw(uint256 amount) public returns (bool success) {
403         require(_isIssuable == true);
404 
405         // Safety check
406         require(amount > 0);        
407         require(amount <= _amountRedeem[msg.sender]);
408         require(amount >= MIN_WITHDRAW_AMOUNT);
409 
410         // Transfer the amount of tokens in the mining contract `mintableAddress` to the user account
411         require(balances[mintableAddress] >= amount);
412 
413         // The balance of the user redeemed tokens.
414         _amountRedeem[msg.sender] -= amount;
415 
416         // Keep track of the tokens minted by the user.
417         _amountMinted[msg.sender] += amount;
418 
419         balances[mintableAddress] -= amount;
420         balances[msg.sender] += amount;
421         
422         emit Transfer(mintableAddress, msg.sender, amount);
423         return true;               
424     }
425 
426     /**
427      * @dev Setup the contract address that can mint tokens
428      * @param _mintable The address of the smart contract
429      * @return The result of the setup
430      */
431     function setupMintableAddress(address _mintable) public onlyOwner returns (bool success) {
432         mintableAddress = _mintable;
433         return true;
434     }
435 
436     /**
437      * @dev Mint an amount of tokens and transfer to the user
438      * @param to The address of the user who will receive the tokens
439      * @param amount The amount of rewarded tokens
440      * @return The result of token transfer
441      */
442     function mintToken(address to, uint256 amount) public returns (bool success) {
443         require(msg.sender == mintableAddress);
444         require(balances[multiSigWallet] >= amount);
445 
446         balances[multiSigWallet] -= amount;
447         balances[to] += amount;
448 
449         emit Transfer(multiSigWallet, to, amount);
450         return true;
451     }
452 
453     /**
454      * @dev Suspend the issuance of new tokens.
455      * Once set to false, '_isIssuable' can never be set to 'true' again.
456      */
457     function setMinWithdrawAmount(uint256 amount) public onlyOwner returns (bool success) {
458         require(amount > 0);
459         MIN_WITHDRAW_AMOUNT = amount;
460         return true;
461     }
462 
463     /**
464      * @dev Resume the issuance of new tokens.
465      * Once set to false, '_isIssuable' can never be set to 'true' again.
466      */
467     function getMinWithdrawAmount() public view returns (uint256 amount) {
468         return MIN_WITHDRAW_AMOUNT;
469     }
470 
471     /**
472      * @dev Freeze an user
473      * @param account The address of the user who will be frozen
474      * @return The result of freezing an user
475      */
476     function freezeAccount(address account) public onlyOwner returns (bool) {
477         require(!frozenAccount[account]);
478         frozenAccount[account] = true;
479         emit Freeze(account);
480         return true;
481     }
482 
483     /**
484      * @dev Unfreeze an user
485      * @param account The address of the user who will be unfrozen
486      * @return The result of unfreezing an user
487      */
488     function unfreezeAccount(address account) public onlyOwner returns (bool) {
489         require(frozenAccount[account]);
490         frozenAccount[account] = false;
491         emit Unfreeze(account);
492         return true;
493     }
494 
495     /**
496      * @dev This function makes it easy to get the creator of the tokens
497      * @return The address of token creator
498      */
499     function getCreator() external view returns (address) {
500         return owner;
501     }
502 
503     /**
504      * @dev This function makes it easy to get the mintableAddress
505      * @return The address of token creator
506      */
507     function getMintableAddress() external view returns (address) {
508         return mintableAddress;
509     }
510 }