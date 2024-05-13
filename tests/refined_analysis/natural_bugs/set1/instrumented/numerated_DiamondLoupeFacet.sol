1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { LibDiamond } from "../Libraries/LibDiamond.sol";
5 import { IDiamondLoupe } from "../Interfaces/IDiamondLoupe.sol";
6 import { IERC165 } from "../Interfaces/IERC165.sol";
7 
8 /// @title Diamond Loupe Facet
9 /// @author LI.FI (https://li.fi)
10 /// @notice Core EIP-2535 Facet for inspecting Diamond Proxies.
11 /// @custom:version 1.0.0
12 contract DiamondLoupeFacet is IDiamondLoupe, IERC165 {
13     // Diamond Loupe Functions
14     ////////////////////////////////////////////////////////////////////
15     /// These functions are expected to be called frequently by tools.
16     //
17     // struct Facet {
18     //     address facetAddress;
19     //     bytes4[] functionSelectors;
20     // }
21 
22     /// @notice Gets all facets and their selectors.
23     /// @return facets_ Facet
24     function facets() external view override returns (Facet[] memory facets_) {
25         LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
26         uint256 numFacets = ds.facetAddresses.length;
27         facets_ = new Facet[](numFacets);
28         for (uint256 i = 0; i < numFacets; ) {
29             address facetAddress_ = ds.facetAddresses[i];
30             facets_[i].facetAddress = facetAddress_;
31             facets_[i].functionSelectors = ds
32                 .facetFunctionSelectors[facetAddress_]
33                 .functionSelectors;
34             unchecked {
35                 ++i;
36             }
37         }
38     }
39 
40     /// @notice Gets all the function selectors provided by a facet.
41     /// @param _facet The facet address.
42     /// @return facetFunctionSelectors_
43     function facetFunctionSelectors(
44         address _facet
45     )
46         external
47         view
48         override
49         returns (bytes4[] memory facetFunctionSelectors_)
50     {
51         LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
52         facetFunctionSelectors_ = ds
53             .facetFunctionSelectors[_facet]
54             .functionSelectors;
55     }
56 
57     /// @notice Get all the facet addresses used by a diamond.
58     /// @return facetAddresses_
59     function facetAddresses()
60         external
61         view
62         override
63         returns (address[] memory facetAddresses_)
64     {
65         LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
66         facetAddresses_ = ds.facetAddresses;
67     }
68 
69     /// @notice Gets the facet that supports the given selector.
70     /// @dev If facet is not found return address(0).
71     /// @param _functionSelector The function selector.
72     /// @return facetAddress_ The facet address.
73     function facetAddress(
74         bytes4 _functionSelector
75     ) external view override returns (address facetAddress_) {
76         LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
77         facetAddress_ = ds
78             .selectorToFacetAndPosition[_functionSelector]
79             .facetAddress;
80     }
81 
82     // This implements ERC-165.
83     function supportsInterface(
84         bytes4 _interfaceId
85     ) external view override returns (bool) {
86         LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
87         return ds.supportedInterfaces[_interfaceId];
88     }
89 }
