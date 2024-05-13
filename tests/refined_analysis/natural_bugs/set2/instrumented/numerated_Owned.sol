1 //SPDX-License-Identifier: MIT
2 pragma solidity 0.7.5;
3 
4 import "@openzeppelin/contracts/access/Ownable.sol";
5 
6 abstract contract Owned is Ownable {
7     constructor(address _owner) {
8         transferOwnership(_owner);
9     }
10 }
