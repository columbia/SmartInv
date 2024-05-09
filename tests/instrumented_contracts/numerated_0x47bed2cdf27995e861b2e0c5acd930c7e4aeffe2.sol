1 pragma solidity ^0.4.24;
2 
3 
4 
5 
6 /**
7 * @title SafeMath
8 * @dev Math operations with safety checks that throw on error
9 */
10 library SafeMath {
11 
12     /**
13     * @dev Multiplies two numbers, throws on overflow.
14     */
15     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
16         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
17         // benefit is lost if 'b' is also tested.
18         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
19         if (a == 0) {
20             return 0;
21         }
22 
23         c = a * b;
24         assert(c / a == b);
25         return c;
26     }
27 
28     /**
29     * @dev Integer division of two numbers, truncating the quotient.
30     */
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         // assert(b > 0); // Solidity automatically throws when dividing by 0
33         // uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35         return a / b;
36     }
37 
38     /**
39     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40     */
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         assert(b <= a);
43         return a - b;
44     }
45 
46     /**
47     * @dev Adds two numbers, throws on overflow.
48     */
49     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
50         c = a + b;
51         assert(c >= a);
52         return c;
53     }
54 }
55 
56 
57 /**
58 * @title ERC20Basic
59 * @dev Simpler version of ERC20 interface
60 */
61 contract ERC20Basic {
62     function totalSupply() public view returns (uint256);
63     function balanceOf(address who) public view returns (uint256);
64     function transfer(address to, uint256 value) public returns (bool);
65     event Transfer(address indexed from, address indexed to, uint256 value);
66 }
67 
68 
69 /**
70 * @title ERC20 interface
71 */
72 contract ERC20 is ERC20Basic {
73     function allowance(address owner, address spender)
74         public view returns (uint256);
75 
76     function transferFrom(address from, address to, uint256 value)
77         public returns (bool);
78 
79     function approve(address spender, uint256 value) public returns (bool);
80     event Approval(
81         address indexed owner,
82         address indexed spender,
83         uint256 value
84     );
85 }
86 
87 
88 /**
89 * @title Basic token
90 * @dev Basic version of StandardToken, with no allowances.
91 */
92 contract BasicToken is ERC20Basic {
93     using SafeMath for uint256;
94 
95     mapping(address => uint256) balances;
96 
97     uint256 totalSupply_;
98 
99     /**
100     * @dev Total number of tokens in existence
101     */
102     function totalSupply() public view returns (uint256) {
103         return totalSupply_;
104     }
105 
106     /**
107     * @dev Transfer token for a specified address
108     * @param _to The address to transfer to.
109     * @param _value The amount to be transferred.
110     */
111     function transfer(address _to, uint256 _value) public returns (bool) {
112         require(_to != address(0));
113         require(_value <= balances[msg.sender]);
114 
115         balances[msg.sender] = balances[msg.sender].sub(_value);
116         balances[_to] = balances[_to].add(_value);
117         emit Transfer(msg.sender, _to, _value);
118         return true;
119     }
120 
121     /**
122     * @dev Gets the balance of the specified address.
123     * @param _owner The address to query the the balance of.
124     * @return An uint256 representing the amount owned by the passed address.
125     */
126     function balanceOf(address _owner) public view returns (uint256) {
127         return balances[_owner];
128     }
129 
130 }
131 
132 
133 /**
134 * @title Standard ERC20 token
135 *
136 * @dev Implementation of the basic standard token.
137 */
138 contract StandardToken is ERC20, BasicToken {
139 
140     mapping (address => mapping (address => uint256)) internal allowed;
141 
142     /**
143     * @dev Transfer tokens from one address to another
144     * @param _from address The address which you want to send tokens from
145     * @param _to address The address which you want to transfer to
146     * @param _value uint256 the amount of tokens to be transferred
147     */
148     function transferFrom(
149         address _from,
150         address _to,
151         uint256 _value
152     )
153         public
154         returns (bool)
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
168     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
169     * Beware that changing an allowance with this method brings the risk that someone may use both the old
170     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
171     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards,
172     * i.e. clients SHOULD make sure to create user interfaces in such a way 
173     * that they set the allowance first to 0 before setting it to another value for the same spender. 
174     * @param _spender The address which will spend the funds.
175     * @param _value The amount of tokens to be spent.
176     */
177     function approve(address _spender, uint256 _value) public returns (bool) {
178         allowed[msg.sender][_spender] = _value;
179         emit Approval(msg.sender, _spender, _value);
180         return true;
181     }
182 
183     /**
184     * @dev Function to check the amount of tokens that an owner allowed to a spender.
185     * @param _owner address The address which owns the funds.
186     * @param _spender address The address which will spend the funds.
187     * @return A uint256 specifying the amount of tokens still available for the spender.
188     */
189     function allowance(
190         address _owner,
191         address _spender
192    )
193         public
194         view
195         returns (uint256)
196     {
197         return allowed[_owner][_spender];
198     }
199 
200     /**
201     * @dev Increase the amount of tokens that an owner allowed to a spender.
202     * approve should be called when allowed[_spender] == 0. To increment
203     * allowed value is better to use this function to avoid 2 calls (and wait until
204     * the first transaction is mined)
205     * @param _spender The address which will spend the funds.
206     * @param _addedValue The amount of tokens to increase the allowance by.
207     */
208     function increaseApproval(
209         address _spender,
210         uint256 _addedValue
211     )
212         public
213         returns (bool)
214     {
215         allowed[msg.sender][_spender] = (
216             allowed[msg.sender][_spender].add(_addedValue));
217         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218         return true;
219     }
220 
221     /**
222     * @dev Decrease the amount of tokens that an owner allowed to a spender.
223     * approve should be called when allowed[_spender] == 0. To decrement
224     * allowed value is better to use this function to avoid 2 calls (and wait until
225     * the first transaction is mined)
226     * @param _spender The address which will spend the funds.
227     * @param _subtractedValue The amount of tokens to decrease the allowance by.
228     */
229     function decreaseApproval(
230         address _spender,
231         uint256 _subtractedValue
232     )
233         public
234         returns (bool)
235     {
236         uint256 oldValue = allowed[msg.sender][_spender];
237         if (_subtractedValue > oldValue) {
238             allowed[msg.sender][_spender] = 0;
239         } else {
240             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
241         }
242         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
243         return true;
244     }
245 
246 }
247 
248 
249 contract BSBEXToken is StandardToken {
250 
251     string public constant name = "BSBEXToken";
252     string public constant symbol = "BSB";
253     uint8 public constant decimals = 18;
254 
255     uint256 constant MONTH = 3600*24*30;
256 
257     struct TimeLock {
258         // total amount of tokens that is granted to the user
259         uint256 amount;
260 
261         // total amount of tokens that have been vested
262         uint256 vestedAmount;
263 
264         // total amount of vested months (tokens are vested on a monthly basis)
265         uint16 vestedMonths;
266 
267         // token timestamp start
268         uint256 start;
269 
270         // token timestamp release start (when user can start receive vested tokens)
271         uint256 cliff;
272 
273         // token timestamp release end (when all the tokens can be vested)
274         uint256 vesting;
275 
276         address from;
277     }
278 
279     mapping(address => TimeLock) timeLocks;
280 
281     event NewTokenGrant(address indexed _from, address indexed _to, uint256 _amount, uint256 _start, uint256 _cliff, uint256 _vesting);
282     event VestedTokenRedeemed(address indexed _to, uint256 _amount, uint256 _vestedMonths);
283     event GrantedTokenReturned(address indexed _from, address indexed _to, uint256 _amount);
284 
285     /**
286     * @dev Constructor that gives msg.sender all of existing tokens.
287     */
288     constructor() public {
289         totalSupply_ = 200000000 * (10 ** uint256(decimals));
290         balances[msg.sender] = totalSupply_;
291         emit Transfer(address(0), msg.sender, totalSupply_);
292     }
293 
294     function vestBalanceOf(address who)
295         public view
296         returns (uint256 amount, uint256 vestedAmount, uint256 start, uint256 cliff, uint256 vesting)
297     {
298         require(who != address(0));
299         amount = timeLocks[who].amount;
300         vestedAmount = timeLocks[who].vestedAmount;
301         start = timeLocks[who].start;
302         cliff = timeLocks[who].cliff;
303         vesting = timeLocks[who].vesting;
304     }
305 
306     /**
307     * @dev Function to grant the amount of tokens that will be vested later.
308     * @param _to The address which will own the tokens.
309     * @param _amount The amount of tokens that will be vested later.
310     * @param _start Token timestamp start.
311     * @param _cliff Token timestamp release start.
312     * @param _vesting Token timestamp release end.
313     */
314     function grantToken(
315         address _to,
316         uint256 _amount,
317         uint256 _start,
318         uint256 _cliff,
319         uint256 _vesting
320     )
321         public
322         returns (bool success)
323     {
324         require(_to != address(0));
325         require(_amount <= balances[msg.sender], "Not enough balance to grant token.");
326         require(_amount > 0, "Nothing to transfer.");
327         require((timeLocks[_to].amount.sub(timeLocks[_to].vestedAmount) == 0), "The previous vesting should be completed.");
328         require(_cliff >= _start, "_cliff must be >= _start");
329         require(_vesting > _start, "_vesting must be bigger than _start");
330         require(_vesting > _cliff, "_vesting must be bigger than _cliff");
331 
332         balances[msg.sender] = balances[msg.sender].sub(_amount);
333         timeLocks[_to] = TimeLock(_amount, 0, 0, _start, _cliff, _vesting, msg.sender);
334 
335         emit NewTokenGrant(msg.sender, _to, _amount, _start, _cliff, _vesting);
336         return true;
337     }
338 
339     /**
340     * @dev Function to grant the amount of tokens that will be vested later.
341     * @param _to The address which will own the tokens.
342     * @param _amount The amount of tokens that will be vested later.
343     * @param _cliffMonths Token release start in months from now.
344     * @param _vestingMonths Token release end in months from now.
345     */
346     function grantTokenStartNow(
347         address _to,
348         uint256 _amount,
349         uint256 _cliffMonths,
350         uint256 _vestingMonths
351     )
352         public
353         returns (bool success)
354     {
355         return grantToken(
356             _to,
357             _amount,
358             now,
359             now.add(_cliffMonths.mul(MONTH)),
360             now.add(_vestingMonths.mul(MONTH))
361             );
362     }
363 
364     /**
365     * @dev Function to calculate the amount of tokens that can be vested at this moment.
366     * @param _to The address which will own the tokens.
367     * @return amount - A uint256 specifying the amount of tokens available to be vested at this moment.
368     * @return vestedMonths - A uint256 specifying the number of the vested months since the last vesting.
369     * @return curTime - A uint256 specifying the current timestamp.
370     */
371     function calcVestableToken(address _to)
372         internal view
373         returns (uint256 amount, uint256 vestedMonths, uint256 curTime)
374     {
375         uint256 vestTotalMonths;
376         uint256 vestedAmount;
377         uint256 vestPart;
378         amount = 0;
379         vestedMonths = 0;
380         curTime = now;
381         
382         require(timeLocks[_to].amount > 0, "Nothing was granted to this address.");
383         
384         if (curTime <= timeLocks[_to].cliff) {
385             return (0, 0, curTime);
386         }
387 
388         vestedMonths = curTime.sub(timeLocks[_to].start) / MONTH;
389         vestedMonths = vestedMonths.sub(timeLocks[_to].vestedMonths);
390 
391         if (curTime >= timeLocks[_to].vesting) {
392             return (timeLocks[_to].amount.sub(timeLocks[_to].vestedAmount), vestedMonths, curTime);
393         }
394 
395         if (vestedMonths > 0) {
396             vestTotalMonths = timeLocks[_to].vesting.sub(timeLocks[_to].start) / MONTH;
397             vestPart = timeLocks[_to].amount.div(vestTotalMonths);
398             amount = vestedMonths.mul(vestPart);
399             vestedAmount = timeLocks[_to].vestedAmount.add(amount);
400             if (vestedAmount > timeLocks[_to].amount) {
401                 amount = timeLocks[_to].amount.sub(timeLocks[_to].vestedAmount);
402             }
403         }
404 
405         return (amount, vestedMonths, curTime);
406     }
407 
408     /**
409     * @dev Function to redeem tokens that can be vested at this moment.
410     * @param _to The address which will own the tokens.
411     */
412     function redeemVestableToken(address _to)
413         public
414         returns (bool success)
415     {
416         require(_to != address(0));
417         require(timeLocks[_to].amount > 0, "Nothing was granted to this address!");
418         require(timeLocks[_to].vestedAmount < timeLocks[_to].amount, "All tokens were vested!");
419 
420         (uint256 amount, uint256 vestedMonths, uint256 curTime) = calcVestableToken(_to);
421         require(amount > 0, "Nothing to redeem now.");
422 
423         TimeLock storage t = timeLocks[_to];
424         balances[_to] = balances[_to].add(amount);
425         t.vestedAmount = t.vestedAmount.add(amount);
426         t.vestedMonths = t.vestedMonths + uint16(vestedMonths);
427         t.cliff = curTime;
428 
429         emit VestedTokenRedeemed(_to, amount, vestedMonths);
430         return true;
431     }
432 
433     /**
434     * @dev Function to return granted token to the initial sender.
435     * @param _amount - A uint256 specifying the amount of tokens to be returned.
436     */
437     function returnGrantedToken(uint256 _amount)
438         public
439         returns (bool success)
440     {
441         address to = timeLocks[msg.sender].from;
442         require(to != address(0));
443         require(_amount > 0, "Nothing to transfer.");
444         require(timeLocks[msg.sender].amount > 0, "Nothing to return.");
445         require(_amount <= timeLocks[msg.sender].amount.sub(timeLocks[msg.sender].vestedAmount), "Not enough granted token to return.");
446 
447         timeLocks[msg.sender].amount = timeLocks[msg.sender].amount.sub(_amount);
448         balances[to] = balances[to].add(_amount);
449 
450         emit GrantedTokenReturned(msg.sender, to, _amount);
451         return true;
452     }
453 
454 }