// SPDX-License-Identifier: GNU-GPL v3.0 or later

pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "./interfaces/ITokenVault.sol";
import "./interfaces/ILockManager.sol";
import "./interfaces/IRevest.sol";
import "./interfaces/IOutputReceiver.sol";
import "./interfaces/IInterestHandler.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "./utils/RevestAccessControl.sol";
import '@openzeppelin/contracts/utils/introspection/ERC165Checker.sol';

/**
 * This vault knows nothing about ownership. Only what fnftIds correspond to what configs
 * and ensures that all FNFTs are backed by assets in the vault.
 */
contract TokenVault is ITokenVault, AccessControlEnumerable, RevestAccessControl {
    using ERC165Checker for address;
    using SafeERC20 for IERC20;

    event CreateFNFT(uint indexed fnftId, address indexed from);
    event RedeemFNFT(uint indexed fnftId, address indexed from);

    mapping(uint => IRevest.FNFTConfig) private fnfts;

    mapping(address => IRevest.TokenTracker) public tokenTrackers;

    uint private constant multiplierPrecision = 1 ether;
    bytes4 public constant OUTPUT_RECEIVER_INTERFACE_ID = type(IOutputReceiver).interfaceId;


    constructor(address provider) RevestAccessControl(provider) {

    }

    function createFNFT(uint fnftId, IRevest.FNFTConfig memory fnftConfig, uint quantity, address from) external override {
        mapFNFTToToken(fnftId, fnftConfig);
        depositToken(fnftId, fnftConfig.depositAmount, quantity);
        emit CreateFNFT(fnftId, from);
    }


    /**
     * Grab the current balance of this address in the ERC20 and update the multiplier accordingly
     */
    function updateBalance(uint fnftId, uint incomingDeposit) internal {
        IRevest.FNFTConfig storage fnft = fnfts[fnftId];
        address asset = fnft.asset;
        IRevest.TokenTracker storage tracker = tokenTrackers[asset];

        uint currentAmount;
        uint lastBal = tracker.lastBalance;

        if(asset != address(0)){
            currentAmount = IERC20(asset).balanceOf(address(this));
        } else {
            // Keep us from zeroing out zero assets
            currentAmount = lastBal;
        }
        tracker.lastMul = lastBal == 0 ? multiplierPrecision : multiplierPrecision * currentAmount / lastBal;
        tracker.lastBalance = currentAmount + incomingDeposit;
    }

    /**
     * This lines up the fnftId with its config and ensures that the fnftId -> config mapping
     * is only created if the proper tokens are deposited.
     * It does not handle the FNFT creation and assignment itself, that happens in Revest.sol
     * PRECONDITION: fnftId maps to fnftConfig, as done in CreateFNFT()
     */
    function depositToken(
        uint fnftId,
        uint transferAmount,
        uint quantity
    ) public override onlyRevestController {
        // Updates in advance, to handle rebasing tokens
        updateBalance(fnftId, quantity * transferAmount);
        IRevest.FNFTConfig storage fnft = fnfts[fnftId];
        fnft.depositMul = tokenTrackers[fnft.asset].lastMul;
    }

    function withdrawToken(
        uint fnftId,
        uint quantity,
        address user
    ) external override onlyRevestController {
        IRevest.FNFTConfig storage fnft = fnfts[fnftId];
        IRevest.TokenTracker storage tracker = tokenTrackers[fnft.asset];
        address asset = fnft.asset;

        // Update multiplier first
        updateBalance(fnftId, 0);

        uint withdrawAmount = fnft.depositAmount * quantity * tracker.lastMul / fnft.depositMul;
        tracker.lastBalance -= withdrawAmount;

        address pipeTo = fnft.pipeToContract;
        if (pipeTo == address(0)) {
            if(asset != address(0)) {
                IERC20(asset).safeTransfer(user, withdrawAmount);
            }
        }
        else {
            if(fnft.depositAmount > 0 && asset != address(0)) {
                //Only transfer value if there is value to transfer
                IERC20(asset).safeTransfer(fnft.pipeToContract, withdrawAmount);
            }
            if(pipeTo.supportsInterface(OUTPUT_RECEIVER_INTERFACE_ID)) {
                // Callback to OutputReceiver
                IOutputReceiver(pipeTo).receiveRevestOutput(fnftId, asset, payable(user), quantity);
            }
        }

        if(getFNFTHandler().getSupply(fnftId) == 0) {
            removeFNFT(fnftId);
        }
        emit RedeemFNFT(fnftId, _msgSender());
    }


    function mapFNFTToToken(
        uint fnftId,
        IRevest.FNFTConfig memory fnftConfig
    ) public override onlyRevestController {
        // Gas optimizations
        fnfts[fnftId].asset =  fnftConfig.asset;
        fnfts[fnftId].depositAmount =  fnftConfig.depositAmount;
        if(fnftConfig.depositMul > 0) {
            fnfts[fnftId].depositMul = fnftConfig.depositMul;
        }
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

    function splitFNFT(
        uint fnftId,
        uint[] memory newFNFTIds,
        uint[] memory proportions,
        uint quantity
    ) external override {
        IRevest.FNFTConfig storage fnft = fnfts[fnftId];
        updateBalance(fnftId, 0);
        // Burn the original FNFT but keep its lock

        // Create new FNFTs with the same config, only thing changed is the depositAmount
        // proportions should add up to 1000
        uint denominator = 1000;
        uint runningTotal = 0;
        for(uint i = 0; i < proportions.length; i++) {
            runningTotal += proportions[i];
            uint amount = fnft.depositAmount * proportions[i] / denominator;
            IRevest.FNFTConfig memory newFNFT = cloneFNFTConfig(fnft);
            newFNFT.depositAmount = amount;
            newFNFT.split -= 1;
            mapFNFTToToken(newFNFTIds[i], newFNFT);
            emit CreateFNFT(newFNFTIds[i], _msgSender());
        }
        // This is really a precondition but more efficient to place here
        require(runningTotal == denominator, 'E054');
        if(quantity == getFNFTHandler().getSupply(fnftId)) {
            // We should also burn it
            removeFNFT(fnftId);
        }
        emit RedeemFNFT(fnftId, _msgSender());
    }

    function removeFNFT(uint fnftId) internal {
        delete fnfts[fnftId];
    }

    // amount = amount per vault for new mapping
    function handleMultipleDeposits(
        uint fnftId,
        uint newFNFTId,
        uint amount
    ) external override onlyRevestController {
        require(amount >= fnfts[fnftId].depositAmount, 'E003');
        IRevest.FNFTConfig storage config = fnfts[fnftId];
        config.depositAmount = amount;
        mapFNFTToToken(fnftId, config);
        if(newFNFTId != 0) {
            mapFNFTToToken(newFNFTId, config);
        }
    }

    function cloneFNFTConfig(IRevest.FNFTConfig memory old) public pure override returns (IRevest.FNFTConfig memory) {
        return IRevest.FNFTConfig({
            asset: old.asset,
            depositAmount: old.depositAmount,
            depositMul: old.depositMul,
            split: old.split,
            maturityExtension: old.maturityExtension,
            pipeToContract: old.pipeToContract,
            isMulti : old.isMulti,
            depositStopTime: old.depositStopTime,
            nontransferrable: old.nontransferrable
        });
    }

    /**
    // Getters
    **/

    function getFNFTCurrentValue(uint fnftId) external view override returns (uint) {
        if(fnfts[fnftId].pipeToContract.supportsInterface(OUTPUT_RECEIVER_INTERFACE_ID)) {
            return IOutputReceiver(fnfts[fnftId].pipeToContract).getValue((fnftId));
        }

        uint currentAmount = 0;
        if(fnfts[fnftId].asset != address(0)) {
            currentAmount = IERC20(fnfts[fnftId].asset).balanceOf(address(this));
            IRevest.TokenTracker memory tracker = tokenTrackers[fnfts[fnftId].asset];
            uint lastMul = tracker.lastBalance == 0 ? multiplierPrecision : multiplierPrecision * currentAmount / tracker.lastBalance;
            return fnfts[fnftId].depositAmount * lastMul / fnfts[fnftId].depositMul;
        }
        // Default fall-through
        return currentAmount;
    }

    /**
     * Getters
     **/
    function getFNFT(uint fnftId) external view override returns (IRevest.FNFTConfig memory) {
        return fnfts[fnftId];
    }

    function getNontransferable(uint fnftId) external view override returns (bool) {
        return fnfts[fnftId].nontransferrable;
    }

    function getSplitsRemaining(uint fnftId) external view override returns (uint) {
        IRevest.FNFTConfig storage fnft = fnfts[fnftId];
        return fnft.split;
    }
}
