1 /**
2 *   Prod Ethereum Contract for AFTK Token
3 *   Developed By: AiFinTek    
4 *   Author: AiFinTek Dev Team
5 *   Desc: 25 Mil Max Supply - Not Mintable
6 *   Ver 1.2
7 **/
8 pragma solidity ^0.4.18;
9 
10 library SafeMath {
11 
12     /**
13     * @dev Multiplies two numbers, throws on overflow.
14     */
15     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16         if (a == 0) {
17             return 0;
18         }
19         uint256 c = a * b;
20         assert(c / a == b);
21         return c;
22     }
23 
24     /**
25     * @dev Integer division of two numbers, truncating the quotient.
26     */
27     function div(uint256 a, uint256 b) internal pure returns (uint256) {
28         // assert(b > 0); // Solidity automatically throws when dividing by 0
29         uint256 c = a / b;
30         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31         return c;
32     }
33 
34     /**
35     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36     */
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         assert(b <= a);
39         return a - b;
40     }
41 
42     /**
43     * @dev Adds two numbers, throws on overflow.
44     */
45     function add(uint256 a, uint256 b) internal pure returns (uint256) {
46         uint256 c = a + b;
47         assert(c >= a);
48         return c;
49     }
50 }
51 
52 
53 
54 /**
55 *   Purpose: Define Owner and all ownership transfer
56 *   Author: AiFinTek Dev Team
57 **/
58 contract Ownable {
59     address public owner;
60 
61 
62     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64 
65     /**
66      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
67      * account.
68      */
69     function Ownable() public {
70         owner = msg.sender;
71     }
72 
73     /**
74      * @dev Throws if called by any account other than the owner.
75      */
76     modifier onlyOwner() {
77         require(msg.sender == owner);
78         _;
79     }
80 
81     /**
82      * @dev Allows the current owner to transfer control of the contract to a newOwner.
83      * @param newOwner The address to transfer ownership to.
84      */
85     function transferOwnership(address newOwner) public onlyOwner {
86         require(newOwner != address(0));
87         OwnershipTransferred(owner, newOwner);
88         owner = newOwner;
89     }
90 
91 }
92 
93 /**
94 *   Purpose: Interface for basic operations
95 *   Author: AiFinTek Dev Team
96 **/
97 contract ERC20Basic {
98     function totalSupply() public view returns (uint256);
99     function balanceOf(address who) public view returns (uint256);
100     function transfer(address to, uint256 value) public returns (bool);
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 }
103 
104 /**
105 *   Purpose: Implementation for basic operations
106 *   Author: AiFinTek Dev Team
107 **/
108 contract BasicToken is ERC20Basic {
109     using SafeMath for uint256;
110 
111     mapping(address => uint256) balances;
112 
113     uint256 totalSupply_;
114 
115     /**
116     * @dev total number of tokens in existence
117     */
118     function totalSupply() public view returns (uint256) {
119         return totalSupply_;
120     }
121 
122     /**
123     * @dev Gets the balance of the specified address.
124     * @param _owner The address to query the the balance of.
125     * @return An uint256 representing the amount owned by the passed address.
126     */
127     function balanceOf(address _owner) public view returns (uint256 balance) {
128         return balances[_owner];
129     }
130 
131 
132     /**
133     * @dev transfer token for a specified address
134     * @param _to The address to transfer to.
135     * @param _value The amount to be transferred.
136     */
137     function transfer(address _to, uint256 _value) public returns (bool) {
138         require(_to != address(0));
139         require(_value <= balances[msg.sender]);
140 
141         // SafeMath.sub will throw if there is not enough balance.
142         balances[msg.sender] = balances[msg.sender].sub(_value);
143         balances[_to] = balances[_to].add(_value);
144         Transfer(msg.sender, _to, _value);
145         return true;
146     }
147 
148     
149 }
150 
151 /**
152 *   Purpose: BasicToken with Burn Functionality
153 *   Author: AiFinTek Dev Team
154 **/
155 contract AFTKBurnableToken is BasicToken, Ownable {
156 
157     event Burn(address indexed burner, uint256 value);
158 
159     /**
160      * @dev Burns a specific amount of tokens.
161      * @param _value The amount of token to be burned.
162      */
163     function burn(uint256 _value) onlyOwner public {
164         require(_value <= balances[msg.sender]);
165         // no need to require value <= totalSupply, since that would imply the
166         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
167 
168         address burner = msg.sender;
169         balances[burner] = balances[burner].sub(_value);
170         totalSupply_ = totalSupply_.sub(_value);
171         Burn(burner, _value);
172     }
173 
174 
175     /**
176      * Destroy tokens from other account
177      *
178      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
179      *
180      * @param _from the address of the sender
181      * @param _value the amount of money to burn
182      */
183     function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {
184         
185         address burner = _from;
186 
187         require(_value <= balances[burner]);
188         // no need to require value <= totalSupply, since that would imply the
189         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
190 
191         
192         balances[burner] = balances[burner].sub(_value);
193         totalSupply_ = totalSupply_.sub(_value);
194         Burn(burner, _value);
195 
196         return true;
197     }
198 }
199 
200 
201 /**
202 *   Purpose: Authorize other user to spend certain amount. Only Owner can allow.
203 *   Author: AiFinTek Dev Team
204 **/
205 contract ERC20 is ERC20Basic {
206     function allowance(address owner, address spender) public view returns (uint256);
207     function transferFrom(address from, address to, uint256 value) public returns (bool);
208     function approve(address spender, uint256 value) public returns (bool);
209     event Approval(address indexed owner, address indexed spender, uint256 value);
210 }
211 
212 
213 /**
214 *   Purpose: Define library for Safe Approval and Transfer
215 *   Author: AiFinTek Dev Team
216 **/
217 library SafeERC20 {
218     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
219         assert(token.transfer(to, value));
220     }
221 
222     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
223         assert(token.transferFrom(from, to, value));
224     }
225 
226     function safeApprove(ERC20 token, address spender, uint256 value) internal {
227         assert(token.approve(spender, value));
228     }
229 }
230 
231 
232 /**
233 *   Purpose: Standard Token supporting Allowance and BasicToken Technology
234 *   Author: AiFinTek Dev Team
235 **/
236 contract StandardToken is ERC20, BasicToken {
237 
238     mapping (address => mapping (address => uint256)) internal allowed;
239 
240 
241     /**
242      * @dev Transfer tokens from one address to another
243      * @param _from address The address which you want to send tokens from
244      * @param _to address The address which you want to transfer to
245      * @param _value uint256 the amount of tokens to be transferred
246      */
247     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
248         require(_to != address(0));
249         require(_value <= balances[_from]);
250         require(_value <= allowed[_from][msg.sender]);
251 
252         balances[_from] = balances[_from].sub(_value);
253         balances[_to] = balances[_to].add(_value);
254         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
255         Transfer(_from, _to, _value);
256         return true;
257     }
258 
259     /**
260      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
261      *
262      * Beware that changing an allowance with this method brings the risk that someone may use both the old
263      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
264      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
265      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
266      * @param _spender The address which will spend the funds.
267      * @param _value The amount of tokens to be spent.
268      */
269     function approve(address _spender, uint256 _value) public returns (bool) {
270         allowed[msg.sender][_spender] = _value;
271         Approval(msg.sender, _spender, _value);
272         return true;
273     }
274 
275     /**
276      * @dev Function to check the amount of tokens that an owner allowed to a spender.
277      * @param _owner address The address which owns the funds.
278      * @param _spender address The address which will spend the funds.
279      * @return A uint256 specifying the amount of tokens still available for the spender.
280      */
281     function allowance(address _owner, address _spender) public view returns (uint256) {
282         return allowed[_owner][_spender];
283     }
284 
285     /**
286      * @dev Increase the amount of tokens that an owner allowed to a spender.
287      *
288      * approve should be called when allowed[_spender] == 0. To increment
289      * allowed value is better to use this function to avoid 2 calls (and wait until
290      * the first transaction is mined)
291      * From MonolithDAO Token.sol
292      * @param _spender The address which will spend the funds.
293      * @param _addedValue The amount of tokens to increase the allowance by.
294      */
295     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
296         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
297         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
298         return true;
299     }
300 
301     /**
302      * @dev Decrease the amount of tokens that an owner allowed to a spender.
303      *
304      * approve should be called when allowed[_spender] == 0. To decrement
305      * allowed value is better to use this function to avoid 2 calls (and wait until
306      * the first transaction is mined)
307      * From MonolithDAO Token.sol
308      * @param _spender The address which will spend the funds.
309      * @param _subtractedValue The amount of tokens to decrease the allowance by.
310      */
311     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
312         uint oldValue = allowed[msg.sender][_spender];
313         if (_subtractedValue > oldValue) {
314             allowed[msg.sender][_spender] = 0;
315         } else {
316             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
317         }
318         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
319         return true;
320     }
321 
322 }
323 
324 
325 
326 contract MintableToken is StandardToken, Ownable {
327   event Mint(address indexed to, uint256 amount);
328   event MintFinished();
329 
330   bool public mintingFinished = false;
331 
332 
333   modifier canMint() {
334     require(!mintingFinished);
335     _;
336   }
337 
338   /**
339    * @dev Function to mint tokens
340    * @param _to The address that will receive the minted tokens.
341    * @param _amount The amount of tokens to mint.
342    * @return A boolean that indicates if the operation was successful.
343    */
344   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
345     totalSupply_ = totalSupply_.add(_amount);
346     balances[_to] = balances[_to].add(_amount);
347     Mint(_to, _amount);
348     Transfer(0x0, _to, _amount);
349     return true;
350   }
351 
352   /**
353    * @dev Function to stop minting new tokens.
354    * @return True if the operation was successful.
355    */
356   function finishMinting() onlyOwner public returns (bool) {
357     mintingFinished = true;
358     MintFinished();
359     return true;
360   }
361 }
362 
363 /**
364 *   Prod Ethereum Contract for AFTK Token
365 *   Developed By: AiFinTek    
366 *   Author: AiFinTek Dev Team
367 *   Desc: 25 Mil Max Supply - Not Mintable
368 *   Ver 1.2
369 **/
370 contract AFTKToken is MintableToken, AFTKBurnableToken {
371     string public constant name = 'AFTK Token';
372     string public constant symbol = 'AFTK';
373     uint8 public constant decimals = 18;
374 }