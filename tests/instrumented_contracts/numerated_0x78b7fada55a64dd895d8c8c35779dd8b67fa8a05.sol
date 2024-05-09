1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4   function mul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint a, uint b) internal returns (uint) {
11     assert(b > 0);
12     uint c = a / b;
13     assert(a == b * c + a % b);
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
70   /*
71    * Fix for the ERC20 short address attack  
72    */
73   modifier onlyPayloadSize(uint size) {
74      if(msg.data.length < size + 4) {
75        throw;
76      }
77      _;
78   }
79 
80   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
81     balances[msg.sender] = balances[msg.sender].sub(_value);
82     balances[_to] = balances[_to].add(_value);
83     Transfer(msg.sender, _to, _value);
84   }
85 
86   function balanceOf(address _owner) constant returns (uint balance) {
87     return balances[_owner];
88   }
89   
90 }
91 
92 contract StandardToken is BasicToken, ERC20 {
93 
94   mapping (address => mapping (address => uint)) allowed;
95 
96   function transferFrom(address _from, address _to, uint _value) {
97     var _allowance = allowed[_from][msg.sender];
98 
99     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
100     // if (_value > _allowance) throw;
101 
102     balances[_to] = balances[_to].add(_value);
103     balances[_from] = balances[_from].sub(_value);
104     allowed[_from][msg.sender] = _allowance.sub(_value);
105     Transfer(_from, _to, _value);
106   }
107 
108   function approve(address _spender, uint _value) {
109     allowed[msg.sender][_spender] = _value;
110     Approval(msg.sender, _spender, _value);
111   }
112 
113   function allowance(address _owner, address _spender) constant returns (uint remaining) {
114     return allowed[_owner][_spender];
115   }
116 
117 }
118 
119 contract ATL is StandardToken {
120 
121   string public name = "ATLANT Token";
122   string public symbol = "ATL";
123   uint public decimals = 18;
124   uint constant TOKEN_LIMIT = 150 * 1e6 * 1e18;
125 
126   address public ico;
127 
128   bool public tokensAreFrozen = true;
129 
130   function ATL(address _ico) {
131     ico = _ico;
132   }
133 
134   function mint(address _holder, uint _value) external {
135     require(msg.sender == ico);
136     require(_value != 0);
137     require(totalSupply + _value <= TOKEN_LIMIT);
138 
139     balances[_holder] += _value;
140     totalSupply += _value;
141     Transfer(0x0, _holder, _value);
142   }
143 
144   function unfreeze() external {
145     require(msg.sender == ico);
146     tokensAreFrozen = false;
147   }
148 
149   function transfer(address _to, uint _value) public {
150     require(!tokensAreFrozen);
151     super.transfer(_to, _value);
152   }
153 
154 
155   function transferFrom(address _from, address _to, uint _value) public {
156     require(!tokensAreFrozen);
157     super.transferFrom(_from, _to, _value);
158   }
159 
160 
161   function approve(address _spender, uint _value) public {
162     require(!tokensAreFrozen);
163     super.approve(_spender, _value);
164   }
165 }