// ███████╗░█████╗░██████╗░██████╗░███████╗██████╗░░░░███████╗██╗
// ╚════██║██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗░░░██╔════╝██║
// ░░███╔═╝███████║██████╔╝██████╔╝█████╗░░██████╔╝░░░█████╗░░██║
// ██╔══╝░░██╔══██║██╔═══╝░██╔═══╝░██╔══╝░░██╔══██╗░░░██╔══╝░░██║
// ███████╗██║░░██║██║░░░░░██║░░░░░███████╗██║░░██║██╗██║░░░░░██║
// ╚══════╝╚═╝░░╚═╝╚═╝░░░░░╚═╝░░░░░╚══════╝╚═╝░░╚═╝╚═╝╚═╝░░░░░╚═╝
// Copyright (C) 2020 zapper

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//

///@author Zapper
///@notice This contract adds/removes liquidity to/from yEarn Vaults using ETH or ERC20 Tokens.
// SPDX-License-Identifier: GPLv2

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol

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
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
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
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
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
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/ReentrancyGuard.sol

pragma solidity ^0.5.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
contract ReentrancyGuard {
    bool private _notEntered;

    constructor() internal {
        // Storing an initial non-zero value makes deployment a bit more
        // expensive, but in exchange the refund on every call to nonReentrant
        // will be lower in amount. Since refunds are capped to a percetange of
        // the total transaction's gas, it is best to keep them low in cases
        // like this one, to increase the likelihood of the full refund coming
        // into effect.
        _notEntered = true;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_notEntered, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _notEntered = false;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _notEntered = true;
    }
}

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol

pragma solidity ^0.5.0;

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
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

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
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

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
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol

pragma solidity ^0.5.0;

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


            bytes32 accountHash
         = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            codehash := extcodehash(account)
        }
        return (codehash != accountHash && codehash != 0x0);
    }

    /**
     * @dev Converts an `address` into `address payable`. Note that this is
     * simply a type cast: the actual underlying value is not changed.
     *
     * _Available since v2.4.0._
     */
    function toPayable(address account)
        internal
        pure
        returns (address payable)
    {
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
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );

        // solhint-disable-next-line avoid-call-value
        (bool success, ) = recipient.call.value(amount)("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
    }
}

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/GSN/Context.sol

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
    constructor() internal {}

    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

pragma solidity ^0.5.0;

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
    address payable public _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() internal {
        address payable msgSender = _msgSender();
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
    function transferOwnership(address payable newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address payable newOwner) internal {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: yVault_ZapInOut_General_V1_2.sol

/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transfer.selector, to, value)
        );
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
        );
    }

    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        callOptionalReturn(
            token,
            abi.encodeWithSelector(token.approve.selector, spender, value)
        );
    }

    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(
            value
        );
        callOptionalReturn(
            token,
            abi.encodeWithSelector(
                token.approve.selector,
                spender,
                newAllowance
            )
        );
    }

    function safeDecreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(
            value,
            "SafeERC20: decreased allowance below zero"
        );
        callOptionalReturn(
            token,
            abi.encodeWithSelector(
                token.approve.selector,
                spender,
                newAllowance
            )
        );
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

        if (returndata.length > 0) {
            // Return data is optional
            // solhint-disable-next-line max-line-length
            require(
                abi.decode(returndata, (bool)),
                "SafeERC20: ERC20 operation did not succeed"
            );
        }
    }
}

interface IUniswapV2Factory {
    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address);
}

interface IUniswapRouter02 {
    //get estimated amountOut
    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    //token 2 token
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

    //eth 2 token
    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    //token 2 eth
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
}

interface yVault {
    function deposit(uint256) external;

    function withdraw(uint256) external;

    function getPricePerFullShare() external view returns (uint256);

    function token() external view returns (address);
}

interface ICurveZapInGeneral {
    function ZapIn(
        address toWhomToIssue,
        address fromToken,
        address swapAddress,
        uint256 incomingTokenQty,
        uint256 minPoolTokens
    ) external payable returns (uint256 crvTokensBought);
}

interface ICurveZapOutGeneral {
    function ZapOut(
        address payable toWhomToIssue,
        address swapAddress,
        uint256 incomingCrv,
        address toToken,
        uint256 minToTokens
    ) external returns (uint256 ToTokensBought);
}

interface IAaveLendingPoolAddressesProvider {
    function getLendingPool() external view returns (address);

    function getLendingPoolCore() external view returns (address payable);
}

interface IAaveLendingPool {
    function deposit(
        address _reserve,
        uint256 _amount,
        uint16 _referralCode
    ) external payable;
}

interface IAToken {
    function redeem(uint256 _amount) external;

    function underlyingAssetAddress() external returns (address);
}

interface IWETH {
    function deposit() external payable;

    function withdraw(uint256) external;
}

contract yVault_ZapInOut_General_V1_5 is ReentrancyGuard, Ownable {
    using SafeMath for uint256;
    using Address for address;
    using SafeERC20 for IERC20;
    bool public stopped = false;
    uint16 public goodwill;

    IUniswapV2Factory
        private constant UniSwapV2FactoryAddress = IUniswapV2Factory(
        0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f
    );
    IUniswapRouter02 private constant uniswapRouter = IUniswapRouter02(
        0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
    );

    ICurveZapInGeneral public CurveZapInGeneral = ICurveZapInGeneral(
        0xf9A724c2607E5766a7Bbe530D6a7e173532F9f3a
    );
    ICurveZapOutGeneral public CurveZapOutGeneral = ICurveZapOutGeneral(
        0xA3061Cf6aC1423c6F40917AD49602cBA187181Dc
    );

    IAaveLendingPoolAddressesProvider
        private constant lendingPoolAddressProvider = IAaveLendingPoolAddressesProvider(
        0x24a42fD28C976A61Df5D00D0599C34c4f90748c8
    );

    address
        private constant yCurveExchangeAddress = 0xbBC81d23Ea2c3ec7e56D39296F0cbB648873a5d3;
    address
        private constant sBtcCurveExchangeAddress = 0x7fC77b5c7614E1533320Ea6DDc2Eb61fa00A9714;
    address
        private constant bUSDCurveExchangeAddress = 0xb6c057591E073249F2D9D88Ba59a46CFC9B59EdB;
    address
        private constant threeCurveExchangeAddress = 0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7;
    address
        private constant cUSDCurveExchangeAddress = 0xeB21209ae4C2c9FF2a86ACA31E123764A3B6Bc06;

    address
        private constant yCurvePoolTokenAddress = 0xdF5e0e81Dff6FAF3A7e52BA697820c5e32D806A8;
    address
        private constant sBtcCurvePoolTokenAddress = 0x075b1bb99792c9E1041bA13afEf80C91a1e70fB3;
    address
        private constant bUSDCurvePoolTokenAddress = 0x3B3Ac5386837Dc563660FB6a0937DFAa5924333B;
    address
        private constant threeCurvePoolTokenAddress = 0x6c3F90f043a72FA612cbac8115EE7e52BDe6E490;
    address
        private constant cUSDCurvePoolTokenAddress = 0x845838DF265Dcd2c412A1Dc9e959c7d08537f8a2;

    mapping(address => address) public token2Exchange; //Curve token to Curve exchange

    address
        private constant ETHAddress = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address
        private constant wethTokenAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address
        private constant zgoodwillAddress = 0x3CE37278de6388532C3949ce4e886F365B14fB56;

    uint256
        private constant deadline = 0xf000000000000000000000000000000000000000000000000000000000000000;

    event Zapin(
        address _toWhomToIssue,
        address _toYVaultAddress,
        uint256 _Outgoing
    );

    event Zapout(
        address _toWhomToIssue,
        address _fromYVaultAddress,
        address _toTokenAddress,
        uint256 _tokensRecieved
    );

    constructor() public {
        token2Exchange[yCurvePoolTokenAddress] = yCurveExchangeAddress;
        token2Exchange[bUSDCurvePoolTokenAddress] = bUSDCurveExchangeAddress;
        token2Exchange[sBtcCurvePoolTokenAddress] = sBtcCurveExchangeAddress;
        token2Exchange[threeCurvePoolTokenAddress] = threeCurveExchangeAddress;
        token2Exchange[cUSDCurvePoolTokenAddress] = cUSDCurveExchangeAddress;
    }

    // circuit breaker modifiers
    modifier stopInEmergency {
        if (stopped) {
            revert("Temporarily Paused");
        } else {
            _;
        }
    }

    function updateCurveZapIn(address CurveZapInGeneralAddress)
        public
        onlyOwner
    {
        require(CurveZapInGeneralAddress != address(0), "Invalid Address");
        CurveZapInGeneral = ICurveZapInGeneral(CurveZapInGeneralAddress);
    }

    function updateCurveZapOut(address CurveZapOutGeneralAddress)
        public
        onlyOwner
    {
        require(CurveZapOutGeneralAddress != address(0), "Invalid Address");
        CurveZapOutGeneral = ICurveZapOutGeneral(CurveZapOutGeneralAddress);
    }

    function addNewCurveExchange(
        address curvePoolToken,
        address curveExchangeAddress
    ) public onlyOwner {
        require(
            curvePoolToken != address(0) && curveExchangeAddress != address(0),
            "Invalid Address"
        );
        token2Exchange[curvePoolToken] = curveExchangeAddress;
    }

    /**
    @notice This function is used to add liquidity to yVaults
    @param _toWhomToIssue recipient address
    @param _toYVaultAddress The address of vault to add liquidity to
    @param _vaultType Type of underlying token: 0 token; 1 aToken; 2 LP token
    @param _fromTokenAddress The token used for investment (address(0x00) if ether)
    @param _amount The amount of ERC to invest
    @param _minYTokens for slippage
    @return yTokensRec
     */
    function ZapIn(
        address _toWhomToIssue,
        address _toYVaultAddress,
        uint16 _vaultType,
        address _fromTokenAddress,
        uint256 _amount,
        uint256 _minYTokens
    ) public payable nonReentrant stopInEmergency returns (uint256) {
        yVault vaultToEnter = yVault(_toYVaultAddress);
        address underlyingVaultToken = vaultToEnter.token();

        if (_fromTokenAddress == address(0)) {
            require(msg.value > 0, "ERR: No ETH sent");
        } else {
            require(_amount > 0, "Err: No Tokens Sent");
            require(msg.value == 0, "ERR: ETH sent with Token");

            IERC20(_fromTokenAddress).safeTransferFrom(
                msg.sender,
                address(this),
                _amount
            );
        }

        uint256 iniYTokensBal = IERC20(address(vaultToEnter)).balanceOf(
            address(this)
        );

        if (underlyingVaultToken == _fromTokenAddress) {
            IERC20(underlyingVaultToken).safeApprove(
                address(vaultToEnter),
                _amount
            );
            vaultToEnter.deposit(_amount);
        } else {
            // Curve Vaults
            if (_vaultType == 2) {

                    address curveExchangeAddr
                 = token2Exchange[underlyingVaultToken];

                uint256 tokensBought;
                if (_fromTokenAddress == address(0)) {
                    tokensBought = CurveZapInGeneral.ZapIn.value(msg.value)(
                        address(this),
                        address(0),
                        curveExchangeAddr,
                        msg.value,
                        0
                    );
                } else {
                    IERC20(_fromTokenAddress).safeApprove(
                        address(CurveZapInGeneral),
                        _amount
                    );
                    tokensBought = CurveZapInGeneral.ZapIn(
                        address(this),
                        _fromTokenAddress,
                        curveExchangeAddr,
                        _amount,
                        0
                    );
                }

                IERC20(underlyingVaultToken).safeApprove(
                    address(vaultToEnter),
                    tokensBought
                );
                vaultToEnter.deposit(tokensBought);
            } else if (_vaultType == 1) {
                address underlyingAsset = IAToken(underlyingVaultToken)
                    .underlyingAssetAddress();

                uint256 tokensBought;
                if (_fromTokenAddress == address(0)) {
                    tokensBought = _eth2Token(underlyingAsset);
                } else {
                    tokensBought = _token2Token(
                        _fromTokenAddress,
                        underlyingAsset,
                        _amount
                    );
                }

                IERC20(underlyingAsset).safeApprove(
                    lendingPoolAddressProvider.getLendingPoolCore(),
                    tokensBought
                );

                IAaveLendingPool(lendingPoolAddressProvider.getLendingPool())
                    .deposit(underlyingAsset, tokensBought, 0);

                uint256 aTokensBought = IERC20(underlyingVaultToken).balanceOf(
                    address(this)
                );
                IERC20(underlyingVaultToken).safeApprove(
                    address(vaultToEnter),
                    aTokensBought
                );
                vaultToEnter.deposit(aTokensBought);
            } else {
                uint256 tokensBought;
                if (_fromTokenAddress == address(0)) {
                    tokensBought = _eth2Token(underlyingVaultToken);
                } else {
                    tokensBought = _token2Token(
                        _fromTokenAddress,
                        underlyingVaultToken,
                        _amount
                    );
                }

                IERC20(underlyingVaultToken).safeApprove(
                    address(vaultToEnter),
                    tokensBought
                );
                vaultToEnter.deposit(tokensBought);
            }
        }

        uint256 yTokensRec = IERC20(address(vaultToEnter))
            .balanceOf(address(this))
            .sub(iniYTokensBal);
        require(yTokensRec >= _minYTokens, "High Slippage");

        //transfer goodwill
        uint256 goodwillPortion = _transferGoodwill(
            address(vaultToEnter),
            yTokensRec
        );

        IERC20(address(vaultToEnter)).safeTransfer(
            _toWhomToIssue,
            yTokensRec.sub(goodwillPortion)
        );

        emit Zapin(
            _toWhomToIssue,
            address(vaultToEnter),
            yTokensRec.sub(goodwillPortion)
        );

        return (yTokensRec.sub(goodwillPortion));
    }

    /**
    @notice This function is used to remove liquidity from yVaults
    @param _toWhomToIssue recipient address
    @param _ToTokenContractAddress The address of the token to withdraw
    @param _fromYVaultAddress The address of the vault to exit
    @param _vaultType Type of underlying token: 0 token; 1 aToken; 2 LP token
    @param _IncomingAmt The amount of vault tokens removed
    @param _minTokensRec for slippage
    @return toTokensReceived
     */
    function ZapOut(
        address payable _toWhomToIssue,
        address _ToTokenContractAddress,
        address _fromYVaultAddress,
        uint16 _vaultType,
        uint256 _IncomingAmt,
        uint256 _minTokensRec
    ) public nonReentrant stopInEmergency returns (uint256) {
        yVault vaultToExit = yVault(_fromYVaultAddress);
        address underlyingVaultToken = vaultToExit.token();

        IERC20(address(vaultToExit)).safeTransferFrom(
            msg.sender,
            address(this),
            _IncomingAmt
        );

        uint256 goodwillPortion = _transferGoodwill(
            address(vaultToExit),
            _IncomingAmt
        );

        vaultToExit.withdraw(_IncomingAmt.sub(goodwillPortion));
        uint256 underlyingReceived = IERC20(underlyingVaultToken).balanceOf(
            address(this)
        );

        uint256 toTokensReceived;
        if (_ToTokenContractAddress == underlyingVaultToken) {
            IERC20(underlyingVaultToken).safeTransfer(
                _toWhomToIssue,
                underlyingReceived
            );
            toTokensReceived = underlyingReceived;
        } else {
            if (_vaultType == 2) {
                toTokensReceived = _withdrawFromCurve(
                    underlyingVaultToken,
                    underlyingReceived,
                    _toWhomToIssue,
                    _ToTokenContractAddress,
                    0
                );
            } else if (_vaultType == 1) {
                // unwrap atoken
                IAToken(underlyingVaultToken).redeem(underlyingReceived);
                address underlyingAsset = IAToken(underlyingVaultToken)
                    .underlyingAssetAddress();

                // swap
                if (_ToTokenContractAddress == address(0)) {
                    toTokensReceived = _token2Eth(
                        underlyingAsset,
                        underlyingReceived,
                        _toWhomToIssue
                    );
                } else {
                    toTokensReceived = _token2Token(
                        underlyingAsset,
                        _ToTokenContractAddress,
                        underlyingReceived
                    );
                    IERC20(_ToTokenContractAddress).safeTransfer(
                        _toWhomToIssue,
                        toTokensReceived
                    );
                }
            } else {
                if (_ToTokenContractAddress == address(0)) {
                    toTokensReceived = _token2Eth(
                        underlyingVaultToken,
                        underlyingReceived,
                        _toWhomToIssue
                    );
                } else {
                    toTokensReceived = _token2Token(
                        underlyingVaultToken,
                        _ToTokenContractAddress,
                        underlyingReceived
                    );

                    IERC20(_ToTokenContractAddress).safeTransfer(
                        _toWhomToIssue,
                        toTokensReceived
                    );
                }
            }
        }

        require(toTokensReceived >= _minTokensRec, "High Slippage");

        emit Zapout(
            _toWhomToIssue,
            _fromYVaultAddress,
            _ToTokenContractAddress,
            toTokensReceived
        );

        return toTokensReceived;
    }

    function _withdrawFromCurve(
        address _CurvePoolToken,
        uint256 _tokenAmt,
        address _toWhomToIssue,
        address _ToTokenContractAddress,
        uint256 _minTokensRec
    ) internal returns (uint256) {
        IERC20(_CurvePoolToken).safeApprove(
            address(CurveZapOutGeneral),
            _tokenAmt
        );

        address curveExchangeAddr = token2Exchange[_CurvePoolToken];

        return (
            CurveZapOutGeneral.ZapOut(
                Address.toPayable(_toWhomToIssue),
                curveExchangeAddr,
                _tokenAmt,
                _ToTokenContractAddress,
                _minTokensRec
            )
        );
    }

    /**
    @notice This function is used to swap eth for tokens
    @param _tokenContractAddress Token address which we want to buy
    @return tokensBought The quantity of token bought
     */
    function _eth2Token(address _tokenContractAddress)
        internal
        returns (uint256 tokensBought)
    {
        if (_tokenContractAddress == wethTokenAddress) {
            IWETH(wethTokenAddress).deposit.value(msg.value)();
            return msg.value;
        }

        address[] memory path = new address[](2);
        path[0] = wethTokenAddress;
        path[1] = _tokenContractAddress;
        tokensBought = uniswapRouter.swapExactETHForTokens.value(msg.value)(
            1,
            path,
            address(this),
            deadline
        )[path.length - 1];
    }

    /**
    @notice This function is used to swap tokens
    @param _FromTokenContractAddress The token address to swap from
    @param _ToTokenContractAddress The token address to swap to
    @param tokens2Trade The amount of tokens to swap
    @return tokenBought The quantity of tokens bought
    */
    function _token2Token(
        address _FromTokenContractAddress,
        address _ToTokenContractAddress,
        uint256 tokens2Trade
    ) internal returns (uint256 tokenBought) {
        if (_FromTokenContractAddress == _ToTokenContractAddress) {
            return tokens2Trade;
        }

        IERC20(_FromTokenContractAddress).safeApprove(
            address(uniswapRouter),
            tokens2Trade
        );

        if (_FromTokenContractAddress != wethTokenAddress) {
            if (_ToTokenContractAddress != wethTokenAddress) {
                address[] memory path = new address[](3);
                path[0] = _FromTokenContractAddress;
                path[1] = wethTokenAddress;
                path[2] = _ToTokenContractAddress;
                tokenBought = uniswapRouter.swapExactTokensForTokens(
                    tokens2Trade,
                    1,
                    path,
                    address(this),
                    deadline
                )[path.length - 1];
            } else {
                address[] memory path = new address[](2);
                path[0] = _FromTokenContractAddress;
                path[1] = wethTokenAddress;

                tokenBought = uniswapRouter.swapExactTokensForTokens(
                    tokens2Trade,
                    1,
                    path,
                    address(this),
                    deadline
                )[path.length - 1];
            }
        } else {
            address[] memory path = new address[](2);
            path[0] = wethTokenAddress;
            path[1] = _ToTokenContractAddress;
            tokenBought = uniswapRouter.swapExactTokensForTokens(
                tokens2Trade,
                1,
                path,
                address(this),
                deadline
            )[path.length - 1];
        }
    }

    function _token2Eth(
        address _FromTokenContractAddress,
        uint256 tokens2Trade,
        address payable _toWhomToIssue
    ) internal returns (uint256) {
        if (_FromTokenContractAddress == wethTokenAddress) {
            IWETH(wethTokenAddress).withdraw(tokens2Trade);
            _toWhomToIssue.transfer(tokens2Trade);
            return tokens2Trade;
        }

        IERC20(_FromTokenContractAddress).safeApprove(
            address(uniswapRouter),
            tokens2Trade
        );

        address[] memory path = new address[](2);
        path[0] = _FromTokenContractAddress;
        path[1] = wethTokenAddress;
        uint256 ethBought = uniswapRouter.swapExactTokensForETH(
            tokens2Trade,
            1,
            path,
            _toWhomToIssue,
            deadline
        )[path.length - 1];

        return ethBought;
    }

    /**
    @notice This function is used to calculate and transfer goodwill
    @param _tokenContractAddress Token in which goodwill is deducted
    @param tokens2Trade The total amount of tokens to be zapped in
    @return goodwillPortion The quantity of goodwill deducted
     */
    function _transferGoodwill(
        address _tokenContractAddress,
        uint256 tokens2Trade
    ) internal returns (uint256 goodwillPortion) {
        goodwillPortion = SafeMath.div(
            SafeMath.mul(tokens2Trade, goodwill),
            10000
        );

        if (goodwillPortion == 0) {
            return 0;
        }

        IERC20(_tokenContractAddress).safeTransfer(
            zgoodwillAddress,
            goodwillPortion
        );
    }

    function set_new_goodwill(uint16 _new_goodwill) public onlyOwner {
        require(
            _new_goodwill >= 0 && _new_goodwill < 10000,
            "GoodWill Value not allowed"
        );
        goodwill = _new_goodwill;
    }

    function inCaseTokengetsStuck(IERC20 _TokenAddress) public onlyOwner {
        uint256 qty = _TokenAddress.balanceOf(address(this));
        IERC20(address(_TokenAddress)).safeTransfer(owner(), qty);
    }

    // - to Pause the contract
    function toggleContractActive() public onlyOwner {
        stopped = !stopped;
    }

    // - to withdraw any ETH balance sitting in the contract
    function withdraw() public onlyOwner {
        uint256 contractBalance = address(this).balance;
        address payable _to = Address.toPayable(owner());
        _to.transfer(contractBalance);
    }

    function() external payable {
        require(msg.sender != tx.origin, "Do not send ETH directly");
    }
}