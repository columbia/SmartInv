// SPDX-License-Identifier: GNU-GPL v3.0 or later

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "./interfaces/IAddressRegistryV2.sol";
import "./RevestToken.sol";

contract RevestAddressRegistry is Ownable, IAddressRegistryV2, AccessControl {
    bytes32 public constant ADMIN = "ADMIN";
    bytes32 public constant LOCK_MANAGER = "LOCK_MANAGER";
    bytes32 public constant REVEST_TOKEN = "REVEST_TOKEN";
    bytes32 public constant TOKEN_VAULT = "TOKEN_VAULT";
    bytes32 public constant REVEST = "REVEST";
    bytes32 public constant FNFT = "FNFT";
    bytes32 public constant METADATA = "METADATA";
    bytes32 public constant ESCROW = 'ESCROW';
    bytes32 public constant LIQUIDITY_TOKENS = "LIQUIDITY_TOKENS";
    bytes32 public constant BREAKER = 'BREAKER';    
    bytes32 public constant PAUSER = 'PAUSER';
    bytes32 public constant LEGACY_VAULT = 'LEGACY_VAULT';

    uint public next_dex = 0;

    mapping(bytes32 => address) public _addresses;
    mapping(uint => address) public _dex;


    constructor() Ownable() {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    // Set up all addresses for the registry.
    function initialize_with_legacy(
        address lock_manager_,
        address liquidity_,
        address revest_token_,
        address token_vault_,
        address legacy_vault_,
        address revest_,
        address fnft_,
        address metadata_,
        address admin_,
        address rewards_
    ) external override onlyOwner {
        _addresses[ADMIN] = admin_;
        _addresses[LOCK_MANAGER] = lock_manager_;
        _addresses[REVEST_TOKEN] = revest_token_;
        _addresses[TOKEN_VAULT] = token_vault_;
        _addresses[LEGACY_VAULT] = legacy_vault_;
        _addresses[REVEST] = revest_;
        _addresses[FNFT] = fnft_;
        _addresses[METADATA] = metadata_;
        _addresses[LIQUIDITY_TOKENS] = liquidity_;
        _addresses[ESCROW]=rewards_;
    }

    function initialize(
        address lock_manager_,
        address liquidity_,
        address revest_token_,
        address token_vault_,
        address revest_,
        address fnft_,
        address metadata_,
        address admin_,
        address rewards_
    ) external override onlyOwner {
        _addresses[ADMIN] = admin_;
        _addresses[LOCK_MANAGER] = lock_manager_;
        _addresses[REVEST_TOKEN] = revest_token_;
        _addresses[TOKEN_VAULT] = token_vault_;
        _addresses[REVEST] = revest_;
        _addresses[FNFT] = fnft_;
        _addresses[METADATA] = metadata_;
        _addresses[LIQUIDITY_TOKENS] = liquidity_;
        _addresses[ESCROW]=rewards_;
    }

    ///
    /// EMERGENCY FUNCTIONS
    ///

    /// This function breaks the Revest Protocol, temporarily
    /// For use in emergency situations to offline deposits and withdrawals
    /// While making all value stored within totally inaccessible 
    /// Only requires one person to 'throw the switch' to disable entire protocol
    function breakGlass() external override {
        require(hasRole(BREAKER, _msgSender()), 'E042');
        _addresses[REVEST] = address(0x000000000000000000000000000000000000dEaD);
    }

    /// This method will allow the token to paused once this contract is granted the pauser role
    /// Only requires one person to 'throw the switch'
    function pauseToken() external override {
        require(hasRole(PAUSER, _msgSender()), 'E043');
        //TODO: Implement in interface form
        RevestToken(_addresses[REVEST_TOKEN]).pause();
    }

    /// Unpauses the token when the danger has passed
    /// Requires multisig governance system to agree to unpause
    function unpauseToken() external override onlyOwner {
        //TODO: Implement in interface form
        RevestToken(_addresses[REVEST_TOKEN]).unpause();
    }
    
    /// Admin function for adding or removing breakers
    function modifyBreaker(address breaker, bool grant) external override onlyOwner {
        if(grant) {
            // Add to list
            grantRole(BREAKER, breaker);
        } else {
            // Remove from list
            revokeRole(BREAKER, breaker);
        }
    }

    /// Admin function for adding or removing pausers
    function modifyPauser(address pauser, bool grant) external override onlyOwner {
        if(grant) {
            // Add to list
            grantRole(PAUSER, pauser);
        } else {
            // Remove from list
            revokeRole(PAUSER, pauser);
        }
    }


    ///
    /// SETTERS
    ///

    function setAdmin(address admin) external override onlyOwner {
        _addresses[ADMIN] = admin;
    }

    function setLockManager(address manager) external override onlyOwner {
        _addresses[LOCK_MANAGER] = manager;
    }

    function setTokenVault(address vault) external override onlyOwner {
        _addresses[TOKEN_VAULT] = vault;
    }
   
    function setRevest(address revest) external override onlyOwner {
        _addresses[REVEST] = revest;
    }

    function setRevestFNFT(address fnft) external override onlyOwner {
        _addresses[FNFT] = fnft;
    }

    function setMetadataHandler(address metadata) external override onlyOwner {
        _addresses[METADATA] = metadata;
    }

    function setDex(address dex) external override onlyOwner {
        _dex[next_dex] = dex;
        next_dex = next_dex + 1;
    }

    function setRevestToken(address token) external override onlyOwner {
        _addresses[REVEST_TOKEN] = token;
    }

    function setRewardsHandler(address esc) external override onlyOwner {
        _addresses[ESCROW] = esc;
    }

    function setLPs(address liquidToken) external override onlyOwner {
        _addresses[LIQUIDITY_TOKENS] = liquidToken;
    }

    function setLegacyTokenVault(address legacyVault) external override onlyOwner {
        _addresses[LEGACY_VAULT] = legacyVault;
    }

    ///
    /// GETTERS
    ///

    function getAdmin() external view override returns (address) {
        return _addresses[ADMIN];
    }

    function getLockManager() external view override returns (address) {
        return getAddress(LOCK_MANAGER);
    }

    function getTokenVault() external view override returns (address) {
        return getAddress(TOKEN_VAULT);
    }

    function getLegacyTokenVault() external view override returns (address legacy) {
        legacy = getAddress(LEGACY_VAULT);
    }

    function getRevest() external view override returns (address) {
        return getAddress(REVEST);
    }

    function getRevestFNFT() external view override returns (address) {
        return _addresses[FNFT];
    }

    function getMetadataHandler() external view override returns (address) {
        return _addresses[METADATA];
    }

    function getRevestToken() external view override returns (address) {
        return _addresses[REVEST_TOKEN];
    }

    function getDEX(uint index) external view override returns (address) {
        return _dex[index];
    }

    function getRewardsHandler() external view override returns(address) {
        return _addresses[ESCROW];
    }

    function getLPs() external view override returns (address) {
        return _addresses[LIQUIDITY_TOKENS];
    }

    /**
     * @dev Returns an address by id
     * @return The address
     */
    function getAddress(bytes32 id) public view override returns (address) {
        return _addresses[id];
    }



}
