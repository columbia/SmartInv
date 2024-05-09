1 pragma solidity ^0.4.0;
2 
3 contract Destroyable{
4     /**
5      * @notice Allows to destroy the contract and return the tokens to the owner.
6      */
7     function destroy() public{
8         selfdestruct(address(this));
9     }
10 }