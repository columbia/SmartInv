1 pragma solidity ^ 0.4.16;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns(uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns(uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns(uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns(uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39   address public owner;
40 
41 
42   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44 
45   /**
46    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47    * account.
48    */
49   function Ownable() {
50     owner = msg.sender;
51   }
52 
53 
54   /**
55    * @dev Throws if called by any account other than the owner.
56    */
57   modifier onlyOwner() {
58     require(msg.sender == owner);
59     _;
60   }
61 
62 
63   /**
64    * @dev Allows the current owner to transfer control of the contract to a newOwner.
65    * @param newOwner The address to transfer ownership to.
66    */
67   function transferOwnership(address newOwner) onlyOwner public {
68     require(newOwner != address(0));
69     OwnershipTransferred(owner, newOwner);
70     owner = newOwner;
71   }
72 
73 }
74 
75 /**
76  * @title Pausable
77  * @dev Base contract which allows children to implement an emergency stop mechanism.
78  */
79 contract Pausable is Ownable {
80   event Pause();
81   event Unpause();
82 
83   bool public paused = false;
84 
85 
86   /**
87    * @dev Modifier to make a function callable only when the contract is not paused.
88    */
89   modifier whenNotPaused() {
90     require(!paused);
91     _;
92   }
93 
94   /**
95    * @dev Modifier to make a function callable only when the contract is paused.
96    */
97   modifier whenPaused() {
98     require(paused);
99     _;
100   }
101 
102   /**
103    * @dev called by the owner to pause, triggers stopped state
104    */
105   function pause() onlyOwner whenNotPaused public {
106     paused = true;
107     Pause();
108   }
109 
110   /**
111    * @dev called by the owner to unpause, returns to normal state
112    */
113   function unpause() onlyOwner whenPaused public {
114     paused = false;
115     Unpause();
116   }
117 }
118 
119 /**
120  * @title ERC20Basic
121  * @dev Simpler version of ERC20 interface
122  * @dev see https://github.com/ethereum/EIPs/issues/179
123  */
124 contract ERC20Basic {
125   uint256 public totalSupply;
126   function balanceOf(address who) public constant returns(uint256);
127   function transfer(address to, uint256 value) public returns(bool);
128   event Transfer(address indexed from, address indexed to, uint256 value);
129 }
130 
131 /**
132  * @title ERC20 interface
133  * @dev see https://github.com/ethereum/EIPs/issues/20
134  */
135 contract ERC20 is ERC20Basic {
136   function allowance(address owner, address spender) public constant returns(uint256);
137   function transferFrom(address from, address to, uint256 value) public returns(bool);
138   function approve(address spender, uint256 value) public returns(bool);
139   event Approval(address indexed owner, address indexed spender, uint256 value);
140 }
141 
142 contract Lockupable is Pausable {
143   function _unlockIfPosible(address who) internal;
144   function unlockAll() onlyOwner public returns(bool);
145   function lockupOf(address who) public constant returns(uint256[5]);
146   function distribute(address _to, uint256 _value, uint256 _amount1, uint256 _amount2, uint256 _amount3, uint256 _amount4) onlyOwner public returns(bool);
147 }
148 
149 /**
150  * @title ERC20 token
151  *
152  * @dev Implementation of the basic standard token.
153  * @dev https://github.com/ethereum/EIPs/issues/20
154  */
155 contract ERC20Token is ERC20 {
156   using SafeMath for uint256;
157 
158     mapping(address => uint256) balances;
159   mapping(address => mapping(address => uint256)) internal allowed;
160 
161   /**
162   * @dev transfer token for a specified address
163   * @param _to The address to transfer to.
164   * @param _value The amount to be transferred.
165   */
166   function transfer(address _to, uint256 _value) public returns(bool) {
167     require(_to != address(0));
168     require(_value <= balances[msg.sender]);
169 
170     // SafeMath.sub will throw if there is not enough balance.
171     balances[msg.sender] = balances[msg.sender].sub(_value);
172     balances[_to] = balances[_to].add(_value);
173     Transfer(msg.sender, _to, _value);
174     return true;
175   }
176 
177   /**
178   * @dev Gets the balance of the specified address.
179   * @param _holder The address to query the the balance of.
180   * @return An uint256 representing the amount owned by the passed address.
181   */
182   function balanceOf(address _holder) public constant returns(uint256 balance) {
183     return balances[_holder];
184   }
185 
186   /**
187    * @dev Transfer tokens from one address to another
188    * @param _from address The address which you want to send tokens from
189    * @param _to address The address which you want to transfer to
190    * @param _value uint256 the amount of tokens to be transferred
191    */
192   function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
193     require(_to != address(0));
194     require(_value <= balances[_from]);
195     require(_value <= allowed[_from][msg.sender]);
196 
197     balances[_from] = balances[_from].sub(_value);
198     balances[_to] = balances[_to].add(_value);
199     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
200     Transfer(_from, _to, _value);
201     return true;
202   }
203 
204   /**
205    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
206    *
207    * Beware that changing an allowance with this method brings the risk that someone may use both the old
208    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
209    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
210    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
211    * @param _spender The address which will spend the funds.
212    * @param _value The amount of tokens to be spent.
213    */
214   function approve(address _spender, uint256 _value) public returns(bool) {
215     allowed[msg.sender][_spender] = _value;
216     Approval(msg.sender, _spender, _value);
217     return true;
218   }
219 
220   /**
221    * @dev Function to check the amount of tokens that an owner allowed to a spender.
222    * @param _owner address The address which owns the funds.
223    * @param _spender address The address which will spend the funds.
224    * @return A uint256 specifying the amount of tokens still available for the spender.
225    */
226   function allowance(address _owner, address _spender) public constant returns(uint256 remaining) {
227     return allowed[_owner][_spender];
228   }
229 }
230 
231 /**
232  * @title Lockupable token
233  *
234  * @dev ERC20Token modified with lockupable.
235  **/
236 
237 contract LockupableToken is ERC20Token, Lockupable {
238 
239   uint64[] RELEASE = new uint64[](4);
240   mapping(address => uint256[4]) lockups;
241   mapping(uint => address) private holders;
242   uint _lockupHolders;
243   bool unlocked;
244 
245 
246   function transfer(address _to, uint256 _value) public whenNotPaused returns(bool) {
247     _unlockIfPosible(_to);
248     return super.transfer(_to, _value);
249   }
250 
251   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns(bool) {
252     _unlockIfPosible(_from);
253     return super.transferFrom(_from, _to, _value);
254   }
255 
256   function approve(address _spender, uint256 _value) public whenNotPaused returns(bool) {
257     return super.approve(_spender, _value);
258   }
259   function balanceOf(address _holder) public constant returns(uint256 balance) {
260     uint256[5] memory amount = lockupOf(_holder);
261     return amount[0];
262   }
263   /**
264     * @dev Gets the lockup of the specified address.
265     * @param who address The address to query the the balance of.
266     * @return An lockupOf representing the amount owned by the passed address.
267    */
268   function lockupOf(address who) public constant  returns(uint256[5]){
269     uint256[5] memory amount;
270     amount[0] = balances[who];
271     for (uint i = 0; i < RELEASE.length; i++) {
272       amount[i + 1] = lockups[who][i];
273       if (now >= RELEASE[i]) {
274         amount[0] = amount[0].add(lockups[who][i]);
275         amount[i + 1] = 0;
276       }
277     }
278 
279     return amount;
280   }
281   /**
282     * @dev update balance lockUpAmount
283     * @param who address The address updated the balances of.
284     */
285   function _unlockIfPosible(address who) internal{
286     if (now <= RELEASE[3] || !unlocked) {
287       uint256[5] memory amount = lockupOf(who);
288       balances[who] = amount[0];
289       for (uint i = 0; i < 4; i++) {
290         lockups[who][i] = amount[i + 1];
291       }
292     }
293   }
294   /**
295      * @dev unlock all after August 31 , 2019 GMT+9.
296      * 
297      */
298   function unlockAll() onlyOwner public returns(bool){
299     if (now > RELEASE[3]) {
300       for (uint i = 0; i < _lockupHolders; i++) {
301         balances[holders[i]] = balances[holders[i]].add(lockups[holders[i]][0]);
302         balances[holders[i]] = balances[holders[i]].add(lockups[holders[i]][1]);
303         balances[holders[i]] = balances[holders[i]].add(lockups[holders[i]][2]);
304         balances[holders[i]] = balances[holders[i]].add(lockups[holders[i]][3]);
305         lockups[holders[i]][0] = 0;
306         lockups[holders[i]][1] = 0;
307         lockups[holders[i]][2] = 0;
308         lockups[holders[i]][3] = 0;
309       }
310       unlocked = true;
311     }
312 
313     return true;
314   }
315   /**
316     * @dev Distribute tokens from owner address to another , distribute for ICO and bounty campaign
317     * @param _to address The address which you want to transfer to
318     * @param _value uint256 the amount of  Amount1-type-tokens to be transferred
319     * ...
320     * @param _amount4 uint256 the amount of Amount1-type-tokens to be transferred
321     */
322   function distribute(address _to, uint256 _value, uint256 _amount1, uint256 _amount2, uint256 _amount3, uint256 _amount4) onlyOwner public returns(bool) {
323     require(_to != address(0));
324     _unlockIfPosible(msg.sender);
325     uint256 __total = 0;
326     __total = __total.add(_amount1);
327     __total = __total.add(_amount2);
328     __total = __total.add(_amount3);
329     __total = __total.add(_amount4);
330     __total = __total.add(_value);
331     balances[msg.sender] = balances[msg.sender].sub(__total);
332     balances[_to] = balances[_to].add(_value);
333     lockups[_to][0] = lockups[_to][0].add(_amount1);
334     lockups[_to][1] = lockups[_to][1].add(_amount2);
335     lockups[_to][2] = lockups[_to][2].add(_amount3);
336     lockups[_to][3] = lockups[_to][3].add(_amount4);
337 
338     holders[_lockupHolders] = _to;
339     _lockupHolders++;
340 
341     Transfer(msg.sender, _to, __total);
342     return true;
343   }
344 
345 
346 }
347 
348 /**
349  * @title BBXC Token
350  *
351  * @dev Implementation of BBXC Token based on the ERC20Token token.
352  */
353 contract BBXCToken is LockupableToken {
354 
355   function () {
356     //if ether is sent to this address, send it back.
357     revert();
358   }
359 
360   /**
361   * Public variables of the token
362   */
363   string public constant name = 'Bluebelt Exchange Coin';
364   string public constant symbol = 'BBXC';
365   uint8 public constant decimals = 18;
366 
367 
368   /**
369    * @dev Constructor 
370    */
371   function BBXCToken() {
372     _lockupHolders = 0;
373     RELEASE[0] = 1553958000; // March 30, 2019, GMT+9
374     RELEASE[1] = 1556550000; // April 29, 2019, GMT+9.
375     RELEASE[2] = 1559228400; //	May 30, 2019, GMT+9.
376     RELEASE[3] = 1567263600; // August 31 , 2019 GMT+9.
377   
378     totalSupply = 200000000 * (uint256(10) ** decimals);
379     unlocked = false;
380     balances[msg.sender] = totalSupply;
381     Transfer(address(0x0), msg.sender, totalSupply);
382   }
383 }