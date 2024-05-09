//SPDX-License-Identifier: Unlicense

pragma solidity 0.6.12;

interface IFeeRewardForwarder {
    function setConversionPath(address from, address to, address[] calldata _uniswapRoute) external;
    function setTokenPool(address _pool) external;

    function poolNotifyFixedTarget(address _token, uint256 _amount) external;

}
