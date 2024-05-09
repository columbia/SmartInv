1 pragma solidity ^0.4.18;
2 
3 contract ERC20 {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   function allowance(address owner, address spender) public view returns (uint256);
8   function transferFrom(address from, address to, uint256 value) public returns (bool);
9   function approve(address spender, uint256 value) public returns (bool);
10 
11   event Transfer(address indexed from, address indexed to, uint256 value);
12   event Approval(address indexed owner, address indexed spender, uint256 value);
13 }
14 
15 
16 library SafeMath {
17 
18   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19     if (a == 0) {
20       return 0;
21     }
22     uint256 c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a / b;
29     return c;
30   }
31 
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   function add(uint256 a, uint256 b) internal pure returns (uint256) {
38     uint256 c = a + b;
39     assert(c >= a);
40     return c;
41   }
42 }
43 
44 
45 contract LTKN is ERC20 {
46 
47   using SafeMath for uint256;
48 
49   mapping(address => uint256) balances;
50   uint256 totalSupply_;
51   mapping (address => mapping (address => uint256)) internal allowed;
52 
53   string public constant name = "LATINOKEN";
54   string public constant symbol = "LTKN";
55   uint8 public constant decimals = 4;
56 
57   uint256 public constant INITIAL_SUPPLY = 700000000 * (10 ** uint256(decimals));
58 
59   function LTKN() public {
60     totalSupply_ = INITIAL_SUPPLY;
61     balances[msg.sender] = INITIAL_SUPPLY;
62     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
63   }
64 
65   function totalSupply() public view returns (uint256) {
66     return totalSupply_;
67   }
68 
69   function transfer(address _to, uint256 _value) public returns (bool) {
70     require(_to != address(0));
71     require(_value <= balances[msg.sender]);
72 
73     balances[msg.sender] = balances[msg.sender].sub(_value);
74     balances[_to] = balances[_to].add(_value);
75     Transfer(msg.sender, _to, _value);
76     return true;
77   }
78 
79   function balanceOf(address _owner) public view returns (uint256 balance) {
80     return balances[_owner];
81   }
82 
83   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
84     require(_to != address(0));
85     require(_value <= balances[_from]);
86     require(_value <= allowed[_from][msg.sender]);
87 
88     balances[_from] = balances[_from].sub(_value);
89     balances[_to] = balances[_to].add(_value);
90     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
91     Transfer(_from, _to, _value);
92     return true;
93   }
94 
95   function approve(address _spender, uint256 _value) public returns (bool) {
96     allowed[msg.sender][_spender] = _value;
97     Approval(msg.sender, _spender, _value);
98     return true;
99   }
100 
101   function allowance(address _owner, address _spender) public view returns (uint256) {
102     return allowed[_owner][_spender];
103   }
104 
105 }