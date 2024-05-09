// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

interface ICurveOperations {

    function addLiquidity(address _poolAddress, uint256 _poolType, address _token, uint256 _amount) payable external returns (uint256);

    function removeLiquidity(address _poolAddress, uint256 _poolType, address _token, uint256 _amount) external returns (uint256);
    
    function getPoolFromLpToken(address _lpToken) external view returns (address);
}