1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     if (a == 0) {
15       return 0;
16     }
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/179
54  */
55 contract ERC20Basic {
56   function totalSupply() public view returns (uint256);
57   function balanceOf(address who) public view returns (uint256);
58   function transfer(address to, uint256 value) public returns (bool);
59   event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 
63 /**
64  * @title Basic token
65  * @dev Basic version of StandardToken, with no allowances.
66  */
67 contract BasicToken is ERC20Basic {
68   using SafeMath for uint256;
69 
70   mapping(address => uint256) balances;
71 
72   uint256 totalSupply_;
73 
74   /**
75   * @dev total number of tokens in existence
76   */
77   function totalSupply() public view returns (uint256) {
78     return totalSupply_;
79   }
80 
81   /**
82   * @dev transfer token for a specified address
83   * @param _to The address to transfer to.
84   * @param _value The amount to be transferred.
85   */
86   function transfer(address _to, uint256 _value) public returns (bool) {
87     require(_to != address(0));
88     require(_value <= balances[msg.sender]);
89 
90     balances[msg.sender] = balances[msg.sender].sub(_value);
91     balances[_to] = balances[_to].add(_value);
92     emit Transfer(msg.sender, _to, _value);
93     return true;
94   }
95 
96   /**
97   * @dev Gets the balance of the specified address.
98   * @param _owner The address to query the the balance of.
99   * @return An uint256 representing the amount owned by the passed address.
100   */
101   function balanceOf(address _owner) public view returns (uint256) {
102     return balances[_owner];
103   }
104 
105 }
106 
107 /**
108  * @title ERC20 interface
109  * @dev see https://github.com/ethereum/EIPs/issues/20
110  */
111 contract ERC20 is ERC20Basic {
112   function allowance(address owner, address spender)
113     public view returns (uint256);
114 
115   function transferFrom(address from, address to, uint256 value)
116     public returns (bool);
117 
118   function approve(address spender, uint256 value) public returns (bool);
119   event Approval(
120     address indexed owner,
121     address indexed spender,
122     uint256 value
123   );
124 }
125 
126 
127 /**
128  * @title Standard ERC20 token
129  *
130  * @dev Implementation of the basic standard token.
131  * @dev https://github.com/ethereum/EIPs/issues/20
132  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
133  */
134 contract StandardToken is ERC20, BasicToken {
135 
136   mapping (address => mapping (address => uint256)) internal allowed;
137 
138 
139   /**
140    * @dev Transfer tokens from one address to another
141    * @param _from address The address which you want to send tokens from
142    * @param _to address The address which you want to transfer to
143    * @param _value uint256 the amount of tokens to be transferred
144    */
145   function transferFrom(
146     address _from,
147     address _to,
148     uint256 _value
149   )
150     public
151     returns (bool)
152   {
153     require(_to != address(0));
154     require(_value <= balances[_from]);
155     require(_value <= allowed[_from][msg.sender]);
156 
157     balances[_from] = balances[_from].sub(_value);
158     balances[_to] = balances[_to].add(_value);
159     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
160     emit Transfer(_from, _to, _value);
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
176     emit Approval(msg.sender, _spender, _value);
177     return true;
178   }
179 
180   /**
181    * @dev Function to check the amount of tokens that an owner allowed to a spender.
182    * @param _owner address The address which owns the funds.
183    * @param _spender address The address which will spend the funds.
184    * @return A uint256 specifying the amount of tokens still available for the spender.
185    */
186   function allowance(
187     address _owner,
188     address _spender
189    )
190     public
191     view
192     returns (uint256)
193   {
194     return allowed[_owner][_spender];
195   }
196 
197   /**
198    * @dev Increase the amount of tokens that an owner allowed to a spender.
199    *
200    * approve should be called when allowed[_spender] == 0. To increment
201    * allowed value is better to use this function to avoid 2 calls (and wait until
202    * the first transaction is mined)
203    * From MonolithDAO Token.sol
204    * @param _spender The address which will spend the funds.
205    * @param _addedValue The amount of tokens to increase the allowance by.
206    */
207   function increaseApproval(
208     address _spender,
209     uint _addedValue
210   )
211     public
212     returns (bool)
213   {
214     allowed[msg.sender][_spender] = (
215       allowed[msg.sender][_spender].add(_addedValue));
216     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
217     return true;
218   }
219 
220   /**
221    * @dev Decrease the amount of tokens that an owner allowed to a spender.
222    *
223    * approve should be called when allowed[_spender] == 0. To decrement
224    * allowed value is better to use this function to avoid 2 calls (and wait until
225    * the first transaction is mined)
226    * From MonolithDAO Token.sol
227    * @param _spender The address which will spend the funds.
228    * @param _subtractedValue The amount of tokens to decrease the allowance by.
229    */
230   function decreaseApproval(
231     address _spender,
232     uint _subtractedValue
233   )
234     public
235     returns (bool)
236   {
237     uint oldValue = allowed[msg.sender][_spender];
238     if (_subtractedValue > oldValue) {
239       allowed[msg.sender][_spender] = 0;
240     } else {
241       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
242     }
243     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
244     return true;
245   }
246 
247 }
248 
249 
250 /**
251  * @title ERC827 interface, an extension of ERC20 token standard
252  *
253  * @dev Interface of a ERC827 token, following the ERC20 standard with extra
254  * @dev methods to transfer value and data and execute calls in transfers and
255  * @dev approvals.
256  */
257 contract ERC827 is ERC20 {
258   function approveAndCall(
259     address _spender,
260     uint256 _value,
261     bytes _data
262   )
263     public
264     payable
265     returns (bool);
266 
267   function transferAndCall(
268     address _to,
269     uint256 _value,
270     bytes _data
271   )
272     public
273     payable
274     returns (bool);
275 
276   function transferFromAndCall(
277     address _from,
278     address _to,
279     uint256 _value,
280     bytes _data
281   )
282     public
283     payable
284     returns (bool);
285 }
286 
287 
288 /**
289  * @title ERC827, an extension of ERC20 token standard
290  *
291  * @dev Implementation the ERC827, following the ERC20 standard with extra
292  * @dev methods to transfer value and data and execute calls in transfers and
293  * @dev approvals.
294  *
295  * @dev Uses OpenZeppelin StandardToken.
296  */
297 contract TourCash is ERC827, StandardToken {
298     // Public variables of the token
299     string public name;
300     string public symbol;
301     uint8 public decimals = 18;
302     // 18 decimals is the strongly suggested default, avoid changing it
303     
304     function TourCash(
305         uint256 initialSupply,
306         string tokenName,
307         string tokenSymbol
308     ) public {
309         totalSupply_ = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
310         balances[msg.sender] = totalSupply_;                // Give the creator all initial tokens
311         name = tokenName;                                   // Set the name for display purposes
312         symbol = tokenSymbol;                               // Set the symbol for display purposes
313     }
314 
315   /**
316    * @dev Addition to ERC20 token methods. It allows to
317    * @dev approve the transfer of value and execute a call with the sent data.
318    *
319    * @dev Beware that changing an allowance with this method brings the risk that
320    * @dev someone may use both the old and the new allowance by unfortunate
321    * @dev transaction ordering. One possible solution to mitigate this race condition
322    * @dev is to first reduce the spender's allowance to 0 and set the desired value
323    * @dev afterwards:
324    * @dev https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
325    *
326    * @param _spender The address that will spend the funds.
327    * @param _value The amount of tokens to be spent.
328    * @param _data ABI-encoded contract call to call `_to` address.
329    *
330    * @return true if the call function was executed successfully
331    */
332   function approveAndCall(
333     address _spender,
334     uint256 _value,
335     bytes _data
336   )
337     public
338     payable
339     returns (bool)
340   {
341     require(_spender != address(this));
342 
343     super.approve(_spender, _value);
344 
345     // solium-disable-next-line security/no-call-value
346     //require(_spender.call.value(msg.value)(_data));
347 
348     return true;
349   }
350 
351   /**
352    * @dev Addition to ERC20 token methods. Transfer tokens to a specified
353    * @dev address and execute a call with the sent data on the same transaction
354    *
355    * @param _to address The address which you want to transfer to
356    * @param _value uint256 the amout of tokens to be transfered
357    * @param _data ABI-encoded contract call to call `_to` address.
358    *
359    * @return true if the call function was executed successfully
360    */
361   function transferAndCall(
362     address _to,
363     uint256 _value,
364     bytes _data
365   )
366     public
367     payable
368     returns (bool)
369   {
370     require(_to != address(this));
371 
372     super.transfer(_to, _value);
373 
374     // solium-disable-next-line security/no-call-value
375     //require(_to.call.value(msg.value)(_data));
376     return true;
377   }
378 
379   /**
380    * @dev Addition to ERC20 token methods. Transfer tokens from one address to
381    * @dev another and make a contract call on the same transaction
382    *
383    * @param _from The address which you want to send tokens from
384    * @param _to The address which you want to transfer to
385    * @param _value The amout of tokens to be transferred
386    * @param _data ABI-encoded contract call to call `_to` address.
387    *
388    * @return true if the call function was executed successfully
389    */
390   function transferFromAndCall(
391     address _from,
392     address _to,
393     uint256 _value,
394     bytes _data
395   )
396     public payable returns (bool)
397   {
398     require(_to != address(this));
399 
400     super.transferFrom(_from, _to, _value);
401 
402     // solium-disable-next-line security/no-call-value
403     //require(_to.call.value(msg.value)(_data));
404     return true;
405   }
406 
407   /**
408    * @dev Addition to StandardToken methods. Increase the amount of tokens that
409    * @dev an owner allowed to a spender and execute a call with the sent data.
410    *
411    * @dev approve should be called when allowed[_spender] == 0. To increment
412    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
413    * @dev the first transaction is mined)
414    * @dev From MonolithDAO Token.sol
415    *
416    * @param _spender The address which will spend the funds.
417    * @param _addedValue The amount of tokens to increase the allowance by.
418    * @param _data ABI-encoded contract call to call `_spender` address.
419    */
420   function increaseApprovalAndCall(
421     address _spender,
422     uint _addedValue,
423     bytes _data
424   )
425     public
426     payable
427     returns (bool)
428   {
429     require(_spender != address(this));
430 
431     super.increaseApproval(_spender, _addedValue);
432 
433     // solium-disable-next-line security/no-call-value
434     //require(_spender.call.value(msg.value)(_data));
435 
436     return true;
437   }
438 
439   /**
440    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
441    * @dev an owner allowed to a spender and execute a call with the sent data.
442    *
443    * @dev approve should be called when allowed[_spender] == 0. To decrement
444    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
445    * @dev the first transaction is mined)
446    * @dev From MonolithDAO Token.sol
447    *
448    * @param _spender The address which will spend the funds.
449    * @param _subtractedValue The amount of tokens to decrease the allowance by.
450    * @param _data ABI-encoded contract call to call `_spender` address.
451    */
452   function decreaseApprovalAndCall(
453     address _spender,
454     uint _subtractedValue,
455     bytes _data
456   )
457     public
458     payable
459     returns (bool)
460   {
461     require(_spender != address(this));
462 
463     super.decreaseApproval(_spender, _subtractedValue);
464 
465     // solium-disable-next-line security/no-call-value
466     //require(_spender.call.value(msg.value)(_data));
467 
468     return true;
469   }
470 
471 }