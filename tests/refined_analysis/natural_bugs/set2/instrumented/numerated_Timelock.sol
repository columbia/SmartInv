1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "@openzeppelin/contracts/utils/math/SafeMath.sol";
5 
6 // Forked from Compound
7 // See https://github.com/compound-finance/compound-protocol/blob/master/contracts/Timelock.sol
8 contract Timelock {
9     using SafeMath for uint256;
10 
11     event NewAdmin(address indexed newAdmin);
12     event NewPendingAdmin(address indexed newPendingAdmin);
13     event NewDelay(uint256 indexed newDelay);
14     event CancelTransaction(
15         bytes32 indexed txHash,
16         address indexed target,
17         uint256 value,
18         string signature,
19         bytes data,
20         uint256 eta
21     );
22     event ExecuteTransaction(
23         bytes32 indexed txHash,
24         address indexed target,
25         uint256 value,
26         string signature,
27         bytes data,
28         uint256 eta
29     );
30     event QueueTransaction(
31         bytes32 indexed txHash,
32         address indexed target,
33         uint256 value,
34         string signature,
35         bytes data,
36         uint256 eta
37     );
38 
39     uint256 public constant GRACE_PERIOD = 14 days;
40     uint256 public immutable MINIMUM_DELAY;
41     uint256 public constant MAXIMUM_DELAY = 30 days;
42 
43     address public admin;
44     address public pendingAdmin;
45     uint256 public delay;
46 
47     mapping(bytes32 => bool) public queuedTransactions;
48 
49     constructor(
50         address admin_,
51         uint256 delay_,
52         uint256 minDelay_
53     ) {
54         MINIMUM_DELAY = minDelay_;
55         require(delay_ >= minDelay_, "Timelock: Delay must exceed minimum delay.");
56         require(delay_ <= MAXIMUM_DELAY, "Timelock: Delay must not exceed maximum delay.");
57         require(admin_ != address(0), "Timelock: Admin must not be 0 address");
58 
59         admin = admin_;
60         delay = delay_;
61     }
62 
63     receive() external payable {}
64 
65     function setDelay(uint256 delay_) public {
66         require(msg.sender == address(this), "Timelock: Call must come from Timelock.");
67         require(delay_ >= MINIMUM_DELAY, "Timelock: Delay must exceed minimum delay.");
68         require(delay_ <= MAXIMUM_DELAY, "Timelock: Delay must not exceed maximum delay.");
69         delay = delay_;
70 
71         emit NewDelay(delay);
72     }
73 
74     function acceptAdmin() public {
75         require(msg.sender == pendingAdmin, "Timelock: Call must come from pendingAdmin.");
76         admin = msg.sender;
77         pendingAdmin = address(0);
78 
79         emit NewAdmin(admin);
80     }
81 
82     function setPendingAdmin(address pendingAdmin_) public {
83         require(msg.sender == address(this), "Timelock: Call must come from Timelock.");
84         pendingAdmin = pendingAdmin_;
85 
86         emit NewPendingAdmin(pendingAdmin);
87     }
88 
89     function queueTransaction(
90         address target,
91         uint256 value,
92         string memory signature,
93         bytes memory data,
94         uint256 eta
95     ) public virtual returns (bytes32) {
96         require(msg.sender == admin, "Timelock: Call must come from admin.");
97         require(eta >= getBlockTimestamp().add(delay), "Timelock: Estimated execution block must satisfy delay.");
98 
99         bytes32 txHash = getTxHash(target, value, signature, data, eta);
100         queuedTransactions[txHash] = true;
101 
102         emit QueueTransaction(txHash, target, value, signature, data, eta);
103         return txHash;
104     }
105 
106     function cancelTransaction(
107         address target,
108         uint256 value,
109         string memory signature,
110         bytes memory data,
111         uint256 eta
112     ) public {
113         require(msg.sender == admin, "Timelock: Call must come from admin.");
114 
115         _cancelTransaction(target, value, signature, data, eta);
116     }
117 
118     function _cancelTransaction(
119         address target,
120         uint256 value,
121         string memory signature,
122         bytes memory data,
123         uint256 eta
124     ) internal {
125         bytes32 txHash = getTxHash(target, value, signature, data, eta);
126         queuedTransactions[txHash] = false;
127 
128         emit CancelTransaction(txHash, target, value, signature, data, eta);
129     }
130 
131     function executeTransaction(
132         address target,
133         uint256 value,
134         string memory signature,
135         bytes memory data,
136         uint256 eta
137     ) public payable virtual returns (bytes memory) {
138         require(msg.sender == admin, "Timelock: Call must come from admin.");
139 
140         bytes32 txHash = getTxHash(target, value, signature, data, eta);
141         require(queuedTransactions[txHash], "Timelock: Transaction hasn't been queued.");
142         require(getBlockTimestamp() >= eta, "Timelock: Transaction hasn't surpassed time lock.");
143         require(getBlockTimestamp() <= eta.add(GRACE_PERIOD), "Timelock: Transaction is stale.");
144 
145         queuedTransactions[txHash] = false;
146 
147         bytes memory callData;
148 
149         if (bytes(signature).length == 0) {
150             callData = data;
151         } else {
152             callData = abi.encodePacked(bytes4(keccak256(bytes(signature))), data);
153         }
154 
155         // solhint-disable-next-line avoid-low-level-calls
156         (bool success, bytes memory returnData) = target.call{value: value}(callData); //solhint-disable avoid-call-value
157         require(success, "Timelock: Transaction execution reverted.");
158 
159         emit ExecuteTransaction(txHash, target, value, signature, data, eta);
160 
161         return returnData;
162     }
163 
164     function getTxHash(
165         address target,
166         uint256 value,
167         string memory signature,
168         bytes memory data,
169         uint256 eta
170     ) public pure returns (bytes32) {
171         return keccak256(abi.encode(target, value, signature, data, eta));
172     }
173 
174     function getBlockTimestamp() internal view returns (uint256) {
175         return block.timestamp;
176     }
177 }
