1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39   uint256 public totalSupply;
40   function balanceOf(address who) public constant returns (uint256);
41   function transfer(address to, uint256 value) public returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 /**
46  * @title Basic token
47  * @dev Basic version of StandardToken, with no allowances.
48  */
49 contract BasicToken is ERC20Basic {
50   using SafeMath for uint256;
51 
52   mapping(address => uint256) balances;
53 
54   /**
55   * @dev transfer token for a specified address
56   * @param _to The address to transfer to.
57   * @param _value The amount to be transferred.
58   */
59   function transfer(address _to, uint256 _value) public returns (bool) {
60     require(_to != address(0));
61 
62     // SafeMath.sub will throw if there is not enough balance.
63     balances[msg.sender] = balances[msg.sender].sub(_value);
64     balances[_to] = balances[_to].add(_value);
65     Transfer(msg.sender, _to, _value);
66     return true;
67   }
68 
69   /**
70   * @dev Gets the balance of the specified address.
71   * @param _owner The address to query the the balance of.
72   * @return An uint256 representing the amount owned by the passed address.
73   */
74   function balanceOf(address _owner) public constant returns (uint256 balance) {
75     return balances[_owner];
76   }
77 
78 }
79 
80 /**
81  * @title ERC20 interface
82  * @dev see https://github.com/ethereum/EIPs/issues/20
83  */
84 contract ERC20 is ERC20Basic {
85   function allowance(address owner, address spender) public constant returns (uint256);
86   function transferFrom(address from, address to, uint256 value) public returns (bool);
87   function approve(address spender, uint256 value) public returns (bool);
88   event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 contract StandardToken is ERC20, BasicToken {
92 
93   mapping (address => mapping (address => uint256)) allowed;
94   bool public isPreSaleReady = false;
95 
96   /**
97    * @dev Transfer tokens from one address to another
98    * @param _from address The address which you want to send tokens from
99    * @param _to address The address which you want to transfer to
100    * @param _value uint256 the amount of tokens to be transferred
101    */
102   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
103     require(_to != address(0));
104 
105     uint256 _allowance = allowed[_from][msg.sender];
106 
107     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
108     // require (_value <= _allowance);
109 
110     balances[_from] = balances[_from].sub(_value);
111     balances[_to] = balances[_to].add(_value);
112     allowed[_from][msg.sender] = _allowance.sub(_value);
113     Transfer(_from, _to, _value);
114     return true;
115   }
116 
117   /**
118    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
119    *
120    * Beware that changing an allowance with this method brings the risk that someone may use both the old
121    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
122    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
123    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
124    * @param _spender The address which will spend the funds.
125    * @param _value The amount of tokens to be spent.
126    */
127   function approve(address _spender, uint256 _value) public returns (bool) {
128     require(isPreSaleReady);
129     allowed[msg.sender][_spender] = _value;
130     Approval(msg.sender, _spender, _value);
131     return true;
132   }
133 
134   /**
135    * @dev Function to check the amount of tokens that an owner allowed to a spender.
136    * @param _owner address The address which owns the funds.
137    * @param _spender address The address which will spend the funds.
138    * @return A uint256 specifying the amount of tokens still available for the spender.
139    */
140   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
141     return allowed[_owner][_spender];
142   }
143 
144   /**
145    * approve should be called when allowed[_spender] == 0. To increment
146    * allowed value is better to use this function to avoid 2 calls (and wait until
147    * the first transaction is mined)
148    * From MonolithDAO Token.sol
149    */
150   function increaseApproval (address _spender, uint _addedValue) returns (bool success) {
151     require(isPreSaleReady);
152     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
153     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
154     return true;
155   }
156 
157   function decreaseApproval (address _spender, uint _subtractedValue) returns (bool success) {
158     require(isPreSaleReady);
159     uint oldValue = allowed[msg.sender][_spender];
160     if (_subtractedValue > oldValue) {
161       allowed[msg.sender][_spender] = 0;
162     } else {
163       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
164     }
165     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
166     return true;
167   }
168 }
169 
170 /**
171  * @title Ownable
172  * @dev The Ownable contract has an owner address, and provides basic authorization control
173  * functions, this simplifies the implementation of "user permissions".
174  */
175 contract Ownable {
176   address public owner;
177 
178   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
179 
180   /**
181    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
182    * account.
183    */
184   function Ownable() {
185     owner = msg.sender;
186   }
187 
188   /**
189    * @dev Throws if called by any account other than the owner.
190    */
191   modifier onlyOwner() {
192     require(msg.sender == owner);
193     _;
194   }
195 
196   /**
197    * @dev Allows the current owner to transfer control of the contract to a newOwner.
198    * @param newOwner The address to transfer ownership to.
199    */
200   function transferOwnership(address newOwner) onlyOwner public {
201     require(newOwner != address(0));
202     OwnershipTransferred(owner, newOwner);
203     owner = newOwner;
204   }
205 }
206 
207 contract Cointeum is StandardToken, Ownable {
208 
209   string public constant name = "Cointeum";
210   string public constant symbol = "CTM";
211   uint8 public constant decimals = 8;
212 
213   uint256 public constant INITIAL_SUPPLY = 12000000 * (8 ** uint256(decimals));
214 
215   event PreSaleReady();
216 
217   function makePresaleReady() onlyOwner public {
218     require(!isPreSaleReady);
219 
220     PreSaleReady();
221 
222     isPreSaleReady = true;
223   }
224 
225   /**
226    * @dev Constructor that gives msg.sender all of existing tokens.
227    */
228   function Cointeum() {
229     totalSupply = INITIAL_SUPPLY;
230     balances[msg.sender] = INITIAL_SUPPLY;
231   }
232 }