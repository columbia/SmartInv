1 /**
2  * Source Code first verified at https://etherscan.io on Thursday, May 23, 2019
3  (UTC) */
4 
5 pragma solidity ^0.4.12;
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
54   function Ownable() {
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
74     OwnershipTransferred(owner, newOwner);
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
96 contract BasicToken is ERC20Basic, Ownable {
97   using SafeMath for uint256;
98 
99   mapping(address => uint256) balances;
100   // allowedAddresses will be able to transfer even when locked
101   // lockedAddresses will *not* be able to transfer even when *not locked*
102   mapping(address => bool) public allowedAddresses;
103   mapping(address => bool) public lockedAddresses;
104   bool public locked = true;
105 
106   function allowAddress(address _addr, bool _allowed) public onlyOwner {
107     require(_addr != owner);
108     allowedAddresses[_addr] = _allowed;
109   }
110 
111   function lockAddress(address _addr, bool _locked) public onlyOwner {
112     require(_addr != owner);
113     lockedAddresses[_addr] = _locked;
114   }
115 
116   function setLocked(bool _locked) public onlyOwner {
117     locked = _locked;
118   }
119 
120   function canTransfer(address _addr) public constant returns (bool) {
121     if(locked){
122       if(!allowedAddresses[_addr]&&_addr!=owner) return false;
123     }else if(lockedAddresses[_addr]) return false;
124 
125     return true;
126   }
127 
128 
129 
130 
131   /**
132   * @dev transfer token for a specified address
133   * @param _to The address to transfer to.
134   * @param _value The amount to be transferred.
135   */
136   function transfer(address _to, uint256 _value) public returns (bool) {
137     require(_to != address(0));
138     require(canTransfer(msg.sender));
139     
140 
141     // SafeMath.sub will throw if there is not enough balance.
142     balances[msg.sender] = balances[msg.sender].sub(_value);
143     balances[_to] = balances[_to].add(_value);
144     Transfer(msg.sender, _to, _value);
145     return true;
146   }
147 
148   /**
149   * @dev Gets the balance of the specified address.
150   * @param _owner The address to query the the balance of.
151   * @return An uint256 representing the amount owned by the passed address.
152   */
153   function balanceOf(address _owner) public constant returns (uint256 balance) {
154     return balances[_owner];
155   }
156 }
157 
158 /**
159  * @title ERC20 interface
160  * @dev see https://github.com/ethereum/EIPs/issues/20
161  */
162 contract ERC20 is ERC20Basic {
163   function allowance(address owner, address spender) public constant returns (uint256);
164   function transferFrom(address from, address to, uint256 value) public returns (bool);
165   function approve(address spender, uint256 value) public returns (bool);
166   event Approval(address indexed owner, address indexed spender, uint256 value);
167 }
168 
169 
170 /**
171  * @title Standard ERC20 token
172  *
173  * @dev Implementation of the basic standard token.
174  * @dev https://github.com/ethereum/EIPs/issues/20
175  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
176  */
177 contract StandardToken is ERC20, BasicToken {
178 
179   mapping (address => mapping (address => uint256)) allowed;
180 
181 
182   /**
183    * @dev Transfer tokens from one address to another
184    * @param _from address The address which you want to send tokens from
185    * @param _to address The address which you want to transfer to
186    * @param _value uint256 the amount of tokens to be transferred
187    */
188   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
189     require(_to != address(0));
190     require(canTransfer(msg.sender));
191 
192     uint256 _allowance = allowed[_from][msg.sender];
193 
194     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
195     // require (_value <= _allowance);
196 
197     balances[_from] = balances[_from].sub(_value);
198     balances[_to] = balances[_to].add(_value);
199     allowed[_from][msg.sender] = _allowance.sub(_value);
200     Transfer(_from, _to, _value);
201     return true;
202   }
203 
204   /**
205    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
206    *
207    * Beware that changing an allowance with this method brings the risk that someone may use both the old
208    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
209    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
210    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
211    * @param _spender The address which will spend the funds.
212    * @param _value The amount of tokens to be spent.
213    */
214   function approve(address _spender, uint256 _value) public returns (bool) {
215     allowed[msg.sender][_spender] = _value;
216     Approval(msg.sender, _spender, _value);
217     return true;
218   }
219 
220   /**
221    * @dev Function to check the amount of tokens that an owner allowed to a spender.
222    * @param _owner address The address which owns the funds.
223    * @param _spender address The address which will spend the funds.
224    * @return A uint256 specifying the amount of tokens still available for the spender.
225    */
226   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
227     return allowed[_owner][_spender];
228   }
229 
230   /**
231    * approve should be called when allowed[_spender] == 0. To increment
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    */
236   function increaseApproval (address _spender, uint _addedValue)
237     returns (bool success) {
238     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
239     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
240     return true;
241   }
242 
243   function decreaseApproval (address _spender, uint _subtractedValue)
244     returns (bool success) {
245     uint oldValue = allowed[msg.sender][_spender];
246     if (_subtractedValue > oldValue) {
247       allowed[msg.sender][_spender] = 0;
248     } else {
249       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
250     }
251     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 }
255 
256 
257 /**
258  * @title Burnable Token
259  * @dev Token that can be irreversibly burned (destroyed).
260  */
261 contract BurnableToken is StandardToken {
262 
263     event Burn(address indexed burner, uint256 value);
264 
265     /**
266      * @dev Burns a specific amount of tokens.
267      * @param _value The amount of token to be burned.
268      */
269     function burn(uint256 _value) public {
270         require(_value > 0);
271         require(_value <= balances[msg.sender]);
272         // no need to require value <= totalSupply, since that would imply the
273         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
274 
275         address burner = msg.sender;
276         balances[burner] = balances[burner].sub(_value);
277         totalSupply = totalSupply.sub(_value);
278         Burn(burner, _value);
279         Transfer(burner, address(0), _value);
280     }
281 
282 
283 
284 }
285 
286 contract Token  is BurnableToken {
287 
288     string public constant name = "AMUSE COIN";
289     string public constant symbol = "AMS";
290     uint public constant decimals = 18;
291     // there is no problem in using * here instead of .mul()
292     uint256 public constant initialSupply = 5000000000 * (10 ** uint256(decimals));
293 
294     // Constructors
295     function Token () {
296         totalSupply = initialSupply;
297         balances[msg.sender] = initialSupply; // Send all tokens to owner
298         allowedAddresses[owner] = true;
299     }
300 
301 	//minting function
302     function mintToken(address target, uint256 mintedAmount) onlyOwner {
303         balances[target] += mintedAmount;
304         totalSupply += mintedAmount;
305         Transfer(0, this, mintedAmount);
306         Transfer(this, target, mintedAmount);
307     }
308 
309 }