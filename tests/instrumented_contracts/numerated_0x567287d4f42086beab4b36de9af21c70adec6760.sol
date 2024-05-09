1 pragma solidity ^0.4.18;
2 
3 // Latino Token - Latinos Unidos Impulsando la CriptoEconomía - latinotoken.com
4 
5 
6 /**
7  * @title ERC20Basic interface
8  * @dev Basic version of ERC20 interface
9  */
10 
11 contract ERC20Basic {
12   uint256 public totalSupply;
13   function balanceOf(address who) constant returns (uint256);
14   function transfer(address to, uint256 value) returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 /**
19  * @title ERC20 interface
20  * @dev Standard version of ERC20 interface
21  */
22 contract ERC20 is ERC20Basic {
23   function allowance(address owner, address spender) constant returns (uint256);
24   function transferFrom(address from, address to, uint256 value) returns (bool);
25   function approve(address spender, uint256 value) returns (bool);
26   event Approval(address indexed owner, address indexed spender, uint256 value);
27 }
28 
29 /**
30  * @title SafeMath
31  * @dev Math operations with safety checks that throw on error
32  */
33 library SafeMath {
34 
35   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
36     uint256 c = a * b;
37     assert(a == 0 || c / a == b);
38     return c;
39   }
40 
41   function div(uint256 a, uint256 b) internal constant returns (uint256) {
42     // assert(b > 0); // Solidity automatically throws when dividing by 0
43     uint256 c = a / b;
44     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45     return c;
46   }
47 
48   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
49     assert(b <= a);
50     return a - b;
51   }
52 
53   function add(uint256 a, uint256 b) internal constant returns (uint256) {
54     uint256 c = a + b;
55     assert(c >= a);
56     return c;
57   }
58 
59   function mod(uint256 a, uint256 b) internal constant returns (uint256) {
60     // assert(b > 0); // Solidity automatically throws when dividing by 0
61     uint256 c = a % b;
62     //uint256 z = a / b;
63     assert(a == (a / b) * b + c); // There is no case in which this doesn't hold
64     return c;
65   }
66 
67 }
68 
69 /**
70  * @title Ownable
71  * @dev The modified Ownable contract has two owner addresses to provide authorization control
72  * functions.
73  */
74 contract Ownable {
75 
76   address public owner;
77   address public ownerManualMinter; 
78 
79   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
80 
81   /**
82    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
83    * account.
84    */
85   function Ownable() {
86     /**
87     * ownerManualMinter contains the eth address of the party allowed to manually mint outside the crowdsale contract
88     * this is setup at construction time 
89     */ 
90 
91     ownerManualMinter = 0x163dE8a97f6B338bb498145536d1178e1A42AF85 ; // To be changed right after contract is deployed
92     owner = msg.sender;
93   }
94 
95   /**
96    * @dev Throws if called by any account other than the owner.
97    */
98   modifier onlyOwner() {
99     require(msg.sender == owner || msg.sender == ownerManualMinter);
100     _;
101   }
102 
103   /**
104    * @dev Allows the current owner to transfer control of the contract to a newOwner.
105    * This shall be invoked with the ICO crowd sale smart contract address once it´s ready
106    * @param newOwner The address to transfer ownership to.
107    */
108   function transferOwnership(address newOwner) onlyOwner public {
109     require(newOwner != address(0));
110     OwnershipTransferred(owner, newOwner);
111     owner = newOwner;
112   }
113 
114 /**
115    * @dev After the manual minting process ends, this shall be invoked passing the ICO crowd sale contract address so that
116    * nobody else will be ever able to mint more tokens
117    * @param newOwner The address to transfer ownership to.
118    */
119   function transferOwnershipManualMinter(address newOwner) onlyOwner public {
120     require(newOwner != address(0));
121     OwnershipTransferred(owner, newOwner);
122     ownerManualMinter = newOwner;
123   }
124 
125 }
126 
127 contract Restrictable is Ownable {
128     
129     address public restrictedAddress;
130     
131     event RestrictedAddressChanged(address indexed restrictedAddress);
132     
133     function Restrictable() {
134         restrictedAddress = address(0);
135     }
136     
137     //that function could be called only ONCE!!! After that nothing could be reverted!!! 
138     function setRestrictedAddress(address _restrictedAddress) onlyOwner public {
139       restrictedAddress = _restrictedAddress;
140       RestrictedAddressChanged(_restrictedAddress);
141       transferOwnership(_restrictedAddress);
142     }
143     
144     modifier notRestricted(address tryTo) {
145         if(tryTo == restrictedAddress) {
146             revert();
147         }
148         _;
149     }
150 }
151 
152 /**
153  * @title ERC20Basic Token
154  * @dev Implementation of the basic token.
155  */
156 
157 contract BasicToken is ERC20Basic, Restrictable {
158 
159   using SafeMath for uint256;
160 
161   mapping(address => uint256) balances;
162   uint256 public constant icoEndDatetime = 1530421200 ; 
163 
164   /**
165   * @dev transfer token for a specified address
166   * @param _to The address to transfer to.
167   * @param _value The amount to be transferred.
168   */
169 
170   function transfer(address _to, uint256 _value) notRestricted(_to) public returns (bool) {
171     require(_to != address(0));
172     
173     // We won´t allow to transfer tokens until the ICO finishes
174     require(now > icoEndDatetime ); 
175 
176     require(_value <= balances[msg.sender]);
177     balances[msg.sender] = balances[msg.sender].sub(_value);
178     balances[_to] = balances[_to].add(_value);
179     Transfer(msg.sender, _to, _value);
180     return true;
181   }
182 
183   /**
184   * @dev Gets the balance of the specified address.
185   * @param _owner The address to query the the balance of.
186   * @return An uint256 representing the amount owned by the passed address.
187   */
188   function balanceOf(address _owner) public constant returns (uint256 balance) {
189     return balances[_owner];
190   }
191 
192 }
193 
194 /**
195  * @title Standard ERC20 Token
196  * @dev Implementation of the standard token.
197  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
198  */
199 contract StandardToken is ERC20, BasicToken {
200 
201   mapping (address => mapping (address => uint256)) internal allowed;
202 
203   /**
204    * @dev Transfer tokens from one address to another
205    * @param _from address The address which you want to send tokens from
206    * @param _to address The address which you want to transfer to
207    * @param _value uint256 the amout of tokens to be transfered
208    */
209   function transferFrom(address _from, address _to, uint256 _value) notRestricted(_to) public returns (bool) {
210     require(_to != address(0));
211     
212     // We won´t allow to transfer tokens until the ICO finishes
213     require(now > icoEndDatetime) ; 
214 
215 
216     require(_value <= balances[_from]);
217     require(_value <= allowed[_from][msg.sender]);
218 
219     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
220     // require (_value <= _allowance);
221 
222     balances[_from] = balances[_from].sub(_value);
223     balances[_to] = balances[_to].add(_value);
224     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
225     Transfer(_from, _to, _value);
226     return true;
227   }
228   
229   function approve(address _spender, uint256 _value) public returns (bool) {
230 
231     // To change the approve amount you first have to reduce the addresses`
232     //  allowance to zero by calling `approve(_spender, 0)` if it is not
233     //  already 0 to mitigate the race condition described here:
234     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
235 
236 
237     allowed[msg.sender][_spender] = _value;
238     Approval(msg.sender, _spender, _value);
239     return true;
240   }
241 
242   /**
243    * @dev Function to check the amount of tokens that an owner allowed to a spender.
244    * @param _owner address The address which owns the funds.
245    * @param _spender address The address which will spend the funds.
246    * @return A uint256 specifing the amount of tokens still available for the spender.
247    */
248   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
249     return allowed[_owner][_spender];
250   }
251 
252  /**
253    * approve should be called when allowed[_spender] == 0. To increment
254    * allowed value is better to use this function to avoid 2 calls (and wait until
255    * the first transaction is mined)
256    * From MonolithDAO Token.sol
257    */
258   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
259     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
260     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
261     return true;
262   }
263 
264   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
265     uint oldValue = allowed[msg.sender][_spender];
266     if (_subtractedValue > oldValue) {
267       allowed[msg.sender][_spender] = 0;
268     } else {
269       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
270     }
271     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
272     return true;
273   }
274 
275 }
276 
277 
278 /**
279  * @title Mintable token
280  * @dev ERC20 Token, with mintable token creation
281  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
282  */
283 contract MintableToken is StandardToken {
284 
285   uint32 public constant decimals = 4;
286   uint256 public constant MAX_SUPPLY = 700000000 * (10 ** uint256(decimals)); // 700MM tokens hard cap
287 
288   event Mint(address indexed to, uint256 amount);
289 
290   /**
291    * @dev Function to mint tokens
292    * @param _to The address that will recieve the minted tokens.
293    * @param _amount The amount of tokens to mint.
294    * @return A boolean that indicates if the operation was successful.
295    */
296 
297   function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
298     uint256 newTotalSupply = totalSupply.add(_amount);
299     require(newTotalSupply <= MAX_SUPPLY); // never ever allows to create more than the hard cap limit
300     totalSupply = totalSupply.add(_amount);
301     balances[_to] = balances[_to].add(_amount);
302     Mint(_to, _amount);
303     Transfer(0x0, _to, _amount);
304     return true;
305   }
306 
307 }
308 
309 contract LATINOToken is MintableToken 
310 {
311   string public constant name = "Latino Token";
312   string public constant symbol = "LATINO";
313 
314  function LATINOToken() { totalSupply = 0 ; } // initializes to 0 the total token supply 
315 }