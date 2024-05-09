1 /**
2  * This smart contract is modified 2017 by Velix.ID to assemble code for creation of VelixIDToken with
3  * it's unique characteristics. 
4  *
5  * Licensed under the Apache License, version 2.0
6  */
7 
8 /**
9  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
10  *
11  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
12  */
13 
14 pragma solidity ^0.4.18;
15 
16 /**
17  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
18  *
19  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
20  */
21 
22 /**
23  * @title Ownable
24  * @dev The Ownable contract has an owner address, and provides basic authorization control
25  * functions, this simplifies the implementation of "user permissions".
26  */
27 contract Ownable {
28   address public owner;
29 
30 
31   /**
32    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
33    * account.
34    */
35   function Ownable() public {
36     owner = msg.sender;
37   }
38 
39 
40   /**
41    * @dev Throws if called by any account other than the owner.
42    */
43   modifier onlyOwner() {
44     require(msg.sender == owner);
45     _;
46   }
47 
48 
49   /**
50    * @dev Allows the current owner to transfer control of the contract to a newOwner.
51    * @param newOwner The address to transfer ownership to.
52    */
53   function transferOwnership(address newOwner) public onlyOwner {
54     require(newOwner != address(0));      
55     owner = newOwner;
56   }
57 
58 }
59 
60 
61 /**
62  * @title ERC20Basic
63  * @dev Simpler version of ERC20 interface
64  * @dev see https://github.com/ethereum/EIPs/issues/179
65  */
66 contract ERC20Basic {
67   uint256 public totalSupply;
68   function balanceOf(address who) public constant returns (uint256);
69   function transfer(address to, uint256 value) public returns (bool);
70   event Transfer(address indexed from, address indexed to, uint256 value);
71 }
72 
73 /**
74  * @title ERC20 interface
75  * @dev see https://github.com/ethereum/EIPs/issues/20
76  */
77 contract ERC20 is ERC20Basic {
78   function allowance(address owner, address spender) public constant returns (uint256);
79   function transferFrom(address from, address to, uint256 value) public returns (bool);
80   function approve(address spender, uint256 value) public returns (bool);
81   event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 /**
85  * @title Basic token
86  * @dev Basic version of StandardToken, with no allowances. 
87  */
88 contract BasicToken is ERC20Basic {
89   using SafeMath for uint256;
90 
91   mapping(address => uint256) balances;
92 
93   /**
94   * @dev transfer token for a specified address
95   * @param _to The address to transfer to.
96   * @param _value The amount to be transferred.
97   */
98   function transfer(address _to, uint256 _value) public returns (bool) {
99     balances[msg.sender] = balances[msg.sender].sub(_value);
100     balances[_to] = balances[_to].add(_value);
101     Transfer(msg.sender, _to, _value);
102     return true;
103   }
104 
105   /**
106   * @dev Gets the balance of the specified address.
107   * @param _owner The address to query the the balance of. 
108   * @return An uint256 representing the amount owned by the passed address.
109   */
110   function balanceOf(address _owner) public constant returns (uint256 balance) {
111     return balances[_owner];
112   }
113 
114 }
115 
116 
117 /**
118  * @title Standard ERC20 token
119  *
120  * @dev Implementation of the basic standard token.
121  * @dev https://github.com/ethereum/EIPs/issues/20
122  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
123  */
124 contract StandardToken is ERC20, BasicToken {
125 
126   mapping (address => mapping (address => uint256)) allowed;
127 
128 
129   /**
130    * @dev Transfer tokens from one address to another
131    * @param _from address The address which you want to send tokens from
132    * @param _to address The address which you want to transfer to
133    * @param _value uint256 the amout of tokens to be transfered
134    */
135   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
136     var _allowance = allowed[_from][msg.sender];
137 
138     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
139     // require (_value <= _allowance);
140 
141     balances[_to] = balances[_to].add(_value);
142     balances[_from] = balances[_from].sub(_value);
143     allowed[_from][msg.sender] = _allowance.sub(_value);
144     Transfer(_from, _to, _value);
145     return true;
146   }
147 
148   /**
149    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
150    * @param _spender The address which will spend the funds.
151    * @param _value The amount of tokens to be spent.
152    */
153   function approve(address _spender, uint256 _value) public  returns (bool) {
154 
155     // To change the approve amount you first have to reduce the addresses`
156     //  allowance to zero by calling `approve(_spender, 0)` if it is not
157     //  already 0 to mitigate the race condition described here:
158     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
160 
161     allowed[msg.sender][_spender] = _value;
162     Approval(msg.sender, _spender, _value);
163     return true;
164   }
165 
166   /**
167    * @dev Function to check the amount of tokens that an owner allowed to a spender.
168    * @param _owner address The address which owns the funds.
169    * @param _spender address The address which will spend the funds.
170    * @return A uint256 specifing the amount of tokens still available for the spender.
171    */
172   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
173     return allowed[_owner][_spender];
174   }
175 
176 }
177 
178 
179 
180 contract BurnableToken is StandardToken {
181 
182   address public constant BURN_ADDRESS = 0;
183 
184   /** How many tokens we burned */
185   event Burned(address burner, uint burnedAmount);
186 
187   /**
188    * Burn extra tokens from a balance.
189    *
190    */
191   function burn(uint burnAmount) public {
192     address burner = msg.sender;
193     balances[burner] = SafeMath.sub(balances[burner], burnAmount);
194     totalSupply = SafeMath.sub(totalSupply, burnAmount);
195     Burned(burner, burnAmount);
196   }
197 }
198 /**
199  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
200  *
201  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
202  */
203 
204 
205 
206 
207 
208 
209 
210 /**
211  * Define interface for releasing the token transfer after a successful crowdsale.
212  */
213 contract ReleasableToken is ERC20, Ownable {
214 
215   /* The finalizer contract that allows unlift the transfer limits on this token */
216   address public releaseAgent;
217 
218   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
219   bool public released = false;
220 
221   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
222   mapping (address => bool) public transferAgents;
223 
224   event CanTransferChecked(bool canTransfer, address indexed from, bool isTransferAgent, bool isReleased);
225 
226   /**
227    * Limit token transfer until the crowdsale is over.
228    *
229    */
230   modifier canTransfer(address _sender) {
231     CanTransferChecked(released || transferAgents[_sender], _sender, transferAgents[_sender], released);
232     if (released || transferAgents[_sender]) {revert();}
233     _;
234   }
235 
236   /**
237    * Set the contract that can call release and make the token transferable.
238    *
239    * Design choice. Allow reset the release agent to fix fat finger mistakes.
240    */
241   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
242 
243     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
244     releaseAgent = addr;
245   }
246 
247   /**
248    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
249    */
250   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
251     transferAgents[addr] = state;
252   }
253 
254   /**
255    * One way function to release the tokens to the wild.
256    *
257    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
258    */
259   function releaseTokenTransfer() public onlyReleaseAgent {
260     released = true;
261   }
262 
263   /** The function can be called only before or after the tokens have been releasesd */
264   modifier inReleaseState(bool releaseState) {
265     require(releaseState == released);
266     _;
267   }
268 
269   /** The function can be called only by a whitelisted release agent. */
270   modifier onlyReleaseAgent() {
271     require(msg.sender == releaseAgent);
272     _;
273   }
274 
275   function transfer(address _to, uint _value) public returns (bool success) {
276     // Call StandardToken.transfer()
277     CanTransferChecked(released || transferAgents[msg.sender], msg.sender, transferAgents[msg.sender], released);
278     if (released || transferAgents[msg.sender]) {revert();}
279    return super.transfer(_to, _value);
280   }
281 
282   function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
283     // Call StandardToken.transferForm()
284     CanTransferChecked(released || transferAgents[msg.sender], msg.sender, transferAgents[msg.sender], released);
285     if (released || transferAgents[msg.sender]) {revert();}
286     return super.transferFrom(_from, _to, _value);
287   }
288 
289 }
290 
291 
292 
293 /**
294  * @title SafeMath
295  * @dev Math operations with safety checks that throw on error
296  */
297 library SafeMath {
298   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
299     uint256 c = a * b;
300     assert(a == 0 || c / a == b);
301     return c;
302   }
303 
304   function div(uint256 a, uint256 b) internal pure returns (uint256) {
305     // assert(b > 0); // Solidity automatically throws when dividing by 0
306     uint256 c = a / b;
307     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
308     return c;
309   }
310 
311   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
312     assert(b <= a);
313     return a - b;
314   }
315 
316   function add(uint256 a, uint256 b) internal pure returns (uint256) {
317     uint256 c = a + b;
318     assert(c >= a);
319     return c;
320   }
321 }
322 
323 
324 
325 /**
326  * VelixIDToken
327  *
328  * Capped, burnable, and transfer releaseable ERC20 token 
329  * for Velix.ID
330  *
331  */
332 contract VelixIDToken is ReleasableToken, BurnableToken {
333 // contract VelixIDToken is ReleasableToken {
334 
335   using SafeMath for uint256;
336 
337   /** Name and symbol were updated. */
338   event UpdatedTokenInformation(string newName, string newSymbol);
339 
340   string public name;
341 
342   string public symbol;
343 
344   uint public decimals;
345 
346 //   mapping(address => uint256) balances;
347 
348   /**
349    * Construct the token.
350    *
351    * @param _name Token name
352    * @param _symbol Token symbol
353    * @param _initialSupply How many tokens we start with
354    * @param _decimals Number of decimal places
355    */
356   function VelixIDToken(string _name, string _symbol, uint _initialSupply, uint _decimals) public {
357     // Cannot create a token without supply
358     require(_initialSupply != 0);
359 
360     owner = msg.sender;
361 
362     name = _name;
363     symbol = _symbol;
364 
365     totalSupply = _initialSupply;
366 
367     decimals = _decimals;
368 
369     // Create initially all balance on owner
370     balances[owner] = totalSupply;
371   }
372 
373   /**
374    * To update token information at the end.
375    *
376    */
377   function setTokenInformation(string _name, string _symbol) onlyOwner public {
378     name = _name;
379     symbol = _symbol;
380 
381     UpdatedTokenInformation(name, symbol);
382   }
383 
384   function transfer(address _to, uint _value) public returns (bool success) {
385     // Call StandardToken.transfer()
386     CanTransferChecked(released || transferAgents[msg.sender], msg.sender, transferAgents[msg.sender], released);
387     if (released || transferAgents[msg.sender]) {
388       return super.transfer(_to, _value);
389     } else {
390       return false;
391     }
392   }
393 
394   function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
395     // Call StandardToken.transferForm()
396     CanTransferChecked(released || transferAgents[msg.sender], msg.sender, transferAgents[msg.sender], released);
397     if (released || transferAgents[msg.sender]) {
398       return super.transferFrom(_from, _to, _value);
399     } else {
400       return false;
401     }
402   }
403 }