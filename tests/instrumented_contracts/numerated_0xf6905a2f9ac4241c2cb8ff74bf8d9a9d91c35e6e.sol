1 /**
2 *   Prod Ethereum Contract for GoldCoin GOLDC
3 *   Author: Gold Coin Digger
4 *   Ver 1.2
5 **/
6 pragma solidity ^0.4.18;
7 
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     /**
23     * @dev Integer division of two numbers, truncating the quotient.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return c;
30     }
31 
32     /**
33     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34     */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     /**
41     * @dev Adds two numbers, throws on overflow.
42     */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 
51 
52 /**
53 *   Purpose: Define Owner and all ownership transfer
54 *   Author: Gold Coin Digger
55 **/
56 contract Ownable {
57     address public owner;
58 
59 
60     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62 
63     /**
64      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65      * account.
66      */
67     function Ownable() public {
68         owner = msg.sender;
69     }
70 
71     /**
72      * @dev Throws if called by any account other than the owner.
73      */
74     modifier onlyOwner() {
75         require(msg.sender == owner);
76         _;
77     }
78 
79     /**
80      * @dev Allows the current owner to transfer control of the contract to a newOwner.
81      * @param newOwner The address to transfer ownership to.
82      */
83     function transferOwnership(address newOwner) public onlyOwner {
84         require(newOwner != address(0));
85         OwnershipTransferred(owner, newOwner);
86         owner = newOwner;
87     }
88 
89 }
90 
91 /**
92 *   Purpose: Interface for basic operations
93 *   Author: Gold Coin Digger
94 **/
95 contract ERC20Basic {
96     function totalSupply() public view returns (uint256);
97     function balanceOf(address who) public view returns (uint256);
98     function transfer(address to, uint256 value) public returns (bool);
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 }
101 
102 /**
103 *   Purpose: Implementation for basic operations
104 *   Author: Gold Coin Digger
105 **/
106 contract BasicToken is ERC20Basic {
107     using SafeMath for uint256;
108 
109     mapping(address => uint256) balances;
110 
111     uint256 totalSupply_;
112 
113     /**
114     * @dev total number of tokens in existence
115     */
116     function totalSupply() public view returns (uint256) {
117         return totalSupply_;
118     }
119 
120     /**
121     * @dev Gets the balance of the specified address.
122     * @param _owner The address to query the the balance of.
123     * @return An uint256 representing the amount owned by the passed address.
124     */
125     function balanceOf(address _owner) public view returns (uint256 balance) {
126         return balances[_owner];
127     }
128 
129 
130     /**
131     * @dev transfer token for a specified address
132     * @param _to The address to transfer to.
133     * @param _value The amount to be transferred.
134     */
135     function transfer(address _to, uint256 _value) public returns (bool) {
136         require(_to != address(0));
137         require(_value <= balances[msg.sender]);
138 
139         // SafeMath.sub will throw if there is not enough balance.
140         balances[msg.sender] = balances[msg.sender].sub(_value);
141         balances[_to] = balances[_to].add(_value);
142         Transfer(msg.sender, _to, _value);
143         return true;
144     }
145 
146     
147 }
148 
149 /**
150 *   Purpose: BasicToken with Burn Functionality
151 *   Author: Gold Coin Digger
152 **/
153 contract GOLDCBurnableToken is BasicToken, Ownable {
154 
155     event Burn(address indexed burner, uint256 value);
156 
157     /**
158      * @dev Burns a specific amount of tokens.
159      * @param _value The amount of token to be burned.
160      */
161     function burn(uint256 _value) onlyOwner public {
162         require(_value <= balances[msg.sender]);
163         // no need to require value <= totalSupply, since that would imply the
164         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
165 
166         address burner = msg.sender;
167         balances[burner] = balances[burner].sub(_value);
168         totalSupply_ = totalSupply_.sub(_value);
169         Burn(burner, _value);
170     }
171 
172 
173     /**
174      * Destroy tokens from other account
175      *
176      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
177      *
178      * @param _from the address of the sender
179      * @param _value the amount of money to burn
180      */
181     function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {
182         
183         address burner = _from;
184 
185         require(_value <= balances[burner]);
186         // no need to require value <= totalSupply, since that would imply the
187         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
188 
189         
190         balances[burner] = balances[burner].sub(_value);
191         totalSupply_ = totalSupply_.sub(_value);
192         Burn(burner, _value);
193 
194         return true;
195     }
196 
197     /* Function to recover the funds on the contract */
198     function kill() onlyOwner public returns (bool success) {
199         address owner = msg.sender;
200         selfdestruct(owner);
201         return true;
202     }
203 }
204 
205 
206 /**
207 *   Purpose: Authorize other user to spend certain amount. Only Owner can allow.
208 *   Author: Gold Coin Digger
209 **/
210 contract ERC20 is ERC20Basic {
211     function allowance(address owner, address spender) public view returns (uint256);
212     function transferFrom(address from, address to, uint256 value) public returns (bool);
213     function approve(address spender, uint256 value) public returns (bool);
214     event Approval(address indexed owner, address indexed spender, uint256 value);
215 }
216 
217 
218 /**
219 *   Purpose: Define library for Safe Approval and Transfer
220 *   Author: Gold Coin Digger
221 **/
222 library SafeERC20 {
223     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
224         assert(token.transfer(to, value));
225     }
226 
227     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
228         assert(token.transferFrom(from, to, value));
229     }
230 
231     function safeApprove(ERC20 token, address spender, uint256 value) internal {
232         assert(token.approve(spender, value));
233     }
234 }
235 
236 
237 /**
238 *   Purpose: Standard Token supporting Allowance and BasicToken Technology
239 *   Author: Gold Coin Digger
240 **/
241 contract StandardToken is ERC20, BasicToken {
242 
243     mapping (address => mapping (address => uint256)) internal allowed;
244 
245 
246     /**
247      * @dev Transfer tokens from one address to another
248      * @param _from address The address which you want to send tokens from
249      * @param _to address The address which you want to transfer to
250      * @param _value uint256 the amount of tokens to be transferred
251      */
252     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
253         require(_to != address(0));
254         require(_value <= balances[_from]);
255         require(_value <= allowed[_from][msg.sender]);
256 
257         balances[_from] = balances[_from].sub(_value);
258         balances[_to] = balances[_to].add(_value);
259         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
260         Transfer(_from, _to, _value);
261         return true;
262     }
263 
264     /**
265      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
266      *
267      * Beware that changing an allowance with this method brings the risk that someone may use both the old
268      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
269      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
270      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
271      * @param _spender The address which will spend the funds.
272      * @param _value The amount of tokens to be spent.
273      */
274     function approve(address _spender, uint256 _value) public returns (bool) {
275         allowed[msg.sender][_spender] = _value;
276         Approval(msg.sender, _spender, _value);
277         return true;
278     }
279 
280     /**
281      * @dev Function to check the amount of tokens that an owner allowed to a spender.
282      * @param _owner address The address which owns the funds.
283      * @param _spender address The address which will spend the funds.
284      * @return A uint256 specifying the amount of tokens still available for the spender.
285      */
286     function allowance(address _owner, address _spender) public view returns (uint256) {
287         return allowed[_owner][_spender];
288     }
289 
290     /**
291      * @dev Increase the amount of tokens that an owner allowed to a spender.
292      *
293      * approve should be called when allowed[_spender] == 0. To increment
294      * allowed value is better to use this function to avoid 2 calls (and wait until
295      * the first transaction is mined)
296      * From MonolithDAO Token.sol
297      * @param _spender The address which will spend the funds.
298      * @param _addedValue The amount of tokens to increase the allowance by.
299      */
300     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
301         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
302         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
303         return true;
304     }
305 
306     /**
307      * @dev Decrease the amount of tokens that an owner allowed to a spender.
308      *
309      * approve should be called when allowed[_spender] == 0. To decrement
310      * allowed value is better to use this function to avoid 2 calls (and wait until
311      * the first transaction is mined)
312      * From MonolithDAO Token.sol
313      * @param _spender The address which will spend the funds.
314      * @param _subtractedValue The amount of tokens to decrease the allowance by.
315      */
316     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
317         uint oldValue = allowed[msg.sender][_spender];
318         if (_subtractedValue > oldValue) {
319             allowed[msg.sender][_spender] = 0;
320         } else {
321             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
322         }
323         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
324         return true;
325     }
326 
327 }
328 
329 
330 
331 contract MintableToken is StandardToken, Ownable {
332   event Mint(address indexed to, uint256 amount);
333   event MintFinished();
334 
335   bool public mintingFinished = false;
336 
337 
338   modifier canMint() {
339     require(!mintingFinished);
340     _;
341   }
342 
343   /**
344    * @dev Function to mint tokens
345    * @param _to The address that will receive the minted tokens.
346    * @param _amount The amount of tokens to mint.
347    * @return A boolean that indicates if the operation was successful.
348    */
349   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
350     totalSupply_ = totalSupply_.add(_amount);
351     balances[_to] = balances[_to].add(_amount);
352     Mint(_to, _amount);
353     Transfer(0x0, _to, _amount);
354     return true;
355   }
356 
357   /**
358    * @dev Function to stop minting new tokens.
359    * @return True if the operation was successful.
360    */
361   function finishMinting() onlyOwner public returns (bool) {
362     mintingFinished = true;
363     MintFinished();
364     return true;
365   }
366 }
367 
368 contract GOLDCToken is MintableToken, GOLDCBurnableToken {
369     string public constant name = 'GOLDC Token';
370     string public constant symbol = 'GOLDC';
371     uint8 public constant decimals = 18;
372 }