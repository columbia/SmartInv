1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
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
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55   address public owner;
56 
57 
58   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60 
61   /**
62    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63    * account.
64    */
65   function Ownable() public {
66     owner = msg.sender;
67   }
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77   /**
78    * @dev Allows the current owner to transfer control of the contract to a newOwner.
79    * @param newOwner The address to transfer ownership to.
80    */
81   function transferOwnership(address newOwner) public onlyOwner {
82     require(newOwner != address(0));
83     OwnershipTransferred(owner, newOwner);
84     owner = newOwner;
85   }
86 
87 }
88 
89 
90 ////////////////////////////////////
91 ////////////////////////////////////
92 ////////////////////////////////////
93 
94 
95 /**
96  * @title Pausable
97  * @dev Base contract which allows children to implement an emergency stop mechanism.
98  */
99 contract Pausable is Ownable {
100   event Pause();
101   event Unpause();
102 
103   bool public paused = false;
104 
105 
106   /**
107    * @dev Modifier to make a function callable only when the contract is not paused.
108    */
109   modifier whenNotPaused() {
110     require(!paused);
111     _;
112   }
113 
114   /**
115    * @dev Modifier to make a function callable only when the contract is paused.
116    */
117   modifier whenPaused() {
118     require(paused);
119     _;
120   }
121 
122   /**
123    * @dev called by the owner to pause, triggers stopped state
124    */
125   function pause() onlyOwner whenNotPaused public {
126     paused = true;
127     Pause();
128   }
129 
130   /**
131    * @dev called by the owner to unpause, returns to normal state
132    */
133   function unpause() onlyOwner whenPaused public {
134     paused = false;
135     Unpause();
136   }
137 }
138 
139 
140 
141 
142 
143 ////////////////////////////////////
144 ////////////////////////////////////
145 ////////////////////////////////////
146 
147 /**
148  * @title ERC20Basic
149  * @dev Simpler version of ERC20 interface
150  * @dev see https://github.com/ethereum/EIPs/issues/179
151  */
152 contract ERC20Basic {
153   function totalSupply() public view returns (uint256);
154   function balanceOf(address who) public view returns (uint256);
155   function transfer(address to, uint256 value) public returns (bool);
156   event Transfer(address indexed from, address indexed to, uint256 value);
157 }
158 
159 
160 
161 ////////////////////////////////////
162 ////////////////////////////////////
163 ////////////////////////////////////
164 
165 /**
166  * @title ERC20 interface
167  * @dev see https://github.com/ethereum/EIPs/issues/20
168  */
169 contract ERC20 is ERC20Basic {
170   function allowance(address owner, address spender) public view returns (uint256);
171   function transferFrom(address from, address to, uint256 value) public returns (bool);
172   function approve(address spender, uint256 value) public returns (bool);
173   event Approval(address indexed owner, address indexed spender, uint256 value);
174 }
175 
176 ////////////////////////////////////
177 ////////////////////////////////////
178 ////////////////////////////////////
179 
180 
181 /**
182  * @title Basic token
183  * @dev Basic version of StandardToken, with no allowances.
184  */
185 contract BasicToken is ERC20Basic {
186   using SafeMath for uint256;
187 
188   mapping(address => uint256) balances;
189 
190   uint256 totalSupply_;
191 
192   /**
193   * @dev total number of tokens in existence
194   */
195   function totalSupply() public view returns (uint256) {
196     return totalSupply_;
197   }
198 
199   /**
200   * @dev transfer token for a specified address
201   * @param _to The address to transfer to.
202   * @param _value The amount to be transferred.
203   */
204   function transfer(address _to, uint256 _value) public returns (bool) {
205     require(_to != address(0));
206     require(_value <= balances[msg.sender]);
207 
208     // SafeMath.sub will throw if there is not enough balance.
209     balances[msg.sender] = balances[msg.sender].sub(_value);
210     balances[_to] = balances[_to].add(_value);
211     Transfer(msg.sender, _to, _value);
212     return true;
213   }
214 
215   /**
216   * @dev Gets the balance of the specified address.
217   * @param _owner The address to query the the balance of.
218   * @return An uint256 representing the amount owned by the passed address.
219   */
220   function balanceOf(address _owner) public view returns (uint256 balance) {
221     return balances[_owner];
222   }
223 
224 }
225 ////////////////////////////////////
226 ////////////////////////////////////
227 ////////////////////////////////////
228 
229 /**
230  * @title Standard ERC20 token
231  *
232  * @dev Implementation of the basic standard token.
233  * @dev https://github.com/ethereum/EIPs/issues/20
234  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
235  */
236 contract StandardToken is ERC20, BasicToken {
237 
238   mapping (address => mapping (address => uint256)) internal allowed;
239 
240 
241   /**
242    * @dev Transfer tokens from one address to another
243    * @param _from address The address which you want to send tokens from
244    * @param _to address The address which you want to transfer to
245    * @param _value uint256 the amount of tokens to be transferred
246    */
247   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
248     require(_to != address(0));
249     require(_value <= balances[_from]);
250     require(_value <= allowed[_from][msg.sender]);
251 
252     balances[_from] = balances[_from].sub(_value);
253     balances[_to] = balances[_to].add(_value);
254     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
255     Transfer(_from, _to, _value);
256     return true;
257   }
258 
259   /**
260    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
261    *
262    * Beware that changing an allowance with this method brings the risk that someone may use both the old
263    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
264    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
265    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
266    * @param _spender The address which will spend the funds.
267    * @param _value The amount of tokens to be spent.
268    */
269   function approve(address _spender, uint256 _value) public returns (bool) {
270     allowed[msg.sender][_spender] = _value;
271     Approval(msg.sender, _spender, _value);
272     return true;
273   }
274 
275   /**
276    * @dev Function to check the amount of tokens that an owner allowed to a spender.
277    * @param _owner address The address which owns the funds.
278    * @param _spender address The address which will spend the funds.
279    * @return A uint256 specifying the amount of tokens still available for the spender.
280    */
281   function allowance(address _owner, address _spender) public view returns (uint256) {
282     return allowed[_owner][_spender];
283   }
284 
285   /**
286    * @dev Increase the amount of tokens that an owner allowed to a spender.
287    *
288    * approve should be called when allowed[_spender] == 0. To increment
289    * allowed value is better to use this function to avoid 2 calls (and wait until
290    * the first transaction is mined)
291    * From MonolithDAO Token.sol
292    * @param _spender The address which will spend the funds.
293    * @param _addedValue The amount of tokens to increase the allowance by.
294    */
295   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
296     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
297     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
298     return true;
299   }
300 
301   /**
302    * @dev Decrease the amount of tokens that an owner allowed to a spender.
303    *
304    * approve should be called when allowed[_spender] == 0. To decrement
305    * allowed value is better to use this function to avoid 2 calls (and wait until
306    * the first transaction is mined)
307    * From MonolithDAO Token.sol
308    * @param _spender The address which will spend the funds.
309    * @param _subtractedValue The amount of tokens to decrease the allowance by.
310    */
311   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
312     uint oldValue = allowed[msg.sender][_spender];
313     if (_subtractedValue > oldValue) {
314       allowed[msg.sender][_spender] = 0;
315     } else {
316       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
317     }
318     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
319     return true;
320   }
321 
322 }
323 
324 
325 ////////////////////////////////////
326 ////////////////////////////////////
327 ////////////////////////////////////
328 
329 
330 /// @title Redpen Token
331 /// @dev StandardToken modified with Pausable/onlyOwner transfer functionality.
332 contract RedPen is StandardToken, Pausable {
333 
334     string public constant name = "RedPen";
335     string public constant symbol = "RPN";
336     uint8 public constant decimals = 18;
337 
338     function RedPen() public {
339         totalSupply_ = 250000000 ether;
340         balances[owner] = totalSupply_;
341         pause();
342     }
343 
344     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
345         return super.transfer(to, value);
346     }
347     
348     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
349         return super.transferFrom(from, to, value);
350     }
351     
352     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
353         return super.approve(spender, value);
354     }
355     
356     function increaseApproval(address spender, uint addedValue) public whenNotPaused returns (bool) {
357         return super.increaseApproval(spender, addedValue);
358     }
359     
360     function decreaseApproval(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
361         return super.decreaseApproval(spender, subtractedValue);
362     }
363     
364     function specialTransfer(address to, uint256 value) public whenPaused onlyOwner returns (bool) {
365         return super.transfer(to, value);
366     }
367 }