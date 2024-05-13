1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { LibDiamond } from "../Libraries/LibDiamond.sol";
5 import { LibAccess } from "../Libraries/LibAccess.sol";
6 import { LibAllowList } from "../Libraries/LibAllowList.sol";
7 import { CannotAuthoriseSelf } from "../Errors/GenericErrors.sol";
8 
9 /// @title Dex Manager Facet
10 /// @author LI.FI (https://li.fi)
11 /// @notice Facet contract for managing approved DEXs to be used in swaps.
12 /// @custom:version 1.0.0
13 contract DexManagerFacet {
14     /// Events ///
15 
16     event DexAdded(address indexed dexAddress);
17     event DexRemoved(address indexed dexAddress);
18     event FunctionSignatureApprovalChanged(
19         bytes4 indexed functionSignature,
20         bool indexed approved
21     );
22 
23     /// External Methods ///
24 
25     /// @notice Register the address of a DEX contract to be approved for swapping.
26     /// @param _dex The address of the DEX contract to be approved.
27     function addDex(address _dex) external {
28         if (msg.sender != LibDiamond.contractOwner()) {
29             LibAccess.enforceAccessControl();
30         }
31 
32         if (_dex == address(this)) {
33             revert CannotAuthoriseSelf();
34         }
35 
36         LibAllowList.addAllowedContract(_dex);
37 
38         emit DexAdded(_dex);
39     }
40 
41     /// @notice Batch register the address of DEX contracts to be approved for swapping.
42     /// @param _dexs The addresses of the DEX contracts to be approved.
43     function batchAddDex(address[] calldata _dexs) external {
44         if (msg.sender != LibDiamond.contractOwner()) {
45             LibAccess.enforceAccessControl();
46         }
47         uint256 length = _dexs.length;
48 
49         for (uint256 i = 0; i < length; ) {
50             address dex = _dexs[i];
51             if (dex == address(this)) {
52                 revert CannotAuthoriseSelf();
53             }
54             if (LibAllowList.contractIsAllowed(dex)) continue;
55             LibAllowList.addAllowedContract(dex);
56             emit DexAdded(dex);
57             unchecked {
58                 ++i;
59             }
60         }
61     }
62 
63     /// @notice Unregister the address of a DEX contract approved for swapping.
64     /// @param _dex The address of the DEX contract to be unregistered.
65     function removeDex(address _dex) external {
66         if (msg.sender != LibDiamond.contractOwner()) {
67             LibAccess.enforceAccessControl();
68         }
69         LibAllowList.removeAllowedContract(_dex);
70         emit DexRemoved(_dex);
71     }
72 
73     /// @notice Batch unregister the addresses of DEX contracts approved for swapping.
74     /// @param _dexs The addresses of the DEX contracts to be unregistered.
75     function batchRemoveDex(address[] calldata _dexs) external {
76         if (msg.sender != LibDiamond.contractOwner()) {
77             LibAccess.enforceAccessControl();
78         }
79         uint256 length = _dexs.length;
80         for (uint256 i = 0; i < length; ) {
81             LibAllowList.removeAllowedContract(_dexs[i]);
82             emit DexRemoved(_dexs[i]);
83             unchecked {
84                 ++i;
85             }
86         }
87     }
88 
89     /// @notice Adds/removes a specific function signature to/from the allowlist
90     /// @param _signature the function signature to allow/disallow
91     /// @param _approval whether the function signature should be allowed
92     function setFunctionApprovalBySignature(
93         bytes4 _signature,
94         bool _approval
95     ) external {
96         if (msg.sender != LibDiamond.contractOwner()) {
97             LibAccess.enforceAccessControl();
98         }
99 
100         if (_approval) {
101             LibAllowList.addAllowedSelector(_signature);
102         } else {
103             LibAllowList.removeAllowedSelector(_signature);
104         }
105 
106         emit FunctionSignatureApprovalChanged(_signature, _approval);
107     }
108 
109     /// @notice Batch Adds/removes a specific function signature to/from the allowlist
110     /// @param _signatures the function signatures to allow/disallow
111     /// @param _approval whether the function signatures should be allowed
112     function batchSetFunctionApprovalBySignature(
113         bytes4[] calldata _signatures,
114         bool _approval
115     ) external {
116         if (msg.sender != LibDiamond.contractOwner()) {
117             LibAccess.enforceAccessControl();
118         }
119         uint256 length = _signatures.length;
120         for (uint256 i = 0; i < length; ) {
121             bytes4 _signature = _signatures[i];
122             if (_approval) {
123                 LibAllowList.addAllowedSelector(_signature);
124             } else {
125                 LibAllowList.removeAllowedSelector(_signature);
126             }
127             emit FunctionSignatureApprovalChanged(_signature, _approval);
128             unchecked {
129                 ++i;
130             }
131         }
132     }
133 
134     /// @notice Returns whether a function signature is approved
135     /// @param _signature the function signature to query
136     /// @return approved Approved or not
137     function isFunctionApproved(
138         bytes4 _signature
139     ) public view returns (bool approved) {
140         return LibAllowList.selectorIsAllowed(_signature);
141     }
142 
143     /// @notice Returns a list of all approved DEX addresses.
144     /// @return addresses List of approved DEX addresses
145     function approvedDexs()
146         external
147         view
148         returns (address[] memory addresses)
149     {
150         return LibAllowList.getAllowedContracts();
151     }
152 }
