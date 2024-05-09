1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() public {
35     owner = msg.sender;
36   }
37 
38 
39   /**
40    * @dev Throws if called by any account other than the owner.
41    */
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address newOwner) public onlyOwner {
53     require(newOwner != address(0));
54     OwnershipTransferred(owner, newOwner);
55     owner = newOwner;
56   }
57 
58 }
59 
60 
61 
62 
63 
64 
65 
66 
67 
68 
69 
70 
71 
72 
73 
74 
75 
76 
77 
78 /**
79  * @title SafeMath
80  * @dev Math operations with safety checks that throw on error
81  */
82 library SafeMath {
83   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
84     if (a == 0) {
85       return 0;
86     }
87     uint256 c = a * b;
88     assert(c / a == b);
89     return c;
90   }
91 
92   function div(uint256 a, uint256 b) internal pure returns (uint256) {
93     // assert(b > 0); // Solidity automatically throws when dividing by 0
94     uint256 c = a / b;
95     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
96     return c;
97   }
98 
99   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
100     assert(b <= a);
101     return a - b;
102   }
103 
104   function add(uint256 a, uint256 b) internal pure returns (uint256) {
105     uint256 c = a + b;
106     assert(c >= a);
107     return c;
108   }
109 }
110 
111 
112 
113 /**
114  * @title Basic token
115  * @dev Basic version of StandardToken, with no allowances.
116  */
117 contract BasicToken is ERC20Basic {
118   using SafeMath for uint256;
119 
120   mapping(address => uint256) balances;
121 
122   /**
123   * @dev transfer token for a specified address
124   * @param _to The address to transfer to.
125   * @param _value The amount to be transferred.
126   */
127   function transfer(address _to, uint256 _value) public returns (bool) {
128     require(_to != address(0));
129     require(_value <= balances[msg.sender]);
130 
131     // SafeMath.sub will throw if there is not enough balance.
132     balances[msg.sender] = balances[msg.sender].sub(_value);
133     balances[_to] = balances[_to].add(_value);
134     Transfer(msg.sender, _to, _value);
135     return true;
136   }
137 
138   /**
139   * @dev Gets the balance of the specified address.
140   * @param _owner The address to query the the balance of.
141   * @return An uint256 representing the amount owned by the passed address.
142   */
143   function balanceOf(address _owner) public view returns (uint256 balance) {
144     return balances[_owner];
145   }
146 
147 }
148 
149 
150 
151 
152 
153 
154 
155 /**
156  * @title ERC20 interface
157  * @dev see https://github.com/ethereum/EIPs/issues/20
158  */
159 contract ERC20 is ERC20Basic {
160   function allowance(address owner, address spender) public view returns (uint256);
161   function transferFrom(address from, address to, uint256 value) public returns (bool);
162   function approve(address spender, uint256 value) public returns (bool);
163   event Approval(address indexed owner, address indexed spender, uint256 value);
164 }
165 
166 
167 
168 /**
169  * @title Standard ERC20 token
170  *
171  * @dev Implementation of the basic standard token.
172  * @dev https://github.com/ethereum/EIPs/issues/20
173  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
174  */
175 contract StandardToken is ERC20, BasicToken {
176 
177   mapping (address => mapping (address => uint256)) internal allowed;
178 
179 
180   /**
181    * @dev Transfer tokens from one address to another
182    * @param _from address The address which you want to send tokens from
183    * @param _to address The address which you want to transfer to
184    * @param _value uint256 the amount of tokens to be transferred
185    */
186   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
187     require(_to != address(0));
188     require(_value <= balances[_from]);
189     require(_value <= allowed[_from][msg.sender]);
190 
191     balances[_from] = balances[_from].sub(_value);
192     balances[_to] = balances[_to].add(_value);
193     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
194     Transfer(_from, _to, _value);
195     return true;
196   }
197 
198   /**
199    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
200    *
201    * Beware that changing an allowance with this method brings the risk that someone may use both the old
202    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
203    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
204    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
205    * @param _spender The address which will spend the funds.
206    * @param _value The amount of tokens to be spent.
207    */
208   function approve(address _spender, uint256 _value) public returns (bool) {
209     allowed[msg.sender][_spender] = _value;
210     Approval(msg.sender, _spender, _value);
211     return true;
212   }
213 
214   /**
215    * @dev Function to check the amount of tokens that an owner allowed to a spender.
216    * @param _owner address The address which owns the funds.
217    * @param _spender address The address which will spend the funds.
218    * @return A uint256 specifying the amount of tokens still available for the spender.
219    */
220   function allowance(address _owner, address _spender) public view returns (uint256) {
221     return allowed[_owner][_spender];
222   }
223 
224   /**
225    * @dev Increase the amount of tokens that an owner allowed to a spender.
226    *
227    * approve should be called when allowed[_spender] == 0. To increment
228    * allowed value is better to use this function to avoid 2 calls (and wait until
229    * the first transaction is mined)
230    * From MonolithDAO Token.sol
231    * @param _spender The address which will spend the funds.
232    * @param _addedValue The amount of tokens to increase the allowance by.
233    */
234   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
235     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
236     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
237     return true;
238   }
239 
240   /**
241    * @dev Decrease the amount of tokens that an owner allowed to a spender.
242    *
243    * approve should be called when allowed[_spender] == 0. To decrement
244    * allowed value is better to use this function to avoid 2 calls (and wait until
245    * the first transaction is mined)
246    * From MonolithDAO Token.sol
247    * @param _spender The address which will spend the funds.
248    * @param _subtractedValue The amount of tokens to decrease the allowance by.
249    */
250   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
251     uint oldValue = allowed[msg.sender][_spender];
252     if (_subtractedValue > oldValue) {
253       allowed[msg.sender][_spender] = 0;
254     } else {
255       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
256     }
257     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
258     return true;
259   }
260 
261 }
262 
263 
264 
265 
266 
267 /**
268  * @title Mintable token
269  * @dev Simple ERC20 Token example, with mintable token creation
270  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
271  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
272  */
273 
274 contract MintableToken is StandardToken, Ownable {
275   event Mint(address indexed to, uint256 amount);
276   event MintFinished();
277 
278   bool public mintingFinished = false;
279 
280 
281   modifier canMint() {
282     require(!mintingFinished);
283     _;
284   }
285 
286   /**
287    * @dev Function to mint tokens
288    * @param _to The address that will receive the minted tokens.
289    * @param _amount The amount of tokens to mint.
290    * @return A boolean that indicates if the operation was successful.
291    */
292   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
293     totalSupply = totalSupply.add(_amount);
294     balances[_to] = balances[_to].add(_amount);
295     Mint(_to, _amount);
296     Transfer(address(0), _to, _amount);
297     return true;
298   }
299 
300   /**
301    * @dev Function to stop minting new tokens.
302    * @return True if the operation was successful.
303    */
304   function finishMinting() onlyOwner canMint public returns (bool) {
305     mintingFinished = true;
306     MintFinished();
307     return true;
308   }
309 }
310 
311 
312 /**
313  * @title Capped token
314  * @dev Mintable token with a token cap.
315  */
316 
317 contract CappedToken is MintableToken {
318 
319   uint256 public cap;
320 
321   function CappedToken(uint256 _cap) public {
322     require(_cap > 0);
323     cap = _cap;
324   }
325 
326   /**
327    * @dev Function to mint tokens
328    * @param _to The address that will receive the minted tokens.
329    * @param _amount The amount of tokens to mint.
330    * @return A boolean that indicates if the operation was successful.
331    */
332   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
333     require(totalSupply.add(_amount) <= cap);
334 
335     return super.mint(_to, _amount);
336   }
337 
338 }
339 
340 
341 contract ElementeumToken is CappedToken {
342   string public constant name = "Elementeum";
343   string public constant symbol = "ELET";
344   uint8 public constant decimals = 18;
345 
346   /**
347    * @dev Constructor that gives msg.sender all of existing tokens.
348    */
349   function ElementeumToken(uint256 _cap, address[] founderAccounts, address[] operationsAccounts) public 
350     Ownable()
351     CappedToken(_cap)
352   {
353     // Protect against divide by zero errors
354     require(founderAccounts.length > 0);
355     require(operationsAccounts.length > 0);
356 
357     // 15% Allocated for founders
358     uint256 founderAllocation = cap * 15 / 100; 
359 
360     // 15% Allocated for operations
361     uint256 operationsAllocation = cap * 15 / 100; 
362 
363     // Split the founder allocation evenly
364     uint256 allocationPerFounder = founderAllocation / founderAccounts.length;
365 
366     // Split the operations allocation evenly
367     uint256 allocationPerOperationsAccount = operationsAllocation / operationsAccounts.length;
368 
369     // Mint the allocation for each of the founders
370     for (uint i = 0; i < founderAccounts.length; ++i) {
371       mint(founderAccounts[i], allocationPerFounder);
372     }
373 
374     // Mint the allocation for each of the operations accounts
375     for (uint j = 0; j < operationsAccounts.length; ++j) {
376       mint(operationsAccounts[j], allocationPerOperationsAccount);
377     }
378   }
379 }
380 
381 
382 contract ElementeumTokenProxy is Ownable {
383 
384   ElementeumToken public token;
385 
386   function ElementeumTokenProxy(uint256 _cap, address[] _founderAccounts, address[] _operationsAccounts) public 
387     Ownable() {
388     token = new ElementeumToken(_cap, _founderAccounts, _operationsAccounts);
389   }
390 
391   function mint(address _to, uint256 _amount) public onlyOwner returns (bool) {
392     return token.mint(_to, _amount);
393   }
394 
395   function finishMinting() public onlyOwner returns (bool) {
396     return token.finishMinting();
397   }
398 
399   function totalSupply() public returns (uint256) {
400     return token.totalSupply();
401   }
402 
403   function cap() public returns (uint256) {
404     return token.cap();
405   }
406 }