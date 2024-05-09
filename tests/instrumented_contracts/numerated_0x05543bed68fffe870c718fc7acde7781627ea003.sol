1 pragma solidity ^0.4.16;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 /**
35  * @title ERC20Basic
36  * @dev Simpler version of ERC20 interface
37  * @dev see https://github.com/ethereum/EIPs/issues/179
38  */
39 contract ERC20Basic {
40   uint256 public totalSupply;
41   function balanceOf(address who) public constant returns (uint256);
42   function transfer(address to, uint256 value) public returns (bool);
43   event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 /**
47  * @title Basic token
48  * @dev Basic version of StandardToken, with no allowances.
49  */
50 contract BasicToken is ERC20Basic {
51     
52   using SafeMath for uint256;
53 
54   mapping(address => uint256) balances;
55 
56   /**
57     * @dev Fix for the ERC20 short address attack.
58     */
59     modifier onlyMsgDataSize(uint size) {
60         require(!(msg.data.length < size + 4));
61         _;
62     }
63 
64   /**
65   * @dev transfer token for a specified address
66   * @param _to The address to transfer to.
67   * @param _value The amount to be transferred.
68   */
69   function transfer(address _to, uint256 _value) public onlyMsgDataSize(2 * 32) returns (bool) {
70     require(_to != address(0));
71     require(_value > 0 && _value <= balances[msg.sender]);
72 
73     // SafeMath.sub will throw if there is not enough balance.
74     balances[msg.sender] = balances[msg.sender].sub(_value);
75     balances[_to] = balances[_to].add(_value);
76     Transfer(msg.sender, _to, _value);
77     return true;
78   }
79 
80   /**
81   * @dev Gets the balance of the specified address.
82   * @param _owner The address to query the the balance of.
83   * @return An uint256 representing the amount owned by the passed address.
84   */
85   function balanceOf(address _owner) public constant returns (uint256 balance) {
86     return balances[_owner];
87   }
88 
89 }
90 
91 /**
92  * @title ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/20
94  */
95 contract ERC20 is ERC20Basic {
96   function allowance(address owner, address spender) public constant returns (uint256);
97   function transferFrom(address from, address to, uint256 value) public returns (bool);
98   function approve(address spender, uint256 value) public returns (bool);
99   event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 
103 /**
104  * @title Standard ERC20 token
105  *
106  * @dev Implementation of the basic standard token.
107  * @dev https://github.com/ethereum/EIPs/issues/20
108  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
109  */
110 contract StandardToken is ERC20, BasicToken {
111 
112   mapping (address => mapping (address => uint256)) internal allowed;
113 
114   /**
115    * @dev Transfer tokens from one address to another
116    * @param _from address The address which you want to send tokens from
117    * @param _to address The address which you want to transfer to
118    * @param _value uint256 the amount of tokens to be transferred
119    */
120   function transferFrom(address _from, address _to, uint256 _value) public onlyMsgDataSize(2 * 32) returns (bool) {
121     require(_to != address(0));
122     require(_value > 0 && _value <= balances[_from]);
123     require(_value <= allowed[_from][msg.sender]);
124 
125     balances[_from] = balances[_from].sub(_value);
126     balances[_to] = balances[_to].add(_value);
127     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
128     Transfer(_from, _to, _value);
129     return true;
130   }
131 
132   /**
133    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
134    *
135    * Beware that changing an allowance with this method brings the risk that someone may use both the old
136    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
137    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
138    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
139    * @param _spender The address which will spend the funds.
140    * @param _value The amount of tokens to be spent.
141    */
142   function approve(address _spender, uint256 _value) public onlyMsgDataSize(2 * 32) returns (bool) {
143     allowed[msg.sender][_spender] = _value;
144     Approval(msg.sender, _spender, _value);
145     return true;
146   }
147 
148   /**
149    * @dev Function to check the amount of tokens that an owner allowed to a spender.
150    * @param _owner address The address which owns the funds.
151    * @param _spender address The address which will spend the funds.
152    * @return A uint256 specifying the amount of tokens still available for the spender.
153    */
154   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
155     return allowed[_owner][_spender];
156   }
157 
158 }
159 
160 /**
161  * @title Ownable
162  * @dev The Ownable contract has an owner address, and provides basic authorization control
163  * functions, this simplifies the implementation of "user permissions".
164  */
165 contract Ownable {
166     
167   address public owner;
168 
169 
170   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
171 
172 
173   /**
174    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
175    * account.
176    */
177   function Ownable() {
178     owner = msg.sender;
179   }
180 
181 
182   /**
183    * @dev Throws if called by any account other than the owner.
184    */
185   modifier onlyOwner() {
186     require(msg.sender == owner);
187     _;
188   }
189 
190 
191   /**
192    * @dev Allows the current owner to transfer control of the contract to a newOwner.
193    * @param newOwner The address to transfer ownership to.
194    */
195   function transferOwnership(address newOwner) onlyOwner public {
196     require(newOwner != address(0));
197     OwnershipTransferred(owner, newOwner);
198     owner = newOwner;
199   }
200 }
201 
202 /**
203  * @title Pausable
204  * @dev Base contract which allows children to implement an emergency stop mechanism.
205  */
206 contract Pausable is Ownable {
207   event Pause();
208   event Unpause();
209 
210   bool public paused = false;
211 
212 
213   /**
214    * @dev Modifier to make a function callable only when the contract is not paused.
215    */
216   modifier whenNotPaused() {
217     require(!paused);
218     _;
219   }
220 
221   /**
222    * @dev Modifier to make a function callable only when the contract is paused.
223    */
224   modifier whenPaused() {
225     require(paused);
226     _;
227   }
228 
229   /**
230    * @dev called by the owner to pause, triggers stopped state
231    */
232   function pause() onlyOwner whenNotPaused public {
233     paused = true;
234     Pause();
235   }
236 
237   /**
238    * @dev called by the owner to unpause, returns to normal state
239    */
240   function unpause() onlyOwner whenPaused public {
241     paused = false;
242     Unpause();
243   }
244 }
245 
246 /**
247  * @title Pausable token
248  *
249  * @dev StandardToken modified with pausable transfers.
250  **/
251 
252 contract PausableToken is StandardToken, Pausable {
253 
254   /** frozen the accont */
255   mapping (address => bool) public frozenAccount;
256 
257   /* This generates a public event on the blockchain that will notify clients */
258   event FrozenFunds(address _target, bool _frozen);
259 
260   // This notifies clients about the amount burnt
261   event Burn(address indexed from, uint256 value);
262 
263   // This notifies clients about the amount burnt destroyed Froze Funds.
264   event DestroyedFrozeFunds(address _frozenAddress, uint frozenFunds);
265 
266   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
267     require(!frozenAccount[_to]);
268     require(!frozenAccount[msg.sender]);
269     return super.transfer(_to, _value);
270   }
271 
272   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
273     require(!frozenAccount[_from]);
274     require(!frozenAccount[_to]);
275     return super.transferFrom(_from, _to, _value);
276   }
277 
278   function approve(address _spender, uint256 _value) public whenNotPaused onlyMsgDataSize(2 * 32) returns (bool) {
279     return super.approve(_spender, _value);
280   }
281   
282   /**
283    * batch transfer recivers to be _value
284    *
285    * @param _receivers Address to be frozen
286    * @param _value either to freeze it or not
287    */
288   function batchTransfer(address[] _receivers, uint256 _value) public whenNotPaused onlyMsgDataSize(2 * 32) returns (bool) {
289     uint cnt = _receivers.length;
290     require(cnt > 0 && cnt <= 100);
291     require(_value > 0);
292     for (uint i = 0; i < cnt; i++) {
293          if (!frozenAccount[_receivers[i]] && balances[msg.sender] >= _value ) {
294             balances[msg.sender] = balances[msg.sender].sub(_value);
295             balances[_receivers[i]] = balances[_receivers[i]].add(_value);
296             Transfer(msg.sender, _receivers[i], _value);
297          }
298     }
299     return true;
300   }
301 
302   /**
303    * @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
304    *
305    * @param _target Address to be frozen
306    * @param _freeze either to freeze it or not
307    */
308   function freezeAccount(address _target, bool _freeze) onlyOwner public {
309       frozenAccount[_target] = _freeze;
310       FrozenFunds(_target, _freeze);
311   }
312 
313   /**
314    * @notice `freeze? destroy freezed tokens
315    *
316    * @param _frozenAddress frozened address
317    */
318   function destroyFreezeFunds(address _frozenAddress) public onlyOwner {
319       require(frozenAccount[_frozenAddress]);
320       uint frozenFunds = balanceOf(_frozenAddress);
321       balances[_frozenAddress] = 0;
322       totalSupply = totalSupply.sub(frozenFunds);
323       DestroyedFrozeFunds(_frozenAddress, frozenFunds);
324   }
325 
326    /**
327      * Destroy tokens
328      *
329      * Remove `_value` tokens from the system irreversibly
330      *
331      * @param _value the amount of money to burn
332      */
333     function burn(uint256 _value) public whenNotPaused returns (bool success) {
334         require(balances[msg.sender] >= _value);   // Check if the sender has enough
335         balances[msg.sender] = balances[msg.sender].sub(_value);            // Subtract from the sender
336         totalSupply = totalSupply.sub(_value);                  // Updates totalSupply
337         Burn(msg.sender, _value);
338         return true;
339     }
340 
341     /**
342      * Destroy tokens from other account
343      *
344      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
345      *
346      * @param _from the address of the sender
347      * @param _value the amount of money to burn
348      */
349     function burnFrom(address _from, uint256 _value) public whenNotPaused returns (bool success) {
350         require(balances[_from] >= _value);                // Check if the targeted balance is enough
351         require(_value <= allowed[_from][msg.sender]);    // Check allowance
352         balances[_from] = balances[_from].sub(_value);                      // Subtract from the targeted balance
353         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);   // Subtract from the sender's allowance
354         totalSupply = totalSupply.sub(_value);                          // Update totalSupply
355         Burn(_from, _value);
356         return true;
357     }
358 }
359 
360 /**
361  * @title LGC Token
362  *
363  * @dev Implementation of LGC Token based on the basic standard token.
364  */
365 contract LGCToken is PausableToken {
366     
367     /**
368     * Public variables of the token
369     * The following variables are OPTIONAL vanities. One does not have to include them.
370     * They allow one to customise the token contract & in no way influences the core functionality.
371     * Some wallets/interfaces might not even bother to look at this information.
372     */
373     string public name = "LongCoin";
374     string public symbol = "LGC";
375     string public version = '1.0.0';
376     uint8 public decimals = 8;
377 
378     /**
379      * @dev Function to check the amount of tokens that an owner allowed to a spender.
380      */
381     function LGCToken() {
382       totalSupply = 10000000000 * (10**(uint256(decimals)));
383       balances[msg.sender] = totalSupply;    // Give the creator all initial tokens
384     }
385 
386     function () {
387         //if ether is sent to this address, send it back.
388         revert();
389     }
390 }