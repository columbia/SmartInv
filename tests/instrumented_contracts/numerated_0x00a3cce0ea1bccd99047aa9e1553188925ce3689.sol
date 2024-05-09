1 pragma solidity 0.5.11; // optimization runs: 200, evm version: petersburg
2 
3 
4 /**
5  * @title UpgradeBeaconProxyV1
6  * @author 0age
7  * @notice This contract delegates all logic, including initialization, to an
8  * implementation contract specified by a hard-coded "upgrade beacon" contract.
9  * Note that this implementation can be reduced in size by stripping out the
10  * metadata hash, or even more significantly by using a minimal upgrade beacon
11  * proxy implemented using raw EVM opcodes.
12  */
13 contract UpgradeBeaconProxyV1 {
14   // Set upgrade beacon address as a constant (i.e. not in contract storage).
15   address private constant _UPGRADE_BEACON = address(
16     0x000000000026750c571ce882B17016557279ADaa
17   );
18 
19   /**
20    * @notice In the constructor, perform initialization via delegatecall to the
21    * implementation set on the upgrade beacon, supplying initialization calldata
22    * as a constructor argument. The deployment will revert and pass along the
23    * revert reason in the event that this initialization delegatecall reverts.
24    * @param initializationCalldata Calldata to supply when performing the
25    * initialization delegatecall.
26    */
27   constructor(bytes memory initializationCalldata) public payable {
28     // Delegatecall into the implementation, supplying initialization calldata.
29     (bool ok, ) = _implementation().delegatecall(initializationCalldata);
30     
31     // Revert and include revert data if delegatecall to implementation reverts.
32     if (!ok) {
33       assembly {
34         returndatacopy(0, 0, returndatasize)
35         revert(0, returndatasize)
36       }
37     }
38   }
39 
40   /**
41    * @notice In the fallback, delegate execution to the implementation set on
42    * the upgrade beacon.
43    */
44   function () external payable {
45     // Delegate execution to implementation contract provided by upgrade beacon.
46     _delegate(_implementation());
47   }
48 
49   /**
50    * @notice Private view function to get the current implementation from the
51    * upgrade beacon. This is accomplished via a staticcall to the beacon with no
52    * data, and the beacon will return an abi-encoded implementation address.
53    * @return implementation Address of the implementation.
54    */
55   function _implementation() private view returns (address implementation) {
56     // Get the current implementation address from the upgrade beacon.
57     (bool ok, bytes memory returnData) = _UPGRADE_BEACON.staticcall("");
58     
59     // Revert and pass along revert message if call to upgrade beacon reverts.
60     require(ok, string(returnData));
61 
62     // Set the implementation to the address returned from the upgrade beacon.
63     implementation = abi.decode(returnData, (address));
64   }
65 
66   /**
67    * @notice Private function that delegates execution to an implementation
68    * contract. This is a low level function that doesn't return to its internal
69    * call site. It will return whatever is returned by the implementation to the
70    * external caller, reverting and returning the revert data if implementation
71    * reverts.
72    * @param implementation Address to delegate.
73    */
74   function _delegate(address implementation) private {
75     assembly {
76       // Copy msg.data. We take full control of memory in this inline assembly
77       // block because it will not return to Solidity code. We overwrite the
78       // Solidity scratch pad at memory position 0.
79       calldatacopy(0, 0, calldatasize)
80 
81       // Delegatecall to the implementation, supplying calldata and gas.
82       // Out and outsize are set to zero - instead, use the return buffer.
83       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
84 
85       // Copy the returned data from the return buffer.
86       returndatacopy(0, 0, returndatasize)
87 
88       switch result
89       // Delegatecall returns 0 on error.
90       case 0 { revert(0, returndatasize) }
91       default { return(0, returndatasize) }
92     }
93   }
94 }