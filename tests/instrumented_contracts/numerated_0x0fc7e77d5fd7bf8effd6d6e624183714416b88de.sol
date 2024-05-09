1 pragma solidity ^0.4.12;
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
13         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24 
25     /**
26     * @dev Integer division of two numbers, truncating the quotient.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         // uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return a / b;
33     }
34 
35     /**
36     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37     */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     /**
44     * @dev Adds two numbers, throws on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47         c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59     address public owner;
60     address public pendingOwner;
61 
62 
63     event OwnershipTransferred(
64         address indexed previousOwner,
65         address indexed newOwner
66     );
67 
68 
69     /**
70      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
71      * account.
72      */
73     constructor() public {
74         owner = msg.sender;
75     }
76 
77     /**
78      * @dev Throws if called by any account other than the owner.
79      */
80     modifier onlyOwner() {
81         require(msg.sender == owner);
82         _;
83     }
84 
85     /**
86      * @dev Allows the current owner to transfer control of the contract to a newOwner.
87      * @param _newOwner The address to transfer ownership to.
88      */
89     function transferOwnership(address _newOwner) public onlyOwner {
90         require(_newOwner != address(0));
91         pendingOwner = _newOwner;
92     }
93 
94     /**
95      * @dev Grants ownership to pendingOwner.
96     */
97     function acceptOwnership() public {
98         require(msg.sender == pendingOwner);
99         emit OwnershipTransferred(owner, pendingOwner);
100         owner = pendingOwner;
101         pendingOwner = address(0);
102     }
103 
104 }
105 
106 /**
107  * @title Support
108  * @dev Provides authorization control to Support.
109  */
110 contract Support is Ownable {
111     mapping(address => bool) public supportList;
112 
113     event SupportAdded(address indexed _who);
114     event SupportRemoved(address indexed _who);
115 
116     /**
117     * @dev Throws if called by any account other than the supportList or owner.
118     */
119     modifier supportOrOwner {
120         require(msg.sender == owner || supportList[msg.sender]);
121         _;
122     }
123 
124     /**
125     * @dev Allows current owner to grant extended contract access to _who .
126     * @param _who The address to change permissions.
127     */
128     function addSupport(address _who) public onlyOwner {
129         require(_who != address(0));
130         require(_who != owner);
131         require(!supportList[_who]);
132         supportList[_who] = true;
133         emit SupportAdded(_who);
134     }
135 
136     /**
137     * @dev Allows current owner to revoke extended contract access from _who .
138     * @param _who The address to change permissions.
139     */
140     function removeSupport(address _who) public onlyOwner {
141         require(supportList[_who]);
142         supportList[_who] = false;
143         emit SupportRemoved(_who);
144     }
145 }
146 
147 /**
148  * @title ERC20Basic
149  * @dev Simpler version of ERC20 interface
150  * @dev see https://github.com/ethereum/EIPs/issues/179
151  */
152 contract ERC20Basic {
153     function totalSupply() public view returns (uint256);
154     function balanceOf(address who) public view returns (uint256);
155     function transfer(address to, uint256 value) public returns (bool);
156     event Transfer(address indexed from, address indexed to, uint256 value);
157 }
158 
159 /**
160  * @title ERC20 interface
161  * @dev see https://github.com/ethereum/EIPs/issues/20
162  */
163 contract ERC20 is ERC20Basic {
164     function allowance(address owner, address spender)
165     public view returns (uint256);
166 
167     function transferFrom(address from, address to, uint256 value)
168     public returns (bool);
169 
170     function approve(address spender, uint256 value) public returns (bool);
171 
172     event Approval(
173         address indexed owner,
174         address indexed spender,
175         uint256 value
176     );
177 }
178 
179 /**
180  * @title Basic token
181  * @dev Basic version of StandardToken, with no allowances.
182  */
183 contract BasicToken is ERC20Basic {
184     using SafeMath for uint256;
185 
186     mapping(address => uint256) balances;
187 
188     uint256 totalSupply_;
189 
190     /**
191     * @dev total number of tokens in existence
192     */
193     function totalSupply() public view returns (uint256) {
194         return totalSupply_;
195     }
196 
197     /**
198     * @dev Transfer token for a specified address
199     * @param _to The address to transfer to.
200     * @param _value The amount to be transferred.
201     */
202     function transfer(address _to, uint256 _value) public returns (bool) {
203         require(_to != address(0));
204         require(_value <= balances[msg.sender]);
205 
206         balances[msg.sender] = balances[msg.sender].sub(_value);
207         balances[_to] = balances[_to].add(_value);
208         emit Transfer(msg.sender, _to, _value);
209         return true;
210     }
211 
212     /**
213     * @dev Gets the balance of the specified address.
214     * @param _owner The address to query the the balance of.
215     * @return An uint256 representing the amount owned by the passed address.
216     */
217     function balanceOf(address _owner) public view returns (uint256) {
218         return balances[_owner];
219     }
220 
221 }
222 
223 /**
224  * @title Standard ERC20 token
225  *
226  * @dev Implementation of the basic standard token.
227  * @dev https://github.com/ethereum/EIPs/issues/20
228  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
229  */
230 contract StandardToken is ERC20, BasicToken {
231 
232     mapping(address => mapping(address => uint256)) internal allowed;
233 
234 
235     /**
236      * @dev Transfer tokens from one address to another
237      * @param _from address The address which you want to send tokens from
238      * @param _to address The address which you want to transfer to
239      * @param _value uint256 the amount of tokens to be transferred
240      */
241     function transferFrom(
242         address _from,
243         address _to,
244         uint256 _value
245     )
246         public
247         returns (bool)
248     {
249         require(_from != address(0));
250         require(_to != address(0));
251         require(_value <= balances[_from]);
252         require(_value <= allowed[_from][msg.sender]);
253 
254         balances[_from] = balances[_from].sub(_value);
255         balances[_to] = balances[_to].add(_value);
256         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
257         emit Transfer(_from, _to, _value);
258         return true;
259     }
260 
261     /**
262      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
263      * Beware that changing an allowance with this method brings the risk that someone may use both the old
264      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
265      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
266      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
267      * @param _spender The address which will spend the funds.
268      * @param _value The amount of tokens to be spent.
269      */
270     function approve(address _spender, uint256 _value) public returns (bool) {
271         require(_spender != address(0));
272         require(_value <= balances[msg.sender]);
273 
274         allowed[msg.sender][_spender] = _value;
275         emit Approval(msg.sender, _spender, _value);
276         return true;
277     }
278 
279     /**
280      * @dev Function to check the amount of tokens that an owner allowed to a spender.
281      * @param _owner address The address which owns the funds.
282      * @param _spender address The address which will spend the funds.
283      * @return A uint256 specifying the amount of tokens still available for the spender.
284      */
285     function allowance(
286         address _owner,
287         address _spender
288     )
289         public
290         view
291         returns (uint256)
292     {
293         return allowed[_owner][_spender];
294     }
295 
296     /**
297      * @dev Increase the amount of tokens that an owner allowed to a spender.
298      * approve should be called when allowed[_spender] == 0. To increment
299      * allowed value is better to use this function to avoid 2 calls (and wait until
300      * the first transaction is mined)
301      * From MonolithDAO Token.sol
302      * @param _spender The address which will spend the funds.
303      * @param _addedValue The amount of tokens to increase the allowance by.
304      */
305     function increaseApproval(
306         address _spender,
307         uint256 _addedValue
308     )
309         public
310         returns (bool)
311     {
312         require(_spender != address(0));
313         require(allowed[msg.sender][_spender].add(_addedValue) <= balances[msg.sender]);
314 
315         allowed[msg.sender][_spender] = (
316         allowed[msg.sender][_spender].add(_addedValue));
317         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
318         return true;
319     }
320 
321     /**
322      * @dev Decrease the amount of tokens that an owner allowed to a spender.
323      *
324      * approve should be called when allowed[_spender] == 0. To decrement
325      * allowed value is better to use this function to avoid 2 calls (and wait until
326      * the first transaction is mined)
327      * From MonolithDAO Token.sol
328      * @param _spender The address which will spend the funds.
329      * @param _subtractedValue The amount of tokens to decrease the allowance by.
330      */
331     function decreaseApproval(
332         address _spender,
333         uint256 _subtractedValue
334     )
335         public
336         returns (bool)
337     {
338         require(_spender != address(0));
339 
340         uint oldValue = allowed[msg.sender][_spender];
341         if (_subtractedValue > oldValue) {
342             allowed[msg.sender][_spender] = 0;
343         } else {
344             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
345         }
346         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
347         return true;
348     }
349 }
350 
351 /**
352  * @title Burnable Token
353  * @dev Token that can be irreversibly burned (destroyed).
354  */
355 contract BurnableToken is BasicToken, Support {
356 
357     event Burn(address indexed burner, uint256 value);
358 
359     /**
360      * @dev Burns a specific amount of tokens.
361      * @param _value The amount of token to be burned.
362      */
363     function burn(uint256 _value) supportOrOwner public {
364         _burn(msg.sender, _value);
365     }
366 
367     function _burn(address _who, uint256 _value) internal {
368         require(_value <= balances[_who]);
369         // no need to require value <= totalSupply, since that would imply the
370         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
371 
372         balances[_who] = balances[_who].sub(_value);
373         totalSupply_ = totalSupply_.sub(_value);
374         emit Burn(_who, _value);
375         emit Transfer(_who, address(0), _value);
376     }
377 }
378 
379 /**
380  * @title FreezeTokenCrowdsale
381  * @dev Freezes tokens transfer while crowdsale.
382  * Only owner and supportList are able to transfer tokens during crowd sale.
383  */
384 contract FreezeTokenCrowdsale is StandardToken, Support {
385 
386     event CrowdsaleFinalized();
387 
388     bool public freeze = false;
389 
390     /**
391      * @dev Modifier to make a function available to everyone when crowd sale is over
392      */
393     modifier freezeTransfer() {
394         require(freeze == false || msg.sender == owner || supportList[msg.sender]);
395         _;
396     }
397 
398     /**
399      * @dev Has to be called when crowdsale is over to allow all users transfer tokens.
400      */
401     function finalizeCrowdsale() onlyOwner public {
402         require(freeze == true);
403         freeze = false;
404         emit CrowdsaleFinalized();
405     }
406 
407     function transfer(
408         address _to,
409         uint256 _value
410     )
411         public
412         freezeTransfer
413         returns (bool)
414     {
415         return super.transfer(_to, _value);
416     }
417 
418     function transferFrom(
419         address _from,
420         address _to,
421         uint256 _value
422     )
423         public
424         freezeTransfer
425         returns (bool)
426     {
427         return super.transferFrom(_from, _to, _value);
428     }
429 
430 }
431 
432 /**
433  * @title Crypster
434  * @dev ERC20 Token.
435  */
436 contract Crypster is FreezeTokenCrowdsale, BurnableToken {
437 
438     string public constant name = "Crypster"; // solium-disable-line uppercase
439     string public constant symbol = "CRP"; // solium-disable-line uppercase
440     uint8 public constant decimals = 8; // solium-disable-line uppercase
441 
442     uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
443 
444     /**
445      * @dev Constructor that gives msg.sender all of existing tokens.
446      */
447     constructor() public {
448         totalSupply_ = INITIAL_SUPPLY;
449         balances[msg.sender] = INITIAL_SUPPLY;
450         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
451     }
452 
453 }