1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity 0.8.6;
3 
4 interface IConvexYieldWrapper {
5     function addVault(bytes12 vault_) external;
6 
7     function removeVault(bytes12 vaultId_, address account_) external;
8 }
