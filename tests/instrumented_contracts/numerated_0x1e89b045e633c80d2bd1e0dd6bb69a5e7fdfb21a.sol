1 /**
2  * This smart contract is modified 2017 by 4new.co.uk to assemble code for creation of FRNCoin with
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
14 
15 /**
16  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
17  *
18  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
19  */
20 
21 
22 /**
23  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
24  *
25  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
26  */
27 
28 
29 
30 
31 
32 
33 
34 /**
35  * @title ERC20Basic
36  * @dev Simpler version of ERC20 interface
37  * @dev see https://github.com/ethereum/EIPs/issues/179
38  */
39 contract ERC20Basic {
40   uint256 public totalSupply;
41   function balanceOf(address who) constant returns (uint256);
42   function transfer(address to, uint256 value) returns (bool);
43   event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 
47 
48 /**
49  * @title ERC20 interface
50  * @dev see https://github.com/ethereum/EIPs/issues/20
51  */
52 contract ERC20 is ERC20Basic {
53   function allowance(address owner, address spender) constant returns (uint256);
54   function transferFrom(address from, address to, uint256 value) returns (bool);
55   function approve(address spender, uint256 value) returns (bool);
56   event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 // Temporarily have SafeMath here until all contracts have been migrated to SafeMathLib version from OpenZeppelin
60 
61 
62 
63 /**
64  * Math operations with safety checks
65  */
66 contract SafeMath {
67   function safeMul(uint a, uint b) internal returns (uint) {
68     uint c = a * b;
69     assert(a == 0 || c / a == b);
70     return c;
71   }
72 
73   function safeDiv(uint a, uint b) internal returns (uint) {
74     assert(b > 0);
75     uint c = a / b;
76     assert(a == b * c + a % b);
77     return c;
78   }
79 
80   function safeSub(uint a, uint b) internal returns (uint) {
81     assert(b <= a);
82     return a - b;
83   }
84 
85   function safeAdd(uint a, uint b) internal returns (uint) {
86     uint c = a + b;
87     assert(c>=a && c>=b);
88     return c;
89   }
90 
91   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
92     return a >= b ? a : b;
93   }
94 
95   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
96     return a < b ? a : b;
97   }
98 
99   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
100     return a >= b ? a : b;
101   }
102 
103   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
104     return a < b ? a : b;
105   }
106 
107 }
108 
109 
110 
111 /**
112  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
113  *
114  * Based on code by FirstBlood:
115  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
116  */
117 contract StandardToken is ERC20, SafeMath {
118 
119   /* Token supply got increased and a new owner received these tokens */
120   event Minted(address receiver, uint amount);
121 
122   /* Actual balances of token holders */
123   mapping(address => uint) balances;
124 
125   /* approve() allowances */
126   mapping (address => mapping (address => uint)) allowed;
127 
128   /* Interface declaration */
129   function isToken() public constant returns (bool weAre) {
130     return true;
131   }
132 
133   function transfer(address _to, uint _value) returns (bool success) {
134     balances[msg.sender] = safeSub(balances[msg.sender], _value);
135     balances[_to] = safeAdd(balances[_to], _value);
136     Transfer(msg.sender, _to, _value);
137     return true;
138   }
139 
140   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
141     uint _allowance = allowed[_from][msg.sender];
142 
143     balances[_to] = safeAdd(balances[_to], _value);
144     balances[_from] = safeSub(balances[_from], _value);
145     allowed[_from][msg.sender] = safeSub(_allowance, _value);
146     Transfer(_from, _to, _value);
147     return true;
148   }
149 
150   function balanceOf(address _owner) constant returns (uint balance) {
151     return balances[_owner];
152   }
153 
154   function approve(address _spender, uint _value) returns (bool success) {
155 
156     // To change the approve amount you first have to reduce the addresses`
157     //  allowance to zero by calling `approve(_spender, 0)` if it is not
158     //  already 0 to mitigate the race condition described here:
159     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
160     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
161 
162     allowed[msg.sender][_spender] = _value;
163     Approval(msg.sender, _spender, _value);
164     return true;
165   }
166 
167   function allowance(address _owner, address _spender) constant returns (uint remaining) {
168     return allowed[_owner][_spender];
169   }
170 
171 }
172 
173 
174 contract BurnableToken is StandardToken {
175 
176   address public constant BURN_ADDRESS = 0;
177 
178   /** How many tokens we burned */
179   event Burned(address burner, uint burnedAmount);
180 
181   /**
182    * Burn extra tokens from a balance.
183    *
184    */
185   function burn(uint burnAmount) {
186     address burner = msg.sender;
187     balances[burner] = safeSub(balances[burner], burnAmount);
188     totalSupply = safeSub(totalSupply, burnAmount);
189     Burned(burner, burnAmount);
190   }
191 }
192 
193 /**
194  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
195  *
196  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
197  */
198 
199 
200 
201 
202 /**
203  * @title Ownable
204  * @dev The Ownable contract has an owner address, and provides basic authorization control
205  * functions, this simplifies the implementation of "user permissions".
206  */
207 contract Ownable {
208   address public owner;
209 
210 
211   /**
212    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
213    * account.
214    */
215   function Ownable() {
216     owner = msg.sender;
217   }
218 
219 
220   /**
221    * @dev Throws if called by any account other than the owner.
222    */
223   modifier onlyOwner() {
224     require(msg.sender == owner);
225     _;
226   }
227 
228 
229   /**
230    * @dev Allows the current owner to transfer control of the contract to a newOwner.
231    * @param newOwner The address to transfer ownership to.
232    */
233   function transferOwnership(address newOwner) onlyOwner {
234     require(newOwner != address(0));      
235     owner = newOwner;
236   }
237 
238 }
239 
240 
241 
242 
243 /**
244  * Define interface for releasing the token transfer after a successful crowdsale.
245  */
246 contract ReleasableToken is ERC20, Ownable {
247 
248   /* The finalizer contract that allows unlift the transfer limits on this token */
249   address public releaseAgent;
250 
251   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
252   bool public released = false;
253 
254   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
255   mapping (address => bool) public transferAgents;
256 
257   /**
258    * Limit token transfer until the crowdsale is over.
259    *
260    */
261   modifier canTransfer(address _sender) {
262     require(released || transferAgents[_sender]);
263     _;
264   }
265 
266   /**
267    * Set the contract that can call release and make the token transferable.
268    *
269    * Design choice. Allow reset the release agent to fix fat finger mistakes.
270    */
271   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
272 
273     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
274     releaseAgent = addr;
275   }
276 
277   /**
278    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
279    */
280   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
281     transferAgents[addr] = state;
282   }
283 
284   /**
285    * One way function to release the tokens to the wild.
286    *
287    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
288    */
289   function releaseTokenTransfer() public onlyReleaseAgent {
290     released = true;
291   }
292 
293   /** The function can be called only before or after the tokens have been releasesd */
294   modifier inReleaseState(bool releaseState) {
295     require(releaseState == released);
296     _;
297   }
298 
299   /** The function can be called only by a whitelisted release agent. */
300   modifier onlyReleaseAgent() {
301     require(msg.sender == releaseAgent);
302     _;
303   }
304 
305   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
306     // Call StandardToken.transfer()
307    return super.transfer(_to, _value);
308   }
309 
310   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
311     // Call StandardToken.transferForm()
312     return super.transferFrom(_from, _to, _value);
313   }
314 
315 }
316 
317 
318 
319 /**
320  * FRNCoin
321  *
322  * Capped, burnable, and transfer releaseable ERC20 token 
323  * for 4new.co.uk
324  *
325  */
326 contract FRNCoin is ReleasableToken, BurnableToken {
327 
328   /** Name and symbol were updated. */
329   event UpdatedTokenInformation(string newName, string newSymbol);
330 
331   string public name;
332 
333   string public symbol;
334 
335   uint public decimals;
336 
337   /**
338    * Construct the token.
339    *
340    * @param _name Token name
341    * @param _symbol Token symbol
342    * @param _initialSupply How many tokens we start with
343    * @param _decimals Number of decimal places
344    */
345   function FRNCoin(string _name, string _symbol, uint _initialSupply, uint _decimals) {
346     // Cannot create a token without supply
347     require(_initialSupply != 0);
348 
349     owner = msg.sender;
350 
351     name = _name;
352     symbol = _symbol;
353 
354     totalSupply = _initialSupply;
355 
356     decimals = _decimals;
357 
358     // Create initially all balance on owner
359     balances[owner] = totalSupply;
360   }
361 
362   /**
363    * To update token information at the end.
364    *
365    */
366   function setTokenInformation(string _name, string _symbol) onlyOwner {
367     name = _name;
368     symbol = _symbol;
369 
370     UpdatedTokenInformation(name, symbol);
371   }
372 }