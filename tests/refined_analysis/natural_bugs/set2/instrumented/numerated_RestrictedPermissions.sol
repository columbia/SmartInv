1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "./IPermissionsRead.sol";
5 
6 /** 
7   @title Restricted Permissions module
8   @author Fei Protocol
9   @notice this contract is used to deprecate certain roles irrevocably on a contract.
10   Particularly, the burner, pcv controller, and governor all revert when called.
11 
12   To use, call setCore on the target contract and set to RestrictedPermissions. By revoking the governor, a new Core cannot be set.
13   This enforces that onlyGovernor, onlyBurner, and onlyPCVController actions are irrevocably disabled.
14 
15   The mint and guardian rolls pass through to the immutably referenced core contract.
16 
17   @dev IMPORTANT: fei() and tribe() calls normally present on Core are not used here, so this contract only works for contracts that don't rely on them.
18 */
19 contract RestrictedPermissions is IPermissionsRead {
20     /// @notice passthrough core to reference
21     IPermissionsRead public immutable core;
22 
23     constructor(IPermissionsRead _core) {
24         core = _core;
25     }
26 
27     /// @notice checks if address is a minter
28     /// @param _address address to check
29     /// @return true _address is a minter
30     function isMinter(address _address) external view override returns (bool) {
31         return core.isMinter(_address);
32     }
33 
34     /// @notice checks if address is a guardian
35     /// @param _address address to check
36     /// @return true _address is a guardian
37     function isGuardian(address _address) public view override returns (bool) {
38         return core.isGuardian(_address);
39     }
40 
41     // ---------- Deprecated roles for caller ---------
42 
43     /// @dev returns false rather than reverting so calls to onlyGuardianOrGovernor don't revert
44     function isGovernor(address) external pure override returns (bool) {
45         return false;
46     }
47 
48     function isPCVController(address) external pure override returns (bool) {
49         revert("RestrictedPermissions: PCV Controller deprecated for contract");
50     }
51 
52     function isBurner(address) external pure override returns (bool) {
53         revert("RestrictedPermissions: Burner deprecated for contract");
54     }
55 }
