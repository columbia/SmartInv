1 /*
2  _______    ______   __     __  ________         ______   __    __      __ 
3 |       \  /      \ |  \   |  \|        \       /      \ |  \  |  \    /  \
4 | $$$$$$$\|  $$$$$$\| $$   | $$| $$$$$$$$      |  $$$$$$\| $$   \$$\  /  $$
5 | $$  | $$| $$__| $$| $$   | $$| $$__          | $$__| $$| $$    \$$\/  $$ 
6 | $$  | $$| $$    $$ \$$\ /  $$| $$  \         | $$    $$| $$     \$$  $$  
7 | $$  | $$| $$$$$$$$  \$$\  $$ | $$$$$         | $$$$$$$$| $$      \$$$$   
8 | $$__/ $$| $$  | $$   \$$ $$  | $$_____       | $$  | $$| $$_____ | $$    
9 | $$    $$| $$  | $$    \$$$   | $$     \      | $$  | $$| $$     \| $$    
10  \$$$$$$$  \$$   \$$     \$     \$$$$$$$$       \$$   \$$ \$$$$$$$$ \$$    
11 
12 */
13 
14 // SPDX-License-Identifier: MIT
15 pragma solidity ^0.8.7;
16 
17 interface IERC20 {
18     function totalSupply() external view returns (uint256);
19 
20     function balanceOf(address account) external view returns (uint256);
21 
22     function transfer(address recipient, uint256 amount) external returns (bool);
23 
24     function allowance(address owner, address spender) external view returns (uint256);
25 
26     function approve(address spender, uint256 amount) external returns (bool);
27 
28     function transferFrom(
29         address sender,
30         address recipient,
31         uint256 amount
32     ) external returns (bool);
33 
34     event Transfer(address indexed from, address indexed to, uint256 value);
35 
36     event Approval(address indexed owner, address indexed spender, uint256 value);
37 }
38 
39 abstract contract Context {
40     function _msgSender() internal view virtual returns (address) {
41         return msg.sender;
42     }
43 
44     function _msgData() internal view virtual returns (bytes calldata) {
45         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
46         return msg.data;
47     }
48 }
49 
50 abstract contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     constructor() {
56         _setOwner(_msgSender());
57     }
58 
59     function owner() public view virtual returns (address) {
60         return _owner;
61     }
62 
63     modifier onlyOwner() {
64         require(owner() == _msgSender(), "Ownable: caller is not the owner");
65         _;
66     }
67 
68     function renounceOwnership() public virtual onlyOwner {
69         _setOwner(address(0));
70     }
71 
72     function transferOwnership(address newOwner) public virtual onlyOwner {
73         require(newOwner != address(0), "Ownable: new owner is the zero address");
74         _setOwner(newOwner);
75     }
76 
77     function _setOwner(address newOwner) private {
78         address oldOwner = _owner;
79         _owner = newOwner;
80         emit OwnershipTransferred(oldOwner, newOwner);
81     }
82 }
83 
84 interface IFactory{
85         function createPair(address tokenA, address tokenB) external returns (address pair);
86 }
87 
88 interface IRouter {
89     function factory() external pure returns (address);
90     function WETH() external pure returns (address);
91     function addLiquidityETH(
92         address token,
93         uint amountTokenDesired,
94         uint amountTokenMin,
95         uint amountETHMin,
96         address to,
97         uint deadline
98     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
99 
100     function swapExactTokensForETHSupportingFeeOnTransferTokens(
101         uint amountIn,
102         uint amountOutMin,
103         address[] calldata path,
104         address to,
105         uint deadline) external;
106 }
107 
108 library Address{
109     function sendValue(address payable recipient, uint256 amount) internal {
110         require(address(this).balance >= amount, "Address: insufficient balance");
111 
112         (bool success, ) = recipient.call{value: amount}("");
113         require(success, "Address: unable to send value, recipient may have reverted");
114     }
115 }
116 
117 
118 contract PANDORABOX is IERC20, Context, Ownable {
119     using Address for address payable;
120     
121     mapping (address => uint256) private _rOwned;
122     mapping (address => uint256) private _tOwned;
123     mapping (address => mapping (address => uint256)) private _allowances;
124     mapping (address => bool) private _isExcludedFromFee;
125     mapping (address => bool) private _isExcluded;
126     mapping (address => bool) public allowedTransfer;
127     mapping (address => bool) private _isBlacklisted;
128 
129     address[] private _excluded;
130 
131     bool public tradingEnabled;
132     bool public swapEnabled;
133     bool private swapping;
134     
135     mapping(address => uint256) private _lastSell;
136     
137     uint256 public coolDownTime = 0 seconds;
138     bool public coolDownEnabled = false;
139     
140     modifier antiBot(address account){
141         require(tradingEnabled || allowedTransfer[account], "Trading not enabled yet");
142         _;
143     }
144 
145     IRouter public router;
146     address public pair;
147 
148     uint8 private constant _decimals = 9;
149     uint256 private constant MAX = ~uint256(0);
150 
151     uint256 private _tTotal = 10000000  * 10 **_decimals;
152     uint256 private _rTotal = (MAX - (MAX % _tTotal));
153     
154     uint256 public genesis_block;
155     
156     string private constant _name = "Pandora Box";
157     string private constant _symbol = "pBOX";
158 
159     uint256 public Pandora_Max_Buy_Limit = 50000 * 10**9;
160     uint256 public Pandora_Max_Sell_Limit = 50000 * 10**9;
161 
162     address private Pandora_Marketing_Wallet = 0x3d2ad72043Ed81F9C8BDd7518998d6f413874e47;
163     address private Pandora_Team_Wallet = 0x39D9693a340ADdBDB6AEAcA668105B2da7D1aB7e;
164 
165     uint256 public Pandora_Max_Wallet_Limit = 50000  * 10**9;
166     uint256 public swapTokensAtAmount = 20000 * 10**9;
167     
168 
169     struct Taxes {
170         uint256 rfi;
171         uint256 marketing;
172         uint256 liquidity; 
173         uint256 team;
174     }
175 
176     Taxes public sellTaxes = Taxes(0, 70, 10, 10);
177     Taxes public taxes = Taxes(0, 70, 10, 10);
178     
179 
180     struct TotFeesPaidStruct{
181         uint256 rfi;
182         uint256 marketing;
183         uint256 liquidity; 
184         uint256 team;
185     }
186     
187     TotFeesPaidStruct public totFeesPaid;
188 
189     struct valuesFromGetValues{
190       uint256 rAmount;
191       uint256 rTransferAmount;
192       uint256 rRfi;
193       uint256 rMarketing;
194       uint256 rLiquidity;
195       uint256 rTeam;
196       uint256 tTransferAmount;
197       uint256 tRfi;
198       uint256 tMarketing;
199       uint256 tLiquidity;
200       uint256 tTeam;
201     }
202 
203     event FeesChanged();
204     event UpdatedRouter(address oldRouter, address newRouter);
205 
206     modifier lockTheSwap {
207         swapping = true;
208         _;
209         swapping = false;
210     }
211 
212     constructor (address routerAddress) {
213         IRouter _router = IRouter(routerAddress);
214         address _pair = IFactory(_router.factory())
215             .createPair(address(this), _router.WETH());
216 
217         router = _router;
218         pair = _pair;
219         
220         excludeFromReward(pair);
221 
222         _rOwned[owner()] = _rTotal;
223         _isExcludedFromFee[address(this)] = true;
224         _isExcludedFromFee[owner()] = true;
225         _isExcludedFromFee[Pandora_Marketing_Wallet] = true;
226         _isExcludedFromFee[Pandora_Team_Wallet] = true;
227         
228         allowedTransfer[address(this)] = true;
229         allowedTransfer[owner()] = true;
230         allowedTransfer[pair] = true;
231         allowedTransfer[Pandora_Marketing_Wallet] = true;
232         allowedTransfer[Pandora_Team_Wallet] = true;
233 
234         emit Transfer(address(0), owner(), _tTotal);
235     }
236 
237     //std ERC20:
238     function name() public pure returns (string memory) {
239         return _name;
240     }
241     function symbol() public pure returns (string memory) {
242         return _symbol;
243     }
244     function decimals() public pure returns (uint8) {
245         return _decimals;
246     }
247 
248     //override ERC20:
249     function totalSupply() public view override returns (uint256) {
250         return _tTotal;
251     }
252 
253     function balanceOf(address account) public view override returns (uint256) {
254         if (_isExcluded[account]) return _tOwned[account];
255         return tokenFromReflection(_rOwned[account]);
256     }
257     
258     function allowance(address owner, address spender) public view override returns (uint256) {
259         return _allowances[owner][spender];
260     }
261 
262     function approve(address spender, uint256 amount) public  override antiBot(msg.sender) returns(bool) {
263         _approve(_msgSender(), spender, amount);
264         return true;
265     }
266 
267     function transferFrom(address sender, address recipient, uint256 amount) public override antiBot(sender) returns (bool) {
268         _transfer(sender, recipient, amount);
269 
270         uint256 currentAllowance = _allowances[sender][_msgSender()];
271         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
272         _approve(sender, _msgSender(), currentAllowance - amount);
273 
274         return true;
275     }
276 
277     function increaseAllowance(address spender, uint256 addedValue) public  antiBot(msg.sender) returns (bool) {
278         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
279         return true;
280     }
281 
282     function decreaseAllowance(address spender, uint256 subtractedValue) public  antiBot(msg.sender) returns (bool) {
283         uint256 currentAllowance = _allowances[_msgSender()][spender];
284         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
285         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
286 
287         return true;
288     }
289     
290     function transfer(address recipient, uint256 amount) public override antiBot(msg.sender) returns (bool)
291     { 
292       _transfer(msg.sender, recipient, amount);
293       return true;
294     }
295 
296     function isExcludedFromReward(address account) public view returns (bool) {
297         return _isExcluded[account];
298     }
299 
300     function reflectionFromToken(uint256 tAmount, bool deductTransferRfi) public view returns(uint256) {
301         require(tAmount <= _tTotal, "Amount must be less than supply");
302         if (!deductTransferRfi) {
303             valuesFromGetValues memory s = _getValues(tAmount, true, false);
304             return s.rAmount;
305         } else {
306             valuesFromGetValues memory s = _getValues(tAmount, true, false);
307             return s.rTransferAmount;
308         }
309     }
310 
311     function setTradingStatus(bool state) external onlyOwner{
312         tradingEnabled = state;
313         swapEnabled = state;
314         if(state == true && genesis_block == 0) genesis_block = block.number;
315     }
316 
317     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
318         require(rAmount <= _rTotal, "Amount must be less than total reflections");
319         uint256 currentRate =  _getRate();
320         return rAmount/currentRate;
321     }
322 
323     function excludeFromReward(address account) public onlyOwner() {
324         require(!_isExcluded[account], "Account is already excluded");
325         if(_rOwned[account] > 0) {
326             _tOwned[account] = tokenFromReflection(_rOwned[account]);
327         }
328         _isExcluded[account] = true;
329         _excluded.push(account);
330     }
331 
332     function includeInReward(address account) external onlyOwner() {
333         require(_isExcluded[account], "Account is not excluded");
334         for (uint256 i = 0; i < _excluded.length; i++) {
335             if (_excluded[i] == account) {
336                 _excluded[i] = _excluded[_excluded.length - 1];
337                 _tOwned[account] = 0;
338                 _isExcluded[account] = false;
339                 _excluded.pop();
340                 break;
341             }
342         }
343     }
344 
345     function excludeFromFee(address account) public onlyOwner {
346         _isExcludedFromFee[account] = true;
347     }
348 
349     function includeInFee(address account) public onlyOwner {
350         _isExcludedFromFee[account] = false;
351     }
352 
353     function isExcludedFromFee(address account) public view returns(bool) {
354         return _isExcludedFromFee[account];
355     }
356 
357     function setTaxes(uint256 _rfi, uint256 _marketing, uint256 _liquidity, uint256 _team) public onlyOwner {
358        taxes = Taxes(_rfi,_marketing,_liquidity,_team);
359         emit FeesChanged();
360     }
361     
362     function setSellTaxes(uint256 _rfi, uint256 _marketing, uint256 _liquidity, uint256 _team) public onlyOwner {
363        sellTaxes = Taxes(_rfi,_marketing,_liquidity,_team);
364         emit FeesChanged();
365     }
366 
367     function _reflectRfi(uint256 rRfi, uint256 tRfi) private {
368         _rTotal -=rRfi;
369         totFeesPaid.rfi +=tRfi;
370     }
371 
372     function _takeLiquidity(uint256 rLiquidity, uint256 tLiquidity) private {
373         totFeesPaid.liquidity +=tLiquidity;
374 
375         if(_isExcluded[address(this)])
376         {
377             _tOwned[address(this)]+=tLiquidity;
378         }
379         _rOwned[address(this)] +=rLiquidity;
380     }
381 
382     function _takeMarketing(uint256 rMarketing, uint256 tMarketing) private {
383         totFeesPaid.marketing +=tMarketing;
384 
385         if(_isExcluded[address(this)])
386         {
387             _tOwned[address(this)]+=tMarketing;
388         }
389         _rOwned[address(this)] +=rMarketing;
390     }
391     
392     function _takeTeam(uint256 rTeam, uint256 tTeam) private {
393         totFeesPaid.team +=tTeam;
394 
395         if(_isExcluded[address(this)])
396         {
397             _tOwned[address(this)]+=tTeam;
398         }
399         _rOwned[address(this)] +=rTeam;
400     }
401 
402 
403     
404     function _getValues(uint256 tAmount, bool takeFee, bool isSell) private view returns (valuesFromGetValues memory to_return) {
405         to_return = _getTValues(tAmount, takeFee, isSell);
406         (to_return.rAmount, to_return.rTransferAmount, to_return.rRfi, to_return.rMarketing, to_return.rLiquidity) = _getRValues1(to_return, tAmount, takeFee, _getRate());
407         (to_return.rTeam) = _getRValues2(to_return, takeFee, _getRate());
408         return to_return;
409     }
410 
411     function _getTValues(uint256 tAmount, bool takeFee, bool isSell) private view returns (valuesFromGetValues memory s) {
412 
413         if(!takeFee) {
414           s.tTransferAmount = tAmount;
415           return s;
416         }
417         Taxes memory temp;
418         if(isSell) temp = sellTaxes;
419         else temp = taxes;
420         
421         s.tRfi = tAmount*temp.rfi/100;
422         s.tMarketing = tAmount*temp.marketing/100;
423         s.tLiquidity = tAmount*temp.liquidity/100;
424         s.tTeam = tAmount*temp.team/100;
425         s.tTransferAmount = tAmount-s.tRfi-s.tMarketing-s.tLiquidity-s.tTeam;
426         return s;
427     }
428 
429     function _getRValues1(valuesFromGetValues memory s, uint256 tAmount, bool takeFee, uint256 currentRate) private pure returns (uint256 rAmount, uint256 rTransferAmount, uint256 rRfi,uint256 rMarketing, uint256 rLiquidity){
430         rAmount = tAmount*currentRate;
431 
432         if(!takeFee) {
433           return(rAmount, rAmount, 0,0,0);
434         }
435 
436         rRfi = s.tRfi*currentRate;
437         rMarketing = s.tMarketing*currentRate;
438         rLiquidity = s.tLiquidity*currentRate;
439         uint256 rTeam = s.tTeam*currentRate;
440         rTransferAmount =  rAmount-rRfi-rMarketing-rLiquidity-rTeam;
441         return (rAmount, rTransferAmount, rRfi,rMarketing,rLiquidity);
442     }
443     
444     function _getRValues2(valuesFromGetValues memory s, bool takeFee, uint256 currentRate) private pure returns (uint256 rTeam) {
445 
446         if(!takeFee) {
447           return(0);
448         }
449 
450         rTeam = s.tTeam*currentRate;
451         return (rTeam);
452     }
453 
454     function _getRate() private view returns(uint256) {
455         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
456         return rSupply/tSupply;
457     }
458 
459     function _getCurrentSupply() private view returns(uint256, uint256) {
460         uint256 rSupply = _rTotal;
461         uint256 tSupply = _tTotal;
462         for (uint256 i = 0; i < _excluded.length; i++) {
463             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
464             rSupply = rSupply-_rOwned[_excluded[i]];
465             tSupply = tSupply-_tOwned[_excluded[i]];
466         }
467         if (rSupply < _rTotal/_tTotal) return (_rTotal, _tTotal);
468         return (rSupply, tSupply);
469     }
470 
471     function _approve(address owner, address spender, uint256 amount) private {
472         require(owner != address(0), "ERC20: approve from the zero address");
473         require(spender != address(0), "ERC20: approve to the zero address");
474         _allowances[owner][spender] = amount;
475         emit Approval(owner, spender, amount);
476     }
477 
478     function _transfer(address from, address to, uint256 amount) private {
479         require(from != address(0), "ERC20: transfer from the zero address");
480         require(to != address(0), "ERC20: transfer to the zero address");
481         require(amount > 0, "Transfer amount must be greater than zero");
482         require(amount <= balanceOf(from),"You are trying to transfer more than your balance");
483         require(!_isBlacklisted[from] && !_isBlacklisted[to], "You are a bot");
484         
485         if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
486             require(tradingEnabled, "Trading not active");
487         }
488         
489         if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to] && block.number <= genesis_block + 3) {
490             require(to != pair, "Sells not allowed for first 3 blocks");
491         }
492         
493         if(from == pair && !_isExcludedFromFee[to] && !swapping){
494             require(amount <= Pandora_Max_Buy_Limit, "You are exceeding Pandora_Max_Buy_Limit");
495             require(balanceOf(to) + amount <= Pandora_Max_Wallet_Limit, "You are exceeding Pandora_Max_Wallet_Limit");
496         }
497         
498         if(from != pair && !_isExcludedFromFee[to] && !_isExcludedFromFee[from] && !swapping){
499             require(amount <= Pandora_Max_Sell_Limit, "You are exceeding Pandora_Max_Sell_Limit");
500             if(to != pair){
501                 require(balanceOf(to) + amount <= Pandora_Max_Wallet_Limit, "You are exceeding Pandora_Max_Wallet_Limit");
502             }
503             if(coolDownEnabled){
504                 uint256 timePassed = block.timestamp - _lastSell[from];
505                 require(timePassed >= coolDownTime, "Cooldown enabled");
506                 _lastSell[from] = block.timestamp;
507             }
508         }
509         
510         
511         if(balanceOf(from) - amount <= 10 *  10**decimals()) amount -= (10 * 10**decimals() + amount - balanceOf(from));
512         
513        
514         bool canSwap = balanceOf(address(this)) >= swapTokensAtAmount;
515         if(!swapping && swapEnabled && canSwap && from != pair && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
516             if(to == pair)  swapAndLiquify(swapTokensAtAmount, sellTaxes);
517             else  swapAndLiquify(swapTokensAtAmount, taxes);
518         }
519         bool takeFee = true;
520         bool isSell = false;
521         if(swapping || _isExcludedFromFee[from] || _isExcludedFromFee[to]) takeFee = false;
522         if(to == pair) isSell = true;
523 
524         _tokenTransfer(from, to, amount, takeFee, isSell);
525     }
526 
527 
528     //this method is responsible for taking all fee, if takeFee is true
529     function _tokenTransfer(address sender, address recipient, uint256 tAmount, bool takeFee, bool isSell) private {
530 
531         valuesFromGetValues memory s = _getValues(tAmount, takeFee, isSell);
532 
533         if (_isExcluded[sender] ) {  //from excluded
534                 _tOwned[sender] = _tOwned[sender]-tAmount;
535         }
536         if (_isExcluded[recipient]) { //to excluded
537                 _tOwned[recipient] = _tOwned[recipient]+s.tTransferAmount;
538         }
539 
540         _rOwned[sender] = _rOwned[sender]-s.rAmount;
541         _rOwned[recipient] = _rOwned[recipient]+s.rTransferAmount;
542         
543         if(s.rRfi > 0 || s.tRfi > 0) _reflectRfi(s.rRfi, s.tRfi);
544         if(s.rLiquidity > 0 || s.tLiquidity > 0) {
545             _takeLiquidity(s.rLiquidity,s.tLiquidity);
546             emit Transfer(sender, address(this), s.tLiquidity + s.tMarketing + s.tTeam);
547         }
548         if(s.rMarketing > 0 || s.tMarketing > 0) _takeMarketing(s.rMarketing, s.tMarketing);
549         if(s.rTeam > 0 || s.tTeam > 0) _takeTeam(s.rTeam, s.tTeam);
550         emit Transfer(sender, recipient, s.tTransferAmount);
551         
552     }
553 
554     function swapAndLiquify(uint256 contractBalance, Taxes memory temp) private lockTheSwap{
555         uint256 denominator = (temp.liquidity + temp.marketing + temp.team) * 2;
556         uint256 tokensToAddLiquidityWith = contractBalance * temp.liquidity / denominator;
557         uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
558 
559         uint256 initialBalance = address(this).balance;
560 
561         swapTokensForBNB(toSwap);
562 
563         uint256 deltaBalance = address(this).balance - initialBalance;
564         uint256 unitBalance= deltaBalance / (denominator - temp.liquidity);
565         uint256 bnbToAddLiquidityWith = unitBalance * temp.liquidity;
566 
567         if(bnbToAddLiquidityWith > 0){
568             // Add liquidity to pancake
569             addLiquidity(tokensToAddLiquidityWith, bnbToAddLiquidityWith);
570         }
571 
572         uint256 marketingAmt = unitBalance * 2 * temp.marketing;
573         if(marketingAmt > 0){
574             payable(Pandora_Marketing_Wallet).sendValue(marketingAmt);
575         }
576         uint256 teamAmt = unitBalance * 2 * temp.team;
577         if(teamAmt > 0){
578             payable(Pandora_Team_Wallet).sendValue(teamAmt);
579         }
580     }
581 
582     function addLiquidity(uint256 tokenAmount, uint256 bnbAmount) private {
583         // approve token transfer to cover all possible scenarios
584         _approve(address(this), address(router), tokenAmount);
585 
586         // add the liquidity
587         router.addLiquidityETH{value: bnbAmount}(
588             address(this),
589             tokenAmount,
590             0, // slippage is unavoidable
591             0, // slippage is unavoidable
592             owner(),
593             block.timestamp
594         );
595     }
596 
597     function swapTokensForBNB(uint256 tokenAmount) private {
598         // generate the uniswap pair path of token -> weth
599         address[] memory path = new address[](2);
600         path[0] = address(this);
601         path[1] = router.WETH();
602 
603         _approve(address(this), address(router), tokenAmount);
604 
605         // make the swap
606         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
607             tokenAmount,
608             0, // accept any amount of ETH
609             path,
610             address(this),
611             block.timestamp
612         );
613     }
614     
615     function airdropTokens(address[] memory accounts, uint256[] memory amounts) external onlyOwner{
616         require(accounts.length == amounts.length, "Arrays must have same size");
617         for(uint256 i = 0; i < accounts.length; i++){
618             _tokenTransfer(msg.sender, accounts[i], amounts[i], false, false);
619         }
620     }
621     
622     function bulkExcludeFee(address[] memory accounts, bool state) external onlyOwner{
623         for(uint256 i = 0; i < accounts.length; i++){
624             _isExcludedFromFee[accounts[i]] = state;
625         }
626     }
627 
628     function __Update_MarketingWallet(address newWallet) external onlyOwner{
629         Pandora_Marketing_Wallet = newWallet;
630     }
631     
632     function __Update_TeamWallet(address newWallet) external onlyOwner{
633         Pandora_Team_Wallet = newWallet;
634     }
635 
636     
637     function updateCooldown(bool state, uint256 time) external onlyOwner{
638         coolDownTime = time * 1 seconds;
639         coolDownEnabled = state;
640     }
641 
642     function updateSwapTokensAtAmount(uint256 amount) external onlyOwner{
643         swapTokensAtAmount = amount * 10**_decimals;
644     }
645 
646     function updateSwapEnabled(bool _enabled) external onlyOwner{
647         swapEnabled = _enabled;
648     }
649     
650     function updateIsBlacklisted(address account, bool state) external onlyOwner{
651         _isBlacklisted[account] = state;
652     }
653     
654     function bulkIsBlacklisted(address[] memory accounts, bool state) external onlyOwner{
655         for(uint256 i =0; i < accounts.length; i++){
656             _isBlacklisted[accounts[i]] = state;
657 
658         }
659     }
660     
661     function updateAllowedTransfer(address account, bool state) external onlyOwner{
662         allowedTransfer[account] = state;
663     }
664     
665     function updateMaxTxLimit(uint256 maxBuy, uint256 maxSell) external onlyOwner{
666         Pandora_Max_Buy_Limit = maxBuy * 10**decimals();
667         Pandora_Max_Sell_Limit = maxSell * 10**decimals();
668     }
669     
670     function updatePandora_Max_Wallet_Limit(uint256 amount) external onlyOwner{
671         Pandora_Max_Wallet_Limit = amount * 10**decimals();
672     }
673 
674     function updateRouterAndPair(address newRouter, address newPair) external onlyOwner{
675         router = IRouter(newRouter);
676         pair = newPair;
677     }
678     
679     //Use this in case BNB are sent to the contract by mistake
680     function rescueBNB(uint256 weiAmount) external onlyOwner{
681         require(address(this).balance >= weiAmount, "insufficient BNB balance");
682         payable(msg.sender).transfer(weiAmount);
683     }
684     
685 
686     function rescueAnyBEP20Tokens(address _tokenAddr, address _to, uint _amount) public onlyOwner {
687         IERC20(_tokenAddr).transfer(_to, _amount);
688     }
689 
690     receive() external payable{
691     }
692 }