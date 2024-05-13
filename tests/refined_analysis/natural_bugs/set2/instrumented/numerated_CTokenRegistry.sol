1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.9;
3 
4 import "../../../../interfaces/vendor/CToken.sol";
5 import "../../../../interfaces/vendor/Comptroller.sol";
6 import "../../../../libraries/Errors.sol";
7 
8 contract CTokenRegistry {
9     Comptroller public immutable comptroller;
10 
11     address public constant COMPTROLLER_MAINNET_ADDRESS =
12         address(0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B);
13 
14     mapping(address => address) internal _underlyingToCToken;
15 
16     constructor(address comptrollerAddress) {
17         comptroller = Comptroller(comptrollerAddress);
18         _updateCTokenMapping();
19     }
20 
21     /**
22      * @notice Tries to read the CToken contract address for a given underlying token address
23      * If not found, tries to fetch it from the Comptroller contract and fails if
24      * cannot find it in the comptroller either
25      */
26     function fetchCToken(address underlying) external returns (CToken) {
27         CToken ctoken = getCToken(underlying, false);
28         if (address(ctoken) != address(0)) {
29             return CToken(ctoken);
30         }
31 
32         _updateCTokenMapping();
33         return getCToken(underlying, true);
34     }
35 
36     /**
37      * @notice Reads the CToken contract address for a given underlying token address
38      * or fails if not found
39      */
40     function getCToken(address underlying) external view returns (CToken) {
41         return getCToken(underlying, true);
42     }
43 
44     /**
45      * @notice Reads the CToken contract address for a given underlying token address
46      * If `ensureExists` is `true`, fails if not found, otherwise returns address 0
47      */
48     function getCToken(address underlying, bool ensureExists) public view returns (CToken) {
49         CToken ctoken = CToken(_underlyingToCToken[underlying]);
50         if (ensureExists && (address(ctoken) == address(0) || !_isCTokenUsable(ctoken))) {
51             revert(Error.UNDERLYING_NOT_SUPPORTED);
52         }
53         return ctoken;
54     }
55 
56     /**
57      * @dev Updates the CToken mapping by fetching information from the Comptroller contract
58      */
59     function _updateCTokenMapping() internal {
60         CToken[] memory ctokens = comptroller.getAllMarkets();
61         for (uint256 i = 0; i < ctokens.length; i++) {
62             CToken ctoken = ctokens[i];
63             if (!_isCTokenUsable(ctoken)) {
64                 continue;
65             }
66             if (
67                 keccak256(abi.encodePacked(ctoken.symbol())) == keccak256(abi.encodePacked("cETH"))
68             ) {
69                 _underlyingToCToken[address(0)] = address(ctoken);
70             } else {
71                 _underlyingToCToken[ctoken.underlying()] = address(ctoken);
72             }
73         }
74     }
75 
76     function _isCTokenUsable(CToken ctoken) internal view returns (bool) {
77         (bool listed, , ) = comptroller.markets(address(ctoken));
78         // NOTE: comptroller.isDeprecated is not available on Kovan
79         bool deprecated = address(comptroller) == COMPTROLLER_MAINNET_ADDRESS &&
80             comptroller.isDeprecated(ctoken);
81         return listed && !deprecated;
82     }
83 }
