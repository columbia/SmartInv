1 pragma solidity 0.4.24;
2 
3 /// @notice RenExAtomicSwapper implements the RenEx atomic swapping interface
4 /// for Ether values. Does not support ERC20 tokens.
5 contract RenExAtomicSwapper {
6     string public VERSION; // Passed in as a constructor parameter.
7 
8     struct Swap {
9         uint256 timelock;
10         uint256 value;
11         address ethTrader;
12         address withdrawTrader;
13         bytes32 secretLock;
14         bytes32 secretKey;
15     }
16 
17     enum States {
18         INVALID,
19         OPEN,
20         CLOSED,
21         EXPIRED
22     }
23 
24     // Events
25     event LogOpen(bytes32 _swapID, address _withdrawTrader, bytes32 _secretLock);
26     event LogExpire(bytes32 _swapID);
27     event LogClose(bytes32 _swapID, bytes32 _secretKey);
28 
29     // Storage
30     mapping (bytes32 => Swap) private swaps;
31     mapping (bytes32 => States) private swapStates;
32     mapping (bytes32 => uint256) public redeemedAt;
33 
34     /// @notice Throws if the swap is not invalid (i.e. has already been opened)
35     modifier onlyInvalidSwaps(bytes32 _swapID) {
36         require(swapStates[_swapID] == States.INVALID, "swap opened previously");
37         _;
38     }
39 
40     /// @notice Throws if the swap is not open.
41     modifier onlyOpenSwaps(bytes32 _swapID) {
42         require(swapStates[_swapID] == States.OPEN, "swap not open");
43         _;
44     }
45 
46     /// @notice Throws if the swap is not closed.
47     modifier onlyClosedSwaps(bytes32 _swapID) {
48         require(swapStates[_swapID] == States.CLOSED, "swap not redeemed");
49         _;
50     }
51 
52     /// @notice Throws if the swap is not expirable.
53     modifier onlyExpirableSwaps(bytes32 _swapID) {
54         /* solium-disable-next-line security/no-block-members */
55         require(now >= swaps[_swapID].timelock, "swap not expirable");
56         _;
57     }
58 
59     /// @notice Throws if the secret key is not valid.
60     modifier onlyWithSecretKey(bytes32 _swapID, bytes32 _secretKey) {
61         require(swaps[_swapID].secretLock == sha256(abi.encodePacked(_secretKey)), "invalid secret");
62         _;
63     }
64 
65     /// @notice The contract constructor.
66     ///
67     /// @param _VERSION A string defining the contract version.
68     constructor(string _VERSION) public {
69         VERSION = _VERSION;
70     }
71 
72     /// @notice Initiates the atomic swap.
73     ///
74     /// @param _swapID The unique atomic swap id.
75     /// @param _withdrawTrader The address of the withdrawing trader.
76     /// @param _secretLock The hash of the secret (Hash Lock).
77     /// @param _timelock The unix timestamp when the swap expires.
78     function initiate(
79         bytes32 _swapID,
80         address _withdrawTrader,
81         bytes32 _secretLock,
82         uint256 _timelock
83     ) external onlyInvalidSwaps(_swapID) payable {
84         // Store the details of the swap.
85         Swap memory swap = Swap({
86             timelock: _timelock,
87             value: msg.value,
88             ethTrader: msg.sender,
89             withdrawTrader: _withdrawTrader,
90             secretLock: _secretLock,
91             secretKey: 0x0
92         });
93         swaps[_swapID] = swap;
94         swapStates[_swapID] = States.OPEN;
95 
96         // Logs open event
97         emit LogOpen(_swapID, _withdrawTrader, _secretLock);
98     }
99 
100     /// @notice Redeems an atomic swap.
101     ///
102     /// @param _swapID The unique atomic swap id.
103     /// @param _secretKey The secret of the atomic swap.
104     function redeem(bytes32 _swapID, bytes32 _secretKey) external onlyOpenSwaps(_swapID) onlyWithSecretKey(_swapID, _secretKey) {
105         // Close the swap.
106         Swap memory swap = swaps[_swapID];
107         swaps[_swapID].secretKey = _secretKey;
108         swapStates[_swapID] = States.CLOSED;
109         /* solium-disable-next-line security/no-block-members */
110         redeemedAt[_swapID] = now;
111 
112         // Transfer the ETH funds from this contract to the withdrawing trader.
113         swap.withdrawTrader.transfer(swap.value);
114 
115         // Logs close event
116         emit LogClose(_swapID, _secretKey);
117     }
118 
119     /// @notice Refunds an atomic swap.
120     ///
121     /// @param _swapID The unique atomic swap id.
122     function refund(bytes32 _swapID) external onlyOpenSwaps(_swapID) onlyExpirableSwaps(_swapID) {
123         // Expire the swap.
124         Swap memory swap = swaps[_swapID];
125         swapStates[_swapID] = States.EXPIRED;
126 
127         // Transfer the ETH value from this contract back to the ETH trader.
128         swap.ethTrader.transfer(swap.value);
129 
130         // Logs expire event
131         emit LogExpire(_swapID);
132     }
133 
134     /// @notice Audits an atomic swap.
135     ///
136     /// @param _swapID The unique atomic swap id.
137     function audit(bytes32 _swapID) external view returns (uint256 timelock, uint256 value, address to, address from, bytes32 secretLock) {
138         Swap memory swap = swaps[_swapID];
139         return (swap.timelock, swap.value, swap.withdrawTrader, swap.ethTrader, swap.secretLock);
140     }
141 
142     /// @notice Audits the secret of an atomic swap.
143     ///
144     /// @param _swapID The unique atomic swap id.
145     function auditSecret(bytes32 _swapID) external view onlyClosedSwaps(_swapID) returns (bytes32 secretKey) {
146         Swap memory swap = swaps[_swapID];
147         return swap.secretKey;
148     }
149 
150     /// @notice Checks whether a swap is refundable or not.
151     ///
152     /// @param _swapID The unique atomic swap id.
153     function refundable(bytes32 _swapID) external view returns (bool) {
154         /* solium-disable-next-line security/no-block-members */
155         return (now >= swaps[_swapID].timelock && swapStates[_swapID] == States.OPEN);
156     }
157 
158     /// @notice Checks whether a swap is initiatable or not.
159     ///
160     /// @param _swapID The unique atomic swap id.
161     function initiatable(bytes32 _swapID) external view returns (bool) {
162         return (swapStates[_swapID] == States.INVALID);
163     }
164 
165     /// @notice Checks whether a swap is redeemable or not.
166     ///
167     /// @param _swapID The unique atomic swap id.
168     function redeemable(bytes32 _swapID) external view returns (bool) {
169         return (swapStates[_swapID] == States.OPEN);
170     }
171 
172     /// @notice Generates a deterministic swap id using initiate swap details.
173     ///
174     /// @param _withdrawTrader The address of the withdrawing trader.
175     /// @param _secretLock The hash of the secret.
176     /// @param _timelock The expiry timestamp.
177     function swapID(address _withdrawTrader, bytes32 _secretLock, uint256 _timelock) public pure returns (bytes32) {
178         return keccak256(abi.encodePacked(_withdrawTrader, _secretLock, _timelock));
179     }
180 }