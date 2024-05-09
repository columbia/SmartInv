1 pragma solidity ^0.4.21;
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
33 contract Ownable {
34   address public owner;
35 
36   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38   /**
39    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
40    * account.
41    */
42   function Ownable() public {
43     owner = msg.sender;
44   }
45 
46   /**
47    * @dev Throws if called by any account other than the owner.
48    */
49   modifier onlyOwner() {
50     require(msg.sender == owner);
51     _;
52   }
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address newOwner) public onlyOwner {
59     require(newOwner != address(0));
60     emit OwnershipTransferred(owner, newOwner);
61     owner = newOwner;
62   }
63 
64 }
65 
66 /**
67  * @title ERC20Basic
68  */
69 contract ERC20Basic {
70   function totalSupply() public view returns (uint256);
71   function balanceOf(address who) public view returns (uint256);
72   function transfer(address to, uint256 value) public returns (bool);
73   event Transfer(address indexed from, address indexed to, uint256 value);
74 }
75 
76 /**
77  * @title ERC20 interface
78  */
79 contract ERC20 is ERC20Basic {
80   function allowance(address owner, address spender) public view returns (uint256);
81   function transferFrom(address from, address to, uint256 value) public returns (bool);
82   function approve(address spender, uint256 value) public returns (bool);
83   event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 /**
87  * @title Basic token
88  * @dev Basic version of StandardToken, with no allowances.
89  */
90 contract BasicToken is ERC20Basic {
91   using SafeMath for uint256;
92 
93   mapping(address => uint256) balances;
94 
95   uint256 totalSupply_;
96 
97   /**
98   * @dev total number of tokens in existence
99   */
100   function totalSupply() public view returns (uint256) {
101     return totalSupply_;
102   }
103 
104   /**
105   * @dev transfer token for a specified address
106   * @param _to The address to transfer to.
107   * @param _value The amount to be transferred.
108   */
109   function transfer(address _to, uint256 _value) public returns (bool) {
110     require(_to != address(0));
111     require(_value <= balances[msg.sender]);
112 
113     balances[msg.sender] = balances[msg.sender].sub(_value);
114     balances[_to] = balances[_to].add(_value);
115     emit Transfer(msg.sender, _to, _value);
116     return true;
117   }
118 
119   /**
120   * @dev Gets the balance of the specified address.
121   * @param _owner The address to query the the balance of.
122   * @return An uint256 representing the amount owned by the passed address.
123   */
124   function balanceOf(address _owner) public view returns (uint256) {
125     return balances[_owner];
126   }
127 
128 }
129 
130 contract StandardToken is ERC20, BasicToken {
131 
132   mapping (address => mapping (address => uint256)) internal allowed;
133 
134 
135   /**
136    * @dev Transfer tokens from one address to another
137    * @param _from address The address which you want to send tokens from
138    * @param _to address The address which you want to transfer to
139    * @param _value uint256 the amount of tokens to be transferred
140    */
141   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
142     require(_to != address(0));
143     require(_value <= balances[_from]);
144     require(_value <= allowed[_from][msg.sender]);
145 
146     balances[_from] = balances[_from].sub(_value);
147     balances[_to] = balances[_to].add(_value);
148     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
149     emit Transfer(_from, _to, _value);
150     return true;
151   }
152 
153   /**
154    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
155    * @param _spender The address which will spend the funds.
156    * @param _value The amount of tokens to be spent.
157    */
158   function approve(address _spender, uint256 _value) public returns (bool) {
159     allowed[msg.sender][_spender] = _value;
160     emit Approval(msg.sender, _spender, _value);
161     return true;
162   }
163 
164   /**
165    * @dev Function to check the amount of tokens that an owner allowed to a spender.
166    * @param _owner address The address which owns the funds.
167    * @param _spender address The address which will spend the funds.
168    * @return A uint256 specifying the amount of tokens still available for the spender.
169    */
170   function allowance(address _owner, address _spender) public view returns (uint256) {
171     return allowed[_owner][_spender];
172   }
173 
174   /**
175    * @dev Increase the amount of tokens that an owner allowed to a spender.
176    * @param _spender The address which will spend the funds.
177    * @param _addedValue The amount of tokens to increase the allowance by.
178    */
179   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
180     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
181     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
182     return true;
183   }
184 
185   /**
186    * @dev Decrease the amount of tokens that an owner allowed to a spender.
187    * @param _spender The address which will spend the funds.
188    * @param _subtractedValue The amount of tokens to decrease the allowance by.
189    */
190   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
191     uint oldValue = allowed[msg.sender][_spender];
192     if (_subtractedValue > oldValue) {
193       allowed[msg.sender][_spender] = 0;
194     } else {
195       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
196     }
197     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
198     return true;
199   }
200 
201 }
202 
203 /**
204  * @title Mintable token
205  * @dev Simple ERC20 Token example, with mintable token creation
206  */
207 contract MintableToken is StandardToken, Ownable {
208   event Mint(address indexed to, uint256 amount);
209   event MintFinished();
210 
211   bool public mintingFinished = false;
212 
213 
214   modifier canMint() {
215     require(!mintingFinished);
216     _;
217   }
218 
219   /**
220    * @dev Function to mint tokens
221    * @param _to The address that will receive the minted tokens.
222    * @param _amount The amount of tokens to mint.
223    * @return A boolean that indicates if the operation was successful.
224    */
225   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
226     totalSupply_ = totalSupply_.add(_amount);
227     balances[_to] = balances[_to].add(_amount);
228     emit Mint(_to, _amount);
229     emit Transfer(address(0), _to, _amount);
230     return true;
231   }
232 
233   /**
234    * @dev Function to stop minting new tokens.
235    * @return True if the operation was successful.
236    */
237   function finishMinting() onlyOwner canMint public returns (bool) {
238     mintingFinished = true;
239     emit MintFinished();
240     return true;
241   }
242 }
243 
244 /**
245  * @title Burnable Token
246  * @dev Token that can be irreversibly burned (destroyed).
247  */
248 contract BurnableToken is BasicToken {
249 
250   event Burn(address indexed burner, uint256 value);
251 
252   /**
253    * @dev Burns a specific amount of tokens.
254    * @param _value The amount of token to be burned.
255    */
256   function burn(uint256 _value) public {
257     _burn(msg.sender, _value);
258   }
259 
260   function _burn(address _who, uint256 _value) internal {
261     require(_value <= balances[_who]);
262     // no need to require value <= totalSupply, since that would imply the
263     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
264 
265     balances[_who] = balances[_who].sub(_value);
266     totalSupply_ = totalSupply_.sub(_value);
267     emit Burn(_who, _value);
268     emit Transfer(_who, address(0), _value);
269   }
270 }
271 
272 contract PGGToken is BurnableToken, MintableToken {
273     string public name = "PGG Token";
274     string public symbol = "PGG";
275     uint public decimals = 18;
276 }