1 /**
2  * Source Code first verified at https://etherscan.io on Wednesday, May 8, 2019
3  (UTC) */
4 
5 /**
6  * Source Code first verified at https://etherscan.io on Wednesday, May 1, 2019
7  (UTC) */
8 
9 pragma solidity ^0.4.24;
10 
11 // ----------------------------------------------------------------------------
12 // 'aGifttoken'  token contract
13 //
14 // Symbol      : LLion
15 // Name        : Lydian Lion Token
16 // Total supply: 50,000,000,000
17 // Decimals    : 5
18 // (c) by Team @ LydianLionToken 2019.
19 // ----------------------------------------------------------------------------
20 
21 
22 /**
23  * @title SafeMath
24  * @dev Math operations with safety checks that throw on error
25  */
26 library SafeMath {
27   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a * b;
29     assert(a == 0 || c / a == b);
30     return c;
31   }
32 
33   function div(uint256 a, uint256 b) internal constant returns (uint256) {
34     // assert(b > 0); // Solidity automatically throws when dividing by 0
35     uint256 c = a / b;
36     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37     return c;
38   }
39 
40   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   function add(uint256 a, uint256 b) internal constant returns (uint256) {
46     uint256 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64 
65   /**
66    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
67    * account.
68    */
69   function Ownable() {
70     owner = msg.sender;
71   }
72 
73 
74   /**
75    * @dev Throws if called by any account other than the owner.
76    */
77   modifier onlyOwner() {
78     require(msg.sender == owner);
79     _;
80   }
81 
82 
83   /**
84    * @dev Allows the current owner to transfer control of the contract to a newOwner.
85    * @param newOwner The address to transfer ownership to.
86    */
87   function transferOwnership(address newOwner) onlyOwner public {
88     require(newOwner != address(0));
89     OwnershipTransferred(owner, newOwner);
90     owner = newOwner;
91   }
92 }
93 
94 /**
95  * @title ERC20Basic
96  * @dev Simpler version of ERC20 interface
97  * @dev see https://github.com/ethereum/EIPs/issues/179
98  */
99 contract ERC20Basic {
100   uint256 public totalSupply;
101   function balanceOf(address who) public constant returns (uint256);
102   function transfer(address to, uint256 value) public returns (bool);
103   event Transfer(address indexed from, address indexed to, uint256 value);
104 }
105 
106 
107 /**
108  * @title Basic token
109  * @dev Basic version of StandardToken, with no allowances.
110  */
111 contract BasicToken is ERC20Basic, Ownable {
112   using SafeMath for uint256;
113 
114   mapping(address => uint256) balances;
115   // allowedAddresses will be able to transfer even when locked
116   // lockedAddresses will *not* be able to transfer even when *not locked*
117   mapping(address => bool) public allowedAddresses;
118   mapping(address => bool) public lockedAddresses;
119   bool public locked = true;
120 
121   function allowAddress(address _addr, bool _allowed) public onlyOwner {
122     require(_addr != owner);
123     allowedAddresses[_addr] = _allowed;
124   }
125 
126   function lockAddress(address _addr, bool _locked) public onlyOwner {
127     require(_addr != owner);
128     lockedAddresses[_addr] = _locked;
129   }
130 
131   function setLocked(bool _locked) public onlyOwner {
132     locked = _locked;
133   }
134 
135   function canTransfer(address _addr) public constant returns (bool) {
136     if(locked){
137       if(!allowedAddresses[_addr]&&_addr!=owner) return false;
138     }else if(lockedAddresses[_addr]) return false;
139 
140     return true;
141   }
142 
143 
144 
145 
146   /**
147   * @dev transfer token for a specified address
148   * @param _to The address to transfer to.
149   * @param _value The amount to be transferred.
150   */
151   function transfer(address _to, uint256 _value) public returns (bool) {
152     require(_to != address(0));
153     require(canTransfer(msg.sender));
154     
155 
156     // SafeMath.sub will throw if there is not enough balance.
157     balances[msg.sender] = balances[msg.sender].sub(_value);
158     balances[_to] = balances[_to].add(_value);
159     Transfer(msg.sender, _to, _value);
160     return true;
161   }
162 
163   /**
164   * @dev Gets the balance of the specified address.
165   * @param _owner The address to query the the balance of.
166   * @return An uint256 representing the amount owned by the passed address.
167   */
168   function balanceOf(address _owner) public constant returns (uint256 balance) {
169     return balances[_owner];
170   }
171 }
172 
173 /**
174  * @title ERC20 interface
175  * @dev see https://github.com/ethereum/EIPs/issues/20
176  */
177 contract ERC20 is ERC20Basic {
178   function allowance(address owner, address spender) public constant returns (uint256);
179   function transferFrom(address from, address to, uint256 value) public returns (bool);
180   function approve(address spender, uint256 value) public returns (bool);
181   event Approval(address indexed owner, address indexed spender, uint256 value);
182 }
183 
184 
185 /**
186  * @title Standard ERC20 token
187  *
188  * @dev Implementation of the basic standard token.
189  * @dev https://github.com/ethereum/EIPs/issues/20
190  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
191  */
192 contract StandardToken is ERC20, BasicToken {
193 
194   mapping (address => mapping (address => uint256)) allowed;
195 
196 
197   /**
198    * @dev Transfer tokens from one address to another
199    * @param _from address The address which you want to send tokens from
200    * @param _to address The address which you want to transfer to
201    * @param _value uint256 the amount of tokens to be transferred
202    */
203   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
204     require(_to != address(0));
205     require(canTransfer(msg.sender));
206 
207     uint256 _allowance = allowed[_from][msg.sender];
208 
209     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
210     // require (_value <= _allowance);
211 
212     balances[_from] = balances[_from].sub(_value);
213     balances[_to] = balances[_to].add(_value);
214     allowed[_from][msg.sender] = _allowance.sub(_value);
215     Transfer(_from, _to, _value);
216     return true;
217   }
218 
219   /**
220    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
221    *
222    * Beware that changing an allowance with this method brings the risk that someone may use both the old
223    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
224    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
225    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
226    * @param _spender The address which will spend the funds.
227    * @param _value The amount of tokens to be spent.
228    */
229   function approve(address _spender, uint256 _value) public returns (bool) {
230     allowed[msg.sender][_spender] = _value;
231     Approval(msg.sender, _spender, _value);
232     return true;
233   }
234 
235   /**
236    * @dev Function to check the amount of tokens that an owner allowed to a spender.
237    * @param _owner address The address which owns the funds.
238    * @param _spender address The address which will spend the funds.
239    * @return A uint256 specifying the amount of tokens still available for the spender.
240    */
241   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
242     return allowed[_owner][_spender];
243   }
244 
245   /**
246    * approve should be called when allowed[_spender] == 0. To increment
247    * allowed value is better to use this function to avoid 2 calls (and wait until
248    * the first transaction is mined)
249    * From MonolithDAO Token.sol
250    */
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
269 }
270 
271 
272 /**
273  * @title Burnable Token
274  * @dev Token that can be irreversibly burned (destroyed).
275  */
276 contract BurnableToken is StandardToken {
277 
278     event Burn(address indexed burner, uint256 value);
279 
280     /**
281      * @dev Burns a specific amount of tokens.
282      * @param _value The amount of token to be burned.
283      */
284     function burn(uint256 _value) public {
285         require(_value > 0);
286         require(_value <= balances[msg.sender]);
287         // no need to require value <= totalSupply, since that would imply the
288         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
289 
290         address burner = msg.sender;
291         balances[burner] = balances[burner].sub(_value);
292         totalSupply = totalSupply.sub(_value);
293         Burn(burner, _value);
294         Transfer(burner, address(0), _value);
295     }
296 }
297 
298 contract LydianLionToken is BurnableToken {
299 
300     string public constant name = "Lydian Lion Token";
301     string public constant symbol = "LLion";
302     uint public constant decimals = 5;
303     // there is no problem in using * here instead of .mul()
304     uint256 public constant initialSupply = 50000000000 * (10 ** uint256(decimals));
305 
306     // Constructors
307     function LydianLionToken () {
308         totalSupply = initialSupply;
309         balances[msg.sender] = initialSupply; // Send all tokens to owner
310         allowedAddresses[owner] = true;
311     }
312 
313 }