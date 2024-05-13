1 pragma solidity ^0.5.0;
2 pragma experimental ABIEncoderV2;
3 
4 import "./../../libs/ownership/Ownable.sol";
5 import "./../../libs/common/ZeroCopySource.sol";
6 import "./../../libs/common/ZeroCopySink.sol";
7 import "./../../libs/utils/Utils.sol";
8 import "./../../libs/token/ERC20/SafeERC20.sol";
9 import "./../../libs/token/ERC20/ERC20Detailed.sol";
10 import "./../../libs/lifecycle/Pausable.sol";
11 import "./../cross_chain_manager/interface/IEthCrossChainManager.sol";
12 import "./../cross_chain_manager/interface/IEthCrossChainManagerProxy.sol";
13 
14 contract LockProxyPip4 is Ownable, Pausable {
15     using SafeMath for uint;
16     using SafeERC20 for IERC20;
17 
18     uint8 constant StandardDecimals = 18;
19 
20     struct TxArgs {
21         bytes toAssetHash;
22         bytes toAddress;
23         uint256 amount;
24     }
25     address public managerProxyContract;
26 
27     mapping(uint64 => bytes) public proxyHashMap;
28     mapping(address => mapping(uint64 => bytes)) public assetHashMap;
29     mapping(address => address) public assetLPMap;
30 
31     event SetManagerProxyEvent(address manager);
32     event BindProxyEvent(uint64 toChainId, bytes targetProxyHash);
33     event BindAssetEvent(address fromAssetHash, uint64 toChainId, bytes targetProxyHash, uint initialAmount);
34     event UnlockEvent(address toAssetHash, address toAddress, uint256 amount);
35     event LockEvent(address fromAssetHash, address fromAddress, uint64 toChainId, bytes toAssetHash, bytes toAddress, uint256 amount);
36 
37     event depositEvent(address toAddress, address fromAssetHash, address fromLPHash, uint256 amount);
38     event withdrawEvent(address toAddress, address fromAssetHash, address fromLPHash, uint256 amount);
39     event BindLPToAssetEvent(address originAssetAddress, address LPTokenAddress);
40 
41     modifier onlyManagerContract() {
42         IEthCrossChainManagerProxy ieccmp = IEthCrossChainManagerProxy(managerProxyContract);
43         require(_msgSender() == ieccmp.getEthCrossChainManager(), "msgSender is not EthCrossChainManagerContract");
44         _;
45     }
46 
47     function pause() onlyOwner whenNotPaused public returns (bool) {
48         _pause();
49         return true;
50     }
51     function unpause() onlyOwner whenPaused public returns (bool) {
52         _unpause();
53         return true;
54     }
55     
56     function setManagerProxy(address ethCCMProxyAddr) onlyOwner public {
57         managerProxyContract = ethCCMProxyAddr;
58         emit SetManagerProxyEvent(managerProxyContract);
59     }
60     
61     function bindProxyHash(uint64 toChainId, bytes memory targetProxyHash) onlyOwner public returns (bool) {
62         proxyHashMap[toChainId] = targetProxyHash;
63         emit BindProxyEvent(toChainId, targetProxyHash);
64         return true;
65     }
66 
67     function bindAssetHash(address fromAssetHash, uint64 toChainId, bytes memory toAssetHash) onlyOwner public returns (bool) {
68         assetHashMap[fromAssetHash][toChainId] = toAssetHash;
69         emit BindAssetEvent(fromAssetHash, toChainId, toAssetHash, getBalanceFor(fromAssetHash));
70         return true;
71     }
72 
73     function bindLPToAsset(address originAssetAddress, address LPTokenAddress) onlyOwner public returns (bool) {
74         assetLPMap[originAssetAddress] = LPTokenAddress;
75         emit BindLPToAssetEvent(originAssetAddress, LPTokenAddress);
76         return true;
77     }
78 
79     function bindLPAndAsset(address fromAssetHash, address fromLPHash, uint64 toChainId, bytes memory toAssetHash, bytes memory toLPHash) onlyOwner public returns (bool) {
80         assetHashMap[fromAssetHash][toChainId] = toAssetHash;
81         assetHashMap[fromLPHash][toChainId] = toLPHash;
82         assetLPMap[fromAssetHash] = fromLPHash;
83         emit BindAssetEvent(fromAssetHash, toChainId, toAssetHash, getBalanceFor(fromAssetHash));
84         emit BindAssetEvent(fromLPHash, toChainId, toLPHash, getBalanceFor(fromLPHash));
85         emit BindLPToAssetEvent(fromAssetHash, fromLPHash);
86         return true;
87     }
88     
89     function bindProxyHashBatch(uint64[] memory toChainId, bytes[] memory targetProxyHash) onlyOwner public returns (bool) {
90         require(toChainId.length == targetProxyHash.length, "bindProxyHashBatch: args length diff");
91         for (uint i = 0; i < toChainId.length; i++) {
92             proxyHashMap[toChainId[i]] = targetProxyHash[i];
93             emit BindProxyEvent(toChainId[i], targetProxyHash[i]);
94         }
95         return true;
96     }
97 
98     function bindAssetHashBatch(address[] memory fromAssetHash, uint64[] memory toChainId, bytes[] memory toAssetHash) onlyOwner public returns (bool) {
99         require(toChainId.length == fromAssetHash.length, "bindAssetHashBatch: args length diff");
100         require(toChainId.length == toAssetHash.length, "bindAssetHashBatch: args length diff");
101         for (uint i = 0; i < toChainId.length; i++) {
102             assetHashMap[fromAssetHash[i]][toChainId[i]] = toAssetHash[i];
103             emit BindAssetEvent(fromAssetHash[i], toChainId[i], toAssetHash[i], getBalanceFor(fromAssetHash[i]));
104         }
105         return true;
106     }
107 
108     function bindLPToAssetBatch(address[] memory originAssetAddress, address[] memory LPTokenAddress) onlyOwner public returns (bool) {
109         require(originAssetAddress.length == LPTokenAddress.length, "bindLPToAssetBatch: args length diff");
110         for (uint i = 0; i < originAssetAddress.length; i++) {
111             assetLPMap[originAssetAddress[i]] = LPTokenAddress[i];
112             emit BindLPToAssetEvent(originAssetAddress[i], LPTokenAddress[i]);
113         }
114         return true;
115     }
116  
117     function bindLPAndAssetBatch(address[] memory fromAssetHash, address[] memory fromLPHash, uint64[] memory toChainId, bytes[] memory toAssetHash, bytes[] memory toLPHash) onlyOwner public returns (bool) {
118         require(fromAssetHash.length == fromLPHash.length, "bindLPAndAssetBatch: args length diff");
119         require(toAssetHash.length == toLPHash.length, "bindLPAndAssetBatch: args length diff");
120         for(uint256 i = 0; i < fromLPHash.length; i++) {
121             assetHashMap[fromAssetHash[i]][toChainId[i]] = toAssetHash[i];
122             assetHashMap[fromLPHash[i]][toChainId[i]] = toLPHash[i];
123             assetLPMap[fromAssetHash[i]] = fromLPHash[i];
124             emit BindAssetEvent(fromAssetHash[i], toChainId[i], toAssetHash[i], getBalanceFor(fromAssetHash[i]));
125             emit BindAssetEvent(fromLPHash[i], toChainId[i], toLPHash[i], getBalanceFor(fromLPHash[i]));
126             emit BindLPToAssetEvent(fromAssetHash[i], fromLPHash[i]);
127         }
128         return true;
129     } 
130 
131     /* @notice                  This function is meant to be invoked by the user,
132     *                           a certain amount tokens will be locked in the proxy contract the invoker/msg.sender immediately.
133     *                           Then the same amount of tokens will be unloked from target chain proxy contract at the target chain with chainId later.
134     *  @param fromAssetHash     The asset address in current chain, uniformly named as `fromAssetHash`
135     *  @param toChainId         The target chain id
136     *                           
137     *  @param toAddress         The address in bytes format to receive same amount of tokens in target chain 
138     *  @param amount            The amount of tokens to be crossed from ethereum to the chain with chainId
139     */
140     function lock(address fromAssetHash, uint64 toChainId, bytes memory toAddress, uint256 amount) public payable returns (bool) {
141         require(amount != 0, "amount cannot be zero!");
142         require(_transferToContract(fromAssetHash, amount), "transfer asset from fromAddress to lock_proxy contract failed!");
143         bytes memory toAssetHash = assetHashMap[fromAssetHash][toChainId];
144         require(toAssetHash.length != 0, "empty illegal toAssetHash");
145     
146         TxArgs memory txArgs = TxArgs({
147             toAssetHash: toAssetHash,
148             toAddress: toAddress,
149             amount: _toStandardDecimals(fromAssetHash, amount)
150         });
151         bytes memory txData = _serializeTxArgs(txArgs);
152         
153         IEthCrossChainManagerProxy eccmp = IEthCrossChainManagerProxy(managerProxyContract);
154         address eccmAddr = eccmp.getEthCrossChainManager();
155         IEthCrossChainManager eccm = IEthCrossChainManager(eccmAddr);
156         
157         bytes memory toProxyHash = proxyHashMap[toChainId];
158         require(toProxyHash.length != 0, "empty illegal toProxyHash");
159         require(eccm.crossChain(toChainId, toProxyHash, "unlock", txData), "EthCrossChainManager crossChain executed error!");
160 
161         emit LockEvent(fromAssetHash, _msgSender(), toChainId, toAssetHash, toAddress, amount);
162         
163         return true;
164     }
165     
166     /* @notice                  This function is meant to be invoked by the ETH crosschain management contract,
167     *                           then mint a certin amount of tokens to the designated address since a certain amount 
168     *                           was burnt from the source chain invoker.
169     *  @param argsBs            The argument bytes recevied by the ethereum lock proxy contract, need to be deserialized.
170     *                           based on the way of serialization in the source chain proxy contract.
171     *  @param fromContractAddr  The source chain contract address
172     *  @param fromChainId       The source chain id
173     */
174     function unlock(bytes memory argsBs, bytes memory fromContractAddr, uint64 fromChainId) onlyManagerContract public returns (bool) {
175         TxArgs memory args = _deserializeTxArgs(argsBs);
176 
177         require(fromContractAddr.length != 0, "from proxy contract address cannot be empty");
178         require(Utils.equalStorage(proxyHashMap[fromChainId], fromContractAddr), "From Proxy contract address error!");
179         
180         require(args.toAssetHash.length != 0, "toAssetHash cannot be empty");
181         address toAssetHash = Utils.bytesToAddress(args.toAssetHash);
182 
183         require(args.toAddress.length != 0, "toAddress cannot be empty");
184         address toAddress = Utils.bytesToAddress(args.toAddress);
185 
186         uint amount = _fromStandardDecimals(toAssetHash, args.amount);
187         
188         require(_transferFromContract(toAssetHash, toAddress, amount), "transfer asset from lock_proxy contract to toAddress failed!");
189         
190         emit UnlockEvent(toAssetHash, toAddress, amount);
191         return true;
192     }
193 
194     function deposit(address originAssetAddress, uint amount) whenNotPaused payable public returns (bool) {
195         require(amount != 0, "amount cannot be zero!");
196         require(_transferToContract(originAssetAddress, amount), "transfer asset from fromAddress to lock_proxy contract failed!");
197 
198         address LPTokenAddress = assetLPMap[originAssetAddress];
199         require(LPTokenAddress != address(0), "do not support deposite this token");
200 
201         uint standardAmount = _toStandardDecimals(originAssetAddress, amount);
202         uint lpAmount = _fromStandardDecimals(LPTokenAddress, standardAmount);
203         require(_transferFromContract(LPTokenAddress, msg.sender, lpAmount), "transfer proof of liquidity from lock_proxy contract to fromAddress failed!");
204         
205         emit depositEvent(msg.sender, originAssetAddress, LPTokenAddress, amount);
206         return true;
207     }
208 
209     function withdraw(address targetTokenAddress, uint lpAmount) whenNotPaused public returns (bool) {
210         require(lpAmount != 0, "amount cannot be zero!");
211 
212         address LPTokenAddress = assetLPMap[targetTokenAddress];
213         require(LPTokenAddress != address(0), "do not support withdraw this token");
214         require(_transferToContract(LPTokenAddress, lpAmount), "transfer proof of liquidity from fromAddress to lock_proxy contract failed!");
215 
216         uint standardAmount = _toStandardDecimals(LPTokenAddress, lpAmount);
217         uint amount = _fromStandardDecimals(targetTokenAddress, standardAmount);
218         require(_transferFromContract(targetTokenAddress, msg.sender, amount), "transfer asset from lock_proxy contract to fromAddress failed!");
219         
220         emit withdrawEvent(msg.sender, targetTokenAddress, LPTokenAddress, amount);
221         return true;
222     }
223 
224     function getBalanceFor(address fromAssetHash) public view returns (uint256) {
225         if (fromAssetHash == address(0)) {
226             // return address(this).balance; // this expression would result in error: Failed to decode output: Error: insufficient data for uint256 type
227             address selfAddr = address(this);
228             return selfAddr.balance;
229         } else {
230             IERC20 erc20Token = IERC20(fromAssetHash);
231             return erc20Token.balanceOf(address(this));
232         }
233     }
234 
235     function _toStandardDecimals(address token, uint256 amount) internal view returns (uint256) {
236         uint8 decimals;
237         if (token == address(0)) {
238             decimals = 18;
239         } else {
240             decimals = ERC20Detailed(token).decimals();
241         }
242         if (decimals == StandardDecimals) {
243             return amount;
244         } else if (decimals < StandardDecimals) {
245             return amount * (10 ** uint(StandardDecimals - decimals));
246         } else {
247             return amount / (10 ** uint(decimals - StandardDecimals));
248         }
249     }
250 
251     function _fromStandardDecimals(address token, uint256 standardAmount) internal view returns (uint256) {
252         uint8 decimals;
253         if (token == address(0)) {
254             decimals = 18;
255         } else {
256             decimals = ERC20Detailed(token).decimals();
257         }
258         if (decimals == StandardDecimals) {
259             return standardAmount;
260         } else if (decimals < StandardDecimals) {
261             return standardAmount / (10 ** uint(StandardDecimals - decimals));
262         } else {
263             return standardAmount * (10 ** uint(decimals - StandardDecimals));
264         }
265     }
266 
267     function _transferToContract(address fromAssetHash, uint256 amount) internal returns (bool) {
268         if (fromAssetHash == address(0)) {
269             // fromAssetHash === address(0) denotes user choose to lock ether
270             // passively check if the received msg.value equals amount
271             require(msg.value != 0, "transferred ether cannot be zero!");
272             require(msg.value == amount, "transferred ether is not equal to amount!");
273         } else {
274             // make sure lockproxy contract will decline any received ether
275             require(msg.value == 0, "there should be no ether transfer!");
276             // actively transfer amount of asset from msg.sender to lock_proxy contract
277             require(_transferERC20ToContract(fromAssetHash, _msgSender(), address(this), amount), "transfer erc20 asset to lock_proxy contract failed!");
278         }
279         return true;
280     }
281     function _transferFromContract(address toAssetHash, address toAddress, uint256 amount) internal returns (bool) {
282         if (toAssetHash == address(0x0000000000000000000000000000000000000000)) {
283             // toAssetHash === address(0) denotes contract needs to unlock ether to toAddress
284             // convert toAddress from 'address' type to 'address payable' type, then actively transfer ether
285             address(uint160(toAddress)).transfer(amount);
286         } else {
287             // actively transfer amount of asset from msg.sender to lock_proxy contract 
288             require(_transferERC20FromContract(toAssetHash, toAddress, amount), "transfer erc20 asset to lock_proxy contract failed!");
289         }
290         return true;
291     }
292     
293     function _transferERC20ToContract(address fromAssetHash, address fromAddress, address toAddress, uint256 amount) internal returns (bool) {
294          IERC20 erc20Token = IERC20(fromAssetHash);
295         //  require(erc20Token.transferFrom(fromAddress, toAddress, amount), "trasnfer ERC20 Token failed!");
296          erc20Token.safeTransferFrom(fromAddress, toAddress, amount);
297          return true;
298     }
299     function _transferERC20FromContract(address toAssetHash, address toAddress, uint256 amount) internal returns (bool) {
300          IERC20 erc20Token = IERC20(toAssetHash);
301         //  require(erc20Token.transfer(toAddress, amount), "transfer ERC20 Token failed!");
302          erc20Token.safeTransfer(toAddress, amount);
303          return true;
304     }
305     
306     function _serializeTxArgs(TxArgs memory args) internal pure returns (bytes memory) {
307         bytes memory buff;
308         buff = abi.encodePacked(
309             ZeroCopySink.WriteVarBytes(args.toAssetHash),
310             ZeroCopySink.WriteVarBytes(args.toAddress),
311             ZeroCopySink.WriteUint255(args.amount)
312             );
313         return buff;
314     }
315 
316     function _deserializeTxArgs(bytes memory valueBs) internal pure returns (TxArgs memory) {
317         TxArgs memory args;
318         uint256 off = 0;
319         (args.toAssetHash, off) = ZeroCopySource.NextVarBytes(valueBs, off);
320         (args.toAddress, off) = ZeroCopySource.NextVarBytes(valueBs, off);
321         (args.amount, off) = ZeroCopySource.NextUint255(valueBs, off);
322         return args;
323     }
324 }