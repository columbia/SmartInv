1 pragma solidity ^0.4.24;
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
49 
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/179
54  */
55 contract ERC20Basic {
56     function totalSupply() public view returns (uint256);
57 
58     function balanceOf(address who) public view returns (uint256);
59 
60     function transfer(address to, uint256 value) public returns (bool);
61 
62     event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 /**
66  * @title ERC20 interface
67  * @dev see https://github.com/ethereum/EIPs/issues/20
68  */
69 contract ERC20 is ERC20Basic {
70     function allowance(address owner, address spender)
71     public view returns (uint256);
72 
73     function transferFrom(address from, address to, uint256 value)
74     public returns (bool);
75 
76     function approve(address spender, uint256 value) public returns (bool);
77 
78     event Approval(
79         address indexed owner,
80         address indexed spender,
81         uint256 value
82     );
83 }
84 
85 
86 /**
87  * @title Basic token
88  * @dev Basic version of StandardToken, with no allowances.
89  */
90 contract BasicToken is ERC20Basic {
91     using SafeMath for uint256;
92 
93     mapping(address => uint256) balances;
94 
95     uint256 totalSupply_;
96 
97     /**
98     * @dev total number of tokens in existence
99     */
100     function totalSupply() public view returns (uint256) {
101         return totalSupply_;
102     }
103 
104     /**
105     * @dev transfer token for a specified address
106     * @param _to The address to transfer to.
107     * @param _value The amount to be transferred.
108     */
109     function transfer(address _to, uint256 _value) public returns (bool) {
110         require(_to != address(0));
111         require(_value <= balances[msg.sender]);
112 
113         balances[msg.sender] = balances[msg.sender].sub(_value);
114         balances[_to] = balances[_to].add(_value);
115         emit Transfer(msg.sender, _to, _value);
116         return true;
117     }
118 
119     /**
120     * @dev Gets the balance of the specified address.
121     * @param _owner The address to query the the balance of.
122     * @return An uint256 representing the amount owned by the passed address.
123     */
124     function balanceOf(address _owner) public view returns (uint256) {
125         return balances[_owner];
126     }
127 
128 }
129 
130 /**
131  * @title Standard ERC20 token
132  *
133  * @dev Implementation of the basic standard token.
134  * @dev https://github.com/ethereum/EIPs/issues/20
135  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
136  */
137 contract StandardToken is ERC20, BasicToken {
138 
139     mapping(address => mapping(address => uint256)) internal allowed;
140 
141 
142     /**
143      * @dev Transfer tokens from one address to another
144      * @param _from address The address which you want to send tokens from
145      * @param _to address The address which you want to transfer to
146      * @param _value uint256 the amount of tokens to be transferred
147      */
148     function transferFrom(
149         address _from,
150         address _to,
151         uint256 _value
152     )
153     public
154     returns (bool)
155     {
156         require(_to != address(0));
157         require(_value <= balances[_from]);
158         require(_value <= allowed[_from][msg.sender]);
159 
160         balances[_from] = balances[_from].sub(_value);
161         balances[_to] = balances[_to].add(_value);
162         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
163         emit Transfer(_from, _to, _value);
164         return true;
165     }
166 
167     /**
168      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
169      *
170      * Beware that changing an allowance with this method brings the risk that someone may use both the old
171      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
172      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
173      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174      * @param _spender The address which will spend the funds.
175      * @param _value The amount of tokens to be spent.
176      */
177     function approve(address _spender, uint256 _value) public returns (bool) {
178         allowed[msg.sender][_spender] = _value;
179         emit Approval(msg.sender, _spender, _value);
180         return true;
181     }
182 
183     /**
184      * @dev Function to check the amount of tokens that an owner allowed to a spender.
185      * @param _owner address The address which owns the funds.
186      * @param _spender address The address which will spend the funds.
187      * @return A uint256 specifying the amount of tokens still available for the spender.
188      */
189     function allowance(
190         address _owner,
191         address _spender
192     )
193     public
194     view
195     returns (uint256)
196     {
197         return allowed[_owner][_spender];
198     }
199 
200     /**
201      * @dev Increase the amount of tokens that an owner allowed to a spender.
202      *
203      * approve should be called when allowed[_spender] == 0. To increment
204      * allowed value is better to use this function to avoid 2 calls (and wait until
205      * the first transaction is mined)
206      * From MonolithDAO Token.sol
207      * @param _spender The address which will spend the funds.
208      * @param _addedValue The amount of tokens to increase the allowance by.
209      */
210     function increaseApproval(
211         address _spender,
212         uint _addedValue
213     )
214     public
215     returns (bool)
216     {
217         allowed[msg.sender][_spender] = (
218         allowed[msg.sender][_spender].add(_addedValue));
219         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
220         return true;
221     }
222 
223     /**
224      * @dev Decrease the amount of tokens that an owner allowed to a spender.
225      *
226      * approve should be called when allowed[_spender] == 0. To decrement
227      * allowed value is better to use this function to avoid 2 calls (and wait until
228      * the first transaction is mined)
229      * From MonolithDAO Token.sol
230      * @param _spender The address which will spend the funds.
231      * @param _subtractedValue The amount of tokens to decrease the allowance by.
232      */
233     function decreaseApproval(
234         address _spender,
235         uint _subtractedValue
236     )
237     public
238     returns (bool)
239     {
240         uint oldValue = allowed[msg.sender][_spender];
241         if (_subtractedValue > oldValue) {
242             allowed[msg.sender][_spender] = 0;
243         } else {
244             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
245         }
246         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
247         return true;
248     }
249 
250 }
251 
252 /**
253  * @title Burnable Token
254  * @dev Token that can be irreversibly burned (destroyed).
255  */
256 contract BurnableToken is BasicToken {
257 
258     event Burn(address indexed burner, uint256 value);
259 
260     /**
261      * @dev Burns a specific amount of tokens.
262      * @param _value The amount of token to be burned.
263      */
264     function burn(uint256 _value) public {
265         _burn(msg.sender, _value);
266     }
267 
268     function _burn(address _who, uint256 _value) internal {
269         require(_value <= balances[_who]);
270         // no need to require value <= totalSupply, since that would imply the
271         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
272 
273         balances[_who] = balances[_who].sub(_value);
274         totalSupply_ = totalSupply_.sub(_value);
275         emit Burn(_who, _value);
276         emit Transfer(_who, address(0), _value);
277     }
278 
279 }
280 
281 /**
282  * @title Standard Burnable Token
283  * @dev Adds burnFrom method to ERC20 implementations
284  */
285 contract StandardBurnableToken is BurnableToken, StandardToken {
286 
287     /**
288      * @dev Burns a specific amount of tokens from the target address and decrements allowance
289      * @param _from address The address which you want to send tokens from
290      * @param _value uint256 The amount of token to be burned
291      */
292     function burnFrom(address _from, uint256 _value) public {
293         require(_value <= allowed[_from][msg.sender]);
294         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
295         // this function needs to emit an event with the updated approval.
296         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
297         _burn(_from, _value);
298     }
299 }
300 
301 /**
302  * @title ERC827 interface, an extension of ERC20 token standard
303  *
304  * @dev Interface of a ERC827 token, following the ERC20 standard with extra
305  * @dev methods to transfer value and data and execute calls in transfers and
306  * @dev approvals.
307  */
308 contract ERC827 is ERC20 {
309     function approveAndCall(
310         address _spender,
311         uint256 _value,
312         bytes _data
313     )
314     public
315     payable
316     returns (bool);
317 
318     function transferAndCall(
319         address _to,
320         uint256 _value,
321         bytes _data
322     )
323     public
324     payable
325     returns (bool);
326 
327     function transferFromAndCall(
328         address _from,
329         address _to,
330         uint256 _value,
331         bytes _data
332     )
333     public
334     payable
335     returns (bool);
336 }
337 
338 /**
339  * @title ERC827, an extension of ERC20 token standard
340  *
341  * @dev Implementation the ERC827, following the ERC20 standard with extra
342  * @dev methods to transfer value and data and execute calls in transfers and
343  * @dev approvals.
344  *
345  * @dev Uses OpenZeppelin StandardToken.
346  */
347 contract ERC827Token is ERC827, StandardToken {
348 
349     /**
350      * @dev Addition to ERC20 token methods. It allows to
351      * @dev approve the transfer of value and execute a call with the sent data.
352      *
353      * @dev Beware that changing an allowance with this method brings the risk that
354      * @dev someone may use both the old and the new allowance by unfortunate
355      * @dev transaction ordering. One possible solution to mitigate this race condition
356      * @dev is to first reduce the spender's allowance to 0 and set the desired value
357      * @dev afterwards:
358      * @dev https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
359      *
360      * @param _spender The address that will spend the funds.
361      * @param _value The amount of tokens to be spent.
362      * @param _data ABI-encoded contract call to call `_to` address.
363      *
364      * @return true if the call function was executed successfully
365      */
366     function approveAndCall(
367         address _spender,
368         uint256 _value,
369         bytes _data
370     )
371     public
372     payable
373     returns (bool)
374     {
375         require(_spender != address(this));
376 
377         super.approve(_spender, _value);
378 
379         // solium-disable-next-line security/no-call-value
380         require(_spender.call.value(msg.value)(_data));
381 
382         return true;
383     }
384 
385     /**
386      * @dev Addition to ERC20 token methods. Transfer tokens to a specified
387      * @dev address and execute a call with the sent data on the same transaction
388      *
389      * @param _to address The address which you want to transfer to
390      * @param _value uint256 the amout of tokens to be transfered
391      * @param _data ABI-encoded contract call to call `_to` address.
392      *
393      * @return true if the call function was executed successfully
394      */
395     function transferAndCall(
396         address _to,
397         uint256 _value,
398         bytes _data
399     )
400     public
401     payable
402     returns (bool)
403     {
404         require(_to != address(this));
405 
406         super.transfer(_to, _value);
407 
408         // solium-disable-next-line security/no-call-value
409         require(_to.call.value(msg.value)(_data));
410         return true;
411     }
412 
413     /**
414      * @dev Addition to ERC20 token methods. Transfer tokens from one address to
415      * @dev another and make a contract call on the same transaction
416      *
417      * @param _from The address which you want to send tokens from
418      * @param _to The address which you want to transfer to
419      * @param _value The amout of tokens to be transferred
420      * @param _data ABI-encoded contract call to call `_to` address.
421      *
422      * @return true if the call function was executed successfully
423      */
424     function transferFromAndCall(
425         address _from,
426         address _to,
427         uint256 _value,
428         bytes _data
429     )
430     public payable returns (bool)
431     {
432         require(_to != address(this));
433 
434         super.transferFrom(_from, _to, _value);
435 
436         // solium-disable-next-line security/no-call-value
437         require(_to.call.value(msg.value)(_data));
438         return true;
439     }
440 
441     /**
442      * @dev Addition to StandardToken methods. Increase the amount of tokens that
443      * @dev an owner allowed to a spender and execute a call with the sent data.
444      *
445      * @dev approve should be called when allowed[_spender] == 0. To increment
446      * @dev allowed value is better to use this function to avoid 2 calls (and wait until
447      * @dev the first transaction is mined)
448      * @dev From MonolithDAO Token.sol
449      *
450      * @param _spender The address which will spend the funds.
451      * @param _addedValue The amount of tokens to increase the allowance by.
452      * @param _data ABI-encoded contract call to call `_spender` address.
453      */
454     function increaseApprovalAndCall(
455         address _spender,
456         uint _addedValue,
457         bytes _data
458     )
459     public
460     payable
461     returns (bool)
462     {
463         require(_spender != address(this));
464 
465         super.increaseApproval(_spender, _addedValue);
466 
467         // solium-disable-next-line security/no-call-value
468         require(_spender.call.value(msg.value)(_data));
469 
470         return true;
471     }
472 
473     /**
474      * @dev Addition to StandardToken methods. Decrease the amount of tokens that
475      * @dev an owner allowed to a spender and execute a call with the sent data.
476      *
477      * @dev approve should be called when allowed[_spender] == 0. To decrement
478      * @dev allowed value is better to use this function to avoid 2 calls (and wait until
479      * @dev the first transaction is mined)
480      * @dev From MonolithDAO Token.sol
481      *
482      * @param _spender The address which will spend the funds.
483      * @param _subtractedValue The amount of tokens to decrease the allowance by.
484      * @param _data ABI-encoded contract call to call `_spender` address.
485      */
486     function decreaseApprovalAndCall(
487         address _spender,
488         uint _subtractedValue,
489         bytes _data
490     )
491     public
492     payable
493     returns (bool)
494     {
495         require(_spender != address(this));
496 
497         super.decreaseApproval(_spender, _subtractedValue);
498 
499         // solium-disable-next-line security/no-call-value
500         require(_spender.call.value(msg.value)(_data));
501 
502         return true;
503     }
504 
505 }
506 
507 /**
508  * @title Freezable Token
509  * @dev Token that can be Frozen.
510  */
511 contract FreezableToken is BasicToken {
512 
513     mapping (address => uint256) freezes;
514     event Freeze(address indexed from, uint256 value);
515     event Unfreeze(address indexed from, uint256 value);
516 
517     function freeze(uint256 _value) public returns (bool success) {
518         require(_value <= balances[msg.sender]);
519         balances[msg.sender] = balances[msg.sender].sub(_value);
520         freezes[msg.sender] = freezes[msg.sender].add(_value);
521         emit Freeze(msg.sender, _value);
522         return true;
523     }
524 
525     function unfreeze(uint256 _value) public returns (bool success) {
526         require(_value <= freezes[msg.sender]);
527         freezes[msg.sender] = freezes[msg.sender].sub(_value);
528         balances[msg.sender] = balances[msg.sender].add(_value);
529         emit Unfreeze(msg.sender, _value);
530         return true;
531     }
532     function freezeOf(address _owner) public view returns (uint256) {
533         return freezes[_owner];
534     }
535 }
536 
537 contract ChainBowToken is StandardBurnableToken, FreezableToken, ERC827Token {
538 
539     string public name;
540     string public symbol;
541     uint8 public decimals;
542     address public admin;
543 
544     constructor(address _teamWallet, uint256 _initialSupply, string _tokenName, string _tokenSymbol, uint8 _decimals) public {
545         totalSupply_ = _initialSupply;
546         balances[_teamWallet] = _initialSupply;
547         name = _tokenName;
548         symbol = _tokenSymbol;
549         decimals = _decimals;
550         admin = msg.sender;
551     }
552 
553     /**
554      * withdraw foreign tokens
555      */
556     function withdrawForeignTokens(address _tokenContract) public returns (bool) {
557         require(msg.sender == admin);
558         ERC20Basic token = ERC20Basic(_tokenContract);
559         uint256 amount = token.balanceOf(address(this));
560         return token.transfer(admin, amount);
561     }
562 
563 }