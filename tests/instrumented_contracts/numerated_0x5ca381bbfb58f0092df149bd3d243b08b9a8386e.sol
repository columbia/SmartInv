1 pragma solidity ^0.4.24;
2 
3 /**
4 * MXC Smart Contract for Ethereum
5 * 
6 * Copyright 2018 MXC Foundation
7 *
8 */
9 
10 
11 /**
12 * @title SafeMath
13 * @dev Math operations with safety checks that throw on error
14 */
15 library SafeMath {
16 
17     /**
18     * @dev Multiplies two numbers, throws on overflow.
19     */
20     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
21         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
22         // benefit is lost if 'b' is also tested.
23         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
24         if (a == 0) {
25             return 0;
26         }
27 
28         c = a * b;
29         assert(c / a == b);
30         return c;
31     }
32 
33     /**
34     * @dev Integer division of two numbers, truncating the quotient.
35     */
36     function div(uint256 a, uint256 b) internal pure returns (uint256) {
37         // assert(b > 0); // Solidity automatically throws when dividing by 0
38         // uint256 c = a / b;
39         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40         return a / b;
41     }
42 
43     /**
44     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
45     */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         assert(b <= a);
48         return a - b;
49     }
50 
51     /**
52     * @dev Adds two numbers, throws on overflow.
53     */
54     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
55         c = a + b;
56         assert(c >= a);
57         return c;
58     }
59 }
60 
61 
62 /**
63 * @title ERC20Basic
64 * @dev Simpler version of ERC20 interface
65 */
66 contract ERC20Basic {
67     function totalSupply() public view returns (uint256);
68     function balanceOf(address who) public view returns (uint256);
69     function transfer(address to, uint256 value) public returns (bool);
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 }
72 
73 
74 /**
75 * @title ERC20 interface
76 */
77 contract ERC20 is ERC20Basic {
78     function allowance(address owner, address spender)
79         public view returns (uint256);
80 
81     function transferFrom(address from, address to, uint256 value)
82         public returns (bool);
83 
84     function approve(address spender, uint256 value) public returns (bool);
85     event Approval(
86         address indexed owner,
87         address indexed spender,
88         uint256 value
89     );
90 }
91 
92 
93 /**
94 * @title Basic token
95 * @dev Basic version of StandardToken, with no allowances.
96 */
97 contract BasicToken is ERC20Basic {
98     using SafeMath for uint256;
99 
100     mapping(address => uint256) balances;
101 
102     uint256 totalSupply_;
103 
104     /**
105     * @dev Total number of tokens in existence
106     */
107     function totalSupply() public view returns (uint256) {
108         return totalSupply_;
109     }
110 
111     /**
112     * @dev Transfer token for a specified address
113     * @param _to The address to transfer to.
114     * @param _value The amount to be transferred.
115     */
116     function transfer(address _to, uint256 _value) public returns (bool) {
117         require(_to != address(0));
118         require(_value <= balances[msg.sender]);
119 
120         balances[msg.sender] = balances[msg.sender].sub(_value);
121         balances[_to] = balances[_to].add(_value);
122         emit Transfer(msg.sender, _to, _value);
123         return true;
124     }
125 
126     /**
127     * @dev Gets the balance of the specified address.
128     * @param _owner The address to query the the balance of.
129     * @return An uint256 representing the amount owned by the passed address.
130     */
131     function balanceOf(address _owner) public view returns (uint256) {
132         return balances[_owner];
133     }
134 
135 }
136 
137 
138 /**
139 * @title Standard ERC20 token
140 *
141 * @dev Implementation of the basic standard token.
142 */
143 contract StandardToken is ERC20, BasicToken {
144 
145     mapping (address => mapping (address => uint256)) internal allowed;
146 
147     /**
148     * @dev Transfer tokens from one address to another
149     * @param _from address The address which you want to send tokens from
150     * @param _to address The address which you want to transfer to
151     * @param _value uint256 the amount of tokens to be transferred
152     */
153     function transferFrom(
154         address _from,
155         address _to,
156         uint256 _value
157     )
158         public
159         returns (bool)
160     {
161         require(_to != address(0));
162         require(_value <= balances[_from]);
163         require(_value <= allowed[_from][msg.sender]);
164 
165         balances[_from] = balances[_from].sub(_value);
166         balances[_to] = balances[_to].add(_value);
167         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
168         emit Transfer(_from, _to, _value);
169         return true;
170     }
171 
172     /**
173     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
174     * Beware that changing an allowance with this method brings the risk that someone may use both the old
175     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
176     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards,
177     * i.e. clients SHOULD make sure to create user interfaces in such a way 
178     * that they set the allowance first to 0 before setting it to another value for the same spender. 
179     * @param _spender The address which will spend the funds.
180     * @param _value The amount of tokens to be spent.
181     */
182     function approve(address _spender, uint256 _value) public returns (bool) {
183         allowed[msg.sender][_spender] = _value;
184         emit Approval(msg.sender, _spender, _value);
185         return true;
186     }
187 
188     /**
189     * @dev Function to check the amount of tokens that an owner allowed to a spender.
190     * @param _owner address The address which owns the funds.
191     * @param _spender address The address which will spend the funds.
192     * @return A uint256 specifying the amount of tokens still available for the spender.
193     */
194     function allowance(
195         address _owner,
196         address _spender
197    )
198         public
199         view
200         returns (uint256)
201     {
202         return allowed[_owner][_spender];
203     }
204 
205     /**
206     * @dev Increase the amount of tokens that an owner allowed to a spender.
207     * approve should be called when allowed[_spender] == 0. To increment
208     * allowed value is better to use this function to avoid 2 calls (and wait until
209     * the first transaction is mined)
210     * @param _spender The address which will spend the funds.
211     * @param _addedValue The amount of tokens to increase the allowance by.
212     */
213     function increaseApproval(
214         address _spender,
215         uint256 _addedValue
216     )
217         public
218         returns (bool)
219     {
220         allowed[msg.sender][_spender] = (
221             allowed[msg.sender][_spender].add(_addedValue));
222         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
223         return true;
224     }
225 
226     /**
227     * @dev Decrease the amount of tokens that an owner allowed to a spender.
228     * approve should be called when allowed[_spender] == 0. To decrement
229     * allowed value is better to use this function to avoid 2 calls (and wait until
230     * the first transaction is mined)
231     * @param _spender The address which will spend the funds.
232     * @param _subtractedValue The amount of tokens to decrease the allowance by.
233     */
234     function decreaseApproval(
235         address _spender,
236         uint256 _subtractedValue
237     )
238         public
239         returns (bool)
240     {
241         uint256 oldValue = allowed[msg.sender][_spender];
242         if (_subtractedValue > oldValue) {
243             allowed[msg.sender][_spender] = 0;
244         } else {
245             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
246         }
247         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
248         return true;
249     }
250 
251 }
252 
253 
254 contract MXCToken is StandardToken {
255 
256     string public constant name = "MXCToken";
257     string public constant symbol = "MXC";
258     uint8 public constant decimals = 18;
259 
260     uint256 constant MONTH = 3600*24*30;
261 
262     struct TimeLock {
263         // total amount of tokens that is granted to the user
264         uint256 amount;
265 
266         // total amount of tokens that have been vested
267         uint256 vestedAmount;
268 
269         // total amount of vested months (tokens are vested on a monthly basis)
270         uint16 vestedMonths;
271 
272         // token timestamp start
273         uint256 start;
274 
275         // token timestamp release start (when user can start receive vested tokens)
276         uint256 cliff;
277 
278         // token timestamp release end (when all the tokens can be vested)
279         uint256 vesting;
280 
281         address from;
282     }
283 
284     mapping(address => TimeLock) timeLocks;
285 
286     event NewTokenGrant(address indexed _from, address indexed _to, uint256 _amount, uint256 _start, uint256 _cliff, uint256 _vesting);
287     event VestedTokenRedeemed(address indexed _to, uint256 _amount, uint256 _vestedMonths);
288     event GrantedTokenReturned(address indexed _from, address indexed _to, uint256 _amount);
289 
290     /**
291     * @dev Constructor that gives msg.sender all of existing tokens.
292     */
293     constructor() public {
294         totalSupply_ = 2664965800 * (10 ** uint256(decimals));
295         balances[msg.sender] = totalSupply_;
296         emit Transfer(address(0), msg.sender, totalSupply_);
297     }
298 
299     function vestBalanceOf(address who)
300         public view
301         returns (uint256 amount, uint256 vestedAmount, uint256 start, uint256 cliff, uint256 vesting)
302     {
303         require(who != address(0));
304         amount = timeLocks[who].amount;
305         vestedAmount = timeLocks[who].vestedAmount;
306         start = timeLocks[who].start;
307         cliff = timeLocks[who].cliff;
308         vesting = timeLocks[who].vesting;
309     }
310 
311     /**
312     * @dev Function to grant the amount of tokens that will be vested later.
313     * @param _to The address which will own the tokens.
314     * @param _amount The amount of tokens that will be vested later.
315     * @param _start Token timestamp start.
316     * @param _cliff Token timestamp release start.
317     * @param _vesting Token timestamp release end.
318     */
319     function grantToken(
320         address _to,
321         uint256 _amount,
322         uint256 _start,
323         uint256 _cliff,
324         uint256 _vesting
325     )
326         public
327         returns (bool success)
328     {
329         require(_to != address(0));
330         require(_amount <= balances[msg.sender], "Not enough balance to grant token.");
331         require(_amount > 0, "Nothing to transfer.");
332         require((timeLocks[_to].amount.sub(timeLocks[_to].vestedAmount) == 0), "The previous vesting should be completed.");
333         require(_cliff >= _start, "_cliff must be >= _start");
334         require(_vesting > _start, "_vesting must be bigger than _start");
335         require(_vesting > _cliff, "_vesting must be bigger than _cliff");
336 
337         balances[msg.sender] = balances[msg.sender].sub(_amount);
338         timeLocks[_to] = TimeLock(_amount, 0, 0, _start, _cliff, _vesting, msg.sender);
339 
340         emit NewTokenGrant(msg.sender, _to, _amount, _start, _cliff, _vesting);
341         return true;
342     }
343 
344     /**
345     * @dev Function to grant the amount of tokens that will be vested later.
346     * @param _to The address which will own the tokens.
347     * @param _amount The amount of tokens that will be vested later.
348     * @param _cliffMonths Token release start in months from now.
349     * @param _vestingMonths Token release end in months from now.
350     */
351     function grantTokenStartNow(
352         address _to,
353         uint256 _amount,
354         uint256 _cliffMonths,
355         uint256 _vestingMonths
356     )
357         public
358         returns (bool success)
359     {
360         return grantToken(
361             _to,
362             _amount,
363             now,
364             now.add(_cliffMonths.mul(MONTH)),
365             now.add(_vestingMonths.mul(MONTH))
366             );
367     }
368 
369     /**
370     * @dev Function to calculate the amount of tokens that can be vested at this moment.
371     * @param _to The address which will own the tokens.
372     * @return amount - A uint256 specifying the amount of tokens available to be vested at this moment.
373     * @return vestedMonths - A uint256 specifying the number of the vested months since the last vesting.
374     * @return curTime - A uint256 specifying the current timestamp.
375     */
376     function calcVestableToken(address _to)
377         internal view
378         returns (uint256 amount, uint256 vestedMonths, uint256 curTime)
379     {
380         uint256 vestTotalMonths;
381         uint256 vestedAmount;
382         uint256 vestPart;
383         amount = 0;
384         vestedMonths = 0;
385         curTime = now;
386         
387         require(timeLocks[_to].amount > 0, "Nothing was granted to this address.");
388         
389         if (curTime <= timeLocks[_to].cliff) {
390             return (0, 0, curTime);
391         }
392 
393         vestedMonths = curTime.sub(timeLocks[_to].start) / MONTH;
394         vestedMonths = vestedMonths.sub(timeLocks[_to].vestedMonths);
395 
396         if (curTime >= timeLocks[_to].vesting) {
397             return (timeLocks[_to].amount.sub(timeLocks[_to].vestedAmount), vestedMonths, curTime);
398         }
399 
400         if (vestedMonths > 0) {
401             vestTotalMonths = timeLocks[_to].vesting.sub(timeLocks[_to].start) / MONTH;
402             vestPart = timeLocks[_to].amount.div(vestTotalMonths);
403             amount = vestedMonths.mul(vestPart);
404             vestedAmount = timeLocks[_to].vestedAmount.add(amount);
405             if (vestedAmount > timeLocks[_to].amount) {
406                 amount = timeLocks[_to].amount.sub(timeLocks[_to].vestedAmount);
407             }
408         }
409 
410         return (amount, vestedMonths, curTime);
411     }
412 
413     /**
414     * @dev Function to redeem tokens that can be vested at this moment.
415     * @param _to The address which will own the tokens.
416     */
417     function redeemVestableToken(address _to)
418         public
419         returns (bool success)
420     {
421         require(_to != address(0));
422         require(timeLocks[_to].amount > 0, "Nothing was granted to this address!");
423         require(timeLocks[_to].vestedAmount < timeLocks[_to].amount, "All tokens were vested!");
424 
425         (uint256 amount, uint256 vestedMonths, uint256 curTime) = calcVestableToken(_to);
426         require(amount > 0, "Nothing to redeem now.");
427 
428         TimeLock storage t = timeLocks[_to];
429         balances[_to] = balances[_to].add(amount);
430         t.vestedAmount = t.vestedAmount.add(amount);
431         t.vestedMonths = t.vestedMonths + uint16(vestedMonths);
432         t.cliff = curTime;
433 
434         emit VestedTokenRedeemed(_to, amount, vestedMonths);
435         return true;
436     }
437 
438     /**
439     * @dev Function to return granted token to the initial sender.
440     * @param _amount - A uint256 specifying the amount of tokens to be returned.
441     */
442     function returnGrantedToken(uint256 _amount)
443         public
444         returns (bool success)
445     {
446         address to = timeLocks[msg.sender].from;
447         require(to != address(0));
448         require(_amount > 0, "Nothing to transfer.");
449         require(timeLocks[msg.sender].amount > 0, "Nothing to return.");
450         require(_amount <= timeLocks[msg.sender].amount.sub(timeLocks[msg.sender].vestedAmount), "Not enough granted token to return.");
451 
452         timeLocks[msg.sender].amount = timeLocks[msg.sender].amount.sub(_amount);
453         balances[to] = balances[to].add(_amount);
454 
455         emit GrantedTokenReturned(msg.sender, to, _amount);
456         return true;
457     }
458 
459 }