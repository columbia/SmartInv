1 pragma solidity ^0.4.19;
2 
3 // DELEGATION SC v1.1
4 // (c) SecureVote 2018
5 // Author: Max Kaye <max@secure.vote>
6 // Released under MIT licence
7 
8 // the most up-to-date version of the contract lives at delegate.secvote.eth
9 
10 
11 // Main delegation contract v1.1
12 contract SVDelegationV0101 {
13 
14     address public owner;
15 
16     // in the last version we didn't include enough data - this makes it trivial to traverse off-chain
17     struct Delegation {
18         uint64 thisDelegationId;
19         uint64 prevDelegationId;
20         uint64 setAtBlock;
21         address delegatee;
22         address delegator;
23         address tokenContract;
24     }
25 
26     // easy lookups
27     mapping (address => mapping (address => Delegation)) tokenDlgts;
28     mapping (address => Delegation) globalDlgts;
29 
30     // track which token contracts we know about for easy traversal + backwards compatibility
31     mapping (address => bool) knownTokenContracts;
32     address[] logTokenContracts;
33 
34     // track all delegations via an indexed map
35     mapping (uint64 => Delegation) historicalDelegations;
36     uint64 public totalDelegations = 0;
37 
38     // reference to v1.0 of contract
39     SVDelegation prevSVDelegation;
40 
41     // pretty straight forward - events
42     event SetGlobalDelegation(address voter, address delegate);
43     event SetTokenDelegation(address voter, address tokenContract, address delegate);
44 
45     // main constructor - requires the prevDelegationSC address
46     function SVDelegationV0101(address prevDelegationSC) public {
47         owner = msg.sender;
48 
49         prevSVDelegation = SVDelegation(prevDelegationSC);
50 
51         // commit the genesis historical delegation to history (like genesis block) - somewhere to point back to
52         createDelegation(address(0), 0, address(0));
53     }
54 
55     // internal function to handle inserting delegates into state
56     function createDelegation(address dlgtAddress, uint64 prevDelegationId, address tokenContract) internal returns(Delegation) {
57         // use this to log known tokenContracts
58         if (!knownTokenContracts[tokenContract]) {
59             logTokenContracts.push(tokenContract);
60             knownTokenContracts[tokenContract] = true;
61         }
62 
63         uint64 myDelegationId = totalDelegations;
64         historicalDelegations[myDelegationId] = Delegation(myDelegationId, prevDelegationId, uint64(block.number), dlgtAddress, msg.sender, tokenContract);
65         totalDelegations += 1;
66 
67         return historicalDelegations[myDelegationId];
68     }
69 
70     // get previous delegation, create new delegation via function and then commit to globalDlgts
71     function setGlobalDelegation(address dlgtAddress) public {
72         uint64 prevDelegationId = globalDlgts[msg.sender].thisDelegationId;
73         globalDlgts[msg.sender] = createDelegation(dlgtAddress, prevDelegationId, address(0));
74         SetGlobalDelegation(msg.sender, dlgtAddress);
75     }
76 
77     // get previous delegation, create new delegation via function and then commit to tokenDlgts
78     function setTokenDelegation(address tokenContract, address dlgtAddress) public {
79         uint64 prevDelegationId = tokenDlgts[tokenContract][msg.sender].thisDelegationId;
80         tokenDlgts[tokenContract][msg.sender] = createDelegation(dlgtAddress, prevDelegationId, tokenContract);
81         SetTokenDelegation(msg.sender, tokenContract, dlgtAddress);
82     }
83 
84     // given some voter and token address, get the delegation id - failover to global on 0 address
85     function getDelegationID(address voter, address tokenContract) public constant returns(uint64) {
86         // default to token resolution but use global if no delegation
87         Delegation memory _tokenDlgt = tokenDlgts[tokenContract][voter];
88         if (tokenContract == address(0)) {
89             _tokenDlgt = globalDlgts[voter];
90         }
91 
92         // default to 0 if we don't have a valid delegation
93         if (_validDelegation(_tokenDlgt)) {
94             return _tokenDlgt.thisDelegationId;
95         }
96         return 0;
97     }
98 
99     function resolveDelegation(address voter, address tokenContract) public constant returns(uint64, uint64, uint64, address, address, address) {
100         Delegation memory _tokenDlgt = tokenDlgts[tokenContract][voter];
101 
102         // if we have a delegation in this contract return it
103         if (_validDelegation(_tokenDlgt)) {
104             return _dlgtRet(_tokenDlgt);
105         }
106 
107         // otherwise try the global delegation
108         Delegation memory _globalDlgt = globalDlgts[voter];
109         if (_validDelegation(_globalDlgt)) {
110             return _dlgtRet(_globalDlgt);
111         }
112 
113         // but if we don't have a delegation in this contract then resolve according the prev contract
114         address _dlgt;
115         uint256 meh;
116         (meh, _dlgt, meh, meh) = prevSVDelegation.resolveDelegation(voter, tokenContract);
117         return (0, 0, 0, _dlgt, voter, tokenContract);
118     }
119 
120     // returns 2 lists: first of voter addresses, second of token contracts
121     function findPossibleDelegatorsOf(address delegate) public view returns(address[] memory, address[] memory) {
122         // not meant to be run on-chain, but off-chain via API, mostly convenience
123         address[] memory voters;
124         address[] memory tokenContracts;
125         Delegation memory _delegation;
126 
127         // all the senders who participated in v1.0 of the contract prior to block 5203500
128         address[43] memory oldSenders =
129             [ 0xE8193Bc3D5F3F482406706F843A5f161563F37Bf
130             , 0x7A933c8a0Eb99e8Bdb07E1b42Aa10872845394B7
131             , 0x88341191EfA40Cd031F46138817830A5D3545Ba9
132             , 0xB6dc48E8583C8C6e320DaF918CAdef65f2d85B46
133             , 0xF02d417c8c6736Dbc7Eb089DC6738b950c2F444e
134             , 0xF66fE29Ad1E87104A8816AD1A8427976d83CB033
135             , 0xfd5955bf412B7537873CBB77eB1E39871e20e142
136             , 0xe83Efc57d9C487ACc55a7B62896dA43928E64C3E
137             , 0xd0c41588b27E64576ddA4e6a08452c59F5A2B2dD
138             , 0x640370126072f6B890d4Ca2E893103e9363DbE8B
139             , 0x887dbaCD9a0e58B46065F93cc1f82a52DEfDb979
140             , 0xe223771699665bCB0AAf7930277C35d3deC573aF
141             , 0x364B503B0e86b20B7aC1484c247DE50f10DfD8cf
142             , 0x4512F5867d91D6B0131427b89Bdb7b460fF30397
143             , 0xF5fBff477F5Bf5a950F661B70F6b5364875A1bD7
144             , 0x9EbB758483Da174DC3d411386B75afd093CEfCf1
145             , 0x499B36A6B92F91524A6B5b8Ff321740e84a2B57e
146             , 0x05D6e87fd6326F977a2d8c67b9F3EcC030527261
147             , 0x7f679053a1679dE7913885F0Db1278e91e8927Ca
148             , 0xF9CD08d36e972Bb070bBD2C1598D21045259AB0D
149             , 0xa5617800B8FD754fB81F47A65dc49A60acCc3432
150             , 0xa9F6238B83fcb65EcA3c3189a0dce8689e275D57
151             , 0xa30F92F9cc478562e0dde73665f1B7ADddDC2dCd
152             , 0x70278C15A29f0Ef62A845e1ac31AE41988F24C10
153             , 0xd42622471946CCFf9F7b9246e8D786c74410bFcC
154             , 0xd65955EF0f8890D7996f5a7b7b5b05B80605C06a
155             , 0xB46F4eBDD6404686D785EDACE37D66f815ED7cF8
156             , 0xf4d3aa8091D23f97706177CDD94b8dF4c7e4C2FB
157             , 0x4Fe584FFc9C755BF6Aa9354323e97166958475c9
158             , 0xB4802f497Bf6238A29e043103EE6eeae1331BFde
159             , 0x3EeE0f8Fadc1C29bFB782E70067a8D91B4ddeD56
160             , 0x46381F606014C5D68B38aD5C7e8f9401149FAa75
161             , 0xC81Be3496d053364255f9cb052F81Ca9e84A9cF3
162             , 0xa632837B095d8fa2ef46a22099F91Fe10B3F0538
163             , 0x19FA94aEbD4bC694802B566Ae65aEd8F07B992f7
164             , 0xE9Ef7664d36191Ad7aB001b9BB0aAfAcD260277F
165             , 0x17DAB6BB606f32447aff568c1D0eEDC3649C101C
166             , 0xaBA96c77E3dd7EEa16cc5EbdAAA05483CDD0FF89
167             , 0x57d36B0B5f5E333818b1ce072A6D84218E734deC
168             , 0x59E7612706DFB1105220CcB97aaF3cBF304cD608
169             , 0xCf7EC4dcA84b5c8Dc7896c38b4834DC6379BB73D
170             , 0x5Ed1Da246EA52F302FFf9391e56ec64b9c14cce1
171             , 0x4CabFD1796Ec9EAd77457768e5cA782a1A9e576F
172             ];
173 
174         // there were no global delegations in v1.0 of contract
175         address oldToken = 0x9e88613418cF03dCa54D6a2cf6Ad934A78C7A17A;
176 
177         // first loop through delegations in this contract
178         uint64 i;
179         // start at 1 because the first delegation is a "genesis" delegation in constructor
180         for (i = 1; i < totalDelegations; i++) {
181             _delegation = historicalDelegations[i];
182             if (_delegation.delegatee == delegate) {
183                 // since `.push` isn't available on memory arrays, use their length as the next index location
184                 voters = _appendMemArray(voters, _delegation.delegator);
185                 tokenContracts = _appendMemArray(tokenContracts, _delegation.tokenContract);
186             }
187         }
188 
189         // then loop through delegations in the previous contract
190         for (i = 0; i < oldSenders.length; i++) {
191             uint256 _oldId;
192             address _oldDlgt;
193             uint256 _oldSetAtBlock;
194             uint256 _oldPrevId;
195             (_oldId, _oldDlgt, _oldSetAtBlock, _oldPrevId) = prevSVDelegation.resolveDelegation(oldSenders[i], oldToken);
196             if (_oldDlgt == delegate && _oldSetAtBlock != 0) {
197                 voters = _appendMemArray(voters, oldSenders[i]);
198                 tokenContracts = _appendMemArray(tokenContracts, oldToken);
199             }
200         }
201 
202         return (voters, tokenContracts);
203     }
204 
205     // give access to historicalDelegations
206     function getHistoricalDelegation(uint64 delegationId) public constant returns(uint64, uint64, uint64, address, address, address) {
207         return _dlgtRet(historicalDelegations[delegationId]);
208     }
209 
210     // access the globalDelegation map
211     function _rawGetGlobalDelegation(address _voter) public constant returns(uint64, uint64, uint64, address, address, address) {
212         return _dlgtRet(globalDlgts[_voter]);
213     }
214 
215     // access the tokenDelegation map
216     function _rawGetTokenDelegation(address _voter, address _tokenContract) public constant returns(uint64, uint64, uint64, address, address, address) {
217         return _dlgtRet(tokenDlgts[_tokenContract][_voter]);
218     }
219 
220     // access our log list of token contracts
221     function _getLogTokenContract(uint256 i) public constant returns(address) {
222         return logTokenContracts[i];
223     }
224 
225     // convenience function to turn Delegations into a returnable structure
226     function _dlgtRet(Delegation d) internal pure returns(uint64, uint64, uint64, address, address, address) {
227         return (d.thisDelegationId, d.prevDelegationId, d.setAtBlock, d.delegatee, d.delegator, d.tokenContract);
228     }
229 
230     // internal function to test if a delegation is valid or revoked / nonexistent
231     function _validDelegation(Delegation d) internal pure returns(bool) {
232         // probs simplest test to check if we have a valid delegation - important to check if delegation is set to 0x00
233         // to avoid counting a revocation (which is done by delegating to 0x00)
234         return d.setAtBlock > 0 && d.delegatee != address(0);
235     }
236 
237     function _appendMemArray(address[] memory arr, address toAppend) internal pure returns(address[] memory arr2) {
238         arr2 = new address[](arr.length + 1);
239 
240         for (uint k = 0; k < arr.length; k++) {
241             arr2[k] = arr[k];
242         }
243 
244         arr2[arr.length] = toAppend;
245     }
246 }
247 
248 
249 
250 // Minimal interface for delegation needs
251 // ERC Token Standard #20 Interface
252 // https://github.com/ethereum/EIPs/issues/20
253 contract ERC20Interface {
254     // Get the account balance of another account with address _owner
255     function balanceOf(address _owner) constant public returns (uint256 balance);
256 }
257 
258 
259 
260 // Include previous contract in this one so we can access the various components. Not all things needed are accessible
261 // through functions - e.g. `historicalDelegations` mapping.
262 contract SVDelegation {
263 
264     address public owner;
265 
266     struct Delegation {
267         uint256 thisDelegationId;
268         address dlgt;
269         uint256 setAtBlock;
270         uint256 prevDelegation;
271     }
272 
273     mapping (address => mapping (address => Delegation)) tokenDlgts;
274     mapping (address => Delegation) globalDlgts;
275 
276     mapping (uint256 => Delegation) public historicalDelegations;
277     uint256 public totalDelegations = 0;
278 
279     event SetGlobalDelegation(address voter, address delegate);
280     event SetTokenDelegation(address voter, address tokenContract, address delegate);
281 
282     function SVDelegation() public {
283         owner = msg.sender;
284 
285         // commit the genesis historical delegation to history (like genesis block)
286         createDelegation(address(0), 0);
287     }
288 
289     function createDelegation(address dlgtAddress, uint256 prevDelegationId) internal returns(Delegation) {
290         uint256 myDelegationId = totalDelegations;
291         historicalDelegations[myDelegationId] = Delegation(myDelegationId, dlgtAddress, block.number, prevDelegationId);
292         totalDelegations += 1;
293 
294         return historicalDelegations[myDelegationId];
295     }
296 
297     // get previous delegation, create new delegation via function and then commit to globalDlgts
298     function setGlobalDelegation(address dlgtAddress) public {
299         uint256 prevDelegationId = globalDlgts[msg.sender].thisDelegationId;
300         globalDlgts[msg.sender] = createDelegation(dlgtAddress, prevDelegationId);
301         SetGlobalDelegation(msg.sender, dlgtAddress);
302     }
303 
304     // get previous delegation, create new delegation via function and then commit to tokenDlgts
305     function setTokenDelegation(address tokenContract, address dlgtAddress) public {
306         uint256 prevDelegationId = tokenDlgts[tokenContract][msg.sender].thisDelegationId;
307         tokenDlgts[tokenContract][msg.sender] = createDelegation(dlgtAddress, prevDelegationId);
308         SetTokenDelegation(msg.sender, tokenContract, dlgtAddress);
309     }
310 
311     function resolveDelegation(address voter, address tokenContract) public constant returns(uint256, address, uint256, uint256) {
312         Delegation memory _tokenDlgt = tokenDlgts[tokenContract][voter];
313 
314         // probs simplest test to check if we have a valid delegation
315         if (_tokenDlgt.setAtBlock > 0) {
316             return _dlgtRet(_tokenDlgt);
317         } else {
318             return _dlgtRet(globalDlgts[voter]);
319         }
320     }
321 
322     function _rawGetGlobalDelegation(address _voter) public constant returns(uint256, address, uint256, uint256) {
323         return _dlgtRet(globalDlgts[_voter]);
324     }
325 
326     function _rawGetTokenDelegation(address _voter, address _tokenContract) public constant returns(uint256, address, uint256, uint256) {
327         return _dlgtRet(tokenDlgts[_tokenContract][_voter]);
328     }
329 
330     function _dlgtRet(Delegation d) internal pure returns(uint256, address, uint256, uint256) {
331         return (d.thisDelegationId, d.dlgt, d.setAtBlock, d.prevDelegation);
332     }
333 }