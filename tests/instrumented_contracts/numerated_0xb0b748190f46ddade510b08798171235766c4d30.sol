1 // File: TestContracts/Proxy.sol
2 
3 pragma solidity 0.8.7;
4 
5 /// @dev Proxy for NFT Factory
6 contract Proxy {
7 
8     // Storage for this proxy
9     bytes32 private constant IMPLEMENTATION_SLOT = bytes32(0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc);
10     bytes32 private constant ADMIN_SLOT          = bytes32(0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103);
11 
12     constructor(address impl) {
13         require(impl != address(0));
14 
15         _setSlotValue(IMPLEMENTATION_SLOT, bytes32(uint256(uint160(impl))));
16         _setSlotValue(ADMIN_SLOT, bytes32(uint256(uint160(msg.sender))));
17     }
18 
19     function setImplementation(address newImpl) public {
20         require(msg.sender == _getAddress(ADMIN_SLOT));
21         _setSlotValue(IMPLEMENTATION_SLOT, bytes32(uint256(uint160(newImpl))));
22     }
23     
24     function implementation() public view returns (address impl) {
25         impl = address(uint160(uint256(_getSlotValue(IMPLEMENTATION_SLOT))));
26     }
27 
28     function _getAddress(bytes32 key) internal view returns (address add) {
29         add = address(uint160(uint256(_getSlotValue(key))));
30     }
31 
32     function _getSlotValue(bytes32 slot_) internal view returns (bytes32 value_) {
33         assembly {
34             value_ := sload(slot_)
35         }
36     }
37 
38     function _setSlotValue(bytes32 slot_, bytes32 value_) internal {
39         assembly {
40             sstore(slot_, value_)
41         }
42     }
43 
44     /**
45      * @dev Delegates the current call to `implementation`.
46      *
47      * This function does not return to its internall call site, it will return directly to the external caller.
48      */
49     function _delegate(address implementation__) internal virtual {
50         assembly {
51             // Copy msg.data. We take full control of memory in this inline assembly
52             // block because it will not return to Solidity code. We overwrite the
53             // Solidity scratch pad at memory position 0.
54             calldatacopy(0, 0, calldatasize())
55 
56             // Call the implementation.
57             // out and outsize are 0 because we don't know the size yet.
58             let result := delegatecall(gas(), implementation__, 0, calldatasize(), 0, 0)
59 
60             // Copy the returned data.
61             returndatacopy(0, 0, returndatasize())
62 
63             switch result
64             // delegatecall returns 0 on error.
65             case 0 {
66                 revert(0, returndatasize())
67             }
68             default {
69                 return(0, returndatasize())
70             }
71         }
72     }
73 
74 
75     /**
76      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
77      * function in the contract matches the call data.
78      */
79     fallback() external payable virtual {
80         _delegate(_getAddress(IMPLEMENTATION_SLOT));
81     }
82 
83 }