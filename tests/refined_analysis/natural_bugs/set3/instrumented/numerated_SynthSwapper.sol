1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 import "synthetix/contracts/interfaces/ISynthetix.sol";
6 import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
7 import "@openzeppelin/contracts-upgradeable/proxy/Initializable.sol";
8 import "../interfaces/ISwap.sol";
9 
10 /**
11  * @title SynthSwapper
12  * @notice Replacement of Virtual Synths in favor of gas savings. Allows swapping synths via the Synthetix protocol
13  * or Saddle's pools. The `Bridge.sol` contract will deploy minimal clones of this contract upon initiating
14  * any cross-asset swaps.
15  */
16 contract SynthSwapper is Initializable {
17     using SafeERC20 for IERC20;
18 
19     address payable owner;
20     // SYNTHETIX points to `ProxyERC20` (0xC011a73ee8576Fb46F5E1c5751cA3B9Fe0af2a6F).
21     // This contract is a proxy of `Synthetix` and is used to exchange synths.
22     ISynthetix public constant SYNTHETIX =
23         ISynthetix(0xC011a73ee8576Fb46F5E1c5751cA3B9Fe0af2a6F);
24     // "SADDLE" in bytes32 form
25     bytes32 public constant TRACKING =
26         0x534144444c450000000000000000000000000000000000000000000000000000;
27 
28     /**
29      * @notice Initializes the contract when deploying this directly. This prevents
30      * others from calling initialize() on the target contract and setting themself as the owner.
31      */
32     constructor() public {
33         initialize();
34     }
35 
36     /**
37      * @notice This modifier checks if the caller is the owner
38      */
39     modifier onlyOwner() {
40         require(msg.sender == owner, "is not owner");
41         _;
42     }
43 
44     /**
45      * @notice Sets the `owner` as the caller of this function
46      */
47     function initialize() public initializer {
48         require(owner == address(0), "owner already set");
49         owner = msg.sender;
50     }
51 
52     /**
53      * @notice Swaps the synth to another synth via the Synthetix protocol.
54      * @param sourceKey currency key of the source synth
55      * @param synthAmount amount of the synth to swap
56      * @param destKey currency key of the destination synth
57      * @return amount of the destination synth received
58      */
59     function swapSynth(
60         bytes32 sourceKey,
61         uint256 synthAmount,
62         bytes32 destKey
63     ) external onlyOwner returns (uint256) {
64         return
65             SYNTHETIX.exchangeWithTracking(
66                 sourceKey,
67                 synthAmount,
68                 destKey,
69                 msg.sender,
70                 TRACKING
71             );
72     }
73 
74     /**
75      * @notice Approves the given `tokenFrom` and swaps it to another token via the given `swap` pool.
76      * @param swap the address of a pool to swap through
77      * @param tokenFrom the address of the stored synth
78      * @param tokenFromIndex the index of the token to swap from
79      * @param tokenToIndex the token the user wants to swap to
80      * @param tokenFromAmount the amount of the token to swap
81      * @param minAmount the min amount the user would like to receive, or revert.
82      * @param deadline latest timestamp to accept this transaction
83      * @param recipient the address of the recipient
84      */
85     function swapSynthToToken(
86         ISwap swap,
87         IERC20 tokenFrom,
88         uint8 tokenFromIndex,
89         uint8 tokenToIndex,
90         uint256 tokenFromAmount,
91         uint256 minAmount,
92         uint256 deadline,
93         address recipient
94     ) external onlyOwner returns (IERC20, uint256) {
95         tokenFrom.approve(address(swap), tokenFromAmount);
96         swap.swap(
97             tokenFromIndex,
98             tokenToIndex,
99             tokenFromAmount,
100             minAmount,
101             deadline
102         );
103         IERC20 tokenTo = swap.getToken(tokenToIndex);
104         uint256 balance = tokenTo.balanceOf(address(this));
105         tokenTo.safeTransfer(recipient, balance);
106         return (tokenTo, balance);
107     }
108 
109     /**
110      * @notice Withdraws the given amount of `token` to the `recipient`.
111      * @param token the address of the token to withdraw
112      * @param recipient the address of the account to receive the token
113      * @param withdrawAmount the amount of the token to withdraw
114      * @param shouldDestroy whether this contract should be destroyed after this call
115      */
116     function withdraw(
117         IERC20 token,
118         address recipient,
119         uint256 withdrawAmount,
120         bool shouldDestroy
121     ) external onlyOwner {
122         token.safeTransfer(recipient, withdrawAmount);
123         if (shouldDestroy) {
124             _destroy();
125         }
126     }
127 
128     /**
129      * @notice Destroys this contract. Only owner can call this function.
130      */
131     function destroy() external onlyOwner {
132         _destroy();
133     }
134 
135     function _destroy() internal {
136         selfdestruct(msg.sender);
137     }
138 }
