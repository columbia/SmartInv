1 pragma solidity 0.8.7;
2 
3 
4 // SPDX-License-Identifier: MIT
5 /**
6  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
7  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
8  * be specified by overriding the virtual {_implementation} function.
9  *
10  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
11  * different contract through the {_delegate} function.
12  *
13  * The success and return data of the delegated call will be returned back to the caller of the proxy.
14  */
15 contract Proxy {
16 
17     address implementation_;
18     address public admin;
19 
20     constructor(address impl) {
21         implementation_ = impl;
22         admin = msg.sender;
23     }
24 
25     receive() external payable {}
26 
27     function setImplementation(address newImpl) public {
28         require(msg.sender == admin);
29         implementation_ = newImpl;
30     }
31     
32     function implementation() public view returns (address impl) {
33         impl = implementation_;
34     }
35 
36     /**
37      * @dev Delegates the current call to `implementation`.
38      *
39      * This function does not return to its internall call site, it will return directly to the external caller.
40      */
41     function _delegate(address implementation__) internal virtual {
42         assembly {
43             // Copy msg.data. We take full control of memory in this inline assembly
44             // block because it will not return to Solidity code. We overwrite the
45             // Solidity scratch pad at memory position 0.
46             calldatacopy(0, 0, calldatasize())
47 
48             // Call the implementation.
49             // out and outsize are 0 because we don't know the size yet.
50             let result := delegatecall(gas(), implementation__, 0, calldatasize(), 0, 0)
51 
52             // Copy the returned data.
53             returndatacopy(0, 0, returndatasize())
54 
55             switch result
56             // delegatecall returns 0 on error.
57             case 0 {
58                 revert(0, returndatasize())
59             }
60             default {
61                 return(0, returndatasize())
62             }
63         }
64     }
65 
66     /**
67      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
68      * and {_fallback} should delegate.
69      */
70     function _implementation() internal view returns (address) {
71         return implementation_;
72     }
73 
74 
75     /**
76      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
77      * function in the contract matches the call data.
78      */
79     fallback() external payable virtual {
80         _delegate(_implementation());
81     }
82 
83 }