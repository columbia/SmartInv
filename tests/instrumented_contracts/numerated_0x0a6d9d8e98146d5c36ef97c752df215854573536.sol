1 pragma solidity ^0.5.3;
2 
3 contract Ownable {
4     address private _owner;
5 
6     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8     constructor () internal {
9         _owner = msg.sender;
10         emit OwnershipTransferred(address(0), _owner);
11     }
12 
13     function owner() public view returns (address) {
14         return _owner;
15     }
16 
17     modifier onlyOwner() {
18         require(isOwner());
19         _;
20     }
21 
22     function isOwner() public view returns (bool) {
23         return msg.sender == _owner;
24     }
25 
26     function renounceOwnership() public onlyOwner {
27         emit OwnershipTransferred(_owner, address(0));
28         _owner = address(0);
29     }
30 
31     function transferOwnership(address newOwner) public onlyOwner {
32         _transferOwnership(newOwner);
33     }
34 
35     function _transferOwnership(address newOwner) internal {
36         require(newOwner != address(0));
37         emit OwnershipTransferred(_owner, newOwner);
38         _owner = newOwner;
39     }
40 }
41 
42 contract RelayRegistry is Ownable {
43     
44     event AddedRelay(address relay);
45     event RemovedRelay(address relay);
46     
47     mapping (address => bool) public relays;
48     
49     constructor(address initialRelay) public {
50         relays[initialRelay] = true;
51     }
52     
53     function triggerRelay(address relay, bool value) onlyOwner public returns (bool) {
54         relays[relay] = value;
55         if(value) {
56             emit AddedRelay(relay);
57         } else {
58             emit RemovedRelay(relay);
59         }
60         return true;
61     }
62     
63 }
64 
65 interface IERC20 {
66     function transfer(address to, uint256 value) external returns (bool);
67 }
68 
69 // All functions of SmartWallet Implementations should be called using delegatecall
70 contract SmartWallet {
71 
72     event Upgrade(address indexed newImplementation);
73 
74     // Shared key value store. Data should be encoded and decoded using abi.encode()/abi.decode() by different implementations
75     mapping (bytes32 => bytes) public store;
76     
77     modifier onlyRelay {
78         RelayRegistry registry = RelayRegistry(0xd23e2F482005a90FC2b8dcDd58affc05D5776cb7); // relay registry address
79         require(registry.relays(msg.sender));
80         _;
81     }
82     
83     modifier onlyOwner {
84         require(msg.sender == abi.decode(store["owner"], (address)) || msg.sender == abi.decode(store["factory"], (address)));
85         _;
86     }
87     
88     function initiate(address owner) public returns (bool) {
89         // this function can only be called by the factory
90         if(msg.sender != abi.decode(store["factory"], (address))) return false;
91         // store current owner in key store
92         store["owner"] = abi.encode(owner);
93         store["nonce"] = abi.encode(0);
94         return true;
95     }
96     
97     // Called by factory to initiate state if deployment was relayed
98     function initiate(address owner, address relay, uint fee, address token) public returns (bool) {
99         require(initiate(owner), "internal initiate failed");
100         // Access ERC20 token
101         IERC20 tokenContract = IERC20(token);
102         // Send fee to relay
103         require(tokenContract.transfer(relay, fee), "fee transfer failed");
104         return true;
105     }
106     
107     function pay(address to, uint value, uint fee, address tokenContract, uint8 v, bytes32 r, bytes32 s) onlyRelay public returns (bool) {
108         uint currentNonce = abi.decode(store["nonce"], (uint));
109         require(abi.decode(store["owner"], (address)) == recover(keccak256(abi.encodePacked(msg.sender, to, tokenContract, abi.decode(store["factory"], (address)), value, fee, tx.gasprice, currentNonce)), v, r, s));
110         IERC20 token = IERC20(tokenContract);
111         store["nonce"] = abi.encode(currentNonce+1);
112         require(token.transfer(to, value));
113         require(token.transfer(msg.sender, fee));
114         return true;
115     }
116     
117     function pay(address to, uint value, address tokenContract) onlyOwner public returns (bool) {
118         IERC20 token = IERC20(tokenContract);
119         require(token.transfer(to, value));
120         return true;
121     }
122     
123     function pay(address[] memory to, uint[] memory value, address[] memory tokenContract) onlyOwner public returns (bool) {
124         for (uint i; i < to.length; i++) {
125             IERC20 token = IERC20(tokenContract[i]);
126             require(token.transfer(to[i], value[i]));
127         }
128         return true;
129     }
130     
131     function upgrade(address implementation, uint fee, address feeContract, uint8 v, bytes32 r, bytes32 s) onlyRelay public returns (bool) {
132         uint currentNonce = abi.decode(store["nonce"], (uint));
133         address owner = abi.decode(store["owner"], (address));
134         address factory = abi.decode(store["factory"], (address));
135         require(owner == recover(keccak256(abi.encodePacked(msg.sender, implementation, feeContract, factory, fee, tx.gasprice, currentNonce)), v, r, s));
136         store["nonce"] = abi.encode(currentNonce+1);
137         store["fallback"] = abi.encode(implementation);
138         IERC20 feeToken = IERC20(feeContract);
139         require(feeToken.transfer(msg.sender, fee));
140         emit Upgrade(implementation);
141         return true;
142         
143     }
144     
145     function upgrade(address implementation) onlyOwner public returns (bool) {
146         store["fallback"] = abi.encode(implementation);
147         emit Upgrade(implementation);
148         return true;
149     }
150     
151     
152     function recover(bytes32 messageHash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
153         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
154         bytes32 prefixedMessageHash = keccak256(abi.encodePacked(prefix, messageHash));
155         return ecrecover(prefixedMessageHash, v, r, s);
156     }
157     
158 }
159 
160 contract Proxy {
161     
162     // Shared key value store. Data should be encoded and decoded using abi.encode()/abi.decode() by different implementations
163     mapping (bytes32 => bytes) public store;
164     
165     constructor() public {
166         // set implementation address in storage
167         store["fallback"] = abi.encode(0x09892527914356473380b3Aebe1F96ce0DC6982C); // SmartWallet address
168         // set factory address in storage
169         store["factory"] = abi.encode(msg.sender);
170     }
171     
172     // forwards everything as a delegatecall to appropriate address
173     function() external {
174         address impl = abi.decode(store["fallback"], (address));
175         assembly {
176           let ptr := mload(0x40)
177         
178           // (1) copy incoming call data
179           calldatacopy(ptr, 0, calldatasize)
180         
181           // (2) forward call to logic contract
182           let result := delegatecall(gas, impl, ptr, calldatasize, 0, 0)
183           let size := returndatasize
184         
185           // (3) retrieve return data
186           returndatacopy(ptr, 0, size)
187 
188           // (4) forward return data back to caller
189           switch result
190           case 0 { revert(ptr, size) }
191           default { return(ptr, size) }
192         }
193     }
194 }
195 
196 contract Factory {
197     
198     event Deployed(address indexed addr, address indexed owner);
199 
200     modifier onlyRelay {
201         RelayRegistry registry = RelayRegistry(0xd23e2F482005a90FC2b8dcDd58affc05D5776cb7); // Relay Registry address
202         require(registry.relays(msg.sender));
203         _;
204     }
205 
206     // internal create2 deployer
207     function deployCreate2(address owner) internal returns (address) {
208         bytes memory code = type(Proxy).creationCode;
209         address addr;
210         assembly {
211             // create2
212             addr := create2(0, add(code, 0x20), mload(code), owner)
213             // revert if contract was not created
214             if iszero(extcodesize(addr)) {revert(0, 0)}
215         }
216         return addr;
217     }
218 
219     // create2 with a relayer
220     function deployWallet(uint fee, address token, uint8 v, bytes32 r, bytes32 s) onlyRelay public returns (address) {
221         address signer = recover(keccak256(abi.encodePacked(address(this), msg.sender, token, tx.gasprice, fee)), v, r, s);
222         address addr = deployCreate2(signer);
223         SmartWallet wallet = SmartWallet(uint160(addr));
224         require(wallet.initiate(signer, msg.sender, fee, token));
225         emit Deployed(addr, signer);
226         return addr;
227     }
228     
229     function deployWallet(uint fee, address token, address to, uint value, uint8 v, bytes32 r, bytes32 s) onlyRelay public returns (address addr) {
230         address signer = recover(keccak256(abi.encodePacked(address(this), msg.sender, token, to, tx.gasprice, fee, value)), v, r, s);
231         addr = deployCreate2(signer);
232         SmartWallet wallet = SmartWallet(uint160(addr));
233         require(wallet.initiate(signer, msg.sender, fee, token));
234         require(wallet.pay(to, value, token));
235         emit Deployed(addr, signer);
236     }
237     
238     // create2 directly from owner
239     function deployWallet() public returns (address) {
240         address addr = deployCreate2(msg.sender);
241         SmartWallet wallet = SmartWallet(uint160(addr));
242         require(wallet.initiate(msg.sender));
243         emit Deployed(addr, msg.sender);
244         return addr;
245         
246     }
247 
248     // get create2
249     function getCreate2Address(address owner) public view returns (address) {
250         bytes32 temp = keccak256(abi.encodePacked(bytes1(0xff), address(this), uint(owner), bytes32(keccak256(type(Proxy).creationCode))));
251         address ret;
252         uint mask = 2 ** 160 - 1;
253         assembly {
254             ret := and(temp, mask)
255         }
256         return ret;
257     }
258     
259     function getCreate2Address() public view returns (address) {
260         return getCreate2Address(msg.sender);
261     }
262     
263     function canDeploy(address owner) public view returns (bool inexistent) {
264         address wallet = getCreate2Address(owner);
265         assembly {
266             inexistent := eq(extcodesize(wallet), 0)
267         }
268     }
269     
270     function canDeploy() public view returns (bool) {
271         return canDeploy(msg.sender);
272     }
273     
274     function recover(bytes32 messageHash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
275         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
276         bytes32 prefixedMessageHash = keccak256(abi.encodePacked(prefix, messageHash));
277         return ecrecover(prefixedMessageHash, v, r, s);
278     }
279 
280 }