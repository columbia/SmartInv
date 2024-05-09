1 // File: @laborx/solidity-shared-lib/contracts/ERC20Interface.sol
2 
3 /**
4 * Copyright 2017–2018, LaborX PTY
5 * Licensed under the AGPL Version 3 license.
6 */
7 
8 pragma solidity ^0.4.23;
9 
10 
11 /// @title Defines an interface for EIP20 token smart contract
12 contract ERC20Interface {
13     
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event Approval(address indexed from, address indexed spender, uint256 value);
16 
17     string public symbol;
18 
19     function decimals() public view returns (uint8);
20     function totalSupply() public view returns (uint256 supply);
21 
22     function balanceOf(address _owner) public view returns (uint256 balance);
23     function transfer(address _to, uint256 _value) public returns (bool success);
24     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
25     function approve(address _spender, uint256 _value) public returns (bool success);
26     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
27 }
28 
29 // File: @laborx/solidity-shared-lib/contracts/Owned.sol
30 
31 /**
32 * Copyright 2017–2018, LaborX PTY
33 * Licensed under the AGPL Version 3 license.
34 */
35 
36 pragma solidity ^0.4.23;
37 
38 
39 
40 /// @title Owned contract with safe ownership pass.
41 ///
42 /// Note: all the non constant functions return false instead of throwing in case if state change
43 /// didn't happen yet.
44 contract Owned {
45 
46     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48     address public contractOwner;
49     address public pendingContractOwner;
50 
51     modifier onlyContractOwner {
52         if (msg.sender == contractOwner) {
53             _;
54         }
55     }
56 
57     constructor()
58     public
59     {
60         contractOwner = msg.sender;
61     }
62 
63     /// @notice Prepares ownership pass.
64     /// Can only be called by current owner.
65     /// @param _to address of the next owner.
66     /// @return success.
67     function changeContractOwnership(address _to)
68     public
69     onlyContractOwner
70     returns (bool)
71     {
72         if (_to == 0x0) {
73             return false;
74         }
75         pendingContractOwner = _to;
76         return true;
77     }
78 
79     /// @notice Finalize ownership pass.
80     /// Can only be called by pending owner.
81     /// @return success.
82     function claimContractOwnership()
83     public
84     returns (bool)
85     {
86         if (msg.sender != pendingContractOwner) {
87             return false;
88         }
89 
90         emit OwnershipTransferred(contractOwner, pendingContractOwner);
91         contractOwner = pendingContractOwner;
92         delete pendingContractOwner;
93         return true;
94     }
95 
96     /// @notice Allows the current owner to transfer control of the contract to a newOwner.
97     /// @param newOwner The address to transfer ownership to.
98     function transferOwnership(address newOwner)
99     public
100     onlyContractOwner
101     returns (bool)
102     {
103         if (newOwner == 0x0) {
104             return false;
105         }
106 
107         emit OwnershipTransferred(contractOwner, newOwner);
108         contractOwner = newOwner;
109         delete pendingContractOwner;
110         return true;
111     }
112 
113     /// @notice Allows the current owner to transfer control of the contract to a newOwner.
114     /// @dev Backward compatibility only.
115     /// @param newOwner The address to transfer ownership to.
116     function transferContractOwnership(address newOwner)
117     public
118     returns (bool)
119     {
120         return transferOwnership(newOwner);
121     }
122 
123     /// @notice Withdraw given tokens from contract to owner.
124     /// This method is only allowed for contact owner.
125     function withdrawTokens(address[] tokens)
126     public
127     onlyContractOwner
128     {
129         address _contractOwner = contractOwner;
130         for (uint i = 0; i < tokens.length; i++) {
131             ERC20Interface token = ERC20Interface(tokens[i]);
132             uint balance = token.balanceOf(this);
133             if (balance > 0) {
134                 token.transfer(_contractOwner, balance);
135             }
136         }
137     }
138 
139     /// @notice Withdraw ether from contract to owner.
140     /// This method is only allowed for contact owner.
141     function withdrawEther()
142     public
143     onlyContractOwner
144     {
145         uint balance = address(this).balance;
146         if (balance > 0)  {
147             contractOwner.transfer(balance);
148         }
149     }
150 
151     /// @notice Transfers ether to another address.
152     /// Allowed only for contract owners.
153     /// @param _to recepient address
154     /// @param _value wei to transfer; must be less or equal to total balance on the contract
155     function transferEther(address _to, uint256 _value)
156     public
157     onlyContractOwner
158     {
159         require(_to != 0x0, "INVALID_ETHER_RECEPIENT_ADDRESS");
160         if (_value > address(this).balance) {
161             revert("INVALID_VALUE_TO_TRANSFER_ETHER");
162         }
163 
164         _to.transfer(_value);
165     }
166 }
167 
168 // File: @laborx/solidity-eventshistory-lib/contracts/EventsHistorySourceAdapter.sol
169 
170 /**
171 * Copyright 2017–2018, LaborX PTY
172 * Licensed under the AGPL Version 3 license.
173 */
174 
175 pragma solidity ^0.4.21;
176 
177 
178 /**
179  * @title EventsHistory Source Adapter.
180  */
181 contract EventsHistorySourceAdapter {
182 
183     // It is address of MultiEventsHistory caller assuming we are inside of delegate call.
184     function _self()
185     internal
186     view
187     returns (address)
188     {
189         return msg.sender;
190     }
191 }
192 
193 // File: @laborx/solidity-eventshistory-lib/contracts/MultiEventsHistoryAdapter.sol
194 
195 /**
196 * Copyright 2017–2018, LaborX PTY
197 * Licensed under the AGPL Version 3 license.
198 */
199 
200 pragma solidity ^0.4.21;
201 
202 
203 
204 /**
205  * @title General MultiEventsHistory user.
206  */
207 contract MultiEventsHistoryAdapter is EventsHistorySourceAdapter {
208 
209     address internal localEventsHistory;
210 
211     event ErrorCode(address indexed self, uint errorCode);
212 
213     function getEventsHistory()
214     public
215     view
216     returns (address)
217     {
218         address _eventsHistory = localEventsHistory;
219         return _eventsHistory != 0x0 ? _eventsHistory : this;
220     }
221 
222     function emitErrorCode(uint _errorCode) public {
223         emit ErrorCode(_self(), _errorCode);
224     }
225 
226     function _setEventsHistory(address _eventsHistory) internal returns (bool) {
227         localEventsHistory = _eventsHistory;
228         return true;
229     }
230     
231     function _emitErrorCode(uint _errorCode) internal returns (uint) {
232         MultiEventsHistoryAdapter(getEventsHistory()).emitErrorCode(_errorCode);
233         return _errorCode;
234     }
235 }
236 
237 // File: contracts/StorageManager.sol
238 
239 /**
240  * Copyright 2017–2018, LaborX PTY
241  * Licensed under the AGPL Version 3 license.
242  */
243 
244 pragma solidity ^0.4.23;
245 
246 
247 
248 
249 contract StorageManager is Owned, MultiEventsHistoryAdapter {
250 
251     uint constant OK = 1;
252 
253     event AccessGiven(address indexed self, address indexed actor, bytes32 role);
254     event AccessBlocked(address indexed self, address indexed actor, bytes32 role);
255     event AuthorizationGranted(address indexed self, address indexed account);
256     event AuthorizationRevoked(address indexed self, address indexed account);
257 
258     mapping (address => uint) public authorised;
259     mapping (bytes32 => bool) public accessRights;
260     mapping (address => bool) public acl;
261 
262     modifier onlyAuthorized {
263         if (msg.sender == contractOwner || acl[msg.sender]) {
264             _;
265         }
266     }
267 
268     function setupEventsHistory(address _eventsHistory)
269     external
270     onlyContractOwner
271     returns (uint)
272     {
273         _setEventsHistory(_eventsHistory);
274         return OK;
275     }
276 
277     function authorize(address _address)
278     external
279     onlyAuthorized
280     returns (uint)
281     {
282         require(_address != 0x0, "STORAGE_MANAGER_INVALID_ADDRESS");
283         acl[_address] = true;
284 
285         _emitter().emitAuthorizationGranted(_address);
286         return OK;
287     }
288 
289     function revoke(address _address)
290     external
291     onlyContractOwner
292     returns (uint)
293     {
294         require(acl[_address], "STORAGE_MANAGER_ADDRESS_SHOULD_EXIST");
295         delete acl[_address];
296 
297         _emitter().emitAuthorizationRevoked(_address);
298         return OK;
299     }
300 
301     function giveAccess(address _actor, bytes32 _role)
302     external
303     onlyAuthorized
304     returns (uint)
305     {
306         if (!accessRights[_getKey(_actor, _role)]) {
307             accessRights[_getKey(_actor, _role)] = true;
308             authorised[_actor] += 1;
309             _emitter().emitAccessGiven(_actor, _role);
310         }
311 
312         return OK;
313     }
314 
315     function blockAccess(address _actor, bytes32 _role)
316     external
317     onlyAuthorized
318     returns (uint)
319     {
320         if (accessRights[_getKey(_actor, _role)]) {
321             delete accessRights[_getKey(_actor, _role)];
322             authorised[_actor] -= 1;
323             if (authorised[_actor] == 0) {
324                 delete authorised[_actor];
325             }
326             _emitter().emitAccessBlocked(_actor, _role);
327         }
328 
329         return OK;
330     }
331 
332     function isAllowed(address _actor, bytes32 _role)
333     public
334     view
335     returns (bool)
336     {
337         return accessRights[keccak256(abi.encodePacked(_actor, _role))] || (this == _actor);
338     }
339 
340     function hasAccess(address _actor)
341     public
342     view
343     returns (bool)
344     {
345         return (authorised[_actor] > 0) || (address(this) == _actor);
346     }
347 
348     function emitAccessGiven(address _user, bytes32 _role) public {
349         emit AccessGiven(_self(), _user, _role);
350     }
351 
352     function emitAccessBlocked(address _user, bytes32 _role) public {
353         emit AccessBlocked(_self(), _user, _role);
354     }
355 
356     function emitAuthorizationGranted(address _account) public {
357         emit AuthorizationGranted(_self(), _account);
358     }
359 
360     function emitAuthorizationRevoked(address _account) public {
361         emit AuthorizationRevoked(_self(), _account);
362     }
363 
364     function _emitter() internal view returns (StorageManager) {
365         return StorageManager(getEventsHistory());
366     }
367 
368     function _getKey(address _actor, bytes32 _role) private pure returns (bytes32) {
369         return keccak256(abi.encodePacked(_actor, _role));
370     }
371 }