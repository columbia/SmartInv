pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

/**
 * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
 *
 * These functions can be used to verify that a message was signed by the holder
 * of the private keys of a given address.
 */
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


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
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
        return msg.sender == _owner;
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
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract CampaignBank is Ownable {
    using ECDSA for bytes32;

    mapping(address => bool) public trustedSigner;
    mapping(bytes32 => bool) public alreadySent;

    event RegisteredSigner(
        address indexed sender,
        address indexed signer,
        uint256 indexed date
    );
    event RemovedSigner(
        address indexed sender,
        address indexed signer,
        uint256 indexed date
    );
    event Rewarded(
        address indexed targetContract,
        bytes32 indexed hashedSig,
        bytes payload,
        uint256 signedTimestamp,
        bytes signature,
        address sender
    );

    constructor() public Ownable() {}

    function registerTrustedSigner(address target, bool allowed)
        public
        onlyOwner
    {
        if (allowed && !trustedSigner[target]) {
            trustedSigner[target] = true;
            emit RegisteredSigner(msg.sender, target, block.timestamp);
        } else if (!allowed && trustedSigner[target]) {
            trustedSigner[target] = false;
            emit RemovedSigner(msg.sender, target, block.timestamp);
        }
    }

    event TransactionRelayed(
        address indexed sender,
        address indexed targetContract,
        bytes payload,
        uint256 value,
        bytes signature
    );

    function claimManyRewards(
        address[] memory targetContract,
        bytes[] memory payload,
        uint256[] memory expirationTimestamp,
        bytes[] memory signature
    ) public {
        require(
            targetContract.length == payload.length,
            "Arrays should be of the same size"
        );
        require(
            targetContract.length == expirationTimestamp.length,
            "Arrays should be of the same size"
        );
        require(
            targetContract.length == signature.length,
            "Arrays should be of the same size"
        );
        uint256 length = targetContract.length;

        for (uint256 i = 0; i < length; i++) {
            if (
                !claimReward(
                    targetContract[i],
                    payload[i],
                    expirationTimestamp[i],
                    signature[i]
                )
            ) {
                revert("Transaction failed");
            }
        }
    }

    function claimReward(
        address targetContract,
        bytes memory payload,
        uint256 expirationTimestamp,
        bytes memory signature
    ) public returns (bool) {
        require(block.timestamp < expirationTimestamp, "Signature too old");

        bytes memory blob = abi.encode(
            targetContract,
            payload,
            expirationTimestamp
        );
        bytes32 signed = keccak256(blob);
        bytes32 verify = signed.toEthSignedMessageHash();
        require(!alreadySent[signed], "Already sent!");

        require(
            trustedSigner[verify.recover(signature)],
            "Invalid signature provided"
        );

        alreadySent[signed] = true;

        bool result;
        (result,) = targetContract.call(payload);
        if (!result) {
            revert("Failed call");
        }

        emit Rewarded(
            targetContract,
            signed,
            payload,
            expirationTimestamp,
            signature,
            msg.sender
        );

        return true;
    }

    function halt() public onlyOwner {
        selfdestruct(address(uint256(owner())));
    }
}