1 // SPDX-License-Identifier: GNU-GPL v3.0 or later
2 
3 pragma solidity >=0.8.0;
4 
5 import "./IAddressRegistry.sol";
6 
7 /**
8  * @title Provider interface for Revest FNFTs
9  * @dev
10  *
11  */
12 interface IAddressRegistryV2 is IAddressRegistry {
13 
14         function initialize_with_legacy(
15         address lock_manager_,
16         address liquidity_,
17         address revest_token_,
18         address token_vault_,
19         address legacy_vault_,
20         address revest_,
21         address fnft_,
22         address metadata_,
23         address admin_,
24         address rewards_
25     ) external;
26 
27     function getLegacyTokenVault() external view returns (address legacy);
28 
29     function setLegacyTokenVault(address legacyVault) external;
30 
31     function breakGlass() external;
32 
33     function pauseToken() external;
34 
35     function unpauseToken() external;
36 
37     function modifyPauser(address pauser, bool grant) external;
38 
39     function modifyBreaker(address breaker, bool grant) external;
40 }
