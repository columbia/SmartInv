1 pragma solidity ^0.4.13;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
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
39  * @title ERC20Basic
40  * @dev Simpler version of ERC20 interface
41  * @dev see https://github.com/ethereum/EIPs/issues/179
42  */
43 contract ERC20Basic {
44   uint256 public totalSupply;
45   function balanceOf(address who) public constant returns (uint256);
46   function transfer(address to, uint256 value) public returns (bool);
47   event Transfer(address indexed from, address indexed to, uint256 value);
48 }
49 
50 /**
51  * @title ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/20
53  */
54 contract ERC20 is ERC20Basic {
55   function allowance(address owner, address spender) public constant returns (uint256);
56   function transferFrom(address from, address to, uint256 value) public returns (bool);
57   function approve(address spender, uint256 value) public returns (bool);
58   event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 /**
62  * @title Basic token
63  * @dev Basic version of StandardToken, with no allowances.
64  */
65 contract BasicToken is ERC20Basic {
66   using SafeMath for uint256;
67 
68   mapping(address => uint256) balances;
69 
70   /**
71   * @dev transfer token for a specified address
72   * @param _to The address to transfer to.
73   * @param _value The amount to be transferred.
74   */
75   function transfer(address _to, uint256 _value) public returns (bool) {
76     require(_to != address(0));
77     require(_value <= balances[msg.sender]);
78 
79     // SafeMath.sub will throw if there is not enough balance.
80     balances[msg.sender] = balances[msg.sender].sub(_value);
81     balances[_to] = balances[_to].add(_value);
82     Transfer(msg.sender, _to, _value);
83     return true;
84   }
85 
86   /**
87   * @dev Gets the balance of the specified address.
88   * @param _owner The address to query the the balance of.
89   * @return An uint256 representing the amount owned by the passed address.
90   */
91   function balanceOf(address _owner) public constant returns (uint256 balance) {
92     return balances[_owner];
93   }
94 
95 }
96 
97 /**
98  * @title Standard ERC20 token
99  *
100  * @dev Implementation of the basic standard token.
101  * @dev https://github.com/ethereum/EIPs/issues/20
102  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
103  */
104 contract StandardToken is ERC20, BasicToken {
105 
106   mapping (address => mapping (address => uint256)) internal allowed;
107 
108 
109   /**
110    * @dev Transfer tokens from one address to another
111    * @param _from address The address which you want to send tokens from
112    * @param _to address The address which you want to transfer to
113    * @param _value uint256 the amount of tokens to be transferred
114    */
115   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
116     require(_to != address(0));
117     require(_value <= balances[_from]);
118     require(_value <= allowed[_from][msg.sender]);
119 
120     balances[_from] = balances[_from].sub(_value);
121     balances[_to] = balances[_to].add(_value);
122     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
123     Transfer(_from, _to, _value);
124     return true;
125   }
126 
127   /**
128    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
129    *
130    * Beware that changing an allowance with this method brings the risk that someone may use both the old
131    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
132    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
133    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
134    * @param _spender The address which will spend the funds.
135    * @param _value The amount of tokens to be spent.
136    */
137   function approve(address _spender, uint256 _value) public returns (bool) {
138     allowed[msg.sender][_spender] = _value;
139     Approval(msg.sender, _spender, _value);
140     return true;
141   }
142 
143   /**
144    * @dev Function to check the amount of tokens that an owner allowed to a spender.
145    * @param _owner address The address which owns the funds.
146    * @param _spender address The address which will spend the funds.
147    * @return A uint256 specifying the amount of tokens still available for the spender.
148    */
149   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
150     return allowed[_owner][_spender];
151   }
152 
153   /**
154    * approve should be called when allowed[_spender] == 0. To increment
155    * allowed value is better to use this function to avoid 2 calls (and wait until
156    * the first transaction is mined)
157    * From MonolithDAO Token.sol
158    */
159   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
160     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
161     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
162     return true;
163   }
164 
165   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
166     uint oldValue = allowed[msg.sender][_spender];
167     if (_subtractedValue > oldValue) {
168       allowed[msg.sender][_spender] = 0;
169     } else {
170       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
171     }
172     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
173     return true;
174   }
175 
176 }
177 
178 /**
179  * @title Ownable
180  * @dev The Ownable contract has an owner address, and provides basic authorization control
181  * functions, this simplifies the implementation of "user permissions".
182  */
183 contract Ownable {
184   address public owner;
185 
186 
187   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
188 
189 
190   /**
191    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
192    * account.
193    */
194   function Ownable() {
195     owner = msg.sender;
196   }
197 
198 
199   /**
200    * @dev Throws if called by any account other than the owner.
201    */
202   modifier onlyOwner() {
203     require(msg.sender == owner);
204     _;
205   }
206 
207 
208   /**
209    * @dev Allows the current owner to transfer control of the contract to a newOwner.
210    * @param newOwner The address to transfer ownership to.
211    */
212   function transferOwnership(address newOwner) onlyOwner public {
213     require(newOwner != address(0));
214     OwnershipTransferred(owner, newOwner);
215     owner = newOwner;
216   }
217 
218 }
219 
220 /**
221  * @title Mintable token
222  * @dev Simple ERC20 Token example, with mintable token creation
223  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
224  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
225  */
226 
227 contract MintableToken is StandardToken, Ownable {
228   event Mint(address indexed to, uint256 amount);
229   event MintFinished();
230 
231   bool public mintingFinished = false;
232 
233 
234   modifier canMint() {
235     require(!mintingFinished);
236     _;
237   }
238 
239   /**
240    * @dev Function to mint tokens
241    * @param _to The address that will receive the minted tokens.
242    * @param _amount The amount of tokens to mint.
243    * @return A boolean that indicates if the operation was successful.
244    */
245   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
246     totalSupply = totalSupply.add(_amount);
247     balances[_to] = balances[_to].add(_amount);
248     Mint(_to, _amount);
249     Transfer(address(0), _to, _amount);
250     return true;
251   }
252 
253   /**
254    * @dev Function to stop minting new tokens.
255    * @return True if the operation was successful.
256    */
257   function finishMinting() onlyOwner canMint public returns (bool) {
258     mintingFinished = true;
259     MintFinished();
260     return true;
261   }
262 }
263 
264 /**
265  * @title Burnable Token
266  * @dev Token that can be irreversibly burned (destroyed).
267  */
268 contract BurnableToken is StandardToken {
269 
270     event Burn(address indexed burner, uint256 value);
271 
272     /**
273      * @dev Burns a specific amount of tokens.
274      * @param _value The amount of token to be burned.
275      */
276     function burn(uint256 _value) public {
277         require(_value > 0);
278         require(_value <= balances[msg.sender]);
279         // no need to require value <= totalSupply, since that would imply the
280         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
281 
282         address burner = msg.sender;
283         balances[burner] = balances[burner].sub(_value);
284         totalSupply = totalSupply.sub(_value);
285         Burn(burner, _value);
286     }
287 }
288 
289 contract SaleToken is MintableToken, BurnableToken {
290     using SafeMath for uint256;
291 
292     uint256 public price = 300000000000000000;
293     string public constant symbol = "BST";
294     string public constant name = "BlockShow Token";
295     uint8 public constant decimals = 18;
296     uint256 constant level = 10 ** uint256(decimals);
297     uint256 public totalSupply = 10000 * level;
298 
299     event Payment(uint256 _give, uint256 _get);
300 
301     function setPrice(uint256 newPrice) onlyOwner {
302         price = newPrice;
303     }
304 
305     // Constructor
306     function SaleToken() {
307         owner = msg.sender;
308         balances[owner] = totalSupply;
309     }
310 
311     /**
312     * Fallback function
313     *
314     * The function without name is the default function that is called whenever anyone sends funds to a contract
315     */
316     function() payable {
317         buyTo(msg.sender);
318     }
319 
320     function buyTo(address _to) payable {
321         uint256 etherGive = msg.value;
322         uint256 tokenGet = (etherGive * level).div(price);
323 
324         if(balances[owner] < tokenGet) {
325             revert();
326         }
327 
328         balances[owner] = balances[owner].sub(tokenGet);
329         balances[_to] = balances[_to].add(tokenGet);
330 
331         Payment(etherGive, tokenGet);
332         owner.transfer(etherGive);
333     }
334 }