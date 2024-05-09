1 pragma solidity =0.8.0;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint256);
5     function balanceOf(address account) external view returns (uint256);
6     function transfer(address to, uint256 amount) external returns (bool);
7     function allowance(address owner, address spender) external view returns (uint256);
8     function approve(address spender, uint256 amount) external returns (bool);
9     function transferFrom(address sender, address to, uint256 amount) external returns (bool);
10 
11     event Transfer(address indexed from, address indexed to, uint256 value);
12     event Approval(address indexed owner, address indexed spender, uint256 value);
13 }
14 
15 contract Ownable {
16     address public owner;
17     address public newOwner;
18 
19     event OwnershipTransferred(address indexed from, address indexed to);
20 
21     constructor() {
22         owner = msg.sender;
23         emit OwnershipTransferred(address(0), owner);
24     }
25 
26     modifier onlyOwner {
27         require(msg.sender == owner, "Ownable: Caller is not the owner");
28         _;
29     }
30 
31     function transferOwnership(address transferOwner) external onlyOwner {
32         require(transferOwner != newOwner);
33         newOwner = transferOwner;
34     }
35 
36     function acceptOwnership() virtual public {
37         require(msg.sender == newOwner);
38         emit OwnershipTransferred(owner, newOwner);
39         owner = newOwner;
40         newOwner = address(0);
41     }
42 }
43 
44 library TransferHelper {
45     function safeApprove(address token, address to, uint value) internal {
46         // bytes4(keccak256(bytes('approve(address,uint256)')));
47         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
48         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
49     }
50 
51     function safeTransfer(address token, address to, uint value) internal {
52         // bytes4(keccak256(bytes('transfer(address,uint256)')));
53         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
54         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
55     }
56 
57     function safeTransferFrom(address token, address from, address to, uint value) internal {
58         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
59         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
60         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
61     }
62 
63     function safeTransferETH(address to, uint value) internal {
64         (bool success,) = to.call{value:value}(new bytes(0));
65         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
66     }
67 }
68 
69 contract ERC20ToBEP20Wrapper is Ownable {
70     struct UnwrapInfo {
71         uint amount;
72         uint fee;
73         uint bscNonce;
74     }
75 
76     IERC20 public immutable NBU;
77     uint public minWrapAmount;
78 
79     mapping(address => uint) public userWrapNonces;
80     mapping(address => uint) public userUnwrapNonces;
81     mapping(address => mapping(uint => uint)) public bscToEthUserUnwrapNonces;
82     mapping(address => mapping(uint => uint)) public wraps;
83     mapping(address => mapping(uint => UnwrapInfo)) public unwraps;
84 
85     event Wrap(address indexed user, uint indexed wrapNonce, uint amount);
86     event Unwrap(address indexed user, uint indexed unwrapNonce, uint indexed bscNonce, uint amount, uint fee);
87     event UpdateMinWrapAmount(uint indexed amount);
88     event Rescue(address indexed to, uint amount);
89     event RescueToken(address token, address indexed to, uint amount);
90 
91     constructor(address nbu) {
92         NBU = IERC20(nbu);
93     }
94     
95     function wrap(uint amount) external {
96         require(amount >= minWrapAmount, "ERC20ToBEP20Wrapper: Value too small");
97         
98         NBU.transferFrom(msg.sender, address(this), amount);
99         uint userWrapNonce = ++userWrapNonces[msg.sender];
100         wraps[msg.sender][userWrapNonce] = amount;
101         emit Wrap(msg.sender, userWrapNonce, amount);
102     }
103 
104     function unwrap(address user, uint amount, uint fee, uint bscNonce) external onlyOwner {
105         require(user != address(0), "ERC20ToBEP20Wrapper: Can't be zero address");
106         require(bscToEthUserUnwrapNonces[user][bscNonce] == 0, "ERC20ToBEP20Wrapper: Already processed");
107         
108         NBU.transfer(user, amount - fee);
109         uint unwrapNonce = ++userUnwrapNonces[user];
110         bscToEthUserUnwrapNonces[user][bscNonce] = unwrapNonce;
111         unwraps[user][unwrapNonce].amount = amount;
112         unwraps[user][unwrapNonce].fee = fee;
113         unwraps[user][unwrapNonce].bscNonce = bscNonce;
114         emit Unwrap(user, unwrapNonce, bscNonce, amount, fee);
115     }
116 
117     //Admin functions
118     function rescue(address payable to, uint256 amount) external onlyOwner {
119         require(to != address(0), "ERC20ToBEP20Wrapper: Can't be zero address");
120         require(amount > 0, "ERC20ToBEP20Wrapper: Should be greater than 0");
121         TransferHelper.safeTransferETH(to, amount);
122         emit Rescue(to, amount);
123     }
124 
125     function rescue(address to, address token, uint256 amount) external onlyOwner {
126         require(to != address(0), "ERC20ToBEP20Wrapper: Can't be zero address");
127         require(amount > 0, "ERC20ToBEP20Wrapper: Should be greater than 0");
128         TransferHelper.safeTransfer(token, to, amount);
129         emit RescueToken(token, to, amount);
130     }
131 
132     function updateMinWrapAmount(uint amount) external onlyOwner {
133         require(amount > 0, "ERC20ToBEP20Wrapper: Should be greater than 0");
134         minWrapAmount = amount;
135         emit UpdateMinWrapAmount(amount);
136     }
137 }