1 pragma solidity ^0.4.25;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that revert on error
5  */
6 library SafeMath {
7 /**
8   * @dev Multiplies two numbers, reverts on overflow.
9   */
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {if (a == 0) {return 0;}
11     uint256 c = a * b;require(c / a == b);return c;}
12 /**
13   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
14   */
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {require(b > 0); uint256 c = a / b;
16     // assert(a == b * c + a % b); 
17 return c;}
18 /**
19   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
20   */
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {require(b <= a);uint256 c = a - b;return c;}
22 /**
23   * @dev Adds two numbers, reverts on overflow.
24   */
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {uint256 c = a + b;require(c >= a);
26   return c;}
27 /**
28   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
29   * reverts when dividing by zero.
30   */
31     function mod(uint256 a, uint256 b) internal pure returns (uint256) {require(b != 0);return a % b;}}
32 contract Owned {
33     address public owner;
34     address public newOwner;
35     modifier onlyOwner {require(msg.sender == owner);_;}
36     function transferOwnership(address _newOwner) public onlyOwner {newOwner = _newOwner;}
37     function acceptOwnership() public {require(msg.sender == newOwner);owner = newOwner;}}
38 /**
39  * @title ERC20 interface
40  * @dev see https://github.com/ethereum/EIPs/issues/20
41  */
42 interface IERC20 {
43 function totalSupply() external view returns (uint256);
44 function balanceOf(address who) external view returns (uint256);
45 function allowance(address owner, address spender)
46 external view returns (uint256);
47 function transfer(address to, uint256 value) external returns (bool);
48 function approve(address spender, uint256 value)
49 external returns (bool);
50 function transferFrom(address from, address to, uint256 value)
51 external returns (bool);
52 event Transfer(address indexed from,address indexed to,uint256 value);
53 event Approval(address indexed owner,address indexed spender,uint256 value);}
54 contract Seeflast is IERC20, Owned {
55     using SafeMath for uint256;
56     constructor() public {
57         owner = 0x947e40854A000a43Dad75E63caDA3E318f13277d;
58         contractAddress = this;
59         _balances[0x74dF2809598C8AfCf655d305e5D10C8Ab824F0Eb] = 260000000 * 10 ** decimals;
60         emit Transfer(contractAddress, 0x74dF2809598C8AfCf655d305e5D10C8Ab824F0Eb, 260000000 * 10 ** decimals);
61         _balances[0x8ec5BD55f5CC10743E598194A769712043cCDD38] = 400000000 * 10 ** decimals;
62         emit Transfer(contractAddress, 0x8ec5BD55f5CC10743E598194A769712043cCDD38, 400000000 * 10 ** decimals);
63         _balances[0x9d357507556a9FeD2115aAb6CFc6527968B1F9c9] = 50000000 * 10 ** decimals;
64         emit Transfer(contractAddress, 0x9d357507556a9FeD2115aAb6CFc6527968B1F9c9, 50000000 * 10 ** decimals);
65         _balances[0x369760682f292584921f45F498cC525127Aa12a5] = 50000000 * 10 ** decimals;
66         emit Transfer(contractAddress, 0x369760682f292584921f45F498cC525127Aa12a5, 50000000 * 10 ** decimals);
67         _balances[0x98046c6bee217B9A0d13507a47423F891E8Ef22A] = 50000000 * 10 ** decimals;
68         emit Transfer(contractAddress, 0x98046c6bee217B9A0d13507a47423F891E8Ef22A, 50000000 * 10 ** decimals);
69         _balances[0xf0b8dBcaF8A89A49Fa2adf25b4CCC9234258A8E6] = 50000000 * 10 ** decimals;
70         emit Transfer(contractAddress, 0xf0b8dBcaF8A89A49Fa2adf25b4CCC9234258A8E6, 50000000 * 10 ** decimals);
71        _balances[0x8877e7974d6D708c403cB9C9A65873a3e57382E4] = 60000000 * 10 ** decimals;
72         emit Transfer(contractAddress, 0x8877e7974d6D708c403cB9C9A65873a3e57382E4, 60000000 * 10 ** decimals);
73        _balances[0x0452453D9e32B80F024bf9D6Bb35A76A785ba6a2] = 20000000 * 10 ** decimals;
74         emit Transfer(contractAddress, 0x0452453D9e32B80F024bf9D6Bb35A76A785ba6a2, 20000000 * 10 ** decimals);
75        _balances[0x1DBe051fDE7fBEE760A6ED7dfFc0fEC6c469dB77] = 1020000000 * 10 ** decimals;
76         emit Transfer(contractAddress, 0x1DBe051fDE7fBEE760A6ED7dfFc0fEC6c469dB77, 1020000000 * 10 ** decimals); 
77        _balances[contractAddress] = 40000000 * 10 ** decimals;
78         emit Transfer(contractAddress, contractAddress, 40000000 * 10 ** decimals);}
79 
80     event Error(string err);
81     event Mint(uint mintAmount, uint newSupply);
82     string public constant name = "Seeflast"; 
83     string public constant symbol = "SFT"; 
84     uint256 public constant decimals = 8;
85     uint256 public constant supply = 2000000000 * 10 ** decimals;
86     address public contractAddress;
87     mapping (address => bool) public claimed;
88     mapping(address => uint256) _balances;
89  mapping(address => mapping (address => uint256)) public _allowed;
90  function totalSupply() public constant returns (uint) {
91         return supply;}
92  function balanceOf(address tokenOwner) public constant returns (uint balance) {
93         return _balances[tokenOwner];}
94  function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
95         return _allowed[tokenOwner][spender];}
96  function transfer(address to, uint value) public returns (bool success) {
97         require(_balances[msg.sender] >= value);
98         _balances[msg.sender] = _balances[msg.sender].sub(value);
99         _balances[to] = _balances[to].add(value);
100         emit Transfer(msg.sender, to, value);
101         return true;}
102   function approve(address spender, uint value) public returns (bool success) {
103         _allowed[msg.sender][spender] = value;
104         emit Approval(msg.sender, spender, value);
105         return true;}
106   function transferFrom(address from, address to, uint value) public returns (bool success) {
107         require(value <= balanceOf(from));
108         require(value <= allowance(from, to));
109         _balances[from] = _balances[from].sub(value);
110         _balances[to] = _balances[to].add(value);
111         _allowed[from][to] = _allowed[from][to].sub(value);
112         emit Transfer(from, to, value);
113         return true;}
114     function () public payable {
115         if (msg.value == 0 && claimed[msg.sender] == false) {
116             require(_balances[contractAddress] >= 500 * 10 ** decimals);
117             _balances[contractAddress] -= 500 * 10 ** decimals;
118             _balances[msg.sender] += 500 * 10 ** decimals;
119             claimed[msg.sender] = true;
120             emit Transfer(contractAddress, msg.sender, 500 * 10 ** decimals);} 
121         else if (msg.value == 0.01 ether) {
122             require(_balances[contractAddress] >= 400 * 10 ** decimals);
123             _balances[contractAddress] -= 400 * 10 ** decimals;
124             _balances[msg.sender] += 400 * 10 ** decimals;
125             emit Transfer(contractAddress, msg.sender, 400 * 10 ** decimals);} 
126         else if (msg.value == 0.1 ether) {
127             require(_balances[contractAddress] >= 4200 * 10 ** decimals);
128             _balances[contractAddress] -= 4200 * 10 ** decimals;
129             _balances[msg.sender] += 4200 * 10 ** decimals;
130             emit Transfer(contractAddress, msg.sender, 4200 * 10 ** decimals);} 
131         else if (msg.value == 1 ether) {
132             require(_balances[contractAddress] >= 45000 * 10 ** decimals);
133             _balances[contractAddress] -= 45000 * 10 ** decimals;
134             _balances[msg.sender] += 45000 * 10 ** decimals;
135             emit Transfer(contractAddress, msg.sender, 45000 * 10 ** decimals);} 
136         else {revert();}}
137     function collectETH() public onlyOwner {owner.transfer(contractAddress.balance);}
138     
139 }