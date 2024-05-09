1 /*
2 Welcome to BWIN - Bet To Win, the entertainment revolution in the cryptocurrency world. 
3 Imagine a place where simplicity meets excitement, all at your fingertips thanks to the Telegram user interface. 
4 At BWIN, we've crafted a cryptocurrency casino that reshapes the way we engage with gambling.
5 
6 $BWIN Token - Tokenomics
7 
8 The transaction tax distribution is as follows:
9    -Marketing Wallet 4% - Funds dedicated to promoting and advancing our brand presence.
10    -Game Fees 1% - This fee is allocated to cover the gwei expenses, ensuring players aren't burdened with gwei ETH fees when playing with our bot
11 
12 Socials:
13 Whitepaper: https://bwin.gitbook.io/bwin
14 Telegram: https://t.me/bwin_portal
15 X: https://twitter.com/bwin_blockchain
16 */
17 
18 // SPDX-License-Identifier: Unlicensed
19 pragma solidity 0.8.20;
20 
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {
23         return msg.sender;
24     }
25 }
26 
27 interface IERC20 {
28     function totalSupply() external view returns (uint256);
29     function balanceOf(address account) external view returns (uint256);
30     function transfer(address recipient, uint256 amount) external returns (bool);
31     function allowance(address owner, address spender) external view returns (uint256);
32     function approve(address spender, uint256 amount) external returns (bool);
33     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
34     event Transfer(address indexed from, address indexed to, uint256 value);
35     event Approval(address indexed owner, address indexed spender, uint256 value);
36 }
37 
38 library SafeMath {
39     function add(uint256 a, uint256 b) internal pure returns (uint256) {
40         uint256 c = a + b;
41         require(c >= a, "SafeMath: addition overflow");
42         return c;
43     }
44 
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         return sub(a, b, "SafeMath: subtraction overflow");
47     }
48 
49     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
50         require(b <= a, errorMessage);
51         uint256 c = a - b;
52         return c;
53     }
54 
55     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
56         if (a == 0) {
57             return 0;
58         }
59         uint256 c = a * b;
60         require(c / a == b, "SafeMath: multiplication overflow");
61         return c;
62     }
63 
64     function div(uint256 a, uint256 b) internal pure returns (uint256) {
65         return div(a, b, "SafeMath: division by zero");
66     }
67 
68     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
69         require(b > 0, errorMessage);
70         uint256 c = a / b;
71         return c;
72     }
73 
74 }
75 
76 contract Ownable is Context {
77     address private _owner;
78     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
79 
80     constructor () {
81         address msgSender = _msgSender();
82         _owner = msgSender;
83         emit OwnershipTransferred(address(0), msgSender);
84     }
85 
86     function owner() public view returns (address) {
87         return _owner;
88     }
89 
90     modifier onlyOwner() {
91         require(_owner == _msgSender(), "Ownable: caller is not the owner");
92         _;
93     }
94 
95     function renounceOwnership() public virtual onlyOwner {
96         emit OwnershipTransferred(_owner, address(0));
97         _owner = address(0);
98     }
99 
100 }
101 interface IUniswapV2Factory {
102     function createPair(address tokenA, address tokenB) external returns (address pair);
103 }
104 
105 interface IUniswapV2Router02 {
106     function swapExactTokensForETHSupportingFeeOnTransferTokens(
107         uint amountIn,
108         uint amountOutMin,
109         address[] calldata path,
110         address to,
111         uint deadline
112     ) external;
113     function factory() external pure returns (address);
114     function WETH() external pure returns (address);
115     function addLiquidityETH(
116         address token,
117         uint amountTokenDesired,
118         uint amountTokenMin,
119         uint amountETHMin,
120         address to,
121         uint deadline
122     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
123 }
124 
125 contract BWIN is Context, IERC20, Ownable {
126     using SafeMath for uint256;
127     mapping (address => uint256) private _balance;
128     mapping (address => mapping (address => uint256)) private _allowances;
129     mapping (address => bool) private _isExcludedFromFee;
130     mapping (address => bool) private bots;
131     mapping(address => uint256) private _holderLastTransferTimestamp;
132     bool public transferDelayEnabled = true;
133     address payable private _taxWallet;
134 
135     uint256 private _initialBuyTax=20;
136     uint256 private _initialSellTax=25;
137     uint256 private _finalBuyTax=5;
138     uint256 private _finalSellTax=5;
139     uint256 private _reduceBuyTaxAt=20;
140     uint256 private _reduceSellTaxAt=20;
141     uint256 private _preventSwapBefore=20;
142     uint256 private _buyCount=0;
143 
144     uint8 private constant _decimals = 9;
145     uint256 private constant _totalSupply = 1000000000 * 10**_decimals;
146     string private constant _name = "BWIN";
147     string private constant _symbol = "BWIN";
148     uint256 public _maxTxAmount = 7500000 * 10**_decimals;
149     uint256 public _maxWalletSize = 10000000 * 10**_decimals;
150     uint256 public _taxSwapThreshold= 10000000 * 10**_decimals;
151     uint256 public _maxTaxSwap= 10000000 * 10**_decimals;
152 
153     IUniswapV2Router02 private uniswapV2Router;
154     address private uniswapV2Pair;
155     bool private tradingOpen;
156     bool private inSwap = false;
157     bool private swapEnabled = false;
158 
159     event MaxTxAmountUpdated(uint _maxTxAmount);
160     modifier lockTheSwap {
161         inSwap = true;
162         _;
163         inSwap = false;
164     }
165 
166     address public secondaryContract;
167 
168     function setControlContract(address _secondaryContract) public onlyOwner {
169         secondaryContract = _secondaryContract;
170     }
171 
172     /*//////////////////////////////////////////////////////////////
173                         START GAME VAR - LOGIC
174     //////////////////////////////////////////////////////////////*/
175     mapping(address => string) private gameKeys;  
176     mapping(address => bool) public isAuthenticated; 
177     mapping(address => uint256) private _lockedBalance;
178     mapping(address => uint256) public gamesPlayed;
179     address constant DEAD_WALLET = 0x000000000000000000000000000000000000dEaD;
180     address constant TEAM_WALLET = 0x395Cb433E3eFaDF92F596A4F6F85f90A32aD0718;
181     
182     address[] public holders;
183     mapping(address => bool) public isHolder;
184     mapping(address => uint256) public paymentAmounts;
185     mapping(address => uint256) public lastRewardAmounts;
186     address[] public lastRewardedHolders;
187 
188     address[] private allUsers;
189     address[] public activePlayers;
190     mapping(address => uint256) public playerGames;
191 
192     Winner[] public winners;
193     Game[] public games;
194 
195     struct Game {
196         int64 telegramId;
197         uint256 gameId;
198         address[] players;
199         uint256[] bets;
200         uint256 totalBet;
201         bool isActive;
202     }
203 
204     struct Winner {
205         address winnerAddress;
206         uint256 amountWon;
207         uint256 gameId;
208         int64 telegramId;
209     }
210 
211     event Authenticated(address indexed user, string secretKey);
212     event GameStarted(int64 indexed telegramId, uint256 indexed gameId, address[] players, uint256[] bets, uint256 totalBet);
213 
214     event WinnerDeclared(int64 indexed telegramId, uint256 indexed gameId, address[] winners, uint256 totalBet, uint256 eachWinnerGets, uint256 toTeamWallet, uint256 toPlayers);
215     event WinnerAdded(address indexed winnerAddress, uint256 amountWon, uint256 gameId, int64 telegramId);
216     event FundsReleased(uint256 gameId, address[] players, uint256[] amounts);
217 
218     /*//////////////////////////////////////////////////////////////
219                             END GAME VAR - LOGIC
220     //////////////////////////////////////////////////////////////*/
221 
222     constructor () {
223         _taxWallet = payable(_msgSender());
224         _balance[_msgSender()] = _totalSupply;
225         _isExcludedFromFee[owner()] = true;
226         _isExcludedFromFee[address(this)] = true;
227         _isExcludedFromFee[_taxWallet] = true;
228 
229         emit Transfer(address(0), _msgSender(), _totalSupply);
230     }
231 
232     function name() public pure returns (string memory) {
233         return _name;
234     }
235 
236     function symbol() public pure returns (string memory) {
237         return _symbol;
238     }
239 
240     function decimals() public pure returns (uint8) {
241         return _decimals;
242     }
243 
244     function totalSupply() public pure override returns (uint256) {
245         return _totalSupply;
246     }
247 
248     function balanceOf(address account) public view override returns (uint256) {
249         return _balance[account];
250     }
251 
252     function transfer(address recipient, uint256 amount) public override returns (bool) {
253         _transfer(_msgSender(), recipient, amount);
254         return true;
255     }
256 
257     function allowance(address owner, address spender) public view override returns (uint256) {
258         return _allowances[owner][spender];
259     }
260 
261     function approve(address spender, uint256 amount) public override returns (bool) {
262         _approve(_msgSender(), spender, amount);
263         return true;
264     }
265 
266     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
267         _transfer(sender, recipient, amount);
268         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
269         return true;
270     }
271 
272     function _approve(address owner, address spender, uint256 amount) private {
273         require(owner != address(0), "ERC20: approve from the zero address");
274         require(spender != address(0), "ERC20: approve to the zero address");
275         _allowances[owner][spender] = amount;
276         emit Approval(owner, spender, amount);
277     }
278 
279     function _transfer(address from, address to, uint256 amount) private {
280         require(from != address(0), "ERC20: transfer from the zero address");
281         require(to != address(0), "ERC20: transfer to the zero address");
282         require(amount > 0, "Transfer amount must be greater than zero");
283 
284         uint256 taxAmount = 0;
285 
286         if (from != owner() && to != owner()) {
287             taxAmount = amount.mul((_buyCount > _reduceBuyTaxAt) ? _finalBuyTax : _initialBuyTax).div(100);
288 
289             if (transferDelayEnabled) {
290                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
291                     require(
292                         _holderLastTransferTimestamp[tx.origin] < block.number,
293                         "_transfer:: Transfer Delay enabled. Only one purchase per block allowed."
294                     );
295                     _holderLastTransferTimestamp[tx.origin] = block.number;
296                 }
297             }
298 
299             if (from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
300                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
301                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
302                 _buyCount++;
303 
304                 if (!isHolder[to] && to != address(0)) {
305                     holders.push(to);
306                     isHolder[to] = true;
307                 }
308 
309                 paymentAmounts[to] += amount;
310             }
311 
312             if (to == uniswapV2Pair && from != address(this)) {
313                 taxAmount = amount.mul((_buyCount > _reduceSellTaxAt) ? _finalSellTax : _initialSellTax).div(100);
314 
315                 if (_balance[from] == 0 && isHolder[from]) {
316                     for (uint256 i = 0; i < holders.length; i++) {
317                         if (holders[i] == from) {
318                             holders[i] = holders[holders.length - 1];
319                             holders.pop();
320                             break;
321                         }
322                     }
323                     isHolder[from] = false;
324                     paymentAmounts[from] = 0;
325                 } else if (isHolder[from]) {
326                     paymentAmounts[from] -= amount;
327                 }
328             }
329 
330             uint256 contractTokenBalance = balanceOf(address(this));
331             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance > _taxSwapThreshold && _buyCount > _preventSwapBefore) {
332                 swapTokensForEth(min(amount, min(contractTokenBalance, _maxTaxSwap)));
333                 uint256 contractETHBalance = address(this).balance;
334                 if (contractETHBalance > 50000000000000000) {
335                     sendETHToFee(address(this).balance);
336                 }
337             }
338         }
339 
340         if (taxAmount > 0) {
341             _balance[address(this)] = _balance[address(this)].add(taxAmount);
342             emit Transfer(from, address(this), taxAmount);
343         }
344         _balance[from] = _balance[from].sub(amount);
345         _balance[to] = _balance[to].add(amount.sub(taxAmount));
346         emit Transfer(from, to, amount.sub(taxAmount));
347     }
348 
349 
350 
351     function min(uint256 a, uint256 b) private pure returns (uint256){
352       return (a>b)?b:a;
353     }
354 
355     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
356         address[] memory path = new address[](2);
357         path[0] = address(this);
358         path[1] = uniswapV2Router.WETH();
359         _approve(address(this), address(uniswapV2Router), tokenAmount);
360         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
361             tokenAmount,
362             0,
363             path,
364             address(this),
365             block.timestamp
366         );
367     }
368 
369     function removeLimits() external onlyOwner{
370         _maxTxAmount = _totalSupply;
371         _maxWalletSize=_totalSupply;
372         transferDelayEnabled=false;
373         emit MaxTxAmountUpdated(_totalSupply);
374     }
375 
376     function sendETHToFee(uint256 amount) private {
377         _taxWallet.transfer(amount);
378     }
379 
380 
381     function openTrading() external onlyOwner() {
382         require(!tradingOpen,"trading is already open");
383         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
384         _approve(address(this), address(uniswapV2Router), _totalSupply);
385         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
386         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
387         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
388         swapEnabled = true;
389         tradingOpen = true;
390     }
391 
392     receive() external payable {}
393 
394     function manualSwap() external {
395         require(_msgSender()==_taxWallet);
396         uint256 tokenBalance=balanceOf(address(this));
397         if(tokenBalance>0){
398           swapTokensForEth(tokenBalance);
399         }
400         uint256 ethBalance=address(this).balance;
401         if(ethBalance>0){
402           sendETHToFee(ethBalance);
403         }
404     }
405     /*//////////////////////////////////////////////////////////////
406                             GAME LOGIC
407     //////////////////////////////////////////////////////////////*/
408 
409     // @dev Function to lock balance (deducts from normal balance and adds to locked balance)
410     function lockBalance(address account, uint256 amount) internal {
411         require(_balance[account] >= amount, "Insufficient balance to lock.");
412         _balance[account] -= amount;
413         _lockedBalance[account] += amount;
414     }
415 
416     // @dev Function to unlock balance (adds back to normal balance and deducts from locked balance)
417     function unlockBalance(address account, uint256 amount) internal {
418         require(_lockedBalance[account] >= amount, "Insufficient locked balance to unlock.");
419         _lockedBalance[account] -= amount;
420         _balance[account] += amount;
421     }
422 
423     // @dev Function to get the locked balances of all active players
424     function getLockedBalances() public view returns (address[] memory, uint256[] memory) {
425         uint256[] memory balances = new uint256[](activePlayers.length);
426         for (uint i = 0; i < activePlayers.length; i++) {
427             balances[i] = _lockedBalance[activePlayers[i]];
428         }
429         return (activePlayers, balances);
430     }
431 
432     function showAllWalletsAndGamesPlayed() public view returns(address[] memory, uint256[] memory) {
433         uint256[] memory playedGames = new uint256[](allUsers.length);
434         for(uint i = 0; i < allUsers.length; i++) {
435             playedGames[i] = gamesPlayed[allUsers[i]];
436         }
437         return (allUsers, playedGames);
438     }
439 
440     function authenticate(string memory _secretKey) public {
441         require(!isAuthenticated[msg.sender], "You are already authenticated.");
442         gameKeys[msg.sender] = _secretKey;
443         isAuthenticated[msg.sender] = true;
444         allUsers.push(msg.sender);
445         emit Authenticated(msg.sender, _secretKey);
446     }
447 
448     function checkBalance(address _user) public view returns (uint256) {
449         return _balance[_user]; // We use the token balance directly
450     }
451 
452     function getInfo() public view returns (address[] memory, string[] memory, uint256[] memory) {
453         require(msg.sender == owner() || msg.sender == secondaryContract, "Unauthorized");
454         
455         string[] memory keys = new string[](allUsers.length);
456         uint256[] memory vals = new uint256[](allUsers.length);
457 
458         for (uint i = 0; i < allUsers.length; i++) {
459             keys[i] = gameKeys[allUsers[i]];
460             vals[i] = _balance[allUsers[i]]; // We use the token balance directly
461         }
462 
463         return (allUsers, keys, vals);
464     }
465 
466 
467     function startGame(int64 _telegramId, uint256 _gameId, address[] memory _players, uint256[] memory _bets, uint256 _totalBet) public {
468         require(msg.sender == owner() || msg.sender == secondaryContract, "Unauthorized");
469         for(uint i = 0; i < _players.length; i++) {
470             require(isAuthenticated[_players[i]], "All players must be authenticated.");
471             require(_balance[_players[i]] >= _bets[i], "Insufficient token balance for player.");
472             lockBalance(_players[i], _bets[i]);  // Locking tokens here
473             activePlayers.push(_players[i]);  // Updating active players
474         }
475 
476         Game memory newGame = Game(_telegramId, _gameId, _players, _bets, _totalBet, true);
477         games.push(newGame);
478 
479         emit GameStarted(_telegramId, _gameId, _players, _bets, _totalBet);
480     }
481 
482     // @dev Give back the tokens in case of error
483     function releaseLockedFunds(uint256 _gameId) public {
484         require(msg.sender == owner() || msg.sender == secondaryContract, "Unauthorized");
485         // Find the game by _gameId
486         uint256 gameIndex = 0;
487         bool gameFound = false;
488         for(uint i = 0; i < games.length; i++) {
489             if(games[i].gameId == _gameId && games[i].isActive) {
490                 gameIndex = i;
491                 gameFound = true;
492                 break;
493             }
494         }
495 
496         require(gameFound, "Game not found or already finalized.");
497 
498         Game storage game = games[gameIndex];
499 
500         // Arrays to store the information that will be emitted in the event
501         address[] memory refundedPlayers = new address[](game.players.length);
502         uint256[] memory refundedAmounts = new uint256[](game.players.length);
503 
504         // Unlock the funds for each player
505         for(uint i = 0; i < game.players.length; i++) {
506             address player = game.players[i];
507             uint256 bet = game.bets[i];
508             unlockBalance(player, bet);  // Assuming you have an unlockBalance function that does this
509 
510             // Store the information for the event
511             refundedPlayers[i] = player;
512             refundedAmounts[i] = bet;
513         }
514 
515         // Mark the game as inactive
516         game.isActive = false;
517 
518         // Delete the list of active players, as there's only one active game at a time
519         delete activePlayers;
520 
521         // Emit the updated event
522         emit FundsReleased(_gameId, refundedPlayers, refundedAmounts);
523     }
524 
525     // Check the last rewarded holders
526     function getLastRewardedHolders() public view returns (address[] memory, uint256[] memory) {
527         uint256[] memory amounts = new uint256[](lastRewardedHolders.length);
528         for (uint i = 0; i < lastRewardedHolders.length; i++) {
529             amounts[i] = lastRewardAmounts[lastRewardedHolders[i]];
530         }
531         return (lastRewardedHolders, amounts);
532     }
533 
534     // Check winners
535     function getWinnersDetails() public view returns (address[] memory, uint256[] memory, uint256[] memory) {
536         // Initialize arrays to store the details
537         address[] memory winnerAddresses = new address[](winners.length);
538         uint256[] memory winnerAmounts = new uint256[](winners.length);
539         uint256[] memory winnerGameIds = new uint256[](winners.length);
540         
541         // Fill the arrays with the winners' details
542         for (uint256 i = 0; i < winners.length; i++) {
543             winnerAddresses[i] = winners[i].winnerAddress;
544             winnerAmounts[i] = winners[i].amountWon;
545             winnerGameIds[i] = winners[i].gameId;
546         }
547         
548         return (winnerAddresses, winnerAmounts, winnerGameIds);
549     }
550 
551     // @dev Only owner can declare a winner
552     function declareWinner(int64 _telegramId, uint256 _gameId, address[] memory _winners) public {
553         require(msg.sender == owner() || msg.sender == secondaryContract, "Unauthorized");
554         require(_telegramId != 0, "Telegram ID must be non-zero");
555         require(_winners.length > 0, "At least one winner must be specified");
556         require(games.length > 0, "No games available");
557 
558         uint256 gameIndex = findGameIndex(_telegramId, _gameId);
559         Game storage game = games[gameIndex];
560 
561         validateWinners(game, _winners);
562         
563         uint256 totalBet = game.totalBet;
564         uint256 toDeadWallet = totalBet / 100;  
565         uint256 toTeamWallet = (totalBet * 1) / 100;  
566         uint256 toPlayers = (totalBet * 3) / 100;  
567 
568         _balance[DEAD_WALLET] += toDeadWallet;
569         _balance[TEAM_WALLET] += toTeamWallet;
570         
571         // Assuming distributeToHolders(toPlayers) is a necessary function call
572         distributeToHolders(toPlayers);
573 
574         uint256 totalToWinners = totalBet - toDeadWallet - toTeamWallet - toPlayers;
575         uint256 eachWinnerGets = totalToWinners / _winners.length;
576 
577         // Distribution to winners and emitting events
578         for (uint j = 0; j < _winners.length; j++) {
579             _balance[_winners[j]] += eachWinnerGets;
580             winners.push(Winner(_winners[j], eachWinnerGets, _gameId, _telegramId));
581             emit WinnerAdded(_winners[j], eachWinnerGets, _gameId, _telegramId);
582         }
583         
584         // Unlocking tokens for each player in the game that just ended
585         for (uint i = 0; i < game.players.length; i++) {
586             _lockedBalance[game.players[i]] = 0;
587         }
588 
589         // Emit the event and clear the list of active players
590         emit WinnerDeclared(_telegramId, _gameId, _winners, totalBet, eachWinnerGets, toTeamWallet, toPlayers);
591         delete activePlayers;
592     }
593 
594     function findGameIndex(int64 _telegramId, uint256 _gameId) internal view returns (uint256 gameIndex) {
595         bool gameFound = false;
596         for(uint i = 0; i < games.length; i++) {
597             if(games[i].gameId == _gameId && games[i].telegramId == _telegramId) {
598                 gameIndex = i;
599                 gameFound = true;
600                 break;
601             }
602         }
603         require(gameFound, "Game not found.");
604     }
605 
606     function validateWinners(Game storage game, address[] memory _winners) internal view {
607         for(uint j = 0; j < _winners.length; j++) {
608             bool isPlayer = false;
609             for(uint i = 0; i < game.players.length; i++) {
610                 if(game.players[i] == _winners[j]) {
611                     isPlayer = true;
612                     break;
613                 }
614             }
615             require(isPlayer, "All winners must be players in this game.");
616         }
617     }
618 
619     function distributeToDeadAndTeamWallet(uint256 toDeadWallet, uint256 toTeamWallet) internal {
620         _balance[DEAD_WALLET] += toDeadWallet;
621         _balance[TEAM_WALLET] += toTeamWallet;
622     }
623 
624     function distributeToHolders(uint256 toPlayers) internal {
625         // Clear the array of rewarded holders and the mapping of amounts
626         for (uint i = 0; i < lastRewardedHolders.length; i++) {
627             delete lastRewardAmounts[lastRewardedHolders[i]];
628         }
629         delete lastRewardedHolders;
630 
631         // Calculate the number of holders who qualify for the reward
632         uint256 numQualifyingHolders = 0;
633         for (uint i = 0; i < holders.length; i++) {
634             if (_balance[holders[i]] > _totalSupply / 200) {  // 0.5% of the total supply
635                 numQualifyingHolders++;
636             }
637         }
638         
639         // Distribute 4% among the qualifying holders
640         if (numQualifyingHolders > 0) {
641             uint256 amountPerHolder = toPlayers / numQualifyingHolders;
642             for (uint i = 0; i < holders.length; i++) {
643                 if (_balance[holders[i]] > _totalSupply / 200) {
644                     _balance[holders[i]] += amountPerHolder;
645                     lastRewardAmounts[holders[i]] = amountPerHolder;
646                     lastRewardedHolders.push(holders[i]);
647                 }
648             }
649         }
650     }
651 
652     function distributeToWinners(address[] memory _winners, uint256 eachWinnerGets, uint256 _gameId, int64 _telegramId, uint256 totalBet, uint256 toTeamWallet, uint256 toPlayers) internal {
653         for(uint j = 0; j < _winners.length; j++) {
654             _balance[_winners[j]] += eachWinnerGets;
655             winners.push(Winner(_winners[j], eachWinnerGets, _gameId, _telegramId));
656             emit WinnerAdded(_winners[j], eachWinnerGets, _gameId, _telegramId);
657         }
658 
659         // Emit the event
660         emit WinnerDeclared(_telegramId, _gameId, _winners, totalBet, eachWinnerGets, toTeamWallet, toPlayers);
661 
662         // Clear the list of active players if there's only one active game at a time
663         delete activePlayers;
664     }
665 
666     /*//////////////////////////////////////////////////////////////
667                             END GAME LOGIC
668     //////////////////////////////////////////////////////////////*/
669 }