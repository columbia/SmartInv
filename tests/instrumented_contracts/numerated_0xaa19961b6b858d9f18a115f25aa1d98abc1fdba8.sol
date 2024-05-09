1 /*
2  *  LocalCoinSwap Cryptoshare Source Code
3  *         www.localcoinswap.com
4  */
5 
6 pragma solidity ^0.4.19;
7 
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 contract Ownable {
51   address public owner;
52 
53 
54   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 
56 
57   /**
58    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
59    * account.
60    */
61   function Ownable() public {
62     owner = msg.sender;
63   }
64 
65   /**
66    * @dev Throws if called by any account other than the owner.
67    */
68   modifier onlyOwner() {
69     require(msg.sender == owner);
70     _;
71   }
72 
73   /**
74    * @dev Allows the current owner to transfer control of the contract to a newOwner.
75    * @param newOwner The address to transfer ownership to.
76    */
77   function transferOwnership(address newOwner) public onlyOwner {
78     require(newOwner != address(0));
79     OwnershipTransferred(owner, newOwner);
80     owner = newOwner;
81   }
82 
83 }
84 
85 contract ERC20Basic {
86   function totalSupply() public view returns (uint256);
87   function balanceOf(address who) public view returns (uint256);
88   function transfer(address to, uint256 value) public returns (bool);
89   event Transfer(address indexed from, address indexed to, uint256 value);
90 }
91 
92 contract BasicToken is ERC20Basic {
93   using SafeMath for uint256;
94 
95   mapping(address => uint256) balances;
96 
97   uint256 totalSupply_;
98 
99   /**
100   * @dev total number of tokens in existence
101   */
102   function totalSupply() public view returns (uint256) {
103     return totalSupply_;
104   }
105 
106   /**
107   * @dev transfer token for a specified address
108   * @param _to The address to transfer to.
109   * @param _value The amount to be transferred.
110   */
111   function transfer(address _to, uint256 _value) public returns (bool) {
112     require(_to != address(0));
113     require(_value <= balances[msg.sender]);
114 
115     // SafeMath.sub will throw if there is not enough balance.
116     balances[msg.sender] = balances[msg.sender].sub(_value);
117     balances[_to] = balances[_to].add(_value);
118     Transfer(msg.sender, _to, _value);
119     return true;
120   }
121 
122   /**
123   * @dev Gets the balance of the specified address.
124   * @param _owner The address to query the the balance of.
125   * @return An uint256 representing the amount owned by the passed address.
126   */
127   function balanceOf(address _owner) public view returns (uint256 balance) {
128     return balances[_owner];
129   }
130 
131 }
132 
133 contract BurnableToken is BasicToken {
134 
135   event Burn(address indexed burner, uint256 value);
136 
137   /**
138    * @dev Burns a specific amount of tokens.
139    * @param _value The amount of token to be burned.
140    */
141   function burn(uint256 _value) public {
142     require(_value <= balances[msg.sender]);
143     // no need to require value <= totalSupply, since that would imply the
144     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
145 
146     address burner = msg.sender;
147     balances[burner] = balances[burner].sub(_value);
148     totalSupply_ = totalSupply_.sub(_value);
149     Burn(burner, _value);
150   }
151 }
152 
153 contract ERC20 is ERC20Basic {
154   function allowance(address owner, address spender) public view returns (uint256);
155   function transferFrom(address from, address to, uint256 value) public returns (bool);
156   function approve(address spender, uint256 value) public returns (bool);
157   event Approval(address indexed owner, address indexed spender, uint256 value);
158 }
159 
160 contract StandardToken is ERC20, BasicToken {
161 
162   mapping (address => mapping (address => uint256)) internal allowed;
163 
164 
165   /**
166    * @dev Transfer tokens from one address to another
167    * @param _from address The address which you want to send tokens from
168    * @param _to address The address which you want to transfer to
169    * @param _value uint256 the amount of tokens to be transferred
170    */
171   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
172     require(_to != address(0));
173     require(_value <= balances[_from]);
174     require(_value <= allowed[_from][msg.sender]);
175 
176     balances[_from] = balances[_from].sub(_value);
177     balances[_to] = balances[_to].add(_value);
178     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
179     Transfer(_from, _to, _value);
180     return true;
181   }
182 
183   /**
184    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
185    *
186    * Beware that changing an allowance with this method brings the risk that someone may use both the old
187    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
188    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
189    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
190    * @param _spender The address which will spend the funds.
191    * @param _value The amount of tokens to be spent.
192    */
193   function approve(address _spender, uint256 _value) public returns (bool) {
194     allowed[msg.sender][_spender] = _value;
195     Approval(msg.sender, _spender, _value);
196     return true;
197   }
198 
199   /**
200    * @dev Function to check the amount of tokens that an owner allowed to a spender.
201    * @param _owner address The address which owns the funds.
202    * @param _spender address The address which will spend the funds.
203    * @return A uint256 specifying the amount of tokens still available for the spender.
204    */
205   function allowance(address _owner, address _spender) public view returns (uint256) {
206     return allowed[_owner][_spender];
207   }
208 
209   /**
210    * @dev Increase the amount of tokens that an owner allowed to a spender.
211    *
212    * approve should be called when allowed[_spender] == 0. To increment
213    * allowed value is better to use this function to avoid 2 calls (and wait until
214    * the first transaction is mined)
215    * From MonolithDAO Token.sol
216    * @param _spender The address which will spend the funds.
217    * @param _addedValue The amount of tokens to increase the allowance by.
218    */
219   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
220     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
221     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222     return true;
223   }
224 
225   /**
226    * @dev Decrease the amount of tokens that an owner allowed to a spender.
227    *
228    * approve should be called when allowed[_spender] == 0. To decrement
229    * allowed value is better to use this function to avoid 2 calls (and wait until
230    * the first transaction is mined)
231    * From MonolithDAO Token.sol
232    * @param _spender The address which will spend the funds.
233    * @param _subtractedValue The amount of tokens to decrease the allowance by.
234    */
235   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
236     uint oldValue = allowed[msg.sender][_spender];
237     if (_subtractedValue > oldValue) {
238       allowed[msg.sender][_spender] = 0;
239     } else {
240       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
241     }
242     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
243     return true;
244   }
245 
246 }
247 
248 contract DerivativeTokenInterface {
249     function mint(address _to, uint256 _amount) public returns (bool);
250 }
251 
252 contract LCS is StandardToken, BurnableToken, Ownable {
253     string public constant name = "LocalCoinSwap Cryptoshare";
254     string public constant symbol = "LCS";
255     uint256 public constant decimals = 18;
256     uint256 public constant initialSupply = 100000000 * (10 ** 18);
257 
258     // Array of derivative token addresses
259     DerivativeTokenInterface[] public derivativeTokens;
260 
261     bool public nextDerivativeTokenScheduled = false;
262 
263     // Time until next token distribution
264     uint256 public nextDerivativeTokenTime;
265 
266     // Next token to be distrubuted
267     DerivativeTokenInterface public nextDerivativeToken;
268 
269     // Index of last token claimed by LCS holder, required for holder to claim unclaimed tokens
270     mapping (address => uint256) lastDerivativeTokens;
271 
272     function LCS() public {
273         totalSupply_ = initialSupply;
274         balances[msg.sender] = totalSupply_;
275         Transfer(0, msg.sender, totalSupply_);
276     }
277 
278     // Event for token distribution
279     event DistributeDerivativeTokens(address indexed to, uint256 number, uint256 amount);
280 
281     // Modifier to handle token distribution
282     modifier handleDerivativeTokens(address from) {
283         if (nextDerivativeTokenScheduled && now > nextDerivativeTokenTime) {
284             derivativeTokens.push(nextDerivativeToken);
285 
286             nextDerivativeTokenScheduled = false;
287 
288             delete nextDerivativeTokenTime;
289             delete nextDerivativeToken;
290         }
291 
292         for (uint256 i = lastDerivativeTokens[from]; i < derivativeTokens.length; i++) {
293             // Since tokens haven't redeemed yet, mint new ones and send them to LCS holder
294             derivativeTokens[i].mint(from, balances[from]);
295             DistributeDerivativeTokens(from, i, balances[from]);
296         }
297 
298         lastDerivativeTokens[from] = derivativeTokens.length;
299 
300         _;
301     }
302 
303     // Claim unclaimed derivative tokens
304     function claimDerivativeTokens() public handleDerivativeTokens(msg.sender) returns (bool) {
305         return true;
306     }
307 
308     // Set the address and release time of the next token distribution
309     function scheduleNewDerivativeToken(address _address, uint256 _time) public onlyOwner returns (bool) {
310         require(!nextDerivativeTokenScheduled);
311 
312         nextDerivativeTokenScheduled = true;
313         nextDerivativeTokenTime = _time;
314         nextDerivativeToken = DerivativeTokenInterface(_address);
315 
316         return true;
317     }
318 
319     // Make sure derivative tokens are handled for the _from and _to addresses
320     function transferFrom(address _from, address _to, uint256 _value) public handleDerivativeTokens(_from) handleDerivativeTokens(_to) returns (bool) {
321         return super.transferFrom(_from, _to, _value);
322     }
323 
324     // Make sure derivative tokens are handled for the msg.sender and _to addresses
325     function transfer(address _to, uint256 _value) public handleDerivativeTokens(msg.sender) handleDerivativeTokens(_to) returns (bool) {
326         return super.transfer(_to, _value);
327     }
328 }