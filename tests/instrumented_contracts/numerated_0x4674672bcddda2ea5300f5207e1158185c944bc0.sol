1 pragma solidity ^0.4.12;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 
8 library SafeMath {
9 
10   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
11     uint256 c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal constant returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal constant returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 
34 }
35 
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42 
43   address public owner;
44 
45   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47   /**
48    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49    * account.
50    */
51 
52   function Ownable() {
53     owner = msg.sender;
54   }
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59 
60   modifier onlyOwner() {
61     require(msg.sender == owner);
62     _;
63   }
64 
65   /**
66    * @dev Allows the current owner to transfer control of the contract to a newOwner.
67    * @param newOwner The address to transfer ownership to.
68    */
69 
70   function transferOwnership(address newOwner) onlyOwner public {
71     require(newOwner != address(0));
72     OwnershipTransferred(owner, newOwner);
73     owner = newOwner;
74   }
75 
76 }
77 
78 /**
79  * @title ERC20Basic
80  * @dev Simpler version of ERC20 interface
81  * @dev see https://github.com/ethereum/EIPs/issues/179
82  */
83 
84 contract ERC20Basic {
85 
86   uint256 public totalSupply;
87 
88   function balanceOf(address who) public constant returns (uint256);
89   function transfer(address to, uint256 value) public returns (bool);
90   event Transfer(address indexed from, address indexed to, uint256 value);
91 
92 }
93 
94 /**
95  * @title Basic token
96  * @dev Basic version of StandardToken, with no allowances.
97  */
98 
99 contract BasicToken is ERC20Basic, Ownable {
100 
101   using SafeMath for uint256;
102 
103   mapping(address => uint256) balances;
104 
105   // allowedAddresses will be able to transfer even when locked
106   // lockedAddresses will *not* be able to transfer even when *not locked*
107 
108   mapping(address => bool) public allowedAddresses;
109   mapping(address => bool) public lockedAddresses;
110   bool public locked = true;
111 
112   function allowAddress(address _addr, bool _allowed) public onlyOwner {
113     require(_addr != owner);
114     allowedAddresses[_addr] = _allowed;
115   }
116 
117   function lockAddress(address _addr, bool _locked) public onlyOwner {
118     require(_addr != owner);
119     lockedAddresses[_addr] = _locked;
120   }
121 
122   function setLocked(bool _locked) public onlyOwner {
123     locked = _locked;
124   }
125 
126   function canTransfer(address _addr) public constant returns (bool) {
127     if(locked){
128       if(!allowedAddresses[_addr]&&_addr!=owner) return false;
129     }else if(lockedAddresses[_addr]) return false;
130 
131     return true;
132   }
133 
134   /**
135   * @dev transfer token for a specified address
136   * @param _to The address to transfer to.
137   * @param _value The amount to be transferred.
138   */
139 
140   function transfer(address _to, uint256 _value) public returns (bool) {
141     require(_to != address(0));
142     require(canTransfer(msg.sender));
143 
144     // SafeMath.sub will throw if there is not enough balance.
145 
146     balances[msg.sender] = balances[msg.sender].sub(_value);
147     balances[_to] = balances[_to].add(_value);
148     Transfer(msg.sender, _to, _value);
149 
150     return true;
151   }
152 
153   /**
154   * @dev Gets the balance of the specified address.
155   * @param _owner The address to query the the balance of.
156   * @return An uint256 representing the amount owned by the passed address.
157   */
158 
159   function balanceOf(address _owner) public constant returns (uint256 balance) {
160     return balances[_owner];
161   }
162   
163 }
164 
165 /**
166  * @title ERC20 interface
167  * @dev see https://github.com/ethereum/EIPs/issues/20
168  */
169 
170 contract ERC20 is ERC20Basic {
171   function allowance(address owner, address spender) public constant returns (uint256);
172   function transferFrom(address from, address to, uint256 value) public returns (bool);
173   function approve(address spender, uint256 value) public returns (bool);
174   event Approval(address indexed owner, address indexed spender, uint256 value);
175 }
176 
177 /**
178  * @title Standard ERC20 token
179  *
180  * @dev Implementation of the basic standard token.
181  * @dev https://github.com/ethereum/EIPs/issues/20
182  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
183  */
184 
185 contract StandardToken is ERC20, BasicToken {
186 
187   mapping (address => mapping (address => uint256)) allowed;
188 
189   /**
190    * @dev Transfer tokens from one address to another
191    * @param _from address The address which you want to send tokens from
192    * @param _to address The address which you want to transfer to
193    * @param _value uint256 the amount of tokens to be transferred
194    */
195 
196   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
197     require(_to != address(0));
198     require(canTransfer(_from));
199 
200     uint256 _allowance = allowed[_from][msg.sender];
201 
202     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
203     // require (_value <= _allowance);
204 
205     balances[_from] = balances[_from].sub(_value);
206     balances[_to] = balances[_to].add(_value);
207     allowed[_from][msg.sender] = _allowance.sub(_value);
208     Transfer(_from, _to, _value);
209 
210     return true;
211 
212   }
213 
214   /**
215    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
216    *
217    * Beware that changing an allowance with this method brings the risk that someone may use both the old
218    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
219    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
220    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
221    * @param _spender The address which will spend the funds.
222    * @param _value The amount of tokens to be spent.
223    */
224 
225   function approve(address _spender, uint256 _value) public returns (bool) {
226       
227     allowed[msg.sender][_spender] = _value;
228     Approval(msg.sender, _spender, _value);
229     return true;
230     
231   }
232 
233   /**
234    * @dev Function to check the amount of tokens that an owner allowed to a spender.
235    * @param _owner address The address which owns the funds.
236    * @param _spender address The address which will spend the funds.
237    * @return A uint256 specifying the amount of tokens still available for the spender.
238    */
239 
240   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
241     return allowed[_owner][_spender];
242   }
243 
244   /**
245    * approve should be called when allowed[_spender] == 0. To increment
246    * allowed value is better to use this function to avoid 2 calls (and wait until
247    * the first transaction is mined)
248    * From MonolithDAO Token.sol
249    */
250 
251   function increaseApproval (address _spender, uint _addedValue)
252     returns (bool success) {
253     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
254     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
255     return true;
256   }
257 
258   function decreaseApproval (address _spender, uint _subtractedValue)
259     returns (bool success) {
260     uint oldValue = allowed[msg.sender][_spender];
261     if (_subtractedValue > oldValue) {
262       allowed[msg.sender][_spender] = 0;
263     } else {
264       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
265     }
266     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
267     return true;
268   }
269 
270 }
271 
272 
273 /**
274  * @title Burnable Token
275  * @dev Token that can be irreversibly burned (destroyed).
276  */
277 
278 contract BurnableToken is StandardToken {
279 
280     event Burn(address indexed burner, uint256 value);
281     
282     /**
283      * @dev Burns a specific amount of tokens.
284      * @param _value The amount of token to be burned.
285      */
286 
287     function burn(uint256 _value) onlyOwner public {
288         
289         require(_value > 0);
290         require(_value <= balances[msg.sender]);
291 
292         // no need to require value <= totalSupply, since that would imply the
293         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
294 
295         address burner = msg.sender;
296         balances[burner] = balances[burner].sub(_value);
297         totalSupply = totalSupply.sub(_value);
298         Burn(burner, _value);
299         Transfer(burner, address(0), _value);
300         
301     }
302 
303 
304 }
305 
306  
307 
308 contract Token is BurnableToken {
309 
310     string public constant name = "Gem Exchange and Trading";
311     string public constant symbol = "GXT";
312     uint public constant decimals = 18;
313 
314     // there is no problem in using * here instead of .mul()
315 
316     uint256 public constant initialSupply = 500000000 * (10 ** uint256(decimals));
317 
318     // Constructors
319 
320     function Token () {
321         totalSupply = initialSupply;
322         balances[msg.sender] = initialSupply; // Send all tokens to owner
323         allowedAddresses[owner] = true;
324     }
325 
326 }