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

library LibEIP712 {
    string internal constant DOMAIN_NAME = "Mai Protocol";

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

library ECDSA {
    /**
     * @dev Returns the address that signed a hashed message (`hash`) with
     * `signature`. This address can then be used for verification purposes.
     *
     * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
     * this function rejects them by requiring the `s` value to be in the lower
     * half order, and the `v` value to be either 27 or 28.
     *
     * NOTE: This call _does not revert_ if the signature is invalid, or
     * if the signer is otherwise unable to be retrieved. In those scenarios,
     * the zero address is returned.
     *
     * IMPORTANT: `hash` _must_ be the result of a hash operation for the
     * verification to be secure: it is possible to craft signatures that
     * recover to arbitrary addresses for non-hashed data. A safe way to ensure
     * this is by receiving a hash of the original message (which may otherwise
     * be too long), and then calling {toEthSignedMessageHash} on it.
     */
    function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
        // Check the signature length
        if (signature.length != 65) {
            return (address(0));
        }

        // Divide the signature in r, s and v variables
        bytes32 r;
        bytes32 s;
        uint8 v;

        // ecrecover takes the signature parameters, and the only way to get them
        // currently is to use assembly.
        // solhint-disable-next-line no-inline-assembly
        assembly {
            r := mload(add(signature, 0x20))
            s := mload(add(signature, 0x40))
            v := byte(0, mload(add(signature, 0x60)))
        }

        // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
        // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
        // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
        // signatures from current libraries generate a unique signature with an s-value in the lower half order.
        //
        // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
        // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
        // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
        // these malleable signatures as well.
        if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
            return address(0);
        }

        if (v != 27 && v != 28) {
            return address(0);
        }

        // If the signature is valid (and not malleable), return the signer address
        return ecrecover(hash, v, r, s);
    }

    /**
     * @dev Returns an Ethereum Signed Message, created from a `hash`. This
     * replicates the behavior of the
     * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
     * JSON-RPC method.
     *
     * See {recover}.
     */
    function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
        // 32 is the length in bytes of hash,
        // enforced by the type signature above
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
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
     * @param hash Hash bytes calculated by taking the hash of the passed order data
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
            recovered = recover(
                keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),
                v,
                signature.r,
                signature.s
            );
        } else if (method == uint8(SignatureMethod.EIP712)) {
            recovered = recover(hash, v, signature.r, signature.s);
        } else {
            revert("invalid sign method");
        }

        return signerAddress == recovered;
    }

    // see "@openzeppelin/contracts/cryptography/ECDSA.sol"
    function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
        if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
            revert("ECDSA: invalid signature 's' value");
        }

        if (v != 27 && v != 28) {
            revert("ECDSA: invalid signature 'v' value");
        }

        // If the signature is valid (and not malleable), return the signer address
        address signer = ecrecover(hash, v, r, s);
        require(signer != address(0), "ECDSA: invalid signature");

        return signer;
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

library LibOrder {
    using LibMathSigned for int256;
    using LibMathUnsigned for uint256;

    bytes32 public constant EIP712_ORDER_TYPE = keccak256(
        abi.encodePacked(
            "Order(address trader,address broker,address perpetual,uint256 amount,uint256 price,bytes32 data)"
        )
    );

    int256 public constant FEE_RATE_BASE = 10 ** 5;

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
         * ║ chainId            │ 8               chain id                                  ║
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

    /**
     * @dev Get order hash from parameters of order. Rebuild order and hash it.
     *
     * @param orderParam Order parameters.
     * @param perpetual  Address of perpetual contract.
     * @param broker     Address of broker.
     * @return Hash of the order.
     */
    function getOrderHash(
        OrderParam memory orderParam,
        address perpetual,
        address broker
    ) internal pure returns (bytes32 orderHash) {
        Order memory order = getOrder(orderParam, perpetual, broker);
        orderHash = LibEIP712.hashEIP712Message(hashOrder(order));
    }

    /**
     * @dev Get order hash from order.
     *
     * @param order Order to hash.
     * @return Hash of the order.
     */
    function getOrderHash(Order memory order) internal pure returns (bytes32 orderHash) {
        orderHash = LibEIP712.hashEIP712Message(hashOrder(order));
    }

    /**
     * @dev Get order from parameters.
     *
     * @param orderParam Order parameters.
     * @param perpetual  Address of perpetual contract.
     * @param broker     Address of broker.
     * @return Order data structure.
     */
    function getOrder(
        OrderParam memory orderParam,
        address perpetual,
        address broker
    ) internal pure returns (LibOrder.Order memory order) {
        order.trader = orderParam.trader;
        order.broker = broker;
        order.perpetual = perpetual;
        order.amount = orderParam.amount;
        order.price = orderParam.price;
        order.data = orderParam.data;
    }

    /**
     * @dev Hash fields in order to generate a hash as identifier.
     *
     * @param order Order to hash.
     * @return Hash of the order.
     */
    function hashOrder(Order memory order) internal pure returns (bytes32 result) {
        bytes32 orderType = EIP712_ORDER_TYPE;
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            // "Order(address trader,address broker,address perpetual,uint256 amount,uint256 price,bytes32 data)"
            // hash these 6 field to get a hash
            // address will be extended to 32 bytes.
            let start := sub(order, 32)
            let tmp := mload(start)
            mstore(start, orderType)
            // [0...32)   bytes: EIP712_ORDER_TYPE, len 32
            // [32...224) bytes: order, len 6 * 32
            // 224 = 32 + 192
            result := keccak256(start, 224)
            mstore(start, tmp)
        }
    }

    // extract order parameters.

    function orderVersion(OrderParam memory orderParam) internal pure returns (uint256) {
        return uint256(uint8(bytes1(orderParam.data)));
    }

    function expiredAt(OrderParam memory orderParam) internal pure returns (uint256) {
        return uint256(uint40(bytes5(orderParam.data << (8 * 3))));
    }

    function isSell(OrderParam memory orderParam) internal pure returns (bool) {
        bool sell = uint8(orderParam.data[1]) == 1;
        return isInversed(orderParam) ? !sell : sell;
    }

    function getPrice(OrderParam memory orderParam) internal pure returns (uint256) {
        return isInversed(orderParam) ? LibMathUnsigned.WAD().wdiv(orderParam.price) : orderParam.price;
    }

    function isMarketOrder(OrderParam memory orderParam) internal pure returns (bool) {
        return uint8(orderParam.data[2]) > 0;
    }

    function isMarketBuy(OrderParam memory orderParam) internal pure returns (bool) {
        return !isSell(orderParam) && isMarketOrder(orderParam);
    }

    function isMakerOnly(OrderParam memory orderParam) internal pure returns (bool) {
        return uint8(orderParam.data[22]) > 0;
    }

    function isInversed(OrderParam memory orderParam) internal pure returns (bool) {
        return uint8(orderParam.data[23]) > 0;
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

    function chainId(OrderParam memory orderParam) internal pure returns (uint256) {
        return uint256(uint64(bytes8(orderParam.data << (8 * 24))));
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

contract Exchange {
    using LibMathSigned for int256;
    using LibMathUnsigned for uint256;
    using LibOrder for LibOrder.Order;
    using LibOrder for LibOrder.OrderParam;
    using LibSignature for LibSignature.OrderSignature;

    // to verify the field in order data, increase if there are incompatible update in order's data.
    uint256 public constant SUPPORTED_ORDER_VERSION = 2;

    IGlobalConfig public globalConfig;

    // order status
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

    constructor(address _globalConfig) public {
        globalConfig = IGlobalConfig(_globalConfig);
    }

    /**
     * Match orders from one taker and multiple makers.
     *
     * @param takerOrderParam   Taker's order to match.
     * @param makerOrderParams  Array of maker's order to match with.
     * @param _perpetual        Address of perpetual contract.
     * @param amounts           Array of matching amounts of each taker/maker pair.
     */
    function matchOrders(
        LibOrder.OrderParam memory takerOrderParam,
        LibOrder.OrderParam[] memory makerOrderParams,
        address _perpetual,
        uint256[] memory amounts
    ) public {
        require(globalConfig.brokers(msg.sender), "unauthorized broker");
        require(amounts.length > 0 && makerOrderParams.length == amounts.length, "no makers to match");
        require(!takerOrderParam.isMakerOnly(), "taker order is maker only");

        IPerpetual perpetual = IPerpetual(_perpetual);
        require(perpetual.status() == LibTypes.Status.NORMAL, "wrong perpetual status");

        uint256 tradingLotSize = perpetual.getGovernance().tradingLotSize;
        bytes32 takerOrderHash = validateOrderParam(perpetual, takerOrderParam);
        uint256 takerFilledAmount = filled[takerOrderHash];
        uint256 takerOpened;

        for (uint256 i = 0; i < makerOrderParams.length; i++) {
            if (amounts[i] == 0) {
                continue;
            }

            require(takerOrderParam.trader != makerOrderParams[i].trader, "self trade");
            require(takerOrderParam.isInversed() == makerOrderParams[i].isInversed(), "invalid inversed pair");
            require(takerOrderParam.isSell() != makerOrderParams[i].isSell(), "side must be long or short");
            require(!makerOrderParams[i].isMarketOrder(), "market order cannot be maker");

            validatePrice(takerOrderParam, makerOrderParams[i]);

            bytes32 makerOrderHash = validateOrderParam(perpetual, makerOrderParams[i]);
            uint256 makerFilledAmount = filled[makerOrderHash];

            require(amounts[i] <= takerOrderParam.amount.sub(takerFilledAmount), "taker overfilled");
            require(amounts[i] <= makerOrderParams[i].amount.sub(makerFilledAmount), "maker overfilled");
            require(amounts[i].mod(tradingLotSize) == 0, "amount must be divisible by tradingLotSize");

            uint256 opened = fillOrder(perpetual, takerOrderParam, makerOrderParams[i], amounts[i]);

            takerOpened = takerOpened.add(opened);
            filled[makerOrderHash] = makerFilledAmount.add(amounts[i]);
            takerFilledAmount = takerFilledAmount.add(amounts[i]);
        }

        // all trades done, check taker safe.
        if (takerOpened > 0) {
            require(perpetual.isIMSafe(takerOrderParam.trader), "taker initial margin unsafe");
        } else {
            require(perpetual.isSafe(takerOrderParam.trader), "maker unsafe");
        }
        require(perpetual.isSafe(msg.sender), "broker unsafe");

        filled[takerOrderHash] = takerFilledAmount;
    }

    /**
     * @dev Match orders from taker with amm. It is exactly same with directly trading from amm.
     *
     * @param takerOrderParam  Taker's order to match.
     * @param _perpetual        Address of perpetual contract.
     * @param amount           Amount to fiil.
     * @return Opened position amount of taker.
     */
    function matchOrderWithAMM(
        LibOrder.OrderParam memory takerOrderParam,
        address _perpetual,
        uint256 amount
    ) public {
        require(globalConfig.brokers(msg.sender), "unauthorized broker");
        require(amount > 0, "amount must be greater than 0");
        require(!takerOrderParam.isMakerOnly(), "taker order is maker only");

        IPerpetual perpetual = IPerpetual(_perpetual);
        IAMM amm = IAMM(perpetual.amm());

        bytes32 takerOrderHash = validateOrderParam(perpetual, takerOrderParam);
        uint256 takerFilledAmount = filled[takerOrderHash];
        require(amount <= takerOrderParam.amount.sub(takerFilledAmount), "taker overfilled");

        // trading with pool
        uint256 takerOpened;
        uint256 price = takerOrderParam.getPrice();
        uint256 expired = takerOrderParam.expiredAt();
        if (takerOrderParam.isSell()) {
            takerOpened = amm.sellFromWhitelisted(
                takerOrderParam.trader,
                amount,
                price,
                expired
            );
        } else {
            takerOpened = amm.buyFromWhitelisted(takerOrderParam.trader, amount, price, expired);
        }
        filled[takerOrderHash] = filled[takerOrderHash].add(amount);

        emit MatchWithAMM(_perpetual, takerOrderParam, amount);
    }

    /**
     * @dev Cancel order.
     *
     * @param order Order to cancel.
     */
    function cancelOrder(LibOrder.Order memory order) public {
        require(msg.sender == order.trader || msg.sender == order.broker, "invalid caller");

        bytes32 orderHash = order.getOrderHash();
        cancelled[orderHash] = true;

        emit Cancel(orderHash);
    }

    /**
     * @dev Get current chain id. need istanbul hardfork.
     *
     * @return Current chain id.
     */
    function getChainId() public pure returns (uint256 id) {
        assembly {
            id := chainid()
        }
    }

    /**
     * @dev Fill order at the maker's price, then claim trading and dev fee from both side.
     *
     * @param perpetual        Address of perpetual contract.
     * @param takerOrderParam  Taker's order to match.
     * @param makerOrderParam  Maker's order to match.
     * @param amount           Amount to fiil.
     * @return Opened position amount of taker.
     */
    function fillOrder(
        IPerpetual perpetual,
        LibOrder.OrderParam memory takerOrderParam,
        LibOrder.OrderParam memory makerOrderParam,
        uint256 amount
    ) internal returns (uint256) {
        uint256 price = makerOrderParam.getPrice();
        (uint256 takerOpened, uint256 makerOpened) = perpetual.tradePosition(
            takerOrderParam.trader,
            makerOrderParam.trader,
            takerOrderParam.side(),
            price,
            amount
        );

        // trading fee
        int256 takerTradingFee = amount.wmul(price).toInt256().wmul(takerOrderParam.takerFeeRate());
        claimTradingFee(perpetual, takerOrderParam.trader, takerTradingFee);
        int256 makerTradingFee = amount.wmul(price).toInt256().wmul(makerOrderParam.makerFeeRate());
        claimTradingFee(perpetual, makerOrderParam.trader, makerTradingFee);

        // dev fee
        claimTakerDevFee(perpetual, takerOrderParam.trader, price, takerOpened, amount.sub(takerOpened));
        claimMakerDevFee(perpetual, makerOrderParam.trader, price, makerOpened, amount.sub(makerOpened));
        if (makerOpened > 0) {
            require(perpetual.isIMSafe(makerOrderParam.trader), "maker initial margin unsafe");
        } else {
            require(perpetual.isSafe(makerOrderParam.trader), "maker unsafe");
        }

        emit MatchWithOrders(address(perpetual), takerOrderParam, makerOrderParam, amount);

        return takerOpened;
    }

    /**
     * @dev Check prices are meet.
     *
     * @param takerOrderParam  Taker's order.
     * @param takerOrderParam  Maker's order.
     * @return Opened position amount of taker.
     */
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


    /**
     * @dev Validate fields of order.
     *
     * @param perpetual  Instance of perpetual contract.
     * @param orderParam Order parameter.
     * @return Valid order hash.
     */
    function validateOrderParam(IPerpetual perpetual, LibOrder.OrderParam memory orderParam)
        internal
        view
        returns (bytes32)
    {
        require(orderParam.orderVersion() == SUPPORTED_ORDER_VERSION, "unsupported version");
        require(orderParam.expiredAt() >= block.timestamp, "order expired");
        require(orderParam.chainId() == getChainId(), "unmatched chainid");

        bytes32 orderHash = orderParam.getOrderHash(address(perpetual), msg.sender);
        require(!cancelled[orderHash], "cancelled order");
        require(orderParam.signature.isValidSignature(orderHash, orderParam.trader), "invalid signature");
        require(filled[orderHash] < orderParam.amount, "fullfilled order");

        return orderHash;
    }

    /**
     * @dev Claim trading fee. Fee goes to brokers margin account.
     *
     * @param perpetual Address of perpetual contract.
     * @param trader    Address of account who will pay fee out.
     * @param fee       Amount of fee, decimals = 18.
     */
    function claimTradingFee(
        IPerpetual perpetual,
        address trader,
        int256 fee
    )
        internal
    {
        if (fee > 0) {
            perpetual.transferCashBalance(trader, msg.sender, fee.toUint256());
        } else if (fee < 0) {
            perpetual.transferCashBalance(msg.sender, trader, fee.neg().toUint256());
        }
    }


    /**
     * @dev Claim dev fee. Especially, for fee from closing positon
     *
     * @param perpetual     Address of perpetual.
     * @param trader        Address of margin account.
     * @param price         Price of position.
     * @param openedAmount  Opened position amount.
     * @param closedAmount  Closed position amount.
     * @param feeRate       Maker's order.
     */
    function claimDevFee(
        IPerpetual perpetual,
        address trader,
        uint256 price,
        uint256 openedAmount,
        uint256 closedAmount,
        int256 feeRate
    )
        internal
    {
        if (feeRate == 0) {
            return;
        }
        int256 hard = price.wmul(openedAmount).toInt256().wmul(feeRate);
        int256 soft = price.wmul(closedAmount).toInt256().wmul(feeRate);
        int256 fee = hard.add(soft);
        address devAddress = perpetual.devAddress();
        if (fee > 0) {
            int256 available = perpetual.availableMargin(trader);
            require(available >= hard, "available margin too low for fee");
            fee = fee.min(available);
            perpetual.transferCashBalance(trader, devAddress, fee.toUint256());
        } else if (fee < 0) {
            perpetual.transferCashBalance(devAddress, trader, fee.neg().toUint256());
            require(perpetual.isSafe(devAddress), "dev unsafe");
        }
    }

    /**
     * @dev Claim dev fee in taker fee rate set by perpetual governacne.
     *
     * @param perpetual     Address of perpetual.
     * @param trader        Taker's order.
     * @param price         Maker's order.
     * @param openedAmount  Maker's order.
     * @param closedAmount  Maker's order.
     */
    function claimTakerDevFee(
        IPerpetual perpetual,
        address trader,
        uint256 price,
        uint256 openedAmount,
        uint256 closedAmount
    )
        internal
    {
        int256 rate = perpetual.getGovernance().takerDevFeeRate;
        claimDevFee(perpetual, trader, price, openedAmount, closedAmount, rate);
    }

    /**
     * @dev Claim dev fee in maker fee rate set by perpetual governacne.
     *
     * @param perpetual     Address of perpetual.
     * @param trader        Taker's order.
     * @param price         Maker's order.
     * @param openedAmount  Maker's order.
     * @param closedAmount  Maker's order.
     */
    function claimMakerDevFee(
        IPerpetual perpetual,
        address trader,
        uint256 price,
        uint256 openedAmount,
        uint256 closedAmount
    )
        internal
    {
        int256 rate = perpetual.getGovernance().makerDevFeeRate;
        claimDevFee(perpetual, trader, price, openedAmount, closedAmount, rate);
    }
}