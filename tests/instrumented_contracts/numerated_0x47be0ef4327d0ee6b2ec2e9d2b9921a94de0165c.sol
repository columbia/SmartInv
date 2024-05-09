1 pragma solidity ^0.4.24;
2 
3     /**
4 
5      * @title ERC20Basic
6 
7      * @dev Simpler version of ERC20 interface
8 
9      * See https://github.com/ethereum/EIPs/issues/179
10 
11      */
12 
13     contract ERC20Basic {
14 
15         function totalSupply() public view returns (uint256);
16   
17         function balanceOf(address who) public view returns (uint256);
18   
19         function transfer(address to, uint256 value) public returns (bool);
20   
21         event Transfer(address indexed from, address indexed to, uint256 value);
22   
23       }
24       /**
25   
26        * @title ERC20 interface
27   
28        * @dev see https://github.com/ethereum/EIPs/issues/20
29   
30        */
31   
32       contract ERC20 is ERC20Basic {
33   
34         function allowance(address owner, address spender)
35   
36          public view returns (uint256);
37   
38         function transferFrom(address from, address to, uint256 value)
39   
40          public returns (bool);
41   
42        function approve(address spender, uint256 value) public returns (bool);
43   
44        event Approval(address indexed owner,address indexed spender,uint256 value);
45   
46       }
47   
48   
49        /* @title SafeERC20
50   
51        * @dev Wrappers around ERC20 operations that throw on failure.
52   
53        * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
54   
55        * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
56   
57        */
58   
59       library SafeERC20 {
60   
61         function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
62   
63           require(token.transfer(to, value));
64   
65         }
66   
67   
68   
69   
70         function safeTransferFrom(
71   
72           ERC20 token,
73   
74           address from,
75   
76           address to,
77   
78           uint256 value
79   
80         )
81   
82           internal
83   
84         {
85   
86           require(token.transferFrom(from, to, value));
87   
88         }
89   
90   
91   
92   
93         function safeApprove(ERC20 token, address spender, uint256 value) internal {
94   
95           require(token.approve(spender, value));
96   
97         }
98   
99       }
100       /**
101   
102        * @title Ownable
103   
104        * @dev The Ownable contract has an owner address, and provides basic authorization control
105   
106        * functions, this simplifies the implementation of "user permissions".
107   
108        */
109   
110       contract Ownable {
111   
112         address public owner;
113   
114         event OwnershipRenounced(address indexed previousOwner);
115   
116         event OwnershipTransferred(
117   
118           address indexed previousOwner,
119   
120           address indexed newOwner
121   
122         );
123   
124         /**
125   
126          * @dev The Ownable constructor sets the original `owner` of the contract to the sender
127   
128          * account.
129   
130          */
131         constructor() public {
132   
133           owner = msg.sender;
134   
135         }
136   
137   
138         /**
139          * @dev Throws if called by any account other than the owner.
140          */
141   
142         modifier onlyOwner() {
143   
144           require(msg.sender == owner);
145   
146           _;
147   
148         }
149   
150   
151         /**
152   
153          * @dev Allows the current owner to relinquish control of the contract.
154   
155          * @notice Renouncing to ownership will leave the contract without an owner.
156   
157          * It will not be possible to call the functions with the `onlyOwner`
158   
159          * modifier anymore.
160   
161          */
162   
163         function renounceOwnership() public onlyOwner {
164   
165           emit OwnershipRenounced(owner);
166   
167           owner = address(0);
168   
169         }
170   
171         /**
172   
173          * @dev Allows the current owner to transfer control of the contract to a newOwner.
174   
175          * @param _newOwner The address to transfer ownership to.
176   
177          */
178   
179         function transferOwnership(address _newOwner) public onlyOwner {
180   
181           _transferOwnership(_newOwner);
182   
183         }
184   
185   
186   
187   
188         /**
189   
190          * @dev Transfers control of the contract to a newOwner.
191   
192          * @param _newOwner The address to transfer ownership to.
193   
194          */
195   
196         function _transferOwnership(address _newOwner) internal {
197   
198           require(_newOwner != address(0));
199   
200           emit OwnershipTransferred(owner,     _newOwner);
201   
202           owner = _newOwner;
203   
204         }
205   
206       }
207       /**
208   
209        * @title SafeMath
210   
211        * @dev Math operations with safety checks that throw on error
212   
213        */
214   
215       library SafeMath {
216   
217         /**
218   
219         * @dev Multiplies two numbers, throws on overflow.
220   
221         */
222   
223         function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
224   
225           // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
226   
227           // benefit is lost if 'b' is also tested.
228   
229           // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
230   
231           if (a == 0) {
232   
233             return 0;
234   
235           }
236           c = a * b;
237           assert(c / a == b);
238   
239           return c;
240         }
241   
242   
243         /**
244   
245         * @dev Integer division of two numbers, truncating the quotient.
246   
247         */
248   
249         function div(uint256 a, uint256 b) internal pure returns (uint256) {
250   
251           // assert(b > 0); // Solidity automatically throws when dividing by 0
252   
253           // uint256 c = a / b;
254   
255           // assert(a == b * c + a % b); // There is no case in which this doesn't hold
256   
257           return a / b;
258   
259         }
260   
261         /**
262   
263         * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
264   
265         */
266   
267         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
268   
269           assert(b <= a);
270   
271           return a - b;
272   
273         }
274   
275         /**
276   
277         * @dev Adds two numbers, throws on overflow.
278   
279         */
280   
281         function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
282   
283           c = a + b;
284   
285           assert(c >= a);
286   
287           return c;
288   
289         }
290   
291       }
292   
293 /**
294  * @title Standard ERC20 token
295  *
296  * @dev Implementation of the basic standard token.
297  * https://github.com/ethereum/EIPs/issues/20
298  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
299  */
300 contract StandardToken is ERC20 {
301   using SafeMath for uint256;
302 
303   mapping(address => uint256) balances;
304 
305   mapping (address => mapping (address => uint256)) internal allowed;
306 
307   uint256 totalSupply_;
308 
309   /**
310   * @dev Total number of tokens in existence
311   */
312   function totalSupply() public view returns (uint256) {
313     return totalSupply_;
314   }
315 
316   /**
317   * @dev Gets the balance of the specified address.
318   * @param _owner The address to query the the balance of.
319   * @return An uint256 representing the amount owned by the passed address.
320   */
321   function balanceOf(address _owner) public view returns (uint256) {
322     return balances[_owner];
323   }
324 
325   /**
326    * @dev Function to check the amount of tokens that an owner allowed to a spender.
327    * @param _owner address The address which owns the funds.
328    * @param _spender address The address which will spend the funds.
329    * @return A uint256 specifying the amount of tokens still available for the spender.
330    */
331   function allowance(
332     address _owner,
333     address _spender
334    )
335     public
336     view
337     returns (uint256)
338   {
339     return allowed[_owner][_spender];
340   }
341 
342   /**
343   * @dev Transfer token for a specified address
344   * @param _to The address to transfer to.
345   * @param _value The amount to be transferred.
346   */
347   function transfer(address _to, uint256 _value) public returns (bool) {
348     require(_value <= balances[msg.sender]);
349     require(_to != address(0));
350 
351     balances[msg.sender] = balances[msg.sender].sub(_value);
352     balances[_to] = balances[_to].add(_value);
353     emit Transfer(msg.sender, _to, _value);
354     return true;
355   }
356 
357   /**
358    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
359    * Beware that changing an allowance with this method brings the risk that someone may use both the old
360    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
361    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
362    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
363    * @param _spender The address which will spend the funds.
364    * @param _value The amount of tokens to be spent.
365    */
366   function approve(address _spender, uint256 _value) public returns (bool) {
367     allowed[msg.sender][_spender] = _value;
368     emit Approval(msg.sender, _spender, _value);
369     return true;
370   }
371 
372   /**
373    * @dev Transfer tokens from one address to another
374    * @param _from address The address which you want to send tokens from
375    * @param _to address The address which you want to transfer to
376    * @param _value uint256 the amount of tokens to be transferred
377    */
378   function transferFrom(
379     address _from,
380     address _to,
381     uint256 _value
382   )
383     public
384     returns (bool)
385   {
386     require(_value <= balances[_from]);
387     require(_value <= allowed[_from][msg.sender]);
388     require(_to != address(0));
389 
390     balances[_from] = balances[_from].sub(_value);
391     balances[_to] = balances[_to].add(_value);
392     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
393     emit Transfer(_from, _to, _value);
394     return true;
395   }
396 
397   /**
398    * @dev Increase the amount of tokens that an owner allowed to a spender.
399    * approve should be called when allowed[_spender] == 0. To increment
400    * allowed value is better to use this function to avoid 2 calls (and wait until
401    * the first transaction is mined)
402    * From MonolithDAO Token.sol
403    * @param _spender The address which will spend the funds.
404    * @param _addedValue The amount of tokens to increase the allowance by.
405    */
406   function increaseApproval(
407     address _spender,
408     uint256 _addedValue
409   )
410     public
411     returns (bool)
412   {
413     allowed[msg.sender][_spender] = (
414       allowed[msg.sender][_spender].add(_addedValue));
415     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
416     return true;
417   }
418 
419   /**
420    * @dev Decrease the amount of tokens that an owner allowed to a spender.
421    * approve should be called when allowed[_spender] == 0. To decrement
422    * allowed value is better to use this function to avoid 2 calls (and wait until
423    * the first transaction is mined)
424    * From MonolithDAO Token.sol
425    * @param _spender The address which will spend the funds.
426    * @param _subtractedValue The amount of tokens to decrease the allowance by.
427    */
428   function decreaseApproval(
429     address _spender,
430     uint256 _subtractedValue
431   )
432     public
433     returns (bool)
434   {
435     uint256 oldValue = allowed[msg.sender][_spender];
436     if (_subtractedValue >= oldValue) {
437       allowed[msg.sender][_spender] = 0;
438     } else {
439       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
440     }
441     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
442     return true;
443   }
444 
445 }
446 
447 
448 contract FexToken is StandardToken {
449     string public constant name = "FEX NEW Token";
450     string public constant symbol = "FEX";
451     uint8 public constant decimals = 18;
452     
453   
454     constructor() public {
455       totalSupply_ = 30000000000000000000000000;
456       balances[msg.sender] = totalSupply_;
457     }
458   }