// SPDX-License-Identifier: GNU-GPL v3.0 or later

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../interfaces/IAddressRegistry.sol";
import "../interfaces/IFNFTHandler.sol";

contract TokenVaultMigrator is Ownable, IAddressRegistry, IFNFTHandler {

    /// The active address registry
    address private provider;

    constructor(address _provider) Ownable() {
        provider = _provider;
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
    ) external override {}

    ///
    /// SETTERS
    ///

    function setAdmin(address admin) external override onlyOwner {}

    function setLockManager(address manager) external override onlyOwner {}

    function setTokenVault(address vault) external override onlyOwner {}
   
    function setRevest(address revest) external override onlyOwner {}

    function setRevestFNFT(address fnft) external override onlyOwner {}

    function setMetadataHandler(address metadata) external override onlyOwner {}

    function setDex(address dex) external override onlyOwner {}

    function setRevestToken(address token) external override onlyOwner {}

    function setRewardsHandler(address esc) external override onlyOwner {}

    function setLPs(address liquidToken) external override onlyOwner {}

    function setProvider(address _provider) external onlyOwner {
        provider = _provider;
    }

    ///
    /// GETTERS
    ///

    function getAdmin() external view override returns (address) {
        return IAddressRegistry(provider).getAdmin();
    }

    function getLockManager() external view override returns (address) {
        return IAddressRegistry(provider).getLockManager();
    }

    function getTokenVault() external view override returns (address) {
        return IAddressRegistry(provider).getTokenVault();
    }

    // Fools the old TokenVault into believing the new token vault can control it
    function getRevest() external view override returns (address) {
        return IAddressRegistry(provider).getTokenVault();
    }

    /// Fools the old TokenVault into believeing this contract is the FNFTHandler
    function getRevestFNFT() external view override returns (address) {
        return address(this);
    }

    function getMetadataHandler() external view override returns (address) {
        return IAddressRegistry(provider).getMetadataHandler();
    }

    function getRevestToken() external view override returns (address) {
        return IAddressRegistry(provider).getRevestToken();
    }

    function getDEX(uint index) external view override returns (address) {
        return IAddressRegistry(provider).getDEX(index);
    }

    function getRewardsHandler() external view override returns(address) {
        return IAddressRegistry(provider).getRewardsHandler();
    }

    function getLPs() external view override returns (address) {
        return IAddressRegistry(provider).getLPs();
    }

    function getAddress(bytes32 id) public view override returns (address) {
        return IAddressRegistry(provider).getAddress(id);
    }


    ///
    /// FNFTHandler mock methods
    ///

    function mint(address account, uint id, uint amount, bytes memory data) external override {}

    function mintBatchRec(address[] memory recipients, uint[] memory quantities, uint id, uint newSupply, bytes memory data) external override {}

    function mintBatch(address to, uint[] memory ids, uint[] memory amounts, bytes memory data) external override {}

    function setURI(string memory newuri) external override {}

    function burn(address account, uint id, uint amount) external override {}

    function burnBatch(address account, uint[] memory ids, uint[] memory amounts) external override {}

    function getBalance(address tokenHolder, uint id) external view override returns (uint) {
        return IFNFTHandler(IAddressRegistry(provider).getRevestFNFT()).getBalance(tokenHolder, id);
    }

    function getSupply(uint fnftId) external view override returns (uint supply) {
        supply = IFNFTHandler(IAddressRegistry(provider).getRevestFNFT()).getSupply(fnftId);
        supply = supply == 0 ? 1 : supply;
    }

    function getNextId() external view override returns (uint nextId) {
        nextId = IFNFTHandler(IAddressRegistry(provider).getRevestFNFT()).getNextId();
    }

}
