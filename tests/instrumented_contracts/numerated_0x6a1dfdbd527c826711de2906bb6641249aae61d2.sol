1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7  
8 interface IERC20 {
9 
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address who) external view returns (uint256);
19 
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 
26 }
27 
28 
29 
30 
31 
32 
33 
34 
35 /**
36  * @title SafeMath
37  * @dev Unsigned math operations with safety checks that revert on error
38  */
39  
40 library SafeMath {
41     /**
42     * @dev Multiplies two unsigned integers, reverts on overflow.
43     */
44     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
46         // benefit is lost if 'b' is also tested.
47         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
48         if (a == 0) {
49             return 0;
50         }
51 
52         uint256 c = a * b;
53         require(c / a == b);
54 
55         return c;
56     }
57 
58     /**
59     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
60     */
61     function div(uint256 a, uint256 b) internal pure returns (uint256) {
62         // Solidity only automatically asserts when dividing by 0
63         require(b > 0);
64         uint256 c = a / b;
65         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66 
67         return c;
68     }
69 
70     /**
71     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
72     */
73     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74         require(b <= a);
75         uint256 c = a - b;
76 
77         return c;
78     }
79 
80     /**
81     * @dev Adds two unsigned integers, reverts on overflow.
82     */
83     function add(uint256 a, uint256 b) internal pure returns (uint256) {
84         uint256 c = a + b;
85         require(c >= a);
86 
87         return c;
88     }
89 
90     /**
91     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
92     * reverts when dividing by zero.
93     */
94     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
95         require(b != 0);
96         return a % b;
97     }
98 }
99 
100 
101 
102 
103 /**
104  * @title Ownable
105  * @dev The Ownable contract has an owner address, and provides basic authorization control
106  * functions, this simplifies the implementation of "user permissions".
107  */
108  
109 contract Ownable {
110     address internal _owner;
111 
112     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
113 
114     /**
115      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
116      * account.
117      */
118     constructor () internal {
119         _owner = msg.sender;
120         emit OwnershipTransferred(address(0), _owner);
121     }
122 
123     /**
124      * @return the address of the owner.
125      */
126     function owner() public view returns (address) {
127         return _owner;
128     }
129 
130     /**
131      * @dev Throws if called by any account other than the owner.
132      */
133     modifier onlyOwner() {
134         require(isOwner());
135         _;
136     }
137 
138     /**
139      * @return true if `msg.sender` is the owner of the contract.
140      */
141     function isOwner() public view returns (bool) {
142         return msg.sender == _owner;
143     }
144 
145     /**
146      * @dev Allows the current owner to relinquish control of the contract.
147      * @notice Renouncing to ownership will leave the contract without an owner.
148      * It will not be possible to call the functions with the `onlyOwner`
149      * modifier anymore.
150      */
151     function renounceOwnership() public onlyOwner {
152         emit OwnershipTransferred(_owner, address(0));
153         _owner = address(0);
154     }
155 
156     /**
157      * @dev Allows the current owner to transfer control of the contract to a newOwner.
158      * @param newOwner The address to transfer ownership to.
159      */
160     function transferOwnership(address newOwner) public onlyOwner {
161         _transferOwnership(newOwner);
162     }
163 
164     /**
165      * @dev Transfers control of the contract to a newOwner.
166      * @param newOwner The address to transfer ownership to.
167      */
168     function _transferOwnership(address newOwner) internal {
169         require(newOwner != address(0),"You can't transfer the ownership to this account");
170         emit OwnershipTransferred(_owner, newOwner);
171         _owner = newOwner;
172     }
173 }
174 
175 contract Remote is Ownable, IERC20 {
176     using SafeMath for uint;
177 
178     IERC20 internal _remoteToken;
179     address internal _remoteContractAddress;
180 
181     uint _totalSupply;
182 
183     mapping(address => uint) balances;
184     mapping(address => mapping(address => uint)) allowed;
185 
186     // ------------------------------------------------------------------------
187     // Total supply
188     // ------------------------------------------------------------------------
189     function totalSupply() public view returns (uint) {
190         return _totalSupply.sub(balances[address(0)]);
191     }
192 
193     // ------------------------------------------------------------------------
194     // Get the token balance for account `tokenOwner`
195     // ------------------------------------------------------------------------
196     function balanceOf(address tokenOwner) public view returns (uint balance) {
197         return balances[tokenOwner];
198     }
199 
200     // ------------------------------------------------------------------------
201     // Transfer the balance from token owner's account to `to` account
202     // - Owner's account must have sufficient balance to transfer
203     // - 0 value transfers are allowed
204     // ------------------------------------------------------------------------
205     function transfer(address to, uint tokens) public returns (bool success) {
206         balances[msg.sender] = balances[msg.sender].sub(tokens);
207         balances[to] = balances[to].add(tokens);
208         emit Transfer(msg.sender, to, tokens);
209         return true;
210     }
211 
212     // ------------------------------------------------------------------------
213     // Token owner can approve for `spender` to transferFrom(...) `tokens`
214     // from the token owner's account
215     //
216     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
217     // recommends that there are no checks for the approval double-spend attack
218     // as this should be implemented in user interfaces
219     // ------------------------------------------------------------------------
220     function approve(address spender, uint tokens) public returns (bool success) {
221         allowed[msg.sender][spender] = tokens;
222         emit Approval(msg.sender, spender, tokens);
223         return true;
224     }
225 
226     // ------------------------------------------------------------------------
227     // Transfer `tokens` from the `from` account to the `to` account
228     //
229     // The calling account must already have sufficient tokens approve(...)-d
230     // for spending from the `from` account and
231     // - From account must have sufficient balance to transfer
232     // - Spender must have sufficient allowance to transfer
233     // - 0 value transfers are allowed
234     // ------------------------------------------------------------------------
235     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
236         balances[from] = balances[from].sub(tokens);
237         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
238         balances[to] = balances[to].add(tokens);
239         emit Transfer(from, to, tokens);
240         return true;
241     }
242 
243     // ------------------------------------------------------------------------
244     // Returns the amount of tokens approved by the owner that can be
245     // transferred to the spender's account
246     // ------------------------------------------------------------------------
247     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
248         return allowed[tokenOwner][spender];
249     }
250 
251     /**
252     @dev approveSpenderOnDex
253     This is only needed if you put the funds in the Dex contract address, and then need to withdraw them
254     Avoid this, by not putting funds in there that you need to get back.
255     @param spender The address that will be used to withdraw from the Dex.
256     @param value The amount of tokens to approve.
257     @return success
258      */
259     function approveSpenderOnDex (address spender, uint256 value) 
260         external onlyOwner returns (bool success) {
261         // NOTE Approve the spender on the Dex address
262         _remoteToken.approve(spender, value);     
263         success = true;
264     }
265 
266    /** 
267     @dev remoteTransferFrom This allows the admin to withdraw tokens from the contract, using an 
268     allowance that has been previously set. 
269     @param from address to take the tokens from (allowance)
270     @param to the recipient to give the tokens to
271     @param value the amount in tokens to send
272     @return bool
273     */
274     function remoteTransferFrom (address from, address to, uint256 value) external onlyOwner returns (bool) {
275         return _remoteTransferFrom(from, to, value);
276     }
277 
278     /**
279     @dev setRemoteContractAddress
280     @param remoteContractAddress The remote contract's address
281     @return success
282      */
283     function setRemoteContractAddress (address remoteContractAddress)
284         external onlyOwner returns (bool success) {
285         _remoteContractAddress = remoteContractAddress;        
286         _remoteToken = IERC20(_remoteContractAddress);
287         success = true;
288     }
289 
290     function remoteBalanceOf(address owner) external view returns (uint256) {
291         return _remoteToken.balanceOf(owner);
292     }
293 
294     function remoteTotalSupply() external view returns (uint256) {
295         return _remoteToken.totalSupply();
296     }
297 
298     /** */
299     function remoteAllowance (address owner, address spender) external view returns (uint256) {
300         return _remoteToken.allowance(owner, spender);
301     }
302 
303     /**
304     @dev remoteBalanceOfDex Return tokens from the balance of the Dex contract.
305     @return balance
306      */
307     function remoteBalanceOfDex () external view onlyOwner 
308         returns(uint256 balance) {
309         balance = _remoteToken.balanceOf(address(this));
310     }
311 
312     /**
313     @dev remoteAllowanceOnMyAddress Check contracts allowance on the users address.
314     @return allowance
315      */
316     function remoteAllowanceOnMyAddress () public view
317         returns(uint256 myRemoteAllowance) {
318         myRemoteAllowance = _remoteToken.allowance(msg.sender, address(this));
319     } 
320 
321     /** 
322     @dev _remoteTransferFrom This allows contract to withdraw tokens from an address, using an 
323     allowance that has been previously set. 
324     @param from address to take the tokens from (allowance)
325     @param to the recipient to give the tokens to
326     @param value the amount in tokens to send
327     @return bool
328     */
329     function _remoteTransferFrom (address from, address to, uint256 value) internal returns (bool) {
330         return _remoteToken.transferFrom(from, to, value);
331     }
332 
333 }
334 
335 contract Dex is Remote {
336 
337     event TokensPurchased(address owner, uint256 amountOfTokens, uint256 amountOfWei);
338     event TokensSold(address owner, uint256 amountOfTokens, uint256 amountOfWei);
339     event TokenPricesSet(uint256 sellPrice, uint256 buyPrice);
340     
341     address internal _dexAddress;
342 
343     uint256 public sellPrice = 200000000000;
344     uint256 public buyPrice = 650000000000;
345     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
346     /// @param newSellPrice Price the users can sell to the contract
347     /// @param newBuyPrice Price users can buy from the contract
348     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) public onlyOwner returns (bool success) {
349         sellPrice = newSellPrice;
350         buyPrice = newBuyPrice;
351 
352         emit TokenPricesSet(sellPrice, buyPrice);
353         success = true;
354     }
355 
356     function topUpEther() external payable {
357         // allow payable function to top up the contract
358         // without buying tokens.
359     }
360     
361     function _purchaseToken (address sender, uint256 amountOfWei) internal returns (bool success) {
362         
363         uint256 amountOfTokens = buyTokenExchangeAmount(amountOfWei);
364         
365         uint256 dexTokenBalance = _remoteToken.balanceOf(_dexAddress);
366         require(dexTokenBalance >= amountOfTokens, "The VeriDex does not have enough tokens for this purchase.");
367 
368         _remoteToken.transfer(sender, amountOfTokens);
369 
370         emit TokensPurchased(sender, amountOfTokens, amountOfWei);
371         success = true;
372     }
373 
374     /** 
375     @dev dexRequestTokensFromUser This allows the contract to transferFrom the user to 
376     the contract using allowance that has been previously set. 
377     // User must have an allowance already. If the user sends tokens to the address, 
378     // Then the admin must transfer manually.
379     @return string Message
380     */
381     function dexRequestTokensFromUser () external returns (bool success) {
382 
383         // calculate remote allowance given to the contract on the senders address
384         // completed via the wallet
385         uint256 amountAllowed = _remoteToken.allowance(msg.sender, _dexAddress);
386 
387         require(amountAllowed > 0, "No allowance has been set.");        
388         
389         uint256 amountBalance = _remoteToken.balanceOf(msg.sender);
390 
391         require(amountBalance >= amountAllowed, "Your balance must be equal or more than your allowance");
392         
393         uint256 amountOfWei = sellTokenExchangeAmount(amountAllowed);
394 
395         uint256 dexWeiBalance = _dexAddress.balance;
396 
397         uint256 dexTokenBalance = _remoteToken.balanceOf(_dexAddress);
398 
399         require(dexWeiBalance >= amountOfWei, "Dex balance must be equal or more than your allowance");
400 
401         _remoteTransferFrom(msg.sender, _dexAddress, amountAllowed);
402 
403         _remoteToken.approve(_dexAddress, dexTokenBalance.add(amountAllowed));  
404  
405         // Send Ether back to user
406         msg.sender.transfer(amountOfWei);
407 
408         emit TokensSold(msg.sender, amountAllowed, amountOfWei);
409         success = true;
410     }
411  
412     /**
413     @dev etherBalance: Returns value of the ether in contract.
414     @return tokensOut
415      */
416     function etherBalance() public view returns (uint256 etherValue) {
417         etherValue = _dexAddress.balance;
418     }
419 
420     /**
421     @dev etherBalance: Returns value of the ether in contract.
422     @return tokensOut
423      */
424     function withdrawBalance() public onlyOwner returns (bool success) {
425         msg.sender.transfer(_dexAddress.balance);
426         success = true;
427     }
428 
429     /**
430     @dev buyTokenExchangeAmount: Returns value of the reward. Does not allocate reward.
431     @param numberOfWei The number of ether in wei
432     @return tokensOut
433      */
434     function buyTokenExchangeAmount(uint256 numberOfWei) public view returns (uint256 tokensOut) {
435         tokensOut = numberOfWei.mul(10**18).div(buyPrice);
436     }
437 
438     /**
439     @dev sellTokenExchangeAmount: Returns value of the reward. Does not allocate reward.
440     @param numberOfTokens The number of tokens
441     @return weiOut
442      */
443     function sellTokenExchangeAmount(uint256 numberOfTokens) public view returns (uint256 weiOut) {
444         weiOut = numberOfTokens.mul(sellPrice).div(10**18);
445     }
446  
447 }
448 
449 /**
450  * @title VeriDex
451  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
452  * Note they can later distribute these tokens as they wish using `transfer` and other
453  * `ERC20` functions.
454  */
455 
456 contract VeriDex is Dex {
457     
458     // User should not send tokens directly to the address
459 
460     string public symbol;
461     string public  name;
462     uint8 public decimals;
463     /**
464      * @dev Constructior to set up treasury and remote address.
465      */
466     constructor ( address remoteContractAddress)
467         public  {
468         symbol = "VRDX";
469         name = "VeriDex";
470         decimals = 18;
471         _totalSupply = 20000000000 * 10**uint(decimals);
472         _remoteContractAddress = remoteContractAddress;
473         _remoteToken = IERC20(_remoteContractAddress);
474         _dexAddress = address(this);
475         balances[_owner] = _totalSupply;
476         emit Transfer(address(0), _owner, _totalSupply);
477     }
478 
479     function() external payable {
480         // If Ether is sent to this address, send tokens.
481         require(_purchaseToken(msg.sender, msg.value), "Validation on purchase failed.");
482     }
483  
484     /**
485      * @dev adminDoDestructContract
486      */ 
487     function adminDoDestructContract() external onlyOwner { 
488         selfdestruct(msg.sender);
489     }
490 
491     /**
492     * @dev dexDetails
493     * @return address dexAddress
494     * @return address remoteContractAddress
495      */ 
496     function dexDetails() external view returns (
497         address dexAddress,  
498         address remoteContractAddress) {
499         dexAddress = _dexAddress;
500         remoteContractAddress = _remoteContractAddress;
501     }
502 
503 }