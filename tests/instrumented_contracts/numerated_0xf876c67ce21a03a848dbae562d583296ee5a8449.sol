1 pragma solidity ^0.4.15;
2 
3 
4 contract Dispatcher {
5     address target;
6 
7     function Dispatcher(address _target) public {
8         target = _target;
9     }
10 
11     function() public {
12         assembly {
13             let _target := sload(0)
14             calldatacopy(0x0, 0x0, calldatasize)
15             let retval := delegatecall(gas, _target, 0x0, calldatasize, 0x0, 0)
16             let returnsize := returndatasize
17             returndatacopy(0x0, 0x0, returnsize)
18             switch retval case 0 {revert(0, 0)} default {return (0, returnsize)}
19         }
20     }
21 }