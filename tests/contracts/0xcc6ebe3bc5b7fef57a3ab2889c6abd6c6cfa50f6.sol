pragma solidity 0.5.12;
pragma experimental ABIEncoderV2;


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

    function _msgSender() internal view returns (address _payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

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

interface PoolInterface {
    function swapExactAmountIn(address, address, uint, address, uint, uint) external returns (uint, uint);
    function swapExactAmountOut(address, address, uint, address, uint, uint) external returns (uint, uint);
    function calcInGivenOut(uint, uint, uint, uint, uint, uint) external pure returns (uint);
    function calcOutGivenIn(uint, uint, uint, uint, uint, uint) external pure returns (uint);
    function getDenormalizedWeight(address) external view returns (uint);
    function getBalance(address) external view returns (uint);
    function getSwapFee() external view returns (uint);
}

interface TokenInterface {
    function balanceOf(address) external view returns (uint);
    function allowance(address, address) external view returns (uint);
    function approve(address, uint) external returns (bool);
    function transfer(address, uint) external returns (bool);
    function transferFrom(address, address, uint) external returns (bool);
    function deposit() external payable;
    function withdraw(uint) external;
}

interface RegistryInterface {
    function getBestPoolsWithLimit(address, address, uint) external view returns (address[] memory);
}

contract ExchangeProxy is Ownable {

    using SafeMath for uint256;

    struct Pool {
        address pool;
        uint    tokenBalanceIn;
        uint    tokenWeightIn;
        uint    tokenBalanceOut;
        uint    tokenWeightOut;
        uint    swapFee;
        uint    effectiveLiquidity;
    }

    struct Swap {
        address pool;
        address tokenIn;
        address tokenOut;
        uint    swapAmount; // tokenInAmount / tokenOutAmount
        uint    limitReturnAmount; // minAmountOut / maxAmountIn
        uint    maxPrice;
    }

    TokenInterface weth;
    RegistryInterface registry;
    address private constant ETH_ADDRESS = address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
    uint private constant BONE = 10**18;

    constructor(address _weth) public {
        weth = TokenInterface(_weth);
    }

    function setRegistry(address _registry) external onlyOwner {
        registry = RegistryInterface(_registry);
    }

    function batchSwapExactIn(
        Swap[] memory swaps,
        TokenInterface tokenIn,
        TokenInterface tokenOut,
        uint totalAmountIn,
        uint minTotalAmountOut
    )
    public payable
    returns (uint totalAmountOut)
    {
        transferFromAll(tokenIn, totalAmountIn);

        for (uint i = 0; i < swaps.length; i++) {
            Swap memory swap = swaps[i];
            TokenInterface SwapTokenIn = TokenInterface(swap.tokenIn);
            PoolInterface pool = PoolInterface(swap.pool);

            if (SwapTokenIn.allowance(address(this), swap.pool) > 0) {
                safeApprove(SwapTokenIn, swap.pool, 0);
            }
            safeApprove(SwapTokenIn, swap.pool, swap.swapAmount);

            (uint tokenAmountOut,) = pool.swapExactAmountIn(
                msg.sender,
                swap.tokenIn,
                swap.swapAmount,
                swap.tokenOut,
                swap.limitReturnAmount,
                swap.maxPrice
            );
            totalAmountOut = tokenAmountOut.add(totalAmountOut);
        }

        require(totalAmountOut >= minTotalAmountOut, "ERR_LIMIT_OUT");

        transferAll(tokenOut, totalAmountOut);
        transferAll(tokenIn, getBalance(tokenIn));
    }

    function batchSwapExactOut(
        Swap[] memory swaps,
        TokenInterface tokenIn,
        TokenInterface tokenOut,
        uint maxTotalAmountIn
    )
    public payable
    returns (uint totalAmountIn)
    {
        transferFromAll(tokenIn, maxTotalAmountIn);

        for (uint i = 0; i < swaps.length; i++) {
            Swap memory swap = swaps[i];
            TokenInterface SwapTokenIn = TokenInterface(swap.tokenIn);
            PoolInterface pool = PoolInterface(swap.pool);

            if (SwapTokenIn.allowance(address(this), swap.pool) > 0) {
                safeApprove(SwapTokenIn, swap.pool, 0);
            }
            safeApprove(SwapTokenIn, swap.pool, swap.limitReturnAmount);

            (uint tokenAmountIn,) = pool.swapExactAmountOut(
                msg.sender,
                swap.tokenIn,
                swap.limitReturnAmount,
                swap.tokenOut,
                swap.swapAmount,
                swap.maxPrice
            );
            totalAmountIn = tokenAmountIn.add(totalAmountIn);
        }
        require(totalAmountIn <= maxTotalAmountIn, "ERR_LIMIT_IN");

        transferAll(tokenOut, getBalance(tokenOut));
        transferAll(tokenIn, getBalance(tokenIn));

    }

    function multihopBatchSwapExactIn(
        Swap[][] memory swapSequences,
        TokenInterface tokenIn,
        TokenInterface tokenOut,
        uint totalAmountIn,
        uint minTotalAmountOut
    )
    public payable
    returns (uint totalAmountOut)
    {

        transferFromAll(tokenIn, totalAmountIn);

        for (uint i = 0; i < swapSequences.length; i++) {
            uint tokenAmountOut;
            for (uint k = 0; k < swapSequences[i].length; k++) {
                Swap memory swap = swapSequences[i][k];
                TokenInterface SwapTokenIn = TokenInterface(swap.tokenIn);
                if (k == 1) {
                    // Makes sure that on the second swap the output of the first was used
                    // so there is not intermediate token leftover
                    swap.swapAmount = tokenAmountOut;
                }

                PoolInterface pool = PoolInterface(swap.pool);
                if (SwapTokenIn.allowance(address(this), swap.pool) > 0) {
                    safeApprove(SwapTokenIn, swap.pool, 0);
                }
                safeApprove(SwapTokenIn, swap.pool, swap.swapAmount);

                (tokenAmountOut,) = pool.swapExactAmountIn(
                    msg.sender,
                    swap.tokenIn,
                    swap.swapAmount,
                    swap.tokenOut,
                    swap.limitReturnAmount,
                    swap.maxPrice
                );
            }
            // This takes the amountOut of the last swap
            totalAmountOut = tokenAmountOut.add(totalAmountOut);
        }

        require(totalAmountOut >= minTotalAmountOut, "ERR_LIMIT_OUT");

        transferAll(tokenOut, totalAmountOut);
        transferAll(tokenIn, getBalance(tokenIn));

    }

    function multihopBatchSwapExactOut(
        Swap[][] memory swapSequences,
        TokenInterface tokenIn,
        TokenInterface tokenOut,
        uint maxTotalAmountIn
    )
    public payable
    returns (uint totalAmountIn)
    {

        transferFromAll(tokenIn, maxTotalAmountIn);

        for (uint i = 0; i < swapSequences.length; i++) {
            uint tokenAmountInFirstSwap;
            // Specific code for a simple swap and a multihop (2 swaps in sequence)
            if (swapSequences[i].length == 1) {
                Swap memory swap = swapSequences[i][0];
                TokenInterface SwapTokenIn = TokenInterface(swap.tokenIn);

                PoolInterface pool = PoolInterface(swap.pool);
                if (SwapTokenIn.allowance(address(this), swap.pool) > 0) {
                    safeApprove(SwapTokenIn, swap.pool, 0);
                }
                safeApprove(SwapTokenIn, swap.pool, swap.limitReturnAmount);

                (tokenAmountInFirstSwap,) = pool.swapExactAmountOut(
                    msg.sender,
                    swap.tokenIn,
                    swap.limitReturnAmount,
                    swap.tokenOut,
                    swap.swapAmount,
                    swap.maxPrice
                );
            } else {
                // Consider we are swapping A -> B and B -> C. The goal is to buy a given amount
                // of token C. But first we need to buy B with A so we can then buy C with B
                // To get the exact amount of C we then first need to calculate how much B we'll need:
                uint intermediateTokenAmount; // This would be token B as described above
                Swap memory secondSwap = swapSequences[i][1];
                PoolInterface poolSecondSwap = PoolInterface(secondSwap.pool);
                intermediateTokenAmount = poolSecondSwap.calcInGivenOut(
                    poolSecondSwap.getBalance(secondSwap.tokenIn),
                    poolSecondSwap.getDenormalizedWeight(secondSwap.tokenIn),
                    poolSecondSwap.getBalance(secondSwap.tokenOut),
                    poolSecondSwap.getDenormalizedWeight(secondSwap.tokenOut),
                    secondSwap.swapAmount,
                    poolSecondSwap.getSwapFee()
                );

                //// Buy intermediateTokenAmount of token B with A in the first pool
                Swap memory firstSwap = swapSequences[i][0];
                TokenInterface FirstSwapTokenIn = TokenInterface(firstSwap.tokenIn);
                PoolInterface poolFirstSwap = PoolInterface(firstSwap.pool);
                if (FirstSwapTokenIn.allowance(address(this), firstSwap.pool) < uint(-1)) {
                    safeApprove(FirstSwapTokenIn, firstSwap.pool, uint(-1));
                }

                (tokenAmountInFirstSwap,) = poolFirstSwap.swapExactAmountOut(
                    msg.sender,
                    firstSwap.tokenIn,
                    firstSwap.limitReturnAmount,
                    firstSwap.tokenOut,
                    intermediateTokenAmount, // This is the amount of token B we need
                    firstSwap.maxPrice
                );

                //// Buy the final amount of token C desired
                TokenInterface SecondSwapTokenIn = TokenInterface(secondSwap.tokenIn);
                if (SecondSwapTokenIn.allowance(address(this), secondSwap.pool) < uint(-1)) {
                    safeApprove(SecondSwapTokenIn, secondSwap.pool, uint(-1));
                }

                poolSecondSwap.swapExactAmountOut(
                    msg.sender,
                    secondSwap.tokenIn,
                    secondSwap.limitReturnAmount,
                    secondSwap.tokenOut,
                    secondSwap.swapAmount,
                    secondSwap.maxPrice
                );
            }
            totalAmountIn = tokenAmountInFirstSwap.add(totalAmountIn);
        }

        require(totalAmountIn <= maxTotalAmountIn, "ERR_LIMIT_IN");

        transferAll(tokenOut, getBalance(tokenOut));
        transferAll(tokenIn, getBalance(tokenIn));

    }


    function transferFromAll(TokenInterface token, uint amount) internal returns(bool) {
        if (isETH(token)) {
            weth.deposit.value(msg.value)();
        } else {
//            require(token.transferFrom(msg.sender, address(this), amount), "ERR_TRANSFER_FAILED");
            safeTransferFrom(token, msg.sender, address(this), amount);
        }
    }

    function getBalance(TokenInterface token) internal view returns (uint) {
        if (isETH(token)) {
            return weth.balanceOf(address(this));
        } else {
            return token.balanceOf(address(this));
        }
    }

    function transferAll(TokenInterface token, uint amount) internal returns(bool) {
        if (amount == 0) {
            return true;
        }

        if (isETH(token)) {
            weth.withdraw(amount);
            (bool xfer,) = msg.sender.call.value(amount)("");
            require(xfer, "ERR_ETH_FAILED");
        } else {
//            require(token.transfer(msg.sender, amount), "ERR_TRANSFER_FAILED");
            safeTransfer(token, msg.sender, amount);
        }
    }

    function isETH(TokenInterface token) internal pure returns(bool) {
        return (address(token) == ETH_ADDRESS);
    }

    function safeTransfer(TokenInterface token, address to , uint256 amount) internal {
        bytes memory data = abi.encodeWithSelector(token.transfer.selector, to, amount);
        bytes memory returndata = functionCall(address(token), data, "low-level call failed");
        if (returndata.length > 0) {
            require(abi.decode(returndata, (bool)), "not succeed");
        }
    }

    function safeTransferFrom(TokenInterface token, address from, address to , uint256 amount) internal {
        bytes memory data = abi.encodeWithSelector(token.transferFrom.selector, from, to, amount);
        bytes memory returndata = functionCall(address(token), data, "low-level call failed");
        if (returndata.length > 0) {
            require(abi.decode(returndata, (bool)), "not succeed");
        }
    }

    function safeApprove(TokenInterface token, address to , uint256 amount) internal {
        bytes memory data = abi.encodeWithSelector(token.approve.selector, to, amount);
        bytes memory returndata = functionCall(address(token), data, "low-level call failed");
        if (returndata.length > 0) {
            require(abi.decode(returndata, (bool)), "not succeed");
        }
    }

    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        (bool success, bytes memory returndata) = target.call(data);// value: weiValue }(data);
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

    function() external payable {}
}