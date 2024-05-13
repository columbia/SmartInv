1 // SPDX-License-Identifier: GNU-GPL v3.0 or later
2 
3 pragma solidity ^0.8.0;
4 
5 import "@openzeppelin/contracts/access/Ownable.sol";
6 import "../interfaces/IAddressRegistry.sol";
7 import "../interfaces/ILockManager.sol";
8 import "../interfaces/IRewardsHandler.sol";
9 import "../interfaces/ITokenVault.sol";
10 import "../interfaces/IRevestToken.sol";
11 import "../interfaces/IFNFTHandler.sol";
12 import "../lib/uniswap/IUniswapV2Factory.sol";
13 import "../interfaces/IInterestHandler.sol";
14 
15 
16 contract RevestAccessControl is Ownable {
17     IAddressRegistry internal addressesProvider;
18     address addressProvider;
19 
20     constructor(address provider) Ownable() {
21         addressesProvider = IAddressRegistry(provider);
22         addressProvider = provider;
23     }
24 
25     modifier onlyRevest() {
26         require(_msgSender() != address(0), "E004");
27         require(
28                 _msgSender() == addressesProvider.getLockManager() ||
29                 _msgSender() == addressesProvider.getRewardsHandler() ||
30                 _msgSender() == addressesProvider.getTokenVault() ||
31                 _msgSender() == addressesProvider.getRevest() ||
32                 _msgSender() == addressesProvider.getRevestToken(),
33             "E016"
34         );
35         _;
36     }
37 
38     modifier onlyRevestController() {
39         require(_msgSender() != address(0), "E004");
40         require(_msgSender() == addressesProvider.getRevest(), "E017");
41         _;
42     }
43 
44     modifier onlyTokenVault() {
45         require(_msgSender() != address(0), "E004");
46         require(_msgSender() == addressesProvider.getTokenVault(), "E017");
47         _;
48     }
49 
50     function setAddressRegistry(address registry) external onlyOwner {
51         addressesProvider = IAddressRegistry(registry);
52     }
53 
54     function getAdmin() internal view returns (address) {
55         return addressesProvider.getAdmin();
56     }
57 
58     function getRevest() internal view returns (IRevest) {
59         return IRevest(addressesProvider.getRevest());
60     }
61 
62     function getRevestToken() internal view returns (IRevestToken) {
63         return IRevestToken(addressesProvider.getRevestToken());
64     }
65 
66     function getLockManager() internal view returns (ILockManager) {
67         return ILockManager(addressesProvider.getLockManager());
68     }
69 
70     function getTokenVault() internal view returns (ITokenVault) {
71         return ITokenVault(addressesProvider.getTokenVault());
72     }
73 
74     function getUniswapV2() internal view returns (IUniswapV2Factory) {
75         return IUniswapV2Factory(addressesProvider.getDEX(0));
76     }
77 
78     function getFNFTHandler() internal view returns (IFNFTHandler) {
79         return IFNFTHandler(addressesProvider.getRevestFNFT());
80     }
81 
82     function getRewardsHandler() internal view returns (IRewardsHandler) {
83         return IRewardsHandler(addressesProvider.getRewardsHandler());
84     }
85 }
