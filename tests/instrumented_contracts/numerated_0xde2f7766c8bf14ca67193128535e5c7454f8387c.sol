1 pragma solidity 0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/179
54  */
55 contract ERC20Basic {
56   function totalSupply() public view returns (uint256);
57   function balanceOf(address who) public view returns (uint256);
58   function transfer(address to, uint256 value) public returns (bool);
59   event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 /**
63  * @title ERC20 interface
64  * @dev see https://github.com/ethereum/EIPs/issues/20
65  */
66 contract ERC20 is ERC20Basic {
67   function allowance(address owner, address spender) public view returns (uint256);
68   function transferFrom(address from, address to, uint256 value) public returns (bool);
69   function approve(address spender, uint256 value) public returns (bool);
70   event Approval(address indexed owner, address indexed spender, uint256 value);
71 }
72 
73 /**
74  * @title Basic token
75  * @dev Basic version of StandardToken, with no allowances.
76  */
77 contract BasicToken is ERC20Basic {
78   using SafeMath for uint256;
79 
80   mapping(address => uint256) balances;
81 
82   uint256 totalSupply_;
83 
84   /**
85   * @dev total number of tokens in existence
86   */
87   function totalSupply() public view returns (uint256) {
88     return totalSupply_;
89   }
90 
91   /**
92   * @dev transfer token for a specified address
93   * @param _to The address to transfer to.
94   * @param _value The amount to be transferred.
95   */
96   function transfer(address _to, uint256 _value) public returns (bool) {
97     require(_to != address(0));
98     require(_value <= balances[msg.sender]);
99 
100     // SafeMath.sub will throw if there is not enough balance.
101     balances[msg.sender] = balances[msg.sender].sub(_value);
102     balances[_to] = balances[_to].add(_value);
103     Transfer(msg.sender, _to, _value);
104     return true;
105   }
106 
107   /**
108   * @dev Gets the balance of the specified address.
109   * @param _owner The address to query the the balance of.
110   * @return An uint256 representing the amount owned by the passed address.
111   */
112   function balanceOf(address _owner) public view returns (uint256 balance) {
113     return balances[_owner];
114   }
115 
116 }
117 
118 /**
119  * @title Standard ERC20 token
120  *
121  * @dev Implementation of the basic standard token.
122  * @dev https://github.com/ethereum/EIPs/issues/20
123  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
124  */
125 contract StandardToken is ERC20, BasicToken {
126 
127   mapping (address => mapping (address => uint256)) internal allowed;
128 
129 
130   /**
131    * @dev Transfer tokens from one address to another
132    * @param _from address The address which you want to send tokens from
133    * @param _to address The address which you want to transfer to
134    * @param _value uint256 the amount of tokens to be transferred
135    */
136   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
137     require(_to != address(0));
138     require(_value <= balances[_from]);
139     require(_value <= allowed[_from][msg.sender]);
140 
141     balances[_from] = balances[_from].sub(_value);
142     balances[_to] = balances[_to].add(_value);
143     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
144     Transfer(_from, _to, _value);
145     return true;
146   }
147 
148   /**
149    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
150    *
151    * Beware that changing an allowance with this method brings the risk that someone may use both the old
152    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
153    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
154    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
155    * @param _spender The address which will spend the funds.
156    * @param _value The amount of tokens to be spent.
157    */
158   function approve(address _spender, uint256 _value) public returns (bool) {
159     allowed[msg.sender][_spender] = _value;
160     Approval(msg.sender, _spender, _value);
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
176    *
177    * approve should be called when allowed[_spender] == 0. To increment
178    * allowed value is better to use this function to avoid 2 calls (and wait until
179    * the first transaction is mined)
180    * From MonolithDAO Token.sol
181    * @param _spender The address which will spend the funds.
182    * @param _addedValue The amount of tokens to increase the allowance by.
183    */
184   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
185     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
186     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
187     return true;
188   }
189 
190   /**
191    * @dev Decrease the amount of tokens that an owner allowed to a spender.
192    *
193    * approve should be called when allowed[_spender] == 0. To decrement
194    * allowed value is better to use this function to avoid 2 calls (and wait until
195    * the first transaction is mined)
196    * From MonolithDAO Token.sol
197    * @param _spender The address which will spend the funds.
198    * @param _subtractedValue The amount of tokens to decrease the allowance by.
199    */
200   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
201     uint oldValue = allowed[msg.sender][_spender];
202     if (_subtractedValue > oldValue) {
203       allowed[msg.sender][_spender] = 0;
204     } else {
205       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
206     }
207     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
208     return true;
209   }
210 
211 }
212 
213 
214 /**
215  * @title Ownable
216  * @dev The Ownable contract has an owner address, and provides basic authorization control
217  * functions, this simplifies the implementation of "user permissions".
218  */
219 contract Ownable {
220   address public owner;
221 
222 
223   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
224 
225 
226   /**
227    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
228    * account.
229    */
230   function Ownable() public {
231     owner = msg.sender;
232   }
233 
234   /**
235    * @dev Throws if called by any account other than the owner.
236    */
237   modifier onlyOwner() {
238     require(msg.sender == owner);
239     _;
240   }
241 
242   /**
243    * @dev Allows the current owner to transfer control of the contract to a newOwner.
244    * @param newOwner The address to transfer ownership to.
245    */
246   function transferOwnership(address newOwner) public onlyOwner {
247     require(newOwner != address(0));
248     OwnershipTransferred(owner, newOwner);
249     owner = newOwner;
250   }
251 
252 }
253 
254 /**
255  * @title Metadium
256  * @dev ERC20 Token, where all tokens are pre-assigned to the creator.
257  * Note they can later distribute these tokens as they wish using `transfer` and other
258  * `StandardToken` functions.
259  */
260 contract Metadium is StandardToken, Ownable {
261 
262   string public constant name = "Metadium";
263   string public constant symbol = "META";
264   uint8 public constant decimals = 18; 
265 
266   uint256 public constant INITIAL_SUPPLY = 2000000000 * (10 ** uint256(decimals));
267 
268   bool public transferEnabled = false;
269   
270   event Burn(address burner, uint256 value);
271   event TransferEnabled(address owner);
272   event TransferDisabled(address owner);
273 
274   modifier isTradable(){
275     require(transferEnabled || msg.sender == owner);
276     _;
277   }
278   /**
279    * @dev Constructor that gives msg.sender all of existing tokens.
280    */
281   function Metadium() public {
282     totalSupply_ = INITIAL_SUPPLY;
283     balances[msg.sender] = INITIAL_SUPPLY;
284     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
285   }
286 
287   function enableTransfer() external onlyOwner {
288     transferEnabled = true;
289     TransferEnabled(owner);
290   }
291   
292   function disableTransfer() external onlyOwner {
293     transferEnabled = false;
294     TransferDisabled(owner);
295   }
296 
297   function transfer(address to, uint256 value) public isTradable returns (bool) {
298     return super.transfer(to, value);
299   }
300     
301   function transferFrom(address from, address to, uint256 value) public isTradable returns (bool) {
302     return super.transferFrom(from, to, value);
303   }
304 
305   /**
306    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
307    * Metadium specific require() is added to defence attack of race condition
308    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
309    * @param _spender The address which will spend the funds.
310    * @param _value The amount of tokens to be spent.
311    */
312   function approve(address _spender, uint256 _value) public returns (bool) {
313     require(allowed[msg.sender][_spender] == 0);
314     allowed[msg.sender][_spender] = _value;
315     Approval(msg.sender, _spender, _value);
316     return true;
317   }
318 
319   
320   /**
321    * @dev Burns a specific amount of tokens.
322    * @param _value The amount of token to be burned.
323    */
324   function burn(uint256 _value) external onlyOwner {
325     require(_value <= balances[msg.sender]);
326     require(_value <= totalSupply_);
327     balances[msg.sender] = balances[msg.sender].sub(_value);
328     totalSupply_ = totalSupply_.sub(_value);
329     Burn(msg.sender, _value);
330     Transfer(msg.sender, address(0), _value);
331   }
332 
333 }