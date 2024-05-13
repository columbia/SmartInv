1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import "../PCVDeposit.sol";
5 import "../../refs/CoreRef.sol";
6 
7 interface ITokemakPool {
8     function underlyer() external view returns (address);
9 
10     function balanceOf(address holder) external view returns (uint256);
11 
12     function requestWithdrawal(uint256 amount) external;
13 }
14 
15 interface ITokemakRewards {
16     struct Recipient {
17         uint256 chainId;
18         uint256 cycle;
19         address wallet;
20         uint256 amount;
21     }
22 
23     function claim(
24         Recipient calldata recipient,
25         uint8 v,
26         bytes32 r,
27         bytes32 s // bytes calldata signature
28     ) external;
29 }
30 
31 /// @title base class for a Tokemak PCV Deposit
32 /// @author Fei Protocol
33 abstract contract TokemakPCVDepositBase is PCVDeposit {
34     /// @notice event generated when rewards are claimed
35     event ClaimRewards(address indexed _caller, address indexed _token, address indexed _to, uint256 _amount);
36 
37     /// @notice event generated when a withdrawal is requested
38     event RequestWithdrawal(address indexed _caller, address indexed _to, uint256 _amount);
39 
40     address private constant TOKE_TOKEN_ADDRESS = address(0x2e9d63788249371f1DFC918a52f8d799F4a38C94);
41 
42     /// @notice the tokemak pool to deposit in
43     address public immutable pool;
44 
45     /// @notice the tokemak rewards contract to claim TOKE incentives
46     address public immutable rewards;
47 
48     /// @notice the token stored in the Tokemak pool
49     IERC20 public immutable token;
50 
51     /// @notice Tokemak PCV Deposit constructor
52     /// @param _core Fei Core for reference
53     /// @param _pool Tokemak pool to deposit in
54     /// @param _rewards Tokemak rewards contract to claim TOKE incentives
55     constructor(
56         address _core,
57         address _pool,
58         address _rewards
59     ) CoreRef(_core) {
60         pool = _pool;
61         rewards = _rewards;
62         token = IERC20(ITokemakPool(_pool).underlyer());
63     }
64 
65     /// @notice returns total balance of PCV in the Deposit excluding the FEI
66     function balance() public view override returns (uint256) {
67         return ITokemakPool(pool).balanceOf(address(this));
68     }
69 
70     /// @notice display the related token of the balance reported
71     function balanceReportedIn() public view override returns (address) {
72         return address(token);
73     }
74 
75     /// @notice request to withdraw a given amount of tokens to Tokemak. These
76     /// tokens will be available for withdraw in the next cycles.
77     /// This function can be called by the contract admin, e.g. the OA multisig,
78     /// in anticipation of the execution of a DAO proposal that will call withdraw().
79     /// @dev note that withdraw() calls will revert if this function has not been
80     /// called before.
81     /// @param amountUnderlying of tokens to withdraw in a subsequent withdraw() call.
82     function requestWithdrawal(uint256 amountUnderlying) external onlyGovernorOrAdmin whenNotPaused {
83         ITokemakPool(pool).requestWithdrawal(amountUnderlying);
84 
85         emit RequestWithdrawal(msg.sender, address(this), amountUnderlying);
86     }
87 
88     /// @notice claim TOKE rewards associated to this PCV Deposit. The TOKE tokens
89     /// will be sent to the PCVDeposit, and can then be moved with withdrawERC20.
90     /// The Tokemak rewards are distributed as follow :
91     /// "At the end of each cycle we publish a signed message for each LP out to
92     //    a "folder" on IPFS. This message says how much TOKE the account is entitled
93     //    to as their reward (and this is cumulative not just for a single cycle).
94     //    That folder hash is published out to the website which will call out to
95     //    an IPFS gateway, /ipfs/{folderHash}/{account}.json, and get the payload
96     //    they need to submit to the contract. Tx is executed with that payload and
97     //    the account is sent their TOKE."
98     /// For an example of IPFS json file, see :
99     //  https://ipfs.tokemaklabs.xyz/ipfs/Qmf5Vuy7x5t3rMCa6u57hF8AE89KLNkjdxSKjL8USALwYo/0x4eff3562075c5d2d9cb608139ec2fe86907005fa.json
100     function claimRewards(
101         uint256 cycle,
102         uint256 amount,
103         uint8 v,
104         bytes32 r,
105         bytes32 s // bytes calldata signature
106     ) external whenNotPaused {
107         ITokemakRewards.Recipient memory recipient = ITokemakRewards.Recipient(
108             1, // chainId
109             cycle,
110             address(this), // wallet
111             amount
112         );
113 
114         ITokemakRewards(rewards).claim(recipient, v, r, s);
115 
116         emit ClaimRewards(msg.sender, address(TOKE_TOKEN_ADDRESS), address(this), amount);
117     }
118 }
