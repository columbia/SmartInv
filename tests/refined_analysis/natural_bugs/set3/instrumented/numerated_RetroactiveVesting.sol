1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.6;
4 
5 import "@openzeppelin/contracts-4.2.0/token/ERC20/utils/SafeERC20.sol";
6 import "@openzeppelin/contracts-4.2.0/utils/cryptography/MerkleProof.sol";
7 
8 /**
9  * @title RetroactiveVesting
10  * @notice A token holder contract that can release its token balance linearly over
11  * the vesting period of 2 years. Respective address and the amount are included in each merkle node.
12  */
13 contract RetroactiveVesting {
14     using SafeERC20 for IERC20;
15 
16     struct VestingData {
17         bool isVerified;
18         uint120 totalAmount;
19         uint120 released;
20     }
21 
22     event Claimed(address indexed account, uint256 amount);
23 
24     // Address of the token that is subject to vesting
25     IERC20 public immutable token;
26     // Merkle root used to verify the beneficiary address and the amount of the tokens
27     bytes32 public immutable merkleRoot;
28     // Epoch unix timestamp in seconds when the vesting starts to decay
29     uint256 public immutable startTimestamp;
30     // Vesting period of 2 years
31     uint256 public constant DURATION = 2 * (52 weeks);
32 
33     mapping(address => VestingData) public vestings;
34 
35     /**
36      * @notice Deploys this contract with given parameters
37      * @dev The information about the method used to generate the merkle root and how to replicate it
38      * can be found on https://docs.saddle.finance.
39      * @param token_ Address of the token that will be vested
40      * @param merkleRoot_ Bytes of the merkle root node which is generated off chain.
41      * @param startTimestamp_ Timestamp in seconds when to start vesting. This can be backdated as well.
42      */
43     constructor(
44         IERC20 token_,
45         bytes32 merkleRoot_,
46         uint256 startTimestamp_
47     ) public {
48         require(address(token_) != address(0), "token_ cannot be empty");
49         require(merkleRoot_[0] != 0, "merkleRoot_ cannot be empty");
50         require(startTimestamp_ != 0, "startTimestamp_ cannot be 0");
51 
52         token = token_;
53         merkleRoot = merkleRoot_;
54         startTimestamp = startTimestamp_;
55     }
56 
57     /**
58      * @notice Verifies the given account is eligible for the given amount. Then claims the
59      * vested amount out of the total amount eligible.
60      * @param account Address of the account that the caller is verifying for
61      * @param totalAmount Total amount that will be vested linearly
62      * @param merkleProof Merkle proof that was generated off chain.
63      */
64     function verifyAndClaimReward(
65         address account,
66         uint256 totalAmount,
67         bytes32[] calldata merkleProof
68     ) external {
69         require(
70             totalAmount > 0 && totalAmount < type(uint120).max,
71             "totalAmount cannot be 0 or larger than max uint120 value"
72         );
73         VestingData storage vesting = vestings[account];
74         if (!vesting.isVerified) {
75             // Verify the merkle proof.
76             bytes32 node = keccak256(abi.encodePacked(account, totalAmount));
77             require(
78                 MerkleProof.verify(merkleProof, merkleRoot, node),
79                 "could not verify merkleProof"
80             );
81             // Save the verified state
82             vesting.isVerified = true;
83             vesting.totalAmount = uint120(totalAmount);
84         }
85         _claimReward(account);
86     }
87 
88     /**
89      * @notice Claims the vested amount out of the total amount eligible for the given account.
90      * @param account Address of the account that the caller is claiming for. If this is set
91      * to `address(0)`, it will use the `msg.sender` instead.
92      */
93     function claimReward(address account) external {
94         if (account == address(0)) {
95             account = msg.sender;
96         }
97         require(vestings[account].isVerified, "must verify first");
98         _claimReward(account);
99     }
100 
101     function _claimReward(address account) internal {
102         VestingData storage vesting = vestings[account];
103         uint256 released = vesting.released;
104         uint256 amount = _vestedAmount(
105             vesting.totalAmount,
106             released,
107             startTimestamp,
108             DURATION
109         );
110         uint256 newReleased = amount + released;
111         require(
112             newReleased < type(uint120).max,
113             "newReleased is too big to be cast uint120"
114         );
115         vesting.released = uint120(newReleased);
116         token.safeTransfer(account, amount);
117 
118         emit Claimed(account, amount);
119     }
120 
121     /**
122      * @notice Calculated the amount that has already vested but hasn't been released yet.
123      * Reverts if the given account has not been verified.
124      * @param account Address to calculate the vested amount for
125      */
126     function vestedAmount(address account) external view returns (uint256) {
127         require(vestings[account].isVerified, "must verify first");
128         return
129             _vestedAmount(
130                 vestings[account].totalAmount,
131                 vestings[account].released,
132                 startTimestamp,
133                 DURATION
134             );
135     }
136 
137     /**
138      * @notice Calculates the amount that has already vested but hasn't been released yet.
139      */
140     function _vestedAmount(
141         uint256 total,
142         uint256 released,
143         uint256 startTimestamp,
144         uint256 durationInSeconds
145     ) internal view returns (uint256) {
146         uint256 blockTimestamp = block.timestamp;
147 
148         // If current block is before the start, there are no vested amount.
149         if (blockTimestamp < startTimestamp) {
150             return 0;
151         }
152 
153         uint256 elapsedTime = blockTimestamp - startTimestamp;
154         uint256 vested;
155 
156         // If over vesting duration, all tokens vested
157         if (elapsedTime >= durationInSeconds) {
158             vested = total;
159         } else {
160             vested = (total * elapsedTime) / durationInSeconds;
161         }
162 
163         return vested - released;
164     }
165 }
