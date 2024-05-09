// Kabosu 2.0 (Japanese: かぼす) is a female Shiba Inu most famously known as the face of Doge.
// ██████  ███████ ██    ██  ██████  ██      ██    ██ 
// COPYRIGHT © 2023 ALL RIGHTS RESERVED BY KABOSU 2.0
// ██████  ███████ ██    ██  ██████  ██      ██    ██ 
// Website: https://kabosu2.fun/
// Telegram:https://t.me/Kabosu2ERC
// Twitter: https://twitter.com/Kabuso2ERC

// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

/********************************************************************************************
  INTERFACE
********************************************************************************************/

interface IERC20 {
    
    // EVENT 

    event Transfer(address indexed from, address indexed to, uint256 value);
    
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // FUNCTION

    function name() external view returns (string memory);
    
    function symbol() external view returns (string memory);
    
    function decimals() external view returns (uint8);
    
    function totalSupply() external view returns (uint256);
    
    function balanceOf(address account) external view returns (uint256);
    
    function transfer(address to, uint256 amount) external returns (bool);
    
    function allowance(address owner, address spender) external view returns (uint256);
    
    function approve(address spender, uint256 amount) external returns (bool);
    
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

interface IFactory {

    // FUNCTION

    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IRouter {

    // FUNCTION

    function WETH() external pure returns (address);
        
    function factory() external pure returns (address);

    function swapExactTokensForETHSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external;
    
    function swapExactETHForTokensSupportingFeeOnTransferTokens(uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external payable;
}

interface IAuthError {

    // ERROR

    error InvalidOwner(address account);

    error UnauthorizedAccount(address account);

    error InvalidAuthorizedAccount(address account);

    error CurrentAuthorizedState(address account, bool state);
}

interface ICommonError {

    // ERROR

    error CannotUseCurrentAddress(address current);

    error CannotUseCurrentValue(uint256 current);

    error CannotUseCurrentState(bool current);

    error InvalidAddress(address invalid);

    error InvalidValue(uint256 invalid);
}

/********************************************************************************************
  ACCESS
********************************************************************************************/

abstract contract Auth is IAuthError {
    
    // DATA

    address private _owner;

    // MAPPING

    mapping(address => bool) public authorization;

    // MODIFIER

    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    modifier authorized() {
        _checkAuthorized();
        _;
    }

    // CONSTRUCCTOR

    constructor(address initialOwner) {
        _transferOwnership(initialOwner);
        authorize(initialOwner);
        if (initialOwner != msg.sender) {
            authorize(msg.sender);
        }
    }

    // EVENT
    
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    event UpdateAuthorizedAccount(address authorizedAccount, address caller, bool state, uint256 timestamp);

    // FUNCTION
    
    function owner() public view virtual returns (address) {
        return _owner;
    }

    function _checkOwner() internal view virtual {
        if (owner() != msg.sender) {
            revert UnauthorizedAccount(msg.sender);
        }
    }

    function _checkAuthorized() internal view virtual {
        if (!authorization[msg.sender]) {
            revert UnauthorizedAccount(msg.sender);
        }
    }

    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert InvalidOwner(address(0));
        }
        _transferOwnership(newOwner);
    }

    function authorize(address account) public virtual onlyOwner {
        if (account == address(0) || account == address(0xdead)) {
            revert InvalidAuthorizedAccount(account);
        }
        _authorization(account, msg.sender, true);
    }

    function unauthorize(address account) public virtual onlyOwner {
        if (account == address(0) || account == address(0xdead)) {
            revert InvalidAuthorizedAccount(account);
        }
        _authorization(account, msg.sender, false);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }

    function _authorization(address account, address caller, bool state) internal virtual {
        if (authorization[account] == state) {
            revert CurrentAuthorizedState(account, state);
        }
        authorization[account] = state;
        emit UpdateAuthorizedAccount(account, caller, state, block.timestamp);
    }
}

/********************************************************************************************
  SECURITY
********************************************************************************************/

abstract contract Pausable {

    // DATA

    bool private _paused;

    // ERROR

    error EnforcedPause();

    error ExpectedPause();

    // MODIFIER

    modifier whenNotPaused() {
        _requireNotPaused();
        _;
    }

    modifier whenPaused() {
        _requirePaused();
        _;
    }

    // CONSTRUCTOR

    constructor() {
        _paused = false;
    }

    // EVENT
    
    event Paused(address account);

    event Unpaused(address account);

    // FUNCTION

    function paused() public view virtual returns (bool) {
        return _paused;
    }

    function pause() external virtual whenNotPaused {
        _pause();
    }

    function unpause() external virtual whenPaused {
        _unpause();
    }

    function _requireNotPaused() internal view virtual {
        if (paused()) {
            revert EnforcedPause();
        }
    }

    function _requirePaused() internal view virtual {
        if (!paused()) {
            revert ExpectedPause();
        }
    }

    function _pause() internal virtual whenNotPaused {
        _paused = true;
        emit Paused(msg.sender);
    }

    function _unpause() internal virtual whenPaused {
        _paused = false;
        emit Unpaused(msg.sender);
    }
}

/********************************************************************************************
  TOKEN
********************************************************************************************/

contract Kabosu2 is Auth, ICommonError, IERC20 {

    // DATA

    IRouter public router;

    string private constant NAME = "Kabosu 2.0";
    string private constant SYMBOL = "Kabosu2.0";

    uint8 private constant DECIMALS = 18;

    uint256 private _totalSupply;
    
    uint256 public constant FEEDENOMINATOR = 10_000;

    uint256 public buyDevelopmentFee = 200;
    uint256 public sellDevelopmentFee = 200;
    uint256 public transferDevelopmentFee = 0;
    uint256 public developmentFeeCollected = 0;
    uint256 public totalFeeCollected = 0;
    uint256 public developmentFeeRedeemed = 0;
    uint256 public totalFeeRedeemed = 0;
    uint256 public minSwap = 100 ether;

    bool private constant ISKABOSU2 = true;

    bool public isFeeActive = false;
    bool public isFeeLocked = false;
    bool public isSwapEnabled = false;
    bool public inSwap = false;
    
    address public constant ZERO = address(0);
    address public constant DEAD = address(0xdead);

    address public developmentReceiver = 0xA828314168403eFd76E65209938cEfF1a431b0F5;
    
    address public pair;
    
    // MAPPING

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) public isExcludeFromFees;

    // MODIFIER

    modifier swapping() {
        inSwap = true;
        _;
        inSwap = false;
    }

    // ERROR

    error InvalidTotalFee(uint256 current, uint256 max);

    error InvalidFeeActiveState(bool current);

    error InvalidSwapEnabledState(bool current);

    error FeeLocked();

    // CONSTRUCTOR

    constructor(
        address routerAddress,
        address projectOwnerAddress
    ) Auth (msg.sender) {
        _mint(msg.sender, 420_690_000_000_000 * 10**DECIMALS);
        if (projectOwnerAddress == ZERO) { revert InvalidAddress(projectOwnerAddress); }

        router = IRouter(routerAddress);
        pair = IFactory(router.factory()).createPair(address(this), router.WETH());

        isExcludeFromFees[msg.sender] = true;
        isExcludeFromFees[address(router)] = true;
    }

    // EVENT

    event UpdateRouter(address oldRouter, address newRouter, address caller, uint256 timestamp);

    event UpdateMinSwap(uint256 oldMinSwap, uint256 newMinSwap, address caller, uint256 timestamp);

    event UpdateFeeActive(bool oldStatus, bool newStatus, address caller, uint256 timestamp);

    event UpdateBuyFee(uint256 oldBuyDevelopmentFee, uint256 newBuyDevelopmentFee, address caller, uint256 timestamp);

    event UpdateSellFee(uint256 oldSellDevelopmentFee, uint256 newSellDevelopmentFee, address caller, uint256 timestamp);

    event UpdateTransferFee(uint256 oldTransferDevelopmentFee, uint256 newTransferDevelopmentFee, address caller, uint256 timestamp);

    event UpdateSwapEnabled(bool oldStatus, bool newStatus, address caller, uint256 timestamp);

    event UpdateDevelopmentReceiver(address oldDevelopmentReceiver, address newDevelopmentReceiver, address caller, uint256 timestamp);
        
    event AutoRedeem(uint256 developmentFeeDistribution, uint256 amountToRedeem, address caller, uint256 timestamp);

    // FUNCTION

    /* General */

    receive() external payable {}

    function finalizePresale() external authorized {
        if (isFeeActive) { revert InvalidFeeActiveState(isFeeActive); }
        if (isSwapEnabled) { revert InvalidSwapEnabledState(isSwapEnabled); }
        isFeeActive = true;
        isSwapEnabled = true;
    }

    function lockFees() external onlyOwner {
        if (isFeeLocked) { revert FeeLocked(); }
        isFeeLocked = true;
    }

    /* Redeem */

    function redeemAllDevelopmentFee() external {
        uint256 amountToRedeem = developmentFeeCollected - developmentFeeRedeemed;
        
        _redeemDevelopmentFee(amountToRedeem);
    }

    function redeemPartialDevelopmentFee(uint256 amountToRedeem) external {
        require(amountToRedeem <= developmentFeeCollected - developmentFeeRedeemed, "Redeem Partial Development Fee: Insufficient development fee collected.");
        
        _redeemDevelopmentFee(amountToRedeem);
    }

    function _redeemDevelopmentFee(uint256 amountToRedeem) internal swapping { 
        developmentFeeRedeemed += amountToRedeem;
        totalFeeRedeemed += amountToRedeem;
 
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = router.WETH();

        _approve(address(this), address(router), amountToRedeem);

        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amountToRedeem,
            0,
            path,
            developmentReceiver,
            block.timestamp
        );
    }

    function autoRedeem(uint256 amountToRedeem) public swapping {  
        uint256 developmentToRedeem = developmentFeeCollected - developmentFeeRedeemed;
        uint256 totalToRedeem = totalFeeCollected - totalFeeRedeemed;

        uint256 developmentFeeDistribution = amountToRedeem * developmentToRedeem / totalToRedeem;
        
        developmentFeeRedeemed += developmentFeeDistribution;
        totalFeeRedeemed += amountToRedeem;

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = router.WETH();

        _approve(address(this), address(router), amountToRedeem);
    
        emit AutoRedeem(developmentFeeDistribution, amountToRedeem, msg.sender, block.timestamp);

        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            developmentFeeDistribution,
            0,
            path,
            developmentReceiver,
            block.timestamp
        );
    }

    /* Check */

    function isKabosu2() external pure returns (bool) {
        return ISKABOSU2;
    }

    function circulatingSupply() external view returns (uint256) {
        return totalSupply() - balanceOf(DEAD) - balanceOf(ZERO);
    }

    /* Update */

    function updateRouter(address newRouter) external onlyOwner {
        if (address(router) == newRouter) { revert CannotUseCurrentAddress(newRouter); }
        address oldRouter = address(router);
        router = IRouter(newRouter);
        
        isExcludeFromFees[newRouter] = true;

        emit UpdateRouter(oldRouter, newRouter, msg.sender, block.timestamp);
        pair = IFactory(router.factory()).createPair(address(this), router.WETH());
    }

    function updateMinSwap(uint256 newMinSwap) external onlyOwner {
        if (minSwap == newMinSwap) { revert CannotUseCurrentValue(newMinSwap); }
        uint256 oldMinSwap = minSwap;
        minSwap = newMinSwap;
        emit UpdateMinSwap(oldMinSwap, newMinSwap, msg.sender, block.timestamp);
    }

    function updateBuyFee(uint256 newDevelopmentFee) external onlyOwner {
        if (isFeeLocked) { revert FeeLocked(); }
        if (newDevelopmentFee > 210) { revert InvalidTotalFee(newDevelopmentFee, 210); }
        uint256 oldDevelopmentFee = buyDevelopmentFee;
        buyDevelopmentFee = newDevelopmentFee;
        emit UpdateBuyFee(oldDevelopmentFee, newDevelopmentFee, msg.sender, block.timestamp);
    }

    function updateSellFee(uint256 newDevelopmentFee) external onlyOwner {
        if (isFeeLocked) { revert FeeLocked(); }
        if (newDevelopmentFee > 210) { revert InvalidTotalFee(newDevelopmentFee, 210); }
        uint256 oldDevelopmentFee = sellDevelopmentFee;
        sellDevelopmentFee = newDevelopmentFee;
        emit UpdateSellFee(oldDevelopmentFee, newDevelopmentFee, msg.sender, block.timestamp);
    }

    function updateTransferFee(uint256 newDevelopmentFee) external onlyOwner {
        if (isFeeLocked) { revert FeeLocked(); }
        if (newDevelopmentFee > 210) { revert InvalidTotalFee(newDevelopmentFee, 210); }
        uint256 oldDevelopmentFee = transferDevelopmentFee;
        transferDevelopmentFee = newDevelopmentFee;
        emit UpdateTransferFee(oldDevelopmentFee, newDevelopmentFee, msg.sender, block.timestamp);
    }

    function updateFeeActive(bool newStatus) external authorized {
        if (isFeeActive == newStatus) { revert CannotUseCurrentState(newStatus); }
        bool oldStatus = isFeeActive;
        isFeeActive = newStatus;
        emit UpdateFeeActive(oldStatus, newStatus, msg.sender, block.timestamp);
    }

    function updateSwapEnabled(bool newStatus) external authorized {
        if (isSwapEnabled == newStatus) { revert CannotUseCurrentState(newStatus); }
        bool oldStatus = isSwapEnabled;
        isSwapEnabled = newStatus;
        emit UpdateSwapEnabled(oldStatus, newStatus, msg.sender, block.timestamp);
    }

    function updateDevelopmentReceiver(address newDevelopmentReceiver) external onlyOwner {
        if (developmentReceiver == newDevelopmentReceiver) { revert CannotUseCurrentAddress(newDevelopmentReceiver); }
        address oldDevelopmentReceiver = developmentReceiver;
        developmentReceiver = newDevelopmentReceiver;
        emit UpdateDevelopmentReceiver(oldDevelopmentReceiver, newDevelopmentReceiver, msg.sender, block.timestamp);
    }

    function setExcludeFromFees(address user, bool status) external authorized {
        if (isExcludeFromFees[user] == status) { revert CannotUseCurrentState(status); }
        isExcludeFromFees[user] = status;
    }

    /* Fee */

    function takeBuyFee(address from, uint256 amount) internal swapping returns (uint256) {
        uint256 feeAmount = amount * buyDevelopmentFee / FEEDENOMINATOR;
        uint256 newAmount = amount - feeAmount;
        tallyBuyFee(from, feeAmount, buyDevelopmentFee);
        return newAmount;
    }

    function takeSellFee(address from, uint256 amount) internal swapping returns (uint256) {
        uint256 feeAmount = amount * sellDevelopmentFee / FEEDENOMINATOR;
        uint256 newAmount = amount - feeAmount;
        tallySellFee(from, feeAmount, sellDevelopmentFee);
        return newAmount;
    }

    function takeTransferFee(address from, uint256 amount) internal swapping returns (uint256) {
        uint256 feeAmount = amount * transferDevelopmentFee / FEEDENOMINATOR;
        uint256 newAmount = amount - feeAmount;
        tallyTransferFee(from, feeAmount, transferDevelopmentFee);
        return newAmount;
    }

    function tallyBuyFee(address from, uint256 amount, uint256 fee) internal swapping {
        uint256 collectDevelopment = amount * buyDevelopmentFee / fee;
        tallyCollection(collectDevelopment, amount);
        
        _balances[from] -= amount;
        _balances[address(this)] += amount;
    }

    function tallySellFee(address from, uint256 amount, uint256 fee) internal swapping {
        uint256 collectDevelopment = amount * sellDevelopmentFee / fee;
        tallyCollection(collectDevelopment, amount);
        
        _balances[from] -= amount;
        _balances[address(this)] += amount;
    }

    function tallyTransferFee(address from, uint256 amount, uint256 fee) internal swapping {
        uint256 collectDevelopment = amount * transferDevelopmentFee / fee;
        tallyCollection(collectDevelopment, amount);

        _balances[from] -= amount;
        _balances[address(this)] += amount;
    }

    function tallyCollection(uint256 collectDevelopment, uint256 amount) internal swapping {
        developmentFeeCollected += collectDevelopment;
        totalFeeCollected += amount;
    }

    /* Buyback */

    function triggerZeusBuyback(uint256 amount) external authorized {
        buyTokens(amount, DEAD);
    }

    function buyTokens(uint256 amount, address to) internal swapping {
        if (msg.sender == DEAD) { revert InvalidAddress(DEAD); }
        address[] memory path = new address[](2);
        path[0] = router.WETH();
        path[1] = address(this);

        router.swapExactETHForTokensSupportingFeeOnTransferTokens{
            value: amount
        }(0, path, to, block.timestamp);
    }

    /* ERC20 Standard */

    function name() external view virtual override returns (string memory) {
        return NAME;
    }
    
    function symbol() external view virtual override returns (string memory) {
        return SYMBOL;
    }
    
    function decimals() external view virtual override returns (uint8) {
        return DECIMALS;
    }
    
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }
    
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }
    
    function transfer(address to, uint256 amount) external virtual override returns (bool) {
        address provider = msg.sender;
        return _transfer(provider, to, amount);
    }
    
    function allowance(address provider, address spender) public view virtual override returns (uint256) {
        return _allowances[provider][spender];
    }
    
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        address provider = msg.sender;
        _approve(provider, spender, amount);
        return true;
    }
    
    function transferFrom(address from, address to, uint256 amount) external virtual override returns (bool) {
        address spender = msg.sender;
        _spendAllowance(from, spender, amount);
        return _transfer(from, to, amount);
    }
    
    function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
        address provider = msg.sender;
        _approve(provider, spender, allowance(provider, spender) + addedValue);
        return true;
    }
    
    function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
        address provider = msg.sender;
        uint256 currentAllowance = allowance(provider, spender);
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(provider, spender, currentAllowance - subtractedValue);
        }

        return true;
    }
    
    function _mint(address account, uint256 amount) internal virtual {
        if (account == ZERO) { revert InvalidAddress(account); }

        _totalSupply += amount;
        unchecked {
            _balances[account] += amount;
        }
        emit Transfer(address(0), account, amount);
    }

    function _approve(address provider, address spender, uint256 amount) internal virtual {
        if (provider == ZERO) { revert InvalidAddress(provider); }
        if (spender == ZERO) { revert InvalidAddress(spender); }

        _allowances[provider][spender] = amount;
        emit Approval(provider, spender, amount);
    }
    
    function _spendAllowance(address provider, address spender, uint256 amount) internal virtual {
        uint256 currentAllowance = allowance(provider, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(provider, spender, currentAllowance - amount);
            }
        }
    }

    /* Additional */

    function _basicTransfer(address from, address to, uint256 amount ) internal returns (bool) {
        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[from] = fromBalance - amount;
            _balances[to] += amount;
        }

        emit Transfer(from, to, amount);
        return true;
    }
    
    /* Overrides */
 
    function _transfer(address from, address to, uint256 amount) internal virtual returns (bool) {
        if (from == ZERO) { revert InvalidAddress(from); }
        if (to == ZERO) { revert InvalidAddress(to); }

        if (inSwap || isExcludeFromFees[from]) {
            return _basicTransfer(from, to, amount);
        }

        if (from != pair && isSwapEnabled && totalFeeCollected - totalFeeRedeemed >= minSwap) {
            autoRedeem(minSwap);
        }

        uint256 newAmount = amount;

        if (isFeeActive && !isExcludeFromFees[from]) {
            newAmount = _beforeTokenTransfer(from, to, amount);
        }

        require(_balances[from] >= newAmount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[from] = _balances[from] - newAmount;
            _balances[to] += newAmount;
        }

        emit Transfer(from, to, newAmount);

        return true;
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal swapping virtual returns (uint256) {
        if (from == pair && (buyDevelopmentFee > 0)) {
            return takeBuyFee(from, amount);
        }
        if (to == pair && (sellDevelopmentFee > 0)) {
            return takeSellFee(from, amount);
        }
        if (from != pair && to != pair && (transferDevelopmentFee > 0)) {
            return takeTransferFee(from, amount);
        }
        return amount;
    }
}