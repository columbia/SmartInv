1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 /**
6  * @title Proxy
7  * @dev Implements delegation of calls to other contracts, with proper
8  * forwarding of return values and bubbling of failures.
9  * It defines a fallback function that delegates all calls to the address
10  * returned by the abstract _implementation() internal function.
11  */
12 abstract contract Proxy {
13   /**
14    * @dev Fallback function.
15    * Implemented entirely in `_fallback`.
16    */
17   fallback () payable external {
18     _fallback();
19   }
20 
21   receive () payable external {}
22 
23   /**
24    * @return The Address of the implementation.
25    */
26   function _implementation() internal view virtual returns (address);
27 
28   /**
29    * @dev Delegates execution to an implementation contract.
30    * This is a low level function that doesn't return to its internal call site.
31    * It will return to the external caller whatever the implementation returns.
32    * @param implementation Address to delegate.
33    */
34   function _delegate(address implementation) internal {
35     assembly {
36       // Copy msg.data. We take full control of memory in this inline assembly
37       // block because it will not return to Solidity code. We overwrite the
38       // Solidity scratch pad at memory position 0.
39       calldatacopy(0, 0, calldatasize())
40 
41       // Call the implementation.
42       // out and outsize are 0 because we don't know the size yet.
43       let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
44 
45       // Copy the returned data.
46       returndatacopy(0, 0, returndatasize())
47 
48       switch result
49       // delegatecall returns 0 on error.
50       case 0 { revert(0, returndatasize()) }
51       default { return(0, returndatasize()) }
52     }
53   }
54 
55   /**
56    * @dev Function that is run as the first thing in the fallback function.
57    * Can be redefined in derived contracts to add functionality.
58    * Redefinitions must call super._willFallback().
59    */
60   function _willFallback() internal {
61   }
62 
63   /**
64    * @dev fallback implementation.
65    * Extracted to enable manual triggering.
66    */
67   function _fallback() internal {
68     _willFallback();
69     _delegate(_implementation());
70   }
71 }
