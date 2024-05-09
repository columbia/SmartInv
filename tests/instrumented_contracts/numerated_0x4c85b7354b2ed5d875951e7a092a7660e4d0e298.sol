1 pragma solidity ^0.4.11;
2 
3 
4 contract ERC20Basic {
5   uint256 public totalSupply;
6   function balanceOf(address who) constant returns (uint256);
7   function transfer(address to, uint256 value) returns (bool);
8   event Transfer(address indexed from, address indexed to, uint256 value);
9 }
10 
11 
12 contract ERC20 is ERC20Basic {
13   function allowance(address owner, address spender) constant returns (uint256);
14   function transferFrom(address from, address to, uint256 value) returns (bool);
15   function approve(address spender, uint256 value) returns (bool);
16   event Approval(address indexed owner, address indexed spender, uint256 value);
17 }
18 
19 
20 library SafeMath {
21   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
22     uint256 c = a * b;
23     assert(a == 0 || c / a == b);
24     return c;
25   }
26 
27   function div(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a / b;
29     return c;
30   }
31 
32   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   function add(uint256 a, uint256 b) internal constant returns (uint256) {
38     uint256 c = a + b;
39     assert(c >= a);
40     return c;
41   }
42 }
43 
44 
45 contract BasicToken is ERC20Basic {
46   using SafeMath for uint256;
47 
48   mapping(address => uint256) balances;
49 
50   function transfer(address _to, uint256 _value) returns (bool) {
51     balances[msg.sender] = balances[msg.sender].sub(_value);
52     balances[_to] = balances[_to].add(_value);
53     Transfer(msg.sender, _to, _value);
54     return true;
55   }
56 
57   function balanceOf(address _owner) constant returns (uint256 balance) {
58     return balances[_owner];
59   }
60 
61 }
62 
63 contract StandardToken is ERC20, BasicToken {
64 
65   mapping (address => mapping (address => uint256)) allowed;
66 
67   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
68     var _allowance = allowed[_from][msg.sender];
69 
70     balances[_to] = balances[_to].add(_value);
71     balances[_from] = balances[_from].sub(_value);
72     allowed[_from][msg.sender] = _allowance.sub(_value);
73     Transfer(_from, _to, _value);
74     return true;
75   }
76 
77   function approve(address _spender, uint256 _value) returns (bool) {
78     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
79 
80     allowed[msg.sender][_spender] = _value;
81     Approval(msg.sender, _spender, _value);
82     return true;
83   }
84 
85   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
86     return allowed[_owner][_spender];
87   }
88 
89 }
90 
91 
92 contract TokenFactory is StandardToken {
93 
94   string public name;
95   string public symbol;
96   uint256 public decimals;
97 
98 
99   function TokenFactory(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) {
100     balances[msg.sender] = _initialAmount;
101     totalSupply = _initialAmount;
102     name = _tokenName;
103     decimals = _decimalUnits;
104     symbol = _tokenSymbol;
105   }
106 }