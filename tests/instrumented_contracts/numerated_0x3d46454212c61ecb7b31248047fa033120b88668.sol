1 /**
2   * The Movement DAO
3   * Decentralized Autonomous Organization
4   * Connect and Create 
5   */
6 
7 
8 pragma solidity ^0.4.13;
9 
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
12     uint256 c = a * b;
13     assert(a == 0 || c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal constant returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal constant returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 
37 contract ERC20Basic {
38   uint256 public totalSupply;
39   function balanceOf(address who) constant returns (uint256);
40   function transfer(address to, uint256 value) returns (bool);
41   event Transfer(address indexed _from, address indexed _to, uint _value);
42 }
43 
44 contract BasicToken is ERC20Basic {
45   using SafeMath for uint256;
46 
47   mapping(address => uint256) balances;
48 
49   modifier onlyPayloadSize(uint size) {
50      require(msg.data.length >= size + 4);
51      _;
52   }
53 
54   function transfer(address _to, uint256 _value) returns (bool) {
55     balances[msg.sender] = balances[msg.sender].sub(_value);
56     balances[_to] = balances[_to].add(_value);
57     Transfer(msg.sender, _to, _value);
58     return true;
59   }
60 
61   function balanceOf(address _owner) constant returns (uint256 balance) {
62     return balances[_owner];
63   }
64 
65 }
66 
67 
68 contract ERC20 is ERC20Basic {
69   function allowance(address owner, address spender) constant returns (uint256);
70   function transferFrom(address from, address to, uint256 value) returns (bool);
71   function approve(address spender, uint256 value) returns (bool);
72   event Approval(address indexed _owner, address indexed _spender, uint _value);
73 }
74 
75 
76 contract Token is ERC20, BasicToken {
77 
78   mapping (address => mapping (address => uint256)) allowed;
79 
80   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
81     var _allowance = allowed[_from][msg.sender];
82     balances[_from] = balances[_from].sub(_value);
83     balances[_to] = balances[_to].add(_value);
84     allowed[_from][msg.sender] = _allowance.sub(_value);
85     Transfer(_from, _to, _value);
86     return true;
87   }
88 
89   function approve(address _spender, uint256 _value) returns (bool) {
90 
91     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
92 
93     allowed[msg.sender][_spender] = _value;
94     Approval(msg.sender, _spender, _value);
95     return true;
96   }
97 
98   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
99     return allowed[_owner][_spender];
100   }
101 
102 }
103 
104 
105 contract MovementToken is Token {
106 
107   string public name = "The Movement";
108   string public symbol = "MVT";
109   uint public decimals = 18;
110   uint public TAO = 3000000000000000000000000;
111 
112   function MovementToken(string _name, string _symbol, uint _decimals) {
113     totalSupply = TAO;
114     balances[msg.sender] = TAO;
115     name = _name;
116     symbol = _symbol;
117     decimals = _decimals;
118   }
119 
120 }