1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { LibDiamond } from "../Libraries/LibDiamond.sol";
5 
6 /// @title Non Standard Selectors Registry Facet
7 /// @author LIFI (https://li.finance)
8 /// @notice Registry for non-standard selectors
9 /// @custom:version 1.0.0
10 contract NonStandardSelectorsRegistryFacet {
11     // Storage //
12     bytes32 internal constant NAMESPACE =
13         keccak256("com.lifi.facets.nonstandardselectorsregistry");
14 
15     // Types //
16     struct Storage {
17         mapping(bytes4 => bool) selectors;
18     }
19 
20     // @notice set a selector as non-standard
21     // @param _selector the selector to set
22     // @param _isNonStandardSelector whether the selector is non-standard
23     function setNonStandardSelector(
24         bytes4 _selector,
25         bool _isNonStandardSelector
26     ) external {
27         LibDiamond.enforceIsContractOwner();
28         Storage storage s = getStorage();
29         s.selectors[_selector] = _isNonStandardSelector;
30     }
31 
32     // @notice batch set selectors as non-standard
33     // @param _selectors the selectors to set
34     // @param _isNonStandardSelectors whether the selectors are non-standard
35     function batchSetNonStandardSelectors(
36         bytes4[] calldata _selectors,
37         bool[] calldata _isNonStandardSelectors
38     ) external {
39         LibDiamond.enforceIsContractOwner();
40         Storage storage s = getStorage();
41         require(
42             _selectors.length == _isNonStandardSelectors.length,
43             "NonStandardSelectorsRegistryFacet: selectors and isNonStandardSelectors length mismatch"
44         );
45         for (uint256 i = 0; i < _selectors.length; i++) {
46             s.selectors[_selectors[i]] = _isNonStandardSelectors[i];
47         }
48     }
49 
50     // @notice check if a selector is non-standard
51     // @param _selector the selector to check
52     // @return whether the selector is non-standard
53     function isNonStandardSelector(
54         bytes4 _selector
55     ) external view returns (bool) {
56         return getStorage().selectors[_selector];
57     }
58 
59     // Internal Functions //
60 
61     // @notice get the storage slot for the NonStandardSelectorsRegistry
62     function getStorage() internal pure returns (Storage storage s) {
63         bytes32 position = NAMESPACE;
64         assembly {
65             s.slot := position
66         }
67     }
68 }
