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
    function _msgSender() internal virtual view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal virtual view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

pragma solidity ^0.6.0;

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

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() internal {
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
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

pragma solidity ^0.6.0;

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

pragma solidity ^0.6.0;

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
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
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
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

pragma solidity ^0.6.2;

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
        assembly {
            size := extcodesize(account)
        }
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
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{value: amount}("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
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
    function functionCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
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
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return
            functionCallWithValue(
                target,
                data,
                value,
                "Address: low-level call with value failed"
            );
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(
            address(this).balance >= value,
            "Address: insufficient balance for call"
        );
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(
        address target,
        bytes memory data,
        uint256 weiValue,
        string memory errorMessage
    ) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{value: weiValue}(
            data
        );
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

pragma solidity ^0.6.0;

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
        _callOptionalReturn(
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
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
        );
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
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
        _callOptionalReturn(
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
        _callOptionalReturn(
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
        _callOptionalReturn(
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
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(
            data,
            "SafeERC20: low-level call failed"
        );
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

pragma solidity >=0.6.0;

/**
 * @title Roles
 * @dev Library for managing addresses assigned to a Role.
 */
library Roles {
    struct Role {
        mapping(address => bool) bearer;
    }

    /**
     * @dev Give an account access to this role.
     */
    function add(Role storage role, address account) internal {
        require(!has(role, account), "Roles: account already has role");
        role.bearer[account] = true;
    }

    /**
     * @dev Remove an account's access to this role.
     */
    function remove(Role storage role, address account) internal {
        require(has(role, account), "Roles: account does not have role");
        role.bearer[account] = false;
    }

    /**
     * @dev Check if an account has this role.
     * @return bool
     */
    function has(Role storage role, address account)
        internal
        view
        returns (bool)
    {
        require(account != address(0), "Roles: account is the zero address");
        return role.bearer[account];
    }
}

contract MinterRole is Context {
    using Roles for Roles.Role;

    event MinterAdded(address indexed account);
    event MinterRemoved(address indexed account);

    Roles.Role private _minters;

    constructor() internal {
        _addMinter(_msgSender());
    }

    modifier onlyMinter() {
        require(
            isMinter(_msgSender()),
            "MinterRole: caller does not have the Minter role"
        );
        _;
    }

    function isMinter(address account) public view returns (bool) {
        return _minters.has(account);
    }

    function addMinter(address account) public onlyMinter {
        _addMinter(account);
    }

    function renounceMinter() public {
        _removeMinter(_msgSender());
    }

    function _addMinter(address account) internal {
        _minters.add(account);
        emit MinterAdded(account);
    }

    function _removeMinter(address account) internal {
        _minters.remove(account);
        emit MinterRemoved(account);
    }
}

contract CanTransferRole is Context {
    using Roles for Roles.Role;

    event CanTransferAdded(address indexed account);
    event CanTransferRemoved(address indexed account);

    Roles.Role private _canTransfer;

    constructor() internal {
        _addCanTransfer(_msgSender());
    }

    modifier onlyCanTransfer() {
        require(
            canTransfer(_msgSender()),
            "CanTransferRole: caller does not have the CanTransfer role"
        );
        _;
    }

    function canTransfer(address account) public view returns (bool) {
        return _canTransfer.has(account);
    }

    function addCanTransfer(address account) public onlyCanTransfer {
        _addCanTransfer(account);
    }

    function renounceCanTransfer() public {
        _removeCanTransfer(_msgSender());
    }

    function _addCanTransfer(address account) internal {
        _canTransfer.add(account);
        emit CanTransferAdded(account);
    }

    function _removeCanTransfer(address account) internal {
        _canTransfer.remove(account);
        emit CanTransferRemoved(account);
    }
}

contract ToshiCoinNonTradable is Ownable, MinterRole, CanTransferRole {
    using SafeMath for uint256;

    event Transfer(address indexed from, address indexed to, uint256 value);

    mapping(address => uint256) private _balances;

    string public name = "ToshiCoin - Non Tradable";
    string public symbol = "ToshiCoin";
    uint8 public decimals = 18;

    uint256 public totalSupply;
    uint256 public totalClaimed;
    uint256 public totalMinted;

    uint256 public remainingToshiCoinForSale = 4000 * (1e18);
    uint256 public priceInTOSHI = 3;

    IERC20 public toshi;
    address public toshiTreasury;

    constructor(IERC20 _toshi, address _toshiTreasury) public {
        toshi = _toshi;
        toshiTreasury = _toshiTreasury;
    }

    function addClaimed(uint256 amount) internal {
        totalClaimed = totalClaimed.add(amount);
    }

    function addMinted(uint256 amount) internal {
        totalMinted = totalMinted.add(amount);
    }

    function setRemainingToshiCoinForSale(uint256 _remainingToshiCoinForSale)
        external
        onlyMinter
    {
        remainingToshiCoinForSale = _remainingToshiCoinForSale;
    }

    function setPriceInToshi(uint256 _priceInTOSHI) external onlyMinter {
        priceInTOSHI = _priceInTOSHI;
    }

    function setToshiTreasury(address _toshiTreasury) external onlyMinter {
        toshiTreasury = _toshiTreasury;
    }

    /**
     * @dev Anyone can purchase ToshiCoin for TOSHI until it is sold out.
     */
    function purchase(uint256 amount) external {
        uint256 price = priceInTOSHI.mul(amount);
        uint256 balance = toshi.balanceOf(msg.sender);

        require(balance >= price, "ToshiCoin: Not enough TOSHI in wallet.");
        require(
            remainingToshiCoinForSale >= amount,
            "ToshiCoin: Not enough ToshiCoin for sale."
        );

        safeToshiTransferFrom(msg.sender, toshiTreasury, price);

        remainingToshiCoinForSale = remainingToshiCoinForSale.sub(amount);

        _mint(msg.sender, amount);
        addMinted(amount);
    }

    /**
     * @dev Claiming is white-listed to specific minter addresses for now to limit transfers.
     */
    function claim(address to, uint256 amount) public onlyCanTransfer {
        transfer(to, amount);
        addClaimed(amount);
    }

    /**
     * @dev Transferring is white-listed to specific minter addresses for now.
     */
    function transfer(address to, uint256 amount)
        public
        onlyCanTransfer
        returns (bool)
    {
        require(
            amount <= _balances[msg.sender],
            "ToshiCoin: Cannot transfer more than balance"
        );

        _balances[msg.sender] = _balances[msg.sender].sub(amount);
        _balances[to] = _balances[to].add(amount);

        emit Transfer(msg.sender, to, amount);

        return true;
    }

    /**
     * @dev Transferring is white-listed to specific minter addresses for now.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public onlyCanTransfer returns (bool) {
        require(
            amount <= _balances[from],
            "ToshiCoin: Cannot transfer more than balance"
        );

        _balances[from] = _balances[from].sub(amount);
        _balances[to] = _balances[to].add(amount);

        emit Transfer(from, to, amount);

        return true;
    }

    /**
     * @dev Gets the balance of the specified address.
     */
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev Minting is white-listed to specific minter addresses for now.
     */
    function mint(address to, uint256 amount) public onlyMinter {
        _mint(to, amount);
        addMinted(amount);
    }

    /**
     * @dev Burning is white-listed to specific minter addresses for now.
     */
    function burn(address from, uint256 value) public onlyCanTransfer {
        require(
            _balances[from] >= value,
            "ToshiCoin: Cannot burn more than the address balance"
        );

        _burn(from, value);
    }

    /**
     * @dev Internal function that creates an amount of the token and assigns it to an account.
     * This encapsulates the modification of balances such that the proper events are emitted.
     * @param to The account that will receive the created tokens.
     * @param amount The amount that will be created.
     */
    function _mint(address to, uint256 amount) internal {
        require(to != address(0), "ToshiCoin: mint to the zero address");

        totalSupply = totalSupply.add(amount);
        _balances[to] = _balances[to].add(amount);

        emit Transfer(address(0), to, amount);
    }

    /**
     * @dev Internal function that destroys an amount of the token of a given address.
     * @param from The account whose tokens will be destroyed.
     * @param amount The amount that will be destroyed.
     */
    function _burn(address from, uint256 amount) internal {
        require(from != address(0), "ToshiCoin: burn from the zero address");

        totalSupply = totalSupply.sub(amount);
        _balances[from] = _balances[from].sub(amount);

        emit Transfer(from, address(0), amount);
    }

    /**
     * @dev Safe token transfer from to prevent over-transfers.
     */
    function safeToshiTransferFrom(
        address from,
        address to,
        uint256 amount
    ) internal {
        uint256 tokenBalance = toshi.balanceOf(address(from));
        uint256 transferAmount = amount > tokenBalance ? tokenBalance : amount;

        toshi.transferFrom(from, to, transferAmount);
    }
}

pragma solidity >=0.6.0;

contract ToshiCoinFarm is Ownable {
    using SafeMath for uint256;

    struct UserInfo {
        uint256 amountInPool;
        uint256 coinsReceivedToDate;
        /*
         *  At any point in time, the amount of ToshiCoin earned by a user waiting to be claimed is:
         *
         *    Pending claim = (user.amountInPool * pool.coinsEarnedPerToken) - user.coinsReceivedToDate
         *
         *  Whenever a user deposits or withdraws tokens to a pool, the following occurs:
         *   1. The pool's `coinsEarnedPerToken` is rebalanced to account for the new shares in the pool.
         *   2. The `lastRewardBlock` is updated to the latest block.
         *   3. The user receives the pending claim sent to their address.
         *   4. The user's `amountInPool` and `coinsReceivedToDate` get updated for this pool.
         */
    }

    struct PoolInfo {
        IERC20 token;
        uint256 lastUpdateTime;
        uint256 coinsPerDay;
        uint256 coinsEarnedPerToken;
    }

    PoolInfo[] public poolInfo;

    mapping(uint256 => mapping(address => UserInfo)) public userInfo;
    mapping(address => uint256) public tokenPoolIds;

    ToshiCoinNonTradable public ToshiCoin;

    event Deposit(address indexed user, uint256 indexed poolId, uint256 amount);
    event Withdraw(
        address indexed user,
        uint256 indexed poolId,
        uint256 amount
    );
    event EmergencyWithdraw(
        address indexed user,
        uint256 indexed poolId,
        uint256 amount
    );

    constructor(ToshiCoinNonTradable toshiCoinAddress) public {
        ToshiCoin = toshiCoinAddress;
    }

    function poolLength() external view returns (uint256) {
        return poolInfo.length;
    }

    function pendingCoins(uint256 poolId, address user)
        public
        view
        returns (uint256)
    {
        PoolInfo storage pool = poolInfo[poolId];
        UserInfo storage user = userInfo[poolId][user];

        uint256 tokenSupply = pool.token.balanceOf(address(this));
        uint256 coinsEarnedPerToken = pool.coinsEarnedPerToken;

        if (block.timestamp > pool.lastUpdateTime && tokenSupply > 0) {
            uint256 pendingCoins = block
                .timestamp
                .sub(pool.lastUpdateTime)
                .mul(pool.coinsPerDay)
                .div(86400);

            coinsEarnedPerToken = coinsEarnedPerToken.add(
                pendingCoins.mul(1e18).div(tokenSupply)
            );
        }

        return
            user.amountInPool.mul(coinsEarnedPerToken).div(1e18).sub(
                user.coinsReceivedToDate
            );
    }

    function totalPendingCoins(address user) public view returns (uint256) {
        uint256 total = 0;
        uint256 length = poolInfo.length;

        for (uint256 poolId = 0; poolId < length; ++poolId) {
            total = total.add(pendingCoins(poolId, user));
        }

        return total;
    }

    /**
     * @dev Add new pool to the farm. Cannot add the same token more than once.
     */
    function addPool(IERC20 token, uint256 _coinsPerDay) public onlyOwner {
        require(
            tokenPoolIds[address(token)] == 0,
            "ToshiCoinFarm: Added duplicate token pool"
        );
        require(
            address(token) != address(ToshiCoin),
            "ToshiCoinFarm: Cannot add ToshiCoin pool"
        );

        poolInfo.push(
            PoolInfo({
                token: token,
                coinsPerDay: _coinsPerDay,
                lastUpdateTime: block.timestamp,
                coinsEarnedPerToken: 0
            })
        );

        tokenPoolIds[address(token)] = poolInfo.length;
    }

    function setCoinsPerDay(uint256 poolId, uint256 amount) public onlyOwner {
        require(amount >= 0, "ToshiCoinFarm: Coins per day cannot be negative");

        updatePool(poolId);

        poolInfo[poolId].coinsPerDay = amount;
    }

    /**
     * @dev Claim all pending rewards in all pools.
     */
    function claimAll(uint256[] memory poolIds) public {
        uint256 length = poolInfo.length;

        for (uint256 poolId = 0; poolId < length; poolId++) {
            withdraw(poolIds[poolId], 0);
        }
    }

    /**
     * @dev Update pending rewards in all pools.
     */
    function updateAllPools() public {
        uint256 length = poolInfo.length;

        for (uint256 poolId = 0; poolId < length; poolId++) {
            updatePool(poolId);
        }
    }

    /**
     * @dev Update pending rewards for a pool.
     */
    function updatePool(uint256 poolId) public {
        PoolInfo storage pool = poolInfo[poolId];

        if (block.timestamp <= pool.lastUpdateTime) {
            return;
        }

        uint256 tokenSupply = pool.token.balanceOf(address(this));

        if (pool.coinsPerDay == 0 || tokenSupply == 0) {
            pool.lastUpdateTime = block.timestamp;
            return;
        }

        uint256 pendingCoins = block
            .timestamp
            .sub(pool.lastUpdateTime)
            .mul(pool.coinsPerDay)
            .div(86400);

        ToshiCoin.mint(address(this), pendingCoins);

        pool.lastUpdateTime = block.timestamp;
        pool.coinsEarnedPerToken = pool.coinsEarnedPerToken.add(
            pendingCoins.mul(1e18).div(tokenSupply)
        );
    }

    /**
     * @dev Deposit tokens into a pool and claim pending reward.
     */
    function deposit(uint256 poolId, uint256 amount) public {
        require(
            amount > 0,
            "ToshiCoinFarm: Cannot deposit non-positive amount into pool"
        );

        PoolInfo storage pool = poolInfo[poolId];
        UserInfo storage user = userInfo[poolId][msg.sender];

        updatePool(poolId);

        uint256 pending = user
            .amountInPool
            .mul(pool.coinsEarnedPerToken)
            .div(1e18)
            .sub(user.coinsReceivedToDate);

        if (pending > 0) {
            safeToshiCoinClaim(msg.sender, pending);
        }

        user.amountInPool = user.amountInPool.add(amount);
        user.coinsReceivedToDate = user
            .amountInPool
            .mul(pool.coinsEarnedPerToken)
            .div(1e18);

        safePoolTransferFrom(msg.sender, address(this), amount, pool);

        emit Deposit(msg.sender, poolId, amount);
    }

    /**
     * @dev Withdraw tokens from a pool and claim pending reward.
     */
    function withdraw(uint256 poolId, uint256 amount) public {
        PoolInfo storage pool = poolInfo[poolId];
        UserInfo storage user = userInfo[poolId][msg.sender];

        require(
            user.amountInPool >= amount,
            "ToshiCoinFarm: User does not have enough funds to withdraw from this pool"
        );

        updatePool(poolId);

        uint256 pending = user
            .amountInPool
            .mul(pool.coinsEarnedPerToken)
            .div(1e18)
            .sub(user.coinsReceivedToDate);

        if (pending > 0) {
            safeToshiCoinClaim(msg.sender, pending);
        }

        user.amountInPool = user.amountInPool.sub(amount);
        user.coinsReceivedToDate = user
            .amountInPool
            .mul(pool.coinsEarnedPerToken)
            .div(1e18);

        if (amount > 0) {
            safePoolTransfer(msg.sender, amount, pool);
        }

        emit Withdraw(msg.sender, poolId, amount);
    }

    /**
     * @dev Emergency withdraw withdraws funds without claiming rewards.
     *      This should only be used in emergencies.
     */
    function emergencyWithdraw(uint256 poolId) public {
        PoolInfo storage pool = poolInfo[poolId];
        UserInfo storage user = userInfo[poolId][msg.sender];

        require(
            user.amountInPool > 0,
            "ToshiCoinFarm: User has no funds to withdraw from this pool"
        );

        uint256 amount = user.amountInPool;

        user.amountInPool = 0;
        user.coinsReceivedToDate = 0;

        safePoolTransfer(msg.sender, amount, pool);

        emit EmergencyWithdraw(msg.sender, poolId, amount);
    }

    /**
     * @dev Safe ToshiCoin transfer to prevent over-transfers.
     */
    function safeToshiCoinClaim(address to, uint256 amount) internal {
        uint256 coinsBalance = ToshiCoin.balanceOf(address(this));
        uint256 claimAmount = amount > coinsBalance ? coinsBalance : amount;

        ToshiCoin.claim(to, claimAmount);
    }

    /**
     * @dev Safe pool token transfer to prevent over-transfers.
     */
    function safePoolTransfer(
        address to,
        uint256 amount,
        PoolInfo storage pool
    ) internal {
        uint256 tokenBalance = pool.token.balanceOf(address(this));
        uint256 transferAmount = amount > tokenBalance ? tokenBalance : amount;

        pool.token.transfer(to, transferAmount);
    }

    /**
     * @dev Safe pool token transfer from to prevent over-transfers.
     */
    function safePoolTransferFrom(
        address from,
        address to,
        uint256 amount,
        PoolInfo storage pool
    ) internal {
        uint256 tokenBalance = pool.token.balanceOf(from);
        uint256 transferAmount = amount > tokenBalance ? tokenBalance : amount;

        pool.token.transferFrom(from, to, transferAmount);
    }
}