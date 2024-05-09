/**

Telegram t.me/McBasePortal
Website wwww.mcbase.finance
Twitter www.twitter.com/Mcbase_Finance
Medium: https://mcbase-finance.medium.com/

*/ 

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}



/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}



/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

interface AggregatorV3Interface {

  function decimals() external view returns (uint8);
  function description() external view returns (string memory);
  function version() external view returns (uint256);

  // getRoundData and latestRoundData should both raise "No data present"
  // if they do not have data to report, instead of returning unset values
  // which could be misinterpreted as actual reported values.
  function getRoundData(uint80 _roundId)
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );
  function latestRoundData()
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );

}

contract PriceConsumerV3 {

    AggregatorV3Interface internal priceFeed;

    /**
     * Network: Goerli
     * Aggregator: ETH/USD
     * Address: 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
     */
    constructor() public {
        priceFeed = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419); //eth mainnet : 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
    }

    /**
     * Returns the latest price
     */
    function getLatestPrice() public view returns (int) {
        (
            uint80 roundID, 
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        return price;
    }
}

interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IUniswapV2Pair {
    function sync() external;
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

contract MCBASE is Context, IERC20, Ownable {
    using SafeMath for uint256;
    using Address for address;
    
    IUniswapV2Router02 public uniV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
    address public uniEthPool;
    address[] public uniPairPath;
    
    PriceConsumerV3 _priceContract;
    
    string private _name = 'McBase.finance';
    string private _symbol = 'MCBASE';
    uint8 private _decimals = 18;
    
    uint256 private constant MAX_UINT256 = ~uint256(0);
    uint256 private constant INITIAL_TOTAL_SUPPLY = 3000 * 1e18;
    uint256 private constant TOTAL_MUL = MAX_UINT256 - (MAX_UINT256 % INITIAL_TOTAL_SUPPLY);
    uint256 private constant MAX_SUPPLY = ~uint128(0);
    uint256 public PEGGED_PRICE = 515e6;                                                // $5.15

    uint256 private _totalSupply;
    uint256 private _rebaseRate;
    mapping (address => uint256) private _balance;
    mapping (address => mapping (address => uint256)) private _allowances;
    mapping(address => bool) public blacklist;
    
    uint256 public _supersize_caller_fee = 5e18;
    uint256 public _epochCycle = 12 hours;    //main net 12 hours;
    uint256 public _lastEpochTime;
    uint256 public _lastRebaseBlock;
    bool public _live;
    uint256 public _rebaseLag = 50;                         // lag 5
    
    uint256 private _lastPriceCheckTime;
    uint256 private _priceCumulative;
    uint256 private _priceCheckInterval = 30 seconds;

    bool swapping;
    uint256 public _txFee = 5;  // 2.5% to liquidity, 2.5% to team
    modifier lockTheSwap {swapping = true; _; swapping = false;}
    address private team = 0x366098c9a8f4f2C13F68348cbd37b71c02886B8e;
    uint256 public _swapThreshold = 1000; //0.1% of total supply
    
    
    constructor () public {
        _priceContract = new PriceConsumerV3();
        
        _totalSupply = INITIAL_TOTAL_SUPPLY;
        _balance[_msgSender()] = TOTAL_MUL;
        _rebaseRate = TOTAL_MUL.div(INITIAL_TOTAL_SUPPLY);
        
        uniEthPool = IUniswapV2Factory(uniV2Router.factory())
            .createPair(address(this), uniV2Router.WETH());
            
        uniPairPath = new address[](2);
        uniPairPath[0] = uniV2Router.WETH();
        uniPairPath[1] = address(this);
        
        emit Transfer(address(0x0), _msgSender(), _totalSupply);
    }

    receive() external payable {}
    
    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balance[account].div(_rebaseRate);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }
    
    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }
    
    function _transfer(address sender, address recipient, uint256 amount) private {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer from the zero address");
        require(amount > 0, "ERC20: Transfer amount must be greater than zero");
        
        if(block.number == _lastRebaseBlock)
            require(sender == address(this), 'MCBASE: the transaction is not allowed at epoch block.');
            
        if(sender != uniEthPool)
            require(!blacklist[recipient] && !blacklist[sender], 'MCBASE: the transaction was blocked.');
        
        uint256 currentTime =  block.timestamp;
        if(_live && currentTime.sub(_lastPriceCheckTime) >= _priceCheckInterval) {
            uint256 tokenPriceInUSD = getTokenPriceInUSD();
            _priceCumulative = _priceCumulative.add(tokenPriceInUSD.mul(currentTime.sub(_lastPriceCheckTime)));
            _lastPriceCheckTime = currentTime;
        }

        if(!swapping && balanceOf(address(this)) >= _totalSupply.div(_swapThreshold) && msg.sender != uniEthPool) {
            swapAndLiquify(_totalSupply.div(_swapThreshold));
        }
               
        uint256 rebaseValue = amount.mul(_rebaseRate);
        _balance[sender] = _balance[sender].sub(rebaseValue);

        if(sender != owner() && recipient != owner() && (sender == uniEthPool || sender == address(uniV2Router) || recipient == uniEthPool || recipient == address(uniV2Router))) {
            uint256 txFee = _live ? _txFee : 25;
            uint256 feeAmount = amount.mul(txFee).div(100);
            uint256 rebaseFeeAmount = feeAmount.mul(_rebaseRate);
            _balance[recipient] = _balance[recipient].add(rebaseValue.sub(rebaseFeeAmount));
            _balance[address(this)] = _balance[address(this)].add(rebaseFeeAmount);
            emit Transfer(sender, recipient, amount.sub(feeAmount));
            emit Transfer(sender, address(this), feeAmount);
        } else {
            _balance[recipient] = _balance[recipient].add(rebaseValue);
            emit Transfer(sender, recipient, amount);
        }
    }
    
    function swapAndLiquify(uint256 tokens) private lockTheSwap {
        uint256 toTeam = tokens.mul(3).div(4);
        uint256 initialBalance = address(this).balance;
        swapTokensForETH(toTeam);
        uint256 deltaBalance = address(this).balance.sub(initialBalance);
        uint256 teamBalance= deltaBalance.mul(2).div(3);
        uint256 ETHToAddLiquidityWith = deltaBalance.sub(teamBalance);
        if(ETHToAddLiquidityWith > 0){
            addLiquidity(tokens.sub(toTeam), ETHToAddLiquidityWith); }
        if(teamBalance > 0){
          payable(team).transfer(teamBalance); }
    }

    function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
        _approve(address(this), address(uniV2Router), tokenAmount);
        uniV2Router.addLiquidityETH{value: ETHAmount}(
            address(this),
            tokenAmount,
            0,
            0,
            address(this),
            block.timestamp);
    }

    function swapTokensForETH(uint256 tokenAmount) private {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniV2Router.WETH();
        _approve(address(this), address(uniV2Router), tokenAmount);
        uniV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(this),
            block.timestamp);
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
    
    function Supersize() public returns(uint256) {
        require(_live && block.timestamp >= _lastEpochTime + _epochCycle, 'MCBASE: early epoch.');

        uint256 currentTime =  block.timestamp;
        uint256 tokenPriceInUSD = getTokenPriceInUSD();
        uint256 peggedPriceInUSD = PEGGED_PRICE.mul(1e18);
        
        uint256 priceCumulative = _priceCumulative.add(tokenPriceInUSD.mul(currentTime.sub(_lastPriceCheckTime)));
        uint256 tokenAveragePriceInUSD = priceCumulative.div(currentTime.sub(_lastEpochTime));

        _lastEpochTime = currentTime;
        _lastPriceCheckTime = currentTime;
        _priceCumulative = 0;
        _lastRebaseBlock = block.number;
        
        uint256 newTotalSupply = _totalSupply.mul(tokenAveragePriceInUSD).div(peggedPriceInUSD);
        
        if(newTotalSupply > _totalSupply) {
            uint256 increaseAmount = (newTotalSupply.sub(_totalSupply)).mul(10).div(_rebaseLag);
            _totalSupply = _totalSupply.add(increaseAmount);
        }
        else if(newTotalSupply < _totalSupply) {
            uint256 decreaseAmount = (_totalSupply.sub(newTotalSupply)).mul(10).div(_rebaseLag);
            _totalSupply = _totalSupply.sub(decreaseAmount);
        }
        
        _rebaseRate = TOTAL_MUL.div(_totalSupply);
        IUniswapV2Pair(uniEthPool).sync();
        
        if(_supersize_caller_fee > 0)
            _transfer(address(this), _msgSender(), _supersize_caller_fee);

        return newTotalSupply;
    }
    
    function updateLive() public onlyOwner {
        if(!_live) {
            _lastEpochTime = block.timestamp;
            _lastPriceCheckTime = _lastEpochTime;
            _live = true;    
        }
    }
    
    function updateRebaseLag(uint256 rebaseLag) public onlyOwner {
        require(rebaseLag > 0, 'MCBASE: rebase lag is 0');
        _rebaseLag = rebaseLag;
    }

    function updateSuperizeCallerFee(uint256 supersize_caller_fee) public onlyOwner {
        _supersize_caller_fee = supersize_caller_fee;
    }
    
    function unblockWallet(address account) public onlyOwner {
        blacklist[account] = false;
    }

    function updateTxFee(uint256 txFee) public onlyOwner {
        require(txFee <=5, 'max txFee is 5.');
        _txFee = txFee;
    }

    function updatePeggedPrice(uint256 peggedPrice) public onlyOwner {
        require(peggedPrice > 1e6, 'pegged price should be greater than $0.01');
        PEGGED_PRICE = peggedPrice;
    }

    function updateSwapThreshold(uint256 swapThreshold) public onlyOwner {
        require(swapThreshold >= 100, 'max swap threshold percentage is 1% of total supply');
        _swapThreshold = swapThreshold;
    }
    
    function getTokenAveragePriceInUSD() public view returns(uint256) {
        uint256 currentTime =  block.timestamp;
        uint256 tokenPriceInUSD = getTokenPriceInUSD();
        uint256 priceCumulative = _priceCumulative.add(tokenPriceInUSD.mul(currentTime.sub(_lastPriceCheckTime)));
        return priceCumulative.div(currentTime.sub(_lastEpochTime));
    }
    
    function getTokenPriceInETH() public view returns(uint256) {
        return uniV2Router.getAmountsIn(1e18, uniPairPath)[0];
    }
    
    function getETHPriceInUSD() public view returns(uint256) {
        return uint256(_priceContract.getLatestPrice());
    }
    
    function getTokenPriceInUSD() public view returns(uint256) {
        uint256 tokenPriceInETH = getTokenPriceInETH();
        uint256 ETHPriceInUSD = uint256(_priceContract.getLatestPrice());
        return tokenPriceInETH.mul(ETHPriceInUSD);
    }
    
    function getSupersizeRate() public view returns(uint256, bool) {
        uint256 currentTime =  block.timestamp;
        uint256 tokenPriceInUSD = getTokenPriceInUSD();
        uint256 peggedPriceInUSD = PEGGED_PRICE.mul(1e18);
        
        uint256 priceCumulative = _priceCumulative.add(tokenPriceInUSD.mul(currentTime.sub(_lastPriceCheckTime)));
        uint256 tokenAveragePriceInUSD = priceCumulative.div(currentTime.sub(_lastEpochTime));
        
        uint256 newTotalSupply = _totalSupply.mul(tokenAveragePriceInUSD).div(peggedPriceInUSD);
        
        if(newTotalSupply >= _totalSupply) {
            return ((newTotalSupply.sub(_totalSupply)).mul(10000).div(_totalSupply), true);
        } else if(newTotalSupply < _totalSupply) {
            return ((_totalSupply.sub(newTotalSupply)).mul(10000).div(_totalSupply), false);
        }
    }
}