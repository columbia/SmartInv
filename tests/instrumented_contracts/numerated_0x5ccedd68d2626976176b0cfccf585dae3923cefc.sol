1 pragma solidity 0.4.15;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) onlyOwner public {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 contract OnlyAllowedAddresses is Ownable {
46     mapping (address => bool) allowedAddresses;
47 
48     modifier onlyAllowedAddresses {
49         require(msg.sender == owner || allowedAddresses[msg.sender] == true);
50         _;
51     }
52 
53     /**
54      * Set allowance for address to interact with contract
55      */
56     function allowAddress(address _address, bool _allow) onlyOwner external {
57         require(_address != address(0));
58         allowedAddresses[_address] = _allow;
59     }
60 }
61 
62 /**
63  * @title ERC20Basic
64  * @dev Simpler version of ERC20 interface
65  * @dev see https://github.com/ethereum/EIPs/issues/179
66  */
67 contract ERC20Basic {
68   uint256 public totalSupply;
69   function balanceOf(address who) public constant returns (uint256);
70   function transfer(address to, uint256 value) public returns (bool);
71   event Transfer(address indexed from, address indexed to, uint256 value);
72 }
73 
74 /**
75  * @title ERC20 interface
76  * @dev see https://github.com/ethereum/EIPs/issues/20
77  */
78 contract ERC20 is ERC20Basic {
79   function allowance(address owner, address spender) public constant returns (uint256);
80   function transferFrom(address from, address to, uint256 value) public returns (bool);
81   function approve(address spender, uint256 value) public returns (bool);
82   event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 contract TokenInterface is ERC20 {
86     address public owner;
87 
88     function name() public constant returns (string);
89 
90     function symbol() public constant returns (string);
91 
92     function decimals() public constant returns (uint256);
93 
94     event Burn(address indexed tokensOwner, address indexed burner, uint256 value);
95 
96     function burnFrom(address _tokensOwner, uint256 _tokensToBurn) public;
97 }
98 
99 /**
100  * @title SafeMath
101  * @dev Math operations with safety checks that throw on error
102  */
103 library SafeMath {
104   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
105     uint256 c = a * b;
106     assert(a == 0 || c / a == b);
107     return c;
108   }
109 
110   function div(uint256 a, uint256 b) internal constant returns (uint256) {
111     // assert(b > 0); // Solidity automatically throws when dividing by 0
112     uint256 c = a / b;
113     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
114     return c;
115   }
116 
117   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
118     assert(b <= a);
119     return a - b;
120   }
121 
122   function add(uint256 a, uint256 b) internal constant returns (uint256) {
123     uint256 c = a + b;
124     assert(c >= a);
125     return c;
126   }
127 }
128 
129 /**
130  * @title Basic token
131  * @dev Basic version of StandardToken, with no allowances.
132  */
133 contract BasicToken is ERC20Basic {
134   using SafeMath for uint256;
135 
136   mapping(address => uint256) balances;
137 
138   /**
139   * @dev transfer token for a specified address
140   * @param _to The address to transfer to.
141   * @param _value The amount to be transferred.
142   */
143   function transfer(address _to, uint256 _value) public returns (bool) {
144     require(_to != address(0));
145 
146     // SafeMath.sub will throw if there is not enough balance.
147     balances[msg.sender] = balances[msg.sender].sub(_value);
148     balances[_to] = balances[_to].add(_value);
149     Transfer(msg.sender, _to, _value);
150     return true;
151   }
152 
153   /**
154   * @dev Gets the balance of the specified address.
155   * @param _owner The address to query the the balance of.
156   * @return An uint256 representing the amount owned by the passed address.
157   */
158   function balanceOf(address _owner) public constant returns (uint256 balance) {
159     return balances[_owner];
160   }
161 
162 }
163 
164 /**
165  * @title Standard ERC20 token
166  *
167  * @dev Implementation of the basic standard token.
168  * @dev https://github.com/ethereum/EIPs/issues/20
169  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
170  */
171 contract StandardToken is ERC20, BasicToken {
172 
173   mapping (address => mapping (address => uint256)) allowed;
174 
175 
176   /**
177    * @dev Transfer tokens from one address to another
178    * @param _from address The address which you want to send tokens from
179    * @param _to address The address which you want to transfer to
180    * @param _value uint256 the amount of tokens to be transferred
181    */
182   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
183     require(_to != address(0));
184 
185     uint256 _allowance = allowed[_from][msg.sender];
186 
187     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
188     // require (_value <= _allowance);
189 
190     balances[_from] = balances[_from].sub(_value);
191     balances[_to] = balances[_to].add(_value);
192     allowed[_from][msg.sender] = _allowance.sub(_value);
193     Transfer(_from, _to, _value);
194     return true;
195   }
196 
197   /**
198    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
199    *
200    * Beware that changing an allowance with this method brings the risk that someone may use both the old
201    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
202    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
203    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
204    * @param _spender The address which will spend the funds.
205    * @param _value The amount of tokens to be spent.
206    */
207   function approve(address _spender, uint256 _value) public returns (bool) {
208     allowed[msg.sender][_spender] = _value;
209     Approval(msg.sender, _spender, _value);
210     return true;
211   }
212 
213   /**
214    * @dev Function to check the amount of tokens that an owner allowed to a spender.
215    * @param _owner address The address which owns the funds.
216    * @param _spender address The address which will spend the funds.
217    * @return A uint256 specifying the amount of tokens still available for the spender.
218    */
219   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
220     return allowed[_owner][_spender];
221   }
222 
223   /**
224    * approve should be called when allowed[_spender] == 0. To increment
225    * allowed value is better to use this function to avoid 2 calls (and wait until
226    * the first transaction is mined)
227    * From MonolithDAO Token.sol
228    */
229   function increaseApproval (address _spender, uint _addedValue)
230     returns (bool success) {
231     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
232     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
233     return true;
234   }
235 
236   function decreaseApproval (address _spender, uint _subtractedValue)
237     returns (bool success) {
238     uint oldValue = allowed[msg.sender][_spender];
239     if (_subtractedValue > oldValue) {
240       allowed[msg.sender][_spender] = 0;
241     } else {
242       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
243     }
244     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
245     return true;
246   }
247 
248 }
249 
250 /**
251  * @title Contracts that should not own Ether
252  * @author Remco Bloemen <remco@2π.com>
253  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
254  * in the contract, it will allow the owner to reclaim this ether.
255  * @notice Ether can still be send to this contract by:
256  * calling functions labeled `payable`
257  * `selfdestruct(contract_address)`
258  * mining directly to the contract address
259 */
260 contract HasNoEther is Ownable {
261 
262   /**
263   * @dev Constructor that rejects incoming Ether
264   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
265   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
266   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
267   * we could use assembly to access msg.value.
268   */
269   function HasNoEther() payable {
270     require(msg.value == 0);
271   }
272 
273   /**
274    * @dev Disallows direct send by settings a default function without the `payable` flag.
275    */
276   function() external {
277   }
278 
279   /**
280    * @dev Transfer all Ether held by the contract to the owner.
281    */
282   function reclaimEther() external onlyOwner {
283     assert(owner.send(this.balance));
284   }
285 }
286 
287 /**
288  * @title Claimable
289  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
290  * This allows the new owner to accept the transfer.
291  */
292 contract Claimable is Ownable {
293   address public pendingOwner;
294 
295   /**
296    * @dev Modifier throws if called by any account other than the pendingOwner.
297    */
298   modifier onlyPendingOwner() {
299     require(msg.sender == pendingOwner);
300     _;
301   }
302 
303   /**
304    * @dev Allows the current owner to set the pendingOwner address.
305    * @param newOwner The address to transfer ownership to.
306    */
307   function transferOwnership(address newOwner) onlyOwner public {
308     pendingOwner = newOwner;
309   }
310 
311   /**
312    * @dev Allows the pendingOwner address to finalize the transfer.
313    */
314   function claimOwnership() onlyPendingOwner public {
315     OwnershipTransferred(owner, pendingOwner);
316     owner = pendingOwner;
317     pendingOwner = 0x0;
318   }
319 }
320 
321 contract FamilyPointsToken is TokenInterface, StandardToken, OnlyAllowedAddresses, HasNoEther, Claimable {
322     event Burn(address indexed tokensOwner, address indexed burner, uint256 value);
323 
324     function FamilyPointsToken() {
325         totalSupply = uint256(225 * 10 ** (6 + 18));
326         balances[msg.sender] = totalSupply;
327     }
328 
329     function name() public constant returns (string) {
330         return "FamilyPoints Token";
331     }
332 
333     function symbol() public constant returns (string) {
334         return "FPT";
335     }
336 
337     function decimals() public constant returns (uint256) {
338         return uint256(18);
339     }
340 
341     /**
342      * @dev Burns a specific amount of tokens. Updated version of the BurnableToken methods from OpenZeppelin 1.3.0
343      * @param _tokensToBurn The amount of token to be burned.
344      */
345     function burnFrom(address _tokensOwner, uint256 _tokensToBurn) onlyAllowedAddresses public {
346         require(_tokensToBurn > 0);
347 
348         address burner = msg.sender;
349 
350         //If we are not own this tokens we should be checked for allowance
351         if (_tokensOwner != burner) {
352             uint256 allowedTokens = allowance(_tokensOwner, burner);
353             require(allowedTokens >= _tokensToBurn);
354         }
355 
356         balances[_tokensOwner] = balances[_tokensOwner].sub(_tokensToBurn);
357         totalSupply = totalSupply.sub(_tokensToBurn);
358         Burn(_tokensOwner, burner, _tokensToBurn);
359     }
360 }