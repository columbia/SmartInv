1 /*
2  * ERC20 interface
3  * see https://github.com/ethereum/EIPs/issues/20
4  */
5 contract ERC20 {
6   uint public totalSupply;
7   function balanceOf(address who) constant returns (uint);
8   function allowance(address owner, address spender) constant returns (uint);
9 
10   function transfer(address to, uint value) returns (bool ok);
11   function transferFrom(address from, address to, uint value) returns (bool ok);
12   function approve(address spender, uint value) returns (bool ok);
13   event Transfer(address indexed from, address indexed to, uint value);
14   event Approval(address indexed owner, address indexed spender, uint value);
15 }
16 
17 
18 
19 /**
20  * Math operations with safety checks
21  */
22 contract SafeMath {
23   function safeMul(uint a, uint b) internal returns (uint) {
24     uint c = a * b;
25     assert(a == 0 || c / a == b);
26     return c;
27   }
28 
29   function safeDiv(uint a, uint b) internal returns (uint) {
30     assert(b > 0);
31     uint c = a / b;
32     assert(a == b * c + a % b);
33     return c;
34   }
35 
36   function safeSub(uint a, uint b) internal returns (uint) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   function safeAdd(uint a, uint b) internal returns (uint) {
42     uint c = a + b;
43     assert(c>=a && c>=b);
44     return c;
45   }
46 
47   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
48     return a >= b ? a : b;
49   }
50 
51   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
52     return a < b ? a : b;
53   }
54 
55   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
56     return a >= b ? a : b;
57   }
58 
59   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
60     return a < b ? a : b;
61   }
62 
63   function assert(bool assertion) internal {
64     if (!assertion) {
65       throw;
66     }
67   }
68 }
69 
70 
71 
72 /**
73  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
74  *
75  * Based on code by FirstBlood:
76  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
77  */
78 contract StandardToken is ERC20, SafeMath {
79 
80   mapping(address => uint) balances;
81   mapping (address => mapping (address => uint)) allowed;
82 
83   // Interface marker
84   bool public constant isToken = true;
85 
86   /**
87    *
88    * Fix for the ERC20 short address attack
89    *
90    * http://vessenes.com/the-erc20-short-address-attack-explained/
91    */
92   modifier onlyPayloadSize(uint size) {
93      if(msg.data.length < size + 4) {
94        throw;
95      }
96      _;
97   }
98 
99   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {
100     balances[msg.sender] = safeSub(balances[msg.sender], _value);
101     balances[_to] = safeAdd(balances[_to], _value);
102     Transfer(msg.sender, _to, _value);
103     return true;
104   }
105 
106   function transferFrom(address _from, address _to, uint _value)  returns (bool success) {
107     var _allowance = allowed[_from][msg.sender];
108 
109     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
110     // if (_value > _allowance) throw;
111 
112     balances[_to] = safeAdd(balances[_to], _value);
113     balances[_from] = safeSub(balances[_from], _value);
114     allowed[_from][msg.sender] = safeSub(_allowance, _value);
115     Transfer(_from, _to, _value);
116     return true;
117   }
118 
119   function balanceOf(address _owner) constant returns (uint balance) {
120     return balances[_owner];
121   }
122 
123   function approve(address _spender, uint _value) returns (bool success) {
124 
125     // To change the approve amount you first have to reduce the addresses`
126     //  allowance to zero by calling `approve(_spender, 0)` if it is not
127     //  already 0 to mitigate the race condition described here:
128     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
129     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
130 
131     allowed[msg.sender][_spender] = _value;
132     Approval(msg.sender, _spender, _value);
133     return true;
134   }
135 
136   function allowance(address _owner, address _spender) constant returns (uint remaining) {
137     return allowed[_owner][_spender];
138   }
139 
140 }
141 
142 contract CentToken is StandardToken { 
143 
144     /* Public variables of the token */
145     string public name;
146     uint8 public decimals;
147     string public symbol;
148     string public version = '1.0';
149 
150     function CentToken(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) {
151         balances[msg.sender] = _initialAmount;
152         totalSupply = _initialAmount;
153         name = _tokenName;
154         decimals = _decimalUnits;
155         symbol = _tokenSymbol;
156     }
157 
158     /* Approves and then calls the receiving contract */
159     
160     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
161         allowed[msg.sender][_spender] = _value;
162         Approval(msg.sender, _spender, _value);
163         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
164         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
165         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
166         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
167         return true;
168     }
169 
170 }