1 // SPDX-License-Identifier: GNU-GPL v3.0 or later
2 
3 pragma solidity >=0.8.0;
4 
5 /**
6  * @title Provider interface for Revest FNFTs
7  * @dev
8  *
9  */
10 interface IAddressRegistry {
11 
12     function initialize(
13         address lock_manager_,
14         address liquidity_,
15         address revest_token_,
16         address token_vault_,
17         address revest_,
18         address fnft_,
19         address metadata_,
20         address admin_,
21         address rewards_
22     ) external;
23 
24     function getAdmin() external view returns (address);
25 
26     function setAdmin(address admin) external;
27 
28     function getLockManager() external view returns (address);
29 
30     function setLockManager(address manager) external;
31 
32     function getTokenVault() external view returns (address);
33 
34     function setTokenVault(address vault) external;
35 
36     function getRevestFNFT() external view returns (address);
37 
38     function setRevestFNFT(address fnft) external;
39 
40     function getMetadataHandler() external view returns (address);
41 
42     function setMetadataHandler(address metadata) external;
43 
44     function getRevest() external view returns (address);
45 
46     function setRevest(address revest) external;
47 
48     function getDEX(uint index) external view returns (address);
49 
50     function setDex(address dex) external;
51 
52     function getRevestToken() external view returns (address);
53 
54     function setRevestToken(address token) external;
55 
56     function getRewardsHandler() external view returns(address);
57 
58     function setRewardsHandler(address esc) external;
59 
60     function getAddress(bytes32 id) external view returns (address);
61 
62     function getLPs() external view returns (address);
63 
64     function setLPs(address liquidToken) external;
65 
66 }
