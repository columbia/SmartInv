//SPDX-License-Identifier: Unlicense

pragma solidity 0.6.12;

interface IFeeRewardForwarderV2 {
    function setConversionPath(address from, address to, address[] calldata _uniswapRoute, address _router) external;
    function setTokenPool(address _pool) external;

    function poolNotifyFixedTarget(address _token, uint256 _amount) external;

}
