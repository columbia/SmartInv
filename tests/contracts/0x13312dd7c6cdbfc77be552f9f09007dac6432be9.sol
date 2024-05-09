// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol

pragma solidity ^0.5.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see {ERC20Detailed}.
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

// File: openzeppelin-solidity/contracts/math/SafeMath.sol

pragma solidity ^0.5.0;

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
     * - Subtraction cannot overflow.
     *
     * _Available since v2.4.0._
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
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
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
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: openzeppelin-solidity/contracts/utils/Address.sol

pragma solidity ^0.5.5;

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
     * @dev Converts an `address` into `address payable`. Note that this is
     * simply a type cast: the actual underlying value is not changed.
     *
     * _Available since v2.4.0._
     */
    function toPayable(address account) internal pure returns (address payable) {
        return address(uint160(account));
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
     *
     * _Available since v2.4.0._
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-call-value
        (bool success, ) = recipient.call.value(amount)("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

// File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol

pragma solidity ^0.5.0;




/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves.

        // A Solidity high level call has three parts:
        //  1. The target address is checked to verify it contains contract code
        //  2. The call itself is made, and success asserted
        //  3. The return value is decoded, which in turn checks the size of the returned data.
        // solhint-disable-next-line max-line-length
        require(address(token).isContract(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

// File: contracts/Interfaces/IBadStaticCallERC20.sol

pragma solidity ^0.5.0;

/**
 * @dev Interface to be safe with not so good proxy contracts.
 */
interface IBadStaticCallERC20 {

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external returns (uint256);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external returns (uint256);

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
}

// File: contracts/Utils/SafeStaticCallERC20.sol

pragma solidity ^0.5.0;




library SafeStaticCallERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeApprove(IBadStaticCallERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeProxyERC20: approve from non-zero to non-zero allowance"
        );
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function callOptionalReturn(IBadStaticCallERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves.

        // A Solidity high level call has three parts:
        //  1. The target address is checked to verify it contains contract code
        //  2. The call itself is made, and success asserted
        //  3. The return value is decoded, which in turn checks the size of the returned data.
        // solhint-disable-next-line max-line-length
        require(address(token).isContract(), "SafeProxyERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeProxyERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeProxyERC20: ERC20 operation did not succeed");
        }
    }
}

// File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol

pragma solidity >=0.5.0;

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}

// File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol

pragma solidity >=0.5.0;

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

// File: @uniswap/v2-periphery/contracts/interfaces/IWETH.sol

pragma solidity >=0.5.0;

interface IWETH {
    function deposit() external payable;
    function transfer(address to, uint value) external returns (bool);
    function withdraw(uint) external;
}

// File: contracts/Utils/UniswapV2Library.sol

pragma solidity >=0.5.0;

// reimplemented because the original library imports the local SafeMath that requires solidity 0.6.x



library UniswapV2Library {
    using SafeMath for uint;

    // returns sorted token addresses, used to handle return values from pairs sorted in this order
    function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
        require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
    }

    // calculates the CREATE2 address for a pair without making any external calls
    function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
        (address token0, address token1) = sortTokens(tokenA, tokenB);
        pair = address(uint(keccak256(abi.encodePacked(
                hex'ff',
                factory,
                keccak256(abi.encodePacked(token0, token1)),
                hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
            ))));
    }

    // fetches and sorts the reserves for a pair
    function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
        (address token0,) = sortTokens(tokenA, tokenB);
        (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
        (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
    }

    // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
    function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
        require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
        require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
        amountB = amountA.mul(reserveB) / reserveA;
    }

    // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
        require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
        uint amountInWithFee = amountIn.mul(997);
        uint numerator = amountInWithFee.mul(reserveOut);
        uint denominator = reserveIn.mul(1000).add(amountInWithFee);
        amountOut = numerator / denominator;
    }

    // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
        require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
        uint numerator = reserveIn.mul(amountOut).mul(1000);
        uint denominator = reserveOut.sub(amountOut).mul(997);
        amountIn = (numerator / denominator).add(1);
    }

    // performs chained getAmountOut calculations on any number of pairs
    function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
        require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
        amounts = new uint[](path.length);
        amounts[0] = amountIn;
        for (uint i; i < path.length - 1; i++) {
            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
            amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
        }
    }

    // performs chained getAmountIn calculations on any number of pairs
    function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
        require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
        amounts = new uint[](path.length);
        amounts[amounts.length - 1] = amountOut;
        for (uint i = path.length - 1; i > 0; i--) {
            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
            amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
        }
    }
}

// File: contracts/Interfaces/IUniswapV2Router01.sol

pragma solidity >=0.5.0;

//interface IUniswapV2Factory {
//  event PairCreated(address indexed token0, address indexed token1, address pair, uint);
//
//  function getPair(address tokenA, address tokenB) external view returns (address pair);
//  function allPairs(uint) external view returns (address pair);
//  function allPairsLength() external view returns (uint);
//
//  function feeTo() external view returns (address);
//  function feeToSetter() external view returns (address);
//
//  function createPair(address tokenA, address tokenB) external returns (address pair);
//}
//
//interface IUniswapV2Pair {
//  event Approval(address indexed owner, address indexed spender, uint value);
//  event Transfer(address indexed from, address indexed to, uint value);
//
//  function name() external pure returns (string memory);
//  function symbol() external pure returns (string memory);
//  function decimals() external pure returns (uint8);
//  function totalSupply() external view returns (uint);
//  function balanceOf(address owner) external view returns (uint);
//  function allowance(address owner, address spender) external view returns (uint);
//
//  function approve(address spender, uint value) external returns (bool);
//  function transfer(address to, uint value) external returns (bool);
//  function transferFrom(address from, address to, uint value) external returns (bool);
//
//  function DOMAIN_SEPARATOR() external view returns (bytes32);
//  function PERMIT_TYPEHASH() external pure returns (bytes32);
//  function nonces(address owner) external view returns (uint);
//
//  function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
//
//  event Mint(address indexed sender, uint amount0, uint amount1);
//  event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
//  event Swap(
//    address indexed sender,
//    uint amount0In,
//    uint amount1In,
//    uint amount0Out,
//    uint amount1Out,
//    address indexed to
//  );
//  event Sync(uint112 reserve0, uint112 reserve1);
//
//  function MINIMUM_LIQUIDITY() external pure returns (uint);
//  function factory() external view returns (address);
//  function token0() external view returns (address);
//  function token1() external view returns (address);
//  function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
//  function price0CumulativeLast() external view returns (uint);
//  function price1CumulativeLast() external view returns (uint);
//  function kLast() external view returns (uint);
//
//  function mint(address to) external returns (uint liquidity);
//  function burn(address to) external returns (uint amount0, uint amount1);
//  function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
//  function skim(address to) external;
//  function sync() external;
//}

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

// File: openzeppelin-solidity/contracts/GSN/Context.sol

pragma solidity ^0.5.0;

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
contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File: openzeppelin-solidity/contracts/Ownership/Ownable.sol

pragma solidity ^0.5.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
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
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Returns true if the caller is the current owner.
     */
    function isOwner() public view returns (bool) {
        return _msgSender() == _owner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: contracts/Utils/Destructible.sol

pragma solidity >=0.5.0;


/**
 * @title Destructible
 * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
 */
contract Destructible is Ownable {
  /**
   * @dev Transfers the current balance to the owner and terminates the contract.
   */
  function destroy() public onlyOwner {
    selfdestruct(address(bytes20(owner())));
  }

  function destroyAndSend(address payable _recipient) public onlyOwner {
    selfdestruct(_recipient);
  }
}

// File: contracts/Utils/Pausable.sol

pragma solidity >=0.4.24;


/**
 * @title Pausable
 * @dev Base contract which allows children to implement an emergency stop mechanism.
 */
contract Pausable is Ownable {
  event Pause();
  event Unpause();

  bool public paused = false;


  /**
   * @dev Modifier to make a function callable only when the contract is not paused.
   */
  modifier whenNotPaused() {
    require(!paused, "The contract is paused");
    _;
  }

  /**
   * @dev Modifier to make a function callable only when the contract is paused.
   */
  modifier whenPaused() {
    require(paused, "The contract is not paused");
    _;
  }

  /**
   * @dev called by the owner to pause, triggers stopped state
   */
  function pause() public onlyOwner whenNotPaused {
    paused = true;
    emit Pause();
  }

  /**
   * @dev called by the owner to unpause, returns to normal state
   */
  function unpause() public onlyOwner whenPaused {
    paused = false;
    emit Unpause();
  }
}

// File: contracts/Utils/Withdrawable.sol

pragma solidity >=0.4.24;





contract Withdrawable is Ownable {
  using SafeERC20 for IERC20;
  address constant ETHER = address(0);

  event LogWithdrawToken(
    address indexed _from,
    address indexed _token,
    uint amount
  );

  /**
   * @dev Withdraw asset.
   * @param _tokenAddress Asset to be withdrawed.
   */
  function withdrawAll(address _tokenAddress) public onlyOwner {
    uint tokenBalance;
    if (_tokenAddress == ETHER) {
      address self = address(this); // workaround for a possible solidity bug
      tokenBalance = self.balance;
    } else {
      tokenBalance = IBadStaticCallERC20(_tokenAddress).balanceOf(address(this));
    }
    _withdraw(_tokenAddress, tokenBalance);
  }

  function _withdraw(address _tokenAddress, uint _amount) internal {
    if (_tokenAddress == ETHER) {
      msg.sender.transfer(_amount);
    } else {
      IERC20(_tokenAddress).safeTransfer(msg.sender, _amount);
    }
    emit LogWithdrawToken(msg.sender, _tokenAddress, _amount);
  }

}

// File: contracts/Utils/WithFee.sol

pragma solidity ^0.5.0;





contract WithFee is Ownable {
  using SafeERC20 for IERC20;
  using SafeMath for uint;
  address payable public feeWallet;
  uint public storedSpread;
  uint constant spreadDecimals = 6;
  uint constant spreadUnit = 10 ** spreadDecimals;

  event LogFee(address token, uint amount);

  constructor(address payable _wallet, uint _spread) public {
    require(_wallet != address(0), "_wallet == address(0)");
    require(_spread < spreadUnit, "spread >= spreadUnit");
    feeWallet = _wallet;
    storedSpread = _spread;
  }

  function setFeeWallet(address payable _wallet) external onlyOwner {
    require(_wallet != address(0), "_wallet == address(0)");
    feeWallet = _wallet;
  }

  function setSpread(uint _spread) external onlyOwner {
    storedSpread = _spread;
  }

  function _getFee(uint underlyingTokenTotal) internal view returns(uint) {
    return underlyingTokenTotal.mul(storedSpread).div(spreadUnit);
  }

  function _payFee(address feeToken, uint fee) internal {
    if (fee > 0) {
      if (feeToken == address(0)) {
        feeWallet.transfer(fee);
      } else {
        IERC20(feeToken).safeTransfer(feeWallet, fee);
      }
      emit LogFee(feeToken, fee);
    }
  }

}

// File: contracts/Interfaces/IErc20Swap.sol

pragma solidity >=0.4.0;

interface IErc20Swap {
    function getRate(address src, address dst, uint256 srcAmount) external view returns(uint expectedRate, uint slippageRate);  // real rate = returned value / 1e18
    function swap(address src, uint srcAmount, address dest, uint maxDestAmount, uint minConversionRate) external payable;

    event LogTokenSwap(
        address indexed _userAddress,
        address indexed _userSentTokenAddress,
        uint _userSentTokenAmount,
        address indexed _userReceivedTokenAddress,
        uint _userReceivedTokenAmount
    );
}

// File: contracts/base/NetworkBasedTokenSwap.sol

pragma solidity >=0.5.0;










contract NetworkBasedTokenSwap is Withdrawable, Pausable, Destructible, WithFee, IErc20Swap
{
  using SafeMath for uint;
  using SafeERC20 for IERC20;
  address constant ETHER = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

  mapping (address => mapping (address => uint)) spreadCustom;

  event UnexpectedIntialBalance(address token, uint amount);

  constructor(
    address payable _wallet,
    uint _spread
  )
    public WithFee(_wallet, _spread)
  {}

  function() external payable {
    // can receive ethers
  }

  // spread value >= spreadUnit means no fee
  function setSpread(address tokenA, address tokenB, uint spread) public onlyOwner {
    uint value = spread > spreadUnit ? spreadUnit : spread;
    spreadCustom[tokenA][tokenB] = value;
    spreadCustom[tokenB][tokenA] = value;
  }

  function getSpread(address tokenA, address tokenB) public view returns(uint) {
    uint value = spreadCustom[tokenA][tokenB];
    if (value == 0) return storedSpread;
    if (value >= spreadUnit) return 0;
    else return value;
  }

  // kyber network style rate
  function getNetworkRate(address src, address dest, uint256 srcAmount) internal view returns(uint expectedRate, uint slippageRate);

  function getRate(address src, address dest, uint256 srcAmount) external view
    returns(uint expectedRate, uint slippageRate)
  {
    (uint256 kExpected, uint256 kSplippage) = getNetworkRate(src, dest, srcAmount);
    uint256 spread = getSpread(src, dest);
    expectedRate = kExpected.mul(spreadUnit - spread).div(spreadUnit);
    slippageRate = kSplippage.mul(spreadUnit - spread).div(spreadUnit);
  }

  function _freeUnexpectedTokens(address token) private {
    uint256 unexpectedBalance = token == ETHER
      ? _myEthBalance().sub(msg.value)
      : IBadStaticCallERC20(token).balanceOf(address(this));
    if (unexpectedBalance > 0) {
      _transfer(token, address(bytes20(owner())), unexpectedBalance);
      emit UnexpectedIntialBalance(token, unexpectedBalance);
    }
  }

  function swap(address src, uint srcAmount, address dest, uint maxDestAmount, uint minConversionRate) public payable {
    require(src != dest, "src == dest");
    require(srcAmount > 0, "srcAmount == 0");

    // empty unexpected initial balances
    _freeUnexpectedTokens(src);
    _freeUnexpectedTokens(dest);

    if (src == ETHER) {
      require(msg.value == srcAmount, "msg.value != srcAmount");
    } else {
      require(
        IBadStaticCallERC20(src).allowance(msg.sender, address(this)) >= srcAmount,
        "ERC20 allowance < srcAmount"
      );
      // get user's tokens
      IERC20(src).safeTransferFrom(msg.sender, address(this), srcAmount);
    }

    uint256 spread = getSpread(src, dest);

    // calculate the minConversionRate and maxDestAmount keeping in mind the fee
    uint256 adaptedMinRate = minConversionRate.mul(spreadUnit).div(spreadUnit - spread);
    uint256 adaptedMaxDestAmount = maxDestAmount.mul(spreadUnit).div(spreadUnit - spread);
    uint256 destTradedAmount = doNetworkTrade(src, srcAmount, dest, adaptedMaxDestAmount, adaptedMinRate);

    uint256 notTraded = _myBalance(src);
    uint256 srcTradedAmount = srcAmount.sub(notTraded);
    require(srcTradedAmount > 0, "no traded tokens");
    require(
      _myBalance(dest) >= destTradedAmount,
      "No enough dest tokens after trade"
    );
    // pay fee and user
    uint256 toUserAmount = _payFee(dest, destTradedAmount, spread);
    _transfer(dest, msg.sender, toUserAmount);
    // returns not traded tokens if any
    if (notTraded > 0) {
      _transfer(src, msg.sender, notTraded);
    }

    emit LogTokenSwap(
      msg.sender,
      src,
      srcTradedAmount,
      dest,
      toUserAmount
    );
  }

  function doNetworkTrade(address src, uint srcAmount, address dest, uint maxDestAmount, uint minConversionRate) internal returns(uint256);

  function _payFee(address token, uint destTradedAmount, uint spread) private returns(uint256 toUserAmount) {
    uint256 fee = destTradedAmount.mul(spread).div(spreadUnit);
    toUserAmount = destTradedAmount.sub(fee);
    // pay fee
    super._payFee(token == ETHER ? address(0) : token, fee);
  }

  // workaround for a solidity bug
  function _myEthBalance() private view returns(uint256) {
    address self = address(this);
    return self.balance;
  }

  function _myBalance(address token) private returns(uint256) {
    return token == ETHER
      ? _myEthBalance()
      : IBadStaticCallERC20(token).balanceOf(address(this));
  }

  function _transfer(address token, address payable recipient, uint256 amount) private {
    if (token == ETHER) {
      recipient.transfer(amount);
    } else {
      IERC20(token).safeTransfer(recipient, amount);
    }
  }

}

// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol

pragma solidity ^0.5.0;


/**
 * @dev Optional functions from the ERC20 standard.
 */
contract ERC20Detailed is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    /**
     * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
     * these values are immutable: they can only be set once during
     * construction.
     */
    constructor (string memory name, string memory symbol, uint8 decimals) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view returns (uint8) {
        return _decimals;
    }
}

// File: contracts/Utils/LowLevel.sol

pragma solidity ^0.5.0;

library LowLevel {
  function staticCallContractAddr(address target, bytes memory payload) internal view
    returns (bool success_, address result_)
  {
    (bool success, bytes memory result) = address(target).staticcall(payload);
    if (success && result.length == 32) {
      return (true, abi.decode(result, (address)));
    }
    return (false, address(0));
  }

  function callContractAddr(address target, bytes memory payload) internal
    returns (bool success_, address result_)
  {
    (bool success, bytes memory result) = address(target).call(payload);
    if (success && result.length == 32) {
      return (true, abi.decode(result, (address)));
    }
    return (false, address(0));
  }

  function staticCallContractUint(address target, bytes memory payload) internal view
    returns (bool success_, uint result_)
  {
    (bool success, bytes memory result) = address(target).staticcall(payload);
    if (success && result.length == 32) {
      return (true, abi.decode(result, (uint)));
    }
    return (false, 0);
  }

  function callContractUint(address target, bytes memory payload) internal
    returns (bool success_, uint result_)
  {
    (bool success, bytes memory result) = address(target).call(payload);
    if (success && result.length == 32) {
      return (true, abi.decode(result, (uint)));
    }
    return (false, 0);
  }
}

// File: contracts/Utils/RateNormalization.sol

pragma solidity ^0.5.0;





contract RateNormalization is Ownable {
  using SafeMath for uint;

  struct RateAdjustment {
    uint factor;
    bool multiply;
  }

  mapping (address => mapping(address => RateAdjustment)) public rateAdjustment;
  mapping (address => uint) public forcedDecimals;

  function _getAdjustment(address src, address dest) private view returns(RateAdjustment memory) {
    RateAdjustment memory adj = rateAdjustment[src][dest];
    if (adj.factor == 0) {
      uint srcDecimals = _getDecimals(src);
      uint destDecimals = _getDecimals(dest);
      if (srcDecimals != destDecimals) {
        if (srcDecimals > destDecimals) {
          adj.multiply = true;
          adj.factor = 10 ** (srcDecimals - destDecimals);
        } else {
          adj.multiply = false;
          adj.factor = 10 ** (destDecimals - srcDecimals);
        }
      }
    }
    return adj;
  }

  // return normalized rate
  function normalizeRate(address src, address dest, uint256 rate) public view
    returns(uint)
  {
    RateAdjustment memory adj = _getAdjustment(src, dest);
    if (adj.factor > 1) {
      rate = adj.multiply
        ? rate.mul(adj.factor)
        : rate.div(adj.factor);
    }
    return rate;
  }

  function denormalizeRate(address src, address dest, uint256 rate) public view
    returns(uint)
  {
    RateAdjustment memory adj = _getAdjustment(src, dest);
    if (adj.factor > 1) {
      rate = adj.multiply  // invert multiply/divide for denormalization
        ? rate.div(adj.factor)
        : rate.mul(adj.factor);
    }
    return rate;
  }

  function denormalizeRate(address src, address dest, uint256 rate, uint256 slippage) public view
    returns(uint, uint)
  {
    RateAdjustment memory adj = _getAdjustment(src, dest);
    if (adj.factor > 1) {
      if (adj.multiply) {
        rate = rate.div(adj.factor);
        slippage = slippage.div(adj.factor);
      } else {
        rate = rate.mul(adj.factor);
        slippage = slippage.mul(adj.factor);
      }
    }
    return (rate, slippage);
  }

  function _getDecimals(address token) internal view returns(uint) {
    uint forced = forcedDecimals[token];
    if (forced > 0) return forced;
    bytes memory payload = abi.encodeWithSignature("decimals()");
    (bool success, uint decimals) = LowLevel.staticCallContractUint(token, payload);
    require(success, "the token doesn't expose the decimals number");
    return decimals;
  }

  function setRateAdjustmentFactor(address src, address dest, uint factor, bool multiply) public onlyOwner {
    rateAdjustment[src][dest] = RateAdjustment(factor, multiply);
    rateAdjustment[dest][src] = RateAdjustment(factor, !multiply);
  }

  function setForcedDecimals(address token, uint decimals) public onlyOwner {
    forcedDecimals[token] = decimals;
  }

}

// File: contracts/UniswapV2TokenSwap.sol

pragma solidity >=0.5.0;













contract UniswapV2TokenSwap is RateNormalization, NetworkBasedTokenSwap
{
  using SafeMath for uint;
  using SafeERC20 for IERC20;
  using SafeStaticCallERC20 for IBadStaticCallERC20;
  uint constant expScale = 1e18;

  IUniswapV2Factory public uniswapFactory;
  IUniswapV2Router01 public router;

  constructor(
    address payable _wallet,
    uint _spread
  )
    public NetworkBasedTokenSwap(_wallet, _spread)
  {
    setForcedDecimals(ETHER, 18);
    // the router address is deterministic and it is the same in all networks
    setUniswap(0xf164fC0Ec4E93095b804a4795bBe1e041497b92a);
  }

  function setUniswap(address _uniswapRouter) public onlyOwner {
    require(_uniswapRouter != address(0), "_uniswapRouter == address(0)");
    router = IUniswapV2Router01(_uniswapRouter);
    uniswapFactory = IUniswapV2Factory(router.factory());
  }

  function _getUniswapRate(address[] memory path, uint srcAmount) private view returns(uint rate, uint destAmount) {
    uint[] memory amounts = UniswapV2Library.getAmountsOut(address(uniswapFactory), srcAmount, path);
    destAmount = amounts[amounts.length - 1];
//    rate = destAmount.mul(expScale).div(srcAmount);
    rate = _calcRate(srcAmount, destAmount);
  }

  function _getPath(address srcToken, address destToken) internal view returns(address[] memory res) {
    address WETH = router.WETH();
    address from = srcToken == ETHER ? WETH : srcToken;
    address to = destToken == ETHER ? WETH : destToken;
    if (uniswapFactory.getPair(from, to) != address(0)) {
      res = new address[](2);
      res[0] = from;
      res[1] = to;
    } else if (
      uniswapFactory.getPair(from, WETH) != address(0) &&
      uniswapFactory.getPair(WETH, to) != address(0)
    ) {
      res = new address[](3);
      res[0] = from;
      res[1] = WETH;
      res[2] = to;
    } else {
      res = new address[](0);
    }
  }

  function _calcRate(uint srcAmount, uint destAmount) private pure returns(uint) {
    return destAmount.mul(expScale).div(srcAmount);
  }

  function getNetworkRate(address src, address dest, uint256 srcAmount) internal view
    returns(uint expectedRate, uint slippageRate)
  {
    address[] memory path = _getPath(src, dest);
    (uint rate, ) = _getUniswapRate(path, srcAmount);
    uint normalizedRate = normalizeRate(src, dest, rate);
    return (normalizedRate, normalizedRate);
  }

  function _approveWithReset(address token, address spender, uint amount) private {
    if (IBadStaticCallERC20(token).allowance(address(this), spender) > 0) {
      IBadStaticCallERC20(token).safeApprove(spender, 0);
    }
    IBadStaticCallERC20(token).safeApprove(spender, amount);
  }

  function doNetworkTrade(address src, uint srcAmount, address dest, uint maxDestAmount, uint minConversionRate)
    internal returns(uint256)
  {
    address[] memory path = _getPath(src, dest);
    (uint rate, uint destAmount) = _getUniswapRate(path, srcAmount);
    uint toTradeAmount = destAmount > maxDestAmount
      ? maxDestAmount.mul(expScale).div(rate)
      : srcAmount;

    // convert source ethers to WETHs
    if (src == ETHER) {
      IWETH(router.WETH()).deposit.value(toTradeAmount)();
    }

    _approveWithReset(path[0], address(router), toTradeAmount);
    uint[] memory amounts = router.swapExactTokensForTokens(toTradeAmount, 0, path, address(this), now);
    require(amounts.length > 0, 'amounts.length == 0');
    uint finalDestAmount = amounts[amounts.length - 1];

    // convert WETHs to ethers
    if (dest == ETHER) {
      IWETH(router.WETH()).withdraw(finalDestAmount);
    }

    require(normalizeRate(src, dest, _calcRate(toTradeAmount, finalDestAmount)) >= minConversionRate, "cannot satisfy minConversionRate");
    return finalDestAmount;
  }

}

// File: contracts/UniswapV2DoubleHop.sol

pragma solidity >=0.5.0;







contract UniswapV2DoubleHop is UniswapV2TokenSwap
{
  using SafeMath for uint;
  using SafeERC20 for IERC20;
  using SafeStaticCallERC20 for IBadStaticCallERC20;
  uint constant expScale = 1e18;

  address public middleToken;

  constructor(
    address _middleToken,
    address payable _wallet,
    uint _spread
  )
    public UniswapV2TokenSwap(_wallet, _spread)
  {
    middleToken = _middleToken;
  }

  function setMiddleToken(address _middleToken) public onlyOwner {
    middleToken = _middleToken;
  }

  function _getPath(address srcToken, address destToken) internal view returns(address[] memory res) {
    address WETH = router.WETH();
    address from = srcToken == ETHER ? WETH : srcToken;
    address to = destToken == ETHER ? WETH : destToken;

    if (uniswapFactory.getPair(from, middleToken) != address(0) &&
        uniswapFactory.getPair(middleToken, to) != address(0)
    ) {
      res = new address[](3);
      res[0] = from;
      res[1] = middleToken;
      res[2] = to;
    } else {
      res = new address[](0);
    }
  }

}