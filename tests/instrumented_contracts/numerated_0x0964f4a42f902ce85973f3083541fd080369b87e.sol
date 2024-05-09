1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 /**
46  * @title ERC20Basic
47  * @dev Simpler version of ERC20 interface
48  * @dev see https://github.com/ethereum/EIPs/issues/179
49  */
50 contract ERC20Basic {
51   uint256 public totalSupply;
52   function balanceOf(address who) public view returns (uint256);
53   function transfer(address to, uint256 value) public returns (bool);
54   event Transfer(address indexed from, address indexed to, uint256 value);
55 }
56 
57 /**
58  * @title ERC20 interface
59  * @dev see https://github.com/ethereum/EIPs/issues/20
60  */
61 contract ERC20 is ERC20Basic {
62   function allowance(address owner, address spender) public view returns (uint256);
63   function transferFrom(address from, address to, uint256 value) public returns (bool);
64   function approve(address spender, uint256 value) public returns (bool);
65   event Approval(address indexed owner, address indexed spender, uint256 value);
66 }
67 
68 /**
69  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
70  *
71  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
72  */
73 
74 pragma solidity ^0.4.8;
75 
76 
77 
78 
79 
80 /**
81  * Define interface for releasing the token transfer after a successful crowdsale.
82  */
83 contract ReleasableToken is ERC20, Ownable {
84 
85   /* The finalizer contract that allows unlift the transfer limits on this token */
86   address public releaseAgent;
87 
88   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
89   bool public released = false;
90 
91   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
92   mapping (address => bool) public transferAgents;
93 
94   /**
95    * Limit token transfer until the crowdsale is over.
96    *
97    */
98   modifier canTransfer(address _sender) {
99 
100     if(!released) {
101         if(!transferAgents[_sender]) {
102             throw;
103         }
104     }
105 
106     _;
107   }
108 
109   /**
110    * Set the contract that can call release and make the token transferable.
111    *
112    * Design choice. Allow reset the release agent to fix fat finger mistakes.
113    */
114   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
115 
116     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
117     releaseAgent = addr;
118   }
119 
120   /**
121    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
122    */
123   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
124     transferAgents[addr] = state;
125   }
126 
127   /**
128    * One way function to release the tokens to the wild.
129    *
130    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
131    */
132   function releaseTokenTransfer() public onlyReleaseAgent {
133     released = true;
134   }
135 
136   /** The function can be called only before or after the tokens have been releasesd */
137   modifier inReleaseState(bool releaseState) {
138     if(releaseState != released) {
139         throw;
140     }
141     _;
142   }
143 
144   /** The function can be called only by a whitelisted release agent. */
145   modifier onlyReleaseAgent() {
146     if(msg.sender != releaseAgent) {
147         throw;
148     }
149     _;
150   }
151 
152   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
153     // Call StandardToken.transfer()
154    return super.transfer(_to, _value);
155   }
156 
157   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
158     // Call StandardToken.transferForm()
159     return super.transferFrom(_from, _to, _value);
160   }
161 
162 }
163 
164 /**
165  * @title SafeMath
166  * @dev Math operations with safety checks that throw on error
167  */
168 library SafeMath {
169   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
170     if (a == 0) {
171       return 0;
172     }
173     uint256 c = a * b;
174     assert(c / a == b);
175     return c;
176   }
177 
178   function div(uint256 a, uint256 b) internal pure returns (uint256) {
179     // assert(b > 0); // Solidity automatically throws when dividing by 0
180     uint256 c = a / b;
181     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
182     return c;
183   }
184 
185   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
186     assert(b <= a);
187     return a - b;
188   }
189 
190   function add(uint256 a, uint256 b) internal pure returns (uint256) {
191     uint256 c = a + b;
192     assert(c >= a);
193     return c;
194   }
195 }
196 
197 /**
198  * @title Basic token
199  * @dev Basic version of StandardToken, with no allowances.
200  */
201 contract BasicToken is ERC20Basic {
202   using SafeMath for uint256;
203 
204   mapping(address => uint256) balances;
205 
206   /**
207   * @dev transfer token for a specified address
208   * @param _to The address to transfer to.
209   * @param _value The amount to be transferred.
210   */
211   function transfer(address _to, uint256 _value) public returns (bool) {
212     require(_to != address(0));
213     require(_value <= balances[msg.sender]);
214 
215     // SafeMath.sub will throw if there is not enough balance.
216     balances[msg.sender] = balances[msg.sender].sub(_value);
217     balances[_to] = balances[_to].add(_value);
218     Transfer(msg.sender, _to, _value);
219     return true;
220   }
221 
222   /**
223   * @dev Gets the balance of the specified address.
224   * @param _owner The address to query the the balance of.
225   * @return An uint256 representing the amount owned by the passed address.
226   */
227   function balanceOf(address _owner) public view returns (uint256 balance) {
228     return balances[_owner];
229   }
230 
231 }
232 
233 /**
234  * @title Burnable Token
235  * @dev Token that can be irreversibly burned (destroyed).
236  */
237 contract BurnableToken is BasicToken {
238 
239     event Burn(address indexed burner, uint256 value);
240 
241     /**
242      * @dev Burns a specific amount of tokens.
243      * @param _value The amount of token to be burned.
244      */
245     function burn(uint256 _value) public {
246         require(_value <= balances[msg.sender]);
247         // no need to require value <= totalSupply, since that would imply the
248         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
249 
250         address burner = msg.sender;
251         balances[burner] = balances[burner].sub(_value);
252         totalSupply = totalSupply.sub(_value);
253         Burn(burner, _value);
254     }
255 }
256 
257 /**
258  * @title Standard ERC20 token
259  *
260  * @dev Implementation of the basic standard token.
261  * @dev https://github.com/ethereum/EIPs/issues/20
262  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
263  */
264 contract StandardToken is ERC20, BasicToken {
265 
266   mapping (address => mapping (address => uint256)) internal allowed;
267 
268 
269   /**
270    * @dev Transfer tokens from one address to another
271    * @param _from address The address which you want to send tokens from
272    * @param _to address The address which you want to transfer to
273    * @param _value uint256 the amount of tokens to be transferred
274    */
275   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
276     require(_to != address(0));
277     require(_value <= balances[_from]);
278     require(_value <= allowed[_from][msg.sender]);
279 
280     balances[_from] = balances[_from].sub(_value);
281     balances[_to] = balances[_to].add(_value);
282     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
283     Transfer(_from, _to, _value);
284     return true;
285   }
286 
287   /**
288    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
289    *
290    * Beware that changing an allowance with this method brings the risk that someone may use both the old
291    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
292    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
293    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
294    * @param _spender The address which will spend the funds.
295    * @param _value The amount of tokens to be spent.
296    */
297   function approve(address _spender, uint256 _value) public returns (bool) {
298     allowed[msg.sender][_spender] = _value;
299     Approval(msg.sender, _spender, _value);
300     return true;
301   }
302 
303   /**
304    * @dev Function to check the amount of tokens that an owner allowed to a spender.
305    * @param _owner address The address which owns the funds.
306    * @param _spender address The address which will spend the funds.
307    * @return A uint256 specifying the amount of tokens still available for the spender.
308    */
309   function allowance(address _owner, address _spender) public view returns (uint256) {
310     return allowed[_owner][_spender];
311   }
312 
313   /**
314    * @dev Increase the amount of tokens that an owner allowed to a spender.
315    *
316    * approve should be called when allowed[_spender] == 0. To increment
317    * allowed value is better to use this function to avoid 2 calls (and wait until
318    * the first transaction is mined)
319    * From MonolithDAO Token.sol
320    * @param _spender The address which will spend the funds.
321    * @param _addedValue The amount of tokens to increase the allowance by.
322    */
323   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
324     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
325     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
326     return true;
327   }
328 
329   /**
330    * @dev Decrease the amount of tokens that an owner allowed to a spender.
331    *
332    * approve should be called when allowed[_spender] == 0. To decrement
333    * allowed value is better to use this function to avoid 2 calls (and wait until
334    * the first transaction is mined)
335    * From MonolithDAO Token.sol
336    * @param _spender The address which will spend the funds.
337    * @param _subtractedValue The amount of tokens to decrease the allowance by.
338    */
339   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
340     uint oldValue = allowed[msg.sender][_spender];
341     if (_subtractedValue > oldValue) {
342       allowed[msg.sender][_spender] = 0;
343     } else {
344       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
345     }
346     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
347     return true;
348   }
349 
350 }
351 
352 /**
353  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
354  *
355  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
356  */
357 
358 pragma solidity ^0.4.8;
359 
360 
361 
362 
363 
364 
365 /**
366  * A crowdsaled token.
367  *
368  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
369  *
370  * - The token transfer() is disabled until the crowdsale is over
371  * - The token contract gives an opt-in upgrade path to a new contract
372  * - The same token can be part of several crowdsales through approve() mechanism
373  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
374  *
375  */
376 contract CrowdsaleToken is StandardToken, BurnableToken, ReleasableToken {
377 
378     string public name;
379 
380     string public symbol;
381 
382     uint public decimals;
383 
384     /**
385      * Construct the token.
386      *
387      * This token must be created through a team multisig wallet, so that it is owned by that wallet.
388      *
389      * @param _name Token name
390      * @param _symbol Token symbol - should be all caps
391      * @param _initialSupply How many tokens we start with
392      * @param _decimals Number of decimal places
393      */
394     function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals) public {
395 
396         // Create any address, can be transferred
397         // to team multisig via changeOwner(),
398         owner = msg.sender;
399 
400         name = _name;
401         symbol = _symbol;
402 
403         totalSupply = _initialSupply;
404 
405         decimals = _decimals;
406 
407         // Create initially all balance on the team multisig
408         balances[owner] = totalSupply;
409     }
410 
411     function burn(uint256 _value) canTransfer(msg.sender) public {
412         super.burn(_value);
413     }
414 
415 }