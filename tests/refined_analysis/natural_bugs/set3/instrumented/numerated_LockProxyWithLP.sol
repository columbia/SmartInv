1 pragma solidity ^0.5.0;
2 pragma experimental ABIEncoderV2;
3 
4 import "./../../libs/ownership/Ownable.sol";
5 import "./../../libs/common/ZeroCopySource.sol";
6 import "./../../libs/common/ZeroCopySink.sol";
7 import "./../../libs/utils/Utils.sol";
8 import "./../../libs/token/ERC20/SafeERC20.sol";
9 import "./../../libs/lifecycle/Pausable.sol";
10 import "./../cross_chain_manager/interface/IEthCrossChainManager.sol";
11 import "./../cross_chain_manager/interface/IEthCrossChainManagerProxy.sol";
12 
13 contract LockProxyWithLP is Ownable, Pausable {
14     using SafeMath for uint;
15     using SafeERC20 for IERC20;
16 
17     struct TxArgs {
18         bytes toAssetHash;
19         bytes toAddress;
20         uint256 amount;
21     }
22     address public managerProxyContract;
23 
24     mapping(uint64 => bytes) public proxyHashMap;
25     mapping(address => mapping(uint64 => bytes)) public assetHashMap;
26     mapping(address => address) public assetLPMap;
27 
28     event SetManagerProxyEvent(address manager);
29     event BindProxyEvent(uint64 toChainId, bytes targetProxyHash);
30     event BindAssetEvent(address fromAssetHash, uint64 toChainId, bytes targetProxyHash, uint initialAmount);
31     event UnlockEvent(address toAssetHash, address toAddress, uint256 amount);
32     event LockEvent(address fromAssetHash, address fromAddress, uint64 toChainId, bytes toAssetHash, bytes toAddress, uint256 amount);
33 
34     event depositEvent(address toAddress, address fromAssetHash, address fromLPHash, uint256 amount);
35     event withdrawEvent(address toAddress, address fromAssetHash, address fromLPHash, uint256 amount);
36     event BindLPToAssetEvent(address originAssetAddress, address LPTokenAddress);
37 
38     modifier onlyManagerContract() {
39         IEthCrossChainManagerProxy ieccmp = IEthCrossChainManagerProxy(managerProxyContract);
40         require(_msgSender() == ieccmp.getEthCrossChainManager(), "msgSender is not EthCrossChainManagerContract");
41         _;
42     }
43 
44     function pause() onlyOwner whenNotPaused public returns (bool) {
45         _pause();
46         return true;
47     }
48     function unpause() onlyOwner whenPaused public returns (bool) {
49         _unpause();
50         return true;
51     }
52     
53     function setManagerProxy(address ethCCMProxyAddr) onlyOwner public {
54         managerProxyContract = ethCCMProxyAddr;
55         emit SetManagerProxyEvent(managerProxyContract);
56     }
57     
58     function bindProxyHash(uint64 toChainId, bytes memory targetProxyHash) onlyOwner public returns (bool) {
59         proxyHashMap[toChainId] = targetProxyHash;
60         emit BindProxyEvent(toChainId, targetProxyHash);
61         return true;
62     }
63 
64     function bindAssetHash(address fromAssetHash, uint64 toChainId, bytes memory toAssetHash) onlyOwner public returns (bool) {
65         assetHashMap[fromAssetHash][toChainId] = toAssetHash;
66         emit BindAssetEvent(fromAssetHash, toChainId, toAssetHash, getBalanceFor(fromAssetHash));
67         return true;
68     }
69 
70     function bindLPToAsset(address originAssetAddress, address LPTokenAddress) onlyOwner public returns (bool) {
71         assetLPMap[originAssetAddress] = LPTokenAddress;
72         emit BindLPToAssetEvent(originAssetAddress, LPTokenAddress);
73         return true;
74     }
75 
76     function bindLPAndAsset(address fromAssetHash, address fromLPHash, uint64 toChainId, bytes memory toAssetHash, bytes memory toLPHash) onlyOwner public returns (bool) {
77         assetHashMap[fromAssetHash][toChainId] = toAssetHash;
78         assetHashMap[fromLPHash][toChainId] = toLPHash;
79         assetLPMap[fromAssetHash] = fromLPHash;
80         emit BindAssetEvent(fromAssetHash, toChainId, toAssetHash, getBalanceFor(fromAssetHash));
81         emit BindAssetEvent(fromLPHash, toChainId, toLPHash, getBalanceFor(fromLPHash));
82         emit BindLPToAssetEvent(fromAssetHash, fromLPHash);
83         return true;
84     }
85     
86     function bindProxyHashBatch(uint64[] memory toChainId, bytes[] memory targetProxyHash) onlyOwner public returns (bool) {
87         require(toChainId.length == targetProxyHash.length, "bindProxyHashBatch: args length diff");
88         for (uint i = 0; i < toChainId.length; i++) {
89             proxyHashMap[toChainId[i]] = targetProxyHash[i];
90             emit BindProxyEvent(toChainId[i], targetProxyHash[i]);
91         }
92         return true;
93     }
94 
95     function bindAssetHashBatch(address[] memory fromAssetHash, uint64[] memory toChainId, bytes[] memory toAssetHash) onlyOwner public returns (bool) {
96         require(toChainId.length == fromAssetHash.length, "bindAssetHashBatch: args length diff");
97         require(toChainId.length == toAssetHash.length, "bindAssetHashBatch: args length diff");
98         for (uint i = 0; i < toChainId.length; i++) {
99             assetHashMap[fromAssetHash[i]][toChainId[i]] = toAssetHash[i];
100             emit BindAssetEvent(fromAssetHash[i], toChainId[i], toAssetHash[i], getBalanceFor(fromAssetHash[i]));
101         }
102         return true;
103     }
104 
105     function bindLPToAssetBatch(address[] memory originAssetAddress, address[] memory LPTokenAddress) onlyOwner public returns (bool) {
106         require(originAssetAddress.length == LPTokenAddress.length, "bindLPToAssetBatch: args length diff");
107         for (uint i = 0; i < originAssetAddress.length; i++) {
108             assetLPMap[originAssetAddress[i]] = LPTokenAddress[i];
109             emit BindLPToAssetEvent(originAssetAddress[i], LPTokenAddress[i]);
110         }
111         return true;
112     }
113  
114     function bindLPAndAssetBatch(address[] memory fromAssetHash, address[] memory fromLPHash, uint64[] memory toChainId, bytes[] memory toAssetHash, bytes[] memory toLPHash) onlyOwner public returns (bool) {
115         require(fromAssetHash.length == fromLPHash.length, "bindLPAndAssetBatch: args length diff");
116         require(toAssetHash.length == toLPHash.length, "bindLPAndAssetBatch: args length diff");
117         for(uint256 i = 0; i < fromLPHash.length; i++) {
118             assetHashMap[fromAssetHash[i]][toChainId[i]] = toAssetHash[i];
119             assetHashMap[fromLPHash[i]][toChainId[i]] = toLPHash[i];
120             assetLPMap[fromAssetHash[i]] = fromLPHash[i];
121             emit BindAssetEvent(fromAssetHash[i], toChainId[i], toAssetHash[i], getBalanceFor(fromAssetHash[i]));
122             emit BindAssetEvent(fromLPHash[i], toChainId[i], toLPHash[i], getBalanceFor(fromLPHash[i]));
123             emit BindLPToAssetEvent(fromAssetHash[i], fromLPHash[i]);
124         }
125         return true;
126     } 
127 
128     /* @notice                  This function is meant to be invoked by the user,
129     *                           a certain amount tokens will be locked in the proxy contract the invoker/msg.sender immediately.
130     *                           Then the same amount of tokens will be unloked from target chain proxy contract at the target chain with chainId later.
131     *  @param fromAssetHash     The asset address in current chain, uniformly named as `fromAssetHash`
132     *  @param toChainId         The target chain id
133     *                           
134     *  @param toAddress         The address in bytes format to receive same amount of tokens in target chain 
135     *  @param amount            The amount of tokens to be crossed from ethereum to the chain with chainId
136     */
137     function lock(address fromAssetHash, uint64 toChainId, bytes memory toAddress, uint256 amount) public payable returns (bool) {
138         require(amount != 0, "amount cannot be zero!");
139         require(_transferToContract(fromAssetHash, amount), "transfer asset from fromAddress to lock_proxy contract failed!");
140         bytes memory toAssetHash = assetHashMap[fromAssetHash][toChainId];
141         require(toAssetHash.length != 0, "empty illegal toAssetHash");
142 
143         TxArgs memory txArgs = TxArgs({
144             toAssetHash: toAssetHash,
145             toAddress: toAddress,
146             amount: amount
147         });
148         bytes memory txData = _serializeTxArgs(txArgs);
149         
150         IEthCrossChainManagerProxy eccmp = IEthCrossChainManagerProxy(managerProxyContract);
151         address eccmAddr = eccmp.getEthCrossChainManager();
152         IEthCrossChainManager eccm = IEthCrossChainManager(eccmAddr);
153         
154         bytes memory toProxyHash = proxyHashMap[toChainId];
155         require(toProxyHash.length != 0, "empty illegal toProxyHash");
156         require(eccm.crossChain(toChainId, toProxyHash, "unlock", txData), "EthCrossChainManager crossChain executed error!");
157 
158         emit LockEvent(fromAssetHash, _msgSender(), toChainId, toAssetHash, toAddress, amount);
159         
160         return true;
161     }
162     
163     /* @notice                  This function is meant to be invoked by the ETH crosschain management contract,
164     *                           then mint a certin amount of tokens to the designated address since a certain amount 
165     *                           was burnt from the source chain invoker.
166     *  @param argsBs            The argument bytes recevied by the ethereum lock proxy contract, need to be deserialized.
167     *                           based on the way of serialization in the source chain proxy contract.
168     *  @param fromContractAddr  The source chain contract address
169     *  @param fromChainId       The source chain id
170     */
171     function unlock(bytes memory argsBs, bytes memory fromContractAddr, uint64 fromChainId) onlyManagerContract public returns (bool) {
172         TxArgs memory args = _deserializeTxArgs(argsBs);
173 
174         require(fromContractAddr.length != 0, "from proxy contract address cannot be empty");
175         require(Utils.equalStorage(proxyHashMap[fromChainId], fromContractAddr), "From Proxy contract address error!");
176         
177         require(args.toAssetHash.length != 0, "toAssetHash cannot be empty");
178         address toAssetHash = Utils.bytesToAddress(args.toAssetHash);
179 
180         require(args.toAddress.length != 0, "toAddress cannot be empty");
181         address toAddress = Utils.bytesToAddress(args.toAddress);
182         
183         require(_transferFromContract(toAssetHash, toAddress, args.amount), "transfer asset from lock_proxy contract to toAddress failed!");
184         
185         emit UnlockEvent(toAssetHash, toAddress, args.amount);
186         return true;
187     }
188 
189 
190     function deposit(address originAssetAddress, uint amount) whenNotPaused payable public returns (bool) {
191         require(amount != 0, "amount cannot be zero!");
192 
193         require(_transferToContract(originAssetAddress, amount), "transfer asset from fromAddress to lock_proxy contract failed!");
194 
195         address LPTokenAddress = assetLPMap[originAssetAddress];
196         require(LPTokenAddress != address(0), "do not support deposite this token");
197         require(_transferFromContract(LPTokenAddress, msg.sender, amount), "transfer proof of liquidity from lock_proxy contract to fromAddress failed!");
198         
199         emit depositEvent(msg.sender, originAssetAddress, LPTokenAddress, amount);
200         return true;
201     }
202 
203     function withdraw(address targetTokenAddress, uint amount) whenNotPaused public returns (bool) {
204         require(amount != 0, "amount cannot be zero!");
205 
206         address LPTokenAddress = assetLPMap[targetTokenAddress];
207         require(LPTokenAddress != address(0), "do not support withdraw this token");
208         require(_transferToContract(LPTokenAddress, amount), "transfer proof of liquidity from fromAddress to lock_proxy contract failed!");
209 
210         require(_transferFromContract(targetTokenAddress, msg.sender, amount), "transfer asset from lock_proxy contract to fromAddress failed!");
211         
212         emit withdrawEvent(msg.sender, targetTokenAddress, LPTokenAddress, amount);
213         return true;
214     }
215 
216     function getBalanceFor(address fromAssetHash) public view returns (uint256) {
217         if (fromAssetHash == address(0)) {
218             // return address(this).balance; // this expression would result in error: Failed to decode output: Error: insufficient data for uint256 type
219             address selfAddr = address(this);
220             return selfAddr.balance;
221         } else {
222             IERC20 erc20Token = IERC20(fromAssetHash);
223             return erc20Token.balanceOf(address(this));
224         }
225     }
226 
227     function _transferToContract(address fromAssetHash, uint256 amount) internal returns (bool) {
228         if (fromAssetHash == address(0)) {
229             // fromAssetHash === address(0) denotes user choose to lock ether
230             // passively check if the received msg.value equals amount
231             require(msg.value != 0, "transferred ether cannot be zero!");
232             require(msg.value == amount, "transferred ether is not equal to amount!");
233         } else {
234             // make sure lockproxy contract will decline any received ether
235             require(msg.value == 0, "there should be no ether transfer!");
236             // actively transfer amount of asset from msg.sender to lock_proxy contract
237             require(_transferERC20ToContract(fromAssetHash, _msgSender(), address(this), amount), "transfer erc20 asset to lock_proxy contract failed!");
238         }
239         return true;
240     }
241     function _transferFromContract(address toAssetHash, address toAddress, uint256 amount) internal returns (bool) {
242         if (toAssetHash == address(0x0000000000000000000000000000000000000000)) {
243             // toAssetHash === address(0) denotes contract needs to unlock ether to toAddress
244             // convert toAddress from 'address' type to 'address payable' type, then actively transfer ether
245             address(uint160(toAddress)).transfer(amount);
246         } else {
247             // actively transfer amount of asset from msg.sender to lock_proxy contract 
248             require(_transferERC20FromContract(toAssetHash, toAddress, amount), "transfer erc20 asset to lock_proxy contract failed!");
249         }
250         return true;
251     }
252     
253     function _transferERC20ToContract(address fromAssetHash, address fromAddress, address toAddress, uint256 amount) internal returns (bool) {
254          IERC20 erc20Token = IERC20(fromAssetHash);
255         //  require(erc20Token.transferFrom(fromAddress, toAddress, amount), "trasnfer ERC20 Token failed!");
256          erc20Token.safeTransferFrom(fromAddress, toAddress, amount);
257          return true;
258     }
259     function _transferERC20FromContract(address toAssetHash, address toAddress, uint256 amount) internal returns (bool) {
260          IERC20 erc20Token = IERC20(toAssetHash);
261         //  require(erc20Token.transfer(toAddress, amount), "transfer ERC20 Token failed!");
262          erc20Token.safeTransfer(toAddress, amount);
263          return true;
264     }
265     
266     function _serializeTxArgs(TxArgs memory args) internal pure returns (bytes memory) {
267         bytes memory buff;
268         buff = abi.encodePacked(
269             ZeroCopySink.WriteVarBytes(args.toAssetHash),
270             ZeroCopySink.WriteVarBytes(args.toAddress),
271             ZeroCopySink.WriteUint255(args.amount)
272             );
273         return buff;
274     }
275 
276     function _deserializeTxArgs(bytes memory valueBs) internal pure returns (TxArgs memory) {
277         TxArgs memory args;
278         uint256 off = 0;
279         (args.toAssetHash, off) = ZeroCopySource.NextVarBytes(valueBs, off);
280         (args.toAddress, off) = ZeroCopySource.NextVarBytes(valueBs, off);
281         (args.amount, off) = ZeroCopySource.NextUint255(valueBs, off);
282         return args;
283     }
284 }