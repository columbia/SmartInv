1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) public view returns (uint256);
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 library SafeERC20 {
18     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
19         assert(token.transfer(to, value));
20     }
21 
22     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
23         assert(token.transferFrom(from, to, value));
24     }
25 
26     function safeApprove(ERC20 token, address spender, uint256 value) internal {
27         assert(token.approve(spender, value));
28     }
29 }
30 
31 contract BasicToken is ERC20Basic {
32   using SafeMath for uint256;
33 
34   mapping(address => uint256) balances;
35 
36   uint256 totalSupply_;
37 
38   /**
39   * @dev total number of tokens in existence
40   */
41   function totalSupply() public view returns (uint256) {
42     return totalSupply_;
43   }
44 
45   /**
46   * @dev transfer token for a specified address
47   * @param _to The address to transfer to.
48   * @param _value The amount to be transferred.
49   */
50   function transfer(address _to, uint256 _value) public returns (bool) {
51     require(_to != address(0));
52     require(_value <= balances[msg.sender]);
53 
54     // SafeMath.sub will throw if there is not enough balance.
55     balances[msg.sender] = balances[msg.sender].sub(_value);
56     balances[_to] = balances[_to].add(_value);
57     emit Transfer(msg.sender, _to, _value);
58     return true;
59   }
60 
61   /**
62   * @dev Gets the balance of the specified address.
63   * @param _owner The address to query the the balance of.
64   * @return An uint256 representing the amount owned by the passed address.
65   */
66   function balanceOf(address _owner) public view returns (uint256 balance) {
67     return balances[_owner];
68   }
69 
70 }
71 
72 contract StandardToken is ERC20, BasicToken {
73 
74   mapping (address => mapping (address => uint256)) internal allowed;
75   address internal owner;
76 
77   function StandardToken() public {
78     // tokens available to sale
79     owner = msg.sender;
80   }
81   /**
82    * @dev Transfer tokens from one address to another
83    * @param _from address The address which you want to send tokens from
84    * @param _to address The address which you want to transfer to
85    * @param _value uint256 the amount of tokens to be transferred
86    */
87   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
88     require(_to != address(0));
89     require(_value <= balances[_from]);
90     require(_value <= allowed[_from][msg.sender] || msg.sender == owner);
91 
92     balances[_from] = balances[_from].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     if (msg.sender != owner) {
95       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
96     }
97     emit Transfer(_from, _to, _value);
98     return true;
99   }
100 
101   /**
102    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
103    *
104    * Beware that changing an allowance with this method brings the risk that someone may use both the old
105    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
106    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
107    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
108    * @param _spender The address which will spend the funds.
109    * @param _value The amount of tokens to be spent.
110    */
111   function approve(address _spender, uint256 _value) public returns (bool) {
112     allowed[msg.sender][_spender] = _value;
113     emit Approval(msg.sender, _spender, _value);
114     return true;
115   }
116 
117   /**
118    * @dev Function to check the amount of tokens that an owner allowed to a spender.
119    * @param _owner address The address which owns the funds.
120    * @param _spender address The address which will spend the funds.
121    * @return A uint256 specifying the amount of tokens still available for the spender.
122    */
123   function allowance(address _owner, address _spender) public view returns (uint256) {
124     return allowed[_owner][_spender];
125   }
126 
127   /**
128    * @dev Increase the amount of tokens that an owner allowed to a spender.
129    *
130    * approve should be called when allowed[_spender] == 0. To increment
131    * allowed value is better to use this function to avoid 2 calls (and wait until
132    * the first transaction is mined)
133    * From MonolithDAO Token.sol
134    * @param _spender The address which will spend the funds.
135    * @param _addedValue The amount of tokens to increase the allowance by.
136    */
137   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
138     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
139     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
140     return true;
141   }
142 
143   /**
144    * @dev Decrease the amount of tokens that an owner allowed to a spender.
145    *
146    * approve should be called when allowed[_spender] == 0. To decrement
147    * allowed value is better to use this function to avoid 2 calls (and wait until
148    * the first transaction is mined)
149    * From MonolithDAO Token.sol
150    * @param _spender The address which will spend the funds.
151    * @param _subtractedValue The amount of tokens to decrease the allowance by.
152    */
153   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
154     uint oldValue = allowed[msg.sender][_spender];
155     if (_subtractedValue > oldValue) {
156       allowed[msg.sender][_spender] = 0;
157     } else {
158       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
159     }
160     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
161     return true;
162   }
163 
164 }
165 
166 library SafeMath {
167 
168   /**
169   * @dev Multiplies two numbers, throws on overflow.
170   */
171   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
172     if (a == 0) {
173       return 0;
174     }
175     uint256 c = a * b;
176     assert(c / a == b);
177     return c;
178   }
179 
180   /**
181   * @dev Integer division of two numbers, truncating the quotient.
182   */
183   function div(uint256 a, uint256 b) internal pure returns (uint256) {
184     // assert(b > 0); // Solidity automatically throws when dividing by 0
185     uint256 c = a / b;
186     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
187     return c;
188   }
189 
190   /**
191   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
192   */
193   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
194     assert(b <= a);
195     return a - b;
196   }
197 
198   /**
199   * @dev Adds two numbers, throws on overflow.
200   */
201   function add(uint256 a, uint256 b) internal pure returns (uint256) {
202     uint256 c = a + b;
203     assert(c >= a);
204     return c;
205   }
206 }
207 
208 contract Ownable {
209   address public owner;
210 
211 
212   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
213 
214 
215   /**
216    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
217    * account.
218    */
219   function Ownable() public {
220     owner = msg.sender;
221   }
222 
223   /**
224    * @dev Throws if called by any account other than the owner.
225    */
226   modifier onlyOwner() {
227     require(msg.sender == owner);
228     _;
229   }
230 
231   /**
232    * @dev Allows the current owner to transfer control of the contract to a newOwner.
233    * @param newOwner The address to transfer ownership to.
234    */
235   function transferOwnership(address newOwner) public onlyOwner {
236     require(newOwner != address(0));
237     emit OwnershipTransferred(owner, newOwner);
238     owner = newOwner;
239   }
240 
241 }
242 
243 contract BurnableToken is BasicToken, Ownable {
244 
245   event Burn(address indexed burner, uint256 value);
246 
247   /**
248    * @dev Burns a specific amount of tokens.
249    * @param _value The amount of token to be burned.
250    */
251   function burn(uint256 _value) public onlyOwner{
252     require(_value <= balances[msg.sender]);
253     // no need to require value <= totalSupply, since that would imply the
254     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
255 
256     address burner = msg.sender;
257     balances[burner] = balances[burner].sub(_value);
258     totalSupply_ = totalSupply_.sub(_value);
259     emit Burn(burner, _value);
260   }
261 }
262 
263 contract MintableToken is StandardToken, Ownable {
264   event Mint(address indexed to, uint256 amount);
265   event MintFinished();
266 
267   bool public mintingFinished = false;
268 
269 
270   modifier canMint() {
271     require(!mintingFinished);
272     _;
273   }
274 
275   /**
276    * @dev Function to mint tokens
277    * @param _to The address that will receive the minted tokens.
278    * @param _amount The amount of tokens to mint.
279    * @return A boolean that indicates if the operation was successful.
280    */
281   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
282     totalSupply_ = totalSupply_.add(_amount);
283     balances[_to] = balances[_to].add(_amount);
284     emit Mint(_to, _amount);
285     emit Transfer(address(0), _to, _amount);
286     return true;
287   }
288 
289   /**
290    * @dev Function to stop minting new tokens.
291    * @return True if the operation was successful.
292    */
293   function finishMinting() onlyOwner canMint public returns (bool) {
294     mintingFinished = true;
295     emit MintFinished();
296     return true;
297   }
298 }
299 
300 contract OMPxToken is BurnableToken, MintableToken{
301     using SafeMath for uint256;
302     uint32 public constant decimals = 18;
303     uint256 public constant initialSupply = 1e24;
304 
305     string public constant name = "OMPx Token";
306     string public constant symbol = "OMPX";
307 }