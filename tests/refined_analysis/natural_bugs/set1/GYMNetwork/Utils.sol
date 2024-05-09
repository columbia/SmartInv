// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.9;

contract Utils {
    function getChainID() internal view returns (uint256) {
        uint256 chainID;
        assembly {
            chainID := chainid()
        }
        return chainID;
    }

    function max(uint a, uint b) internal pure returns (uint) {
        return a > b ? a : b;
    }

    function min(uint a, uint b) internal pure returns (uint) {
        return a < b ? a : b;
    }

    function round(uint a, uint m) internal pure returns (uint ) {
        return ((a + m - 1) / m) * m;
    }
}