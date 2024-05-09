1 pragma solidity ^0.4.13;
2 /**
3 v0.4.24+commit.e67f0147
4  * BiFree.io Official Token
5  * じ☆ve共識是終極目標，路徑却是無比麯摺的灬
6  *   ┌─────────────────────────────────────────────────────────┐ ╔╦╗┬ ┬┌─┐┌┐┌┬┌─┌─┐  ╔╦╗┌─┐
7  *   │  Poseidon                                               │  ║ ├─┤├─┤│││├┴┐└─┐   ║ │ │
8  *   │  Iris,Tina                                              │  ╩ ┴ ┴┴ ┴┘└┘┴ ┴└─┘   ╩ └─┘
9  *   │ 	Qidong,Tuco Z,Jacky H,FeiFei					       └───────────────────────────┐
10  *   │  Jerry Broth, Pro Chen, Ling                                                             │ 
11  *   │              Without your help, we wouldn't have the Bifree.io                      │
12  *   └─────────────────────────────────────────────────────────────────────────────────────┘
13  * 
14  * This product is protected under license.  Any unauthorized copy, modification, or use without 
15  * express written consent from the creators is prohibited.
16  * 
17  * WARNING:  THIS PRODUCT IS HIGHLY ADDICTIVE.  IF YOU HAVE AN ADDICTIVE NATURE.  DO NOT PLAY.
18  */
19 library SafeMath {
20 
21   /**
22   * @dev Multiplies two numbers, throws on overflow.
23   */
24   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25     if (a == 0) {
26       return 0;
27     }
28     uint256 c = a * b;
29     assert(c / a == b);
30     return c;
31   }
32 
33   /**
34   * @dev Integer division of two numbers, truncating the quotient.
35   */
36   function div(uint256 a, uint256 b) internal pure returns (uint256) {
37     // assert(b > 0); // Solidity automatically throws when dividing by 0
38     uint256 c = a / b;
39     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40     return c;
41   }
42 
43   /**
44   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
45   */
46   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   /**
52   * @dev Adds two numbers, throws on overflow.
53   */
54   function add(uint256 a, uint256 b) internal pure returns (uint256) {
55     uint256 c = a + b;
56     assert(c >= a);
57     return c;
58   }
59 }
60 
61 contract Ownable {
62   address public owner;
63 
64 
65   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
66 
67 
68   /**
69    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
70    * account.
71    */
72   function Ownable() public {
73     owner = msg.sender;
74   }
75 
76   /**
77    * @dev Throws if called by any account other than the owner.
78    */
79   modifier onlyOwner() {
80     require(msg.sender == owner);
81     _;
82   }
83 
84   /**
85    * @dev Allows the current owner to transfer control of the contract to a newOwner.
86    * @param newOwner The address to transfer ownership to.
87    */
88   function transferOwnership(address newOwner) public onlyOwner {
89     require(newOwner != address(0));
90     OwnershipTransferred(owner, newOwner);
91     owner = newOwner;
92   }
93 
94 }
95 
96 contract Pausable is Ownable {
97   event Pause();
98   event Unpause();
99 
100   bool public paused = false;
101 
102 
103   /**
104    * @dev Modifier to make a function callable only when the contract is not paused.
105    */
106   modifier whenNotPaused() {
107     require(!paused);
108     _;
109   }
110 
111   /**
112    * @dev Modifier to make a function callable only when the contract is paused.
113    */
114   modifier whenPaused() {
115     require(paused);
116     _;
117   }
118 
119   /**
120    * @dev called by the owner to pause, triggers stopped state
121    */
122   function pause() onlyOwner whenNotPaused public {
123     paused = true;
124     Pause();
125   }
126 
127   /**
128    * @dev called by the owner to unpause, returns to normal state
129    */
130   function unpause() onlyOwner whenPaused public {
131     paused = false;
132     Unpause();
133   }
134 }
135 
136 contract ERC20Basic {
137   function totalSupply() public view returns (uint256);
138   function balanceOf(address who) public view returns (uint256);
139   function transfer(address to, uint256 value) public returns (bool);
140   event Transfer(address indexed from, address indexed to, uint256 value);
141 }
142 
143 contract BasicToken is ERC20Basic {
144   using SafeMath for uint256;
145 
146   mapping(address => uint256) balances;
147 
148   uint256 totalSupply_;
149 
150   /**
151   * @dev total number of tokens in existence
152   */
153   function totalSupply() public view returns (uint256) {
154     return totalSupply_;
155   }
156 
157   /**
158   * @dev transfer token for a specified address
159   * @param _to The address to transfer to.
160   * @param _value The amount to be transferred.
161   */
162   function transfer(address _to, uint256 _value) public returns (bool) {
163     require(_to != address(0));
164     require(_value <= balances[msg.sender]);
165 
166     // SafeMath.sub will throw if there is not enough balance.
167     balances[msg.sender] = balances[msg.sender].sub(_value);
168     balances[_to] = balances[_to].add(_value);
169     Transfer(msg.sender, _to, _value);
170     return true;
171   }
172 
173   /**
174   * @dev Gets the balance of the specified address.
175   * @param _owner The address to query the the balance of.
176   * @return An uint256 representing the amount owned by the passed address.
177   */
178   function balanceOf(address _owner) public view returns (uint256 balance) {
179     return balances[_owner];
180   }
181 
182 }
183 
184 contract ERC20 is ERC20Basic {
185   function allowance(address owner, address spender) public view returns (uint256);
186   function transferFrom(address from, address to, uint256 value) public returns (bool);
187   function approve(address spender, uint256 value) public returns (bool);
188   event Approval(address indexed owner, address indexed spender, uint256 value);
189 }
190 
191 contract StandardToken is ERC20, BasicToken {
192 
193   mapping (address => mapping (address => uint256)) internal allowed;
194 
195 
196   /**
197    * @dev Transfer tokens from one address to another
198    * @param _from address The address which you want to send tokens from
199    * @param _to address The address which you want to transfer to
200    * @param _value uint256 the amount of tokens to be transferred
201    */
202   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
203     require(_to != address(0));
204     require(_value <= balances[_from]);
205     require(_value <= allowed[_from][msg.sender]);
206 
207     balances[_from] = balances[_from].sub(_value);
208     balances[_to] = balances[_to].add(_value);
209     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
210     Transfer(_from, _to, _value);
211     return true;
212   }
213 
214   /**
215    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
216    *
217    * Beware that changing an allowance with this method brings the risk that someone may use both the old
218    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
219    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
220    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
221    * @param _spender The address which will spend the funds.
222    * @param _value The amount of tokens to be spent.
223    */
224   function approve(address _spender, uint256 _value) public returns (bool) {
225     allowed[msg.sender][_spender] = _value;
226     Approval(msg.sender, _spender, _value);
227     return true;
228   }
229 
230   /**
231    * @dev Function to check the amount of tokens that an owner allowed to a spender.
232    * @param _owner address The address which owns the funds.
233    * @param _spender address The address which will spend the funds.
234    * @return A uint256 specifying the amount of tokens still available for the spender.
235    */
236   function allowance(address _owner, address _spender) public view returns (uint256) {
237     return allowed[_owner][_spender];
238   }
239 
240   /**
241    * @dev Increase the amount of tokens that an owner allowed to a spender.
242    *
243    * approve should be called when allowed[_spender] == 0. To increment
244    * allowed value is better to use this function to avoid 2 calls (and wait until
245    * the first transaction is mined)
246    * From MonolithDAO Token.sol
247    * @param _spender The address which will spend the funds.
248    * @param _addedValue The amount of tokens to increase the allowance by.
249    */
250   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
251     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
252     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
253     return true;
254   }
255 
256   /**
257    * @dev Decrease the amount of tokens that an owner allowed to a spender.
258    *
259    * approve should be called when allowed[_spender] == 0. To decrement
260    * allowed value is better to use this function to avoid 2 calls (and wait until
261    * the first transaction is mined)
262    * From MonolithDAO Token.sol
263    * @param _spender The address which will spend the funds.
264    * @param _subtractedValue The amount of tokens to decrease the allowance by.
265    */
266   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
267     uint oldValue = allowed[msg.sender][_spender];
268     if (_subtractedValue > oldValue) {
269       allowed[msg.sender][_spender] = 0;
270     } else {
271       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
272     }
273     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
274     return true;
275   }
276 
277 }
278 
279 contract BifreeToken is Ownable, StandardToken {
280 
281     string public name = 'Bifree.io Official Token';
282     string public symbol = 'BFT';
283     uint8 public decimals = 18;
284     uint public INITIAL_SUPPLY = 500000000;
285 
286     event Burn(address indexed burner, uint256 value);
287     event EnableTransfer();
288     event DisableTransfer();
289 
290     bool public transferable = false;
291 
292     modifier whenTransferable() {
293         require(transferable || msg.sender == owner);
294         _;
295     }
296 
297     modifier whenNotTransferable() {
298         require(!transferable);
299         _;
300     }
301 
302     function BifreeToken() public {
303         totalSupply_ = INITIAL_SUPPLY * 10 ** uint256(decimals);
304         balances[msg.sender] = totalSupply_;
305     }
306 
307     function burn(uint256 _value) public {
308         require(_value <= balances[msg.sender]);
309         address burner = msg.sender;
310         balances[burner] = balances[burner].sub(_value);
311         totalSupply_ = totalSupply_.sub(_value);
312         Burn(burner, _value);
313     }
314 
315     // enable transfer after token sale and before listing
316     function enableTransfer() onlyOwner  public {
317         transferable = true;
318         EnableTransfer();
319     }
320 
321     // disable transfer for upgrade or emergency events
322     function disableTransfer() onlyOwner public
323     {
324         transferable = false;
325         DisableTransfer();
326     }
327 
328     function transfer(address _to, uint256 _value) public whenTransferable returns (bool) {
329         return super.transfer(_to, _value);
330     }
331 
332 
333     function transferFrom(address _from, address _to, uint256 _value) public whenTransferable returns (bool) {
334         return super.transferFrom(_from, _to, _value);
335     }
336 
337     function approve(address _spender, uint256 _value) public whenTransferable returns (bool) {
338         return super.approve(_spender, _value);
339     }
340 
341     function increaseApproval(address _spender, uint _addedValue) public whenTransferable returns (bool success) {
342         return super.increaseApproval(_spender, _addedValue);
343     }
344 
345     function decreaseApproval(address _spender, uint _subtractedValue) public whenTransferable returns (bool success) {
346         return super.decreaseApproval(_spender, _subtractedValue);
347     }
348 
349 }