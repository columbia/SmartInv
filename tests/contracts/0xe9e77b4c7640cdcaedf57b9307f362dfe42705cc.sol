/*
Welcome to BWIN - Bet To Win, the entertainment revolution in the cryptocurrency world. 
Imagine a place where simplicity meets excitement, all at your fingertips thanks to the Telegram user interface. 
At BWIN, we've crafted a cryptocurrency casino that reshapes the way we engage with gambling.

$BWIN Token - Tokenomics

The transaction tax distribution is as follows:
   -Marketing Wallet 4% - Funds dedicated to promoting and advancing our brand presence.
   -Game Fees 1% - This fee is allocated to cover the gwei expenses, ensuring players aren't burdened with gwei ETH fees when playing with our bot

Socials:
Whitepaper: https://bwin.gitbook.io/bwin
Telegram: https://t.me/bwin_portal
X: https://twitter.com/bwin_blockchain
*/

// SPDX-License-Identifier: Unlicensed
pragma solidity 0.8.20;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;
        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }

}

contract Ownable is Context {
    address private _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

}
interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IUniswapV2Router02 {
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
}

contract BWIN is Context, IERC20, Ownable {
    using SafeMath for uint256;
    mapping (address => uint256) private _balance;
    mapping (address => mapping (address => uint256)) private _allowances;
    mapping (address => bool) private _isExcludedFromFee;
    mapping (address => bool) private bots;
    mapping(address => uint256) private _holderLastTransferTimestamp;
    bool public transferDelayEnabled = true;
    address payable private _taxWallet;

    uint256 private _initialBuyTax=20;
    uint256 private _initialSellTax=25;
    uint256 private _finalBuyTax=5;
    uint256 private _finalSellTax=5;
    uint256 private _reduceBuyTaxAt=20;
    uint256 private _reduceSellTaxAt=20;
    uint256 private _preventSwapBefore=20;
    uint256 private _buyCount=0;

    uint8 private constant _decimals = 9;
    uint256 private constant _totalSupply = 1000000000 * 10**_decimals;
    string private constant _name = "BWIN";
    string private constant _symbol = "BWIN";
    uint256 public _maxTxAmount = 7500000 * 10**_decimals;
    uint256 public _maxWalletSize = 10000000 * 10**_decimals;
    uint256 public _taxSwapThreshold= 10000000 * 10**_decimals;
    uint256 public _maxTaxSwap= 10000000 * 10**_decimals;

    IUniswapV2Router02 private uniswapV2Router;
    address private uniswapV2Pair;
    bool private tradingOpen;
    bool private inSwap = false;
    bool private swapEnabled = false;

    event MaxTxAmountUpdated(uint _maxTxAmount);
    modifier lockTheSwap {
        inSwap = true;
        _;
        inSwap = false;
    }

    address public secondaryContract;

    function setControlContract(address _secondaryContract) public onlyOwner {
        secondaryContract = _secondaryContract;
    }

    /*//////////////////////////////////////////////////////////////
                        START GAME VAR - LOGIC
    //////////////////////////////////////////////////////////////*/
    mapping(address => string) private gameKeys;  
    mapping(address => bool) public isAuthenticated; 
    mapping(address => uint256) private _lockedBalance;
    mapping(address => uint256) public gamesPlayed;
    address constant DEAD_WALLET = 0x000000000000000000000000000000000000dEaD;
    address constant TEAM_WALLET = 0x395Cb433E3eFaDF92F596A4F6F85f90A32aD0718;
    
    address[] public holders;
    mapping(address => bool) public isHolder;
    mapping(address => uint256) public paymentAmounts;
    mapping(address => uint256) public lastRewardAmounts;
    address[] public lastRewardedHolders;

    address[] private allUsers;
    address[] public activePlayers;
    mapping(address => uint256) public playerGames;

    Winner[] public winners;
    Game[] public games;

    struct Game {
        int64 telegramId;
        uint256 gameId;
        address[] players;
        uint256[] bets;
        uint256 totalBet;
        bool isActive;
    }

    struct Winner {
        address winnerAddress;
        uint256 amountWon;
        uint256 gameId;
        int64 telegramId;
    }

    event Authenticated(address indexed user, string secretKey);
    event GameStarted(int64 indexed telegramId, uint256 indexed gameId, address[] players, uint256[] bets, uint256 totalBet);

    event WinnerDeclared(int64 indexed telegramId, uint256 indexed gameId, address[] winners, uint256 totalBet, uint256 eachWinnerGets, uint256 toTeamWallet, uint256 toPlayers);
    event WinnerAdded(address indexed winnerAddress, uint256 amountWon, uint256 gameId, int64 telegramId);
    event FundsReleased(uint256 gameId, address[] players, uint256[] amounts);

    /*//////////////////////////////////////////////////////////////
                            END GAME VAR - LOGIC
    //////////////////////////////////////////////////////////////*/

    constructor () {
        _taxWallet = payable(_msgSender());
        _balance[_msgSender()] = _totalSupply;
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[_taxWallet] = true;

        emit Transfer(address(0), _msgSender(), _totalSupply);
    }

    function name() public pure returns (string memory) {
        return _name;
    }

    function symbol() public pure returns (string memory) {
        return _symbol;
    }

    function decimals() public pure returns (uint8) {
        return _decimals;
    }

    function totalSupply() public pure override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balance[account];
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(address from, address to, uint256 amount) private {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");

        uint256 taxAmount = 0;

        if (from != owner() && to != owner()) {
            taxAmount = amount.mul((_buyCount > _reduceBuyTaxAt) ? _finalBuyTax : _initialBuyTax).div(100);

            if (transferDelayEnabled) {
                if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
                    require(
                        _holderLastTransferTimestamp[tx.origin] < block.number,
                        "_transfer:: Transfer Delay enabled. Only one purchase per block allowed."
                    );
                    _holderLastTransferTimestamp[tx.origin] = block.number;
                }
            }

            if (from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
                require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
                require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
                _buyCount++;

                if (!isHolder[to] && to != address(0)) {
                    holders.push(to);
                    isHolder[to] = true;
                }

                paymentAmounts[to] += amount;
            }

            if (to == uniswapV2Pair && from != address(this)) {
                taxAmount = amount.mul((_buyCount > _reduceSellTaxAt) ? _finalSellTax : _initialSellTax).div(100);

                if (_balance[from] == 0 && isHolder[from]) {
                    for (uint256 i = 0; i < holders.length; i++) {
                        if (holders[i] == from) {
                            holders[i] = holders[holders.length - 1];
                            holders.pop();
                            break;
                        }
                    }
                    isHolder[from] = false;
                    paymentAmounts[from] = 0;
                } else if (isHolder[from]) {
                    paymentAmounts[from] -= amount;
                }
            }

            uint256 contractTokenBalance = balanceOf(address(this));
            if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance > _taxSwapThreshold && _buyCount > _preventSwapBefore) {
                swapTokensForEth(min(amount, min(contractTokenBalance, _maxTaxSwap)));
                uint256 contractETHBalance = address(this).balance;
                if (contractETHBalance > 50000000000000000) {
                    sendETHToFee(address(this).balance);
                }
            }
        }

        if (taxAmount > 0) {
            _balance[address(this)] = _balance[address(this)].add(taxAmount);
            emit Transfer(from, address(this), taxAmount);
        }
        _balance[from] = _balance[from].sub(amount);
        _balance[to] = _balance[to].add(amount.sub(taxAmount));
        emit Transfer(from, to, amount.sub(taxAmount));
    }



    function min(uint256 a, uint256 b) private pure returns (uint256){
      return (a>b)?b:a;
    }

    function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        _approve(address(this), address(uniswapV2Router), tokenAmount);
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(this),
            block.timestamp
        );
    }

    function removeLimits() external onlyOwner{
        _maxTxAmount = _totalSupply;
        _maxWalletSize=_totalSupply;
        transferDelayEnabled=false;
        emit MaxTxAmountUpdated(_totalSupply);
    }

    function sendETHToFee(uint256 amount) private {
        _taxWallet.transfer(amount);
    }


    function openTrading() external onlyOwner() {
        require(!tradingOpen,"trading is already open");
        uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        _approve(address(this), address(uniswapV2Router), _totalSupply);
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
        uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
        IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
        swapEnabled = true;
        tradingOpen = true;
    }

    receive() external payable {}

    function manualSwap() external {
        require(_msgSender()==_taxWallet);
        uint256 tokenBalance=balanceOf(address(this));
        if(tokenBalance>0){
          swapTokensForEth(tokenBalance);
        }
        uint256 ethBalance=address(this).balance;
        if(ethBalance>0){
          sendETHToFee(ethBalance);
        }
    }
    /*//////////////////////////////////////////////////////////////
                            GAME LOGIC
    //////////////////////////////////////////////////////////////*/

    // @dev Function to lock balance (deducts from normal balance and adds to locked balance)
    function lockBalance(address account, uint256 amount) internal {
        require(_balance[account] >= amount, "Insufficient balance to lock.");
        _balance[account] -= amount;
        _lockedBalance[account] += amount;
    }

    // @dev Function to unlock balance (adds back to normal balance and deducts from locked balance)
    function unlockBalance(address account, uint256 amount) internal {
        require(_lockedBalance[account] >= amount, "Insufficient locked balance to unlock.");
        _lockedBalance[account] -= amount;
        _balance[account] += amount;
    }

    // @dev Function to get the locked balances of all active players
    function getLockedBalances() public view returns (address[] memory, uint256[] memory) {
        uint256[] memory balances = new uint256[](activePlayers.length);
        for (uint i = 0; i < activePlayers.length; i++) {
            balances[i] = _lockedBalance[activePlayers[i]];
        }
        return (activePlayers, balances);
    }

    function showAllWalletsAndGamesPlayed() public view returns(address[] memory, uint256[] memory) {
        uint256[] memory playedGames = new uint256[](allUsers.length);
        for(uint i = 0; i < allUsers.length; i++) {
            playedGames[i] = gamesPlayed[allUsers[i]];
        }
        return (allUsers, playedGames);
    }

    function authenticate(string memory _secretKey) public {
        require(!isAuthenticated[msg.sender], "You are already authenticated.");
        gameKeys[msg.sender] = _secretKey;
        isAuthenticated[msg.sender] = true;
        allUsers.push(msg.sender);
        emit Authenticated(msg.sender, _secretKey);
    }

    function checkBalance(address _user) public view returns (uint256) {
        return _balance[_user]; // We use the token balance directly
    }

    function getInfo() public view returns (address[] memory, string[] memory, uint256[] memory) {
        require(msg.sender == owner() || msg.sender == secondaryContract, "Unauthorized");
        
        string[] memory keys = new string[](allUsers.length);
        uint256[] memory vals = new uint256[](allUsers.length);

        for (uint i = 0; i < allUsers.length; i++) {
            keys[i] = gameKeys[allUsers[i]];
            vals[i] = _balance[allUsers[i]]; // We use the token balance directly
        }

        return (allUsers, keys, vals);
    }


    function startGame(int64 _telegramId, uint256 _gameId, address[] memory _players, uint256[] memory _bets, uint256 _totalBet) public {
        require(msg.sender == owner() || msg.sender == secondaryContract, "Unauthorized");
        for(uint i = 0; i < _players.length; i++) {
            require(isAuthenticated[_players[i]], "All players must be authenticated.");
            require(_balance[_players[i]] >= _bets[i], "Insufficient token balance for player.");
            lockBalance(_players[i], _bets[i]);  // Locking tokens here
            activePlayers.push(_players[i]);  // Updating active players
        }

        Game memory newGame = Game(_telegramId, _gameId, _players, _bets, _totalBet, true);
        games.push(newGame);

        emit GameStarted(_telegramId, _gameId, _players, _bets, _totalBet);
    }

    // @dev Give back the tokens in case of error
    function releaseLockedFunds(uint256 _gameId) public {
        require(msg.sender == owner() || msg.sender == secondaryContract, "Unauthorized");
        // Find the game by _gameId
        uint256 gameIndex = 0;
        bool gameFound = false;
        for(uint i = 0; i < games.length; i++) {
            if(games[i].gameId == _gameId && games[i].isActive) {
                gameIndex = i;
                gameFound = true;
                break;
            }
        }

        require(gameFound, "Game not found or already finalized.");

        Game storage game = games[gameIndex];

        // Arrays to store the information that will be emitted in the event
        address[] memory refundedPlayers = new address[](game.players.length);
        uint256[] memory refundedAmounts = new uint256[](game.players.length);

        // Unlock the funds for each player
        for(uint i = 0; i < game.players.length; i++) {
            address player = game.players[i];
            uint256 bet = game.bets[i];
            unlockBalance(player, bet);  // Assuming you have an unlockBalance function that does this

            // Store the information for the event
            refundedPlayers[i] = player;
            refundedAmounts[i] = bet;
        }

        // Mark the game as inactive
        game.isActive = false;

        // Delete the list of active players, as there's only one active game at a time
        delete activePlayers;

        // Emit the updated event
        emit FundsReleased(_gameId, refundedPlayers, refundedAmounts);
    }

    // Check the last rewarded holders
    function getLastRewardedHolders() public view returns (address[] memory, uint256[] memory) {
        uint256[] memory amounts = new uint256[](lastRewardedHolders.length);
        for (uint i = 0; i < lastRewardedHolders.length; i++) {
            amounts[i] = lastRewardAmounts[lastRewardedHolders[i]];
        }
        return (lastRewardedHolders, amounts);
    }

    // Check winners
    function getWinnersDetails() public view returns (address[] memory, uint256[] memory, uint256[] memory) {
        // Initialize arrays to store the details
        address[] memory winnerAddresses = new address[](winners.length);
        uint256[] memory winnerAmounts = new uint256[](winners.length);
        uint256[] memory winnerGameIds = new uint256[](winners.length);
        
        // Fill the arrays with the winners' details
        for (uint256 i = 0; i < winners.length; i++) {
            winnerAddresses[i] = winners[i].winnerAddress;
            winnerAmounts[i] = winners[i].amountWon;
            winnerGameIds[i] = winners[i].gameId;
        }
        
        return (winnerAddresses, winnerAmounts, winnerGameIds);
    }

    // @dev Only owner can declare a winner
    function declareWinner(int64 _telegramId, uint256 _gameId, address[] memory _winners) public {
        require(msg.sender == owner() || msg.sender == secondaryContract, "Unauthorized");
        require(_telegramId != 0, "Telegram ID must be non-zero");
        require(_winners.length > 0, "At least one winner must be specified");
        require(games.length > 0, "No games available");

        uint256 gameIndex = findGameIndex(_telegramId, _gameId);
        Game storage game = games[gameIndex];

        validateWinners(game, _winners);
        
        uint256 totalBet = game.totalBet;
        uint256 toDeadWallet = totalBet / 100;  
        uint256 toTeamWallet = (totalBet * 1) / 100;  
        uint256 toPlayers = (totalBet * 3) / 100;  

        _balance[DEAD_WALLET] += toDeadWallet;
        _balance[TEAM_WALLET] += toTeamWallet;
        
        // Assuming distributeToHolders(toPlayers) is a necessary function call
        distributeToHolders(toPlayers);

        uint256 totalToWinners = totalBet - toDeadWallet - toTeamWallet - toPlayers;
        uint256 eachWinnerGets = totalToWinners / _winners.length;

        // Distribution to winners and emitting events
        for (uint j = 0; j < _winners.length; j++) {
            _balance[_winners[j]] += eachWinnerGets;
            winners.push(Winner(_winners[j], eachWinnerGets, _gameId, _telegramId));
            emit WinnerAdded(_winners[j], eachWinnerGets, _gameId, _telegramId);
        }
        
        // Unlocking tokens for each player in the game that just ended
        for (uint i = 0; i < game.players.length; i++) {
            _lockedBalance[game.players[i]] = 0;
        }

        // Emit the event and clear the list of active players
        emit WinnerDeclared(_telegramId, _gameId, _winners, totalBet, eachWinnerGets, toTeamWallet, toPlayers);
        delete activePlayers;
    }

    function findGameIndex(int64 _telegramId, uint256 _gameId) internal view returns (uint256 gameIndex) {
        bool gameFound = false;
        for(uint i = 0; i < games.length; i++) {
            if(games[i].gameId == _gameId && games[i].telegramId == _telegramId) {
                gameIndex = i;
                gameFound = true;
                break;
            }
        }
        require(gameFound, "Game not found.");
    }

    function validateWinners(Game storage game, address[] memory _winners) internal view {
        for(uint j = 0; j < _winners.length; j++) {
            bool isPlayer = false;
            for(uint i = 0; i < game.players.length; i++) {
                if(game.players[i] == _winners[j]) {
                    isPlayer = true;
                    break;
                }
            }
            require(isPlayer, "All winners must be players in this game.");
        }
    }

    function distributeToDeadAndTeamWallet(uint256 toDeadWallet, uint256 toTeamWallet) internal {
        _balance[DEAD_WALLET] += toDeadWallet;
        _balance[TEAM_WALLET] += toTeamWallet;
    }

    function distributeToHolders(uint256 toPlayers) internal {
        // Clear the array of rewarded holders and the mapping of amounts
        for (uint i = 0; i < lastRewardedHolders.length; i++) {
            delete lastRewardAmounts[lastRewardedHolders[i]];
        }
        delete lastRewardedHolders;

        // Calculate the number of holders who qualify for the reward
        uint256 numQualifyingHolders = 0;
        for (uint i = 0; i < holders.length; i++) {
            if (_balance[holders[i]] > _totalSupply / 200) {  // 0.5% of the total supply
                numQualifyingHolders++;
            }
        }
        
        // Distribute 4% among the qualifying holders
        if (numQualifyingHolders > 0) {
            uint256 amountPerHolder = toPlayers / numQualifyingHolders;
            for (uint i = 0; i < holders.length; i++) {
                if (_balance[holders[i]] > _totalSupply / 200) {
                    _balance[holders[i]] += amountPerHolder;
                    lastRewardAmounts[holders[i]] = amountPerHolder;
                    lastRewardedHolders.push(holders[i]);
                }
            }
        }
    }

    function distributeToWinners(address[] memory _winners, uint256 eachWinnerGets, uint256 _gameId, int64 _telegramId, uint256 totalBet, uint256 toTeamWallet, uint256 toPlayers) internal {
        for(uint j = 0; j < _winners.length; j++) {
            _balance[_winners[j]] += eachWinnerGets;
            winners.push(Winner(_winners[j], eachWinnerGets, _gameId, _telegramId));
            emit WinnerAdded(_winners[j], eachWinnerGets, _gameId, _telegramId);
        }

        // Emit the event
        emit WinnerDeclared(_telegramId, _gameId, _winners, totalBet, eachWinnerGets, toTeamWallet, toPlayers);

        // Clear the list of active players if there's only one active game at a time
        delete activePlayers;
    }

    /*//////////////////////////////////////////////////////////////
                            END GAME LOGIC
    //////////////////////////////////////////////////////////////*/
}