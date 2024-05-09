pragma solidity ^0.5.2;
pragma experimental ABIEncoderV2;


library LibMathSigned {
    int256 private constant _WAD = 10**18;
    int256 private constant _INT256_MIN = -2**255;

    function WAD() internal pure returns (int256) {
        return _WAD;
    }

    // additive inverse
    function neg(int256 a) internal pure returns (int256) {
        return sub(int256(0), a);
    }

    /**
     * @dev wmultiplies two signed integers, reverts on overflow.
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
     * @dev Integer wdivision of two signed integers truncating the quotient, reverts on wdivision by zero.
     */
    function div(int256 a, int256 b) internal pure returns (int256) {
        require(b != 0, "wdivision by zero");
        require(!(b == -1 && a == _INT256_MIN), "wdivision overflow");

        int256 c = a / b;

        return c;
    }

    /**
     * @dev Subtracts two signed integers, reverts on overflow.
     */
    function sub(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a - b;
        require((b >= 0 && c <= a) || (b < 0 && c > a), "subtraction overflow");

        return c;
    }

    /**
     * @dev Adds two signed integers, reverts on overflow.
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
            z = -z;
            t = -t;
        }
        r = roundHalfUp(t, z) / z;
    }

    function min(int256 x, int256 y) internal pure returns (int256 z) {
        return x <= y ? x : y;
    }

    function max(int256 x, int256 y) internal pure returns (int256 z) {
        return x >= y ? x : y;
    }

    // quotient and remainder
    function pwdiv(int256 x, int256 y) internal pure returns (int256 z, int256 m) {
        z = wdiv(x, y);
        m = sub(wmul(y, z), x);
    }

    function toUint256(int256 x) internal pure returns (uint256) {
        require(x >= 0, "int overflow");
        return uint256(x);
    }

    // x ^ n
    // NOTE: n is a normal integer, do not shift 18 decimals
    // solium-disable-next-line security/no-assign-params
    function wpowi(int256 x, int256 n) internal pure returns (int256 z) {
        z = n % 2 != 0 ? x : _WAD;

        for (n /= 2; n != 0; n /= 2) {
            x = wmul(x, x);

            if (n % 2 != 0) {
                z = wmul(z, x);
            }
        }
    }

    uint8 internal constant fixed_digits = 18;
    int256 internal constant fixed_1 = 1000000000000000000;
    int256 internal constant fixed_e = 2718281828459045235;
    uint8 internal constant longer_digits = 36;
    int256 internal constant longer_fixed_log_e_1_5 = 405465108108164381978013115464349137;
    int256 internal constant longer_fixed_1 = 1000000000000000000000000000000000000;
    int256 internal constant longer_fixed_log_e_10 = 2302585092994045684017991454684364208;

    // ROUND_HALF_UP rule helper. 0.5 ≈ 1, 0.4 ≈ 0, -0.5 ≈ -1, -0.4 ≈ 0
    function roundHalfUp(int256 x, int256 y) internal pure returns (int256) {
        require(y > 0, "roundHalfUp only supports y > 0");
        if (x >= 0) {
            return add(x, y / 2);
        }
        return sub(x, y / 2);
    }

    // function roundFloor(int256 x, int256 y) internal pure returns (int256) {
    //     require(y > 0, "roundHalfUp only supports y > 0");
    //     if (x >= 0 || x % _WAD == 0) {
    //         return x;
    //     }
    //     return sub(x, y);
    // }

    // function roundCeil(int256 x, int256 y) internal pure returns (int256) {
    //     require(y > 0, "roundHalfUp only supports y > 0");
    //     if (x <= 0 || x % _WAD == 0) {
    //         return x;
    //     }
    //     return add(x, y);
    // }

    // Log(e, x)
    // solium-disable-next-line security/no-assign-params
    function wln(int256 x) internal pure returns (int256) {
        require(x > 0, "logE of negative number");
        require(x <= 10000000000000000000000000000000000000000, "logE only accepts v <= 1e22 * 1e18"); // in order to prevent using safe-math
        int256 r = 0;
        uint8 extra_digits = longer_digits - fixed_digits;
        int256 t = int256(uint256(10)**uint256(extra_digits));

        while (x <= fixed_1 / 10) {
            x = x * 10;
            r -= longer_fixed_log_e_10;
        }
        while (x >= 10 * fixed_1) {
            x = x / 10;
            r += longer_fixed_log_e_10;
        }
        while (x < fixed_1) {
            x = wmul(x, fixed_e);
            r -= longer_fixed_1;
        }
        while (x > fixed_e) {
            x = wdiv(x, fixed_e);
            r += longer_fixed_1;
        }
        if (x == fixed_1) {
            return roundHalfUp(r, t) / t;
        }
        if (x == fixed_e) {
            return fixed_1 + roundHalfUp(r, t) / t;
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
        r = r + longer_fixed_log_e_1_5;
        int256 a1_5 = (3 * longer_fixed_1) / 2;
        int256 m = (longer_fixed_1 * (x - a1_5)) / (x + a1_5);
        r = r + 2 * m;
        int256 m2 = (m * m) / longer_fixed_1;
        uint8 i = 3;
        while (true) {
            m = (m * m2) / longer_fixed_1;
            r = r + (2 * m) / int256(i);
            i += 2;
            if (i >= 3 + 2 * fixed_digits) {
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
    uint256 private constant _UINT256_MAX = 2**255 - 1;

    function WAD() internal pure returns (uint256) {
        return _WAD;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "Unaddition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "Unsubtraction overflow");
        uint256 c = a - b;

        return c;
    }

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

    function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
        return x <= y ? x : y;
    }

    function max(uint256 x, uint256 y) internal pure returns (uint256 z) {
        return x >= y ? x : y;
    }

    // quotient and remainder
    function pwdiv(uint256 x, uint256 y) internal pure returns (uint256 z, uint256 m) {
        z = wdiv(x, y);
        m = sub(wmul(y, z), x);
    }

    function toInt256(uint256 x) internal pure returns (int256) {
        require(x <= _UINT256_MAX, "uint256 overflow");
        return int256(x);
    }

    function mod(uint256 x, uint256 m) internal pure returns (uint256) {
        require(m != 0, "mod by zero");
        return x % m;
    }

    function ceil(uint256 x, uint256 m) internal pure returns (uint256) {
        require(m > 0, "ceil need m > 0");
        return (sub(add(x, m), 1) / m) * m;
    }
}

library LibEIP712 {
    string internal constant DOMAIN_NAME = "Mai Protocol";

    struct OrderSignature {
        bytes32 config;
        bytes32 r;
        bytes32 s;
    }

    /**
     * Hash of the EIP712 Domain Separator Schema
     */
    bytes32 private constant EIP712_DOMAIN_TYPEHASH = keccak256(abi.encodePacked("EIP712Domain(string name)"));

    bytes32 private constant DOMAIN_SEPARATOR = keccak256(
        abi.encodePacked(EIP712_DOMAIN_TYPEHASH, keccak256(bytes(DOMAIN_NAME)))
    );

    /**
     * Calculates EIP712 encoding for a hash struct in this EIP712 Domain.
     *
     * @param eip712hash The EIP712 hash struct.
     * @return EIP712 hash applied to this EIP712 Domain.
     */
    function hashEIP712Message(bytes32 eip712hash) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, eip712hash));
    }
}

library LibSignature {
    enum SignatureMethod {ETH_SIGN, EIP712}

    struct OrderSignature {
        bytes32 config;
        bytes32 r;
        bytes32 s;
    }

    /**
     * Validate a signature given a hash calculated from the order data, the signer, and the
     * signature data passed in with the order.
     *
     * This function will revert the transaction if the signature method is invalid.
     *
     * @param signature The signature data passed along with the order to validate against
     * @param hash Hash bytes calculated by taking the EIP712 hash of the passed order data
     * @param signerAddress The address of the signer
     * @return True if the calculated signature matches the order signature data, false otherwise.
     */
    function isValidSignature(OrderSignature memory signature, bytes32 hash, address signerAddress)
        internal
        pure
        returns (bool)
    {
        uint8 method = uint8(signature.config[1]);
        address recovered;
        uint8 v = uint8(signature.config[0]);

        if (method == uint8(SignatureMethod.ETH_SIGN)) {
            recovered = ecrecover(
                keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),
                v,
                signature.r,
                signature.s
            );
        } else if (method == uint8(SignatureMethod.EIP712)) {
            recovered = ecrecover(hash, v, signature.r, signature.s);
        } else {
            revert("invalid sign method");
        }

        return signerAddress == recovered;
    }
}

library LibOrder {
    using LibMathSigned for int256;
    using LibMathUnsigned for uint256;

    bytes32 public constant EIP712_ORDER_TYPE = keccak256(
        abi.encodePacked(
            "Order(address trader,address broker,address perpetual,uint256 amount,uint256 price,bytes32 data)"
        )
    );

    int256 public constant FEE_RATE_BASE = 100000;
    uint256 public constant ONE = 1e18;

    struct Order {
        address trader;
        address broker;
        address perpetual;
        uint256 amount;
        uint256 price;
        /**
         * Data contains the following values packed into 32 bytes
         * ╔════════════════════╤═══════════════════════════════════════════════════════════╗
         * ║                    │ length(bytes)   desc                                      ║
         * ╟────────────────────┼───────────────────────────────────────────────────────────╢
         * ║ version            │ 1               order version                             ║
         * ║ side               │ 1               0: buy (long), 1: sell (short)            ║
         * ║ isMarketOrder      │ 1               0: limitOrder, 1: marketOrder             ║
         * ║ expiredAt          │ 5               order expiration time in seconds          ║
         * ║ asMakerFeeRate     │ 2               maker fee rate (base 100,000)             ║
         * ║ asTakerFeeRate     │ 2               taker fee rate (base 100,000)             ║
         * ║ (d) makerRebateRate│ 2               rebate rate for maker (base 100)          ║
         * ║ salt               │ 8               salt                                      ║
         * ║ isMakerOnly        │ 1               is maker only                             ║
         * ║ isInversed         │ 1               is inversed contract                      ║
         * ║                    │ 8               reserved                                  ║
         * ╚════════════════════╧═══════════════════════════════════════════════════════════╝
         */
        bytes32 data;
    }

    struct OrderParam {
        address trader;
        uint256 amount;
        uint256 price;
        bytes32 data;
        LibSignature.OrderSignature signature;
    }

    function getOrderHash(OrderParam memory orderParam, address perpetual, address broker)
        internal
        pure
        returns (bytes32 orderHash)
    {
        Order memory order = getOrder(orderParam, perpetual, broker);
        orderHash = LibEIP712.hashEIP712Message(hashOrder(order));
        return orderHash;
    }

    function getOrderHash(Order memory order) internal pure returns (bytes32 orderHash) {
        orderHash = LibEIP712.hashEIP712Message(hashOrder(order));
        return orderHash;
    }

    function getOrder(OrderParam memory orderParam, address perpetual, address broker)
        internal
        pure
        returns (LibOrder.Order memory order)
    {
        order.trader = orderParam.trader;
        order.broker = broker;
        order.perpetual = perpetual;
        order.amount = orderParam.amount;
        order.price = orderParam.price;
        order.data = orderParam.data;
    }

    function hashOrder(Order memory order) internal pure returns (bytes32 result) {
        bytes32 orderType = EIP712_ORDER_TYPE;
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            let start := sub(order, 32)
            let tmp := mload(start)
            mstore(start, orderType)
            result := keccak256(start, 224)
            mstore(start, tmp)
        }
        return result;
    }

    function getOrderVersion(OrderParam memory orderParam) internal pure returns (uint256) {
        return uint256(uint8(bytes1(orderParam.data)));
    }

    function getExpiredAt(OrderParam memory orderParam) internal pure returns (uint256) {
        return uint256(uint40(bytes5(orderParam.data << (8 * 3))));
    }

    function isSell(OrderParam memory orderParam) internal pure returns (bool) {
        bool sell = uint8(orderParam.data[1]) == 1;
        return isInversed(orderParam) ? !sell : sell;
    }

    function getPrice(OrderParam memory orderParam) internal pure returns (uint256) {
        return isInversed(orderParam) ? ONE.wdiv(orderParam.price) : orderParam.price;
    }

    function isMarketOrder(OrderParam memory orderParam) internal pure returns (bool) {
        return uint8(orderParam.data[2]) == 1;
    }

    function isMarketBuy(OrderParam memory orderParam) internal pure returns (bool) {
        return !isSell(orderParam) && isMarketOrder(orderParam);
    }

    function isMakerOnly(OrderParam memory orderParam) internal pure returns (bool) {
        return uint8(orderParam.data[22]) == 1;
    }

    function isInversed(OrderParam memory orderParam) internal pure returns (bool) {
        return uint8(orderParam.data[23]) == 1;
    }

    function side(OrderParam memory orderParam) internal pure returns (LibTypes.Side) {
        return isSell(orderParam) ? LibTypes.Side.SHORT : LibTypes.Side.LONG;
    }

    function makerFeeRate(OrderParam memory orderParam) internal pure returns (int256) {
        return int256(int16(bytes2(orderParam.data << (8 * 8)))).mul(LibMathSigned.WAD()).div(FEE_RATE_BASE);
    }

    function takerFeeRate(OrderParam memory orderParam) internal pure returns (int256) {
        return int256(int16(bytes2(orderParam.data << (8 * 10)))).mul(LibMathSigned.WAD()).div(FEE_RATE_BASE);
    }
}

library LibTypes {
    enum Side {FLAT, SHORT, LONG}

    enum Status {NORMAL, SETTLING, SETTLED}

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

    // CollateralAccount represents cash account of user
    struct CollateralAccount {
        // currernt deposited erc20 token amount, representing in decimals 18
        int256 balance;
        // the amount of withdrawal applied by user
        // which allowed to withdraw in the future but not available in trading
        int256 appliedBalance;
        // applied balance will be appled only when the block height below is reached
        uint256 appliedHeight;
    }

    struct PositionAccount {
        LibTypes.Side side;
        uint256 size;
        uint256 entryValue;
        int256 entrySocialLoss;
        int256 entryFundingLoss;
    }

    struct BrokerRecord {
        address broker;
        uint256 appliedHeight;
    }

    struct Broker {
        BrokerRecord previous;
        BrokerRecord current;
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

interface IPerpetualProxy {
    // a gas-optimized version of position*
    struct PoolAccount {
        uint256 positionSize;
        uint256 positionEntryValue;
        int256 cashBalance;
        int256 socialLossPerContract;
        int256 positionEntrySocialLoss;
        int256 positionEntryFundingLoss;
    }

    function self() external view returns (address);

    function perpetual() external view returns (address);

    function devAddress() external view returns (address);

    function currentBroker(address guy) external view returns (address);

    function markPrice() external returns (uint256);

    function settlementPrice() external view returns (uint256);

    function availableMargin(address guy) external returns (int256);

    function getPoolAccount() external view returns (PoolAccount memory pool);

    function cashBalance() external view returns (int256);

    function positionSize() external view returns (uint256);

    function positionSide() external view returns (LibTypes.Side);

    function positionEntryValue() external view returns (uint256);

    function positionEntrySocialLoss() external view returns (int256);

    function positionEntryFundingLoss() external view returns (int256);

    // function isEmergency() external view returns (bool);

    // function isGlobalSettled() external view returns (bool);

    function status() external view returns (LibTypes.Status);

    function socialLossPerContract(LibTypes.Side side) external view returns (int256);

    function transferBalanceIn(address from, uint256 amount) external;

    function transferBalanceOut(address to, uint256 amount) external;

    function transferBalanceTo(address from, address to, uint256 amount) external;

    function trade(address guy, LibTypes.Side side, uint256 price, uint256 amount) external returns (uint256);

    function setBrokerFor(address guy, address broker) external;

    function depositFor(address guy, uint256 amount) external;

    function depositEtherFor(address guy) external payable;

    function withdrawFor(address payable guy, uint256 amount) external;

    function isSafe(address guy) external returns (bool);

    function isSafeWithPrice(address guy, uint256 currentMarkPrice) external returns (bool);

    function isProxySafe() external returns (bool);

    function isProxySafeWithPrice(uint256 currentMarkPrice) external returns (bool);

    function isIMSafe(address guy) external returns (bool);

    function isIMSafeWithPrice(address guy, uint256 currentMarkPrice) external returns (bool);

    function lotSize() external view returns (uint256);

    function tradingLotSize() external view returns (uint256);
}

interface IAMM {
    function shareTokenAddress() external view returns (address);

    function lastFundingState() external view returns (LibTypes.FundingState memory);

    function getGovernance() external view returns (LibTypes.AMMGovernanceConfig memory);

    function perpetualProxy() external view returns (IPerpetualProxy);

    function currentMarkPrice() external returns (uint256);

    function currentAvailableMargin() external returns (uint256);

    function currentFairPrice() external returns (uint256);

    function positionSize() external returns (uint256);

    function currentAccumulatedFundingPerContract() external returns (int256);

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
}

interface IPerpetual {
    function devAddress() external view returns (address);

    function getCashBalance(address guy) external view returns (LibTypes.CollateralAccount memory);

    function getPosition(address guy) external view returns (LibTypes.PositionAccount memory);

    function getBroker(address guy) external view returns (LibTypes.Broker memory);

    function getGovernance() external view returns (LibTypes.PerpGovernanceConfig memory);

    function status() external view returns (LibTypes.Status);

    function settlementPrice() external view returns (uint256);

    function globalConfig() external view returns (address);

    function collateral() external view returns (address);

    function isWhitelisted(address account) external view returns (bool);

    function currentBroker(address guy) external view returns (address);

    function amm() external view returns (IAMM);

    function totalSize(LibTypes.Side side) external view returns (uint256);

    function markPrice() external returns (uint256);

    function socialLossPerContract(LibTypes.Side side) external view returns (int256);

    function availableMargin(address guy) external returns (int256);

    function positionMargin(address guy) external view returns (uint256);

    function maintenanceMargin(address guy) external view returns (uint256);

    function isSafe(address guy) external returns (bool);

    function isSafeWithPrice(address guy, uint256 currentMarkPrice) external returns (bool);

    function isIMSafe(address guy) external returns (bool);

    function isIMSafeWithPrice(address guy, uint256 currentMarkPrice) external returns (bool);

    function tradePosition(address guy, LibTypes.Side side, uint256 price, uint256 amount) external returns (uint256);

    function transferCashBalance(address from, address to, uint256 amount) external;

    function setBrokerFor(address guy, address broker) external;

    function depositFor(address guy, uint256 amount) external;

    function depositEtherFor(address guy) external payable;

    function withdrawFor(address payable guy, uint256 amount) external;

    function liquidate(address guy, uint256 amount) external returns (uint256, uint256);

    function liquidateFrom(address from, address guy, uint256 amount) external returns (uint256, uint256);

    function insuranceFundBalance() external view returns (int256);
}

contract Exchange {
    using LibMathSigned for int256;
    using LibMathUnsigned for uint256;
    using LibOrder for LibOrder.Order;
    using LibOrder for LibOrder.OrderParam;
    using LibSignature for LibSignature.OrderSignature;

    uint256 public constant SUPPORTED_ORDER_VERSION = 2;

    enum OrderStatus {EXPIRED, CANCELLED, FILLABLE, FULLY_FILLED}

    mapping(bytes32 => uint256) public filled;
    mapping(bytes32 => bool) public cancelled;

    event MatchWithOrders(
        address perpetual,
        LibOrder.OrderParam takerOrderParam,
        LibOrder.OrderParam makerOrderParam,
        uint256 amount
    );
    event MatchWithAMM(address perpetual, LibOrder.OrderParam takerOrderParam, uint256 amount);
    event Cancel(bytes32 indexed orderHash);

    function matchOrders(
        LibOrder.OrderParam memory takerOrderParam,
        LibOrder.OrderParam[] memory makerOrderParams,
        address _perpetual,
        uint256[] memory amounts
    ) public {
        require(!takerOrderParam.isMakerOnly(), "taker order is maker only");

        IPerpetual perpetual = IPerpetual(_perpetual);
        require(perpetual.status() == LibTypes.Status.NORMAL, "wrong perpetual status");

        uint256 tradingLotSize = perpetual.getGovernance().tradingLotSize;
        bytes32 takerOrderHash = validateOrderParam(perpetual, takerOrderParam);
        uint256 takerFilledAmount = filled[takerOrderHash];
        uint256 takerOpened;

        for (uint256 i = 0; i < makerOrderParams.length; i++) {
            require(takerOrderParam.trader != makerOrderParams[i].trader, "self trade");
            require(takerOrderParam.isInversed() == makerOrderParams[i].isInversed(), "invalid inversed pair");
            require(takerOrderParam.isSell() != makerOrderParams[i].isSell(), "invalid side");
            require(!makerOrderParams[i].isMarketOrder(), "market order cannot be maker");

            validatePrice(takerOrderParam, makerOrderParams[i]);

            bytes32 makerOrderHash = validateOrderParam(perpetual, makerOrderParams[i]);
            uint256 makerFilledAmount = filled[makerOrderHash];

            require(amounts[i] <= takerOrderParam.amount.sub(takerFilledAmount), "taker overfilled");
            require(amounts[i] <= makerOrderParams[i].amount.sub(makerFilledAmount), "maker overfilled");
            require(amounts[i].mod(tradingLotSize) == 0, "invalid trading lot size");

            uint256 opened = fillOrder(perpetual, takerOrderParam, makerOrderParams[i], amounts[i]);

            takerOpened = takerOpened.add(opened);
            filled[makerOrderHash] = makerFilledAmount.add(amounts[i]);
            takerFilledAmount = takerFilledAmount.add(amounts[i]);
        }

        // all trades done, check taker safe.
        if (takerOpened > 0) {
            require(perpetual.isIMSafe(takerOrderParam.trader), "taker margin");
        } else {
            require(perpetual.isSafe(takerOrderParam.trader), "maker unsafe");
        }
        require(perpetual.isSafe(msg.sender), "broker unsafe");

        filled[takerOrderHash] = takerFilledAmount;
    }

    function fillOrder(
        IPerpetual perpetual,
        LibOrder.OrderParam memory takerOrderParam,
        LibOrder.OrderParam memory makerOrderParam,
        uint256 amount
    ) internal returns (uint256) {
        uint256 price = makerOrderParam.getPrice();
        uint256 takerOpened = perpetual.tradePosition(takerOrderParam.trader, takerOrderParam.side(), price, amount);
        uint256 makerOpened = perpetual.tradePosition(makerOrderParam.trader, makerOrderParam.side(), price, amount);

        // trading fee
        int256 takerTradingFee = amount.wmul(price).toInt256().wmul(takerOrderParam.takerFeeRate());
        claimTradingFee(perpetual, takerOrderParam.trader, takerTradingFee);
        int256 makerTradingFee = amount.wmul(price).toInt256().wmul(makerOrderParam.makerFeeRate());
        claimTradingFee(perpetual, makerOrderParam.trader, makerTradingFee);

        // dev fee
        claimTakerDevFee(perpetual, takerOrderParam.trader, price, takerOpened, amount.sub(takerOpened));
        claimMakerDevFee(perpetual, makerOrderParam.trader, price, makerOpened, amount.sub(makerOpened));
        if (makerOpened > 0) {
            require(perpetual.isIMSafe(makerOrderParam.trader), "maker margin");
        } else {
            require(perpetual.isSafe(makerOrderParam.trader), "maker unsafe");
        }

        emit MatchWithOrders(address(perpetual), takerOrderParam, makerOrderParam, amount);

        return takerOpened;
    }

    function matchOrderWithAMM(LibOrder.OrderParam memory takerOrderParam, address _perpetual, uint256 amount) public {
        require(!takerOrderParam.isMakerOnly(), "taker order is maker only");

        IPerpetual perpetual = IPerpetual(_perpetual);
        IAMM amm = IAMM(perpetual.amm());

        require(amount.mod(perpetual.getGovernance().tradingLotSize) == 0, "invalid trading lot size");

        bytes32 takerOrderHash = validateOrderParam(perpetual, takerOrderParam);
        uint256 takerFilledAmount = filled[takerOrderHash];
        require(amount <= takerOrderParam.amount.sub(takerFilledAmount), "taker overfilled");

        // trading with pool
        uint256 takerOpened;
        uint256 price = takerOrderParam.getPrice();
        if (takerOrderParam.isSell()) {
            takerOpened = amm.sellFromWhitelisted(
                takerOrderParam.trader,
                amount,
                price,
                takerOrderParam.getExpiredAt()
            );
        } else {
            takerOpened = amm.buyFromWhitelisted(takerOrderParam.trader, amount, price, takerOrderParam.getExpiredAt());
        }
        filled[takerOrderHash] = filled[takerOrderHash].add(amount);

        emit MatchWithAMM(_perpetual, takerOrderParam, amount);
    }

    function validatePrice(LibOrder.OrderParam memory takerOrderParam, LibOrder.OrderParam memory makerOrderParam)
        internal
        pure
    {
        if (takerOrderParam.isMarketOrder()) {
            return;
        }
        uint256 takerPrice = takerOrderParam.getPrice();
        uint256 makerPrice = makerOrderParam.getPrice();
        require(takerOrderParam.isSell() ? takerPrice <= makerPrice : takerPrice >= makerPrice, "price not match");
    }

    function validateOrderParam(IPerpetual perpetual, LibOrder.OrderParam memory orderParam)
        internal
        view
        returns (bytes32)
    {
        address broker = perpetual.currentBroker(orderParam.trader);
        require(broker == msg.sender, "invalid broker");
        require(orderParam.getOrderVersion() == 2, "unsupported version");
        require(orderParam.getExpiredAt() >= block.timestamp, "order expired");

        bytes32 orderHash = orderParam.getOrderHash(address(perpetual), broker);
        require(orderParam.signature.isValidSignature(orderHash, orderParam.trader), "invalid signature");
        require(filled[orderHash] < orderParam.amount, "fullfilled order");

        return orderHash;
    }

    function claimTradingFee(IPerpetual perpetual, address trader, int256 fee) internal {
        if (fee > 0) {
            perpetual.transferCashBalance(trader, msg.sender, fee.toUint256());
        } else if (fee < 0) {
            perpetual.transferCashBalance(msg.sender, trader, fee.neg().toUint256());
        }
    }

    function cancelOrder(LibOrder.Order memory order) public {
        require(msg.sender == order.trader || msg.sender == order.broker, "invalid caller");

        bytes32 orderHash = order.getOrderHash();
        cancelled[orderHash] = true;

        emit Cancel(orderHash);
    }

    function claimDevFee(
        IPerpetual perpetual,
        address guy,
        uint256 price,
        uint256 openedAmount,
        uint256 closedAmount,
        int256 feeRate
    ) internal {
        if (feeRate == 0) {
            return;
        }
        int256 hard = price.wmul(openedAmount).toInt256().wmul(feeRate);
        int256 soft = price.wmul(closedAmount).toInt256().wmul(feeRate);
        int256 fee = hard.add(soft);
        address devAddress = perpetual.devAddress();
        if (fee > 0) {
            int256 available = perpetual.availableMargin(guy);
            require(available >= hard, "dev margin");
            fee = fee.min(available);
            perpetual.transferCashBalance(guy, devAddress, fee.toUint256());
        } else if (fee < 0) {
            perpetual.transferCashBalance(devAddress, guy, fee.neg().toUint256());
            require(perpetual.isSafe(devAddress), "dev unsafe");
        }
    }

    function claimTakerDevFee(
        IPerpetual perpetual,
        address guy,
        uint256 price,
        uint256 openedAmount,
        uint256 closedAmount
    ) internal {
        int256 rate = perpetual.getGovernance().takerDevFeeRate;
        claimDevFee(perpetual, guy, price, openedAmount, closedAmount, rate);
    }

    function claimMakerDevFee(
        IPerpetual perpetual,
        address guy,
        uint256 price,
        uint256 openedAmount,
        uint256 closedAmount
    ) internal {
        int256 rate = perpetual.getGovernance().makerDevFeeRate;
        claimDevFee(perpetual, guy, price, openedAmount, closedAmount, rate);
    }
}