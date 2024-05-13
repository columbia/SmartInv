1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { IERC173 } from "../Interfaces/IERC173.sol";
5 import { LibAsset } from "../Libraries/LibAsset.sol";
6 
7 contract TransferrableOwnership is IERC173 {
8     address public owner;
9     address public pendingOwner;
10 
11     /// Errors ///
12     error UnAuthorized();
13     error NoNullOwner();
14     error NewOwnerMustNotBeSelf();
15     error NoPendingOwnershipTransfer();
16     error NotPendingOwner();
17 
18     /// Events ///
19     event OwnershipTransferRequested(
20         address indexed _from,
21         address indexed _to
22     );
23 
24     constructor(address initialOwner) {
25         owner = initialOwner;
26     }
27 
28     modifier onlyOwner() {
29         if (msg.sender != owner) revert UnAuthorized();
30         _;
31     }
32 
33     /// @notice Initiates transfer of ownership to a new address
34     /// @param _newOwner the address to transfer ownership to
35     function transferOwnership(address _newOwner) external onlyOwner {
36         if (_newOwner == LibAsset.NULL_ADDRESS) revert NoNullOwner();
37         if (_newOwner == msg.sender) revert NewOwnerMustNotBeSelf();
38         pendingOwner = _newOwner;
39         emit OwnershipTransferRequested(msg.sender, pendingOwner);
40     }
41 
42     /// @notice Cancel transfer of ownership
43     function cancelOwnershipTransfer() external onlyOwner {
44         if (pendingOwner == LibAsset.NULL_ADDRESS)
45             revert NoPendingOwnershipTransfer();
46         pendingOwner = LibAsset.NULL_ADDRESS;
47     }
48 
49     /// @notice Confirms transfer of ownership to the calling address (msg.sender)
50     function confirmOwnershipTransfer() external {
51         address _pendingOwner = pendingOwner;
52         if (msg.sender != _pendingOwner) revert NotPendingOwner();
53         emit OwnershipTransferred(owner, _pendingOwner);
54         owner = _pendingOwner;
55         pendingOwner = LibAsset.NULL_ADDRESS;
56     }
57 }
