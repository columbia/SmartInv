1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { LibDiamond } from "../Libraries/LibDiamond.sol";
5 
6 /// @title Periphery Registry Facet
7 /// @author LI.FI (https://li.fi)
8 /// @notice A simple registry to track LIFI periphery contracts
9 /// @custom:version 1.0.0
10 contract PeripheryRegistryFacet {
11     /// Storage ///
12 
13     bytes32 internal constant NAMESPACE =
14         keccak256("com.lifi.facets.periphery_registry");
15 
16     /// Types ///
17 
18     struct Storage {
19         mapping(string => address) contracts;
20     }
21 
22     /// Events ///
23 
24     event PeripheryContractRegistered(string name, address contractAddress);
25 
26     /// External Methods ///
27 
28     /// @notice Registers a periphery contract address with a specified name
29     /// @param _name the name to register the contract address under
30     /// @param _contractAddress the address of the contract to register
31     function registerPeripheryContract(
32         string calldata _name,
33         address _contractAddress
34     ) external {
35         LibDiamond.enforceIsContractOwner();
36         Storage storage s = getStorage();
37         s.contracts[_name] = _contractAddress;
38         emit PeripheryContractRegistered(_name, _contractAddress);
39     }
40 
41     /// @notice Returns the registered contract address by its name
42     /// @param _name the registered name of the contract
43     function getPeripheryContract(
44         string calldata _name
45     ) external view returns (address) {
46         return getStorage().contracts[_name];
47     }
48 
49     /// @dev fetch local storage
50     function getStorage() private pure returns (Storage storage s) {
51         bytes32 namespace = NAMESPACE;
52         // solhint-disable-next-line no-inline-assembly
53         assembly {
54             s.slot := namespace
55         }
56     }
57 }
