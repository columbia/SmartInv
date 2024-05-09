//SPDX-License-Identifier: MIT
pragma solidity 0.7.5;

// Inheritance
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import "../interfaces/Owned.sol";
import "../interfaces/ISwapReceiver.sol";


/// @title   Umbrella Rewards contract
/// @author  umb.network
/// @notice  This contract serves Swap functionality for rewards tokens
/// @dev     It allows to swap itself for other token (main UMB token).
///          Swap can start 1y from deployment or can be triggered earlier by owner.
///          There is a daily limit for swapping so we can't swap all at once.
///          When swap is executing, this contract do not care about target token,
///          so target token should be responsible for all the check before he mint tokens for swap.
abstract contract SwappableToken is Owned, ERC20 {
    using SafeMath for uint256;

    uint256 public totalAmountToBeSwapped;
    uint256 public swappedSoFar;
    uint256 public swapStartsOn;
    uint256 public swapDuration;

    // ========== CONSTRUCTOR ========== //

    constructor(uint _totalAmountToBeSwapped, uint _swapDuration) {
        require(_totalAmountToBeSwapped != 0, "_totalAmountToBeSwapped is empty");
        require(_swapDuration != 0, "swapDuration is empty");

        totalAmountToBeSwapped = _totalAmountToBeSwapped;
        swapStartsOn = block.timestamp + 365 days;
        swapDuration = _swapDuration;
    }

    // ========== MODIFIERS ========== //

    // ========== VIEWS ========== //

    function isSwapStarted() public view returns (bool) {
        return block.timestamp >= swapStartsOn;
    }

    function canSwapTokens(address _address) public view returns (bool) {
        return balanceOf(_address) <= totalUnlockedAmountOfToken().sub(swappedSoFar);
    }

    function totalUnlockedAmountOfToken() public view returns (uint256) {
        if (block.timestamp < swapStartsOn)
            return 0;
        if (block.timestamp >= swapStartsOn.add(swapDuration)) {
            return totalSupply().add(swappedSoFar);
        } else {
            return totalSupply().add(swappedSoFar).mul(block.timestamp.sub(swapStartsOn)).div(swapDuration);
        }
    }

    // ========== MUTATIVE FUNCTIONS ========== //

    function swapFor(ISwapReceiver _umb) external {
        require(block.timestamp >= swapStartsOn, "swapping period has not started yet");

        uint amountToSwap = balanceOf(_msgSender());

        require(amountToSwap != 0, "you dont have tokens to swap");
        require(amountToSwap <= totalUnlockedAmountOfToken().sub(swappedSoFar), "your swap is over the limit");

        swappedSoFar = swappedSoFar.add(amountToSwap);

        _burn(_msgSender(), amountToSwap);
        _umb.swapMint(_msgSender(), amountToSwap);

        emit LogSwap(_msgSender(), amountToSwap);
    }

    // ========== PRIVATE / INTERNAL ========== //

    // ========== RESTRICTED FUNCTIONS ========== //

    function startEarlySwap() external onlyOwner {
        require(block.timestamp < swapStartsOn, "swap is already allowed");

        swapStartsOn = block.timestamp;
        emit LogStartEarlySwapNow(block.timestamp);
    }

    // ========== EVENTS ========== //

    event LogStartEarlySwapNow(uint time);
    event LogSwap(address indexed swappedTo, uint amount);
}
