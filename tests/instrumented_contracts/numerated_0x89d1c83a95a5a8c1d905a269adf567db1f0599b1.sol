1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Proxy
5  * @dev Basic proxy that delegates all calls to a fixed implementing contract.
6  * The implementing contract cannot be upgraded.
7  * @author Julien Niset - <julien@argent.xyz>
8  */
9 contract Proxy {
10 
11     address implementation;
12 
13     event Received(uint indexed value, address indexed sender, bytes data);
14 
15     constructor(address _implementation) public {
16         implementation = _implementation;
17     }
18 
19     function() external payable {
20 
21         if(msg.data.length == 0 && msg.value > 0) { 
22             emit Received(msg.value, msg.sender, msg.data); 
23         }
24         else {
25             // solium-disable-next-line security/no-inline-assembly
26             assembly {
27                 let target := sload(0)
28                 calldatacopy(0, 0, calldatasize())
29                 let result := delegatecall(gas, target, 0, calldatasize(), 0, 0)
30                 returndatacopy(0, 0, returndatasize())
31                 switch result 
32                 case 0 {revert(0, returndatasize())} 
33                 default {return (0, returndatasize())}
34             }
35         }
36     }
37 }