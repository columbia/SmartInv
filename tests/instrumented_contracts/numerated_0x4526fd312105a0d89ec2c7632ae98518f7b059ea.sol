1 // SPDX-License-Identifier: MIT
2 
3 /**
4 ZVOID Team
5 
6 Website: https://www.zevoid.io/
7 Telegram: https://t.me/ZeVoidPortal
8 Twitter: https://twitter.com/ZeVoidOfficial
9 
10 
11 Dr_0x1
12 Head of development
13 */
14 
15 
16 
17 pragma solidity >=0.4.22 <0.9.0;
18 
19 
20 
21 interface IFactory {
22     function createPair(address tokenA, address tokenB) external returns (address pair);
23 }
24 
25 // implementation: https://etherscan.io/address/0x48d118c9185e4dbafe7f3813f8f29ec8a6248359#code
26 // proxy: https://etherscan.io/address/0x48d118c9185e4dbafe7f3813f8f29ec8a6248359#code
27 interface ItrustSwap {
28     function lockToken(
29         address _tokenAddress,
30         address _withdrawalAddress,
31         uint256 _amount,
32         uint256 _unlockTime,
33         bool _mintNFT
34     )external payable returns (uint256 _id);
35 
36     function transferLocks(uint256 _id, address _receiverAddress) external;
37     function addTokenToFreeList(address token) external;
38     function extendLockDuration(uint256 _id, uint256 _unlockTime) external;
39     function getFeesInETH(address _tokenAddress) external view returns (uint256);
40     function withdrawTokens(uint256 _id, uint256 _amount) external;
41 
42     function getDepositDetails(uint256 _id)view external returns (
43         address _tokenAddress, 
44         address _withdrawalAddress, 
45         uint256 _tokenAmount, 
46         uint256 _unlockTime, 
47         bool _withdrawn, 
48         uint256 _tokenId,
49         bool _isNFT,
50         uint256 _migratedLockDepositId,
51         bool _isNFTMinted);
52 }
53 
54 interface IPair {
55     function allowance(address owner, address spender) external view returns (uint);
56     function approve(address spender, uint value) external returns (bool);    
57     function transfer(address to, uint256 amount) external returns (bool);
58     function balanceOf(address owner) external view returns (uint);
59     function getReserves() external view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast);
60 }
61 
62 interface IRouter {
63     function factory() external pure returns (address);
64 
65     function WETH() external pure returns (address);
66 
67     function addLiquidityETH(
68         address token,
69         uint256 amountTokenDesired,
70         uint256 amountTokenMin,
71         uint256 amountETHMin,
72         address to,
73         uint256 deadline
74     )
75         external
76         payable
77         returns (
78             uint256 amountToken,
79             uint256 amountETH,
80             uint256 liquidity
81         ); 
82 
83     function removeLiquidityETHSupportingFeeOnTransferTokens(
84         address token,
85         uint liquidity,
86         uint amountTokenMin,
87         uint amountETHMin,
88         address to,
89         uint deadline
90     ) external returns (uint amountETH);
91 
92     function swapExactTokensForETHSupportingFeeOnTransferTokens(
93         uint256 amountIn,
94         uint256 amountOutMin,
95         address[] calldata path,
96         address to,
97         uint256 deadline
98     ) external;
99 
100     function swapExactETHForTokensSupportingFeeOnTransferTokens(
101         uint amountOutMin,
102         address[] calldata path,
103         address to,
104         uint deadline
105     ) external payable;
106 
107     function getAmountsOut(uint amountIn, address[] memory path) external view returns (uint[] memory amounts);
108     
109 }
110 
111 abstract contract Context {
112     function _msgSender() internal view virtual returns (address) {
113         return msg.sender;
114     }
115 
116     function _msgData() internal view virtual returns (bytes calldata) {
117         return msg.data;
118     }
119 }
120 
121 /**
122  * @dev Interface of the ERC20 standard as defined in the EIP.
123  */
124 interface IERC20 {
125     /**
126      * @dev Emitted when `value` tokens are moved from one account (`from`) to
127      * another (`to`).
128      *
129      * Note that `value` may be zero.
130      */
131     event Transfer(address indexed from, address indexed to, uint256 value);
132 
133     /**
134      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
135      * a call to {approve}. `value` is the new allowance.
136      */
137     event Approval(address indexed owner, address indexed spender, uint256 value);
138 
139     /**
140      * @dev Returns the amount of tokens in existence.
141      */
142     function totalSupply() external view returns (uint256);
143 
144     /**
145      * @dev Returns the amount of tokens owned by `account`.
146      */
147     function balanceOf(address account) external view returns (uint256);
148 
149     /**
150      * @dev Moves `amount` tokens from the caller's account to `to`.
151      *
152      * Returns a boolean value indicating whether the operation succeeded.
153      *
154      * Emits a {Transfer} event.
155      */
156     function transfer(address to, uint256 amount) external returns (bool);
157 
158     /**
159      * @dev Returns the remaining number of tokens that `spender` will be
160      * allowed to spend on behalf of `owner` through {transferFrom}. This is
161      * zero by default.
162      *
163      * This value changes when {approve} or {transferFrom} are called.
164      */
165     function allowance(address owner, address spender) external view returns (uint256);
166 
167     /**
168      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
169      *
170      * Returns a boolean value indicating whether the operation succeeded.
171      *
172      * IMPORTANT: Beware that changing an allowance with this method brings the risk
173      * that someone may use both the old and the new allowance by unfortunate
174      * transaction ordering. One possible solution to mitigate this race
175      * condition is to first reduce the spender's allowance to 0 and set the
176      * desired value afterwards:
177      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
178      *
179      * Emits an {Approval} event.
180      */
181     function approve(address spender, uint256 amount) external returns (bool);
182 
183     /**
184      * @dev Moves `amount` tokens from `from` to `to` using the
185      * allowance mechanism. `amount` is then deducted from the caller's
186      * allowance.
187      *
188      * Returns a boolean value indicating whether the operation succeeded.
189      *
190      * Emits a {Transfer} event.
191      */
192     function transferFrom(
193         address from,
194         address to,
195         uint256 amount
196     ) external returns (bool);
197 }
198 
199 
200 contract ERC20 is Context, IERC20 {
201     mapping(address => uint256) private _balances;
202 
203     mapping(address => mapping(address => uint256)) private _allowances;
204 
205     uint256 private _totalSupply;
206 
207     string public name;
208     string public symbol;
209     uint8 public decimals;
210 
211     constructor(string memory name_, string memory symbol_) {
212         name = name_;
213         symbol = symbol_;
214         decimals = 18;
215     }
216 
217     function totalSupply() public view virtual override returns (uint256) {
218         return _totalSupply;
219     }
220 
221     function balanceOf(address account) public view virtual override returns (uint256) {
222         return _balances[account];
223     }
224 
225     function transfer(address to, uint256 amount) public virtual override returns (bool) {}
226 
227     function allowance(address owner, address spender) public view virtual override returns (uint256) {
228         return _allowances[owner][spender];
229     }
230 
231     function approve(address spender, uint256 amount) public virtual override returns (bool) {
232         address owner = _msgSender();
233         _approve(owner, spender, amount);
234         return true;
235     }
236 
237     function transferFrom(
238         address from,
239         address to,
240         uint256 amount
241     ) public virtual override returns (bool) {}
242 
243     function _transfer(
244         address from,
245         address to,
246         uint256 amount
247     ) internal virtual {
248         require(from != address(0), "ERC20: transfer from the zero address");
249         require(to != address(0), "ERC20: transfer to the zero address");
250 
251         uint256 fromBalance = _balances[from];
252         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
253         unchecked {
254             _balances[from] = fromBalance - amount;
255         }
256         _balances[to] += amount;
257 
258         emit Transfer(from, to, amount);
259     }
260 
261     function _mint(address account, uint256 amount) internal virtual {
262         require(account != address(0), "ERC20: mint to the zero address");
263 
264         _totalSupply += amount;
265         _balances[account] += amount;
266         emit Transfer(address(0), account, amount);
267     }
268 
269     function _approve(
270         address owner,
271         address spender,
272         uint256 amount
273     ) internal virtual {
274         require(owner != address(0), "ERC20: approve from the zero address");
275         require(spender != address(0), "ERC20: approve to the zero address");
276 
277         _allowances[owner][spender] = amount;
278         emit Approval(owner, spender, amount);
279     }
280 
281     function _spendAllowance(
282         address owner,
283         address spender,
284         uint256 amount
285     ) internal virtual {
286         uint256 currentAllowance = allowance(owner, spender);
287         if (currentAllowance != type(uint256).max) {
288             require(currentAllowance >= amount, "ERC20: insufficient allowance");
289             unchecked {
290                 _approve(owner, spender, currentAllowance - amount);
291             }
292         }
293     }
294 
295 
296 }
297 
298 
299 
300 contract Zevoid is ERC20 {
301 
302   struct Taxes { 
303     uint256 lp_tax;
304     uint256 devMarketing_tax; 
305     uint256 ETH_gasfee_tax; 
306     uint256 team_tax; 
307     uint256 total; 
308     //ecosystem 
309     uint256 early_sell_tax; 
310     uint256 deadblock_tax; 
311     uint256 blacklist_tax; 
312   }
313   struct EarlyBuySellTracker {
314     uint256 buy_blockNumber;
315     uint256 sell_blockNumber;
316   }
317 
318   mapping(address => EarlyBuySellTracker) first_actions_map;
319   uint256 ebst_treshold = 60*60*24; //24h
320   mapping(address => uint256) private team_members;
321   
322   struct Shares{
323     uint256 share_team;
324     uint256 share_developmentMarketing;
325     uint256 share_Fees;
326     uint256 share_LP;
327   }
328   Shares private shareObj;
329 
330   address[] private team_member_list;  
331   address[] whitelist; 
332   address[] blacklist; 
333   address[] holders;
334 
335   uint256 private end_blockNr = 0;
336   uint256 _unlockTime_in_UTC = 210 days; //7months
337   uint256 public unlockTime_in_UTC_local;
338   bool public trading_enabled = false;
339 
340   uint256 public lp_eth_balance;
341   
342   Taxes public buy_taxes = Taxes({
343     lp_tax: 250, 
344     devMarketing_tax: 240, 
345     ETH_gasfee_tax: 10, 
346     team_tax: 200, 
347     total: (250 + 240 + 10 + 200),
348     //
349     early_sell_tax: 0, 
350     deadblock_tax: 7300, 
351     blacklist_tax: 7000 
352   });
353 
354   Taxes public sell_taxes = Taxes({
355     lp_tax: 250,
356     devMarketing_tax: 240,
357     ETH_gasfee_tax: 10,
358     team_tax: 200,
359     total: (250 + 240 + 10 + 200),
360     //
361     early_sell_tax: 1200, 
362     deadblock_tax: 700, 
363     blacklist_tax: 7000
364   });
365 
366 
367 uint256 totalTokenAmount = 7 * (10 ** 6) * (10 ** 18);
368 uint256 initialSupply;
369 uint256 BASISPOINT = 10000;
370 
371 uint256 public _maxWallet = (totalTokenAmount / 100); // 1%
372 uint256 public _maxTx = (totalTokenAmount * 50) / BASISPOINT; //0.5%
373 
374 IRouter uniswapV2Router;
375 IPair public uniswapV2Pair;
376 ItrustSwap externLocker;
377 uint256[] locks_ids;
378 address public owner;
379 address public zeOracle_address;
380 address private developmentMarketing_address; 
381 
382 
383 constructor(
384   address owner_0,
385   address router_v2_address, 
386   address externLocker_address,
387   address developmentMarketing_address_,
388   address zeOracle_address_ 
389   ) 
390   ERC20("ZeVoid", "ZVOID") 
391   {
392     //owner: multisig  
393     owner = owner_0;
394     
395     initialSupply = ((totalTokenAmount * 80) / 100);
396     
397     _mint(address(this), initialSupply); //80%
398     _mint(owner, (totalTokenAmount - initialSupply)); //20% for CEX
399 
400     zeOracle_address = zeOracle_address_;
401     developmentMarketing_address = developmentMarketing_address_;
402 
403     uniswapV2Router = IRouter(router_v2_address); 
404     address _pair = IFactory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
405 
406     uniswapV2Pair = IPair(_pair);
407     externLocker = ItrustSwap(externLocker_address);
408         
409     whitelist.push(address(this));
410     whitelist.push(owner);
411     whitelist.push(zeOracle_address);
412     //
413     whitelist.push(router_v2_address);
414     whitelist.push(_pair);
415     whitelist.push(externLocker_address);
416 
417 
418     //team members
419     //
420     team_member_list.push(0x13D47263B1B770AbD441AEAb67e5e00EDA11B1C5);    
421     team_members[0x13D47263B1B770AbD441AEAb67e5e00EDA11B1C5] = 2000; 
422     //
423     team_member_list.push(0xA795a19fB3797466517FDC7804fdB9E87DAeDfd4);    
424     team_members[0xA795a19fB3797466517FDC7804fdB9E87DAeDfd4] = 2000; 
425     //
426     team_member_list.push(0x11F184dFA987973933A5150531e5BeA2882b0687);    
427     team_members[0x11F184dFA987973933A5150531e5BeA2882b0687] = 2000; 
428     //
429     team_member_list.push(0x9A22519df3fac8b3829f8F3150ae2D6C3A6b809D);    
430     team_members[0x9A22519df3fac8b3829f8F3150ae2D6C3A6b809D] = 2000; 
431     //
432     team_member_list.push(0xDeE2DE3F2532791B5F58c5Ff0EE834586930cf99);    
433     team_members[0xDeE2DE3F2532791B5F58c5Ff0EE834586930cf99] = 2000; 
434     //
435 
436 
437     //
438     shareObj = Shares({
439         share_team: 3000,
440         share_developmentMarketing: 3400,
441         share_Fees: 100,
442         share_LP: 3500
443     });
444 }
445 
446 
447 
448 function plock(uint256 ethAmount) payable external onlyOwner {
449 
450   if((msg.value <= externLocker.getFeesInETH(address(uniswapV2Pair))))revert('Not enough liql!');
451 
452   (bool sent,) = payable(address(this)).call{value: ethAmount}("");
453   if(sent == true){
454 
455     if(initialSupply > 0 && ethAmount > 0){
456       addLiquidity(address(this), initialSupply, ethAmount);
457       lock_LP_Tokens();
458     }
459   }else{
460     revert('sending ETH in plock: fail');
461   }
462 }
463 
464 modifier onlyOwner(){
465   require(owner == msg.sender, 'Only Owner!');
466   _;
467 }
468 
469 modifier onlyOwnerZeOracle(){
470   require(zeOracle_address == msg.sender || owner == msg.sender, 'Only owner or zeOracle!');
471   _;
472 }
473 
474 modifier tradingAutoDisabled(){
475   bool before_trading_enabled = trading_enabled; 
476   trading_enabled = false;
477   _;
478   trading_enabled = before_trading_enabled;
479 }
480 
481 
482 function set_deadblock_tax(uint256 new_deadblock_buy_tax, uint256 new_deadblock_sell_tax) onlyOwner external{
483   buy_taxes.deadblock_tax = new_deadblock_buy_tax;
484   sell_taxes.deadblock_tax = new_deadblock_sell_tax;
485 }
486 
487 
488 function set_unlockTime_in_UTC(uint256 new_unlockTime_in_UTC) onlyOwner external{
489   _unlockTime_in_UTC = new_unlockTime_in_UTC;
490 }
491 
492 function set_early_sell_tax(uint256 new_early_sell_tax) onlyOwner external{
493   sell_taxes.early_sell_tax = new_early_sell_tax;
494 }
495 
496 
497 function set_blacklist_tax(uint256 new_blacklist_buy_tax, uint256 new_blacklist_sell_tax) onlyOwner external{
498   buy_taxes.blacklist_tax = new_blacklist_buy_tax;
499   sell_taxes.blacklist_tax = new_blacklist_sell_tax;
500 }
501 
502 
503 function set_buy_taxes(
504   uint256 new_lp_tax, 
505   uint256 new_devMarketing_tax,
506   uint256 new_ETH_gasfee_tax,
507   uint256 new_team_tax
508   ) onlyOwner external{
509   buy_taxes.lp_tax = new_lp_tax;
510   buy_taxes.devMarketing_tax = new_devMarketing_tax;
511   buy_taxes.ETH_gasfee_tax = new_ETH_gasfee_tax;
512   buy_taxes.team_tax = new_team_tax;
513   buy_taxes.total = buy_taxes.lp_tax + buy_taxes.devMarketing_tax + buy_taxes.ETH_gasfee_tax + buy_taxes.team_tax;
514 }
515 
516 
517 function set_sell_taxes(  
518   uint256 new_lp_tax, 
519   uint256 new_devMarketing_tax,
520   uint256 new_ETH_gasfee_tax,
521   uint256 new_team_tax
522 ) onlyOwner external{
523   sell_taxes.lp_tax = new_lp_tax;
524   sell_taxes.devMarketing_tax = new_devMarketing_tax;
525   sell_taxes.ETH_gasfee_tax = new_ETH_gasfee_tax;
526   sell_taxes.team_tax = new_team_tax;
527   sell_taxes.total = sell_taxes.lp_tax + sell_taxes.devMarketing_tax + sell_taxes.ETH_gasfee_tax + sell_taxes.team_tax;
528 }
529 
530 
531 
532 
533 
534 function set_owner(address new_owner) onlyOwner external{
535   add_whitelist(new_owner);
536   owner = new_owner;
537 }
538 
539 function set_zeOracle_address(address new_zeOracle_address) onlyOwner external{
540   zeOracle_address = new_zeOracle_address;
541 }
542 
543 
544 function set_maxTx_maxWallet(uint256 new_maxWallet_in_ZVOID, uint256 new__maxTx_in_ZVOID) onlyOwner external{  
545   _maxWallet = new_maxWallet_in_ZVOID; 
546   _maxTx = new__maxTx_in_ZVOID; 
547 }
548 
549 
550 function set_ebst_treshold(uint256 new_ebst_treshold) onlyOwner external{
551   ebst_treshold = new_ebst_treshold;
552 }
553 
554 function set_trading_enabled(bool new_trading_enabled, uint256 nBlock) onlyOwner external{
555   trading_enabled = new_trading_enabled;
556   if(end_blockNr == 0) end_blockNr = (block.number + nBlock); 
557 }
558 
559 function is_team_member(address team_member) public view returns(bool, uint256) {
560     for(uint256 i=0; i < team_member_list.length; i++){
561         if(team_member_list[i] == team_member){
562             return (true, i);
563         }
564     }
565     return (false, 0);
566 }
567 
568 function team_shares_correct() view private returns(bool) {
569     uint256 total_shares = 0;
570     for(uint256 i=0; i < team_member_list.length; i++){
571         total_shares += team_members[team_member_list[i]];
572     }
573     //
574     if((total_shares) <= BASISPOINT){
575         return true;
576     }
577     return false;
578 }
579 
580 function add_team_member(address team_member, uint256 share_perc_in_BASISPOINT) onlyOwner external returns(bool) {
581     (bool is_tm,) = is_team_member(team_member);
582     if(is_tm == true)return false;
583     //
584     team_member_list.push(team_member);    
585     team_members[team_member] = share_perc_in_BASISPOINT; 
586     //
587     if(team_shares_correct()==false)revert('Total share is greater than 100%.');
588     //
589     return true;
590 }
591 
592 function delete_team_member(address team_member) onlyOwner external returns(bool){    
593     (bool is_tm, uint256 i) = is_team_member(team_member);
594     if(is_tm == true){
595         delete team_member_list[i];
596         delete team_members[team_member];
597         return true;
598     } 
599   return false;
600 }
601 
602 function get_team_member_list() public view returns(address[] memory) {
603     return team_member_list;
604 }
605 
606 function set_team_member(address old_team_member, address new_team_member, uint256 share_perc_in_BASISPOINT) onlyOwner external returns(bool){
607     (bool is_tm, uint256 i) = is_team_member(old_team_member);
608     if(is_tm == true){
609         team_member_list[i] = new_team_member;
610         //
611         delete team_members[old_team_member];
612         team_members[new_team_member] = share_perc_in_BASISPOINT;
613         //
614         if(team_shares_correct()==false)revert('Total share is greater than 100%.');
615         //
616         return true;
617     }
618     return false;
619 }
620 
621 
622 function is_whitelisted(address user) public view returns(bool) {
623   for(uint256 i=0; i<whitelist.length; i++){
624     if(whitelist[i] == user)return true;
625   }
626   return false;
627 }
628 
629 function is_blacklisted(address user) public view returns(bool) {
630   for(uint256 i=0; i<blacklist.length; i++){
631     if(blacklist[i] == user)return true;
632   }
633   return false;
634 }
635 
636 
637 function get_holders() public view returns(address[] memory){
638   return holders;
639 }
640 
641 
642 function add_or_remove_holder(address user) private returns(uint256) {
643   uint256 amount = balanceOf(user);
644   
645   for(uint256 i=0; i<holders.length; i++){
646     if(holders[i] == user && amount == 0 || holders[i] == address(0)){
647       delete holders[i];
648       return 2;
649     }
650   }
651   
652   if(user != address(0) && amount > 0){
653     holders.push(user); 
654     return 1;
655   }
656   
657   return 0;
658 }
659 
660 
661 function add_whitelist(address user) onlyOwner public returns(address){
662   for(uint256 i=0; i < whitelist.length; i++){
663     if(whitelist[i] == user){
664       return user;
665     }
666   }
667   whitelist.push(user);
668   return user; 
669 }
670 
671 function remove_whitelist(address user) external onlyOwner returns(address){
672   for(uint256 i=0; i<whitelist.length; i++){
673     if(whitelist[i] == user){
674       delete whitelist[i];
675       return user;
676     }
677   }
678   return user;
679 }
680 
681 function add_blacklist(address user) external onlyOwner returns(address){
682   for(uint256 i=0; i<blacklist.length; i++){
683     if(blacklist[i] == user){
684       return user;
685     }
686   }
687   blacklist.push(user);
688   return user;  
689 }
690 
691 function remove_blacklist(address user) external onlyOwner returns(address){
692   for(uint256 i=0; i<blacklist.length; i++){
693     if(blacklist[i] == user){
694       delete blacklist[i];
695       return user;
696     }
697   }
698   return user;
699 }
700 
701 
702   function transferFrom(
703       address from,
704       address to,
705       uint256 amount
706   ) public virtual override returns (bool) {    
707     require( 
708       (is_whitelisted(from) && is_whitelisted(to)) || 
709       trading_enabled == true,
710       'Paused!'
711     );
712 
713     address spender = _msgSender(); 
714     uint256 tax = 0;
715     
716     if(to == address(uniswapV2Pair) && from != address(uniswapV2Router)){
717       tax = taxnomics_sell(from); 
718     }
719     
720     _spendAllowance(from, spender, amount);
721 
722     if(tax > 0){
723       uint256 tax_amount = (amount * tax) / BASISPOINT; 
724       amount -= tax_amount;
725       if(tax_amount > 0)_transfer(from, address(this), tax_amount);
726     }
727     //
728     _transfer(from, to, amount);
729     
730     //
731     add_or_remove_holder(to);
732     add_or_remove_holder(from);
733     //
734 
735     if(to == address(uniswapV2Pair) && from != address(uniswapV2Router)){
736       if(amount > _maxTx && is_whitelisted(from)==false)revert('_maxWallet or _maxTx reached!');
737     }
738     
739     return true;
740   }
741 
742 
743   function transfer(address to, uint256 amount) public virtual override returns (bool) {  
744     address owner_ = _msgSender();
745     require( 
746       (is_whitelisted(owner_) && is_whitelisted(to)) || 
747       trading_enabled == true,
748       'Paused!'
749     );
750     
751     uint256 tax = 0;
752     //
753     if(owner_ == address(uniswapV2Pair) && to != address(uniswapV2Router)){
754       first_actions_map[to] = EarlyBuySellTracker({buy_blockNumber: block.timestamp, sell_blockNumber: (block.timestamp + ebst_treshold)});
755       tax = taxnomics_buy(to);
756     }
757     //
758     if(tax > 0){
759       uint256 tax_amount = (amount * tax) / BASISPOINT; 
760       amount -= tax_amount;
761       if(tax_amount > 0)_transfer(owner_, address(this), tax_amount);
762     }
763     //
764     _transfer(owner_, to, amount);
765     //
766     add_or_remove_holder(to);
767     add_or_remove_holder(owner_);
768     //
769 
770     if(owner_ == address(uniswapV2Pair) && to != address(uniswapV2Router)){
771       if(maxTx_maxWallet_reached(to, amount)==true)revert('_maxWallet or _maxTx reached!');
772     }
773     
774     return true;
775   }
776   
777 
778   function maxTx_maxWallet_reached(address user, uint256 amount) private view returns(bool){    
779     if((balanceOf(user) > _maxWallet && is_whitelisted(user)==false) || 
780     (amount > _maxTx && is_whitelisted(user)==false)) return true;
781     return false;
782   }
783 
784   
785   function taxnomics_buy(address wallet) private view returns(uint256) {    
786     uint256 tax = buy_taxes.total; 
787 
788     if(is_whitelisted(wallet)){
789       tax = 0;
790 
791     }else if(is_blacklisted(wallet)){   
792       tax = buy_taxes.blacklist_tax;
793 
794     }
795     else if(block.number > 0 && end_blockNr > 0 && block.number <= end_blockNr){
796       tax = buy_taxes.deadblock_tax;
797     }
798 
799     return tax;
800   }
801 
802 
803 
804   function taxnomics_sell(address wallet) private view returns(uint256) {    
805     uint256 tax = sell_taxes.total; 
806     
807     if(is_whitelisted(wallet)){
808       tax = 0;
809 
810     }else if(is_blacklisted(wallet)){   
811       tax = sell_taxes.blacklist_tax;
812 
813     }else if(block.number > 0 && end_blockNr > 0 && block.number <= end_blockNr){
814       tax = sell_taxes.deadblock_tax;
815       
816     }else if(
817       block.timestamp >= first_actions_map[wallet].buy_blockNumber &&
818       block.timestamp <= first_actions_map[wallet].sell_blockNumber){
819       tax = sell_taxes.early_sell_tax;
820     }
821 
822     return tax;
823   }
824 
825 
826   function addLiquidity(address to, uint256 tokenAmount, uint256 ethAmount) private returns(uint256) {
827     _approve(address(this), address(uniswapV2Router), tokenAmount);
828     (
829       ,
830       ,
831       uint256 liquidity
832     ) = uniswapV2Router.addLiquidityETH{value: ethAmount}(
833         address(this), 
834         tokenAmount, 
835         0,
836         0, 
837         to, 
838         block.timestamp + 360 
839     );
840     return liquidity;
841   }
842 
843 
844   function swapTokensForETH(address to, uint256 tokenAmount) private {
845     address[] memory path = new address[](2);
846     path[0] = address(this);
847     path[1] = uniswapV2Router.WETH();
848 
849     _approve(address(this), address(uniswapV2Router), tokenAmount);
850 
851     uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
852       tokenAmount, 
853       0, 
854       path, 
855       to,
856       block.timestamp + 360
857     );
858   }
859 
860 
861   function release_all(uint256 chart_friendly_release_token_amount) external onlyOwnerZeOracle {
862     if((chart_friendly_release_token_amount == 0) && (balanceOf(address(this)) < chart_friendly_release_token_amount))revert('release_all() error');
863 
864     address msgSender = address(this);
865     uint256 bal_before = msgSender.balance;
866     swapTokensForETH(msgSender, chart_friendly_release_token_amount);
867     uint256 ethBalance = msgSender.balance - bal_before;
868     
869     if(msgSender.balance < bal_before)revert('send ethBalance: fail');
870     //
871     release_team_tax(ethBalance);
872     //
873     release_ETH(zeOracle_address, ethBalance, shareObj.share_Fees);
874 
875     release_ETH(developmentMarketing_address, ethBalance, shareObj.share_developmentMarketing);
876     //  
877     // //LP balance 
878     lp_eth_balance += (ethBalance * shareObj.share_LP) / BASISPOINT;
879   }
880 
881 
882   function release_team_tax(uint256 ethBalance) private tradingAutoDisabled{
883 
884     uint256 amount = (ethBalance * shareObj.share_team) / BASISPOINT;
885     
886     for(uint256 i=0; i < team_member_list.length; i++){
887       address to = team_member_list[i];
888       uint256 ethAmount = (amount * team_members[to]) / (BASISPOINT);
889       if(ethAmount > 0){
890         (bool sent,) = payable(to).call{value: ethAmount}("");
891         if(sent == false)revert('send ether: fail');
892       }
893       ethAmount = 0;
894     }
895   }
896 
897 
898   function release_ETH(address to, uint256 ethBalance, uint256 shares) 
899   private tradingAutoDisabled returns(bool) {
900     uint256 ethAmount = (ethBalance * shares) / BASISPOINT;
901 
902     if(ethAmount > 0){
903       (bool sent,) = payable(to).call{value: ethAmount}("");
904       if(sent == false)revert('send ethAmount: fail');
905       ethAmount = 0;
906       return true;
907     }else{
908       return false;
909     }
910   }
911 
912 
913 function pool(uint256 pool_ethAmount) external onlyOwnerZeOracle tradingAutoDisabled{
914 
915   if(lp_eth_balance == 0 || pool_ethAmount == 0)revert('cannot send 0!');
916   
917   address msgSender = msg.sender;
918   uint256 ethAmount = pool_ethAmount / 2;
919   uint256 tokenAmount_before = balanceOf(msgSender);
920   //
921   address[] memory path = new address[](2);
922   path[0] = uniswapV2Router.WETH();
923   path[1] = address(this);
924   
925   uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{
926       value: ethAmount
927     }(
928     0,
929     path,
930     msgSender,
931     block.timestamp + (300)
932   );
933   
934   uint256 tokenAmount_after = balanceOf(msgSender) - tokenAmount_before;
935   uint256 b_balance = balanceOf(address(this));
936   _transfer(msgSender, address(this), tokenAmount_after);
937   uint256 a_balance = balanceOf(address(this)) - b_balance;
938 
939   if(a_balance != tokenAmount_after)revert('Error: while pooling');
940   
941   addLiquidity(address(this), tokenAmount_after, ethAmount);
942   lp_eth_balance -= pool_ethAmount;
943 }
944 
945 
946 function get_lock_ids() public view returns(uint256[] memory) {
947   return locks_ids;
948 } 
949 
950 
951 function lock_LP_Tokens() private {
952   uint256 _amount = uniswapV2Pair.balanceOf(address(this));
953   bool allowanceAmount = uniswapV2Pair.approve(address(externLocker), _amount); 
954 
955   if(allowanceAmount == true){
956     uint256 ethAmount = externLocker.getFeesInETH(address(uniswapV2Pair));  
957     
958     uint256 endTime = _unlockTime_in_UTC + block.timestamp;
959     unlockTime_in_UTC_local = endTime;
960     uint256 externLocker_id = externLocker.lockToken{value: ethAmount}(address(uniswapV2Pair), address(this), _amount, endTime, false);
961 
962     locks_ids.push(externLocker_id); 
963 
964   }else{
965     revert('approve in lock_LP_Tokens: fail');
966   }
967 }
968 
969 
970 function extendLockDuration() external onlyOwnerZeOracle{
971   for(uint256 i=0; i<locks_ids.length; i++){
972     uint256 endTime = _unlockTime_in_UTC + block.timestamp;
973     unlockTime_in_UTC_local = endTime;
974     externLocker.extendLockDuration(locks_ids[i], endTime);
975   }
976 }
977 
978 
979 function get_lp_tokens() public onlyOwner {
980   if(block.timestamp < unlockTime_in_UTC_local)revert('lp tokens locked.');
981   //
982   for(uint256 i=0; i<locks_ids.length; i++){
983     (, , uint256 _tokenAmount, , , , , , ) = externLocker.getDepositDetails(locks_ids[i]);
984     externLocker.withdrawTokens(locks_ids[i], _tokenAmount);
985   }
986   //
987   uint256 lpTokens = uniswapV2Pair.balanceOf(address(this));
988   if(lpTokens > 0)uniswapV2Pair.transfer(owner, lpTokens);
989 }
990  
991 
992 function get_contractsETH(address newContract) public onlyOwner returns(bool){  
993   uint256 ethAmount2 = address(this).balance;
994   if(ethAmount2 > 0){
995     (bool sent,) = payable(newContract).call{value: ethAmount2}("");
996     return sent;
997   }
998   return false;
999 }
1000  
1001 
1002 function ETH_migration(address newContract) external onlyOwner returns(bool) {
1003   // 
1004   get_lp_tokens(); 
1005   //
1006   uint256 lpTokens = uniswapV2Pair.balanceOf(address(this));
1007   bool approved = uniswapV2Pair.approve(address(uniswapV2Router), lpTokens);
1008   bool res = false;
1009   //
1010   if(lpTokens > 0 && approved==true){
1011     uint256 ethAmount1 = uniswapV2Router.removeLiquidityETHSupportingFeeOnTransferTokens(
1012       address(uniswapV2Pair),
1013       lpTokens,
1014       0,
1015       0,
1016       newContract,
1017       (block.timestamp + 360)
1018     );
1019     if(ethAmount1 > 0) res = true;
1020   }
1021   //
1022   if(get_contractsETH(newContract) ==true) res=true;
1023   return res;
1024 }
1025 
1026   
1027   receive() external payable {}
1028   fallback() external payable{
1029     revert('fallback()');
1030   }
1031 
1032 }