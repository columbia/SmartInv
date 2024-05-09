pragma solidity 0.5.17;


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
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see {ERC20Detailed}.
 */

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

interface ICurveDeposit {
    function add_liquidity(uint[4] calldata uamounts, uint min_mint_amount) external;
    function remove_liquidity(uint amount, uint[4] calldata min_uamounts) external;
    function remove_liquidity_imbalance(uint[4] calldata uamounts, uint max_burn_amount) external;
    function remove_liquidity_one_coin(uint _token_amount, int128 i, uint min_uamount) external;
    function calc_withdraw_one_coin(uint _token_amount, int128 i) external view returns(uint);
}

interface ICurve {
    function add_liquidity(uint[4] calldata uamounts, uint min_mint_amount) external;
    function remove_liquidity_imbalance(uint[4] calldata uamounts, uint max_burn_amount) external;
    function remove_liquidity(uint amount, uint[4] calldata min_amounts) external;
    function calc_token_amount(uint[4] calldata inAmounts, bool deposit) external view returns(uint);
    function balances(int128 i) external view returns(uint);
    function get_virtual_price() external view returns(uint);
    function exchange(int128 i, int128 j, uint256 dx, uint256 min_dy) external;
    // for tests
    function mock_add_to_balance(uint[4] calldata amounts) external;
}

library Math {
    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow, so we distribute
        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
    }
}

interface ICore {
    function mint(uint dusdAmount, address account) external returns(uint usd);
    function redeem(uint dusdAmount, address account) external returns(uint usd);
    function dusdToUsd(uint _dusd, bool fee) external view returns(uint usd);
    function peaks(address peak) external view returns (uint,uint,uint8);
}

interface IPeak {
    function portfolioValue() external view returns(uint);
}

contract IController {
    function earn(address _token) external;
    function vaultWithdraw(IERC20 token, uint _shares) external;
    function withdraw(IERC20 token, uint amount) external;
    function getPricePerFullShare(address token) external view returns(uint);
}

contract Initializable {
    bool initialized = false;

    modifier notInitialized() {
        require(!initialized, "already initialized");
        initialized = true;
        _;
    }

    // Reserved storage space to allow for layout changes in the future.
    uint256[20] private _gap;

    function getStore(uint a) internal view returns(uint) {
        require(a < 20, "Not allowed");
        return _gap[a];
    }

    function setStore(uint a, uint val) internal {
        require(a < 20, "Not allowed");
        _gap[a] = val;
    }
}

contract OwnableProxy {
    bytes32 constant OWNER_SLOT = keccak256("proxy.owner");

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() internal {
        _transferOwnership(msg.sender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns(address _owner) {
        bytes32 position = OWNER_SLOT;
        assembly {
            _owner := sload(position)
        }
    }

    modifier onlyOwner() {
        require(isOwner(), "NOT_OWNER");
        _;
    }

    function isOwner() public view returns (bool) {
        return owner() == msg.sender;
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "OwnableProxy: new owner is the zero address");
        emit OwnershipTransferred(owner(), newOwner);
        bytes32 position = OWNER_SLOT;
        assembly {
            sstore(position, newOwner)
        }
    }
}

contract YVaultPeak is OwnableProxy, Initializable, IPeak {
    using SafeERC20 for IERC20;
    using SafeMath for uint;
    using Math for uint;

    string constant ERR_INSUFFICIENT_FUNDS = "INSUFFICIENT_FUNDS";
    uint constant MAX = 10000;

    uint min;
    uint redeemMultiplier;
    uint[4] feed; // unused for now but might need later

    ICore core;
    ICurve ySwap;
    IERC20 yCrv;
    IERC20 yUSD;

    IController controller;

    function initialize(IController _controller)
        public
        notInitialized
    {
        controller = _controller;
        // these need to be initialzed here, because the contract is used via a proxy
        core = ICore(0xE449Ca7d10b041255E7e989D158Bee355d8f88d3);
        ySwap = ICurve(0x45F783CCE6B7FF23B2ab2D70e416cdb7D6055f51);
        yCrv = IERC20(0xdF5e0e81Dff6FAF3A7e52BA697820c5e32D806A8);
        yUSD = IERC20(0x5dbcF33D8c2E976c6b560249878e6F1491Bca25c);
        _setParams(
            200, // 200.div(10000) implies to keep 2% of yCRV in the contract
            9998 // 9998.div(10000) implies a redeem fee of .02%
        );
    }

    function mintWithYcrv(uint inAmount) external returns(uint dusdAmount) {
        yCrv.safeTransferFrom(msg.sender, address(this), inAmount);
        dusdAmount = calcMintWithYcrv(inAmount);
        core.mint(dusdAmount, msg.sender);
        // best effort at keeping min.div(MAX) funds here
        uint farm = toFarm();
        if (farm > 0) {
            yCrv.safeTransfer(address(controller), farm);
            controller.earn(address(yCrv)); // this is acting like a callback
        }
    }

    // Sets minimum required on-hand to keep small withdrawals cheap
    function toFarm() internal view returns (uint) {
        (uint here, uint total) = yCrvDistribution();
        uint shouldBeHere = total.mul(min).div(MAX);
        if (here > shouldBeHere) {
            return here.sub(shouldBeHere);
        }
        return 0;
    }

    function yCrvDistribution() public view returns (uint here, uint total) {
        here = yCrv.balanceOf(address(this));
        total = yUSD.balanceOf(address(controller))
            .mul(controller.getPricePerFullShare(address(yCrv)))
            .div(1e18)
            .add(here);
    }

    function calcMintWithYcrv(uint inAmount) public view returns (uint dusdAmount) {
        return inAmount.mul(yCrvToUsd()).div(1e18);
    }

    function redeemInYcrv(uint dusdAmount, uint minOut) external returns(uint _yCrv) {
        core.redeem(dusdAmount, msg.sender);
        _yCrv = dusdAmount.mul(1e18).div(yCrvToUsd()).mul(redeemMultiplier).div(MAX);
        uint here = yCrv.balanceOf(address(this));
        if (here < _yCrv) {
            // withdraw only as much as needed from the vault
            uint _withdraw = _yCrv.sub(here).mul(1e18).div(controller.getPricePerFullShare(address(yCrv)));
            controller.vaultWithdraw(yCrv, _withdraw);
            _yCrv = yCrv.balanceOf(address(this));
        }
        require(_yCrv >= minOut, ERR_INSUFFICIENT_FUNDS);
        yCrv.safeTransfer(msg.sender, _yCrv);
    }

    function calcRedeemInYcrv(uint dusdAmount) public view returns (uint _yCrv) {
        _yCrv = dusdAmount.mul(1e18).div(yCrvToUsd()).mul(redeemMultiplier).div(MAX);
        (,uint total) = yCrvDistribution();
        return _yCrv.min(total);
    }

    function yCrvToUsd() public view returns (uint) {
        return ySwap.get_virtual_price();
    }

    // yUSD

    function mintWithYusd(uint inAmount) external {
        yUSD.safeTransferFrom(msg.sender, address(controller), inAmount);
        core.mint(calcMintWithYusd(inAmount), msg.sender);
    }

    function calcMintWithYusd(uint inAmount) public view returns (uint dusdAmount) {
        return inAmount.mul(yUSDToUsd()).div(1e18);
    }

    function redeemInYusd(uint dusdAmount, uint minOut) external {
        core.redeem(dusdAmount, msg.sender);
        uint r = dusdAmount.mul(1e18).div(yUSDToUsd()).mul(redeemMultiplier).div(MAX);
        // there should be no reason that this contracts has yUSD, however being safe doesn't hurt
        uint b = yUSD.balanceOf(address(this));
        if (b < r) {
            controller.withdraw(yUSD, r.sub(b));
            r = yUSD.balanceOf(address(this));
        }
        require(r >= minOut, ERR_INSUFFICIENT_FUNDS);
        yUSD.safeTransfer(msg.sender, r);
    }

    function calcRedeemInYusd(uint dusdAmount) public view returns (uint) {
        uint r = dusdAmount.mul(1e18).div(yUSDToUsd()).mul(redeemMultiplier).div(MAX);
        return r.min(
            yUSD.balanceOf(address(this))
            .add(yUSD.balanceOf(address(controller))));
    }

    function yUSDToUsd() public view returns (uint) {
        return controller.getPricePerFullShare(address(yCrv)) // # yCrv
            .mul(yCrvToUsd()) // USD price
            .div(1e18);
    }

    function portfolioValue() external view returns(uint) {
        (,uint total) = yCrvDistribution();
        return total.mul(yCrvToUsd()).div(1e18);
    }

    function vars() external view returns(
        address _core,
        address _ySwap,
        address _yCrv,
        address _yUSD,
        address _controller,
        uint _redeemMultiplier,
        uint _min
    ) {
        return(
            address(core),
            address(ySwap),
            address(yCrv),
            address(yUSD),
            address(controller),
            redeemMultiplier,
            min
        );
    }

    // Privileged methods

    function setParams(uint _min, uint _redeemMultiplier) external onlyOwner {
        _setParams(_min, _redeemMultiplier);
    }

    function _setParams(uint _min, uint _redeemMultiplier) internal {
        require(min <= MAX && redeemMultiplier <= MAX, "Invalid");
        min = _min;
        redeemMultiplier = _redeemMultiplier;
    }
}

contract YVaultZap {
    using SafeMath for uint;
    using SafeERC20 for IERC20;

    uint constant N_COINS = 4;
    string constant ERR_SLIPPAGE = "ERR_SLIPPAGE";

    uint[N_COINS] ZEROES = [uint(0),uint(0),uint(0),uint(0)];
    address[N_COINS] coins = [
        0x16de59092dAE5CcF4A1E6439D611fd0653f0Bd01, // ydai
        0xd6aD7a6750A7593E092a9B218d66C0A814a3436e, // yusdc
        0x83f798e925BcD4017Eb265844FDDAbb448f1707D, // yusdt
        0x73a052500105205d34Daf004eAb301916DA8190f // ytusd
    ];
    address[N_COINS] underlyingCoins = [
        0x6B175474E89094C44Da98b954EedeAC495271d0F, // dai
        0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, // usdc
        0xdAC17F958D2ee523a2206206994597C13D831ec7, // usdt
        0x0000000000085d4780B73119b644AE5ecd22b376 // tusd
    ];

    ICurveDeposit yDeposit = ICurveDeposit(0xbBC81d23Ea2c3ec7e56D39296F0cbB648873a5d3);
    ICurve ySwap = ICurve(0x45F783CCE6B7FF23B2ab2D70e416cdb7D6055f51);
    IERC20 yCrv = IERC20(0xdF5e0e81Dff6FAF3A7e52BA697820c5e32D806A8);
    IERC20 dusd = IERC20(0x5BC25f649fc4e26069dDF4cF4010F9f706c23831);
    YVaultPeak yVaultPeak;

    constructor (YVaultPeak _yVaultPeak) public {
        yVaultPeak = _yVaultPeak;
    }

    /**
    * @dev Mint DUSD
    * @param inAmounts Exact inAmounts in the same order as required by the curve pool
    * @param minDusdAmount Minimum DUSD to mint, used for capping slippage
    */
    function mint(uint[N_COINS] calldata inAmounts, uint minDusdAmount)
        external
        returns (uint dusdAmount)
    {
        address[N_COINS] memory _coins = underlyingCoins;
        for (uint i = 0; i < N_COINS; i++) {
            if (inAmounts[i] > 0) {
                IERC20(_coins[i]).safeTransferFrom(msg.sender, address(this), inAmounts[i]);
                IERC20(_coins[i]).safeApprove(address(yDeposit), inAmounts[i]);
            }
        }
        yDeposit.add_liquidity(inAmounts, 0);
        uint inAmount = yCrv.balanceOf(address(this));
        yCrv.safeApprove(address(yVaultPeak), 0);
        yCrv.safeApprove(address(yVaultPeak), inAmount);
        dusdAmount = yVaultPeak.mintWithYcrv(inAmount);
        require(dusdAmount >= minDusdAmount, ERR_SLIPPAGE);
        dusd.safeTransfer(msg.sender, dusdAmount);
    }

    function calcMint(uint[N_COINS] memory inAmounts)
        public view
        returns (uint dusdAmount)
    {
        for(uint i = 0; i < N_COINS; i++) {
            inAmounts[i] = inAmounts[i].mul(1e18).div(yERC20(coins[i]).getPricePerFullShare());
        }
        uint _yCrv = ySwap.calc_token_amount(inAmounts, true /* deposit */);
        return yVaultPeak.calcMintWithYcrv(_yCrv);
    }

    /**
    * @dev Redeem DUSD
    * @param dusdAmount Exact dusdAmount to burn
    * @param minAmounts Min expected amounts to cap slippage
    */
    function redeem(uint dusdAmount, uint[N_COINS] calldata minAmounts)
        external
    {
        dusd.safeTransferFrom(msg.sender, address(this), dusdAmount);
        uint r = yVaultPeak.redeemInYcrv(dusdAmount, 0);
        yCrv.safeApprove(address(yDeposit), r);
        yDeposit.remove_liquidity(r, ZEROES);
        address[N_COINS] memory _coins = underlyingCoins;
        uint toTransfer;
        for (uint i = 0; i < N_COINS; i++) {
            toTransfer = IERC20(_coins[i]).balanceOf(address(this));
            require(toTransfer >= minAmounts[i], ERR_SLIPPAGE);
            IERC20(_coins[i]).safeTransfer(msg.sender, toTransfer);
        }
    }

    function calcRedeem(uint dusdAmount)
        public view
        returns (uint[N_COINS] memory amounts)
    {
        uint _yCrv = yVaultPeak.calcRedeemInYcrv(dusdAmount);
        uint totalSupply = yCrv.totalSupply();
        for(uint i = 0; i < N_COINS; i++) {
            amounts[i] = ySwap.balances(int128(i))
                .mul(_yCrv)
                .div(totalSupply)
                .mul(yERC20(coins[i]).getPricePerFullShare())
                .div(1e18);
        }
    }

    function redeemInSingleCoin(uint dusdAmount, uint i, uint minOut)
        external
    {
        dusd.safeTransferFrom(msg.sender, address(this), dusdAmount);
        uint r = yVaultPeak.redeemInYcrv(dusdAmount, 0);
        yCrv.safeApprove(address(yDeposit), r);
        yDeposit.remove_liquidity_one_coin(r, int128(i), minOut); // checks for slippage
        IERC20 coin = IERC20(underlyingCoins[i]);
        uint toTransfer = coin.balanceOf(address(this));
        coin.safeTransfer(msg.sender, toTransfer);
    }

    function calcRedeemInSingleCoin(uint dusdAmount, uint i)
        public view
        returns(uint)
    {
        uint _yCrv = yVaultPeak.calcRedeemInYcrv(dusdAmount);
        return yDeposit.calc_withdraw_one_coin(_yCrv, int128(i));
    }
}

interface yERC20 {
    function getPricePerFullShare() external view returns(uint);
}