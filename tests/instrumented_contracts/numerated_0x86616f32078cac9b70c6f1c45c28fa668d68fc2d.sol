1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) public onlyOwner {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55   uint256 public totalSupply;
56   function balanceOf(address who) public view returns (uint256);
57   function transfer(address to, uint256 value) public returns (bool);
58   event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 // File: zeppelin-solidity/contracts/token/ERC20.sol
62 
63 /**
64  * @title ERC20 interface
65  * @dev see https://github.com/ethereum/EIPs/issues/20
66  */
67 contract ERC20 is ERC20Basic {
68   function allowance(address owner, address spender) public view returns (uint256);
69   function transferFrom(address from, address to, uint256 value) public returns (bool);
70   function approve(address spender, uint256 value) public returns (bool);
71   event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 // File: contracts/base/tokens/ReleasableToken.sol
75 
76 /**
77  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
78  *
79  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
80  */
81 
82 pragma solidity ^0.4.18;
83 
84 
85 
86 
87 
88 /**
89  * Define interface for releasing the token transfer after a successful crowdsale.
90  */
91 contract ReleasableToken is ERC20, Ownable {
92 
93   /* The finalizer contract that allows unlift the transfer limits on this token */
94   address public releaseAgent;
95 
96   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
97   bool public released = false;
98 
99   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
100   mapping (address => bool) public transferAgents;
101 
102   /**
103    * Limit token transfer until the crowdsale is over.
104    *
105    */
106   modifier canTransfer(address _sender) {
107     if (!released) {
108       require(transferAgents[_sender]);
109     }
110 
111     _;
112   }
113 
114   /**
115    * Set the contract that can call release and make the token transferable.
116    *
117    * Design choice. Allow reset the release agent to fix fat finger mistakes.
118    */
119   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
120 
121     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
122     releaseAgent = addr;
123   }
124 
125   /**
126    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
127    */
128   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
129     transferAgents[addr] = state;
130   }
131 
132   /**
133    * One way function to release the tokens to the wild.
134    *
135    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
136    */
137   function releaseTokenTransfer() public onlyReleaseAgent {
138     released = true;
139   }
140 
141   /** The function can be called only before or after the tokens have been released */
142   modifier inReleaseState(bool releaseState) {
143     require(releaseState == released);
144     _;
145   }
146 
147   /** The function can be called only by a whitelisted release agent. */
148   modifier onlyReleaseAgent() {
149     require(msg.sender == releaseAgent);
150     _;
151   }
152 
153   function transfer(address _to, uint _value) public canTransfer(msg.sender) returns (bool success) {
154     // Call StandardToken.transfer()
155     return super.transfer(_to, _value);
156   }
157 
158   function transferFrom(address _from, address _to, uint _value) public canTransfer(_from) returns (bool success) {
159     // Call StandardToken.transferForm()
160     return super.transferFrom(_from, _to, _value);
161   }
162 
163 }
164 
165 // File: zeppelin-solidity/contracts/math/SafeMath.sol
166 
167 /**
168  * @title SafeMath
169  * @dev Math operations with safety checks that throw on error
170  */
171 library SafeMath {
172   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
173     if (a == 0) {
174       return 0;
175     }
176     uint256 c = a * b;
177     assert(c / a == b);
178     return c;
179   }
180 
181   function div(uint256 a, uint256 b) internal pure returns (uint256) {
182     // assert(b > 0); // Solidity automatically throws when dividing by 0
183     uint256 c = a / b;
184     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
185     return c;
186   }
187 
188   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
189     assert(b <= a);
190     return a - b;
191   }
192 
193   function add(uint256 a, uint256 b) internal pure returns (uint256) {
194     uint256 c = a + b;
195     assert(c >= a);
196     return c;
197   }
198 }
199 
200 // File: zeppelin-solidity/contracts/token/BasicToken.sol
201 
202 /**
203  * @title Basic token
204  * @dev Basic version of StandardToken, with no allowances.
205  */
206 contract BasicToken is ERC20Basic {
207   using SafeMath for uint256;
208 
209   mapping(address => uint256) balances;
210 
211   /**
212   * @dev transfer token for a specified address
213   * @param _to The address to transfer to.
214   * @param _value The amount to be transferred.
215   */
216   function transfer(address _to, uint256 _value) public returns (bool) {
217     require(_to != address(0));
218     require(_value <= balances[msg.sender]);
219 
220     // SafeMath.sub will throw if there is not enough balance.
221     balances[msg.sender] = balances[msg.sender].sub(_value);
222     balances[_to] = balances[_to].add(_value);
223     Transfer(msg.sender, _to, _value);
224     return true;
225   }
226 
227   /**
228   * @dev Gets the balance of the specified address.
229   * @param _owner The address to query the the balance of.
230   * @return An uint256 representing the amount owned by the passed address.
231   */
232   function balanceOf(address _owner) public view returns (uint256 balance) {
233     return balances[_owner];
234   }
235 
236 }
237 
238 // File: zeppelin-solidity/contracts/token/StandardToken.sol
239 
240 /**
241  * @title Standard ERC20 token
242  *
243  * @dev Implementation of the basic standard token.
244  * @dev https://github.com/ethereum/EIPs/issues/20
245  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
246  */
247 contract StandardToken is ERC20, BasicToken {
248 
249   mapping (address => mapping (address => uint256)) internal allowed;
250 
251 
252   /**
253    * @dev Transfer tokens from one address to another
254    * @param _from address The address which you want to send tokens from
255    * @param _to address The address which you want to transfer to
256    * @param _value uint256 the amount of tokens to be transferred
257    */
258   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
259     require(_to != address(0));
260     require(_value <= balances[_from]);
261     require(_value <= allowed[_from][msg.sender]);
262 
263     balances[_from] = balances[_from].sub(_value);
264     balances[_to] = balances[_to].add(_value);
265     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
266     Transfer(_from, _to, _value);
267     return true;
268   }
269 
270   /**
271    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
272    *
273    * Beware that changing an allowance with this method brings the risk that someone may use both the old
274    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
275    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
276    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
277    * @param _spender The address which will spend the funds.
278    * @param _value The amount of tokens to be spent.
279    */
280   function approve(address _spender, uint256 _value) public returns (bool) {
281     allowed[msg.sender][_spender] = _value;
282     Approval(msg.sender, _spender, _value);
283     return true;
284   }
285 
286   /**
287    * @dev Function to check the amount of tokens that an owner allowed to a spender.
288    * @param _owner address The address which owns the funds.
289    * @param _spender address The address which will spend the funds.
290    * @return A uint256 specifying the amount of tokens still available for the spender.
291    */
292   function allowance(address _owner, address _spender) public view returns (uint256) {
293     return allowed[_owner][_spender];
294   }
295 
296   /**
297    * @dev Increase the amount of tokens that an owner allowed to a spender.
298    *
299    * approve should be called when allowed[_spender] == 0. To increment
300    * allowed value is better to use this function to avoid 2 calls (and wait until
301    * the first transaction is mined)
302    * From MonolithDAO Token.sol
303    * @param _spender The address which will spend the funds.
304    * @param _addedValue The amount of tokens to increase the allowance by.
305    */
306   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
307     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
308     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
309     return true;
310   }
311 
312   /**
313    * @dev Decrease the amount of tokens that an owner allowed to a spender.
314    *
315    * approve should be called when allowed[_spender] == 0. To decrement
316    * allowed value is better to use this function to avoid 2 calls (and wait until
317    * the first transaction is mined)
318    * From MonolithDAO Token.sol
319    * @param _spender The address which will spend the funds.
320    * @param _subtractedValue The amount of tokens to decrease the allowance by.
321    */
322   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
323     uint oldValue = allowed[msg.sender][_spender];
324     if (_subtractedValue > oldValue) {
325       allowed[msg.sender][_spender] = 0;
326     } else {
327       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
328     }
329     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
330     return true;
331   }
332 
333 }
334 
335 // File: contracts/BRFToken/BRFToken.sol
336 
337 contract BRFToken is StandardToken, ReleasableToken {
338   string public constant name = "Bitrace Token";
339   string public constant symbol = "BRF";
340   uint8 public constant decimals = 18;
341 
342   function BRFToken() public {
343     totalSupply = 1000000000 * (10 ** uint256(decimals));
344     balances[msg.sender] = totalSupply;
345     setReleaseAgent(msg.sender);
346     setTransferAgent(msg.sender, true);
347   }
348 }