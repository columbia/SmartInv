1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.7;
4 
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
25     function setImplementation(address newImpl) public {
26         require(msg.sender == admin);
27         implementation_ = newImpl;
28     }
29     
30     function implementation() public view returns (address impl) {
31         impl = implementation_;
32     }
33 
34     /**
35      * @dev Delegates the current call to `implementation`.
36      *
37      * This function does not return to its internall call site, it will return directly to the external caller.
38      */
39     function _delegate(address implementation__) internal virtual {
40         assembly {
41             // Copy msg.data. We take full control of memory in this inline assembly
42             // block because it will not return to Solidity code. We overwrite the
43             // Solidity scratch pad at memory position 0.
44             calldatacopy(0, 0, calldatasize())
45 
46             // Call the implementation.
47             // out and outsize are 0 because we don't know the size yet.
48             let result := delegatecall(gas(), implementation__, 0, calldatasize(), 0, 0)
49 
50             // Copy the returned data.
51             returndatacopy(0, 0, returndatasize())
52 
53             switch result
54             // delegatecall returns 0 on error.
55             case 0 {
56                 revert(0, returndatasize())
57             }
58             default {
59                 return(0, returndatasize())
60             }
61         }
62     }
63 
64     /**
65      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
66      * and {_fallback} should delegate.
67      */
68     function _implementation() internal view returns (address) {
69         return implementation_;
70     }
71 
72 
73     /**
74      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
75      * function in the contract matches the call data.
76      */
77     fallback() external payable virtual {
78         _delegate(_implementation());
79     }
80 
81 }