1 pragma solidity ^0.4.18;
2 
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a / b;
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 contract ERC20Basic {
32   uint256 public totalSupply;
33   function balanceOf(address who) public view returns (uint256);
34   function transfer(address to, uint256 value) public returns (bool);
35   event Transfer(address indexed from, address indexed to, uint256 value);
36 }
37 
38 contract BasicToken is ERC20Basic {
39   using SafeMath for uint256;
40 
41   mapping(address => uint256) balances;
42 
43   function transfer(address _to, uint256 _value) public returns (bool) {
44     require(_to != address(0));
45     require(_value <= balances[msg.sender]);
46 
47     balances[msg.sender] = balances[msg.sender].sub(_value);
48     balances[_to] = balances[_to].add(_value);
49     Transfer(msg.sender, _to, _value);
50     return true;
51   }
52 
53   function balanceOf(address _owner) public view returns (uint256 balance) {
54     return balances[_owner];
55   }
56 
57 }
58 
59 
60 
61 contract ERC20 is ERC20Basic {
62   function allowance(address owner, address spender) public view returns (uint256);
63   function transferFrom(address from, address to, uint256 value) public returns (bool);
64   function approve(address spender, uint256 value) public returns (bool);
65   event Approval(address indexed owner, address indexed spender, uint256 value);
66 }
67 
68 
69 contract StandardToken is ERC20, BasicToken {
70 
71   mapping (address => mapping (address => uint256)) internal allowed;
72 
73   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
74     require(_to != address(0));
75     require(_value <= balances[_from]);
76     require(_value <= allowed[_from][msg.sender]);
77 
78     balances[_from] = balances[_from].sub(_value);
79     balances[_to] = balances[_to].add(_value);
80     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
81     Transfer(_from, _to, _value);
82     return true;
83   }
84 
85   function approve(address _spender, uint256 _value) public returns (bool) {
86     allowed[msg.sender][_spender] = _value;
87     Approval(msg.sender, _spender, _value);
88     return true;
89   }
90 
91   function allowance(address _owner, address _spender) public view returns (uint256) {
92     return allowed[_owner][_spender];
93   }
94 
95   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
96     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
97     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
98     return true;
99   }
100 
101   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
102     uint oldValue = allowed[msg.sender][_spender];
103     if (_subtractedValue > oldValue) {
104       allowed[msg.sender][_spender] = 0;
105     } else {
106       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
107     }
108     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
109     return true;
110   }
111 
112 }
113 contract BlackHorseWallet is StandardToken {
114 
115   string public constant name = "BlackHorseWallet";
116   string public constant symbol = "BHW";
117   uint8 public constant decimals = 18;
118 
119   address public owner;
120 
121   uint256 public constant TOTAL_SUPPLY = 100000000 * 10 * (10 ** uint256(decimals));
122 
123   function BlackHorseWallet() public {
124     owner = msg.sender;
125     totalSupply = TOTAL_SUPPLY;
126     balances[owner] =   totalSupply;
127   }
128 
129 }