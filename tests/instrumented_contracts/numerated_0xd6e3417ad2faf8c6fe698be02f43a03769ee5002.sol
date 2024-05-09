1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract ERC20Basic {
33   uint256 public totalSupply;
34   function balanceOf(address who) public view returns (uint256);
35   function transfer(address to, uint256 value) public returns (bool);
36   event Transfer(address indexed from, address indexed to, uint256 value);
37 }
38 
39 contract ERC20 is ERC20Basic {
40   function allowance(address owner, address spender) public view returns (uint256);
41   function transferFrom(address from, address to, uint256 value) public returns (bool);
42   function approve(address spender, uint256 value) public returns (bool);
43   event Approval(address indexed owner, address indexed spender, uint256 value);
44 }
45 
46 contract BasicToken is ERC20Basic {
47   using SafeMath for uint256;
48 
49   mapping(address => uint256) balances;
50 
51   /**
52   * @dev transfer token for a specified address
53   * @param _to The address to transfer to.
54   * @param _value The amount to be transferred.
55   */
56   function transfer(address _to, uint256 _value) public returns (bool) {
57     require(_to != address(0));
58     require(_value <= balances[msg.sender]);
59 
60     // SafeMath.sub will throw if there is not enough balance.
61     balances[msg.sender] = balances[msg.sender].sub(_value);
62     balances[_to] = balances[_to].add(_value);
63     Transfer(msg.sender, _to, _value);
64     return true;
65   }
66 
67   /**
68   * @dev Gets the balance of the specified address.
69   * @param _owner The address to query the the balance of.
70   * @return An uint256 representing the amount owned by the passed address.
71   */
72   function balanceOf(address _owner) public view returns (uint256 balance) {
73     return balances[_owner];
74   }
75 
76 }
77 
78 contract StandardToken is ERC20, BasicToken {
79 
80   mapping (address => mapping (address => uint256)) internal allowed;
81 
82 
83   /**
84    * @dev Transfer tokens from one address to another
85    * @param _from address The address which you want to send tokens from
86    * @param _to address The address which you want to transfer to
87    * @param _value uint256 the amount of tokens to be transferred
88    */
89   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
90     require(_to != address(0));
91     require(_value <= balances[_from]);
92     require(_value <= allowed[_from][msg.sender]);
93 
94     balances[_from] = balances[_from].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
97     Transfer(_from, _to, _value);
98     return true;
99   }
100 
101   /**
102    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
103    *
104    * Beware that changing an allowance with this method brings the risk that someone may use both the old
105    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
106    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
107    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
108    * @param _spender The address which will spend the funds.
109    * @param _value The amount of tokens to be spent.
110    */
111   function approve(address _spender, uint256 _value) public returns (bool) {
112     allowed[msg.sender][_spender] = _value;
113     Approval(msg.sender, _spender, _value);
114     return true;
115   }
116 
117   /**
118    * @dev Function to check the amount of tokens that an owner allowed to a spender.
119    * @param _owner address The address which owns the funds.
120    * @param _spender address The address which will spend the funds.
121    * @return A uint256 specifying the amount of tokens still available for the spender.
122    */
123   function allowance(address _owner, address _spender) public view returns (uint256) {
124     return allowed[_owner][_spender];
125   }
126 
127   /**
128    * @dev Increase the amount of tokens that an owner allowed to a spender.
129    *
130    * approve should be called when allowed[_spender] == 0. To increment
131    * allowed value is better to use this function to avoid 2 calls (and wait until
132    * the first transaction is mined)
133    * From MonolithDAO Token.sol
134    * @param _spender The address which will spend the funds.
135    * @param _addedValue The amount of tokens to increase the allowance by.
136    */
137   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
138     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
139     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
140     return true;
141   }
142 
143   /**
144    * @dev Decrease the amount of tokens that an owner allowed to a spender.
145    *
146    * approve should be called when allowed[_spender] == 0. To decrement
147    * allowed value is better to use this function to avoid 2 calls (and wait until
148    * the first transaction is mined)
149    * From MonolithDAO Token.sol
150    * @param _spender The address which will spend the funds.
151    * @param _subtractedValue The amount of tokens to decrease the allowance by.
152    */
153   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
154     uint oldValue = allowed[msg.sender][_spender];
155     if (_subtractedValue > oldValue) {
156       allowed[msg.sender][_spender] = 0;
157     } else {
158       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
159     }
160     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
161     return true;
162   }
163 
164 }
165 
166 contract Ownable {
167   address public owner;
168 
169 
170   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
171 
172 
173   /**
174    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
175    * account.
176    */
177   function Ownable() public {
178     owner = msg.sender;
179   }
180 
181 
182   /**
183    * @dev Throws if called by any account other than the owner.
184    */
185   modifier onlyOwner() {
186     require(msg.sender == owner);
187     _;
188   }
189 
190 
191   /**
192    * @dev Allows the current owner to transfer control of the contract to a newOwner.
193    * @param newOwner The address to transfer ownership to.
194    */
195   function transferOwnership(address newOwner) public onlyOwner {
196     require(newOwner != address(0));
197     OwnershipTransferred(owner, newOwner);
198     owner = newOwner;
199   }
200 
201 }
202 
203 contract MintableToken is StandardToken, Ownable {
204   event Mint(address indexed to, uint256 amount);
205   event MintFinished();
206 
207   bool public mintingFinished = false;
208 
209 
210   modifier canMint() {
211     require(!mintingFinished);
212     _;
213   }
214 
215   /**
216    * @dev Function to mint tokens
217    * @param _to The address that will receive the minted tokens.
218    * @param _amount The amount of tokens to mint.
219    * @return A boolean that indicates if the operation was successful.
220    */
221   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
222     totalSupply = totalSupply.add(_amount);
223     balances[_to] = balances[_to].add(_amount);
224     Mint(_to, _amount);
225     Transfer(address(0), _to, _amount);
226     return true;
227   }
228 
229   /**
230    * @dev Function to stop minting new tokens.
231    * @return True if the operation was successful.
232    */
233   function finishMinting() onlyOwner canMint public returns (bool) {
234     mintingFinished = true;
235     MintFinished();
236     return true;
237   }
238 }
239 
240 contract NucleusVisionAirDrop is Ownable {
241 
242   function NucleusVisionAirDrop() public {
243   }
244 
245   function batchAirDrop(address token_address, address[] recipients, uint256 ncash) onlyOwner public {
246     NucleusVisionToken token = NucleusVisionToken(token_address);
247     for(uint i = 0 ; i < recipients.length ; i++) {
248       address recipient = recipients[i];
249       require(token.transfer(recipient, ncash));
250     }
251   }
252 
253   function revokeBalance(address token_address, address recipient) onlyOwner public {
254     NucleusVisionToken token = NucleusVisionToken(token_address);
255     uint256 balance = token.balanceOf(this);
256     require(token.transfer(recipient, balance));
257   }
258 }
259 
260 contract Pausable is Ownable {
261   event Pause();
262   event Unpause();
263 
264   bool public paused = false;
265 
266 
267   /**
268    * @dev Modifier to make a function callable only when the contract is not paused.
269    */
270   modifier whenNotPaused() {
271     require(!paused);
272     _;
273   }
274 
275   /**
276    * @dev Modifier to make a function callable only when the contract is paused.
277    */
278   modifier whenPaused() {
279     require(paused);
280     _;
281   }
282 
283   /**
284    * @dev called by the owner to pause, triggers stopped state
285    */
286   function pause() onlyOwner whenNotPaused public {
287     paused = true;
288     Pause();
289   }
290 
291   /**
292    * @dev called by the owner to unpause, returns to normal state
293    */
294   function unpause() onlyOwner whenPaused public {
295     paused = false;
296     Unpause();
297   }
298 }
299 
300 contract NucleusVisionToken is MintableToken {
301   string public constant name = "NucleusVision";
302   string public constant symbol = "nCash";
303   uint8 public constant decimals = 18;
304 
305   // Total supply of nCash tokens is 10 Billion
306   uint256 public constant MAX_SUPPLY = 10 * 1000 * 1000 * 1000 * (10 ** uint256(decimals));
307   // Bit that controls whether the token can be transferred / traded
308   bool public unlocked = false;
309 
310   event NucleusVisionTokenUnlocked();
311 
312   /**
313    * @dev totalSupply is set via the minting process
314    */
315   function NucleusVisionToken() public {
316   }
317 
318   function mint(address to, uint256 amount) onlyOwner public returns (bool) {
319     require(totalSupply + amount <= MAX_SUPPLY);
320     return super.mint(to, amount);
321   }
322 
323   function unlockToken() onlyOwner public {
324     require (!unlocked);
325     unlocked = true;
326     NucleusVisionTokenUnlocked();
327   }
328 
329   // Overriding basic ERC-20 specification that lets people transfer/approve tokens.
330   function transfer(address to, uint256 value) public returns (bool) {
331     require(unlocked);
332     return super.transfer(to, value);
333   }
334 
335   function transferFrom(address from, address to, uint256 value) public returns (bool) {
336     require(unlocked);
337     return super.transferFrom(from, to, value);
338   }
339 
340   function approve(address spender, uint256 value) public returns (bool) {
341     require(unlocked);
342     return super.approve(spender, value);
343   }
344 
345   // Overriding StandardToken functions that lets people transfer/approve tokens.
346   function increaseApproval(address spender, uint addedValue) public returns (bool) {
347     require(unlocked);
348     return super.increaseApproval(spender, addedValue);
349   }
350 
351   function decreaseApproval(address spender, uint subtractedValue) public returns (bool) {
352     require(unlocked);
353     return super.decreaseApproval(spender, subtractedValue);
354   }
355 
356 }