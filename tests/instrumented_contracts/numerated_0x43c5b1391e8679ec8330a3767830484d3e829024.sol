1 pragma solidity ^0.5.16;
2 
3 
4 // Math operations with safety checks that throw on error
5 library SafeMath {
6     function add(uint256 a, uint256 b) internal pure returns (uint256) {
7         uint256 c = a + b;
8         require(c >= a, "Math error");
9         return c;
10     }
11 
12     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13         require(a >= b, "Math error");
14         return a - b;
15     }
16 }
17 
18 
19 // Abstract contract for the full ERC 20 Token standard
20 interface ERC20 {
21     function balanceOf(address _address) external view returns (uint256 balance);
22     function transfer(address _to, uint256 _value) external returns (bool success);
23     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
24     function approve(address _spender, uint256 _value) external returns (bool success);
25     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
26 
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 
32 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
33 library TransferHelper {
34     function safeApprove(address token, address to, uint value) internal {
35         // bytes4(keccak256(bytes('approve(address,uint256)')));
36         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
37         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
38     }
39 
40     function safeTransfer(address token, address to, uint value) internal {
41         // bytes4(keccak256(bytes('transfer(address,uint256)')));
42         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
43         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
44     }
45 
46     function safeTransferFrom(address token, address from, address to, uint value) internal {
47         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
48         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
49         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
50     }
51 
52     function safeTransferETH(address to, uint value) internal {
53         // (bool success,) = to.call{value:value}(new bytes(0));
54         (bool success,) = to.call.value(value)(new bytes(0));
55         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
56     }
57 }
58 
59 
60 // Manage contract
61 contract BhxManage {
62     // 管理员
63     address public owner;
64     // 管理员2; 用于双重签名验证
65     address public owner2;
66     // 签名的messageHash
67     mapping (bytes32 => bool) public signHash;
68     // bhx合约地址
69     address public bhx;
70     // usdt合约地址
71     address public usdt;
72     // 接受10%手续费的地址
73     address public feeAddress;
74 
75     // 参数1: 二次签名的地址
76     // 参数2: bhx代币合约地址
77     // 参数3: usdt代币合约地址
78     // 参数4: 接受手续费的地址
79     constructor(address _owner2, address _bhx, address _usdt, address _feeAddress) public {
80         owner = msg.sender;
81         owner2 = _owner2;
82         bhx = _bhx;
83         usdt = _usdt;
84         feeAddress = _feeAddress;
85     }
86 
87     // 领取BHX触发事件
88     event BhxRed(address indexed owner, uint256 value);
89     // 领取USDT触发事件
90     event UsdtRed(address indexed owner, uint256 value);
91 
92     // 管理员修饰符
93     modifier onlyOwner() {
94         require(owner == msg.sender, "BHXManage: You are not owner");
95         _;
96     }
97 
98     // 设置新的管理员
99     function setOwner(address _owner) external onlyOwner {
100         require(_owner != address(0), "BHXManage: Zero address error");
101         owner = _owner;
102     }
103 
104     // 设置新的管理员2
105     function setOwner2(address _owner2) external onlyOwner {
106         require(_owner2 != address(0), "BHXManage: Zero address error");
107         owner2 = _owner2;
108     }
109 
110     // 设置新的收币地址
111     function setFeeAddress(address _feeAddress) external onlyOwner {
112         require(_feeAddress != address(0), "BHXManage: Zero address error");
113         feeAddress = _feeAddress;
114     }
115 
116     // 管理员取出合约里的erc20代币
117     function takeErc20(address _erc20Address) external onlyOwner {
118         require(_erc20Address != address(0), "BHXManage: Zero address error");
119         // 创建usdt的合约对象
120         ERC20 erc20 = ERC20(_erc20Address);
121         // 获取合约地址的余额
122         uint256 _value = erc20.balanceOf(address(this));
123         // 从合约地址转出usdt到to地址
124         TransferHelper.safeTransfer(_erc20Address, msg.sender, _value);
125     }
126 
127     // 管理员取出合约里的ETH
128     function takeETH() external onlyOwner {
129         uint256 _value = address(this).balance;
130         TransferHelper.safeTransferETH(msg.sender, _value);
131     }
132 
133     // 后台交易bhx; 使用二次签名进行验证, 从合约地址扣除bhx
134     // 参数1: 交易的数量
135     // 参数2: 用户需要支付gas费用的10%给到feeAddress;
136     // 参数3: 唯一的值(使用随机的唯一数就可以)
137     // 参数4: owner签名的signature值
138     function backendTransferBhx(uint256 _value, uint256 _feeValue, uint256 _nonce, bytes memory _signature) public payable {
139         address _to = msg.sender;
140         require(_to != address(0), "BHXManage: Zero address error");
141         // 创建bhx合约对象
142         ERC20 bhxErc20 = ERC20(bhx);
143         // 获取合约地址的bhx余额
144         uint256 bhxBalance = bhxErc20.balanceOf(address(this));
145         require(bhxBalance >= _value && _value > 0, "BHXManage: Insufficient balance or zero amount");
146         // 验证得到的地址是不是owner2, 并且数据没有被修改;
147         // 所使用的数据有: 接受币地址, 交易的数量, 10%的手续费, nonce值
148         bytes32 hash = keccak256(abi.encodePacked(_to, _value, _feeValue, _nonce));
149         bytes32 messageHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
150         address signer = recoverSigner(messageHash, _signature);
151         require(signer == owner2, "BHXManage: Signer is not owner2");
152         // 签名的messageHash必须是没有使用过的
153         require(signHash[messageHash] == false, "BHXManage: MessageHash is used");
154         // 该messageHash设置为已使用
155         signHash[messageHash] = true;
156         // 用户给的ETH必须等于签名时候使用的feeValue
157         require(msg.value == _feeValue, "BHXManage: Value unequal fee value");
158 
159         // 从合约地址转出bhx到to地址
160         TransferHelper.safeTransfer(bhx, _to, _value);
161         // 把ETH给到fee地址
162         TransferHelper.safeTransferETH(feeAddress, _feeValue);
163         emit BhxRed(_to, _value);
164     }
165 
166     // 抵押bhx借贷usdt; 使用二次签名进行验证, 从合约地址扣除usdt
167     // 参数1: 交易的数量
168     // 参数2: 用户需要支付gas费用的10%给到feeAddress;
169     // 参数3: 唯一的值(使用随机的唯一数就可以)
170     // 参数4: owner签名的signature值
171     function backendTransferUsdt(uint256 _value, uint256 _feeValue, uint256 _nonce, bytes memory _signature) public payable {
172         address _to = msg.sender;
173         require(_to != address(0), "BHXManage: Zero address error");
174         // 创建usdt的合约对象
175         ERC20 usdtErc20 = ERC20(usdt);
176         // 获取合约地址的usdt余额
177         uint256 usdtBalance = usdtErc20.balanceOf(address(this));
178         require(usdtBalance >= _value && _value > 0, "BHXManage: Insufficient balance or zero amount");
179         // 验证得到的地址是不是owner2, 并且数据没有被修改;
180         // 所使用的数据有: 接受币地址, 交易的数量, 10%的手续费, nonce值
181         bytes32 hash = keccak256(abi.encodePacked(_to, _value, _feeValue, _nonce));
182         bytes32 messageHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
183         address signer = recoverSigner(messageHash, _signature);
184         require(signer == owner2, "BHXManage: Signer is not owner2");
185         // 签名的messageHash必须是没有使用过的
186         require(signHash[messageHash] == false, "BHXManage: MessageHash is used");
187         // 该messageHash设置为已使用
188         signHash[messageHash] = true;
189         // 用户给的ETH必须等于签名时候使用的feeValue
190         require(msg.value == _feeValue, "BHXManage: Value unequal fee value");
191 
192         // 从合约地址转出usdt到to地址
193         TransferHelper.safeTransfer(usdt, _to, _value);
194         // 把ETH给到fee地址
195         TransferHelper.safeTransferETH(feeAddress, _feeValue);
196         emit UsdtRed(_to, _value);
197     }
198 
199     // 提取签名中的发起方地址
200     function recoverSigner(bytes32 message, bytes memory sig) internal pure returns (address) {
201         (uint8 v, bytes32 r, bytes32 s) = splitSignature(sig);
202         return ecrecover(message, v, r, s);
203     }
204 
205     // 分离签名信息的 v r s
206     function splitSignature(bytes memory sig) internal pure returns (uint8 v, bytes32 r, bytes32 s) {
207         require(sig.length == 65);
208         assembly {
209             r := mload(add(sig, 32))
210             s := mload(add(sig, 64))
211             v := byte(0, mload(add(sig, 96)))
212         }
213         return (v, r, s);
214     }
215 
216     function() payable external {}
217 
218 }