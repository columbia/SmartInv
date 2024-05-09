1 pragma solidity ^0.4.11;
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
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39 
40   address public owner;
41 
42   /**
43    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
44    * account.
45    */
46   function Ownable() {
47     owner = msg.sender;
48   }
49 
50   /**
51    * @dev Throws if called by any account other than the owner.
52    */
53   modifier onlyOwner() {
54     require(msg.sender == owner);
55     _;
56   }
57 
58   /**
59    * @dev Allows the current owner to transfer control of the contract to a newOwner.
60    * @param newOwner The address to transfer ownership to.
61    */
62   function transferOwnership(address newOwner) onlyOwner {
63     require(newOwner != address(0));
64     owner = newOwner;
65   }
66 }
67 
68 /**
69  * @title ERC20Basic
70  * @dev Simpler version of ERC20 interface
71  * @dev see https://github.com/ethereum/EIPs/issues/179
72  */
73 contract ERC20Basic is Ownable {
74   uint256 public totalSupply;
75   function balanceOf(address who) public constant returns (uint256);
76   function transfer(address to, uint256 value) public returns (bool);
77   event Transfer(address indexed from, address indexed to, uint256 value);
78 }
79 
80 /**
81  * @title Basic token
82  * @dev Basic version of StandardToken, with no allowances.
83  */
84 contract BasicToken is ERC20Basic {
85   using SafeMath for uint256;
86 
87   mapping(address => uint256) balances;
88   uint256 public constant START = 1521371400;
89 
90     function isActive() constant returns (bool) {
91         return (
92             now >= START
93         );
94     }
95     
96     modifier whenSaleIsActive() {
97         // Check if sale is active
98         assert(isActive());
99 
100         _;
101     }
102     
103     
104     
105   /**
106   * @dev transfer token for a specified address
107   * @param _to The address to transfer to.
108   * @param _value The amount to be transferred.
109   */
110   function transfer(address _to, uint256 _value) public returns (bool) {
111     require(now > 1526382000 || msg.sender == owner);
112 
113     balances[msg.sender] = balances[msg.sender].sub(_value);
114     balances[_to] = balances[_to].add(_value);
115     Transfer(msg.sender, _to, _value);
116     return true;
117   }
118 
119   /**
120   * @dev Gets the balance of the specified address.
121   * @param _owner The address to query the the balance of.
122   * @return An uint256 representing the amount owned by the passed address.
123   */
124   function balanceOf(address _owner) public constant returns (uint256 balance) {
125     return balances[_owner];
126   }
127 
128 }
129 
130 /**
131  * @title ERC20 interface
132  * @dev see https://github.com/ethereum/EIPs/issues/20
133  */
134 contract ERC20 is ERC20Basic {
135   function allowance(address owner, address spender) constant returns (uint256);
136   function transferFrom(address from, address to, uint256 value) returns (bool);
137   function approve(address spender, uint256 value) returns (bool);
138   event Approval(address indexed owner, address indexed spender, uint256 value);
139 }
140 
141 /**
142  * @title Standard ERC20 token
143  *
144  * @dev Implementation of the basic standard token.
145  * @dev https://github.com/ethereum/EIPs/issues/20
146  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
147  */
148 contract StandardToken is ERC20, BasicToken {
149 
150   mapping (address => mapping (address => uint256)) allowed;
151 
152 
153     event Burn(address indexed burner, uint256 value);
154 
155   /**
156    * @dev Burns a specific amount of tokens.
157    * @param _value The amount of token to be burned.
158    */
159   function burn(uint256 _value) public {
160     require(_value <= balances[msg.sender]);
161     // no need to require value <= totalSupply, since that would imply the
162     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
163 
164     address burner = msg.sender;
165     balances[burner] = balances[burner].sub(_value);
166     totalSupply = totalSupply.sub(_value);
167     Burn(burner, _value);
168     Transfer(burner, address(0), _value);
169   }
170 
171   /**
172    * @dev Transfer tokens from one address to another
173    * @param _from address The address which you want to send tokens from
174    * @param _to address The address which you want to transfer to
175    * @param _value uint256 the amout of tokens to be transfered
176    */
177   function transferFrom(address _from, address _to, uint256 _value) whenSaleIsActive public returns (bool) {
178     require(now > 1526382000 || msg.sender == owner);
179     require(_to != address(0));
180     require(_value <= balances[_from]);
181     require(_value <= allowed[_from][msg.sender]);
182 
183     balances[_from] = balances[_from].sub(_value);
184     balances[_to] = balances[_to].add(_value);
185     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
186     Transfer(_from, _to, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
192    * @param _spender The address which will spend the funds.
193    * @param _value The amount of tokens to be spent.
194    */
195   function approve(address _spender, uint256 _value) public returns (bool) {
196 
197     // To change the approve amount you first have to reduce the addresses`
198     //  allowance to zero by calling `approve(_spender, 0)` if it is not
199     //  already 0 to mitigate the race condition described here:
200     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
201     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
202 
203     allowed[msg.sender][_spender] = _value;
204     Approval(msg.sender, _spender, _value);
205     return true;
206   }
207 
208   /**
209    * @dev Function to check the amount of tokens that an owner allowed to a spender.
210    * @param _owner address The address which owns the funds.
211    * @param _spender address The address which will spend the funds.
212    * @return A uint256 specifing the amount of tokens still available for the spender.
213    */
214   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
215     return allowed[_owner][_spender];
216   }
217 
218 }
219 
220 
221 /**
222  * @title SimpleToken
223  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
224  * Note they can later distribute these tokens as they wish using `transfer` and other
225  * `StandardToken` functions.
226  */
227 contract DigitalTicks is StandardToken {
228 
229   string public constant name = "DigitalTicks";
230   string public constant symbol = "DTX";
231   uint256 public constant decimals = 18;
232 
233   uint256 public constant INITIAL_SUPPLY = 128000000 * 10**18;
234 
235   /**
236    * @dev Contructor that gives msg.sender all of existing tokens.
237    */
238   function DigitalTicks() {
239     totalSupply = INITIAL_SUPPLY;
240     balances[msg.sender] = INITIAL_SUPPLY;
241   }
242 }