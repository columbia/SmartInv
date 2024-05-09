1 // solium-disable linebreak-style
2 pragma solidity ^0.4.23;
3 
4 contract Pedro_ERC20Token {
5     string public name = "Pedro Token";
6     string public symbol = "PEDRO";
7     uint public decimals = 2;
8     uint public INITIAL_SUPPLY = 255000000 * 10**uint(decimals);
9     uint256 public totalSupply_;
10 
11     using SafeMath for uint256;
12 
13     /**
14     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15     * account.
16     */
17     constructor() 
18     public 
19     {
20         owner = msg.sender;
21         totalSupply_ = INITIAL_SUPPLY;
22         balances[owner] = INITIAL_SUPPLY;
23     }
24 
25     mapping(address => uint256) balances;
26 
27     /**
28     * @dev We use a single lock for the whole contract.
29     */
30     bool private reentrancyLock = false;
31 
32     /**
33     * @dev Prevents a contract from calling itself, directly or indirectly.
34     * @notice If you mark a function `nonReentrant`, you should also
35     * mark it `external`. Calling one nonReentrant function from
36     * another is not supported. Instead, you can implement a
37     * `private` function doing the actual work, and a `external`
38     * wrapper marked as `nonReentrant`.
39     */
40     modifier nonReentrant() 
41     {
42         require(!reentrancyLock);
43         reentrancyLock = true;
44         _;
45         reentrancyLock = false;
46     }
47 
48     /**
49     * @dev Total number of tokens in existence
50     */
51     function totalSupply() 
52     public 
53     view 
54     returns (uint256) 
55     {
56         return totalSupply_;
57     }
58 
59     /**
60     * @dev Transfer token for a specified address
61     * @param _to The address to transfer to.
62     * @param _value The amount to be transferred.
63     */
64     function transfer(
65         address _to, 
66         uint256 _value
67     ) 
68     public 
69     returns (bool) 
70     {
71         _transfer(_to, _value);
72     }
73     
74     function _transfer(
75         address _to, 
76         uint256 _value
77     ) 
78     internal
79     nonReentrant
80     returns (bool) 
81     {
82         require(_to != address(0));
83         require(_value <= balances[msg.sender]);
84 
85         balances[msg.sender] = balances[msg.sender].sub(_value);
86         balances[_to] = balances[_to].add(_value);
87         emit Transfer(msg.sender, _to, _value);
88         emit Transfer(msg.sender, msg.sender, _to, _value);
89         return true;
90     }
91     
92     event Transfer(
93         address indexed _from, 
94         address indexed _to, 
95         uint256 value
96     );
97     event Transfer(
98         address indexed _spender,
99         address indexed _from,
100         address indexed _to,
101         uint256 _value
102     );
103 
104     /**
105     * @dev Gets the balance of the specified address.
106     * @param _owner The address to query the the balance of.
107     * @return An uint256 representing the amount owned by the passed address.
108     */
109     function balanceOf(
110         address _owner
111     ) 
112     public 
113     view 
114     returns (uint256) 
115     {
116         return balances[_owner];
117     }
118 
119     mapping(address => mapping (address => uint256)) internal allowed;
120 
121 
122     /**
123     * @dev Transfer tokens from one address to another
124     * @param _from address The address which you want to send tokens from
125     * @param _to address The address which you want to transfer to
126     * @param _value uint256 the amount of tokens to be transferred
127     */
128     function transferFrom(
129         address _from,
130         address _to,
131         uint256 _value
132     )
133     public
134     returns(bool)
135     {
136         _transferFrom(_from,_to,_value);
137     }
138 
139     function _transferFrom(
140         address _from,
141         address _to,
142         uint256 _value
143     )
144     public
145     nonReentrant
146     returns(bool)
147     {
148         require(_to != address(0));
149         require(_value <= balances[_from]);
150         require(_value <= allowed[_from][msg.sender]);
151 
152         balances[_from] = balances[_from].sub(_value);
153         balances[_to] = balances[_to].add(_value);
154         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
155         emit Transfer(_from, _to, _value);
156         emit Transfer(msg.sender,_from, _to, _value);
157         return true;
158     }
159 
160     /**
161     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
162     * Beware that changing an allowance with this method brings the risk that someone may use both the old
163     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
164     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
165     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
166     * @param _spender The address which will spend the funds.
167     * @param _value The amount of tokens to be spent.
168     */
169     function approve(
170         address _spender, 
171         uint256 _currentValue,
172         uint256 _value
173     ) 
174     public 
175     returns(bool) 
176     {
177         require(_currentValue == allowed[msg.sender][_spender]);
178         allowed[msg.sender][_spender] = _value;
179         emit Approval(msg.sender, _spender, _value);
180         emit Approval(msg.sender, _spender, _currentValue, _value);
181         return true;
182     }
183 
184     event Approval(
185         address indexed _owner,
186         address indexed _spender,
187         uint256 value
188     );
189     event Approval(
190         address indexed _owner,
191         address indexed _spender,
192         uint256 _oldValue,
193         uint256 _value
194     );
195 
196     /**
197     * @dev Function to check the amount of tokens that an owner allowed to a spender.
198     * @param _owner address The address which owns the funds.
199     * @param _spender address The address which will spend the funds.
200     * @return A uint256 specifying the amount of tokens still available for the spender.
201     */
202     function allowance(
203         address _owner,
204         address _spender
205     )
206     public
207     view
208     returns(uint256)
209     {
210         return allowed[_owner][_spender];
211     }
212 
213     /**
214     * @dev Increase the amount of tokens that an owner allowed to a spender.
215     * approve should be called when allowed[_spender] == 0. To increment
216     * allowed value is better to use this function to avoid 2 calls (and wait until
217     * the first transaction is mined)
218     * From MonolithDAO Token.sol
219     * @param _spender The address which will spend the funds.
220     * @param _addedValue The amount of tokens to increase the allowance by.
221     */
222     function increaseApproval(
223         address _spender,
224         uint256 _addedValue
225     )
226     public
227     returns(bool)
228     {
229         allowed[msg.sender][_spender] = (
230         allowed[msg.sender][_spender].add(_addedValue));
231         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
232         return true;
233     }
234 
235     /**
236     * @dev Decrease the amount of tokens that an owner allowed to a spender.
237     * approve should be called when allowed[_spender] == 0. To decrement
238     * allowed value is better to use this function to avoid 2 calls (and wait until
239     * the first transaction is mined)
240     * From MonolithDAO Token.sol
241     * @param _spender The address which will spend the funds.
242     * @param _subtractedValue The amount of tokens to decrease the allowance by.
243     */
244     function decreaseApproval(
245         address _spender,
246         uint256 _subtractedValue
247     )
248     public
249     returns(bool)
250     {
251         uint256 oldValue = allowed[msg.sender][_spender];
252         if (_subtractedValue > oldValue) {
253             allowed[msg.sender][_spender] = 0;
254         } else {
255             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
256         }
257         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
258         return true;
259     }
260 
261     address public owner;
262 
263     event OwnershipRenounced(
264         address indexed previousOwner
265     );
266     event OwnershipTransferred(
267         address indexed previousOwner,
268         address indexed newOwner
269     );
270 
271     /**
272     * @dev Throws if called by any account other than the owner.
273     */
274     modifier onlyOwner() 
275     {
276         require(msg.sender == owner);
277         _;
278     }
279 
280     /**
281     * @dev Allows the current owner to relinquish control of the contract.
282     * @notice Renouncing to ownership will leave the contract without an owner.
283     * It will not be possible to call the functions with the `onlyOwner`
284     * modifier anymore.
285     */
286     function renounceOwnership() 
287     public 
288     onlyOwner 
289     {
290         emit OwnershipRenounced(owner);
291         owner = address(0);
292     }
293 
294     /**
295     * @dev Allows the current owner to transfer control of the contract to a newOwner.
296     * @param _newOwner The address to transfer ownership to.
297     */
298     function transferOwnership(
299         address _newOwner
300     ) 
301     public 
302     onlyOwner 
303     {
304         _transferOwnership(_newOwner);
305     }
306 
307     /**
308     * @dev Transfers control of the contract to a newOwner.
309     * @param _newOwner The address to transfer ownership to.
310     */
311     function _transferOwnership(
312         address _newOwner
313     ) 
314     internal 
315     {
316         require(_newOwner != address(0));
317         emit OwnershipTransferred(owner, _newOwner);
318         owner = _newOwner;
319     }
320 
321     event Mint(address indexed to, uint256 amount);
322     event MintFinished();
323 
324     bool public mintingFinished = false;
325 
326 
327     modifier canMint() 
328     {
329         require(!mintingFinished);
330         _;
331     }
332 
333     modifier hasMintPermission() 
334     {
335         require(msg.sender == owner);
336         _;
337     }
338 
339     /**
340     * @dev Function to mint tokens
341     * @param _to The address that will receive the minted tokens.
342     * @param _amount The amount of tokens to mint.
343     * @return A boolean that indicates if the operation was successful.
344     */
345     function mint(
346         address _to,
347         uint256 _amount
348     )
349     public
350     hasMintPermission canMint
351     returns (bool)
352     {
353         totalSupply_ = totalSupply_.add(_amount);
354         balances[_to] = balances[_to].add(_amount);
355         emit Mint(_to, _amount);
356         emit Transfer(address(0), _to, _amount);
357         return true;
358     }
359 
360     /**
361     * @dev Function to stop minting new tokens.
362     * @return True if the operation was successful.
363     */
364     function finishMinting() 
365     public  
366     onlyOwner canMint
367     returns (bool) 
368     {
369         mintingFinished = true;
370         emit MintFinished();
371         return true;
372     }
373     
374     event Burn(address indexed burner, uint256 value);
375 
376     /**
377     * @dev Burns a specific amount of tokens.
378     * @param _value The amount of token to be burned.
379     */
380     function burn(
381         uint256 _value
382     ) 
383     public 
384     {
385         _burn(msg.sender, _value);
386     }
387 
388     function _burn(
389         address _who, 
390         uint256 _value
391     ) 
392     internal 
393     {
394         require(_value <= balances[_who]);
395         // no need to require value <= totalSupply, since that would imply the
396         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
397 
398         balances[_who] = balances[_who].sub(_value);
399         totalSupply_ = totalSupply_.sub(_value);
400         emit Burn(_who, _value);
401         emit Transfer(_who, address(0), _value);
402     }
403 }
404 
405 /**
406  * @title Math
407  * @dev Assorted math operations
408  */
409 /**
410  * @title SafeMath
411  * @dev Math operations with safety checks that throw on error
412  */
413 library SafeMath {
414 
415     /**
416     * @dev Multiplies two numbers, throws on overflow.
417     */
418     function mul(
419         uint256 a, 
420         uint256 b
421     ) 
422     internal 
423     pure 
424     returns(uint256 c) 
425     {
426         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
427         // benefit is lost if 'b' is also tested.
428         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
429         if (a == 0) {
430             return 0;
431         }
432 
433         c = a * b;
434         assert(c / a == b);
435         return c;
436     }
437 
438     /**
439     * @dev Integer division of two numbers, truncating the quotient.
440     */
441     function div(
442         uint256 a,
443         uint256 b
444     ) 
445     internal 
446     pure 
447     returns(uint256) 
448     {
449         // assert(b > 0); 
450         // Solidity automatically throws when dividing by 0
451         // uint256 c = a / b;
452         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
453         return a / b;
454     }
455 
456     /**
457     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
458     */
459     function sub(
460         uint256 a, 
461         uint256 b
462     ) 
463     internal 
464     pure 
465     returns(uint256) 
466     {
467         assert(b <= a);
468         return a - b;
469     }
470 
471     /**
472     * @dev Adds two numbers, throws on overflow.
473     */
474     function add(
475         uint256 a, 
476         uint256 b
477     ) 
478     internal 
479     pure 
480     returns(uint256 c) 
481     {
482         c = a + b;
483         assert(c >= a);
484         return c;
485     }
486 }