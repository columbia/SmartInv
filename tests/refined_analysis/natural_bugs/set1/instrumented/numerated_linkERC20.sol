1 pragma solidity ^0.4.11;
2 
3 
4 import './linkERC20Basic.sol';
5 
6 
7 /**
8  * @title ERC20 interface
9  * @dev see https://github.com/ethereum/EIPs/issues/20
10  */
11 contract linkERC20 is linkERC20Basic {
12   function allowance(address owner, address spender) constant returns (uint256);
13   function transferFrom(address from, address to, uint256 value) returns (bool);
14   function approve(address spender, uint256 value) returns (bool);
15   event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
