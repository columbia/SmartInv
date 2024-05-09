1 /**
2  * This smart contract is modified 2017 by 4new.co.uk to assemble code for creation of 4NEW Token with
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
22 
23 
24 
25 
26 
27 /**
28  * @title ERC20Basic
29  * @dev Simpler version of ERC20 interface
30  * @dev see https://github.com/ethereum/EIPs/issues/179
31  */
32 contract ERC20Basic {
33   uint256 public totalSupply;
34   function balanceOf(address who) constant returns (uint256);
35   function transfer(address to, uint256 value) returns (bool);
36   event Transfer(address indexed from, address indexed to, uint256 value);
37 }
38 
39 
40 
41 /**
42  * @title ERC20 interface
43  * @dev see https://github.com/ethereum/EIPs/issues/20
44  */
45 contract ERC20 is ERC20Basic {
46   function allowance(address owner, address spender) constant returns (uint256);
47   function transferFrom(address from, address to, uint256 value) returns (bool);
48   function approve(address spender, uint256 value) returns (bool);
49   event Approval(address indexed owner, address indexed spender, uint256 value);
50 }
51 
52 // Temporarily have SafeMath here until all contracts have been migrated to SafeMathLib version from OpenZeppelin
53 
54 
55 
56 /**
57  * Math operations with safety checks
58  */
59 contract SafeMath {
60   function safeMul(uint a, uint b) internal returns (uint) {
61     uint c = a * b;
62     assert(a == 0 || c / a == b);
63     return c;
64   }
65 
66   function safeDiv(uint a, uint b) internal returns (uint) {
67     assert(b > 0);
68     uint c = a / b;
69     assert(a == b * c + a % b);
70     return c;
71   }
72 
73   function safeSub(uint a, uint b) internal returns (uint) {
74     assert(b <= a);
75     return a - b;
76   }
77 
78   function safeAdd(uint a, uint b) internal returns (uint) {
79     uint c = a + b;
80     assert(c>=a && c>=b);
81     return c;
82   }
83 
84   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
85     return a >= b ? a : b;
86   }
87 
88   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
89     return a < b ? a : b;
90   }
91 
92   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
93     return a >= b ? a : b;
94   }
95 
96   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
97     return a < b ? a : b;
98   }
99 
100 }
101 
102 
103 
104 /**
105  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
106  *
107  * Based on code by FirstBlood:
108  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
109  */
110 contract StandardToken is ERC20, SafeMath {
111 
112   /* Token supply got increased and a new owner received these tokens */
113   event Minted(address receiver, uint amount);
114 
115   /* Actual balances of token holders */
116   mapping(address => uint) balances;
117 
118   /* approve() allowances */
119   mapping (address => mapping (address => uint)) allowed;
120 
121   /* Interface declaration */
122   function isToken() public constant returns (bool weAre) {
123     return true;
124   }
125 
126   function transfer(address _to, uint _value) returns (bool success) {
127     balances[msg.sender] = safeSub(balances[msg.sender], _value);
128     balances[_to] = safeAdd(balances[_to], _value);
129     Transfer(msg.sender, _to, _value);
130     return true;
131   }
132 
133   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
134     uint _allowance = allowed[_from][msg.sender];
135 
136     balances[_to] = safeAdd(balances[_to], _value);
137     balances[_from] = safeSub(balances[_from], _value);
138     allowed[_from][msg.sender] = safeSub(_allowance, _value);
139     Transfer(_from, _to, _value);
140     return true;
141   }
142 
143   function balanceOf(address _owner) constant returns (uint balance) {
144     return balances[_owner];
145   }
146 
147   function approve(address _spender, uint _value) returns (bool success) {
148 
149     // To change the approve amount you first have to reduce the addresses`
150     //  allowance to zero by calling `approve(_spender, 0)` if it is not
151     //  already 0 to mitigate the race condition described here:
152     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
154 
155     allowed[msg.sender][_spender] = _value;
156     Approval(msg.sender, _spender, _value);
157     return true;
158   }
159 
160   function allowance(address _owner, address _spender) constant returns (uint remaining) {
161     return allowed[_owner][_spender];
162   }
163 
164 }
165 /**
166  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
167  *
168  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
169  */
170 
171 
172 
173 
174 /**
175  * @title Ownable
176  * @dev The Ownable contract has an owner address, and provides basic authorization control
177  * functions, this simplifies the implementation of "user permissions".
178  */
179 contract Ownable {
180   address public owner;
181 
182 
183   /**
184    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
185    * account.
186    */
187   function Ownable() {
188     owner = msg.sender;
189   }
190 
191 
192   /**
193    * @dev Throws if called by any account other than the owner.
194    */
195   modifier onlyOwner() {
196     require(msg.sender == owner);
197     _;
198   }
199 
200 
201   /**
202    * @dev Allows the current owner to transfer control of the contract to a newOwner.
203    * @param newOwner The address to transfer ownership to.
204    */
205   function transferOwnership(address newOwner) onlyOwner {
206     require(newOwner != address(0));      
207     owner = newOwner;
208   }
209 
210 }
211 
212 
213 
214 
215 /**
216  * Define interface for releasing the token transfer after a successful crowdsale.
217  */
218 contract ReleasableToken is ERC20, Ownable {
219 
220   /* The finalizer contract that allows unlift the transfer limits on this token */
221   address public releaseAgent;
222 
223   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
224   bool public released = false;
225 
226   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
227   mapping (address => bool) public transferAgents;
228 
229   /**
230    * Limit token transfer until the crowdsale is over.
231    *
232    */
233   modifier canTransfer(address _sender) {
234     require(released || transferAgents[_sender]);
235     _;
236   }
237 
238   /**
239    * Set the contract that can call release and make the token transferable.
240    *
241    * Design choice. Allow reset the release agent to fix fat finger mistakes.
242    */
243   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
244 
245     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
246     releaseAgent = addr;
247   }
248 
249   /**
250    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
251    */
252   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
253     transferAgents[addr] = state;
254   }
255 
256   /**
257    * One way function to release the tokens to the wild.
258    *
259    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
260    */
261   function releaseTokenTransfer() public onlyReleaseAgent {
262     released = true;
263   }
264 
265   /** The function can be called only before or after the tokens have been releasesd */
266   modifier inReleaseState(bool releaseState) {
267     require(releaseState == released);
268     _;
269   }
270 
271   /** The function can be called only by a whitelisted release agent. */
272   modifier onlyReleaseAgent() {
273     require(msg.sender == releaseAgent);
274     _;
275   }
276 
277   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
278     // Call StandardToken.transfer()
279    return super.transfer(_to, _value);
280   }
281 
282   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
283     // Call StandardToken.transferForm()
284     return super.transferFrom(_from, _to, _value);
285   }
286 
287 }
288 
289 
290 
291 /**
292  * FournewToken
293  *
294  * An ERC-20 token designed specifically for crowdsales
295  *
296  * - The token transfer() is disabled until the crowdsale is over
297  * - The token contract gives an opt-in upgrade path to a new contract
298  * - The same token can be part of several crowdsales through approve() mechanism
299  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
300  *
301  */
302 contract FournewToken is ReleasableToken, StandardToken {
303 
304   /** Name and symbol were updated. */
305   event UpdatedTokenInformation(string newName, string newSymbol);
306 
307   string public name;
308 
309   string public symbol;
310 
311   uint public decimals;
312 
313   /**
314    * Construct the token.
315    *
316    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
317    *
318    * @param _name Token name
319    * @param _symbol Token symbol - should be all caps
320    * @param _initialSupply How many tokens we start with
321    * @param _decimals Number of decimal places
322    */
323   function FournewToken(string _name, string _symbol, uint _initialSupply, uint _decimals) {
324 
325     // Cannot create a token without supply
326     require(_initialSupply != 0);
327 
328     // Create any address, can be transferred
329     // to team multisig via changeOwner(),
330     // also remember to call setUpgradeMaster()
331     owner = msg.sender;
332 
333     name = _name;
334     symbol = _symbol;
335 
336     totalSupply = _initialSupply;
337 
338     decimals = _decimals;
339 
340     // Create initially all balance on the team multisig
341     balances[owner] = totalSupply;
342   }
343 
344   /**
345    * To update token information at the end.
346    *
347    * It is often useful to conceal the actual token association, until
348    * the token operations, like central issuance or reissuance have been completed.
349    *
350    * This function allows the token owner to rename the token after the operations
351    * have been completed and then point the audience to use the token contract.
352    */
353   function setTokenInformation(string _name, string _symbol) onlyOwner {
354     name = _name;
355     symbol = _symbol;
356 
357     UpdatedTokenInformation(name, symbol);
358   }
359 }