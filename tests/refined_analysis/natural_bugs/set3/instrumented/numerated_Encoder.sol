1 pragma solidity ^0.5.0;
2 pragma experimental ABIEncoderV2;
3 
4 contract AbiEncoder {
5     function encodeWhiteList(address _contract, bytes[] memory _methods) public pure returns(bytes memory) {
6         return abi.encode(_contract,_methods);
7     }
8 }