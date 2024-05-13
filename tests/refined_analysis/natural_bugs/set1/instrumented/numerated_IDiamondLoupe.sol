1 // SPDX-License-Identifier: MIT
2 pragma experimental ABIEncoderV2;
3 pragma solidity =0.7.6;
4 // A loupe is a small magnifying glass used to look at diamonds.
5 // These functions look at diamonds
6 interface IDiamondLoupe {
7     /// These functions are expected to be called frequently
8     /// by tools.
9 
10     struct Facet {
11         address facetAddress;
12         bytes4[] functionSelectors;
13     }
14 
15     /// @notice Gets all facet addresses and their four byte function selectors.
16     /// @return facets_ Facet
17     function facets() external view returns (Facet[] memory facets_);
18 
19     /// @notice Gets all the function selectors supported by a specific facet.
20     /// @param _facet The facet address.
21     /// @return facetFunctionSelectors_
22     function facetFunctionSelectors(address _facet) external view returns (bytes4[] memory facetFunctionSelectors_);
23 
24     /// @notice Get all the facet addresses used by a diamond.
25     /// @return facetAddresses_
26     function facetAddresses() external view returns (address[] memory facetAddresses_);
27 
28     /// @notice Gets the facet that supports the given selector.
29     /// @dev If facet is not found return address(0).
30     /// @param _functionSelector The function selector.
31     /// @return facetAddress_ The facet address.
32     function facetAddress(bytes4 _functionSelector) external view returns (address facetAddress_);
33 }
