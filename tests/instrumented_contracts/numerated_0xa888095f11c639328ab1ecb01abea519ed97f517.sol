1 /**
2  * amon.tech. 2018.
3  */
4 
5 /**
6  * This smart contract is created 2018 by amon.tech.
7  * Licensed under the Apache License, version 2.0
8  */
9 
10  
11 contract SafeMath {
12   function safeMul(uint a, uint b) internal returns (uint) {
13     uint c = a * b;
14     assert(a == 0 || c / a == b);
15     return c;
16   }
17 
18   function safeDiv(uint a, uint b) internal returns (uint) {
19     assert(b > 0);
20     uint c = a / b;
21     assert(a == b * c + a % b);
22     return c;
23   }
24 
25   function safeSub(uint a, uint b) internal returns (uint) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function safeAdd(uint a, uint b) internal returns (uint) {
31     uint c = a + b;
32     assert(c>=a && c>=b);
33     return c;
34   }
35 
36   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
37     return a >= b ? a : b;
38   }
39 
40   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
41     return a < b ? a : b;
42   }
43 
44   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
45     return a >= b ? a : b;
46   }
47 
48   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
49     return a < b ? a : b;
50   }
51 }
52 
53 
54 /**
55  * @title ERC20Basic
56  * @dev Simpler version of ERC20 interface
57  * @dev see https://github.com/ethereum/EIPs/issues/179
58  */
59 contract ERC20Basic {
60   uint256 public totalSupply;
61   function balanceOf(address who) constant returns (uint256);
62   function transfer(address to, uint256 value) returns (bool);
63   event Transfer(address indexed from, address indexed to, uint256 value);
64 }
65 
66 /**
67  * @title ERC20 interface
68  * @dev see https://github.com/ethereum/EIPs/issues/20
69  */
70 contract ERC20 is ERC20Basic {
71   function allowance(address owner, address spender) constant returns (uint256);
72   function transferFrom(address from, address to, uint256 value) returns (bool);
73   function approve(address spender, uint256 value) returns (bool);
74   event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 
78 /**
79  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
80  */
81 contract StandardToken is ERC20, SafeMath {
82 
83   /* Token supply got increased and a new owner received these tokens */
84   event Minted(address receiver, uint amount);
85 
86   /* Actual balances of token holders */
87   mapping(address => uint) balances;
88 
89   /* approve() allowances */
90   mapping (address => mapping (address => uint)) allowed;
91 
92   /* Interface declaration */
93   function isToken() public constant returns (bool weAre) {
94     return true;
95   }
96 
97   function transfer(address _to, uint _value) returns (bool success) {
98     balances[msg.sender] = safeSub(balances[msg.sender], _value);
99     balances[_to] = safeAdd(balances[_to], _value);
100     Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
105     uint _allowance = allowed[_from][msg.sender];
106 
107     balances[_to] = safeAdd(balances[_to], _value);
108     balances[_from] = safeSub(balances[_from], _value);
109     allowed[_from][msg.sender] = safeSub(_allowance, _value);
110     Transfer(_from, _to, _value);
111     return true;
112   }
113 
114   function balanceOf(address _owner) constant returns (uint balance) {
115     return balances[_owner];
116   }
117 
118   function approve(address _spender, uint _value) returns (bool success) {
119 
120     // To change the approve amount you first have to reduce the addresses`
121     //  allowance to zero by calling `approve(_spender, 0)` if it is not
122     //  already 0 to mitigate the race condition described here:
123     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
124     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
125 
126     allowed[msg.sender][_spender] = _value;
127     Approval(msg.sender, _spender, _value);
128     return true;
129   }
130 
131   function allowance(address _owner, address _spender) constant returns (uint remaining) {
132     return allowed[_owner][_spender];
133   }
134 }
135 
136 
137 contract BurnableToken is StandardToken {
138 
139   address public constant BURN_ADDRESS = 0;
140 
141   /** How many tokens we burned */
142   event Burned(address burner, uint burnedAmount);
143 
144   /**
145    * Burn extra tokens from a balance.
146    *
147    */
148   function burn(uint burnAmount) {
149     address burner = msg.sender;
150     balances[burner] = safeSub(balances[burner], burnAmount);
151     totalSupply = safeSub(totalSupply, burnAmount);
152     Burned(burner, burnAmount);
153   }
154 }
155 
156 
157 /**
158  * @title Ownable
159  * @dev The Ownable contract has an owner address, and provides basic authorization control
160  * functions, this simplifies the implementation of "user permissions".
161  */
162 contract Ownable {
163   address public owner;
164 
165   /**
166    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
167    * account.
168    */
169   function Ownable() {
170     owner = msg.sender;
171   }
172 
173   /**
174    * @dev Throws if called by any account other than the owner.
175    */
176   modifier onlyOwner() {
177     require(msg.sender == owner);
178     _;
179   }
180 
181   /**
182    * @dev Allows the current owner to transfer control of the contract to a newOwner.
183    * @param newOwner The address to transfer ownership to.
184    */
185   function transferOwnership(address newOwner) onlyOwner {
186     require(newOwner != address(0));      
187     owner = newOwner;
188   }
189 }
190 
191 
192 /**
193  * Define interface for releasing the token transfer after a successful crowdsale.
194  */
195 contract ReleasableToken is ERC20, Ownable {
196 
197   /* The finalizer contract that allows unlift the transfer limits on this token */
198   address public releaseAgent;
199 
200   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
201   bool public released = true;
202 
203   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
204   mapping (address => bool) public transferAgents;
205 
206   /**
207    * Limit token transfer until the crowdsale is over.
208    *
209    */
210   modifier canTransfer(address _sender) {
211     require(released || transferAgents[_sender]);
212     _;
213   }
214 
215   /**
216    * Set the contract that can call release and make the token transferable.
217    *
218    * Design choice. Allow reset the release agent to fix fat finger mistakes.
219    */
220   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
221 
222     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
223     releaseAgent = addr;
224   }
225 
226   /**
227    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
228    */
229   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
230     transferAgents[addr] = state;
231   }
232 
233   /**
234    * One way function to release the tokens to the wild.
235    *
236    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
237    */
238   function releaseTokenTransfer() public onlyReleaseAgent {
239     released = true;
240   }
241 
242   /** The function can be called only before or after the tokens have been releasesd */
243   modifier inReleaseState(bool releaseState) {
244     require(releaseState == released);
245     _;
246   }
247 
248   /** The function can be called only by a whitelisted release agent. */
249   modifier onlyReleaseAgent() {
250     require(msg.sender == releaseAgent);
251     _;
252   }
253 
254   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
255     // Call StandardToken.transfer()
256    return super.transfer(_to, _value);
257   }
258 
259   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
260     // Call StandardToken.transferForm()
261     return super.transferFrom(_from, _to, _value);
262   }
263 }
264 
265 
266 
267 /**
268  * amon.tech
269  *
270  * Burnable and transfer releaseable ERC20 token 
271  *
272  */
273 contract AmonToken is ReleasableToken, BurnableToken {
274 
275   /** Name and symbol were updated. */
276   event UpdatedTokenInformation(string newName, string newSymbol);
277 
278   string public name;
279 
280   string public symbol;
281 
282   uint public decimals;
283 
284   /**
285    * Construct the token.
286    *
287    * @param _name Token name
288    * @param _symbol Token symbol
289    * @param _initialSupply How many tokens we start with
290    * @param _decimals Number of decimal places
291    */
292   function AmonToken(string _name, string _symbol, uint _initialSupply, uint _decimals) {
293     // Cannot create a token without supply
294     require(_initialSupply != 0);
295 
296     owner = msg.sender;
297 
298     name = _name;
299     symbol = _symbol;
300 
301     totalSupply = _initialSupply;
302 
303     decimals = _decimals;
304 
305     // Create initially all balance on owner
306     balances[owner] = totalSupply;
307   }
308 
309   /**
310    * To update token information at the end.
311    *
312    */
313   function setTokenInformation(string _name, string _symbol) onlyOwner {
314     name = _name;
315     symbol = _symbol;
316 
317     UpdatedTokenInformation(name, symbol);
318   }
319 }