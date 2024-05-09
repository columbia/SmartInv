1 pragma solidity ^0.4.11;
2 
3 
4 
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control 
9  * functions, this simplifies the implementation of "user permissions". 
10  */
11 contract Ownable {
12   address public owner;
13 
14 
15   /** 
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner. 
26    */
27   modifier onlyOwner() {
28     if (msg.sender != owner) {
29       throw;
30     }
31     _;
32   }
33 
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to. 
38    */
39   function transferOwnership(address newOwner) onlyOwner {
40     if (newOwner != address(0)) {
41       owner = newOwner;
42     }
43   }
44 
45 }
46 
47 
48 /**
49  * Math operations with safety checks
50  */
51 library SafeMath {
52   function mul(uint a, uint b) internal returns (uint) {
53     uint c = a * b;
54     assert(a == 0 || c / a == b);
55     return c;
56   }
57 
58   function div(uint a, uint b) internal returns (uint) {
59     // assert(b > 0); // Solidity automatically throws when dividing by 0
60     uint c = a / b;
61     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
62     return c;
63   }
64 
65   function sub(uint a, uint b) internal returns (uint) {
66     assert(b <= a);
67     return a - b;
68   }
69 
70   function add(uint a, uint b) internal returns (uint) {
71     uint c = a + b;
72     assert(c >= a);
73     return c;
74   }
75 
76   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
77     return a >= b ? a : b;
78   }
79 
80   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
81     return a < b ? a : b;
82   }
83 
84   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
85     return a >= b ? a : b;
86   }
87 
88   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
89     return a < b ? a : b;
90   }
91 
92   function assert(bool assertion) internal {
93     if (!assertion) {
94       throw;
95     }
96   }
97 }
98 
99 
100 /**
101  * @title ERC20Basic
102  * @dev Simpler version of ERC20 interface
103  * @dev see https://github.com/ethereum/EIPs/issues/20
104  */
105 contract ERC20Basic {
106   uint public totalSupply;
107   function balanceOf(address who) constant returns (uint);
108   function transfer(address to, uint value);
109   event Transfer(address indexed from, address indexed to, uint value);
110 }
111 
112 contract ERC20 is ERC20Basic {
113   function allowance(address owner, address spender) constant returns (uint);
114   function transferFrom(address from, address to, uint value);
115   function approve(address spender, uint value);
116   event Approval(address indexed owner, address indexed spender, uint value);
117 }
118 
119 /**
120  * @title Basic token
121  * @dev Basic version of StandardToken, with no allowances. 
122  */
123 contract BasicToken is ERC20Basic {
124   using SafeMath for uint;
125 
126   mapping(address => uint) balances;
127 
128   /**
129    * @dev Fix for the ERC20 short address attack.
130    */
131   modifier onlyPayloadSize(uint size) {
132      if(msg.data.length < size + 4) {
133        throw;
134      }
135      _;
136   }
137 
138   /**
139   * @dev transfer token for a specified address
140   * @param _to The address to transfer to.
141   * @param _value The amount to be transferred.
142   */
143   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
144     balances[msg.sender] = balances[msg.sender].sub(_value);
145     balances[_to] = balances[_to].add(_value);
146     Transfer(msg.sender, _to, _value);
147   }
148 
149   /**
150   * @dev Gets the balance of the specified address.
151   * @param _owner The address to query the the balance of. 
152   * @return An uint representing the amount owned by the passed address.
153   */
154   function balanceOf(address _owner) constant returns (uint balance) {
155     return balances[_owner];
156   }
157 
158 }
159 
160 /**
161  * @title Standard ERC20 token
162  *
163  * @dev Implemantation of the basic standart token.
164  * @dev https://github.com/ethereum/EIPs/issues/20
165  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
166  */
167 contract StandardToken is BasicToken, ERC20 {
168 
169   mapping (address => mapping (address => uint)) allowed;
170 
171 
172   /**
173    * @dev Transfer tokens from one address to another
174    * @param _from address The address which you want to send tokens from
175    * @param _to address The address which you want to transfer to
176    * @param _value uint the amout of tokens to be transfered
177    */
178   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
179     var _allowance = allowed[_from][msg.sender];
180 
181     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
182     // if (_value > _allowance) throw;
183 
184     balances[_to] = balances[_to].add(_value);
185     balances[_from] = balances[_from].sub(_value);
186     allowed[_from][msg.sender] = _allowance.sub(_value);
187     Transfer(_from, _to, _value);
188   }
189 
190   /**
191    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
192    * @param _spender The address which will spend the funds.
193    * @param _value The amount of tokens to be spent.
194    */
195   function approve(address _spender, uint _value) {
196 
197     // To change the approve amount you first have to reduce the addresses`
198     //  allowance to zero by calling `approve(_spender, 0)` if it is not
199     //  already 0 to mitigate the race condition described here:
200     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
201     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
202 
203     allowed[msg.sender][_spender] = _value;
204     Approval(msg.sender, _spender, _value);
205   }
206 
207   /**
208    * @dev Function to check the amount of tokens than an owner allowed to a spender.
209    * @param _owner address The address which owns the funds.
210    * @param _spender address The address which will spend the funds.
211    * @return A uint specifing the amount of tokens still avaible for the spender.
212    */
213   function allowance(address _owner, address _spender) constant returns (uint remaining) {
214     return allowed[_owner][_spender];
215   }
216 
217 }
218 
219 
220 /**
221  * @title SimpleToken
222  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
223  * Note they can later distribute these tokens as they wish using `transfer` and other
224  * `StandardToken` functions.
225  */
226 contract RBCToken is StandardToken, Ownable {
227 
228   string public name = "RBCToken";
229   string public symbol = "RBC";
230   uint public decimals = 18;
231   uint public INITIAL_SUPPLY = 100000000 * 1000000000000000000;
232 
233   /**
234    * @dev Contructor that gives msg.sender all of existing tokens.
235    */
236   function RBCToken() {
237     totalSupply = INITIAL_SUPPLY;
238     balances[msg.sender] = INITIAL_SUPPLY;
239   }
240 
241 }