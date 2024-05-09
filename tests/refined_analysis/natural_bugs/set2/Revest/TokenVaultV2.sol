// SPDX-License-Identifier: GNU-GPL v3.0 or later

pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "./interfaces/ITokenVaultV2.sol";
import "./interfaces/ILockManager.sol";
import "./interfaces/IRevest.sol";
import "./interfaces/IOutputReceiver.sol";

import "./utils/RevestAccessControl.sol";
import "./RevestSmartWallet.sol";

import '@openzeppelin/contracts/utils/introspection/ERC165Checker.sol';
import "@openzeppelin/contracts/proxy/Clones.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";


/**
 * This vault knows nothing about ownership. Only what fnftIds correspond to what configs
 * and ensures that all FNFTs are backed by assets in the vault.
 */
contract TokenVaultV2 is ITokenVaultV2, Ownable, RevestAccessControl {
    using ERC165Checker for address;
    using SafeERC20 for IERC20;

    /// Address to use for EIP-1167 smart-wallet creation calls
    address public immutable TEMPLATE;

    /// Cutoff ID above which FNFTs are created from this contract
    uint public immutable FNFT_CUTOFF;

    /// Maps fnftIds to their respective configs
    mapping(uint => IRevest.FNFTConfig) private fnfts;

    /// Tracks migrations for updated staking contracts
    mapping(address => address) public migrations;

    /// Used for calculations
    uint private constant multiplierPrecision = 1 ether;

    /// The identifier for IOutputReceivers to return for use with ERC-165
    bytes4 public constant OUTPUT_RECEIVER_INTERFACE_ID = type(IOutputReceiver).interfaceId;


    constructor(
        address provider, 
        address[] memory oldOutputs, 
        address[] memory newOutputs
    ) RevestAccessControl(provider) {
        RevestSmartWallet wallet = new RevestSmartWallet();
        TEMPLATE = address(wallet);
        FNFT_CUTOFF = getFNFTHandler().getNextId() - 1;
        for(uint i = 0; i < oldOutputs.length; i++) {
            migrations[oldOutputs[i]] = newOutputs[i];
        }
    }

    /**
     * @notice Maps an fnftConfig object to a given FNFT ID
     * @param fnftId the FNFT ID to map the config to
     * @param fnftConfig the config to map to the ID
     * @param quantity the quantity to create
     * @param from the user generating this call
     * @dev this can only ever be called from Revest.sol during the minting process
     */
    function createFNFT(uint fnftId, IRevest.FNFTConfig memory fnftConfig, uint quantity, address from) external override onlyRevestController {
        mapFNFTToToken(fnftId, fnftConfig);
        if(fnftConfig.asset != address(0)) {
            emit DepositERC20(fnftConfig.asset, from, fnftId, fnftConfig.depositAmount * quantity, getFNFTAddress(fnftId));
        }
        emit CreateFNFT(fnftId, from);
    }

    /**
     * @notice allows for the withdrawal of unlocked FNFTs
     * @param fnftId the FNFT ID to withdraw from
     * @param quantity the number of FNFTs within that series to withdraw
     * @param user the user requesting the withdrawal of funds
     * @dev should only ever be called from Revest.sol
     */
    function withdrawToken(
        uint fnftId,
        uint quantity,
        address user
    ) external override onlyRevestController {
        // If the FNFT is an old one, this just assigns to zero-value
        IRevest.FNFTConfig memory fnft = fnfts[fnftId];
        address asset = fnft.asset;
        address pipeTo = fnft.pipeToContract;
        uint amountToWithdraw;

        uint supplyBefore = getFNFTHandler().getSupply(fnftId) + quantity;
        if(fnftId <= FNFT_CUTOFF) {
            // Uses the old TokenVault
            // Withdraw and remap
            // Begin by getting the FNFT Config from the old TokenVault
            address oldVault = addressesProvider.getLegacyTokenVault();

            fnft = ITokenVault(oldVault).getFNFT(fnftId);

            amountToWithdraw = quantity * fnft.depositAmount;
            // Update vars to reflect accurate state
            asset = fnft.asset;
            // Modify output receivers to forward underlying value to this contract
            if(fnft.pipeToContract != address(0)) {
                pipeTo = fnft.pipeToContract; // Store original output receiver destination
                fnft.pipeToContract = address(this);
                ITokenVault(oldVault).mapFNFTToToken(fnftId, fnft);

                // Handle any migrations needed from old to new staking contract
                if(migrations[pipeTo] != address(0)) {
                    pipeTo = migrations[pipeTo];
                }
            }
            // Call withdrawal method on old system
            ITokenVault(oldVault).withdrawToken(fnftId, quantity, user);
            // Very uncommon edge-case, no known system will use this, but need to cover regardless
            if(pipeTo != address(0) && supplyBefore - quantity != 0) {
                // If there are still instances, need to re-write to accurate OutputRec for future withdrawals 
                fnft.pipeToContract = pipeTo;
                ITokenVault(oldVault).mapFNFTToToken(fnftId, fnft);
            }

            // If value has been routed here, forward onto destination, then handle callback
            if(pipeTo != address(0) && asset != address(0)) {
                // NB: The user has control of where these external calls go
                amountToWithdraw = IERC20(asset).balanceOf(address(this)); 
                IERC20(asset).safeTransfer(pipeTo, amountToWithdraw);
            }

        } else {
            // Handle any migrations needed from old to new staking contract
            if(migrations[pipeTo] != address(0)) {
                pipeTo = migrations[pipeTo];
            }
            
            // Deploy the smart wallet object
            if(asset != address(0)) {
                // Real tokens, deploy smart-wallet
                address smartWallAdd = Clones.cloneDeterministic(TEMPLATE, keccak256(abi.encode(fnftId)));
                RevestSmartWallet wallet = RevestSmartWallet(smartWallAdd);
                // NB: The user has control of where this external call goes
                amountToWithdraw = quantity * IERC20(asset).balanceOf(smartWallAdd) / supplyBefore;
                if(pipeTo == address(0)) {
                    wallet.withdraw(amountToWithdraw, asset, user);
                } else {
                    wallet.withdraw(amountToWithdraw, asset, pipeTo);
                }
            } 
        }
        
        // Handle all callbacks from here, regardless of what system it was
        // NB: This makes an external call and could be used for reentrancy:
        //     all important systems on IOutputReceiver implementations should be
        //     marked as nonReentrant to ensure that exploitation is impossible
        //     or properly follow checks-effects-interactions
        if(pipeTo != address(0) && pipeTo.supportsInterface(OUTPUT_RECEIVER_INTERFACE_ID)) {
            IOutputReceiver(pipeTo).receiveRevestOutput(fnftId, asset, payable(user), quantity);
        }

        // Perform clean-up 
        if(supplyBefore - quantity == 0 && fnftId > FNFT_CUTOFF) {
            removeFNFT(fnftId);
        }
        emit RedeemFNFT(fnftId, user);
        if(asset != address(0) && amountToWithdraw > 0) {
            emit WithdrawERC20(asset, user, fnftId, amountToWithdraw, getFNFTAddress(fnftId));
        }
    }

    /**
     * @notice this function maps an FNFT config to an FNFT ID
     * @param fnftId the FNFT ID to map to
     * @param fnftConfig the config to map to that ID
     * @dev this should only ever be called from Revest.sol
     */
    function mapFNFTToToken(
        uint fnftId,
        IRevest.FNFTConfig memory fnftConfig
    ) public override onlyRevestController {
        // Gas optimizations
        fnfts[fnftId].asset =  fnftConfig.asset;
        // We don't specify depositAmount or depositMul, neither are necessary anymore
        if(fnftConfig.split > 0) {
            fnfts[fnftId].split = fnftConfig.split;
        }
        if(fnftConfig.maturityExtension) {
            fnfts[fnftId].maturityExtension = fnftConfig.maturityExtension;
        }
        if(fnftConfig.pipeToContract != address(0)) {
            fnfts[fnftId].pipeToContract = fnftConfig.pipeToContract;
        }
        if(fnftConfig.isMulti) {
            fnfts[fnftId].isMulti = fnftConfig.isMulti;
            fnfts[fnftId].depositStopTime = fnftConfig.depositStopTime;
        }
        if(fnftConfig.nontransferrable){
            fnfts[fnftId].nontransferrable = fnftConfig.nontransferrable;
        }
    }

    /**
     * @notice Emits an event when we have an additional deposit 
     * @param user the user who is making the deposit
     * @param fnftId the ID of the FNFT being deposited
     * @param tokenAmount the amount of tokens being deposited
     * @dev this should only ever be called from Revest.sol
     */
    function recordAdditionalDeposit(
        address user, 
        uint fnftId, 
        uint tokenAmount
    ) external override onlyRevestController {
        emit DepositERC20(fnfts[fnftId].asset, user, fnftId, tokenAmount, getFNFTAddress(fnftId));
    }

    ///
    /// Utility functions
    ///

    /// Internal function to remove FNFT configs
    function removeFNFT(uint fnftId) private {
        delete fnfts[fnftId];
    }

    /**
     * @notice Given an FNFT config, clones it and returns a deep copy
     * @param old an FNFT config to be cloned
     * @return a new FNFT config that is a deep copy of the passed-in parameter
     */
    function cloneFNFTConfig(IRevest.FNFTConfig memory old) public pure override returns (IRevest.FNFTConfig memory) {
        return IRevest.FNFTConfig({
            asset: old.asset,
            split: old.split,
            depositAmount:old.depositAmount,
            depositMul:old.depositMul,
            maturityExtension: old.maturityExtension,
            pipeToContract: old.pipeToContract,
            isMulti : old.isMulti,
            depositStopTime: old.depositStopTime,
            nontransferrable: old.nontransferrable
        });
    }

    ///
    /// Getters
    ///

    /**
     * @notice gets the current face-value of an FNFT: if it has an OutputReceiver, will source data from there
     * @param fnftId the fnft to get the value of
     * @return the face-value of the FNFT – for native Revest vault storage, this is guaranteed to be accurate
     * @dev for FNFTs with OutputReceivers, this value is provided by the OutputReceiver and not gauranteed to be accurate
     */
    function getFNFTCurrentValue(uint fnftId) external view override returns (uint) {      
        if(fnftId <= FNFT_CUTOFF) {
            ITokenVault legacyVault = ITokenVault(addressesProvider.getLegacyTokenVault());
            IRevest.FNFTConfig memory fnft = legacyVault.getFNFT(fnftId);
            if(fnft.pipeToContract != address(0) && fnft.pipeToContract.supportsInterface(OUTPUT_RECEIVER_INTERFACE_ID)) {
                address migration = migrations[fnft.pipeToContract];
                if(migration != address(0) && migration.supportsInterface(OUTPUT_RECEIVER_INTERFACE_ID)) {
                    // NB: The user has control of where this external view call goes
                    return IOutputReceiver(migration).getValue((fnftId));
                } else if(migration == address(0)) {
                    // NB: The user has control of where this external view call goes
                    return IOutputReceiver(fnft.pipeToContract).getValue((fnftId));
                }
            } else {
                return legacyVault.getFNFTCurrentValue(fnftId);
            }
        }

        // NB: The user has control of where this external call goes
        if(fnfts[fnftId].pipeToContract.supportsInterface(OUTPUT_RECEIVER_INTERFACE_ID)) {
            return IOutputReceiver(fnfts[fnftId].pipeToContract).getValue((fnftId));
        }

        uint currentAmount = 0;
        address asset = fnfts[fnftId].asset;
        if(asset != address(0)) {
            address smartWallet = getFNFTAddress(fnftId);
            uint supply = getFNFTHandler().getSupply(fnftId);
            // NB: The user has control of where this external call goes
            return IERC20(asset).balanceOf(smartWallet) / supply;
        }
        // Default fall-through
        return currentAmount;
    }

    /**
     * @notice Get the FNFT Config for a given FNFT ID
     * @param fnftId the FNFT ID to get the config for
     * @return the FNFT Config associated with the FNFT ID
     * @dev for TokenVaultV2 FNFTs, depositAmount will not be recorded
     */
    function getFNFT(uint fnftId) public view override returns (IRevest.FNFTConfig memory) {
        if(fnftId <= FNFT_CUTOFF) {
            IRevest.FNFTConfig memory config = ITokenVault(addressesProvider.getLegacyTokenVault()).getFNFT(fnftId);
            return config;
        } else {
            return fnfts[fnftId];
        }
    }

    /// Gets whether a given FNFT is nontransferrable
    function getNontransferable(uint fnftId) external view override returns (bool) {
        return getFNFT(fnftId).nontransferrable;
    }
    
    /// Gets the number of splits remaining for a given FNFT
    function getSplitsRemaining(uint fnftId) external view override returns (uint) {
        return getFNFT(fnftId).split;
    }

    /**
     * @notice Retrieves the smart-wallet address associated with a given FNFT ID
     * @param fnftId The FNFT Id to get the address for
     * @return smartWallet The address for the smart-wallet where funds for the given FNFT ID are stored 
     */
    function getFNFTAddress(uint fnftId) public view override returns (address smartWallet) {
        smartWallet = Clones.predictDeterministicAddress(TEMPLATE, keccak256(abi.encode(fnftId)));
    }

    ///
    /// Deprecated Functions
    ///

    /**
     * @dev Deprecated from TokenVaultV2 onwards
     */
    function splitFNFT(
        uint fnftId,
        uint[] memory newFNFTIds,
        uint[] memory proportions,
        uint quantity
    ) external override onlyRevestController {}

    /**
     * @dev Deprecated from TokenVaultV2 onwards
     */
    function depositToken(
        uint fnftId,
        uint transferAmount,
        uint quantity
    ) public override onlyRevestController {}

    /**
     * @dev Deprecated from TokenVaultV2 onwards
     */
    function handleMultipleDeposits(uint, uint, uint) external override onlyRevestController {}

}
