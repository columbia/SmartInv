1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9     uint256 public totalSupply;
10     function balanceOf(address who) public view returns (uint256);
11     function transfer(address to, uint256 value) public returns (bool);
12     event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20     function allowance(address owner, address spender) public view returns (uint256);
21     function transferFrom(address from, address to, uint256 value) public returns (bool);
22     function approve(address spender, uint256 value) public returns (bool);
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 
27 /**
28  * @title SafeMath
29  * @dev Math operations with safety checks that throw on error
30  */
31 library SafeMath {
32     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33         if (a == 0) {
34             return 0;
35         }
36         uint256 c = a * b;
37         assert(c / a == b);
38         return c;
39     }
40 
41     function div(uint256 a, uint256 b) internal pure returns (uint256) {
42         // assert(b > 0); // Solidity automatically throws when dividing by 0
43         uint256 c = a / b;
44         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45         return c;
46     }
47 
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         assert(b <= a);
50         return a - b;
51     }
52 
53     function add(uint256 a, uint256 b) internal pure returns (uint256) {
54         uint256 c = a + b;
55         assert(c >= a);
56         return c;
57     }
58 }
59 
60 
61 /**
62  * @title Basic token
63  * @dev Basic version of StandardToken, with no allowances.
64  */
65 contract BasicToken is ERC20Basic {
66     using SafeMath for uint256;
67 
68     mapping(address => uint256) balances;
69 
70     /**
71     * @dev transfer token for a specified address
72     * @param _to The address to transfer to.
73     * @param _value The amount to be transferred.
74     */
75     function transfer(address _to, uint256 _value) public returns (bool) {
76         require(_to != address(0));
77         require(_value <= balances[msg.sender]);
78 
79         // SafeMath.sub will throw if there is not enough balance.
80         balances[msg.sender] = balances[msg.sender].sub(_value);
81         balances[_to] = balances[_to].add(_value);
82         emit Transfer(msg.sender, _to, _value);
83         return true;
84     }
85 
86     /**
87     * @dev Gets the balance of the specified address.
88     * @param _owner The address to query the the balance of.
89     * @return An uint256 representing the amount owned by the passed address.
90     */
91     function balanceOf(address _owner) public view returns (uint256 balance) {
92         return balances[_owner];
93     }
94 
95 }
96 
97 /**
98  * @title Standard ERC20 token
99  *
100  * @dev Implementation of the basic standard token.
101  * @dev https://github.com/ethereum/EIPs/issues/20
102  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
103  */
104 contract StandardToken is ERC20, BasicToken {
105 
106     mapping (address => mapping (address => uint256)) internal allowed;
107 
108 
109     /**
110     * @dev Transfer tokens from one address to another
111     * @param _from address The address which you want to send tokens from
112     * @param _to address The address which you want to transfer to
113     * @param _value uint256 the amount of tokens to be transferred
114     */
115     function transferFrom(
116         address _from,
117         address _to,
118         uint256 _value
119     )
120         public
121         returns (bool)
122     {
123         require(_to != address(0));
124         require(_value <= balances[_from]);
125         require(_value <= allowed[_from][msg.sender]);
126 
127         balances[_from] = balances[_from].sub(_value);
128         balances[_to] = balances[_to].add(_value);
129         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
130         emit Transfer(_from, _to, _value);
131         return true;
132     }
133 
134     /**
135     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
136     *
137     * Beware that changing an allowance with this method brings the risk that someone may use both the old
138     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
139     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
140     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
141     * @param _spender The address which will spend the funds.
142     * @param _value The amount of tokens to be spent.
143     */
144     function approve(address _spender, uint256 _value) public returns (bool) {
145         allowed[msg.sender][_spender] = _value;
146         emit Approval(msg.sender, _spender, _value);
147         return true;
148     }
149 
150     /**
151     * @dev Function to check the amount of tokens that an owner allowed to a spender.
152     * @param _owner address The address which owns the funds.
153     * @param _spender address The address which will spend the funds.
154     * @return A uint256 specifying the amount of tokens still available for the spender.
155     */
156     function allowance(
157         address _owner,
158         address _spender
159     )
160         public
161         view
162         returns (uint256)
163     {
164         return allowed[_owner][_spender];
165     }
166 
167     /**
168     * @dev Increase the amount of tokens that an owner allowed to a spender.
169     *
170     * approve should be called when allowed[_spender] == 0. To increment
171     * allowed value is better to use this function to avoid 2 calls (and wait until
172     * the first transaction is mined)
173     * From MonolithDAO Token.sol
174     * @param _spender The address which will spend the funds.
175     * @param _addedValue The amount of tokens to increase the allowance by.
176     */
177     function increaseApproval(
178         address _spender,
179         uint _addedValue
180     )
181         public
182         returns (bool)
183     {
184         allowed[msg.sender][_spender] = (
185         allowed[msg.sender][_spender].add(_addedValue));
186         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
187         return true;
188     }
189 
190     /**
191     * @dev Decrease the amount of tokens that an owner allowed to a spender.
192     *
193     * approve should be called when allowed[_spender] == 0. To decrement
194     * allowed value is better to use this function to avoid 2 calls (and wait until
195     * the first transaction is mined)
196     * From MonolithDAO Token.sol
197     * @param _spender The address which will spend the funds.
198     * @param _subtractedValue The amount of tokens to decrease the allowance by.
199     */
200     function decreaseApproval(
201         address _spender,
202         uint _subtractedValue
203     )
204         public
205         returns (bool)
206     {
207         uint oldValue = allowed[msg.sender][_spender];
208         if (_subtractedValue > oldValue) {
209             allowed[msg.sender][_spender] = 0;
210         } else {
211             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
212         }
213         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214         return true;
215     }
216 
217 }
218 
219 /**
220  * admin manager
221  */
222 contract AdminManager {
223     event ChangeOwner(address _oldOwner, address _newOwner);
224     event SetAdmin(address _address, bool _isAdmin);
225     //constract's owner
226     address public owner;
227     //constract's admins. permission less than owner
228     mapping(address=>bool) public admins;
229 
230     /**
231      * constructor
232      */
233     constructor() public {
234         owner = msg.sender;
235     }
236 
237     /**
238      * modifier for some action only owner can do
239      */
240     modifier onlyOwner() {
241         require(msg.sender == owner);
242         _;
243     }
244 
245     /**
246      * modifier for some action only admin or owner can do
247      */
248     modifier onlyAdmins() {
249         require(msg.sender == owner || admins[msg.sender]);
250         _;
251     }
252 
253     /**
254      * change this constract's owner
255      */
256     function changeOwner(address _newOwner) public onlyOwner {
257         require(_newOwner != address(0));
258         emit ChangeOwner(owner, _newOwner);
259         owner = _newOwner;
260     }
261 
262     /**
263      * add or delete admin
264      */
265     function setAdmin(address _address, bool _isAdmin) public onlyOwner {
266         emit SetAdmin(_address, _isAdmin);
267         if(!_isAdmin){
268             delete admins[_address];
269         }else{
270             admins[_address] = true;
271         }
272     }
273 }
274 
275 /**
276  * pausable token 
277  */
278 contract PausableToken is StandardToken, AdminManager {
279     event SetPause(bool isPause);
280     bool public paused = true;
281 
282     /**
283      * modifier for pause constract. not contains admin and owner
284      */
285     modifier whenNotPaused() {
286         if(paused) {
287             require(msg.sender == owner || admins[msg.sender]);
288         }
289         _;
290     }
291 
292     /**
293      * @dev called by the owner to set new pause flags
294      * pausedPublic can't be false while pausedOwnerAdmin is true
295      */
296     function setPause(bool _isPause) onlyAdmins public {
297         require(paused != _isPause);
298         paused = _isPause;
299         emit SetPause(_isPause);
300     }
301 
302     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
303         return super.transfer(_to, _value);
304     }
305 
306     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
307         return super.transferFrom(_from, _to, _value);
308     }
309 
310     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
311         return super.approve(_spender, _value);
312     }
313 
314     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
315         return super.increaseApproval(_spender, _addedValue);
316     }
317 
318     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
319         return super.decreaseApproval(_spender, _subtractedValue);
320     }
321 }
322 
323 /**
324  * lockadble token
325  */
326 contract LockableToken is PausableToken {
327 
328     /**
329      * lock data struct
330      */
331     struct LockData {
332         uint256 balance;
333         uint256 releaseTimeS;
334     }
335 
336     event SetLock(address _address, uint256 _lockValue, uint256 _releaseTimeS);
337 
338     mapping (address => LockData) public locks;
339 
340     /**
341      * if active balance is not enought. deny transaction
342      */
343     modifier whenNotLocked(address _from, uint256 _value) {
344         require( activeBalanceOf(_from) >= _value );
345         _;
346     }
347 
348     /**
349      * active balance of address
350      */
351     function activeBalanceOf(address _owner) public view returns (uint256) {
352         if( uint256(now) < locks[_owner].releaseTimeS ) {
353             return balances[_owner].sub(locks[_owner].balance);
354         }
355         return balances[_owner];
356     }
357     
358     /**
359      * lock one address
360      * one address only be locked at the same time. 
361      * because the gas reson, so not support multi lock of one address
362      * 
363      * @param _lockValue     how many tokens locked
364      * @param _releaseTimeS  the lock release unix time 
365      */
366     function setLock(address _address, uint256 _lockValue, uint256 _releaseTimeS) onlyAdmins public {
367         require( uint256(now) > locks[_address].releaseTimeS );
368         locks[_address].balance = _lockValue;
369         locks[_address].releaseTimeS = _releaseTimeS;
370         emit SetLock(_address, _lockValue, _releaseTimeS);
371     }
372 
373     function transfer(address _to, uint256 _value) public whenNotLocked(msg.sender, _value) returns (bool) {
374         return super.transfer(_to, _value);
375     }
376 
377     function transferFrom(address _from, address _to, uint256 _value) public whenNotLocked(_from, _value) returns (bool) {
378         return super.transferFrom(_from, _to, _value);
379     }
380 }
381 
382 
383 contract LeekUprising is LockableToken {
384     event Burn(address indexed _burner, uint256 _value);
385 
386     string  public  constant name = "LeekUprising";
387     string  public  constant symbol = "LUP";
388     uint8   public  constant decimals = 6;
389 
390     /**
391      * constructor 
392      */
393     constructor() public {
394         //set totalSupply 1000 000 000.000000
395         totalSupply = 10**15;
396         //init balances
397         balances[msg.sender] = totalSupply;
398         emit Transfer(address(0x0), msg.sender, totalSupply);   
399     }
400 
401     /**
402      * transfer and lock this value
403      * only called by admins (limit when setLock)
404      */
405     function transferAndLock(address _to, uint256 _value, uint256 _releaseTimeS) public returns (bool) {
406         //at first, try lock address
407         setLock(_to,_value,_releaseTimeS);
408         //if transfer failed, must be throw a exception
409         transfer(_to, _value);
410         return true;
411     }
412 
413     /**
414      * transfer to multi accounts
415      * if need multi accounts with diffient value, please create a help contract
416      */
417     function transferMulti(address[] adds, uint256 value) public{
418         //transfer for every one
419         for(uint256 i=0; i<adds.length; i++){
420             //if transfer failed, must be throw a exception
421             transfer(adds[i], value);
422         }
423     }
424 }