1 /**
2  * Source Code first verified at https://etherscan.io on Thursday, June 14, 2018
3  (UTC) */
4 
5 pragma solidity ^0.4.24;
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     uint256 c = a * b;
14     assert(a == 0 || c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     uint256 c = a / b;
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 /**
36  * @title Ownable
37  * The Ownable contract has an owner address, and provides basic authorization control
38  */
39 contract Ownable {
40   address public owner;
41 
42 
43   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45 
46   /**
47    * The Ownable constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50   function Ownable() {
51     owner = msg.sender;
52   }
53 
54   /**
55    * Throws if called by any account other than the owner.
56    */
57   modifier onlyOwner() {
58     require(msg.sender == owner);
59     _;
60   }
61 
62 
63   /**
64    * Allows the current owner to transfer control of the contract to a newOwner.
65    */
66   function transferOwnership(address newOwner) onlyOwner {
67     require(newOwner != address(0));      
68     OwnershipTransferred(owner, newOwner);
69     owner = newOwner;
70   }
71 
72 }
73 
74 /**
75  * @title Pausable
76  * Base contract which allows children to implement an emergency stop mechanism.
77  */
78 contract Pausable is Ownable {
79   event Pause();
80   event Unpause();
81 
82   bool public paused = false;
83 
84 
85   /**
86    * Modifier to make a function callable only when the contract is not paused.
87    */
88   modifier whenNotPaused() {
89     require(!paused);
90     _;
91   }
92 
93   /**
94    * Modifier to make a function callable only when the contract is paused.
95    */
96   modifier whenPaused() {
97     require(paused);
98     _;
99   }
100 
101   /**
102    * called by the owner to pause, triggers stopped state
103    */
104   function pause() onlyOwner whenNotPaused {
105     paused = true;
106     Pause();
107   }
108 
109   /**
110    * called by the owner to unpause, returns to normal state
111    */
112   function unpause() onlyOwner whenPaused {
113     paused = false;
114     Unpause();
115   }
116 }
117 
118  
119 /**
120  * @title ERC20 interface
121  */
122 contract ERC20 is Ownable {
123   uint256 public totalSupply;
124   function balanceOf(address who) public view returns (uint256);
125   function transfer(address to, uint256 value) public returns (bool);
126   function allowance(address owner, address spender) public view returns (uint256);
127   function transferFrom(address from, address to, uint256 value) public returns (bool);
128   function approve(address spender, uint256 value) public returns (bool);
129   function burn(uint256 value) public returns(bool);
130   function burnFrom(address from,uint256 value)public returns(bool);
131   event Transfer(address indexed from, address indexed to, uint256 value);
132   event Approval(address indexed owner, address indexed spender, uint256 value);
133   event Burn(address target,uint amount);
134 }
135 
136 /**
137  * @title Standard ERC20 token
138  *
139  * @dev Implementation of the basic standard token.
140  * @dev https://github.com/ethereum/EIPs/issues/20
141  */
142 contract StandardToken is ERC20, Pausable {
143   using SafeMath for uint256;
144 
145   mapping(address => uint256) balances;
146   mapping (address => mapping (address => uint256)) allowed;
147 
148  mapping(address => bool) frozen;
149 
150   /**
151    * check if given address is frozen. Freeze works only if moderator role is active
152    */
153   function isFrozen(address _addr) constant returns (bool){
154       return frozen[_addr];
155   }
156 
157   /**
158    * Freezes address (no transfer can be made from or to this address).
159    */
160   function freeze(address _addr) onlyOwner {
161       frozen[_addr] = true;
162   }
163 
164   /**
165    * Unfreezes frozen address.
166    */
167   function unfreeze(address _addr) onlyOwner {
168       frozen[_addr] = false;
169   }
170 
171   /**
172    * @dev Gets the balance of the specified address.
173    * @param _owner The address to query the the balance of.
174    * @return An uint256 representing the amount owned by the passed address.
175    */
176   function balanceOf(address _owner) public view returns (uint256 balance) {
177     return balances[_owner];
178   }
179 
180   /**
181    * @dev transfer token for a specified address
182    * @param _to The address to transfer to.
183    * @param _value The amount to be transferred.
184    */
185   function transfer(address _to, uint256 _value) public returns (bool) {
186     require(_to != address(0));
187 
188     // SafeMath.sub will throw if there is not enough balance.
189     balances[msg.sender] = balances[msg.sender].sub(_value);
190     balances[_to] = balances[_to].add(_value);
191     Transfer(msg.sender, _to, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Transfer tokens from one address to another
197    * @param _from address The address which you want to send tokens from
198    * @param _to address The address which you want to transfer to
199    * @param _value uint256 the amount of tokens to be transferred
200    */
201   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
202     var _allowance = allowed[_from][msg.sender];
203     require(_to != address(0));
204     require (_value <= _allowance);
205     balances[_from] = balances[_from].sub(_value);
206     balances[_to] = balances[_to].add(_value);
207     allowed[_from][msg.sender] = _allowance.sub(_value);
208     Transfer(_from, _to, _value);
209     return true;
210   }
211 
212   /**
213    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
214    * @param _spender The address which will spend the funds.
215    * @param _value The amount of tokens to be spent.
216    */
217   function approve(address _spender, uint256 _value) public returns (bool) {
218     // To change the approve amount you first have to reduce the addresses`
219     //  allowance to zero by calling `approve(_spender, 0)` if it is not
220     //  already 0 to mitigate the race condition described here:
221     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
222     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
223     allowed[msg.sender][_spender] = _value;
224     Approval(msg.sender, _spender, _value);
225     return true;
226   }
227 
228   /**
229    * @dev Function to check the amount of tokens that an owner allowed to a spender.
230    * @param _owner address The address which owns the funds.
231    * @param _spender address The address which will spend the funds.
232    * @return A uint256 specifying the amount of tokens still available for the spender.
233    */
234   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
235     return allowed[_owner][_spender];
236   }
237   
238   function burn(uint256 _value) public returns(bool success){
239     require(balances[msg.sender]>=_value);
240     totalSupply-=_value;
241     balances[msg.sender]-=_value;
242     emit Burn(msg.sender,_value);
243     return true;
244     }
245     
246   function burnFrom(address _from,uint256 _value)public returns(bool success){
247     require(balances[_from]>=_value);
248     require(allowed[_from][msg.sender]>=_value);
249     totalSupply-=_value;
250     balances[msg.sender]-=_value;
251     allowed[_from][msg.sender]-=_value;
252     emit Burn(msg.sender,_value);
253     return true;
254     }
255 }
256 
257 /**
258  * Pausable token with moderator role and freeze address implementation
259  **/
260 contract ModToken is StandardToken {
261 
262   mapping(address => bool) frozen;
263 
264   /**
265    * check if given address is frozen. Freeze works only if moderator role is active
266    */
267   function isFrozen(address _addr) constant returns (bool){
268       return frozen[_addr];
269   }
270 
271   /**
272    * Freezes address (no transfer can be made from or to this address).
273    */
274   function freeze(address _addr) onlyOwner {
275       frozen[_addr] = true;
276   }
277 
278   /**
279    * Unfreezes frozen address.
280    */
281   function unfreeze(address _addr) onlyOwner {
282       frozen[_addr] = false;
283   }
284 
285   /**
286    * Declines transfers from/to frozen addresses.
287    */
288   function transfer(address _to, uint256 _value) whenNotPaused returns (bool) {
289     require(!isFrozen(msg.sender));
290     require(!isFrozen(_to));
291     return super.transfer(_to, _value);
292   }
293 
294   /**
295    * Declines transfers from/to/by frozen addresses.
296    */
297   function transferFrom(address _from, address _to, uint256 _value) whenNotPaused returns (bool) {
298     require(!isFrozen(msg.sender));
299     require(!isFrozen(_from));
300     require(!isFrozen(_to));
301     return super.transferFrom(_from, _to, _value);
302   }
303 }
304 
305 
306 contract ShinhwaToken is ModToken {
307    uint256 _initialAmount = 10000000000;
308     uint8 constant public decimals = 18;
309     uint public totalSupply = _initialAmount * 10 ** uint256(decimals);
310     string constant public name = "Shinhwa Token";
311     string constant public symbol = "SWT";
312     
313   function ShinhwaToken() public {
314         balances[msg.sender] = totalSupply;
315         Transfer(address(0), msg.sender, totalSupply);
316   }
317 }