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
///@notice This contract adds liquidity to Curve pools in one transaction with ETH or ERC tokens.

// File: Context.sol

pragma solidity ^0.5.5;

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
// File: OpenZepplinOwnable.sol

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
// File: OpenZepplinSafeMath.sol

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
// File: OpenZepplinIERC20.sol

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
// File: OpenZepplinReentrancyGuard.sol

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
 * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
 * metering changes introduced in the Istanbul hardfork.
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

// File: @openzeppelin/contracts/utils/Address.sol

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

// File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol

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

interface ICurveSwap {
    function coins(int128 arg0) external view returns (address);

    function underlying_coins(int128 arg0) external view returns (address);

    function add_liquidity(uint256[4] calldata amounts, uint256 min_mint_amount)
        external;

    function add_liquidity(uint256[3] calldata amounts, uint256 min_mint_amount)
        external;

    function add_liquidity(
        uint256[3] calldata amounts,
        uint256 min_mint_amount,
        bool isUnderLying
    ) external;

    function add_liquidity(uint256[2] calldata amounts, uint256 min_mint_amount)
        external;
}

interface ICurveEthSwap {
    function add_liquidity(uint256[2] calldata amounts, uint256 min_mint_amount)
        external
        payable
        returns (uint256);
}

interface yERC20 {
    function deposit(uint256 _amount) external;
}

interface IWETH {
    function deposit() external payable;

    function transfer(address to, uint256 value) external returns (bool);

    function withdraw(uint256) external;
}

interface ICurveRegistry {
    function metaPools(address tokenAddress)
        external
        view
        returns (address swapAddress);

    function getTokenAddress(address swapAddress)
        external
        view
        returns (address tokenAddress);

    function getPoolTokens(address swapAddress)
        external
        view
        returns (address[4] memory poolTokens);

    function isMetaPool(address swapAddress) external view returns (bool);

    function getNumTokens(address swapAddress)
        external
        view
        returns (uint8 numTokens);

    function isBtcPool(address swapAddress) external view returns (bool);

    function isUnderlyingToken(
        address swapAddress,
        address tokenContractAddress
    ) external view returns (bool, uint8);
}

contract Curve_ZapIn_General_V2_0_1 is ReentrancyGuard, Ownable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    bool public stopped = false;
    uint16 public goodwill = 0;
    address
        public zgoodwillAddress = 0x3CE37278de6388532C3949ce4e886F365B14fB56;

    address
        private constant ETHToken = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    ICurveRegistry public curveReg;

    address private Aave = 0xDeBF20617708857ebe4F679508E7b7863a8A8EeE;

    // circuit breaker modifiers
    modifier stopInEmergency {
        if (stopped) {
            revert("Temporarily Paused");
        } else {
            _;
        }
    }

    constructor(ICurveRegistry _curveRegistry) public {
        curveReg = _curveRegistry;
    }

    event zapIn(address sender, address pool, uint256 crvTokens);

    /**
    @notice This function adds liquidity to a Curve pool with ETH or ERC20 tokens
    @param _fromTokenAddress The token used for entry (address(0) if ether)
    @param _toTokenAddress The intermediate ERC20 token to swap to
    @param _swapAddress Curve swap address for the pool
    @param _incomingTokenQty The amount of fromToken to invest
    @param _minPoolTokens The minimum acceptable quantity of Curve LP to receive. Reverts otherwise
    @param _allowanceTarget Spender for the first swap
    @param _swapTarget Excecution target for the first swap
    @param _swapCallData DEX quote data
    @return crvTokensBought- Quantity of Curve LP tokens received
     */
    function ZapIn(
        address _fromTokenAddress,
        address _toTokenAddress,
        address _swapAddress,
        uint256 _incomingTokenQty,
        uint256 _minPoolTokens,
        address _allowanceTarget,
        address _swapTarget,
        bytes calldata _swapCallData
    )
        external
        payable
        stopInEmergency
        nonReentrant
        returns (uint256 crvTokensBought)
    {
        if (_fromTokenAddress == address(0)) {
            require(msg.value > 0, "Error: ETH not sent");
            _incomingTokenQty = msg.value;
            _fromTokenAddress = ETHToken;
        } else {
            require(msg.value == 0, "Error: ETH sent");
            require(_incomingTokenQty > 0, "Error: Invalid ERC amount");
            IERC20(_fromTokenAddress).safeTransferFrom(
                msg.sender,
                address(this),
                _incomingTokenQty
            );
        }

        //perform zapIn
        crvTokensBought = _performZapIn(
            _fromTokenAddress,
            _toTokenAddress,
            _swapAddress,
            _incomingTokenQty,
            _allowanceTarget,
            _swapTarget,
            _swapCallData
        );

        require(
            crvTokensBought > _minPoolTokens,
            "Received less than minPoolTokens"
        );

        address poolTokenAddress = curveReg.getTokenAddress(_swapAddress);
        uint256 goodwillPortion;

        emit zapIn(msg.sender, poolTokenAddress, crvTokensBought);

        //transfer goodwill
        if (goodwill > 0) {
            goodwillPortion = SafeMath.div(
                SafeMath.mul(crvTokensBought, goodwill),
                10000
            );
            IERC20(poolTokenAddress).safeTransfer(
                zgoodwillAddress,
                goodwillPortion
            );
        }

        //transfer crvTokens to msg.sender
        IERC20(poolTokenAddress).transfer(
            msg.sender,
            SafeMath.sub(crvTokensBought, goodwillPortion)
        );

        return SafeMath.sub(crvTokensBought, goodwillPortion);
    }

    function _performZapIn(
        address _fromTokenAddress,
        address _toTokenAddress,
        address _swapAddress,
        uint256 toInvest,
        address _allowanceTarget,
        address _swapTarget,
        bytes memory _swapCallData
    ) internal returns (uint256 crvTokensBought) {
        (bool isUnderlying, uint8 underlyingIndex) = curveReg.isUnderlyingToken(
            _swapAddress,
            _fromTokenAddress
        );

        if (isUnderlying) {
            crvTokensBought = _enterCurve(
                _swapAddress,
                toInvest,
                underlyingIndex
            );
        } else {
            //swap tokens using 0x swap
            uint256 tokensBought = _fillQuote(
                _fromTokenAddress,
                _toTokenAddress,
                toInvest,
                _allowanceTarget,
                _swapTarget,
                _swapCallData
            );
            if (_toTokenAddress == address(0)) _toTokenAddress = ETHToken;

            //get underlying token index
            (isUnderlying, underlyingIndex) = curveReg.isUnderlyingToken(
                _swapAddress,
                _toTokenAddress
            );

            if (isUnderlying) {
                crvTokensBought = _enterCurve(
                    _swapAddress,
                    tokensBought,
                    underlyingIndex
                );
            } else {
                (uint256 tokens, uint8 metaIndex) = _enterMetaPool(
                    _swapAddress,
                    _toTokenAddress,
                    tokensBought
                );

                crvTokensBought = _enterCurve(_swapAddress, tokens, metaIndex);
            }
        }
    }

    /**
    @notice This function gets adds the liquidity for meta pools and returns the token index and swap tokens
    @param _swapAddress Curve swap address for the pool
    @param _toTokenAddress The ERC20 token to which from token to be convert
    @param  swapTokens amount of toTokens to invest
    @return tokensBought- quantity of curve LP acquired
    @return index- index of LP token in _swapAddress whose pool tokens were acquired
     */
    function _enterMetaPool(
        address _swapAddress,
        address _toTokenAddress,
        uint256 swapTokens
    ) internal returns (uint256 tokensBought, uint8 index) {
        address[4] memory poolTokens = curveReg.getPoolTokens(_swapAddress);
        for (uint8 i = 0; i < 4; i++) {
            address intermediateSwapAddress = curveReg.metaPools(poolTokens[i]);
            if (intermediateSwapAddress != address(0)) {
                (, index) = curveReg.isUnderlyingToken(
                    intermediateSwapAddress,
                    _toTokenAddress
                );

                tokensBought = _enterCurve(
                    intermediateSwapAddress,
                    swapTokens,
                    index
                );

                return (tokensBought, i);
            }
        }
    }

    function _fillQuote(
        address _fromTokenAddress,
        address _toTokenAddress,
        uint256 _amount,
        address _allowanceTarget,
        address _swapTarget,
        bytes memory _swapCallData
    ) internal returns (uint256 amountBought) {
        uint256 valueToSend;

        if (_fromTokenAddress == _toTokenAddress) {
            return _amount;
        }
        if (_fromTokenAddress == ETHToken) {
            valueToSend = _amount;
        } else {
            IERC20 fromToken = IERC20(_fromTokenAddress);

            require(
                fromToken.balanceOf(address(this)) >= _amount,
                "Insufficient Balance"
            );

            fromToken.safeApprove(address(_allowanceTarget), 0);
            fromToken.safeApprove(address(_allowanceTarget), _amount);
        }

        uint256 initialBalance = _toTokenAddress == address(0)
            ? address(this).balance
            : IERC20(_toTokenAddress).balanceOf(address(this));

        (bool success, ) = _swapTarget.call.value(valueToSend)(_swapCallData);
        require(success, "Error Swapping Tokens");

        amountBought = _toTokenAddress == address(0)
            ? (address(this).balance).sub(initialBalance)
            : IERC20(_toTokenAddress).balanceOf(address(this)).sub(
                initialBalance
            );

        require(amountBought > 0, "Swapped To Invalid Intermediate");
    }

    /**
    @notice This function adds liquidity to a curve pool
    @param _swapAddress Curve swap address for the pool
    @param amount The quantity of tokens being added as liquidity
    @param index The token index for the add_liquidity call
    @return crvTokensBought- the quantity of curve LP tokens received
    */
    function _enterCurve(
        address _swapAddress,
        uint256 amount,
        uint8 index
    ) internal returns (uint256 crvTokensBought) {
        address tokenAddress = curveReg.getTokenAddress(_swapAddress);
        uint256 initialBalance = IERC20(tokenAddress).balanceOf(address(this));
        address entryToken = curveReg.getPoolTokens(_swapAddress)[index];
        if (entryToken != ETHToken) {
            IERC20(entryToken).safeIncreaseAllowance(
                address(_swapAddress),
                amount
            );
        }
        uint256 numTokens = curveReg.getNumTokens(_swapAddress);
        if (numTokens == 4) {
            uint256[4] memory amounts;
            amounts[index] = amount;
            ICurveSwap(_swapAddress).add_liquidity(amounts, 0);
        } else if (numTokens == 3) {
            uint256[3] memory amounts;
            amounts[index] = amount;
            if (_swapAddress == Aave) {
                ICurveSwap(_swapAddress).add_liquidity(amounts, 0, true);
            } else {
                ICurveSwap(_swapAddress).add_liquidity(amounts, 0);
            }
        } else {
            uint256[2] memory amounts;
            amounts[index] = amount;
            if (isETHUnderlying(_swapAddress)) {
                ICurveEthSwap(_swapAddress).add_liquidity.value(amount)(
                    amounts,
                    0
                );
            } else {
                ICurveSwap(_swapAddress).add_liquidity(amounts, 0);
            }
        }
        crvTokensBought = (IERC20(tokenAddress).balanceOf(address(this))).sub(
            initialBalance
        );
    }

    function isETHUnderlying(address _swapAddress)
        internal
        view
        returns (bool)
    {
        address[4] memory poolTokens = curveReg.getPoolTokens(_swapAddress);
        for (uint8 i = 0; i < 4; i++) {
            if (poolTokens[i] == ETHToken) {
                return true;
            }
        }
        return false;
    }

    function updateAaveAddress(address _newAddress) external onlyOwner {
        require(_newAddress != address(0), "Zero Address");
        Aave = _newAddress;
    }

    function inCaseTokengetsStuck(IERC20 _TokenAddress) external onlyOwner {
        uint256 qty = _TokenAddress.balanceOf(address(this));
        IERC20(_TokenAddress).safeTransfer(_owner, qty);
    }

    function set_new_goodwill(uint16 _new_goodwill) external onlyOwner {
        require(
            _new_goodwill >= 0 && _new_goodwill < 100,
            "GoodWill Value not allowed"
        );
        goodwill = _new_goodwill;
    }

    function set_new_zgoodwillAddress(address _new_zgoodwillAddress)
        external
        onlyOwner
    {
        zgoodwillAddress = _new_zgoodwillAddress;
    }

    function updateCurveRegistry(ICurveRegistry newCurveRegistry)
        external
        onlyOwner
    {
        require(newCurveRegistry != curveReg, "Already using this Registry");
        curveReg = newCurveRegistry;
    }

    // - to Pause the contract
    function toggleContractActive() external onlyOwner {
        stopped = !stopped;
    }

    // - to withdraw any ETH balance sitting in the contract
    function withdraw() external onlyOwner {
        _owner.transfer(address(this).balance);
    }

    function() external payable {
        require(msg.sender != tx.origin, "Do not send ETH directly");
    }
}