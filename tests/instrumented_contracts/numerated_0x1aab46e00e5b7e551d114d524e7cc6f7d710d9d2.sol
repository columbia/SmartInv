1 /**
2  *Submitted for verification at Etherscan.io on 2019-01-03
3 */
4 
5 pragma solidity ^0.4.24;
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
13     uint256 c = a * b;
14     assert(a == 0 || c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal constant returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal constant returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 
38 /**
39  * @title Ownable
40  * @dev The Ownable contract has an owner address, and provides basic authorization control
41  * functions, this simplifies the implementation of "user permissions".
42  */
43 contract Ownable {
44   address public owner;
45 
46 
47   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49 
50   /**
51    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
52    * account.
53    */
54   constructor() public{
55     owner = msg.sender;
56   }
57 
58 
59   /**
60    * @dev Throws if called by any account other than the owner.
61    */
62   modifier onlyOwner() {
63     require(msg.sender == owner);
64     _;
65   }
66 
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) onlyOwner public {
73     require(newOwner != address(0));
74     emit OwnershipTransferred(owner, newOwner);
75     owner = newOwner;
76   }
77 }
78 
79 /**
80  * @title ERC20Basic
81  * @dev Simpler version of ERC20 interface
82  * @dev see https://github.com/ethereum/EIPs/issues/179
83  */
84 contract ERC20Basic {
85   uint256 public totalSupply;
86   function balanceOf(address who) public constant returns (uint256);
87   function transfer(address to, uint256 value) public returns (bool);
88   event Transfer(address indexed from, address indexed to, uint256 value);
89 }
90 
91 
92 /**
93  * @title Basic token
94  * @dev Basic version of StandardToken, with no allowances.
95  */
96 contract BasicToken is ERC20Basic {
97   using SafeMath for uint256;
98 
99   mapping(address => uint256) balances;
100 
101   /**
102   * @dev transfer token for a specified address
103   * @param _to The address to transfer to.
104   * @param _value The amount to be transferred.
105   */
106   function transfer(address _to, uint256 _value) public returns (bool) {
107     require(_to != address(0));
108 
109     // SafeMath.sub will throw if there is not enough balance.
110     balances[msg.sender] = balances[msg.sender].sub(_value);
111     balances[_to] = balances[_to].add(_value);
112     emit Transfer(msg.sender, _to, _value);
113     return true;
114   }
115 
116   /**
117   * @dev Gets the balance of the specified address.
118   * @param _owner The address to query the the balance of.
119   * @return An uint256 representing the amount owned by the passed address.
120   */
121   function balanceOf(address _owner) public constant returns (uint256 balance) {
122     return balances[_owner];
123   }
124 }
125 
126 /**
127  * @title ERC20 interface
128  * @dev see https://github.com/ethereum/EIPs/issues/20
129  */
130 contract ERC20 is ERC20Basic {
131   function allowance(address owner, address spender) public constant returns (uint256);
132   function transferFrom(address from, address to, uint256 value) public returns (bool);
133   function approve(address spender, uint256 value) public returns (bool);
134   event Approval(address indexed owner, address indexed spender, uint256 value);
135 }
136 
137 
138 /**
139  * @title Standard ERC20 token
140  *
141  * @dev Implementation of the basic standard token.
142  * @dev https://github.com/ethereum/EIPs/issues/20
143  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
144  */
145 contract StandardToken is ERC20, BasicToken {
146 
147   mapping (address => mapping (address => uint256)) allowed;
148 
149 
150   /**
151    * @dev Transfer tokens from one address to another
152    * @param _from address The address which you want to send tokens from
153    * @param _to address The address which you want to transfer to
154    * @param _value uint256 the amount of tokens to be transferred
155    */
156   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
157     require(_to != address(0));
158 
159     uint256 _allowance = allowed[_from][msg.sender];
160 
161     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
162     // require (_value <= _allowance);
163 
164     balances[_from] = balances[_from].sub(_value);
165     balances[_to] = balances[_to].add(_value);
166     allowed[_from][msg.sender] = _allowance.sub(_value);
167     emit Transfer(_from, _to, _value);
168     return true;
169   }
170 
171   /**
172    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
173    *
174    * Beware that changing an allowance with this method brings the risk that someone may use both the old
175    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
176    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
177    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
178    * @param _spender The address which will spend the funds.
179    * @param _value The amount of tokens to be spent.
180    */
181   function approve(address _spender, uint256 _value) public returns (bool) {
182     allowed[msg.sender][_spender] = _value;
183     emit Approval(msg.sender, _spender, _value);
184     return true;
185   }
186 
187   /**
188    * @dev Function to check the amount of tokens that an owner allowed to a spender.
189    * @param _owner address The address which owns the funds.
190    * @param _spender address The address which will spend the funds.
191    * @return A uint256 specifying the amount of tokens still available for the spender.
192    */
193   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
194     return allowed[_owner][_spender];
195   }
196 
197   /**
198    * approve should be called when allowed[_spender] == 0. To increment
199    * allowed value is better to use this function to avoid 2 calls (and wait until
200    * the first transaction is mined)
201    * From MonolithDAO Token.sol
202    */
203   function increaseApproval (address _spender, uint _addedValue) public
204     returns (bool success)  {
205     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
206     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
207     return true;
208   }
209 
210   function decreaseApproval (address _spender, uint _subtractedValue) public
211     returns (bool success) {
212     uint oldValue = allowed[msg.sender][_spender];
213     if (_subtractedValue > oldValue) {
214       allowed[msg.sender][_spender] = 0;
215     } else {
216       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
217     }
218     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
219     return true;
220   }
221 }
222 
223 
224 /**
225  * @title Burnable Token
226  * @dev Token that can be irreversibly burned (destroyed).
227  */
228 contract BurnableToken is StandardToken, Ownable {
229 
230     event Burn(address indexed burner, uint256 value);
231 
232     /**
233      * @dev Burns a specific amount of tokens.
234      * @param _value The amount of token to be burned.
235      */
236     function burn(uint256 _value) onlyOwner public {
237         require(_value > 0);
238         require(_value <= balances[msg.sender]);
239         // no need to require value <= totalSupply, since that would imply the
240         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
241 
242         address burner = msg.sender;
243         balances[burner] = balances[burner].sub(_value);
244         totalSupply = totalSupply.sub(_value);
245         emit Burn(burner, _value);
246         emit Transfer(burner, address(0), _value);
247     }
248 }
249 
250 contract MdukeyLuckyToken is BurnableToken  {
251 
252     string public constant name = "MDU LUCKY";
253     string public constant symbol = "MDULY";
254     uint public constant decimals = 6;
255     // there is no problem in using * here instead of .mul()
256     uint256 public constant initialSupply = 200000  * (10 ** uint256(decimals));
257 
258     // Constructors
259     constructor() public {
260         totalSupply = initialSupply;
261         balances[msg.sender] = initialSupply; // Send all tokens to owner
262     }
263 
264 }