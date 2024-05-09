// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

interface ICurveMetaRegistry {
    
    function get_lp_token(address _pool) external view returns (address);

    function get_pool_from_lp_token(address _token) external view returns (address);
}