1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { IDiamondCut } from "../Interfaces/IDiamondCut.sol";
5 import { LibDiamond } from "../Libraries/LibDiamond.sol";
6 
7 /// @title Diamond Cut Facet
8 /// @author LI.FI (https://li.fi)
9 /// @notice Core EIP-2535 Facet for upgrading Diamond Proxies.
10 /// @custom:version 1.0.0
11 contract DiamondCutFacet is IDiamondCut {
12     /// @notice Add/replace/remove any number of functions and optionally execute
13     ///         a function with delegatecall
14     /// @param _diamondCut Contains the facet addresses and function selectors
15     /// @param _init The address of the contract or facet to execute _calldata
16     /// @param _calldata A function call, including function selector and arguments
17     ///                  _calldata is executed with delegatecall on _init
18     function diamondCut(
19         FacetCut[] calldata _diamondCut,
20         address _init,
21         bytes calldata _calldata
22     ) external override {
23         LibDiamond.enforceIsContractOwner();
24         LibDiamond.diamondCut(_diamondCut, _init, _calldata);
25     }
26 }
