1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11     event OwnershipRenounced(address indexed previousOwner);
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14     /**
15      * @dev The Ownable constructor sets the original owner of the contract to the sender
16      * account.
17      */
18     constructor() public {
19         owner = msg.sender;
20     }
21 
22     /**
23      * @dev Throws if called by any account other than the owner.
24      */
25     modifier onlyOwner() {
26         require(msg.sender == owner);
27         _;
28     }
29 
30     /**
31      * @dev Allows the current owner to transfer control of the contract to a newOwner.
32      * @param _newOwner The address to transfer ownership to.
33      */
34     function transferOwnership(address _newOwner) public onlyOwner {
35         _transferOwnership(_newOwner);
36     }
37 
38     /**
39      * @dev Transfers control of the contract to a newOwner.
40      * @param _newOwner The address to transfer ownership to.
41      */
42     function _transferOwnership(address _newOwner) internal {
43         require(_newOwner != address(0));
44         emit OwnershipTransferred(owner, _newOwner);
45         owner = _newOwner;
46     }
47 }
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  */
53 contract ERC20Basic {
54     function totalSupply() public view returns (uint256);
55 
56     function balanceOf(address who) public view returns (uint256);
57 
58     function transfer(address to, uint256 value) public returns (bool);
59 
60     event Transfer(address indexed from, address indexed to, uint256 value);
61 }
62 
63 /**
64  * @title ERC20 interface
65  */
66 contract ERC20 is ERC20Basic {
67     function allowance(address owner, address spender)
68     public view returns (uint256);
69 
70     function transferFrom(address from, address to, uint256 value)
71     public returns (bool);
72 
73     function approve(address spender, uint256 value) public returns (bool);
74 
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 /**
79  * @title SafeMath
80  * @dev Math operations with safety checks that throw on error
81  */
82 library SafeMath {
83 
84     /**
85     * @dev Multiplies two numbers, throws on overflow.
86     */
87     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
88         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
89         // benefit is lost if 'b' is also tested.
90         if (a == 0) {
91             return 0;
92         }
93 
94         c = a * b;
95         assert(c / a == b);
96         return c;
97     }
98 
99     /**
100     * @dev Integer division of two numbers, truncating the quotient.
101     */
102     function div(uint256 a, uint256 b) internal pure returns (uint256) {
103         // assert(b > 0); // Solidity automatically throws when dividing by 0
104         // uint256 c = a / b;
105         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
106         return a / b;
107     }
108 
109     /**
110     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
111     */
112     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
113         assert(b <= a);
114         return a - b;
115     }
116 
117     /**
118     * @dev Adds two numbers, throws on overflow.
119     */
120     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
121         c = a + b;
122         assert(c >= a);
123         return c;
124     }
125 }
126 
127 /**
128  * Utility library of inline functions on addresses
129  */
130 library AddressUtils {
131     /**
132          * Returns whether the target address is a contract
133          * @dev This function will return false if invoked during the constructor of a contract,
134          * as the code is not actually created until after the constructor finishes.
135          * @param addr address to check
136          * @return whether the target address is a contract
137          */
138     function isContract(address addr) internal view returns (bool) {
139         uint256 size;
140         // XXX Currently there is no better way to check if there is a contract in an address
141         // than to check the size of the code at that address.
142         // See https://ethereum.stackexchange.com/a/14016/36603
143         // for more details about how this works.
144         // TODO Check this again before the Serenity release, because all addresses will be
145         // contracts then.
146         // solium-disable-next-line security/no-inline-assembly
147         assembly { size := extcodesize(addr) }
148         return size > 0;
149     }
150 
151 }
152 
153 /**
154  * @title Basic token
155  * @dev Basic version of StandardToken, with no allowances.
156  */
157 contract BasicToken is ERC20Basic {
158     using SafeMath for uint256;
159 
160     mapping(address => uint256) balances;
161 
162     uint256 totalSupply_;
163 
164     /**
165     * @dev Total number of tokens in existence
166     */
167     function totalSupply() public view returns (uint256) {
168         return totalSupply_;
169     }
170 
171     /**
172     * Internal transfer, only can be called by this contract
173     */
174 
175     function _transfer(address _to, uint _value) internal {
176         require(_to != address(0));
177         require(_value <= balances[msg.sender]);
178 
179         balances[msg.sender] = balances[msg.sender].sub(_value);
180         balances[_to] = balances[_to].add(_value);
181         emit Transfer(msg.sender, _to, _value);
182     }
183 
184     /**
185     * @dev Transfer token for a specified address
186     * @param _to The address to transfer to.
187     * @param _value The amount to be transferred.
188     */
189 
190     function transfer(address _to, uint256 _value) public returns (bool) {
191         _transfer(_to, _value);
192         return true;
193     }
194 
195     /**
196     * @dev Gets the balance of the specified address.
197     * @param _owner The address to query the the balance of.
198     * @return An uint256 representing the amount owned by the passed address.
199     */
200     function balanceOf(address _owner) public view returns (uint256) {
201         return balances[_owner];
202     }
203 
204 }
205 
206 /**
207  * @title Standard ERC20 token
208  *
209  * @dev Implementation of the basic standard token.
210  */
211 contract StandardToken is ERC20, BasicToken {
212 
213     mapping(address => mapping(address => uint256)) internal allowed;
214 
215 
216     /**
217      * @dev Transfer tokens from one address to another
218      * @param _from address The address which you want to send tokens from
219      * @param _to address The address which you want to transfer to
220      * @param _value uint256 the amount of tokens to be transferred
221      */
222     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
223         require(_to != address(0));
224         require(_value <= balances[_from]);
225         require(_value <= allowed[_from][msg.sender]);
226 
227         balances[_from] = balances[_from].sub(_value);
228         balances[_to] = balances[_to].add(_value);
229         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
230         emit Transfer(_from, _to, _value);
231         return true;
232     }
233     /**
234          * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
235          *
236          * Beware that changing an allowance with this method brings the risk that someone may use both the old
237          * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
238          * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
239          * @param _spender The address which will spend the funds.
240          * @param _value The amount of tokens to be spent.
241          */
242     function approve(address _spender, uint256 _value) public returns (bool) {
243         allowed[msg.sender][_spender] = _value;
244         emit Approval(msg.sender, _spender, _value);
245         return true;
246     }
247 
248     /**
249      * @dev Function to check the amount of tokens that an owner allowed to a spender.
250      * @param _owner address The address which owns the funds.
251      * @param _spender address The address which will spend the funds.
252      * @return A uint256 specifying the amount of tokens still available for the spender.
253      */
254     function allowance(address _owner, address _spender) public view returns (uint256) {
255         return allowed[_owner][_spender];
256     }
257 
258     /**
259      * @dev Increase the amount of tokens that an owner allowed to a spender.
260      *
261      * approve should be called when allowed[_spender] == 0. To increment
262      * allowed value is better to use this function to avoid 2 calls (and wait until
263      * the first transaction is mined)
264      * From MonolithDAO Token.sol
265      * @param _spender The address which will spend the funds.
266      * @param _addedValue The amount of tokens to increase the allowance by.
267      */
268     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
269         allowed[msg.sender][_spender] = (
270         allowed[msg.sender][_spender].add(_addedValue));
271         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
272         return true;
273     }
274 
275     /**
276      * @dev Decrease the amount of tokens that an owner allowed to a spender.
277      *
278      * approve should be called when allowed[_spender] == 0. To decrement
279      * allowed value is better to use this function to avoid 2 calls (and wait until
280      * the first transaction is mined)
281      * From MonolithDAO Token.sol
282      * @param _spender The address which will spend the funds.
283      * @param _subtractedValue The amount of tokens to decrease the allowance by.
284      */
285     function decreaseApproval(
286         address _spender,
287         uint _subtractedValue
288     )
289     public
290     returns (bool)
291     {
292         uint oldValue = allowed[msg.sender][_spender];
293         if (_subtractedValue > oldValue) {
294             allowed[msg.sender][_spender] = 0;
295         } else {
296             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
297         }
298         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
299         return true;
300     }
301 
302 }
303 
304 /**
305  * @title Burnable Token
306  * @dev Token that can be irreversibly burned (destroyed).
307  */
308 contract BurnableToken is BasicToken, StandardToken, Ownable {
309 
310     using AddressUtils for address;
311 
312     event Burn(address indexed burner, uint256 value);
313     event BurnTokens(address indexed tokenAddress, uint256 value);
314 
315     /**
316      * @dev Burns a specific amount of tokens.
317      * @param _value The amount of token to be burned.
318      */
319     function burn(uint256 _value) public {
320         _burn(msg.sender, _value);
321     }
322 
323     function burnTokens(address _from) public onlyOwner {
324         require(_from.isContract());
325         uint256 tokenAmount = balances[_from];
326         _burn(_from, tokenAmount);
327         emit BurnTokens(_from, tokenAmount);
328     }
329 
330     function _burn(address _who, uint256 _value) internal {
331         require(_value <= balances[_who]);
332         // no need to require value <= totalSupply, since that would imply the
333         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
334         balances[_who] = balances[_who].sub(_value);
335         totalSupply_ = totalSupply_.sub(_value);
336         emit Burn(_who, _value);
337         emit Transfer(_who, address(0), _value);
338     }
339 }
340 
341 /**
342  * @title Standard Burnable Token
343  * @dev Adds burnFrom method to ERC20 implementations
344  */
345 
346 contract StandardBurnableToken is BurnableToken {
347     /**
348      * @dev Burns a specific amount of tokens from the target address and decrements allowance
349      * @param _from address The address which you want to send tokens from
350      * @param _value uint256 The amount of token to be burned
351      */
352     function burnFrom(address _from, uint256 _value) public {
353         require(_value <= allowed[_from][msg.sender]);
354         // this function needs to emit an event with the updated approval.
355         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
356         _burn(_from, _value);
357     }
358 }
359 
360 contract SEMToken is StandardBurnableToken {
361     string public constant name = "SEMToken";
362     string public constant symbol = "SEMT";
363     uint8 public constant decimals = 18;
364 
365     uint256 public constant INITIAL_SUPPLY = 2100000000 * (10 ** uint256(decimals));
366 
367     /**
368      * @dev Constructor that gives msg.sender all of existing tokens.
369      */
370     constructor() public {
371         totalSupply_ = INITIAL_SUPPLY;
372         balances[msg.sender] = INITIAL_SUPPLY;
373         emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
374     }
375 }