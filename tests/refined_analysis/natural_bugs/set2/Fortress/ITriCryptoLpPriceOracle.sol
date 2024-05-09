// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

interface ITriCryptoLpPriceOracle {

    function lp_price() external view returns (uint256);
}