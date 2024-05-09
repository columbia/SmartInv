1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
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
15 abstract contract Proxy {
16     /**
17      * @dev Delegates the current call to `implementation`.
18      * 
19      * This function does not return to its internall call site, it will return directly to the external caller.
20      */
21     function _delegate(address implementation) internal {
22         // solhint-disable-next-line no-inline-assembly
23         assembly {
24             // Copy msg.data. We take full control of memory in this inline assembly
25             // block because it will not return to Solidity code. We overwrite the
26             // Solidity scratch pad at memory position 0.
27             calldatacopy(0, 0, calldatasize())
28 
29             // Call the implementation.
30             // out and outsize are 0 because we don't know the size yet.
31             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
32 
33             // Copy the returned data.
34             returndatacopy(0, 0, returndatasize())
35 
36             switch result
37             // delegatecall returns 0 on error.
38             case 0 { revert(0, returndatasize()) }
39             default { return(0, returndatasize()) }
40         }
41     }
42 
43     /**
44      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
45      * and {_fallback} should delegate.
46      */
47     function _implementation() internal virtual view returns (address);
48 
49     /**
50      * @dev Delegates the current call to the address returned by `_implementation()`.
51      * 
52      * This function does not return to its internall call site, it will return directly to the external caller.
53      */
54     function _fallback() internal {
55         _beforeFallback();
56         _delegate(_implementation());
57     }
58 
59     /**
60      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
61      * function in the contract matches the call data.
62      */
63     fallback () payable external {
64         _fallback();
65     }
66 
67     /**
68      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
69      * is empty.
70      */
71     receive () payable external {
72         _fallback();
73     }
74 
75     /**
76      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
77      * call, or as part of the Solidity `fallback` or `receive` functions.
78      * 
79      * If overriden should call `super._beforeFallback()`.
80      */
81     function _beforeFallback() internal virtual {
82     }
83 }
84 
85 contract XGoldProxy is Proxy {
86     
87     address public impl;
88     address public contractOwner;
89 
90     address public fourthLevelUpdater;
91 
92     modifier onlyContractOwner() { 
93         require(msg.sender == contractOwner); 
94         _; 
95     }
96 
97     constructor(address _impl) public {
98         impl = _impl;
99         contractOwner = msg.sender;
100     }
101     
102     function update(address newImpl) public onlyContractOwner {
103         impl = newImpl;
104     }
105 
106     function removeOwnership() public onlyContractOwner {
107         contractOwner = address(0);
108     }
109     
110     function _implementation() internal override view returns (address) {
111         return impl;
112     }
113 }