// File: contracts/lib/math/SafeMath.sol

pragma solidity 0.5.12;

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
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
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

// File: contracts/lib/ownership/Ownable.sol

pragma solidity 0.5.12;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be aplied to your functions to restrict their use to
 * the owner.
 */
contract Ownable {
    address public owner;
    address public pendingOwner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        owner = msg.sender;
        emit OwnershipTransferred(address(0), owner);
    }

    /**
    * @dev Modifier throws if called by any account other than the pendingOwner.
    */
    modifier onlyPendingOwner() {
        require(msg.sender == pendingOwner);
        _;
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
        return msg.sender == owner;
    }

    /**
    * @dev Allows the current owner to set the pendingOwner address.
    * @param newOwner The address to transfer ownership to.
    */
    function transferOwnership(address newOwner) public onlyOwner {
        pendingOwner = newOwner;
    }

    /**
    * @dev Allows the pendingOwner address to finalize the transfer.
    */
    function claimOwnership() public onlyPendingOwner {
        emit OwnershipTransferred(owner, pendingOwner);
        owner = pendingOwner;
        pendingOwner = address(0);
    }
}

// File: contracts/lib/utils/ReentrancyGuard.sol

pragma solidity ^0.5.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
 * available, which can be aplied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 */
contract ReentrancyGuard {
    /// @dev counter to allow mutex lock with only one SSTORE operation
    uint256 private _guardCounter;

    constructor () internal {
        // The counter starts at one to prevent changing it from zero to a non-zero
        // value, which is a more expensive operation.
        _guardCounter = 1;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _guardCounter += 1;
        uint256 localCounter = _guardCounter;
        _;
        require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
    }
}

// File: contracts/Utils.sol

pragma solidity 0.5.12;


interface ERC20 {
    function balanceOf(address account) external view returns (uint256);
}

interface MarketDapp {
    // Returns the address to approve tokens for
    function tokenReceiver(address[] calldata assetIds, uint256[] calldata dataValues, address[] calldata addresses) external view returns(address);
    function trade(address[] calldata assetIds, uint256[] calldata dataValues, address[] calldata addresses, address payable recipient) external payable;
}

/// @title Util functions for the BrokerV2 contract for Switcheo Exchange
/// @author Switcheo Network
/// @notice Functions were moved from the BrokerV2 contract into this contract
/// so that the BrokerV2 contract would not exceed the maximum contract size of
/// 24 KB.
library Utils {
    using SafeMath for uint256;

    // The constants for EIP-712 are precompiled to reduce contract size,
    // the original values are left here for reference and verification.
    //
    // bytes32 public constant EIP712_DOMAIN_TYPEHASH = keccak256(abi.encodePacked(
    //     "EIP712Domain(",
    //         "string name,",
    //         "string version,",
    //         "uint256 chainId,",
    //         "address verifyingContract,",
    //         "bytes32 salt",
    //     ")"
    // ));
    // bytes32 public constant EIP712_DOMAIN_TYPEHASH = 0xd87cd6ef79d4e2b95e15ce8abf732db51ec771f1ca2edccf22a46c729ac56472;
    //
    // bytes32 public constant CONTRACT_NAME = keccak256("Switcheo Exchange");
    // bytes32 public constant CONTRACT_VERSION = keccak256("2");
    // uint256 public constant CHAIN_ID = 1;
    // address public constant VERIFYING_CONTRACT = 0x7ee7Ca6E75dE79e618e88bDf80d0B1DB136b22D0;
    // bytes32 public constant SALT = keccak256("switcheo-eth-salt");

    // bytes32 public constant DOMAIN_SEPARATOR = keccak256(abi.encode(
    //     EIP712_DOMAIN_TYPEHASH,
    //     CONTRACT_NAME,
    //     CONTRACT_VERSION,
    //     CHAIN_ID,
    //     VERIFYING_CONTRACT,
    //     SALT
    // ));
    bytes32 public constant DOMAIN_SEPARATOR = 0x256c0713d13c6a01bd319a2f7edabde771b6c167d37c01778290d60b362ccc7d;

    // bytes32 public constant OFFER_TYPEHASH = keccak256(abi.encodePacked(
    //     "Offer(",
    //         "address maker,",
    //         "address offerAssetId,",
    //         "uint256 offerAmount,",
    //         "address wantAssetId,",
    //         "uint256 wantAmount,",
    //         "address feeAssetId,",
    //         "uint256 feeAmount,",
    //         "uint256 nonce",
    //     ")"
    // ));
    bytes32 public constant OFFER_TYPEHASH = 0xf845c83a8f7964bc8dd1a092d28b83573b35be97630a5b8a3b8ae2ae79cd9260;

    // bytes32 public constant CANCEL_TYPEHASH = keccak256(abi.encodePacked(
    //     "Cancel(",
    //         "bytes32 offerHash,",
    //         "address feeAssetId,",
    //         "uint256 feeAmount,",
    //     ")"
    // ));
    bytes32 public constant CANCEL_TYPEHASH = 0x46f6d088b1f0ff5a05c3f232c4567f2df96958e05457e6c0e1221dcee7d69c18;

    // bytes32 public constant FILL_TYPEHASH = keccak256(abi.encodePacked(
    //     "Fill(",
    //         "address filler,",
    //         "address offerAssetId,",
    //         "uint256 offerAmount,",
    //         "address wantAssetId,",
    //         "uint256 wantAmount,",
    //         "address feeAssetId,",
    //         "uint256 feeAmount,",
    //         "uint256 nonce",
    //     ")"
    // ));
    bytes32 public constant FILL_TYPEHASH = 0x5f59dbc3412a4575afed909d028055a91a4250ce92235f6790c155a4b2669e99;

    // The Ether token address is set as the constant 0x00 for backwards
    // compatibility
    address private constant ETHER_ADDR = address(0);

    uint256 private constant mask8 = ~(~uint256(0) << 8);
    uint256 private constant mask16 = ~(~uint256(0) << 16);
    uint256 private constant mask24 = ~(~uint256(0) << 24);
    uint256 private constant mask32 = ~(~uint256(0) << 32);
    uint256 private constant mask40 = ~(~uint256(0) << 40);
    uint256 private constant mask48 = ~(~uint256(0) << 48);
    uint256 private constant mask56 = ~(~uint256(0) << 56);
    uint256 private constant mask120 = ~(~uint256(0) << 120);
    uint256 private constant mask128 = ~(~uint256(0) << 128);
    uint256 private constant mask136 = ~(~uint256(0) << 136);
    uint256 private constant mask144 = ~(~uint256(0) << 144);

    event Trade(
        address maker,
        address taker,
        address makerGiveAsset,
        uint256 makerGiveAmount,
        address fillerGiveAsset,
        uint256 fillerGiveAmount
    );

    /// @dev Calculates the balance increments for a set of trades
    /// @param _values The _values param from the trade method
    /// @param _incrementsLength Should match the value of _addresses.length / 2
    /// from the trade method
    /// @return An array of increments
    function calculateTradeIncrements(
        uint256[] memory _values,
        uint256 _incrementsLength
    )
        public
        pure
        returns (uint256[] memory)
    {
        uint256[] memory increments = new uint256[](_incrementsLength);
        _creditFillBalances(increments, _values);
        _creditMakerBalances(increments, _values);
        _creditMakerFeeBalances(increments, _values);
        return increments;
    }

    /// @dev Calculates the balance decrements for a set of trades
    /// @param _values The _values param from the trade method
    /// @param _decrementsLength Should match the value of _addresses.length / 2
    /// from the trade method
    /// @return An array of decrements
    function calculateTradeDecrements(
        uint256[] memory _values,
        uint256 _decrementsLength
    )
        public
        pure
        returns (uint256[] memory)
    {
        uint256[] memory decrements = new uint256[](_decrementsLength);
        _deductFillBalances(decrements, _values);
        _deductMakerBalances(decrements, _values);
        return decrements;
    }

    /// @dev Calculates the balance increments for a set of network trades
    /// @param _values The _values param from the networkTrade method
    /// @param _incrementsLength Should match the value of _addresses.length / 2
    /// from the networkTrade method
    /// @return An array of increments
    function calculateNetworkTradeIncrements(
        uint256[] memory _values,
        uint256 _incrementsLength
    )
        public
        pure
        returns (uint256[] memory)
    {
        uint256[] memory increments = new uint256[](_incrementsLength);
        _creditMakerBalances(increments, _values);
        _creditMakerFeeBalances(increments, _values);
        return increments;
    }

    /// @dev Calculates the balance decrements for a set of network trades
    /// @param _values The _values param from the trade method
    /// @param _decrementsLength Should match the value of _addresses.length / 2
    /// from the networkTrade method
    /// @return An array of decrements
    function calculateNetworkTradeDecrements(
        uint256[] memory _values,
        uint256 _decrementsLength
    )
        public
        pure
        returns (uint256[] memory)
    {
        uint256[] memory decrements = new uint256[](_decrementsLength);
        _deductMakerBalances(decrements, _values);
        return decrements;
    }

    /// @dev Validates `BrokerV2.trade` parameters to ensure trade fairness,
    /// see `BrokerV2.trade` for param details.
    /// @param _values Values from `trade`
    /// @param _hashes Hashes from `trade`
    /// @param _addresses Addresses from `trade`
    function validateTrades(
        uint256[] memory _values,
        bytes32[] memory _hashes,
        address[] memory _addresses,
        address _operator
    )
        public
        returns (bytes32[] memory)
    {
        _validateTradeInputLengths(_values, _hashes);
        _validateUniqueOffers(_values);
        _validateMatches(_values, _addresses);
        _validateFillAmounts(_values);
        _validateTradeData(_values, _addresses, _operator);

        // validate signatures of all offers
        _validateTradeSignatures(
            _values,
            _hashes,
            _addresses,
            OFFER_TYPEHASH,
            0,
            _values[0] & mask8 // numOffers
        );

        // validate signatures of all fills
        _validateTradeSignatures(
            _values,
            _hashes,
            _addresses,
            FILL_TYPEHASH,
            _values[0] & mask8, // numOffers
            (_values[0] & mask8) + ((_values[0] & mask16) >> 8) // numOffers + numFills
        );

        _emitTradeEvents(_values, _addresses, new address[](0), false);

        return _hashes;
    }

    /// @dev Validates `BrokerV2.networkTrade` parameters to ensure trade fairness,
    /// see `BrokerV2.networkTrade` for param details.
    /// @param _values Values from `networkTrade`
    /// @param _hashes Hashes from `networkTrade`
    /// @param _addresses Addresses from `networkTrade`
    /// @param _operator Address of the `BrokerV2.operator`
    function validateNetworkTrades(
        uint256[] memory _values,
        bytes32[] memory _hashes,
        address[] memory _addresses,
        address _operator
    )
        public
        pure
        returns (bytes32[] memory)
    {
        _validateNetworkTradeInputLengths(_values, _hashes);
        _validateUniqueOffers(_values);
        _validateNetworkMatches(_values, _addresses, _operator);
        _validateTradeData(_values, _addresses, _operator);

        // validate signatures of all offers
        _validateTradeSignatures(
            _values,
            _hashes,
            _addresses,
            OFFER_TYPEHASH,
            0,
            _values[0] & mask8 // numOffers
        );

        return _hashes;
    }

    /// @dev Executes trades against external markets,
    /// see `BrokerV2.networkTrade` for param details.
    /// @param _values Values from `networkTrade`
    /// @param _addresses Addresses from `networkTrade`
    /// @param _marketDapps See `BrokerV2.marketDapps`
    function performNetworkTrades(
        uint256[] memory _values,
        address[] memory _addresses,
        address[] memory _marketDapps
    )
        public
        returns (uint256[] memory)
    {
        uint256[] memory increments = new uint256[](_addresses.length / 2);
        // i = 1 + numOffers * 2
        uint256 i = 1 + (_values[0] & mask8) * 2;
        uint256 end = _values.length;

        // loop matches
        for(i; i < end; i++) {
            uint256[] memory data = new uint256[](9);
            data[0] = _values[i]; // match data
            data[1] = data[0] & mask8; // offerIndex
            data[2] = (data[0] & mask24) >> 16; // operator.surplusAssetIndex
            data[3] = _values[data[1] * 2 + 1]; // offer.dataA
            data[4] = _values[data[1] * 2 + 2]; // offer.dataB
            data[5] = ((data[3] & mask16) >> 8); // maker.offerAssetIndex
            data[6] = ((data[3] & mask24) >> 16); // maker.wantAssetIndex
            // amount of offerAssetId to take from the offer is equal to the match.takeAmount
            data[7] = data[0] >> 128;
            // expected amount to receive is: matchData.takeAmount * offer.wantAmount / offer.offerAmount
            data[8] = data[7].mul(data[4] >> 128).div(data[4] & mask128);

            address[] memory assetIds = new address[](3);
            assetIds[0] = _addresses[data[5] * 2 + 1]; // offer.offerAssetId
            assetIds[1] = _addresses[data[6] * 2 + 1]; // offer.wantAssetId
            assetIds[2] = _addresses[data[2] * 2 + 1]; // surplusAssetId

            uint256[] memory dataValues = new uint256[](3);
            dataValues[0] = data[7]; // the proportion of offerAmount to offer
            dataValues[1] = data[8]; // the proportion of wantAmount to receive for the offer
            dataValues[2] = data[0]; // match data

            increments[data[2]] = _performNetworkTrade(
                assetIds,
                dataValues,
                _marketDapps,
                _addresses
            );
        }

        _emitTradeEvents(_values, _addresses, _marketDapps, true);

        return increments;
    }

    /// @dev Validates the signature of a cancel invocation
    /// @param _values The _values param from the cancel method
    /// @param _hashes The _hashes param from the cancel method
    /// @param _addresses The _addresses param from the cancel method
    function validateCancel(
        uint256[] memory _values,
        bytes32[] memory _hashes,
        address[] memory _addresses
    )
        public
        pure
    {
        bytes32 offerHash = hashOffer(_values, _addresses);

        bytes32 cancelHash = keccak256(abi.encode(
            CANCEL_TYPEHASH,
            offerHash,
            _addresses[4],
            _values[1] >> 128
        ));

        validateSignature(
            cancelHash,
            _addresses[0], // maker
            uint8((_values[2] & mask144) >> 136), // v
            _hashes[0], // r
            _hashes[1], // s
            ((_values[2] & mask136) >> 128) != 0 // prefixedSignature
        );
    }

    /// @dev Hashes an offer for the cancel method
    /// @param _values The _values param from the cancel method
    /// @param _addresses THe _addresses param from the cancel method
    /// @return The hash of the offer
    function hashOffer(
        uint256[] memory _values,
        address[] memory _addresses
    )
        public
        pure
        returns (bytes32)
    {
        return keccak256(abi.encode(
            OFFER_TYPEHASH,
            _addresses[0], // maker
            _addresses[1], // offerAssetId
            _values[0] & mask128, // offerAmount
            _addresses[2], // wantAssetId
            _values[0] >> 128, // wantAmount
            _addresses[3], // feeAssetId
            _values[1] & mask128, // feeAmount
            _values[2] >> 144 // offerNonce
        ));
    }

    /// @notice Approves a token transfer
    /// @param _assetId The address of the token to approve
    /// @param _spender The address of the spender to approve
    /// @param _amount The number of tokens to approve
    function approveTokenTransfer(
        address _assetId,
        address _spender,
        uint256 _amount
    )
        public
    {
        _validateContractAddress(_assetId);

        // Some tokens have an `approve` which returns a boolean and some do not.
        // The ERC20 interface cannot be used here because it requires specifying
        // an explicit return value, and an EVM exception would be raised when calling
        // a token with the mismatched return value.
        bytes memory payload = abi.encodeWithSignature(
            "approve(address,uint256)",
            _spender,
            _amount
        );
        bytes memory returnData = _callContract(_assetId, payload);
        // Ensure that the asset transfer succeeded
        _validateContractCallResult(returnData);
    }

    /// @notice Transfers tokens into the contract
    /// @param _user The address to transfer the tokens from
    /// @param _assetId The address of the token to transfer
    /// @param _amount The number of tokens to transfer
    /// @param _expectedAmount The number of tokens expected to be received,
    /// this may not match `_amount`, for example, tokens which have a
    /// proportion burnt on transfer will have a different amount received.
    function transferTokensIn(
        address _user,
        address _assetId,
        uint256 _amount,
        uint256 _expectedAmount
    )
        public
    {
        _validateContractAddress(_assetId);

        uint256 initialBalance = tokenBalance(_assetId);

        // Some tokens have a `transferFrom` which returns a boolean and some do not.
        // The ERC20 interface cannot be used here because it requires specifying
        // an explicit return value, and an EVM exception would be raised when calling
        // a token with the mismatched return value.
        bytes memory payload = abi.encodeWithSignature(
            "transferFrom(address,address,uint256)",
            _user,
            address(this),
            _amount
        );
        bytes memory returnData = _callContract(_assetId, payload);
        // Ensure that the asset transfer succeeded
        _validateContractCallResult(returnData);

        uint256 finalBalance = tokenBalance(_assetId);
        uint256 transferredAmount = finalBalance.sub(initialBalance);

        require(transferredAmount == _expectedAmount, "Invalid transfer");
    }

    /// @notice Transfers tokens from the contract to a user
    /// @param _receivingAddress The address to transfer the tokens to
    /// @param _assetId The address of the token to transfer
    /// @param _amount The number of tokens to transfer
    function transferTokensOut(
        address _receivingAddress,
        address _assetId,
        uint256 _amount
    )
        public
    {
        _validateContractAddress(_assetId);

        // Some tokens have a `transfer` which returns a boolean and some do not.
        // The ERC20 interface cannot be used here because it requires specifying
        // an explicit return value, and an EVM exception would be raised when calling
        // a token with the mismatched return value.
        bytes memory payload = abi.encodeWithSignature(
                                   "transfer(address,uint256)",
                                   _receivingAddress,
                                   _amount
                               );
        bytes memory returnData = _callContract(_assetId, payload);

        // Ensure that the asset transfer succeeded
        _validateContractCallResult(returnData);
    }

    /// @notice Returns the number of tokens owned by this contract
    /// @param _assetId The address of the token to query
    function externalBalance(address _assetId) public view returns (uint256) {
        if (_assetId == ETHER_ADDR) {
            return address(this).balance;
        }
        return tokenBalance(_assetId);
    }

    /// @notice Returns the number of tokens owned by this contract.
    /// @dev This will not work for Ether tokens, use `externalBalance` for
    /// Ether tokens.
    /// @param _assetId The address of the token to query
    function tokenBalance(address _assetId) public view returns (uint256) {
        return ERC20(_assetId).balanceOf(address(this));
    }

    /// @dev Validates that the specified `_hash` was signed by the specified `_user`.
    /// This method supports the EIP712 specification, the older Ethereum
    /// signed message specification is also supported for backwards compatibility.
    /// @param _hash The original hash that was signed by the user
    /// @param _user The user who signed the hash
    /// @param _v The `v` component of the `_user`'s signature
    /// @param _r The `r` component of the `_user`'s signature
    /// @param _s The `s` component of the `_user`'s signature
    /// @param _prefixed If true, the signature will be verified
    /// against the Ethereum signed message specification instead of the
    /// EIP712 specification
    function validateSignature(
        bytes32 _hash,
        address _user,
        uint8 _v,
        bytes32 _r,
        bytes32 _s,
        bool _prefixed
    )
        public
        pure
    {
        bytes32 eip712Hash = keccak256(abi.encodePacked(
            "\x19\x01",
            DOMAIN_SEPARATOR,
            _hash
        ));

        if (_prefixed) {
            bytes32 prefixedHash = keccak256(abi.encodePacked(
                "\x19Ethereum Signed Message:\n32",
                eip712Hash
            ));
            require(_user == ecrecover(prefixedHash, _v, _r, _s), "Invalid signature");
        } else {
            require(_user == ecrecover(eip712Hash, _v, _r, _s), "Invalid signature");
        }
    }

    /// @dev Ensures that `_address` is not the zero address
    /// @param _address The address to check
    function validateAddress(address _address) public pure {
        require(_address != address(0), "Invalid address");
    }

    /// @dev Credit fillers for each fill.wantAmount,and credit the operator
    /// for each fill.feeAmount. See the `trade` method for param details.
    /// @param _values Values from `trade`
    function _creditFillBalances(
        uint256[] memory _increments,
        uint256[] memory _values
    )
        private
        pure
    {
        // 1 + numOffers * 2
        uint256 i = 1 + (_values[0] & mask8) * 2;
        // i + numFills * 2
        uint256 end = i + ((_values[0] & mask16) >> 8) * 2;

        // loop fills
        for(i; i < end; i += 2) {
            uint256 fillerWantAssetIndex = (_values[i] & mask24) >> 16;
            uint256 wantAmount = _values[i + 1] >> 128;

            // credit fill.wantAmount to filler
            _increments[fillerWantAssetIndex] = _increments[fillerWantAssetIndex].add(wantAmount);

            uint256 feeAmount = _values[i] >> 128;
            if (feeAmount == 0) { continue; }

            uint256 operatorFeeAssetIndex = ((_values[i] & mask40) >> 32);
            // credit fill.feeAmount to operator
            _increments[operatorFeeAssetIndex] = _increments[operatorFeeAssetIndex].add(feeAmount);
        }
    }

    /// @dev Credit makers for each amount received through a matched fill.
    /// See the `trade` method for param details.
    /// @param _values Values from `trade`
    function _creditMakerBalances(
        uint256[] memory _increments,
        uint256[] memory _values
    )
        private
        pure
    {
        uint256 i = 1;
        // i += numOffers * 2
        i += (_values[0] & mask8) * 2;
        // i += numFills * 2
        i += ((_values[0] & mask16) >> 8) * 2;

        uint256 end = _values.length;

        // loop matches
        for(i; i < end; i++) {
            // match.offerIndex
            uint256 offerIndex = _values[i] & mask8;
            // maker.wantAssetIndex
            uint256 makerWantAssetIndex = (_values[1 + offerIndex * 2] & mask24) >> 16;

            // match.takeAmount
            uint256 amount = _values[i] >> 128;
            // receiveAmount = match.takeAmount * offer.wantAmount / offer.offerAmount
            amount = amount.mul(_values[2 + offerIndex * 2] >> 128)
                           .div(_values[2 + offerIndex * 2] & mask128);

            // credit maker for the amount received from the match
            _increments[makerWantAssetIndex] = _increments[makerWantAssetIndex].add(amount);
        }
    }

    /// @dev Credit the operator for each offer.feeAmount if the offer has not
    /// been recorded through a previous `trade` call.
    /// See the `trade` method for param details.
    /// @param _values Values from `trade`
    function _creditMakerFeeBalances(
        uint256[] memory _increments,
        uint256[] memory _values
    )
        private
        pure
    {
        uint256 i = 1;
        // i + numOffers * 2
        uint256 end = i + (_values[0] & mask8) * 2;

        // loop offers
        for(i; i < end; i += 2) {
            bool nonceTaken = ((_values[i] & mask128) >> 120) == 1;
            if (nonceTaken) { continue; }

            uint256 feeAmount = _values[i] >> 128;
            if (feeAmount == 0) { continue; }

            uint256 operatorFeeAssetIndex = (_values[i] & mask40) >> 32;

            // credit make.feeAmount to operator
            _increments[operatorFeeAssetIndex] = _increments[operatorFeeAssetIndex].add(feeAmount);
        }
    }

    /// @dev Deduct tokens from fillers for each fill.offerAmount
    /// and each fill.feeAmount.
    /// See the `trade` method for param details.
    /// @param _values Values from `trade`
    function _deductFillBalances(
        uint256[] memory _decrements,
        uint256[] memory _values
    )
        private
        pure
    {
        // 1 + numOffers * 2
        uint256 i = 1 + (_values[0] & mask8) * 2;
        // i + numFills * 2
        uint256 end = i + ((_values[0] & mask16) >> 8) * 2;

        // loop fills
        for(i; i < end; i += 2) {
            uint256 fillerOfferAssetIndex = (_values[i] & mask16) >> 8;
            uint256 offerAmount = _values[i + 1] & mask128;

            // deduct fill.offerAmount from filler
            _decrements[fillerOfferAssetIndex] = _decrements[fillerOfferAssetIndex].add(offerAmount);

            uint256 feeAmount = _values[i] >> 128;
            if (feeAmount == 0) { continue; }

            // deduct fill.feeAmount from filler
            uint256 fillerFeeAssetIndex = (_values[i] & mask32) >> 24;
            _decrements[fillerFeeAssetIndex] = _decrements[fillerFeeAssetIndex].add(feeAmount);
        }
    }

    /// @dev Deduct tokens from makers for each offer.offerAmount
    /// and each offer.feeAmount if the offer has not been recorded
    /// through a previous `trade` call.
    /// See the `trade` method for param details.
    /// @param _values Values from `trade`
    function _deductMakerBalances(
        uint256[] memory _decrements,
        uint256[] memory _values
    )
        private
        pure
    {
        uint256 i = 1;
        // i + numOffers * 2
        uint256 end = i + (_values[0] & mask8) * 2;

        // loop offers
        for(i; i < end; i += 2) {
            bool nonceTaken = ((_values[i] & mask128) >> 120) == 1;
            if (nonceTaken) { continue; }

            uint256 makerOfferAssetIndex = (_values[i] & mask16) >> 8;
            uint256 offerAmount = _values[i + 1] & mask128;

            // deduct make.offerAmount from maker
            _decrements[makerOfferAssetIndex] = _decrements[makerOfferAssetIndex].add(offerAmount);

            uint256 feeAmount = _values[i] >> 128;
            if (feeAmount == 0) { continue; }

            // deduct make.feeAmount from maker
            uint256 makerFeeAssetIndex = (_values[i] & mask32) >> 24;
            _decrements[makerFeeAssetIndex] = _decrements[makerFeeAssetIndex].add(feeAmount);
        }
    }

    /// @dev Emits trade events for easier tracking
    /// @param _values The _values param from the trade / networkTrade method
    /// @param _addresses The _addresses param from the trade / networkTrade method
    /// @param _marketDapps The _marketDapps from BrokerV2
    /// @param _forNetworkTrade Whether this is called from the networkTrade method
    function _emitTradeEvents(
        uint256[] memory _values,
        address[] memory _addresses,
        address[] memory _marketDapps,
        bool _forNetworkTrade
    )
        private
    {
        uint256 i = 1;
        // i += numOffers * 2
        i += (_values[0] & mask8) * 2;
        // i += numFills * 2
        i += ((_values[0] & mask16) >> 8) * 2;

        uint256 end = _values.length;

        // loop matches
        for(i; i < end; i++) {
            uint256[] memory data = new uint256[](7);
            data[0] = _values[i] & mask8; // match.offerIndex
            data[1] = _values[1 + data[0] * 2] & mask8; // makerIndex
            data[2] = (_values[1 + data[0] * 2] & mask16) >> 8; // makerOfferAssetIndex
            data[3] = (_values[1 + data[0] * 2] & mask24) >> 16; // makerWantAssetIndex
            data[4] = _values[i] >> 128; // match.takeAmount
            // receiveAmount = match.takeAmount * offer.wantAmount / offer.offerAmount
            data[5] = data[4].mul(_values[2 + data[0] * 2] >> 128)
                             .div(_values[2 + data[0] * 2] & mask128);
            // match.fillIndex for `trade`, marketDappIndex for `networkTrade`
            data[6] = (_values[i] & mask16) >> 8;

            address filler;
            if (_forNetworkTrade) {
                filler = _marketDapps[data[6]];
            } else {
                uint256 fillerIndex = (_values[1 + data[6] * 2] & mask8);
                filler = _addresses[fillerIndex * 2];
            }

            emit Trade(
                _addresses[data[1] * 2], // maker
                filler,
                _addresses[data[2] * 2 + 1], // makerGiveAsset
                data[4], // makerGiveAmount
                _addresses[data[3] * 2 + 1], // fillerGiveAsset
                data[5] // fillerGiveAmount
            );
        }
    }


    /// @notice Executes a trade against an external market.
    /// @dev The initial Ether or token balance is compared with the
    /// balance after the trade to ensure that the appropriate amounts of
    /// tokens were taken and an appropriate amount received.
    /// The trade will fail if the number of tokens received is less than
    /// expected. If the number of tokens received is more than expected than
    /// the excess tokens are transferred to the `BrokerV2.operator`.
    /// @param _assetIds[0] The offerAssetId of the offer
    /// @param _assetIds[1] The wantAssetId of the offer
    /// @param _assetIds[2] The surplusAssetId
    /// @param _dataValues[0] The number of tokens offerred
    /// @param _dataValues[1] The number of tokens expected to be received
    /// @param _dataValues[2] Match data
    /// @param _marketDapps See `BrokerV2.marketDapps`
    /// @param _addresses Addresses from `networkTrade`
    function _performNetworkTrade(
        address[] memory _assetIds,
        uint256[] memory _dataValues,
        address[] memory _marketDapps,
        address[] memory _addresses
    )
        private
        returns (uint256)
    {
        uint256 dappIndex = (_dataValues[2] & mask16) >> 8;
        validateAddress(_marketDapps[dappIndex]);
        MarketDapp marketDapp = MarketDapp(_marketDapps[dappIndex]);

        uint256[] memory funds = new uint256[](6);
        funds[0] = externalBalance(_assetIds[0]); // initialOfferTokenBalance
        funds[1] = externalBalance(_assetIds[1]); // initialWantTokenBalance
        if (_assetIds[2] != _assetIds[0] && _assetIds[2] != _assetIds[1]) {
            funds[2] = externalBalance(_assetIds[2]); // initialSurplusTokenBalance
        }

        uint256 ethValue = 0;
        address tokenReceiver;

        if (_assetIds[0] == ETHER_ADDR) {
            ethValue = _dataValues[0]; // offerAmount
        } else {
            tokenReceiver = marketDapp.tokenReceiver(_assetIds, _dataValues, _addresses);
            approveTokenTransfer(
                _assetIds[0], // offerAssetId
                tokenReceiver,
                _dataValues[0] // offerAmount
            );
        }

        marketDapp.trade.value(ethValue)(
            _assetIds,
            _dataValues,
            _addresses,
            // use uint160 to cast `address` to `address payable`
            address(uint160(address(this))) // destAddress
        );

        funds[3] = externalBalance(_assetIds[0]); // finalOfferTokenBalance
        funds[4] = externalBalance(_assetIds[1]); // finalWantTokenBalance
        if (_assetIds[2] != _assetIds[0] && _assetIds[2] != _assetIds[1]) {
            funds[5] = externalBalance(_assetIds[2]); // finalSurplusTokenBalance
        }

        uint256 surplusAmount = 0;

        // validate that the appropriate offerAmount was deducted
        // surplusAssetId == offerAssetId
        if (_assetIds[2] == _assetIds[0]) {
            // surplusAmount = finalOfferTokenBalance - (initialOfferTokenBalance - offerAmount)
            surplusAmount = funds[3].sub(funds[0].sub(_dataValues[0]));
        } else {
            // finalOfferTokenBalance == initialOfferTokenBalance - offerAmount
            require(funds[3] == funds[0].sub(_dataValues[0]), "Invalid offer asset balance");
        }

        // validate that the appropriate wantAmount was credited
        // surplusAssetId == wantAssetId
        if (_assetIds[2] == _assetIds[1]) {
            // surplusAmount = finalWantTokenBalance - (initialWantTokenBalance + wantAmount)
            surplusAmount = funds[4].sub(funds[1].add(_dataValues[1]));
        } else {
            // finalWantTokenBalance == initialWantTokenBalance + wantAmount
            require(funds[4] == funds[1].add(_dataValues[1]), "Invalid want asset balance");
        }

        // surplusAssetId != offerAssetId && surplusAssetId != wantAssetId
        if (_assetIds[2] != _assetIds[0] && _assetIds[2] != _assetIds[1]) {
            // surplusAmount = finalSurplusTokenBalance - initialSurplusTokenBalance
            surplusAmount = funds[5].sub(funds[2]);
        }

        // set the approved token amount back to zero
        if (_assetIds[0] != ETHER_ADDR) {
            approveTokenTransfer(
                _assetIds[0],
                tokenReceiver,
                0
            );
        }

        return surplusAmount;
    }

    /// @dev Validates input lengths based on the expected format
    /// detailed in the `trade` method.
    /// @param _values Values from `trade`
    /// @param _hashes Hashes from `trade`
    function _validateTradeInputLengths(
        uint256[] memory _values,
        bytes32[] memory _hashes
    )
        private
        pure
    {
        uint256 numOffers = _values[0] & mask8;
        uint256 numFills = (_values[0] & mask16) >> 8;
        uint256 numMatches = (_values[0] & mask24) >> 16;

        // Validate that bits(24..256) are zero
        require(_values[0] >> 24 == 0, "Invalid trade input");

        // It is enforced by other checks that if a fill is present
        // then it must be completely filled so there must be at least one offer
        // and at least one match in this case.
        // It is possible to have one offer with no matches and no fills
        // but that is blocked by this check as there is no foreseeable use
        // case for it.
        require(
            numOffers > 0 && numFills > 0 && numMatches > 0,
            "Invalid trade input"
        );

        require(
            _values.length == 1 + numOffers * 2 + numFills * 2 + numMatches,
            "Invalid _values.length"
        );

        require(
            _hashes.length == (numOffers + numFills) * 2,
            "Invalid _hashes.length"
        );
    }

    /// @dev Validates input lengths based on the expected format
    /// detailed in the `networkTrade` method.
    /// @param _values Values from `networkTrade`
    /// @param _hashes Hashes from `networkTrade`
    function _validateNetworkTradeInputLengths(
        uint256[] memory _values,
        bytes32[] memory _hashes
    )
        private
        pure
    {
        uint256 numOffers = _values[0] & mask8;
        uint256 numFills = (_values[0] & mask16) >> 8;
        uint256 numMatches = (_values[0] & mask24) >> 16;

        // Validate that bits(24..256) are zero
        require(_values[0] >> 24 == 0, "Invalid networkTrade input");

        // Validate that numFills is zero because the offers
        // should be filled against external orders
        require(
            numOffers > 0 && numMatches > 0 && numFills == 0,
            "Invalid networkTrade input"
        );

        require(
            _values.length == 1 + numOffers * 2 + numMatches,
            "Invalid _values.length"
        );

        require(
            _hashes.length == numOffers * 2,
            "Invalid _hashes.length"
        );
    }

    /// @dev See the `BrokerV2.trade` method for an explanation of why offer
    /// uniquness is required.
    /// The set of offers in `_values` must be sorted such that offer nonces'
    /// are arranged in a strictly ascending order.
    /// This allows the validation of offer uniqueness to be done in O(N) time,
    /// with N being the number of offers.
    /// @param _values Values from `trade`
    function _validateUniqueOffers(uint256[] memory _values) private pure {
        uint256 numOffers = _values[0] & mask8;

        uint256 prevNonce;

        for(uint256 i = 0; i < numOffers; i++) {
            uint256 nonce = (_values[i * 2 + 1] & mask120) >> 56;

            if (i == 0) {
                // Set the value of the first nonce
                prevNonce = nonce;
                continue;
            }

            require(nonce > prevNonce, "Invalid offer nonces");
            prevNonce = nonce;
        }
    }

    /// @dev Validate that for every match:
    /// 1. offerIndexes fall within the range of offers
    /// 2. fillIndexes falls within the range of fills
    /// 3. offer.offerAssetId == fill.wantAssetId
    /// 4. offer.wantAssetId == fill.offerAssetId
    /// 5. takeAmount > 0
    /// 6. (offer.wantAmount * takeAmount) % offer.offerAmount == 0
    /// @param _values Values from `trade`
    /// @param _addresses Addresses from `trade`
    function _validateMatches(
        uint256[] memory _values,
        address[] memory _addresses
    )
        private
        pure
    {
        uint256 numOffers = _values[0] & mask8;
        uint256 numFills = (_values[0] & mask16) >> 8;

        uint256 i = 1 + numOffers * 2 + numFills * 2;
        uint256 end = _values.length;

        // loop matches
        for (i; i < end; i++) {
            uint256 offerIndex = _values[i] & mask8;
            uint256 fillIndex = (_values[i] & mask16) >> 8;

            require(offerIndex < numOffers, "Invalid match.offerIndex");

            require(fillIndex >= numOffers && fillIndex < numOffers + numFills, "Invalid match.fillIndex");

            require(
                _addresses[_values[1 + offerIndex * 2] & mask8] !=
                _addresses[_values[1 + fillIndex * 2] & mask8],
                "offer.maker cannot be the same as fill.filler"
            );

            uint256 makerOfferAssetIndex = (_values[1 + offerIndex * 2] & mask16) >> 8;
            uint256 makerWantAssetIndex = (_values[1 + offerIndex * 2] & mask24) >> 16;
            uint256 fillerOfferAssetIndex = (_values[1 + fillIndex * 2] & mask16) >> 8;
            uint256 fillerWantAssetIndex = (_values[1 + fillIndex * 2] & mask24) >> 16;

            require(
                _addresses[makerOfferAssetIndex * 2 + 1] ==
                _addresses[fillerWantAssetIndex * 2 + 1],
                "offer.offerAssetId does not match fill.wantAssetId"
            );

            require(
                _addresses[makerWantAssetIndex * 2 + 1] ==
                _addresses[fillerOfferAssetIndex * 2 + 1],
                "offer.wantAssetId does not match fill.offerAssetId"
            );

            // require that bits(16..128) are all zero for every match
            require((_values[i] & mask128) >> 16 == uint256(0), "Invalid match data");

            uint256 takeAmount = _values[i] >> 128;
            require(takeAmount > 0, "Invalid match.takeAmount");

            uint256 offerDataB = _values[2 + offerIndex * 2];
            // (offer.wantAmount * takeAmount) % offer.offerAmount == 0
            require(
                (offerDataB >> 128).mul(takeAmount).mod(offerDataB & mask128) == 0,
                "Invalid amounts"
            );
        }
    }

    /// @dev Validate that for every match:
    /// 1. offerIndexes fall within the range of offers
    /// 2. _addresses[surplusAssetIndexes * 2] matches the operator address
    /// 3. takeAmount > 0
    /// 4. (offer.wantAmount * takeAmount) % offer.offerAmount == 0
    /// @param _values Values from `trade`
    /// @param _addresses Addresses from `trade`
    /// @param _operator Address of the `BrokerV2.operator`
    function _validateNetworkMatches(
        uint256[] memory _values,
        address[] memory _addresses,
        address _operator
    )
        private
        pure
    {
        uint256 numOffers = _values[0] & mask8;

        // 1 + numOffers * 2
        uint256 i = 1 + (_values[0] & mask8) * 2;
        uint256 end = _values.length;

        // loop matches
        for (i; i < end; i++) {
            uint256 offerIndex = _values[i] & mask8;
            uint256 surplusAssetIndex = (_values[i] & mask24) >> 16;

            require(offerIndex < numOffers, "Invalid match.offerIndex");
            require(_addresses[surplusAssetIndex * 2] == _operator, "Invalid operator address");

            uint256 takeAmount = _values[i] >> 128;
            require(takeAmount > 0, "Invalid match.takeAmount");

            uint256 offerDataB = _values[2 + offerIndex * 2];
            // (offer.wantAmount * takeAmount) % offer.offerAmount == 0
            require(
                (offerDataB >> 128).mul(takeAmount).mod(offerDataB & mask128) == 0,
                "Invalid amounts"
            );
        }
    }

    /// @dev Validate that all fills will be completely filled by the specified
    /// matches. See the `BrokerV2.trade` method for an explanation of why
    /// fills must be completely filled.
    /// @param _values Values from `trade`
    function _validateFillAmounts(uint256[] memory _values) private pure {
        // "filled" is used to store the sum of `takeAmount`s and `giveAmount`s.
        // While a fill's `offerAmount` and `wantAmount` are combined to share
        // a single uint256 value, each sum of `takeAmount`s and `giveAmount`s
        // for a fill is tracked with an individual uint256 value.
        // This is to prevent the verification from being vulnerable to overflow
        // issues.
        uint256[] memory filled = new uint256[](_values.length);

        uint256 i = 1;
        // i += numOffers * 2
        i += (_values[0] & mask8) * 2;
        // i += numFills * 2
        i += ((_values[0] & mask16) >> 8) * 2;

        uint256 end = _values.length;

        // loop matches
        for (i; i < end; i++) {
            uint256 offerIndex = _values[i] & mask8;
            uint256 fillIndex = (_values[i] & mask16) >> 8;
            uint256 takeAmount = _values[i] >> 128;
            uint256 wantAmount = _values[2 + offerIndex * 2] >> 128;
            uint256 offerAmount = _values[2 + offerIndex * 2] & mask128;
            // giveAmount = takeAmount * wantAmount / offerAmount
            uint256 giveAmount = takeAmount.mul(wantAmount).div(offerAmount);

            // (1 + fillIndex * 2) would give the index of the first part
            // of the data for the fill at fillIndex within `_values`,
            // and (2 + fillIndex * 2) would give the index of the second part
            filled[1 + fillIndex * 2] = filled[1 + fillIndex * 2].add(giveAmount);
            filled[2 + fillIndex * 2] = filled[2 + fillIndex * 2].add(takeAmount);
        }

        // numOffers
        i = _values[0] & mask8;
        // i + numFills
        end = i + ((_values[0] & mask16) >> 8);

        // loop fills
        for(i; i < end; i++) {
            require(
                // fill.offerAmount == (sum of given amounts for fill)
                _values[i * 2 + 2] & mask128 == filled[i * 2 + 1] &&
                // fill.wantAmount == (sum of taken amounts for fill)
                _values[i * 2 + 2] >> 128 == filled[i * 2 + 2],
                "Invalid fills"
            );
        }
    }

    /// @dev Validates that for every offer / fill
    /// 1. user address matches address referenced by user.offerAssetIndex
    /// 2. user address matches address referenced by user.wantAssetIndex
    /// 3. user address matches address referenced by user.feeAssetIndex
    /// 4. offerAssetId != wantAssetId
    /// 5. offerAmount > 0 && wantAmount > 0
    /// 6. Specified `operator` address matches the expected `operator` address,
    /// 7. Specified `operator.feeAssetId` matches the offer's feeAssetId
    /// @param _values Values from `trade`
    /// @param _addresses Addresses from `trade`
    function _validateTradeData(
        uint256[] memory _values,
        address[] memory _addresses,
        address _operator
    )
        private
        pure
    {
        // numOffers + numFills
        uint256 end = (_values[0] & mask8) +
                      ((_values[0] & mask16) >> 8);

        for (uint256 i = 0; i < end; i++) {
            uint256 dataA = _values[i * 2 + 1];
            uint256 dataB = _values[i * 2 + 2];
            uint256 feeAssetIndex = ((dataA & mask40) >> 32) * 2;

            require(
                // user address == user in user.offerAssetIndex pair
                _addresses[(dataA & mask8) * 2] ==
                _addresses[((dataA & mask16) >> 8) * 2],
                "Invalid user in user.offerAssetIndex"
            );

            require(
                // user address == user in user.wantAssetIndex pair
                _addresses[(dataA & mask8) * 2] ==
                _addresses[((dataA & mask24) >> 16) * 2],
                "Invalid user in user.wantAssetIndex"
            );

            require(
                // user address == user in user.feeAssetIndex pair
                _addresses[(dataA & mask8) * 2] ==
                _addresses[((dataA & mask32) >> 24) * 2],
                "Invalid user in user.feeAssetIndex"
            );

            require(
                // offerAssetId != wantAssetId
                _addresses[((dataA & mask16) >> 8) * 2 + 1] !=
                _addresses[((dataA & mask24) >> 16) * 2 + 1],
                "Invalid trade assets"
            );

            require(
                // offerAmount > 0 && wantAmount > 0
                (dataB & mask128) > 0 && (dataB >> 128) > 0,
                "Invalid trade amounts"
            );

             require(
                _addresses[feeAssetIndex] == _operator,
                "Invalid operator address"
            );

             require(
                _addresses[feeAssetIndex + 1] ==
                _addresses[((dataA & mask32) >> 24) * 2 + 1],
                "Invalid operator fee asset ID"
            );
        }
    }

    /// @dev Validates signatures for a set of offers or fills
    /// Note that the r value of the offer / fill in _hashes will be
    /// overwritten by the hash of that offer / fill
    /// @param _values Values from `trade`
    /// @param _hashes Hashes from `trade`
    /// @param _addresses Addresses from `trade`
    /// @param _typehash The typehash used to construct the signed hash
    /// @param _i The starting index to verify
    /// @param _end The ending index to verify
    /// @return An array of hash keys if _i started as 0, because only
    /// the hash keys of offers are needed
    function _validateTradeSignatures(
        uint256[] memory _values,
        bytes32[] memory _hashes,
        address[] memory _addresses,
        bytes32 _typehash,
        uint256 _i,
        uint256 _end
    )
        private
        pure
    {
        for (_i; _i < _end; _i++) {
            uint256 dataA = _values[_i * 2 + 1];
            uint256 dataB = _values[_i * 2 + 2];

            bytes32 hashKey = keccak256(abi.encode(
                _typehash,
                _addresses[(dataA & mask8) * 2], // user
                _addresses[((dataA & mask16) >> 8) * 2 + 1], // offerAssetId
                dataB & mask128, // offerAmount
                _addresses[((dataA & mask24) >> 16) * 2 + 1], // wantAssetId
                dataB >> 128, // wantAmount
                _addresses[((dataA & mask32) >> 24) * 2 + 1], // feeAssetId
                dataA >> 128, // feeAmount
                (dataA & mask120) >> 56 // nonce
            ));

            bool prefixedSignature = ((dataA & mask56) >> 48) != 0;

            validateSignature(
                hashKey,
                _addresses[(dataA & mask8) * 2], // user
                uint8((dataA & mask48) >> 40), // The `v` component of the user's signature
                _hashes[_i * 2], // The `r` component of the user's signature
                _hashes[_i * 2 + 1], // The `s` component of the user's signature
                prefixedSignature
            );

            _hashes[_i * 2] = hashKey;
        }
    }

    /// @dev Ensure that the address is a deployed contract
    /// @param _contract The address to check
    function _validateContractAddress(address _contract) private view {
        assembly {
            if iszero(extcodesize(_contract)) { revert(0, 0) }
        }
    }

    /// @dev A thin wrapper around the native `call` function, to
    /// validate that the contract `call` must be successful.
    /// See https://solidity.readthedocs.io/en/v0.5.1/050-breaking-changes.html
    /// for details on constructing the `_payload`
    /// @param _contract Address of the contract to call
    /// @param _payload The data to call the contract with
    /// @return The data returned from the contract call
    function _callContract(
        address _contract,
        bytes memory _payload
    )
        private
        returns (bytes memory)
    {
        bool success;
        bytes memory returnData;

        (success, returnData) = _contract.call(_payload);
        require(success, "Contract call failed");

        return returnData;
    }

    /// @dev Fix for ERC-20 tokens that do not have proper return type
    /// See: https://github.com/ethereum/solidity/issues/4116
    /// https://medium.com/loopring-protocol/an-incompatibility-in-smart-contract-threatening-dapp-ecosystem-72b8ca5db4da
    /// https://github.com/sec-bit/badERC20Fix/blob/master/badERC20Fix.sol
    /// @param _data The data returned from a transfer call
    function _validateContractCallResult(bytes memory _data) private pure {
        require(
            _data.length == 0 ||
            (_data.length == 32 && _getUint256FromBytes(_data) != 0),
            "Invalid contract call result"
        );
    }

    /// @dev Converts data of type `bytes` into its corresponding `uint256` value
    /// @param _data The data in bytes
    /// @return The corresponding `uint256` value
    function _getUint256FromBytes(
        bytes memory _data
    )
        private
        pure
        returns (uint256)
    {
        uint256 parsed;
        assembly { parsed := mload(add(_data, 32)) }
        return parsed;
    }
}

// File: contracts/BrokerV2.sol

pragma solidity 0.5.12;





interface IERC1820Registry {
    function setInterfaceImplementer(address account, bytes32 interfaceHash, address implementer) external;
}

interface TokenList {
    function validateToken(address assetId) external view;
}

interface SpenderList {
    function validateSpender(address spender) external view;
    function validateSpenderAuthorization(address user, address spender) external view;
}

/// @title The BrokerV2 contract for Switcheo Exchange
/// @author Switcheo Network
/// @notice This contract faciliates Ethereum and Ethereum token trades
/// between users.
/// Users can trade with each other by making and taking offers without
/// giving up custody of their tokens.
/// Users should first deposit tokens, then communicate off-chain
/// with the exchange coordinator, in order to place orders.
/// This allows trades to be confirmed immediately by the coordinator,
/// and settled on-chain through this contract at a later time.
///
/// @dev Bit compacting is used in the contract to reduce gas costs, when
/// it is used, params are documented as bits(n..m).
/// This means that the documented value is represented by bits starting
/// from and including `n`, up to and excluding `m`.
/// For example, bits(8..16), indicates that the value is represented by bits:
/// [8, 9, 10, 11, 12, 13, 14, 15].
///
/// Bit manipulation of the form (data & ~(~uint(0) << m)) >> n is frequently
/// used to recover the value at the specified bits.
/// For example, to recover bits(2..7) from a uint8 value, we can use
/// (data & ~(~uint8(0) << 7)) >> 2.
/// Given a `data` value of `1101,0111`, bits(2..7) should give "10101".
/// ~uint8(0): "1111,1111" (8 ones)
/// (~uint8(0) << 7): "1000,0000" (1 followed by 7 zeros)
/// ~(~uint8(0) << 7): "0111,1111" (0 followed by 7 ones)
/// (data & ~(~uint8(0) << 7)): "0101,0111" (bits after the 7th bit is zeroed)
/// (data & ~(~uint8(0) << 7)) >> 2: "0001,0101" (matching the expected "10101")
///
/// Additionally, bit manipulation of the form data >> n is used to recover
/// bits(n..e), where e is equal to the number of bits in the data.
/// For example, to recover bits(4..8) from a uint8 value, we can use data >> 4.
/// Given a data value of "1111,1111", bits(4..8) should give "1111".
/// data >> 4: "0000,1111" (matching the expected "1111")
///
/// There is frequent reference and usage of asset IDs, this is a unique
/// identifier used within the contract to represent individual assets.
/// For all tokens, the asset ID is identical to the contract address
/// of the token, this is so that additional mappings are not needed to
/// identify tokens during deposits and withdrawals.
/// The only exception is the Ethereum token, which does not have a contract
/// address, for this reason, the zero address is used to represent the
/// Ethereum token's ID.
contract BrokerV2 is Ownable, ReentrancyGuard {
    using SafeMath for uint256;

    struct WithdrawalAnnouncement {
        uint256 amount;
        uint256 withdrawableAt;
    }

    // Exchange states
    enum State { Active, Inactive }
    // Exchange admin states
    enum AdminState { Normal, Escalated }

    // The constants for EIP-712 are precompiled to reduce contract size,
    // the original values are left here for reference and verification.
    //
    // bytes32 public constant WITHDRAW_TYPEHASH = keccak256(abi.encodePacked(
    //     "Withdraw(",
    //         "address withdrawer,",
    //         "address receivingAddress,",
    //         "address assetId,",
    //         "uint256 amount,",
    //         "address feeAssetId,",
    //         "uint256 feeAmount,",
    //         "uint256 nonce",
    //     ")"
    // ));
    bytes32 public constant WITHDRAW_TYPEHASH = 0xbe2f4292252fbb88b129dc7717b2f3f74a9afb5b13a2283cac5c056117b002eb;

    // bytes32 public constant OFFER_TYPEHASH = keccak256(abi.encodePacked(
    //     "Offer(",
    //         "address maker,",
    //         "address offerAssetId,",
    //         "uint256 offerAmount,",
    //         "address wantAssetId,",
    //         "uint256 wantAmount,",
    //         "address feeAssetId,",
    //         "uint256 feeAmount,",
    //         "uint256 nonce",
    //     ")"
    // ));
    bytes32 public constant OFFER_TYPEHASH = 0xf845c83a8f7964bc8dd1a092d28b83573b35be97630a5b8a3b8ae2ae79cd9260;

    // bytes32 public constant SWAP_TYPEHASH = keccak256(abi.encodePacked(
    //     "Swap(",
    //         "address maker,",
    //         "address taker,",
    //         "address assetId,",
    //         "uint256 amount,",
    //         "bytes32 hashedSecret,",
    //         "uint256 expiryTime,",
    //         "address feeAssetId,",
    //         "uint256 feeAmount,",
    //         "uint256 nonce",
    //     ")"
    // ));
    bytes32 public constant SWAP_TYPEHASH = 0x6ba9001457a287c210b728198a424a4222098d7fac48f8c5fb5ab10ef907d3ef;

    // The Ether token address is set as the constant 0x00 for backwards
    // compatibility
    address private constant ETHER_ADDR = address(0);

    // The maximum length of swap secret values
    uint256 private constant MAX_SWAP_SECRET_LENGTH = 64;

    // Reason codes are used by the off-chain coordinator to track balance changes
    uint256 private constant REASON_DEPOSIT = 0x01;

    uint256 private constant REASON_WITHDRAW = 0x09;
    uint256 private constant REASON_WITHDRAW_FEE_GIVE = 0x14;
    uint256 private constant REASON_WITHDRAW_FEE_RECEIVE = 0x15;

    uint256 private constant REASON_CANCEL = 0x08;
    uint256 private constant REASON_CANCEL_FEE_GIVE = 0x12;
    uint256 private constant REASON_CANCEL_FEE_RECEIVE = 0x13;

    uint256 private constant REASON_SWAP_GIVE = 0x30;
    uint256 private constant REASON_SWAP_FEE_GIVE = 0x32;
    uint256 private constant REASON_SWAP_RECEIVE = 0x35;
    uint256 private constant REASON_SWAP_FEE_RECEIVE = 0x37;

    uint256 private constant REASON_SWAP_CANCEL_RECEIVE = 0x38;
    uint256 private constant REASON_SWAP_CANCEL_FEE_RECEIVE = 0x3B;
    uint256 private constant REASON_SWAP_CANCEL_FEE_REFUND = 0x3D;

    // 7 days * 24 hours * 60 mins * 60 seconds: 604800
    uint256 private constant MAX_SLOW_WITHDRAW_DELAY = 604800;
    uint256 private constant MAX_SLOW_CANCEL_DELAY = 604800;

    uint256 private constant mask8 = ~(~uint256(0) << 8);
    uint256 private constant mask16 = ~(~uint256(0) << 16);
    uint256 private constant mask24 = ~(~uint256(0) << 24);
    uint256 private constant mask32 = ~(~uint256(0) << 32);
    uint256 private constant mask40 = ~(~uint256(0) << 40);
    uint256 private constant mask120 = ~(~uint256(0) << 120);
    uint256 private constant mask128 = ~(~uint256(0) << 128);
    uint256 private constant mask136 = ~(~uint256(0) << 136);
    uint256 private constant mask144 = ~(~uint256(0) << 144);

    State public state;
    AdminState public adminState;
    // All fees will be transferred to the operator address
    address public operator;
    TokenList public tokenList;
    SpenderList public spenderList;

    // The delay in seconds to complete the respective escape hatch (`slowCancel` / `slowWithdraw`).
    // This gives the off-chain service time to update the off-chain state
    // before the state is separately updated by the user.
    uint256 public slowCancelDelay;
    uint256 public slowWithdrawDelay;

    // A mapping of remaining offer amounts: offerHash => availableAmount
    mapping(bytes32 => uint256) public offers;
    // A mapping of used nonces: nonceIndex => nonceData
    // The storing of nonces is used to ensure that transactions signed by
    // the user can only be used once.
    // For space and gas cost efficiency, one nonceData is used to store the
    // state of 256 nonces.
    // This reduces the average cost of storing a new nonce from 20,000 gas
    // to 5000 + 20,000 / 256 = 5078.125 gas
    // See _markNonce and _nonceTaken for more details.
    mapping(uint256 => uint256) public usedNonces;
    // A mapping of user balances: userAddress => assetId => balance
    mapping(address => mapping(address => uint256)) public balances;
    // A mapping of atomic swap states: swapHash => isSwapActive
    mapping(bytes32 => bool) public atomicSwaps;

    // A record of admin addresses: userAddress => isAdmin
    mapping(address => bool) public adminAddresses;
    // A record of market DApp addresses
    address[] public marketDapps;
    // A mapping of cancellation announcements for the cancel escape hatch: offerHash => cancellableAt
    mapping(bytes32 => uint256) public cancellationAnnouncements;
    // A mapping of withdrawal announcements: userAddress => assetId => { amount, withdrawableAt }
    mapping(address => mapping(address => WithdrawalAnnouncement)) public withdrawalAnnouncements;

    // Emitted on positive balance state transitions
    event BalanceIncrease(
        address indexed user,
        address indexed assetId,
        uint256 amount,
        uint256 reason,
        uint256 nonce
    );

    // Emitted on negative balance state transitions
    event BalanceDecrease(
        address indexed user,
        address indexed assetId,
        uint256 amount,
        uint256 reason,
        uint256 nonce
    );

    // Compacted versions of the `BalanceIncrease` and `BalanceDecrease` events.
    // These are used in the `trade` method, they are compacted to save gas costs.
    event Increment(uint256 data);
    event Decrement(uint256 data);

    event TokenFallback(
        address indexed user,
        address indexed assetId,
        uint256 amount
    );

    event TokensReceived(
        address indexed user,
        address indexed assetId,
        uint256 amount
    );

    event AnnounceCancel(
        bytes32 indexed offerHash,
        uint256 cancellableAt
    );

    event SlowCancel(
        bytes32 indexed offerHash,
        uint256 amount
    );

    event AnnounceWithdraw(
        address indexed withdrawer,
        address indexed assetId,
        uint256 amount,
        uint256 withdrawableAt
    );

    event SlowWithdraw(
        address indexed withdrawer,
        address indexed assetId,
        uint256 amount
    );

    /// @notice Initializes the Broker contract
    /// @dev The coordinator, operator and owner (through Ownable) is initialized
    /// to be the address of the sender.
    /// The Broker is put into an active state, with maximum exit delays set.
    /// The Broker is also registered as an implementer of ERC777TokensRecipient
    /// through the ERC1820 registry.
    constructor(address _tokenListAddress, address _spenderListAddress) public {
        adminAddresses[msg.sender] = true;
        operator = msg.sender;
        tokenList = TokenList(_tokenListAddress);
        spenderList = SpenderList(_spenderListAddress);

        slowWithdrawDelay = MAX_SLOW_WITHDRAW_DELAY;
        slowCancelDelay = MAX_SLOW_CANCEL_DELAY;
        state = State.Active;

        IERC1820Registry erc1820 = IERC1820Registry(
            0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24
        );

        erc1820.setInterfaceImplementer(
            address(this),
            keccak256("ERC777TokensRecipient"),
            address(this)
        );
    }

    modifier onlyAdmin() {
        // Error code 1: onlyAdmin, address is not an admin address
        require(adminAddresses[msg.sender], "1");
        _;
    }

    modifier onlyActiveState() {
        // Error code 2: onlyActiveState, state is not 'Active'
        require(state == State.Active, "2");
        _;
    }

    modifier onlyEscalatedAdminState() {
        // Error code 3: onlyEscalatedAdminState, adminState is not 'Escalated'
        require(adminState == AdminState.Escalated, "3");
        _;
    }

    /// @notice Checks whether an address is appointed as an admin user
    /// @param _user The address to check
    /// @return Whether the address is appointed as an admin user
    function isAdmin(address _user) external view returns(bool) {
        return adminAddresses[_user];
    }

    /// @notice Sets tbe Broker's state.
    /// @dev The two available states are `Active` and `Inactive`.
    /// The `Active` state allows for regular exchange activity,
    /// while the `Inactive` state prevents the invocation of deposit
    /// and trading functions.
    /// The `Inactive` state is intended as a means to cease contract operation
    /// in the case of an upgrade or in an emergency.
    /// @param _state The state to transition the contract into
    function setState(State _state) external onlyOwner nonReentrant { state = _state; }

    /// @notice Sets the Broker's admin state.
    /// @dev The two available states are `Normal` and `Escalated`.
    /// In the `Normal` admin state, the admin methods `adminCancel` and `adminWithdraw`
    /// are not invocable.
    /// The admin state must be set to `Escalated` by the contract owner for these
    /// methods to become usable.
    /// In an `Escalated` admin state, admin addresses would be able to cancel offers
    /// and withdraw balances to the respective user's wallet on behalf of users.
    /// The escalated state is intended to be used in the case of a contract upgrade or
    /// in an emergency.
    /// It is set separately from the `Inactive` state so that it is possible
    /// to use admin functions without affecting regular operations.
    /// @param _state The admin state to transition the contract into
    function setAdminState(AdminState _state) external onlyOwner nonReentrant { adminState = _state; }

    /// @notice Sets the operator address.
    /// @dev All fees will be transferred to the operator address.
    /// @param _operator The address to set as the operator
    function setOperator(address _operator) external onlyOwner nonReentrant {
        _validateAddress(operator);
        operator = _operator;
    }

    /// @notice Sets the minimum delay between an `announceCancel` call and
    /// when the cancellation can actually be executed through `slowCancel`.
    /// @dev This gives the off-chain service time to update the off-chain state
    /// before the state is separately updated by the user.
    /// This differs from the regular `cancel` operation, which does not involve a delay.
    /// @param _delay The delay in seconds
    function setSlowCancelDelay(uint256 _delay) external onlyOwner nonReentrant {
        // Error code 4: setSlowCancelDelay, slow cancel delay exceeds max allowable delay
        require(_delay <= MAX_SLOW_CANCEL_DELAY, "4");
        slowCancelDelay = _delay;
    }

    /// @notice Sets the delay between an `announceWithdraw` call and
    /// when the withdrawal can actually be executed through `slowWithdraw`.
    /// @dev This gives the off-chain service time to update the off-chain state
    /// before the state is separately updated by the user.
    /// This differs from the regular `withdraw` operation, which does not involve a delay.
    /// @param _delay The delay in seconds
    function setSlowWithdrawDelay(uint256 _delay) external onlyOwner nonReentrant {
        // Error code 5: setSlowWithdrawDelay, slow withdraw delay exceeds max allowable delay
        require(_delay <= MAX_SLOW_WITHDRAW_DELAY, "5");
        slowWithdrawDelay = _delay;
    }

    /// @notice Gives admin permissons to the specified address.
    /// @dev Admin addresses are intended to coordinate the regular operation
    /// of the Broker contract, and to perform special functions such as
    /// `adminCancel` and `adminWithdraw`.
    /// @param _admin The address to give admin permissions to
    function addAdmin(address _admin) external onlyOwner nonReentrant {
        _validateAddress(_admin);
        // Error code 6: addAdmin, address is already an admin address
        require(!adminAddresses[_admin], "6");
        adminAddresses[_admin] = true;
    }

    /// @notice Removes admin permissons for the specified address.
    /// @param _admin The admin address to remove admin permissions from
    function removeAdmin(address _admin) external onlyOwner nonReentrant {
        _validateAddress(_admin);
        // Error code 7: removeAdmin, address is not an admin address
        require(adminAddresses[_admin], "7");
        delete adminAddresses[_admin];
    }

    /// @notice Adds a market DApp to be used in `networkTrade`
    /// @param _dapp Address of the market DApp
    function addMarketDapp(address _dapp) external onlyOwner nonReentrant {
        _validateAddress(_dapp);
        marketDapps.push(_dapp);
    }

    /// @notice Updates a market DApp to be used in `networkTrade`
    /// @param _index Index of the market DApp to update
    /// @param _dapp The new address of the market DApp
    function updateMarketDapp(uint256 _index, address _dapp) external onlyOwner nonReentrant {
        _validateAddress(_dapp);
        // Error code 8: updateMarketDapp, _index does not refer to an existing non-zero address
        require(marketDapps[_index] != address(0), "8");
        marketDapps[_index] = _dapp;
    }

    /// @notice Removes a market DApp
    /// @param _index Index of the market DApp to remove
    function removeMarketDapp(uint256 _index) external onlyOwner nonReentrant {
        // Error code 9: removeMarketDapp, _index does not refer to a DApp address
        require(marketDapps[_index] != address(0), "9");
        delete marketDapps[_index];
    }

    /// @notice Performs a balance transfer from one address to another
    /// @dev This method is intended to be invoked by spender contracts.
    /// To invoke this method, a spender contract must have been
    /// previously whitelisted and also authorized by the address from which
    /// funds will be deducted.
    /// Balance events are not emitted by this method, they should be separately
    /// emitted by the spender contract.
    /// @param _from The address to deduct from
    /// @param _to The address to credit
    /// @param _assetId The asset to transfer
    /// @param _amount The amount to transfer
    function spendFrom(
        address _from,
        address _to,
        address _assetId,
        uint256 _amount
    )
        external
        nonReentrant
    {
        spenderList.validateSpenderAuthorization(_from, msg.sender);

        _validateAddress(_to);

        balances[_from][_assetId] = balances[_from][_assetId].sub(_amount);
        balances[_to][_assetId] = balances[_to][_assetId].add(_amount);
    }

    /// @notice Allows a whitelisted contract to mark nonces
    /// @dev If the whitelisted contract is malicious or vulnerable then there is
    /// a possibility of a DoS attack. However, since this attack requires cooperation
    /// of the contract owner, the risk is similar to the contract owner withholding
    /// transactions, so there is no violation of the contract's trust model.
    /// In the case that nonces are misused, users will still be able to cancel their offers
    /// and withdraw all their funds using the escape hatch methods.
    /// @param _nonce The nonce to mark
    function markNonce(uint256 _nonce) external nonReentrant {
        spenderList.validateSpender(msg.sender);
        _markNonce(_nonce);
    }

    /// @notice Returns whether a nonce has been taken
    /// @param _nonce The nonce to check
    /// @return Whether the nonce has been taken
    function nonceTaken(uint256 _nonce) external view returns (bool) {
        return _nonceTaken(_nonce);
    }

    /// @notice Deposits ETH into the sender's contract balance
    /// @dev This operation is only usable in an `Active` state
    /// to prevent this contract from receiving ETH in the case that its
    /// operation has been terminated.
    function deposit() external payable onlyActiveState nonReentrant {
        // Error code 10: deposit, msg.value is 0
        require(msg.value > 0, "10");
        _increaseBalance(msg.sender, ETHER_ADDR, msg.value, REASON_DEPOSIT, 0);
    }

    /// @dev This function is needed as market DApps generally send ETH
    /// using the `<address>.transfer` method.
    /// It is left empty to avoid issues with the function call running out
    /// of gas, as some callers set a small limit on how much gas can be
    /// used by the ETH receiver.
    function() payable external {}

    /// @notice Deposits ERC20 tokens under the `_user`'s balance
    /// @dev Transfers token into the Broker contract using the
    /// token's `transferFrom` method.
    /// The user must have previously authorized the token transfer
    /// through the token's `approve` method.
    /// This method has separate `_amount` and `_expectedAmount` values
    /// to support unconventional token transfers, e.g. tokens which have a
    /// proportion burnt on transfer.
    /// @param _user The address of the user depositing the tokens
    /// @param _assetId The address of the token contract
    /// @param _amount The value to invoke the token's `transferFrom` with
    /// @param _expectedAmount The final amount expected to be received by this contract
    /// @param _nonce A nonce for balance tracking, emitted in the BalanceIncrease event
    function depositToken(
        address _user,
        address _assetId,
        uint256 _amount,
        uint256 _expectedAmount,
        uint256 _nonce
    )
        external
        onlyAdmin
        onlyActiveState
        nonReentrant
    {
        _increaseBalance(
            _user,
            _assetId,
            _expectedAmount,
            REASON_DEPOSIT,
            _nonce
        );

        Utils.transferTokensIn(
            _user,
            _assetId,
            _amount,
            _expectedAmount
        );
    }

    /// @notice Deposits ERC223 tokens under the `_user`'s balance
    /// @dev ERC223 tokens should invoke this method when tokens are
    /// sent to the Broker contract.
    /// The invocation will fail unless the token has been previously
    /// whitelisted through the `whitelistToken` method.
    /// @param _user The address of the user sending the tokens
    /// @param _amount The amount of tokens transferred to the Broker
    function tokenFallback(
        address _user,
        uint _amount,
        bytes calldata /* _data */
    )
        external
        onlyActiveState
        nonReentrant
    {
        address assetId = msg.sender;
        tokenList.validateToken(assetId);
        _increaseBalance(_user, assetId, _amount, REASON_DEPOSIT, 0);
        emit TokenFallback(_user, assetId, _amount);
    }

    /// @notice Deposits ERC777 tokens under the `_user`'s balance
    /// @dev ERC777 tokens should invoke this method when tokens are
    /// sent to the Broker contract.
    /// The invocation will fail unless the token has been previously
    /// whitelisted through the `whitelistToken` method.
    /// @param _user The address of the user sending the tokens
    /// @param _to The address receiving the tokens
    /// @param _amount The amount of tokens transferred to the Broker
    function tokensReceived(
        address /* _operator */,
        address _user,
        address _to,
        uint _amount,
        bytes calldata /* _userData */,
        bytes calldata /* _operatorData */
    )
        external
        onlyActiveState
        nonReentrant
    {
        if (_to != address(this)) { return; }
        address assetId = msg.sender;
        tokenList.validateToken(assetId);
        _increaseBalance(_user, assetId, _amount, REASON_DEPOSIT, 0);
        emit TokensReceived(_user, assetId, _amount);
    }

    /// @notice Executes an array of offers and fills
    /// @dev This method accepts an array of "offers" and "fills" together with
    /// an array of "matches" to specify the matching between the "offers" and "fills".
    /// The data is bit compacted for ease of index referencing and to reduce gas costs,
    /// i.e. data representing different types of information is stored within one 256 bit value.
    ///
    /// For efficient balance updates, the `_addresses` array is meant to contain a
    /// unique set of user asset pairs in the form of:
    /// [
    ///     user_1_address,
    ///     asset_1_address,
    ///     user_1_address,
    ///     asset_2_address,
    ///     user_2_address,
    ///     asset_1_address,
    ///     ...
    /// ]
    /// This allows combining multiple balance updates for a user asset pair
    /// into a single update by first calculating the total balance update for
    /// a pair at a specified index, then looping through the sums to perform
    /// the balance update.
    ///
    /// The added benefit is further gas cost reduction because repeated
    /// user asset pairs do not need to be duplicated for the calldata.
    ///
    /// The operator address is enforced to be the contract's current operator
    /// address, and the operator fee asset ID is enforced to be identical to
    /// the maker's / filler's feeAssetId.
    ///
    /// A tradeoff of compacting the bits is that there is a lower maximum value
    /// for offer and fill data, however the limits remain generally practical.
    ///
    /// For `offerAmount`, `wantAmount`, `feeAmount` values, the maximum value
    /// is 2^128. For a token with 18 decimals, this allows support for tokens
    /// with a maximum supply of 1000 million billion billion (33 zeros).
    /// In the case where the maximum value needs to be exceeded, a single
    /// offer / fill can be split into multiple offers / fills by the off-chain
    /// service.
    ///
    /// For nonces the maximum value is 2^64, or more than a billion billion (19 zeros).
    ///
    /// Offers and fills both encompass information about how much (offerAmount)
    /// of a specified token (offerAssetId) the user wants to offer and
    /// how much (wantAmount) of another token (wantAssetId) they want
    /// in return.
    ///
    /// Each match specifies how much of the match's `offer.offerAmount` should
    /// be transferred to the filler, in return, the offer's maker receives:
    /// `offer.wantAmount * match.takeAmount / offer.offerAmount` of the
    /// `offer.wantAssetId` from the filler.
    ///
    /// A few restirctions are enforced to ensure fairness and security of trades:
    /// 1. To prevent unfairness due to rounding issues, it is required that:
    /// `offer.wantAmount * match.takeAmount % offer.offerAmount == 0`.
    ///
    /// 2. Fills can be filled by offers which do not individually match
    /// the `fill.offerAmount` and `fill.wantAmount` ratio. As such, it is
    /// required that:
    /// fill.offerAmount == total amount deducted from filler for the fill's
    /// associated matches (excluding fees)
    /// fill.wantAmount == total amount credited to filler for the fill's
    /// associated matches (excluding fees)
    ///
    /// 3. The offer array must not consist of repeated offers. For efficient
    /// balance updates, a loop through each offer in the offer array is used
    /// to deduct the offer.offerAmount from the respective maker
    /// if the offer has not been recorded by a previos `trade` call.
    /// If an offer is repeated in the offers array, then there would be
    /// duplicate deductions from the maker.
    /// To enforce uniqueness, it is required that offers for a trade transaction
    /// are sorted such that their nonces are in a strictly ascending order.
    ///
    /// 4. The fill array must not consist of repeated fills, for the same
    /// reason why there cannot be repeated offers. Additionally, to prevent
    /// replay attacks, all fill nonces are required to be unused.
    ///
    /// @param _values[0] Number of offers, fills, matches
    /// bits(0..8): number of offers (numOffers)
    /// bits(8..16): number of fills (numFills)
    /// bits(16..24): number of matches (numMatches)
    /// bits(24..256): must be zero
    ///
    /// @param _values[1 + i * 2] First part of offer data for the i'th offer
    /// bits(0..8): Index of the maker's address in _addresses
    /// bits(8..16): Index of the maker offerAssetId pair in _addresses
    /// bits(16..24): Index of the maker wantAssetId pair in _addresses
    /// bits(24..32): Index of the maker feeAssetId pair in _addresses
    /// bits(32..40): Index of the operator feeAssetId pair in _addresses
    /// bits(40..48): The `v` component of the maker's signature for this offer
    /// bits(48..56): Indicates whether the Ethereum signed message
    /// prefix should be prepended during signature verification
    /// bits(56..120): The offer nonce to prevent replay attacks
    /// bits(120..128): Space to indicate whether the offer nonce has been marked before
    /// bits(128..256): The number of tokens to be paid to the operator as fees for this offer
    ///
    /// @param _values[2 + i * 2] Second part of offer data for the i'th offer
    /// bits(0..128): offer.offerAmount, i.e. the number of tokens to offer
    /// bits(128..256): offer.wantAmount, i.e. the number of tokens to ask for in return
    ///
    /// @param _values[1 + numOffers * 2 + i * 2] First part of fill data for the i'th fill
    /// bits(0..8): Index of the filler's address in _addresses
    /// bits(8..16): Index of the filler offerAssetId pair in _addresses
    /// bits(16..24): Index of the filler wantAssetId pair in _addresses
    /// bits(24..32): Index of the filler feeAssetId pair in _addresses
    /// bits(32..40): Index of the operator feeAssetId pair in _addresses
    /// bits(40..48): The `v` component of the filler's signature for this fill
    /// bits(48..56): Indicates whether the Ethereum signed message
    /// prefix should be prepended during signature verification
    /// bits(56..120): The fill nonce to prevent replay attacks
    /// bits(120..128): Left empty to match the offer values format
    /// bits(128..256): The number of tokens to be paid to the operator as fees for this fill
    ///
    /// @param _values[2 + numOffers * 2 + i * 2] Second part of fill data for the i'th fill
    /// bits(0..128): fill.offerAmount, i.e. the number of tokens to offer
    /// bits(128..256): fill.wantAmount, i.e. the number of tokens to ask for in return
    ///
    /// @param _values[1 + numOffers * 2 + numFills * 2 + i] Data for the i'th match
    /// bits(0..8): Index of the offerIndex for this match
    /// bits(8..16): Index of the fillIndex for this match
    /// bits(128..256): The number of tokens to take from the matched offer's offerAmount
    ///
    /// @param _hashes[i * 2] The `r` component of the maker's / filler's signature
    /// for the i'th offer / fill
    ///
    /// @param _hashes[i * 2 + 1] The `s` component of the maker's / filler's signature
    /// for the i'th offer / fill
    ///
    /// @param _addresses An array of user asset pairs in the form of:
    /// [
    ///     user_1_address,
    ///     asset_1_address,
    ///     user_1_address,
    ///     asset_2_address,
    ///     user_2_address,
    ///     asset_1_address,
    ///     ...
    /// ]
    function trade(
        uint256[] memory _values,
        bytes32[] memory _hashes,
        address[] memory _addresses
    )
        public
        onlyAdmin
        onlyActiveState
        nonReentrant
    {
        // Cache the operator address to reduce gas costs from storage reads
        address operatorAddress = operator;
        // An array variable to store balance increments / decrements
        uint256[] memory statements;

        // Cache whether offer nonces are taken in the offer's nonce space
        _cacheOfferNonceStates(_values);

        // `validateTrades` needs to calculate the hash keys of offers and fills
        // to verify the signature of the offer / fill.
        // The calculated hash keys are returned to reduce repeated computation.
        _hashes = Utils.validateTrades(
            _values,
            _hashes,
            _addresses,
            operatorAddress
        );

        statements = Utils.calculateTradeIncrements(_values, _addresses.length / 2);
        _incrementBalances(statements, _addresses, 1);

        statements = Utils.calculateTradeDecrements(_values, _addresses.length / 2);
        _decrementBalances(statements, _addresses);

        // Reduce available offer amounts of offers and store the remaining
        // offer amount in the `offers` mapping.
        // Offer nonces will also be marked as taken.
        _storeOfferData(_values, _hashes);

        // Mark all fill nonces as taken in the `usedNonces` mapping.
        _storeFillNonces(_values);
    }

    /// @notice Executes an array of offers against external orders.
    /// @dev This method accepts an array of "offers" together with
    /// an array of "matches" to specify the matching between the "offers" and
    /// external orders.
    /// The data is bit compacted and formatted in the same way as the `trade` function.
    ///
    /// @param _values[0] Number of offers, fills, matches
    /// bits(0..8): number of offers (numOffers)
    /// bits(8..16): number of fills, must be zero
    /// bits(16..24): number of matches (numMatches)
    /// bits(24..256): must be zero
    ///
    /// @param _values[1 + i * 2] First part of offer data for the i'th offer
    /// bits(0..8): Index of the maker's address in _addresses
    /// bits(8..16): Index of the maker offerAssetId pair in _addresses
    /// bits(16..24): Index of the maker wantAssetId pair in _addresses
    /// bits(24..32): Index of the maker feeAssetId pair in _addresses
    /// bits(32..40): Index of the operator feeAssetId pair in _addresses
    /// bits(40..48): The `v` component of the maker's signature for this offer
    /// bits(48..56): Indicates whether the Ethereum signed message
    /// prefix should be prepended during signature verification
    /// bits(56..120): The offer nonce to prevent replay attacks
    /// bits(120..128): Space to indicate whether the offer nonce has been marked before
    /// bits(128..256): The number of tokens to be paid to the operator as fees for this offer
    ///
    /// @param _values[2 + i * 2] Second part of offer data for the i'th offer
    /// bits(0..128): offer.offerAmount, i.e. the number of tokens to offer
    /// bits(128..256): offer.wantAmount, i.e. the number of tokens to ask for in return
    ///
    /// @param _values[1 + numOffers * 2 + i] Data for the i'th match
    /// bits(0..8): Index of the offerIndex for this match
    /// bits(8..16): Index of the marketDapp for this match
    /// bits(16..24): Index of the surplus receiver and surplus asset ID for this
    /// match, for any excess tokens resulting from the trade
    /// bits(24..128): Additional DApp specific data
    /// bits(128..256): The number of tokens to take from the matched offer's offerAmount
    ///
    /// @param _hashes[i * 2] The `r` component of the maker's / filler's signature
    /// for the i'th offer / fill
    ///
    /// @param _hashes[i * 2 + 1] The `s` component of the maker's / filler's signature
    /// for the i'th offer / fill
    ///
    /// @param _addresses An array of user asset pairs in the form of:
    /// [
    ///     user_1_address,
    ///     asset_1_address,
    ///     user_1_address,
    ///     asset_2_address,
    ///     user_2_address,
    ///     asset_1_address,
    ///     ...
    /// ]
    function networkTrade(
        uint256[] memory _values,
        bytes32[] memory _hashes,
        address[] memory _addresses
    )
        public
        onlyAdmin
        onlyActiveState
        nonReentrant
    {
        // Cache the operator address to reduce gas costs from storage reads
        address operatorAddress = operator;
        // An array variable to store balance increments / decrements
        uint256[] memory statements;

        // Cache whether offer nonces are taken in the offer's nonce space
        _cacheOfferNonceStates(_values);

        // `validateNetworkTrades` needs to calculate the hash keys of offers
        // to verify the signature of the offer.
        // The calculated hash keys for each offer is return to reduce repeated
        // computation.
        _hashes = Utils.validateNetworkTrades(
            _values,
            _hashes,
            _addresses,
            operatorAddress
        );

        statements = Utils.calculateNetworkTradeIncrements(_values, _addresses.length / 2);
        _incrementBalances(statements, _addresses, 1);

        statements = Utils.calculateNetworkTradeDecrements(_values, _addresses.length / 2);
        _decrementBalances(statements, _addresses);

        // Reduce available offer amounts of offers and store the remaining
        // offer amount in the `offers` mapping.
        // Offer nonces will also be marked as taken.
        _storeOfferData(_values, _hashes);

        // There may be excess tokens resulting from a trade
        // Any excess tokens are returned and recorded in `increments`
        statements = Utils.performNetworkTrades(
            _values,
            _addresses,
            marketDapps
        );
        _incrementBalances(statements, _addresses, 0);
    }

    /// @notice Cancels a perviously made offer and refunds the remaining offer
    /// amount to the offer maker.
    /// To reduce gas costs, the original parameters of the offer are not stored
    /// in the contract's storage, only the hash of the parameters is stored for
    /// verification, so the original parameters need to be re-specified here.
    ///
    /// The `_expectedavailableamount` is required to help prevent accidental
    /// cancellation of an offer ahead of time, for example, if there is
    /// a pending fill in the off-chain state.
    ///
    /// @param _values[0] The offerAmount and wantAmount of the offer
    /// bits(0..128): offer.offerAmount
    /// bits(128..256): offer.wantAmount
    ///
    /// @param _values[1] The fee amounts
    /// bits(0..128): offer.feeAmount
    /// bits(128..256): cancelFeeAmount
    ///
    /// @param _values[2] Additional offer and cancellation data
    /// bits(0..128): expectedAvailableAmount
    /// bits(128..136): prefixedSignature
    /// bits(136..144): The `v` component of the maker's signature for the cancellation
    /// bits(144..256): offer.nonce
    ///
    /// @param _hashes[0] The `r` component of the maker's signature for the cancellation
    /// @param _hashes[1] The `s` component of the maker's signature for the cancellation
    ///
    /// @param _addresses[0] offer.maker
    /// @param _addresses[1] offer.offerAssetId
    /// @param _addresses[2] offer.wantAssetId
    /// @param _addresses[3] offer.feeAssetId
    /// @param _addresses[4] offer.cancelFeeAssetId
    function cancel(
        uint256[] calldata _values,
        bytes32[] calldata _hashes,
        address[] calldata _addresses
    )
        external
        onlyAdmin
        nonReentrant
    {
        Utils.validateCancel(_values, _hashes, _addresses);
        bytes32 offerHash = Utils.hashOffer(_values, _addresses);
        _cancel(
            _addresses[0], // maker
            offerHash,
            _values[2] & mask128, // expectedAvailableAmount
            _addresses[1], // offerAssetId
            _values[2] >> 144, // offerNonce
            _addresses[4], // cancelFeeAssetId
            _values[1] >> 128 // cancelFeeAmount
        );
    }

    /// @notice Cancels an offer without requiring the maker's signature
    /// @dev This method is intended to be used in the case of a contract
    /// upgrade or in an emergency. It can only be invoked by an admin and only
    /// after the admin state has been set to `Escalated` by the contract owner.
    ///
    /// To reduce gas costs, the original parameters of the offer are not stored
    /// in the contract's storage, only the hash of the parameters is stored for
    /// verification, so the original parameters need to be re-specified here.
    ///
    /// The `_expectedavailableamount` is required to help prevent accidental
    /// cancellation of an offer ahead of time, for example, if there is
    /// a pending fill in the off-chain state.
    /// @param _maker The address of the offer's maker
    /// @param _offerAssetId The contract address of the offerred asset
    /// @param _offerAmount The number of tokens offerred
    /// @param _wantAssetId The contract address of the asset asked in return
    /// @param _wantAmount The number of tokens asked for in return
    /// @param _feeAssetId The contract address of the fee asset
    /// @param _feeAmount The number of tokens to pay as fees to the operator
    /// @param _offerNonce The nonce of the original offer
    /// @param _expectedAvailableAmount The offer amount remaining
    function adminCancel(
        address _maker,
        address _offerAssetId,
        uint256 _offerAmount,
        address _wantAssetId,
        uint256 _wantAmount,
        address _feeAssetId,
        uint256 _feeAmount,
        uint256 _offerNonce,
        uint256 _expectedAvailableAmount
    )
        external
        onlyAdmin
        onlyEscalatedAdminState
        nonReentrant
    {
        bytes32 offerHash = keccak256(abi.encode(
            OFFER_TYPEHASH,
            _maker,
            _offerAssetId,
            _offerAmount,
            _wantAssetId,
            _wantAmount,
            _feeAssetId,
            _feeAmount,
            _offerNonce
        ));

        _cancel(
            _maker,
            offerHash,
            _expectedAvailableAmount,
            _offerAssetId,
            _offerNonce,
            address(0),
            0
        );
    }

    /// @notice Announces a user's intention to cancel their offer
    /// @dev This method allows a user to cancel their offer without requiring
    /// admin permissions.
    /// An announcement followed by a delay is needed so that the off-chain
    /// service has time to update the off-chain state.
    ///
    /// To reduce gas costs, the original parameters of the offer are not stored
    /// in the contract's storage, only the hash of the parameters is stored for
    /// verification, so the original parameters need to be re-specified here.
    ///
    /// @param _maker The address of the offer's maker
    /// @param _offerAssetId The contract address of the offerred asset
    /// @param _offerAmount The number of tokens offerred
    /// @param _wantAssetId The contract address of the asset asked in return
    /// @param _wantAmount The number of tokens asked for in return
    /// @param _feeAssetId The contract address of the fee asset
    /// @param _feeAmount The number of tokens to pay as fees to the operator
    /// @param _offerNonce The nonce of the original offer
    function announceCancel(
        address _maker,
        address _offerAssetId,
        uint256 _offerAmount,
        address _wantAssetId,
        uint256 _wantAmount,
        address _feeAssetId,
        uint256 _feeAmount,
        uint256 _offerNonce
    )
        external
        nonReentrant
    {
        // Error code 11: announceCancel, invalid msg.sender
        require(_maker == msg.sender, "11");

        bytes32 offerHash = keccak256(abi.encode(
            OFFER_TYPEHASH,
            _maker,
            _offerAssetId,
            _offerAmount,
            _wantAssetId,
            _wantAmount,
            _feeAssetId,
            _feeAmount,
            _offerNonce
        ));

        // Error code 12: announceCancel, nothing left to cancel
        require(offers[offerHash] > 0, "12");

        uint256 cancellableAt = now.add(slowCancelDelay);
        cancellationAnnouncements[offerHash] = cancellableAt;

        emit AnnounceCancel(offerHash, cancellableAt);
    }

    /// @notice Executes an offer cancellation previously announced in `announceCancel`
    /// @dev This method allows a user to cancel their offer without requiring
    /// admin permissions.
    /// An announcement followed by a delay is needed so that the off-chain
    /// service has time to update the off-chain state.
    ///
    /// To reduce gas costs, the original parameters of the offer are not stored
    /// in the contract's storage, only the hash of the parameters is stored for
    /// verification, so the original parameters need to be re-specified here.
    ///
    /// @param _maker The address of the offer's maker
    /// @param _offerAssetId The contract address of the offerred asset
    /// @param _offerAmount The number of tokens offerred
    /// @param _wantAssetId The contract address of the asset asked in return
    /// @param _wantAmount The number of tokens asked for in return
    /// @param _feeAssetId The contract address of the fee asset
    /// @param _feeAmount The number of tokens to pay as fees to the operator
    /// @param _offerNonce The nonce of the original offer
    function slowCancel(
        address _maker,
        address _offerAssetId,
        uint256 _offerAmount,
        address _wantAssetId,
        uint256 _wantAmount,
        address _feeAssetId,
        uint256 _feeAmount,
        uint256 _offerNonce
    )
        external
        nonReentrant
    {
        bytes32 offerHash = keccak256(abi.encode(
            OFFER_TYPEHASH,
            _maker,
            _offerAssetId,
            _offerAmount,
            _wantAssetId,
            _wantAmount,
            _feeAssetId,
            _feeAmount,
            _offerNonce
        ));

        uint256 cancellableAt = cancellationAnnouncements[offerHash];
        // Error code 13: slowCancel, cancellation was not announced
        require(cancellableAt != 0, "13");
        // Error code 14: slowCancel, cancellation delay not yet reached
        require(now >= cancellableAt, "14");

        uint256 availableAmount = offers[offerHash];
        // Error code 15: slowCancel, nothing left to cancel
        require(availableAmount > 0, "15");

        delete cancellationAnnouncements[offerHash];
        _cancel(
            _maker,
            offerHash,
            availableAmount,
            _offerAssetId,
            _offerNonce,
            address(0),
            0
        );

        emit SlowCancel(offerHash, availableAmount);
    }

    /// @notice Withdraws tokens from the Broker contract to a user's wallet balance
    /// @dev The user's internal balance is decreased, and the tokens are transferred
    /// to the `_receivingAddress` signed by the user.
    /// @param _withdrawer The user address whose balance will be reduced
    /// @param _receivingAddress The address to tranfer the tokens to
    /// @param _assetId The contract address of the token to withdraw
    /// @param _amount The number of tokens to withdraw
    /// @param _feeAssetId The contract address of the fee asset
    /// @param _feeAmount The number of tokens to pay as fees to the operator
    /// @param _nonce An unused nonce to prevent replay attacks
    /// @param _v The `v` component of the `_user`'s signature
    /// @param _r The `r` component of the `_user`'s signature
    /// @param _s The `s` component of the `_user`'s signature
    /// @param _prefixedSignature Indicates whether the Ethereum signed message
    /// prefix should be prepended during signature verification
    function withdraw(
        address _withdrawer,
        address payable _receivingAddress,
        address _assetId,
        uint256 _amount,
        address _feeAssetId,
        uint256 _feeAmount,
        uint256 _nonce,
        uint8 _v,
        bytes32 _r,
        bytes32 _s,
        bool _prefixedSignature
    )
        external
        onlyAdmin
        nonReentrant
    {
        _markNonce(_nonce);

        _validateSignature(
            keccak256(abi.encode(
                WITHDRAW_TYPEHASH,
                _withdrawer,
                _receivingAddress,
                _assetId,
                _amount,
                _feeAssetId,
                _feeAmount,
                _nonce
            )),
            _withdrawer,
            _v,
            _r,
            _s,
            _prefixedSignature
        );

        _withdraw(
            _withdrawer,
            _receivingAddress,
            _assetId,
            _amount,
            _feeAssetId,
            _feeAmount,
            _nonce
        );
    }

    /// @notice Withdraws tokens without requiring the withdrawer's signature
    /// @dev This method is intended to be used in the case of a contract
    /// upgrade or in an emergency. It can only be invoked by an admin and only
    /// after the admin state has been set to `Escalated` by the contract owner.
    /// Unlike `withdraw`, tokens can only be withdrawn to the `_withdrawer`'s
    /// address.
    /// @param _withdrawer The user address whose balance will be reduced
    /// @param _assetId The contract address of the token to withdraw
    /// @param _amount The number of tokens to withdraw
    /// @param _nonce An unused nonce for balance tracking
    function adminWithdraw(
        address payable _withdrawer,
        address _assetId,
        uint256 _amount,
        uint256 _nonce
    )
        external
        onlyAdmin
        onlyEscalatedAdminState
        nonReentrant
    {
        _markNonce(_nonce);

        _withdraw(
            _withdrawer,
            _withdrawer,
            _assetId,
            _amount,
            address(0),
            0,
            _nonce
        );
    }

    /// @notice Announces a user's intention to withdraw their funds
    /// @dev This method allows a user to withdraw their funds without requiring
    /// admin permissions.
    /// An announcement followed by a delay before execution is needed so that
    /// the off-chain service has time to update the off-chain state.
    /// @param _assetId The contract address of the token to withdraw
    /// @param _amount The number of tokens to withdraw
    function announceWithdraw(
        address _assetId,
        uint256 _amount
    )
        external
        nonReentrant
    {

        // Error code 16: announceWithdraw, invalid withdrawal amount
        require(_amount > 0 && _amount <= balances[msg.sender][_assetId], "16");

        WithdrawalAnnouncement storage announcement = withdrawalAnnouncements[msg.sender][_assetId];

        announcement.withdrawableAt = now.add(slowWithdrawDelay);
        announcement.amount = _amount;

        emit AnnounceWithdraw(msg.sender, _assetId, _amount, announcement.withdrawableAt);
    }

    /// @notice Executes a withdrawal previously announced in `announceWithdraw`
    /// @dev This method allows a user to withdraw their funds without requiring
    /// admin permissions.
    /// An announcement followed by a delay before execution is needed so that
    /// the off-chain service has time to update the off-chain state.
    /// @param _withdrawer The user address whose balance will be reduced
    /// @param _assetId The contract address of the token to withdraw
    function slowWithdraw(
        address payable _withdrawer,
        address _assetId,
        uint256 _amount
    )
        external
        nonReentrant
    {
        WithdrawalAnnouncement memory announcement = withdrawalAnnouncements[_withdrawer][_assetId];

        // Error code 17: slowWithdraw, withdrawal was not announced
        require(announcement.withdrawableAt != 0, "17");
        // Error code 18: slowWithdraw, withdrawal delay not yet reached
        require(now >= announcement.withdrawableAt, "18");
        // Error code 19: slowWithdraw, withdrawal amount does not match announced amount
        require(announcement.amount == _amount, "19");

        delete withdrawalAnnouncements[_withdrawer][_assetId];
        _withdraw(
            _withdrawer,
            _withdrawer,
            _assetId,
            _amount,
            address(0),
            0,
            0
        );
        emit SlowWithdraw(_withdrawer, _assetId, _amount);
    }

    /// @notice Locks a user's balances for the first part of an atomic swap
    /// @param _addresses[0] maker: the address of the user to deduct the swap tokens from
    /// @param _addresses[1] taker: the address of the swap taker who will receive the swap tokens
    /// if the swap is completed through `executeSwap`
    /// @param _addresses[2] assetId: the contract address of the token to swap
    /// @param _addresses[3] feeAssetId: the contract address of the token to use as fees
    /// @param _values[0] amount: the number of tokens to lock and to transfer if the swap
    ///  is completed through `executeSwap`
    /// @param _values[1] expiryTime: the time in epoch seconds after which the swap will become cancellable
    /// @param _values[2] feeAmount: the number of tokens to be paid to the operator as fees
    /// @param _values[3] nonce: an unused nonce to prevent replay attacks
    /// @param _hashes[0] hashedSecret: the hash of the secret decided by the maker
    /// @param _hashes[1] The `r` component of the user's signature
    /// @param _hashes[2] The `s` component of the user's signature
    /// @param _v The `v` component of the user's signature
    /// @param _prefixedSignature Indicates whether the Ethereum signed message
    /// prefix should be prepended during signature verification
    function createSwap(
        address[4] calldata _addresses,
        uint256[4] calldata _values,
        bytes32[3] calldata _hashes,
        uint8 _v,
        bool _prefixedSignature
    )
        external
        onlyAdmin
        onlyActiveState
        nonReentrant
    {
        // Error code 20: createSwap, invalid swap amount
        require(_values[0] > 0, "20");
        // Error code 21: createSwap, expiry time has already passed
        require(_values[1] > now, "21");
        _validateAddress(_addresses[1]);

        // Error code 39: createSwap, swap maker cannot be the swap taker
        require(_addresses[0] != _addresses[1], "39");

        bytes32 swapHash = _hashSwap(_addresses, _values, _hashes[0]);
        // Error code 22: createSwap, the swap is already active
        require(!atomicSwaps[swapHash], "22");

        _markNonce(_values[3]);

        _validateSignature(
            swapHash,
            _addresses[0], // swap.maker
            _v,
            _hashes[1], // r
            _hashes[2], // s
            _prefixedSignature
        );

        if (_addresses[3] == _addresses[2]) { // feeAssetId == assetId
            // Error code 23: createSwap, swap.feeAmount exceeds swap.amount
            require(_values[2] < _values[0], "23"); // feeAmount < amount
        } else {
            _decreaseBalance(
                _addresses[0], // maker
                _addresses[3], // feeAssetId
                _values[2], // feeAmount
                REASON_SWAP_FEE_GIVE,
                _values[3] // nonce
            );
        }

        _decreaseBalance(
            _addresses[0], // maker
            _addresses[2], // assetId
            _values[0], // amount
            REASON_SWAP_GIVE,
            _values[3] // nonce
        );

        atomicSwaps[swapHash] = true;
    }

    /// @notice Executes a swap by transferring the tokens previously locked through
    /// a `createSwap` call to the swap taker.
    ///
    /// @dev To reduce gas costs, the original parameters of the swap are not stored
    /// in the contract's storage, only the hash of the parameters is stored for
    /// verification, so the original parameters need to be re-specified here.
    ///
    /// @param _addresses[0] maker: the address of the user to deduct the swap tokens from
    /// @param _addresses[1] taker: the address of the swap taker who will receive the swap tokens
    /// @param _addresses[2] assetId: the contract address of the token to swap
    /// @param _addresses[3] feeAssetId: the contract address of the token to use as fees
    /// @param _values[0] amount: the number of tokens previously locked
    /// @param _values[1] expiryTime: the time in epoch seconds after which the swap will become cancellable
    /// @param _values[2] feeAmount: the number of tokens to be paid to the operator as fees
    /// @param _values[3] nonce: an unused nonce to prevent replay attacks
    /// @param _hashedSecret The hash of the secret decided by the maker
    /// @param _preimage The preimage of the `_hashedSecret`
    function executeSwap(
        address[4] calldata _addresses,
        uint256[4] calldata _values,
        bytes32 _hashedSecret,
        bytes calldata _preimage
    )
        external
        nonReentrant
    {
        // Error code 37: swap secret length exceeded
        require(_preimage.length <= MAX_SWAP_SECRET_LENGTH, "37");

        bytes32 swapHash = _hashSwap(_addresses, _values, _hashedSecret);
        // Error code 24: executeSwap, swap is not active
        require(atomicSwaps[swapHash], "24");
        // Error code 25: executeSwap, hash of preimage does not match hashedSecret
        require(sha256(abi.encodePacked(sha256(_preimage))) == _hashedSecret, "25");

        uint256 takeAmount = _values[0];
        if (_addresses[3] == _addresses[2]) { // feeAssetId == assetId
            takeAmount = takeAmount.sub(_values[2]);
        }

        delete atomicSwaps[swapHash];

        _increaseBalance(
            _addresses[1], // taker
            _addresses[2], // assetId
            takeAmount,
            REASON_SWAP_RECEIVE,
            _values[3] // nonce
        );

        _increaseBalance(
            operator,
            _addresses[3], // feeAssetId
            _values[2], // feeAmount
            REASON_SWAP_FEE_RECEIVE,
            _values[3] // nonce
        );
    }

    /// @notice Cancels a swap and refunds the previously locked tokens to
    /// the swap maker.
    ///
    /// @dev To reduce gas costs, the original parameters of the swap are not stored
    /// in the contract's storage, only the hash of the parameters is stored for
    /// verification, so the original parameters need to be re-specified here.
    ///
    /// @param _addresses[0] maker: the address of the user to deduct the swap tokens from
    /// @param _addresses[1] taker: the address of the swap taker who will receive the swap tokens
    /// @param _addresses[2] assetId: the contract address of the token to swap
    /// @param _addresses[3] feeAssetId: the contract address of the token to use as fees
    /// @param _values[0] amount: the number of tokens previously locked
    /// @param _values[1] expiryTime: the time in epoch seconds after which the swap will become cancellable
    /// @param _values[2] feeAmount: the number of tokens to be paid to the operator as fees
    /// @param _values[3] nonce: an unused nonce to prevent replay attacks
    /// @param _hashedSecret The hash of the secret decided by the maker
    /// @param _cancelFeeAmount The number of tokens to be paid to the operator as the cancellation fee
    function cancelSwap(
        address[4] calldata _addresses,
        uint256[4] calldata _values,
        bytes32 _hashedSecret,
        uint256 _cancelFeeAmount
    )
        external
        nonReentrant
    {
        // Error code 26: cancelSwap, expiry time has not been reached
        require(_values[1] <= now, "26");
        bytes32 swapHash = _hashSwap(_addresses, _values, _hashedSecret);
        // Error code 27: cancelSwap, swap is not active
        require(atomicSwaps[swapHash], "27");

        uint256 cancelFeeAmount = _cancelFeeAmount;
        if (!adminAddresses[msg.sender]) { cancelFeeAmount = _values[2]; }

        // cancelFeeAmount <= feeAmount
        // Error code 28: cancelSwap, cancelFeeAmount exceeds swap.feeAmount
        require(cancelFeeAmount <= _values[2], "28");

        uint256 refundAmount = _values[0];
        if (_addresses[3] == _addresses[2]) { // feeAssetId == assetId
            refundAmount = refundAmount.sub(cancelFeeAmount);
        }

        delete atomicSwaps[swapHash];

        _increaseBalance(
            _addresses[0], // maker
            _addresses[2], // assetId
            refundAmount,
            REASON_SWAP_CANCEL_RECEIVE,
            _values[3] // nonce
        );

        _increaseBalance(
            operator,
            _addresses[3], // feeAssetId
            cancelFeeAmount,
            REASON_SWAP_CANCEL_FEE_RECEIVE,
            _values[3] // nonce
        );

        if (_addresses[3] != _addresses[2]) { // feeAssetId != assetId
            uint256 refundFeeAmount = _values[2].sub(cancelFeeAmount);
            _increaseBalance(
                _addresses[0], // maker
                _addresses[3], // feeAssetId
                refundFeeAmount,
                REASON_SWAP_CANCEL_FEE_REFUND,
                _values[3] // nonce
            );
        }
    }

    /// @dev Cache whether offer nonces are taken in the offer's nonce space
    /// @param _values The _values param from the trade / networkTrade method
    function _cacheOfferNonceStates(uint256[] memory _values) private view {
        uint256 i = 1;
        // i + numOffers * 2
        uint256 end = i + (_values[0] & mask8) * 2;

        // loop offers
        for(i; i < end; i += 2) {
            // Error code 38: Invalid nonce space
            require(((_values[i] & mask128) >> 120) == 0, "38");

            uint256 nonce = (_values[i] & mask120) >> 56;
            if (_nonceTaken(nonce)) {
                _values[i] = _values[i] | (uint256(1) << 120);
            }
        }
    }

    /// @dev Reduce available offer amounts of offers and store the remaining
    /// offer amount in the `offers` mapping.
    /// Offer nonces will also be marked as taken.
    /// See the `trade` method for param details.
    /// @param _values Values from `trade`
    /// @param _hashes An array of offer hash keys
    function _storeOfferData(
        uint256[] memory _values,
        bytes32[] memory _hashes
    )
        private
    {
        // takenAmounts with same size as numOffers
        uint256[] memory takenAmounts = new uint256[](_values[0] & mask8);

        uint256 i = 1;
        // i += numOffers * 2
        i += (_values[0] & mask8) * 2;
        // i += numFills * 2
        i += ((_values[0] & mask16) >> 8) * 2;

        uint256 end = _values.length;

        // loop matches
        for (i; i < end; i++) {
            uint256 offerIndex = _values[i] & mask8;
            uint256 takeAmount = _values[i] >> 128;
            takenAmounts[offerIndex] = takenAmounts[offerIndex].add(takeAmount);
        }

        i = 0;
        end = _values[0] & mask8; // numOffers

        // loop offers
        for (i; i < end; i++) {
            // we can use the cached nonce taken value here because offers have been
            // validated to be unique
            bool existingOffer = ((_values[i * 2 + 1] & mask128) >> 120) == 1;
            bytes32 hashKey = _hashes[i * 2];

            uint256 availableAmount = existingOffer ? offers[hashKey] : (_values[i * 2 + 2] & mask128);
            // Error code 31: _storeOfferData, offer's available amount is zero
            require(availableAmount > 0, "31");

            uint256 remainingAmount = availableAmount.sub(takenAmounts[i]);
            if (remainingAmount > 0) { offers[hashKey] = remainingAmount; }
            if (existingOffer && remainingAmount == 0) { delete offers[hashKey]; }

            if (!existingOffer) {
                uint256 nonce = (_values[i * 2 + 1] & mask120) >> 56;
                _markNonce(nonce);
            }
        }
    }

    /// @dev Mark all fill nonces as taken in the `usedNonces` mapping.
    /// This also validates fill uniquness within the set of fills in `_values`,
    /// since fill nonces are marked one at a time with validation that the
    /// nonce to be marked has not been marked before.
    /// See the `trade` method for param details.
    /// @param _values Values from `trade`
    function _storeFillNonces(uint256[] memory _values) private {
        // 1 + numOffers * 2
        uint256 i = 1 + (_values[0] & mask8) * 2;
        // i + numFills * 2
        uint256 end = i + ((_values[0] & mask16) >> 8) * 2;

        // loop fills
        for(i; i < end; i += 2) {
            uint256 nonce = (_values[i] & mask120) >> 56;
            _markNonce(nonce);
        }
    }

    /// @dev The actual cancellation logic shared by `cancel`, `adminCancel`,
    /// `slowCancel`.
    /// The remaining offer amount is refunded back to the offer's maker, and
    /// the specified cancellation fee will be deducted from the maker's balances.
    function _cancel(
        address _maker,
        bytes32 _offerHash,
        uint256 _expectedAvailableAmount,
        address _offerAssetId,
        uint256 _offerNonce,
        address _cancelFeeAssetId,
        uint256 _cancelFeeAmount
    )
        private
    {
        uint256 refundAmount = offers[_offerHash];
        // Error code 32: _cancel, there is no offer amount left to cancel
        require(refundAmount > 0, "32");
        // Error code 33: _cancel, the remaining offer amount does not match
        // the expectedAvailableAmount
        require(refundAmount == _expectedAvailableAmount, "33");

        delete offers[_offerHash];

        if (_cancelFeeAssetId == _offerAssetId) {
            refundAmount = refundAmount.sub(_cancelFeeAmount);
        } else {
            _decreaseBalance(
                _maker,
                _cancelFeeAssetId,
                _cancelFeeAmount,
                REASON_CANCEL_FEE_GIVE,
                _offerNonce
            );
        }

        _increaseBalance(
            _maker,
            _offerAssetId,
            refundAmount,
            REASON_CANCEL,
            _offerNonce
        );

        _increaseBalance(
            operator,
            _cancelFeeAssetId,
            _cancelFeeAmount,
            REASON_CANCEL_FEE_RECEIVE,
            _offerNonce // offer nonce
        );
    }

    /// @dev The actual withdrawal logic shared by `withdraw`, `adminWithdraw`,
    /// `slowWithdraw`. The specified amount is deducted from the `_withdrawer`'s
    /// contract balance and transferred to the external `_receivingAddress`,
    /// and the specified withdrawal fee will be deducted from the `_withdrawer`'s
    /// balance.
    function _withdraw(
        address _withdrawer,
        address payable _receivingAddress,
        address _assetId,
        uint256 _amount,
        address _feeAssetId,
        uint256 _feeAmount,
        uint256 _nonce
    )
        private
    {
        // Error code 34: _withdraw, invalid withdrawal amount
        require(_amount > 0, "34");

        _validateAddress(_receivingAddress);

        _decreaseBalance(
            _withdrawer,
            _assetId,
            _amount,
            REASON_WITHDRAW,
            _nonce
        );

        _increaseBalance(
            operator,
            _feeAssetId,
            _feeAmount,
            REASON_WITHDRAW_FEE_RECEIVE,
            _nonce
        );

        uint256 withdrawAmount;

        if (_feeAssetId == _assetId) {
            withdrawAmount = _amount.sub(_feeAmount);
        } else {
            _decreaseBalance(
                _withdrawer,
                _feeAssetId,
                _feeAmount,
                REASON_WITHDRAW_FEE_GIVE,
                _nonce
            );
            withdrawAmount = _amount;
        }

        if (_assetId == ETHER_ADDR) {
            _receivingAddress.transfer(withdrawAmount);
            return;
        }

        Utils.transferTokensOut(
            _receivingAddress,
            _assetId,
            withdrawAmount
        );
    }

    /// @dev Creates a hash key for a swap using the swap's parameters
    /// @param _addresses[0] Address of the user making the swap
    /// @param _addresses[1] Address of the user taking the swap
    /// @param _addresses[2] Contract address of the asset to swap
    /// @param _addresses[3] Contract address of the fee asset
    /// @param _values[0] The number of tokens to be transferred
    /// @param _values[1] The time in epoch seconds after which the swap will become cancellable
    /// @param _values[2] The number of tokens to pay as fees to the operator
    /// @param _values[3] The swap nonce to prevent replay attacks
    /// @param _hashedSecret The hash of the secret decided by the maker
    /// @return The hash key of the swap
    function _hashSwap(
        address[4] memory _addresses,
        uint256[4] memory _values,
        bytes32 _hashedSecret
    )
        private
        pure
        returns (bytes32)
    {
        return keccak256(abi.encode(
            SWAP_TYPEHASH,
            _addresses[0], // maker
            _addresses[1], // taker
            _addresses[2], // assetId
            _values[0], // amount
            _hashedSecret, // hashedSecret
            _values[1], // expiryTime
            _addresses[3], // feeAssetId
            _values[2], // feeAmount
            _values[3] // nonce
        ));
    }

    /// @dev Checks if the `_nonce` had been previously taken.
    /// To reduce gas costs, a single `usedNonces` value is used to
    /// store the state of 256 nonces, using the formula:
    /// nonceTaken = "usedNonces[_nonce / 256] bit (_nonce % 256)" != 0
    /// For example:
    /// nonce 0 taken: "usedNonces[0] bit 0" != 0 (0 / 256 = 0, 0 % 256 = 0)
    /// nonce 1 taken: "usedNonces[0] bit 1" != 0 (1 / 256 = 0, 1 % 256 = 1)
    /// nonce 2 taken: "usedNonces[0] bit 2" != 0 (2 / 256 = 0, 2 % 256 = 2)
    /// nonce 255 taken: "usedNonces[0] bit 255" != 0 (255 / 256 = 0, 255 % 256 = 255)
    /// nonce 256 taken: "usedNonces[1] bit 0" != 0 (256 / 256 = 1, 256 % 256 = 0)
    /// nonce 257 taken: "usedNonces[1] bit 1" != 0 (257 / 256 = 1, 257 % 256 = 1)
    /// @param _nonce The nonce to check
    /// @return Whether the nonce has been taken
    function _nonceTaken(uint256 _nonce) private view returns (bool) {
        uint256 slotData = _nonce.div(256);
        uint256 shiftedBit = uint256(1) << _nonce.mod(256);
        uint256 bits = usedNonces[slotData];

        // The check is for "!= 0" instead of "== 1" because the shiftedBit is
        // not at the zero'th position, so it would require an additional
        // shift to compare it with "== 1"
        return bits & shiftedBit != 0;
    }

    /// @dev Sets the corresponding `_nonce` bit to 1.
    /// An error will be raised if the corresponding `_nonce` bit was
    /// previously set to 1.
    /// See `_nonceTaken` for details on calculating the corresponding `_nonce` bit.
    /// @param _nonce The nonce to mark
    function _markNonce(uint256 _nonce) private {
        // Error code 35: _markNonce, nonce cannot be zero
        require(_nonce != 0, "35");

        uint256 slotData = _nonce.div(256);
        uint256 shiftedBit = 1 << _nonce.mod(256);
        uint256 bits = usedNonces[slotData];

        // Error code 36: _markNonce, nonce has already been marked
        require(bits & shiftedBit == 0, "36");

        usedNonces[slotData] = bits | shiftedBit;
    }

    /// @dev Validates that the specified `_hash` was signed by the specified `_user`.
    /// This method supports the EIP712 specification, the older Ethereum
    /// signed message specification is also supported for backwards compatibility.
    /// @param _hash The original hash that was signed by the user
    /// @param _user The user who signed the hash
    /// @param _v The `v` component of the `_user`'s signature
    /// @param _r The `r` component of the `_user`'s signature
    /// @param _s The `s` component of the `_user`'s signature
    /// @param _prefixed If true, the signature will be verified
    /// against the Ethereum signed message specification instead of the
    /// EIP712 specification
    function _validateSignature(
        bytes32 _hash,
        address _user,
        uint8 _v,
        bytes32 _r,
        bytes32 _s,
        bool _prefixed
    )
        private
        pure
    {
        Utils.validateSignature(
            _hash,
            _user,
            _v,
            _r,
            _s,
            _prefixed
        );
    }

    /// @dev A utility method to increase the balance of a user.
    /// A corressponding `BalanceIncrease` event will also be emitted.
    /// @param _user The address to increase balance for
    /// @param _assetId The asset's contract address
    /// @param _amount The number of tokens to increase the balance by
    /// @param _reasonCode The reason code for the `BalanceIncrease` event
    /// @param _nonce The nonce for the `BalanceIncrease` event
    function _increaseBalance(
        address _user,
        address _assetId,
        uint256 _amount,
        uint256 _reasonCode,
        uint256 _nonce
    )
        private
    {
        if (_amount == 0) { return; }
        balances[_user][_assetId] = balances[_user][_assetId].add(_amount);

        emit BalanceIncrease(
            _user,
            _assetId,
            _amount,
            _reasonCode,
            _nonce
        );
    }

    /// @dev A utility method to decrease the balance of a user.
    /// A corressponding `BalanceDecrease` event will also be emitted.
    /// @param _user The address to decrease balance for
    /// @param _assetId The asset's contract address
    /// @param _amount The number of tokens to decrease the balance by
    /// @param _reasonCode The reason code for the `BalanceDecrease` event
    /// @param _nonce The nonce for the `BalanceDecrease` event
    function _decreaseBalance(
        address _user,
        address _assetId,
        uint256 _amount,
        uint256 _reasonCode,
        uint256 _nonce
    )
        private
    {
        if (_amount == 0) { return; }
        balances[_user][_assetId] = balances[_user][_assetId].sub(_amount);

        emit BalanceDecrease(
            _user,
            _assetId,
            _amount,
            _reasonCode,
            _nonce
        );
    }

    /// @dev Ensures that `_address` is not the zero address
    /// @param _address The address to check
    function _validateAddress(address _address) private pure {
        Utils.validateAddress(_address);
    }

    /// @dev A utility method to increase balances of multiple addresses.
    /// A corressponding `Increment` event will also be emitted.
    /// @param _increments An array of amounts to increase a user's balance by,
    /// the corresponding user and assetId is referenced by
    /// _addresses[index * 2] and _addresses[index * 2 + 1] respectively
    /// @param _addresses An array of user asset pairs in the form of:
    /// [
    ///     user_1_address,
    ///     asset_1_address,
    ///     user_1_address,
    ///     asset_2_address,
    ///     user_2_address,
    ///     asset_1_address,
    ///     ...
    /// ]
    /// @param _static Indicates if the amount was pre-calculated or only known
    /// at the time the transaction was executed
    function _incrementBalances(
        uint256[] memory _increments,
        address[] memory _addresses,
        uint256 _static
    )
        private
    {
        uint256 end = _increments.length;

        for(uint256 i = 0; i < end; i++) {
            uint256 increment = _increments[i];
            if (increment == 0) { continue; }

            balances[_addresses[i * 2]][_addresses[i * 2 + 1]] =
            balances[_addresses[i * 2]][_addresses[i * 2 + 1]].add(increment);

            emit Increment((i << 248) | (_static << 240) | increment);
        }
    }

    /// @dev A utility method to decrease balances of multiple addresses.
    /// A corressponding `Decrement` event will also be emitted.
    /// @param _decrements An array of amounts to decrease a user's balance by,
    /// the corresponding user and assetId is referenced by
    /// _addresses[index * 2] and _addresses[index * 2 + 1] respectively
    /// @param _addresses An array of user asset pairs in the form of:
    /// [
    ///     user_1_address,
    ///     asset_1_address,
    ///     user_1_address,
    ///     asset_2_address,
    ///     user_2_address,
    ///     asset_1_address,
    ///     ...
    /// ]
    function _decrementBalances(
        uint256[] memory _decrements,
        address[] memory _addresses
    )
        private
    {
        uint256 end = _decrements.length;
        for(uint256 i = 0; i < end; i++) {
            uint256 decrement = _decrements[i];
            if (decrement == 0) { continue; }

            balances[_addresses[i * 2]][_addresses[i * 2 + 1]] =
            balances[_addresses[i * 2]][_addresses[i * 2 + 1]].sub(decrement);

            emit Decrement(i << 248 | decrement);
        }
    }
}