1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity 0.8.6;
3 import "@yield-protocol/vault-interfaces/ICauldron.sol";
4 import "@yield-protocol/vault-interfaces/DataTypes.sol";
5 import "./interfaces/IConvexYieldWrapper.sol";
6 import "../../LadleStorage.sol";
7 
8 /// @title Convex Ladle Module to handle vault addition
9 contract ConvexModule is LadleStorage {
10     constructor(ICauldron cauldron_, IWETH9 weth_) LadleStorage(cauldron_, weth_) {}
11 
12     /// @notice Adds a vault to the user's vault list in the convex wrapper
13     /// @param convexStakingWrapper The address of the convex wrapper to which the vault will be added
14     /// @param vaultId The vaulId to be added
15     function addVault(IConvexYieldWrapper convexStakingWrapper, bytes12 vaultId) external {
16         if (vaultId == bytes12(0)) {
17             convexStakingWrapper.addVault(cachedVaultId);
18         } else {
19             convexStakingWrapper.addVault(vaultId);
20         }
21     }
22 
23     /// @notice Removes a vault from the user's vault list in the convex wrapper
24     /// @param convexStakingWrapper The address of the convex wrapper from which the vault will be removed
25     /// @param vaultId The vaulId to be removed
26     /// @param account The address of the user from whose list the vault is to be removed
27     function removeVault(
28         IConvexYieldWrapper convexStakingWrapper,
29         bytes12 vaultId,
30         address account
31     ) external {
32         convexStakingWrapper.removeVault(vaultId, account);
33     }
34 }
