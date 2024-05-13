1 // SPDX-License-Identifier: MIT
2 pragma experimental ABIEncoderV2;
3 pragma solidity =0.7.6;
4 /******************************************************************************\
5 * Author: Nick Mudge <nick@perfectabstractions.com> (https://twitter.com/mudgen)
6 /******************************************************************************/
7 
8 interface IDiamondCut {
9     enum FacetCutAction {Add, Replace, Remove}
10 
11     struct FacetCut {
12         address facetAddress;
13         FacetCutAction action;
14         bytes4[] functionSelectors;
15     }
16 
17     /// @notice Add/replace/remove any number of functions and optionally execute
18     ///         a function with delegatecall
19     /// @param _diamondCut Contains the facet addresses and function selectors
20     /// @param _init The address of the contract or facet to execute _calldata
21     /// @param _calldata A function call, including function selector and arguments
22     ///                  _calldata is executed with delegatecall on _init
23     function diamondCut(
24         FacetCut[] calldata _diamondCut,
25         address _init,
26         bytes calldata _calldata
27     ) external;
28 
29     event DiamondCut(FacetCut[] _diamondCut, address _init, bytes _calldata);
30 }
