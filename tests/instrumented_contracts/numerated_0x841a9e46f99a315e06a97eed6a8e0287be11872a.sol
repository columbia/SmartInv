1 pragma solidity ^0.4.6;
2 
3 library SafeMath {
4   function mul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint a, uint b) internal returns (uint) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint c = a / b;
13  
14     return c;
15   }
16 
17   function sub(uint a, uint b) internal returns (uint) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint a, uint b) internal returns (uint) {
23     uint c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 
28   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
29     return a >= b ? a : b;
30   }
31 
32   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a < b ? a : b;
34   }
35 
36   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
37     return a >= b ? a : b;
38   }
39 
40   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a < b ? a : b;
42   }
43 
44   function assert(bool assertion) internal {
45     if (!assertion) {
46       throw;
47     }
48   }
49 }
50 
51 contract ERC20Basic {
52   uint public totalSupply;
53   function balanceOf(address who) constant returns (uint);
54   function transfer(address to, uint value);
55   event Transfer(address indexed from, address indexed to, uint value);
56 }
57 
58 contract ERC20 is ERC20Basic {
59   function allowance(address owner, address spender) constant returns (uint);
60   function transferFrom(address from, address to, uint value);
61   function approve(address spender, uint value);
62   event Approval(address indexed owner, address indexed spender, uint value);
63 }
64 
65 contract BasicToken is ERC20Basic {
66   using SafeMath for uint;
67 
68   mapping(address => uint) balances;
69 
70   modifier onlyPayloadSize(uint size) {
71      if(msg.data.length < size + 4) {
72        throw;
73      }
74      _;
75   }
76 
77 
78   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
79     balances[msg.sender] = balances[msg.sender].sub(_value);
80     balances[_to] = balances[_to].add(_value);
81     Transfer(msg.sender, _to, _value);
82   }
83 
84 
85   function balanceOf(address _owner) constant returns (uint balance) {
86     return balances[_owner];
87   }
88 
89 }
90 
91 contract Another is BasicToken, ERC20 {
92 
93   mapping (address => mapping (address => uint)) allowed;
94 
95 
96   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
97     var _allowance = allowed[_from][msg.sender];
98 
99     balances[_to] = balances[_to].add(_value);
100     balances[_from] = balances[_from].sub(_value);
101     allowed[_from][msg.sender] = _allowance.sub(_value);
102     Transfer(_from, _to, _value);
103   }
104 
105 
106   function approve(address _spender, uint _value) {
107 
108     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
109 
110     allowed[msg.sender][_spender] = _value;
111     Approval(msg.sender, _spender, _value);
112   }
113 
114 
115   function allowance(address _owner, address _spender) constant returns (uint remaining) {
116     return allowed[_owner][_spender];
117   }
118 
119 }
120 
121 contract JihoyContract is Another {
122 
123   string public name = "Jihoy";
124   string public symbol = "JIHOY";
125   uint public decimals = 3;
126   uint public INITIAL_SUPPLY = 100000000000;
127 
128   function JihoyContract() {
129     totalSupply = INITIAL_SUPPLY;
130     balances[msg.sender] = INITIAL_SUPPLY;
131   }
132 
133 }