1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 interface IGnosisSafe {
5     enum Operation {
6         Call,
7         DelegateCall
8     }
9 
10     /// @dev Allows a Module to execute a Safe transaction without any further confirmations.
11     /// @param to Destination address of module transaction.
12     /// @param value Ether value of module transaction.
13     /// @param data Data payload of module transaction.
14     /// @param operation Operation type of module transaction.
15     function execTransactionFromModule(
16         address to,
17         uint256 value,
18         bytes calldata data,
19         Operation operation
20     ) external returns (bool success);
21 
22     function execTransaction(
23         address to,
24         uint256 value,
25         bytes calldata data,
26         Operation operation,
27         uint256 safeTxGas,
28         uint256 baseGas,
29         uint256 gasPrice,
30         address gasToken,
31         address payable refundReceiver,
32         bytes memory signatures
33     ) external payable returns (bool success);
34 
35     function approveHash(bytes32 hashToApprove) external;
36 
37     function encodeTransactionData(
38         address to,
39         uint256 value,
40         bytes calldata data,
41         Operation operation,
42         uint256 safeTxGas,
43         uint256 baseGas,
44         uint256 gasPrice,
45         address gasToken,
46         address refundReceiver,
47         uint256 _nonce
48     ) external view returns (bytes memory);
49 
50     /// @dev Returns array of owners.
51     /// @return Array of Safe owners.
52     function getOwners() external view returns (address[] memory);
53 
54     function isOwner(address owner) external view returns (bool);
55 
56     function getThreshold() external view returns (uint256);
57 
58     /// @dev Returns array of modules.
59     /// @param start Start of the page.
60     /// @param pageSize Maximum number of modules that should be returned.
61     /// @return array Array of modules.
62     /// @return next Start of the next page.
63     function getModulesPaginated(address start, uint256 pageSize)
64         external
65         view
66         returns (address[] memory array, address next);
67 
68     /// @dev Returns if an module is enabled
69     /// @return True if the module is enabled
70     function isModuleEnabled(address module) external view returns (bool);
71 }
