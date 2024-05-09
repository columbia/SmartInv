// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

interface IBalancerOperations {

    function addLiquidity(address _poolAddress, address _asset, uint256 _amount) external returns (uint256);

    function removeLiquidity(address _poolAddress, address _asset, uint256 _bptAmountIn) external returns (uint256);
}