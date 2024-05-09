1 pragma solidity 0.4.11;
2 library SafeMath {
3   function mul(uint256 a, uint256 b) internal returns (uint256) {
4     uint256 c = a * b;
5     assert(a == 0 || c / a == b);
6     return c;
7   }
8 
9   function div(uint256 a, uint256 b) internal returns (uint256) {
10     // assert(b > 0); // Solidity automatically throws when dividing by 0
11     uint256 c = a / b;
12     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
13     return c;
14   }
15 
16   function sub(uint256 a, uint256 b) internal returns (uint256) {
17     assert(b <= a);
18     return a - b;
19   }
20 
21   function add(uint256 a, uint256 b) internal returns (uint256) {
22     uint256 c = a + b;
23     assert(c >= a);
24     return c;
25   }
26 
27   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
28     return a >= b ? a : b;
29   }
30 
31   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
32     return a < b ? a : b;
33   }
34 
35   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
36     return a >= b ? a : b;
37   }
38 
39   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
40     return a < b ? a : b;
41   }
42 
43 }
44 contract Ownable {
45   address public owner;
46   
47 
48   function Ownable() {
49     owner = msg.sender;
50   }
51 
52   modifier onlyOwner() {
53     if (msg.sender != owner) {
54       throw;
55     }
56     _;
57   }
58 
59   function transferOwnership(address newOwner) onlyOwner {
60     if (newOwner != address(0)) {
61       owner = newOwner;
62     }
63   }
64   
65   function kill() onlyOwner {
66      selfdestruct(owner);
67   }
68 }
69 contract ERC20Basic {
70   function balanceOf(address who) constant returns (uint256);
71   function transfer(address to, uint256 value);
72   event Transfer(address indexed from, address indexed to, uint256 value);
73 }
74 contract ERC20 is ERC20Basic {
75   function allowance(address owner, address spender) constant returns (uint256);
76   function transferFrom(address from, address to, uint256 value);
77   function approve(address spender, uint256 value);
78   event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 contract BasicToken is ERC20Basic {
81   using SafeMath for uint256;
82 
83   mapping(address => uint256) balances;
84   uint256 public totalSupply;
85 
86   modifier onlyPayloadSize(uint256 size) {
87      if(msg.data.length < size + 4) {
88        throw;
89      }
90      _;
91   }
92 
93   function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) {
94     balances[msg.sender] = balances[msg.sender].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     Transfer(msg.sender, _to, _value);
97   }
98 
99   function balanceOf(address _owner) constant returns (uint256 balance) {
100     return balances[_owner];
101   }
102 
103 }
104 contract StandardToken is BasicToken, ERC20 {
105 
106   mapping (address => mapping (address => uint256)) allowed;
107 
108   function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) {
109     var _allowance = allowed[_from][msg.sender];
110     balances[_to] = balances[_to].add(_value);
111     balances[_from] = balances[_from].sub(_value);
112     allowed[_from][msg.sender] = _allowance.sub(_value);
113     Transfer(_from, _to, _value);
114   }
115 
116   function approve(address _spender, uint256 _value) {
117     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
118 
119     allowed[msg.sender][_spender] = _value;
120     Approval(msg.sender, _spender, _value);
121   }
122 
123   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
124     return allowed[_owner][_spender];
125   }
126 
127 }
128 contract ITSToken is StandardToken, Ownable {
129 
130   string public constant name = "Intelligent Transportation System";
131   string public constant symbol = "ITS";
132   uint256 public constant decimals = 8;
133   
134   
135   function ITSToken(){
136     owner = msg.sender;
137     totalSupply=10000000000000000;
138     balances[owner]=totalSupply;
139   }
140 
141   function () {
142     throw;
143   }
144 
145 }