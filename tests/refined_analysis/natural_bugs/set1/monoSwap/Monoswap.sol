// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.6.0 <0.8.0;

import "./openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "./openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "./openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./openzeppelin/contracts/math/SafeMath.sol";
import "./openzeppelin/contracts-upgradeable/proxy/Initializable.sol";
import "./openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
// import "hardhat/consolse.sol";
import "./libraries/IMonoXPool.sol";
import "./libraries/IWETH.sol";
import "./libraries/MonoXLibrary.sol";

interface IvUSD is IERC20 {
  function mint (address account, uint256 amount) external;

  function burn (address account, uint256 amount) external;
}


/**
 * The Monoswap is ERC1155 contract does this and that...
 */
contract Monoswap is Initializable, OwnableUpgradeable {
  using SafeMath for uint256;
  using SafeERC20 for IERC20;
  using SafeERC20 for IvUSD;

  IvUSD vUSD;
  address WETH;
  address feeTo;
  uint16 fees; // over 1e5, 300 means 0.3%
  uint16 devFee; // over 1e5, 50 means 0.05%

  uint256 constant MINIMUM_LIQUIDITY=100;
  

  struct PoolInfo {
    uint256 pid;
    uint256 lastPoolValue;
    address token;
    PoolStatus status;
    uint112 vusdDebt;
    uint112 vusdCredit;
    uint112 tokenBalance;
    uint112 price; // over 1e18
  }

  enum TxType {
    SELL,
    BUY
  }

  enum PoolStatus {
    UNLISTED,
    LISTED,
    OFFICIAL,
    SYNTHETIC,
    PAUSED
  }
  
  mapping (address => PoolInfo) public pools;
  // tokenStatus is for token lock/transfer. exempt means no need to verify post tx
  mapping (address => uint8) private tokenStatus; //0=unlocked, 1=locked, 2=exempt

  // token poool status is to track if the pool has already been created for the token
  mapping (address => uint8) public tokenPoolStatus; //0=undefined, 1=exists
  
  // negative vUSD balance allowed for each token
  mapping (address => uint) public tokenInsurance;

  uint256 public poolSize;

  uint private unlocked;
  modifier lock() {
    require(unlocked == 1, 'MonoX:LOCKED');
    unlocked = 0;
    _;
    unlocked = 1;
  }

  modifier lockToken(address _token) { 
    uint8 originalState = tokenStatus[_token];
    require(originalState!=1, 'MonoX:POOL_LOCKED');
    if(originalState==0) {
      tokenStatus[_token] = 1;
    }
    _;
    if(originalState==0) {
      tokenStatus[_token] = 0;
    }
  }

  modifier ensure(uint deadline) {
    require(deadline >= block.timestamp, 'MonoX:EXPIRED');
    _;
  }  

  modifier onlySyntheticPool(address _token){
    require(pools[_token].status==PoolStatus.SYNTHETIC,"MonoX:NOT_SYNT");
    _;
  }

  modifier onlyPriceAdjuster(){
    require(priceAdjusterRole[msg.sender]==true,"MonoX:BAD_ROLE");
    _;
  }

  event AddLiquidity(address indexed provider, 
    uint indexed pid,
    address indexed token,
    uint liquidityAmount,
    uint vusdAmount, uint tokenAmount);

  event RemoveLiquidity(address indexed provider, 
    uint indexed pid,
    address indexed token,
    uint liquidityAmount,
    uint vusdAmount, uint tokenAmount);

  event Swap(
    address indexed user,
    address indexed tokenIn,
    address indexed tokenOut,
    uint amountIn,
    uint amountOut
  );

  // event PriceAdjusterChanged(
  //   address indexed priceAdjuster,
  //   bool added
  // );

  event PoolBalanced(
    address _token,
    uint vusdIn
  );

  event SyntheticPoolPriceChanged(
    address _token,
    uint112 price
  );

  event PoolStatusChanged(
    address _token,
    PoolStatus oldStatus,
    PoolStatus newStatus
  );

  IMonoXPool public monoXPool;
  
  // mapping (token address => block number of the last trade)
  mapping (address => uint) public lastTradedBlock; 

  uint256 constant MINIMUM_POOL_VALUE = 10000 * 1e18;
  mapping (address=>bool) public priceAdjusterRole;

  // ------------
  uint public poolSizeMinLimit;

  function initialize(IMonoXPool _monoXPool, IvUSD _vusd) public initializer {
    OwnableUpgradeable.__Ownable_init();
    monoXPool = _monoXPool;
    vUSD = _vusd;
    WETH = _monoXPool.getWETHAddr();

    fees = 300;
    devFee = 50;
    poolSize = 0;
    unlocked = 1;
  }

  // receive() external payable {
  //   assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
  // }

  function setFeeTo (address _feeTo) onlyOwner external {
    feeTo = _feeTo;
  }
  
  function setFees (uint16 _fees) onlyOwner external {
    require(_fees<1e3);
    fees = _fees;
  }

  function setDevFee (uint16 _devFee) onlyOwner external {
    require(_devFee<1e3);
    devFee = _devFee;
  }

  function setPoolSizeMinLimit(uint _poolSizeMinLimit) onlyOwner external {
    poolSizeMinLimit = _poolSizeMinLimit;
  }

  function setTokenInsurance (address _token, uint _insurance) onlyOwner external {
    tokenInsurance[_token] = _insurance;
  }

  // when safu, setting token status to 2 can achieve significant gas savings 
  function setTokenStatus (address _token, uint8 _status) onlyOwner external {
    tokenStatus[_token] = _status;
  } 
  

  // update status of a pool. onlyOwner.
  function updatePoolStatus(address _token, PoolStatus _status) external onlyOwner {    

    PoolStatus poolStatus = pools[_token].status;
    if(poolStatus==PoolStatus.PAUSED){
      require(block.number > lastTradedBlock[_token].add(6000), "MonoX:TOO_EARLY");
    }
    else{
      // okay to pause an official pool, wait 6k blocks and then convert it to synthetic
      require(_status!=PoolStatus.SYNTHETIC,"MonoX:NO_SYNT");
    }
      
    emit PoolStatusChanged(_token, poolStatus,_status);
    pools[_token].status = _status;

    // unlisting a token allows creating a new pool of the same token. 
    // should move it to PAUSED if the goal is to blacklist the token forever
    if(_status==PoolStatus.UNLISTED) {
      tokenPoolStatus[_token] = 0;
    }
  }
  
  /**
    @dev update pools price if there were no active trading for the last 6000 blocks
    @notice Only owner callable, new price can neither be 0 nor be equal to old one
    @param _token pool identifider (token address)
    @param _newPrice new price in wei (uint112)
   */
  function updatePoolPrice(address _token, uint112 _newPrice) external onlyOwner {
    require(_newPrice > 0, 'MonoX:0_PRICE');
    require(tokenPoolStatus[_token] != 0, "MonoX:NO_POOL");

    require(block.number > lastTradedBlock[_token].add(6000), "MonoX:TOO_EARLY");
    pools[_token].price = _newPrice;
    lastTradedBlock[_token] = block.number;
  }

  function updatePriceAdjuster(address account, bool _status) external onlyOwner{
    priceAdjusterRole[account]=_status;
    //emit PriceAdjusterChanged(account,_status);
  }

  function setPoolPrice(address _token, uint112 price) external onlyPriceAdjuster onlySyntheticPool(_token){
    pools[_token].price=price;
    emit SyntheticPoolPriceChanged(_token,price);
  }

  function rebalancePool(address _token,uint256 vusdIn) external lockToken(_token) onlyOwner{
      // PoolInfo memory pool = pools[_token];
      uint poolPrice = pools[_token].price;
      require(vusdIn <= pools[_token].vusdDebt,"MonoX:NO_CREDIT");
      require(pools[_token].tokenBalance * poolPrice >= vusdIn,"MonoX:INSUF_TOKEN_VAL");
      // uint rebalancedAmount = vusdIn.mul(1e18).div(pool.price);
      monoXPool.safeTransferERC20Token(_token, msg.sender, vusdIn.mul(1e18).div(poolPrice));
      _syncPoolInfo(_token, vusdIn, 0);
      emit PoolBalanced(_token, vusdIn);
  }

  // creates a pool
  function _createPool (address _token, uint112 _price, PoolStatus _status) lock internal returns(uint256 _pid)  {
    require(tokenPoolStatus[_token]==0, "MonoX:POOL_EXISTS");
    require (_token != address(vUSD), "MonoX:NO_vUSD");
    _pid = poolSize;
    pools[_token] = PoolInfo({
      token: _token,
      pid: _pid,
      vusdCredit: 0,
      vusdDebt: 0,
      tokenBalance: 0,
      lastPoolValue: 0,
      status: _status,
      price: _price
    });

    poolSize = _pid.add(1);
    tokenPoolStatus[_token]=1;

    // initialze pool's lasttradingblocknumber as the block number on which the pool is created
    lastTradedBlock[_token] = block.number;
  }

  // creates a pool with special status
  function addSpecialToken (address _token, uint112 _price, PoolStatus _status) onlyOwner external returns(uint256 _pid)  {
    _pid = _createPool(_token, _price, _status);
  }

  // internal func to pay contract owner
  function _mintFee (uint256 pid, uint256 lastPoolValue, uint256 newPoolValue) internal {
    
    // uint256 _totalSupply = monoXPool.totalSupplyOf(pid);
    if(newPoolValue>lastPoolValue && lastPoolValue>0) {
      // safe ops, since newPoolValue>lastPoolValue
      uint256 deltaPoolValue = newPoolValue - lastPoolValue; 
      // safe ops, since newPoolValue = deltaPoolValue + lastPoolValue > deltaPoolValue
      uint256 devLiquidity = monoXPool.totalSupplyOf(pid).mul(deltaPoolValue).mul(devFee).div(newPoolValue-deltaPoolValue)/1e5;
      monoXPool.mint(feeTo, pid, devLiquidity);
    }
    
  }

  // util func to get some basic pool info
  function getPool (address _token) view public returns (uint256 poolValue, 
    uint256 tokenBalanceVusdValue, uint256 vusdCredit, uint256 vusdDebt) {
    // PoolInfo memory pool = pools[_token];
    vusdCredit = pools[_token].vusdCredit;
    vusdDebt = pools[_token].vusdDebt;
    tokenBalanceVusdValue = uint(pools[_token].price).mul(pools[_token].tokenBalance)/1e18;

    poolValue = tokenBalanceVusdValue.add(vusdCredit).sub(vusdDebt);
  }

  // trustless listing pool creation. always creates unofficial pool
  function listNewToken (address _token, uint112 _price, 
    uint256 vusdAmount, 
    uint256 tokenAmount,
    address to) external returns(uint _pid, uint256 liquidity) {
    _pid = _createPool(_token, _price, PoolStatus.LISTED);
    liquidity = _addLiquidityPair(_token, vusdAmount, tokenAmount, msg.sender, to);
  }

  // add liquidity pair to a pool. allows adding vusd.
  function addLiquidityPair (address _token, 
    uint256 vusdAmount, 
    uint256 tokenAmount,
    address to) external returns(uint256 liquidity) {
    liquidity = _addLiquidityPair(_token, vusdAmount, tokenAmount, msg.sender, to);
  }

    // add liquidity pair to a pool. allows adding vusd.
  function _addLiquidityPair (address _token, 
    uint256 vusdAmount, 
    uint256 tokenAmount,
    address from,
    address to) internal lockToken(_token) returns(uint256 liquidity) {
    require (tokenAmount>0, "MonoX:BAD_AMOUNT");

    require(tokenPoolStatus[_token]==1, "MonoX:NO_POOL");

    // (uint256 poolValue, , ,) = getPool(_token);
    PoolInfo memory pool = pools[_token];

    uint256 poolValue = uint(pool.price).mul(pool.tokenBalance)/1e18;
    poolValue = poolValue.add(pool.vusdCredit).sub(pool.vusdDebt);

    IMonoXPool monoXPoolLocal = monoXPool;
    
    _mintFee(pool.pid, pool.lastPoolValue, poolValue);

    tokenAmount = transferAndCheck(from,address(monoXPoolLocal),_token,tokenAmount);

    if(vusdAmount>0){
      vUSD.safeTransferFrom(msg.sender, address(monoXPoolLocal), vusdAmount);
      vUSD.burn(address(monoXPool), vusdAmount);
    }

    // this is to avoid stack too deep
    {
      uint256 _totalSupply = monoXPoolLocal.totalSupplyOf(pool.pid);
      uint256 liquidityVusdValue = vusdAmount.add(tokenAmount.mul(pool.price)/1e18);

      if(_totalSupply==0){
        liquidity = liquidityVusdValue.sub(MINIMUM_LIQUIDITY);
        // sorry, oz doesn't allow minting to address(0)
        monoXPoolLocal.mint(feeTo, pool.pid, MINIMUM_LIQUIDITY); 
      }else{
        liquidity = _totalSupply.mul(liquidityVusdValue).div(poolValue);
      }
    }

    monoXPoolLocal.mint(to, pool.pid, liquidity);
    _syncPoolInfo(_token, vusdAmount, 0);

    emit AddLiquidity(to, 
    pool.pid,
    _token,
    liquidity, 
    vusdAmount, tokenAmount);
  }
  
  // add one-sided liquidity to a pool. no vusd
  function addLiquidity (address _token, uint256 _amount, address to) external returns(uint256 liquidity)  {
    liquidity = _addLiquidityPair(_token, 0, _amount, msg.sender, to);
  }  

  // add one-sided ETH liquidity to a pool. no vusd
  function addLiquidityETH (address to) external payable returns(uint256 liquidity)  {
    MonoXLibrary.safeTransferETH(address(monoXPool), msg.value);
    monoXPool.depositWETH(msg.value);
    liquidity = _addLiquidityPair(WETH, 0, msg.value, address(this), to);
  }  

  // updates pool vusd balance, token balance and last pool value.
  // this function requires others to do the input validation
  function _syncPoolInfo (address _token, uint256 vusdIn, uint256 vusdOut) internal returns(uint256 poolValue, 
    uint256 tokenBalanceVusdValue, uint256 vusdCredit, uint256 vusdDebt) {
    // PoolInfo memory pool = pools[_token];
    uint256 tokenPoolPrice = pools[_token].price;
    (vusdCredit, vusdDebt) = _updateVusdBalance(_token, vusdIn, vusdOut);

    uint256 tokenReserve = IERC20(_token).balanceOf(address(monoXPool));
    tokenBalanceVusdValue = tokenPoolPrice.mul(tokenReserve)/1e18;

    require(tokenReserve <= uint112(-1));
    pools[_token].tokenBalance = uint112(tokenReserve);
    // poolValue = tokenBalanceVusdValue.add(vusdCredit).sub(vusdDebt);
    pools[_token].lastPoolValue = tokenBalanceVusdValue.add(vusdCredit).sub(vusdDebt);
  }
  
  // view func for removing liquidity
  function _removeLiquidity (address _token, uint256 liquidity,
    address to) view public returns(
    uint256 poolValue, uint256 liquidityIn, uint256 vusdOut, uint256 tokenOut) {
    
    require (liquidity>0, "MonoX:BAD_AMOUNT");
    uint256 tokenBalanceVusdValue;
    uint256 vusdCredit;
    uint256 vusdDebt;
    PoolInfo memory pool = pools[_token];
    (poolValue, tokenBalanceVusdValue, vusdCredit, vusdDebt) = getPool(_token);
    uint256 _totalSupply = monoXPool.totalSupplyOf(pool.pid);

    liquidityIn = monoXPool.balanceOf(to, pool.pid)>liquidity?liquidity:monoXPool.balanceOf(to, pool.pid);
    uint256 tokenReserve = IERC20(_token).balanceOf(address(monoXPool));
    
    if(tokenReserve < pool.tokenBalance){
      tokenBalanceVusdValue = tokenReserve.mul(pool.price)/1e18;
    }

    if(vusdDebt>0){
      tokenReserve = (tokenBalanceVusdValue.sub(vusdDebt)).mul(1e18).div(pool.price);
    }

    // if vusdCredit==0, vusdOut will be 0 as well
    vusdOut = liquidityIn.mul(vusdCredit).div(_totalSupply);

    tokenOut = liquidityIn.mul(tokenReserve).div(_totalSupply);

  }
  
  // actually removes liquidity
  function removeLiquidity (address _token, uint256 liquidity, address to, 
    uint256 minVusdOut, 
    uint256 minTokenOut) external returns(uint256 vusdOut, uint256 tokenOut)  {
    (vusdOut, tokenOut) = _removeLiquidityHelper (_token, liquidity, to, minVusdOut, minTokenOut, false);
  }

  // actually removes liquidity
  function _removeLiquidityHelper (address _token, uint256 liquidity, address to, 
    uint256 minVusdOut, 
    uint256 minTokenOut,
    bool isETH) lockToken(_token) internal returns(uint256 vusdOut, uint256 tokenOut)  {
    require (tokenPoolStatus[_token]==1, "MonoX:NO_TOKEN");
    PoolInfo memory pool = pools[_token];
    uint256 poolValue;
    uint256 liquidityIn;
    (poolValue, liquidityIn, vusdOut, tokenOut) = _removeLiquidity(_token, liquidity, to);
    _mintFee(pool.pid, pool.lastPoolValue, poolValue);
    require (vusdOut>=minVusdOut, "MonoX:INSUFF_vUSD");
    require (tokenOut>=minTokenOut, "MonoX:INSUFF_TOKEN");

    if (vusdOut>0){
      vUSD.mint(to, vusdOut);
    }
    if (!isETH) {
      monoXPool.safeTransferERC20Token(_token, to, tokenOut);
    } else {
      monoXPool.withdrawWETH(tokenOut);
      monoXPool.safeTransferETH(to, tokenOut);
    }

    monoXPool.burn(to, pool.pid, liquidityIn);

    _syncPoolInfo(_token, 0, vusdOut);

    emit RemoveLiquidity(to, 
      pool.pid,
      _token,
      liquidityIn, 
      vusdOut, tokenOut);
  }

  // actually removes ETH liquidity
  function removeLiquidityETH (uint256 liquidity, address to, 
    uint256 minVusdOut, 
    uint256 minTokenOut) external returns(uint256 vusdOut, uint256 tokenOut)  {

    (vusdOut, tokenOut) = _removeLiquidityHelper (WETH, liquidity, to, minVusdOut, minTokenOut, true);
  }

  // util func to compute new price
  function _getNewPrice (uint256 originalPrice, uint256 reserve, 
    uint256 delta, TxType txType) pure internal returns(uint256 price) {
    if(txType==TxType.SELL) {
      // no risk of being div by 0
      price = originalPrice.mul(reserve)/(reserve.add(delta));
    }else{ // BUY
      price = originalPrice.mul(reserve).div(reserve.sub(delta));
    }
  }

  // util func to compute new price
  function _getAvgPrice (uint256 originalPrice, uint256 newPrice) pure internal returns(uint256 price) {
    price = originalPrice.add(newPrice.mul(4))/5;
  }

  // standard swap interface implementing uniswap router V2
  
  function swapExactETHForToken(
    address tokenOut,
    uint amountOutMin,
    address to,
    uint deadline
  ) external virtual payable ensure(deadline) returns (uint amountOut) {
    uint amountIn = msg.value;
    MonoXLibrary.safeTransferETH(address(monoXPool), amountIn);
    monoXPool.depositWETH(amountIn);
    amountOut = swapIn(WETH, tokenOut, address(this), to, amountIn);
    require(amountOut >= amountOutMin, 'MonoX:INSUFF_OUTPUT');
  }
  
  function swapExactTokenForETH(
    address tokenIn,
    uint amountIn,
    uint amountOutMin,
    address to,
    uint deadline
  ) external virtual ensure(deadline) returns (uint amountOut) {
    IMonoXPool monoXPoolLocal = monoXPool;
    amountOut = swapIn(tokenIn, WETH, msg.sender, address(monoXPoolLocal), amountIn);
    require(amountOut >= amountOutMin, 'MonoX:INSUFF_OUTPUT');
    monoXPoolLocal.withdrawWETH(amountOut);
    monoXPoolLocal.safeTransferETH(to, amountOut);
  }

  function swapETHForExactToken(
    address tokenOut,
    uint amountInMax,
    uint amountOut,
    address to,
    uint deadline
  ) external virtual payable ensure(deadline) returns (uint amountIn) {
    uint amountSentIn = msg.value;
    ( , , amountIn, ) = getAmountIn(WETH, tokenOut, amountOut);
    MonoXLibrary.safeTransferETH(address(monoXPool), amountIn);
    monoXPool.depositWETH(amountIn);
    amountIn = swapOut(WETH, tokenOut, address(this), to, amountOut);
    require(amountIn <= amountSentIn, 'MonoX:BAD_INPUT');
    require(amountIn <= amountInMax, 'MonoX:EXCESSIVE_INPUT');
    if (amountSentIn > amountIn) {
      MonoXLibrary.safeTransferETH(msg.sender, amountSentIn.sub(amountIn));
    }
  }

  function swapTokenForExactETH(
    address tokenIn,
    uint amountInMax,
    uint amountOut,
    address to,
    uint deadline
  ) external virtual ensure(deadline) returns (uint amountIn) {
    IMonoXPool monoXPoolLocal = monoXPool;
    amountIn = swapOut(tokenIn, WETH, msg.sender, address(monoXPoolLocal), amountOut);
    require(amountIn <= amountInMax, 'MonoX:EXCESSIVE_INPUT');
    monoXPoolLocal.withdrawWETH(amountOut);
    monoXPoolLocal.safeTransferETH(to, amountOut);
  }

  function swapExactTokenForToken(
    address tokenIn,
    address tokenOut,
    uint amountIn,
    uint amountOutMin,
    address to,
    uint deadline
  ) external virtual ensure(deadline) returns (uint amountOut) {
    amountOut = swapIn(tokenIn, tokenOut, msg.sender, to, amountIn);
    require(amountOut >= amountOutMin, 'MonoX:INSUFF_OUTPUT');
  }

  function swapTokenForExactToken(
    address tokenIn,
    address tokenOut,
    uint amountInMax,
    uint amountOut,
    address to,
    uint deadline
  ) external virtual ensure(deadline) returns (uint amountIn) {
    amountIn = swapOut(tokenIn, tokenOut, msg.sender, to, amountOut);
    require(amountIn <= amountInMax, 'MonoX:EXCESSIVE_INPUT');
  }

  // util func to manipulate vusd balance
  function _updateVusdBalance (address _token, 
    uint _vusdIn, uint _vusdOut) internal returns (uint _vusdCredit, uint _vusdDebt) {
    if(_vusdIn>_vusdOut){
      _vusdIn = _vusdIn - _vusdOut;
      _vusdOut = 0;
    }else{
      _vusdOut = _vusdOut - _vusdIn;
      _vusdIn = 0;
    }

    // PoolInfo memory _pool = pools[_token];
    uint _poolVusdCredit = pools[_token].vusdCredit;
    uint _poolVusdDebt = pools[_token].vusdDebt;
    PoolStatus _poolStatus = pools[_token].status;
    
    if(_vusdOut>0){
      (_vusdCredit, _vusdDebt) = MonoXLibrary.vusdBalanceSub(
        _poolVusdCredit, _poolVusdDebt, _vusdOut);
      require(_vusdCredit <= uint112(-1) && _vusdDebt <= uint112(-1));
      pools[_token].vusdCredit = uint112(_vusdCredit);
      pools[_token].vusdDebt = uint112(_vusdDebt);
    }

    if(_vusdIn>0){
      (_vusdCredit, _vusdDebt) = MonoXLibrary.vusdBalanceAdd(
        _poolVusdCredit, _poolVusdDebt, _vusdIn);
      require(_vusdCredit <= uint112(-1) && _vusdDebt <= uint112(-1));
      pools[_token].vusdCredit = uint112(_vusdCredit);
      pools[_token].vusdDebt = uint112(_vusdDebt);
    }

    if(_poolStatus == PoolStatus.LISTED){

      require (_vusdDebt<=tokenInsurance[_token], "MonoX:INSUFF_vUSD");
    }
  }
  
  // updates pool token balance and price.
  function _updateTokenInfo (address _token, uint256 _price,
      uint256 _vusdIn, uint256 _vusdOut, uint256 _ETHDebt) internal {
    uint256 _balance = IERC20(_token).balanceOf(address(monoXPool));
    _balance = _balance.sub(_ETHDebt);
    require(pools[_token].status!=PoolStatus.PAUSED,"MonoX:PAUSED");
    require(_price <= uint112(-1) && _balance <= uint112(-1));
    (uint initialPoolValue, , ,) = getPool(_token);
    pools[_token].tokenBalance = uint112(_balance);
    pools[_token].price = uint112(_price);

    // record last trade's block number in mapping: lastTradedBlock
    lastTradedBlock[_token] = block.number;

    _updateVusdBalance(_token, _vusdIn, _vusdOut);

    (uint poolValue, , ,) = getPool(_token);

    require(initialPoolValue <= poolValue || poolValue >= poolSizeMinLimit,
      "MonoX:MIN_POOL_SIZE");
    
    
  }

  function directSwapAllowed(uint tokenInPoolPrice,uint tokenOutPoolPrice, 
                              uint tokenInPoolTokenBalance, uint tokenOutPoolTokenBalance, PoolStatus status, bool getsAmountOut) internal pure returns(bool){
      uint tokenInValue  = tokenInPoolTokenBalance.mul(tokenInPoolPrice).div(1e18);
      uint tokenOutValue = tokenOutPoolTokenBalance.mul(tokenOutPoolPrice).div(1e18);
      bool priceExists   = getsAmountOut?tokenInPoolPrice>0:tokenOutPoolPrice>0;
      
      // only if it's official pool with similar size
      return priceExists&&status==PoolStatus.OFFICIAL&&tokenInValue>0&&tokenOutValue>0&&
        ((tokenInValue/tokenOutValue)+(tokenOutValue/tokenInValue)==1);
        
  }

  // view func to compute amount required for tokenIn to get fixed amount of tokenOut
  function getAmountIn(address tokenIn, address tokenOut, 
    uint256 amountOut) public view returns (uint256 tokenInPrice, uint256 tokenOutPrice, 
    uint256 amountIn, uint256 tradeVusdValue) {
    require(amountOut > 0, 'MonoX:INSUFF_INPUT');
    
    uint256 amountOutWithFee = amountOut.mul(1e5).div(1e5 - fees);
    address vusdAddress = address(vUSD);
    uint tokenOutPoolPrice = pools[tokenOut].price;
    uint tokenOutPoolTokenBalance = pools[tokenOut].tokenBalance;
    if(tokenOut==vusdAddress){
      tradeVusdValue = amountOutWithFee;
      tokenOutPrice = 1e18;
    }else{
      require (tokenPoolStatus[tokenOut]==1, "MonoX:NO_POOL");
      // PoolInfo memory tokenOutPool = pools[tokenOut];
      PoolStatus tokenOutPoolStatus = pools[tokenOut].status;
      
      require (tokenOutPoolStatus != PoolStatus.UNLISTED, "MonoX:POOL_UNLST");
      tokenOutPrice = _getNewPrice(tokenOutPoolPrice, tokenOutPoolTokenBalance, 
        amountOutWithFee, TxType.BUY);

      tradeVusdValue = _getAvgPrice(tokenOutPoolPrice, tokenOutPrice).mul(amountOutWithFee)/1e18;
    }

    if(tokenIn==vusdAddress){
      amountIn = tradeVusdValue;
      tokenInPrice = 1e18;
    }else{
      require (tokenPoolStatus[tokenIn]==1, "MonoX:NO_POOL");
      // PoolInfo memory tokenInPool = pools[tokenIn];
      PoolStatus tokenInPoolStatus = pools[tokenIn].status;
      uint tokenInPoolPrice = pools[tokenIn].price;
      uint tokenInPoolTokenBalance = pools[tokenIn].tokenBalance;
      require (tokenInPoolStatus != PoolStatus.UNLISTED, "MonoX:POOL_UNLST");

      amountIn = tradeVusdValue.add(tokenInPoolTokenBalance.mul(tokenInPoolPrice).div(1e18));
      amountIn = tradeVusdValue.mul(tokenInPoolTokenBalance).div(amountIn);


      bool allowDirectSwap=directSwapAllowed(tokenInPoolPrice,tokenOutPoolPrice,tokenInPoolTokenBalance,tokenOutPoolTokenBalance,tokenInPoolStatus,false);

      // assuming p1*p2 = k, equivalent to uniswap's x * y = k
      uint directSwapTokenInPrice = allowDirectSwap?tokenOutPoolPrice.mul(tokenInPoolPrice).div(tokenOutPrice):1;

      tokenInPrice = _getNewPrice(tokenInPoolPrice, tokenInPoolTokenBalance, 
        amountIn, TxType.SELL);

      tokenInPrice = directSwapTokenInPrice > tokenInPrice?directSwapTokenInPrice:tokenInPrice;

      amountIn = tradeVusdValue.mul(1e18).div(_getAvgPrice(tokenInPoolPrice, tokenInPrice));
    }
  }

  // view func to compute amount required for tokenOut to get fixed amount of tokenIn
  function getAmountOut(address tokenIn, address tokenOut, 
    uint256 amountIn) public view returns (uint256 tokenInPrice, uint256 tokenOutPrice, 
    uint256 amountOut, uint256 tradeVusdValue) {
    require(amountIn > 0, 'MonoX:INSUFF_INPUT');
    
    uint256 amountInWithFee = amountIn.mul(1e5-fees)/1e5;
    address vusdAddress = address(vUSD);
    uint tokenInPoolPrice = pools[tokenIn].price;
    uint tokenInPoolTokenBalance = pools[tokenIn].tokenBalance;

    if(tokenIn==vusdAddress){
      tradeVusdValue = amountInWithFee;
      tokenInPrice = 1e18;
    }else{
      require (tokenPoolStatus[tokenIn]==1, "MonoX:NO_POOL");
      // PoolInfo memory tokenInPool = pools[tokenIn];
      PoolStatus tokenInPoolStatus = pools[tokenIn].status;
      
      require (tokenInPoolStatus != PoolStatus.UNLISTED, "MonoX:POOL_UNLST");
      
      tokenInPrice = _getNewPrice(tokenInPoolPrice, tokenInPoolTokenBalance, 
        amountInWithFee, TxType.SELL);
      tradeVusdValue = _getAvgPrice(tokenInPoolPrice, tokenInPrice).mul(amountInWithFee)/1e18;
    }

    if(tokenOut==vusdAddress){
      amountOut = tradeVusdValue;
      tokenOutPrice = 1e18;
    }else{
      require (tokenPoolStatus[tokenOut]==1, "MonoX:NO_POOL");
      // PoolInfo memory tokenOutPool = pools[tokenOut];
      PoolStatus tokenOutPoolStatus = pools[tokenOut].status;
      uint tokenOutPoolPrice = pools[tokenOut].price;
      uint tokenOutPoolTokenBalance = pools[tokenOut].tokenBalance;

      require (tokenOutPoolStatus != PoolStatus.UNLISTED, "MonoX:POOL_UNLST");
      
      amountOut = tradeVusdValue.add(tokenOutPoolTokenBalance.mul(tokenOutPoolPrice).div(1e18));
      amountOut = tradeVusdValue.mul(tokenOutPoolTokenBalance).div(amountOut);

      bool allowDirectSwap=directSwapAllowed(tokenInPoolPrice,tokenOutPoolPrice,tokenInPoolTokenBalance,tokenOutPoolTokenBalance,tokenOutPoolStatus,true);

      // assuming p1*p2 = k, equivalent to uniswap's x * y = k
      uint directSwapTokenOutPrice = allowDirectSwap?tokenInPoolPrice.mul(tokenOutPoolPrice).div(tokenInPrice):uint(-1);

      // prevent the attack where user can use a small pool to update price in a much larger pool
      tokenOutPrice = _getNewPrice(tokenOutPoolPrice, tokenOutPoolTokenBalance, 
        amountOut, TxType.BUY);
      tokenOutPrice = directSwapTokenOutPrice < tokenOutPrice?directSwapTokenOutPrice:tokenOutPrice;

      amountOut = tradeVusdValue.mul(1e18).div(_getAvgPrice(tokenOutPoolPrice, tokenOutPrice));
    }
  }


  // swap from tokenIn to tokenOut with fixed tokenIn amount.
  function swapIn (address tokenIn, address tokenOut, address from, address to,
      uint256 amountIn) internal lockToken(tokenIn) returns(uint256 amountOut)  {

    address monoXPoolLocal = address(monoXPool);

    amountIn = transferAndCheck(from,monoXPoolLocal,tokenIn,amountIn); 
    
    // uint256 halfFeesInTokenIn = amountIn.mul(fees)/2e5;

    uint256 tokenInPrice;
    uint256 tokenOutPrice;
    uint256 tradeVusdValue;
    
    (tokenInPrice, tokenOutPrice, amountOut, tradeVusdValue) = getAmountOut(tokenIn, tokenOut, amountIn);

    uint256 oneSideFeesInVusd = tokenInPrice.mul(amountIn.mul(fees)/2e5)/1e18;

    // trading in
    if(tokenIn==address(vUSD)){
      vUSD.burn(monoXPoolLocal, amountIn);
      // all fees go to the other side
      oneSideFeesInVusd = oneSideFeesInVusd.mul(2);
    }else{
      _updateTokenInfo(tokenIn, tokenInPrice, 0, tradeVusdValue.add(oneSideFeesInVusd), 0);
    }

    // trading out
    if(tokenOut==address(vUSD)){
      vUSD.mint(to, amountOut);
    }else{
      if (to != monoXPoolLocal) {
        IMonoXPool(monoXPoolLocal).safeTransferERC20Token(tokenOut, to, amountOut);
      }
      _updateTokenInfo(tokenOut, tokenOutPrice, tradeVusdValue.add(oneSideFeesInVusd), 0, 
        to == monoXPoolLocal ? amountOut : 0);
    }

    emit Swap(to, tokenIn, tokenOut, amountIn, amountOut);
    
  }

  
  // swap from tokenIn to tokenOut with fixed tokenOut amount.
  function swapOut (address tokenIn, address tokenOut, address from, address to, 
      uint256 amountOut) internal lockToken(tokenIn) returns(uint256 amountIn)  {
    uint256 tokenInPrice;
    uint256 tokenOutPrice;
    uint256 tradeVusdValue;
    (tokenInPrice, tokenOutPrice, amountIn, tradeVusdValue) = getAmountIn(tokenIn, tokenOut, amountOut);
    
    address monoXPoolLocal = address(monoXPool);

    amountIn = transferAndCheck(from,monoXPoolLocal,tokenIn,amountIn);

    // uint256 halfFeesInTokenIn = amountIn.mul(fees)/2e5;

    uint256 oneSideFeesInVusd = tokenInPrice.mul(amountIn.mul(fees)/2e5)/1e18;

    // trading in
    if(tokenIn==address(vUSD)){
      vUSD.burn(monoXPoolLocal, amountIn);
      // all fees go to buy side
      oneSideFeesInVusd = oneSideFeesInVusd.mul(2);
    }else {
      _updateTokenInfo(tokenIn, tokenInPrice, 0, tradeVusdValue.add(oneSideFeesInVusd), 0);
    }

    // trading out
    if(tokenOut==address(vUSD)){
      vUSD.mint(to, amountOut);
      // all fees go to sell side
      _updateVusdBalance(tokenIn, oneSideFeesInVusd, 0);
    }else{
      if (to != monoXPoolLocal) {
        IMonoXPool(monoXPoolLocal).safeTransferERC20Token(tokenOut, to, amountOut);
      }
      _updateTokenInfo(tokenOut, tokenOutPrice, tradeVusdValue.add(oneSideFeesInVusd), 0, 
        to == monoXPoolLocal ? amountOut:0 );
    }

    emit Swap(to, tokenIn, tokenOut, amountIn, amountOut);

  }

  // function balanceOf(address account, uint256 id) public view returns (uint256) {
  //   return monoXPool.balanceOf(account, id);
  // }

  // function getConfig() public view returns (address _vUSD, address _feeTo, uint16 _fees, uint16 _devFee) {
  //   _vUSD = address(vUSD);
  //   _feeTo = feeTo;
  //   _fees = fees;
  //   _devFee = devFee;
  // }

  function transferAndCheck(address from,address to,address _token,uint amount) internal returns (uint256){
    if(from == address(this)){
      return amount; // if it's ETH
    }

    // if it's not ETH
    if(tokenStatus[_token]==2){
      IERC20(_token).safeTransferFrom(from, to, amount);
      return amount;
    }else{
      uint256 balanceIn0 = IERC20(_token).balanceOf(to);
      IERC20(_token).safeTransferFrom(from, to, amount);
      uint256 balanceIn1 = IERC20(_token).balanceOf(to);
      return balanceIn1.sub(balanceIn0);
    }   

  }
}