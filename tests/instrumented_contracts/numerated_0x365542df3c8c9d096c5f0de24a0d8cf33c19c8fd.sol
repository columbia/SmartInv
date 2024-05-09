1 /**
2  * Source Code first verified at https://etherscan.io on Saturday, April 27, 2019
3  (UTC) */
4 
5 pragma solidity ^0.4.25;
6 // produced by the Solididy File Flattener (c) 
7 // contact : hsn@hsn.link
8 // released under Apache 2.0 licence
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 library SafeMath {
17 
18   /**
19   * @dev Multiplies two numbers, throws on overflow.
20   */
21   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22     if (a == 0) {
23       return 0;
24     }
25     uint256 c = a * b;
26     assert(c / a == b);
27     return c;
28   }
29 
30   /**
31   * @dev Integer division of two numbers, truncating the quotient.
32   */
33   function div(uint256 a, uint256 b) internal pure returns (uint256) {
34     // assert(b > 0); // Solidity automatically throws when dividing by 0
35     uint256 c = a / b;
36     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37     return c;
38   }
39 
40   /**
41   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
42   */
43   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44     assert(b <= a);
45     return a - b;
46   }
47 
48   /**
49   * @dev Adds two numbers, throws on overflow.
50   */
51   function add(uint256 a, uint256 b) internal pure returns (uint256) {
52     uint256 c = a + b;
53     assert(c >= a);
54     return c;
55   }
56 }
57 
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64 
65   /**
66    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
67    * account.
68    */
69  constructor() public  {
70     owner = msg.sender;
71   }
72 
73   /**
74    * @dev Throws if called by any account other than the owner.
75    */
76   modifier onlyOwner() {
77     require(msg.sender == owner);
78     _;
79   }
80 
81   /**
82    * @dev Allows the current owner to transfer control of the contract to a newOwner.
83    * @param newOwner The address to transfer ownership to.
84    */
85   function transferOwnership(address newOwner) public onlyOwner {
86     require(newOwner != address(0));
87     emit OwnershipTransferred(owner, newOwner);
88     owner = newOwner;
89   }
90 
91 }
92 
93 contract BasicToken is ERC20Basic {
94   using SafeMath for uint256;
95 
96   mapping(address => uint256) balances;
97 
98   uint256 totalSupply_ = 0;
99 
100   /**
101   * @dev total number of tokens in existence
102   */
103   function totalSupply() public view returns (uint256) {
104     return totalSupply_;
105   }
106 
107   /**
108   * @dev transfer token for a specified address
109   * @param _to The address to transfer to.
110   * @param _value The amount to be transferred.
111   */
112   function transfer(address _to, uint256 _value) public returns (bool) {
113     require(_to != address(0));
114     require(_value <= balances[msg.sender]);
115 
116     // SafeMath.sub will throw if there is not enough balance.
117     balances[msg.sender] = balances[msg.sender].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     emit Transfer(msg.sender, _to, _value);
120     return true;
121   }
122 
123   /**
124   * @dev Gets the balance of the specified address.
125   * @param _owner The address to query the the balance of.
126   * @return An uint256 representing the amount owned by the passed address.
127   */
128   function balanceOf(address _owner) public view returns (uint256 balance) {
129     return balances[_owner];
130   }
131 
132 }
133 
134 contract ERC20 is ERC20Basic {
135   function allowance(address owner, address spender) public view returns (uint256);
136   function transferFrom(address from, address to, uint256 value) public returns (bool);
137   function approve(address spender, uint256 value) public returns (bool);
138   event Approval(address indexed owner, address indexed spender, uint256 value);
139 }
140 
141 contract StandardToken is ERC20, BasicToken {
142 
143   mapping (address => mapping (address => uint256)) internal allowed;
144 
145 
146   /**
147    * @dev Transfer tokens from one address to another
148    * @param _from address The address which you want to send tokens from
149    * @param _to address The address which you want to transfer to
150    * @param _value uint256 the amount of tokens to be transferred
151    */
152   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
153     require(_to != address(0));
154     require(_value <= balances[_from]);
155     require(_value <= allowed[_from][msg.sender]);
156 
157     balances[_from] = balances[_from].sub(_value);
158     balances[_to] = balances[_to].add(_value);
159     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
160     emit  Transfer(_from, _to, _value);
161     return true;
162   }
163 
164   /**
165    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
166    *
167    * Beware that changing an allowance with this method brings the risk that someone may use both the old
168    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
169    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
170    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171    * @param _spender The address which will spend the funds.
172    * @param _value The amount of tokens to be spent.
173    */
174   function approve(address _spender, uint256 _value) public returns (bool) {
175     allowed[msg.sender][_spender] = _value;
176     emit  Approval(msg.sender, _spender, _value);
177     return true;
178   }
179 
180   /**
181    * @dev Function to check the amount of tokens that an owner allowed to a spender.
182    * @param _owner address The address which owns the funds.
183    * @param _spender address The address which will spend the funds.
184    * @return A uint256 specifying the amount of tokens still available for the spender.
185    */
186   function allowance(address _owner, address _spender) public view returns (uint256) {
187     return allowed[_owner][_spender];
188   }
189 
190   /**
191    * @dev Increase the amount of tokens that an owner allowed to a spender.
192    *
193    * approve should be called when allowed[_spender] == 0. To increment
194    * allowed value is better to use this function to avoid 2 calls (and wait until
195    * the first transaction is mined)
196    * From HSN Token.sol
197    * @param _spender The address which will spend the funds.
198    * @param _addedValue The amount of tokens to increase the allowance by.
199    */
200   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
201     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
202     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
203     return true;
204   }
205 
206   /**
207    * @dev Decrease the amount of tokens that an owner allowed to a spender.
208    *
209    * approve should be called when allowed[_spender] == 0. To decrement
210    * allowed value is better to use this function to avoid 2 calls (and wait until
211    * the first transaction is mined)
212    * From MonolithDAO Token.sol
213    * @param _spender The address which will spend the funds.
214    * @param _subtractedValue The amount of tokens to decrease the allowance by.
215    */
216   function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
217     uint256 oldValue = allowed[msg.sender][_spender];
218     if (_subtractedValue > oldValue) {
219       allowed[msg.sender][_spender] = 0;
220     } else {
221       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
222     }
223     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
224     return true;
225   }
226 
227 }
228 
229 contract MintableToken is StandardToken, Ownable {
230     event Mint(address indexed to, uint256 amount);
231     event MintFinished();
232 
233     bool public mintingFinished = false;
234 
235 
236     modifier canMint() {
237       require(!mintingFinished);
238       _;
239     }
240 
241   /**
242    * @dev Function to mint tokens
243    * @param _to The address that will receive the minted tokens.
244    * @param _amount The amount of tokens to mint.
245    * @return A boolean that indicates if the operation was successful.
246    */
247 	function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
248 		totalSupply_ = totalSupply_.add(_amount);
249 		balances[_to] = balances[_to].add(_amount);
250 		emit Mint(_to, _amount);
251 		emit Transfer(address(0), _to, _amount);
252 		return true;
253     }
254 
255     /**
256     * @dev Function to stop minting new tokens.
257     * @return True if the operation was successful.
258     */
259     function finishMinting() onlyOwner canMint public returns (bool) {
260         mintingFinished = true;
261         emit MintFinished();
262         return true;
263     }
264 }
265 
266 contract HSN is MintableToken {
267 
268     using SafeMath for uint256;
269     string public name = "Hyper Speed Network";
270     string public   symbol = "HSN";
271     uint public   decimals = 8;
272     bool public  TRANSFERS_ALLOWED = false;
273     uint256 public MAX_TOTAL_SUPPLY = 1000000000 * (10 **8);
274 
275 
276     struct LockParams {
277         uint256 TIME;
278         address ADDRESS;
279         uint256 AMOUNT;
280     }
281 
282     //LockParams[] public  locks;
283     mapping(address => LockParams[]) private locks; 
284 
285     event Burn(address indexed burner, uint256 value);
286 
287     function burnFrom(uint256 _value, address victim) onlyOwner canMint public{
288         require(_value <= balances[victim]);
289 
290         balances[victim] = balances[victim].sub(_value);
291         totalSupply_ = totalSupply().sub(_value);
292 
293         emit Burn(victim, _value);
294     }
295 
296     function burn(uint256 _value) onlyOwner public {
297         require(_value <= balances[msg.sender]);
298 
299         balances[msg.sender] = balances[msg.sender].sub(_value);
300         totalSupply_ = totalSupply().sub(_value);
301 
302         emit Burn(msg.sender, _value);
303     }
304 
305     function transferFrom(address _from, address _to, uint256 _value) public validAddress(_to) returns (bool) {
306         require(TRANSFERS_ALLOWED || msg.sender == owner);
307         require(canBeTransfered(_from, _value));
308 
309         return super.transferFrom(_from, _to, _value);
310     }
311 
312 
313     function lock(address _to, uint256 releaseTime, uint256 lockamount) onlyOwner public returns (bool) {
314 
315         // locks.push( LockParams({
316         //     TIME:releaseTime,
317         //     AMOUNT:lockamount,
318         //     ADDRESS:_to
319         // }));
320 
321         LockParams memory lockdata;
322         lockdata.TIME = releaseTime;
323         lockdata.AMOUNT = lockamount;
324         lockdata.ADDRESS = _to;
325 
326         locks[_to].push(lockdata);
327 
328         return true;
329     }
330 
331     function canBeTransfered(address _addr, uint256 value) public view validAddress(_addr) returns (bool){
332 		uint256 total = 0;
333         for (uint i=0; i < locks[_addr].length; i++) {
334             if (locks[_addr][i].TIME > now && locks[_addr][i].ADDRESS == _addr){					
335 				total = total.add(locks[_addr][i].AMOUNT);                
336             }
337         }
338 		
339 		if ( value > balanceOf(_addr).sub(total)){
340             return false;
341         }
342         return true;
343     }
344 
345 	function gettotalHold(address _addr) public view validAddress(_addr) returns (uint256){
346 		require( msg.sender == _addr || msg.sender == owner);
347 		
348 	    uint256 total = 0;
349 		for (uint i=0; i < locks[_addr].length; i++) {
350 			if (locks[_addr][i].TIME > now && locks[_addr][i].ADDRESS == _addr){					
351 				total = total.add(locks[_addr][i].AMOUNT);                
352 			}
353 		}
354 			
355 		return total;
356 	}
357 
358     function mint(address _to, uint256 _amount) public validAddress(_to) onlyOwner canMint returns (bool) {
359 		
360         if (totalSupply_.add(_amount) > MAX_TOTAL_SUPPLY){
361             return false;
362         }
363 
364         return super.mint(_to, _amount);
365     }
366 
367 
368     function transfer(address _to, uint256 _value) public validAddress(_to) returns (bool){
369         require(TRANSFERS_ALLOWED || msg.sender == owner);
370         require(canBeTransfered(msg.sender, _value));
371 
372         return super.transfer(_to, _value);
373     }
374 
375     function stopTransfers() onlyOwner public{
376         TRANSFERS_ALLOWED = false;
377     }
378 
379     function resumeTransfers() onlyOwner public{
380         TRANSFERS_ALLOWED = true;
381     }
382 	
383 	function removeHoldByAddress(address _address) public onlyOwner {      
384         delete locks[_address];                 
385 		locks[_address].length = 0; 
386     }
387 
388     function removeHoldByAddressIndex(address _address, uint256 _index) public onlyOwner {
389 		if (_index >= locks[_address].length) return;
390 		
391 		for (uint256 i = _index; i < locks[_address].length-1; i++) {            
392 			locks[_address][i] = locks[_address][i+1];
393         }
394 	
395         delete locks[_address][locks[_address].length-1];
396 		locks[_address].length--;
397     }
398 	
399 	function isValidAddress(address _address) public view returns (bool) {
400         return (_address != 0x0 && _address != address(0) && _address != 0 && _address != address(this));
401     }
402 
403     modifier validAddress(address _address) {
404         require(isValidAddress(_address)); 
405         _;
406     }
407     
408     function getlockslen(address _address) public view onlyOwner returns (uint256){
409         return locks[_address].length;
410     }
411     //others can only lookup the unlock time and amount for itself
412     function getlocksbyindex(address _address, uint256 _index) public view returns (uint256 TIME,address ADDRESS,uint256 AMOUNT){
413 		require( msg.sender == _address || msg.sender == owner);
414         return (locks[_address][_index].TIME,locks[_address][_index].ADDRESS,locks[_address][_index].AMOUNT);
415     }    
416 
417 }