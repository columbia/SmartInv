1 pragma solidity ^0.4.11;
2 
3 /**
4  * Math operations with safety checks
5  */
6 library SafeMath {
7   function mul(uint a, uint b) internal returns (uint) {
8     uint c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function div(uint a, uint b) internal returns (uint) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint a, uint b) internal returns (uint) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint a, uint b) internal returns (uint) {
26     uint c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 
31   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
32     return a >= b ? a : b;
33   }
34 
35   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
36     return a < b ? a : b;
37   }
38 
39   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
40     return a >= b ? a : b;
41   }
42 
43   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
44     return a < b ? a : b;
45   }
46 
47   function assert(bool assertion) internal {
48     if (!assertion) {
49       throw;
50     }
51   }
52 }
53 
54 /**
55  * @title ERC20Basic
56  * @dev Simpler version of ERC20 interface
57  * @dev see https://github.com/ethereum/EIPs/issues/20
58  */
59 contract ERC20Basic {
60   uint public totalSupply;
61   function balanceOf(address who) constant returns (uint);
62   function transfer(address to, uint value);
63   event Transfer(address indexed from, address indexed to, uint value);
64 }
65 
66 /**
67  * @title ERC20 interface
68  * @dev see https://github.com/ethereum/EIPs/issues/20
69  */
70 contract ERC20 is ERC20Basic {
71   function allowance(address owner, address spender) constant returns (uint);
72   function transferFrom(address from, address to, uint value);
73   function approve(address spender, uint value);
74   event Approval(address indexed owner, address indexed spender, uint value);
75 }
76 
77 /**
78  * @title Basic token
79  * @dev Basic version of StandardToken, with no allowances.
80  */
81 contract BasicToken is ERC20Basic {
82   using SafeMath for uint;
83 
84   mapping(address => uint) balances;
85 
86   /**
87    * @dev Fix for the ERC20 short address attack.
88    */
89   modifier onlyPayloadSize(uint size) {
90      if(msg.data.length < size + 4) {
91        throw;
92      }
93      _;
94   }
95 
96   /**
97   * @dev transfer token for a specified address
98   * @param _to The address to transfer to.
99   * @param _value The amount to be transferred.
100   */
101   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
102     balances[msg.sender] = balances[msg.sender].sub(_value);
103     balances[_to] = balances[_to].add(_value);
104     Transfer(msg.sender, _to, _value);
105   }
106 
107   /**
108   * @dev Gets the balance of the specified address.
109   * @param _owner The address to query the the balance of.
110   * @return An uint representing the amount owned by the passed address.
111   */
112   function balanceOf(address _owner) constant returns (uint balance) {
113     return balances[_owner];
114   }
115 
116 }
117 
118 /**
119  * @title Standard ERC20 token
120  *
121  * @dev Implemantation of the basic standart token.
122  * @dev https://github.com/ethereum/EIPs/issues/20
123  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
124  */
125 contract StandardToken is BasicToken, ERC20 {
126 
127   mapping (address => mapping (address => uint)) allowed;
128 
129 
130   /**
131    * @dev Transfer tokens from one address to another
132    * @param _from address The address which you want to send tokens from
133    * @param _to address The address which you want to transfer to
134    * @param _value uint the amout of tokens to be transfered
135    */
136   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
137     var _allowance = allowed[_from][msg.sender];
138 
139     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
140     // if (_value > _allowance) throw;
141 
142     balances[_to] = balances[_to].add(_value);
143     balances[_from] = balances[_from].sub(_value);
144     allowed[_from][msg.sender] = _allowance.sub(_value);
145     Transfer(_from, _to, _value);
146   }
147 
148   /**
149    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
150    * @param _spender The address which will spend the funds.
151    * @param _value The amount of tokens to be spent.
152    */
153   function approve(address _spender, uint _value) {
154 
155     // To change the approve amount you first have to reduce the addresses`
156     //  allowance to zero by calling `approve(_spender, 0)` if it is not
157     //  already 0 to mitigate the race condition described here:
158     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
160 
161     allowed[msg.sender][_spender] = _value;
162     Approval(msg.sender, _spender, _value);
163   }
164 
165   /**
166    * @dev Function to check the amount of tokens than an owner allowed to a spender.
167    * @param _owner address The address which owns the funds.
168    * @param _spender address The address which will spend the funds.
169    * @return A uint specifing the amount of tokens still avaible for the spender.
170    */
171   function allowance(address _owner, address _spender) constant returns (uint remaining) {
172     return allowed[_owner][_spender];
173   }
174 
175 }
176 
177 /**
178  * @title Feng Shui Coin ERC20 token
179  *
180  * @dev Feng Shui Coin Contract v1.
181  */
182 contract FengShuiCoin is StandardToken {
183 
184     string public name = "Feng Shui Coin";
185     string public symbol = "FSC";
186     //string public version = "FCS1.0";
187     uint public decimals = 18;
188     uint public INITIAL_SUPPLY = 888888888000000000000000000; // 1 billion, 18 decimals
189 
190     function FengShuiCoin() {
191         totalSupply = INITIAL_SUPPLY;
192         balances[msg.sender] = INITIAL_SUPPLY;
193     }
194 }