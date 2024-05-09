1 // ┏━━━┓━┏┓━┏┓━━┏━━━┓━━┏━━━┓━━━━┏━━━┓━━━━━━━━━━━━━━━━━━━┏┓━━━━━┏━━━┓━━━━━━━━━┏┓━━━━━━━━━━━━━━┏┓━
2 // ┃┏━━┛┏┛┗┓┃┃━━┃┏━┓┃━━┃┏━┓┃━━━━┗┓┏┓┃━━━━━━━━━━━━━━━━━━┏┛┗┓━━━━┃┏━┓┃━━━━━━━━┏┛┗┓━━━━━━━━━━━━┏┛┗┓
3 // ┃┗━━┓┗┓┏┛┃┗━┓┗┛┏┛┃━━┃┃━┃┃━━━━━┃┃┃┃┏━━┓┏━━┓┏━━┓┏━━┓┏┓┗┓┏┛━━━━┃┃━┗┛┏━━┓┏━┓━┗┓┏┛┏━┓┏━━┓━┏━━┓┗┓┏┛
4 // ┃┏━━┛━┃┃━┃┏┓┃┏━┛┏┛━━┃┃━┃┃━━━━━┃┃┃┃┃┏┓┃┃┏┓┃┃┏┓┃┃━━┫┣┫━┃┃━━━━━┃┃━┏┓┃┏┓┃┃┏┓┓━┃┃━┃┏┛┗━┓┃━┃┏━┛━┃┃━
5 // ┃┗━━┓━┃┗┓┃┃┃┃┃┃┗━┓┏┓┃┗━┛┃━━━━┏┛┗┛┃┃┃━┫┃┗┛┃┃┗┛┃┣━━┃┃┃━┃┗┓━━━━┃┗━┛┃┃┗┛┃┃┃┃┃━┃┗┓┃┃━┃┗┛┗┓┃┗━┓━┃┗┓
6 // ┗━━━┛━┗━┛┗┛┗┛┗━━━┛┗┛┗━━━┛━━━━┗━━━┛┗━━┛┃┏━┛┗━━┛┗━━┛┗┛━┗━┛━━━━┗━━━┛┗━━┛┗┛┗┛━┗━┛┗┛━┗━━━┛┗━━┛━┗━┛
7 // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┃┃━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
8 // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┗┛━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
9 
10 // SPDX-License-Identifier: CC0-1.0
11 
12 pragma solidity 0.6.11;
13 
14 // This interface is designed to be compatible with the Vyper version.
15 /// @notice This is the Ethereum 2.0 deposit contract interface.
16 /// For more information see the Phase 0 specification under https://github.com/ethereum/eth2.0-specs
17 interface IDepositContract {
18     /// @notice A processed deposit event.
19     event DepositEvent(
20         bytes pubkey,
21         bytes withdrawal_credentials,
22         bytes amount,
23         bytes signature,
24         bytes index
25     );
26 
27     /// @notice Submit a Phase 0 DepositData object.
28     /// @param pubkey A BLS12-381 public key.
29     /// @param withdrawal_credentials Commitment to a public key for withdrawals.
30     /// @param signature A BLS12-381 signature.
31     /// @param deposit_data_root The SHA-256 hash of the SSZ-encoded DepositData object.
32     /// Used as a protection against malformed input.
33     function deposit(
34         bytes calldata pubkey,
35         bytes calldata withdrawal_credentials,
36         bytes calldata signature,
37         bytes32 deposit_data_root
38     ) external payable;
39 
40     /// @notice Query the current deposit root hash.
41     /// @return The deposit root hash.
42     function get_deposit_root() external view returns (bytes32);
43 
44     /// @notice Query the current deposit count.
45     /// @return The deposit count encoded as a little endian 64-bit number.
46     function get_deposit_count() external view returns (bytes memory);
47 }
48 
49 // Based on official specification in https://eips.ethereum.org/EIPS/eip-165
50 interface ERC165 {
51     /// @notice Query if a contract implements an interface
52     /// @param interfaceId The interface identifier, as specified in ERC-165
53     /// @dev Interface identification is specified in ERC-165. This function
54     ///  uses less than 30,000 gas.
55     /// @return `true` if the contract implements `interfaceId` and
56     ///  `interfaceId` is not 0xffffffff, `false` otherwise
57     function supportsInterface(bytes4 interfaceId) external pure returns (bool);
58 }
59 
60 // This is a rewrite of the Vyper Eth2.0 deposit contract in Solidity.
61 // It tries to stay as close as possible to the original source code.
62 /// @notice This is the Ethereum 2.0 deposit contract interface.
63 /// For more information see the Phase 0 specification under https://github.com/ethereum/eth2.0-specs
64 contract DepositContract is IDepositContract, ERC165 {
65     uint constant DEPOSIT_CONTRACT_TREE_DEPTH = 32;
66     // NOTE: this also ensures `deposit_count` will fit into 64-bits
67     uint constant MAX_DEPOSIT_COUNT = 2**DEPOSIT_CONTRACT_TREE_DEPTH - 1;
68 
69     bytes32[DEPOSIT_CONTRACT_TREE_DEPTH] branch;
70     uint256 deposit_count;
71 
72     bytes32[DEPOSIT_CONTRACT_TREE_DEPTH] zero_hashes;
73 
74     constructor() public {
75         // Compute hashes in empty sparse Merkle tree
76         for (uint height = 0; height < DEPOSIT_CONTRACT_TREE_DEPTH - 1; height++)
77             zero_hashes[height + 1] = sha256(abi.encodePacked(zero_hashes[height], zero_hashes[height]));
78     }
79 
80     function get_deposit_root() override external view returns (bytes32) {
81         bytes32 node;
82         uint size = deposit_count;
83         for (uint height = 0; height < DEPOSIT_CONTRACT_TREE_DEPTH; height++) {
84             if ((size & 1) == 1)
85                 node = sha256(abi.encodePacked(branch[height], node));
86             else
87                 node = sha256(abi.encodePacked(node, zero_hashes[height]));
88             size /= 2;
89         }
90         return sha256(abi.encodePacked(
91             node,
92             to_little_endian_64(uint64(deposit_count)),
93             bytes24(0)
94         ));
95     }
96 
97     function get_deposit_count() override external view returns (bytes memory) {
98         return to_little_endian_64(uint64(deposit_count));
99     }
100 
101     function deposit(
102         bytes calldata pubkey,
103         bytes calldata withdrawal_credentials,
104         bytes calldata signature,
105         bytes32 deposit_data_root
106     ) override external payable {
107         // Extended ABI length checks since dynamic types are used.
108         require(pubkey.length == 48, "DepositContract: invalid pubkey length");
109         require(withdrawal_credentials.length == 32, "DepositContract: invalid withdrawal_credentials length");
110         require(signature.length == 96, "DepositContract: invalid signature length");
111 
112         // Check deposit amount
113         require(msg.value >= 1 ether, "DepositContract: deposit value too low");
114         require(msg.value % 1 gwei == 0, "DepositContract: deposit value not multiple of gwei");
115         uint deposit_amount = msg.value / 1 gwei;
116         require(deposit_amount <= type(uint64).max, "DepositContract: deposit value too high");
117 
118         // Emit `DepositEvent` log
119         bytes memory amount = to_little_endian_64(uint64(deposit_amount));
120         emit DepositEvent(
121             pubkey,
122             withdrawal_credentials,
123             amount,
124             signature,
125             to_little_endian_64(uint64(deposit_count))
126         );
127 
128         // Compute deposit data root (`DepositData` hash tree root)
129         bytes32 pubkey_root = sha256(abi.encodePacked(pubkey, bytes16(0)));
130         bytes32 signature_root = sha256(abi.encodePacked(
131             sha256(abi.encodePacked(signature[:64])),
132             sha256(abi.encodePacked(signature[64:], bytes32(0)))
133         ));
134         bytes32 node = sha256(abi.encodePacked(
135             sha256(abi.encodePacked(pubkey_root, withdrawal_credentials)),
136             sha256(abi.encodePacked(amount, bytes24(0), signature_root))
137         ));
138 
139         // Verify computed and expected deposit data roots match
140         require(node == deposit_data_root, "DepositContract: reconstructed DepositData does not match supplied deposit_data_root");
141 
142         // Avoid overflowing the Merkle tree (and prevent edge case in computing `branch`)
143         require(deposit_count < MAX_DEPOSIT_COUNT, "DepositContract: merkle tree full");
144 
145         // Add deposit data root to Merkle tree (update a single `branch` node)
146         deposit_count += 1;
147         uint size = deposit_count;
148         for (uint height = 0; height < DEPOSIT_CONTRACT_TREE_DEPTH; height++) {
149             if ((size & 1) == 1) {
150                 branch[height] = node;
151                 return;
152             }
153             node = sha256(abi.encodePacked(branch[height], node));
154             size /= 2;
155         }
156         // As the loop should always end prematurely with the `return` statement,
157         // this code should be unreachable. We assert `false` just to be safe.
158         assert(false);
159     }
160 
161     function supportsInterface(bytes4 interfaceId) override external pure returns (bool) {
162         return interfaceId == type(ERC165).interfaceId || interfaceId == type(IDepositContract).interfaceId;
163     }
164 
165     function to_little_endian_64(uint64 value) internal pure returns (bytes memory ret) {
166         ret = new bytes(8);
167         bytes8 bytesValue = bytes8(value);
168         // Byteswapping during copying to bytes.
169         ret[0] = bytesValue[7];
170         ret[1] = bytesValue[6];
171         ret[2] = bytesValue[5];
172         ret[3] = bytesValue[4];
173         ret[4] = bytesValue[3];
174         ret[5] = bytesValue[2];
175         ret[6] = bytesValue[1];
176         ret[7] = bytesValue[0];
177     }
178 }