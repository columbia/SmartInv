//SPDX-License-Identifier: MIT
pragma solidity 0.7.5;

// Inheritance
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @title   Umbrella Airdrop contract
/// @author  umb.network
/// @notice  This contract provides Airdrop capability.
abstract contract Airdrop is ERC20 {
    function airdropTokens(
        address[] calldata _addresses,
        uint256[] calldata _amounts
    ) external {
        require(_addresses.length != 0, "there are no _addresses");
        require(_addresses.length == _amounts.length, "the number of _addresses should match _amounts");

        for(uint i = 0; i < _addresses.length; i++) {
            transfer(_addresses[i], _amounts[i]);
        }
    }
}
