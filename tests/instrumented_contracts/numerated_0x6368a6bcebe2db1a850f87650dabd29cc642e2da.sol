1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public view returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 contract DetailedERC20 is ERC20 {
27   string public name;
28   string public symbol;
29   uint8 public decimals;
30 
31   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
32     name = _name;
33     symbol = _symbol;
34     decimals = _decimals;
35   }
36 }
37 
38 /**
39  * @title SafeMath
40  * @dev Math operations with safety checks that throw on error
41  */
42 library SafeMath {
43 
44   /**
45   * @dev Multiplies two numbers, throws on overflow.
46   */
47   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48     if (a == 0) {
49       return 0;
50     }
51     uint256 c = a * b;
52     assert(c / a == b);
53     return c;
54   }
55 
56   /**
57   * @dev Integer division of two numbers, truncating the quotient.
58   */
59   function div(uint256 a, uint256 b) internal pure returns (uint256) {
60     // assert(b > 0); // Solidity automatically throws when dividing by 0
61     uint256 c = a / b;
62     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
63     return c;
64   }
65 
66   /**
67   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
68   */
69   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70     assert(b <= a);
71     return a - b;
72   }
73 
74   /**
75   * @dev Adds two numbers, throws on overflow.
76   */
77   function add(uint256 a, uint256 b) internal pure returns (uint256) {
78     uint256 c = a + b;
79     assert(c >= a);
80     return c;
81   }
82 }
83 
84 /**
85  * @title Basic token
86  * @dev Basic version of StandardToken, with no allowances.
87  */
88 contract BasicToken is ERC20Basic {
89   using SafeMath for uint256;
90 
91   mapping(address => uint256) balances;
92 
93   uint256 totalSupply_;
94 
95   /**
96   * @dev total number of tokens in existence
97   */
98   function totalSupply() public view returns (uint256) {
99     return totalSupply_;
100   }
101 
102   /**
103   * @dev transfer token for a specified address
104   * @param _to The address to transfer to.
105   * @param _value The amount to be transferred.
106   */
107   function transfer(address _to, uint256 _value) public returns (bool) {
108     require(_to != address(0));
109     require(_value <= balances[msg.sender]);
110 
111     // SafeMath.sub will throw if there is not enough balance.
112     balances[msg.sender] = balances[msg.sender].sub(_value);
113     balances[_to] = balances[_to].add(_value);
114     Transfer(msg.sender, _to, _value);
115     return true;
116   }
117 
118   /**
119   * @dev Gets the balance of the specified address.
120   * @param _owner The address to query the the balance of.
121   * @return An uint256 representing the amount owned by the passed address.
122   */
123   function balanceOf(address _owner) public view returns (uint256 balance) {
124     return balances[_owner];
125   }
126 
127 }
128 
129 /**
130  * @title Standard ERC20 token
131  *
132  * @dev Implementation of the basic standard token.
133  * @dev https://github.com/ethereum/EIPs/issues/20
134  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
135  */
136 contract StandardToken is ERC20, BasicToken {
137 
138   mapping (address => mapping (address => uint256)) internal allowed;
139 
140 
141   /**
142    * @dev Transfer tokens from one address to another
143    * @param _from address The address which you want to send tokens from
144    * @param _to address The address which you want to transfer to
145    * @param _value uint256 the amount of tokens to be transferred
146    */
147   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
148     require(_to != address(0));
149     require(_value <= balances[_from]);
150     require(_value <= allowed[_from][msg.sender]);
151 
152     balances[_from] = balances[_from].sub(_value);
153     balances[_to] = balances[_to].add(_value);
154     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
155     Transfer(_from, _to, _value);
156     return true;
157   }
158 
159   /**
160    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
161    *
162    * Beware that changing an allowance with this method brings the risk that someone may use both the old
163    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
164    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
165    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
166    * @param _spender The address which will spend the funds.
167    * @param _value The amount of tokens to be spent.
168    */
169   function approve(address _spender, uint256 _value) public returns (bool) {
170     allowed[msg.sender][_spender] = _value;
171     Approval(msg.sender, _spender, _value);
172     return true;
173   }
174 
175   /**
176    * @dev Function to check the amount of tokens that an owner allowed to a spender.
177    * @param _owner address The address which owns the funds.
178    * @param _spender address The address which will spend the funds.
179    * @return A uint256 specifying the amount of tokens still available for the spender.
180    */
181   function allowance(address _owner, address _spender) public view returns (uint256) {
182     return allowed[_owner][_spender];
183   }
184 
185   /**
186    * @dev Increase the amount of tokens that an owner allowed to a spender.
187    *
188    * approve should be called when allowed[_spender] == 0. To increment
189    * allowed value is better to use this function to avoid 2 calls (and wait until
190    * the first transaction is mined)
191    * From MonolithDAO Token.sol
192    * @param _spender The address which will spend the funds.
193    * @param _addedValue The amount of tokens to increase the allowance by.
194    */
195   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
196     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
197     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
198     return true;
199   }
200 
201   /**
202    * @dev Decrease the amount of tokens that an owner allowed to a spender.
203    *
204    * approve should be called when allowed[_spender] == 0. To decrement
205    * allowed value is better to use this function to avoid 2 calls (and wait until
206    * the first transaction is mined)
207    * From MonolithDAO Token.sol
208    * @param _spender The address which will spend the funds.
209    * @param _subtractedValue The amount of tokens to decrease the allowance by.
210    */
211   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
212     uint oldValue = allowed[msg.sender][_spender];
213     if (_subtractedValue > oldValue) {
214       allowed[msg.sender][_spender] = 0;
215     } else {
216       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
217     }
218     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
219     return true;
220   }
221 
222 }
223 
224 /**
225  * @title Burnable Token
226  * @dev Token that can be irreversibly burned (destroyed).
227  */
228 contract BurnableToken is BasicToken {
229 
230   event Burn(address indexed burner, uint256 value);
231 
232   /**
233    * @dev Burns a specific amount of tokens.
234    * @param _value The amount of token to be burned.
235    */
236   function burn(uint256 _value) public {
237     require(_value <= balances[msg.sender]);
238     // no need to require value <= totalSupply, since that would imply the
239     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
240 
241     address burner = msg.sender;
242     balances[burner] = balances[burner].sub(_value);
243     totalSupply_ = totalSupply_.sub(_value);
244     Burn(burner, _value);
245     Transfer(burner, address(0), _value);
246   }
247 }
248 
249 contract Cryptonationz is DetailedERC20, StandardToken, BurnableToken {
250 
251     uint256 public publicAllocation;
252     uint256 public companyAllocation;
253     uint256 public devAllocation;
254     uint256 public advisorsAllocation;
255     uint256 public reservedAllocation;
256 
257     function Cryptonationz
258     (
259         string _name,
260         string _symbol,
261         uint8 _decimals,
262         address _pubAddress,
263         address _compAddress,
264         address _devAddress,
265         address _advAddress,
266         address _reserveAddress
267     ) 
268     DetailedERC20(_name, _symbol, _decimals)
269     public
270     {
271         require(_pubAddress != address(0) && _compAddress != address(0) && _devAddress != address(0));
272         require(_advAddress != address(0) && _reserveAddress != address(0));
273 
274         totalSupply_ = 400000000 * (10 ** uint256(_decimals));
275 
276         publicAllocation = (70 * totalSupply_) / 100;
277         companyAllocation = (10 * totalSupply_) / 100;
278         devAllocation = (10 * totalSupply_) / 100;
279         advisorsAllocation = (5 * totalSupply_) / 100;
280         reservedAllocation = (5 * totalSupply_) / 100;
281 
282         _allocation(_pubAddress, _compAddress, _devAddress, _advAddress, _reserveAddress);
283 
284     }
285 
286     function _allocation(address _pubAddress, address _compAddress, address _devAddress, address _advAddress, address _reserveAddress) internal {
287         balances[_pubAddress] = balances[_pubAddress].add(publicAllocation);
288         balances[_compAddress] = balances[_compAddress].add(companyAllocation);
289         balances[_devAddress] = balances[_devAddress].add(devAllocation);
290         balances[_advAddress] = balances[_advAddress].add(advisorsAllocation);
291         balances[_reserveAddress] = balances[_reserveAddress].add(reservedAllocation);
292 
293         Transfer(address(0), _pubAddress, publicAllocation);
294         Transfer(address(0), _compAddress, companyAllocation);
295         Transfer(address(0), _devAddress, devAllocation);
296         Transfer(address(0), _advAddress, advisorsAllocation);
297         Transfer(address(0), _reserveAddress, reservedAllocation);
298     }
299 
300 
301 }