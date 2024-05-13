1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { LibDiamond } from "../Libraries/LibDiamond.sol";
5 
6 /// @title Standardized Call Facet
7 /// @author LIFI https://li.finance ed@li.finance
8 /// @notice Allows calling different facet methods through a single standardized entrypoint
9 /// @custom:version 1.0.0
10 contract StandardizedCallFacet {
11     /// External Methods ///
12 
13     /// @notice Make a standardized call to a facet
14     /// @param callData The calldata to forward to the facet
15     function standardizedCall(bytes memory callData) external payable {
16         // Fetch the facetAddress from the dimaond's internal storage
17         // Cheaper than calling the external facetAddress(selector) method directly
18         LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
19         address facetAddress = ds
20             .selectorToFacetAndPosition[bytes4(callData)]
21             .facetAddress;
22 
23         if (facetAddress == address(0)) {
24             revert LibDiamond.FunctionDoesNotExist();
25         }
26 
27         // Execute external function from facet using delegatecall and return any value.
28         // solhint-disable-next-line no-inline-assembly
29         assembly {
30             // execute function call using the facet
31             let result := delegatecall(
32                 gas(),
33                 facetAddress,
34                 add(callData, 0x20),
35                 mload(callData),
36                 0,
37                 0
38             )
39             // get any return value
40             returndatacopy(0, 0, returndatasize())
41             // return any return value or error back to the caller
42             switch result
43             case 0 {
44                 revert(0, returndatasize())
45             }
46             default {
47                 return(0, returndatasize())
48             }
49         }
50     }
51 }
