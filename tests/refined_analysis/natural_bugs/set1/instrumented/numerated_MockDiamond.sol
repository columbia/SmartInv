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
12 import {DiamondCutFacet} from "../beanstalk/diamond/DiamondCutFacet.sol";
13 import {DiamondLoupeFacet} from "../beanstalk/diamond/DiamondLoupeFacet.sol";
14 import {AppStorage} from "../beanstalk/AppStorage.sol";
15 import {IERC165} from "../interfaces/IERC165.sol";
16 import {IDiamondCut} from "../interfaces/IDiamondCut.sol";
17 import {IDiamondLoupe} from "../interfaces/IDiamondLoupe.sol";
18 
19 contract MockDiamond {
20     AppStorage internal s;
21 
22     receive() external payable {}
23 
24     function mockInit(address _contractOwner) external {
25         LibDiamond.setContractOwner(_contractOwner);
26         LibDiamond.addDiamondFunctions(
27             address(new DiamondCutFacet()),
28             address(new DiamondLoupeFacet())
29         );
30     }
31 
32     // Find facet for function that is called and execute the
33     // function if a facet is found and return any value.
34     fallback() external payable {
35         LibDiamond.DiamondStorage storage ds;
36         bytes32 position = LibDiamond.DIAMOND_STORAGE_POSITION;
37         assembly {
38             ds.slot := position
39         }
40         address facet = ds.selectorToFacetAndPosition[msg.sig].facetAddress;
41         require(facet != address(0), "Diamond: Function does not exist");
42         assembly {
43             calldatacopy(0, 0, calldatasize())
44             let result := delegatecall(gas(), facet, 0, calldatasize(), 0, 0)
45             returndatacopy(0, 0, returndatasize())
46             switch result
47             case 0 {
48                 revert(0, returndatasize())
49             }
50             default {
51                 return(0, returndatasize())
52             }
53         }
54     }
55 }
