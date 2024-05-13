1 // SPDX-License-Identifier: GNU-GPL v3.0 or later
2 
3 pragma solidity ^0.8.0;
4 
5 import "../../utils/SecuredAddressLock.sol";
6 import "../../interfaces/IAddressRegistry.sol";
7 import "../../interfaces/IRevest.sol";
8 import '@openzeppelin/contracts/utils/introspection/ERC165.sol';
9 
10 /**
11  * @title
12  * @dev
13  */
14 contract AdminTimeLock is SecuredAddressLock, ERC165  {
15 
16     string public metadataURI = "https://revest.mypinata.cloud/ipfs/QmR9uFVk9fqKwzQHe6dvD4MNDMisJxv16PikxxJNuR6US5";
17 
18     mapping (uint => AdminLock) public locks;
19 
20     struct AdminLock {
21         uint endTime;
22         address admin;
23         bool unlocked;
24     }
25 
26     constructor(address reg_) SecuredAddressLock(reg_) {}
27 
28     function supportsInterface(bytes4 interfaceId) public view override(ERC165, IERC165) returns (bool) {
29         return interfaceId == type(IAddressLock).interfaceId
30             || interfaceId == type(IRegistryProvider).interfaceId
31             || super.supportsInterface(interfaceId);
32     }
33 
34     function isUnlockable(uint, uint lockId) public view override returns (bool) {
35         return locks[lockId].unlocked || block.timestamp > locks[lockId].endTime;
36     }
37 
38 
39     // Create the lock within that contract DURING minting
40     function createLock(uint, uint lockId, bytes memory arguments) external override onlyRevestController {
41         uint endTime;
42         address admin;
43         (endTime, admin) = abi.decode(arguments, (uint, address));
44 
45         // Check that we aren't creating a lock in the past
46         require(block.timestamp < endTime, 'E002');
47 
48         AdminLock memory adminLock = AdminLock(endTime, admin, false);
49         locks[lockId] = adminLock;
50     }
51 
52     function updateLock(uint, uint lockId, bytes memory) external override {
53         // For an admin lock, there are no arguments
54         if(_msgSender() == locks[lockId].admin) {
55            locks[lockId].unlocked = true;
56         }
57     }
58 
59     function needsUpdate() external pure override returns (bool) {
60         return true;
61     }
62 
63     // TODO: Now that we have changed this from being broken for splittable locks, how do we communicate the two-steps
64     // That are now needed to unlock this lock?
65     function getDisplayValues(uint, uint lockId) external view override returns (bytes memory) {
66         uint endTime = locks[lockId].endTime;
67         address admin = locks[lockId].admin;
68         bool canUnlock = admin == _msgSender();
69         return abi.encode(endTime, admin, canUnlock);
70     }
71 
72     function setMetadata(string memory _metadataURI) external onlyOwner {
73         metadataURI = _metadataURI;
74     }
75 
76     function getMetadata() external view override returns (string memory) {
77         return metadataURI;
78     }
79 
80 }
