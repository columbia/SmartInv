pragma solidity ^0.6.0;


// 
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

// 
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

// 
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
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
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

// 
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

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

// 
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

// 
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

interface IRewardDistributionRecipient {
    function notifyRewardAmount(uint256 reward) external;
}

interface IUniswapV2Router02 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) 
    external 
    payable 
    returns (uint amountToken, uint amountETH, uint liquidity);
}

interface IReferrers {
    function isReferrer(address _address) external returns (bool);
}

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
}

// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWWNNWMWXKNMMMMNNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWXXNXKNWkdKN0xKWkl0MMMWkdXMMMMMWKKNNNNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNOKWWxoKXXWMOl0MWdlXOl0MMWXOlxWMMMNxoKWWK0WNKKNNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMX0KWMXllXMKld0KWMKlkMWkdXOlOWXXXNkl0MMMOcOMMMWW0oxXWKkKMWNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXdlxXN0odKKolkkOOOloKKOKNOdO0kOXNKdxXNXkldOOkOOloXWMKlkM0oOXXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWMMMMMMMN0xdxkdcllcccccccccodkO0KKKKKK0K0OxdolccclllllcloxkooX0ldXkoKMNXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXxxNMMMMMMMX0xccccccccccccccccccldO0KKKK0Odl:clodddddddddddoccdxlx0xx0WNxdKXNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNMMWKodXMMNXWNOocccc:;;;;;;;;;::cccccldO0KOdc:coddolllcccllllodddl:lKkoKMKooKKokMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXxxOXWNdo0XOk0dlc:;,'''.''.....'',;:ccccoxxo::lddlcccccccccccccclodocldxKklxXXOkOkOKXNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMWXNMMWKkxdxxOxx00Odc:;''............,''.',;:cc::::ldoccccc::;;::::::c:clddclk0kkNWMNklxXWN00WMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMWWXXNWMNKNWKxk0KK0xc;'.',c,..,.     .cOko:,',;c::;:odloxOOo;cc,',,,,;loccldo:o0KKKXN0o0MMW0lkWWNWMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMW0xxkkxdkXK0KKKKKKK0o,'';d0K: 'o,.cxc. ;XMWXx:'';;;,:dxOKNN0c;od:cxxl,,dK0dldo;lOKKK0K0OKX0xokX0dxKNMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMWWWNK000OkxO00KKKKKKKOl'.,dXWWo. ,'.lOo. lXXOo:'..'''':dooxOK0o,:l:lkOl,;kXXKxdo,ckK00KKK00OO0KOdokKkkNMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMWNKOkxOXNXKXXKKK0KKKK0Oxl;,',:lxd;.    .. .cc;''..'',,,';odcccldo:;;,,;;,;okkdloxdclkOOO0KKKKKK0dd0OxOx0WMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMK0WWN0ddXX00K0KKKKK0Odlccc:;,'..''.............''',,,,,,,cdoccccccc::::::cccccldkkxxkxxk0KKKKKK00KOoOWMWWNXXWMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMM0dkNMMWOOKKKKKKKK0Odlcccccccc:;,''.........'''',,,,,,,,,,,codlcccccccccccccclodocccccc:cdO0KKKKKKKkx0XNXKdoKWMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMKxOXKxdkO000KKKKKKK0xlccccccccccccc:;;,,,,,,,;;;;,,,,,,,,,,,,,;lodollccccccclodddl:::::::;::lx0KKKKKK000NW0odXWNKXMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMWXKOxxxk0K00KKKKKKKKOdlcccccccccccccccccccccccc:;;,,,,,,,,,,,,,,,,;clodddddddddooc::::;::;:::::cd0KKKKKKKKKkokNMWXkxKMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMWKOKWMWKkdk0KKKKKKKKOdcccccccccccccccccccccccc:;;,,,,,,,,,,,,,,,,,,,,,,;:clllcc::;:::;:::;::;::;::d0KKKKKKKKO0XXOxxxkOXMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMWXkxxkKNWWX0KKKKKKKK0xlcccccccccccccccccccccc:;;,,,,,,,,,,,,,,,,,,,,,,,,,,,;;:::::::::::::;::;::::;cx0KKKKKKKK0xdx0NWWKKNMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMN0KNKkxdxOKKKKKKKKKKkoccccccccccccccc:::::cc:;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,;;::::::::::::::::::::::lkKKKKKKKKK0KWMWXOkdkNMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMWWNWWWNKO0KKKKKKKKK0xlcccccccccc::::::::::::::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:::::::::::::::::::::::::x00KK0KK0KKKOxxxkOKNWMMMMMMMMMMMMMM
// MMMMMMMMMMMMMNOxkxxkxk0KKKKKKKKKK0dcccccccccc::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;:d0KKKKKKKKKKO0X0xxxO0XWMMMMMMMMMMMM
// MMMMMMMMMMMMMWNXKKXWX0KKKKKKKKKKK0dcccccccccc::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::d0KKKKK0KKKKKKOxOXWWNKXMMMMMMMMMMMM
// MMMMMMMMMMMNXNWMWNX00KKKKKKKKKKKK0xlccccccccc:::::::;;,,,,;;;;;;;;::::::::::::::::::;;;;;;;;,,,,;:::::::::::::::::cx0KKKKKKKKKKK00KNWNKkxKMMMMMMMMMMMM
// MMMMMMMMMMMNXNXKkkOO0KKKKKKKKKKKKKOoccccccccc::::::::;;;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,;;;;:::::::::::::::::lOKKKKKKKKKKKKK00OkxxkXWWMMMMMMMMMMM
// MMMMMMMMMMW0kxxxxO0KKKKKKKKKKKKKKK0xlcccccccccc:::::::::::::;;;;;;;,,,,,,,,,,,,,,,,,;;;;;;;::::::::::::::::::::::cx0KKKKKKKKKKKKKKKXXNNNKxOWMMMMMMMMMM
// MMMMMMMMMMXkxOKNNXKKKKKKKKKKKKKKKKK0xlccccccccccc:::::::::::::::::::::::::::::::::::::::::::::::::::::::::;:::::cd0KKKKKKKKKKKKKKK00NNKxoxXMMMMMMMMMMM
// MMMMMMMMMMWNNWWWN0O0KKKKKKKKKKKKKKKK0xlccccccccccccc:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::cx0KKKKKKKKKKKKKKKKKXKxldKNKXMMMMMMMMMM
// MMMMMMMMMWKkxkOkxkOKKKKKKKKKKKKKKKKKK0koccccccccccccccccc:::::::::::::::::::::::::::::::::::::::::::::::::;:::lk0KKKKKKKKKKKKKKKKKKKOkKNNNNNMMMMMMMMMM
// MMMMMMMMMXkk0xdkO00KKKKKKKKKKKKKKKKKKK00xlccccccccccccccccccccccccccccccc::::::::::::::::::;::::::::::::::::lxOKKKKKKKKKKKKKKKKKK0K0OXMMMMMMMMMMMMMMMM
// MMMMMMMMMNOkkxxkxx0KKKKKKKKKKKKKKKKKKKKK0Oxolccccccccccccccccccccccccccccc::::::::::::::;;:::::;;;:::::;::lxO0KKKKKKKKKKKKKKKKKKKKKKXWMMMMMMMMMMMMMMMM
// MMMMMMMMMNXNMMMN0O0KKKKKKKKKKKKKKKKKKKKKKK0Okdlccccccccccccccccccccccccccc:::::::::::::::::::::;;::::::coxO0KKKKKKKKKKKKKKKKKKKKKKKKNMMMMMMMMMMMMMMMMM
// MMMMMMMMMXKNNKKWKO0KKKKKKKKKKKKKKKKKKKKKKKKK0kl,,;cccccccccccccccccccccccc:::::::::::::::::::::;;;;;,',oO0K0KKKKKKKKKKKKKKKKKKKKKKKKKOxxxk0NMMMMMMMMMM
// MMMMMMMMMXkxxddkxx0KKKKKKKKKKKKKKKKKKKKKK0Od:.    .lxolccccccccccccccccccc:::::::::::::::::::;:clo:.    .:dO0KKKKKKKKKKKKKKKKKKKKKK0O0KXX0OKWMMMMMMMMM
// MMMMMMMMMNK0KXNNNKKKKKKKKKKKKKKKKKKKKK0Odl:.       'ONKOdlcccccccccccccccc:::;:::::;;::;:;;:cdOKXx.       .,cdk0KKKKKKKKKKKKKKKKKK00KXWMMWNXWMMMMMMMMM
// MMMMMMMMMWKKNNNXKOOKKKKKKKKKKKKKKKK0kdc;,,'.        'OWMWKkl:::::::ccccccc:::;::::;;;:;;;:lkKWMWx.         ...,:ok00KK0KKKKKKKKKKK0OkKNMMNKXMMMMMMMMMM
// MMMMMMMMMW0xkkkkxxOKKKKKKKKKKKK0Oxoc;,,,,,'          'OWMMWXOdc;;;;;::::::;;;;;;;;;;;;;cd0NWMMWx.          ......';lxO0KKKKKKK0KKKK0KXXNWMMMMMMMMMMMMM
// MMMMMMMMMMKOKNMMMWNKKKKKKKKK0kdl:,,,,,,,,,.           'OWMMMMWKxl:;;;;;;;;;;;;;;;;;;:okKWMMMMWx.           .........',cdk0KKKKKKKK0KX0kxxkXMMMMMMMMMMM
// MMMMMMMMMMWKKNNN0kOKK0KK00kdc;,,,,,,,,,,,,.            'kWMMMMMWNOdc;;;;;;;;;;;;;;cd0NWMMMMMWx.            .............,:ok0KKKKKkxxxkkO0NMMMMMMMMMMM
// MMMMMMMMMMMXKNKxlkXNK0Oxoc;,,,,,,,,,,,,,,'.             'kWMMMMMMMWKkl:;;;;;;;;:okKWMMMMMMMWx.             ................';lxO0OddO0XWMMMMMMMMMMMMMM
// MMMMMMMMMMMMNOodKNN0xl:,,,,,,,,,,,,,,,,,,,'...           .kWMMMMMMMMWN0dc;;;:lx0NMMMMMMMMMWx.             ....................';lk0Oxdxxx0WMMMMMMMMMMM
// MMMMMMMMMMMMKdONNNNXo,,,,,,,,,,,,,,,,,,,,,,,,''...        .kWMMMMMMMMMMWKxookXWMMMMMMMMMMWd.         ...........................'lkkkkO0OXMMMMMMMMMMMM
// MMMMMMMMMMMMWNNXOkxxdc;,,,,,,,,,,,,,,,,,,,,,,'...          .kWMMMMMMMMMN0occo0NMMMMMMMMMWd.           .........................'dNWWW0xOXMMMMMMMMMMMMM
// MMMMMMMMMMMMMNkdkOKNMNd;,,,,,,,,,,,,,,,,,,,,'.              .kWMMMMMWXOo:;,'';lONMMMMMMNd.              .......................,oOKNMNKXMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMWWMMMMMWx;,,,,,,,,,,,,,,,,,,,,,'..             .kWMMMWXxc;;;,'''':xXWMMMNd.              ......................'o00kxxxkOXMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMWKK0xdko,,,,,,,,,,,,,,,,,,,,,,'..            .xWWXKK0ko:;,',:ok0KKNWNd.             ........................,kWMMWXkxKMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMWOdkOkkxl:;,,,,,,,,,,,,,,,,,,,,,,''.           .d0KKKKKOo;,',oOKKKKK0l.           .........................'lxxdxOXXKXMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMX0kxdxOKOl,,,,,,,,,,,,,,,,,,,,,,,,,'.          .l0KK0Oo:;,'';oOKKKOc.          ....,,....................,l0WXkxxdkNMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMKk0NWMNXKx;',,,,,,,,,,,,,,,,,,,,,,,,'..        .l00kl;;;,''',lkKOc.         ...'ckXKd;.................'cOXWWXXXKXWMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMXKNNOkxdoo:,,,,,,,,,,,,,,,,,,,,,,,,,'..       .lkdlllllccc:,cdc.        ...,lONMMMWXxokOo,.........'lOkdokXWNKNMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMNXKkddkKKOxc,,,,,,,,,,,,,,,,,,,,,,,,,,''.      .cxxxxxxxxdl,'.       ....,o0NWWWWWWWWWWMWKd;.....,ldxkkO0xdkNMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMWKkKN0odOXKd,',,,,,,,,,,,,,,,,,,,,,,,,,,'.      ';:::;,,,,'.      ......;loooooooooooooool:'...:OWMMWKxx0KXWMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMKdOWMXkodxl;,,,,,,,,,,,,,,,,,,,,,,,,,,'..    .,;;,,'''.     .........'''''''''''''''''..,cllkNMMMMNKXWMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMNKXKxoxXWKodd:,,,,,,,,,,,,,,,,,,,',,,,,,'..   .,;,'''.    ............................,cok00xokNMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMWXkxXWNXxc0WOl;,,,,,,,,,,,,,,,,,,,,,,,,,,,'.  .,,''.  ............................',cONXkodXKddXMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNKXNdoXNXXd:lc;,,,,,,,,,,,,,,,,,,,,,,,,,'...'.. ...........................';ck0ddXMMXdkWWNWMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNWNooKNWXldNNxc;,,,,,,,,,,,,,,,,,,,,,,,,,''............................';ckXNXNNXXNWNKXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMW0OWMMOlkXXNXd:dd:,,,,,,,,,,,,,,,,,,,,,,,'.......................,cook0xdxkO0XWNKKNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWkxXWWMMOlOXOkdll:,,,,,,,,,,,,,,,,,,'...................,ll;lKWKXWWK0Okdd0WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWMMWNN0cxWMWXXXd:doll:,,,,,,,,,,,,'..........,;;';dkkclXMXxodOXWMWKKWWNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXKNXodWMWX0klkNNNWxckd:d0Oooxkocclocoxdxkol0NdlXMMKlxWMWXkokWMMWNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMW00WXKNKodNMMMNodWXldXXXWMMOllxNXXWXNMXoxWKlkWWWOlOK0WMNXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNNN0xKMMMMOlOMMklOXWMMMN0xdoxXWXNMWdoXWdlKX0KO0XXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMW0kNMMXxOWMMMMNKKXKdOWKKWMOdKWXOXWWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWMMMMMWNXNNXWMNNWMWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// https://Newspaper.finance
contract N3WSCrowdsale is Ownable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    uint256 public immutable HARDCAP = 1000 ether;

    uint256 public NEWS_PER_ETH = 500;

    uint256 public immutable startTime;

    uint256 public immutable endTime;

    bool public fcfs;

    mapping(address => bool) public whitelists;

    mapping(address => uint256) public contributions;

    mapping(address => uint256) public balances;

    uint256 public weiRaised;

    bool public finalized;

    IERC20 public token;

    IReferrers public referrers;

    IRewardDistributionRecipient public liquidityLoop;

    IUniswapV2Router02 internal constant uniswapRouter = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

    address internal constant uniswapFactory = address(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);

    constructor(IERC20 _token, IReferrers _referrers, IRewardDistributionRecipient _liquidityLoop, uint256 _startTime, uint256 _endTime)
    public
    Ownable()
    {
        token = _token;
        referrers = _referrers;
        liquidityLoop = _liquidityLoop;
        startTime = _startTime;
        endTime = _endTime;
    }

    receive() payable external {
        _buyTokens(msg.sender);
    }

    function _buyTokens(address _beneficiary) internal {
        uint256 weiToHardcap = HARDCAP.sub(weiRaised);
        uint256 weiAmount = weiToHardcap < msg.value ? weiToHardcap : msg.value;

        _buyTokens(_beneficiary, weiAmount);

        uint256 refund = msg.value.sub(weiAmount);
        if (refund > 0) {
            payable(_beneficiary).transfer(refund);
        }
    }

    function _buyTokens(address _beneficiary, uint256 _amount) internal {
        require(isOpen(), "N3WSCrowdsale: sale is not open yet");
        require(!hasEnded(), "N3WSCrowdsale: sale is over, find me on Uniswap");
        require(isFcFs() || whitelists[_beneficiary], 
            "N3WSCrowdsale: sender is not whitelisted and not FCFS phase");

        weiRaised = weiRaised.add(_amount);
        contributions[_beneficiary] = contributions[_beneficiary].add(_amount);

        uint256 tokenAmount = _getTokenAmount(_amount);
        balances[_beneficiary] = balances[_beneficiary].add(tokenAmount);

        payable(owner()).transfer(_amount.div(2));
    }

    function getCurrentRate() public returns (uint256) {
        if (!isOpen()) {
            return 0;
        }

        uint256 rate = NEWS_PER_ETH;

        if (isReferrer(msg.sender)) {
            rate = rate.mul(105).div(100);
        }
        if (weiRaised < 100 ether) {
            return rate.mul(110).div(100);
        }
    
        uint256 bonus = (110e2 - ((weiRaised/1 ether) - 100))/100;
        return rate.mul(bonus).div(100);
    }

    function _getTokenAmount(uint256 weiAmount) internal returns (uint256) {
        uint256 currentRate = getCurrentRate();
        return currentRate.mul(weiAmount);
    }    

    function isReferrer(address _address) public returns (bool) {
        if (address(referrers) == address(0)) {
            return false;
        }
        return referrers.isReferrer(_address);
    }

    function addWhitelists(address[] calldata _addresses, bool _whitelisted) external onlyOwner {
        for (uint256 i = 0; i < _addresses.length; i++) {
            whitelists[_addresses[i]] = _whitelisted;
        }
    }

    function setLiquidityLoop(IRewardDistributionRecipient _liquidityLooop) external onlyOwner {
        liquidityLoop = _liquidityLooop;
    }    

    function setFcfs(bool _fcfs) external onlyOwner {
        fcfs = _fcfs;
    }

    function withdrawTokens(address _beneficiary) external {
        require(finalized, "N3WSCrowdsale: sale not finalized yet");
        uint256 tokenAmount = balances[_beneficiary];
        require(tokenAmount > 0, "N3WSCrowdsale: beneficiary is not due any tokens");

        balances[_beneficiary] = 0;
        token.safeTransferFrom(owner(), _beneficiary, tokenAmount);
    }

    function withdrawAfterSaleOnlyInCaseOfProblems() external onlyOwner {
        require(block.timestamp >= endTime + 48 hours, "N3WSCrowdsale: can only be done 48 hours after sale is over");
        require(!finalized, "N3WSCrowdsale: sale has already been finalized");
        payable(owner()).transfer(address(this).balance);
    }    

    function finalize() external virtual onlyOwner {
        require(hasEnded(), "N3WSCrowdsale: sale on-going");
        require(!finalized, "N3WSCrowdsale: already finalized");

        uint256 amountEthForUniswap = address(this).balance;
        uint256 amountTokensForUniswap = amountEthForUniswap.mul(NEWS_PER_ETH);

        token.safeTransferFrom(owner(), address(this), amountTokensForUniswap); // pre-approved by owner()
        token.approve(address(uniswapRouter), amountTokensForUniswap);
        uniswapRouter.addLiquidityETH
        { value: amountEthForUniswap }
        (
            address(token),
            amountTokensForUniswap,
            amountTokensForUniswap,
            amountEthForUniswap,
            address(this), // To send to liquidity loop
            now
        );

        // Lock all liquidity in the liquidity loop contract to distribute to crowdsale participants
        address uniswapV2Pair = UniswapV2Library.pairFor(uniswapFactory, address(token), address(uniswapRouter.WETH()));
        uint256 lpTokenBalance = IERC20(uniswapV2Pair).balanceOf(address(this));
        IERC20(uniswapV2Pair).transfer(address(liquidityLoop), lpTokenBalance);
        IRewardDistributionRecipient(liquidityLoop).notifyRewardAmount(lpTokenBalance);

        finalized = true;
    }

    function isOpen() public view returns (bool) {
        return block.timestamp >= startTime;
    }

    function isFcFs() public view returns (bool) {
        return fcfs;
    }

    function hasEnded() public view returns (bool) {
        return block.timestamp >= endTime || weiRaised >= HARDCAP;
    }    
}