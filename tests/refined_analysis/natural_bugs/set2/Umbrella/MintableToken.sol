//SPDX-License-Identifier: MIT
pragma solidity 0.7.5;

// Inheritance
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import "../interfaces/Owned.sol";
import "../interfaces/IBurnableToken.sol";

/// @title   Umbrella Rewards contract
/// @author  umb.network
/// @notice  This contract allows to mint tokens and burn key (renounceOwnership)
/// @dev     Can be use used with MultiSig as owner
abstract contract MintableToken is Owned, ERC20, IBurnableToken {
    using SafeMath for uint256;

    // ========== STATE VARIABLES ========== //

    uint256 public maxAllowedTotalSupply;

    // ========== CONSTRUCTOR ========== //

    constructor (uint256 _maxAllowedTotalSupply) {
        require(_maxAllowedTotalSupply != 0, "_maxAllowedTotalSupply is empty");
        maxAllowedTotalSupply = _maxAllowedTotalSupply;
    }

    // ========== MODIFIERS ========== //

    modifier assertMaxSupply(uint256 _amountToMint) {
        require(totalSupply().add(_amountToMint) <= maxAllowedTotalSupply, "total supply limit exceeded");
        _;
    }

    // ========== MUTATIVE FUNCTIONS ========== //

    function burn(uint256 _amount) override external {
        uint balance = balanceOf(msg.sender);
        require(_amount <= balance, "not enough tokens to burn");

        _burn(msg.sender, _amount);
        maxAllowedTotalSupply = maxAllowedTotalSupply - _amount;
    }

    // ========== RESTRICTED FUNCTIONS ========== //

    function mint(address _holder, uint256 _amount)
    external
    onlyOwner()
    assertMaxSupply(_amount) {
        require(_amount > 0, "zero amount");

        _mint(_holder, _amount);
    }
}
