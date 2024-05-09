1 pragma solidity ^0.4.12;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39   uint256 public totalSupply;
40   function balanceOf(address who) constant returns (uint256);
41   function transfer(address to, uint256 value) returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 /**
46  * @title ERC20 interface
47  * @dev see https://github.com/ethereum/EIPs/issues/20
48  */
49 contract ERC20 is ERC20Basic {
50   function allowance(address owner, address spender) constant returns (uint256);
51   function transferFrom(address from, address to, uint256 value) returns (bool);
52   function approve(address spender, uint256 value) returns (bool);
53   event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 /**
57  * @title Ownable
58  * @dev The Ownable contract has an owner address, and provides basic authorization control
59  * functions, this simplifies the implementation of "user permissions".
60  */
61 contract Ownable {
62   address public owner;
63 
64 
65   /**
66    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
67    * account.
68    */
69   function Ownable() {
70     owner = msg.sender;
71   }
72 
73 
74   /**
75    * @dev Throws if called by any account other than the owner.
76    */
77   modifier onlyOwner() {
78     require(msg.sender == owner);
79     _;
80   }
81 
82 
83   /**
84    * @dev Allows the current owner to transfer control of the contract to a newOwner.
85    * @param newOwner The address to transfer ownership to.
86    */
87   function transferOwnership(address newOwner) onlyOwner {
88     require(newOwner != address(0));      
89     owner = newOwner;
90   }
91 
92 }
93 
94 /** 
95  * @title Contracts that should not own Contracts
96  * @author Remco Bloemen <remco@2π.com>
97  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
98  * of this contract to reclaim ownership of the contracts.
99  */
100 contract HasNoContracts is Ownable {
101 
102   /**
103    * @dev Reclaim ownership of Ownable contracts
104    * @param contractAddr The address of the Ownable to be reclaimed.
105    */
106   function reclaimContract(address contractAddr) external onlyOwner {
107     Ownable contractInst = Ownable(contractAddr);
108     contractInst.transferOwnership(owner);
109   }
110 }
111 
112 /**
113  * @title Contracts that should not own Tokens
114  * @author Remco Bloemen <remco@2π.com>
115  * @dev This blocks incoming ERC23 tokens to prevent accidental loss of tokens.
116  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
117  * owner to reclaim the tokens.
118  */
119 contract HasNoTokens is Ownable {
120 
121  /**
122   * @dev Reject all ERC23 compatible tokens
123   * @param from_ address The address that is transferring the tokens
124   * @param value_ uint256 the amount of the specified token
125   * @param data_ Bytes The data passed from the caller.
126   */
127   function tokenFallback(address from_, uint256 value_, bytes data_) external {
128     revert();
129   }
130 
131   /**
132    * @dev Reclaim all ERC20Basic compatible tokens
133    * @param tokenAddr address The address of the token contract
134    */
135   function reclaimToken(address tokenAddr) external onlyOwner {
136     ERC20Basic tokenInst = ERC20Basic(tokenAddr);
137     uint256 balance = tokenInst.balanceOf(this);
138     tokenInst.transfer(owner, balance);
139   }
140 }
141 
142 
143 
144 /**
145  * @title Basic token
146  * @dev Basic version of StandardToken, with no allowances. 
147  */
148 contract BasicToken is ERC20Basic {
149   using SafeMath for uint256;
150 
151   mapping(address => uint256) balances;
152 
153   /**
154   * @dev transfer token for a specified address
155   * @param _to The address to transfer to.
156   * @param _value The amount to be transferred.
157   */
158   function transfer(address _to, uint256 _value) returns (bool) {
159     balances[msg.sender] = balances[msg.sender].sub(_value);
160     balances[_to] = balances[_to].add(_value);
161     Transfer(msg.sender, _to, _value);
162     return true;
163   }
164 
165   /**
166   * @dev Gets the balance of the specified address.
167   * @param _owner The address to query the the balance of. 
168   * @return An uint256 representing the amount owned by the passed address.
169   */
170   function balanceOf(address _owner) constant returns (uint256 balance) {
171     return balances[_owner];
172   }
173 
174 }
175 
176 /**
177  * @title Standard ERC20 token
178  *
179  * @dev Implementation of the basic standard token.
180  * @dev https://github.com/ethereum/EIPs/issues/20
181  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
182  */
183 contract StandardToken is ERC20, BasicToken {
184 
185   mapping (address => mapping (address => uint256)) allowed;
186 
187 
188   /**
189    * @dev Transfer tokens from one address to another
190    * @param _from address The address which you want to send tokens from
191    * @param _to address The address which you want to transfer to
192    * @param _value uint256 the amout of tokens to be transfered
193    */
194   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
195     var _allowance = allowed[_from][msg.sender];
196 
197     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
198     // require (_value <= _allowance);
199 
200     balances[_to] = balances[_to].add(_value);
201     balances[_from] = balances[_from].sub(_value);
202     allowed[_from][msg.sender] = _allowance.sub(_value);
203     Transfer(_from, _to, _value);
204     return true;
205   }
206 
207   /**
208    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
209    * @param _spender The address which will spend the funds.
210    * @param _value The amount of tokens to be spent.
211    */
212   function approve(address _spender, uint256 _value) returns (bool) {
213 
214     // To change the approve amount you first have to reduce the addresses`
215     //  allowance to zero by calling `approve(_spender, 0)` if it is not
216     //  already 0 to mitigate the race condition described here:
217     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
218     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
219 
220     allowed[msg.sender][_spender] = _value;
221     Approval(msg.sender, _spender, _value);
222     return true;
223   }
224 
225   /**
226    * @dev Function to check the amount of tokens that an owner allowed to a spender.
227    * @param _owner address The address which owns the funds.
228    * @param _spender address The address which will spend the funds.
229    * @return A uint256 specifing the amount of tokens still available for the spender.
230    */
231   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
232     return allowed[_owner][_spender];
233   }
234 
235 }
236 
237 /**
238  * @title Mintable token
239  * @dev Simple ERC20 Token example, with mintable token creation
240  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
241  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
242  */
243 
244 contract MintableToken is StandardToken, Ownable {
245   event Mint(address indexed to, uint256 amount);
246   event MintFinished();
247 
248   bool public mintingFinished = false;
249 
250 
251   modifier canMint() {
252     require(!mintingFinished);
253     _;
254   }
255 
256   /**
257    * @dev Function to mint tokens
258    * @param _to The address that will recieve the minted tokens.
259    * @param _amount The amount of tokens to mint.
260    * @return A boolean that indicates if the operation was successful.
261    */
262   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
263     totalSupply = totalSupply.add(_amount);
264     balances[_to] = balances[_to].add(_amount);
265     Mint(_to, _amount);
266     Transfer(0x0, _to, _amount);
267     return true;
268   }
269 
270   /**
271    * @dev Function to stop minting new tokens.
272    * @return True if the operation was successful.
273    */
274   function finishMinting() onlyOwner returns (bool) {
275     mintingFinished = true;
276     MintFinished();
277     return true;
278   }
279 }
280 
281 
282 /**
283  * @title Draft token
284  */
285 contract DraftToken is MintableToken, HasNoContracts, HasNoTokens { //MintableToken is StandardToken, Ownable
286     using SafeMath for uint256;
287 
288     string public name = "Draft";
289     string public symbol = "DFS";
290     uint256 public decimals = 18;
291 
292 }