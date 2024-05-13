1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { LibDiamond } from "./Libraries/LibDiamond.sol";
5 import { IDiamondCut } from "./Interfaces/IDiamondCut.sol";
6 import { LibUtil } from "./Libraries/LibUtil.sol";
7 
8 /// @title LIFI Diamond Immutable
9 /// @author LI.FI (https://li.fi)
10 /// @notice (Immutable) Base EIP-2535 Diamond Proxy Contract.
11 /// @custom:version 1.0.0
12 contract LiFiDiamondImmutable {
13     constructor(address _contractOwner, address _diamondCutFacet) payable {
14         LibDiamond.setContractOwner(_contractOwner);
15 
16         // Add the diamondCut external function from the diamondCutFacet
17         IDiamondCut.FacetCut[] memory cut = new IDiamondCut.FacetCut[](1);
18         bytes4[] memory functionSelectors = new bytes4[](1);
19         functionSelectors[0] = IDiamondCut.diamondCut.selector;
20         cut[0] = IDiamondCut.FacetCut({
21             facetAddress: _diamondCutFacet,
22             action: IDiamondCut.FacetCutAction.Add,
23             functionSelectors: functionSelectors
24         });
25         LibDiamond.diamondCut(cut, address(0), "");
26     }
27 
28     // Find facet for function that is called and execute the
29     // function if a facet is found and return any value.
30     // solhint-disable-next-line no-complex-fallback
31     fallback() external payable {
32         LibDiamond.DiamondStorage storage ds;
33         bytes32 position = LibDiamond.DIAMOND_STORAGE_POSITION;
34 
35         // get diamond storage
36         // solhint-disable-next-line no-inline-assembly
37         assembly {
38             ds.slot := position
39         }
40 
41         // get facet from function selector
42         address facet = ds.selectorToFacetAndPosition[msg.sig].facetAddress;
43 
44         if (facet == address(0)) {
45             revert LibDiamond.FunctionDoesNotExist();
46         }
47 
48         // Execute external function from facet using delegatecall and return any value.
49         // solhint-disable-next-line no-inline-assembly
50         assembly {
51             // copy function selector and any arguments
52             calldatacopy(0, 0, calldatasize())
53             // execute function call using the facet
54             let result := delegatecall(gas(), facet, 0, calldatasize(), 0, 0)
55             // get any return value
56             returndatacopy(0, 0, returndatasize())
57             // return any return value or error back to the caller
58             switch result
59             case 0 {
60                 revert(0, returndatasize())
61             }
62             default {
63                 return(0, returndatasize())
64             }
65         }
66     }
67 
68     // Able to receive ether
69     // solhint-disable-next-line no-empty-blocks
70     receive() external payable {}
71 }
