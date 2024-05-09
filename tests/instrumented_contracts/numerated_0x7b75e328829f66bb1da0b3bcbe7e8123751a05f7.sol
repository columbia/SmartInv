1 /**
2  *Submitted for verification at Etherscan.io on 2021-04-19
3 */
4 
5 pragma solidity 0.4.24;
6 
7 /**
8  * @title ERC20Basic
9  * @dev Simpler version of ERC20 interface
10  * @dev see https://github.com/ethereum/EIPs/issues/179
11  */
12 contract ERC20Basic {
13   function totalSupply() public view returns (uint256);
14   function balanceOf(address who) public view returns (uint256);
15   function transfer(address to, uint256 value) public returns (bool);
16   event Transfer(address indexed from, address indexed to, uint256 value);
17 }
18 
19 /**
20  * @title Ownable
21  * @dev The Ownable contract has an owner address, and provides basic authorization control
22  * functions, this simplifies the implementation of "user permissions".
23  */
24 contract Ownable {
25   address public owner;
26 
27 
28   //event OwnershipRenounced(address indexed previousOwner);
29   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
30 
31 
32   /**
33    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
34    * account.
35    */
36   constructor() public {
37     owner = msg.sender;
38   }
39 
40   /**
41    * @dev Throws if called by any account other than the owner.
42    */
43   modifier onlyOwner() {
44     require(msg.sender == owner);
45     _;
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address newOwner) public onlyOwner {
53     require(newOwner != address(0));
54     emit OwnershipTransferred(owner, newOwner);
55     owner = newOwner;
56   }
57 
58   /**
59    * @dev Allows the current owner to relinquish control of the contract.
60    */
61   //function renounceOwnership() public onlyOwner {
62   //  emit OwnershipRenounced(owner);
63   //  owner = address(0);
64   //}
65 }
66 
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances.
70  */
71 contract BasicToken is ERC20Basic, Ownable {
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) balances;
75   
76   mapping(address => bool) internal blacklist;
77   address[] internal blacklistHistory;
78   
79   address addressSaleContract;
80   event BlacklistUpdated(address badUserAddress, bool registerStatus);
81 
82   uint256 totalSupply_;
83 
84   /**
85   * @dev total number of tokens in existence
86   */
87   function totalSupply() public view returns (uint256) {
88     return totalSupply_;
89   }
90 
91   /**
92   * @dev transfer token for a specified address
93   * @param _to The address to transfer to.
94   * @param _value The amount to be transferred.
95   */
96   function transfer(address _to, uint256 _value) public returns (bool) {
97     require(_to != address(0));
98     require(_value <= balances[msg.sender]);
99     require(!blacklist[_to]);
100     require(!blacklist[msg.sender]);
101     
102     balances[msg.sender] = balances[msg.sender].sub(_value);
103     balances[_to] = balances[_to].add(_value);
104     emit Transfer(msg.sender, _to, _value);
105     return true;
106   }
107 
108   /**
109   * @dev Gets the balance of the specified address.
110   * @param _owner The address to query the the balance of.
111   * @return An uint256 representing the amount owned by the passed address.
112   */
113   function balanceOf(address _owner) public view returns (uint256) {
114     require(msg.sender == owner || !blacklist[_owner]);
115     require(!blacklist[msg.sender]);
116     return balances[_owner];
117   }
118 
119   /**
120   * @dev Set the specified address to blacklist.
121   * @param _badUserAddress The address of bad user.
122   */
123   function registerToBlacklist(address _badUserAddress) onlyOwner public {
124       if (blacklist[_badUserAddress] != true) {
125 	  	  blacklist[_badUserAddress] = true;
126           blacklistHistory.push(_badUserAddress);
127 	  }
128       emit BlacklistUpdated(_badUserAddress, blacklist[_badUserAddress]);   
129   }
130   
131   /**
132   * @dev Remove the specified address from blacklist.
133   * @param _badUserAddress The address of bad user.
134   */
135   function unregisterFromBlacklist(address _badUserAddress) onlyOwner public {
136       if (blacklist[_badUserAddress] == true) {
137 	  	  blacklist[_badUserAddress] = false;
138 	  }
139       emit BlacklistUpdated(_badUserAddress, blacklist[_badUserAddress]);
140   }
141 
142   /**
143   * @dev Check the address registered in blacklist.
144   * @param _address The address to check.
145   * @return a bool representing registration of the passed address.
146   */
147   function checkBlacklist (address _address) onlyOwner public view returns (bool) {
148       return blacklist[_address];
149   }
150 }
151 
152 /**
153  * @title Burnable Token
154  * @dev Token that can be irreversibly burned (destroyed).
155  */
156 contract BurnableToken is BasicToken {
157 
158   event Burn(address indexed burner, uint256 value);
159 
160   /**
161    * @dev Burns a specific amount of tokens.
162    * @param _value The amount of token to be burned.
163    */
164   function burn(uint256 _value) onlyOwner public {
165     _burn(msg.sender, _value);
166   }
167 
168   function _burn(address _who, uint256 _value) onlyOwner internal {
169     require(_value <= balances[_who]);
170     // no need to require value <= totalSupply, since that would imply the
171     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
172 
173     balances[_who] = balances[_who].sub(_value);
174     totalSupply_ = totalSupply_.sub(_value);
175     emit Burn(_who, _value);
176     emit Transfer(_who, address(0), _value);
177   }
178 }
179 
180 /**
181  * @title ERC20 interface
182  * @dev see https://github.com/ethereum/EIPs/issues/20
183  */
184 contract ERC20 is ERC20Basic {
185   function allowance(address owner, address spender) public view returns (uint256);
186   function transferFrom(address from, address to, uint256 value) public returns (bool);
187   function approve(address spender, uint256 value) public returns (bool);
188   event Approval(address indexed owner, address indexed spender, uint256 value);
189 }
190 
191 /**
192  * @title SafeMath
193  * @dev Math operations with safety checks that throw on error
194  */
195 library SafeMath {
196 
197   /**
198   * @dev Multiplies two numbers, throws on overflow.
199   */
200   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
201     if (a == 0) {
202       return 0;
203     }
204     c = a * b;
205     assert(c / a == b);
206     return c;
207   }
208 
209   /**
210   * @dev Integer division of two numbers, truncating the quotient.
211   */
212   function div(uint256 a, uint256 b) internal pure returns (uint256) {
213     // assert(b > 0); // Solidity automatically throws when dividing by 0
214     // uint256 c = a / b;
215     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
216     return a / b;
217   }
218 
219   /**
220   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
221   */
222   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
223     assert(b <= a);
224     return a - b;
225   }
226 
227   /**
228   * @dev Adds two numbers, throws on overflow.
229   */
230   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
231     c = a + b;
232     assert(c >= a);
233     return c;
234   }
235 }
236 
237 /**
238  * @title Standard ERC20 token
239  *
240  * @dev Implementation of the basic standard token.
241  * @dev https://github.com/ethereum/EIPs/issues/20
242  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
243  */
244 contract StandardToken is ERC20, BasicToken {
245   mapping (address => mapping (address => uint256)) internal allowed;
246   
247   /**
248    * @dev Transfer tokens from one address to another
249    * @param _from address The address which you want to send tokens from
250    * @param _to address The address which you want to transfer to
251    * @param _value uint256 the amount of tokens to be transferred
252    */
253   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
254     require(_to != address(0));
255     require(_value <= balances[_from]);
256     require(_value <= allowed[_from][msg.sender]);
257     require(!blacklist[_from]);
258     require(!blacklist[_to]);
259 	require(!blacklist[msg.sender]);
260 
261     balances[_from] = balances[_from].sub(_value);
262     balances[_to] = balances[_to].add(_value);
263     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
264     emit Transfer(_from, _to, _value);
265     return true;
266   }
267 
268   /**
269    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
270    *
271    * Beware that changing an allowance with this method brings the risk that someone may use both the old
272    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
273    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
274    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
275    * @param _spender The address which will spend the funds.
276    * @param _value The amount of tokens to be spent.
277    */
278   function approve(address _spender, uint256 _value) public returns (bool) {
279     require(!blacklist[_spender]);
280 	require(!blacklist[msg.sender]);
281 
282     allowed[msg.sender][_spender] = _value;
283     emit Approval(msg.sender, _spender, _value);
284     return true;
285   }
286 
287   /**
288    * @dev Function to check the amount of tokens that an owner allowed to a spender.
289    * @param _owner address The address which owns the funds.
290    * @param _spender address The address which will spend the funds.
291    * @return A uint256 specifying the amount of tokens still available for the spender.
292    */
293   function allowance(address _owner, address _spender) public view returns (uint256) {
294     require(!blacklist[_owner]);
295     require(!blacklist[_spender]);
296 	require(!blacklist[msg.sender]);
297 
298     return allowed[_owner][_spender];
299   }
300 }
301 
302 /*
303  * @title Bitcoin Legend Token
304  * @dev Burnable ERC20 standard Token
305  */
306 contract BitcoinLegend is BurnableToken, StandardToken {
307   string public constant name = "BITCOIN LEGEND"; // solium-disable-line uppercase
308   string public constant symbol = "BCL"; // solium-disable-line uppercase
309   uint8 public constant decimals = 18; // solium-disable-line uppercase
310   uint256 public constant INITIAL_SUPPLY = 21000000000 * (10 ** uint256(decimals));
311   mapping (address => mapping (address => uint256)) internal EffectiveDateOfAllowance; // Effective date of Lost-proof, Inheritance
312 
313   /**
314    * @dev Constructor that gives msg.sender all of existing tokens.
315    */
316   constructor() public {
317     totalSupply_ = INITIAL_SUPPLY;
318     balances[msg.sender] = INITIAL_SUPPLY;
319     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
320   }
321 
322   /**
323    * @dev Transfer tokens from one address to another
324    * @param _from address The address which you want to send tokens from
325    * @param _to address The address which you want to transfer to
326    * @param _value uint256 the amount of tokens to be transferred
327    */
328   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
329     require(EffectiveDateOfAllowance[_from][msg.sender] <= block.timestamp); 
330     return super.transferFrom(_from, _to, _value);
331   }
332 
333   /**
334    * @dev Function to check the Effective date of Lost-proof, Inheritance of tokens that an owner allowed to a spender.
335    * @param _owner address The address which owns the funds.
336    * @param _spender address The address which will spend the funds.
337    * @return A uint256 specifying the amount of tokens still available for the spender.
338    */
339   function allowanceEffectiveDate(address _owner, address _spender) public view returns (uint256) {
340     require(!blacklist[_owner]);
341     require(!blacklist[_spender]);
342 	require(!blacklist[msg.sender]);
343 
344     return EffectiveDateOfAllowance[_owner][_spender];
345   }
346 }