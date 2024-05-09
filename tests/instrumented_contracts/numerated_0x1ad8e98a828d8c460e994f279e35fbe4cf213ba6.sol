1 pragma solidity ^0.4.23;
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
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55   function totalSupply() public view returns (uint256);
56   function balanceOf(address who) public view returns (uint256);
57   function transfer(address to, uint256 value) public returns (bool);
58   event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 /**
62  * @title ERC20 interface
63  * @dev see https://github.com/ethereum/EIPs/issues/20
64  */
65 contract ERC20 is ERC20Basic {
66   function allowance(address owner, address spender) public view returns (uint256);
67   function transferFrom(address from, address to, uint256 value) public returns (bool);
68   function approve(address spender, uint256 value) public returns (bool);
69   event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 /**
73  * @title Basic token
74  * @dev Basic version of StandardToken, with no allowances.
75  */
76 contract BasicToken is ERC20Basic {
77   using SafeMath for uint256;
78 
79   mapping(address => uint256) public balances;
80 
81   uint256 public totalSupply_;
82 
83   /**
84   * @dev total number of tokens in existence
85   */
86   function totalSupply() public view returns (uint256) {
87     return totalSupply_;
88   }
89 
90   /**
91   * @dev transfer token for a specified address
92   * @param _to The address to transfer to.
93   * @param _value The amount to be transferred.
94   */
95   function transfer(address _to, uint256 _value) public returns (bool) {
96     require(_to != address(0));
97     require(_value <= balances[msg.sender]);
98 
99     balances[msg.sender] = balances[msg.sender].sub(_value);
100     balances[_to] = balances[_to].add(_value);
101     emit Transfer(msg.sender, _to, _value);
102     return true;
103   }
104 
105   /**
106   * @dev Gets the balance of the specified address.
107   * @param _owner The address to query the the balance of.
108   * @return An uint256 representing the amount owned by the passed address.
109   */
110   function balanceOf(address _owner) public view returns (uint256) {
111     return balances[_owner];
112   }
113 }
114 
115 /**
116  * @title Standard ERC20 token
117  *
118  * @dev Implementation of the basic standard token.
119  * @dev https://github.com/ethereum/EIPs/issues/20
120  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
121  */
122 contract StandardToken is ERC20, BasicToken {
123 
124   mapping (address => mapping (address => uint256)) internal allowed;
125 
126   /**
127    * @dev Transfer tokens from one address to another
128    * @param _from address The address which you want to send tokens from
129    * @param _to address The address which you want to transfer to
130    * @param _value uint256 the amount of tokens to be transferred
131    */
132   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
133     require(_to != address(0));
134     require(_value <= balances[_from]);
135     require(_value <= allowed[_from][msg.sender]);
136 
137     balances[_from] = balances[_from].sub(_value);
138     balances[_to] = balances[_to].add(_value);
139     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
140     emit Transfer(_from, _to, _value);
141     return true;
142   }
143 
144   /**
145    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
146    *
147    * Beware that changing an allowance with this method brings the risk that someone may use both the old
148    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
149    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
150    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
151    * @param _spender The address which will spend the funds.
152    * @param _value The amount of tokens to be spent.
153    */
154   function approve(address _spender, uint256 _value) public returns (bool) {
155     allowed[msg.sender][_spender] = _value;
156     emit Approval(msg.sender, _spender, _value);
157     return true;
158   }
159 
160   /**
161    * @dev Function to check the amount of tokens that an owner allowed to a spender.
162    * @param _owner address The address which owns the funds.
163    * @param _spender address The address which will spend the funds.
164    * @return A uint256 specifying the amount of tokens still available for the spender.
165    */
166   function allowance(address _owner, address _spender) public view returns (uint256) {
167     return allowed[_owner][_spender];
168   }
169  
170   /**
171    * @dev Increase the amount of tokens that an owner allowed to a spender.
172    *
173    * approve should be called when allowed[_spender] == 0. To increment
174    * allowed value is better to use this function to avoid 2 calls (and wait until
175    * the first transaction is mined)
176    * From MonolithDAO Token.sol
177    * @param _spender The address which will spend the funds.
178    * @param _addedValue The amount of tokens to increase the allowance by.
179    */
180   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
181     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
182     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
183     return true;
184   }
185 
186   /**
187    * @dev Decrease the amount of tokens that an owner allowed to a spender.
188    *
189    * approve should be called when allowed[_spender] == 0. To decrement
190    * allowed value is better to use this function to avoid 2 calls (and wait until
191    * the first transaction is mined)
192    * From MonolithDAO Token.sol
193    * @param _spender The address which will spend the funds.
194    * @param _subtractedValue The amount of tokens to decrease the allowance by.
195    */
196   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
197     uint oldValue = allowed[msg.sender][_spender];
198     if (_subtractedValue > oldValue) {
199       allowed[msg.sender][_spender] = 0;
200     } else {
201       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
202     }
203     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
204     return true;
205   }
206 }
207 
208 /**
209  * @title Ownable
210  * @dev The Ownable contract has an owner address, and provides basic authorization control
211  * functions, this simplifies the implementation of "user permissions".
212  */
213 contract Ownable {
214   address public owner;
215 
216   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
217 
218   /**
219    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
220    * account.
221    */
222   constructor() public {
223     owner = msg.sender;
224   }
225 
226   /**
227    * @dev Throws if called by any account other than the owner.
228    */
229   modifier onlyOwner() {
230     require(msg.sender == owner);
231     _;
232   }
233 
234   /**
235    * @dev Allows the current owner to transfer control of the contract to a newOwner.
236    * @param newOwner The address to transfer ownership to.
237    */
238   function transferOwnership(address newOwner) public onlyOwner {
239     require(newOwner != address(0));
240     emit OwnershipTransferred(owner, newOwner);
241     owner = newOwner;
242   }
243 }
244 
245 /**
246  * @title Commit Good token
247  * @dev Commit Good ERC20 Token, that inherits from standard token.
248  */
249 contract CommitGoodToken is StandardToken, Ownable {
250     using SafeMath for uint256;
251 
252     string public symbol = "GOOD";
253     string public name = "GOOD";
254     uint8 public decimals = 18;
255 
256     uint256 public maxSupply = 200000000 * (10 ** uint256(decimals));
257     mapping (address => bool) public mintAgents;
258     bool public mintingFinished = false;
259 
260     event MintAgentChanged(address indexed addr, bool state);
261     event Mint(address indexed to, uint256 amount);
262     event MintFinished();
263 
264     modifier onlyMintAgent() {
265         require(mintAgents[msg.sender]);
266         _;
267     }
268 
269     modifier canMint() {
270         require(!mintingFinished);
271         _;
272     }
273 
274     modifier validAddress(address _addr) {
275         require(_addr != address(0));
276         require(_addr != address(this));
277         _;
278     }
279 
280     /**
281      * @dev Owner can allow a contract to mint tokens.
282      */
283     function setMintAgent(address _addr, bool _state) public onlyOwner validAddress(_addr) {
284         mintAgents[_addr] = _state;
285         emit MintAgentChanged(_addr, _state);
286     }
287 
288     /**
289      * @dev Function to mint tokens
290      * @param _addr The address that will receive the minted tokens.
291      * @param _amount The amount of tokens to mint.
292      * @return A boolean that indicates if the operation was successful.
293      */
294     function mint(address _addr, uint256 _amount) public onlyMintAgent canMint validAddress(_addr) returns (bool) {
295         totalSupply_ = totalSupply_.add(_amount);
296         balances[_addr] = balances[_addr].add(_amount);
297         emit Mint(_addr, _amount);
298         emit Transfer(address(0), _addr, _amount);
299         return true;
300     }
301 
302     /**
303      * @dev Function to stop minting new tokens.
304      * @return True if the operation was successful.
305      */
306     function finishMinting() public onlyMintAgent canMint returns (bool) {
307         mintingFinished = true;
308         emit MintFinished();
309         return true;
310     }
311 }