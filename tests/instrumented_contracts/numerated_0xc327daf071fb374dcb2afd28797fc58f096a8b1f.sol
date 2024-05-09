1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (a == 0) {
13       return 0;
14     }
15 
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract ERC20Basic {
50   function totalSupply() public view returns (uint256);
51   function balanceOf(address who) public view returns (uint256);
52   function transfer(address to, uint256 value) public returns (bool);
53   event Transfer(address indexed from, address indexed to, uint256 value);
54 }
55 
56 contract BasicToken is ERC20Basic {
57   using SafeMath for uint256;
58 
59   mapping(address => uint256) balances;
60 
61   uint256 totalSupply_;
62 
63   /**
64   * @dev total number of tokens in existence
65   */
66   function totalSupply() public view returns (uint256) {
67     return totalSupply_;
68   }
69 
70   /**
71   * @dev transfer token for a specified address
72   * @param _to The address to transfer to.
73   * @param _value The amount to be transferred.
74   */
75   function transfer(address _to, uint256 _value) public returns (bool) {
76     require(_to != address(0));
77     require(_value <= balances[msg.sender]);
78 
79     balances[msg.sender] = balances[msg.sender].sub(_value);
80     balances[_to] = balances[_to].add(_value);
81     emit Transfer(msg.sender, _to, _value);
82     return true;
83   }
84 
85   /**
86   * @dev Gets the balance of the specified address.
87   * @param _owner The address to query the the balance of.
88   * @return An uint256 representing the amount owned by the passed address.
89   */
90   function balanceOf(address _owner) public view returns (uint256) {
91     return balances[_owner];
92   }
93 
94 }
95 
96 contract ERC20 is ERC20Basic {
97   function allowance(address owner, address spender)
98     public view returns (uint256);
99 
100   function transferFrom(address from, address to, uint256 value)
101     public returns (bool);
102 
103   function approve(address spender, uint256 value) public returns (bool);
104   event Approval(
105     address indexed owner,
106     address indexed spender,
107     uint256 value
108   );
109 }
110 
111 contract StandardToken is ERC20, BasicToken {
112 
113   mapping (address => mapping (address => uint256)) internal allowed;
114 
115 
116   /**
117    * @dev Transfer tokens from one address to another
118    * @param _from address The address which you want to send tokens from
119    * @param _to address The address which you want to transfer to
120    * @param _value uint256 the amount of tokens to be transferred
121    */
122   function transferFrom(
123     address _from,
124     address _to,
125     uint256 _value
126   )
127     public
128     returns (bool)
129   {
130     require(_to != address(0));
131     require(_value <= balances[_from]);
132     require(_value <= allowed[_from][msg.sender]);
133 
134     balances[_from] = balances[_from].sub(_value);
135     balances[_to] = balances[_to].add(_value);
136     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
137     emit Transfer(_from, _to, _value);
138     return true;
139   }
140 
141   /**
142    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
143    *
144    * Beware that changing an allowance with this method brings the risk that someone may use both the old
145    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
146    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
147    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
148    * @param _spender The address which will spend the funds.
149    * @param _value The amount of tokens to be spent.
150    */
151   function approve(address _spender, uint256 _value) public returns (bool) {
152     allowed[msg.sender][_spender] = _value;
153     emit Approval(msg.sender, _spender, _value);
154     return true;
155   }
156 
157   /**
158    * @dev Function to check the amount of tokens that an owner allowed to a spender.
159    * @param _owner address The address which owns the funds.
160    * @param _spender address The address which will spend the funds.
161    * @return A uint256 specifying the amount of tokens still available for the spender.
162    */
163   function allowance(
164     address _owner,
165     address _spender
166    )
167     public
168     view
169     returns (uint256)
170   {
171     return allowed[_owner][_spender];
172   }
173 
174   /**
175    * @dev Increase the amount of tokens that an owner allowed to a spender.
176    *
177    * approve should be called when allowed[_spender] == 0. To increment
178    * allowed value is better to use this function to avoid 2 calls (and wait until
179    * the first transaction is mined)
180    * From MonolithDAO Token.sol
181    * @param _spender The address which will spend the funds.
182    * @param _addedValue The amount of tokens to increase the allowance by.
183    */
184   function increaseApproval(
185     address _spender,
186     uint _addedValue
187   )
188     public
189     returns (bool)
190   {
191     allowed[msg.sender][_spender] = (
192       allowed[msg.sender][_spender].add(_addedValue));
193     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
194     return true;
195   }
196 
197   /**
198    * @dev Decrease the amount of tokens that an owner allowed to a spender.
199    *
200    * approve should be called when allowed[_spender] == 0. To decrement
201    * allowed value is better to use this function to avoid 2 calls (and wait until
202    * the first transaction is mined)
203    * From MonolithDAO Token.sol
204    * @param _spender The address which will spend the funds.
205    * @param _subtractedValue The amount of tokens to decrease the allowance by.
206    */
207   function decreaseApproval(
208     address _spender,
209     uint _subtractedValue
210   )
211     public
212     returns (bool)
213   {
214     uint oldValue = allowed[msg.sender][_spender];
215     if (_subtractedValue > oldValue) {
216       allowed[msg.sender][_spender] = 0;
217     } else {
218       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
219     }
220     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
221     return true;
222   }
223 
224 }
225 
226 contract ERC827 is ERC20 {
227   function approveAndCall(
228     address _spender,
229     uint256 _value,
230     bytes _data
231   )
232     public
233     payable
234     returns (bool);
235 
236   function transferAndCall(
237     address _to,
238     uint256 _value,
239     bytes _data
240   )
241     public
242     payable
243     returns (bool);
244 
245   function transferFromAndCall(
246     address _from,
247     address _to,
248     uint256 _value,
249     bytes _data
250   )
251     public
252     payable
253     returns (bool);
254 }
255 
256 contract ERC827Token is ERC827, StandardToken {
257 
258   /**
259    * @dev Addition to ERC20 token methods. It allows to
260    * @dev approve the transfer of value and execute a call with the sent data.
261    *
262    * @dev Beware that changing an allowance with this method brings the risk that
263    * @dev someone may use both the old and the new allowance by unfortunate
264    * @dev transaction ordering. One possible solution to mitigate this race condition
265    * @dev is to first reduce the spender's allowance to 0 and set the desired value
266    * @dev afterwards:
267    * @dev https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
268    *
269    * @param _spender The address that will spend the funds.
270    * @param _value The amount of tokens to be spent.
271    * @param _data ABI-encoded contract call to call `_to` address.
272    *
273    * @return true if the call function was executed successfully
274    */
275   function approveAndCall(
276     address _spender,
277     uint256 _value,
278     bytes _data
279   )
280     public
281     payable
282     returns (bool)
283   {
284     require(_spender != address(this));
285 
286     super.approve(_spender, _value);
287 
288     // solium-disable-next-line security/no-call-value
289     require(_spender.call.value(msg.value)(_data));
290 
291     return true;
292   }
293 
294   /**
295    * @dev Addition to ERC20 token methods. Transfer tokens to a specified
296    * @dev address and execute a call with the sent data on the same transaction
297    *
298    * @param _to address The address which you want to transfer to
299    * @param _value uint256 the amout of tokens to be transfered
300    * @param _data ABI-encoded contract call to call `_to` address.
301    *
302    * @return true if the call function was executed successfully
303    */
304   function transferAndCall(
305     address _to,
306     uint256 _value,
307     bytes _data
308   )
309     public
310     payable
311     returns (bool)
312   {
313     require(_to != address(this));
314 
315     super.transfer(_to, _value);
316 
317     // solium-disable-next-line security/no-call-value
318     require(_to.call.value(msg.value)(_data));
319     return true;
320   }
321 
322   /**
323    * @dev Addition to ERC20 token methods. Transfer tokens from one address to
324    * @dev another and make a contract call on the same transaction
325    *
326    * @param _from The address which you want to send tokens from
327    * @param _to The address which you want to transfer to
328    * @param _value The amout of tokens to be transferred
329    * @param _data ABI-encoded contract call to call `_to` address.
330    *
331    * @return true if the call function was executed successfully
332    */
333   function transferFromAndCall(
334     address _from,
335     address _to,
336     uint256 _value,
337     bytes _data
338   )
339     public payable returns (bool)
340   {
341     require(_to != address(this));
342 
343     super.transferFrom(_from, _to, _value);
344 
345     // solium-disable-next-line security/no-call-value
346     require(_to.call.value(msg.value)(_data));
347     return true;
348   }
349 
350   /**
351    * @dev Addition to StandardToken methods. Increase the amount of tokens that
352    * @dev an owner allowed to a spender and execute a call with the sent data.
353    *
354    * @dev approve should be called when allowed[_spender] == 0. To increment
355    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
356    * @dev the first transaction is mined)
357    * @dev From MonolithDAO Token.sol
358    *
359    * @param _spender The address which will spend the funds.
360    * @param _addedValue The amount of tokens to increase the allowance by.
361    * @param _data ABI-encoded contract call to call `_spender` address.
362    */
363   function increaseApprovalAndCall(
364     address _spender,
365     uint _addedValue,
366     bytes _data
367   )
368     public
369     payable
370     returns (bool)
371   {
372     require(_spender != address(this));
373 
374     super.increaseApproval(_spender, _addedValue);
375 
376     // solium-disable-next-line security/no-call-value
377     require(_spender.call.value(msg.value)(_data));
378 
379     return true;
380   }
381 
382   /**
383    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
384    * @dev an owner allowed to a spender and execute a call with the sent data.
385    *
386    * @dev approve should be called when allowed[_spender] == 0. To decrement
387    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
388    * @dev the first transaction is mined)
389    * @dev From MonolithDAO Token.sol
390    *
391    * @param _spender The address which will spend the funds.
392    * @param _subtractedValue The amount of tokens to decrease the allowance by.
393    * @param _data ABI-encoded contract call to call `_spender` address.
394    */
395   function decreaseApprovalAndCall(
396     address _spender,
397     uint _subtractedValue,
398     bytes _data
399   )
400     public
401     payable
402     returns (bool)
403   {
404     require(_spender != address(this));
405 
406     super.decreaseApproval(_spender, _subtractedValue);
407 
408     // solium-disable-next-line security/no-call-value
409     require(_spender.call.value(msg.value)(_data));
410 
411     return true;
412   }
413 
414 }
415 
416 contract AromaToken is ERC827Token {
417    using SafeMath for uint256;
418 
419    string public name = "Aroma Token";
420    string public symbol = "ART";
421    uint public decimals = 18;
422 
423    address public wallet = 0x0;
424    
425    constructor (address _wallet) public  {
426        wallet = _wallet;
427        totalSupply_ = 21 * 100000000 * 10 ** decimals;
428        balances[wallet] = totalSupply_;
429     }
430 
431     /**
432     * Do not allow direct deposits.
433     */
434     function() public{
435         revert();
436     }
437 
438 
439 }