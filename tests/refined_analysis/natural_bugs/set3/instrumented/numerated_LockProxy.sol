1 pragma solidity ^0.5.0;
2 
3 import "./../../libs/ownership/Ownable.sol";
4 import "./../../libs/common/ZeroCopySource.sol";
5 import "./../../libs/common/ZeroCopySink.sol";
6 import "./../../libs/utils/Utils.sol";
7 import "./../../libs/token/ERC20/SafeERC20.sol";
8 import "./../cross_chain_manager/interface/IEthCrossChainManager.sol";
9 import "./../cross_chain_manager/interface/IEthCrossChainManagerProxy.sol";
10 
11 
12 contract LockProxy is Ownable {
13     using SafeMath for uint;
14     using SafeERC20 for IERC20;
15 
16     struct TxArgs {
17         bytes toAssetHash;
18         bytes toAddress;
19         uint256 amount;
20     }
21     address public managerProxyContract;
22     mapping(uint64 => bytes) public proxyHashMap;
23     mapping(address => mapping(uint64 => bytes)) public assetHashMap;
24     mapping(address => bool) safeTransfer;
25 
26     event SetManagerProxyEvent(address manager);
27     event BindProxyEvent(uint64 toChainId, bytes targetProxyHash);
28     event BindAssetEvent(address fromAssetHash, uint64 toChainId, bytes targetProxyHash, uint initialAmount);
29     event UnlockEvent(address toAssetHash, address toAddress, uint256 amount);
30     event LockEvent(address fromAssetHash, address fromAddress, uint64 toChainId, bytes toAssetHash, bytes toAddress, uint256 amount);
31     
32     modifier onlyManagerContract() {
33         IEthCrossChainManagerProxy ieccmp = IEthCrossChainManagerProxy(managerProxyContract);
34         require(_msgSender() == ieccmp.getEthCrossChainManager(), "msgSender is not EthCrossChainManagerContract");
35         _;
36     }
37     
38     function setManagerProxy(address ethCCMProxyAddr) onlyOwner public {
39         managerProxyContract = ethCCMProxyAddr;
40         emit SetManagerProxyEvent(managerProxyContract);
41     }
42     
43     function bindProxyHash(uint64 toChainId, bytes memory targetProxyHash) onlyOwner public returns (bool) {
44         proxyHashMap[toChainId] = targetProxyHash;
45         emit BindProxyEvent(toChainId, targetProxyHash);
46         return true;
47     }
48     
49     function bindAssetHash(address fromAssetHash, uint64 toChainId, bytes memory toAssetHash) onlyOwner public returns (bool) {
50         assetHashMap[fromAssetHash][toChainId] = toAssetHash;
51         emit BindAssetEvent(fromAssetHash, toChainId, toAssetHash, getBalanceFor(fromAssetHash));
52         return true;
53     }
54     
55     /* @notice                  This function is meant to be invoked by the user,
56     *                           a certin amount teokens will be locked in the proxy contract the invoker/msg.sender immediately.
57     *                           Then the same amount of tokens will be unloked from target chain proxy contract at the target chain with chainId later.
58     *  @param fromAssetHash     The asset address in current chain, uniformly named as `fromAssetHash`
59     *  @param toChainId         The target chain id
60     *                           
61     *  @param toAddress         The address in bytes format to receive same amount of tokens in target chain 
62     *  @param amount            The amount of tokens to be crossed from ethereum to the chain with chainId
63     */
64     function lock(address fromAssetHash, uint64 toChainId, bytes memory toAddress, uint256 amount) public payable returns (bool) {
65         require(amount != 0, "amount cannot be zero!");
66         
67         
68         require(_transferToContract(fromAssetHash, amount), "transfer asset from fromAddress to lock_proxy contract  failed!");
69         
70         bytes memory toAssetHash = assetHashMap[fromAssetHash][toChainId];
71         require(toAssetHash.length != 0, "empty illegal toAssetHash");
72 
73         TxArgs memory txArgs = TxArgs({
74             toAssetHash: toAssetHash,
75             toAddress: toAddress,
76             amount: amount
77         });
78         bytes memory txData = _serializeTxArgs(txArgs);
79         
80         IEthCrossChainManagerProxy eccmp = IEthCrossChainManagerProxy(managerProxyContract);
81         address eccmAddr = eccmp.getEthCrossChainManager();
82         IEthCrossChainManager eccm = IEthCrossChainManager(eccmAddr);
83         
84         bytes memory toProxyHash = proxyHashMap[toChainId];
85         require(toProxyHash.length != 0, "empty illegal toProxyHash");
86         require(eccm.crossChain(toChainId, toProxyHash, "unlock", txData), "EthCrossChainManager crossChain executed error!");
87 
88         emit LockEvent(fromAssetHash, _msgSender(), toChainId, toAssetHash, toAddress, amount);
89         
90         return true;
91 
92     }
93     
94     // /* @notice                  This function is meant to be invoked by the ETH crosschain management contract,
95     // *                           then mint a certin amount of tokens to the designated address since a certain amount 
96     // *                           was burnt from the source chain invoker.
97     // *  @param argsBs            The argument bytes recevied by the ethereum lock proxy contract, need to be deserialized.
98     // *                           based on the way of serialization in the source chain proxy contract.
99     // *  @param fromContractAddr  The source chain contract address
100     // *  @param fromChainId       The source chain id
101     // */
102     function unlock(bytes memory argsBs, bytes memory fromContractAddr, uint64 fromChainId) onlyManagerContract public returns (bool) {
103         TxArgs memory args = _deserializeTxArgs(argsBs);
104 
105         require(fromContractAddr.length != 0, "from proxy contract address cannot be empty");
106         require(Utils.equalStorage(proxyHashMap[fromChainId], fromContractAddr), "From Proxy contract address error!");
107         
108         require(args.toAssetHash.length != 0, "toAssetHash cannot be empty");
109         address toAssetHash = Utils.bytesToAddress(args.toAssetHash);
110 
111         require(args.toAddress.length != 0, "toAddress cannot be empty");
112         address toAddress = Utils.bytesToAddress(args.toAddress);
113         
114         
115         require(_transferFromContract(toAssetHash, toAddress, args.amount), "transfer asset from lock_proxy contract to toAddress failed!");
116         
117         emit UnlockEvent(toAssetHash, toAddress, args.amount);
118         return true;
119     }
120     
121     function getBalanceFor(address fromAssetHash) public view returns (uint256) {
122         if (fromAssetHash == address(0)) {
123             // return address(this).balance; // this expression would result in error: Failed to decode output: Error: insufficient data for uint256 type
124             address selfAddr = address(this);
125             return selfAddr.balance;
126         } else {
127             IERC20 erc20Token = IERC20(fromAssetHash);
128             return erc20Token.balanceOf(address(this));
129         }
130     }
131     function _transferToContract(address fromAssetHash, uint256 amount) internal returns (bool) {
132         if (fromAssetHash == address(0)) {
133             // fromAssetHash === address(0) denotes user choose to lock ether
134             // passively check if the received msg.value equals amount
135             require(msg.value != 0, "transferred ether cannot be zero!");
136             require(msg.value == amount, "transferred ether is not equal to amount!");
137         } else {
138             // make sure lockproxy contract will decline any received ether
139             require(msg.value == 0, "there should be no ether transfer!");
140             // actively transfer amount of asset from msg.sender to lock_proxy contract
141             require(_transferERC20ToContract(fromAssetHash, _msgSender(), address(this), amount), "transfer erc20 asset to lock_proxy contract failed!");
142         }
143         return true;
144     }
145     function _transferFromContract(address toAssetHash, address toAddress, uint256 amount) internal returns (bool) {
146         if (toAssetHash == address(0x0000000000000000000000000000000000000000)) {
147             // toAssetHash === address(0) denotes contract needs to unlock ether to toAddress
148             // convert toAddress from 'address' type to 'address payable' type, then actively transfer ether
149             address(uint160(toAddress)).transfer(amount);
150         } else {
151             // actively transfer amount of asset from lock_proxy contract to toAddress
152             require(_transferERC20FromContract(toAssetHash, toAddress, amount), "transfer erc20 asset from lock_proxy contract to toAddress failed!");
153         }
154         return true;
155     }
156     
157     
158     function _transferERC20ToContract(address fromAssetHash, address fromAddress, address toAddress, uint256 amount) internal returns (bool) {
159          IERC20 erc20Token = IERC20(fromAssetHash);
160         //  require(erc20Token.transferFrom(fromAddress, toAddress, amount), "trasnfer ERC20 Token failed!");
161          erc20Token.safeTransferFrom(fromAddress, toAddress, amount);
162          return true;
163     }
164     function _transferERC20FromContract(address toAssetHash, address toAddress, uint256 amount) internal returns (bool) {
165          IERC20 erc20Token = IERC20(toAssetHash);
166         //  require(erc20Token.transfer(toAddress, amount), "trasnfer ERC20 Token failed!");
167          erc20Token.safeTransfer(toAddress, amount);
168          return true;
169     }
170     
171     function _serializeTxArgs(TxArgs memory args) internal pure returns (bytes memory) {
172         bytes memory buff;
173         buff = abi.encodePacked(
174             ZeroCopySink.WriteVarBytes(args.toAssetHash),
175             ZeroCopySink.WriteVarBytes(args.toAddress),
176             ZeroCopySink.WriteUint255(args.amount)
177             );
178         return buff;
179     }
180 
181     function _deserializeTxArgs(bytes memory valueBs) internal pure returns (TxArgs memory) {
182         TxArgs memory args;
183         uint256 off = 0;
184         (args.toAssetHash, off) = ZeroCopySource.NextVarBytes(valueBs, off);
185         (args.toAddress, off) = ZeroCopySource.NextVarBytes(valueBs, off);
186         (args.amount, off) = ZeroCopySource.NextUint255(valueBs, off);
187         return args;
188     }
189 }