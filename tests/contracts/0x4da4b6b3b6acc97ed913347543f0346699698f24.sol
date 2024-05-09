// File: @openzeppelin/contracts/utils/math/SignedMath.sol


// OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)

pragma solidity ^0.8.0;

/**
 * @dev Standard signed math utilities missing in the Solidity language.
 */
library SignedMath {
    /**
     * @dev Returns the largest of two signed numbers.
     */
    function max(int256 a, int256 b) internal pure returns (int256) {
        return a > b ? a : b;
    }

    /**
     * @dev Returns the smallest of two signed numbers.
     */
    function min(int256 a, int256 b) internal pure returns (int256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two signed numbers without overflow.
     * The result is rounded towards zero.
     */
    function average(int256 a, int256 b) internal pure returns (int256) {
        // Formula from the book "Hacker's Delight"
        int256 x = (a & b) + ((a ^ b) >> 1);
        return x + (int256(uint256(x) >> 255) & (a ^ b));
    }

    /**
     * @dev Returns the absolute unsigned value of a signed value.
     */
    function abs(int256 n) internal pure returns (uint256) {
        unchecked {
            // must be unchecked in order to support `n = type(int256).min`
            return uint256(n >= 0 ? n : -n);
        }
    }
}

// File: @openzeppelin/contracts/utils/math/Math.sol


// OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)

pragma solidity ^0.8.0;

/**
 * @dev Standard math utilities missing in the Solidity language.
 */
library Math {
    enum Rounding {
        Down, // Toward negative infinity
        Up, // Toward infinity
        Zero // Toward zero
    }

    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a > b ? a : b;
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
        // (a + b) / 2 can overflow.
        return (a & b) + (a ^ b) / 2;
    }

    /**
     * @dev Returns the ceiling of the division of two numbers.
     *
     * This differs from standard division with `/` in that it rounds up instead
     * of rounding down.
     */
    function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b - 1) / b can overflow on addition, so we distribute.
        return a == 0 ? 0 : (a - 1) / b + 1;
    }

    /**
     * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
     * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
     * with further edits by Uniswap Labs also under MIT license.
     */
    function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
        unchecked {
            // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
            // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
            // variables such that product = prod1 * 2^256 + prod0.
            uint256 prod0; // Least significant 256 bits of the product
            uint256 prod1; // Most significant 256 bits of the product
            assembly {
                let mm := mulmod(x, y, not(0))
                prod0 := mul(x, y)
                prod1 := sub(sub(mm, prod0), lt(mm, prod0))
            }

            // Handle non-overflow cases, 256 by 256 division.
            if (prod1 == 0) {
                // Solidity will revert if denominator == 0, unlike the div opcode on its own.
                // The surrounding unchecked block does not change this fact.
                // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
                return prod0 / denominator;
            }

            // Make sure the result is less than 2^256. Also prevents denominator == 0.
            require(denominator > prod1, "Math: mulDiv overflow");

            ///////////////////////////////////////////////
            // 512 by 256 division.
            ///////////////////////////////////////////////

            // Make division exact by subtracting the remainder from [prod1 prod0].
            uint256 remainder;
            assembly {
                // Compute remainder using mulmod.
                remainder := mulmod(x, y, denominator)

                // Subtract 256 bit number from 512 bit number.
                prod1 := sub(prod1, gt(remainder, prod0))
                prod0 := sub(prod0, remainder)
            }

            // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
            // See https://cs.stackexchange.com/q/138556/92363.

            // Does not overflow because the denominator cannot be zero at this stage in the function.
            uint256 twos = denominator & (~denominator + 1);
            assembly {
                // Divide denominator by twos.
                denominator := div(denominator, twos)

                // Divide [prod1 prod0] by twos.
                prod0 := div(prod0, twos)

                // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
                twos := add(div(sub(0, twos), twos), 1)
            }

            // Shift in bits from prod1 into prod0.
            prod0 |= prod1 * twos;

            // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
            // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
            // four bits. That is, denominator * inv = 1 mod 2^4.
            uint256 inverse = (3 * denominator) ^ 2;

            // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
            // in modular arithmetic, doubling the correct bits in each step.
            inverse *= 2 - denominator * inverse; // inverse mod 2^8
            inverse *= 2 - denominator * inverse; // inverse mod 2^16
            inverse *= 2 - denominator * inverse; // inverse mod 2^32
            inverse *= 2 - denominator * inverse; // inverse mod 2^64
            inverse *= 2 - denominator * inverse; // inverse mod 2^128
            inverse *= 2 - denominator * inverse; // inverse mod 2^256

            // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
            // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
            // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
            // is no longer required.
            result = prod0 * inverse;
            return result;
        }
    }

    /**
     * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
     */
    function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
        uint256 result = mulDiv(x, y, denominator);
        if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
            result += 1;
        }
        return result;
    }

    /**
     * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
     *
     * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
     */
    function sqrt(uint256 a) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
        //
        // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
        // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
        //
        // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
        // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
        // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
        //
        // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
        uint256 result = 1 << (log2(a) >> 1);

        // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
        // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
        // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
        // into the expected uint128 result.
        unchecked {
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            return min(result, a / result);
        }
    }

    /**
     * @notice Calculates sqrt(a), following the selected rounding direction.
     */
    function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = sqrt(a);
            return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 2, rounded down, of a positive value.
     * Returns 0 if given 0.
     */
    function log2(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >> 128 > 0) {
                value >>= 128;
                result += 128;
            }
            if (value >> 64 > 0) {
                value >>= 64;
                result += 64;
            }
            if (value >> 32 > 0) {
                value >>= 32;
                result += 32;
            }
            if (value >> 16 > 0) {
                value >>= 16;
                result += 16;
            }
            if (value >> 8 > 0) {
                value >>= 8;
                result += 8;
            }
            if (value >> 4 > 0) {
                value >>= 4;
                result += 4;
            }
            if (value >> 2 > 0) {
                value >>= 2;
                result += 2;
            }
            if (value >> 1 > 0) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log2(value);
            return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 10, rounded down, of a positive value.
     * Returns 0 if given 0.
     */
    function log10(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >= 10 ** 64) {
                value /= 10 ** 64;
                result += 64;
            }
            if (value >= 10 ** 32) {
                value /= 10 ** 32;
                result += 32;
            }
            if (value >= 10 ** 16) {
                value /= 10 ** 16;
                result += 16;
            }
            if (value >= 10 ** 8) {
                value /= 10 ** 8;
                result += 8;
            }
            if (value >= 10 ** 4) {
                value /= 10 ** 4;
                result += 4;
            }
            if (value >= 10 ** 2) {
                value /= 10 ** 2;
                result += 2;
            }
            if (value >= 10 ** 1) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log10(value);
            return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 256, rounded down, of a positive value.
     * Returns 0 if given 0.
     *
     * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
     */
    function log256(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >> 128 > 0) {
                value >>= 128;
                result += 16;
            }
            if (value >> 64 > 0) {
                value >>= 64;
                result += 8;
            }
            if (value >> 32 > 0) {
                value >>= 32;
                result += 4;
            }
            if (value >> 16 > 0) {
                value >>= 16;
                result += 2;
            }
            if (value >> 8 > 0) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log256(value);
            return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
        }
    }
}

// File: @openzeppelin/contracts/utils/Strings.sol


// OpenZeppelin Contracts (last updated v4.9.0) (utils/Strings.sol)

pragma solidity ^0.8.0;



/**
 * @dev String operations.
 */
library Strings {
    bytes16 private constant _SYMBOLS = "0123456789abcdef";
    uint8 private constant _ADDRESS_LENGTH = 20;

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        unchecked {
            uint256 length = Math.log10(value) + 1;
            string memory buffer = new string(length);
            uint256 ptr;
            /// @solidity memory-safe-assembly
            assembly {
                ptr := add(buffer, add(32, length))
            }
            while (true) {
                ptr--;
                /// @solidity memory-safe-assembly
                assembly {
                    mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
                }
                value /= 10;
                if (value == 0) break;
            }
            return buffer;
        }
    }

    /**
     * @dev Converts a `int256` to its ASCII `string` decimal representation.
     */
    function toString(int256 value) internal pure returns (string memory) {
        return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
     */
    function toHexString(uint256 value) internal pure returns (string memory) {
        unchecked {
            return toHexString(value, Math.log256(value) + 1);
        }
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
     */
    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }

    /**
     * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
     */
    function toHexString(address addr) internal pure returns (string memory) {
        return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
    }

    /**
     * @dev Returns true if the two strings are equal.
     */
    function equal(string memory a, string memory b) internal pure returns (bool) {
        return keccak256(bytes(a)) == keccak256(bytes(b));
    }
}

// File: @unlock-protocol/contracts/dist/PublicLock/IPublicLockV13.sol


pragma solidity >=0.5.17 <0.9.0;
pragma experimental ABIEncoderV2;

/**
 * @title The PublicLock Interface
 */

interface IPublicLockV13 {
  /// Functions
  function initialize(
    address _lockCreator,
    uint _expirationDuration,
    address _tokenAddress,
    uint _keyPrice,
    uint _maxNumberOfKeys,
    string calldata _lockName
  ) external;

  // default role from OpenZeppelin
  function DEFAULT_ADMIN_ROLE()
    external
    view
    returns (bytes32 role);

  /**
   * @notice The version number of the current implementation on this network.
   * @return The current version number.
   */
  function publicLockVersion()
    external
    pure
    returns (uint16);

  /**
   * @dev Called by lock manager to withdraw all funds from the lock
   * @param _tokenAddress specifies the token address to withdraw or 0 for ETH. This is usually
   * the same as `tokenAddress` in MixinFunds.
   * @param _recipient specifies the address that will receive the tokens
   * @param _amount specifies the max amount to withdraw, which may be reduced when
   * considering the available balance. Set to 0 or MAX_UINT to withdraw everything.
   * -- however be wary of draining funds as it breaks the `cancelAndRefund` and `expireAndRefundFor` use cases.
   */
  function withdraw(
    address _tokenAddress,
    address payable _recipient,
    uint _amount
  ) external;

  /**
   * A function which lets a Lock manager of the lock to change the price for future purchases.
   * @dev Throws if called by other than a Lock manager
   * @dev Throws if lock has been disabled
   * @dev Throws if _tokenAddress is not a valid token
   * @param _keyPrice The new price to set for keys
   * @param _tokenAddress The address of the erc20 token to use for pricing the keys,
   * or 0 to use ETH
   */
  function updateKeyPricing(
    uint _keyPrice,
    address _tokenAddress
  ) external;

  /**
   * Update the main key properties for the entire lock:
   *
   * - default duration of each key
   * - the maximum number of keys the lock can edit
   * - the maximum number of keys a single address can hold
   *
   * @notice keys previously bought are unaffected by this changes in expiration duration (i.e.
   * existing keys timestamps are not recalculated/updated)
   * @param _newExpirationDuration the new amount of time for each key purchased or type(uint).max for a non-expiring key
   * @param _maxKeysPerAcccount the maximum amount of key a single user can own
   * @param _maxNumberOfKeys uint the maximum number of keys
   * @dev _maxNumberOfKeys Can't be smaller than the existing supply
   */
  function updateLockConfig(
    uint _newExpirationDuration,
    uint _maxNumberOfKeys,
    uint _maxKeysPerAcccount
  ) external;

  /**
   * Checks if the user has a non-expired key.
   * @param _user The address of the key owner
   */
  function getHasValidKey(
    address _user
  ) external view returns (bool);

  /**
   * @dev Returns the key's ExpirationTimestamp field for a given owner.
   * @param _tokenId the id of the key
   * @dev Returns 0 if the owner has never owned a key for this lock
   */
  function keyExpirationTimestampFor(
    uint _tokenId
  ) external view returns (uint timestamp);

  /**
   * Public function which returns the total number of unique owners (both expired
   * and valid).  This may be larger than totalSupply.
   */
  function numberOfOwners() external view returns (uint);

  /**
   * Allows the Lock owner to assign
   * @param _lockName a descriptive name for this Lock.
   * @param _lockSymbol a Symbol for this Lock (default to KEY).
   * @param _baseTokenURI the baseTokenURI for this Lock
   */
  function setLockMetadata(
    string calldata _lockName,
    string calldata _lockSymbol,
    string calldata _baseTokenURI
  ) external;

  /**
   * @dev Gets the token symbol
   * @return string representing the token symbol
   */
  function symbol() external view returns (string memory);

  /**  @notice A distinct Uniform Resource Identifier (URI) for a given asset.
   * @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
   *  3986. The URI may point to a JSON file that conforms to the "ERC721
   *  Metadata JSON Schema".
   * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
   * @param _tokenId The tokenID we're inquiring about
   * @return String representing the URI for the requested token
   */
  function tokenURI(
    uint256 _tokenId
  ) external view returns (string memory);

  /**
   * Allows a Lock manager to add or remove an event hook
   * @param _onKeyPurchaseHook Hook called when the `purchase` function is called
   * @param _onKeyCancelHook Hook called when the internal `_cancelAndRefund` function is called
   * @param _onValidKeyHook Hook called to determine if the contract should overide the status for a given address
   * @param _onTokenURIHook Hook called to generate a data URI used for NFT metadata
   * @param _onKeyTransferHook Hook called when a key is transfered
   * @param _onKeyExtendHook Hook called when a key is extended or renewed
   * @param _onKeyGrantHook Hook called when a key is granted
   */
  function setEventHooks(
    address _onKeyPurchaseHook,
    address _onKeyCancelHook,
    address _onValidKeyHook,
    address _onTokenURIHook,
    address _onKeyTransferHook,
    address _onKeyExtendHook,
    address _onKeyGrantHook
  ) external;

  /**
   * Allows a Lock manager to give a collection of users a key with no charge.
   * Each key may be assigned a different expiration date.
   * @dev Throws if called by other than a Lock manager
   * @param _recipients An array of receiving addresses
   * @param _expirationTimestamps An array of expiration Timestamps for the keys being granted
   * @return the ids of the granted tokens
   */
  function grantKeys(
    address[] calldata _recipients,
    uint[] calldata _expirationTimestamps,
    address[] calldata _keyManagers
  ) external returns (uint256[] memory);

  /**
   * Allows the Lock owner to extend an existing keys with no charge.
   * @param _tokenId The id of the token to extend
   * @param _duration The duration in secondes to add ot the key
   * @dev set `_duration` to 0 to use the default duration of the lock
   */
  function grantKeyExtension(
    uint _tokenId,
    uint _duration
  ) external;

  /**
   * @dev Purchase function
   * @param _values array of tokens amount to pay for this purchase >= the current keyPrice - any applicable discount
   * (_values is ignored when using ETH)
   * @param _recipients array of addresses of the recipients of the purchased key
   * @param _referrers array of addresses of the users making the referral
   * @param _keyManagers optional array of addresses to grant managing rights to a specific address on creation
   * @param _data array of arbitrary data populated by the front-end which initiated the sale
   * @notice when called for an existing and non-expired key, the `_keyManager` param will be ignored
   * @dev Setting _value to keyPrice exactly doubles as a security feature. That way if the lock owner increases the
   * price while my transaction is pending I can't be charged more than I expected (only applicable to ERC-20 when more
   * than keyPrice is approved for spending).
   * @return tokenIds the ids of the created tokens
   */
  function purchase(
    uint256[] calldata _values,
    address[] calldata _recipients,
    address[] calldata _referrers,
    address[] calldata _keyManagers,
    bytes[] calldata _data
  ) external payable returns (uint256[] memory tokenIds);

  /**
   * @dev Extend function
   * @param _value the number of tokens to pay for this purchase >= the current keyPrice - any applicable discount
   * (_value is ignored when using ETH)
   * @param _tokenId the id of the key to extend
   * @param _referrer address of the user making the referral
   * @param _data arbitrary data populated by the front-end which initiated the sale
   * @dev Throws if lock is disabled or key does not exist for _recipient. Throws if _recipient == address(0).
   */
  function extend(
    uint _value,
    uint _tokenId,
    address _referrer,
    bytes calldata _data
  ) external payable;

  /**
   * Returns the percentage of the keyPrice to be sent to the referrer (in basis points)
   * @param _referrer the address of the referrer
   * @return referrerFee the percentage of the keyPrice to be sent to the referrer (in basis points)
   */
  function referrerFees(
    address _referrer
  ) external view returns (uint referrerFee);

  /**
   * Set a specific percentage of the keyPrice to be sent to the referrer while purchasing,
   * extending or renewing a key.
   * @param _referrer the address of the referrer
   * @param _feeBasisPoint the percentage of the price to be used for this
   * specific referrer (in basis points)
   * @dev To send a fixed percentage of the key price to all referrers, sett a percentage to `address(0)`
   */
  function setReferrerFee(
    address _referrer,
    uint _feeBasisPoint
  ) external;

  /**
   * Merge existing keys
   * @param _tokenIdFrom the id of the token to substract time from
   * @param _tokenIdTo the id of the destination token  to add time
   * @param _amount the amount of time to transfer (in seconds)
   */
  function mergeKeys(
    uint _tokenIdFrom,
    uint _tokenIdTo,
    uint _amount
  ) external;

  /**
   * Deactivate an existing key
   * @param _tokenId the id of token to burn
   * @notice the key will be expired and ownership records will be destroyed
   */
  function burn(uint _tokenId) external;

  /**
   * @param _gasRefundValue price in wei or token in smallest price unit
   * @dev Set the value to be refunded to the sender on purchase
   */
  function setGasRefundValue(
    uint256 _gasRefundValue
  ) external;

  /**
   * _gasRefundValue price in wei or token in smallest price unit
   * @dev Returns the value/price to be refunded to the sender on purchase
   */
  function gasRefundValue()
    external
    view
    returns (uint256 _gasRefundValue);

  /**
   * @notice returns the minimum price paid for a purchase with these params.
   * @dev this considers any discount from Unlock or the OnKeyPurchase hook.
   */
  function purchasePriceFor(
    address _recipient,
    address _referrer,
    bytes calldata _data
  ) external view returns (uint);

  /**
   * Allow a Lock manager to change the transfer fee.
   * @dev Throws if called by other than a Lock manager
   * @param _transferFeeBasisPoints The new transfer fee in basis-points(bps).
   * Ex: 200 bps = 2%
   */
  function updateTransferFee(
    uint _transferFeeBasisPoints
  ) external;

  /**
   * Determines how much of a fee would need to be paid in order to
   * transfer to another account.  This is pro-rated so the fee goes
   * down overtime.
   * @dev Throws if _tokenId does not have a valid key
   * @param _tokenId The id of the key check the transfer fee for.
   * @param _time The amount of time to calculate the fee for.
   * @return The transfer fee in seconds.
   */
  function getTransferFee(
    uint _tokenId,
    uint _time
  ) external view returns (uint);

  /**
   * @dev Invoked by a Lock manager to expire the user's key
   * and perform a refund and cancellation of the key
   * @param _tokenId The key id we wish to refund to
   * @param _amount The amount to refund to the key-owner
   * @dev Throws if called by other than a Lock manager
   * @dev Throws if _keyOwner does not have a valid key
   */
  function expireAndRefundFor(
    uint _tokenId,
    uint _amount
  ) external;

  /**
   * @dev allows the key manager to expire a given tokenId
   * and send a refund to the keyOwner based on the amount of time remaining.
   * @param _tokenId The id of the key to cancel.
   * @notice cancel is enabled with a 10% penalty by default on all Locks.
   */
  function cancelAndRefund(uint _tokenId) external;

  /**
   * Allow a Lock manager to change the refund penalty.
   * @dev Throws if called by other than a Lock manager
   * @param _freeTrialLength The new duration of free trials for this lock
   * @param _refundPenaltyBasisPoints The new refund penaly in basis-points(bps)
   */
  function updateRefundPenalty(
    uint _freeTrialLength,
    uint _refundPenaltyBasisPoints
  ) external;

  /**
   * @dev Determines how much of a refund a key owner would receive if they issued
   * @param _tokenId the id of the token to get the refund value for.
   * @notice Due to the time required to mine a tx, the actual refund amount will be lower
   * than what the user reads from this call.
   * @return refund the amount of tokens refunded
   */
  function getCancelAndRefundValue(
    uint _tokenId
  ) external view returns (uint refund);

  function addLockManager(address account) external;

  function isLockManager(
    address account
  ) external view returns (bool);

  /**
   * Returns the address of the `onKeyPurchaseHook` hook.
   * @return hookAddress address of the hook
   */
  function onKeyPurchaseHook()
    external
    view
    returns (address hookAddress);

  /**
   * Returns the address of the `onKeyCancelHook` hook.
   * @return hookAddress address of the hook
   */
  function onKeyCancelHook()
    external
    view
    returns (address hookAddress);

  /**
   * Returns the address of the `onValidKeyHook` hook.
   * @return hookAddress address of the hook
   */
  function onValidKeyHook()
    external
    view
    returns (address hookAddress);

  /**
   * Returns the address of the `onTokenURIHook` hook.
   * @return hookAddress address of the hook
   */
  function onTokenURIHook()
    external
    view
    returns (address hookAddress);

  /**
   * Returns the address of the `onKeyTransferHook` hook.
   * @return hookAddress address of the hook
   */
  function onKeyTransferHook()
    external
    view
    returns (address hookAddress);

  /**
   * Returns the address of the `onKeyExtendHook` hook.
   * @return hookAddress the address ok the hook
   */
  function onKeyExtendHook()
    external
    view
    returns (address hookAddress);

  /**
   * Returns the address of the `onKeyGrantHook` hook.
   * @return hookAddress the address ok the hook
   */
  function onKeyGrantHook()
    external
    view
    returns (address hookAddress);

  function renounceLockManager() external;

  /**
   * @return the maximum number of key allowed for a single address
   */
  function maxKeysPerAddress() external view returns (uint);

  function expirationDuration()
    external
    view
    returns (uint256);

  function freeTrialLength()
    external
    view
    returns (uint256);

  function keyPrice() external view returns (uint256);

  function maxNumberOfKeys()
    external
    view
    returns (uint256);

  function refundPenaltyBasisPoints()
    external
    view
    returns (uint256);

  function tokenAddress() external view returns (address);

  function transferFeeBasisPoints()
    external
    view
    returns (uint256);

  function unlockProtocol() external view returns (address);

  function keyManagerOf(
    uint
  ) external view returns (address);

  ///===================================================================

  /**
   * @notice Allows the key owner to safely share their key (parent key) by
   * transferring a portion of the remaining time to a new key (child key).
   * @dev Throws if key is not valid.
   * @dev Throws if `_to` is the zero address
   * @param _to The recipient of the shared key
   * @param _tokenId the key to share
   * @param _timeShared The amount of time shared
   * checks if `_to` is a smart contract (code size > 0). If so, it calls
   * `onERC721Received` on `_to` and throws if the return value is not
   * `bytes4(keccak256('onERC721Received(address,address,uint,bytes)'))`.
   * @dev Emit Transfer event
   */
  function shareKey(
    address _to,
    uint _tokenId,
    uint _timeShared
  ) external;

  /**
   * @notice Update transfer and cancel rights for a given key
   * @param _tokenId The id of the key to assign rights for
   * @param _keyManager The address to assign the rights to for the given key
   */
  function setKeyManagerOf(
    uint _tokenId,
    address _keyManager
  ) external;

  /**
   * Check if a certain key is valid
   * @param _tokenId the id of the key to check validity
   * @notice this makes use of the onValidKeyHook if it is set
   */
  function isValidKey(
    uint _tokenId
  ) external view returns (bool);

  /**
   * Returns the number of keys owned by `_keyOwner` (expired or not)
   * @param _keyOwner address for which we are retrieving the total number of keys
   * @return numberOfKeys total number of keys owned by the address
   */
  function totalKeys(
    address _keyOwner
  ) external view returns (uint numberOfKeys);

  /// @notice A descriptive name for a collection of NFTs in this contract
  function name()
    external
    view
    returns (string memory _name);

  ///===================================================================

  /// From ERC165.sol
  function supportsInterface(
    bytes4 interfaceId
  ) external view returns (bool);

  ///===================================================================

  /// From ERC-721
  /**
   * In the specific case of a Lock, `balanceOf` returns only the tokens with a valid expiration timerange
   * @return balance The number of valid keys owned by `_keyOwner`
   */
  function balanceOf(
    address _owner
  ) external view returns (uint256 balance);

  /**
   * @dev Returns the owner of the NFT specified by `tokenId`.
   */
  function ownerOf(
    uint256 tokenId
  ) external view returns (address _owner);

  /**
   * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
   * another (`to`).
   *
   * Requirements:
   * - `from`, `to` cannot be zero.
   * - `tokenId` must be owned by `from`.
   * - If the caller is not `from`, it must be have been allowed to move this
   * NFT by either {approve} or {setApprovalForAll}.
   */
  function safeTransferFrom(
    address from,
    address to,
    uint256 tokenId
  ) external;

  /**
   * an ERC721-like function to transfer a token from one account to another.
   * @param from the owner of token to transfer
   * @param to the address that will receive the token
   * @param tokenId the id of the token
   * @dev Requirements: if the caller is not `from`, it must be approved to move this token by
   * either {approve} or {setApprovalForAll}.
   * The key manager will be reset to address zero after the transfer
   */
  function transferFrom(
    address from,
    address to,
    uint256 tokenId
  ) external;

  /**
   * Lending a key allows you to transfer the token while retaining the
   * ownerships right by setting yourself as a key manager first.
   * @param from the owner of token to transfer
   * @param to the address that will receive the token
   * @param tokenId the id of the token
   * @notice This function can only be called by 1) the key owner when no key manager is set or 2) the key manager.
   * After calling the function, the `_recipent` will be the new owner, and the sender of the tx
   * will become the key manager.
   */
  function lendKey(
    address from,
    address to,
    uint tokenId
  ) external;

  /**
   * Unlend is called when you have lent a key and want to claim its full ownership back.
   * @param _recipient the address that will receive the token ownership
   * @param _tokenId the id of the token
   * @dev Only the key manager of the token can call this function
   */
  function unlendKey(
    address _recipient,
    uint _tokenId
  ) external;

  function approve(address to, uint256 tokenId) external;

  /**
   * @notice Get the approved address for a single NFT
   * @dev Throws if `_tokenId` is not a valid NFT.
   * @param _tokenId The NFT to find the approved address for
   * @return operator The approved address for this NFT, or the zero address if there is none
   */
  function getApproved(
    uint256 _tokenId
  ) external view returns (address operator);

  /**
   * @dev Sets or unsets the approval of a given operator
   * An operator is allowed to transfer all tokens of the sender on their behalf
   * @param _operator operator address to set the approval
   * @param _approved representing the status of the approval to be set
   * @notice disabled when transfers are disabled
   */
  function setApprovalForAll(
    address _operator,
    bool _approved
  ) external;

  /**
   * @dev Tells whether an operator is approved by a given keyManager
   * @param _owner owner address which you want to query the approval of
   * @param _operator operator address which you want to query the approval of
   * @return bool whether the given operator is approved by the given owner
   */
  function isApprovedForAll(
    address _owner,
    address _operator
  ) external view returns (bool);

  function safeTransferFrom(
    address from,
    address to,
    uint256 tokenId,
    bytes calldata data
  ) external;

  /**
   * Returns the total number of keys, including non-valid ones
   * @return _totalKeysCreated the total number of keys, valid or not
   */
  function totalSupply() external view returns (uint256 _totalKeysCreated);

  function tokenOfOwnerByIndex(
    address _owner,
    uint256 index
  ) external view returns (uint256 tokenId);

  function tokenByIndex(
    uint256 index
  ) external view returns (uint256);

  /**
   * Innherited from Open Zeppelin AccessControl.sol
   */
  function getRoleAdmin(
    bytes32 role
  ) external view returns (bytes32);

  function grantRole(
    bytes32 role,
    address account
  ) external;

  function revokeRole(
    bytes32 role,
    address account
  ) external;

  function renounceRole(
    bytes32 role,
    address account
  ) external;

  function hasRole(
    bytes32 role,
    address account
  ) external view returns (bool);

  /** `owner()` is provided as an helper to mimick the `Ownable` contract ABI.
   * The `Ownable` logic is used by many 3rd party services to determine
   * contract ownership - e.g. who is allowed to edit metadata on Opensea.
   *
   * @notice This logic is NOT used internally by the Unlock Protocol and is made
   * available only as a convenience helper.
   */
  function owner() external view returns (address owner);

  function setOwner(address account) external;

  function isOwner(
    address account
  ) external view returns (bool isOwner);

  /**
   * Migrate data from the previous single owner => key mapping to
   * the new data structure w multiple tokens.
   * @param _calldata an ABI-encoded representation of the params (v10: the number of records to migrate as `uint`)
   * @dev when all record schemas are sucessfully upgraded, this function will update the `schemaVersion`
   * variable to the latest/current lock version
   */
  function migrate(bytes calldata _calldata) external;

  /**
   * Returns the version number of the data schema currently used by the lock
   * @notice if this is different from `publicLockVersion`, then the ability to purchase, grant
   * or extend keys is disabled.
   * @dev will return 0 if no ;igration has ever been run
   */
  function schemaVersion() external view returns (uint);

  /**
   * Set the schema version to the latest
   * @notice only lock manager call call this
   */
  function updateSchemaVersion() external;

  /**
   * Renew a given token
   * @notice only works for non-free, expiring, ERC20 locks
   * @param _tokenId the ID fo the token to renew
   * @param _referrer the address of the person to be granted UDT
   */
  function renewMembershipFor(
    uint _tokenId,
    address _referrer
  ) external;

  /**
   * @dev helper to check if a key is currently renewable 
   * it will revert if the pricing or duration of the lock have been modified 
   * unfavorably since the key was bought(price increase or duration decrease).
   * It will also revert if a lock is not renewable or if the key is not ready for renewal yet 
   * (at least 90% expired).
   * @param tokenId the id of the token to check
   * @param referrer the address where to send the referrer fee
   * @return true if the terms has changed
   */
  function isRenewable(uint256 tokenId, address referrer) external view returns (bool);
}

// File: @openzeppelin/contracts/security/ReentrancyGuard.sol


// OpenZeppelin Contracts (last updated v4.9.0) (security/ReentrancyGuard.sol)

pragma solidity ^0.8.0;

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
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be _NOT_ENTERED
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
     * `nonReentrant` function in the call stack.
     */
    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == _ENTERED;
    }
}

// File: @openzeppelin/contracts/utils/math/SafeMath.sol


// OpenZeppelin Contracts (last updated v4.9.0) (utils/math/SafeMath.sol)

pragma solidity ^0.8.0;

// CAUTION
// This version of SafeMath should only be used with Solidity 0.8 or later,
// because it relies on the compiler's built in overflow checks.

/**
 * @dev Wrappers over Solidity's arithmetic operations.
 *
 * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
 * now has built in overflow checking.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

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
        return a + b;
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
        return a - b;
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
        return a * b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
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
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
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
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
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
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

// File: @openzeppelin/contracts/utils/introspection/IERC165.sol


// OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// File: @openzeppelin/contracts/token/ERC721/IERC721.sol


// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC721/IERC721.sol)

pragma solidity ^0.8.0;


/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
     * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
     * understand this adds an external call which potentially creates a reentrancy vulnerability.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool approved) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol


// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
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

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

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
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

// File: contracts/RFStakePoolV2.sol



// RavenFund - $RAVEN
//
// The raven symbolizes prophecy, insight, transformation, and intelligence. It also represents long-term success.
// The 1st AI-powered hedge fund
//
// https://www.ravenfund.app/
// https://twitter.com/RavenFund
// https://t.me/RavenFundPortal

pragma solidity ^0.8.19;







interface IRavenFundStaking {
    function stakingToken() external view returns (IERC20);
    function rewardsProvider() external view returns (address);
    function teamWallet() external view returns (address);
    function owner() external view returns (address);
    function lockSubNFT(uint256 _index) external view returns (IPublicLockV13, IERC721);
    function maxStakeAmount() external view returns (uint256);
    function minClaimAmount() external view returns (uint256);
    function stakeWaitTime() external view returns (uint256);
    function claimInterval() external view returns (uint256);
    function timeElapsedFactor() external view returns (uint256);
    function rewardResetInterval() external view returns (uint256);
    function malusNoSubscription() external view returns (uint256);
    function totalDistributed() external view returns (uint256);
    function enableClaim() external view returns (bool);
    function enableStake() external view returns (bool);
    function activateSendTeam() external view returns (bool);
    function totalStakedAmount() external view returns (uint256);
    function fundDeposits(uint256 _index) external view returns (uint256, uint256);
    function consolidatedFunds() external view returns (uint256);
    function stakers(address _address) external view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256);
    function stakerAddresses(uint256 _index) external view returns (address);
}

contract RavenFundStakingV2 is ReentrancyGuard {
    using SafeMath for uint256;

    IRavenFundStaking public ravenFundStakingV1;
    address public ravenFundStakingOldAddress;
    IERC20 public stakingToken;
    address public rewardsProvider;
    address public teamWallet;
    address public owner;
    Lockers[] public lockSubNFT;

    struct Lockers {
        IPublicLockV13 instance;
        IERC721 nft;
    }

    uint256 public maxStakeAmount = 0;
    uint256 public minClaimAmount = 15_000 ether;
    uint256 public stakeWaitTime = 12 hours;
    uint256 public claimInterval = 24 hours;
    uint256 public timeElapsedFactor = 7 days;
    uint256 public rewardResetInterval = 15 days;
    uint256 public malusNoSubscription = 70;
    uint256 public totalDistributed = 0;

    bool public enableClaim = false;
    bool public enableStake = false;
    bool public activateSendTeam = true;
    bool public activateConsolidate = true;
    bool public activateRestore = true;

    struct StakerInfo {
        uint256 amountStaked;
        uint256 lastStakeTime;
        uint256 lastClaimTime;
        uint256 rewardsEarned;
        uint256 rewardsClaimed;
        uint256 lastRewardUpdateTime;
        uint256 keyArray;
        bool restoring;
    }

    uint256 public totalStakedAmount;

    struct Funds {
        uint256 amount;
        uint256 depositTime;
    }

    Funds[] public fundDeposits;
    uint256 public consolidatedFunds = 0;

    mapping(address => StakerInfo) public stakers;
    address[] public stakerAddresses;

    constructor(address _stakingToken, address _rewardsProvider, address _teamWallet) {
        stakingToken = IERC20(_stakingToken);
        rewardsProvider = _rewardsProvider;
        teamWallet = _teamWallet;
        owner = msg.sender;
        ravenFundStakingV1 = IRavenFundStaking(address(0xeb94e7cD446a15DCab9C5d04dc5Bb805E528DCbb));
    }

    modifier onlyRewardsProvider() {
        require(msg.sender == rewardsProvider || msg.sender == owner || msg.sender == teamWallet, "Not the rewards provider");
        _;
    }

    function stake(uint256 amount) external nonReentrant {
        require(enableStake, "Stake not enabled.");
        (uint256 amountStaked, uint256 lastStakeTime, uint256 lastClaimTime, uint256 rewardsEarned, uint256 rewardsClaimed, uint256 lastRewardUpdateTime, uint256 keyArray) = ravenFundStakingV1.stakers(msg.sender);
        require(amountStaked <= 0, "Restore your token to the new contract before");
        StakerInfo storage staker = stakers[msg.sender];
        require(staker.restoring == false, "Finish restore before stake again");
        if (maxStakeAmount > 0) {
            require(staker.amountStaked + amount <= maxStakeAmount, "Max stake amount reached");
        }

        if (staker.lastRewardUpdateTime == 0) {
            staker.lastRewardUpdateTime = block.timestamp;
        }

        if (staker.keyArray == 0){
            stakerAddresses.push(msg.sender);
            staker.keyArray = stakerAddresses.length;
        }

        uint256 allowance = stakingToken.allowance(msg.sender, address(this));
        require(allowance >= amount, "Allowance is not sufficient to stake tokens");

        staker.lastStakeTime = block.timestamp;
        staker.amountStaked = staker.amountStaked.add(amount);
        totalStakedAmount = totalStakedAmount.add(amount);

        require(stakingToken.transferFrom(msg.sender, address(this), amount), "Token transfer failed");
    }

    function withdraw(uint256 amount) external nonReentrant {
        StakerInfo storage staker = stakers[msg.sender];

        require(amount > 0, "Amount must be greater than 0");
        require(staker.amountStaked >= amount, "Insufficient staked amount");

        staker.amountStaked = staker.amountStaked.sub(amount);
        totalStakedAmount = totalStakedAmount.sub(amount);

        if (staker.amountStaked <= 0) {
            uint256 reward = staker.rewardsEarned;
            staker.rewardsEarned = 0;
            staker.lastClaimTime = block.timestamp;
            uint256 contractBalance = address(this).balance;
            if (reward > 0 && contractBalance >= reward && activateSendTeam){
                calibrateFundArray(reward);

                payable(teamWallet).transfer(reward);
            }
        }

        require(stakingToken.transfer(msg.sender, amount), "Token transfer failed");
    }

    function canRestore(address stakerAddress) public view returns (bool) {
        (uint256 amountStaked, uint256 lastStakeTime, uint256 lastClaimTime, uint256 rewardsEarned, uint256 rewardsClaimed, uint256 lastRewardUpdateTime, uint256 keyArray) = ravenFundStakingV1.stakers(stakerAddress);
        if (amountStaked > 0)
        {
            StakerInfo storage staker = stakers[stakerAddress];
            if (staker.amountStaked <= 0)
            {
                return true;
            }
        }
        return false;
    }

    function restoreStep1() external nonReentrant {
        require(canRestore(msg.sender), "You cannot restore data");
        require(activateRestore, "You cannot restore data");
        (uint256 amountStaked, uint256 lastStakeTime, uint256 lastClaimTime, uint256 rewardsEarned, uint256 rewardsClaimed, uint256 lastRewardUpdateTime, uint256 keyArray) = ravenFundStakingV1.stakers(msg.sender);

        stakers[msg.sender] = StakerInfo(amountStaked, lastStakeTime, lastClaimTime, rewardsEarned, rewardsClaimed, lastRewardUpdateTime, keyArray, true);
        stakerAddresses.push(msg.sender);
        stakers[msg.sender].keyArray = stakerAddresses.length;

        //withdraw with contract old
    }

    function restoreStep2() external nonReentrant {
        // after withdraw with contract old
        StakerInfo storage staker = stakers[msg.sender];
        require(staker.amountStaked > 0, "Nothing to restore");
        require(staker.restoring, "Not in restore mode");

        uint256 allowance = stakingToken.allowance(msg.sender, address(this));
        require(allowance >= staker.amountStaked, "Allowance is not sufficient to stake tokens");

        require(stakingToken.transferFrom(msg.sender, address(this), staker.amountStaked), "Token transfer failed");

        staker.restoring = false;
        totalStakedAmount = totalStakedAmount.add(staker.amountStaked);
    }

    function canClaim(address stakerAddress) public view returns (bool) {
        StakerInfo storage staker = stakers[stakerAddress];
        uint256 reward = previewStakerRewards(stakerAddress);
        uint256 contractBalance = address(this).balance;
        return enableClaim && reward > 0 && contractBalance >= reward && (staker.amountStaked >= minClaimAmount) && (block.timestamp > staker.lastStakeTime + stakeWaitTime) && (block.timestamp > staker.lastClaimTime + claimInterval);
    }

    function reasonClaim(address stakerAddress) public view returns (string memory) {
        StakerInfo storage staker = stakers[stakerAddress];
        uint256 reward = previewStakerRewards(stakerAddress);
        uint256 contractBalance = address(this).balance;
        if (!enableClaim){
            return "Claim not enabled, please wait a moment.";
        }
        if (staker.amountStaked < minClaimAmount) {
            return string(abi.encodePacked("To be eligible, you have to stake a minimum $RAVEN of ", Strings.toString(minClaimAmount.div(1 ether))));
        }
        if (block.timestamp <= staker.lastStakeTime + stakeWaitTime) {
            return Strings.toString(staker.lastStakeTime + stakeWaitTime);
        }
        if (block.timestamp <= staker.lastClaimTime + claimInterval) {
            return Strings.toString(staker.lastClaimTime + claimInterval);
        }
        if (reward <= 0){
            return "You don't have any reward to claim for the moment.";
        }
        if (contractBalance < reward) {
            return "Please wait new funds to claim your reward.";
        }
        return "You can claim !";
    }

    function claim() external nonReentrant {
        require(enableClaim, "Claim not enabled.");
        StakerInfo storage staker = stakers[msg.sender];
        require(staker.amountStaked >= minClaimAmount, "Not enough tokens staked to claim.");
        require(block.timestamp > staker.lastStakeTime + stakeWaitTime, "Need to wait after staking");
        require(block.timestamp > staker.lastClaimTime + claimInterval, "Already claimed recently");

        updateStakerRewards(msg.sender);

        uint256 reward = staker.rewardsEarned;
        require(reward > 0, "No rewards available");

        uint256 contractBalance = address(this).balance;
        require(contractBalance >= reward, "Not enough ETH in the contract");

        calibrateFundArray(reward);
        staker.rewardsEarned = 0;
        staker.lastClaimTime = block.timestamp;
        staker.rewardsClaimed = staker.rewardsClaimed.add(reward);
        totalDistributed = totalDistributed.add(reward);

        payable(msg.sender).transfer(reward);
    }

    function previewStakerRewards(address stakerAddress) public view returns (uint256) {
        StakerInfo storage staker = stakers[stakerAddress];

        if (staker.amountStaked < minClaimAmount || totalStakedAmount <= 0 || timeElapsedFactor <= 0) {
            return staker.rewardsEarned;
        }

        uint256 totalReward = 0;
        for(uint256 i = 0; i < fundDeposits.length; i++) {
            if (fundDeposits[i].amount == 0) {
                continue;
            }
            uint256 referenceTime = max(staker.lastRewardUpdateTime, fundDeposits[i].depositTime);
            uint256 timeElapsed = block.timestamp.sub(referenceTime);
            
            uint256 timeFactor;
            if(timeElapsed >= timeElapsedFactor) {
                timeFactor = 1 ether;
            } else {
                timeFactor = timeElapsed.mul(1 ether).div(timeElapsedFactor);
            }
            
            uint256 stakerShare = staker.amountStaked.mul(1 ether).div(totalStakedAmount);
            uint256 rewardFromThisDeposit = fundDeposits[i].amount.mul(stakerShare).div(1 ether);
            rewardFromThisDeposit = rewardFromThisDeposit.mul(timeFactor).div(1 ether);

            if (!ownsActiveNFT(stakerAddress)) {
                rewardFromThisDeposit = rewardFromThisDeposit.mul(malusNoSubscription).div(100);
            }

            totalReward = totalReward.add(rewardFromThisDeposit);
        }
        // Then add rewards from consolidated funds
        uint256 timeElapsedConsolidated = block.timestamp.sub(staker.lastRewardUpdateTime);
        uint256 timeFactorConsolidated;
        if(timeElapsedConsolidated >= timeElapsedFactor) {
            timeFactorConsolidated = 1 ether;
        } else {
            timeFactorConsolidated = timeElapsedConsolidated.mul(1 ether).div(timeElapsedFactor);
        }
        uint256 stakerShareFromConsolidated = staker.amountStaked.mul(1 ether).div(totalStakedAmount);
        uint256 rewardFromConsolidated = consolidatedFunds.mul(stakerShareFromConsolidated).div(1 ether);
        rewardFromConsolidated = rewardFromConsolidated.mul(timeFactorConsolidated).div(1 ether);
        if (!ownsActiveNFT(stakerAddress)) {
            rewardFromConsolidated = rewardFromConsolidated.mul(malusNoSubscription).div(100);
        }

        totalReward = totalReward.add(rewardFromConsolidated);

        return staker.rewardsEarned.add(totalReward);
    }

    function updateStakerRewards(address stakerAddress) internal {
        StakerInfo storage staker = stakers[stakerAddress];

        if (staker.amountStaked < minClaimAmount || totalStakedAmount <= 0 || timeElapsedFactor <= 0) {
            staker.lastRewardUpdateTime = block.timestamp;
            return;
        }

        uint256 totalReward = 0;
        for(uint256 i = 0; i < fundDeposits.length; i++) {
            if (fundDeposits[i].amount == 0) {
                continue;
            }
            uint256 referenceTime = max(staker.lastRewardUpdateTime, fundDeposits[i].depositTime);
            uint256 timeElapsed = block.timestamp.sub(referenceTime);
            
            uint256 timeFactor;
            if(timeElapsed >= timeElapsedFactor) {
                timeFactor = 1 ether;
            } else {
                timeFactor = timeElapsed.mul(1 ether).div(timeElapsedFactor);
            }
            
            uint256 stakerShare = staker.amountStaked.mul(1 ether).div(totalStakedAmount);
            uint256 rewardFromThisDeposit = fundDeposits[i].amount.mul(stakerShare).div(1 ether);
            rewardFromThisDeposit = rewardFromThisDeposit.mul(timeFactor).div(1 ether);

            if (!ownsActiveNFT(stakerAddress)) {
                rewardFromThisDeposit = rewardFromThisDeposit.mul(malusNoSubscription).div(100);
            }

            totalReward = totalReward.add(rewardFromThisDeposit);
        }
        // Then add rewards from consolidated funds
        uint256 timeElapsedConsolidated = block.timestamp.sub(staker.lastRewardUpdateTime);
        uint256 timeFactorConsolidated;
        if(timeElapsedConsolidated >= timeElapsedFactor) {
            timeFactorConsolidated = 1 ether;
        } else {
            timeFactorConsolidated = timeElapsedConsolidated.mul(1 ether).div(timeElapsedFactor);
        }
        uint256 stakerShareFromConsolidated = staker.amountStaked.mul(1 ether).div(totalStakedAmount);
        uint256 rewardFromConsolidated = consolidatedFunds.mul(stakerShareFromConsolidated).div(1 ether);
        rewardFromConsolidated = rewardFromConsolidated.mul(timeFactorConsolidated).div(1 ether);
        if (!ownsActiveNFT(stakerAddress)) {
            rewardFromConsolidated = rewardFromConsolidated.mul(malusNoSubscription).div(100);
        }

        totalReward = totalReward.add(rewardFromConsolidated);
        staker.rewardsEarned = staker.rewardsEarned.add(totalReward);
        staker.lastRewardUpdateTime = block.timestamp;
    }

    function consolidateFunds() private {
        Funds[] memory newFundDeposits = new Funds[](fundDeposits.length);

        uint256 count = 0;
        for (uint256 i = 0; i < fundDeposits.length; i++) {
            uint256 timeElapsed = block.timestamp.sub(fundDeposits[i].depositTime);
            if (timeElapsed >= timeElapsedFactor) {
                consolidatedFunds = consolidatedFunds.add(fundDeposits[i].amount);
            } else {
                newFundDeposits[count] = fundDeposits[i];
                count++;
            }
        }

        if (count > 0) {
            if (fundDeposits.length != count) {
                while (fundDeposits.length > count) {
                    fundDeposits.pop();
                }
                
                for (uint256 i = 0; i < count; i++) {
                    fundDeposits[i] = newFundDeposits[i];
                }
            }
        } else {
            delete fundDeposits;
        }
    }

    function getTotalAvailableRewards() public view returns (uint256) {
        uint256 totalAvailable = consolidatedFunds;

        for (uint256 i = 0; i < fundDeposits.length; i++) {
            totalAvailable = totalAvailable.add(fundDeposits[i].amount);
        }

        return totalAvailable;
    }

    receive() external payable {}

    function depositETH() external payable onlyRewardsProvider {
        fundDeposits.push(Funds({
            amount: msg.value,
            depositTime: block.timestamp
        }));

        if (activateConsolidate){
            consolidateFunds();
        }
    }

    function withdrawFunds() external onlyRewardsProvider {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        payable(msg.sender).transfer(balance);

        delete fundDeposits;
        consolidatedFunds = 0;
    }

    function getStakersArray() public view returns (address[] memory) {
        return stakerAddresses;
    }

    function getFundDepositsArray() public view returns (Funds[] memory) {
        return fundDeposits;
    }

    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a > b ? a : b;
    }

    function calibrateFundArray(uint256 amount) private {
        uint256 rewardLeftToClaim = amount;
        for (uint256 i = 0; i < fundDeposits.length && rewardLeftToClaim > 0; i++) {
            if (fundDeposits[i].amount == 0) {
                continue;
            }
            if (fundDeposits[i].amount <= rewardLeftToClaim) {
                rewardLeftToClaim = rewardLeftToClaim.sub(fundDeposits[i].amount);
                delete fundDeposits[i];
            } else {
                fundDeposits[i].amount = fundDeposits[i].amount.sub(rewardLeftToClaim);
                rewardLeftToClaim = 0;
            }
        }
        if (rewardLeftToClaim > 0 && consolidatedFunds > 0) {
            if (consolidatedFunds <= rewardLeftToClaim) {
                rewardLeftToClaim = rewardLeftToClaim.sub(consolidatedFunds);
                consolidatedFunds = 0;
            } else {
                consolidatedFunds = consolidatedFunds.sub(rewardLeftToClaim);
                rewardLeftToClaim = 0;
            }
        }
    }

    function ownsActiveNFT(address _user) public view returns (bool) {
        for (uint256 i = 0; i < lockSubNFT.length; i++) {
            if (lockSubNFT[i].instance.getHasValidKey(_user)) {
                return true;
            }
        }
        return false;
    }

    function ownsActiveNFTList(address _user) public view returns (address[] memory) {
        uint256 activeCount = 0;
        for (uint256 i = 0; i < lockSubNFT.length; i++) {
            if (lockSubNFT[i].instance.getHasValidKey(_user)) {
                activeCount++;
            }
        }
        address[] memory activeLockersAddress = new address[](activeCount);

        uint256 j = 0;
        for (uint256 i = 0; i < lockSubNFT.length; i++) {
            if (lockSubNFT[i].instance.getHasValidKey(_user)) {
                activeLockersAddress[j] = address(lockSubNFT[i].nft);
                j++;
            }
        }

        return activeLockersAddress;
    }

    function cleanFundDeposits() external onlyRewardsProvider {
        delete fundDeposits;
    }

    function cleanLockers() external onlyRewardsProvider {
        delete lockSubNFT;
    }

    function setSubscriptionLockers(address[] calldata _lockers) external onlyRewardsProvider {
        for (uint i = 0; i < _lockers.length; i++) {
            address currentLocker = _lockers[i];
            Lockers memory lock;
            lock.instance = IPublicLockV13(currentLocker);
            lock.nft = IERC721(currentLocker);
            lockSubNFT.push(lock);
        }
    }

    function enableContract(bool _c, bool _s) external onlyRewardsProvider {
        enableClaim = _c;
        enableStake = _s;
    }

    function setTotalStakedAmount(uint256 _amount) external onlyRewardsProvider {
        totalStakedAmount = _amount;
    }

    function setRewardsProvider(address _provider) external onlyRewardsProvider {
        rewardsProvider = _provider;
    }

    function setOwner(address _owner) external onlyRewardsProvider {
        owner = _owner;
    }

    function setMaxStakeAmount(uint256 _amount) external onlyRewardsProvider {
        maxStakeAmount = _amount;
    }

    function setMinClaimAmount(uint256 _amount) external onlyRewardsProvider {
        minClaimAmount = _amount;
    }

    function setStakeWaitTime(uint256 _time) external onlyRewardsProvider {
        stakeWaitTime = _time;
    }

    function setClaimInterval(uint256 _interval) external onlyRewardsProvider {
        claimInterval = _interval;
    }

    function setTimeElapsedFactor(uint256 _time) external onlyRewardsProvider {
        timeElapsedFactor = _time;
    }

    function setMalusNoSubscription(uint256 _malus) external onlyRewardsProvider {
        malusNoSubscription = _malus;
    }

    function setRewardResetInterval(uint256 _reset) external onlyRewardsProvider {
        rewardResetInterval = _reset;
    }

    function setTotalDistributed(uint256 _t) external onlyRewardsProvider {
        totalDistributed = _t;
    }

    function setActivateSendTeam(bool _a) external onlyRewardsProvider {
        activateSendTeam = _a;
    }

    function setActivateConsolidate(bool _c) external onlyRewardsProvider {
        activateConsolidate = _c;
    }

    function setActivateRestore(bool _r) external onlyRewardsProvider {
        activateRestore = _r;
    }

    function setConsolidatedFunds(uint256 _c) external onlyRewardsProvider {
        consolidatedFunds = _c;
    }

    function setStaker(address s, uint256 amount, uint256 ls, uint256 lc, uint256 re, uint256 rc, uint256 lr, bool r) external onlyRewardsProvider {
        stakers[s].amountStaked = amount;
        stakers[s].lastStakeTime = ls;
        stakers[s].lastClaimTime = lc;
        stakers[s].rewardsEarned = re;
        stakers[s].rewardsClaimed = rc;
        stakers[s].lastRewardUpdateTime = lr;
        stakers[s].restoring = r;
    }

    function restoreFundDeposit(uint256 amount, uint256 ts) external onlyRewardsProvider {
        fundDeposits.push(Funds({
            amount: amount,
            depositTime: ts
        }));
    }
}