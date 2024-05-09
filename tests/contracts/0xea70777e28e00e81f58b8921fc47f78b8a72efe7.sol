pragma solidity 0.5.12;

/**
 * @title Roles
 * @dev Library for managing addresses assigned to a Role.
 */
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

/**
 * @title WhitelistAdminRole
 * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
 */
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

/**
 * @title WhitelistedRole
 * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a
 * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove
 * it), and not Whitelisteds themselves.
 */
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

/**
 * @title BulkWhitelistedRole
 * @dev a Whitelist role defined using the Open Zeppelin Role system with the addition of bulkAddWhitelisted and
 * bulkRemoveWhitelisted.
 * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a
 * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove
 * it), and not Whitelisteds themselves.
 */
contract BulkWhitelistedRole is WhitelistedRole {

    function bulkAddWhitelisted(address[] memory accounts) public onlyWhitelistAdmin {
        for (uint256 index = 0; index < accounts.length; index++) {
            _addWhitelisted(accounts[index]);
        }
    }

    function bulkRemoveWhitelisted(address[] memory accounts) public onlyWhitelistAdmin {
        for (uint256 index = 0; index < accounts.length; index++) {
            _removeWhitelisted(accounts[index]);
        }
    }

}

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * [EIP](https://eips.ethereum.org/EIPS/eip-165).
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others (`ERC165Checker`).
 *
 * For an implementation, see `ERC165`.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

/**
 * @dev Required interface of an ERC721 compliant contract.
 */
contract IERC721 is IERC165 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of NFTs in `owner`'s account.
     */
    function balanceOf(address owner) public view returns (uint256 balance);

    /**
     * @dev Returns the owner of the NFT specified by `tokenId`.
     */
    function ownerOf(uint256 tokenId) public view returns (address owner);

    /**
     * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
     * another (`to`).
     *
     * 
     *
     * Requirements:
     * - `from`, `to` cannot be zero.
     * - `tokenId` must be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this
     * NFT by either `approve` or `setApproveForAll`.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) public;
    /**
     * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
     * another (`to`).
     *
     * Requirements:
     * - If the caller is not `from`, it must be approved to move this NFT by
     * either `approve` or `setApproveForAll`.
     */
    function transferFrom(address from, address to, uint256 tokenId) public;
    function approve(address to, uint256 tokenId) public;
    function getApproved(uint256 tokenId) public view returns (address operator);

    function setApprovalForAll(address operator, bool _approved) public;
    function isApprovedForAll(address owner, address operator) public view returns (bool);


    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
}

/**
 * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 */
contract IERC721Metadata is IERC721 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function tokenURI(uint256 tokenId) external view returns (string memory);
}

contract IRegistry is IERC721Metadata {

    event NewURI(uint256 indexed tokenId, string uri);

    event NewURIPrefix(string prefix);

    event Resolve(uint256 indexed tokenId, address indexed to);

    event Sync(address indexed resolver, uint256 indexed updateId, uint256 indexed tokenId);

    /**
     * @dev Controlled function to set the token URI Prefix for all tokens.
     * @param prefix string URI to assign
     */
    function controlledSetTokenURIPrefix(string calldata prefix) external;

    /**
     * @dev Returns whether the given spender can transfer a given token ID.
     * @param spender address of the spender to query
     * @param tokenId uint256 ID of the token to be transferred
     * @return bool whether the msg.sender is approved for the given token ID,
     * is an operator of the owner, or is the owner of the token
     */
    function isApprovedOrOwner(address spender, uint256 tokenId) external view returns (bool);

    /**
     * @dev Mints a new a child token.
     * Calculates child token ID using a namehash function.
     * Requires the msg.sender to be the owner, approved, or operator of tokenId.
     * Requires the token not exist.
     * @param to address to receive the ownership of the given token ID
     * @param tokenId uint256 ID of the parent token
     * @param label subdomain label of the child token ID
     */
    function mintChild(address to, uint256 tokenId, string calldata label) external;

    /**
     * @dev Controlled function to mint a given token ID.
     * Requires the msg.sender to be controller.
     * Requires the token ID to not exist.
     * @param to address the given token ID will be minted to
     * @param label string that is a subdomain
     * @param tokenId uint256 ID of the parent token
     */
    function controlledMintChild(address to, uint256 tokenId, string calldata label) external;

    /**
     * @dev Transfers the ownership of a child token ID to another address.
     * Calculates child token ID using a namehash function.
     * Requires the msg.sender to be the owner, approved, or operator of tokenId.
     * Requires the token already exist.
     * @param from current owner of the token
     * @param to address to receive the ownership of the given token ID
     * @param tokenId uint256 ID of the token to be transferred
     * @param label subdomain label of the child token ID
     */
    function transferFromChild(address from, address to, uint256 tokenId, string calldata label) external;

    /**
     * @dev Controlled function to transfers the ownership of a token ID to
     * another address.
     * Requires the msg.sender to be controller.
     * Requires the token already exist.
     * @param from current owner of the token
     * @param to address to receive the ownership of the given token ID
     * @param tokenId uint256 ID of the token to be transferred
     */
    function controlledTransferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Safely transfers the ownership of a child token ID to another address.
     * Calculates child token ID using a namehash function.
     * Implements a ERC721Reciever check unlike transferFromChild.
     * Requires the msg.sender to be the owner, approved, or operator of tokenId.
     * Requires the token already exist.
     * @param from current owner of the token
     * @param to address to receive the ownership of the given token ID
     * @param tokenId uint256 parent ID of the token to be transferred
     * @param label subdomain label of the child token ID
     * @param _data bytes data to send along with a safe transfer check
     */
    function safeTransferFromChild(address from, address to, uint256 tokenId, string calldata label, bytes calldata _data) external;

    /// Shorthand for calling the above ^^^ safeTransferFromChild function with an empty _data parameter. Similar to ERC721.safeTransferFrom.
    function safeTransferFromChild(address from, address to, uint256 tokenId, string calldata label) external;

    /**
     * @dev Controlled frunction to safely transfers the ownership of a token ID
     * to another address.
     * Implements a ERC721Reciever check unlike controlledSafeTransferFrom.
     * Requires the msg.sender to be controller.
     * Requires the token already exist.
     * @param from current owner of the token
     * @param to address to receive the ownership of the given token ID
     * @param tokenId uint256 parent ID of the token to be transferred
     * @param _data bytes data to send along with a safe transfer check
     */
    function controlledSafeTransferFrom(address from, address to, uint256 tokenId, bytes calldata _data) external;

    /**
     * @dev Burns a child token ID.
     * Calculates child token ID using a namehash function.
     * Requires the msg.sender to be the owner, approved, or operator of tokenId.
     * Requires the token already exist.
     * @param tokenId uint256 ID of the token to be transferred
     * @param label subdomain label of the child token ID
     */
    function burnChild(uint256 tokenId, string calldata label) external;

    /**
     * @dev Controlled function to burn a given token ID.
     * Requires the msg.sender to be controller.
     * Requires the token already exist.
     * @param tokenId uint256 ID of the token to be burned
     */
    function controlledBurn(uint256 tokenId) external;

    /**
     * @dev Sets the resolver of a given token ID to another address.
     * Requires the msg.sender to be the owner, approved, or operator.
     * @param to address the given token ID will resolve to
     * @param tokenId uint256 ID of the token to be transferred
     */
    function resolveTo(address to, uint256 tokenId) external;

    /**
     * @dev Gets the resolver of the specified token ID.
     * @param tokenId uint256 ID of the token to query the resolver of
     * @return address currently marked as the resolver of the given token ID
     */
    function resolverOf(uint256 tokenId) external view returns (address);

    /**
     * @dev Controlled function to sets the resolver of a given token ID.
     * Requires the msg.sender to be controller.
     * @param to address the given token ID will resolve to
     * @param tokenId uint256 ID of the token to be transferred
     */
    function controlledResolveTo(address to, uint256 tokenId) external;

    /**
     * @dev Provides child token (subdomain) of provided tokenId.
     * @param tokenId uint256 ID of the token
     * @param label label of subdomain (for `aaa.bbb.crypto` it will be `aaa`)
     */
    function childIdOf(uint256 tokenId, string calldata label) external pure returns (uint256);

    /**
     * @dev Transfer domain ownership without resetting domain records.
     * @param to address of new domain owner
     * @param tokenId uint256 ID of the token to be transferred
     */
    function setOwner(address to, uint256 tokenId) external;
}

pragma experimental ABIEncoderV2;




contract IResolver {
    function reconfigure(string[] memory keys, string[] memory values, uint256 tokenId) public;
    function setMany(string[] memory keys, string[] memory values, uint256 tokenId) public;
}

contract DomainZoneController is BulkWhitelistedRole {

    event MintChild(uint256 indexed tokenId, uint256 indexed parentTokenId, string label);

    IRegistry internal _registry;

    constructor (IRegistry registry, address[] memory accounts) public {
        _registry = registry;
        for (uint256 index = 0; index < accounts.length; index++) {
            _addWhitelisted(accounts[index]);
        }
    }

    function mintChild(address to, uint256 tokenId, string memory label, string[] memory keys, string[] memory values) public onlyWhitelisted {
        address resolver = _registry.resolverOf(tokenId);
        uint256 childTokenId = _registry.childIdOf(tokenId, label);
        if (keys.length > 0) {
            _registry.mintChild(address(this), tokenId, label);
            _registry.resolveTo(resolver, childTokenId);
            IResolver(resolver).reconfigure(keys, values, childTokenId);
            _registry.setOwner(to, childTokenId);
        } else {
            _registry.mintChild(to, tokenId, label);
        }

        emit MintChild(childTokenId, tokenId, label);
    }

    function resolveTo(address to, uint256 tokenId) external onlyWhitelisted {
        _registry.resolveTo(to, tokenId);
    }

    function setMany(string[] memory keys, string[] memory values, uint256 tokenId) public onlyWhitelisted {
        address resolver = _registry.resolverOf(tokenId);
        IResolver(resolver).setMany(keys, values, tokenId);
    }
}