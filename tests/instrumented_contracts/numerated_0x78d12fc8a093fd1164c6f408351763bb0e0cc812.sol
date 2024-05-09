1 pragma solidity 0.5.1;
2 
3 library ECTools {
4 
5   /**
6    * @dev Recover signer address from a message by using his signature
7    * @param originalMessage bytes32 message, the originalMessage is the signed message. What is recovered is the signer address.
8    * @param signedMessage bytes signature
9    */
10     function recover(bytes32 originalMessage, bytes memory signedMessage) public pure returns (address) {
11         bytes32 r;
12         bytes32 s;
13         uint8 v;
14 
15         //Check the signature length
16         if (signedMessage.length != 65) {
17             return (address(0));
18         }
19 
20         // Divide the signature in r, s and v variables
21         assembly {
22             r := mload(add(signedMessage, 32))
23             s := mload(add(signedMessage, 64))
24             v := byte(0, mload(add(signedMessage, 96)))
25         }
26 
27         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
28         if (v < 27) {
29             v += 27;
30         }
31 
32         // If the version is correct return the signer address
33         if (v != 27 && v != 28) {
34             return (address(0));
35         } else {
36             return ecrecover(originalMessage, v, r, s);
37         }
38     }
39 
40     function toEthereumSignedMessage(bytes32 _msg) public pure returns (bytes32) {
41         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
42         return keccak256(abi.encodePacked(prefix, _msg));
43     }
44 
45     function prefixedRecover(bytes32 _msg, bytes memory sig) public pure returns (address) {
46         bytes32 ethSignedMsg = toEthereumSignedMessage(_msg);
47         return recover(ethSignedMsg, sig);
48     }
49 }
50 
51 /**
52  * @title SafeMath
53  * @dev Unsigned math operations with safety checks that revert on error
54  */
55 library SafeMath {
56     /**
57     * @dev Multiplies two unsigned integers, reverts on overflow.
58     */
59     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
60         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
61         // benefit is lost if 'b' is also tested.
62         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
63         if (a == 0) {
64             return 0;
65         }
66 
67         uint256 c = a * b;
68         require(c / a == b);
69 
70         return c;
71     }
72 
73     /**
74     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
75     */
76     function div(uint256 a, uint256 b) internal pure returns (uint256) {
77         // Solidity only automatically asserts when dividing by 0
78         require(b > 0);
79         uint256 c = a / b;
80         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
81 
82         return c;
83     }
84 
85     /**
86     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
87     */
88     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
89         require(b <= a);
90         uint256 c = a - b;
91 
92         return c;
93     }
94 
95     /**
96     * @dev Adds two unsigned integers, reverts on overflow.
97     */
98     function add(uint256 a, uint256 b) internal pure returns (uint256) {
99         uint256 c = a + b;
100         require(c >= a);
101 
102         return c;
103     }
104 
105     /**
106     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
107     * reverts when dividing by zero.
108     */
109     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
110         require(b != 0);
111         return a % b;
112     }
113 }
114 
115 
116 /**
117  * @title ERC20 interface
118  * @dev see https://github.com/ethereum/EIPs/issues/20
119  */
120 interface IERC20 {
121     function transfer(address to, uint256 value) external returns (bool);
122 
123     function approve(address spender, uint256 value) external returns (bool);
124 
125     function transferFrom(address from, address to, uint256 value) external returns (bool);
126 
127     function totalSupply() external view returns (uint256);
128 
129     function balanceOf(address who) external view returns (uint256);
130 
131     function allowance(address owner, address spender) external view returns (uint256);
132 
133     event Transfer(address indexed from, address indexed to, uint256 value);
134 
135     event Approval(address indexed owner, address indexed spender, uint256 value);
136 }
137 
138 
139 
140 /**
141  * @title Standard ERC20 token
142  *
143  * @dev Implementation of the basic standard token.
144  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
145  * Originally based on code by FirstBlood:
146  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
147  *
148  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
149  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
150  * compliant implementations may not do it.
151  */
152 contract ERC20 is IERC20 {
153     using SafeMath for uint256;
154 
155     mapping (address => uint256) private _balances;
156 
157     mapping (address => mapping (address => uint256)) private _allowed;
158 
159     uint256 private _totalSupply;
160 
161     /**
162     * @dev Total number of tokens in existence
163     */
164     function totalSupply() public view returns (uint256) {
165         return _totalSupply;
166     }
167 
168     /**
169     * @dev Gets the balance of the specified address.
170     * @param owner The address to query the balance of.
171     * @return An uint256 representing the amount owned by the passed address.
172     */
173     function balanceOf(address owner) public view returns (uint256) {
174         return _balances[owner];
175     }
176 
177     /**
178      * @dev Function to check the amount of tokens that an owner allowed to a spender.
179      * @param owner address The address which owns the funds.
180      * @param spender address The address which will spend the funds.
181      * @return A uint256 specifying the amount of tokens still available for the spender.
182      */
183     function allowance(address owner, address spender) public view returns (uint256) {
184         return _allowed[owner][spender];
185     }
186 
187     /**
188     * @dev Transfer token for a specified address
189     * @param to The address to transfer to.
190     * @param value The amount to be transferred.
191     */
192     function transfer(address to, uint256 value) public returns (bool) {
193         _transfer(msg.sender, to, value);
194         return true;
195     }
196 
197     /**
198      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
199      * Beware that changing an allowance with this method brings the risk that someone may use both the old
200      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
201      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
202      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
203      * @param spender The address which will spend the funds.
204      * @param value The amount of tokens to be spent.
205      */
206     function approve(address spender, uint256 value) public returns (bool) {
207         require(spender != address(0));
208 
209         _allowed[msg.sender][spender] = value;
210         emit Approval(msg.sender, spender, value);
211         return true;
212     }
213 
214     /**
215      * @dev Transfer tokens from one address to another.
216      * Note that while this function emits an Approval event, this is not required as per the specification,
217      * and other compliant implementations may not emit the event.
218      * @param from address The address which you want to send tokens from
219      * @param to address The address which you want to transfer to
220      * @param value uint256 the amount of tokens to be transferred
221      */
222     function transferFrom(address from, address to, uint256 value) public returns (bool) {
223         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
224         _transfer(from, to, value);
225         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
226         return true;
227     }
228 
229     /**
230      * @dev Increase the amount of tokens that an owner allowed to a spender.
231      * approve should be called when allowed_[_spender] == 0. To increment
232      * allowed value is better to use this function to avoid 2 calls (and wait until
233      * the first transaction is mined)
234      * From MonolithDAO Token.sol
235      * Emits an Approval event.
236      * @param spender The address which will spend the funds.
237      * @param addedValue The amount of tokens to increase the allowance by.
238      */
239     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
240         require(spender != address(0));
241 
242         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
243         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
244         return true;
245     }
246 
247     /**
248      * @dev Decrease the amount of tokens that an owner allowed to a spender.
249      * approve should be called when allowed_[_spender] == 0. To decrement
250      * allowed value is better to use this function to avoid 2 calls (and wait until
251      * the first transaction is mined)
252      * From MonolithDAO Token.sol
253      * Emits an Approval event.
254      * @param spender The address which will spend the funds.
255      * @param subtractedValue The amount of tokens to decrease the allowance by.
256      */
257     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
258         require(spender != address(0));
259 
260         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
261         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
262         return true;
263     }
264 
265     /**
266     * @dev Transfer token for a specified addresses
267     * @param from The address to transfer from.
268     * @param to The address to transfer to.
269     * @param value The amount to be transferred.
270     */
271     function _transfer(address from, address to, uint256 value) internal {
272         require(to != address(0));
273 
274         _balances[from] = _balances[from].sub(value);
275         _balances[to] = _balances[to].add(value);
276         emit Transfer(from, to, value);
277     }
278 
279     /**
280      * @dev Internal function that mints an amount of the token and assigns it to
281      * an account. This encapsulates the modification of balances such that the
282      * proper events are emitted.
283      * @param account The account that will receive the created tokens.
284      * @param value The amount that will be created.
285      */
286     function _mint(address account, uint256 value) internal {
287         require(account != address(0));
288 
289         _totalSupply = _totalSupply.add(value);
290         _balances[account] = _balances[account].add(value);
291         emit Transfer(address(0), account, value);
292     }
293 
294     /**
295      * @dev Internal function that burns an amount of the token of a given
296      * account.
297      * @param account The account whose tokens will be burnt.
298      * @param value The amount that will be burnt.
299      */
300     function _burn(address account, uint256 value) internal {
301         require(account != address(0));
302 
303         _totalSupply = _totalSupply.sub(value);
304         _balances[account] = _balances[account].sub(value);
305         emit Transfer(account, address(0), value);
306     }
307 
308     /**
309      * @dev Internal function that burns an amount of the token of a given
310      * account, deducting from the sender's allowance for said account. Uses the
311      * internal burn function.
312      * Emits an Approval event (reflecting the reduced allowance).
313      * @param account The account whose tokens will be burnt.
314      * @param value The amount that will be burnt.
315      */
316     function _burnFrom(address account, uint256 value) internal {
317         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
318         _burn(account, value);
319         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
320     }
321 }
322 
323 
324 
325 
326 /**
327  * @title Escrow_V3
328  * @dev Escrow_V3 is the latest version of the escrow contract, currently being used for production
329  */
330 contract Escrow_V3 {
331     using SafeMath for uint256;
332 
333     ERC20 public tokenContract;
334 
335     mapping (address => bool) public signers;
336     mapping (address => bool) public fundExecutors;
337     mapping (uint256 => bool) public usedNonces;
338 
339     address payable public dAppAdmin;
340     uint256 constant public REFUNDING_LOGIC_GAS_COST = 7901; // gas used for single refund
341 
342     uint256 constant public FIAT_PAYMENT_FUND_FUNCTION_CALL_GAS_USED = 32831; // approximated gas for calling fundForFiatPayment
343     uint256 constant public RELAYED_PAYMENT_FUND_FUNCTION_CALL_GAS_USED = 32323; // approximated gas for calling fundForRelayedPayment
344 
345     /**
346     * @dev Restricts the access to a given function to the dApp admin only
347     */
348     modifier onlyDAppAdmin() {
349         require(msg.sender == dAppAdmin, "Unauthorized access");
350         _;
351     }
352 
353     /**
354     * @dev Restricts the access to a given function to the fund executor only
355     */
356     modifier onlyFundExecutor() {
357         require(fundExecutors[msg.sender], "Unauthorized access");
358         _;
359     }
360 
361     /**
362     * @dev Checks whether the nonce in the authorisation signature was already used. Prevents replay attacks.
363     */
364     modifier preValidateFund(uint256 nonce, uint256 gasprice) {
365         require(!usedNonces[nonce], "Nonce already used");
366         require(gasprice == tx.gasprice, "Gas price is different from the signed one");
367         _;
368     }
369 
370     /**
371     * @dev The token address, dappadmin and funding wallets are set on contract deployment. FundExecutors are MAX 5
372     */
373     constructor(address tokenAddress, address payable _dAppAdmin, address[] memory _fundExecutors) public {
374         dAppAdmin = _dAppAdmin;
375         tokenContract = ERC20(tokenAddress);
376         for (uint i = 0; i < _fundExecutors.length; i++) {
377             fundExecutors[_fundExecutors[i]] = true;
378         }
379     }
380    
381     /**
382     * @dev Funds the `addressToFund` with the proided `weiAmount`
383     * Signature from the dapp is used in order to authorize the funding
384     * The msg sender is refunded for the transaction costs
385     */
386     function fundForRelayedPayment(
387         uint256 nonce,
388         uint256 gasprice,
389         address payable addressToFund,
390         uint256 weiAmount,
391         bytes memory authorizationSignature) public preValidateFund(nonce, gasprice) onlyFundExecutor()
392     {
393         uint256 gasLimit = gasleft().add(RELAYED_PAYMENT_FUND_FUNCTION_CALL_GAS_USED);
394 
395         bytes32 hashedParameters = keccak256(abi.encodePacked(nonce, address(this), gasprice, addressToFund, weiAmount));
396         _preFund(hashedParameters, authorizationSignature, nonce);
397 
398         addressToFund.transfer(weiAmount);
399 
400         _refundMsgSender(gasLimit, gasprice);
401     }
402 
403     /**
404     * @dev Funds the `addressToFund` with the proided `weiAmount` and `tokenAmount`
405     * Signature from the dapp is used in order to authorize the funding
406     * The msg sender is refunded for the transaction costs
407     */
408     function fundForFiatPayment(
409         uint256 nonce,
410         uint256 gasprice,
411         address payable addressToFund,
412         uint256 weiAmount,
413         uint256 tokenAmount,
414         bytes memory authorizationSignature) public preValidateFund(nonce, gasprice) onlyFundExecutor()
415     {
416         uint256 gasLimit = gasleft().add(FIAT_PAYMENT_FUND_FUNCTION_CALL_GAS_USED);
417 
418         bytes32 hashedParameters = keccak256(abi.encodePacked(nonce, address(this), gasprice, addressToFund, weiAmount, tokenAmount));
419         _preFund(hashedParameters, authorizationSignature, nonce);
420 
421         tokenContract.transfer(addressToFund, tokenAmount);
422         addressToFund.transfer(weiAmount);
423 
424         _refundMsgSender(gasLimit, gasprice);
425     }
426 
427     /**
428     * @dev Recovers the signer and checks whether the person that signed the signature is whitelisted as `signer`. Marks the nonce as used
429     */
430     function _preFund(bytes32 hashedParameters, bytes memory authorizationSignature, uint256 nonce) internal {
431         address signer = getSigner(hashedParameters, authorizationSignature);
432         require(signers[signer], "Invalid authorization signature or signer");
433 
434         usedNonces[nonce] = true;
435     }
436 
437     /**
438     * @dev performs EC recover on the signature
439     */
440     function getSigner(bytes32 raw, bytes memory sig) public pure returns(address signer) {
441         return ECTools.prefixedRecover(raw, sig);
442     }
443 
444     /**
445     * @dev refunds the msg sender for the transaction costs
446     */
447     function _refundMsgSender(uint256 gasLimit, uint256 gasprice) internal {
448         uint256 refundAmount = gasLimit.sub(gasleft()).add(REFUNDING_LOGIC_GAS_COST).mul(gasprice);
449         msg.sender.transfer(refundAmount);
450     }
451 
452     /**
453     * @dev withdraws the ethers in the escrow contract. Performed only by the dAppAdmin
454     */
455     function withdrawEthers(uint256 ethersAmount) public onlyDAppAdmin {
456         dAppAdmin.transfer(ethersAmount);
457     }
458 
459     /**
460     * @dev withdraws the tokens in the escrow contract. Performed only by the dAppAdmin
461     */
462     function withdrawTokens(uint256 tokensAmount) public onlyDAppAdmin {
463         tokenContract.transfer(dAppAdmin, tokensAmount);
464     }
465 
466     /**
467     * @dev marks a given address as signer or not, depending on the second bool parameter. Performed only by the dAppAdmin
468     */
469     function editSigner(address _newSigner, bool add) public onlyDAppAdmin {
470         signers[_newSigner] = add;
471     }
472 
473     /**
474     * @dev changes the dAppAdmin of the contract. Performed only by the dAppAdmin
475     */
476     function editDappAdmin (address payable _dAppAdmin) public onlyDAppAdmin {
477         dAppAdmin = _dAppAdmin;
478     }
479 
480     /**
481     * @dev marks a given address as fund executor or not, depending on the second bool parameter. Performed only by the dAppAdmin
482     */
483     function editFundExecutor(address _newExecutor, bool add) public onlyDAppAdmin {
484         fundExecutors[_newExecutor] = add;
485     }
486 
487     function() external payable {}
488 }