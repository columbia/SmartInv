1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.7.6;
3 pragma experimental ABIEncoderV2;
4 
5 /******************************************************************************\
6 * Authors: Nick Mudge (https://twitter.com/mudgen)
7 *
8 * Implementation of a diamond.
9 /******************************************************************************/
10 
11 import {LibDiamond} from "../libraries/LibDiamond.sol";
12 import {DiamondCutFacet} from "./diamond/DiamondCutFacet.sol";
13 import {DiamondLoupeFacet} from "./diamond/DiamondLoupeFacet.sol";
14 import {OwnershipFacet} from "./diamond/OwnershipFacet.sol";
15 import {AppStorage} from "./AppStorage.sol";
16 import {IERC165} from "../interfaces/IERC165.sol";
17 import {IDiamondCut} from "../interfaces/IDiamondCut.sol";
18 import {IDiamondLoupe} from "../interfaces/IDiamondLoupe.sol";
19 
20 contract Diamond {
21     AppStorage internal s;
22 
23     receive() external payable {}
24 
25     constructor(address _contractOwner) {
26         LibDiamond.setContractOwner(_contractOwner);
27         LibDiamond.addDiamondFunctions(
28             address(new DiamondCutFacet()),
29             address(new DiamondLoupeFacet())
30         );
31     }
32 
33     // Find facet for function that is called and execute the
34     // function if a facet is found and return any value.
35     fallback() external payable {
36         LibDiamond.DiamondStorage storage ds;
37         bytes32 position = LibDiamond.DIAMOND_STORAGE_POSITION;
38         assembly {
39             ds.slot := position
40         }
41         address facet = ds.selectorToFacetAndPosition[msg.sig].facetAddress;
42         require(facet != address(0), "Diamond: Function does not exist");
43         assembly {
44             calldatacopy(0, 0, calldatasize())
45             let result := delegatecall(gas(), facet, 0, calldatasize(), 0, 0)
46             returndatacopy(0, 0, returndatasize())
47             switch result
48                 case 0 {
49                     revert(0, returndatasize())
50                 }
51                 default {
52                     return(0, returndatasize())
53                 }
54         }
55     }
56 }
