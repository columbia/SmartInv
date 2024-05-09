1 pragma solidity ^0.4.17;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11   /**
12    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13    * account.
14    */
15   function Ownable() public {
16     owner = msg.sender;
17   }
18   /**
19    * @dev Throws if called by any account other than the owner.
20    */
21   modifier onlyOwner(){
22     require(msg.sender == owner);
23     _;
24   }
25   /**
26    * @dev Allows the current owner to transfer control of the contract to a newOwner.
27    * @param newOwner The address to transfer ownership to.
28    */
29   function transferOwnership(address newOwner) onlyOwner public {
30     if (newOwner != address(0)) {
31       owner = newOwner;
32     }
33   }
34 }
35 
36 /**
37  * @title Pausable
38  * @dev Base contract which allows children to implement an emergency stop mechanism.
39  */
40 contract Pausable is Ownable {
41   event Pause();
42   event Unpause();
43   bool public paused = false;
44   /**
45    * @dev modifier to allow actions only when the contract IS paused
46    */
47   modifier whenNotPaused() {
48     require (!paused);
49     _;
50   }
51   /**
52    * @dev modifier to allow actions only when the contract IS NOT paused
53    */
54   modifier whenPaused {
55     require (paused);
56     _;
57   }
58   /**
59    * @dev called by the owner to pause, triggers stopped state
60    */
61   function pause() onlyOwner whenNotPaused  public returns (bool) {
62     paused = true;
63     Pause();
64     return true;
65   }
66   /**
67    * @dev called by the owner to unpause, returns to normal state
68    */
69   function unpause() onlyOwner whenPaused public returns (bool) {
70     paused = false;
71     Unpause();
72     return true;
73   }
74 }
75 /**
76  * @title ERC20Basic
77  * @dev Simpler version of ERC20 interface
78  * @dev see https://github.com/ethereum/EIPs/issues/179
79  */
80 contract ERC20Basic {
81   uint256 public totalSupply;
82   function balanceOf(address who) public constant returns (uint256);
83   function transfer(address to, uint256 value) public returns (bool);
84   event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
87 /**
88  * @title ERC20 interface
89  * @dev see https://github.com/ethereum/EIPs/issues/20
90  */
91 contract ERC20 is ERC20Basic {
92   function allowance(address owner, address spender) public constant returns (uint256);
93   function transferFrom(address from, address to, uint256 value) public returns (bool);
94   function approve(address spender, uint256 value) public returns (bool);
95   event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 /**
99  * @title SafeMath
100  * @dev Math operations with safety checks that throw on error
101  */
102 library SafeMath {
103   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
104     uint256 c = a * b;
105     assert(a == 0 || c / a == b);
106     return c;
107   }
108 
109   function div(uint256 a, uint256 b) internal pure returns (uint256) {
110     // assert(b > 0); // Solidity automatically throws when dividing by 0
111     uint256 c = a / b;
112     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
113     return c;
114   }
115 
116   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
117     assert(b <= a);
118     return a - b;
119   }
120 
121   function add(uint256 a, uint256 b) internal pure returns (uint256) {
122     uint256 c = a + b;
123     assert(c >= a);
124     return c;
125   }
126 }
127 
128 /**
129  * @title Basic token
130  * @dev Basic version of StandardToken, with no allowances.
131  */
132 contract BasicToken is ERC20Basic {
133   using SafeMath for uint256;
134 
135   mapping(address => uint256) balances;
136 
137   /**
138   * @dev transfer token for a specified address
139   * @param _to The address to transfer to.
140     * @param _value The amount to be transferred.
141       */
142   function transfer(address _to, uint256 _value) public returns (bool){
143     require(_to != address(0));
144     require(_value <= balances[msg.sender]);
145     
146     balances[msg.sender] = balances[msg.sender].sub(_value);
147     balances[_to] = balances[_to].add(_value);
148     Transfer(msg.sender, _to, _value);
149     return true;
150   }
151 
152   /**
153   * @dev Gets the balance of the specified address.
154   * @param _owner The address to query the the balance of.
155     * @return An uint256 representing the amount owned by the passed address.
156     */
157   function balanceOf(address _owner) public constant returns (uint256 balance) {
158     return balances[_owner];
159   }
160 }
161 
162 
163 
164 /**
165  * @title Standard ERC20 token
166  *
167  * @dev Implementation of the basic standard token.
168  * @dev https://github.com/ethereum/EIPs/issues/20
169  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
170  */
171 contract StandardToken is ERC20, BasicToken {
172 
173   mapping (address => mapping (address => uint256)) internal allowed;
174 
175 
176   /**
177    * @dev Transfer tokens from one address to another
178    * @param _from address The address which you want to send tokens from
179    * @param _to address The address which you want to transfer to
180    * @param _value uint256 the amount of tokens to be transferred
181    */
182   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
183     require(_to != address(0));
184     require(_value <= balances[_from]);
185     require(_value <= allowed[_from][msg.sender]);
186 
187     balances[_from] = balances[_from].sub(_value);
188     balances[_to] = balances[_to].add(_value);
189     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
190     Transfer(_from, _to, _value);
191     return true;
192   }
193 
194   /**
195    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
196    *
197    * Beware that changing an allowance with this method brings the risk that someone may use both the old
198    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
199    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
200    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
201    * @param _spender The address which will spend the funds.
202    * @param _value The amount of tokens to be spent.
203    */
204   function approve(address _spender, uint256 _value) public returns (bool) {
205     allowed[msg.sender][_spender] = _value;
206     Approval(msg.sender, _spender, _value);
207     return true;
208   }
209 
210   /**
211    * @dev Function to check the amount of tokens that an owner allowed to a spender.
212    * @param _owner address The address which owns the funds.
213    * @param _spender address The address which will spend the funds.
214    * @return A uint256 specifying the amount of tokens still available for the spender.
215    */
216   function allowance(address _owner, address _spender) public view returns (uint256) {
217     return allowed[_owner][_spender];
218   }
219 
220   /**
221    * @dev Increase the amount of tokens that an owner allowed to a spender.
222    *
223    * approve should be called when allowed[_spender] == 0. To increment
224    * allowed value is better to use this function to avoid 2 calls (and wait until
225    * the first transaction is mined)
226    * From MonolithDAO Token.sol
227    * @param _spender The address which will spend the funds.
228    * @param _addedValue The amount of tokens to increase the allowance by.
229    */
230   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
231     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
232     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
233     return true;
234   }
235 
236   /**
237    * @dev Decrease the amount of tokens that an owner allowed to a spender.
238    *
239    * approve should be called when allowed[_spender] == 0. To decrement
240    * allowed value is better to use this function to avoid 2 calls (and wait until
241    * the first transaction is mined)
242    * From MonolithDAO Token.sol
243    * @param _spender The address which will spend the funds.
244    * @param _subtractedValue The amount of tokens to decrease the allowance by.
245    */
246   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
247     uint oldValue = allowed[msg.sender][_spender];
248     if (_subtractedValue > oldValue) {
249       allowed[msg.sender][_spender] = 0;
250     } else {
251       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
252     }
253     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
254     return true;
255   }
256 
257 }
258 
259 
260 
261 
262 // ***********************************************************************************
263 // *************************** END OF THE BASIC **************************************
264 // ***********************************************************************************
265 
266 
267 
268 contract IrisTokenPrivatSale is Ownable, Pausable{
269 
270   using SafeMath for uint256;
271 
272   // The token being sold
273   
274   
275   
276  
277 
278 
279 
280   address public multiSig; 
281 
282   // ***************************
283   // amount of raised money in wei
284   uint256 public weiRaised;
285 
286   
287 
288   event HostEther(address indexed buyer, uint256 value);
289   event TokenPlaced(address indexed beneficiary, uint256 amount); 
290   event SetWallet(address _newWallet);
291   event SendedEtherToMultiSig(address walletaddress, uint256 amountofether);
292 
293   function setWallet(address _newWallet) public onlyOwner {
294     multiSig = _newWallet;
295     SetWallet(_newWallet);
296 }
297   function IrisTokenPrivatSale() public {
298       
299 
300 
301 // *************************************
302 
303     multiSig = 0x02cb1ADc98e984A67a3d892Dbb7eD72b36dA7b07; // IRIS multiSig Wallet Address
304 
305 //**************************************    
306 
307     
308    
309 }
310   
311 
312 
313 
314   // low level token purchase function
315   function buyTokens(address buyer, uint256 amount) whenNotPaused internal {
316     
317     require (multiSig != 0x0);
318     require (msg.value >= 2 ether);
319     // update state
320     weiRaised = weiRaised.add(amount);
321    
322     HostEther(buyer, amount);
323     // send the ether to the MultiSig Wallet
324     multiSig.transfer(this.balance);     // better in case any other ether ends up here
325     SendedEtherToMultiSig(multiSig,amount);
326   }
327 
328   
329 
330   // fallback function can be used to buy tokens
331   function () public payable {
332     buyTokens(msg.sender, msg.value);
333   }
334 
335   function emergencyERC20Drain( ERC20 oddToken, uint amount ) public onlyOwner{
336     oddToken.transfer(owner, amount);
337   }
338 }