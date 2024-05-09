1 pragma solidity ^0.5.1;
2 
3 /// @notice EthSwapContract implements the RenEx atomic swapping interface
4 /// for Ether values. Does not support ERC20 tokens.
5 contract EthSwapContract {
6     string public VERSION; // Passed in as a constructor parameter.
7 
8     struct Swap {
9         uint256 timelock;
10         uint256 value;
11         uint256 brokerFee;
12         bytes32 secretLock;
13         bytes32 secretKey;
14         address payable funder;
15         address payable spender;
16         address payable broker;
17     }
18 
19     enum States {
20         INVALID,
21         OPEN,
22         CLOSED,
23         EXPIRED
24     }
25 
26     // Events
27     event LogOpen(bytes32 _swapID, address _spender, bytes32 _secretLock);
28     event LogExpire(bytes32 _swapID);
29     event LogClose(bytes32 _swapID, bytes32 _secretKey);
30 
31     // Storage
32     mapping (bytes32 => Swap) private swaps;
33     mapping (bytes32 => States) private swapStates;
34     mapping (address => uint256) public brokerFees;
35     mapping (bytes32 => uint256) public redeemedAt;
36 
37     /// @notice Throws if the swap is not invalid (i.e. has already been opened)
38     modifier onlyInvalidSwaps(bytes32 _swapID) {
39         require(swapStates[_swapID] == States.INVALID, "swap opened previously");
40         _;
41     }
42 
43     /// @notice Throws if the swap is not open.
44     modifier onlyOpenSwaps(bytes32 _swapID) {
45         require(swapStates[_swapID] == States.OPEN, "swap not open");
46         _;
47     }
48 
49     /// @notice Throws if the swap is not closed.
50     modifier onlyClosedSwaps(bytes32 _swapID) {
51         require(swapStates[_swapID] == States.CLOSED, "swap not redeemed");
52         _;
53     }
54 
55     /// @notice Throws if the swap is not expirable.
56     modifier onlyExpirableSwaps(bytes32 _swapID) {
57         /* solium-disable-next-line security/no-block-members */
58         require(now >= swaps[_swapID].timelock, "swap not expirable");
59         _;
60     }
61 
62     /// @notice Throws if the secret key is not valid.
63     modifier onlyWithSecretKey(bytes32 _swapID, bytes32 _secretKey) {
64         require(swaps[_swapID].secretLock == sha256(abi.encodePacked(_secretKey)), "invalid secret");
65         _;
66     }
67 
68     /// @notice Throws if the caller is not the authorized spender.
69     modifier onlySpender(bytes32 _swapID, address _spender) {
70         require(swaps[_swapID].spender == _spender, "unauthorized spender");
71         _;
72     }
73 
74     /// @notice The contract constructor.
75     ///
76     /// @param _VERSION A string defining the contract version.
77     constructor(string memory _VERSION) public {
78         VERSION = _VERSION;
79     }
80 
81     /// @notice Initiates the atomic swap with fees.
82     ///
83     /// @param _swapID The unique atomic swap id.
84     /// @param _spender The address of the withdrawing trader.
85     /// @param _broker The address of the broker.
86     /// @param _brokerFee The fee to be paid to the broker on success.
87     /// @param _secretLock The hash of the secret (Hash Lock).
88     /// @param _timelock The unix timestamp when the swap expires.
89     /// @param _value The value of the atomic swap.
90     function initiateWithFees(
91         bytes32 _swapID,
92         address _spender,
93         address _broker,
94         uint256 _brokerFee,
95         bytes32 _secretLock,
96         uint256 _timelock,
97         uint256 _value
98     ) external onlyInvalidSwaps(_swapID) payable {
99         require(_value == msg.value && _value >= _brokerFee);
100         // Store the details of the swap.
101         Swap memory swap = Swap({
102             timelock: _timelock,
103             brokerFee: _brokerFee,
104             value: _value - _brokerFee,
105             funder: address(uint160(msg.sender)),
106             spender: address(uint160(_spender)),
107             broker: address(uint160(_broker)),
108             secretLock: _secretLock,
109             secretKey: 0x0
110         });
111         swaps[_swapID] = swap;
112         swapStates[_swapID] = States.OPEN;
113 
114         // Logs open event
115         emit LogOpen(_swapID, _spender, _secretLock);
116     }
117 
118     /// @notice Initiates the atomic swap.
119     ///
120     /// @param _swapID The unique atomic swap id.
121     /// @param _spender The address of the withdrawing trader.
122     /// @param _secretLock The hash of the secret (Hash Lock).
123     /// @param _timelock The unix timestamp when the swap expires.
124     /// @param _value The value of the atomic swap.
125     function initiate(
126         bytes32 _swapID,
127         address _spender,
128         bytes32 _secretLock,
129         uint256 _timelock,
130         uint256 _value
131     ) external onlyInvalidSwaps(_swapID) payable {
132         require(_value == msg.value);
133         // Store the details of the swap.
134         Swap memory swap = Swap({
135             timelock: _timelock,
136             brokerFee: 0,
137             value: _value,
138             funder: address(uint160(msg.sender)),
139             spender: address(uint160(_spender)),
140             broker: address(0x0),
141             secretLock: _secretLock,
142             secretKey: 0x0
143         });
144         swaps[_swapID] = swap;
145         swapStates[_swapID] = States.OPEN;
146 
147         // Logs open event
148         emit LogOpen(_swapID, _spender, _secretLock);
149     }
150 
151     /// @notice Redeems an atomic swap.
152     ///
153     /// @param _swapID The unique atomic swap id.
154     /// @param _receiver The receiver's address.
155     /// @param _secretKey The secret of the atomic swap.
156     function redeem(bytes32 _swapID, address _receiver, bytes32 _secretKey) external onlyOpenSwaps(_swapID) onlyWithSecretKey(_swapID, _secretKey) onlySpender(_swapID, msg.sender) {
157         address payable receiver = address(uint160(_receiver));
158 
159         // Close the swap.
160         swaps[_swapID].secretKey = _secretKey;
161         swapStates[_swapID] = States.CLOSED;
162         /* solium-disable-next-line security/no-block-members */
163         redeemedAt[_swapID] = now;
164 
165         // Update the broker fees to the broker.
166         brokerFees[swaps[_swapID].broker] += swaps[_swapID].brokerFee;
167 
168         // Transfer the ETH funds from this contract to the receiver.
169         receiver.transfer(swaps[_swapID].value);
170 
171         // Logs close event
172         emit LogClose(_swapID, _secretKey);
173     }
174 
175     /// @notice Refunds an atomic swap.
176     ///
177     /// @param _swapID The unique atomic swap id.
178     function refund(bytes32 _swapID) external onlyOpenSwaps(_swapID) onlyExpirableSwaps(_swapID) {
179         // Expire the swap.
180         swapStates[_swapID] = States.EXPIRED;
181 
182         // Transfer the ETH value from this contract back to the ETH trader.
183         swaps[_swapID].funder.transfer(swaps[_swapID].value + swaps[_swapID].brokerFee);
184 
185         // Logs expire event
186         emit LogExpire(_swapID);
187     }
188 
189     /// @notice Allows broker fee withdrawals.
190     ///
191     /// @param _amount The withdrawal amount.
192     function withdrawBrokerFees(uint256 _amount) external {
193         require(_amount <= brokerFees[msg.sender]);
194         brokerFees[msg.sender] -= _amount;
195         msg.sender.transfer(_amount);
196     }
197 
198     /// @notice Audits an atomic swap.
199     ///
200     /// @param _swapID The unique atomic swap id.
201     function audit(bytes32 _swapID) external view returns (uint256 timelock, uint256 value, address to, uint256 brokerFee, address broker, address from, bytes32 secretLock) {
202         Swap memory swap = swaps[_swapID];
203         return (
204             swap.timelock,
205             swap.value,
206             swap.spender,
207             swap.brokerFee,
208             swap.broker,
209             swap.funder,
210             swap.secretLock
211         );
212     }
213 
214     /// @notice Audits the secret of an atomic swap.
215     ///
216     /// @param _swapID The unique atomic swap id.
217     function auditSecret(bytes32 _swapID) external view onlyClosedSwaps(_swapID) returns (bytes32 secretKey) {
218         return swaps[_swapID].secretKey;
219     }
220 
221     /// @notice Checks whether a swap is refundable or not.
222     ///
223     /// @param _swapID The unique atomic swap id.
224     function refundable(bytes32 _swapID) external view returns (bool) {
225         /* solium-disable-next-line security/no-block-members */
226         return (now >= swaps[_swapID].timelock && swapStates[_swapID] == States.OPEN);
227     }
228 
229     /// @notice Checks whether a swap is initiatable or not.
230     ///
231     /// @param _swapID The unique atomic swap id.
232     function initiatable(bytes32 _swapID) external view returns (bool) {
233         return (swapStates[_swapID] == States.INVALID);
234     }
235 
236     /// @notice Checks whether a swap is redeemable or not.
237     ///
238     /// @param _swapID The unique atomic swap id.
239     function redeemable(bytes32 _swapID) external view returns (bool) {
240         return (swapStates[_swapID] == States.OPEN);
241     }
242 
243     /// @notice Generates a deterministic swap id using initiate swap details.
244     ///
245     /// @param _secretLock The hash of the secret.
246     /// @param _timelock The expiry timestamp.
247     function swapID(bytes32 _secretLock, uint256 _timelock) public pure returns (bytes32) {
248         return keccak256(abi.encodePacked(_secretLock, _timelock));
249     }
250 }