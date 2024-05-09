1 pragma solidity ^0.5.0;
2 
3 
4 /**
5  * @title User Owned Proxy
6  */
7 contract UserProxy {
8 
9     /**
10      * @dev execute authorised calls via delegate call
11      * @param _target logic proxy address
12      * @param _data delegate call data
13      */
14     function execute(address _target, bytes memory _data) public payable returns (bytes memory response) {
15         require(_target != address(0), "user-proxy-target-address-required");
16         assembly {
17             let succeeded := delegatecall(sub(gas, 5000), _target, add(_data, 0x20), mload(_data), 0, 0)
18             let size := returndatasize
19 
20             response := mload(0x40)
21             mstore(0x40, add(response, and(add(add(size, 0x20), 0x1f), not(0x1f))))
22             mstore(response, size)
23             returndatacopy(add(response, 0x20), 0, size)
24 
25             switch iszero(succeeded)
26                 case 1 {
27                     // throw if delegatecall failed
28                     revert(add(response, 0x20), size)
29                 }
30         }
31     }
32 
33 }