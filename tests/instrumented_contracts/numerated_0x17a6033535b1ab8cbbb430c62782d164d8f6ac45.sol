1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title AraProxy
5  * @dev Gives the possibility to delegate any call to a foreign implementation.
6  */
7 contract AraProxy {
8 
9   bytes32 private constant registryPosition_ = keccak256("io.ara.proxy.registry");
10   bytes32 private constant implementationPosition_ = keccak256("io.ara.proxy.implementation");
11 
12   modifier restricted() {
13     bytes32 registryPosition = registryPosition_;
14     address registryAddress;
15     assembly {
16       registryAddress := sload(registryPosition)
17     }
18     require(
19       msg.sender == registryAddress,
20       "Only the AraRegistry can upgrade this proxy."
21     );
22     _;
23   }
24 
25   /**
26   * @dev the constructor sets the AraRegistry address
27   */
28   constructor(address _registryAddress, address _implementationAddress) public {
29     bytes32 registryPosition = registryPosition_;
30     bytes32 implementationPosition = implementationPosition_;
31     assembly {
32       sstore(registryPosition, _registryAddress)
33       sstore(implementationPosition, _implementationAddress)
34     }
35   }
36 
37   function setImplementation(address _newImplementation) public restricted {
38     require(_newImplementation != address(0));
39     bytes32 implementationPosition = implementationPosition_;
40     assembly {
41       sstore(implementationPosition, _newImplementation)
42     }
43   }
44 
45   /**
46   * @dev Fallback function allowing to perform a delegatecall to the given implementation.
47   * This function will return whatever the implementation call returns
48   */
49   function () payable public {
50     bytes32 implementationPosition = implementationPosition_;
51     address _impl;
52     assembly {
53       _impl := sload(implementationPosition)
54     }
55 
56     assembly {
57       let ptr := mload(0x40)
58       calldatacopy(ptr, 0, calldatasize)
59       let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
60       let size := returndatasize
61       returndatacopy(ptr, 0, size)
62 
63       switch result
64       case 0 { revert(ptr, size) }
65       default { return(ptr, size) }
66     }
67   }
68 }