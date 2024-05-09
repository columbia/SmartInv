1 pragma solidity ^0.4.26;
2 /**
3  * ERC20 token
4  *
5  * https://github.com/ethereum/EIPs/issues/20
6  */
7 contract ERC20 {
8   function balanceOf(address _owner) constant returns (uint);
9   function allowance(address _owner, address _spender) constant returns (uint);
10   function transfer(address _to, uint _value) returns (bool ok);
11   function transferFrom(address _from, address _to, uint _value) returns (bool ok);
12   function approve(address _spender, uint _value) returns (bool ok);
13   event Transfer(address indexed _from, address indexed _to, uint _value);
14   event Approval(address indexed _owner, address indexed _spender, uint _value);
15   event Burn(address target,uint amount);
16 }
17 contract SafeMath {
18   function safeMul(uint a, uint b) internal returns (uint) {
19     uint c = a * b;
20     assert(a == 0 || c / a == b);
21     return c;
22   }
23 
24   function safeDiv(uint a, uint b) internal returns (uint) {
25     assert(b > 0);
26     uint c = a / b;
27     assert(a == b * c + a % b);
28     return c;
29   }
30 
31   function safeSub(uint a, uint b) internal returns (uint) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   function safeAdd(uint a, uint b) internal returns (uint) {
37     uint c = a + b;
38     assert(c>=a && c>=b);
39     return c;
40   }
41 
42   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
43     return a >= b ? a : b;
44   }
45 
46   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
47     return a < b ? a : b;
48   }
49 
50   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
51     return a >= b ? a : b;
52   }
53 
54   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
55     return a < b ? a : b;
56   }
57 
58   function assert(bool assertion) internal {
59     if (!assertion) {
60       throw;
61     }
62   }
63 }
64 
65 contract StandardToken is ERC20, SafeMath {
66 
67   mapping(address => uint) balances;
68   mapping (address => mapping (address => uint)) allowed;
69 
70   modifier onlyPayloadSize(uint size) {
71      if(msg.data.length < size + 4) {
72        throw;
73      }
74      _;
75   }
76 
77   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {
78     balances[msg.sender] = safeSub(balances[msg.sender], _value);
79     balances[_to] = safeAdd(balances[_to], _value);
80     Transfer(msg.sender, _to, _value);
81     return true;
82   }
83 
84   function transferFrom(address _from, address _to, uint _value)  returns (bool success) {
85     var _allowance = allowed[_from][msg.sender];
86 
87     balances[_to] = safeAdd(balances[_to], _value);
88     balances[_from] = safeSub(balances[_from], _value);
89     allowed[_from][msg.sender] = safeSub(_allowance, _value);
90     Transfer(_from, _to, _value);
91     return true;
92   }
93 
94   function balanceOf(address _owner) constant returns (uint balance) {
95     return balances[_owner];
96   }
97 
98   function approve(address _spender, uint _value) returns (bool success) {
99     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
100     allowed[msg.sender][_spender] = _value;
101     Approval(msg.sender, _spender, _value);
102     return true;
103   }
104 
105   function allowance(address _owner, address _spender) constant returns (uint remaining) {
106     return allowed[_owner][_spender];
107   }
108 
109 }
110 
111 /**
112 ** Burn token function
113 **/
114 contract BurnableToken is StandardToken {
115   uint256 public totalSupply;
116   address public constant BURN_ADDRESS = 0x0;
117   function burn(uint burnAmount) {
118     require(balances[msg.sender]>=burnAmount);
119     balances[msg.sender]=safeSub(balances[msg.sender],burnAmount);
120     totalSupply = safeSub(totalSupply,burnAmount);
121     emit Burn(msg.sender,burnAmount);
122   }
123 }
124 
125 contract BATCToken is BurnableToken {
126   string public name;
127   string public symbol;
128   uint8 public decimals = 6;
129   function BATCToken(address _owner, string _name, string _symbol, uint _totalSupply, uint8 _decimals) {
130     name = _name;
131     symbol = _symbol;
132     totalSupply = _totalSupply * 10 ** uint256(_decimals);
133     decimals = _decimals;
134     if(_owner!= 0x0){
135         _owner = msg.sender;
136     }
137     balances[_owner] = totalSupply;
138   }
139 }