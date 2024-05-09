1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.16;
3 
4 /**
5  * @dev EtherSwap is a contract for swapping Ether across chains.
6  *
7  *
8  * This contract should be deployed on the chains you want to swap Ether on.
9  *
10  *
11  * How does a swap work?
12  *
13  * A user would announce his intention to swap Ether on a chain by calling the
14  * contract's overloaded {commit} function with:
15  *  - `msg.value` equal to the contract's `fee` + `_payout`
16  *  - `_expectedAmount` the expected amount of ether to receive on the target
17  *     chain
18  *  - `_lockTimeSec` the duration the swap offer is valid
19  *  - `_secretHash` the hash of the secret that will be revealed to claim the
20  *    swap
21  *  - `_payout` the amount of ether to be paid to the counterparty claiming the
22  *    swap
23  *  - `_recipient` either set to the ZERO_ADDRESS (if counterparty is unknown) or
24  *    to the address of the counterparty
25  *
26  * A counterparty that wants to match this trade would first have to check
27  * whether the duration of the offer is enough for him to complete the swap.
28  * If so, he would call the {changeRecipient} function to designate himself as
29  * the recipient of the funds locked for this trade.
30  *
31  * Then he would call the {commit} function on the target chain with:
32  *  - `msg.sender` set to the same address that was used in `changeRecipient`
33  *  - `_recipient` set to the user who created the swap on the source chain
34  *  - `_expectedAmount` expected amount of ether to receive should be set to the
35  *    amount of ether locked in source chain swap
36  *  - `_swapEndTimestamp` the duration should be set to a value lower than the
37  *    source swap's endTimeStamp (if source endTimeStamp is bigger than
38  *    recipientChangeLockDuration, the endTimestamp should be set to a value
39  *    lower than recipientChangeLockDuration)
40  *  - `_hashedSecret` should be set to the same value as the source swap's
41  *    `_hashedSecret`.
42  *
43  * Once the target swap is created, the user who created the source swap would
44  * make sure that the target swap is created with the expected params and then
45  * call the {claim} function on the target chain with the secret that was used
46  * to create the source swap. If the secret is correct the user would  receive
47  * the amount of ether locked on the target chain.
48  *
49  * Now the counterparty knows the secret and can call the `claim` function on
50  * the source chain with it. This call should happen within the endTimestamp
51  * of the source swap. If that is the case the counterparty would receive the
52  * amount of ether locked on the source chain. If the counterparty calls the
53  * {claim} function after the endTimestamp of the source swap has passed he
54  * won't receive any funds.
55  *
56  * ATTENTION: A counterparty matching a swap should make sure to have enough
57  * time to submit the proof once it is being revealed by the user. Failure to
58  * submit the {claim} transaction in time would result in the counterparty not
59  * receiving any funds on the source chain.
60  *
61  * How does a refund work?
62  *
63  * If a swap didn't occur, once the endTimestamp of the swap has passed, the
64  * parties can call the {refund} function to receive their funds back.
65  *
66  * Fees
67  *
68  * The contract can be deployed with a _feePerMillion value. This value would
69  * indicate the amount of ETH that would be taken from the amount of ETH locked.
70  *
71  * The accrued fees can be sent to the _feeRecipient address by calling the
72  * {withdrawFees} function.
73  */
74 contract EtherSwap {
75 
76     struct Swap {
77         bytes32 hashedSecret;
78         address payable initiator;
79         // timestamp after which the swap is expired, can no longer be claimed and can be reimbursed
80         uint64 endTimeStamp;
81         address payable recipient;
82         // timestamp after which the recipient of the swap can be changed
83         // used to prevent dos attacks by locking swaps of users with a random address
84         uint64 changeRecipientTimestamp;
85         uint256 value;
86         uint256 expectedAmount;
87     }
88 
89     uint32 public numberOfSwaps;
90     // duration in seconds of the lock put on swaps to prevent changing their recipient repeatedly
91     uint64 public recipientChangeLockDuration;
92 
93     address payable public feeRecipient;
94     // the fee on a swap will be `swapValue * feePerMillion / 1_000_000`
95     uint64 public feePerMillion;
96     uint256 public collectedFees;
97 
98     mapping(uint32 => Swap) public swaps;
99 
100     event Commit(address initiator, address recipient, uint256 value, uint256 expectedAmount, uint64 endTimeStamp, bytes32 indexed hashedSecret, uint32 indexed id);
101     event ChangeRecipient(address recipient, uint32 indexed id);
102     event Claim(address recipient, uint256 value, bytes32 proof, uint32 indexed id);
103     event Refund(uint32 indexed id);
104     event WithdrawFees(uint256 value);
105 
106     constructor (uint64 _recipientChangeLockDuration, address payable _feeRecipient, uint64 _feePerMillion) {
107         recipientChangeLockDuration = _recipientChangeLockDuration;
108         feeRecipient = _feeRecipient;
109         feePerMillion = _feePerMillion;
110         // Pay the tx.origin to incentivize deployment via a contract using create2 allowing us to pre-compile
111         // the contract address
112         payable(tx.origin).transfer(address(this).balance);
113     }
114 
115     /**
116     * @dev Commit to swap
117     *
118     * This function can be directly called by users matching an already committed swap
119     * and they know the end timestamp and recipient they should use.
120     *
121     * @param _swapEndTimestamp the timestamp at which the commit expires
122     * @param _hashedSecret the hashed secret
123     * @param _payout the value paid to the counterparty claiming the swap
124     * @param _expectedAmount the value expected by the committer in return for _payout
125     * @param _recipient the recipient of the swap - can be the zero address
126     */
127     function commit(uint64 _swapEndTimestamp, bytes32 _hashedSecret, uint256 _payout, uint256 _expectedAmount, address payable _recipient) public payable {
128         require(block.timestamp < _swapEndTimestamp, "Swap end timestamp must be in the future");
129         require(_payout != 0, "Cannot commit to 0 payout");
130         require(_expectedAmount != 0, "Cannot commit to 0 expected amount");
131 
132         uint256 fee = feeFromSwapValue(_payout);
133         require(msg.value == fee + _payout, "Ether value does not match payout + fee");
134 
135         Swap memory swap;
136         swap.hashedSecret = _hashedSecret;
137         swap.initiator = payable(msg.sender);
138         swap.recipient = _recipient;
139         swap.endTimeStamp = _swapEndTimestamp;
140         swap.changeRecipientTimestamp = 0;
141         swap.value = _payout;
142         swap.expectedAmount = _expectedAmount;
143 
144         if (_recipient != address(0)) {
145             swap.changeRecipientTimestamp = type(uint64).max;
146         }
147 
148         swaps[numberOfSwaps] = swap;
149 
150         emit Commit(msg.sender, _recipient, _payout, _expectedAmount, swap.endTimeStamp, _hashedSecret, numberOfSwaps);
151 
152         numberOfSwaps = numberOfSwaps + 1;
153     }
154 
155     /**
156     * @dev Commit to swap
157     *
158     * This function can be called by users uncertain as to when their transaction will be mined
159     *
160     * @param _transactionExpiryTime the timestamp at which the transaction expires
161     *        used to make sure the user does not see himself committed later than expected
162     * @param _lockTimeSec the duration of the swap lock
163     *        swap will expire at block.timestamp + _lockTimeSec
164     * @param _hashedSecret the hashed secret
165     * @param _payout the value paid to the counterparty claiming the swap
166     * @param _expectedAmount the value expected by the committer in return for _payout
167     * @param _recipient the recipient of the swap
168     *        can be the zero address
169     */
170     function commit(uint64 _transactionExpiryTime, uint64 _lockTimeSec, bytes32 _hashedSecret, uint256 _payout, uint256 _expectedAmount, address payable _recipient) external payable {
171         require(block.timestamp < _transactionExpiryTime, "Transaction no longer valid");
172         commit(uint64(block.timestamp) + _lockTimeSec, _hashedSecret, _payout, _expectedAmount, _recipient);
173     }
174 
175     /**
176     * @dev Change recipient of an existing swap
177     *
178     * Call this function when you want to match a swap to set yourself as
179     * the recipient of the swap for `recipientChangeLockDuration` seconds
180     *
181     * @param _swapId the swap id
182     * @param _recipient the recipient to be set
183     */
184     function changeRecipient(uint32 _swapId, address payable _recipient) external {
185         require(_swapId < numberOfSwaps, "No swap with corresponding id");
186         require(swaps[_swapId].changeRecipientTimestamp <= block.timestamp, "Cannot change recipient: timestamp");
187 
188         swaps[_swapId].recipient = _recipient;
189         swaps[_swapId].changeRecipientTimestamp = uint64(block.timestamp) + recipientChangeLockDuration;
190 
191         emit ChangeRecipient(_recipient, _swapId);
192     }
193 
194     /**
195     * @dev Claim a swap
196     *
197     * Claim a swap to sent its locked value to its recipient by revealing the hashed secret
198     *
199     * @param _id the swap id
200     * @param _proof the proof that once hashed produces the `hashedSecret` committed to in the swap
201     */
202     function claim(uint32 _id, bytes32 _proof) external {
203         require(_id < numberOfSwaps, "No swap with corresponding id");
204 
205         Swap memory swap = swaps[_id];
206 
207         require(swap.endTimeStamp >= block.timestamp, "Swap expired");
208         require(swap.recipient != address(0), "Swap has no recipient");
209 
210         bytes32 hashedSecret = keccak256(abi.encode(_proof));
211         require(hashedSecret == swap.hashedSecret, "Incorrect secret");
212 
213         collectedFees = collectedFees + feeFromSwapValue(swap.value);
214         clean(_id);
215         swap.recipient.transfer(swap.value);
216         emit Claim(swap.recipient, swap.value, _proof, _id);
217     }
218 
219     /**
220     * @dev Refund a swap
221     *
222     * Refund an expired swap by transferring back its locked value to the swap initiator.
223     * Requires the swap to be expired.
224     * Also reimburses the eventual fee locked for the swap.
225     *
226     * @param id the swap id
227     */
228     function refund(uint32 id) external {
229         require(id < numberOfSwaps, "No swap with corresponding id");
230         require(swaps[id].endTimeStamp < block.timestamp, "TimeStamp violation");
231         require(swaps[id].value > 0, "Nothing to refund");
232 
233         uint256 value = swaps[id].value;
234         uint256 fee = feeFromSwapValue(value);
235         address payable initiator = swaps[id].initiator;
236 
237         clean(id);
238 
239         initiator.transfer(value + fee);
240         emit Refund(id);
241     }
242 
243     /*
244     * @dev Withdraw the fees
245     *
246     * Send the total collected fees to the `feeRecipient` address.
247     */
248     function withdrawFees() external {
249         uint256 toTransfer = collectedFees;
250         collectedFees = 0;
251         feeRecipient.transfer(toTransfer);
252         emit WithdrawFees(toTransfer);
253     }
254 
255     /**
256     * @dev Clean a swap from storage
257     *
258     * @param id the swap id
259     */
260     function clean(uint32 id) private {
261         Swap storage swap = swaps[id];
262         delete swap.hashedSecret;
263         delete swap.initiator;
264         delete swap.endTimeStamp;
265         delete swap.recipient;
266         delete swap.changeRecipientTimestamp;
267         delete swap.value;
268         delete swap.expectedAmount;
269         delete swaps[id];
270     }
271 
272     /**
273     * @dev Get the fee paid for a swap from its swap value
274     *
275     * @param value the swap value
276     * @return the fee paid for the swap
277     */
278     function feeFromSwapValue(uint256 value) public view returns (uint256) {
279         uint256 fee = value * feePerMillion / 1_000_000;
280         return fee;
281     }
282 }