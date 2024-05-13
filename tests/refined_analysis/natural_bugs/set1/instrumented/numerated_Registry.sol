1 // SPDX-License-Identifier: GPL-3.0
2 pragma solidity 0.8.9;
3 
4 import { ECDSA } from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
5 import { IERC20Token } from "./interfaces/IERC20Token.sol";
6 import { IHermesContract } from "./interfaces/IHermesContract.sol";
7 import { FundsRecovery } from "./FundsRecovery.sol";
8 import { Utils } from "./Utils.sol";
9 
10 interface Channel {
11     function initialize(address _token, address _dex, address _identityHash, address _hermesId, uint256 _fee) external;
12 }
13 
14 contract Registry is FundsRecovery, Utils {
15     using ECDSA for bytes32;
16 
17     uint256 public lastNonce;
18     address payable public dex;     // Any uniswap v2 compatible DEX router address
19     uint256 public minimalHermesStake;
20     Registry public parentRegistry; // Contract could have parent registry if Registry SC was already upgraded
21 
22     struct Implementation {
23         address channelImplAddress;
24         address hermesImplAddress;
25     }
26     Implementation[] internal implementations;
27 
28     struct Hermes {
29         address operator;   // hermes operator who will sign promises
30         uint256 implVer;    // version of hermes implementation smart contract
31         function() external view returns(uint256) stake;
32         bytes url;          // hermes service URL
33     }
34     mapping(address => Hermes) private hermeses;
35 
36     mapping(address => address) private identities;   // key: identity, value: beneficiary wallet address
37 
38     event RegisteredIdentity(address indexed identity, address beneficiary);
39     event RegisteredHermes(address indexed hermesId, address hermesOperator, bytes ur);
40     event HermesURLUpdated(address indexed hermesId, bytes newURL);
41     event ConsumerChannelCreated(address indexed identity, address indexed hermesId, address channelAddress);
42     event BeneficiaryChanged(address indexed identity, address newBeneficiary);
43     event MinimalHermesStakeChanged(uint256 newMinimalStake);
44 
45     // Reject any ethers sent to this smart-contract
46     receive() external payable {
47         revert("Registry: Rejecting tx with ethers sent");
48     }
49 
50     // We're using `initialize` instead of `constructor` to ensure easy way to deploy Registry into
51     // deterministic address on any EVM compatible chain. Registry should be first be deployed using
52     // `deployRegistry` scripts and then initialized with wanted token and implementations.
53     function initialize(address _tokenAddress, address payable _dexAddress, uint256 _minimalHermesStake, address _channelImplementation, address _hermesImplementation, address payable _parentRegistry) public onlyOwner {
54         require(!isInitialized(), "Registry: is already initialized");
55 
56         minimalHermesStake = _minimalHermesStake;
57 
58         require(_tokenAddress != address(0), "Registry: token smart contract can't be deployed into 0x0 address");
59         token = IERC20Token(_tokenAddress);
60 
61         require(_dexAddress != address(0), "Registry: dex can't be deployed into 0x0 address");
62         dex = _dexAddress;
63 
64         // Set initial channel implementations
65         setImplementations(_channelImplementation, _hermesImplementation);
66 
67         // We set initial owner to be sure
68         transferOwnership(msg.sender);
69 
70         // Set parent registry, if `0x0` then this is root registry
71         parentRegistry = Registry(_parentRegistry);
72     }
73 
74     function isInitialized() public view returns (bool) {
75         return address(token) != address(0);
76     }
77 
78     // Register provider and open his channel with given hermes
79     // _stakeAmount - it's amount of tokens staked into hermes to guarantee incomming channel's balance.
80     // _beneficiary - payout address during settlements in hermes channel, if provided 0x0 then will be set to consumer channel address.
81     function registerIdentity(address _hermesId, uint256 _stakeAmount, uint256 _transactorFee, address _beneficiary, bytes memory _signature) public {
82         require(isActiveHermes(_hermesId), "Registry: provided hermes have to be active");
83 
84         // Check if given signature is valid
85         address _identity = keccak256(abi.encodePacked(getChainID(), address(this), _hermesId, _stakeAmount, _transactorFee, _beneficiary)).recover(_signature);
86         require(_identity != address(0), "Registry: wrong identity signature");
87 
88         // Tokens amount to get from channel to cover tx fee and provider's stake
89         uint256 _totalFee = _stakeAmount + _transactorFee;
90         require(_totalFee <= token.balanceOf(getChannelAddress(_identity, _hermesId)), "Registry: not enough funds in channel to cover fees");
91 
92         // Open consumer channel
93         _openChannel(_identity, _hermesId, _beneficiary, _totalFee);
94 
95         // If stake is provided we additionally are opening channel with hermes (a.k.a provider channel)
96         if (_stakeAmount > 0) {
97             IHermesContract(_hermesId).openChannel(_identity, _stakeAmount);
98         }
99 
100         // Pay fee for transaction maker
101         if (_transactorFee > 0) {
102             token.transfer(msg.sender, _transactorFee);
103         }
104     }
105 
106     // Deploys consumer channel and sets beneficiary as newly created channel address
107     function openConsumerChannel(address _hermesId, uint256 _transactorFee, bytes memory _signature) public {
108         require(isActiveHermes(_hermesId), "Registry: provided hermes have to be active");
109 
110         // Check if given signature is valid
111         address _identity = keccak256(abi.encodePacked(getChainID(), address(this), _hermesId, _transactorFee)).recover(_signature);
112         require(_identity != address(0), "Registry: wrong channel openinig signature");
113 
114         require(_transactorFee <= token.balanceOf(getChannelAddress(_identity, _hermesId)), "Registry: not enough funds in channel to cover fees");
115 
116         _openChannel(_identity, _hermesId, address(0), _transactorFee);
117     }
118 
119     // Allows to securely deploy channel's smart contract without consumer signature
120     function openConsumerChannel(address _identity, address _hermesId) public {
121         require(isActiveHermes(_hermesId), "Registry: provided hermes have to be active");
122         require(!isChannelOpened(_identity, _hermesId), "Registry: such consumer channel is already opened");
123 
124         _openChannel(_identity, _hermesId, address(0), 0);
125     }
126 
127     // Deploy payment channel for given consumer identity
128     // We're using minimal proxy (EIP1167) to save on gas cost and blockchain space.
129     function _openChannel(address _identity, address _hermesId, address _beneficiary, uint256 _fee) internal returns (address) {
130         bytes32 _salt = keccak256(abi.encodePacked(_identity, _hermesId));
131         bytes memory _code = getProxyCode(getChannelImplementation(hermeses[_hermesId].implVer));
132         Channel _channel = Channel(deployMiniProxy(uint256(_salt), _code));
133         _channel.initialize(address(token), dex, _identity, _hermesId, _fee);
134 
135         emit ConsumerChannelCreated(_identity, _hermesId, address(_channel));
136 
137         // If beneficiary was not provided, then we're going to use consumer channel for that
138         if (_beneficiary == address(0)) {
139             _beneficiary = address(_channel);
140         }
141 
142         // Mark identity as registered (only during first channel opening)
143         if (!isRegistered(_identity)) {
144             identities[_identity] = _beneficiary;
145             emit RegisteredIdentity(_identity, _beneficiary);
146         }
147 
148         return address(_channel);
149     }
150 
151     function registerHermes(address _hermesOperator, uint256 _hermesStake, uint16 _hermesFee, uint256 _minChannelStake, uint256 _maxChannelStake, bytes memory _url) public {
152         require(isInitialized(), "Registry: only initialized registry can register hermeses");
153         require(_hermesOperator != address(0), "Registry: hermes operator can't be zero address");
154         require(_hermesStake >= minimalHermesStake, "Registry: hermes have to stake at least minimal stake amount");
155 
156         address _hermesId = getHermesAddress(_hermesOperator);
157         require(!isHermes(_hermesId), "Registry: hermes already registered");
158 
159         // Deploy hermes contract (mini proxy which is pointing to implementation)
160         IHermesContract _hermes = IHermesContract(deployMiniProxy(uint256(uint160(_hermesOperator)), getProxyCode(getHermesImplementation())));
161 
162         // Transfer stake into hermes smart contract
163         token.transferFrom(msg.sender, address(_hermes), _hermesStake);
164 
165         // Initialise hermes
166         _hermes.initialize(address(token), _hermesOperator, _hermesFee, _minChannelStake, _maxChannelStake, dex);
167 
168         // Save info about newly created hermes
169         hermeses[_hermesId] = Hermes(_hermesOperator, getLastImplVer(), _hermes.getStake, _url);
170 
171         // Approve hermes contract to `transferFrom` registry (used during hermes channel openings)
172         token.approve(_hermesId, type(uint256).max);
173 
174         emit RegisteredHermes(_hermesId, _hermesOperator, _url);
175     }
176 
177     function getChannelAddress(address _identity, address _hermesId) public view returns (address) {
178         bytes32 _code = keccak256(getProxyCode(getChannelImplementation(hermeses[_hermesId].implVer)));
179         bytes32 _salt = keccak256(abi.encodePacked(_identity, _hermesId));
180         return getCreate2Address(_salt, _code);
181     }
182 
183     function getHermes(address _hermesId) public view returns (Hermes memory) {
184         return isHermes(_hermesId) || !hasParentRegistry() ? hermeses[_hermesId] : parentRegistry.getHermes(_hermesId);
185     }
186 
187     function getHermesAddress(address _hermesOperator) public view returns (address) {
188         bytes32 _code = keccak256(getProxyCode(getHermesImplementation()));
189         return getCreate2Address(bytes32(uint256(uint160(_hermesOperator))), _code);
190     }
191 
192     function getHermesAddress(address _hermesOperator, uint256 _implVer) public view returns (address) {
193         bytes32 _code = keccak256(getProxyCode(getHermesImplementation(_implVer)));
194         return getCreate2Address(bytes32(uint256(uint160(_hermesOperator))), _code);
195     }
196 
197     function getHermesURL(address _hermesId) public view returns (bytes memory) {
198         return hermeses[_hermesId].url;
199     }
200 
201     function updateHermesURL(address _hermesId, bytes memory _url, bytes memory _signature) public {
202         require(isActiveHermes(_hermesId), "Registry: provided hermes has to be active");
203 
204         // Check if given signature is valid
205         address _operator = keccak256(abi.encodePacked(address(this), _hermesId, _url, lastNonce++)).recover(_signature);
206         require(_operator == hermeses[_hermesId].operator, "wrong signature");
207 
208         // Update URL
209         hermeses[_hermesId].url = _url;
210 
211         emit HermesURLUpdated(_hermesId, _url);
212     }
213 
214     // ------------ UTILS ------------
215     function getCreate2Address(bytes32 _salt, bytes32 _code) internal view returns (address) {
216         return address(uint160(uint256(keccak256(abi.encodePacked(
217             bytes1(0xff),
218             address(this),
219             bytes32(_salt),
220             bytes32(_code)
221         )))));
222     }
223 
224     function getProxyCode(address _implementation) public pure returns (bytes memory) {
225         // `_code` is EIP 1167 - Minimal Proxy Contract
226         // more information: https://eips.ethereum.org/EIPS/eip-1167
227         bytes memory _code = hex"3d602d80600a3d3981f3363d3d373d3d3d363d73bebebebebebebebebebebebebebebebebebebebe5af43d82803e903d91602b57fd5bf3";
228 
229         bytes20 _targetBytes = bytes20(_implementation);
230         for (uint8 i = 0; i < 20; i++) {
231             _code[20 + i] = _targetBytes[i];
232         }
233 
234         return _code;
235     }
236 
237     function deployMiniProxy(uint256 _salt, bytes memory _code) internal returns (address payable) {
238         address payable _addr;
239 
240         assembly {
241             _addr := create2(0, add(_code, 0x20), mload(_code), _salt)
242             if iszero(extcodesize(_addr)) {
243                 revert(0, 0)
244             }
245         }
246 
247         return _addr;
248     }
249 
250     function getBeneficiary(address _identity) public view returns (address) {
251         if (hasParentRegistry())
252             return parentRegistry.getBeneficiary(_identity);
253 
254         return identities[_identity];
255     }
256 
257     function setBeneficiary(address _identity, address _newBeneficiary, bytes memory _signature) public {
258         require(_newBeneficiary != address(0), "Registry: beneficiary can't be zero address");
259 
260         // Always set beneficiary into root registry
261         if (hasParentRegistry()) {
262             parentRegistry.setBeneficiary(_identity, _newBeneficiary, _signature);
263         } else {
264             lastNonce = lastNonce + 1;
265 
266             // In signatures we should always use root registry (for backward compatibility)
267             address _rootRegistry = hasParentRegistry() ? address(parentRegistry) : address(this);
268             address _signer = keccak256(abi.encodePacked(getChainID(), _rootRegistry, _identity, _newBeneficiary, lastNonce)).recover(_signature);
269             require(_signer == _identity, "Registry: have to be signed by identity owner");
270 
271             identities[_identity] = _newBeneficiary;
272 
273             emit BeneficiaryChanged(_identity, _newBeneficiary);
274         }
275     }
276 
277     function setMinimalHermesStake(uint256 _newMinimalStake) public onlyOwner {
278         require(isInitialized(), "Registry: only initialized registry can set new minimal hermes stake");
279         minimalHermesStake = _newMinimalStake;
280         emit MinimalHermesStakeChanged(_newMinimalStake);
281     }
282 
283     // -------- UTILS TO WORK WITH CHANNEL AND HERMES IMPLEMENTATIONS ---------
284 
285     function getChannelImplementation() public view returns (address) {
286         return implementations[getLastImplVer()].channelImplAddress;
287     }
288 
289     function getChannelImplementation(uint256 _implVer) public view returns (address) {
290         return implementations[_implVer].channelImplAddress;
291     }
292 
293     function getHermesImplementation() public view returns (address) {
294         return implementations[getLastImplVer()].hermesImplAddress;
295     }
296 
297     function getHermesImplementation(uint256 _implVer) public view returns (address) {
298         return implementations[_implVer].hermesImplAddress;
299     }
300 
301     function setImplementations(address _newChannelImplAddress, address _newHermesImplAddress) public onlyOwner {
302         require(isInitialized(), "Registry: only initialized registry can set new implementations");
303         require(isSmartContract(_newChannelImplAddress) && isSmartContract(_newHermesImplAddress), "Registry: implementations have to be smart contracts");
304         implementations.push(Implementation(_newChannelImplAddress, _newHermesImplAddress));
305     }
306 
307     // Version of latest hermes and channel implementations
308     function getLastImplVer() public view returns (uint256) {
309         return implementations.length-1;
310     }
311 
312     // ------------------------------------------------------------------------
313 
314     function isSmartContract(address _addr) internal view returns (bool) {
315         uint _codeLength;
316 
317         assembly {
318             _codeLength := extcodesize(_addr)
319         }
320 
321         return _codeLength != 0;
322     }
323 
324     // If `parentRegistry` is not set, this is root registry and should return false
325     function hasParentRegistry() public view returns (bool) {
326         return address(parentRegistry) != address(0);
327     }
328 
329     function isRegistered(address _identity) public view returns (bool) {
330         if (hasParentRegistry())
331             return parentRegistry.isRegistered(_identity);
332 
333         // If we know its beneficiary address it is registered identity
334         return identities[_identity] != address(0);
335     }
336 
337     function isHermes(address _hermesId) public view returns (bool) {
338         // To check if it actually properly created hermes address, we need to check if he has operator
339         // and if with that operator we'll get proper hermes address which has code deployed there.
340         address _hermesOperator = hermeses[_hermesId].operator;
341         uint256 _implVer = hermeses[_hermesId].implVer;
342         address _addr = getHermesAddress(_hermesOperator, _implVer);
343         if (_addr != _hermesId)
344             return false; // hermesId should be same as generated address
345 
346         return isSmartContract(_addr) || parentRegistry.isHermes(_hermesId);
347     }
348 
349     function isActiveHermes(address _hermesId) internal view returns (bool) {
350         // First we have to ensure that given address is registered hermes and only then check its status
351         require(isHermes(_hermesId), "Registry: hermes have to be registered");
352 
353         IHermesContract.Status status = IHermesContract(_hermesId).getStatus();
354         return status == IHermesContract.Status.Active;
355     }
356 
357     function isChannelOpened(address _identity, address _hermesId) public view returns (bool) {
358         return isSmartContract(getChannelAddress(_identity, _hermesId)) || isSmartContract(parentRegistry.getChannelAddress(_identity, _hermesId));
359     }
360 
361     function transferCollectedFeeTo(address _beneficiary) public onlyOwner{
362         uint256 _collectedFee = token.balanceOf(address(this));
363         require(_collectedFee > 0, "collected fee cannot be less than zero");
364         token.transfer(_beneficiary, _collectedFee);
365     }
366 }
