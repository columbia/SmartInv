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

contract WhitelistAdminRole {
    using Roles for Roles.Role;

    event WhitelistAdminAdded(address indexed account);
    event WhitelistAdminRemoved(address indexed account);

    Roles.Role private _whitelistAdmins;

    constructor () internal {
        _addWhitelistAdmin(msg.sender);
    }

    modifier onlyWhitelistAdmin() {
        require(isWhitelistAdmin(msg.sender), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
        _;
    }

    function isWhitelistAdmin(address account) public view returns (bool) {
        return _whitelistAdmins.has(account);
    }

    function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
        _addWhitelistAdmin(account);
    }

    function renounceWhitelistAdmin() public {
        _removeWhitelistAdmin(msg.sender);
    }

    function _addWhitelistAdmin(address account) internal {
        _whitelistAdmins.add(account);
        emit WhitelistAdminAdded(account);
    }

    function _removeWhitelistAdmin(address account) internal {
        _whitelistAdmins.remove(account);
        emit WhitelistAdminRemoved(account);
    }
}

contract WhitelistedRole is WhitelistAdminRole {
    using Roles for Roles.Role;

    event WhitelistedAdded(address indexed account);
    event WhitelistedRemoved(address indexed account);

    Roles.Role private _whitelisteds;

    modifier onlyWhitelisted() {
        require(isWhitelisted(msg.sender), "WhitelistedRole: caller does not have the Whitelisted role");
        _;
    }

    function isWhitelisted(address account) public view returns (bool) {
        return _whitelisteds.has(account);
    }

    function addWhitelisted(address account) public onlyWhitelistAdmin {
        _addWhitelisted(account);
    }

    function removeWhitelisted(address account) public onlyWhitelistAdmin {
        _removeWhitelisted(account);
    }

    function renounceWhitelisted() public {
        _removeWhitelisted(msg.sender);
    }

    function _addWhitelisted(address account) internal {
        _whitelisteds.add(account);
        emit WhitelistedAdded(account);
    }

    function _removeWhitelisted(address account) internal {
        _whitelisteds.remove(account);
        emit WhitelistedRemoved(account);
    }
}

contract AMMGovernance is WhitelistedRole {
    using LibMathSigned for int256;
    using LibMathUnsigned for uint256;

    LibTypes.AMMGovernanceConfig internal governance;

    // auto-set when calling setGovernanceParameter
    int256 public emaAlpha2; // 1 - emaAlpha
    int256 public emaAlpha2Ln; // ln(emaAlpha2)

    event UpdateGovernanceParameter(bytes32 indexed key, int256 value);

    function setGovernanceParameter(bytes32 key, int256 value) public onlyWhitelistAdmin {
        if (key == "poolFeeRate") {
            governance.poolFeeRate = value.toUint256();
        } else if (key == "poolDevFeeRate") {
            governance.poolDevFeeRate = value.toUint256();
        } else if (key == "emaAlpha") {
            require(value > 0, "alpha should be > 0");
            governance.emaAlpha = value;
            emaAlpha2 = 10**18 - governance.emaAlpha;
            emaAlpha2Ln = emaAlpha2.wln();
        } else if (key == "updatePremiumPrize") {
            governance.updatePremiumPrize = value.toUint256();
        } else if (key == "markPremiumLimit") {
            governance.markPremiumLimit = value;
        } else if (key == "fundingDampener") {
            governance.fundingDampener = value;
        } else {
            revert("key not exists");
        }
        emit UpdateGovernanceParameter(key, value);
    }

    function getGovernance() public view returns (LibTypes.AMMGovernanceConfig memory) {
        return governance;
    }
}

interface IPriceFeeder {
    function price() external view returns (uint256 lastPrice, uint256 lastTimestamp);
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

contract ERC20 is IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    /**
     * @dev See `IERC20.totalSupply`.
     */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See `IERC20.balanceOf`.
     */
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See `IERC20.transfer`.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    /**
     * @dev See `IERC20.allowance`.
     */
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See `IERC20.approve`.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 value) public returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    /**
     * @dev See `IERC20.transferFrom`.
     *
     * Emits an `Approval` event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of `ERC20`;
     *
     * Requirements:
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `value`.
     * - the caller must have allowance for `sender`'s tokens of at least
     * `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to `approve` that can be used as a mitigation for
     * problems described in `IERC20.approve`.
     *
     * Emits an `Approval` event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to `approve` that can be used as a mitigation for
     * problems described in `IERC20.approve`.
     *
     * Emits an `Approval` event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to `transfer`, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a `Transfer` event.
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

        _balances[sender] = _balances[sender].sub(amount);
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a `Transfer` event with `from` set to the zero address.
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
     * @dev Destoys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a `Transfer` event with `to` set to the zero address.
     *
     * Requirements
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 value) internal {
        require(account != address(0), "ERC20: burn from the zero address");

        _totalSupply = _totalSupply.sub(value);
        _balances[account] = _balances[account].sub(value);
        emit Transfer(account, address(0), value);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
     *
     * This is internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an `Approval` event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 value) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    /**
     * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
     * from the caller's allowance.
     *
     * See `_burn` and `_approve`.
     */
    function _burnFrom(address account, uint256 amount) internal {
        _burn(account, amount);
        _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
    }
}

contract MinterRole {
    using Roles for Roles.Role;

    event MinterAdded(address indexed account);
    event MinterRemoved(address indexed account);

    Roles.Role private _minters;

    constructor () internal {
        _addMinter(msg.sender);
    }

    modifier onlyMinter() {
        require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
        _;
    }

    function isMinter(address account) public view returns (bool) {
        return _minters.has(account);
    }

    function addMinter(address account) public onlyMinter {
        _addMinter(account);
    }

    function renounceMinter() public {
        _removeMinter(msg.sender);
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
     * @dev See `ERC20._mint`.
     *
     * Requirements:
     *
     * - the caller must have the `MinterRole`.
     */
    function mint(address account, uint256 amount) public onlyMinter returns (bool) {
        _mint(account, amount);
        return true;
    }
}

contract ERC20Burnable is ERC20 {
    /**
     * @dev Destoys `amount` tokens from the caller.
     *
     * See `ERC20._burn`.
     */
    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    /**
     * @dev See `ERC20._burnFrom`.
     */
    function burnFrom(address account, uint256 amount) public {
        _burnFrom(account, amount);
    }
}

contract ShareToken is ERC20Mintable {
    uint256 public decimals;
    string public name;
    string public symbol;

    constructor(string memory _name, string memory _symbol, uint256 _decimals) public {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }

    function burn(address account, uint256 amount) public onlyMinter {
        _burn(account, amount);
    }
}

contract AMM is AMMGovernance {
    using LibMathSigned for int256;
    using LibMathUnsigned for uint256;

    uint256 private constant ONE_WAD_U = 10**18;
    int256 private constant ONE_WAD_S = 10**18;

    // interfaces
    ShareToken private shareToken;
    IPerpetualProxy public perpetualProxy;
    IPriceFeeder public priceFeeder;

    // funding
    LibTypes.FundingState internal fundingState;

    event CreateAMM();
    event UpdateFundingRate(LibTypes.FundingState fundingState);

    modifier onlyBroker() {
        require(perpetualProxy.currentBroker(msg.sender) == authorizedBroker(), "invalid broker");
        _;
    }

    constructor(address _perpetualProxy, address _priceFeeder, address _shareToken) public {
        priceFeeder = IPriceFeeder(_priceFeeder);
        perpetualProxy = IPerpetualProxy(_perpetualProxy);
        shareToken = ShareToken(_shareToken);

        emit CreateAMM();
    }

    // view functions
    function authorizedBroker() internal view returns (address) {
        return address(perpetualProxy);
    }

    function shareTokenAddress() public view returns (address) {
        return address(shareToken);
    }

    function indexPrice() public view returns (uint256 price, uint256 timestamp) {
        (price, timestamp) = priceFeeder.price();
        require(price != 0, "dangerous index price");
    }

    function positionSize() public view returns (uint256) {
        return perpetualProxy.positionSize();
    }

    // note: last* functions (lastFundingState, lastAvailableMargin, lastFairPrice, etc.) are calculated based on
    //       the on-chain fundingState. current* functions are calculated based on the current timestamp

    function lastFundingState() public view returns (LibTypes.FundingState memory) {
        return fundingState;
    }

    function lastAvailableMargin() internal view returns (uint256) {
        IPerpetualProxy.PoolAccount memory pool = perpetualProxy.getPoolAccount();
        return availableMarginFromPoolAccount(pool);
    }

    function lastFairPrice() internal view returns (uint256) {
        IPerpetualProxy.PoolAccount memory pool = perpetualProxy.getPoolAccount();
        return fairPriceFromPoolAccount(pool);
    }

    function lastPremium() internal view returns (int256) {
        IPerpetualProxy.PoolAccount memory pool = perpetualProxy.getPoolAccount();
        return premiumFromPoolAccount(pool);
    }

    function lastEMAPremium() internal view returns (int256) {
        return fundingState.lastEMAPremium;
    }

    function lastMarkPrice() internal view returns (uint256) {
        int256 index = fundingState.lastIndexPrice.toInt256();
        int256 limit = index.wmul(governance.markPremiumLimit);
        int256 p = index.add(lastEMAPremium());
        p = p.min(index.add(limit));
        p = p.max(index.sub(limit));
        return p.max(0).toUint256();
    }

    function lastPremiumRate() internal view returns (int256) {
        int256 index = fundingState.lastIndexPrice.toInt256();
        int256 rate = lastMarkPrice().toInt256();
        rate = rate.sub(index).wdiv(index);
        return rate;
    }

    function lastFundingRate() public view returns (int256) {
        int256 rate = lastPremiumRate();
        return rate.max(governance.fundingDampener).add(rate.min(-governance.fundingDampener));
    }

    // Public functions
    // note: current* functions (currentFundingState, currentAvailableMargin, currentFairPrice, etc.) are calculated based on
    //       the current timestamp. current* functions are calculated based on the on-chain fundingState

    function currentFundingState() public returns (LibTypes.FundingState memory) {
        funding();
        return fundingState;
    }

    function currentAvailableMargin() public returns (uint256) {
        funding();
        return lastAvailableMargin();
    }

    function currentFairPrice() public returns (uint256) {
        funding();
        return lastFairPrice();
    }

    function currentPremium() public returns (int256) {
        funding();
        return lastPremium();
    }

    function currentMarkPrice() public returns (uint256) {
        funding();
        return lastMarkPrice();
    }

    function currentPremiumRate() public returns (int256) {
        funding();
        return lastPremiumRate();
    }

    function currentFundingRate() public returns (int256) {
        funding();
        return lastFundingRate();
    }

    function currentAccumulatedFundingPerContract() public returns (int256) {
        funding();
        return fundingState.accumulatedFundingPerContract;
    }

    function createPool(uint256 amount) public {
        require(perpetualProxy.status() == LibTypes.Status.NORMAL, "wrong perpetual status");
        require(positionSize() == 0, "pool not empty");
        require(amount.mod(perpetualProxy.lotSize()) == 0, "invalid lot size");

        address trader = msg.sender;
        uint256 blockTime = getBlockTimestamp();
        uint256 newIndexPrice;
        uint256 newIndexTimestamp;
        (newIndexPrice, newIndexTimestamp) = indexPrice();

        initFunding(newIndexPrice, blockTime);
        perpetualProxy.transferBalanceIn(trader, newIndexPrice.wmul(amount).mul(2));
        uint256 opened = perpetualProxy.trade(trader, LibTypes.Side.SHORT, newIndexPrice, amount);
        mintShareTokenTo(trader, amount);

        forceFunding(); // x, y changed, so fair price changed. we need funding now
        mustSafe(trader, opened);
    }

    function getBuyPrice(uint256 amount) internal returns (uint256 price) {
        uint256 x;
        uint256 y;
        (x, y) = currentXY();
        require(y != 0 && x != 0, "empty pool");
        return x.wdiv(y.sub(amount));
    }

    function buyFrom(address trader, uint256 amount, uint256 limitPrice, uint256 deadline) private returns (uint256) {
        require(perpetualProxy.status() == LibTypes.Status.NORMAL, "wrong perpetual status");
        require(amount.mod(perpetualProxy.tradingLotSize()) == 0, "invalid trading lot size");

        uint256 price = getBuyPrice(amount);
        require(limitPrice >= price, "price limited");
        require(getBlockTimestamp() <= deadline, "deadline exceeded");
        uint256 opened = perpetualProxy.trade(trader, LibTypes.Side.LONG, price, amount);

        uint256 value = price.wmul(amount);
        uint256 fee = value.wmul(governance.poolFeeRate);
        uint256 devFee = value.wmul(governance.poolDevFeeRate);
        address devAddress = perpetualProxy.devAddress();

        perpetualProxy.transferBalanceIn(trader, fee);
        perpetualProxy.transferBalanceTo(trader, devAddress, devFee);

        forceFunding(); // x, y changed, so fair price changed. we need funding now
        mustSafe(trader, opened);
        return opened;
    }

    function buyFromWhitelisted(address trader, uint256 amount, uint256 limitPrice, uint256 deadline)
        public
        onlyWhitelisted
        returns (uint256)
    {
        return buyFrom(trader, amount, limitPrice, deadline);
    }

    function buy(uint256 amount, uint256 limitPrice, uint256 deadline) public onlyBroker returns (uint256) {
        return buyFrom(msg.sender, amount, limitPrice, deadline);
    }

    function getSellPrice(uint256 amount) internal returns (uint256 price) {
        uint256 x;
        uint256 y;
        (x, y) = currentXY();
        require(y != 0 && x != 0, "empty pool");
        return x.wdiv(y.add(amount));
    }

    function sellFrom(address trader, uint256 amount, uint256 limitPrice, uint256 deadline) private returns (uint256) {
        require(perpetualProxy.status() == LibTypes.Status.NORMAL, "wrong perpetual status");
        require(amount.mod(perpetualProxy.tradingLotSize()) == 0, "invalid trading lot size");

        uint256 price = getSellPrice(amount);
        require(limitPrice <= price, "price limited");
        require(getBlockTimestamp() <= deadline, "deadline exceeded");
        uint256 opened = perpetualProxy.trade(trader, LibTypes.Side.SHORT, price, amount);

        uint256 value = price.wmul(amount);
        uint256 fee = value.wmul(governance.poolFeeRate);
        uint256 devFee = value.wmul(governance.poolDevFeeRate);
        address devAddress = perpetualProxy.devAddress();
        perpetualProxy.transferBalanceIn(trader, fee);
        perpetualProxy.transferBalanceTo(trader, devAddress, devFee);

        forceFunding(); // x, y changed, so fair price changed. we need funding now
        mustSafe(trader, opened);
        return opened;
    }

    function sellFromWhitelisted(address trader, uint256 amount, uint256 limitPrice, uint256 deadline)
        public
        onlyWhitelisted
        returns (uint256)
    {
        return sellFrom(trader, amount, limitPrice, deadline);
    }

    function sell(uint256 amount, uint256 limitPrice, uint256 deadline) public onlyBroker returns (uint256) {
        return sellFrom(msg.sender, amount, limitPrice, deadline);
    }

    // sell amount, pay 2 * amount * price collateral
    function addLiquidity(uint256 amount) public onlyBroker {
        require(perpetualProxy.status() == LibTypes.Status.NORMAL, "wrong perpetual status");
        require(amount.mod(perpetualProxy.lotSize()) == 0, "invalid lot size");

        uint256 oldAvailableMargin;
        uint256 oldPoolPositionSize;
        (oldAvailableMargin, oldPoolPositionSize) = currentXY();
        require(oldPoolPositionSize != 0 && oldAvailableMargin != 0, "empty pool");

        address trader = msg.sender;
        uint256 price = oldAvailableMargin.wdiv(oldPoolPositionSize);

        uint256 collateralAmount = amount.wmul(price).mul(2);
        perpetualProxy.transferBalanceIn(trader, collateralAmount);
        uint256 opened = perpetualProxy.trade(trader, LibTypes.Side.SHORT, price, amount);

        mintShareTokenTo(trader, shareToken.totalSupply().wmul(amount).wdiv(oldPoolPositionSize));

        forceFunding(); // x, y changed, so fair price changed. we need funding now
        mustSafe(trader, opened);
    }

    function removeLiquidity(uint256 shareAmount) public onlyBroker {
        require(perpetualProxy.status() == LibTypes.Status.NORMAL, "wrong perpetual status");

        address trader = msg.sender;
        uint256 oldAvailableMargin;
        uint256 oldPoolPositionSize;
        (oldAvailableMargin, oldPoolPositionSize) = currentXY();
        require(oldPoolPositionSize != 0 && oldAvailableMargin != 0, "empty pool");
        require(shareToken.balanceOf(msg.sender) >= shareAmount, "shareBalance limited");
        uint256 price = oldAvailableMargin.wdiv(oldPoolPositionSize);
        uint256 amount = shareAmount.wmul(oldPoolPositionSize).wdiv(shareToken.totalSupply());
        amount = amount.sub(amount.mod(perpetualProxy.lotSize()));

        perpetualProxy.transferBalanceOut(trader, price.wmul(amount).mul(2));
        burnShareTokenFrom(trader, shareAmount);
        uint256 opened = perpetualProxy.trade(trader, LibTypes.Side.LONG, price, amount);

        forceFunding(); // x, y changed, so fair price changed. we need funding now
        mustSafe(trader, opened);
    }

    function settleShare() public {
        require(perpetualProxy.status() == LibTypes.Status.SETTLED, "wrong perpetual status");

        address trader = msg.sender;
        IPerpetualProxy.PoolAccount memory pool = perpetualProxy.getPoolAccount();
        uint256 total = availableMarginFromPoolAccount(pool);
        uint256 shareAmount = shareToken.balanceOf(trader);
        uint256 balance = shareAmount.wmul(total).wdiv(shareToken.totalSupply());
        perpetualProxy.transferBalanceOut(trader, balance);
        burnShareTokenFrom(trader, shareAmount);
    }

    // this is a composite function of perp.setBroker + perp.deposit + amm.buy
    // composite functions accept amount = 0
    function depositAndBuy(uint256 depositAmount, uint256 tradeAmount, uint256 limitPrice, uint256 deadline) public {
        perpetualProxy.setBrokerFor(msg.sender, authorizedBroker());
        if (depositAmount > 0) {
            perpetualProxy.depositFor(msg.sender, depositAmount);
        }
        if (tradeAmount > 0) {
            buy(tradeAmount, limitPrice, deadline);
        }
    }

    // this is a composite function of perp.setBroker + perp.depositEther + amm.buy
    // composite functions accept amount = 0
    function depositEtherAndBuy(uint256 tradeAmount, uint256 limitPrice, uint256 deadline) public payable {
        perpetualProxy.setBrokerFor(msg.sender, authorizedBroker());
        if (msg.value > 0) {
            perpetualProxy.depositEtherFor.value(msg.value)(msg.sender);
        }
        if (tradeAmount > 0) {
            buy(tradeAmount, limitPrice, deadline);
        }
    }

    // this is a composite function of perp.setBroker + perp.deposit + amm.sell
    // composite functions accept amount = 0
    function depositAndSell(uint256 depositAmount, uint256 tradeAmount, uint256 limitPrice, uint256 deadline) public {
        perpetualProxy.setBrokerFor(msg.sender, authorizedBroker());
        if (depositAmount > 0) {
            perpetualProxy.depositFor(msg.sender, depositAmount);
        }
        if (tradeAmount > 0) {
            sell(tradeAmount, limitPrice, deadline);
        }
    }

    // this is a composite function of perp.setBroker + perp.depositEther + amm.sell
    // composite functions accept amount = 0
    function depositEtherAndSell(uint256 tradeAmount, uint256 limitPrice, uint256 deadline) public payable {
        perpetualProxy.setBrokerFor(msg.sender, authorizedBroker());
        if (msg.value > 0) {
            perpetualProxy.depositEtherFor.value(msg.value)(msg.sender);
        }
        if (tradeAmount > 0) {
            sell(tradeAmount, limitPrice, deadline);
        }
    }

    // this is a composite function of perp.setBroker + amm.buy + perp.withdraw
    // composite functions accept amount = 0
    function buyAndWithdraw(uint256 tradeAmount, uint256 limitPrice, uint256 deadline, uint256 withdrawAmount) public {
        perpetualProxy.setBrokerFor(msg.sender, authorizedBroker());
        if (tradeAmount > 0) {
            buy(tradeAmount, limitPrice, deadline);
        }
        if (withdrawAmount > 0) {
            perpetualProxy.withdrawFor(msg.sender, withdrawAmount);
        }
    }

    // this is a composite function of perp.setBroker + amm.sell + perp.withdraw
    // composite functions accept amount = 0
    function sellAndWithdraw(uint256 tradeAmount, uint256 limitPrice, uint256 deadline, uint256 withdrawAmount) public {
        perpetualProxy.setBrokerFor(msg.sender, authorizedBroker());
        if (tradeAmount > 0) {
            sell(tradeAmount, limitPrice, deadline);
        }
        if (withdrawAmount > 0) {
            perpetualProxy.withdrawFor(msg.sender, withdrawAmount);
        }
    }

    // this is a composite function of perp.deposit + perp.setBroker + amm.addLiquidity
    // composite functions accept amount = 0
    function depositAndAddLiquidity(uint256 depositAmount, uint256 amount) public {
        perpetualProxy.setBrokerFor(msg.sender, authorizedBroker());
        if (depositAmount > 0) {
            perpetualProxy.depositFor(msg.sender, depositAmount);
        }
        if (amount > 0) {
            addLiquidity(amount);
        }
    }

    // this is a composite function of perp.deposit + perp.setBroker + amm.addLiquidity
    // composite functions accept amount = 0
    function depositEtherAndAddLiquidity(uint256 amount) public payable {
        perpetualProxy.setBrokerFor(msg.sender, authorizedBroker());
        if (msg.value > 0) {
            perpetualProxy.depositEtherFor.value(msg.value)(msg.sender);
        }
        if (amount > 0) {
            addLiquidity(amount);
        }
    }

    function updateIndex() public {
        uint256 oldIndexPrice = fundingState.lastIndexPrice;
        forceFunding();
        address devAddress = perpetualProxy.devAddress();
        if (oldIndexPrice != fundingState.lastIndexPrice) {
            perpetualProxy.transferBalanceTo(devAddress, msg.sender, governance.updatePremiumPrize);
            require(perpetualProxy.isSafe(devAddress), "dev unsafe");
        }
    }

    function initFunding(uint256 newIndexPrice, uint256 blockTime) private {
        require(fundingState.lastFundingTime == 0, "initalready initialized");
        fundingState.lastFundingTime = blockTime;
        fundingState.lastIndexPrice = newIndexPrice;
        fundingState.lastPremium = 0;
        fundingState.lastEMAPremium = 0;
    }

    // changing conditions for funding:
    // condition 1: time
    // condition 2: indexPrice
    // condition 3: fairPrice - hand over to forceFunding
    function funding() public {
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

    // Internal helpers

    // in order to mock the block.timestamp
    function getBlockTimestamp() internal view returns (uint256) {
        // solium-disable-next-line security/no-block-members
        return block.timestamp;
    }

    // a gas-optimized version of currentAvailableMargin() + positionSize(). almost all formulas require these two
    function currentXY() internal returns (uint256 x, uint256 y) {
        funding();
        IPerpetualProxy.PoolAccount memory pool = perpetualProxy.getPoolAccount();
        x = availableMarginFromPoolAccount(pool);
        y = pool.positionSize;
    }

    // a gas-optimized version of lastAvailableMargin()
    function availableMarginFromPoolAccount(IPerpetualProxy.PoolAccount memory pool) internal view returns (uint256) {
        int256 available = pool.cashBalance;
        available = available.sub(pool.positionEntryValue.toInt256());
        available = available.sub(
            pool.socialLossPerContract.wmul(pool.positionSize.toInt256()).sub(pool.positionEntrySocialLoss)
        );
        available = available.sub(
            fundingState.accumulatedFundingPerContract.wmul(pool.positionSize.toInt256()).sub(
                pool.positionEntryFundingLoss
            )
        );
        return available.max(0).toUint256();
    }

    // a gas-optimized version of lastFairPrice
    function fairPriceFromPoolAccount(IPerpetualProxy.PoolAccount memory pool) internal view returns (uint256) {
        uint256 y = pool.positionSize;
        require(y > 0, "funding initialization required");
        uint256 x = availableMarginFromPoolAccount(pool);
        return x.wdiv(y);
    }

    // a gas-optimized version of lastPremium
    function premiumFromPoolAccount(IPerpetualProxy.PoolAccount memory pool) internal view returns (int256) {
        int256 p = fairPriceFromPoolAccount(pool).toInt256();
        p = p.sub(fundingState.lastIndexPrice.toInt256());
        return p;
    }

    function mustSafe(address trader, uint256 opened) internal {
        // perpetual.markPrice is a little different from ours
        uint256 perpetualMarkPrice = perpetualProxy.markPrice();
        if (opened > 0) {
            require(perpetualProxy.isIMSafeWithPrice(trader, perpetualMarkPrice), "im unsafe");
        }
        require(perpetualProxy.isSafeWithPrice(trader, perpetualMarkPrice), "sender unsafe");
        require(perpetualProxy.isProxySafeWithPrice(perpetualMarkPrice), "amm unsafe");
    }

    function mintShareTokenTo(address guy, uint256 amount) internal {
        shareToken.mint(guy, amount);
    }

    function burnShareTokenFrom(address guy, uint256 amount) internal {
        shareToken.burn(guy, amount);
    }

    function forceFunding() internal {
        uint256 blockTime = getBlockTimestamp();
        uint256 newIndexPrice;
        uint256 newIndexTimestamp;
        (newIndexPrice, newIndexTimestamp) = indexPrice();
        forceFunding(blockTime, newIndexPrice, newIndexTimestamp);
    }

    function forceFunding(uint256 blockTime, uint256 newIndexPrice, uint256 newIndexTimestamp) internal {
        if (fundingState.lastFundingTime == 0) {
            // funding initialization required. but in this case, it's safe to just do nothing and return
            return;
        }
        IPerpetualProxy.PoolAccount memory pool = perpetualProxy.getPoolAccount();
        if (pool.positionSize == 0) {
            // empty pool. it's safe to just do nothing and return
            return;
        }

        if (newIndexTimestamp > fundingState.lastFundingTime) {
            // the 1st update
            nextStateWithTimespan(pool, newIndexPrice, newIndexTimestamp);
        }
        // the 2nd update;
        nextStateWithTimespan(pool, newIndexPrice, blockTime);

        emit UpdateFundingRate(fundingState);
    }

    function nextStateWithTimespan(IPerpetualProxy.PoolAccount memory pool, uint256 newIndexPrice, uint256 endTimestamp)
        private
    {
        require(fundingState.lastFundingTime != 0, "funding initialization required");
        require(endTimestamp >= fundingState.lastFundingTime, "we can't go back in time");

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
                acc.div(8 * 3600)
            ); // ema is according to the old index
            fundingState.lastFundingTime = endTimestamp;
        }

        // always update
        fundingState.lastIndexPrice = newIndexPrice; // should update before premium()
        fundingState.lastPremium = premiumFromPoolAccount(pool);
    }

    // solve t in emaPremium == y equation
    function timeOnFundingCurve(
        int256 y,
        int256 v0, // lastEMAPremium
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
        require(t < ONE_WAD_S, "no solution 3 on funding curve");
        t = t.wln();
        t = t.wdiv(emaAlpha2Ln);
        t = t.ceil(ONE_WAD_S) / ONE_WAD_S;
    }

    // sum emaPremium curve between [x, y)
    function integrateOnFundingCurve(
        int256 x, // normal int, not WAD
        int256 y, // normal int, not WAD
        int256 v0, // lastEMAPremium
        int256 _lastPremium
    ) internal view returns (int256 r) {
        require(x <= y, "integrate reversed");
        r = v0.sub(_lastPremium);
        r = r.wmul(emaAlpha2.wpowi(x).sub(emaAlpha2.wpowi(y)));
        r = r.wdiv(governance.emaAlpha);
        r = r.add(_lastPremium.mul(y.sub(x)));
    }

    struct AccumulatedFundingCalculator {
        int256 vLimit;
        int256 vDampener;
        int256 t1; // normal int, not WAD
        int256 t2; // normal int, not WAD
        int256 t3; // normal int, not WAD
        int256 t4; // normal int, not WAD
    }

    function getAccumulatedFunding(
        int256 n, // time span. normal int, not WAD
        int256 v0, // lastEMAPremium
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