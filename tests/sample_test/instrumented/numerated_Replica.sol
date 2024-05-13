1 1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 2 //test cross bridge
3 3 pragma solidity >=0.6.11;
4 
5 
6 4 contract Replica {
7  
8 5     /**
9 6      * @notice Emitted when message is processed
10 7      * @param messageHash Hash of message that failed to process
11 8      * @param success TRUE if the call was executed successfully, FALSE if the call reverted
12 9      * @param returnData the return data from the external call
13 10      */
14 11     event Process(
15 12         bytes32 indexed messageHash,
16 13         bool indexed success,
17 14         bytes indexed returnData
18 15     );
19 
20    
21 
22 16     function initialize(
23 17         uint32 _remoteDomain,
24 18         address _updater,
25 19         bytes32 _committedRoot,
26 20         uint256 _optimisticSeconds
27 21     ) public initializer {
28 22         __NomadBase_initialize(_updater);
29 23         // set storage variables
30 24         entered = 1;
31 25         remoteDomain = _remoteDomain;
32 26         committedRoot = _committedRoot;
33 27         confirmAt[_committedRoot] = 1;
34 28         optimisticSeconds = _optimisticSeconds;
35 29         emit SetOptimisticTimeout(_optimisticSeconds);
36 30     }
37 
38 31     // ============ External Functions ============
39 
40 32     /**
41 33      * @notice Called by external agent. Submits the signed update's new root,
42 34      * marks root's allowable confirmation time, and emits an `Update` event.
43 35      * @dev Reverts if update doesn't build off latest committedRoot
44 36      * or if signature is invalid.
45 37      * @param _oldRoot Old merkle root
46 38      * @param _newRoot New merkle root
47 39      * @param _signature Updater's signature on `_oldRoot` and `_newRoot`
48 40      */
49 41     function update(
50 42         bytes32 _oldRoot,
51 43         bytes32 _newRoot,
52 44         bytes memory _signature
53 45     ) external notFailed {
54 46         // ensure that update is building off the last submitted root
55 47         // validate updater signature
56 48         // Hook for future use
57 49         _beforeUpdate();
58 50         // set the new root's confirmation timer
59 51         confirmAt[_newRoot] = block.timestamp + optimisticSeconds;
60 52         // update committedRoot
61 53         committedRoot = _newRoot;
62 54         emit Update(remoteDomain, _oldRoot, _newRoot, _signature);
63 55     }
64 
65 56     /**
66 57      * @notice First attempts to prove the validity of provided formatted
67 58      * `message`. If the message is successfully proven, then tries to process
68 59      * message.
69 60      * @dev Reverts if `prove` call returns false
70 61      * @param _message Formatted message (refer to NomadBase.sol Message library)
71 62      * @param _proof Merkle proof of inclusion for message's leaf
72 63      * @param _index Index of leaf in home's merkle tree
73 64      */
74 65     function proveAndProcess(
75 66         bytes memory _message,
76 67         bytes32[32] calldata _proof,
77 68         uint256 _index
78 69     ) external {
79 
80 70         process(_message);
81 71     }
82 
83 72     /**
84 73      * @notice Given formatted message, attempts to dispatch
85 74      * message payload to end recipient.
86 75      * @dev Recipient must implement a `handle` method (refer to IMessageRecipient.sol)
87 76      * Reverts if formatted message's destination domain is not the Replica's domain,
88 77      * if message has not been proven,
89 78      * or if not enough gas is provided for the dispatch transaction.
90 79      * @param _message Formatted message
91 80      * @return _success TRUE iff dispatch transaction succeeded
92 81      */
93 82     function process(bytes memory _message) public returns (bool _success) {
94 83         bytes29 _m = _message.ref(0);
95 84         // ensure message was meant for this domain
96 85         // ensure message has been proven
97 86         bytes32 _messageHash = _m.keccak();
98 87         // check re-entrancy guard
99 88         entered = 0;
100 89         // update message status as processed
101 90         messages[_messageHash] = MessageStatus.Processed;
102 91         // A call running out of gas TYPICALLY errors the whole tx. We want to
103 92         // a) ensure the call has a sufficient amount of gas to make a
104 93         //    meaningful state change.
105 94         // b) ensure that if the subcall runs out of gas, that the tx as a whole
106 95         //    does not revert (i.e. we still mark the message processed)
107 96         // To do this, we require that we have enough gas to process
108 97         // and still return. We then delegate only the minimum processing gas.
109 98         // get the message recipient
110 99         address _recipient = _m.recipientAddress();
111 100         // set up for assembly call
112 101         uint256 _toCopy;
113 102         uint256 _maxCopy = 256;
114 103         uint256 _gas = PROCESS_GAS;
115 104         // allocate memory for returndata
116 105         bytes memory _returnData = new bytes(_maxCopy);
117 106         bytes memory _calldata = abi.encodeWithSignature(
118 107             "handle(uint32,uint32,bytes32,bytes)",
119 108             _m.origin(),
120 109             _m.nonce(),
121 110             _m.sender(),
122 111             _m.body().clone()
123 112         );
124 113         // dispatch message to recipient
125 114         // by assembly calling "handle" function
126 115         // we call via assembly to avoid memcopying a very large returndata
127 116         // returned by a malicious contract
128 117         assembly {
129 118             _success := call(
130 119                 _gas, // gas
131 120                 _recipient, // recipient
132 121                 0, // ether value
133 122                 add(_calldata, 0x20), // inloc
134 123                 mload(_calldata), // inlen
135 124                 0, // outloc
136 125                 0 // outlen
137 126             )
138 127             // limit our copy to 256 bytes
139 128             _toCopy := returndatasize()
140 129             if gt(_toCopy, _maxCopy) {
141 130                 _toCopy := _maxCopy
142 131             }
143 132             // Store the length of the copied bytes
144 133             mstore(_returnData, _toCopy)
145 134             // copy the bytes from returndata[0:_toCopy]
146 135             returndatacopy(add(_returnData, 0x20), 0, _toCopy)
147 136         }
148 137         // emit process results
149 138         emit Process(_messageHash, _success, _returnData);
150 139         // reset re-entrancy guard
151 140         entered = 1;
152 141     }
153 
154 142     // ============ External Owner Functions ============
155 
156 143     /**
157 144      * @notice Set optimistic timeout period for new roots
158 145      * @dev Only callable by owner (Governance)
159 146      * @param _optimisticSeconds New optimistic timeout period
160 147      */
161 148     function setOptimisticTimeout(uint256 _optimisticSeconds)
162 149         external
163 150         onlyOwner
164 151     {
165 152         optimisticSeconds = _optimisticSeconds;
166 153         emit SetOptimisticTimeout(_optimisticSeconds);
167 154     }
168 
169 155     /**
170 156      * @notice Set Updater role
171 157      * @dev MUST ensure that all roots signed by previous Updater have
172 158      * been relayed before calling. Only callable by owner (Governance)
173 159      * @param _updater New Updater
174 160      */
175 161     function setUpdater(address _updater) external onlyOwner {
176 162         _setUpdater(_updater);
177 163     }
178 
179 164     /**
180 165      * @notice Set confirmAt for a given root
181 166      * @dev To be used if in the case that fraud is proven
182 167      * and roots need to be deleted / added. Only callable by owner (Governance)
183 168      * @param _root The root for which to modify confirm time
184 169      * @param _confirmAt The new confirmation time. Set to 0 to "delete" a root.
185 170      */
186 171     function setConfirmation(bytes32 _root, uint256 _confirmAt)
187 172         external
188 173         onlyOwner
189 174     {
190 175         uint256 _previousConfirmAt = confirmAt[_root];
191 176         confirmAt[_root] = _confirmAt;
192 177         emit SetConfirmation(_root, _previousConfirmAt, _confirmAt);
193 178     }
194 
195 179     // ============ Public Functions ============
196 
197 180     /**
198 181      * @notice Check that the root has been submitted
199 182      * and that the optimistic timeout period has expired,
200 183      * meaning the root can be processed
201 184      * @param _root the Merkle root, submitted in an update, to check
202 185      * @return TRUE iff root has been submitted & timeout has expired
203 186      */
204 187     function acceptableRoot(bytes32 _root) public view returns (bool) {
205 188         uint256 _time = confirmAt[_root];
206 189         if (_time == 0) {
207 190             return false;
208 191         }
209 192         return block.timestamp >= _time;
210 193     }
211 
212 194     /**
213 195      * @notice Attempts to prove the validity of message given its leaf, the
214 196      * merkle proof of inclusion for the leaf, and the index of the leaf.
215 197      * @dev Reverts if message's MessageStatus != None (i.e. if message was
216 198      * already proven or processed)
217 199      * @dev For convenience, we allow proving against any previous root.
218 200      * This means that witnesses never need to be updated for the new root
219 201      * @param _leaf Leaf of message to prove
220 202      * @param _proof Merkle proof of inclusion for leaf
221 203      * @param _index Index of leaf in home's merkle tree
222 204      * @return Returns true if proof was valid and `prove` call succeeded
223 205      **/
224 206     function prove(
225 207         bytes32 _leaf,
226 208         bytes32[32] calldata _proof,
227 209         uint256 _index
228 210     ) public returns (bool) {
229 211         // ensure that message has not been proven or processed
230 212         // calculate the expected root based on the proof
231 213         bytes32 _calculatedRoot = MerkleLib.branchRoot(_leaf, _proof, _index);
232 214         // if the root is valid, change status to Proven
233 215         if (acceptableRoot(_calculatedRoot)) {
234 216             messages[_leaf] = MessageStatus.Proven;
235 217             return true;
236 218         }
237 219         return false;
238 220     }
239 
240 221     /**
241 222      * @notice Hash of Home domain concatenated with "NOMAD"
242 223      */
243 224     function homeDomainHash() public view override returns (bytes32) {
244 225         return _homeDomainHash(remoteDomain);
245 226     }
246 
247 227     // ============ Internal Functions ============
248 
249 228     /**
250 229      * @notice Moves the contract into failed state
251 230      * @dev Called when a Double Update is submitted
252 231      */
253 232     function _fail() internal override {
254 233         _setFailed();
255 234     }
256 
257 235     /// @notice Hook for potential future use
258 236     // solhint-disable-next-line no-empty-blocks
259 237     function _beforeUpdate() internal {}
260 238 }