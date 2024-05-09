1 pragma solidity ^0.5.1;
2 
3 interface CompatibleERC20 {
4     // Modified to not return boolean
5     function transfer(address to, uint256 value) external;
6     function transferFrom(address from, address to, uint256 value) external;
7     function approve(address spender, uint256 value) external;
8 
9     // Not modifier
10     function totalSupply() external view returns (uint256);
11     function balanceOf(address who) external view returns (uint256);
12     function allowance(address owner, address spender) external view returns (uint256);
13     event Transfer(address indexed from, address indexed to, uint256 value);
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 interface ERC20SwapContract {
18     /// @notice Initiates the atomic swap.
19     ///
20     /// @param _swapID The unique atomic swap id.
21     /// @param _spender The address of the withdrawing trader.
22     /// @param _secretLock The hash of the secret (Hash Lock).
23     /// @param _timelock The unix timestamp when the swap expires.
24     /// @param _value The value of the atomic swap.
25     function initiate(
26         bytes32 _swapID,
27         address _spender,
28         bytes32 _secretLock,
29         uint256 _timelock,
30         uint256 _value
31     ) external;
32 
33     /// @notice Initiates the atomic swap with broker fees.
34     ///
35     /// @param _swapID The unique atomic swap id.
36     /// @param _spender The address of the withdrawing trader.
37     /// @param _broker The address of the broker.
38     /// @param _brokerFee The fee to be paid to the broker on success.
39     /// @param _secretLock The hash of the secret (Hash Lock).
40     /// @param _timelock The unix timestamp when the swap expires.
41     /// @param _value The value of the atomic swap.
42     function initiateWithFees(
43         bytes32 _swapID,
44         address _spender,
45         address _broker,
46         uint256 _brokerFee,
47         bytes32 _secretLock,
48         uint256 _timelock,
49         uint256 _value
50     ) external;
51 
52     /// @notice Redeems an atomic swap.
53     ///
54     /// @param _swapID The unique atomic swap id.
55     /// @param _receiver The receiver's address.
56     /// @param _secretKey The secret of the atomic swap.
57     function redeem(bytes32 _swapID, address _receiver, bytes32 _secretKey) external;
58 
59     /// @notice Refunds an atomic swap.
60     ///
61     /// @param _swapID The unique atomic swap id.
62     function refund(bytes32 _swapID) external;
63 
64     /// @notice Allows broker fee withdrawals.
65     ///
66     /// @param _amount The withdrawal amount.
67     function withdrawBrokerFees(uint256 _amount) external;
68 
69     /// @notice Audits an atomic swap.
70     ///
71     /// @param _swapID The unique atomic swap id.
72     function audit(bytes32 _swapID) external view returns (uint256 timelock, uint256 value, address to, uint256 brokerFee, address broker, address from, bytes32 secretLock);
73 
74     /// @notice Audits the secret of an atomic swap.
75     ///
76     /// @param _swapID The unique atomic swap id.
77     function auditSecret(bytes32 _swapID) external view  returns (bytes32 secretKey);
78 
79     /// @notice Checks whether a swap is refundable or not.
80     ///
81     /// @param _swapID The unique atomic swap id.
82     function refundable(bytes32 _swapID) external view returns (bool);
83 
84     /// @notice Checks whether a swap is initiatable or not.
85     ///
86     /// @param _swapID The unique atomic swap id.
87     function initiatable(bytes32 _swapID) external view returns (bool);
88 
89     /// @notice Checks whether a swap is redeemable or not.
90     ///
91     /// @param _swapID The unique atomic swap id.
92     function redeemable(bytes32 _swapID) external view returns (bool);
93 
94     /// @notice Generates a deterministic swap id using initiate swap details.
95     ///
96     /// @param _secretLock The hash of the secret.
97     /// @param _timelock The expiry timestamp.
98     function swapID(bytes32 _secretLock, uint256 _timelock) external pure returns (bytes32);
99 }
100 
101 /// @notice WBTCSwapContract implements the ERC20SwapContract interface.
102 contract WBTCSwapContract is ERC20SwapContract {
103     string public VERSION; // Passed in as a constructor parameter.
104     address public TOKEN_ADDRESS; // Address of the ERC20 contract. Passed in as a constructor parameter
105 
106     struct Swap {
107         uint256 timelock;
108         uint256 value;
109         uint256 brokerFee;
110         bytes32 secretLock;
111         bytes32 secretKey;
112         address funder;
113         address spender;
114         address broker;
115     }
116 
117     enum States {
118         INVALID,
119         OPEN,
120         CLOSED,
121         EXPIRED
122     }
123 
124     // Events
125     event LogOpen(bytes32 _swapID, address _spender, bytes32 _secretLock);
126     event LogExpire(bytes32 _swapID);
127     event LogClose(bytes32 _swapID, bytes32 _secretKey);
128 
129     // Storage
130     mapping (bytes32 => Swap) private swaps;
131     mapping (bytes32 => States) private swapStates;
132     mapping (address => uint256) public brokerFees;
133     mapping (bytes32 => uint256) public redeemedAt;
134 
135     /// @notice Throws if the swap is not invalid (i.e. has already been opened)
136     modifier onlyInvalidSwaps(bytes32 _swapID) {
137         require(swapStates[_swapID] == States.INVALID, "swap opened previously");
138         _;
139     }
140 
141     /// @notice Throws if the swap is not open.
142     modifier onlyOpenSwaps(bytes32 _swapID) {
143         require(swapStates[_swapID] == States.OPEN, "swap not open");
144         _;
145     }
146 
147     /// @notice Throws if the swap is not closed.
148     modifier onlyClosedSwaps(bytes32 _swapID) {
149         require(swapStates[_swapID] == States.CLOSED, "swap not redeemed");
150         _;
151     }
152 
153     /// @notice Throws if the swap is not expirable.
154     modifier onlyExpirableSwaps(bytes32 _swapID) {
155         /* solium-disable-next-line security/no-block-members */
156         require(now >= swaps[_swapID].timelock, "swap not expirable");
157         _;
158     }
159 
160     /// @notice Throws if the secret key is not valid.
161     modifier onlyWithSecretKey(bytes32 _swapID, bytes32 _secretKey) {
162         require(swaps[_swapID].secretLock == sha256(abi.encodePacked(_secretKey)), "invalid secret");
163         _;
164     }
165 
166     /// @notice Throws if the caller is not the authorized spender.
167     modifier onlySpender(bytes32 _swapID, address _spender) {
168         require(swaps[_swapID].spender == _spender, "unauthorized spender");
169         _;
170     }
171 
172     /// @notice The contract constructor.
173     ///
174     /// @param _VERSION A string defining the contract version.
175     constructor(string memory _VERSION, address _TOKEN_ADDRESS) public {
176         VERSION = _VERSION;
177         TOKEN_ADDRESS = _TOKEN_ADDRESS;
178     }
179 
180 /// @notice Initiates the atomic swap.
181     ///
182     /// @param _swapID The unique atomic swap id.
183     /// @param _spender The address of the withdrawing trader.
184     /// @param _secretLock The hash of the secret (Hash Lock).
185     /// @param _timelock The unix timestamp when the swap expires.
186     /// @param _value The value of the atomic swap.
187     function initiate(
188         bytes32 _swapID,
189         address _spender,
190         bytes32 _secretLock,
191         uint256 _timelock,
192         uint256 _value
193     ) external onlyInvalidSwaps(_swapID) {
194         // Transfer the token to the contract
195         // TODO: Initiator will first need to call
196         // ERC20(TOKEN_ADDRESS).approve(address(this), _value)
197         // before this contract can make transfers on the initiator's behalf.
198         CompatibleERC20(TOKEN_ADDRESS).transferFrom(msg.sender, address(this), _value);
199 
200         // Store the details of the swap.
201         Swap memory swap = Swap({
202             timelock: _timelock,
203             value: _value,
204             funder: msg.sender,
205             spender: _spender,
206             broker: address(0x0),
207             brokerFee: 0,
208             secretLock: _secretLock,
209             secretKey: 0x0
210         });
211         swaps[_swapID] = swap;
212         swapStates[_swapID] = States.OPEN;
213 
214         // Logs open event
215         emit LogOpen(_swapID, _spender, _secretLock);
216     }
217 
218     /// @notice Initiates the atomic swap with broker fees.
219     ///
220     /// @param _swapID The unique atomic swap id.
221     /// @param _spender The address of the withdrawing trader.
222     /// @param _broker The address of the broker.
223     /// @param _brokerFee The fee to be paid to the broker on success.
224     /// @param _secretLock The hash of the secret (Hash Lock).
225     /// @param _timelock The unix timestamp when the swap expires.
226     /// @param _value The value of the atomic swap.
227     function initiateWithFees(
228         bytes32 _swapID,
229         address _spender,
230         address _broker,
231         uint256 _brokerFee,
232         bytes32 _secretLock,
233         uint256 _timelock,
234         uint256 _value
235     ) external onlyInvalidSwaps(_swapID) {
236         // Transfer the token to the contract
237         // TODO: Initiator will first need to call
238         // ERC20(TOKEN_ADDRESS).approve(address(this), _value)
239         // before this contract can make transfers on the initiator's behalf.
240         CompatibleERC20(TOKEN_ADDRESS).transferFrom(msg.sender, address(this), _value);
241 
242         // Store the details of the swap.
243         Swap memory swap = Swap({
244             timelock: _timelock,
245             value: _value - _brokerFee,
246             funder: msg.sender,
247             spender: _spender,
248             broker: _broker,
249             brokerFee: _brokerFee,
250             secretLock: _secretLock,
251             secretKey: 0x0
252         });
253         swaps[_swapID] = swap;
254         swapStates[_swapID] = States.OPEN;
255 
256         // Logs open event
257         emit LogOpen(_swapID, _spender, _secretLock);
258     }
259 
260     /// @notice Refunds an atomic swap.
261     ///
262     /// @param _swapID The unique atomic swap id.
263     function refund(bytes32 _swapID) external onlyOpenSwaps(_swapID) onlyExpirableSwaps(_swapID) {
264         // Expire the swap.
265         swapStates[_swapID] = States.EXPIRED;
266 
267         // Transfer the ERC20 value from this contract back to the funding trader.
268         CompatibleERC20(TOKEN_ADDRESS).transfer(swaps[_swapID].funder, swaps[_swapID].value + swaps[_swapID].brokerFee);
269 
270         // Logs expire event
271         emit LogExpire(_swapID);
272     }
273 
274     /// @notice Allows broker fee withdrawals.
275     ///
276     /// @param _amount The withdrawal amount.
277     function withdrawBrokerFees(uint256 _amount) external {
278         require(_amount <= brokerFees[msg.sender]);
279         brokerFees[msg.sender] -= _amount;
280         CompatibleERC20(TOKEN_ADDRESS).transfer(msg.sender, _amount);
281     }
282 
283     /// @notice Audits an atomic swap.
284     ///
285     /// @param _swapID The unique atomic swap id.
286     function audit(bytes32 _swapID) external view returns (uint256 timelock, uint256 value, address to, uint256 brokerFee, address broker, address from, bytes32 secretLock) {
287         Swap memory swap = swaps[_swapID];
288         return (
289             swap.timelock,
290             swap.value,
291             swap.spender,
292             swap.brokerFee,
293             swap.broker,
294             swap.funder,
295             swap.secretLock
296         );
297     }
298 
299     /// @notice Audits the secret of an atomic swap.
300     ///
301     /// @param _swapID The unique atomic swap id.
302     function auditSecret(bytes32 _swapID) external view onlyClosedSwaps(_swapID) returns (bytes32 secretKey) {
303         return swaps[_swapID].secretKey;
304     }
305 
306     /// @notice Redeems an atomic swap.
307     ///
308     /// @param _swapID The unique atomic swap id.
309     /// @param _secretKey The secret of the atomic swap.
310     function redeem(bytes32 _swapID, address _receiver, bytes32 _secretKey) external onlyOpenSwaps(_swapID) onlyWithSecretKey(_swapID, _secretKey) onlySpender(_swapID, msg.sender) {
311         // Close the swap.
312         swaps[_swapID].secretKey = _secretKey;
313         swapStates[_swapID] = States.CLOSED;
314         /* solium-disable-next-line security/no-block-members */
315         redeemedAt[_swapID] = now;
316 
317         // Transfer the ERC20 funds from this contract to the broker.
318         brokerFees[swaps[_swapID].broker] += swaps[_swapID].brokerFee;
319 
320         // Transfer the ERC20 funds from this contract to the withdrawing trader.
321         CompatibleERC20(TOKEN_ADDRESS).transfer(_receiver, swaps[_swapID].value);
322 
323         // Logs close event
324         emit LogClose(_swapID, _secretKey);
325     }
326     
327     /// @notice Checks whether a swap is refundable or not.
328     ///
329     /// @param _swapID The unique atomic swap id.
330     function refundable(bytes32 _swapID) external view returns (bool) {
331         /* solium-disable-next-line security/no-block-members */
332         return (now >= swaps[_swapID].timelock && swapStates[_swapID] == States.OPEN);
333     }
334 
335     /// @notice Checks whether a swap is initiatable or not.
336     ///
337     /// @param _swapID The unique atomic swap id.
338     function initiatable(bytes32 _swapID) external view returns (bool) {
339         return (swapStates[_swapID] == States.INVALID);
340     }
341 
342     /// @notice Checks whether a swap is redeemable or not.
343     ///
344     /// @param _swapID The unique atomic swap id.
345     function redeemable(bytes32 _swapID) external view returns (bool) {
346         return (swapStates[_swapID] == States.OPEN);
347     }
348 
349     /// @notice Generates a deterministic swap id using initiate swap details.
350     ///
351     /// @param _secretLock The hash of the secret.
352     /// @param _timelock The expiry timestamp.
353     function swapID(bytes32 _secretLock, uint256 _timelock) public pure returns (bytes32) {
354         return keccak256(abi.encodePacked(_secretLock, _timelock));
355     }
356 }