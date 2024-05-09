1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         if (a == 0) {
14             return 0;
15         }
16         c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         // uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return a / b;
29     }
30 
31     /**
32     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43         c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55     function totalSupply() public view returns (uint256);
56     function balanceOf(address who) public view returns (uint256);
57     function transfer(address to, uint256 value) public returns (bool);
58     event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 
62 /**
63  * @title ERC20 interface
64  * @dev see https://github.com/ethereum/EIPs/issues/20
65  */
66 contract ERC20 is ERC20Basic {
67     function allowance(address owner, address spender)
68         public view returns (uint256);
69 
70     function transferFrom(address from, address to, uint256 value)
71         public returns (bool);
72 
73     function approve(address spender, uint256 value) public returns (bool);
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 /**
78  * @title Basic token
79  * @dev Basic version of StandardToken, with no allowances.
80  */
81 contract BasicToken is ERC20Basic {
82     using SafeMath for uint256;
83 
84     mapping(address => uint256) balances;
85 
86     uint256 totalSupply_;
87 
88     /**
89     * @dev total number of tokens in existence
90     */
91     function totalSupply() public view returns (uint256) {
92         return totalSupply_;
93     }
94 
95     /**
96     * @dev transfer token for a specified address
97     * @param _to The address to transfer to.
98     * @param _value The amount to be transferred.
99     */
100     function transfer(address _to, uint256 _value) public returns (bool) {
101         require(_to != address(0));
102         require(_value <= balances[msg.sender]);
103 
104         balances[msg.sender] = balances[msg.sender].sub(_value);
105         balances[_to] = balances[_to].add(_value);
106         emit Transfer(msg.sender, _to, _value);
107         return true;
108     }
109 
110     /**
111     * @dev Gets the balance of the specified address.
112     * @param _owner The address to query the the balance of.
113     * @return An uint256 representing the amount owned by the passed address.
114     */
115     function balanceOf(address _owner) public view returns (uint256) {
116         return balances[_owner];
117     }
118 
119 }
120 
121 /**
122  * @title Standard ERC20 token
123  *
124  * @dev Implementation of the basic standard token.
125  * @dev https://github.com/ethereum/EIPs/issues/20
126  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
127  */
128 contract StandardToken is ERC20, BasicToken {
129 
130     mapping (address => mapping (address => uint256)) internal allowed;
131 
132 
133   /**
134    * @dev Transfer tokens from one address to another
135    * @param _from address The address which you want to send tokens from
136    * @param _to address The address which you want to transfer to
137    * @param _value uint256 the amount of tokens to be transferred
138    */
139     function transferFrom(
140         address _from,
141         address _to,
142         uint256 _value
143     )
144         public
145         returns (bool)
146     {
147         require(_to != address(0));
148         require(_value <= balances[_from]);
149         require(_value <= allowed[_from][msg.sender]);
150 
151         balances[_from] = balances[_from].sub(_value);
152         balances[_to] = balances[_to].add(_value);
153         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
154         emit Transfer(_from, _to, _value);
155         return true;
156     }
157 
158   /**
159    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
160    *
161    * Beware that changing an allowance with this method brings the risk that someone may use both the old
162    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
163    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
164    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165    * @param _spender The address which will spend the funds.
166    * @param _value The amount of tokens to be spent.
167    */
168     function approve(address _spender, uint256 _value) public returns (bool) {
169         allowed[msg.sender][_spender] = _value;
170         emit Approval(msg.sender, _spender, _value);
171         return true;
172     }
173 
174   /**
175    * @dev Function to check the amount of tokens that an owner allowed to a spender.
176    * @param _owner address The address which owns the funds.
177    * @param _spender address The address which will spend the funds.
178    * @return A uint256 specifying the amount of tokens still available for the spender.
179    */
180     function allowance(
181         address _owner,
182         address _spender
183     )
184         public
185         view
186         returns (uint256)
187     {
188         return allowed[_owner][_spender];
189     }
190 
191   /**
192    * @dev Increase the amount of tokens that an owner allowed to a spender.
193    *
194    * approve should be called when allowed[_spender] == 0. To increment
195    * allowed value is better to use this function to avoid 2 calls (and wait until
196    * the first transaction is mined)
197    * From MonolithDAO Token.sol
198    * @param _spender The address which will spend the funds.
199    * @param _addedValue The amount of tokens to increase the allowance by.
200    */
201     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
202         allowed[msg.sender][_spender] = (
203             allowed[msg.sender][_spender].add(_addedValue));
204         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
205         return true;
206     }
207 
208   /**
209    * @dev Decrease the amount of tokens that an owner allowed to a spender.
210    *
211    * approve should be called when allowed[_spender] == 0. To decrement
212    * allowed value is better to use this function to avoid 2 calls (and wait until
213    * the first transaction is mined)
214    * From MonolithDAO Token.sol
215    * @param _spender The address which will spend the funds.
216    * @param _subtractedValue The amount of tokens to decrease the allowance by.
217    */
218     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
219         uint oldValue = allowed[msg.sender][_spender];
220         if (_subtractedValue > oldValue) {
221             allowed[msg.sender][_spender] = 0;
222         } else {
223             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
224         }
225         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226         return true;
227     }
228 
229 }
230 
231 /**
232  * @title Ownable
233  * @dev The Ownable contract has an owner address, and provides basic authorization control
234  * functions, this simplifies the implementation of "user permissions".
235  */
236 contract Ownable {
237     address public owner;
238 
239 
240     event OwnershipRenounced(address indexed previousOwner);
241     event OwnershipTransferred(
242         address indexed previousOwner,
243         address indexed newOwner
244     );
245 
246 
247     /**
248     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
249     * account.
250     */
251     constructor() public {
252         owner = msg.sender;
253     }
254 
255     /**
256     * @dev Throws if called by any account other than the owner.
257     */
258     modifier onlyOwner() {
259         require(msg.sender == owner);
260         _;
261     }
262 
263     /**
264     * @dev Allows the current owner to transfer control of the contract to a newOwner.
265     * @param newOwner The address to transfer ownership to.
266     */
267     function transferOwnership(address newOwner) public onlyOwner {
268         require(newOwner != address(0));
269         emit OwnershipTransferred(owner, newOwner);
270         owner = newOwner;
271     }
272 
273     /**
274     * @dev Allows the current owner to relinquish control of the contract.
275     */
276     function renounceOwnership() public onlyOwner {
277         emit OwnershipRenounced(owner);
278         owner = address(0);
279     }
280 }
281 
282 contract BurnableMintableToken is BasicToken, Ownable {
283 
284     event Burn(address indexed burner, uint256 value);
285     event Mint(address indexed to, uint256 amount);
286     event MintFinished();
287 
288     bool public mintingFinished = false;
289 
290     /**
291     * @dev Burns a specific amount of tokens.
292     * @param _value The amount of token to be burned.
293     */
294     function burn(uint256 _value) public onlyOwner {
295         _burn(msg.sender, _value);
296     }
297 
298     function _burn(address _who, uint256 _value) internal {
299         require(_value <= balances[_who]);
300         // no need to require value <= totalSupply, since that would imply the
301         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
302 
303         balances[_who] = balances[_who].sub(_value);
304         totalSupply_ = totalSupply_.sub(_value);
305         emit Burn(_who, _value);
306         emit Transfer(_who, address(0), _value);
307     }
308 
309 
310 
311 
312     modifier canMint() {
313         require(!mintingFinished);
314         _;
315     }
316 
317     modifier hasMintPermission() {
318         require(msg.sender == owner);
319         _;
320     }
321 
322     /**
323     * @dev Function to mint tokens
324     * @param _to The address that will receive the minted tokens.
325     * @param _amount The amount of tokens to mint.
326     * @return A boolean that indicates if the operation was successful.
327     */
328     function mint(
329         address _to,
330         uint256 _amount
331     )
332         hasMintPermission
333         canMint
334         public
335         returns (bool)
336     {
337         totalSupply_ = totalSupply_.add(_amount);
338         balances[_to] = balances[_to].add(_amount);
339         emit Mint(_to, _amount);
340         emit Transfer(address(0), _to, _amount);
341         return true;
342     }
343 
344     /**
345     * @dev Function to stop minting new tokens.
346     * @return True if the operation was successful.
347     */
348     function finishMinting() onlyOwner canMint public returns (bool) {
349         mintingFinished = true;
350         emit MintFinished();
351         return true;
352     }
353 }
354 
355 contract PAYBUDToken is BurnableMintableToken {
356     string public constant name = "PAYBUD Token";
357     string public constant symbol = "PAYBUD";
358     uint8 public constant decimals = 18;
359 
360     constructor() public {
361         
362     }
363 }