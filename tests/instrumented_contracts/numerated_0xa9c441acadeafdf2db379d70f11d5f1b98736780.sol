1 pragma solidity ^0.5.16;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint256);
5     function balanceOf(address account) external view returns (uint256);
6     function transfer(address recipient, uint256 amount) external returns (bool);
7     function allowance(address owner, address spender) external view returns (uint256);
8     function approve(address spender, uint256 amount) external returns (bool);
9     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
10     event Transfer(address indexed from, address indexed to, uint256 value);
11     event Approval(address indexed owner, address indexed spender, uint256 value);
12 }
13 
14 library SafeMath {
15     function add(uint256 a, uint256 b) internal pure returns (uint256) {
16         uint256 c = a + b;
17         require(c >= a, "SafeMath: addition overflow");
18 
19         return c;
20     }
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         return sub(a, b, "SafeMath: subtraction overflow");
23     }
24     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
25         require(b <= a, errorMessage);
26         uint256 c = a - b;
27 
28         return c;
29     }
30     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31         if (a == 0) {
32             return 0;
33         }
34 
35         uint256 c = a * b;
36         require(c / a == b, "SafeMath: multiplication overflow");
37 
38         return c;
39     }
40     function div(uint256 a, uint256 b) internal pure returns (uint256) {
41         return div(a, b, "SafeMath: division by zero");
42     }
43     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
44         // Solidity only automatically asserts when dividing by 0
45         require(b > 0, errorMessage);
46         uint256 c = a / b;
47 
48         return c;
49     }
50     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
51         return mod(a, b, "SafeMath: modulo by zero");
52     }
53     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
54         require(b != 0, errorMessage);
55         return a % b;
56     }
57 }
58 
59 library Address {
60     function isContract(address account) internal view returns (bool) {
61         bytes32 codehash;
62         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
63         // solhint-disable-next-line no-inline-assembly
64         assembly { codehash := extcodehash(account) }
65         return (codehash != 0x0 && codehash != accountHash);
66     }
67     function toPayable(address account) internal pure returns (address payable) {
68         return address(uint160(account));
69     }
70     function sendValue(address payable recipient, uint256 amount) internal {
71         require(address(this).balance >= amount, "Address: insufficient balance");
72 
73         // solhint-disable-next-line avoid-call-value
74         (bool success, ) = recipient.call.value(amount)("");
75         require(success, "Address: unable to send value, recipient may have reverted");
76     }
77 }
78 
79 library SafeERC20 {
80     using SafeMath for uint256;
81     using Address for address;
82 
83     function safeTransfer(IERC20 token, address to, uint256 value) internal {
84         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
85     }
86 
87     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
88         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
89     }
90 
91     function safeApprove(IERC20 token, address spender, uint256 value) internal {
92         require((value == 0) || (token.allowance(address(this), spender) == 0),
93             "SafeERC20: approve from non-zero to non-zero allowance"
94         );
95         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
96     }
97 
98     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
99         uint256 newAllowance = token.allowance(address(this), spender).add(value);
100         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
101     }
102 
103     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
104         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
105         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
106     }
107     function callOptionalReturn(IERC20 token, bytes memory data) private {
108         require(address(token).isContract(), "SafeERC20: call to non-contract");
109 
110         // solhint-disable-next-line avoid-low-level-calls
111         (bool success, bytes memory returndata) = address(token).call(data);
112         require(success, "SafeERC20: low-level call failed");
113 
114         if (returndata.length > 0) { // Return data is optional
115             // solhint-disable-next-line max-line-length
116             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
117         }
118     }
119 }
120 
121 interface yVault {
122     function balanceOf(address) external view returns (uint);
123     function decimals() external view returns (uint8);
124     function name() external view returns (string memory);
125     function symbol() external view returns (string memory);
126     function token() external view returns (address);
127     function totalSupply() external view returns (uint);
128     function withdraw(uint) external;
129     function withdrawAll() external;
130     function getPricePerFullShare() external view returns (uint);
131     function deposit(uint) external;
132     function depositAll() external;
133 }
134 
135 contract yVaultCheck {
136     using SafeERC20 for IERC20;
137     using Address for address;
138     using SafeMath for uint256;
139     
140     yVault public constant vault = yVault(0xACd43E627e64355f1861cEC6d3a6688B31a6F952);
141     
142     constructor () public {}
143     
144     function withdrawAll() external {
145         withdraw(vault.balanceOf(msg.sender));
146     }
147     
148     // No rebalance implementation for lower fees and faster swaps
149     function withdraw(uint _shares) public {
150         IERC20(address(vault)).safeTransferFrom(msg.sender, address(this), _shares);
151         IERC20 _underlying = IERC20(vault.token());
152         
153         uint _expected = vault.balanceOf(address(this));
154         _expected = _expected.mul(vault.getPricePerFullShare()).div(1e18);
155         _expected = _expected.mul(99).div(100);
156         
157         uint _before = _underlying.balanceOf(address(this));
158         vault.withdrawAll();
159         uint _after = _underlying.balanceOf(address(this));
160         require(_after.sub(_before) >= _expected, "slippage");
161         _underlying.safeTransfer(msg.sender, _underlying.balanceOf(address(this)));
162     }
163 }