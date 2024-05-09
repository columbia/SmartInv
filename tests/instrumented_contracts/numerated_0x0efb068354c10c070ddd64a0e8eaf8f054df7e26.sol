1 pragma solidity 0.5.11;
2 
3 
4 /**
5  * @title DharmaTradeReserve
6  * @author 0age
7  * @notice This contract delegates all logic, including initialization, to an
8  * implementation contract specified by a hard-coded "upgrade beacon" contract.
9  */
10 contract DharmaTradeReserve {
11   // Set upgrade beacon address as a constant (i.e. not in contract storage).
12   address private constant _UPGRADE_BEACON = address(
13     0x2Cf7C0333D9b7F94BbF55B9701227E359F92fD31
14   );
15 
16   /**
17    * @notice In the constructor, perform initialization via delegatecall to the
18    * implementation set on the upgrade beacon, supplying initialization calldata
19    * as a constructor argument. The deployment will revert and pass along the
20    * revert reason in the event that this initialization delegatecall reverts.
21    * @param initializationCalldata Calldata to supply when performing the
22    * initialization delegatecall.
23    */
24   constructor(bytes memory initializationCalldata) public payable {
25     // Delegatecall into the implementation, supplying initialization calldata.
26     (bool ok, ) = _implementation().delegatecall(initializationCalldata);
27 
28     // Revert and include revert data if delegatecall to implementation reverts.
29     if (!ok) {
30       assembly {
31         returndatacopy(0, 0, returndatasize)
32         revert(0, returndatasize)
33       }
34     }
35   }
36 
37   /**
38    * @notice In the fallback, delegate execution to the implementation set on
39    * the upgrade beacon.
40    */
41   function () external payable {
42     // Delegate execution to implementation contract provided by upgrade beacon.
43     _delegate(_implementation());
44   }
45 
46   /**
47    * @notice Private view function to get the current implementation from the
48    * upgrade beacon. This is accomplished via a staticcall to the beacon with no
49    * data, and the beacon will return an abi-encoded implementation address.
50    * @return implementation Address of the implementation.
51    */
52   function _implementation() private view returns (address implementation) {
53     // Get the current implementation address from the upgrade beacon.
54     (bool ok, bytes memory returnData) = _UPGRADE_BEACON.staticcall("");
55 
56     // Revert and pass along revert message if call to upgrade beacon reverts.
57     require(ok, string(returnData));
58 
59     // Set the implementation to the address returned from the upgrade beacon.
60     implementation = abi.decode(returnData, (address));
61   }
62 
63   /**
64    * @notice Private function that delegates execution to an implementation
65    * contract. This is a low level function that doesn't return to its internal
66    * call site. It will return whatever is returned by the implementation to the
67    * external caller, reverting and returning the revert data if implementation
68    * reverts.
69    * @param implementation Address to delegate.
70    */
71   function _delegate(address implementation) private {
72     assembly {
73       // Copy msg.data. We take full control of memory in this inline assembly
74       // block because it will not return to Solidity code. We overwrite the
75       // Solidity scratch pad at memory position 0.
76       calldatacopy(0, 0, calldatasize)
77 
78       // Delegatecall to the implementation, supplying calldata and gas.
79       // Out and outsize are set to zero - instead, use the return buffer.
80       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
81 
82       // Copy the returned data from the return buffer.
83       returndatacopy(0, 0, returndatasize)
84 
85       switch result
86       // Delegatecall returns 0 on error.
87       case 0 { revert(0, returndatasize) }
88       default { return(0, returndatasize) }
89     }
90   }
91 }