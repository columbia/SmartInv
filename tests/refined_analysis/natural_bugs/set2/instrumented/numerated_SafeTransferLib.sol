1 // SPDX-License-Identifier: AGPL-3.0-only
2 pragma solidity >=0.8.0;
3 
4 import {ERC20} from "../ERC20.sol";
5 
6 /// @notice Safe ETH and ERC20 transfer library that gracefully handles missing return values.
7 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/SafeTransferLib.sol)
8 /// @dev Use with caution! Some functions in this library knowingly create dirty bits at the destination of the free memory pointer.
9 /// @dev Note that none of the functions in this library check that a token has code at all! That responsibility is delegated to the caller.
10 library SafeTransferLib {
11     /*//////////////////////////////////////////////////////////////
12                              ETH OPERATIONS
13     //////////////////////////////////////////////////////////////*/
14 
15     function safeTransferETH(address to, uint256 amount) internal {
16         bool success;
17 
18         assembly {
19             // Transfer the ETH and store if it succeeded or not.
20             success := call(gas(), to, amount, 0, 0, 0, 0)
21         }
22 
23         require(success, "ETH_TRANSFER_FAILED");
24     }
25 
26     /*//////////////////////////////////////////////////////////////
27                             ERC20 OPERATIONS
28     //////////////////////////////////////////////////////////////*/
29 
30     function safeTransferFrom(
31         ERC20 token,
32         address from,
33         address to,
34         uint256 amount
35     ) internal {
36         bool success;
37 
38         assembly {
39             // Get a pointer to some free memory.
40             let freeMemoryPointer := mload(0x40)
41 
42             // Write the abi-encoded calldata into memory, beginning with the function selector.
43             mstore(freeMemoryPointer, 0x23b872dd00000000000000000000000000000000000000000000000000000000)
44             mstore(add(freeMemoryPointer, 4), from) // Append the "from" argument.
45             mstore(add(freeMemoryPointer, 36), to) // Append the "to" argument.
46             mstore(add(freeMemoryPointer, 68), amount) // Append the "amount" argument.
47 
48             success := and(
49                 // Set success to whether the call reverted, if not we check it either
50                 // returned exactly 1 (can't just be non-zero data), or had no return data.
51                 or(and(eq(mload(0), 1), gt(returndatasize(), 31)), iszero(returndatasize())),
52                 // We use 100 because the length of our calldata totals up like so: 4 + 32 * 3.
53                 // We use 0 and 32 to copy up to 32 bytes of return data into the scratch space.
54                 // Counterintuitively, this call must be positioned second to the or() call in the
55                 // surrounding and() call or else returndatasize() will be zero during the computation.
56                 call(gas(), token, 0, freeMemoryPointer, 100, 0, 32)
57             )
58         }
59 
60         require(success, "TRANSFER_FROM_FAILED");
61     }
62 
63     function safeTransfer(
64         ERC20 token,
65         address to,
66         uint256 amount
67     ) internal {
68         bool success;
69 
70         assembly {
71             // Get a pointer to some free memory.
72             let freeMemoryPointer := mload(0x40)
73 
74             // Write the abi-encoded calldata into memory, beginning with the function selector.
75             mstore(freeMemoryPointer, 0xa9059cbb00000000000000000000000000000000000000000000000000000000)
76             mstore(add(freeMemoryPointer, 4), to) // Append the "to" argument.
77             mstore(add(freeMemoryPointer, 36), amount) // Append the "amount" argument.
78 
79             success := and(
80                 // Set success to whether the call reverted, if not we check it either
81                 // returned exactly 1 (can't just be non-zero data), or had no return data.
82                 or(and(eq(mload(0), 1), gt(returndatasize(), 31)), iszero(returndatasize())),
83                 // We use 68 because the length of our calldata totals up like so: 4 + 32 * 2.
84                 // We use 0 and 32 to copy up to 32 bytes of return data into the scratch space.
85                 // Counterintuitively, this call must be positioned second to the or() call in the
86                 // surrounding and() call or else returndatasize() will be zero during the computation.
87                 call(gas(), token, 0, freeMemoryPointer, 68, 0, 32)
88             )
89         }
90 
91         require(success, "TRANSFER_FAILED");
92     }
93 
94     function safeApprove(
95         ERC20 token,
96         address to,
97         uint256 amount
98     ) internal {
99         bool success;
100 
101         assembly {
102             // Get a pointer to some free memory.
103             let freeMemoryPointer := mload(0x40)
104 
105             // Write the abi-encoded calldata into memory, beginning with the function selector.
106             mstore(freeMemoryPointer, 0x095ea7b300000000000000000000000000000000000000000000000000000000)
107             mstore(add(freeMemoryPointer, 4), to) // Append the "to" argument.
108             mstore(add(freeMemoryPointer, 36), amount) // Append the "amount" argument.
109 
110             success := and(
111                 // Set success to whether the call reverted, if not we check it either
112                 // returned exactly 1 (can't just be non-zero data), or had no return data.
113                 or(and(eq(mload(0), 1), gt(returndatasize(), 31)), iszero(returndatasize())),
114                 // We use 68 because the length of our calldata totals up like so: 4 + 32 * 2.
115                 // We use 0 and 32 to copy up to 32 bytes of return data into the scratch space.
116                 // Counterintuitively, this call must be positioned second to the or() call in the
117                 // surrounding and() call or else returndatasize() will be zero during the computation.
118                 call(gas(), token, 0, freeMemoryPointer, 68, 0, 32)
119             )
120         }
121 
122         require(success, "APPROVE_FAILED");
123     }
124 }