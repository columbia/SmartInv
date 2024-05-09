interface IERC165Upgradeable {
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

interface IERC721Upgradeable is IERC165Upgradeable {
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
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;

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
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

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
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

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
    function setApprovalForAll(address operator, bool _approved) external;

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


interface IERC4906Upgradeable is IERC165Upgradeable, IERC721Upgradeable {
    /// @dev This event emits when the metadata of a token is changed.
    /// So that the third-party platforms such as NFT market could
    /// timely update the images and related attributes of the NFT.
    event MetadataUpdate(uint256 _tokenId);

    /// @dev This event emits when the metadata of a range of tokens is changed.
    /// So that the third-party platforms such as NFT market could
    /// timely update the images and related attributes of the NFTs.
    event BatchMetadataUpdate(uint256 _fromTokenId, uint256 _toTokenId);
}

interface IRenovaItemBase is IERC4906Upgradeable {
    /// @notice Emitted when an item is minted.
    /// @param player The player who owns the item.
    /// @param tokenId The token ID.
    /// @param hashverseItemId The Hashverse Item ID.
    event Mint(
        address indexed player,
        uint256 tokenId,
        uint256 hashverseItemId
    );

    /// @notice Emitted when the Custom Metadata URI is updated.
    /// @param uri The new URI.
    event UpdateCustomURI(string uri);

    /// @notice Emitted when an item is bridged out of the current chain.
    /// @param player The player.
    /// @param tokenId The Token ID.
    /// @param hashverseItemId The Hashverse Item ID.
    /// @param dstWormholeChainId The Wormhole Chain ID of the chain the item is being bridged to.
    /// @param sequence The Wormhole sequence number.
    event XChainBridgeOut(
        address indexed player,
        uint256 tokenId,
        uint256 hashverseItemId,
        uint16 dstWormholeChainId,
        uint256 sequence,
        uint256 relayerFee
    );

    /// @notice Emitted when an item was bridged into the current chain.
    /// @param player The player.
    /// @param tokenId The Token ID.
    /// @param hashverseItemId The Hashverse Item ID.
    /// @param srcWormholeChainId The Wormhole Chain ID of the chain the item is being bridged from.
    event XChainBridgeIn(
        address indexed player,
        uint256 tokenId,
        uint256 hashverseItemId,
        uint16 srcWormholeChainId
    );

    /// @notice Bridges an item into the chain via Wormhole.
    /// @param vaa The Wormhole VAA.
    function wormholeBridgeIn(bytes memory vaa) external;

    /// @notice Bridges an item out of the chain via Wormhole.
    /// @param tokenId The Token ID.
    /// @param dstWormholeChainId The Wormhole Chain ID of the chain the item is being bridged to.
    function wormholeBridgeOut(
        uint256 tokenId,
        uint16 dstWormholeChainId,
        uint256 wormholeMessageFee
    ) external payable;

    /// @notice Sets the default royalty for the Item collection.
    /// @param receiver The receiver of royalties.
    /// @param feeNumerator The numerator of the fraction denoting the royalty percentage.
    function setDefaultRoyalty(address receiver, uint96 feeNumerator) external;

    /// @notice Sets a custom base URI for the token metadata.
    /// @param customBaseURI The new Custom URI.
    function setCustomBaseURI(string memory customBaseURI) external;

    /// @notice Emits a refresh metadata event for a token.
    /// @param tokenId The ID of the token.
    function refreshMetadata(uint256 tokenId) external;

    /// @notice Emits a refresh metadata event for all tokens.
    function refreshAllMetadata() external;
}

interface IRenovaItem is IRenovaItemBase {
    /// @notice Emitted when the authorization status of a minter changes.
    /// @param minter The minter for which the status was updated.
    /// @param status The new status.
    event UpdateMinterAuthorization(address minter, bool status);

    /// @notice Initializer function.
    /// @param minter The initial authorized minter.
    /// @param wormhole The Wormhole Endpoint address. See {IWormholeBaseUpgradeable}.
    /// @param wormholeConsistencyLevel The Wormhole Consistency Level. See {IWormholeBaseUpgradeable}.
    function initialize(
        address minter,
        address wormhole,
        uint8 wormholeConsistencyLevel
    ) external;

    /// @notice Mints an item.
    /// @param tokenOwner The owner of the item.
    /// @param hashverseItemId The Hashverse Item ID.
    function mint(address tokenOwner, uint256 hashverseItemId) external;

    /// @notice Updates the authorization status of a minter.
    /// @param minter The minter to update the authorization status for.
    /// @param status The new status.
    function updateMinterAuthorization(address minter, bool status) external;
}

library MerkleProof {
    /**
     * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
     * defined by `root`. For this, a `proof` must be provided, containing
     * sibling hashes on the branch from the leaf to the root of the tree. Each
     * pair of leaves and each pair of pre-images are assumed to be sorted.
     */
    function verify(
        bytes32[] memory proof,
        bytes32 root,
        bytes32 leaf
    ) internal pure returns (bool) {
        return processProof(proof, leaf) == root;
    }

    /**
     * @dev Calldata version of {verify}
     *
     * _Available since v4.7._
     */
    function verifyCalldata(
        bytes32[] calldata proof,
        bytes32 root,
        bytes32 leaf
    ) internal pure returns (bool) {
        return processProofCalldata(proof, leaf) == root;
    }

    /**
     * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
     * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
     * hash matches the root of the tree. When processing the proof, the pairs
     * of leafs & pre-images are assumed to be sorted.
     *
     * _Available since v4.4._
     */
    function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
        bytes32 computedHash = leaf;
        for (uint256 i = 0; i < proof.length; i++) {
            computedHash = _hashPair(computedHash, proof[i]);
        }
        return computedHash;
    }

    /**
     * @dev Calldata version of {processProof}
     *
     * _Available since v4.7._
     */
    function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
        bytes32 computedHash = leaf;
        for (uint256 i = 0; i < proof.length; i++) {
            computedHash = _hashPair(computedHash, proof[i]);
        }
        return computedHash;
    }

    /**
     * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
     * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
     *
     * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
     *
     * _Available since v4.7._
     */
    function multiProofVerify(
        bytes32[] memory proof,
        bool[] memory proofFlags,
        bytes32 root,
        bytes32[] memory leaves
    ) internal pure returns (bool) {
        return processMultiProof(proof, proofFlags, leaves) == root;
    }

    /**
     * @dev Calldata version of {multiProofVerify}
     *
     * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
     *
     * _Available since v4.7._
     */
    function multiProofVerifyCalldata(
        bytes32[] calldata proof,
        bool[] calldata proofFlags,
        bytes32 root,
        bytes32[] memory leaves
    ) internal pure returns (bool) {
        return processMultiProofCalldata(proof, proofFlags, leaves) == root;
    }

    /**
     * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
     * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
     * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
     * respectively.
     *
     * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
     * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
     * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
     *
     * _Available since v4.7._
     */
    function processMultiProof(
        bytes32[] memory proof,
        bool[] memory proofFlags,
        bytes32[] memory leaves
    ) internal pure returns (bytes32 merkleRoot) {
        // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
        // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
        // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
        // the merkle tree.
        uint256 leavesLen = leaves.length;
        uint256 totalHashes = proofFlags.length;

        // Check proof validity.
        require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");

        // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
        // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
        bytes32[] memory hashes = new bytes32[](totalHashes);
        uint256 leafPos = 0;
        uint256 hashPos = 0;
        uint256 proofPos = 0;
        // At each step, we compute the next hash using two values:
        // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
        //   get the next hash.
        // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
        //   `proof` array.
        for (uint256 i = 0; i < totalHashes; i++) {
            bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
            bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
            hashes[i] = _hashPair(a, b);
        }

        if (totalHashes > 0) {
            return hashes[totalHashes - 1];
        } else if (leavesLen > 0) {
            return leaves[0];
        } else {
            return proof[0];
        }
    }

    /**
     * @dev Calldata version of {processMultiProof}.
     *
     * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
     *
     * _Available since v4.7._
     */
    function processMultiProofCalldata(
        bytes32[] calldata proof,
        bool[] calldata proofFlags,
        bytes32[] memory leaves
    ) internal pure returns (bytes32 merkleRoot) {
        // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
        // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
        // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
        // the merkle tree.
        uint256 leavesLen = leaves.length;
        uint256 totalHashes = proofFlags.length;

        // Check proof validity.
        require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");

        // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
        // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
        bytes32[] memory hashes = new bytes32[](totalHashes);
        uint256 leafPos = 0;
        uint256 hashPos = 0;
        uint256 proofPos = 0;
        // At each step, we compute the next hash using two values:
        // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
        //   get the next hash.
        // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
        //   `proof` array.
        for (uint256 i = 0; i < totalHashes; i++) {
            bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
            bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
            hashes[i] = _hashPair(a, b);
        }

        if (totalHashes > 0) {
            return hashes[totalHashes - 1];
        } else if (leavesLen > 0) {
            return leaves[0];
        } else {
            return proof[0];
        }
    }

    function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
        return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
    }

    function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
        /// @solidity memory-safe-assembly
        assembly {
            mstore(0x00, a)
            mstore(0x20, b)
            value := keccak256(0x00, 0x40)
        }
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

contract MEMint is Context {
    bytes32 private _preAllocatedMerkleRoot;
    bytes32 private _publicMerkleRoot;

    address private _renovaItem;
    mapping(address => bool) _minted;

    uint256 private _maxPublicMints;
    uint256 private _numPublicMints;

    uint256 public totalMinted;

    event Mint(address player);

    constructor(
        bytes32 preAllocatedMerkleRoot,
        bytes32 publicMerkleRoot,
        address renovaItem,
        uint256 maxPublicMints
    ) {
        require(
            preAllocatedMerkleRoot != bytes32(0),
            'MEMint::constructor Pre-allocated Merkle Root cannot be 0.'
        );
        require(
            publicMerkleRoot != bytes32(0),
            'MEMint::constructor Public Merkle Root cannot be 0.'
        );
        require(
            renovaItem != address(0),
            'MEMint::constructor RenovaItem cannot be 0.'
        );

        _preAllocatedMerkleRoot = preAllocatedMerkleRoot;
        _publicMerkleRoot = publicMerkleRoot;

        _renovaItem = renovaItem;

        _maxPublicMints = maxPublicMints;
        _numPublicMints = 0;
    }

    function mint(
        uint256[] calldata hashverseItemIds,
        bytes32[] calldata proof
    ) external {
        require(!_minted[_msgSender()], 'MEMint::mint Already minted.');

        bytes32 leaf = keccak256(
            abi.encodePacked(_msgSender(), hashverseItemIds)
        );

        if (!MerkleProof.verifyCalldata(proof, _preAllocatedMerkleRoot, leaf)) {
            if (!MerkleProof.verifyCalldata(proof, _publicMerkleRoot, leaf)) {
                revert('MEMint::mint Proof invalid.');
            } else {
                require(
                    _numPublicMints < _maxPublicMints,
                    'MEMint::mint Mint limit reached.'
                );
                _numPublicMints++;
                totalMinted++;
            }
        }

        _minted[_msgSender()] = true;

        emit Mint(_msgSender());

        for (uint256 i = 0; i < hashverseItemIds.length; i++) {
            IRenovaItem(_renovaItem).mint(_msgSender(), hashverseItemIds[i]);
        }
    }
}