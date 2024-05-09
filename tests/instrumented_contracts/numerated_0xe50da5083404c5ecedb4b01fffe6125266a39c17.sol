1 pragma solidity ^0.4.24;
2 
3 
4 /// @title ERC-20 interface
5 /// @dev Full ERC-20 interface is described at https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md.
6 interface ERC20 {
7 
8     event Transfer(address indexed from, address indexed to, uint256 value);
9     event Approval(address indexed owner, address indexed spender, uint256 value);
10 
11     function transfer(address to, uint256 value) external returns (bool);
12     function transferFrom(address from, address to, uint256 value) external returns (bool);
13     function approve(address spender, uint256 value) external returns (bool);
14 
15     function totalSupply() external view returns (uint256);
16     function balanceOf(address owner) external view returns (uint256);
17     function allowance(address owner, address spender) external view returns (uint256);
18 }
19 
20 
21 /// @title ERC-677 (excluding ERC-20) interface
22 /// @dev Full ERC-677 interface is discussed at https://github.com/ethereum/EIPs/issues/677.
23 interface ERC677 {
24 
25     event Transfer(address indexed from, address indexed to, uint256 value, bytes data);
26 
27     function transferAndCall(address to, uint256 value, bytes data) external returns (bool);
28 }
29 
30 
31 /// @title ERC-677 mint/burn/claim extension interface
32 /// @dev Extension of ERC-677 interface for allowing using a token in Token Bridge.
33 interface ERC677Bridgeable {
34 
35     event Mint(address indexed receiver, uint256 value);
36     event Burn(address indexed burner, uint256 value);
37 
38     function mint(address receiver, uint256 value) external returns (bool);
39     function burn(uint256 value) external;
40     function claimTokens(address token, address to) external;
41 }
42 
43 
44 /// @title SafeMath
45 /// @dev Math operations with safety checks that throw on error.
46 library SafeMath {
47 
48     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49         if (a == 0) {
50             return 0;
51         }
52         uint256 c = a * b;
53         assert(c / a == b);
54         return c;
55     }
56 
57     function div(uint256 a, uint256 b) internal pure returns (uint256) {
58         // assert(b > 0); // Solidity automatically throws when dividing by 0
59         uint256 c = a / b;
60         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61         return c;
62     }
63 
64     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
65         assert(b <= a);
66         return a - b;
67     }
68 
69     function add(uint256 a, uint256 b) internal pure returns (uint256) {
70         uint256 c = a + b;
71         assert(c >= a);
72         return c;
73     }
74 }
75 
76 
77 /// @title SafeOwnable
78 /// @dev The SafeOwnable contract has an owner address, and provides basic authorization control
79 /// functions, this simplifies the implementation of "user permissions".
80 contract SafeOwnable {
81 
82     // EVENTS
83 
84     event OwnershipProposed(address indexed previousOwner, address indexed newOwner);
85     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
86 
87     // PUBLIC FUNCTIONS
88 
89     /// @dev The SafeOwnable constructor sets the original `owner` of the contract to the sender account.
90     constructor() internal {
91         _owner = msg.sender;
92         emit OwnershipTransferred(address(0), _owner);
93     }
94 
95     /// @dev Allows the current owner to propose control of the contract to a new owner.
96     /// @param newOwner The address to propose ownership to.
97     function proposeOwnership(address newOwner) public onlyOwner {
98         require(newOwner != address(0) && newOwner != _owner);
99         _ownerCandidate = newOwner;
100         emit OwnershipProposed(_owner, _ownerCandidate);
101     }
102 
103     /// @dev Allows the current owner candidate to accept proposed ownership and set actual owner of a contract.
104     function acceptOwnership() public onlyOwnerCandidate {
105         emit OwnershipTransferred(_owner, _ownerCandidate);
106         _owner = _ownerCandidate;
107         _ownerCandidate = address(0);
108     }
109 
110     /// @dev Returns the address of the owner.
111     function owner() public view returns (address) {
112         return _owner;
113     }
114 
115     /// @dev Returns the address of the owner candidate.
116     function ownerCandidate() public view returns (address) {
117         return _ownerCandidate;
118     }
119 
120     // MODIFIERS
121 
122     /// @dev Throws if called by any account other than the owner.
123     modifier onlyOwner() {
124         require(msg.sender == _owner);
125         _;
126     }
127 
128     /// @dev Throws if called by any account other than the owner candidate.
129     modifier onlyOwnerCandidate() {
130         require(msg.sender == _ownerCandidate);
131         _;
132     }
133 
134     // FIELDS
135 
136     address internal _owner;
137     address internal _ownerCandidate;
138 }
139 
140 
141 /// @title Standard ERC-20 token
142 /// @dev Implementation of the basic ERC-20 token.
143 contract TokenERC20 is ERC20 {
144     using SafeMath for uint256;
145 
146     // PUBLIC FUNCTIONS
147 
148     /// @dev Transfers tokens to a specified address.
149     /// @param to The address to transfer tokens to.
150     /// @param value The amount of tokens to be transferred.
151     /// @return A boolean that indicates if the operation was successful.
152     function transfer(address to, uint256 value) public returns (bool) {
153         _transfer(msg.sender, to, value);
154         return true;
155     }
156 
157     /// @dev Transfers tokens from one address to another.
158     /// @param from The address to transfer tokens from.
159     /// @param to The address to transfer tokens to.
160     /// @param value The amount of tokens to be transferred.
161     /// @return A boolean that indicates if the operation was successful.
162     function transferFrom(address from, address to, uint256 value) public returns (bool) {
163         _decreaseAllowance(from, msg.sender, value);
164         _transfer(from, to, value);
165         return true;
166     }
167 
168     /// @dev Approves a specified address to spend a specified amount of tokens on behalf of msg.sender.
169     /// Beware that changing an allowance with this method brings the risk that someone may use both the old
170     /// and the new allowance by an unfortunate transaction ordering. One possible solution to mitigate this
171     /// rare condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
172     /// https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
173     /// @param spender Address which will be allowed to spend the tokens.
174     /// @param value Amount of tokens to allow to be spent.
175     /// @return A boolean that indicates if the operation was successful.
176     function approve(address spender, uint256 value) public returns (bool) {
177         _allowances[msg.sender][spender] = value;
178         emit Approval(msg.sender, spender, value);
179         return true;
180     }
181 
182     /// @dev Increases the amount of tokens that an owner allowed to spent by the spender.
183     /// Method approve() should be called when _allowances[spender] == 0. To decrement allowance
184     /// is better to use this function to avoid 2 calls (and wait until the first transaction is mined).
185     /// @param spender The address which will spend the tokens.
186     /// @param value The amount of tokens to increase the allowance by.
187     /// @return A boolean that indicates if the operation was successful.
188     function increaseAllowance(address spender, uint256 value) public returns (bool) {
189         require(spender != address(0));
190         _increaseAllowance(msg.sender, spender, value);
191         return true;
192     }
193 
194     /// @dev Decreases the amount of tokens that an owner allowed to spent by the spender.
195     /// Method approve() should be called when _allowances[spender] == 0. To decrement allowance
196     /// is better to use this function to avoid 2 calls (and wait until the first transaction is mined).
197     /// @param spender The address which will spend the tokens.
198     /// @param value The amount of tokens to decrease the allowance by.
199     /// @return A boolean that indicates if the operation was successful.
200     function decreaseAllowance(address spender, uint256 value) public returns (bool) {
201         require(spender != address(0));
202         _decreaseAllowance(msg.sender, spender, value);
203         return true;
204     }
205 
206     /// @dev Returns total amount of tokens in existence.
207     /// @return A uint256 representing the amount of tokens in existence.
208     function totalSupply() public view returns (uint256) {
209         return _totalSupply;
210     }
211 
212     /// @dev Gets the balance of a specified address.
213     /// @param owner The address to query the balance of.
214     /// @return A uint256 representing the amount of tokens owned by the specified address.
215     function balanceOf(address owner) public view returns (uint256) {
216         return _balances[owner];
217     }
218 
219     /// @dev Function to check the amount of tokens that an owner allowed to spend by the spender.
220     /// @param owner The address which owns the tokens.
221     /// @param spender The address which will spend the tokens.
222     /// @return A uint256 representing the amount of tokens still available to spend by the spender.
223     function allowance(address owner, address spender) public view returns (uint256) {
224         return _allowances[owner][spender];
225     }
226 
227     // INTERNAL FUNCTIONS
228 
229     /// @dev Transfers tokens from one address to another address.
230     /// @param from The address to transfer from.
231     /// @param to The address to transfer to.
232     /// @param value The amount to be transferred.
233     function _transfer(address from, address to, uint256 value) internal {
234         require(to != address(0));
235         require(value <= _balances[from]);
236         _balances[from] = _balances[from].sub(value);
237         _balances[to] = _balances[to].add(value);
238         emit Transfer(from, to, value);
239     }
240 
241     /// @dev Increases the amount of tokens that an owner allowed to spent by the spender.
242     /// Method approve() should be called when _allowances[spender] == 0. To decrement allowance
243     /// is better to use this function to avoid 2 calls (and wait until the first transaction is mined).
244     /// @param owner The address which owns the tokens.
245     /// @param spender The address which will spend the tokens.
246     /// @param value The amount of tokens to increase the allowance by.
247     function _increaseAllowance(address owner, address spender, uint256 value) internal {
248         require(value > 0);
249         _allowances[owner][spender] = _allowances[owner][spender].add(value);
250         emit Approval(owner, spender, _allowances[owner][spender]);
251     }
252 
253     /// @dev Decreases the amount of tokens that an owner allowed to spent by the spender.
254     /// Method approve() should be called when _allowances[spender] == 0. To decrement allowance
255     /// is better to use this function to avoid 2 calls (and wait until the first transaction is mined).
256     /// @param owner The address which owns the tokens.
257     /// @param spender The address which will spend the tokens.
258     /// @param value The amount of tokens to decrease the allowance by.
259     function _decreaseAllowance(address owner, address spender, uint256 value) internal {
260         require(value > 0 && value <= _allowances[owner][spender]);
261         _allowances[owner][spender] = _allowances[owner][spender].sub(value);
262         emit Approval(owner, spender, _allowances[owner][spender]);
263     }
264 
265     /// @dev Internal function that mints specified amount of tokens and assigns it to an address.
266     /// This encapsulates the modification of balances such that the proper events are emitted.
267     /// @param receiver The address that will receive the minted tokens.
268     /// @param value The amount of tokens that will be minted.
269     function _mint(address receiver, uint256 value) internal {
270         require(receiver != address(0));
271         require(value > 0);
272         _balances[receiver] = _balances[receiver].add(value);
273         _totalSupply = _totalSupply.add(value);
274         //_totalMinted = _totalMinted.add(value);
275         emit Transfer(address(0), receiver, value);
276     }
277 
278     /// @dev Internal function that burns specified amount of tokens of a given address.
279     /// @param burner The address from which tokens will be burnt.
280     /// @param value The amount of tokens that will be burnt.
281     function _burn(address burner, uint256 value) internal {
282         require(burner != address(0));
283         require(value > 0 && value <= _balances[burner]);
284         _balances[burner] = _balances[burner].sub(value);
285         _totalSupply = _totalSupply.sub(value);
286         emit Transfer(burner, address(0), value);
287     }
288 
289     /// @dev Internal function that burns specified amount of tokens of a given address,
290     /// deducting from the sender's allowance for said account. Uses the internal burn function.
291     /// @param burner The address from which tokens will be burnt.
292     /// @param value The amount of tokens that will be burnt.
293     function _burnFrom(address burner, uint256 value) internal {
294         _decreaseAllowance(burner, msg.sender, value);
295         _burn(burner, value);
296     }
297 
298     // FIELDS
299 
300     uint256 internal _totalSupply;
301     mapping (address => uint256) internal _balances;
302     mapping (address => mapping(address => uint256)) internal _allowances;
303 }
304 
305 
306 /// @title Papyrus Token contract (PPR).
307 contract PapyrusToken is SafeOwnable, TokenERC20, ERC677, ERC677Bridgeable {
308 
309     // EVENTS
310 
311     event ControlByOwnerRevoked();
312     event MintableChanged(bool mintable);
313     event TransferableChanged(bool transferable);
314     event ContractFallbackCallFailed(address from, address to, uint256 value);
315     event BridgeContractChanged(address indexed previousBridgeContract, address indexed newBridgeContract);
316 
317     // PUBLIC FUNCTIONS
318 
319     constructor() public {
320         _totalSupply = PPR_INITIAL_SUPPLY;
321         _balances[msg.sender] = _totalSupply;
322         emit Transfer(address(0), msg.sender, _totalSupply);
323     }
324 
325     /// @dev Transfers tokens to a specified address with additional data if the recipient is a contact.
326     /// @param to The address to transfer tokens to.
327     /// @param value The amount of tokens to be transferred.
328     /// @param data The extra data to be passed to the receiving contract.
329     /// @return A boolean that indicates if the operation was successful.
330     function transferAndCall(address to, uint256 value, bytes data) external canTransfer returns (bool) {
331         require(to != address(this));
332         require(super.transfer(to, value));
333         emit Transfer(msg.sender, to, value, data);
334         if (isContract(to)) {
335             require(contractFallback(msg.sender, to, value, data));
336         }
337         return true;
338     }
339 
340     /// @dev Transfers tokens to a specified address.
341     /// @param to The address to transfer tokens to.
342     /// @param value The amount of tokens to be transferred.
343     /// @return A boolean that indicates if the operation was successful.
344     function transfer(address to, uint256 value) public canTransfer returns (bool) {
345         require(super.transfer(to, value));
346         if (isContract(to) && !contractFallback(msg.sender, to, value, new bytes(0))) {
347             if (to == _bridgeContract) {
348                 revert();
349             }
350             emit ContractFallbackCallFailed(msg.sender, to, value);
351         }
352         return true;
353     }
354 
355     /// @dev Transfers tokens from one address to another.
356     /// @param from The address to transfer tokens from.
357     /// @param to The address to transfer tokens to.
358     /// @param value The amount of tokens to be transferred.
359     /// @return A boolean that indicates if the operation was successful.
360     function transferFrom(address from, address to, uint256 value) public canTransfer returns (bool) {
361         require(super.transferFrom(from, to, value));
362         if (isContract(to) && !contractFallback(from, to, value, new bytes(0))) {
363             if (to == _bridgeContract) {
364                 revert();
365             }
366             emit ContractFallbackCallFailed(from, to, value);
367         }
368         return true;
369     }
370 
371     /// @dev Transfers tokens to a specified addresses (optimized version for initial sending tokens).
372     /// @param recipients Addresses to transfer tokens to.
373     /// @param values Amounts of tokens to be transferred.
374     /// @return A boolean that indicates if the operation was successful.
375     function airdrop(address[] recipients, uint256[] values) public canTransfer returns (bool) {
376         require(recipients.length == values.length);
377         uint256 senderBalance = _balances[msg.sender];
378         for (uint256 i = 0; i < values.length; i++) {
379             uint256 value = values[i];
380             address to = recipients[i];
381             require(senderBalance >= value);
382             if (msg.sender != recipients[i]) {
383                 senderBalance = senderBalance - value;
384                 _balances[to] += value;
385             }
386             emit Transfer(msg.sender, to, value);
387         }
388         _balances[msg.sender] = senderBalance;
389         return true;
390     }
391 
392     /// @dev Mints specified amount of tokens and assigns it to a specified address.
393     /// @param receiver The address that will receive the minted tokens.
394     /// @param value The amount of tokens that will be minted.
395     function mint(address receiver, uint256 value) public canMint returns (bool) {
396         _mint(receiver, value);
397         _totalMinted = _totalMinted.add(value);
398         emit Mint(receiver, value);
399         return true;
400     }
401 
402     /// @dev Burns specified amount of tokens of the sender.
403     /// @param value The amount of token to be burnt.
404     function burn(uint256 value) public canBurn {
405         _burn(msg.sender, value);
406         _totalBurnt = _totalBurnt.add(value);
407         emit Burn(msg.sender, value);
408     }
409 
410     /// @dev Burns specified amount of tokens of the specified account.
411     /// @param burner The address from which tokens will be burnt.
412     /// @param value The amount of token to be burnt.
413     function burnByOwner(address burner, uint256 value) public canBurnByOwner {
414         _burn(burner, value);
415         _totalBurnt = _totalBurnt.add(value);
416         emit Burn(burner, value);
417     }
418 
419     /// @dev Transfers funds stored on the token contract to specified recipient (required by token bridge).
420     function claimTokens(address token, address to) public onlyOwnerOrBridgeContract {
421         require(to != address(0));
422         if (token == address(0)) {
423             to.transfer(address(this).balance);
424         } else {
425             ERC20 erc20 = ERC20(token);
426             uint256 balance = erc20.balanceOf(address(this));
427             require(erc20.transfer(to, balance));
428         }
429     }
430 
431     /// @dev Revokes control by owner so it is not possible to burn tokens from any account by contract owner.
432     function revokeControlByOwner() public onlyOwner {
433         require(_controllable);
434         _controllable = false;
435         emit ControlByOwnerRevoked();
436     }
437 
438     /// @dev Changes ability to mint tokens by permissioned accounts.
439     function setMintable(bool mintable) public onlyOwner {
440         require(_mintable != mintable);
441         _mintable = mintable;
442         emit MintableChanged(_mintable);
443     }
444 
445     /// @dev Changes ability to transfer tokens by token holders.
446     function setTransferable(bool transferable) public onlyOwner {
447         require(_transferable != transferable);
448         _transferable = transferable;
449         emit TransferableChanged(_transferable);
450     }
451 
452     /// @dev Changes address of token bridge contract.
453     function setBridgeContract(address bridgeContract) public onlyOwner {
454         require(_controllable);
455         require(bridgeContract != address(0) && bridgeContract != _bridgeContract && isContract(bridgeContract));
456         emit BridgeContractChanged(_bridgeContract, bridgeContract);
457         _bridgeContract = bridgeContract;
458     }
459 
460     /// @dev Turn off renounceOwnership() method from Ownable contract.
461     function renounceOwnership() public pure {
462         revert();
463     }
464 
465     /// @dev Returns a boolean flag representing ability to burn tokens from any account by contract owner.
466     /// @return A boolean that indicates if tokens can be burnt from any account by contract owner.
467     function controllableByOwner() public view returns (bool) {
468         return _controllable;
469     }
470 
471     /// @dev Returns a boolean flag representing token mint ability.
472     /// @return A boolean that indicates if tokens can be mintable by permissioned accounts.
473     function mintable() public view returns (bool) {
474         return _mintable;
475     }
476 
477     /// @dev Returns a boolean flag representing token transfer ability.
478     /// @return A boolean that indicates if tokens can be transferred by token holders.
479     function transferable() public view returns (bool) {
480         return _transferable;
481     }
482 
483     /// @dev Returns an address of token bridge contract.
484     /// @return An address of token bridge contract.
485     function bridgeContract() public view returns (address) {
486         return _bridgeContract;
487     }
488 
489     /// @dev Returns total amount of minted tokens.
490     /// @return A uint256 representing the amount of tokens were mint during token lifetime.
491     function totalMinted() public view returns (uint256) {
492         return _totalMinted;
493     }
494 
495     /// @dev Returns total amount of burnt tokens.
496     /// @return A uint256 representing the amount of tokens were burnt during token lifetime.
497     function totalBurnt() public view returns (uint256) {
498         return _totalBurnt;
499     }
500 
501     /// @dev Returns version of token interfaces (required by token bridge).
502     function getTokenInterfacesVersion() public pure returns (uint64, uint64, uint64) {
503         uint64 major = 2;
504         uint64 minor = 0;
505         uint64 patch = 0;
506         return (major, minor, patch);
507     }
508 
509     // PRIVATE FUNCTIONS
510 
511     /// @dev Calls method onTokenTransfer() on specified contract address `receiver`.
512     /// @return A boolean that indicates if the operation was successful.
513     function contractFallback(address from, address receiver, uint256 value, bytes data) private returns (bool) {
514         return receiver.call(abi.encodeWithSignature("onTokenTransfer(address,uint256,bytes)", from, value, data));
515     }
516 
517     /// @dev Determines if specified address is contract address.
518     /// @return A boolean that indicates if specified address is contract address.
519     function isContract(address account) private view returns (bool) {
520         uint256 codeSize;
521         assembly { codeSize := extcodesize(account) }
522         return codeSize > 0;
523     }
524 
525     // MODIFIERS
526 
527     modifier onlyOwnerOrBridgeContract() {
528         require(msg.sender == _owner || msg.sender == _bridgeContract);
529         _;
530     }
531 
532     modifier canMint() {
533         require(_mintable);
534         require(msg.sender == _owner || msg.sender == _bridgeContract);
535         _;
536     }
537 
538     modifier canBurn() {
539         require(msg.sender == _owner || msg.sender == _bridgeContract);
540         _;
541     }
542 
543     modifier canBurnByOwner() {
544         require(msg.sender == _owner && _controllable);
545         _;
546     }
547 
548     modifier canTransfer() {
549         require(_transferable || msg.sender == _owner);
550         _;
551     }
552 
553     // FIELDS
554 
555     // Standard fields used to describe the token
556     string public constant name = "Papyrus Token";
557     string public constant symbol = "PPR";
558     uint8 public constant decimals = 18;
559 
560     // At the start of the token existence it is fully controllable by owner
561     bool private _controllable = true;
562 
563     // At the start of the token existence it is mintable
564     bool private _mintable = true;
565 
566     // At the start of the token existence it is not transferable
567     bool private _transferable = false;
568 
569     // Address of token bridge contract
570     address private _bridgeContract;
571 
572     // Total amount of tokens minted during token lifetime
573     uint256 private _totalMinted;
574     // Total amount of tokens burnt during token lifetime
575     uint256 private _totalBurnt;
576 
577     // Amount of initially supplied tokens is constant and equals to 1,000,000,000 PPR
578     uint256 private constant PPR_INITIAL_SUPPLY = 10**27;
579 }