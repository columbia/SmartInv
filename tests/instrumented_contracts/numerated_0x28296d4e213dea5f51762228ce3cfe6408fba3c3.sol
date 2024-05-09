1 pragma solidity 0.5.12;
2 pragma experimental ABIEncoderV2;
3 
4  // @author Authereum, Inc.
5 
6 /**
7  * @title AuthereumProxy
8  * @author Authereum, Inc.
9  * @dev The Authereum Proxy.
10  */
11 
12 contract AuthereumProxy {
13     string constant public authereumProxyVersion = "2019102500";
14 
15     /// @dev Storage slot with the address of the current implementation.
16     /// @notice This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted 
17     /// @notice by 1, and is validated in the constructor.
18     bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
19 
20     /// @dev Set the implementation in the constructor
21     /// @param _logic Address of the logic contract
22     constructor(address _logic) public payable {
23         bytes32 slot = IMPLEMENTATION_SLOT;
24         assembly {
25             sstore(slot, _logic)
26         }
27     }
28 
29     /// @dev Fallback function
30     /// @notice A payable fallback needs to be implemented in the implementation contract
31     /// @notice This is a low level function that doesn't return to its internal call site.
32     /// @notice It will return to the external caller whatever the implementation returns.
33     function () external payable {
34         if (msg.data.length == 0) return;
35         address _implementation = implementation();
36 
37         assembly {
38             // Copy msg.data. We take full control of memory in this inline assembly
39             // block because it will not return to Solidity code. We overwrite the
40             // Solidity scratch pad at memory position 0.
41             calldatacopy(0, 0, calldatasize)
42 
43             // Call the implementation.
44             // out and outsize are 0 because we don't know the size yet.
45             let result := delegatecall(gas, _implementation, 0, calldatasize, 0, 0)
46 
47             // Copy the returned data.
48             returndatacopy(0, 0, returndatasize)
49 
50             switch result
51             // delegatecall returns 0 on error.
52             case 0 { revert(0, returndatasize) }
53             default { return(0, returndatasize) }
54         }
55     }
56 
57     /// @dev Returns the current implementation.
58     /// @return Address of the current implementation
59     function implementation() public view returns (address impl) {
60         bytes32 slot = IMPLEMENTATION_SLOT;
61         assembly {
62             impl := sload(slot)
63         }
64     }
65 }