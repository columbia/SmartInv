1 /**
2  *Submitted for verification at Etherscan.io on 2018-10-21
3 */
4 
5 pragma solidity ^0.4.23;
6 
7 /**
8  * @title Ownable
9  * @dev The Ownable contract has an owner address, and provides basic authorization control
10  * functions, this simplifies the implementation of "user permissions".
11  */
12 contract Ownable {
13   address public owner;
14 
15 
16   event OwnershipRenounced(address indexed previousOwner);
17   event OwnershipTransferred(
18     address indexed previousOwner,
19     address indexed newOwner
20   );
21   
22 
23   /**
24    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
25    * account.
26    */
27   constructor() public {
28     owner = msg.sender;
29   }
30 
31   /**
32    * @dev Throws if called by any account other than the owner.
33    */
34   modifier onlyOwner() {
35     require(msg.sender == owner);
36     _;
37   }
38 
39   /**
40    * @dev Allows the current owner to transfer control of the contract to a newOwner.
41    * @param newOwner The address to transfer ownership to.
42    */
43   function transferOwnership(address newOwner) public onlyOwner {
44     require(newOwner != address(0));
45     emit OwnershipTransferred(owner, newOwner);
46     owner = newOwner;
47   }
48 
49   /**
50    * @dev Allows the current owner to relinquish control of the contract.
51    */
52   function renounceOwnership() public onlyOwner {
53     emit OwnershipRenounced(owner);
54     owner = address(0);
55   }
56 }
57 
58 /**
59  * @title SafeMath
60  * @dev Math operations with safety checks that throw on error
61  */
62 library SafeMath {
63 
64   /**
65   * @dev Multiplies two numbers, throws on overflow.
66   */
67   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
68     if (a == 0) {
69       return 0;
70     }
71     c = a * b;
72     assert(c / a == b);
73     return c;
74   }
75 
76   /**
77   * @dev Integer division of two numbers, truncating the quotient.
78   */
79   function div(uint256 a, uint256 b) internal pure returns (uint256) {
80     // assert(b > 0); // Solidity automatically throws when dividing by 0
81     // uint256 c = a / b;
82     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
83     return a / b;
84   }
85 
86   /**
87   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
88   */
89   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
90     assert(b <= a);
91     return a - b;
92   }
93 
94   /**
95   * @dev Adds two numbers, throws on overflow.
96   */
97   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
98     c = a + b;
99     assert(c >= a);
100     return c;
101   }
102 }
103 
104 /**
105  * @title ERC20Basic
106  * @dev Simpler version of ERC20 interface
107  * @dev see https://github.com/ethereum/EIPs/issues/179
108  */
109 contract ERC20Basic {
110   function totalSupply() public view returns (uint256);
111   function transfer(address to, uint256 value) public returns (bool);
112   event Transfer(address indexed from, address indexed to, uint256 value);
113 }
114 
115 /**
116  * @title ERC20 interface
117  * @dev see https://github.com/ethereum/EIPs/issues/20
118  */
119 contract ERC20 is ERC20Basic {
120   function allowance(address owner, address spender) public view returns (uint256);
121   function transferFrom(address from, address to, uint256 value) public returns (bool);
122   function approve(address spender, uint256 value) public returns (bool);
123   event Approval(address indexed owner, address indexed spender, uint256 value);
124 }
125 
126 contract BasicToken is ERC20Basic {
127   using SafeMath for uint256;
128 
129   mapping(address => uint256) balances;
130 
131   uint256 totalSupply_;
132 
133   /**
134   * @dev total number of tokens in existence
135   */
136   function totalSupply() public view returns (uint256) {
137     return totalSupply_;
138   }
139 
140   /**
141   * @dev transfer token for a specified address
142   * @param _to The address to transfer to.
143   * @param _value The amount to be transferred.
144   */
145   function transfer(address _to, uint256 _value) public returns (bool) {
146     require(_to != address(0));
147     require(_value <= balances[msg.sender]);
148 
149     balances[msg.sender] = balances[msg.sender].sub(_value);
150     balances[_to] = balances[_to].add(_value);
151     emit Transfer(msg.sender, _to, _value);
152     return true;
153   }
154 }
155 /**
156  * @title Standard ERC20 token
157  *
158  * @dev Implementation of the basic standard token.
159  * @dev https://github.com/ethereum/EIPs/issues/20
160  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
161  */
162 contract StandardToken is ERC20, BasicToken {
163 
164   mapping (address => mapping (address => uint256)) internal allowed;
165 
166 
167   /**
168    * @dev Transfer tokens from one address to another
169    * @param _from address The address which you want to send tokens from
170    * @param _to address The address which you want to transfer to
171    * @param _value uint256 the amount of tokens to be transferred
172    */
173   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
174     require(_to != address(0));
175     require(_value <= balances[_from]);
176     require(_value <= allowed[_from][msg.sender]);
177 
178     balances[_from] = balances[_from].sub(_value);
179     balances[_to] = balances[_to].add(_value);
180     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
181     emit Transfer(_from, _to, _value);
182     return true;
183   }
184 
185   /**
186    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
187    *
188    * Beware that changing an allowance with this method brings the risk that someone may use both the old
189    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
190    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
191    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
192    * @param _spender The address which will spend the funds.
193    * @param _value The amount of tokens to be spent.
194    */
195   function approve(address _spender, uint256 _value) public returns (bool) {
196     allowed[msg.sender][_spender] = _value;
197     emit Approval(msg.sender, _spender, _value);
198     return true;
199   }
200 
201   /**
202    * @dev Function to check the amount of tokens that an owner allowed to a spender.
203    * @param _owner address The address which owns the funds.
204    * @param _spender address The address which will spend the funds.
205    * @return A uint256 specifying the amount of tokens still available for the spender.
206    */
207   function allowance(address _owner, address _spender) public view returns (uint256) {
208     return allowed[_owner][_spender];
209   }
210 
211   /**
212    * @dev Increase the amount of tokens that an owner allowed to a spender.
213    *
214    * approve should be called when allowed[_spender] == 0. To increment
215    * allowed value is better to use this function to avoid 2 calls (and wait until
216    * the first transaction is mined)
217    * From MonolithDAO Token.sol
218    * @param _spender The address which will spend the funds.
219    * @param _addedValue The amount of tokens to increase the allowance by.
220    */
221   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
222     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
223     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
224     return true;
225   }
226 
227   /**
228    * @dev Decrease the amount of tokens that an owner allowed to a spender.
229    *
230    * approve should be called when allowed[_spender] == 0. To decrement
231    * allowed value is better to use this function to avoid 2 calls (and wait until
232    * the first transaction is mined)
233    * From MonolithDAO Token.sol
234    * @param _spender The address which will spend the funds.
235    * @param _subtractedValue The amount of tokens to decrease the allowance by.
236    */
237   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
238     uint oldValue = allowed[msg.sender][_spender];
239     if (_subtractedValue > oldValue) {
240       allowed[msg.sender][_spender] = 0;
241     } else {
242       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
243     }
244     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
245     return true;
246   }
247 
248 }
249 
250 contract EMC is StandardToken, Ownable {
251   string public constant name = "Exploitation Mine Chain"; // solium-disable-line uppercase
252   string public constant symbol = "EMC"; // solium-disable-line uppercase
253   uint8 public constant decimals = 8; // solium-disable-line uppercase
254   
255   uint256 constant MAX_SUPPLY = 3600 * 10000 * (10 ** uint256(decimals));
256 
257   /* This creates an array with all frozen */
258   mapping (address => uint256) public freezeOf;
259 
260   /* This notifies clients about the amount burnt */
261   event Burn(address indexed from, uint256 value);
262   
263   /* This notifies clients about the amount frozen */
264   event Freeze(address indexed from, uint256 value);
265   
266   /* This notifies clients about the amount unfrozen */
267   event Unfreeze(address indexed from, uint256 value);
268 
269   /* Initializes contract with max supply tokens to the creator of the contract */
270   constructor() public {
271     totalSupply_ = MAX_SUPPLY;
272     balances[msg.sender] = MAX_SUPPLY;
273     emit Transfer(0x0, msg.sender, MAX_SUPPLY);
274   }
275   
276   /**
277   * @dev Gets the balance of the specified address.
278   * @param _owner The address to query the the balance of.
279   * @return An uint256 representing the amount owned by the passed address.
280   */
281   function balanceOf(address _owner) public view returns (uint256) {
282     return balances[_owner].add(freezeOf[_owner]);
283   } 
284 
285   function burn(uint256 _value) public returns (bool success) {
286     require(_value <= balances[msg.sender]);            // Check if the sender has enough
287     require(_value > 0); 
288     balances[msg.sender] = balances[msg.sender].sub(_value);                     // Subtract from the sender
289     totalSupply_ = totalSupply_.sub(_value);                                // Updates totalSupply
290     emit Burn(msg.sender, _value);
291     return true;
292   }
293   
294   function freeze(address target, uint256 _value) onlyOwner public returns (bool success) {
295     require(_value <= balances[target]);            // Check if the sender has enough
296     require(_value > 0); 
297     balances[target] = balances[target].sub(_value);                      // Subtract from the sender
298     freezeOf[target] = freezeOf[target].add(_value);                      // Updates totalSupply
299     emit Freeze(target, _value);
300     return true;
301   }
302   
303   function unfreeze(address target, uint256 _value) onlyOwner public returns (bool success) {
304     require(_value <= freezeOf[target]);            // Check if the sender has enough
305     require(_value > 0); 
306     freezeOf[target] = freezeOf[target].sub(_value);                      // Subtract from the sender
307     balances[target] = balances[target].add(_value);
308     emit Unfreeze(target, _value);
309     return true;
310   }
311   
312   function mint(uint256 mintedAmount) public onlyOwner returns (bool success){
313         balances[owner] += mintedAmount;
314         totalSupply_ += mintedAmount;
315         Transfer(0, owner, mintedAmount);
316         return true;
317     }
318   
319   // transfer balance to owner
320   function withdrawEther() onlyOwner public {
321     msg.sender.transfer(this.balance);          // sends ether for withdrawal. 
322   }
323   
324   // can accept ether
325   function () payable public{
326     owner.transfer(this.balance);
327   }
328 }