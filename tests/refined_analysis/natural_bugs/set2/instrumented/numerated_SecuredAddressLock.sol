1 // SPDX-License-Identifier: GNU-GPL v3.0 or later
2 
3 pragma solidity ^0.8.0;
4 
5 import "../interfaces/IAddressLock.sol";
6 import "@openzeppelin/contracts/access/Ownable.sol";
7 
8 abstract contract SecuredAddressLock is IAddressLock, Ownable {
9 
10     IAddressRegistry public addressesProvider;
11 
12     constructor(address provider) Ownable() {
13         addressesProvider = IAddressRegistry(provider);
14     }
15 
16     function setAddressRegistry(address registry) external override onlyOwner {
17         addressesProvider = IAddressRegistry(registry);
18     }
19 
20     function getAddressRegistry() external view override returns (address) {
21         return address(addressesProvider);
22     }
23 
24 
25     modifier onlyLockManager() {
26         require(_msgSender() != address(0), "E004");
27         require(_msgSender() == addressesProvider.getLockManager(), 'E074');
28         _;
29     }
30 
31     modifier onlyRevestController() {
32         require(_msgSender() != address(0), "E004");
33         require(_msgSender() == addressesProvider.getRevest(), "E017");
34         _;
35     }
36 
37 }
