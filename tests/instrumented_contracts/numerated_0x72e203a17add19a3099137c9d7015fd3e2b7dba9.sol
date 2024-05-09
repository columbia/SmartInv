1 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
2 
3 pragma solidity ^0.4.18;
4 
5 
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * @dev see https://github.com/ethereum/EIPs/issues/179
10  */
11 contract ERC20Basic {
12   function totalSupply() public view returns (uint256);
13   function balanceOf(address who) public view returns (uint256);
14   function transfer(address to, uint256 value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 // File: zeppelin-solidity/contracts/math/SafeMath.sol
19 
20 pragma solidity ^0.4.18;
21 
22 
23 /**
24  * @title SafeMath
25  * @dev Math operations with safety checks that throw on error
26  */
27 library SafeMath {
28 
29   /**
30   * @dev Multiplies two numbers, throws on overflow.
31   */
32   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33     if (a == 0) {
34       return 0;
35     }
36     uint256 c = a * b;
37     assert(c / a == b);
38     return c;
39   }
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 a, uint256 b) internal pure returns (uint256) {
45     // assert(b > 0); // Solidity automatically throws when dividing by 0
46     uint256 c = a / b;
47     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48     return c;
49   }
50 
51   /**
52   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55     assert(b <= a);
56     return a - b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 a, uint256 b) internal pure returns (uint256) {
63     uint256 c = a + b;
64     assert(c >= a);
65     return c;
66   }
67 }
68 
69 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
70 
71 pragma solidity ^0.4.18;
72 
73 
74 
75 
76 /**
77  * @title Basic token
78  * @dev Basic version of StandardToken, with no allowances.
79  */
80 contract BasicToken is ERC20Basic {
81   using SafeMath for uint256;
82 
83   mapping(address => uint256) balances;
84 
85   uint256 totalSupply_;
86 
87   /**
88   * @dev total number of tokens in existence
89   */
90   function totalSupply() public view returns (uint256) {
91     return totalSupply_;
92   }
93 
94   /**
95   * @dev transfer token for a specified address
96   * @param _to The address to transfer to.
97   * @param _value The amount to be transferred.
98   */
99   function transfer(address _to, uint256 _value) public returns (bool) {
100     require(_to != address(0));
101     require(_value <= balances[msg.sender]);
102 
103     // SafeMath.sub will throw if there is not enough balance.
104     balances[msg.sender] = balances[msg.sender].sub(_value);
105     balances[_to] = balances[_to].add(_value);
106     Transfer(msg.sender, _to, _value);
107     return true;
108   }
109 
110   /**
111   * @dev Gets the balance of the specified address.
112   * @param _owner The address to query the the balance of.
113   * @return An uint256 representing the amount owned by the passed address.
114   */
115   function balanceOf(address _owner) public view returns (uint256 balance) {
116     return balances[_owner];
117   }
118 
119 }
120 
121 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
122 
123 pragma solidity ^0.4.18;
124 
125 
126 
127 /**
128  * @title ERC20 interface
129  * @dev see https://github.com/ethereum/EIPs/issues/20
130  */
131 contract ERC20 is ERC20Basic {
132   function allowance(address owner, address spender) public view returns (uint256);
133   function transferFrom(address from, address to, uint256 value) public returns (bool);
134   function approve(address spender, uint256 value) public returns (bool);
135   event Approval(address indexed owner, address indexed spender, uint256 value);
136 }
137 
138 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
139 
140 pragma solidity ^0.4.18;
141 
142 
143 
144 
145 /**
146  * @title Standard ERC20 token
147  *
148  * @dev Implementation of the basic standard token.
149  * @dev https://github.com/ethereum/EIPs/issues/20
150  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
151  */
152 contract StandardToken is ERC20, BasicToken {
153 
154   mapping (address => mapping (address => uint256)) internal allowed;
155 
156 
157   /**
158    * @dev Transfer tokens from one address to another
159    * @param _from address The address which you want to send tokens from
160    * @param _to address The address which you want to transfer to
161    * @param _value uint256 the amount of tokens to be transferred
162    */
163   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
164     require(_to != address(0));
165     require(_value <= balances[_from]);
166     require(_value <= allowed[_from][msg.sender]);
167 
168     balances[_from] = balances[_from].sub(_value);
169     balances[_to] = balances[_to].add(_value);
170     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
171     Transfer(_from, _to, _value);
172     return true;
173   }
174 
175   /**
176    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
177    *
178    * Beware that changing an allowance with this method brings the risk that someone may use both the old
179    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
180    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
181    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
182    * @param _spender The address which will spend the funds.
183    * @param _value The amount of tokens to be spent.
184    */
185   function approve(address _spender, uint256 _value) public returns (bool) {
186     allowed[msg.sender][_spender] = _value;
187     Approval(msg.sender, _spender, _value);
188     return true;
189   }
190 
191   /**
192    * @dev Function to check the amount of tokens that an owner allowed to a spender.
193    * @param _owner address The address which owns the funds.
194    * @param _spender address The address which will spend the funds.
195    * @return A uint256 specifying the amount of tokens still available for the spender.
196    */
197   function allowance(address _owner, address _spender) public view returns (uint256) {
198     return allowed[_owner][_spender];
199   }
200 
201   /**
202    * @dev Increase the amount of tokens that an owner allowed to a spender.
203    *
204    * approve should be called when allowed[_spender] == 0. To increment
205    * allowed value is better to use this function to avoid 2 calls (and wait until
206    * the first transaction is mined)
207    * From MonolithDAO Token.sol
208    * @param _spender The address which will spend the funds.
209    * @param _addedValue The amount of tokens to increase the allowance by.
210    */
211   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
212     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
213     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214     return true;
215   }
216 
217   /**
218    * @dev Decrease the amount of tokens that an owner allowed to a spender.
219    *
220    * approve should be called when allowed[_spender] == 0. To decrement
221    * allowed value is better to use this function to avoid 2 calls (and wait until
222    * the first transaction is mined)
223    * From MonolithDAO Token.sol
224    * @param _spender The address which will spend the funds.
225    * @param _subtractedValue The amount of tokens to decrease the allowance by.
226    */
227   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
228     uint oldValue = allowed[msg.sender][_spender];
229     if (_subtractedValue > oldValue) {
230       allowed[msg.sender][_spender] = 0;
231     } else {
232       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
233     }
234     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
235     return true;
236   }
237 
238 }
239 
240 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
241 
242 pragma solidity ^0.4.18;
243 
244 
245 /**
246  * @title Ownable
247  * @dev The Ownable contract has an owner address, and provides basic authorization control
248  * functions, this simplifies the implementation of "user permissions".
249  */
250 contract Ownable {
251   address public owner;
252 
253 
254   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
255 
256 
257   /**
258    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
259    * account.
260    */
261   function Ownable() public {
262     owner = msg.sender;
263   }
264 
265   /**
266    * @dev Throws if called by any account other than the owner.
267    */
268   modifier onlyOwner() {
269     require(msg.sender == owner);
270     _;
271   }
272 
273   /**
274    * @dev Allows the current owner to transfer control of the contract to a newOwner.
275    * @param newOwner The address to transfer ownership to.
276    */
277   function transferOwnership(address newOwner) public onlyOwner {
278     require(newOwner != address(0));
279     OwnershipTransferred(owner, newOwner);
280     owner = newOwner;
281   }
282 
283 }
284 
285 // File: contracts/VaryingSupplyToken.sol
286 
287 pragma solidity ^0.4.17;
288 
289 
290 
291 
292 contract VaryingSupplyToken is StandardToken, Ownable {
293 
294     event Mint(address indexed to, uint256 amount);
295     event Burn(address indexed from, uint256 amount);
296 
297 
298     /**
299     * @dev Function to create tokens
300     * @param _to The address that will receive the minted tokens.
301     * @param _amount The amount of tokens to mint.
302     * @return A boolean that indicates if the operation was successful.
303     */
304     function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
305         totalSupply_ = totalSupply_.add(_amount);
306         balances[_to] = balances[_to].add(_amount);
307         
308         Mint(_to, _amount);
309         Transfer(0x0, _to, _amount);
310         return true;
311     }
312 
313     /**
314     * @dev Function to destroy tokens
315     * @param _from The address that will lose the burned tokens.
316     * @param _amount The amount of tokens to burn.
317     * @return A boolean that indicates if the operation was successful.
318     */
319     function burn(address _from, uint256 _amount) onlyOwner public returns (bool) {
320         require(_amount <= balances[_from]);
321 
322         totalSupply_ = totalSupply_.sub(_amount);
323         balances[_from] = balances[_from].sub(_amount);
324         
325         Burn(_from, _amount);
326         Transfer(_from, 0x0, _amount);
327         return true;
328     }
329     
330 }
331 
332 // File: contracts/BCP.sol
333 
334 pragma solidity ^0.4.17;
335 
336 
337 
338 contract BCP is VaryingSupplyToken {
339 
340     string public constant name = "BlockchainPoland";
341     string public constant symbol = "BCP";
342     uint8 public constant decimals = 18;
343 
344 }