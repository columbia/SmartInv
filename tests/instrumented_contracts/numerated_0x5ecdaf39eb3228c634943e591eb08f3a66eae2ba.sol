1 pragma solidity ^0.4.23;
2 
3 contract Destroy{
4       function delegatecall_selfdestruct(address _target) external returns (bool _ans) {
5           _ans = _target.delegatecall(bytes4(sha3("address)")), this); 
6       }
7 }