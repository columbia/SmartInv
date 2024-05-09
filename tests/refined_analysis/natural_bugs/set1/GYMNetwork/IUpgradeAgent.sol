// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.9;

/**
 * Upgrade agent interface inspired by Lunyr.
 *
 * Upgrade agent transfers tokens to a new contract.
 * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
 */
abstract contract IUpgradeAgent {
    function isUpgradeAgent() external virtual pure returns (bool);
    function upgradeFrom(address _from, uint256 _value) public virtual;
    function originalSupply() public virtual view returns (uint256);
    function originalToken() public virtual view returns (address);
}
