1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { LibDiamond } from "../Libraries/LibDiamond.sol";
5 import { IERC173 } from "../Interfaces/IERC173.sol";
6 import { LibUtil } from "../Libraries/LibUtil.sol";
7 import { LibAsset } from "../Libraries/LibAsset.sol";
8 
9 /// @title Ownership Facet
10 /// @author LI.FI (https://li.fi)
11 /// @notice Manages ownership of the LiFi Diamond contract for admin purposes
12 /// @custom:version 1.0.0
13 contract OwnershipFacet is IERC173 {
14     /// Storage ///
15 
16     bytes32 internal constant NAMESPACE =
17         keccak256("com.lifi.facets.ownership");
18 
19     /// Types ///
20 
21     struct Storage {
22         address newOwner;
23     }
24 
25     /// Errors ///
26 
27     error NoNullOwner();
28     error NewOwnerMustNotBeSelf();
29     error NoPendingOwnershipTransfer();
30     error NotPendingOwner();
31 
32     /// Events ///
33 
34     event OwnershipTransferRequested(
35         address indexed _from,
36         address indexed _to
37     );
38 
39     /// External Methods ///
40 
41     /// @notice Initiates transfer of ownership to a new address
42     /// @param _newOwner the address to transfer ownership to
43     function transferOwnership(address _newOwner) external override {
44         LibDiamond.enforceIsContractOwner();
45         Storage storage s = getStorage();
46 
47         if (LibUtil.isZeroAddress(_newOwner)) revert NoNullOwner();
48 
49         if (_newOwner == LibDiamond.contractOwner())
50             revert NewOwnerMustNotBeSelf();
51 
52         s.newOwner = _newOwner;
53         emit OwnershipTransferRequested(msg.sender, s.newOwner);
54     }
55 
56     /// @notice Cancel transfer of ownership
57     function cancelOwnershipTransfer() external {
58         LibDiamond.enforceIsContractOwner();
59         Storage storage s = getStorage();
60 
61         if (LibUtil.isZeroAddress(s.newOwner))
62             revert NoPendingOwnershipTransfer();
63         s.newOwner = address(0);
64     }
65 
66     /// @notice Confirms transfer of ownership to the calling address (msg.sender)
67     function confirmOwnershipTransfer() external {
68         Storage storage s = getStorage();
69         address _pendingOwner = s.newOwner;
70         if (msg.sender != _pendingOwner) revert NotPendingOwner();
71         emit OwnershipTransferred(LibDiamond.contractOwner(), _pendingOwner);
72         LibDiamond.setContractOwner(_pendingOwner);
73         s.newOwner = LibAsset.NULL_ADDRESS;
74     }
75 
76     /// @notice Return the current owner address
77     /// @return owner_ The current owner address
78     function owner() external view override returns (address owner_) {
79         owner_ = LibDiamond.contractOwner();
80     }
81 
82     /// Private Methods ///
83 
84     /// @dev fetch local storage
85     function getStorage() private pure returns (Storage storage s) {
86         bytes32 namespace = NAMESPACE;
87         // solhint-disable-next-line no-inline-assembly
88         assembly {
89             s.slot := namespace
90         }
91     }
92 }
