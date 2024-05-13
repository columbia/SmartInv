1 pragma solidity ^0.8.0;
2 
3 import "../refs/CoreRef.sol";
4 import "../external/fuse/Unitroller.sol";
5 
6 /// @title a Fuse pause and borrow cap guardian used to expand access control to more Fei roles
7 /// @author joeysantoro
8 contract FuseGuardian is CoreRef {
9     /// @notice the fuse comptroller
10     Unitroller public immutable comptroller;
11 
12     /// @param _core address of core contract
13     /// @param _comptroller the fuse comptroller
14     constructor(address _core, Unitroller _comptroller) CoreRef(_core) {
15         comptroller = _comptroller;
16         /// @notice The reason we are reusing the tribal chief admin role is it consolidates control in the OA,
17         /// and means we don't have to do another governance action to create this role in core
18         _setContractAdminRole(keccak256("FUSE_ADMIN"));
19     }
20 
21     // ************ BORROW GUARDIAN FUNCTIONS ************
22     /**
23      * @notice Set the given supply caps for the given cToken markets. Supplying that brings total underlying supply to or above supply cap will revert.
24      * @dev Admin or borrowCapGuardian function to set the supply caps. A supply cap of 0 corresponds to unlimited supplying.
25      * @param cTokens The addresses of the markets (tokens) to change the supply caps for
26      * @param newSupplyCaps The new supply cap values in underlying to be set. A value of 0 corresponds to unlimited supplying.
27      */
28     function _setMarketSupplyCaps(CToken[] memory cTokens, uint256[] calldata newSupplyCaps)
29         external
30         isGovernorOrGuardianOrAdmin
31     {
32         _setMarketSupplyCapsInternal(cTokens, newSupplyCaps);
33     }
34 
35     function _setMarketSupplyCapsByUnderlying(address[] calldata underlyings, uint256[] calldata newSupplyCaps)
36         external
37         isGovernorOrGuardianOrAdmin
38     {
39         _setMarketSupplyCapsInternal(_underlyingToCTokens(underlyings), newSupplyCaps);
40     }
41 
42     function _setMarketSupplyCapsInternal(CToken[] memory cTokens, uint256[] calldata newSupplyCaps) internal {
43         comptroller._setMarketSupplyCaps(cTokens, newSupplyCaps);
44     }
45 
46     function _underlyingToCTokens(address[] calldata underlyings) internal view returns (CToken[] memory) {
47         CToken[] memory cTokens = new CToken[](underlyings.length);
48         for (uint256 i = 0; i < underlyings.length; i++) {
49             address cToken = comptroller.cTokensByUnderlying(underlyings[i]);
50             require(cToken != address(0), "cToken doesn't exist");
51             cTokens[i] = CToken(cToken);
52         }
53         return cTokens;
54     }
55 
56     /**
57      * @notice Set the given borrow caps for the given cToken markets. Borrowing that brings total borrows to or above borrow cap will revert.
58      * @dev Admin or borrowCapGuardian function to set the borrow caps. A borrow cap of 0 corresponds to unlimited borrowing.
59      * @param cTokens The addresses of the markets (tokens) to change the borrow caps for
60      * @param newBorrowCaps The new borrow cap values in underlying to be set. A value of 0 corresponds to unlimited borrowing.
61      */
62     function _setMarketBorrowCaps(CToken[] memory cTokens, uint256[] calldata newBorrowCaps)
63         external
64         isGovernorOrGuardianOrAdmin
65     {
66         _setMarketBorrowCapsInternal(cTokens, newBorrowCaps);
67     }
68 
69     function _setMarketBorrowCapsInternal(CToken[] memory cTokens, uint256[] calldata newBorrowCaps) internal {
70         comptroller._setMarketBorrowCaps(cTokens, newBorrowCaps);
71     }
72 
73     function _setMarketBorrowCapsByUnderlying(address[] calldata underlyings, uint256[] calldata newBorrowCaps)
74         external
75         isGovernorOrGuardianOrAdmin
76     {
77         _setMarketBorrowCapsInternal(_underlyingToCTokens(underlyings), newBorrowCaps);
78     }
79 
80     /**
81      * @notice Admin function to change the Borrow Cap Guardian
82      * @param newBorrowCapGuardian The address of the new Borrow Cap Guardian
83      */
84     function _setBorrowCapGuardian(address newBorrowCapGuardian) external onlyGovernor {
85         comptroller._setBorrowCapGuardian(newBorrowCapGuardian);
86     }
87 
88     // ************ PAUSE GUARDIAN FUNCTIONS ************
89     /**
90      * @notice Admin function to change the Pause Guardian
91      * @param newPauseGuardian The address of the new Pause Guardian
92      * @return uint 0=success, otherwise a failure. (See enum Error for details)
93      */
94     function _setPauseGuardian(address newPauseGuardian) external onlyGovernor returns (uint256) {
95         return comptroller._setPauseGuardian(newPauseGuardian);
96     }
97 
98     function _setMintPausedByUnderlying(address underlying, bool state)
99         external
100         isGovernorOrGuardianOrAdmin
101         returns (bool)
102     {
103         address cToken = comptroller.cTokensByUnderlying(underlying);
104         require(cToken != address(0), "cToken doesn't exist");
105         _setMintPausedInternal(CToken(cToken), state);
106     }
107 
108     function _setMintPaused(CToken cToken, bool state) external isGovernorOrGuardianOrAdmin returns (bool) {
109         return _setMintPausedInternal(cToken, state);
110     }
111 
112     function _setMintPausedInternal(CToken cToken, bool state) internal returns (bool) {
113         return comptroller._setMintPaused(cToken, state);
114     }
115 
116     function _setBorrowPausedByUnderlying(address underlying, bool state)
117         external
118         isGovernorOrGuardianOrAdmin
119         returns (bool)
120     {
121         address cToken = comptroller.cTokensByUnderlying(underlying);
122         require(cToken != address(0), "cToken doesn't exist");
123         return _setBorrowPausedInternal(CToken(cToken), state);
124     }
125 
126     function _setBorrowPausedInternal(CToken cToken, bool state) internal returns (bool) {
127         return comptroller._setBorrowPaused(cToken, state);
128     }
129 
130     function _setBorrowPaused(CToken cToken, bool state) external isGovernorOrGuardianOrAdmin returns (bool) {
131         _setBorrowPausedInternal(CToken(cToken), state);
132     }
133 
134     function _setTransferPaused(bool state) external isGovernorOrGuardianOrAdmin returns (bool) {
135         return comptroller._setTransferPaused(state);
136     }
137 
138     function _setSeizePaused(bool state) external isGovernorOrGuardianOrAdmin returns (bool) {
139         return comptroller._setSeizePaused(state);
140     }
141 }
