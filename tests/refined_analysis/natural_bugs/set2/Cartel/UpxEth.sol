// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/presets/ERC1155PresetMinterPauser.sol)

pragma solidity 0.8.19;

import {ERC1155} from "solmate/tokens/ERC1155.sol";
import {AccessControlDefaultAdminRules} from "openzeppelin-contracts/contracts/access/AccessControlDefaultAdminRules.sol";

/**
 * @title UpxEth
 * @notice Semi Fungible token contract used as an IOU by user 
 * @dev ERC1155 token contract with minting and burning capabilities, using AccessControl for role-based access.
 *
 * UpxEth contract includes:
 * - Total supply tracking for each token ID
 * - Token burning functionality for holders
 * - Minter role for token creation
 *
 * The contract deploys with the default admin role, allowing it to grant minter and burner roles to other accounts.
 * The contract uses AccessControl for role-based access control.
 *
 * Deprecated in favor of [Contracts Wizard](https://wizard.openzeppelin.com/).
 * @author redactedcartel.finance
 */
contract UpxEth is AccessControlDefaultAdminRules, ERC1155 {
    /**
     * @dev Bytes32 constant representing the role to mint new tokens.
     */
    bytes32 internal constant MINTER_ROLE = keccak256("MINTER_ROLE");

    /**
     * @dev Bytes32 constant representing the role to burn (destroy) tokens.
     */
    bytes32 internal constant BURNER_ROLE = keccak256("BURNER_ROLE");

    /**
     * @dev Constructor to initialize the UpxEth contract.
     * @param _initialDelay uint48 Initial delay for AccessControl's admin lock, set by the contract deployer.
     */
    constructor(
        uint48 _initialDelay
    ) AccessControlDefaultAdminRules(_initialDelay, msg.sender) {}

    /**
     * @notice Mints new tokens for a specific address.
     * @dev Restricted to accounts with the MINTER_ROLE.
     * @param to     address Address to receive the minted tokens.
     * @param id     uint256 Token ID to mint.
     * @param amount uint256 Amount of tokens to mint.
     * @param data   bytes   Additional data to include in the minting transaction.
     */
    function mint(
        address to,
        uint256 id,
        uint256 amount,
        bytes calldata data
    ) external onlyRole(MINTER_ROLE) {
        _mint(to, id, amount, data);
    }

    /**
     * @notice Mints a batch of new tokens for a specific address.
     * @dev Restricted to accounts with the MINTER_ROLE.
     * @param to      address   Address to receive the minted tokens.
     * @param ids     uint256[] Array of token IDs to mint.
     * @param amounts uint256[] Array of amounts of tokens to mint.
     * @param data    bytes     Additional data to include in the minting transaction.
     */
    function mintBatch(
        address to,
        uint256[] calldata ids,
        uint256[] calldata amounts,
        bytes calldata data
    ) external onlyRole(MINTER_ROLE) {
        _batchMint(to, ids, amounts, data);
    }

    /**
     * @notice Burns a batch of tokens from a specific address.
     * @dev Restricted to accounts with the BURNER_ROLE.
     * @param from    address   Address from which to burn tokens.
     * @param ids     uint256[] Array of token IDs to burn.
     * @param amounts uint256[] Array of amounts of tokens to burn.
     */
    function burnBatch(
        address from,
        uint256[] calldata ids,
        uint256[] calldata amounts
    ) external onlyRole(BURNER_ROLE) {
        _batchBurn(from, ids, amounts);
    }

    /**
     * @notice Burns a specific amount of tokens from a specific address.
     * @dev Restricted to accounts with the BURNER_ROLE.
     * @param from   address Address from which to burn tokens.
     * @param id     uint256 Token ID to burn.
     * @param amount uint256 Amount of tokens to burn.
     */
    function burn(
        address from,
        uint256 id,
        uint256 amount
    ) external onlyRole(BURNER_ROLE) {
        _burn(from, id, amount);
    }

    /**
     * @inheritdoc ERC1155
     * @dev Not implemented due to semi-fungible only requirement
     */
    function uri(uint256 id) public view override returns (string memory) {}

    /**
     * @inheritdoc ERC1155
     */
    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        override(AccessControlDefaultAdminRules, ERC1155)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
