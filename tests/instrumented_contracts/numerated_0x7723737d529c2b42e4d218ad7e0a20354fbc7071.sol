1 pragma solidity ^0.4.21;
2 
3 // File: /app/node/returmSolidity/node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: /app/node/returmSolidity/node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20.sol
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address owner, address spender) public view returns (uint256);
25   function transferFrom(address from, address to, uint256 value) public returns (bool);
26   function approve(address spender, uint256 value) public returns (bool);
27   event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 // File: /app/node/returmSolidity/node_modules/zeppelin-solidity/contracts/token/ERC827/ERC827.sol
31 
32 /**
33  * @title ERC827 interface, an extension of ERC20 token standard
34  *
35  * @dev Interface of a ERC827 token, following the ERC20 standard with extra
36  * @dev methods to transfer value and data and execute calls in transfers and
37  * @dev approvals.
38  */
39 contract ERC827 is ERC20 {
40   function approveAndCall( address _spender, uint256 _value, bytes _data) public payable returns (bool);
41   function transferAndCall( address _to, uint256 _value, bytes _data) public payable returns (bool);
42   function transferFromAndCall(
43     address _from,
44     address _to,
45     uint256 _value,
46     bytes _data
47   )
48     public
49     payable
50     returns (bool);
51 }
52 
53 // File: /app/node/returmSolidity/node_modules/zeppelin-solidity/contracts/math/SafeMath.sol
54 
55 /**
56  * @title SafeMath
57  * @dev Math operations with safety checks that throw on error
58  */
59 library SafeMath {
60 
61   /**
62   * @dev Multiplies two numbers, throws on overflow.
63   */
64   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
65     if (a == 0) {
66       return 0;
67     }
68     c = a * b;
69     assert(c / a == b);
70     return c;
71   }
72 
73   /**
74   * @dev Integer division of two numbers, truncating the quotient.
75   */
76   function div(uint256 a, uint256 b) internal pure returns (uint256) {
77     // assert(b > 0); // Solidity automatically throws when dividing by 0
78     // uint256 c = a / b;
79     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
80     return a / b;
81   }
82 
83   /**
84   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
85   */
86   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
87     assert(b <= a);
88     return a - b;
89   }
90 
91   /**
92   * @dev Adds two numbers, throws on overflow.
93   */
94   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
95     c = a + b;
96     assert(c >= a);
97     return c;
98   }
99 }
100 
101 // File: /app/node/returmSolidity/node_modules/zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
102 
103 /**
104  * @title Basic token
105  * @dev Basic version of StandardToken, with no allowances.
106  */
107 contract BasicToken is ERC20Basic {
108   using SafeMath for uint256;
109 
110   mapping(address => uint256) balances;
111 
112   uint256 totalSupply_;
113 
114   /**
115   * @dev total number of tokens in existence
116   */
117   function totalSupply() public view returns (uint256) {
118     return totalSupply_;
119   }
120 
121   /**
122   * @dev transfer token for a specified address
123   * @param _to The address to transfer to.
124   * @param _value The amount to be transferred.
125   */
126   function transfer(address _to, uint256 _value) public returns (bool) {
127     require(_to != address(0));
128     require(_value <= balances[msg.sender]);
129 
130     balances[msg.sender] = balances[msg.sender].sub(_value);
131     balances[_to] = balances[_to].add(_value);
132     emit Transfer(msg.sender, _to, _value);
133     return true;
134   }
135 
136   /**
137   * @dev Gets the balance of the specified address.
138   * @param _owner The address to query the the balance of.
139   * @return An uint256 representing the amount owned by the passed address.
140   */
141   function balanceOf(address _owner) public view returns (uint256) {
142     return balances[_owner];
143   }
144 
145 }
146 
147 // File: /app/node/returmSolidity/node_modules/zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
148 
149 /**
150  * @title Standard ERC20 token
151  *
152  * @dev Implementation of the basic standard token.
153  * @dev https://github.com/ethereum/EIPs/issues/20
154  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
155  */
156 contract StandardToken is ERC20, BasicToken {
157 
158   mapping (address => mapping (address => uint256)) internal allowed;
159 
160 
161   /**
162    * @dev Transfer tokens from one address to another
163    * @param _from address The address which you want to send tokens from
164    * @param _to address The address which you want to transfer to
165    * @param _value uint256 the amount of tokens to be transferred
166    */
167   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
168     require(_to != address(0));
169     require(_value <= balances[_from]);
170     require(_value <= allowed[_from][msg.sender]);
171 
172     balances[_from] = balances[_from].sub(_value);
173     balances[_to] = balances[_to].add(_value);
174     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
175     emit Transfer(_from, _to, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
181    *
182    * Beware that changing an allowance with this method brings the risk that someone may use both the old
183    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
184    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
185    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
186    * @param _spender The address which will spend the funds.
187    * @param _value The amount of tokens to be spent.
188    */
189   function approve(address _spender, uint256 _value) public returns (bool) {
190     allowed[msg.sender][_spender] = _value;
191     emit Approval(msg.sender, _spender, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Function to check the amount of tokens that an owner allowed to a spender.
197    * @param _owner address The address which owns the funds.
198    * @param _spender address The address which will spend the funds.
199    * @return A uint256 specifying the amount of tokens still available for the spender.
200    */
201   function allowance(address _owner, address _spender) public view returns (uint256) {
202     return allowed[_owner][_spender];
203   }
204 
205   /**
206    * @dev Increase the amount of tokens that an owner allowed to a spender.
207    *
208    * approve should be called when allowed[_spender] == 0. To increment
209    * allowed value is better to use this function to avoid 2 calls (and wait until
210    * the first transaction is mined)
211    * From MonolithDAO Token.sol
212    * @param _spender The address which will spend the funds.
213    * @param _addedValue The amount of tokens to increase the allowance by.
214    */
215   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
216     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
217     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221   /**
222    * @dev Decrease the amount of tokens that an owner allowed to a spender.
223    *
224    * approve should be called when allowed[_spender] == 0. To decrement
225    * allowed value is better to use this function to avoid 2 calls (and wait until
226    * the first transaction is mined)
227    * From MonolithDAO Token.sol
228    * @param _spender The address which will spend the funds.
229    * @param _subtractedValue The amount of tokens to decrease the allowance by.
230    */
231   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
232     uint oldValue = allowed[msg.sender][_spender];
233     if (_subtractedValue > oldValue) {
234       allowed[msg.sender][_spender] = 0;
235     } else {
236       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
237     }
238     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239     return true;
240   }
241 
242 }
243 
244 // File: zeppelin-solidity/contracts/token/ERC827/ERC827Token.sol
245 
246 /* solium-disable security/no-low-level-calls */
247 
248 pragma solidity ^0.4.21;
249 
250 
251 
252 
253 /**
254  * @title ERC827, an extension of ERC20 token standard
255  *
256  * @dev Implementation the ERC827, following the ERC20 standard with extra
257  * @dev methods to transfer value and data and execute calls in transfers and
258  * @dev approvals.
259  *
260  * @dev Uses OpenZeppelin StandardToken.
261  */
262 contract ERC827Token is ERC827, StandardToken {
263 
264   /**
265    * @dev Addition to ERC20 token methods. It allows to
266    * @dev approve the transfer of value and execute a call with the sent data.
267    *
268    * @dev Beware that changing an allowance with this method brings the risk that
269    * @dev someone may use both the old and the new allowance by unfortunate
270    * @dev transaction ordering. One possible solution to mitigate this race condition
271    * @dev is to first reduce the spender's allowance to 0 and set the desired value
272    * @dev afterwards:
273    * @dev https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
274    *
275    * @param _spender The address that will spend the funds.
276    * @param _value The amount of tokens to be spent.
277    * @param _data ABI-encoded contract call to call `_to` address.
278    *
279    * @return true if the call function was executed successfully
280    */
281   function approveAndCall(address _spender, uint256 _value, bytes _data) public payable returns (bool) {
282     require(_spender != address(this));
283 
284     super.approve(_spender, _value);
285 
286     // solium-disable-next-line security/no-call-value
287     require(_spender.call.value(msg.value)(_data));
288 
289     return true;
290   }
291 
292   /**
293    * @dev Addition to ERC20 token methods. Transfer tokens to a specified
294    * @dev address and execute a call with the sent data on the same transaction
295    *
296    * @param _to address The address which you want to transfer to
297    * @param _value uint256 the amout of tokens to be transfered
298    * @param _data ABI-encoded contract call to call `_to` address.
299    *
300    * @return true if the call function was executed successfully
301    */
302   function transferAndCall(address _to, uint256 _value, bytes _data) public payable returns (bool) {
303     require(_to != address(this));
304 
305     super.transfer(_to, _value);
306 
307     // solium-disable-next-line security/no-call-value
308     require(_to.call.value(msg.value)(_data));
309     return true;
310   }
311 
312   /**
313    * @dev Addition to ERC20 token methods. Transfer tokens from one address to
314    * @dev another and make a contract call on the same transaction
315    *
316    * @param _from The address which you want to send tokens from
317    * @param _to The address which you want to transfer to
318    * @param _value The amout of tokens to be transferred
319    * @param _data ABI-encoded contract call to call `_to` address.
320    *
321    * @return true if the call function was executed successfully
322    */
323   function transferFromAndCall(
324     address _from,
325     address _to,
326     uint256 _value,
327     bytes _data
328   )
329     public payable returns (bool)
330   {
331     require(_to != address(this));
332 
333     super.transferFrom(_from, _to, _value);
334 
335     // solium-disable-next-line security/no-call-value
336     require(_to.call.value(msg.value)(_data));
337     return true;
338   }
339 
340   /**
341    * @dev Addition to StandardToken methods. Increase the amount of tokens that
342    * @dev an owner allowed to a spender and execute a call with the sent data.
343    *
344    * @dev approve should be called when allowed[_spender] == 0. To increment
345    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
346    * @dev the first transaction is mined)
347    * @dev From MonolithDAO Token.sol
348    *
349    * @param _spender The address which will spend the funds.
350    * @param _addedValue The amount of tokens to increase the allowance by.
351    * @param _data ABI-encoded contract call to call `_spender` address.
352    */
353   function increaseApprovalAndCall(address _spender, uint _addedValue, bytes _data) public payable returns (bool) {
354     require(_spender != address(this));
355 
356     super.increaseApproval(_spender, _addedValue);
357 
358     // solium-disable-next-line security/no-call-value
359     require(_spender.call.value(msg.value)(_data));
360 
361     return true;
362   }
363 
364   /**
365    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
366    * @dev an owner allowed to a spender and execute a call with the sent data.
367    *
368    * @dev approve should be called when allowed[_spender] == 0. To decrement
369    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
370    * @dev the first transaction is mined)
371    * @dev From MonolithDAO Token.sol
372    *
373    * @param _spender The address which will spend the funds.
374    * @param _subtractedValue The amount of tokens to decrease the allowance by.
375    * @param _data ABI-encoded contract call to call `_spender` address.
376    */
377   function decreaseApprovalAndCall(address _spender, uint _subtractedValue, bytes _data) public payable returns (bool) {
378     require(_spender != address(this));
379 
380     super.decreaseApproval(_spender, _subtractedValue);
381 
382     // solium-disable-next-line security/no-call-value
383     require(_spender.call.value(msg.value)(_data));
384 
385     return true;
386   }
387 
388 }
389 
390 // File: contracts/ReturMTokenPublic.sol
391 
392 contract ReturMTokenPublic is ERC827Token {
393     uint public INITIAL_SUPPLY = 1000000000000000000;
394     string public name = "ReturM";
395     string public symbol = "RM";
396     uint8 public decimals = 8;
397     address owner;
398     bool public released = false;
399 
400     constructor() public {
401         totalSupply_ = INITIAL_SUPPLY * 10 ** uint(decimals);
402         // totalSupply_ = INITIAL_SUPPLY;
403         balances[msg.sender] = INITIAL_SUPPLY;
404         owner = msg.sender;
405     }
406 }
407 
408 // File: returmFlatten.sol