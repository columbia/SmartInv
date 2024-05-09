//SPDX-License-Identifier: Unlicensed
pragma solidity >=0.7.5;

library Strings {
    function appendString(string memory str1, string memory str2) public pure returns (string memory result) {
        return string(abi.encodePacked(str1,str2));
    }
    function appendNumber(string memory str, uint i) public pure returns (string memory result) {
        return string(abi.encodePacked(str,i+uint(48)));
    }
}
