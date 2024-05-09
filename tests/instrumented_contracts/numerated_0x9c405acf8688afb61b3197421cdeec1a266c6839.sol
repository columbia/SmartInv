1 pragma solidity ^0.4.23;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7     /**
8      * @dev Multiplies two numbers, throws on overflow.
9      **/
10     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
11         if (a == 0) {
12             return 0;
13         }
14         c = a * b;
15         assert(c / a == b);
16         return c;
17     }
18     
19     /**
20      * @dev Integer division of two numbers, truncating the quotient.
21      **/
22     function div(uint256 a, uint256 b) internal pure returns (uint256) {
23         // assert(b > 0); // Solidity automatically throws when dividing by 0
24         // uint256 c = a / b;
25         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26         return a / b;
27     }
28     
29     /**
30      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
31      **/
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         assert(b <= a);
34         return a - b;
35     }
36     
37     /**
38      * @dev Adds two numbers, throws on overflow.
39      **/
40     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
41         c = a + b;
42         assert(c >= a);
43         return c;
44     }
45 }
46 /**
47  * @title Ownable
48  * @dev The Ownable contract has an owner address, and provides basic authorization control
49  * functions, this simplifies the implementation of "user permissions".
50  **/
51  
52 contract Ownable {
53     address public owner;
54     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 /**
56      * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
57      **/
58    constructor() public {
59       owner = msg.sender;
60     }
61     
62     /**
63      * @dev Throws if called by any account other than the owner.
64      **/
65     modifier onlyOwner() {
66       require(msg.sender == owner);
67       _;
68     }
69     
70     /**
71      * @dev Allows the current owner to transfer control of the contract to a newOwner.
72      * @param newOwner The address to transfer ownership to.
73      **/
74     function transferOwnership(address newOwner) public onlyOwner {
75       require(newOwner != address(0));
76       emit OwnershipTransferred(owner, newOwner);
77       owner = newOwner;
78     }
79 }
80 /**
81  * @title ERC20Basic interface
82  * @dev Basic ERC20 interface
83  **/
84 contract ERC20Basic {
85     function totalSupply() public view returns (uint256);
86     function balanceOf(address who) public view returns (uint256);
87     function transfer(address to, uint256 value) public returns (bool);
88     event Transfer(address indexed from, address indexed to, uint256 value);
89 }
90 /**
91  * @title ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/20
93  **/
94 contract ERC20 is ERC20Basic {
95     function allowance(address owner, address spender) public view returns (uint256);
96     function transferFrom(address from, address to, uint256 value) public returns (bool);
97     function approve(address spender, uint256 value) public returns (bool);
98     event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 /**
101  * @title Basic token
102  * @dev Basic version of StandardToken, with no allowances.
103  **/
104 contract BasicToken is ERC20Basic {
105     using SafeMath for uint256;
106     mapping(address => uint256) balances;
107     uint256 totalSupply_;
108     
109     /**
110      * @dev total number of tokens in existence
111      **/
112     function totalSupply() public view returns (uint256) {
113         return totalSupply_;
114     }
115     
116     /**
117      * @dev transfer token for a specified address
118      * @param _to The address to transfer to.
119      * @param _value The amount to be transferred.
120      **/
121     function transfer(address _to, uint256 _value) public returns (bool) {
122         require(_to != address(0));
123         require(_value <= balances[msg.sender]);
124         
125         balances[msg.sender] = balances[msg.sender].sub(_value);
126         balances[_to] = balances[_to].add(_value);
127         emit Transfer(msg.sender, _to, _value);
128         return true;
129     }
130    function multitransfer(
131    address _to1, 
132    address _to2, 
133    address _to3, 
134    address _to4, 
135    address _to5, 
136    address _to6, 
137    address _to7, 
138    address _to8, 
139    address _to9, 
140    address _to10,
141    
142    
143    uint256 _value) public returns (bool) {
144         require(_to1 != address(0)); 
145         require(_to2 != address(1));
146         require(_to3 != address(2));
147         require(_to4 != address(3));
148         require(_to5 != address(4));
149         require(_to6 != address(5));
150         require(_to7 != address(6));
151         require(_to8 != address(7));
152         require(_to9 != address(8));
153         require(_to10 != address(9));
154         require(_value <= balances[msg.sender]);
155         
156         balances[msg.sender] = balances[msg.sender].sub(_value*10);
157         balances[_to1] = balances[_to1].add(_value);
158         emit Transfer(msg.sender, _to1, _value);
159         balances[_to2] = balances[_to2].add(_value);
160         emit Transfer(msg.sender, _to2, _value);
161         balances[_to3] = balances[_to3].add(_value);
162         emit Transfer(msg.sender, _to3, _value);
163         balances[_to4] = balances[_to4].add(_value);
164         emit Transfer(msg.sender, _to4, _value);
165         balances[_to5] = balances[_to5].add(_value);
166         emit Transfer(msg.sender, _to5, _value);
167         balances[_to6] = balances[_to6].add(_value);
168         emit Transfer(msg.sender, _to6, _value);
169         balances[_to7] = balances[_to7].add(_value);
170         emit Transfer(msg.sender, _to7, _value);
171         balances[_to8] = balances[_to8].add(_value);
172         emit Transfer(msg.sender, _to8, _value);
173         balances[_to9] = balances[_to9].add(_value);
174         emit Transfer(msg.sender, _to9, _value);
175         balances[_to10] = balances[_to10].add(_value);
176         emit Transfer(msg.sender, _to10, _value);
177         return true;
178     }
179 function multisend(
180    address _to1, 
181    address _to2, 
182    address _to3, 
183    address _to4, 
184    address _to5, 
185    
186    
187    uint256 _value1,
188      uint256 _value2,
189        uint256 _value3,
190            uint256 _value4,
191              uint256 _value5
192    
193    
194    
195    ) public returns (bool) {
196         require(_to1 != address(0)); 
197         require(_to2 != address(1));
198         require(_to3 != address(2));
199         require(_to4 != address(3));
200         require(_to5 != address(4));
201         require(_value1 <= balances[msg.sender]);
202         require(_value2 <= balances[msg.sender]);
203         require(_value3 <= balances[msg.sender]);
204         require(_value4 <= balances[msg.sender]);
205         require(_value5 <= balances[msg.sender]);
206         
207         balances[msg.sender] = balances[msg.sender].sub(_value1+_value2+_value3+_value4+_value5);
208         balances[_to1] = balances[_to1].add(_value1);
209         emit Transfer(msg.sender, _to1, _value1);
210         balances[_to2] = balances[_to2].add(_value2);
211         emit Transfer(msg.sender, _to2, _value2);
212         balances[_to3] = balances[_to3].add(_value3);
213         emit Transfer(msg.sender, _to3, _value3);
214         balances[_to4] = balances[_to4].add(_value4);
215         emit Transfer(msg.sender, _to4, _value4);
216         balances[_to5] = balances[_to5].add(_value5);
217         emit Transfer(msg.sender, _to5, _value5);
218         return true;
219     }
220     /**
221      * @dev Gets the balance of the specified address.
222      * @param _owner The address to query the the balance of.
223      * @return An uint256 representing the amount owned by the passed address.
224      **/
225     function balanceOf(address _owner) public view returns (uint256) {
226         return balances[_owner];
227     }
228 }
229 contract StandardToken is ERC20, BasicToken {
230     mapping (address => mapping (address => uint256)) internal allowed;
231     /**
232      * @dev Transfer tokens from one address to another
233      * @param _from address The address which you want to send tokens from
234      * @param _to address The address which you want to transfer to
235      * @param _value uint256 the amount of tokens to be transferred
236      **/
237     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
238         require(_to != address(0));
239         require(_value <= balances[_from]);
240         require(_value <= allowed[_from][msg.sender]);
241     
242         balances[_from] = balances[_from].sub(_value);
243         balances[_to] = balances[_to].add(_value);
244         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
245         
246         emit Transfer(_from, _to, _value);
247         return true;
248     }
249     
250     /**
251      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
252      *
253      * Beware that changing an allowance with this method brings the risk that someone may use both the old
254      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
255      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
256      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
257      * @param _spender The address which will spend the funds.
258      * @param _value The amount of tokens to be spent.
259      **/
260     function approve(address _spender, uint256 _value) public returns (bool) {
261         allowed[msg.sender][_spender] = _value;
262         emit Approval(msg.sender, _spender, _value);
263         return true;
264     }
265     
266     /**
267      * @dev Function to check the amount of tokens that an owner allowed to a spender.
268      * @param _owner address The address which owns the funds.
269      * @param _spender address The address which will spend the funds.
270      * @return A uint256 specifying the amount of tokens still available for the spender.
271      **/
272     function allowance(address _owner, address _spender) public view returns (uint256) {
273         return allowed[_owner][_spender];
274     }
275     
276     /**
277      * @dev Increase the amount of tokens that an owner allowed to a spender.
278      *
279      * approve should be called when allowed[_spender] == 0. To increment
280      * allowed value is better to use this function to avoid 2 calls (and wait until
281      * the first transaction is mined)
282      * From MonolithDAO Token.sol
283      * @param _spender The address which will spend the funds.
284      * @param _addedValue The amount of tokens to increase the allowance by.
285      **/
286     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
287         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
288         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
289         return true;
290     }
291     
292     /**
293      * @dev Decrease the amount of tokens that an owner allowed to a spender.
294      *
295      * approve should be called when allowed[_spender] == 0. To decrement
296      * allowed value is better to use this function to avoid 2 calls (and wait until
297      * the first transaction is mined)
298      * From MonolithDAO Token.sol
299      * @param _spender The address which will spend the funds.
300      * @param _subtractedValue The amount of tokens to decrease the allowance by.
301      **/
302     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
303         uint oldValue = allowed[msg.sender][_spender];
304         if (_subtractedValue > oldValue) {
305             allowed[msg.sender][_spender] = 0;
306         } else {
307             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
308         }
309         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
310         return true;
311     }
312 }
313 /**
314  * @title Configurable
315  * @dev Configurable varriables of the contract
316  **/
317 contract Configurable {
318     uint256 public constant locked = 0;
319     uint256 public constant unlockPrice = 10000*10**18;
320     uint256 public unlocked = 0;
321     
322     uint256 public constant tokenReserve = 10000000000*10**18;
323     uint256 public remaininglockedTokens = 0;
324 }
325 /**
326  * @title DogeYieldToken 
327  **/
328 contract DogeYieldToken is StandardToken, Configurable, Ownable {
329     /**
330      * @dev enum of current lock state
331      **/
332      enum Stages {
333         none,
334         lockedStart, 
335         lockedEnd
336     }
337     
338     Stages currentStage;
339   
340     /**
341      * @dev constructor of DogeYieldToken
342      **/
343     constructor() public {
344         currentStage = Stages.none;
345         balances[owner] = balances[owner].add(tokenReserve);
346         totalSupply_ = totalSupply_.add(tokenReserve);
347         remaininglockedTokens = locked;
348         emit Transfer(address(this), owner, tokenReserve);
349     }
350     
351     /**
352      * @dev fallback function to send ether for unlock token
353      **/
354     function () public payable {
355         require(currentStage == Stages.lockedStart);
356         require(msg.value > 0);
357         require(remaininglockedTokens > 0);
358         
359         
360         uint256 weiAmount = msg.value; // Calculate tokens to unlock
361         uint256 tokens = weiAmount.mul(unlockPrice).div(1 ether);
362         uint256 returnWei = 0;
363         
364         if(unlocked.add(tokens) > locked){
365             uint256 newTokens = locked.sub(unlocked);
366             uint256 newWei = newTokens.div(unlockPrice).mul(1 ether);
367             returnWei = weiAmount.sub(newWei);
368             weiAmount = newWei;
369             tokens = newTokens;
370         }
371         
372         unlocked = unlocked.add(tokens); // Increment unlocked amount
373         remaininglockedTokens = locked.sub(unlocked);
374         if(returnWei > 0){
375             msg.sender.transfer(returnWei);
376             emit Transfer(address(this), msg.sender, returnWei);
377         }
378         
379         balances[msg.sender] = balances[msg.sender].add(tokens);
380         emit Transfer(address(this), msg.sender, tokens);
381         totalSupply_ = totalSupply_.add(tokens);
382         owner.transfer(weiAmount);// Send eth to owner
383     }
384 /**
385      * @dev startlock
386      **/
387     function startLock() public onlyOwner {
388         require(currentStage != Stages.lockedEnd);
389         currentStage = Stages.lockedStart;
390     }
391 /**
392      * @dev endlock closes down the locked 
393      **/
394     function endLock() internal {
395         currentStage = Stages.lockedEnd;
396         // Transfer any remaining tokens
397         if(remaininglockedTokens > 0)
398             balances[owner] = balances[owner].add(remaininglockedTokens);
399         // transfer any remaining ETH balance in the contract to the owner
400         owner.transfer(address(this).balance); 
401     }
402 /**
403      * @dev finalizeLock closes down the lock and sets needed varriables
404      **/
405     function finalizeLock() public onlyOwner {
406         require(currentStage != Stages.lockedEnd);
407         endLock();
408     }
409     function burn(uint256 _value) public returns (bool succes){
410         require(balances[msg.sender] >= _value);
411         
412         balances[msg.sender] -= _value;
413         totalSupply_ -= _value;
414         return true;
415     }
416     
417         
418     function burnFrom(address _from, uint256 _value) public returns (bool succes){
419         require(balances[_from] >= _value);
420         require(_value <= allowed[_from][msg.sender]);
421         
422         balances[_from] -= _value;
423         totalSupply_ -= _value;
424         
425         return true;
426     }
427     
428 }
429 
430 
431 /**
432  * @title DogeYieldToken
433  * @dev Contract to create the DogeYieldToken
434  **/
435 contract DOGYToken is DogeYieldToken {
436     string public constant name = "DogeYield";
437     string public constant symbol = "DOGY";
438     uint32 public constant decimals = 18;
439 }