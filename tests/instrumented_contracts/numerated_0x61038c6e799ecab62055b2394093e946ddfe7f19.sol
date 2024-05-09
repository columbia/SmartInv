1 pragma solidity ^0.7.0;
2 //SPDX-License-Identifier: UNLICENSED
3 
4 // Telegram https://t.me/FirestarterNFT
5 
6 interface IERC20 {
7     function totalSupply() external view returns (uint);
8     function balanceOf(address who) external view returns (uint);
9     function allowance(address owner, address spender) external view returns (uint);
10     function transfer(address to, uint value) external returns (bool);
11     function approve(address spender, uint value) external returns (bool);
12     function transferFrom(address from, address to, uint value) external returns (bool);
13     event Transfer(address indexed from, address indexed to, uint value);
14     event Approval(address indexed owner, address indexed spender, uint value);
15 }
16 interface IUNIv2 {
17     function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) 
18     external 
19     payable 
20     returns (uint amountToken, uint amountETH, uint liquidity);
21     
22     function WETH() external pure returns (address);
23 
24 }
25 
26 interface IUnicrypt {
27     event onDeposit(address, uint256, uint256);
28     event onWithdraw(address, uint256);
29     function depositToken(address token, uint256 amount, uint256 unlock_date) external payable; 
30     function withdrawToken(address token, uint256 amount) external;
31 
32 }
33 
34 interface IUniswapV2Factory {
35   event PairCreated(address indexed token0, address indexed token1, address pair, uint);
36 
37   function createPair(address tokenA, address tokenB) external returns (address pair);
38 }
39 
40 abstract contract Context {
41     function _msgSender() internal view virtual returns (address payable) {
42         return msg.sender;
43     }
44 
45     function _msgData() internal view virtual returns (bytes memory) {
46         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
47         return msg.data;
48     }
49 }
50 
51 
52 abstract contract Ownable is Context {
53     address private _owner;
54 
55     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57     /**
58      * @dev Initializes the contract setting the deployer as the initial owner.
59      */
60     constructor () {
61         address msgSender = _msgSender();
62         _owner = msgSender;
63         emit OwnershipTransferred(address(0), msgSender);
64     }
65 
66     /**
67      * @dev Returns the address of the current owner.
68      */
69     function owner() public view returns (address) {
70         return _owner;
71     }
72 
73     /**
74      * @dev Throws if called by any account other than the owner.
75      */
76     modifier onlyOwner() {
77         require(_owner == _msgSender(), "Ownable: caller is not the owner");
78         _;
79     }
80 
81     /**
82      * @dev Leaves the contract without owner. It will not be possible to call
83      * `onlyOwner` functions anymore. Can only be called by the current owner.
84      *
85      * NOTE: Renouncing ownership will leave the contract without an owner,
86      * thereby removing any functionality that is only available to the owner.
87      */
88     function renounceOwnership() public virtual onlyOwner {
89         emit OwnershipTransferred(_owner, address(0));
90         _owner = address(0);
91     }
92  
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) public virtual onlyOwner {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         emit OwnershipTransferred(_owner, newOwner);
100         _owner = newOwner;
101     }
102 }
103 
104 contract FIRE is IERC20, Context {
105     
106     using SafeMath for uint;
107     IUNIv2 constant uniswap =  IUNIv2(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
108     IUniswapV2Factory constant uniswapFactory = IUniswapV2Factory(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
109     IUnicrypt constant unicrypt = IUnicrypt(0x17e00383A843A9922bCA3B280C0ADE9f8BA48449);
110     string public _symbol;
111     string public _name;
112     uint8 public _decimals;
113     uint _totalSupply;
114     
115     uint public tokensBought;
116     bool public isStopped = false;
117     bool public teamClaimed = false;
118     bool public moonMissionStarted = false;
119 
120     uint constant tokensForUniswap = 1500 ether;
121     uint constant teamTokens = 375 ether;
122     uint constant tokensForStakingAndMarketining = 775 ether;
123     uint constant tokensForNftVault = 1500 ether;
124     uint constant tokensForPartnerships = 350 ether;
125     address vault;
126     
127     address payable owner;
128     address payable constant owner2 = 0x7781b7780B8E02b89994fDa7034EF659d4C292BA;
129     address payable constant owner3 = 0x4ebbE7c22CD00f6411F0994161A5d4539CaF081B;
130     address payable constant multisig = 0x251CfD87CE1AA5A07E7bfcA004895E965B47eCBD;
131     
132     address public pool;
133     
134     uint256 public liquidityUnlock;
135     uint256 constant StakingAndMarketiningWithdrawDate = 1608422400; // 12/20/2020 @ 12:00am (UTC)
136     
137     uint256 public ethSent;
138     uint256 constant tokensPerETH = 10;
139     bool transferPaused;
140     bool presaleStarted; 
141     uint256 public lockedLiquidityAmount;
142     
143     // Will prevent burning when calling addLiquidity()
144     bool public burning;
145     
146 
147     
148     mapping(address => uint) _balances;
149     mapping(address => mapping(address => uint)) _allowances;
150     mapping(address => uint) ethSpent;
151 
152      modifier onlyOwner() {
153         require(msg.sender == owner, "You are not the owner");
154         _;
155     }
156     
157     constructor(address _vault) {
158         vault = _vault;
159         owner = msg.sender; 
160         _symbol = "$FIRE";
161         _name = "FireStarter";
162         _decimals = 18;
163         _totalSupply = 7500 ether;
164         uint tokensForContract = _totalSupply.sub(tokensForNftVault).sub(tokensForPartnerships); 
165         _balances[address(this)] = tokensForContract;
166         _balances[vault] = tokensForNftVault;
167         _balances[multisig] = tokensForPartnerships;
168         transferPaused = true;
169         liquidityUnlock = block.timestamp.add(365 days);
170         
171         emit Transfer(address(0), address(this), tokensForContract);
172         emit Transfer(address(0), vault, tokensForNftVault);
173         emit Transfer(address(0), multisig, tokensForPartnerships);
174         setUniswapPool();
175     }
176     
177     
178     receive() external payable {
179         
180         buyTokens();
181     }
182     
183     
184     function lockWithUnicrypt() external onlyOwner {
185         IERC20 liquidityTokens = IERC20(pool);
186         uint256 liquidityBalance = liquidityTokens.balanceOf(address(this));
187         uint256 timeToLuck = liquidityUnlock;
188         liquidityTokens.approve(address(unicrypt), liquidityBalance);
189 
190         unicrypt.depositToken{value: 0} (pool, liquidityBalance, timeToLuck);
191         lockedLiquidityAmount = lockedLiquidityAmount.add(liquidityBalance);
192     }
193     
194     function withdrawFromUnicrypt(uint256 amount) external onlyOwner{
195         unicrypt.withdrawToken(pool, amount);
196     }
197     
198     function setUniswapPool() public {
199         require(pool == address(0), "The pool is already created");
200         pool = uniswapFactory.createPair(address(this), uniswap.WETH());
201     }
202     
203     function claimTeamFeeAndAddLiquidity() external onlyOwner {
204        require(!teamClaimed);
205        uint256 amountETH = address(this).balance.mul(5).div(100); // 5% for the each of the owners 
206        uint256 forMultisig = address(this).balance.mul(35).div(100); // 35%
207        owner.transfer(amountETH);
208        owner2.transfer(amountETH);
209        owner3.transfer(amountETH);
210        multisig.transfer(forMultisig);
211        teamClaimed = true;
212        
213        addLiquidity();
214     }
215     
216     function startPresale() external onlyOwner { 
217         presaleStarted = true;
218     }
219     function buyTokens() public payable {
220         require(presaleStarted == true, "Preale didn't start yet");
221         require(!isStopped);
222         require(msg.value >= 1 ether, "You sent less than 1 ETH");
223         require(msg.value <= 10 ether, "You sent more than 10 ETH");
224         require(ethSent < 300 ether, "Hard cap reached");
225         require(ethSpent[msg.sender].add(msg.value) <= 10 ether, "You can't buy more");
226         uint256 tokens = msg.value.mul(tokensPerETH);
227         require(_balances[address(this)] >= tokens, "Not enough tokens in the contract");
228         _balances[address(this)] = _balances[address(this)].sub(tokens);
229         _balances[msg.sender] = _balances[msg.sender].add(tokens);
230         ethSpent[msg.sender] = ethSpent[msg.sender].add(msg.value);
231         tokensBought = tokensBought.add(tokens);
232         ethSent = ethSent.add(msg.value);
233         emit Transfer(address(this), msg.sender, tokens);
234     }
235    
236     function userEthSpenttInPresale(address user) external view returns(uint){
237         return ethSpent[user];
238     }
239     
240     function addLiquidity() internal {
241         uint256 ETH = address(this).balance;
242         uint tokensToBurn = balanceOf(address(this)).sub(tokensForUniswap).sub(teamTokens).sub(tokensForStakingAndMarketining);
243         transferPaused = false;
244         this.approve(address(uniswap), tokensForUniswap);
245         uniswap.addLiquidityETH
246         { value: ETH }
247         (
248             address(this),
249             tokensForUniswap,
250             tokensForUniswap,
251             ETH,
252             address(this),
253             block.timestamp + 5 minutes
254         );
255         burning = true;
256         if (tokensToBurn > 0) {
257          _balances[address(this)] = _balances[address(this)].sub(tokensToBurn);
258          _totalSupply = _totalSupply.sub(tokensToBurn);
259           emit Transfer(address(this), address(0), tokensToBurn);
260         }
261         if(!isStopped)
262             isStopped = true;
263             
264    }
265     
266     function name() public view returns (string memory) {
267         return _name;
268     }
269 
270     function symbol() public view returns (string memory) {
271         return _symbol;
272     }
273 
274     function decimals() public view returns (uint8) {
275         return _decimals;
276     }
277 
278     function totalSupply() public view override returns (uint256) {
279         return _totalSupply;
280     }
281 
282     function balanceOf(address account) public view override returns (uint256) {
283         return _balances[account];
284     }
285 
286 
287     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
288         _transfer(_msgSender(), recipient, amount);
289         return true;
290     }
291 
292     function allowance(address _owner, address spender) public view virtual override returns (uint256) {
293         return _allowances[_owner][spender];
294     }
295 
296     
297     function approve(address spender, uint256 amount) public virtual override returns (bool) {
298         _approve(_msgSender(), spender, amount);
299         return true;
300     }
301 
302     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
303         _transfer(sender, recipient, amount);
304         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
305         return true;
306     }
307 
308 
309     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
310         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
311         return true;
312     }
313 
314 
315     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
316         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
317         return true;
318     }
319     
320 
321     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
322         require(sender != address(0), "ERC20: transfer from the zero address");
323         require(recipient != address(0), "ERC20: transfer to the zero address");
324        if (transferPaused){
325            
326           if (recipient == address(pool) || recipient == address(uniswap) || recipient == address(uniswapFactory)){
327             revert();
328         }
329      }
330      
331         if (recipient == pool && _totalSupply > 6000 ether && burning) {
332         uint256 ToBurn = amount.mul(20).div(100);
333         uint256 ToTransfer = amount.sub(ToBurn);
334         
335         _burn(sender, ToBurn);
336         _beforeTokenTransfer(sender, recipient, ToTransfer);
337 
338         _balances[sender] = _balances[sender].sub(ToTransfer, "ERC20: transfer amount exceeds balance");
339         _balances[recipient] = _balances[recipient].add(ToTransfer);
340         emit Transfer(sender, recipient, ToTransfer);
341     }
342         else {
343         _beforeTokenTransfer(sender, recipient, amount);
344 
345         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
346         _balances[recipient] = _balances[recipient].add(amount);
347         emit Transfer(sender, recipient, amount);
348         }
349     }
350 
351     function _burn(address account, uint256 amount) internal virtual {
352         require(account != address(0), "ERC20: burn from the zero address");
353 
354         _beforeTokenTransfer(account, address(0), amount);
355 
356         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
357         _totalSupply = _totalSupply.sub(amount);
358         emit Transfer(account, address(0), amount);
359     }
360     
361     function burnMyTokensFOREVER(uint256 amount) external {
362         require(amount > 0);
363         address account = msg.sender;
364         _beforeTokenTransfer(account, address(0), amount);
365 
366         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
367         _totalSupply = _totalSupply.sub(amount);
368         emit Transfer(account, address(0), amount);
369     }
370 
371     function _approve(address _owner, address spender, uint256 amount) internal virtual {
372         require(_owner != address(0), "ERC20: approve from the zero address");
373         require(spender != address(0), "ERC20: approve to the zero address");
374 
375         _allowances[_owner][spender] = amount;
376         emit Approval(_owner, spender, amount);
377     }
378 
379     /**
380      * @dev Hook that is called before any transfer of tokens. This includes
381      * minting and burning.
382      *
383      * Calling conditions:
384      *
385      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
386      * will be to transferred to `to`.
387      * - when `from` is zero, `amount` tokens will be minted for `to`.
388      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
389      * - `from` and `to` are never both zero.
390      *
391      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
392      */
393     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
394     
395     function withdrawLockedTokensAfter1Year(address tokenAddress, uint256 tokenAmount) external onlyOwner  {
396         require(block.timestamp >= liquidityUnlock);
397         IERC20(tokenAddress).transfer(owner, tokenAmount);
398     }
399     
400     function withdrawStakingAndMarketining() external onlyOwner {
401         require(block.timestamp >= StakingAndMarketiningWithdrawDate);
402         transfer(multisig, tokensForStakingAndMarketining);
403     }
404 }
405 
406 
407 library SafeMath {
408     /**
409      * @dev Returns the addition of two unsigned integers, reverting on
410      * overflow.
411      *
412      * Counterpart to Solidity's `+` operator.
413      *
414      * Requirements:
415      *
416      * - Addition cannot overflow.
417      */
418     function add(uint256 a, uint256 b) internal pure returns (uint256) {
419         uint256 c = a + b;
420         require(c >= a, "SafeMath: addition overflow");
421 
422         return c;
423     }
424 
425     /**
426      * @dev Returns the subtraction of two unsigned integers, reverting on
427      * overflow (when the result is negative).
428      *
429      * Counterpart to Solidity's `-` operator.
430      *
431      * Requirements:
432      *
433      * - Subtraction cannot overflow.
434      */
435     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
436         return sub(a, b, "SafeMath: subtraction overflow");
437     }
438 
439     /**
440      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
441      * overflow (when the result is negative).
442      *
443      * Counterpart to Solidity's `-` operator.
444      *
445      * Requirements:
446      *
447      * - Subtraction cannot overflow.
448      */
449     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
450         require(b <= a, errorMessage);
451         uint256 c = a - b;
452 
453         return c;
454     }
455 
456     /**
457      * @dev Returns the multiplication of two unsigned integers, reverting on
458      * overflow.
459      *
460      * Counterpart to Solidity's `*` operator.
461      *
462      * Requirements:
463      *
464      * - Multiplication cannot overflow.
465      */
466     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
467         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
468         // benefit is lost if 'b' is also tested.
469         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
470         if (a == 0) {
471             return 0;
472         }
473 
474         uint256 c = a * b;
475         require(c / a == b, "SafeMath: multiplication overflow");
476 
477         return c;
478     }
479 
480     /**
481      * @dev Returns the integer division of two unsigned integers. Reverts on
482      * division by zero. The result is rounded towards zero.
483      *
484      * Counterpart to Solidity's `/` operator. Note: this function uses a
485      * `revert` opcode (which leaves remaining gas untouched) while Solidity
486      * uses an invalid opcode to revert (consuming all remaining gas).
487      *
488      * Requirements:
489      *
490      * - The divisor cannot be zero.
491      */
492     function div(uint256 a, uint256 b) internal pure returns (uint256) {
493         return div(a, b, "SafeMath: division by zero");
494     }
495 
496     /**
497      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
498      * division by zero. The result is rounded towards zero.
499      *
500      * Counterpart to Solidity's `/` operator. Note: this function uses a
501      * `revert` opcode (which leaves remaining gas untouched) while Solidity
502      * uses an invalid opcode to revert (consuming all remaining gas).
503      *
504      * Requirements:
505      *
506      * - The divisor cannot be zero.
507      */
508     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
509         require(b > 0, errorMessage);
510         uint256 c = a / b;
511         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
512 
513         return c;
514     }
515 
516     /**
517      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
518      * Reverts when dividing by zero.
519      *
520      * Counterpart to Solidity's `%` operator. This function uses a `revert`
521      * opcode (which leaves remaining gas untouched) while Solidity uses an
522      * invalid opcode to revert (consuming all remaining gas).
523      *
524      * Requirements:
525      *
526      * - The divisor cannot be zero.
527      */
528     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
529         return mod(a, b, "SafeMath: modulo by zero");
530     }
531 
532     /**
533      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
534      * Reverts with custom message when dividing by zero.
535      *
536      * Counterpart to Solidity's `%` operator. This function uses a `revert`
537      * opcode (which leaves remaining gas untouched) while Solidity uses an
538      * invalid opcode to revert (consuming all remaining gas).
539      *
540      * Requirements:
541      *
542      * - The divisor cannot be zero.
543      */
544     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
545         require(b != 0, errorMessage);
546         return a % b;
547     }
548 }