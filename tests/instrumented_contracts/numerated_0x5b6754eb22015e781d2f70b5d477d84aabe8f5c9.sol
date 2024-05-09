1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 
37 }
38 
39 
40 /**
41  * @title Ownable
42  * @dev The Ownable contract has an owner address, and provides basic authorization control
43  * functions, this simplifies the implementation of "user permissions".
44  */
45 contract Ownable {
46 
47   address public owner;
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51   /**
52    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
53    * account.
54    */
55   function Ownable() public {
56     owner = msg.sender;
57   }
58 
59   /**
60    * @dev Throws if called by any account other than the owner.
61    */
62   modifier onlyOwner() {
63     require(msg.sender == owner);
64     _;
65   }
66 
67   /**
68    * @dev Allows the current owner to transfer control of the contract to a newOwner.
69    * @param newOwner The address to transfer ownership to.
70    */
71   function transferOwnership(address newOwner) public onlyOwner {
72     require(newOwner != address(0));
73     OwnershipTransferred(owner, newOwner);
74     owner = newOwner;
75   }
76 
77 }
78 
79 
80 /**
81  * @title ERC20Basic
82  * @dev Simpler version of ERC20 interface
83  * @dev see https://github.com/ethereum/EIPs/issues/179
84  */
85 contract ERC20Basic {
86 
87   uint256 public totalSupply;
88   function balanceOf(address who) public view returns (uint256);
89   function transfer(address to, uint256 value) public returns (bool);
90   event Transfer(address indexed from, address indexed to, uint256 value);
91 
92 }
93 
94 
95 /**
96  * @title ERC20 interface
97  * @dev see https://github.com/ethereum/EIPs/issues/20
98  */
99 contract ERC20 is ERC20Basic {
100 
101   function allowance(address owner, address spender) public view returns (uint256);
102   function transferFrom(address from, address to, uint256 value) public returns (bool);
103   function approve(address spender, uint256 value) public returns (bool);
104   event Approval(address indexed owner, address indexed spender, uint256 value);
105 
106 }
107 
108 
109 /**
110  * @title Basic token
111  * @dev Basic version of StandardToken, with no allowances.
112  */
113 contract BasicToken is ERC20Basic {
114 
115   using SafeMath for uint256;
116 
117   mapping(address => uint256) balances;
118 
119   /**
120   * @dev transfer token for a specified address
121   * @param _to The address to transfer to.
122   * @param _value The amount to be transferred.
123   */
124   function transfer(address _to, uint256 _value) public returns (bool) {
125     require(_to != address(0));
126     require(_value <= balances[msg.sender]);
127 
128     // SafeMath.sub will throw if there is not enough balance.
129     balances[msg.sender] = balances[msg.sender].sub(_value);
130     balances[_to] = balances[_to].add(_value);
131     Transfer(msg.sender, _to, _value);
132     return true;
133   }
134 
135   /**
136   * @dev Gets the balance of the specified address.
137   * @param _owner The address to query the the balance of.
138   * @return An uint256 representing the amount owned by the passed address.
139   */
140   function balanceOf(address _owner) public view returns (uint256 balance) {
141     return balances[_owner];
142   }
143 
144 }
145 
146 
147 /**
148  * @title Standard ERC20 token
149  *
150  * @dev Implementation of the basic standard token.
151  * @dev https://github.com/ethereum/EIPs/issues/20
152  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
153  */
154 contract StandardToken is ERC20, BasicToken {
155 
156   mapping (address => mapping (address => uint256)) internal allowed;
157 
158   /**
159    * @dev Transfer tokens from one address to another
160    * @param _from address The address which you want to send tokens from
161    * @param _to address The address which you want to transfer to
162    * @param _value uint256 the amount of tokens to be transferred
163    */
164   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
165     require(_to != address(0));
166     require(_value <= balances[_from]);
167     require(_value <= allowed[_from][msg.sender]);
168 
169     balances[_from] = balances[_from].sub(_value);
170     balances[_to] = balances[_to].add(_value);
171     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
172     Transfer(_from, _to, _value);
173     return true;
174   }
175 
176   /**
177    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
178    *
179    * Beware that changing an allowance with this method brings the risk that someone may use both the old
180    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
181    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
182    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
183    * @param _spender The address which will spend the funds.
184    * @param _value The amount of tokens to be spent.
185    */
186   function approve(address _spender, uint256 _value) public returns (bool) {
187     allowed[msg.sender][_spender] = _value;
188     Approval(msg.sender, _spender, _value);
189     return true;
190   }
191 
192   /**
193    * @dev Function to check the amount of tokens that an owner allowed to a spender.
194    * @param _owner address The address which owns the funds.
195    * @param _spender address The address which will spend the funds.
196    * @return A uint256 specifying the amount of tokens still available for the spender.
197    */
198   function allowance(address _owner, address _spender) public view returns (uint256) {
199     return allowed[_owner][_spender];
200   }
201 
202   /**
203    * approve should be called when allowed[_spender] == 0. To increment
204    * allowed value is better to use this function to avoid 2 calls (and wait until
205    * the first transaction is mined)
206    * From MonolithDAO Token.sol
207    */
208   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
209     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
210     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
211     return true;
212   }
213 
214   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
215     uint oldValue = allowed[msg.sender][_spender];
216     if (_subtractedValue > oldValue) {
217       allowed[msg.sender][_spender] = 0;
218     } else {
219       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
220     }
221     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222     return true;
223   }
224 
225 }
226 
227 
228 contract Releasable is Ownable {
229 
230   event Release();
231 
232   bool public released = false;
233 
234   modifier afterReleased() {
235     require(released);
236     _;
237   }
238 
239   function release() onlyOwner public {
240     require(!released);
241     released = true;
242     Release();
243   }
244 
245 }
246 
247 
248 contract Managed is Releasable {
249 
250   mapping (address => bool) public manager;
251   event SetManager(address _addr);
252   event UnsetManager(address _addr);
253 
254   function Managed() public {
255     manager[msg.sender] = true;
256   }
257 
258   modifier onlyManager() {
259     require(manager[msg.sender]);
260     _;
261   }
262 
263   function setManager(address _addr) public onlyOwner {
264     require(_addr != address(0) && manager[_addr] == false);
265     manager[_addr] = true;
266 
267     SetManager(_addr);
268   }
269 
270   function unsetManager(address _addr) public onlyOwner {
271     require(_addr != address(0) && manager[_addr] == true);
272     manager[_addr] = false;
273 
274     UnsetManager(_addr);
275   }
276 
277 }
278 
279 
280 contract ReleasableToken is StandardToken, Managed {
281 
282   function transfer(address _to, uint256 _value) public afterReleased returns (bool) {
283     return super.transfer(_to, _value);
284   }
285 
286   function saleTransfer(address _to, uint256 _value) public onlyManager returns (bool) {
287     return super.transfer(_to, _value);
288   }
289 
290   function transferFrom(address _from, address _to, uint256 _value) public afterReleased returns (bool) {
291     return super.transferFrom(_from, _to, _value);
292   }
293 
294   function approve(address _spender, uint256 _value) public afterReleased returns (bool) {
295     return super.approve(_spender, _value);
296   }
297 
298   function increaseApproval(address _spender, uint _addedValue) public afterReleased returns (bool success) {
299     return super.increaseApproval(_spender, _addedValue);
300   }
301 
302   function decreaseApproval(address _spender, uint _subtractedValue) public afterReleased returns (bool success) {
303     return super.decreaseApproval(_spender, _subtractedValue);
304   }
305 
306 }
307 
308 
309 contract BurnableToken is ReleasableToken {
310 
311     event Burn(address indexed burner, uint256 value);
312 
313     /**
314      * @dev Burns a specific amount of tokens.
315      * @param _value The amount of token to be burned.
316      */
317     function burn(uint256 _value) onlyManager public {
318         require(_value > 0);
319         require(_value <= balances[msg.sender]);
320         // no need to require value <= tota0lSupply, since that would imply the
321         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
322 
323         address burner = msg.sender;
324         balances[burner] = balances[burner].sub(_value);
325         totalSupply = totalSupply.sub(_value);
326         Burn(burner, _value);
327     }
328 
329 }
330 
331 
332 /**
333   *  GANA
334   */
335 contract GANA is BurnableToken {
336 
337   string public constant name = "GANA";
338   string public constant symbol = "GANA";
339   uint8 public constant decimals = 18;
340 
341   event ClaimedTokens(address manager, address _token, uint256 claimedBalance);
342 
343   function GANA() public {
344     totalSupply = 2000000000 * 1 ether;
345     balances[msg.sender] = totalSupply;
346   }
347 
348   function claimTokens(address _token, uint256 _claimedBalance) public onlyManager afterReleased {
349     ERC20Basic token = ERC20Basic(_token);
350     uint256 tokenBalance = token.balanceOf(this);
351     require(tokenBalance >= _claimedBalance);
352 
353     address manager = msg.sender;
354     token.transfer(manager, _claimedBalance);
355     ClaimedTokens(manager, _token, _claimedBalance);
356   }
357 
358 }
359 
360 
361 /**
362   *  GANA LOCKER
363   */
364 contract GanaLocker {
365   GANA gana;
366   uint256 public releaseTime = 1554076800; //UTC 04/01/2019 12:00am
367   address public owner;
368 
369   event Unlock();
370 
371   function GanaLocker(address _gana, address _owner) public {
372     require(_owner != address(0));
373     owner = _owner;
374     gana = GANA(_gana);
375   }
376 
377   function unlock() public {
378     require(msg.sender == owner);
379     require(releaseTime < now);
380     uint256 unlockGana = gana.balanceOf(this);
381     gana.transfer(owner, unlockGana);
382     Unlock();
383   }
384 
385 }