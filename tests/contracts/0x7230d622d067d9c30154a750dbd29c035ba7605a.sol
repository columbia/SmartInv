// The software and documentation available in this repository (the "Software") is protected by copyright law and accessible pursuant to the license set forth below. Copyright © 2020 MRTB Ltd. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person or organization obtaining the Software (the “Licensee”) to privately study, review, and analyze the Software. Licensee shall not use the Software for any other purpose. Licensee shall not modify, transfer, assign, share, or sub-license the Software or any derivative works of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND NON-INFRINGEMENT. IN NO EVENT SHALL THE COPYRIGHT HOLDERS BE LIABLE FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT, OR OTHERWISE, ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE.

pragma solidity 0.5.15;
pragma experimental ABIEncoderV2;


library LibMathSigned {
    int256 private constant _WAD = 10 ** 18;
    int256 private constant _INT256_MIN = -2 ** 255;

    uint8 private constant FIXED_DIGITS = 18;
    int256 private constant FIXED_1 = 10 ** 18;
    int256 private constant FIXED_E = 2718281828459045235;
    uint8 private constant LONGER_DIGITS = 36;
    int256 private constant LONGER_FIXED_LOG_E_1_5 = 405465108108164381978013115464349137;
    int256 private constant LONGER_FIXED_1 = 10 ** 36;
    int256 private constant LONGER_FIXED_LOG_E_10 = 2302585092994045684017991454684364208;


    function WAD() internal pure returns (int256) {
        return _WAD;
    }

    // additive inverse
    function neg(int256 a) internal pure returns (int256) {
        return sub(int256(0), a);
    }

    /**
     * @dev Multiplies two signed integers, reverts on overflow
     * see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/math/SignedSafeMath.sol#L13
     */
    function mul(int256 a, int256 b) internal pure returns (int256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }
        require(!(a == -1 && b == _INT256_MIN), "wmultiplication overflow");

        int256 c = a * b;
        require(c / a == b, "wmultiplication overflow");

        return c;
    }

    /**
     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
     * see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/math/SignedSafeMath.sol#L32
     */
    function div(int256 a, int256 b) internal pure returns (int256) {
        require(b != 0, "wdivision by zero");
        require(!(b == -1 && a == _INT256_MIN), "wdivision overflow");

        int256 c = a / b;

        return c;
    }

    /**
     * @dev Subtracts two signed integers, reverts on overflow.
     * see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/math/SignedSafeMath.sol#L44
     */
    function sub(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a - b;
        require((b >= 0 && c <= a) || (b < 0 && c > a), "subtraction overflow");

        return c;
    }

    /**
     * @dev Adds two signed integers, reverts on overflow.
     * see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/math/SignedSafeMath.sol#L54
     */
    function add(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a + b;
        require((b >= 0 && c >= a) || (b < 0 && c < a), "addition overflow");

        return c;
    }

    function wmul(int256 x, int256 y) internal pure returns (int256 z) {
        z = roundHalfUp(mul(x, y), _WAD) / _WAD;
    }

    // solium-disable-next-line security/no-assign-params
    function wdiv(int256 x, int256 y) internal pure returns (int256 z) {
        if (y < 0) {
            y = -y;
            x = -x;
        }
        z = roundHalfUp(mul(x, _WAD), y) / y;
    }

    // solium-disable-next-line security/no-assign-params
    function wfrac(int256 x, int256 y, int256 z) internal pure returns (int256 r) {
        int256 t = mul(x, y);
        if (z < 0) {
            z = neg(z);
            t = neg(t);
        }
        r = roundHalfUp(t, z) / z;
    }

    function min(int256 x, int256 y) internal pure returns (int256) {
        return x <= y ? x : y;
    }

    function max(int256 x, int256 y) internal pure returns (int256) {
        return x >= y ? x : y;
    }

    // see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/utils/SafeCast.sol#L103
    function toUint256(int256 x) internal pure returns (uint256) {
        require(x >= 0, "int overflow");
        return uint256(x);
    }

    // x ^ n
    // NOTE: n is a normal integer, do not shift 18 decimals
    // solium-disable-next-line security/no-assign-params
    function wpowi(int256 x, int256 n) internal pure returns (int256 z) {
        require(n >= 0, "wpowi only supports n >= 0");
        z = n % 2 != 0 ? x : _WAD;

        for (n /= 2; n != 0; n /= 2) {
            x = wmul(x, x);

            if (n % 2 != 0) {
                z = wmul(z, x);
            }
        }
    }

    // ROUND_HALF_UP rule helper. You have to call roundHalfUp(x, y) / y to finish the rounding operation
    // 0.5 ≈ 1, 0.4 ≈ 0, -0.5 ≈ -1, -0.4 ≈ 0
    function roundHalfUp(int256 x, int256 y) internal pure returns (int256) {
        require(y > 0, "roundHalfUp only supports y > 0");
        if (x >= 0) {
            return add(x, y / 2);
        }
        return sub(x, y / 2);
    }

    // solium-disable-next-line security/no-assign-params
    function wln(int256 x) internal pure returns (int256) {
        require(x > 0, "logE of negative number");
        require(x <= 10000000000000000000000000000000000000000, "logE only accepts v <= 1e22 * 1e18"); // in order to prevent using safe-math
        int256 r = 0;
        uint8 extraDigits = LONGER_DIGITS - FIXED_DIGITS;
        int256 t = int256(uint256(10)**uint256(extraDigits));

        while (x <= FIXED_1 / 10) {
            x = x * 10;
            r -= LONGER_FIXED_LOG_E_10;
        }
        while (x >= 10 * FIXED_1) {
            x = x / 10;
            r += LONGER_FIXED_LOG_E_10;
        }
        while (x < FIXED_1) {
            x = wmul(x, FIXED_E);
            r -= LONGER_FIXED_1;
        }
        while (x > FIXED_E) {
            x = wdiv(x, FIXED_E);
            r += LONGER_FIXED_1;
        }
        if (x == FIXED_1) {
            return roundHalfUp(r, t) / t;
        }
        if (x == FIXED_E) {
            return FIXED_1 + roundHalfUp(r, t) / t;
        }
        x *= t;

        //               x^2   x^3   x^4
        // Ln(1+x) = x - --- + --- - --- + ...
        //                2     3     4
        // when -1 < x < 1, O(x^n) < ε => when n = 36, 0 < x < 0.316
        //
        //                    2    x           2    x          2    x
        // Ln(a+x) = Ln(a) + ---(------)^1  + ---(------)^3 + ---(------)^5 + ...
        //                    1   2a+x         3   2a+x        5   2a+x
        //
        // Let x = v - a
        //                  2   v-a         2   v-a        2   v-a
        // Ln(v) = Ln(a) + ---(-----)^1  + ---(-----)^3 + ---(-----)^5 + ...
        //                  1   v+a         3   v+a        5   v+a
        // when n = 36, 1 < v < 3.423
        r = r + LONGER_FIXED_LOG_E_1_5;
        int256 a1_5 = (3 * LONGER_FIXED_1) / 2;
        int256 m = (LONGER_FIXED_1 * (x - a1_5)) / (x + a1_5);
        r = r + 2 * m;
        int256 m2 = (m * m) / LONGER_FIXED_1;
        uint8 i = 3;
        while (true) {
            m = (m * m2) / LONGER_FIXED_1;
            r = r + (2 * m) / int256(i);
            i += 2;
            if (i >= 3 + 2 * FIXED_DIGITS) {
                break;
            }
        }
        return roundHalfUp(r, t) / t;
    }

    // Log(b, x)
    function logBase(int256 base, int256 x) internal pure returns (int256) {
        return wdiv(wln(x), wln(base));
    }

    function ceil(int256 x, int256 m) internal pure returns (int256) {
        require(x >= 0, "ceil need x >= 0");
        require(m > 0, "ceil need m > 0");
        return (sub(add(x, m), 1) / m) * m;
    }
}

library LibMathUnsigned {
    uint256 private constant _WAD = 10**18;
    uint256 private constant _POSITIVE_INT256_MAX = 2**255 - 1;

    function WAD() internal pure returns (uint256) {
        return _WAD;
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on overflow.
     * see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/math/SafeMath.sol#L26
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "Unaddition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     * see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/math/SafeMath.sol#L55
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "Unsubtraction overflow");
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     * see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/math/SafeMath.sol#L71
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "Unmultiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     * see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/math/SafeMath.sol#L111
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "Undivision by zero");
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    function wmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = add(mul(x, y), _WAD / 2) / _WAD;
    }

    function wdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = add(mul(x, _WAD), y / 2) / y;
    }

    function wfrac(uint256 x, uint256 y, uint256 z) internal pure returns (uint256 r) {
        r = mul(x, y) / z;
    }

    function min(uint256 x, uint256 y) internal pure returns (uint256) {
        return x <= y ? x : y;
    }

    function max(uint256 x, uint256 y) internal pure returns (uint256) {
        return x >= y ? x : y;
    }

    function toInt256(uint256 x) internal pure returns (int256) {
        require(x <= _POSITIVE_INT256_MAX, "uint256 overflow");
        return int256(x);
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     * see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/math/SafeMath.sol#L146
     */
    function mod(uint256 x, uint256 m) internal pure returns (uint256) {
        require(m != 0, "mod by zero");
        return x % m;
    }

    function ceil(uint256 x, uint256 m) internal pure returns (uint256) {
        require(m > 0, "ceil need m > 0");
        return (sub(add(x, m), 1) / m) * m;
    }
}

library LibTypes {
    enum Side {FLAT, SHORT, LONG}

    enum Status {NORMAL, EMERGENCY, SETTLED}

    function counterSide(Side side) internal pure returns (Side) {
        if (side == Side.LONG) {
            return Side.SHORT;
        } else if (side == Side.SHORT) {
            return Side.LONG;
        }
        return side;
    }

    //////////////////////////////////////////////////////////////////////////
    // Perpetual
    //////////////////////////////////////////////////////////////////////////
    struct PerpGovernanceConfig {
        uint256 initialMarginRate;
        uint256 maintenanceMarginRate;
        uint256 liquidationPenaltyRate;
        uint256 penaltyFundRate;
        int256 takerDevFeeRate;
        int256 makerDevFeeRate;
        uint256 lotSize;
        uint256 tradingLotSize;
    }

    struct MarginAccount {
        LibTypes.Side side;
        uint256 size;
        uint256 entryValue;
        int256 entrySocialLoss;
        int256 entryFundingLoss;
        int256 cashBalance;
    }

    //////////////////////////////////////////////////////////////////////////
    // AMM
    //////////////////////////////////////////////////////////////////////////
    struct AMMGovernanceConfig {
        uint256 poolFeeRate;
        uint256 poolDevFeeRate;
        int256 emaAlpha;
        uint256 updatePremiumPrize;
        int256 markPremiumLimit;
        int256 fundingDampener;
    }

    struct FundingState {
        uint256 lastFundingTime;
        int256 lastPremium;
        int256 lastEMAPremium;
        uint256 lastIndexPrice;
        int256 accumulatedFundingPerContract;
    }
}

interface IPriceFeeder {
    function price() external view returns (uint256 lastPrice, uint256 lastTimestamp);
}

interface IAMM {
    function shareTokenAddress() external view returns (address);

    function indexPrice() external view returns (uint256 price, uint256 timestamp);

    function positionSize() external returns (uint256);

    function lastFundingState() external view returns (LibTypes.FundingState memory);

    function currentFundingRate() external returns (int256);

    function currentFundingState() external returns (LibTypes.FundingState memory);

    function lastFundingRate() external view returns (int256);

    function getGovernance() external view returns (LibTypes.AMMGovernanceConfig memory);

    function perpetualProxy() external view returns (IPerpetual);

    function currentMarkPrice() external returns (uint256);

    function currentAvailableMargin() external returns (uint256);

    function currentPremiumRate() external returns (int256);

    function currentFairPrice() external returns (uint256);

    function currentPremium() external returns (int256);

    function currentAccumulatedFundingPerContract() external returns (int256);

    function updateIndex() external;

    function createPool(uint256 amount) external;

    function settleShare(uint256 shareAmount) external;

    function buy(uint256 amount, uint256 limitPrice, uint256 deadline) external returns (uint256);

    function sell(uint256 amount, uint256 limitPrice, uint256 deadline) external returns (uint256);

    function buyFromWhitelisted(address trader, uint256 amount, uint256 limitPrice, uint256 deadline)
        external
        returns (uint256);

    function sellFromWhitelisted(address trader, uint256 amount, uint256 limitPrice, uint256 deadline)
        external
        returns (uint256);

    function buyFrom(address trader, uint256 amount, uint256 limitPrice, uint256 deadline) external returns (uint256);

    function sellFrom(address trader, uint256 amount, uint256 limitPrice, uint256 deadline) external returns (uint256);

    function depositAndBuy(
        uint256 depositAmount,
        uint256 tradeAmount,
        uint256 limitPrice,
        uint256 deadline
    ) external payable;

    function depositAndSell(
        uint256 depositAmount,
        uint256 tradeAmount,
        uint256 limitPrice,
        uint256 deadline
    ) external payable;

    function buyAndWithdraw(
        uint256 tradeAmount,
        uint256 limitPrice,
        uint256 deadline,
        uint256 withdrawAmount
    ) external;

    function sellAndWithdraw(
        uint256 tradeAmount,
        uint256 limitPrice,
        uint256 deadline,
        uint256 withdrawAmount
    ) external;

    function depositAndAddLiquidity(uint256 depositAmount, uint256 amount) external payable;
}

interface IPerpetual {
    function devAddress() external view returns (address);

    function getMarginAccount(address trader) external view returns (LibTypes.MarginAccount memory);

    function getGovernance() external view returns (LibTypes.PerpGovernanceConfig memory);

    function status() external view returns (LibTypes.Status);

    function paused() external view returns (bool);

    function withdrawDisabled() external view returns (bool);

    function settlementPrice() external view returns (uint256);

    function globalConfig() external view returns (address);

    function collateral() external view returns (address);

    function amm() external view returns (IAMM);

    function totalSize(LibTypes.Side side) external view returns (uint256);

    function markPrice() external returns (uint256);

    function socialLossPerContract(LibTypes.Side side) external view returns (int256);

    function availableMargin(address trader) external returns (int256);

    function positionMargin(address trader) external view returns (uint256);

    function maintenanceMargin(address trader) external view returns (uint256);

    function isSafe(address trader) external returns (bool);

    function isSafeWithPrice(address trader, uint256 currentMarkPrice) external returns (bool);

    function isIMSafe(address trader) external returns (bool);

    function isIMSafeWithPrice(address trader, uint256 currentMarkPrice) external returns (bool);

    function tradePosition(
        address taker,
        address maker,
        LibTypes.Side side,
        uint256 price,
        uint256 amount
    ) external returns (uint256, uint256);

    function transferCashBalance(
        address from,
        address to,
        uint256 amount
    ) external;

    function depositFor(address trader, uint256 amount) external payable;

    function withdrawFor(address payable trader, uint256 amount) external;

    function liquidate(address trader, uint256 amount) external returns (uint256, uint256);

    function insuranceFundBalance() external view returns (int256);

    function beginGlobalSettlement(uint256 price) external;

    function endGlobalSettlement() external;

    function isValidLotSize(uint256 amount) external view returns (bool);

    function isValidTradingLotSize(uint256 amount) external view returns (bool);
}

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

contract ERC20 is Context, IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20};
     *
     * Requirements:
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for `sender`'s tokens of at least
     * `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: burn from the zero address");

        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
     *
     * This is internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
     * from the caller's allowance.
     *
     * See {_burn} and {_approve}.
     */
    function _burnFrom(address account, uint256 amount) internal {
        _burn(account, amount);
        _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
    }
}

library Roles {
    struct Role {
        mapping (address => bool) bearer;
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
    function has(Role storage role, address account) internal view returns (bool) {
        require(account != address(0), "Roles: account is the zero address");
        return role.bearer[account];
    }
}

contract MinterRole is Context {
    using Roles for Roles.Role;

    event MinterAdded(address indexed account);
    event MinterRemoved(address indexed account);

    Roles.Role private _minters;

    constructor () internal {
        _addMinter(_msgSender());
    }

    modifier onlyMinter() {
        require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
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

contract ERC20Mintable is ERC20, MinterRole {
    /**
     * @dev See {ERC20-_mint}.
     *
     * Requirements:
     *
     * - the caller must have the {MinterRole}.
     */
    function mint(address account, uint256 amount) public onlyMinter returns (bool) {
        _mint(account, amount);
        return true;
    }
}

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

contract ShareToken is ERC20Mintable, ERC20Detailed {

    constructor(string memory _name, string memory _symbol, uint8 _decimals)
        ERC20Detailed(_name, _symbol, _decimals)
        public
    {
    }

    function burn(address account, uint256 amount) public onlyMinter returns (bool) {
        _burn(account, amount);
        return true;
    }
}

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

interface IGlobalConfig {

    function owner() external view returns (address);

    function isOwner() external view returns (bool);

    function renounceOwnership() external;

    function transferOwnership(address newOwner) external;

    function brokers(address broker) external view returns (bool);
    
    function pauseControllers(address broker) external view returns (bool);

    function withdrawControllers(address broker) external view returns (bool);

    function addBroker() external;

    function removeBroker() external;

    function isComponent(address component) external view returns (bool);

    function addComponent(address perpetual, address component) external;

    function removeComponent(address perpetual, address component) external;

    function addPauseController(address controller) external;

    function removePauseController(address controller) external;

    function addWithdrawController(address controller) external;

    function removeWithdrawControllers(address controller) external;
}

contract AMMGovernance {
    using LibMathSigned for int256;
    using LibMathUnsigned for uint256;

    LibTypes.AMMGovernanceConfig internal governance;
    LibTypes.FundingState internal fundingState;

    // auto-set when calling setGovernanceParameter
    int256 public emaAlpha2; // 1 - emaAlpha
    int256 public emaAlpha2Ln; // ln(emaAlpha2)

    IPerpetual public perpetualProxy;
    IPriceFeeder public priceFeeder;
    IGlobalConfig public globalConfig;

    event UpdateGovernanceParameter(bytes32 indexed key, int256 value);

    constructor(address _globalConfig) public {
        require(_globalConfig != address(0), "invalid global config");
        globalConfig = IGlobalConfig(_globalConfig);
    }

    modifier onlyOwner() {
        require(globalConfig.owner() == msg.sender, "not owner");
        _;
    }

    modifier onlyAuthorized() {
        require(globalConfig.isComponent(msg.sender), "unauthorized caller");
        _;
    }

    /**
     * @dev Set governance parameters.
     *
     * @param key   Name of parameter.
     * @param value Value of parameter.
     */
    function setGovernanceParameter(bytes32 key, int256 value) public onlyOwner {
        if (key == "poolFeeRate") {
            governance.poolFeeRate = value.toUint256();
        } else if (key == "poolDevFeeRate") {
            governance.poolDevFeeRate = value.toUint256();
        } else if (key == "emaAlpha") {
            require(value > 0, "alpha should be > 0");
            require(value <= 10**18, "alpha should be <= 1");
            governance.emaAlpha = value;
            emaAlpha2 = 10**18 - governance.emaAlpha;
            emaAlpha2Ln = emaAlpha2.wln();
        } else if (key == "updatePremiumPrize") {
            governance.updatePremiumPrize = value.toUint256();
        } else if (key == "markPremiumLimit") {
            governance.markPremiumLimit = value;
        } else if (key == "fundingDampener") {
            governance.fundingDampener = value;
        } else if (key == "accumulatedFundingPerContract") {
            require(perpetualProxy.status() == LibTypes.Status.EMERGENCY, "wrong perpetual status");
            fundingState.accumulatedFundingPerContract = value;
        } else if (key == "priceFeeder") {
            require(Address.isContract(address(value)), "wrong address");
            priceFeeder = IPriceFeeder(value);
        } else {
            revert("key not exists");
        }
        emit UpdateGovernanceParameter(key, value);
    }

    // get governance data structure.
    function getGovernance() public view returns (LibTypes.AMMGovernanceConfig memory) {
        return governance;
    }
}

contract AMM is AMMGovernance {
    using LibMathSigned for int256;
    using LibMathUnsigned for uint256;

    int256 private constant FUNDING_PERIOD = 28800; // 8 * 3600;

    // ERC20 token
    ShareToken private shareToken;

    event CreateAMM();
    event UpdateFundingRate(LibTypes.FundingState fundingState);

    constructor(
        address _globalConfig,
        address _perpetualProxy,
        address _priceFeeder,
        address _shareToken
    )
        public
        AMMGovernance(_globalConfig)
    {
        priceFeeder = IPriceFeeder(_priceFeeder);
        perpetualProxy = IPerpetual(_perpetualProxy);
        shareToken = ShareToken(_shareToken);

        emit CreateAMM();
    }

    /**
     * @notice Share token's ERC20 address.
     */
    function shareTokenAddress() public view returns (address) {
        return address(shareToken);
    }

    /**
     * @notice Index price.
     *
     * Re-read the oracle price instead of the cached value.
     */
    function indexPrice() public view returns (uint256 price, uint256 timestamp) {
        (price, timestamp) = priceFeeder.price();
        require(price != 0, "dangerous index price");
    }

    /**
     * @notice Pool's position size (y).
     */
    function positionSize() public view returns (uint256) {
        return perpetualProxy.getMarginAccount(tradingAccount()).size;
    }

    /**
     * @notice FundingState.
     *
     * Note: last* functions (lastFundingState, lastAvailableMargin, lastFairPrice, etc.) are calculated based on
     *       the on-chain fundingState. current* functions are calculated based on the current timestamp.
     */
    function lastFundingState() public view returns (LibTypes.FundingState memory) {
        return fundingState;
    }

    /**
     * @notice AvailableMargin (x).
     *
     * Note: last* functions (lastFundingState, lastAvailableMargin, lastFairPrice, etc.) are calculated based on
     *       the on-chain fundingState. current* functions are calculated based on the current timestamp.
     */
    function lastAvailableMargin() internal view returns (uint256) {
        LibTypes.MarginAccount memory account = perpetualProxy.getMarginAccount(tradingAccount());
        return availableMarginFromPoolAccount(account);
    }

    /**
     * @notice FairPrice.
     *
     * Note: last* functions (lastFundingState, lastAvailableMargin, lastFairPrice, etc.) are calculated based on
     *       the on-chain fundingState. current* functions are calculated based on the current timestamp.
     */
    function lastFairPrice() internal view returns (uint256) {
        LibTypes.MarginAccount memory account = perpetualProxy.getMarginAccount(tradingAccount());
        return fairPriceFromPoolAccount(account);
    }

    /**
     * @notice Premium.
     *
     * Note: last* functions (lastFundingState, lastAvailableMargin, lastFairPrice, etc.) are calculated based on
     *       the on-chain fundingState. current* functions are calculated based on the current timestamp.
     */
    function lastPremium() internal view returns (int256) {
        LibTypes.MarginAccount memory account = perpetualProxy.getMarginAccount(tradingAccount());
        return premiumFromPoolAccount(account);
    }

    /**
     * @notice EMAPremium.
     *
     * Note: last* functions (lastFundingState, lastAvailableMargin, lastFairPrice, etc.) are calculated based on
     *       on-chain fundingState. current* functions are calculated based on the current timestamp.
     */
    function lastEMAPremium() internal view returns (int256) {
        return fundingState.lastEMAPremium;
    }

    /**
     * @notice MarkPrice.
     *
     * Note: last* functions (lastFundingState, lastAvailableMargin, lastFairPrice, etc.) are calculated based on
     *       the on-chain fundingState. current* functions are calculated based on the current timestamp.
     */
    function lastMarkPrice() internal view returns (uint256) {
        int256 index = fundingState.lastIndexPrice.toInt256();
        int256 limit = index.wmul(governance.markPremiumLimit);
        int256 p = index.add(lastEMAPremium());
        p = p.min(index.add(limit));
        p = p.max(index.sub(limit));
        return p.max(0).toUint256();
    }

    /**
     * @notice PremiumRate.
     *
     * Note: last* functions (lastFundingState, lastAvailableMargin, lastFairPrice, etc.) are calculated based on
     *       the on-chain fundingState. current* functions are calculated based on the current timestamp.
     */
    function lastPremiumRate() internal view returns (int256) {
        int256 index = fundingState.lastIndexPrice.toInt256();
        int256 rate = lastMarkPrice().toInt256();
        rate = rate.sub(index).wdiv(index);
        return rate;
    }

    /**
     * @notice FundingRate.
     *
     * Note: last* functions (lastFundingState, lastAvailableMargin, lastFairPrice, etc.) are calculated based on
     *       the on-chain fundingState. current* functions are calculated based on the current timestamp.
     */
    function lastFundingRate() public view returns (int256) {
        int256 rate = lastPremiumRate();
        return rate.max(governance.fundingDampener).add(rate.min(-governance.fundingDampener));
    }

    // Public functions

    /**
     * @notice FundingState.
     *
     * Note: current* functions (currentFundingState, currentAvailableMargin, currentFairPrice, etc.) are calculated based on
     *       the current timestamp. current* functions are calculated based on the on-chain fundingState.
     */
    function currentFundingState() public returns (LibTypes.FundingState memory) {
        funding();
        return fundingState;
    }

    /**
     * @notice AvailableMargin (x).
     *
     * Note: current* functions (currentFundingState, currentAvailableMargin, currentFairPrice, etc.) are calculated based on
     *       the current timestamp. current* functions are calculated based on the on-chain fundingState.
     */
    function currentAvailableMargin() public returns (uint256) {
        funding();
        return lastAvailableMargin();
    }

    /**
     * @notice FairPrice.
     *
     * Note: current* functions (currentFundingState, currentAvailableMargin, currentFairPrice, etc.) are calculated based on
     *       the current timestamp. current* functions are calculated based on the on-chain fundingState.
     */
    function currentFairPrice() public returns (uint256) {
        funding();
        return lastFairPrice();
    }

    /**
     * @notice Premium.
     *
     * Note: current* functions (currentFundingState, currentAvailableMargin, currentFairPrice, etc.) are calculated based on
     *       the current timestamp. current* functions are calculated based on the on-chain fundingState.
     */
    function currentPremium() public returns (int256) {
        funding();
        return lastPremium();
    }

    /**
     * @notice MarkPrice.
     *
     * Note: current* functions (currentFundingState, currentAvailableMargin, currentFairPrice, etc.) are calculated based on
     *       the current timestamp. current* functions are calculated based on the on-chain fundingState.
     */
    function currentMarkPrice() public returns (uint256) {
        funding();
        return lastMarkPrice();
    }

    /**
     * @notice PremiumRate.
     *
     * Note: current* functions (currentFundingState, currentAvailableMargin, currentFairPrice, etc.) are calculated based on
     *       the current timestamp. current* functions are calculated based on the on-chain fundingState.
     */
    function currentPremiumRate() public returns (int256) {
        funding();
        return lastPremiumRate();
    }

    /**
     * @notice FundingRate.
     *
     * Note: current* functions (currentFundingState, currentAvailableMargin, currentFairPrice, etc.) are calculated based on
     *       the current timestamp. current* functions are calculated based on the on-chain fundingState.
     */
    function currentFundingRate() public returns (int256) {
        funding();
        return lastFundingRate();
    }

    /**
     * @notice AccumulatedFundingPerContract.
     *
     * Note: current* functions (currentFundingState, currentAvailableMargin, currentFairPrice, etc.) are calculated based on
     *       the current timestamp. current* functions are calculated based on the on-chain fundingState.
     */
    function currentAccumulatedFundingPerContract() public returns (int256) {
        funding();
        return fundingState.accumulatedFundingPerContract;
    }

    /**
     * @notice The pool's margin account.
     */
    function tradingAccount() internal view returns (address) {
        return address(perpetualProxy);
    }

    /**
     * @notice The 1st addLiquidity.
     *
     * The semantics of this function is almost identical to addLiquidity except that the trading price
     * is not determined by fairPrice, but by indexPrice.
     *
     * Note: buy() and sell() will fail before this function is called.
     * @param amount Sell amount. Must be a multiple of lotSize.
     */
    function createPool(uint256 amount) public {
        require(amount > 0, "amount must be greater than zero");
        require(perpetualProxy.status() == LibTypes.Status.NORMAL, "wrong perpetual status");
        require(positionSize() == 0, "pool not empty");

        address trader = msg.sender;
        uint256 blockTime = getBlockTimestamp();
        uint256 newIndexPrice;
        uint256 newIndexTimestamp;
        (newIndexPrice, newIndexTimestamp) = indexPrice();

        initFunding(newIndexPrice, blockTime);
        perpetualProxy.transferCashBalance(trader, tradingAccount(), newIndexPrice.wmul(amount).mul(2));
        (uint256 opened, ) = perpetualProxy.tradePosition(
            trader,
            tradingAccount(),
            LibTypes.Side.SHORT,
            newIndexPrice,
            amount
        );
        mintShareTokenTo(trader, amount);

        forceFunding(); // x, y changed, so fair price changed. we need funding now
        mustSafe(trader, opened);
    }

    /**
     * @notice Price of buy/long.
     *
     * @param amount Buy amount.
     */
    function getBuyPrice(uint256 amount) internal returns (uint256 price) {
        uint256 x;
        uint256 y;
        (x, y) = currentXY();
        require(y != 0 && x != 0, "empty pool");
        return x.wdiv(y.sub(amount));
    }

    /**
     * @notice Real implementation of buy/long.
     *
     * @param trader The trader.
     * @param amount Buy amount. Must be a multiple of lotSize.
     * @param limitPrice Assert the trading price <= limitPrice.
     * @param deadline Assert the trading time <= deadline.
     */
    function buyFrom(
        address trader,
        uint256 amount,
        uint256 limitPrice,
        uint256 deadline
    )
        private
        returns (uint256) {
        require(perpetualProxy.status() == LibTypes.Status.NORMAL, "wrong perpetual status");
        require(perpetualProxy.isValidTradingLotSize(amount), "amount must be divisible by tradingLotSize");

        uint256 price = getBuyPrice(amount);
        require(limitPrice >= price, "price limited");
        require(getBlockTimestamp() <= deadline, "deadline exceeded");
        (uint256 opened, ) = perpetualProxy.tradePosition(trader, tradingAccount(), LibTypes.Side.LONG, price, amount);

        uint256 value = price.wmul(amount);
        uint256 fee = value.wmul(governance.poolFeeRate);
        uint256 devFee = value.wmul(governance.poolDevFeeRate);
        address devAddress = perpetualProxy.devAddress();

        perpetualProxy.transferCashBalance(trader, tradingAccount(), fee);
        perpetualProxy.transferCashBalance(trader, devAddress, devFee);

        forceFunding(); // x, y changed, so fair price changed. we need funding now
        mustSafe(trader, opened);
        return opened;
    }

    /**
     * @notice Buy/long with AMM if the trader comes from the whitelist.
     *
     * @param trader The trader.
     * @param amount Buy amount. Must be a multiple of lotSize.
     * @param limitPrice Assert the trading price <= limitPrice.
     * @param deadline Assert the trading time <= deadline.
     */
    function buyFromWhitelisted(
        address trader,
        uint256 amount,
        uint256 limitPrice,
        uint256 deadline
    )
        public
        onlyAuthorized
        returns (uint256)
    {
        return buyFrom(trader, amount, limitPrice, deadline);
    }

    /**
     * @notice Buy/long with AMM.
     *
     * @param amount Buy amount. Must be a multiple of lotSize.
     * @param limitPrice Assert the trading price <= limitPrice.
     * @param deadline Assert the trading time <= deadline.
     */
    function buy(
        uint256 amount,
        uint256 limitPrice,
        uint256 deadline
    ) public returns (uint256) {
        return buyFrom(msg.sender, amount, limitPrice, deadline);
    }

    /**
     * @notice Price of sell/short.
     *
     * @param amount Sell amount.
     */
    function getSellPrice(uint256 amount) internal returns (uint256 price) {
        uint256 x;
        uint256 y;
        (x, y) = currentXY();
        require(y != 0 && x != 0, "empty pool");
        return x.wdiv(y.add(amount));
    }

    /**
     * @notice Real implementation of sell/short.
     *
     * @param trader The trader.
     * @param amount Sell amount. Must be a multiple of lotSize.
     * @param limitPrice Assert the trading price >= limitPrice.
     * @param deadline Assert the trading time <= deadline.
     */
    function sellFrom(
        address trader,
        uint256 amount,
        uint256 limitPrice,
        uint256 deadline
    ) private returns (uint256) {
        require(perpetualProxy.status() == LibTypes.Status.NORMAL, "wrong perpetual status");
        require(perpetualProxy.isValidTradingLotSize(amount), "amount must be divisible by tradingLotSize");

        uint256 price = getSellPrice(amount);
        require(limitPrice <= price, "price limited");
        require(getBlockTimestamp() <= deadline, "deadline exceeded");
        (uint256 opened, ) = perpetualProxy.tradePosition(trader, tradingAccount(), LibTypes.Side.SHORT, price, amount);

        uint256 value = price.wmul(amount);
        uint256 fee = value.wmul(governance.poolFeeRate);
        uint256 devFee = value.wmul(governance.poolDevFeeRate);
        address devAddress = perpetualProxy.devAddress();
        perpetualProxy.transferCashBalance(trader, tradingAccount(), fee);
        perpetualProxy.transferCashBalance(trader, devAddress, devFee);

        forceFunding(); // x, y changed, so fair price changed. we need funding now
        mustSafe(trader, opened);
        return opened;
    }

    /**
     * @notice Sell/short with AMM if the trader comes from the whitelist.
     *
     * @param trader The trader.
     * @param amount Sell amount. Must be a multiple of lotSize.
     * @param limitPrice Assert the trading price >= limitPrice.
     * @param deadline Assert the trading time <= deadline.
     */
    function sellFromWhitelisted(
        address trader,
        uint256 amount,
        uint256 limitPrice,
        uint256 deadline
    )
        public
        onlyAuthorized
        returns (uint256)
    {
        return sellFrom(trader, amount, limitPrice, deadline);
    }

    /**
     * @notice Sell/short with AMM.
     *
     * @param amount Sell amount. Must be a multiple of lotSize.
     * @param limitPrice Assert the trading price >= limitPrice.
     * @param deadline Assert the trading time <= deadline.
     */
    function sell(
        uint256 amount,
        uint256 limitPrice,
        uint256 deadline
    ) public returns (uint256) {
        return sellFrom(msg.sender, amount, limitPrice, deadline);
    }

    /**
     * @notice Move collateral from the current liquidity provider's margin account into AMM and mint the Share token.
     *
     * After addLiquidity, the liquidity provider will:
     * 1. Pay (2 * amount * price) collateral.
     * 2. Get Share tokens to prove that there're some Long positions and collaterals in AMM that belongs to current liquidity provider.
     * 3. Get some Short positions.
     *
     * The number of short positions obtained is obviously the same as the number of long positions obtained in the pool.
     *
     * @param amount Sell amount. Must be a multiple of lotSize.
     */
    function addLiquidity(uint256 amount) public {
        require(perpetualProxy.status() == LibTypes.Status.NORMAL, "wrong perpetual status");

        uint256 oldAvailableMargin;
        uint256 oldPoolPositionSize;
        (oldAvailableMargin, oldPoolPositionSize) = currentXY();
        require(oldPoolPositionSize != 0 && oldAvailableMargin != 0, "empty pool");

        address trader = msg.sender;
        uint256 price = oldAvailableMargin.wdiv(oldPoolPositionSize);

        uint256 collateralAmount = amount.wmul(price).mul(2);
        perpetualProxy.transferCashBalance(trader, tradingAccount(), collateralAmount);
        (uint256 opened, ) = perpetualProxy.tradePosition(trader, tradingAccount(), LibTypes.Side.SHORT, price, amount);

        mintShareTokenTo(trader, shareToken.totalSupply().wmul(amount).wdiv(oldPoolPositionSize));

        forceFunding(); // x, y changed, so fair price changed. we need funding now
        mustSafe(trader, opened);
    }

    /**
     * @notice Burn Share tokens to remove the collateral attributed to the current liquidity provider
     *         from AMM into the liquidity provider's margin account.
     *
     * @param shareAmount The number of share tokens about to burn. The real trading amount will be
     *        automatically aligned to lotSize.
     */
    function removeLiquidity(uint256 shareAmount) public {
        require(perpetualProxy.status() == LibTypes.Status.NORMAL, "wrong perpetual status");

        address trader = msg.sender;
        uint256 oldAvailableMargin;
        uint256 oldPoolPositionSize;
        (oldAvailableMargin, oldPoolPositionSize) = currentXY();
        require(oldPoolPositionSize != 0 && oldAvailableMargin != 0, "empty pool");
        require(shareToken.balanceOf(msg.sender) >= shareAmount, "shareBalance too low");
        uint256 price = oldAvailableMargin.wdiv(oldPoolPositionSize);
        uint256 amount = shareAmount.wmul(oldPoolPositionSize).wdiv(shareToken.totalSupply());
        // align to lotSize
        uint256 lotSize = perpetualProxy.getGovernance().lotSize;
        amount = amount.sub(amount.mod(lotSize));

        perpetualProxy.transferCashBalance(tradingAccount(), trader, price.wmul(amount).mul(2));
        burnShareTokenFrom(trader, shareAmount);
        (uint256 opened, ) = perpetualProxy.tradePosition(trader, tradingAccount(), LibTypes.Side.LONG, price, amount);

        forceFunding(); // x, y changed, so fair price changed. we need funding now
        mustSafe(trader, opened);
    }

    /**
     * @notice In SETTLED status, burn Share tokens to remove the collateral attributed to the current liquidity provider
     *         from AMM to the liquidity provider's margin account.
     *
     * Also call perpetual.settle() to finally withdraw all collaterals after calling this function.
     */
    function settleShare() public {
        require(perpetualProxy.status() == LibTypes.Status.SETTLED, "wrong perpetual status");

        address trader = msg.sender;
        LibTypes.MarginAccount memory account = perpetualProxy.getMarginAccount(tradingAccount());
        uint256 total = availableMarginFromPoolAccount(account);
        uint256 shareAmount = shareToken.balanceOf(trader);
        uint256 balance = shareAmount.wmul(total).wdiv(shareToken.totalSupply());
        perpetualProxy.transferCashBalance(tradingAccount(), trader, balance);
        burnShareTokenFrom(trader, shareAmount);
    }

    /**
     * @notice This is a composite function of perp.deposit + amm.buy.
     *
     * Composite functions accept amount = 0.
     *
     * @param depositAmount The collateral amount. Note: The actual token.decimals should be filled in and not necessarily 18.
     * @param tradeAmount Buy amount.
     * @param limitPrice Assert the trading price <= limitPrice.
     * @param deadline Assert the trading time <= deadline.
     */
    function depositAndBuy(
        uint256 depositAmount,
        uint256 tradeAmount,
        uint256 limitPrice,
        uint256 deadline
    )
        public
        payable
    {
        if (depositAmount > 0) {
            perpetualProxy.depositFor.value(msg.value)(msg.sender, depositAmount);
        }
        if (tradeAmount > 0) {
            buy(tradeAmount, limitPrice, deadline);
        }
    }

    /**
     * @notice This is a composite function of perp.deposit + amm.sell.
     *
     * Composite functions accept amount = 0.
     *
     * @param depositAmount The collateral amount. Note: The actual token.decimals should be filled in and not necessarily 18.
     * @param tradeAmount Sell amount.
     * @param limitPrice Assert the trading price >= limitPrice.
     * @param deadline Assert the trading time <= deadline.
     */
    function depositAndSell(
        uint256 depositAmount,
        uint256 tradeAmount,
        uint256 limitPrice,
        uint256 deadline
    )
        public
        payable
    {
        if (depositAmount > 0) {
            perpetualProxy.depositFor.value(msg.value)(msg.sender, depositAmount);
        }
        if (tradeAmount > 0) {
            sell(tradeAmount, limitPrice, deadline);
        }
    }

    /**
     * @notice This is a composite function of amm.buy + perp.withdraw.
     *
     * Composite functions accept amount = 0.
     *
     * @param tradeAmount Buy amount.
     * @param limitPrice Assert the trading price <= limitPrice.
     * @param deadline Assert the trading time <= deadline.
     * @param withdrawAmount The collateral amount. Note: The actual token.decimals should be filled in and not necessarily 18.
     */
    function buyAndWithdraw(
        uint256 tradeAmount,
        uint256 limitPrice,
        uint256 deadline,
        uint256 withdrawAmount
    ) public {
        if (tradeAmount > 0) {
            buy(tradeAmount, limitPrice, deadline);
        }
        if (withdrawAmount > 0) {
            perpetualProxy.withdrawFor(msg.sender, withdrawAmount);
        }
    }

    /**
     * @notice This is a composite function of amm.sell + perp.withdraw.
     *
     * Composite functions accept amount = 0.
     *
     * @param tradeAmount Sell amount.
     * @param limitPrice Assert the trading price >= limitPrice.
     * @param deadline Assert the trading time <= deadline.
     * @param withdrawAmount The collateral amount. Note: The actual token.decimals should be filled in and not necessarily 18.
     */
    function sellAndWithdraw(
        uint256 tradeAmount,
        uint256 limitPrice,
        uint256 deadline,
        uint256 withdrawAmount
    ) public {
        if (tradeAmount > 0) {
            sell(tradeAmount, limitPrice, deadline);
        }
        if (withdrawAmount > 0) {
            perpetualProxy.withdrawFor(msg.sender, withdrawAmount);
        }
    }

    /**
     * @notice This is a composite function of perp.deposit + amm.addLiquidity.
     *
     * Composite functions accept amount = 0.
     *
     * After depositAndAddLiquidity, the liquidity provider will:
     * 1. Deposit depositAmount collateral.
     * 2. Pay (2 * amount * price) collateral.
     * 3. Get Share tokens to prove that there're some Long positions and collaterals in AMM that belongs to current liquidity provider.
     * 4. Get some Short positions.
     *
     * The number of short positions obtained is obviously the same as the number of long positions obtained in the pool.
     *
     * @param depositAmount The collateral amount. Note: The actual token.decimals should be filled in and not necessarily 18.
     * @param amount Sell amount, pay (2 * amount * price) collateral.
     */
    function depositAndAddLiquidity(uint256 depositAmount, uint256 amount) public payable {
        if (depositAmount > 0) {
            perpetualProxy.depositFor.value(msg.value)(msg.sender, depositAmount);
        }
        if (amount > 0) {
            addLiquidity(amount);
        }
    }

    /**
     * @notice Any ETH address can call this function to update the index price of this AMM and get some prize.
     */
    function updateIndex() public {
        require(perpetualProxy.status() == LibTypes.Status.NORMAL, "wrong perpetual status");
        uint256 oldIndexPrice = fundingState.lastIndexPrice;
        forceFunding();
        address devAddress = perpetualProxy.devAddress();
        if (oldIndexPrice != fundingState.lastIndexPrice) {
            perpetualProxy.transferCashBalance(devAddress, msg.sender, governance.updatePremiumPrize);
            require(perpetualProxy.isSafe(devAddress), "dev unsafe");
        }
    }

    // Internal helpers

    /**
     * @notice In order to mock the block.timestamp
     */
    function getBlockTimestamp() internal view returns (uint256) {
        // solium-disable-next-line security/no-block-members
        return block.timestamp;
    }

    /**
     * @notice a gas-optimized version of currentAvailableMargin() + positionSize(). almost all formulas require these two
     */
    function currentXY() internal returns (uint256 x, uint256 y) {
        funding();
        LibTypes.MarginAccount memory account = perpetualProxy.getMarginAccount(tradingAccount());
        x = availableMarginFromPoolAccount(account);
        y = account.size;
    }

    /**
     * @notice a gas-optimized version of lastAvailableMargin()
     */
    function availableMarginFromPoolAccount(LibTypes.MarginAccount memory account) internal view returns (uint256) {
        int256 available = account.cashBalance;
        int256 socialLossPerContract = perpetualProxy.socialLossPerContract(account.side);
        available = available.sub(account.entryValue.toInt256());
        available = available.sub(socialLossPerContract.wmul(account.size.toInt256()).sub(account.entrySocialLoss));
        available = available.sub(
            fundingState.accumulatedFundingPerContract.wmul(account.size.toInt256()).sub(account.entryFundingLoss)
        );
        return available.max(0).toUint256();
    }

    /**
     * @notice a gas-optimized version of lastFairPrice
     */
    function fairPriceFromPoolAccount(LibTypes.MarginAccount memory account) internal view returns (uint256) {
        uint256 y = account.size;
        require(y > 0, "funding initialization required");
        uint256 x = availableMarginFromPoolAccount(account);
        return x.wdiv(y);
    }

    /**
     * @notice a gas-optimized version of lastPremium
     */
    function premiumFromPoolAccount(LibTypes.MarginAccount memory account) internal view returns (int256) {
        int256 p = fairPriceFromPoolAccount(account).toInt256();
        p = p.sub(fundingState.lastIndexPrice.toInt256());
        return p;
    }

    /**
     * @notice Assert that the given trader is safe.
     *
     * A trader must at least MM-safe. If the trader is opening positions, it also needs to be IM-safe.
     *
     * @param trader The trader.
     * @param opened Non zero if the trader is opening positions.
     */
    function mustSafe(address trader, uint256 opened) internal {
        // perpetual.markPrice is a little different from ours
        uint256 perpetualMarkPrice = perpetualProxy.markPrice();
        if (opened > 0) {
            require(perpetualProxy.isIMSafeWithPrice(trader, perpetualMarkPrice), "im unsafe");
        }
        require(perpetualProxy.isSafeWithPrice(trader, perpetualMarkPrice), "sender unsafe");
        require(perpetualProxy.isSafeWithPrice(tradingAccount(), perpetualMarkPrice), "amm unsafe");
    }

    /**
     * @notice Mint Share token to a given trader.
     *
     * @param trader The trader.
     * @param amount Tokens.
     */
    function mintShareTokenTo(address trader, uint256 amount) internal {
        require(shareToken.mint(trader, amount), "mint failed");
    }

    /**
     * @notice Burn Share token from a given trader.
     * @param trader The trader.
     * @param amount Tokens.
     */
    function burnShareTokenFrom(address trader, uint256 amount) internal {
        require(shareToken.burn(trader, amount), "burn failed");
    }

    /**
     * @notice Init the fundingState. This function should be called before a funding().
     *
     * @param newIndexPrice Index price.
     * @param blockTime Use this timestamp instead of the time that the index price is generated, because this is the first initialization.
     */
    function initFunding(uint256 newIndexPrice, uint256 blockTime) private {
        require(fundingState.lastFundingTime == 0, "already initialized");
        fundingState.lastFundingTime = blockTime;
        fundingState.lastIndexPrice = newIndexPrice;
        fundingState.lastPremium = 0;
        fundingState.lastEMAPremium = 0;
    }

    /**
     * @notice current* functions need a funding() before return our states.
     *
     * Note: Will skip funding() other than NORMAL
     *
     * There are serveral conditions for change the funding state:
     * Condition 1: time.
     * Condition 2: indexPrice.
     * Condition 3: fairPrice. This condition is not covered in this function. We hand over to forceFunding.
     */
    function funding() internal {
        if (perpetualProxy.status() != LibTypes.Status.NORMAL) {
            return;
        }
        uint256 blockTime = getBlockTimestamp();
        uint256 newIndexPrice;
        uint256 newIndexTimestamp;
        (newIndexPrice, newIndexTimestamp) = indexPrice();
        if (
            blockTime != fundingState.lastFundingTime || // condition 1
            newIndexPrice != fundingState.lastIndexPrice || // condition 2, especially when updateIndex and buy/sell are in the same block
            newIndexTimestamp > fundingState.lastFundingTime // condition 2
        ) {
            forceFunding(blockTime, newIndexPrice, newIndexTimestamp);
        }
    }

    /**
     * @notice Update fundingState without checking whether the funding condition changes.
     *
     * This function also splits the funding process into 2 parts:
     * 1. funding from [lastFundingTime, lastIndexTimestamp)
     * 2. funding from [lastIndexTimestamp, blockTime)
     *
     */
    function forceFunding() internal {
        require(perpetualProxy.status() == LibTypes.Status.NORMAL, "wrong perpetual status");
        uint256 blockTime = getBlockTimestamp();
        uint256 newIndexPrice;
        uint256 newIndexTimestamp;
        (newIndexPrice, newIndexTimestamp) = indexPrice();
        forceFunding(blockTime, newIndexPrice, newIndexTimestamp);
    }

    /**
     * @notice Update fundingState without checking whether the funding condition changes.
     *
     * This function also splits the funding process into 2 parts:
     * 1. funding from [lastFundingTime, lastIndexTimestamp)
     * 2. funding from [lastIndexTimestamp, blockTime)
     *
     * @param blockTime The real end time.
     * @param newIndexPrice The latest index price.
     * @param newIndexTimestamp The timestamp of the latest index.
     */
    function forceFunding(uint256 blockTime, uint256 newIndexPrice, uint256 newIndexTimestamp) private {
        if (fundingState.lastFundingTime == 0) {
            // funding initialization required. but in this case, it's safe to just do nothing and return
            return;
        }
        LibTypes.MarginAccount memory account = perpetualProxy.getMarginAccount(tradingAccount());
        if (account.size == 0) {
            // empty pool. it's safe to just do nothing and return
            return;
        }

        if (newIndexTimestamp > fundingState.lastFundingTime) {
            // the 1st update
            nextStateWithTimespan(account, newIndexPrice, newIndexTimestamp);
        }
        // the 2nd update;
        nextStateWithTimespan(account, newIndexPrice, blockTime);

        emit UpdateFundingRate(fundingState);
    }

    /**
     * @notice Update fundingState from the lastFundingTime to the given time.
     *
     * This function also adds Acc / (8*3600) into accumulatedFundingPerContract, where Acc is accumulated
     * funding payment per position since lastFundingTime
     *
     * @param account The pool account.
     * @param newIndexPrice New index price.
     * @param endTimestamp The given end time.
     */
    function nextStateWithTimespan(
        LibTypes.MarginAccount memory account,
        uint256 newIndexPrice,
        uint256 endTimestamp
    ) private {
        require(fundingState.lastFundingTime != 0, "funding initialization required");
        require(endTimestamp >= fundingState.lastFundingTime, "time steps (n) must be positive");

        // update ema
        if (fundingState.lastFundingTime != endTimestamp) {
            int256 timeDelta = endTimestamp.sub(fundingState.lastFundingTime).toInt256();
            int256 acc;
            (fundingState.lastEMAPremium, acc) = getAccumulatedFunding(
                timeDelta,
                fundingState.lastEMAPremium,
                fundingState.lastPremium,
                fundingState.lastIndexPrice.toInt256() // ema is according to the old index
            );
            fundingState.accumulatedFundingPerContract = fundingState.accumulatedFundingPerContract.add(
                acc.div(FUNDING_PERIOD)
            );
            fundingState.lastFundingTime = endTimestamp;
        }

        // always update
        fundingState.lastIndexPrice = newIndexPrice; // should update before premium()
        fundingState.lastPremium = premiumFromPoolAccount(account);
    }

    /**
     * @notice Solve t in emaPremium == y equation
     *
     * @param y Required function output.
     * @param v0 LastEMAPremium.
     * @param _lastPremium LastPremium.
     */
    function timeOnFundingCurve(
        int256 y,
        int256 v0,
        int256 _lastPremium
    )
        internal
        view
        returns (
            int256 t // normal int, not WAD
        )
    {
        require(y != _lastPremium, "no solution 1 on funding curve");
        t = y.sub(_lastPremium);
        t = t.wdiv(v0.sub(_lastPremium));
        require(t > 0, "no solution 2 on funding curve");
        require(t < LibMathSigned.WAD(), "no solution 3 on funding curve");
        t = t.wln();
        t = t.wdiv(emaAlpha2Ln);
        t = t.ceil(LibMathSigned.WAD()) / LibMathSigned.WAD();
    }

    /**
     * @notice Sum emaPremium curve between [x, y)
     *
     * @param x Begin time. normal int, not WAD.
     * @param y End time. normal int, not WAD.
     * @param v0 LastEMAPremium.
     * @param _lastPremium LastPremium.
     */
    function integrateOnFundingCurve(
        int256 x,
        int256 y,
        int256 v0,
        int256 _lastPremium
    ) internal view returns (int256 r) {
        require(x <= y, "integrate reversed");
        r = v0.sub(_lastPremium);
        r = r.wmul(emaAlpha2.wpowi(x).sub(emaAlpha2.wpowi(y)));
        r = r.wdiv(governance.emaAlpha);
        r = r.add(_lastPremium.mul(y.sub(x)));
    }

   /**
     * @notice The intermediate variables required by getAccumulatedFunding. This is only used to move stack
     *         variables to storage variables.
     */
    struct AccumulatedFundingCalculator {
        int256 vLimit;
        int256 vDampener;
        int256 t1; // normal int, not WAD
        int256 t2; // normal int, not WAD
        int256 t3; // normal int, not WAD
        int256 t4; // normal int, not WAD
    }

    /**
     * @notice Calculate the `Acc`. Sigma the funding rate curve while considering the limit and dampener. There are
     *         4 boundary points on the curve (-GovMarkPremiumLimit, -GovFundingDampener, +GovFundingDampener, +GovMarkPremiumLimit)
     *         which segment the curve into 5 parts, so that the calculation can be arranged into 5 * 5 = 25 cases.
     *         In order to reduce the amount of calculation, the code is expanded into 25 branches.
     *
     * @param n Time span. normal int, not WAD.
     * @param v0 LastEMAPremium.
     * @param _lastPremium LastPremium.
     * @param _lastIndexPrice LastIndexPrice.
     */
    function getAccumulatedFunding(
        int256 n,
        int256 v0,
        int256 _lastPremium,
        int256 _lastIndexPrice
    )
        internal
        view
        returns (
            int256 vt, // new LastEMAPremium
            int256 acc
        )
    {
        require(n > 0, "we can't go back in time");
        AccumulatedFundingCalculator memory ctx;
        vt = v0.sub(_lastPremium);
        vt = vt.wmul(emaAlpha2.wpowi(n));
        vt = vt.add(_lastPremium);
        ctx.vLimit = governance.markPremiumLimit.wmul(_lastIndexPrice);
        ctx.vDampener = governance.fundingDampener.wmul(_lastIndexPrice);
        if (v0 <= -ctx.vLimit) {
            // part A
            if (vt <= -ctx.vLimit) {
                acc = (-ctx.vLimit).add(ctx.vDampener).mul(n);
            } else if (vt <= -ctx.vDampener) {
                ctx.t1 = timeOnFundingCurve(-ctx.vLimit, v0, _lastPremium);
                acc = (-ctx.vLimit).mul(ctx.t1);
                acc = acc.add(integrateOnFundingCurve(ctx.t1, n, v0, _lastPremium));
                acc = acc.add(ctx.vDampener.mul(n));
            } else if (vt <= ctx.vDampener) {
                ctx.t1 = timeOnFundingCurve(-ctx.vLimit, v0, _lastPremium);
                ctx.t2 = timeOnFundingCurve(-ctx.vDampener, v0, _lastPremium);
                acc = (-ctx.vLimit).mul(ctx.t1);
                acc = acc.add(integrateOnFundingCurve(ctx.t1, ctx.t2, v0, _lastPremium));
                acc = acc.add(ctx.vDampener.mul(ctx.t2));
            } else if (vt <= ctx.vLimit) {
                ctx.t1 = timeOnFundingCurve(-ctx.vLimit, v0, _lastPremium);
                ctx.t2 = timeOnFundingCurve(-ctx.vDampener, v0, _lastPremium);
                ctx.t3 = timeOnFundingCurve(ctx.vDampener, v0, _lastPremium);
                acc = (-ctx.vLimit).mul(ctx.t1);
                acc = acc.add(integrateOnFundingCurve(ctx.t1, ctx.t2, v0, _lastPremium));
                acc = acc.add(integrateOnFundingCurve(ctx.t3, n, v0, _lastPremium));
                acc = acc.add(ctx.vDampener.mul(ctx.t2.sub(n).add(ctx.t3)));
            } else {
                ctx.t1 = timeOnFundingCurve(-ctx.vLimit, v0, _lastPremium);
                ctx.t2 = timeOnFundingCurve(-ctx.vDampener, v0, _lastPremium);
                ctx.t3 = timeOnFundingCurve(ctx.vDampener, v0, _lastPremium);
                ctx.t4 = timeOnFundingCurve(ctx.vLimit, v0, _lastPremium);
                acc = (-ctx.vLimit).mul(ctx.t1);
                acc = acc.add(integrateOnFundingCurve(ctx.t1, ctx.t2, v0, _lastPremium));
                acc = acc.add(integrateOnFundingCurve(ctx.t3, ctx.t4, v0, _lastPremium));
                acc = acc.add(ctx.vLimit.mul(n.sub(ctx.t4)));
                acc = acc.add(ctx.vDampener.mul(ctx.t2.sub(n).add(ctx.t3)));
            }
        } else if (v0 <= -ctx.vDampener) {
            // part B
            if (vt <= -ctx.vLimit) {
                ctx.t4 = timeOnFundingCurve(-ctx.vLimit, v0, _lastPremium);
                acc = integrateOnFundingCurve(0, ctx.t4, v0, _lastPremium);
                acc = acc.add((-ctx.vLimit).mul(n.sub(ctx.t4)));
                acc = acc.add(ctx.vDampener.mul(n));
            } else if (vt <= -ctx.vDampener) {
                acc = integrateOnFundingCurve(0, n, v0, _lastPremium);
                acc = acc.add(ctx.vDampener.mul(n));
            } else if (vt <= ctx.vDampener) {
                ctx.t2 = timeOnFundingCurve(-ctx.vDampener, v0, _lastPremium);
                acc = integrateOnFundingCurve(0, ctx.t2, v0, _lastPremium);
                acc = acc.add(ctx.vDampener.mul(ctx.t2));
            } else if (vt <= ctx.vLimit) {
                ctx.t2 = timeOnFundingCurve(-ctx.vDampener, v0, _lastPremium);
                ctx.t3 = timeOnFundingCurve(ctx.vDampener, v0, _lastPremium);
                acc = integrateOnFundingCurve(0, ctx.t2, v0, _lastPremium);
                acc = acc.add(integrateOnFundingCurve(ctx.t3, n, v0, _lastPremium));
                acc = acc.add(ctx.vDampener.mul(ctx.t2.sub(n).add(ctx.t3)));
            } else {
                ctx.t2 = timeOnFundingCurve(-ctx.vDampener, v0, _lastPremium);
                ctx.t3 = timeOnFundingCurve(ctx.vDampener, v0, _lastPremium);
                ctx.t4 = timeOnFundingCurve(ctx.vLimit, v0, _lastPremium);
                acc = integrateOnFundingCurve(0, ctx.t2, v0, _lastPremium);
                acc = acc.add(integrateOnFundingCurve(ctx.t3, ctx.t4, v0, _lastPremium));
                acc = acc.add(ctx.vLimit.mul(n.sub(ctx.t4)));
                acc = acc.add(ctx.vDampener.mul(ctx.t2.sub(n).add(ctx.t3)));
            }
        } else if (v0 <= ctx.vDampener) {
            // part C
            if (vt <= -ctx.vLimit) {
                ctx.t3 = timeOnFundingCurve(-ctx.vDampener, v0, _lastPremium);
                ctx.t4 = timeOnFundingCurve(-ctx.vLimit, v0, _lastPremium);
                acc = integrateOnFundingCurve(ctx.t3, ctx.t4, v0, _lastPremium);
                acc = acc.add((-ctx.vLimit).mul(n.sub(ctx.t4)));
                acc = acc.add(ctx.vDampener.mul(n.sub(ctx.t3)));
            } else if (vt <= -ctx.vDampener) {
                ctx.t3 = timeOnFundingCurve(-ctx.vDampener, v0, _lastPremium);
                acc = integrateOnFundingCurve(ctx.t3, n, v0, _lastPremium);
                acc = acc.add(ctx.vDampener.mul(n.sub(ctx.t3)));
            } else if (vt <= ctx.vDampener) {
                acc = 0;
            } else if (vt <= ctx.vLimit) {
                ctx.t3 = timeOnFundingCurve(ctx.vDampener, v0, _lastPremium);
                acc = integrateOnFundingCurve(ctx.t3, n, v0, _lastPremium);
                acc = acc.sub(ctx.vDampener.mul(n.sub(ctx.t3)));
            } else {
                ctx.t3 = timeOnFundingCurve(ctx.vDampener, v0, _lastPremium);
                ctx.t4 = timeOnFundingCurve(ctx.vLimit, v0, _lastPremium);
                acc = integrateOnFundingCurve(ctx.t3, ctx.t4, v0, _lastPremium);
                acc = acc.add(ctx.vLimit.mul(n.sub(ctx.t4)));
                acc = acc.sub(ctx.vDampener.mul(n.sub(ctx.t3)));
            }
        } else if (v0 <= ctx.vLimit) {
            // part D
            if (vt <= -ctx.vLimit) {
                ctx.t2 = timeOnFundingCurve(ctx.vDampener, v0, _lastPremium);
                ctx.t3 = timeOnFundingCurve(-ctx.vDampener, v0, _lastPremium);
                ctx.t4 = timeOnFundingCurve(-ctx.vLimit, v0, _lastPremium);
                acc = integrateOnFundingCurve(0, ctx.t2, v0, _lastPremium);
                acc = acc.add(integrateOnFundingCurve(ctx.t3, ctx.t4, v0, _lastPremium));
                acc = acc.add((-ctx.vLimit).mul(n.sub(ctx.t4)));
                acc = acc.add(ctx.vDampener.mul(n.sub(ctx.t3).sub(ctx.t2)));
            } else if (vt <= -ctx.vDampener) {
                ctx.t2 = timeOnFundingCurve(ctx.vDampener, v0, _lastPremium);
                ctx.t3 = timeOnFundingCurve(-ctx.vDampener, v0, _lastPremium);
                acc = integrateOnFundingCurve(0, ctx.t2, v0, _lastPremium);
                acc = acc.add(integrateOnFundingCurve(ctx.t3, n, v0, _lastPremium));
                acc = acc.add(ctx.vDampener.mul(n.sub(ctx.t3).sub(ctx.t2)));
            } else if (vt <= ctx.vDampener) {
                ctx.t2 = timeOnFundingCurve(ctx.vDampener, v0, _lastPremium);
                acc = integrateOnFundingCurve(0, ctx.t2, v0, _lastPremium);
                acc = acc.sub(ctx.vDampener.mul(ctx.t2));
            } else if (vt <= ctx.vLimit) {
                acc = integrateOnFundingCurve(0, n, v0, _lastPremium);
                acc = acc.sub(ctx.vDampener.mul(n));
            } else {
                ctx.t4 = timeOnFundingCurve(ctx.vLimit, v0, _lastPremium);
                acc = integrateOnFundingCurve(0, ctx.t4, v0, _lastPremium);
                acc = acc.add(ctx.vLimit.mul(n.sub(ctx.t4)));
                acc = acc.sub(ctx.vDampener.mul(n));
            }
        } else {
            // part E
            if (vt <= -ctx.vLimit) {
                ctx.t1 = timeOnFundingCurve(ctx.vLimit, v0, _lastPremium);
                ctx.t2 = timeOnFundingCurve(ctx.vDampener, v0, _lastPremium);
                ctx.t3 = timeOnFundingCurve(-ctx.vDampener, v0, _lastPremium);
                ctx.t4 = timeOnFundingCurve(-ctx.vLimit, v0, _lastPremium);
                acc = ctx.vLimit.mul(ctx.t1);
                acc = acc.add(integrateOnFundingCurve(ctx.t1, ctx.t2, v0, _lastPremium));
                acc = acc.add(integrateOnFundingCurve(ctx.t3, ctx.t4, v0, _lastPremium));
                acc = acc.add((-ctx.vLimit).mul(n.sub(ctx.t4)));
                acc = acc.add(ctx.vDampener.mul(n.sub(ctx.t3).sub(ctx.t2)));
            } else if (vt <= -ctx.vDampener) {
                ctx.t1 = timeOnFundingCurve(ctx.vLimit, v0, _lastPremium);
                ctx.t2 = timeOnFundingCurve(ctx.vDampener, v0, _lastPremium);
                ctx.t3 = timeOnFundingCurve(-ctx.vDampener, v0, _lastPremium);
                acc = ctx.vLimit.mul(ctx.t1);
                acc = acc.add(integrateOnFundingCurve(ctx.t1, ctx.t2, v0, _lastPremium));
                acc = acc.add(integrateOnFundingCurve(ctx.t3, n, v0, _lastPremium));
                acc = acc.add(ctx.vDampener.mul(n.sub(ctx.t3).sub(ctx.t2)));
            } else if (vt <= ctx.vDampener) {
                ctx.t1 = timeOnFundingCurve(ctx.vLimit, v0, _lastPremium);
                ctx.t2 = timeOnFundingCurve(ctx.vDampener, v0, _lastPremium);
                acc = ctx.vLimit.mul(ctx.t1);
                acc = acc.add(integrateOnFundingCurve(ctx.t1, ctx.t2, v0, _lastPremium));
                acc = acc.add(ctx.vDampener.mul(-ctx.t2));
            } else if (vt <= ctx.vLimit) {
                ctx.t1 = timeOnFundingCurve(ctx.vLimit, v0, _lastPremium);
                acc = ctx.vLimit.mul(ctx.t1);
                acc = acc.add(integrateOnFundingCurve(ctx.t1, n, v0, _lastPremium));
                acc = acc.sub(ctx.vDampener.mul(n));
            } else {
                acc = ctx.vLimit.sub(ctx.vDampener).mul(n);
            }
        }
    } // getAccumulatedFunding
}