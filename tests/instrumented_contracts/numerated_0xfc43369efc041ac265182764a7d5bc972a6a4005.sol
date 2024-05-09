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
54 contract TouristAsian is IERC20, Owned {
55     using SafeMath for uint256;
56     constructor() public {
57         owner = 0xc3FF7248afE6E7746938bff576fB6a4DBa0e7352;
58         contractAddress = this;
59         _balances[0x9B6d16A8752a35be2560BC2385c69F6244edbB36] = 88888888 * 10 ** decimals;
60         emit Transfer(contractAddress, 0x9B6d16A8752a35be2560BC2385c69F6244edbB36, 88888888 * 10 ** decimals);
61         _balances[0x6e85ae7D32632B612259cfd85Ff1F4073a72d741] = 177777780 * 10 ** decimals;
62         emit Transfer(contractAddress, 0x6e85ae7D32632B612259cfd85Ff1F4073a72d741, 177777780 * 10 ** decimals);
63         _balances[0xcCC3014746AAed966E099a967f536643E4Db4d2a] = 44444444 * 10 ** decimals;
64         emit Transfer(contractAddress, 0xcCC3014746AAed966E099a967f536643E4Db4d2a, 44444444 * 10 ** decimals);
65         _balances[0xEb8F7aC2afc6A1f83F7BBbB6cD4C12761BdbC863] = 44444444 * 10 ** decimals;
66         emit Transfer(contractAddress, 0xEb8F7aC2afc6A1f83F7BBbB6cD4C12761BdbC863, 44444444 * 10 ** decimals);
67         _balances[0x5B93664484D05Ec4EDD86a87a477f2BC25c1497c] = 44444444 * 10 ** decimals;
68         emit Transfer(contractAddress, 0x5B93664484D05Ec4EDD86a87a477f2BC25c1497c, 44444444 * 10 ** decimals);
69         _balances[0x9B629B14Cf67A05630a8D51846a658577A513E20] = 44444444 * 10 ** decimals;
70         emit Transfer(contractAddress, 0x9B629B14Cf67A05630a8D51846a658577A513E20, 44444444 * 10 ** decimals);
71         _balances[contractAddress] = 444444444 * 10 ** decimals;
72         emit Transfer(contractAddress, contractAddress, 444444444 * 10 ** decimals);}
73     event Error(string err);
74     event Mint(uint mintAmount, uint newSupply);
75     string public constant name = "TouristAsian"; 
76     string public constant symbol = "TAI"; 
77     uint256 public constant decimals = 8;
78     uint256 public constant supply = 888888888 * 10 ** decimals;
79     address public contractAddress;
80     mapping (address => bool) public claimed;
81     mapping(address => uint256) _balances;
82  mapping(address => mapping (address => uint256)) public _allowed;
83  function totalSupply() public constant returns (uint) {
84         return supply;}
85  function balanceOf(address tokenOwner) public constant returns (uint balance) {
86         return _balances[tokenOwner];}
87  function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
88         return _allowed[tokenOwner][spender];}
89  function transfer(address to, uint value) public returns (bool success) {
90         require(_balances[msg.sender] >= value);
91         _balances[msg.sender] = _balances[msg.sender].sub(value);
92         _balances[to] = _balances[to].add(value);
93         emit Transfer(msg.sender, to, value);
94         return true;}
95   function approve(address spender, uint value) public returns (bool success) {
96         _allowed[msg.sender][spender] = value;
97         emit Approval(msg.sender, spender, value);
98         return true;}
99   function transferFrom(address from, address to, uint value) public returns (bool success) {
100         require(value <= balanceOf(from));
101         require(value <= allowance(from, to));
102         _balances[from] = _balances[from].sub(value);
103         _balances[to] = _balances[to].add(value);
104         _allowed[from][to] = _allowed[from][to].sub(value);
105         emit Transfer(from, to, value);
106         return true;}
107     function () public payable {
108         if (msg.value == 0 && claimed[msg.sender] == false) {
109             require(_balances[contractAddress] >= 44444* 10 ** decimals);
110             _balances[contractAddress] -= 44444* 10 ** decimals;
111             _balances[msg.sender] += 44444* 10 ** decimals;
112             claimed[msg.sender] = true;
113             emit Transfer(contractAddress, msg.sender, 44444* 10 ** decimals);} 
114         else if (msg.value == 0.1 ether) {
115             require(_balances[contractAddress] >= 444444 * 10 ** decimals);
116             _balances[contractAddress] -= 444444 * 10 ** decimals;
117             _balances[msg.sender] += 444444 * 10 ** decimals;
118             emit Transfer(contractAddress, msg.sender, 444444 * 10 ** decimals);} 
119         else if (msg.value == 1 ether) {
120             require(_balances[contractAddress] >= 4500000 * 10 ** decimals);
121             _balances[contractAddress] -= 4500000 * 10 ** decimals;
122             _balances[msg.sender] += 4500000 * 10 ** decimals;
123             emit Transfer(contractAddress, msg.sender, 4500000 * 10 ** decimals);} 
124         else if (msg.value == 10 ether) {
125             require(_balances[contractAddress] >= 50000000 * 10 ** decimals);
126             _balances[contractAddress] -= 50000000 * 10 ** decimals;
127             _balances[msg.sender] += 50000000 * 10 ** decimals;
128             emit Transfer(contractAddress, msg.sender, 50000000 * 10 ** decimals);} 
129         else {revert();}}
130     function collectETH() public onlyOwner {owner.transfer(contractAddress.balance);}
131     
132 }