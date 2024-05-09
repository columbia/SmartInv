// SPDX-License-Identifier: GNU-GPL v3.0 or later

pragma solidity ^0.8.0;

import "./interfaces/IRewardsHandler.sol";
import "./utils/RevestAccessControl.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract RewardsHandler is RevestAccessControl, IRewardsHandler {
    using SafeERC20 for IERC20;

    address internal immutable WETH;
    address internal immutable RVST;
    address public STAKING;
    uint public constant PRECISION = 10**27;

    uint public erc20Fee; // out of 1000
    uint constant public erc20multiplierPrecision = 1000;

    /**
     allocPoints is the same for all reward tokens (WETH vs RVST)
     lastMul is different for staking types (LP vs basic)
     */

    mapping(uint => UserBalance) public wethBasicBalances;
    mapping(uint => UserBalance) public wethLPBalances;
    mapping(uint => UserBalance) public rvstBasicBalances;
    mapping(uint => UserBalance) public rvstLPBalances;

    uint public wethBasicGlobalMul = PRECISION;
    uint public wethLPGlobalMul = PRECISION;
    uint public rvstBasicGlobalMul = PRECISION;
    uint public rvstLPGlobalMul = PRECISION;
    uint public totalLPAllocPoint = 1; // Total allocation points. Must be the sum of all allocation points. We start at 1 to avoid divide-by-zero
    uint public totalBasicAllocPoint = 1;

    constructor(address provider, address weth, address rvst) RevestAccessControl(provider) {
        WETH = weth;
        RVST = rvst;
    }

    /**
     * When receiving new allocPoint, you have to adjust the multiplier accordingly. Claim rewards as part of this
     * `allocPoint` will always be the same for WETH and RVST, but we need to update them both
     */
    function updateLPShares(uint fnftId, uint newAllocPoint) external override onlyStakingContract {
        // allocPoint is the same for wethBasic and rvstBasic
        totalLPAllocPoint = totalLPAllocPoint + newAllocPoint - wethLPBalances[fnftId].allocPoint;

        wethLPBalances[fnftId].allocPoint = newAllocPoint;
        wethLPBalances[fnftId].lastMul = wethLPGlobalMul;
        rvstLPBalances[fnftId].allocPoint = newAllocPoint;
        rvstLPBalances[fnftId].lastMul = rvstLPGlobalMul;
    }

    function updateBasicShares(uint fnftId, uint newAllocPoint) external override onlyStakingContract {
        // allocPoint is the same for wethBasic and rvstBasic
        totalBasicAllocPoint = totalBasicAllocPoint + newAllocPoint - wethBasicBalances[fnftId].allocPoint;

        wethBasicBalances[fnftId].allocPoint = newAllocPoint;
        wethBasicBalances[fnftId].lastMul = wethBasicGlobalMul;
        rvstBasicBalances[fnftId].allocPoint = newAllocPoint;
        rvstBasicBalances[fnftId].lastMul = rvstBasicGlobalMul;
    }

    /**
     * We require claiming all rewards simultaneously for simplicity
     * 0 = has neither, 1 = WETH, 2 = RVST, 3 = BOTH
     * Implicit assumption that user is authenticated to this FNFT prior to claiming
     */
    function claimRewards(uint fnftId, address caller) external override onlyStakingContract returns (uint) {
        bool hasWeth = claimRewardsForToken(fnftId, WETH, caller);
        bool hasRVST = claimRewardsForToken(fnftId, RVST, caller);
        if(hasWeth) {
            if(hasRVST) {
                return 3;
            } else {
                return 1;
            }
        }
        return hasRVST ? 2 : 0;
    }

    function claimRewardsForToken(uint fnftId, address token, address user) internal returns (bool) {
        (UserBalance storage lpBalance, UserBalance storage basicBalance) = getBalances(fnftId, token);
        uint amount = rewardsOwed(token, lpBalance, basicBalance);
        lpBalance.lastMul = getLPGlobalMul(token);
        basicBalance.lastMul = getBasicGlobalMul(token);

        IERC20(token).safeTransfer(user, amount);
        return amount > 0;
    }

    function getRewards(uint fnftId, address token) external view override returns (uint) {
        (UserBalance memory lpBalance, UserBalance memory basicBalance) = getBalances(fnftId, token);
        uint rewards = rewardsOwed(token, lpBalance, basicBalance);
        return rewards;
    }

    /**
     * Precondition: fee is already approved by msg sender
     * This simple function increments the multiplier for everyone with existing positions
     * Hence it covers the case where someone enters later, they start with a higher multiplier.
     * We increment totalAllocPoint with new depositors, and increment curMul with new income.
     */
    function receiveFee(address token, uint amount) external override {
        require(token == WETH || token == RVST, "Only WETH and RVST supported");
        IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
        if(totalLPAllocPoint + totalBasicAllocPoint > 0) {
            uint basicMulInc = (amount * PRECISION / 2) / totalBasicAllocPoint;
            uint lpMulInc = (amount * PRECISION / 2) / totalLPAllocPoint;
            setBasicGlobalMul(token, getBasicGlobalMul(token) + basicMulInc);
            setLPGlobalMul(token, getLPGlobalMul(token) + lpMulInc);
        }
    }

    function getAllocPoint(uint fnftId, address token, bool isBasic) external view override returns (uint) {
        if (token == WETH) {
            return isBasic ? wethBasicBalances[fnftId].allocPoint : wethLPBalances[fnftId].allocPoint;
        } else {
            return isBasic ? rvstBasicBalances[fnftId].allocPoint : rvstLPBalances[fnftId].allocPoint;
        }
    }

    function setStakingContract(address stake) external override onlyOwner {
        STAKING = stake;
    }

    // INTERNAL FUNCTIONS

    /**
     * View-only function. Does not update any balances.
     */
    function rewardsOwed(address token, UserBalance memory lpBalance, UserBalance memory basicBalance) internal view returns (uint) {
        uint globalBalance = IERC20(token).balanceOf(address(this));
        uint lpRewards = (getLPGlobalMul(token) - lpBalance.lastMul) * lpBalance.allocPoint;
        uint basicRewards = (getBasicGlobalMul(token) - basicBalance.lastMul) * basicBalance.allocPoint;
        uint tokenAmount = (lpRewards + basicRewards) / PRECISION;
        return tokenAmount;
    }

    function getBalances(uint fnftId, address token) internal view returns (UserBalance storage, UserBalance storage) {
        return token == WETH ? (wethLPBalances[fnftId], wethBasicBalances[fnftId]) : (rvstLPBalances[fnftId], rvstBasicBalances[fnftId]);
    }

    function getLPGlobalMul(address token) internal view returns (uint) {
        return token == WETH ? wethLPGlobalMul : rvstLPGlobalMul;
    }

    function setLPGlobalMul(address token, uint newMul) internal {
        if (token == WETH) {
            wethLPGlobalMul = newMul;
        } else {
            rvstLPGlobalMul = newMul;
        }
    }

    function getBasicGlobalMul(address token) internal view returns (uint) {
        return token == WETH ? wethBasicGlobalMul : rvstBasicGlobalMul;
    }

    function setBasicGlobalMul(address token, uint newMul) internal {
        if (token == WETH) {
            wethBasicGlobalMul = newMul;
        } else {
            rvstBasicGlobalMul = newMul;
        }
    }

    // Admin functions for migration
    // To be fully abandoned in future via contract-based owner
    // Apart from setStakingContract

    function manualMapRVSTBasic(
        uint[] memory fnfts,
        uint[] memory allocPoints
    ) external onlyOwner {
        for(uint i = 0; i < fnfts.length; i++) {
            UserBalance storage userBal = rvstBasicBalances[fnfts[i]];
            userBal.allocPoint = allocPoints[i];
            userBal.lastMul = rvstBasicGlobalMul;
        }
    }

    function manualMapRVSTLP(
        uint[] memory fnfts,
        uint[] memory allocPoints
    ) external onlyOwner {
        for(uint i = 0; i < fnfts.length; i++) {
            UserBalance storage userBal = rvstLPBalances[fnfts[i]];
            userBal.allocPoint = allocPoints[i];
            userBal.lastMul = rvstLPGlobalMul;
        }
    }

    function manualMapWethBasic(
        uint[] memory fnfts,
        uint[] memory allocPoints
    ) external onlyOwner {
        for(uint i = 0; i < fnfts.length; i++) {
            UserBalance storage userBal = wethBasicBalances[fnfts[i]];
            userBal.allocPoint = allocPoints[i];
            userBal.lastMul = wethBasicGlobalMul;
        }
    }

    function manualMapWethLP(
        uint[] memory fnfts,
        uint[] memory allocPoints
    ) external onlyOwner {
        for(uint i = 0; i < fnfts.length; i++) {
            UserBalance storage userBal = wethLPBalances[fnfts[i]];
            userBal.allocPoint = allocPoints[i];
            userBal.lastMul = wethLPGlobalMul;
        }
    }

    function manualSetAllocPoints(uint _totalBasic, uint _totalLP) external onlyOwner {
        if (_totalBasic > 0) {
            totalBasicAllocPoint = _totalBasic;
        }
        if (_totalLP > 0) {
            totalLPAllocPoint = _totalLP;
        }
    }

    modifier onlyStakingContract() {
        require(_msgSender() != address(0), "E004");
        require(_msgSender() == STAKING, "E060");
        _;
    }

}
