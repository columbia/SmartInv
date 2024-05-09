1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic interface
5  * @dev Basic version of ERC20 interface
6  */
7 
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) constant returns (uint256);
11   function transfer(address to, uint256 value) returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev Standard version of ERC20 interface
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) constant returns (uint256);
21   function transferFrom(address from, address to, uint256 value) returns (bool);
22   function approve(address spender, uint256 value) returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31 
32   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
33     uint256 c = a * b;
34     assert(a == 0 || c / a == b);
35     return c;
36   }
37 
38   function div(uint256 a, uint256 b) internal constant returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return c;
43   }
44 
45   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
46     assert(b <= a);
47     return a - b;
48   }
49 
50   function add(uint256 a, uint256 b) internal constant returns (uint256) {
51     uint256 c = a + b;
52     assert(c >= a);
53     return c;
54   }
55 
56   function mod(uint256 a, uint256 b) internal constant returns (uint256) {
57     // assert(b > 0); // Solidity automatically throws when dividing by 0
58     uint256 c = a % b;
59     //uint256 z = a / b;
60     assert(a == (a / b) * b + c); // There is no case in which this doesn't hold
61     return c;
62   }
63 
64 }
65 
66 /**
67  * @title Ownable
68  * @dev The modified Ownable contract has two owner addresses to provide authorization control
69  * functions.
70  */
71 contract Ownable {
72 
73   address public owner;
74   address public ownerManualMinter; 
75 
76   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
77 
78   /**
79    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
80    * account.
81    */
82   function Ownable() {
83     /**
84     * ownerManualMinter contains the eth address of the party allowed to manually mint outside the crowdsale contract
85     * this is setup at construction time 
86     */ 
87 
88     ownerManualMinter = 0x163dE8a97f6B338bb498145536d1178e1A42AF85 ; // To be changed right after contract is deployed
89     owner = msg.sender;
90   }
91 
92   /**
93    * @dev Throws if called by any account other than the owner.
94    */
95   modifier onlyOwner() {
96     require(msg.sender == owner || msg.sender == ownerManualMinter);
97     _;
98   }
99 
100   /**
101    * @dev Allows the current owner to transfer control of the contract to a newOwner.
102    * This shall be invoked with the ICO crowd sale smart contract address once it´s ready
103    * @param newOwner The address to transfer ownership to.
104    */
105   function transferOwnership(address newOwner) onlyOwner public {
106     require(newOwner != address(0));
107     OwnershipTransferred(owner, newOwner);
108     owner = newOwner;
109   }
110 
111 /**
112    * @dev After the manual minting process ends, this shall be invoked passing the ICO crowd sale contract address so that
113    * nobody else will be ever able to mint more tokens
114    * @param newOwner The address to transfer ownership to.
115    */
116   function transferOwnershipManualMinter(address newOwner) onlyOwner public {
117     require(newOwner != address(0));
118     OwnershipTransferred(owner, newOwner);
119     ownerManualMinter = newOwner;
120   }
121 
122 }
123 
124 contract Restrictable is Ownable {
125     
126     address public restrictedAddress;
127     
128     event RestrictedAddressChanged(address indexed restrictedAddress);
129     
130     function Restrictable() {
131         restrictedAddress = address(0);
132     }
133     
134     //that function could be called only ONCE!!! After that nothing could be reverted!!! 
135     function setRestrictedAddress(address _restrictedAddress) onlyOwner public {
136       restrictedAddress = _restrictedAddress;
137       RestrictedAddressChanged(_restrictedAddress);
138       transferOwnership(_restrictedAddress);
139     }
140     
141     modifier notRestricted(address tryTo) {
142         if(tryTo == restrictedAddress) {
143             revert();
144         }
145         _;
146     }
147 }
148 
149 /**
150  * @title ERC20Basic Token
151  * @dev Implementation of the basic token.
152  */
153 
154 contract BasicToken is ERC20Basic, Restrictable {
155 
156   using SafeMath for uint256;
157 
158   mapping(address => uint256) balances;
159   uint256 public constant icoEndDatetime = 1530421200 ; 
160 
161   /**
162   * @dev transfer token for a specified address
163   * @param _to The address to transfer to.
164   * @param _value The amount to be transferred.
165   */
166 
167   function transfer(address _to, uint256 _value) notRestricted(_to) public returns (bool) {
168     require(_to != address(0));
169     
170     // We won´t allow to transfer tokens until the ICO finishes
171     require(now > icoEndDatetime ); 
172 
173     require(_value <= balances[msg.sender]);
174     balances[msg.sender] = balances[msg.sender].sub(_value);
175     balances[_to] = balances[_to].add(_value);
176     Transfer(msg.sender, _to, _value);
177     return true;
178   }
179 
180   /**
181   * @dev Gets the balance of the specified address.
182   * @param _owner The address to query the the balance of.
183   * @return An uint256 representing the amount owned by the passed address.
184   */
185   function balanceOf(address _owner) public constant returns (uint256 balance) {
186     return balances[_owner];
187   }
188 
189 }
190 
191 /**
192  * @title Standard ERC20 Token
193  * @dev Implementation of the standard token.
194  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
195  */
196 contract StandardToken is ERC20, BasicToken {
197 
198   mapping (address => mapping (address => uint256)) internal allowed;
199 
200   /**
201    * @dev Transfer tokens from one address to another
202    * @param _from address The address which you want to send tokens from
203    * @param _to address The address which you want to transfer to
204    * @param _value uint256 the amout of tokens to be transfered
205    */
206   function transferFrom(address _from, address _to, uint256 _value) notRestricted(_to) public returns (bool) {
207     require(_to != address(0));
208     
209     // We won´t allow to transfer tokens until the ICO finishes
210     require(now > icoEndDatetime) ; 
211 
212 
213     require(_value <= balances[_from]);
214     require(_value <= allowed[_from][msg.sender]);
215 
216     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
217     // require (_value <= _allowance);
218 
219     balances[_from] = balances[_from].sub(_value);
220     balances[_to] = balances[_to].add(_value);
221     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
222     Transfer(_from, _to, _value);
223     return true;
224   }
225   
226   function approve(address _spender, uint256 _value) public returns (bool) {
227 
228     // To change the approve amount you first have to reduce the addresses`
229     //  allowance to zero by calling `approve(_spender, 0)` if it is not
230     //  already 0 to mitigate the race condition described here:
231     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
232 
233 
234     allowed[msg.sender][_spender] = _value;
235     Approval(msg.sender, _spender, _value);
236     return true;
237   }
238 
239   /**
240    * @dev Function to check the amount of tokens that an owner allowed to a spender.
241    * @param _owner address The address which owns the funds.
242    * @param _spender address The address which will spend the funds.
243    * @return A uint256 specifing the amount of tokens still available for the spender.
244    */
245   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
246     return allowed[_owner][_spender];
247   }
248 
249  /**
250    * approve should be called when allowed[_spender] == 0. To increment
251    * allowed value is better to use this function to avoid 2 calls (and wait until
252    * the first transaction is mined)
253    * From MonolithDAO Token.sol
254    */
255   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
256     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
257     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
258     return true;
259   }
260 
261   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
262     uint oldValue = allowed[msg.sender][_spender];
263     if (_subtractedValue > oldValue) {
264       allowed[msg.sender][_spender] = 0;
265     } else {
266       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
267     }
268     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
269     return true;
270   }
271 
272 }
273 
274 
275 /**
276  * @title Mintable token
277  * @dev ERC20 Token, with mintable token creation
278  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
279  */
280 contract MintableToken is StandardToken {
281 
282   uint32 public constant decimals = 4;
283   uint256 public constant MAX_SUPPLY = 700000000 * (10 ** uint256(decimals)); // 700MM tokens hard cap
284 
285   event Mint(address indexed to, uint256 amount);
286 
287   /**
288    * @dev Function to mint tokens
289    * @param _to The address that will recieve the minted tokens.
290    * @param _amount The amount of tokens to mint.
291    * @return A boolean that indicates if the operation was successful.
292    */
293 
294   function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
295     uint256 newTotalSupply = totalSupply.add(_amount);
296     require(newTotalSupply <= MAX_SUPPLY); // never ever allows to create more than the hard cap limit
297     totalSupply = totalSupply.add(_amount);
298     balances[_to] = balances[_to].add(_amount);
299     Mint(_to, _amount);
300     Transfer(0x0, _to, _amount);
301     return true;
302   }
303 
304 }
305 
306 contract LAFIN is MintableToken 
307 {
308   string public constant name = "LAFIN";
309   string public constant symbol = "LAFIN";
310 
311  function LAFIN() { totalSupply = 0 ; } // initializes to 0 the total token supply 
312 }