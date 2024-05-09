1 pragma solidity ^0.4.18;
2 
3 contract ERC20 {
4   function balanceOf(address who) public view returns (uint256);
5   function transfer(address to, uint256 value) public returns (bool);
6   function allowance(address owner, address spender) public view returns (uint256 remaining);
7   function transferFrom(address from, address to, uint256 value) public returns (bool);
8   function approve(address spender, uint256 value) public returns (bool);
9 
10   event Transfer(address indexed from, address indexed to, uint256 value);
11   event Approval(address indexed owner, address indexed spender, uint256 value);
12 }
13 
14 library SafeMath {
15   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16     if (a == 0) {
17       return 0;
18     }
19     uint256 c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a / b;
26     return c;
27   }
28 
29   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b <= a);
31     return a - b;
32   }
33 
34   function add(uint256 a, uint256 b) internal pure returns (uint256) {
35     uint256 c = a + b;
36     assert(c >= a);
37     return c;
38   }
39 }
40 
41 contract NebToken is ERC20 {
42   using SafeMath for uint256;
43 
44   string public name = "Nebula Network Token";
45   string public symbol = "NEB";
46   uint8 public decimals = 0;
47   address public treasury;
48   uint256 public totalSupply;
49 
50   mapping (address => uint256) public balances;
51   mapping (address => mapping (address => uint256)) internal allowed;
52 
53   constructor(uint256 _totalSupply) public {
54     treasury = msg.sender;
55     totalSupply = _totalSupply;
56     balances[treasury] = totalSupply;
57     emit Transfer(0x0, treasury, totalSupply);
58   }
59 
60   function balanceOf(address _addr) public view returns(uint256) {
61     return balances[_addr];
62   }
63 
64   function transfer(address _to, uint256 _amount) public returns (bool) {
65     require(_to != address(0));
66     require(_amount <= balances[msg.sender]);
67 
68     balances[msg.sender] = balances[msg.sender].sub(_amount);
69     balances[_to] = balances[_to].add(_amount);
70     emit Transfer(msg.sender, _to, _amount);
71     return true;
72   }
73 
74   function allowance(address _owner, address _spender) public view returns (uint256) {
75     return allowed[_owner][_spender];
76   }
77 
78   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool) {
79     require(_to != address(0));
80     require(_amount <= balances[_from]);
81     require(_amount <= allowed[_from][msg.sender]);
82 
83     balances[_from] = balances[_from].sub(_amount);
84     balances[_to] = balances[_to].add(_amount);
85     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
86     emit Transfer(_from, _to, _amount);
87     return true;
88   }
89 
90   function approve(address _spender, uint256 _amount) public returns (bool) {
91       allowed[msg.sender][_spender] = _amount;
92       emit Approval(msg.sender, _spender, _amount);
93       return true;
94   }
95 }