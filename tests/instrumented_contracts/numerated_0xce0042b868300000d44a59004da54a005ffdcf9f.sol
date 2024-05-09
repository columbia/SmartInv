1 pragma solidity 0.6.2;
2 
3 
4 /**
5  * @title Singleton Factory (EIP-2470)
6  * @notice Exposes CREATE2 (EIP-1014) to deploy bytecode on deterministic addresses based on initialization code and salt.
7  * @author Ricardo Guilherme Schmidt (Status Research & Development GmbH)
8  */
9 contract SingletonFactory {
10     /**
11      * @notice Deploys `_initCode` using `_salt` for defining the deterministic address.
12      * @param _initCode Initialization code.
13      * @param _salt Arbitrary value to modify resulting address.
14      * @return createdContract Created contract address.
15      */
16     function deploy(bytes memory _initCode, bytes32 _salt)
17         public
18         returns (address payable createdContract)
19     {
20         assembly {
21             createdContract := create2(0, add(_initCode, 0x20), mload(_initCode), _salt)
22         }
23     }
24 }
25 // IV is a value changed to generate the vanity address.
26 // IV: 6583047