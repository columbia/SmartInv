1 pragma solidity ^0.4.17;
2 
3 
4 
5 /**
6  * Math operations with safety checks
7  */
8 library SafeMath {
9   function mul(uint a, uint b) internal returns (uint) {
10     uint c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint a, uint b) internal returns (uint) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint a, uint b) internal returns (uint) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint a, uint b) internal returns (uint) {
28     uint c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 
33   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
34     return a >= b ? a : b;
35   }
36 
37   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
38     return a < b ? a : b;
39   }
40 
41   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
42     return a >= b ? a : b;
43   }
44 
45   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
46     return a < b ? a : b;
47   }
48 
49   function assert(bool assertion) internal {
50     if (!assertion) {
51       throw;
52     }
53   }
54 }
55 
56 
57 /**
58  * @title ERC20Basic
59  * @dev Simpler version of ERC20 interface
60  * @dev see https://github.com/ethereum/EIPs/issues/20
61  */
62 contract ERC20Basic {
63   uint public totalSupply;
64   function balanceOf(address who) constant returns (uint);
65   function transfer(address to, uint value) returns (bool);
66   event Transfer(address indexed from, address indexed to, uint value);
67 }
68 
69 
70 
71 
72 /**
73  * @title Basic token
74  * @dev Basic version of StandardToken, with no allowances. 
75  */
76 contract BasicToken is ERC20Basic {
77   using SafeMath for uint;
78 
79   mapping(address => uint) balances;
80 
81   /**
82    * @dev Fix for the ERC20 short address attack.
83    */
84   modifier onlyPayloadSize(uint size) {
85      if(msg.data.length < size + 4) {
86        throw;
87      }
88      _;
89   }
90 
91   /**
92   * @dev transfer token for a specified address
93   * @param _to The address to transfer to.
94   * @param _value The amount to be transferred.
95   */
96   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool){
97     require(_to != address(0));
98     require(_value <= balances[msg.sender]);
99 
100     balances[msg.sender] = balances[msg.sender].sub(_value);
101     balances[_to] = balances[_to].add(_value);
102     Transfer(msg.sender, _to, _value);
103     return true;
104   }
105 
106   /**
107   * @dev Gets the balance of the specified address.
108   * @param _owner The address to query the the balance of. 
109   * @return An uint representing the amount owned by the passed address.
110   */
111   function balanceOf(address _owner) constant returns (uint balance) {
112     return balances[_owner];
113   }
114 
115 }
116 
117 
118 
119 
120 /**
121  * @title ERC20 interface
122  * @dev see https://github.com/ethereum/EIPs/issues/20
123  */
124 contract ERC20 is ERC20Basic {
125   function allowance(address owner, address spender) constant returns (uint);
126   function transferFrom(address from, address to, uint value) returns (bool);
127   function approve(address spender, uint value) returns (bool);
128   event Approval(address indexed owner, address indexed spender, uint value);
129 }
130 
131 
132 
133 
134 /**
135  * @title Standard ERC20 token
136  *
137  * @dev Implemantation of the basic standart token.
138  * @dev https://github.com/ethereum/EIPs/issues/20
139  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
140  */
141 contract StandardToken is BasicToken, ERC20 {
142 
143   mapping (address => mapping (address => uint)) allowed;
144 
145 
146   /**
147    * @dev Transfer tokens from one address to another
148    * @param _from address The address which you want to send tokens from
149    * @param _to address The address which you want to transfer to
150    * @param _value uint the amout of tokens to be transfered
151    */
152   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) returns (bool) {
153     var _allowance = allowed[_from][msg.sender];
154 
155     require(_to != address(0));
156     require(_value <= balances[_from]);
157     require(_value <= _allowance);
158 
159     balances[_to] = balances[_to].add(_value);
160     balances[_from] = balances[_from].sub(_value);
161     allowed[_from][msg.sender] = _allowance.sub(_value);
162     Transfer(_from, _to, _value);
163 
164     return true;
165   }
166 
167   /**
168    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
169    * @param _spender The address which will spend the funds.
170    * @param _value The amount of tokens to be spent.
171    */
172   function approve(address _spender, uint _value) returns (bool) {
173 
174     // To change the approve amount you first have to reduce the addresses`
175     //  allowance to zero by calling `approve(_spender, 0)` if it is not
176     //  already 0 to mitigate the race condition described here:
177     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
178     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
179 
180     allowed[msg.sender][_spender] = _value;
181     Approval(msg.sender, _spender, _value);
182 
183     return true;
184   }
185 
186   /**
187    * @dev Function to check the amount of tokens than an owner allowed to a spender.
188    * @param _owner address The address which owns the funds.
189    * @param _spender address The address which will spend the funds.
190    * @return A uint specifing the amount of tokens still avaible for the spender.
191    */
192   function allowance(address _owner, address _spender) constant returns (uint remaining) {
193     return allowed[_owner][_spender];
194   }
195 
196 }
197 
198 contract CrypviserToken is StandardToken {
199   //FIELDS
200   string public constant name = "CVCOIN ERC20";
201   string public constant symbol = "CVN";
202   uint8   public constant decimals = 5;
203 
204   //CONSTANTS
205   //CVN Token limit
206   uint256 public constant TOTAL_SUPPLY = 15e6 * (10 ** uint256(decimals));
207   
208   //ASSIGNED IN INITIALIZATION
209   //Special Addresses
210   address public openLedgerAddress;
211 
212   function CrypviserToken(address _openLedger) {
213     openLedgerAddress = _openLedger;
214     mint(openLedgerAddress, TOTAL_SUPPLY);
215   }
216 
217   function mint(address _to, uint256 _value) private {
218     totalSupply = totalSupply.add(_value);
219     balances[_to] = balances[_to].add(_value);
220 
221     Transfer(0x0, _to, _value);
222   }
223 }