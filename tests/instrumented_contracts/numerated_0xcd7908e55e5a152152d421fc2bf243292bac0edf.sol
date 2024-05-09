1 /**
2  * Math operations with safety checks
3  */
4 library SafeMath {
5   function mul(uint a, uint b) internal returns (uint) {
6     uint c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function div(uint a, uint b) internal returns (uint) {
12     // assert(b > 0); // Solidity automatically throws when dividing by 0
13     uint c = a / b;
14     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15     return c;
16   }
17 
18   function sub(uint a, uint b) internal returns (uint) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint a, uint b) internal returns (uint) {
24     uint c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 
29   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
30     return a >= b ? a : b;
31   }
32 
33   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
34     return a < b ? a : b;
35   }
36 
37   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
38     return a >= b ? a : b;
39   }
40 
41   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
42     return a < b ? a : b;
43   }
44 
45   function assert(bool assertion) internal {
46     if (!assertion) {
47       throw;
48     }
49   }
50 }
51 
52 /**
53  * @title ERC20Basic
54  * @dev Simpler version of ERC20 interface
55  * @dev see https://github.com/ethereum/EIPs/issues/20
56  */
57 contract ERC20Basic {
58   uint public totalSupply;
59   function balanceOf(address who) constant returns (uint);
60   function transfer(address to, uint value);
61   event Transfer(address indexed from, address indexed to, uint value);
62 }
63 
64 /**
65  * @title ERC20 interface
66  * @dev see https://github.com/ethereum/EIPs/issues/20
67  */
68 contract ERC20 is ERC20Basic {
69   function allowance(address owner, address spender) constant returns (uint);
70   function transferFrom(address from, address to, uint value);
71   function approve(address spender, uint value);
72   event Approval(address indexed owner, address indexed spender, uint value);
73 }
74 
75 /**
76  * @title Basic token
77  * @dev Basic version of StandardToken, with no allowances.
78  */
79 contract BasicToken is ERC20Basic {
80   using SafeMath for uint;
81 
82   mapping(address => uint) balances;
83 
84   /**
85    * @dev Fix for the ERC20 short address attack.
86    */
87   modifier onlyPayloadSize(uint size) {
88      if(msg.data.length < size + 4) {
89        throw;
90      }
91      _;
92   }
93 
94   /**
95   * @dev transfer token for a specified address
96   * @param _to The address to transfer to.
97   * @param _value The amount to be transferred.
98   */
99   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
100     balances[msg.sender] = balances[msg.sender].sub(_value);
101     balances[_to] = balances[_to].add(_value);
102     Transfer(msg.sender, _to, _value);
103   }
104 
105   /**
106   * @dev Gets the balance of the specified address.
107   * @param _owner The address to query the the balance of.
108   * @return An uint representing the amount owned by the passed address.
109   */
110   function balanceOf(address _owner) constant returns (uint balance) {
111     return balances[_owner];
112   }
113 
114 }
115 
116 /**
117  * @title Standard ERC20 token
118  *
119  * @dev Implemantation of the basic standart token.
120  * @dev https://github.com/ethereum/EIPs/issues/20
121  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
122  */
123 contract StandardToken is BasicToken, ERC20 {
124 
125   mapping (address => mapping (address => uint)) allowed;
126 
127 
128   /**
129    * @dev Transfer tokens from one address to another
130    * @param _from address The address which you want to send tokens from
131    * @param _to address The address which you want to transfer to
132    * @param _value uint the amout of tokens to be transfered
133    */
134   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
135     var _allowance = allowed[_from][msg.sender];
136 
137     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
138     // if (_value > _allowance) throw;
139 
140     balances[_to] = balances[_to].add(_value);
141     balances[_from] = balances[_from].sub(_value);
142     allowed[_from][msg.sender] = _allowance.sub(_value);
143     Transfer(_from, _to, _value);
144   }
145 
146   /**
147    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
148    * @param _spender The address which will spend the funds.
149    * @param _value The amount of tokens to be spent.
150    */
151   function approve(address _spender, uint _value) {
152 
153     // To change the approve amount you first have to reduce the addresses`
154     //  allowance to zero by calling `approve(_spender, 0)` if it is not
155     //  already 0 to mitigate the race condition described here:
156     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
158 
159     allowed[msg.sender][_spender] = _value;
160     Approval(msg.sender, _spender, _value);
161   }
162 
163   /**
164    * @dev Function to check the amount of tokens than an owner allowed to a spender.
165    * @param _owner address The address which owns the funds.
166    * @param _spender address The address which will spend the funds.
167    * @return A uint specifing the amount of tokens still avaible for the spender.
168    */
169   function allowance(address _owner, address _spender) constant returns (uint remaining) {
170     return allowed[_owner][_spender];
171   }
172 
173 }
174 
175 /**
176  * @title BITHALAL ERC20 token
177  *
178  * @dev Implemantation of the BITHalal token.
179  */
180 contract BITHALALToken is StandardToken {
181 
182     string public name = "BITHALAL";
183     string public symbol = "BTH";
184     uint public decimals = 8;
185     uint public INITIAL_SUPPLY = 10000000000000000; // Initial supply is 100,000,000 BTH
186 
187     function BITHALALToken() {
188         totalSupply = INITIAL_SUPPLY;
189         balances[msg.sender] = INITIAL_SUPPLY;
190     }
191 }