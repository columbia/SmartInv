// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "src/shared/interfaces/ERC20.sol";
import "src/mainnet/compounders/curve/CurveCompounder.sol";
import "src/mainnet/compounders/balancer/BalancerCompounder.sol";

interface IFortressRegistry {

    function registerCurveCompounder(address _compounder, address _asset, string memory _symbol, string memory _name, address[] memory _underlyingAssets) external;

    function registerBalancerCompounder(address _compounder, address _asset, string memory _symbol, string memory _name, address[] memory _underlyingAssets) external;

}