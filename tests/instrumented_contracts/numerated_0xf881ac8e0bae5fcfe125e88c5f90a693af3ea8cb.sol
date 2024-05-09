1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.3;
4 
5 library SafeMath {
6     function add(uint256 a, uint256 b) internal pure returns (uint256) {
7         uint256 c = a + b;
8         require(c >= a, "SafeMath: addition overflow");
9 
10         return c;
11     }
12 
13     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
14         return sub(a, b, "SafeMath: subtraction overflow");
15     }
16 
17     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
18         require(b <= a, errorMessage);
19         uint256 c = a - b;
20 
21         return c;
22     }
23 
24     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25         if (a == 0) {
26             return 0;
27         }
28 
29         uint256 c = a * b;
30         require(c / a == b, "SafeMath: multiplication overflow");
31 
32         return c;
33     }
34 
35     function div(uint256 a, uint256 b) internal pure returns (uint256) {
36         return div(a, b, "SafeMath: division by zero");
37     }
38 
39     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
40         require(b > 0, errorMessage);
41         uint256 c = a / b;
42 
43         return c;
44     }
45 
46     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
47         return mod(a, b, "SafeMath: modulo by zero");
48     }
49 
50     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
51         require(b != 0, errorMessage);
52         return a % b;
53     }
54 }
55 
56 
57 contract Ownable {
58     address public _owner;
59 
60     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62     constructor () {
63         _owner = msg.sender;
64         emit OwnershipTransferred(address(0), msg.sender);
65     }
66 
67     function owner() public view returns (address) {
68         return _owner;
69     }
70 
71     modifier onlyOwner() {
72         require(_owner == msg.sender, "Ownable: caller is not the owner");
73         _;
74     }
75 
76     function renounceOwnership() public virtual onlyOwner {
77         emit OwnershipTransferred(_owner, address(0));
78         _owner = address(0);
79     }
80 
81     function transferOwnership(address newOwner) public virtual onlyOwner {
82         require(newOwner != address(0), "Ownable: new owner is the zero address");
83         emit OwnershipTransferred(_owner, newOwner);
84         _owner = newOwner;
85     }
86 }
87 
88 interface IERC20 {
89     function totalSupply() external view returns (uint256);
90     function balanceOf(address tokenOwner) external view returns (uint256 balance);
91     function allowance(address tokenOwner, address spender) external view returns (uint256 remaining);
92     function transfer(address to, uint256 tokens) external returns (bool success);
93     function approve(address spender, uint256 tokens) external returns (bool success);
94     function transferFrom(address from, address to, uint256 tokens) external returns (bool success);
95 }
96 
97 contract ClearingHouse is Ownable {
98     using SafeMath for uint256;
99 
100     mapping(address => bool) supportedTokens;
101     mapping(address => uint256) nonces;
102 
103     // Double mapping as token address -> owner -> balance
104     event TokensWrapped(address token, string receiver, uint256 amount);
105 
106     function deposit(address token, uint256 amount, string memory receiver) public {
107         require(supportedTokens[token] == true, 'Unsupported token!');
108 
109         IERC20 tokenERC = IERC20(token);
110         tokenERC.transferFrom(msg.sender, address(this), amount);
111 
112         emit TokensWrapped(token, receiver, amount);
113     }
114 
115     function hashEthMsg(bytes32 _messageHash) public pure returns (bytes32) {
116         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash));
117     }
118 
119 
120     function hash(bytes memory x) public pure returns (bytes32) {
121         return keccak256(x);
122     }
123     
124     function encode(address token, uint256 amount, uint256 nonce, address sender) public pure returns (bytes memory) {
125                 return abi.encode(
126                     token,
127                     amount,
128                     nonce,
129                     sender
130                 );
131     }
132     
133     function withdraw(address token, uint256 amount, uint256 nonce, uint8 v, bytes32 r, bytes32 s) public {
134             bytes memory encoded = encode(token, amount, nonce, msg.sender);
135             bytes32 hashed = hash(encoded);
136             hashed = hashEthMsg(hashed);
137             address recoveredAddress = ecrecover(hashed, v, r, s);
138             require(recoveredAddress != address(0) && recoveredAddress == owner(), 'Invalid Signature!');
139             require(nonces[msg.sender] < nonce, 'Invalid Nonce!');
140             nonces[msg.sender] = nonce;
141             IERC20 tokenERC = IERC20(token);
142             tokenERC.transfer(msg.sender, amount);
143     }
144 
145     // Admin functions for adding and removing tokens from the wrapped token system
146     function addToken(address token) public onlyOwner {
147         supportedTokens[token] = true;
148     }
149 
150     function removeToken(address token) public onlyOwner {
151         supportedTokens[token] = false;
152     }
153 }