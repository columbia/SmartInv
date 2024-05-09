1 pragma solidity ^0.4.16;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   /**
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() {
17     owner = msg.sender;
18   }
19 
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to.
33    */
34   function transferOwnership(address newOwner) onlyOwner {
35     if (newOwner != address(0)) {
36       owner = newOwner;
37     }
38   }
39 
40 }
41 
42 
43 contract Saleable is Ownable {
44   event Sale();
45   event Unsale();
46 
47   bool public saled = false;
48 
49   modifier whenNotSaled() {
50     require(!saled);
51     _;
52   }
53 
54   modifier whenSaled {
55     require(saled);
56     _;
57   }
58 
59   function sale() onlyOwner whenNotSaled returns (bool) {
60     saled = true;
61     Sale();
62     return true;
63   }
64 
65   /**
66    * @dev called by the owner to unpause, returns to normal state
67    */
68   function unsale() onlyOwner whenSaled returns (bool) {
69     saled = false;
70     Unsale();
71     return true;
72   }
73 }
74 
75 /**
76  * @title SafeMath
77  * @dev Math operations with safety checks that throw on error
78  */
79 library SafeMath {
80   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
81     uint256 c = a * b;
82     assert(a == 0 || c / a == b);
83     return c;
84   }
85 
86   function div(uint256 a, uint256 b) internal constant returns (uint256) {
87     // assert(b > 0); // Solidity automatically throws when dividing by 0
88     uint256 c = a / b;
89     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90     return c;
91   }
92 
93   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
94     assert(b <= a);
95     return a - b;
96   }
97 
98   function add(uint256 a, uint256 b) internal constant returns (uint256) {
99     uint256 c = a + b;
100     assert(c >= a);
101     return c;
102   }
103 }
104 
105 
106 /**
107  * @title ERC20Basic
108  * @dev Simpler version of ERC20 interface
109  * @dev see https://github.com/ethereum/EIPs/issues/179
110  */
111 contract ERC20Basic {
112   uint256 public totalSupply;
113   function balanceOf(address who) constant returns (uint256);
114   function transfer(address to, uint256 value) returns (bool);
115   event Transfer(address indexed from, address indexed to, uint256 value);
116 }
117 
118 /**
119  * @title ERC20 interface
120  * @dev see https://github.com/ethereum/EIPs/issues/20
121  */
122 contract ERC20 is ERC20Basic {
123   function allowance(address owner, address spender) constant returns (uint256);
124   function transferFrom(address from, address to, uint256 value) returns (bool);
125   function approve(address spender, uint256 value) returns (bool);
126   event Approval(address indexed owner, address indexed spender, uint256 value);
127 }
128 
129 /**
130  * @title Basic token
131  * @dev Basic version of StandardToken, with no allowances.
132  */
133 contract BasicToken is ERC20Basic {
134   using SafeMath for uint256;
135 
136   mapping(address => uint256) balances;
137 
138   /**
139   * @dev transfer token for a specified address
140   * @param _to The address to transfer to.
141   * @param _value The amount to be transferred.
142   */
143   function transfer(address _to, uint256 _value) returns (bool) 
144   {
145     require(_to != address(0));
146     require(_value <= balances[msg.sender]);
147 
148     balances[msg.sender] = balances[msg.sender].sub(_value);
149     balances[_to] = balances[_to].add(_value);
150     Transfer(msg.sender, _to, _value);
151     return true;
152   }
153 
154   /**
155   * @dev Gets the balance of the specified address.
156   * @param _owner The address to query the the balance of.
157   * @return An uint256 representing the amount owned by the passed address.
158   */
159   function balanceOf(address _owner) constant returns (uint256 balance) {
160     return balances[_owner];
161   }
162 
163 }
164 
165 
166 /**
167  * @title Standard ERC20 token
168  *
169  * @dev Implementation of the basic standard token.
170  * @dev https://github.com/ethereum/EIPs/issues/20
171  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
172  */
173 contract StandardToken is ERC20, BasicToken {
174 
175   mapping (address => mapping (address => uint256)) allowed;
176 
177 
178   /**
179    * @dev Transfer tokens from one address to another
180    * @param _from address The address which you want to send tokens from
181    * @param _to address The address which you want to transfer to
182    * @param _value uint256 the amout of tokens to be transfered
183    */
184   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
185     require(_to != address(0));
186     require(_value <= balances[_from]);
187  
188     var _allowance = allowed[_from][msg.sender];
189 
190     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
191     // require (_value <= _allowance);
192 
193     balances[_to] = balances[_to].add(_value);
194     balances[_from] = balances[_from].sub(_value);
195     allowed[_from][msg.sender] = _allowance.sub(_value);
196     Transfer(_from, _to, _value);
197     return true;
198   }
199 
200   /**
201    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
202    * @param _spender The address which will spend the funds.
203    * @param _value The amount of tokens to be spent.
204    */
205   function approve(address _spender, uint256 _value) returns (bool) {
206 
207     // To change the approve amount you first have to reduce the addresses`
208     //  allowance to zero by calling `approve(_spender, 0)` if it is not
209     //  already 0 to mitigate the race condition described here:
210     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
211     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
212 
213     allowed[msg.sender][_spender] = _value;
214     Approval(msg.sender, _spender, _value);
215     return true;
216   }
217 
218   /**
219    * @dev Function to check the amount of tokens that an owner allowed to a spender.
220    * @param _owner address The address which owns the funds.
221    * @param _spender address The address which will spend the funds.
222    * @return A uint256 specifing the amount of tokens still avaible for the spender.
223    */
224   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
225     return allowed[_owner][_spender];
226   }
227 
228 }
229 
230 contract O2OToken is StandardToken, Saleable {
231 	string public name; 
232     string public symbol; 
233     uint8 public decimals = 18; 
234     uint256 public totalSupply;
235 
236 	function O2OToken( uint256 initialSupply, string tokenName, string tokenSymbol) public {
237 		totalSupply = initialSupply * 10 ** uint256(decimals);
238 		balances[msg.sender] = totalSupply;  
239 		name = tokenName;
240 		symbol = tokenSymbol;
241 	}
242 	
243 	function transferOwner(address dst, uint wad) onlyOwner external {
244         super.transfer(dst, wad);
245     }
246     
247 	function transfer(address dst, uint wad) whenSaled returns (bool) {
248         return super.transfer(dst, wad);
249     }
250     function transferFrom(address src, address dst, uint wad ) whenSaled returns (bool) {
251         return super.transferFrom(src, dst, wad);
252     }
253 }