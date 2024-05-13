1 pragma solidity ^0.5.0;
2 
3 import "./../../libs/GSN/Context.sol";
4 import "./../../libs/common/ZeroCopySource.sol";
5 import "./../../libs/common/ZeroCopySink.sol";
6 import "./../../libs/utils/Utils.sol";
7 import "./../../libs/math/SafeMath.sol";
8 import "./../cross_chain_manager/interface/IEthCrossChainManager.sol";
9 import "./../cross_chain_manager/interface/IEthCrossChainManagerProxy.sol";
10 
11 interface ERC20Interface {
12     function transfer(address _to, uint256 _value) external returns (bool);
13     function transferFrom(address _from, address _to, uint _value) external returns (bool success);
14     function balanceOf(address account) external view returns (uint256);
15 }
16 
17 contract LockProxyPip1 is Context {
18     using SafeMath for uint;
19 
20     struct RegisterAssetTxArgs {
21         bytes assetHash;
22         bytes nativeAssetHash;
23     }
24 
25     struct TxArgs {
26         bytes fromAssetHash;
27         bytes toAssetHash;
28         bytes toAddress;
29         uint256 amount;
30         uint256 feeAmount;
31         bytes feeAddress;
32     }
33 
34     address public managerProxyContract;
35     mapping(bytes32 => bool) public registry;
36     mapping(bytes32 => uint256) public balances;
37 
38     event SetManagerProxyEvent(address manager);
39     event DelegateAssetEvent(address assetHash, uint64 nativeChainId, bytes nativeLockProxy, bytes nativeAssetHash);
40     event UnlockEvent(address toAssetHash, address toAddress, uint256 amount);
41     event LockEvent(address fromAssetHash, address fromAddress, uint64 toChainId, bytes toAssetHash, bytes toAddress, bytes txArgs);
42 
43     constructor(address ethCCMProxyAddr) public {
44         managerProxyContract = ethCCMProxyAddr;
45         emit SetManagerProxyEvent(managerProxyContract);
46     }
47 
48     modifier onlyManagerContract() {
49         IEthCrossChainManagerProxy ieccmp = IEthCrossChainManagerProxy(managerProxyContract);
50         require(_msgSender() == ieccmp.getEthCrossChainManager(), "msgSender is not EthCrossChainManagerContract");
51         _;
52     }
53 
54     function delegateAsset(uint64 nativeChainId, bytes memory nativeLockProxy, bytes memory nativeAssetHash, uint256 delegatedSupply) public {
55         require(nativeChainId != 0, "nativeChainId cannot be zero");
56         require(nativeLockProxy.length != 0, "empty nativeLockProxy");
57         require(nativeAssetHash.length != 0, "empty nativeAssetHash");
58 
59         address assetHash = _msgSender();
60         bytes32 key = _getRegistryKey(assetHash, nativeChainId, nativeLockProxy, nativeAssetHash);
61 
62         require(registry[key] != true, "asset already registered");
63         require(balances[key] == 0, "balance is not zero");
64         require(_balanceFor(assetHash) == delegatedSupply, "controlled balance does not match delegatedSupply");
65 
66         registry[key] = true;
67 
68         RegisterAssetTxArgs memory txArgs = RegisterAssetTxArgs({
69             assetHash: Utils.addressToBytes(assetHash),
70             nativeAssetHash: nativeAssetHash
71         });
72 
73         bytes memory txData = _serializeRegisterAssetTxArgs(txArgs);
74 
75         IEthCrossChainManager eccm = _getEccm();
76         require(eccm.crossChain(nativeChainId, nativeLockProxy, "registerAsset", txData), "EthCrossChainManager crossChain executed error!");
77         balances[key] = delegatedSupply;
78 
79         emit DelegateAssetEvent(assetHash, nativeChainId, nativeLockProxy, nativeAssetHash);
80     }
81 
82     function registerAsset(bytes memory argsBs, bytes memory fromContractAddr, uint64 fromChainId) onlyManagerContract public returns (bool) {
83         RegisterAssetTxArgs memory args = _deserializeRegisterAssetTxArgs(argsBs);
84 
85         bytes32 key = _getRegistryKey(Utils.bytesToAddress(args.nativeAssetHash), fromChainId, fromContractAddr, args.assetHash);
86 
87         require(registry[key] != true, "asset already registerd");
88         registry[key] = true;
89 
90         return true;
91     }
92 
93     /* @notice                  This function is meant to be invoked by the user,
94     *                           a certain amount teokens will be locked in the proxy contract the invoker/msg.sender immediately.
95     *                           Then the same amount of tokens will be unloked from target chain proxy contract at the target chain with chainId later.
96     *  @param fromAssetHash     The asset hash in current chain
97     *  @param toChainId         The target chain id
98     *
99     *  @param toAddress         The address in bytes format to receive same amount of tokens in target chain
100     *  @param amount            The amount of tokens to be crossed from ethereum to the chain with chainId
101     */
102     function lock(
103         address fromAssetHash,
104         uint64 toChainId,
105         bytes memory targetProxyHash,
106         bytes memory toAssetHash,
107         bytes memory toAddress,
108         uint256 amount,
109         bool deductFeeInLock,
110         uint256 feeAmount,
111         bytes memory feeAddress
112     )
113         public
114         payable
115         returns (bool)
116     {
117         require(toChainId != 0, "toChainId cannot be zero");
118         require(targetProxyHash.length != 0, "empty targetProxyHash");
119         require(toAssetHash.length != 0, "empty toAssetHash");
120         require(toAddress.length != 0, "empty toAddress");
121         require(amount != 0, "amount must be more than zero!");
122 
123         require(_transferToContract(fromAssetHash, amount), "transfer asset from fromAddress to lock_proxy contract  failed!");
124 
125         bytes32 key = _getRegistryKey(fromAssetHash, toChainId, targetProxyHash, toAssetHash);
126         require(registry[key] == true, "asset not registered");
127 
128         TxArgs memory txArgs = TxArgs({
129             fromAssetHash: Utils.addressToBytes(fromAssetHash),
130             toAssetHash: toAssetHash,
131             toAddress: toAddress,
132             amount: amount,
133             feeAmount: feeAmount,
134             feeAddress: feeAddress
135         });
136 
137         if (feeAmount != 0 && deductFeeInLock) {
138             require(feeAddress.length != 0, "empty fee address");
139             uint256 afterFeeAmount = amount.sub(feeAmount);
140             require(_transferFromContract(fromAssetHash, Utils.bytesToAddress(feeAddress), feeAmount), "transfer asset from lock_proxy contract to feeAddress failed!");
141 
142             // set feeAmount to zero as fee has already been transferred
143             txArgs.feeAmount = 0;
144             txArgs.amount = afterFeeAmount;
145         }
146 
147         bytes memory txData = _serializeTxArgs(txArgs);
148         IEthCrossChainManager eccm = _getEccm();
149 
150         require(eccm.crossChain(toChainId, targetProxyHash, "unlock", txData), "EthCrossChainManager crossChain executed error!");
151         balances[key] = balances[key].add(txArgs.amount);
152 
153         emit LockEvent(fromAssetHash, _msgSender(), toChainId, toAssetHash, toAddress, txData);
154 
155         return true;
156     }
157 
158     // /* @notice                  This function is meant to be invoked by the ETH crosschain management contract,
159     // *                           then mint a certin amount of tokens to the designated address since a certain amount
160     // *                           was burnt from the source chain invoker.
161     // *  @param argsBs            The argument bytes recevied by the ethereum lock proxy contract, need to be deserialized.
162     // *                           based on the way of serialization in the source chain proxy contract.
163     // *  @param fromContractAddr  The source chain contract address
164     // *  @param fromChainId       The source chain id
165     // */
166     function unlock(bytes memory argsBs, bytes memory fromContractAddr, uint64 fromChainId) onlyManagerContract public returns (bool) {
167         TxArgs memory args = _deserializeTxArgs(argsBs);
168         address toAssetHash = Utils.bytesToAddress(args.toAssetHash);
169         address toAddress = Utils.bytesToAddress(args.toAddress);
170 
171         bytes32 key = _getRegistryKey(toAssetHash, fromChainId, fromContractAddr, args.fromAssetHash);
172 
173         require(registry[key] == true, "asset not registered");
174         require(balances[key] >= args.amount, "insufficient balance in registry");
175 
176         balances[key] = balances[key].sub(args.amount);
177 
178         uint256 afterFeeAmount = args.amount;
179         if (args.feeAmount != 0) {
180             afterFeeAmount = args.amount.sub(args.feeAmount);
181             address feeAddress = Utils.bytesToAddress(args.feeAddress);
182 
183             // transfer feeAmount to feeAddress
184             require(_transferFromContract(toAssetHash, feeAddress, args.feeAmount), "transfer asset from lock_proxy contract to feeAddress failed!");
185             emit UnlockEvent(toAssetHash, feeAddress, args.feeAmount);
186         }
187 
188         require(_transferFromContract(toAssetHash, toAddress, afterFeeAmount), "transfer asset from lock_proxy contract to toAddress failed!");
189 
190         emit UnlockEvent(toAssetHash, toAddress, args.amount);
191         return true;
192     }
193 
194     function _balanceFor(address fromAssetHash) public view returns (uint256) {
195         if (fromAssetHash == address(0)) {
196             // return address(this).balance; // this expression would result in error: Failed to decode output: Error: insufficient data for uint256 type
197             address selfAddr = address(this);
198             return selfAddr.balance;
199         } else {
200             ERC20Interface erc20Token = ERC20Interface(fromAssetHash);
201             return erc20Token.balanceOf(address(this));
202         }
203     }
204     function _getEccm() internal view returns (IEthCrossChainManager) {
205       IEthCrossChainManagerProxy eccmp = IEthCrossChainManagerProxy(managerProxyContract);
206       address eccmAddr = eccmp.getEthCrossChainManager();
207       IEthCrossChainManager eccm = IEthCrossChainManager(eccmAddr);
208       return eccm;
209     }
210     function _getRegistryKey(address assetHash, uint64 nativeChainId, bytes memory nativeLockProxy, bytes memory nativeAssetHash) internal pure returns (bytes32) {
211         return keccak256(abi.encodePacked(
212             assetHash,
213             nativeChainId,
214             nativeLockProxy,
215             nativeAssetHash
216         ));
217     }
218     function _transferToContract(address fromAssetHash, uint256 amount) internal returns (bool) {
219         if (fromAssetHash == address(0)) {
220             // fromAssetHash === address(0) denotes user choose to lock ether
221             // passively check if the received msg.value equals amount
222             require(msg.value == amount, "transferred ether is not equal to amount!");
223         } else {
224             // actively transfer amount of asset from msg.sender to lock_proxy contract
225             require(_transferERC20ToContract(fromAssetHash, _msgSender(), address(this), amount), "transfer erc20 asset to lock_proxy contract failed!");
226         }
227         return true;
228     }
229     function _transferFromContract(address toAssetHash, address toAddress, uint256 amount) internal returns (bool) {
230         if (toAssetHash == address(0x0000000000000000000000000000000000000000)) {
231             // toAssetHash === address(0) denotes contract needs to unlock ether to toAddress
232             // convert toAddress from 'address' type to 'address payable' type, then actively transfer ether
233             address(uint160(toAddress)).transfer(amount);
234         } else {
235             // actively transfer amount of asset from msg.sender to lock_proxy contract
236             require(_transferERC20FromContract(toAssetHash, toAddress, amount), "transfer erc20 asset to lock_proxy contract failed!");
237         }
238         return true;
239     }
240 
241 
242     function _transferERC20ToContract(address fromAssetHash, address fromAddress, address toAddress, uint256 amount) internal returns (bool) {
243          ERC20Interface erc20Token = ERC20Interface(fromAssetHash);
244          require(erc20Token.transferFrom(fromAddress, toAddress, amount), "trasnfer ERC20 Token failed!");
245          return true;
246     }
247     function _transferERC20FromContract(address toAssetHash, address toAddress, uint256 amount) internal returns (bool) {
248          ERC20Interface erc20Token = ERC20Interface(toAssetHash);
249          require(erc20Token.transfer(toAddress, amount), "trasnfer ERC20 Token failed!");
250          return true;
251     }
252 
253     function _serializeTxArgs(TxArgs memory args) internal pure returns (bytes memory) {
254         bytes memory buff;
255         buff = abi.encodePacked(
256             ZeroCopySink.WriteVarBytes(args.fromAssetHash),
257             ZeroCopySink.WriteVarBytes(args.toAssetHash),
258             ZeroCopySink.WriteVarBytes(args.toAddress),
259             ZeroCopySink.WriteUint255(args.amount),
260             ZeroCopySink.WriteUint255(args.feeAmount),
261             ZeroCopySink.WriteVarBytes(args.feeAddress)
262         );
263         return buff;
264     }
265 
266     function _serializeRegisterAssetTxArgs(RegisterAssetTxArgs memory args) internal pure returns (bytes memory) {
267         bytes memory buff;
268         buff = abi.encodePacked(
269             ZeroCopySink.WriteVarBytes(args.assetHash),
270             ZeroCopySink.WriteVarBytes(args.nativeAssetHash)
271         );
272         return buff;
273     }
274 
275     function _deserializeRegisterAssetTxArgs(bytes memory valueBs) internal pure returns (RegisterAssetTxArgs memory) {
276         RegisterAssetTxArgs memory args;
277         uint256 off = 0;
278         (args.assetHash, off) = ZeroCopySource.NextVarBytes(valueBs, off);
279         (args.nativeAssetHash, off) = ZeroCopySource.NextVarBytes(valueBs, off);
280         return args;
281     }
282 
283     function _deserializeTxArgs(bytes memory valueBs) internal pure returns (TxArgs memory) {
284         TxArgs memory args;
285         uint256 off = 0;
286         (args.fromAssetHash, off) = ZeroCopySource.NextVarBytes(valueBs, off);
287         (args.toAssetHash, off) = ZeroCopySource.NextVarBytes(valueBs, off);
288         (args.toAddress, off) = ZeroCopySource.NextVarBytes(valueBs, off);
289         (args.amount, off) = ZeroCopySource.NextUint255(valueBs, off);
290         (args.feeAmount, off) = ZeroCopySource.NextUint255(valueBs, off);
291         (args.feeAddress, off) = ZeroCopySource.NextVarBytes(valueBs, off);
292         return args;
293     }
294 }