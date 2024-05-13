1 // SPDX-License-Identifier: GNU-GPL v3.0 or later
2 
3 pragma solidity ^0.8.0;
4 
5 import "../../interfaces/IAddressRegistry.sol";
6 import "../../interfaces/IRevest.sol";
7 import "../../interfaces/ITokenVault.sol";
8 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
9 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
10 import '@openzeppelin/contracts/utils/introspection/ERC165.sol';
11 import "../../utils/SecuredAddressLock.sol";
12 
13 contract SupplyLock is SecuredAddressLock, ERC165  {
14 
15     mapping(uint => SupplyLockDetails) private locks;
16 
17     struct SupplyLockDetails {
18         uint supplyLevels;
19         address asset;
20         bool isLockRisingEdge;
21     }
22 
23     using SafeERC20 for IERC20;
24 
25     constructor(address registry) SecuredAddressLock(registry) {}
26 
27     function supportsInterface(bytes4 interfaceId) public view override(ERC165, IERC165) returns (bool) {
28         return interfaceId == type(IAddressLock).interfaceId
29             || interfaceId == type(IRegistryProvider).interfaceId
30             || super.supportsInterface(interfaceId);
31     }
32 
33     function isUnlockable(uint, uint lockId) public view override returns (bool) {
34         address asset = locks[lockId].asset;
35         uint supply = locks[lockId].supplyLevels;
36         if (locks[lockId].isLockRisingEdge) {
37             return IERC20(asset).totalSupply() > supply;
38         } else {
39             return IERC20(asset).totalSupply() < supply;
40         }
41     }
42 
43     function createLock(uint , uint lockId, bytes memory arguments) external override onlyRevestController {
44         uint supply;
45         bool isRisingEdge;
46         address asset;
47         (supply, asset, isRisingEdge) = abi.decode(arguments, (uint, address, bool));
48         locks[lockId].supplyLevels = supply;
49         locks[lockId].isLockRisingEdge = isRisingEdge;
50         locks[lockId].asset = asset;
51     }
52 
53     function updateLock(uint fnftId, uint lockId, bytes memory arguments) external override {}
54 
55     function needsUpdate() external pure override returns (bool) {
56         return false;
57     }
58 
59     function getMetadata() external pure override returns (string memory) {
60         return "https://revest.mypinata.cloud/ipfs/QmWQWvdpn4ovFEZxYXEqtcGdCCmpwf2FCwDUdh198Fb62g";
61     }
62 
63     function getDisplayValues(uint, uint lockId) external view override returns (bytes memory) {
64         SupplyLockDetails memory lockDetails = locks[lockId];
65         return abi.encode(lockDetails.supplyLevels, lockDetails.asset, lockDetails.isLockRisingEdge);
66     }
67 }
