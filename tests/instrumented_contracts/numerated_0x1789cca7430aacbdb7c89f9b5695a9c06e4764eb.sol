1 pragma solidity ^0.4.21;
2 
3 /** @title  A dual control contract.
4   *
5   * @notice  A general purpose contract that implements dual control over
6   * co-operating contracts through a callback mechanism.
7   *
8   * @dev  This contract implements dual control through a 2-of-N
9   * threshold multi-signature scheme. The contract recognizes a set of N signers,
10   * and will unlock requests with signatures from any distinct pair of them.
11   * This contract signals the unlocking through a co-operative callback
12   * scheme.
13   * This contract also provides time lock and revocation features.
14   * Requests made by a 'primary' account have a default time lock applied.
15   * All other request must pay a 1 ETH stake and have an extended time lock
16   * applied.
17   * A request that is completed will prevent all previous pending requests
18   * that share the same callback from being completed: this is the
19   * revocation feature.
20   *
21   * @author  Gemini Trust Company, LLC
22   */
23 contract Custodian {
24 
25     // TYPES
26     /** @dev  The `Request` struct stores a pending unlocking.
27       * `callbackAddress` and `callbackSelector` are the data required to
28       * make a callback. The custodian completes the process by
29       * calling `callbackAddress.call(callbackSelector, lockId)`, which
30       * signals to the contract co-operating with the Custodian that
31       * the 2-of-N signatures have been provided and verified.
32       */
33     struct Request {
34         bytes32 lockId;
35         bytes4 callbackSelector; // bytes4 and address can be packed into 1 word
36         address callbackAddress;
37         uint256 idx;
38         uint256 timestamp;
39         bool extended;
40     }
41 
42     // EVENTS
43     /// @dev  Emitted by successful `requestUnlock` calls.
44     event Requested(
45         bytes32 _lockId,
46         address _callbackAddress,
47         bytes4  _callbackSelector,
48         uint256 _nonce,
49         address _whitelistedAddress,
50         bytes32 _requestMsgHash,
51         uint256 _timeLockExpiry
52     );
53 
54     /// @dev  Emitted by `completeUnlock` calls on requests in the time-locked state.
55     event TimeLocked(
56         uint256 _timeLockExpiry,
57         bytes32 _requestMsgHash
58     );
59 
60     /// @dev  Emitted by successful `completeUnlock` calls.
61     event Completed(
62         bytes32 _lockId,
63         bytes32 _requestMsgHash,
64         address _signer1,
65         address _signer2
66     );
67 
68     /// @dev  Emitted by `completeUnlock` calls where the callback failed.
69     event Failed(
70         bytes32 _lockId,
71         bytes32 _requestMsgHash,
72         address _signer1,
73         address _signer2
74     );
75 
76     /// @dev  Emitted by successful `extendRequestTimeLock` calls.
77     event TimeLockExtended(
78         uint256 _timeLockExpiry,
79         bytes32 _requestMsgHash
80     );
81 
82     // MEMBERS
83     /** @dev  The count of all requests.
84       * This value is used as a nonce, incorporated into the request hash.
85       */
86     uint256 public requestCount;
87 
88     /// @dev  The set of signers: signatures from two signers unlock a pending request.
89     mapping (address => bool) public signerSet;
90 
91     /// @dev  The map of request hashes to pending requests.
92     mapping (bytes32 => Request) public requestMap;
93 
94     /// @dev  The map of callback addresses to callback selectors to request indexes.
95     mapping (address => mapping (bytes4 => uint256)) public lastCompletedIdxs;
96 
97     /** @dev  The default period of time (in seconds) to time-lock requests.
98       * All requests will be subject to this default time lock, and the duration
99       * is fixed at contract creation.
100       */
101     uint256 public defaultTimeLock;
102 
103     /** @dev  The extended period of time (in seconds) to time-lock requests.
104       * Requests not from the primary account are subject to this time lock.
105       * The primary account may also elect to extend the time lock on requests
106       * that originally received the default.
107       */
108     uint256 public extendedTimeLock;
109 
110     /// @dev  The primary account is the privileged account for making requests.
111     address public primary;
112 
113     // CONSTRUCTOR
114     function Custodian(
115         address[] _signers,
116         uint256 _defaultTimeLock,
117         uint256 _extendedTimeLock,
118         address _primary
119     )
120         public
121     {
122         // check for at least two `_signers`
123         require(_signers.length >= 2);
124 
125         // validate time lock params
126         require(_defaultTimeLock <= _extendedTimeLock);
127         defaultTimeLock = _defaultTimeLock;
128         extendedTimeLock = _extendedTimeLock;
129 
130         primary = _primary;
131 
132         // explicitly initialize `requestCount` to zero
133         requestCount = 0;
134         // turn the array into a set
135         for (uint i = 0; i < _signers.length; i++) {
136             // no zero addresses or duplicates
137             require(_signers[i] != address(0) && !signerSet[_signers[i]]);
138             signerSet[_signers[i]] = true;
139         }
140     }
141 
142     // MODIFIERS
143     modifier onlyPrimary {
144         require(msg.sender == primary);
145         _;
146     }
147 
148     // METHODS
149     /** @notice  Requests an unlocking with a lock identifier and a callback.
150       *
151       * @dev  If called by an account other than the primary a 1 ETH stake
152       * must be paid. This is an anti-spam measure. As well as the callback
153       * and the lock identifier parameters a 'whitelisted address' is required
154       * for compatibility with existing signature schemes.
155       *
156       * @param  _lockId  The identifier of a pending request in a co-operating contract.
157       * @param  _callbackAddress  The address of a co-operating contract.
158       * @param  _callbackSelector  The function selector of a function within
159       * the co-operating contract at address `_callbackAddress`.
160       * @param  _whitelistedAddress  An address whitelisted in existing
161       * offline control protocols.
162       *
163       * @return  requestMsgHash  The hash of a request message to be signed.
164       */
165     function requestUnlock(
166         bytes32 _lockId,
167         address _callbackAddress,
168         bytes4 _callbackSelector,
169         address _whitelistedAddress
170     )
171         public
172         payable
173         returns (bytes32 requestMsgHash)
174     {
175         require(msg.sender == primary || msg.value >= 1 ether);
176 
177         // disallow using a zero value for the callback address
178         require(_callbackAddress != address(0));
179 
180         uint256 requestIdx = ++requestCount;
181         // compute a nonce value
182         // - the blockhash prevents prediction of future nonces
183         // - the address of this contract prevents conflicts with co-operating contracts using this scheme
184         // - the counter prevents conflicts arising from multiple txs within the same block
185         uint256 nonce = uint256(keccak256(block.blockhash(block.number - 1), address(this), requestIdx));
186 
187         requestMsgHash = keccak256(nonce, _whitelistedAddress, uint256(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF));
188 
189         requestMap[requestMsgHash] = Request({
190             lockId: _lockId,
191             callbackSelector: _callbackSelector,
192             callbackAddress: _callbackAddress,
193             idx: requestIdx,
194             timestamp: block.timestamp,
195             extended: false
196         });
197 
198         // compute the expiry time
199         uint256 timeLockExpiry = block.timestamp;
200         if (msg.sender == primary) {
201             timeLockExpiry += defaultTimeLock;
202         } else {
203             timeLockExpiry += extendedTimeLock;
204 
205             // any sender that is not the creator will get the extended time lock
206             requestMap[requestMsgHash].extended = true;
207         }
208 
209         emit Requested(_lockId, _callbackAddress, _callbackSelector, nonce, _whitelistedAddress, requestMsgHash, timeLockExpiry);
210     }
211 
212     /** @notice  Completes a pending unlocking with two signatures.
213       *
214       * @dev  Given a request message hash as two signatures of it from
215       * two distinct signers in the signer set, this function completes the
216       * unlocking of the pending request by executing the callback.
217       *
218       * @param  _requestMsgHash  The request message hash of a pending request.
219       * @param  _recoveryByte1  The public key recovery byte (27 or 28)
220       * @param  _ecdsaR1  The R component of an ECDSA signature (R, S) pair
221       * @param  _ecdsaS1  The S component of an ECDSA signature (R, S) pair
222       * @param  _recoveryByte2  The public key recovery byte (27 or 28)
223       * @param  _ecdsaR2  The R component of an ECDSA signature (R, S) pair
224       * @param  _ecdsaS2  The S component of an ECDSA signature (R, S) pair
225       *
226       * @return  success  True if the callback successfully executed.
227       */
228     function completeUnlock(
229         bytes32 _requestMsgHash,
230         uint8 _recoveryByte1, bytes32 _ecdsaR1, bytes32 _ecdsaS1,
231         uint8 _recoveryByte2, bytes32 _ecdsaR2, bytes32 _ecdsaS2
232     )
233         public
234         returns (bool success)
235     {
236         Request storage request = requestMap[_requestMsgHash];
237 
238         // copy storage to locals before `delete`
239         bytes32 lockId = request.lockId;
240         address callbackAddress = request.callbackAddress;
241         bytes4 callbackSelector = request.callbackSelector;
242 
243         // failing case of the lookup if the callback address is zero
244         require(callbackAddress != address(0));
245 
246         // reject confirms of earlier withdrawals buried under later confirmed withdrawals
247         require(request.idx > lastCompletedIdxs[callbackAddress][callbackSelector]);
248 
249         address signer1 = ecrecover(_requestMsgHash, _recoveryByte1, _ecdsaR1, _ecdsaS1);
250         require(signerSet[signer1]);
251 
252         address signer2 = ecrecover(_requestMsgHash, _recoveryByte2, _ecdsaR2, _ecdsaS2);
253         require(signerSet[signer2]);
254         require(signer1 != signer2);
255 
256         if (request.extended && ((block.timestamp - request.timestamp) < extendedTimeLock)) {
257             emit TimeLocked(request.timestamp + extendedTimeLock, _requestMsgHash);
258             return false;
259         } else if ((block.timestamp - request.timestamp) < defaultTimeLock) {
260             emit TimeLocked(request.timestamp + defaultTimeLock, _requestMsgHash);
261             return false;
262         } else {
263             if (address(this).balance > 0) {
264                 // reward sender with anti-spam payments
265                 // ignore send success (assign to `success` but this will be overwritten)
266                 success = msg.sender.send(address(this).balance);
267             }
268 
269             // raise the waterline for the last completed unlocking
270             lastCompletedIdxs[callbackAddress][callbackSelector] = request.idx;
271             // and delete the request
272             delete requestMap[_requestMsgHash];
273 
274             // invoke callback
275             success = callbackAddress.call(callbackSelector, lockId);
276 
277             if (success) {
278                 emit Completed(lockId, _requestMsgHash, signer1, signer2);
279             } else {
280                 emit Failed(lockId, _requestMsgHash, signer1, signer2);
281             }
282         }
283     }
284 
285     /** @notice  Reclaim the storage of a pending request that is uncompleteable.
286       *
287       * @dev  If a pending request shares the callback (address and selector) of
288       * a later request has has been completed, then the request can no longer
289       * be completed. This function will reclaim the contract storage of the
290       * pending request.
291       *
292       * @param  _requestMsgHash  The request message hash of a pending request.
293       */
294     function deleteUncompletableRequest(bytes32 _requestMsgHash) public {
295         Request storage request = requestMap[_requestMsgHash];
296 
297         uint256 idx = request.idx;
298 
299         require(0 < idx && idx < lastCompletedIdxs[request.callbackAddress][request.callbackSelector]);
300 
301         delete requestMap[_requestMsgHash];
302     }
303 
304     /** @notice  Extend the time lock of a pending request.
305       *
306       * @dev  Requests made by the primary account receive the default time lock.
307       * This function allows the primary account to apply the extended time lock
308       * to one its own requests.
309       *
310       * @param  _requestMsgHash  The request message hash of a pending request.
311       */
312     function extendRequestTimeLock(bytes32 _requestMsgHash) public onlyPrimary {
313         Request storage request = requestMap[_requestMsgHash];
314 
315         // reject ‘null’ results from the map lookup
316         // this can only be the case if an unknown `_requestMsgHash` is received
317         require(request.callbackAddress != address(0));
318 
319         // `extendRequestTimeLock` must be idempotent
320         require(request.extended != true);
321 
322         // set the `extended` flag; note that this is never unset
323         request.extended = true;
324 
325         emit TimeLockExtended(request.timestamp + extendedTimeLock, _requestMsgHash);
326     }
327 }