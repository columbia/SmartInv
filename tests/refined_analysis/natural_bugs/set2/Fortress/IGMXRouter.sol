// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

interface IGMXRouter {

    function swap(address[] memory _path, uint256 _amountIn, uint256 _minOut, address _receiver) external;
}