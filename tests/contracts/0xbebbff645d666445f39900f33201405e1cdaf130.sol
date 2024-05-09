// File: openzeppelin-solidity-2.3.0/contracts/ownership/Ownable.sol

pragma solidity ^0.5.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be aplied to your functions to restrict their use to
 * the owner.
 */
contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
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
        return msg.sender == _owner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * > Note: Renouncing ownership will leave the contract without an owner,
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

// File: openzeppelin-solidity-2.3.0/contracts/token/ERC20/IERC20.sol

pragma solidity ^0.5.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see `ERC20Detailed`.
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
     * Emits a `Transfer` event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through `transferFrom`. This is
     * zero by default.
     *
     * This value changes when `approve` or `transferFrom` are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * > Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an `Approval` event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a `Transfer` event.
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
     * a call to `approve`. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: @uniswap/v2-core/contracts/libraries/Math.sol

pragma solidity =0.5.16;

// a library for performing various math operations

library Math {
    function min(uint x, uint y) internal pure returns (uint z) {
        z = x < y ? x : y;
    }

    // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
    function sqrt(uint y) internal pure returns (uint z) {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }
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

// File: openzeppelin-solidity-2.3.0/contracts/math/SafeMath.sol

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
        require(b <= a, "SafeMath: subtraction overflow");
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
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
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
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");
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
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}


// File: contracts/5/uniswap/IUniswapV2Router02.sol

pragma solidity >=0.5.0;

interface IUniswapV2Router02 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountETH);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

// File: contracts/5/interfaces/IBank.sol

pragma solidity 0.5.16;

interface IBank {       

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
     * Emits a `Transfer` event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through `transferFrom`. This is
     * zero by default.
     *
     * This value changes when `approve` or `transferFrom` are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * > Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an `Approval` event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a `Transfer` event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /// @dev Return the total ETH entitled to the token holders. Be careful of unaccrued interests.
    function totalETH() external view returns (uint256);

    /// @dev Add more ETH to the bank. Hope to get some good returns.
    function deposit() external payable;

    /// @dev Withdraw ETH from the bank by burning the share tokens.
    function withdraw(uint256 share) external;

}

// File: contracts/5/IbETHRouter.sol

pragma solidity =0.5.16;







// helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
library TransferHelper {
    function safeApprove(
        address token,
        address to,
        uint256 value
    ) internal {
        // bytes4(keccak256(bytes('approve(address,uint256)')));
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSelector(0x095ea7b3, to, value)
        );
        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            "TransferHelper: APPROVE_FAILED"
        );
    }

    function safeTransfer(
        address token,
        address to,
        uint256 value
    ) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSelector(0xa9059cbb, to, value)
        );
        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            "TransferHelper: TRANSFER_FAILED"
        );
    }

    function safeTransferFrom(
        address token,
        address from,
        address to,
        uint256 value
    ) internal {
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSelector(0x23b872dd, from, to, value)
        );
        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            "TransferHelper: TRANSFER_FROM_FAILED"
        );
    }

    function safeTransferETH(address to, uint256 value) internal {
        (bool success, ) = to.call.value(value)(new bytes(0));
        require(success, "TransferHelper: ETH_TRANSFER_FAILED");
    }
}

contract IbETHRouter is Ownable {
    using SafeMath for uint256;

    address public router;
    address public ibETH; 
    address public alpha;     
    address public lpToken;     

    constructor(address _router, address _ibETH, address _alpha) public {
        router = _router;
        ibETH = _ibETH;   
        alpha = _alpha;                             
        address factory = IUniswapV2Router02(router).factory();   
        lpToken = IUniswapV2Factory(factory).getPair(ibETH, alpha);                  
        IUniswapV2Pair(lpToken).approve(router, uint256(-1)); // 100% trust in the router        
        IBank(ibETH).approve(router, uint256(-1)); // 100% trust in the router        
        IERC20(alpha).approve(router, uint256(-1)); // 100% trust in the router        
    }

    function() external payable {
        assert(msg.sender == ibETH); // only accept ETH via fallback from the Bank contract
    }

    // **** ETH-ibETH FUNCTIONS ****
    // Get number of ibETH needed to withdraw to get exact amountETH from the Bank
    function ibETHForExactETH(uint256 amountETH) public view returns (uint256) {
        uint256 totalETH = IBank(ibETH).totalETH();        
        return totalETH == 0 ? amountETH : amountETH.mul(IBank(ibETH).totalSupply()).add(totalETH).sub(1).div(totalETH); 
    }   
    
    // Add ETH and Alpha from ibETH-Alpha Pool.
    // 1. Receive ETH and Alpha from caller.
    // 2. Wrap ETH to ibETH.
    // 3. Provide liquidity to the pool.
    function addLiquidityETH(        
        uint256 amountAlphaDesired,
        uint256 amountAlphaMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable        
        returns (
            uint256 amountAlpha,
            uint256 amountETH,
            uint256 liquidity
        ) {                
        TransferHelper.safeTransferFrom(alpha, msg.sender, address(this), amountAlphaDesired);
        IBank(ibETH).deposit.value(msg.value)();   
        uint256 amountIbETHDesired = IBank(ibETH).balanceOf(address(this)); 
        uint256 amountIbETH;
        (amountAlpha, amountIbETH, liquidity) = IUniswapV2Router02(router).addLiquidity(
            alpha,
            ibETH,
            amountAlphaDesired,            
            amountIbETHDesired,
            amountAlphaMin,            
            0,
            to,
            deadline
        );         
        if (amountAlphaDesired > amountAlpha) {
            TransferHelper.safeTransfer(alpha, msg.sender, amountAlphaDesired.sub(amountAlpha));
        }                       
        IBank(ibETH).withdraw(amountIbETHDesired.sub(amountIbETH));        
        amountETH = msg.value - address(this).balance;
        if (amountETH > 0) {
            TransferHelper.safeTransferETH(msg.sender, address(this).balance);
        }
        require(amountETH >= amountETHMin, "IbETHRouter: require more ETH than amountETHmin");
    }

    /// @dev Compute optimal deposit amount
    /// @param amtA amount of token A desired to deposit
    /// @param amtB amonut of token B desired to deposit
    /// @param resA amount of token A in reserve
    /// @param resB amount of token B in reserve
    /// (forked from ./StrategyAddTwoSidesOptimal.sol)
    function optimalDeposit(
        uint256 amtA,
        uint256 amtB,
        uint256 resA,
        uint256 resB
    ) internal pure returns (uint256 swapAmt, bool isReversed) {
        if (amtA.mul(resB) >= amtB.mul(resA)) {
            swapAmt = _optimalDepositA(amtA, amtB, resA, resB);
            isReversed = false;
        } else {
            swapAmt = _optimalDepositA(amtB, amtA, resB, resA);
            isReversed = true;
        }
    }

    /// @dev Compute optimal deposit amount helper
    /// @param amtA amount of token A desired to deposit
    /// @param amtB amonut of token B desired to deposit
    /// @param resA amount of token A in reserve
    /// @param resB amount of token B in reserve
    /// (forked from ./StrategyAddTwoSidesOptimal.sol)
    function _optimalDepositA(
        uint256 amtA,
        uint256 amtB,
        uint256 resA,
        uint256 resB
    ) internal pure returns (uint256) {
        require(amtA.mul(resB) >= amtB.mul(resA), "Reversed");

        uint256 a = 997;
        uint256 b = uint256(1997).mul(resA);
        uint256 _c = (amtA.mul(resB)).sub(amtB.mul(resA));
        uint256 c = _c.mul(1000).div(amtB.add(resB)).mul(resA);

        uint256 d = a.mul(c).mul(4);
        uint256 e = Math.sqrt(b.mul(b).add(d));

        uint256 numerator = e.sub(b);
        uint256 denominator = a.mul(2);

        return numerator.div(denominator);
    }

    // Add ibETH and Alpha to ibETH-Alpha Pool.
    // All ibETH and Alpha supplied are optimally swap and add too ibETH-Alpha Pool.
    function addLiquidityTwoSidesOptimal(        
        uint256 amountIbETHDesired,        
        uint256 amountAlphaDesired,        
        uint256 amountLPMin,
        address to,
        uint256 deadline
    )
        external        
        returns (            
            uint256 liquidity
        ) {        
        if (amountIbETHDesired > 0) {
            TransferHelper.safeTransferFrom(ibETH, msg.sender, address(this), amountIbETHDesired);    
        }
        if (amountAlphaDesired > 0) {
            TransferHelper.safeTransferFrom(alpha, msg.sender, address(this), amountAlphaDesired);    
        }        
        uint256 swapAmt;
        bool isReversed;
        {
            (uint256 r0, uint256 r1, ) = IUniswapV2Pair(lpToken).getReserves();
            (uint256 ibETHReserve, uint256 alphaReserve) = IUniswapV2Pair(lpToken).token0() == ibETH ? (r0, r1) : (r1, r0);
            (swapAmt, isReversed) = optimalDeposit(amountIbETHDesired, amountAlphaDesired, ibETHReserve, alphaReserve);
        }
        address[] memory path = new address[](2);
        (path[0], path[1]) = isReversed ? (alpha, ibETH) : (ibETH, alpha);        
        IUniswapV2Router02(router).swapExactTokensForTokens(swapAmt, 0, path, address(this), now);                
        (,, liquidity) = IUniswapV2Router02(router).addLiquidity(
            alpha,
            ibETH,
            IERC20(alpha).balanceOf(address(this)),            
            IBank(ibETH).balanceOf(address(this)),
            0,            
            0,
            to,
            deadline
        );        
        uint256 dustAlpha = IERC20(alpha).balanceOf(address(this));
        uint256 dustIbETH = IBank(ibETH).balanceOf(address(this));
        if (dustAlpha > 0) {
            TransferHelper.safeTransfer(alpha, msg.sender, dustAlpha);
        }    
        if (dustIbETH > 0) {
            TransferHelper.safeTransfer(ibETH, msg.sender, dustIbETH);
        }                    
        require(liquidity >= amountLPMin, "IbETHRouter: receive less lpToken than amountLPMin");
    }

    // Add ETH and Alpha to ibETH-Alpha Pool.
    // All ETH and Alpha supplied are optimally swap and add too ibETH-Alpha Pool.
    function addLiquidityTwoSidesOptimalETH(                
        uint256 amountAlphaDesired,        
        uint256 amountLPMin,
        address to,
        uint256 deadline
    )
        external
        payable        
        returns (            
            uint256 liquidity
        ) {                
        if (amountAlphaDesired > 0) {
            TransferHelper.safeTransferFrom(alpha, msg.sender, address(this), amountAlphaDesired);    
        }       
        IBank(ibETH).deposit.value(msg.value)();   
        uint256 amountIbETHDesired = IBank(ibETH).balanceOf(address(this));                  
        uint256 swapAmt;
        bool isReversed;
        {
            (uint256 r0, uint256 r1, ) = IUniswapV2Pair(lpToken).getReserves();
            (uint256 ibETHReserve, uint256 alphaReserve) = IUniswapV2Pair(lpToken).token0() == ibETH ? (r0, r1) : (r1, r0);
            (swapAmt, isReversed) = optimalDeposit(amountIbETHDesired, amountAlphaDesired, ibETHReserve, alphaReserve);
        }        
        address[] memory path = new address[](2);
        (path[0], path[1]) = isReversed ? (alpha, ibETH) : (ibETH, alpha);        
        IUniswapV2Router02(router).swapExactTokensForTokens(swapAmt, 0, path, address(this), now);                
        (,, liquidity) = IUniswapV2Router02(router).addLiquidity(
            alpha,
            ibETH,
            IERC20(alpha).balanceOf(address(this)),            
            IBank(ibETH).balanceOf(address(this)),
            0,            
            0,
            to,
            deadline
        );        
        uint256 dustAlpha = IERC20(alpha).balanceOf(address(this));
        uint256 dustIbETH = IBank(ibETH).balanceOf(address(this));
        if (dustAlpha > 0) {
            TransferHelper.safeTransfer(alpha, msg.sender, dustAlpha);
        }    
        if (dustIbETH > 0) {
            TransferHelper.safeTransfer(ibETH, msg.sender, dustIbETH);
        }                    
        require(liquidity >= amountLPMin, "IbETHRouter: receive less lpToken than amountLPMin");
    }
      
    // Remove ETH and Alpha from ibETH-Alpha Pool.
    // 1. Remove ibETH and Alpha from the pool.
    // 2. Unwrap ibETH to ETH.
    // 3. Return ETH and Alpha to caller.
    function removeLiquidityETH(        
        uint256 liquidity,
        uint256 amountAlphaMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) public returns (uint256 amountAlpha, uint256 amountETH) {                  
        TransferHelper.safeTransferFrom(lpToken, msg.sender, address(this), liquidity);          
        uint256 amountIbETH;
        (amountAlpha, amountIbETH) = IUniswapV2Router02(router).removeLiquidity(
            alpha,
            ibETH,
            liquidity,
            amountAlphaMin,
            0,
            address(this),
            deadline
        );                        
        TransferHelper.safeTransfer(alpha, to, amountAlpha); 
        IBank(ibETH).withdraw(amountIbETH);        
        amountETH = address(this).balance;
        if (amountETH > 0) {
            TransferHelper.safeTransferETH(msg.sender, address(this).balance);
        }
        require(amountETH >= amountETHMin, "IbETHRouter: receive less ETH than amountETHmin");                               
    }

    // Remove liquidity from ibETH-Alpha Pool and convert all ibETH to Alpha 
    // 1. Remove ibETH and Alpha from the pool.
    // 2. Swap ibETH for Alpha.
    // 3. Return Alpha to caller.   
    function removeLiquidityAllAlpha(        
        uint256 liquidity,
        uint256 amountAlphaMin,        
        address to,
        uint256 deadline
    ) public returns (uint256 amountAlpha) {                  
        TransferHelper.safeTransferFrom(lpToken, msg.sender, address(this), liquidity);          
        (uint256 removeAmountAlpha, uint256 removeAmountIbETH) = IUniswapV2Router02(router).removeLiquidity(
            alpha,
            ibETH,
            liquidity,
            0,
            0,
            address(this),
            deadline
        );        
        address[] memory path = new address[](2);
        path[0] = ibETH;
        path[1] = alpha;
        uint256[] memory amounts = IUniswapV2Router02(router).swapExactTokensForTokens(removeAmountIbETH, 0, path, to, deadline);               
        TransferHelper.safeTransfer(alpha, to, removeAmountAlpha);                        
        amountAlpha = removeAmountAlpha.add(amounts[1]);
        require(amountAlpha >= amountAlphaMin, "IbETHRouter: receive less Alpha than amountAlphaMin");                               
    }       

    // Swap exact amount of ETH for Token
    // 1. Receive ETH from caller
    // 2. Wrap ETH to ibETH.
    // 3. Swap ibETH for Token    
    function swapExactETHForAlpha(
        uint256 amountAlphaOutMin,        
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts) {                           
        IBank(ibETH).deposit.value(msg.value)();   
        address[] memory path = new address[](2);
        path[0] = ibETH;
        path[1] = alpha;     
        uint256[] memory swapAmounts = IUniswapV2Router02(router).swapExactTokensForTokens(IBank(ibETH).balanceOf(address(this)), amountAlphaOutMin, path, to, deadline);
        amounts = new uint256[](2);        
        amounts[0] = msg.value;
        amounts[1] = swapAmounts[1];
    }

    // Swap Token for exact amount of ETH
    // 1. Receive Token from caller
    // 2. Swap Token for ibETH.
    // 3. Unwrap ibETH to ETH.
    function swapAlphaForExactETH(
        uint256 amountETHOut,
        uint256 amountAlphaInMax,         
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts) {
        TransferHelper.safeTransferFrom(alpha, msg.sender, address(this), amountAlphaInMax);
        address[] memory path = new address[](2);
        path[0] = alpha;
        path[1] = ibETH;
        IBank(ibETH).withdraw(0);
        uint256[] memory swapAmounts = IUniswapV2Router02(router).swapTokensForExactTokens(ibETHForExactETH(amountETHOut), amountAlphaInMax, path, address(this), deadline);                           
        IBank(ibETH).withdraw(swapAmounts[1]);
        amounts = new uint256[](2);
        amounts[0] = swapAmounts[0];
        amounts[1] = address(this).balance;
        TransferHelper.safeTransferETH(to, address(this).balance);        
        if (amountAlphaInMax > amounts[0]) {
            TransferHelper.safeTransfer(alpha, msg.sender, amountAlphaInMax.sub(amounts[0]));
        }                    
    }

    // Swap exact amount of Token for ETH
    // 1. Receive Token from caller
    // 2. Swap Token for ibETH.
    // 3. Unwrap ibETH to ETH.
    function swapExactAlphaForETH(
        uint256 amountAlphaIn,
        uint256 amountETHOutMin,         
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts) {
        TransferHelper.safeTransferFrom(alpha, msg.sender, address(this), amountAlphaIn); 
        address[] memory path = new address[](2);
        path[0] = alpha;
        path[1] = ibETH;
        uint256[] memory swapAmounts = IUniswapV2Router02(router).swapExactTokensForTokens(amountAlphaIn, 0, path, address(this), deadline);                        
        IBank(ibETH).withdraw(swapAmounts[1]);        
        amounts = new uint256[](2);
        amounts[0] = swapAmounts[0];
        amounts[1] = address(this).balance;
        TransferHelper.safeTransferETH(to, amounts[1]);
        require(amounts[1] >= amountETHOutMin, "IbETHRouter: receive less ETH than amountETHmin");                                       
    }

    // Swap ETH for exact amount of Token
    // 1. Receive ETH from caller
    // 2. Wrap ETH to ibETH.
    // 3. Swap ibETH for Token    
    function swapETHForExactAlpha(
        uint256 amountAlphaOut,          
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts) {             
        IBank(ibETH).deposit.value(msg.value)();              
        uint256 amountIbETHInMax = IBank(ibETH).balanceOf(address(this));        
        address[] memory path = new address[](2);
        path[0] = ibETH;
        path[1] = alpha;                
        uint256[] memory swapAmounts = IUniswapV2Router02(router).swapTokensForExactTokens(amountAlphaOut, amountIbETHInMax, path, to, deadline);                                                
        amounts = new uint256[](2);               
        amounts[0] = msg.value;
        amounts[1] = swapAmounts[1];
        // Transfer left over ETH back
        if (amountIbETHInMax > swapAmounts[0]) {                         
            IBank(ibETH).withdraw(amountIbETHInMax.sub(swapAmounts[0]));                    
            amounts[0] = msg.value - address(this).balance;
            TransferHelper.safeTransferETH(to, address(this).balance);
        }                                       
    }   

    /// @dev Recover ERC20 tokens that were accidentally sent to this smart contract.
    /// @param token The token contract. Can be anything. This contract should not hold ERC20 tokens.
    /// @param to The address to send the tokens to.
    /// @param value The number of tokens to transfer to `to`.
    function recover(address token, address to, uint256 value) external onlyOwner {        
        TransferHelper.safeTransfer(token, to, value);                
    }

    /// @dev Recover ETH that were accidentally sent to this smart contract.    
    /// @param to The address to send the ETH to.
    /// @param value The number of ETH to transfer to `to`.
    function recoverETH(address to, uint256 value) external onlyOwner {        
        TransferHelper.safeTransferETH(to, value);                
    }
}