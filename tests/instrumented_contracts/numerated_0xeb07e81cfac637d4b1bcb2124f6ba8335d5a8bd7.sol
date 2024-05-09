1 /**
2     Copyright (c) 2018 Taylor OÜ
3 
4     Permission is hereby granted, free of charge, to any person obtaining a copy
5     of this software and associated documentation files (the "Software"), to deal
6     in the Software without restriction, including without limitation the rights
7     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
8     copies of the Software, and to permit persons to whom the Software is
9     furnished to do so, subject to the following conditions:
10 
11     The above copyright notice and this permission notice shall be included in
12     all copies or substantial portions of the Software.
13 
14     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
15     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
16     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
17     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
18     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
19     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
20     THE SOFTWARE.
21 
22     based on the contracts of OpenZeppelin:
23     https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts
24 
25 **/
26 
27 pragma solidity ^0.4.18;
28 
29 /**
30  * @title Ownable
31  * @dev The Ownable contract has an owner address, and provides basic authorization control
32  * functions, this simplifies the implementation of "user permissions".
33  */
34 contract Ownable {
35   address public owner;
36 
37 
38   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39 
40 
41   /**
42    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
43    * account.
44    */
45   function Ownable() public {
46     owner = msg.sender;
47   }
48 
49 
50   /**
51    * @dev Throws if called by any account other than the owner.
52    */
53   modifier onlyOwner() {
54     require(msg.sender == owner);
55     _;
56   }
57 
58 
59   /**
60    * @dev Allows the current owner to transfer control of the contract to a newOwner.
61    * @param newOwner The address to transfer ownership to.
62    */
63   function transferOwnership(address newOwner) public onlyOwner {
64     require(newOwner != address(0));
65     OwnershipTransferred(owner, newOwner);
66     owner = newOwner;
67   }
68 
69 }
70 
71 
72 /**
73  * @title SafeMath
74  * @dev Math operations with safety checks that throw on error
75  */
76 library SafeMath {
77   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78     if (a == 0) {
79       return 0;
80     }
81     uint256 c = a * b;
82     assert(c / a == b);
83     return c;
84   }
85 
86   function div(uint256 a, uint256 b) internal pure returns (uint256) {
87     // assert(b > 0); // Solidity automatically throws when dividing by 0
88     uint256 c = a / b;
89     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90     return c;
91   }
92 
93   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
94     assert(b <= a);
95     return a - b;
96   }
97 
98   function add(uint256 a, uint256 b) internal pure returns (uint256) {
99     uint256 c = a + b;
100     assert(c >= a);
101     return c;
102   }
103 }
104 
105 
106 /**
107   @title TaylorToken
108 **/
109 contract TaylorToken is Ownable{
110 
111     using SafeMath for uint256;
112 
113     /**
114         EVENTS
115     **/
116     event Transfer(address indexed _from, address indexed _to, uint256 _value);
117     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
118     event Burn(address indexed _owner, uint256 _amount);
119     /**
120         CONTRACT VARIABLES
121     **/
122     mapping (address => uint256) balances;
123     mapping (address => mapping (address => uint256)) allowed;
124 
125     //this address can transfer even when transfer is disabled.
126     mapping (address => bool) public whitelistedTransfer;
127     mapping (address => bool) public whitelistedBurn;
128 
129     string public name = "Taylor";
130     string public symbol = "TAY";
131     uint8 public decimals = 18;
132     uint256 constant internal DECIMAL_CASES = 10**18;
133     uint256 public totalSupply = 10**7 * DECIMAL_CASES;
134     bool public transferable = false;
135 
136     /**
137         MODIFIERS
138     **/
139     modifier onlyWhenTransferable(){
140       if(!whitelistedTransfer[msg.sender]){
141         require(transferable);
142       }
143       _;
144     }
145 
146     /**
147         CONSTRUCTOR
148     **/
149 
150     /**
151       @dev Constructor function executed on contract creation
152     **/
153     function TaylorToken()
154       Ownable()
155       public
156     {
157       balances[owner] = balances[owner].add(totalSupply);
158       whitelistedTransfer[msg.sender] = true;
159       whitelistedBurn[msg.sender] = true;
160       Transfer(address(0),owner, totalSupply);
161     }
162 
163     /**
164         OWNER ONLY FUNCTIONS
165     **/
166 
167     /**
168       @dev Activates the trasfer for all users
169     **/
170     function activateTransfers()
171       public
172       onlyOwner
173     {
174       transferable = true;
175     }
176 
177     /**
178       @dev Allows the owner to add addresse that can bypass the
179       transfer lock. Eg: ICO contract, TGE contract.
180       @param _address address Address to be added
181     **/
182     function addWhitelistedTransfer(address _address)
183       public
184       onlyOwner
185     {
186       whitelistedTransfer[_address] = true;
187     }
188 
189     /**
190       @dev Sends all avaible TAY to the TGE contract to be properly
191       distribute
192       @param _tgeAddress address Address of the token distribution
193       contract
194     **/
195     function distribute(address _tgeAddress)
196       public
197       onlyOwner
198     {
199       whitelistedTransfer[_tgeAddress] = true;
200       transfer(_tgeAddress, balances[owner]);
201     }
202 
203 
204     /**
205       @dev Allows the owner to add addresse that can burn tokens
206       Eg: ICO contract, TGE contract.
207       @param _address address Address to be added
208     **/
209     function addWhitelistedBurn(address _address)
210       public
211       onlyOwner
212     {
213       whitelistedBurn[_address] = true;
214     }
215 
216     /**
217         PUBLIC FUNCTIONS
218     **/
219 
220     /**
221     * @dev transfer token for a specified address
222     * @param _to The address to transfer to.
223     * @param _value The amount to be transferred.
224     */
225     function transfer(address _to, uint256 _value)
226       public
227       onlyWhenTransferable
228       returns (bool success)
229     {
230       require(_to != address(0));
231       require(_value <= balances[msg.sender]);
232 
233       balances[msg.sender] = balances[msg.sender].sub(_value);
234       balances[_to] = balances[_to].add(_value);
235       Transfer(msg.sender, _to, _value);
236       return true;
237     }
238 
239     /**
240    * @dev Transfer tokens from one address to another
241    * @param _from address The address which you want to send tokens from
242    * @param _to address The address which you want to transfer to
243    * @param _value uint256 the amount of tokens to be transferred
244    */
245     function transferFrom
246       (address _from,
247         address _to,
248         uint256 _value)
249         public
250         onlyWhenTransferable
251         returns (bool success) {
252       require(_to != address(0));
253       require(_value <= balances[_from]);
254       require(_value <= allowed[_from][msg.sender]);
255 
256       balances[_from] = balances[_from].sub(_value);
257       balances[_to] = balances[_to].add(_value);
258       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
259       Transfer(_from, _to, _value);
260       return true;
261     }
262 
263     /**
264    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
265     For security reasons, if one need to change the value from a existing allowance, it must furst sets
266     it to zero and then sets the new value
267 
268    * @param _spender The address which will spend the funds.
269    * @param _value The amount of tokens to be spent.
270    */
271     function approve(address _spender, uint256 _value)
272       public
273       onlyWhenTransferable
274       returns (bool success)
275     {
276       allowed[msg.sender][_spender] = _value;
277       Approval(msg.sender, _spender, _value);
278       return true;
279     }
280 
281       /**
282      * @dev Increase the amount of tokens that an owner allowed to a spender.
283      *
284      * approve should be called when allowed[_spender] == 0. To increment
285      * allowed value is better to use this function to avoid 2 calls (and wait until
286      * the first transaction is mined)
287      * From MonolithDAO Token.sol
288      * @param _spender The address which will spend the funds.
289      * @param _addedValue The amount of tokens to increase the allowance by.
290      */
291     function increaseApproval(address _spender, uint _addedValue)
292       public
293       returns (bool)
294     {
295       allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
296       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
297       return true;
298     }
299 
300     /**
301      * @dev Decrease the amount of tokens that an owner allowed to a spender.
302      *
303      * approve should be called when allowed[_spender] == 0. To decrement
304      * allowed value is better to use this function to avoid 2 calls (and wait until
305      * the first transaction is mined)
306      * From MonolithDAO Token.sol
307      * @param _spender The address which will spend the funds.
308      * @param _subtractedValue The amount of tokens to decrease the allowance by.
309      */
310     function decreaseApproval(address _spender, uint _subtractedValue)
311       public
312       returns (bool)
313     {
314       uint oldValue = allowed[msg.sender][_spender];
315       if (_subtractedValue > oldValue) {
316         allowed[msg.sender][_spender] = 0;
317       } else {
318         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
319       }
320       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
321       return true;
322     }
323 
324     /**
325       @dev Allows for msg.sender to burn his on tokens
326       @param _amount uint256 The amount of tokens to be burned
327     **/
328     function burn(uint256 _amount)
329       public
330       returns (bool success)
331     {
332       require(whitelistedBurn[msg.sender]);
333       require(_amount <= balances[msg.sender]);
334       balances[msg.sender] = balances[msg.sender].sub(_amount);
335       totalSupply =  totalSupply.sub(_amount);
336       Burn(msg.sender, _amount);
337       return true;
338     }
339 
340 
341     /**
342         CONSTANT FUNCTIONS
343     **/
344 
345     /**
346     * @dev Gets the balance of the specified address.
347     * @param _owner The address to query the the balance of.
348     * @return An uint256 representing the amount owned by the passed address.
349     */
350     function balanceOf(address _owner) view public returns (uint256 balance) {
351         return balances[_owner];
352     }
353 
354     /**
355    * @dev Function to check the amount of tokens that an owner allowed to a spender.
356    * @param _owner address The address which owns the funds.
357    * @param _spender address The address which will spend the funds.
358    * @return A uint256 specifying the amount of tokens still available for the spender.
359    */
360     function allowance(address _owner, address _spender)
361       view
362       public
363       returns (uint256 remaining)
364     {
365       return allowed[_owner][_spender];
366     }
367 
368 }
369 
370 
371 
372 contract TaylorTokenTGE is Ownable {
373   using SafeMath for uint256;
374 
375   uint256 constant internal DECIMAL_CASES = 10**18;
376   TaylorToken public token;
377 
378   uint256 constant public FOUNDERS = 10**6 * DECIMAL_CASES;
379   uint256 constant public ADVISORS = 4 * 10**5 * DECIMAL_CASES;
380   uint256 constant public TEAM = 3 * 10**5 * DECIMAL_CASES;
381   uint256 constant public REFERRAL_PROGRAMS = 7 * 10**5 * DECIMAL_CASES;
382   uint256 constant public PRESALE = 1190476 * DECIMAL_CASES;
383   uint256 constant public PUBLICSALE = 6409524 * DECIMAL_CASES;
384 
385   address public founders_address;
386   address public advisors_address;
387   address public team_address;
388   address public referral_address;
389   address public presale_address;
390   address public publicsale_address;
391 
392   /**
393     @dev Sets up alll the addresses needed for the token distribution
394     @param _token address The address of the token that will be distributed
395     @param _founders addresses The address that the founders share will be sent to
396     @param _advisors addresses The address that the advisors share will be sent to
397     @param _team addresses The address that the team share will be sent to
398     @param _referral addresses The address that the referral share will be sent to
399     @param _presale addresses The address that presale share will be sent to
400     @param _publicSale addresses The address that the public sale
401   **/
402   function setUp(address _token, address _founders, address _advisors, address _team, address _referral, address _presale, address _publicSale) public onlyOwner{
403     token = TaylorToken(_token);
404     founders_address = _founders;
405     advisors_address = _advisors;
406     team_address = _team;
407     referral_address = _referral;
408     presale_address = _presale;
409     publicsale_address = _publicSale;
410   }
411 
412   /**
413     @dev Distributes all the tokens belonging to this contract to it's defined destinationss
414   **/
415   function distribute() public onlyOwner {
416     uint256 total = FOUNDERS.add(ADVISORS).add(TEAM).add(REFERRAL_PROGRAMS).add(PRESALE).add(PUBLICSALE);
417     require(total >= token.balanceOf(this));
418     token.transfer(founders_address, FOUNDERS);
419     token.transfer(advisors_address, ADVISORS);
420     token.transfer(team_address, TEAM);
421     token.transfer(referral_address, REFERRAL_PROGRAMS);
422     token.transfer(presale_address, PRESALE);
423     token.transfer(publicsale_address, PUBLICSALE);
424   }
425 
426 }