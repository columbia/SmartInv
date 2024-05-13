1 // SPDX-License-Identifier: GPL-2.0-or-later
2 
3 pragma solidity ^0.8.0;
4 
5 import "../Utils.sol";
6 
7 contract EulStakes {
8     address public immutable eul;
9     string public constant name = "EUL Stakes";
10     mapping(address => mapping(address => uint)) userStaked;
11 
12     event Stake(address indexed who, address indexed underlying, address sender, uint newAmount);
13 
14     constructor(address eul_) {
15         eul = eul_;
16     }
17 
18     /// @notice Retrieve current amount staked
19     /// @param account User address
20     /// @param underlying Token staked upon
21     /// @return Amount of EUL token staked
22     function staked(address account, address underlying) external view returns (uint) {
23         return userStaked[account][underlying];
24     }
25 
26     /// @notice Staking operation item. Positive amount means to increase stake on this underlying, negative to decrease.
27     struct StakeOp {
28         address underlying;
29         int amount;
30     }
31 
32     /// @notice Modify stake of a series of underlyings. If the sum of all amounts is positive, then this amount of EUL will be transferred in from the sender's wallet. If negative, EUL will be transferred out to the sender's wallet.
33     /// @param ops Array of operations to perform
34     function stake(StakeOp[] memory ops) public {
35         int delta = 0;
36 
37         for (uint i = 0; i < ops.length; ++i) {
38             StakeOp memory op = ops[i];
39             if (op.amount == 0) continue;
40 
41             require(op.amount > -1e36 && op.amount < 1e36, "amount out of range");
42 
43             uint newAmount;
44 
45             {
46                 int newAmountSigned = int(userStaked[msg.sender][op.underlying]) + op.amount;
47                 require(newAmountSigned >= 0, "insufficient staked");
48                 newAmount = uint(newAmountSigned);
49             }
50 
51             userStaked[msg.sender][op.underlying] = newAmount;
52             emit Stake(msg.sender, op.underlying, msg.sender, newAmount);
53 
54             delta += op.amount;
55         }
56 
57         if (delta > 0) {
58             Utils.safeTransferFrom(eul, msg.sender, address(this), uint(delta));
59         } else if (delta < 0) {
60             Utils.safeTransfer(eul, msg.sender, uint(-delta));
61         }
62     }
63 
64     /// @notice Increase stake on an underlying, and transfer this stake to a beneficiary
65     /// @param beneficiary Who is given credit for this staked EUL
66     /// @param underlying The underlying token to be staked upon
67     /// @param amount How much EUL to stake
68     function stakeGift(address beneficiary, address underlying, uint amount) external {
69         require(amount < 1e36, "amount out of range");
70         if (amount == 0) return;
71 
72         uint newAmount = userStaked[beneficiary][underlying] + amount;
73 
74         userStaked[beneficiary][underlying] = newAmount;
75         emit Stake(beneficiary, underlying, msg.sender, newAmount);
76 
77         Utils.safeTransferFrom(eul, msg.sender, address(this), amount);
78     }
79 
80     /// @notice Applies a permit() signature to EUL and then applies a sequence of staking operations
81     /// @param ops Array of operations to perform
82     /// @param value The value field of the permit message
83     /// @param deadline The deadline field of the permit message
84     /// @param v Signature field
85     /// @param r Signature field
86     /// @param s Signature field
87     function stakePermit(StakeOp[] memory ops, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
88         IERC20Permit(eul).permit(msg.sender, address(this), value, deadline, v, r, s);
89 
90         stake(ops);
91     }
92 }
