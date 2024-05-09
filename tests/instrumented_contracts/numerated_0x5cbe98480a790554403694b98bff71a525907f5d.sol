1 pragma solidity >=0.5.0;
2 
3 library Helper {
4     function safeTransfer(address token, address to, uint256 value) internal {
5         // bytes4(keccak256(bytes('transfer(address,uint256)')));
6         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
7         require(success && (data.length == 0 || abi.decode(data, (bool))), 'Helper::safeTransfer: failed');
8     }
9 
10     function safeTransferFrom(address token, address from, address to, uint256 value) internal {
11         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
12         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
13         require(success && (data.length == 0 || abi.decode(data, (bool))), 'Helper::safeTransferFrom: failed');
14     }
15 }
16 
17 contract ProxySwapAsset {
18     event LogChangeMPCOwner(address indexed oldOwner, address indexed newOwner, uint indexed effectiveTime);
19     event LogChangeLpProvider(address indexed oldProvider, address indexed newProvider);
20     event LogSwapin(bytes32 indexed txhash, address indexed account, uint amount);
21     event LogSwapout(address indexed account, address indexed bindaddr, uint amount);
22 
23     address private _oldOwner;
24     address private _newOwner;
25     uint256 private _newOwnerEffectiveTime;
26     uint256 constant public effectiveInterval = 2 * 24 * 3600;
27 
28     address public proxyToken;
29     address public lpProvider;
30 
31     modifier onlyOwner() {
32         require(msg.sender == owner(), "only owner");
33         _;
34     }
35 
36     modifier onlyProvider() {
37         require(msg.sender == lpProvider, "only lp provider");
38         _;
39     }
40 
41     constructor(address _proxyToken, address _lpProvider) public {
42         proxyToken = _proxyToken;
43         lpProvider = _lpProvider;
44         _newOwner = msg.sender;
45         _newOwnerEffectiveTime = block.timestamp;
46     }
47 
48     function owner() public view returns (address) {
49         return block.timestamp >= _newOwnerEffectiveTime ? _newOwner : _oldOwner;
50     }
51 
52     function changeMPCOwner(address newOwner) public onlyOwner returns (bool) {
53         require(newOwner != address(0), "new owner is the zero address");
54         _oldOwner = owner();
55         _newOwner = newOwner;
56         _newOwnerEffectiveTime = block.timestamp + effectiveInterval;
57         emit LogChangeMPCOwner(_oldOwner, _newOwner, _newOwnerEffectiveTime);
58         return true;
59     }
60 
61     function changeLpProvider(address newProvider) public onlyProvider returns (bool) {
62         require(newProvider != address(0), "new provider is the zero address");
63         emit LogChangeLpProvider(lpProvider, newProvider);
64         lpProvider = newProvider;
65     }
66 
67     function withdraw(address to, uint256 amount) public onlyProvider {
68         Helper.safeTransfer(proxyToken, to, amount);
69     }
70 
71     function Swapin(bytes32 txhash, address account, uint256 amount) public onlyOwner returns (bool) {
72         Helper.safeTransfer(proxyToken, account, amount);
73         emit LogSwapin(txhash, account, amount);
74         return true;
75     }
76 
77     // keep same interface with 'amount' parameter though it's unnecessary here
78     function Swapout(uint256 amount, address bindaddr) public returns (bool) {
79         require(bindaddr != address(0), "bind address is the zero address");
80         Helper.safeTransferFrom(proxyToken, msg.sender, address(this), amount);
81         emit LogSwapout(msg.sender, bindaddr, amount);
82         return true;
83     }
84 }