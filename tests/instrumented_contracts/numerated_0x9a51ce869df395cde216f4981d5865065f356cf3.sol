1 pragma solidity ^0.4.18;
2 
3 // Test contract with timelock support is deployed at https://kovan.etherscan.io/address/0x40a94e42d9d64aa6542f10ecb53345075faad546
4 // Future date to unlock transfer of tokens for this test contract is June 1st. 2018 2018 00:00AM GMT
5 // unix epoch time == 1527811200
6 
7 
8 /**
9  * @title ERC20Basic interface
10  * @dev Basic version of ERC20 interface
11  */
12 
13 contract ERC20Basic {
14   uint256 public totalSupply;
15   function balanceOf(address who) constant returns (uint256);
16   function transfer(address to, uint256 value) returns (bool);
17   event Transfer(address indexed from, address indexed to, uint256 value);
18 }
19 
20 /**
21  * @title ERC20 interface
22  * @dev Standard version of ERC20 interface
23  */
24 contract ERC20 is ERC20Basic {
25   function allowance(address owner, address spender) constant returns (uint256);
26   function transferFrom(address from, address to, uint256 value) returns (bool);
27   function approve(address spender, uint256 value) returns (bool);
28   event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 /**
32  * @title SafeMath
33  * @dev Math operations with safety checks that throw on error
34  */
35 library SafeMath {
36 
37   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
38     uint256 c = a * b;
39     assert(a == 0 || c / a == b);
40     return c;
41   }
42 
43   function div(uint256 a, uint256 b) internal constant returns (uint256) {
44     // assert(b > 0); // Solidity automatically throws when dividing by 0
45     uint256 c = a / b;
46     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47     return c;
48   }
49 
50   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   function add(uint256 a, uint256 b) internal constant returns (uint256) {
56     uint256 c = a + b;
57     assert(c >= a);
58     return c;
59   }
60 
61   function mod(uint256 a, uint256 b) internal constant returns (uint256) {
62     // assert(b > 0); // Solidity automatically throws when dividing by 0
63     uint256 c = a % b;
64     //uint256 z = a / b;
65     assert(a == (a / b) * b + c); // There is no case in which this doesn't hold
66     return c;
67   }
68 
69 }
70 
71 /**
72  * @title Ownable
73  * @dev The modified Ownable contract has two owner addresses to provide authorization control
74  * functions.
75  */
76 contract Ownable {
77 
78   address public owner;
79   address public ownerManualMinter; 
80 
81   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
82 
83   /**
84    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
85    * account.
86    */
87   function Ownable() {
88     /**
89     * ownerManualMinter contains the eth address of the party allowed to manually mint outside the crowdsale contract
90     * this is setup at construction time 
91     */ 
92 
93     ownerManualMinter = 0xd97c302e9b5ee38ab900d3a07164c2ad43ffc044 ; // To be changed right after contract is deployed
94     owner = msg.sender;
95   }
96 
97   /**
98    * @dev Throws if called by any account other than the owner.
99    */
100   modifier onlyOwner() {
101     require(msg.sender == owner || msg.sender == ownerManualMinter);
102     _;
103   }
104 
105   /**
106    * @dev Allows the current owner to transfer control of the contract to a newOwner.
107    * This shall be invoked with the ICO crowd sale smart contract address once it´s ready
108    * @param newOwner The address to transfer ownership to.
109    */
110   function transferOwnership(address newOwner) onlyOwner public {
111     require(newOwner != address(0));
112     OwnershipTransferred(owner, newOwner);
113     owner = newOwner;
114   }
115 
116 /**
117    * @dev After the manual minting process ends, this shall be invoked passing the ICO crowd sale contract address so that
118    * nobody else will be ever able to mint more tokens
119    * @param newOwner The address to transfer ownership to.
120    */
121   function transferOwnershipManualMinter(address newOwner) onlyOwner public {
122     require(newOwner != address(0));
123     OwnershipTransferred(owner, newOwner);
124     ownerManualMinter = newOwner;
125   }
126 
127 }
128 
129 contract Restrictable is Ownable {
130     
131     address public restrictedAddress;
132     
133     event RestrictedAddressChanged(address indexed restrictedAddress);
134     
135     function Restrictable() {
136         restrictedAddress = address(0);
137     }
138     
139     //that function could be called only ONCE!!! After that nothing could be reverted!!! 
140     function setRestrictedAddress(address _restrictedAddress) onlyOwner public {
141       restrictedAddress = _restrictedAddress;
142       RestrictedAddressChanged(_restrictedAddress);
143       transferOwnership(_restrictedAddress);
144     }
145     
146     modifier notRestricted(address tryTo) {
147         if(tryTo == restrictedAddress) {
148             revert();
149         }
150         _;
151     }
152 }
153 
154 /**
155  * @title ERC20Basic Token
156  * @dev Implementation of the basic token.
157  */
158 
159 contract BasicToken is ERC20Basic, Restrictable {
160 
161   using SafeMath for uint256;
162 
163   mapping(address => uint256) balances;
164   uint256 public constant icoEndDatetime = 1520978217 ; 
165 
166   /**
167   * @dev transfer token for a specified address
168   * @param _to The address to transfer to.
169   * @param _value The amount to be transferred.
170   */
171 
172   function transfer(address _to, uint256 _value) notRestricted(_to) public returns (bool) {
173     require(_to != address(0));
174     
175     // We won´t allow to transfer tokens until the ICO finishes
176     require(now > icoEndDatetime ); 
177 
178     require(_value <= balances[msg.sender]);
179     balances[msg.sender] = balances[msg.sender].sub(_value);
180     balances[_to] = balances[_to].add(_value);
181     Transfer(msg.sender, _to, _value);
182     return true;
183   }
184 
185   /**
186   * @dev Gets the balance of the specified address.
187   * @param _owner The address to query the the balance of.
188   * @return An uint256 representing the amount owned by the passed address.
189   */
190   function balanceOf(address _owner) public constant returns (uint256 balance) {
191     return balances[_owner];
192   }
193 
194 }
195 
196 /**
197  * @title Standard ERC20 Token
198  * @dev Implementation of the standard token.
199  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
200  */
201 contract StandardToken is ERC20, BasicToken {
202 
203   mapping (address => mapping (address => uint256)) internal allowed;
204 
205   /**
206    * @dev Transfer tokens from one address to another
207    * @param _from address The address which you want to send tokens from
208    * @param _to address The address which you want to transfer to
209    * @param _value uint256 the amout of tokens to be transfered
210    */
211   function transferFrom(address _from, address _to, uint256 _value) notRestricted(_to) public returns (bool) {
212     require(_to != address(0));
213     
214     // We won´t allow to transfer tokens until the ICO finishes
215     require(now > icoEndDatetime) ; 
216 
217 
218     require(_value <= balances[_from]);
219     require(_value <= allowed[_from][msg.sender]);
220 
221     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
222     // require (_value <= _allowance);
223 
224     balances[_from] = balances[_from].sub(_value);
225     balances[_to] = balances[_to].add(_value);
226     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
227     Transfer(_from, _to, _value);
228     return true;
229   }
230   
231   function approve(address _spender, uint256 _value) public returns (bool) {
232 
233     // To change the approve amount you first have to reduce the addresses`
234     //  allowance to zero by calling `approve(_spender, 0)` if it is not
235     //  already 0 to mitigate the race condition described here:
236     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
237 
238 
239     allowed[msg.sender][_spender] = _value;
240     Approval(msg.sender, _spender, _value);
241     return true;
242   }
243 
244   /**
245    * @dev Function to check the amount of tokens that an owner allowed to a spender.
246    * @param _owner address The address which owns the funds.
247    * @param _spender address The address which will spend the funds.
248    * @return A uint256 specifing the amount of tokens still available for the spender.
249    */
250   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
251     return allowed[_owner][_spender];
252   }
253 
254  /**
255    * approve should be called when allowed[_spender] == 0. To increment
256    * allowed value is better to use this function to avoid 2 calls (and wait until
257    * the first transaction is mined)
258    * From MonolithDAO Token.sol
259    */
260   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
261     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
262     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
263     return true;
264   }
265 
266   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
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
279 
280 /**
281  * @title Mintable token
282  * @dev ERC20 Token, with mintable token creation
283  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
284  */
285 contract MintableToken is StandardToken {
286 
287   uint32 public constant decimals = 4;
288   uint256 public constant MAX_SUPPLY = 700000000 * (10 ** uint256(decimals)); // 700MM tokens hard cap
289 
290   event Mint(address indexed to, uint256 amount);
291 
292   /**
293    * @dev Function to mint tokens
294    * @param _to The address that will recieve the minted tokens.
295    * @param _amount The amount of tokens to mint.
296    * @return A boolean that indicates if the operation was successful.
297    */
298 
299   function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
300     uint256 newTotalSupply = totalSupply.add(_amount);
301     require(newTotalSupply <= MAX_SUPPLY); // never ever allows to create more than the hard cap limit
302     totalSupply = totalSupply.add(_amount);
303     balances[_to] = balances[_to].add(_amount);
304     Mint(_to, _amount);
305     Transfer(0x0, _to, _amount);
306     return true;
307   }
308 
309 }
310 
311 contract LAFINAL3 is MintableToken 
312 {
313   string public constant name = "LAFINAL2";
314   string public constant symbol = "LAFINAL2";
315 
316  function LAFINAL3() { totalSupply = 0 ; } // initializes to 0 the total token supply 
317 }