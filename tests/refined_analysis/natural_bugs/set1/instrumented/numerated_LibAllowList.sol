1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { InvalidContract } from "../Errors/GenericErrors.sol";
5 
6 /// @title Lib Allow List
7 /// @author LI.FI (https://li.fi)
8 /// @notice Library for managing and accessing the conract address allow list
9 library LibAllowList {
10     /// Storage ///
11     bytes32 internal constant NAMESPACE =
12         keccak256("com.lifi.library.allow.list");
13 
14     struct AllowListStorage {
15         mapping(address => bool) allowlist;
16         mapping(bytes4 => bool) selectorAllowList;
17         address[] contracts;
18     }
19 
20     /// @dev Adds a contract address to the allow list
21     /// @param _contract the contract address to add
22     function addAllowedContract(address _contract) internal {
23         _checkAddress(_contract);
24 
25         AllowListStorage storage als = _getStorage();
26 
27         if (als.allowlist[_contract]) return;
28 
29         als.allowlist[_contract] = true;
30         als.contracts.push(_contract);
31     }
32 
33     /// @dev Checks whether a contract address has been added to the allow list
34     /// @param _contract the contract address to check
35     function contractIsAllowed(
36         address _contract
37     ) internal view returns (bool) {
38         return _getStorage().allowlist[_contract];
39     }
40 
41     /// @dev Remove a contract address from the allow list
42     /// @param _contract the contract address to remove
43     function removeAllowedContract(address _contract) internal {
44         AllowListStorage storage als = _getStorage();
45 
46         if (!als.allowlist[_contract]) {
47             return;
48         }
49 
50         als.allowlist[_contract] = false;
51 
52         uint256 length = als.contracts.length;
53         // Find the contract in the list
54         for (uint256 i = 0; i < length; i++) {
55             if (als.contracts[i] == _contract) {
56                 // Move the last element into the place to delete
57                 als.contracts[i] = als.contracts[length - 1];
58                 // Remove the last element
59                 als.contracts.pop();
60                 break;
61             }
62         }
63     }
64 
65     /// @dev Fetch contract addresses from the allow list
66     function getAllowedContracts() internal view returns (address[] memory) {
67         return _getStorage().contracts;
68     }
69 
70     /// @dev Add a selector to the allow list
71     /// @param _selector the selector to add
72     function addAllowedSelector(bytes4 _selector) internal {
73         _getStorage().selectorAllowList[_selector] = true;
74     }
75 
76     /// @dev Removes a selector from the allow list
77     /// @param _selector the selector to remove
78     function removeAllowedSelector(bytes4 _selector) internal {
79         _getStorage().selectorAllowList[_selector] = false;
80     }
81 
82     /// @dev Returns if selector has been added to the allow list
83     /// @param _selector the selector to check
84     function selectorIsAllowed(bytes4 _selector) internal view returns (bool) {
85         return _getStorage().selectorAllowList[_selector];
86     }
87 
88     /// @dev Fetch local storage struct
89     function _getStorage()
90         internal
91         pure
92         returns (AllowListStorage storage als)
93     {
94         bytes32 position = NAMESPACE;
95         // solhint-disable-next-line no-inline-assembly
96         assembly {
97             als.slot := position
98         }
99     }
100 
101     /// @dev Contains business logic for validating a contract address.
102     /// @param _contract address of the dex to check
103     function _checkAddress(address _contract) private view {
104         if (_contract == address(0)) revert InvalidContract();
105 
106         if (_contract.code.length == 0) revert InvalidContract();
107     }
108 }
