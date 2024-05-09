1 pragma solidity ^0.4.18;
2 /**
3  * @title ERC20Basic
4  * @dev Simpler version of ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/179
6  */
7 contract ERC20Basic {
8   uint256 public totalSupply;
9   function balanceOf(address who) constant public returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 
14 /**
15  * @title ERC20 interface
16  * @dev see https://github.com/ethereum/EIPs/issues/20
17  */
18 contract ERC20 is ERC20Basic {
19   function allowance(address owner, address spender) public constant  returns (uint256);
20   function transferFrom(address from, address to, uint256 value) public returns (bool);
21   function approve(address spender, uint256 value) public returns (bool);
22   event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 /**
26  * @title SafeMath
27  * @dev Math operations with safety checks that throw on error
28  */
29 library SafeMath {
30     
31   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a * b;
33     assert(a == 0 || c / a == b);
34     return c;
35   }
36 
37   function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     // assert(b > 0); // Solidity automatically throws when dividing by 0
39     uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41     return c;
42   }
43 
44   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45     assert(b <= a);
46     return a - b;
47   }
48 
49   function add(uint256 a, uint256 b) internal pure returns (uint256) {
50     uint256 c = a + b;
51     assert(c >= a);
52     return c;
53   }
54   
55 }
56 
57 /**
58  * @title Basic token
59  * @dev Basic version of StandardToken, with no allowances. 
60  */
61 contract BasicToken is ERC20Basic {
62     
63   using SafeMath for uint256;
64 
65   mapping(address => uint256) balances;
66 
67   /**
68   * @dev transfer token for a specified address
69   * @param _to The address to transfer to.
70   * @param _value The amount to be transferred.
71   */
72   function transfer(address _to, uint256 _value) public returns (bool) {
73     balances[msg.sender] = balances[msg.sender].sub(_value);
74     balances[_to] = balances[_to].add(_value);
75     Transfer(msg.sender, _to, _value);
76     return true;
77   }
78 
79   /**
80   * @dev Gets the balance of the specified address.
81   * @param _owner The address to query the the balance of. 
82   * @return An uint256 representing the amount owned by the passed address.
83   */
84   function balanceOf(address _owner) constant public returns (uint256 balance) {
85     return balances[_owner];
86   }
87 
88 }
89 
90 /**
91  * @title Standard ERC20 token
92  *
93  * @dev Implementation of the basic standard token.
94  * @dev https://github.com/ethereum/EIPs/issues/20
95  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
96  */
97 contract StandardToken is ERC20, BasicToken {
98 
99   mapping (address => mapping (address => uint256)) allowed;
100 
101   /**
102    * @dev Transfer tokens from one address to another
103    * @param _from address The address which you want to send tokens from
104    * @param _to address The address which you want to transfer to
105    * @param _value uint256 the amout of tokens to be transfered
106    */
107   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
108     var _allowance = allowed[_from][msg.sender];
109 
110     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
111     // require (_value <= _allowance);
112 
113     balances[_to] = balances[_to].add(_value);
114     balances[_from] = balances[_from].sub(_value);
115     allowed[_from][msg.sender] = _allowance.sub(_value);
116     Transfer(_from, _to, _value);
117     return true;
118   }
119 
120   /**
121    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
122    * @param _spender The address which will spend the funds.
123    * @param _value The amount of tokens to be spent.
124    */
125   function approve(address _spender, uint256 _value) public returns (bool) {
126 
127     // To change the approve amount you first have to reduce the addresses`
128     //  allowance to zero by calling `approve(_spender, 0)` if it is not
129     //  already 0 to mitigate the race condition described here:
130     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
131     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
132 
133     allowed[msg.sender][_spender] = _value;
134     Approval(msg.sender, _spender, _value);
135     return true;
136   }
137 
138   /**
139    * @dev Function to check the amount of tokens that an owner allowed to a spender.
140    * @param _owner address The address which owns the funds.
141    * @param _spender address The address which will spend the funds.
142    * @return A uint256 specifing the amount of tokens still available for the spender.
143    */
144   function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
145     return allowed[_owner][_spender];
146   }
147 
148 }
149 
150 /**
151  * @title Ownable
152  * @dev The Ownable contract has an owner address, and provides basic authorization control
153  * functions, this simplifies the implementation of "user permissions".
154  */
155 contract Ownable {
156     
157   address public owner;
158 
159   /**
160    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
161    * account.
162    */
163   function Ownable() public{
164     owner = msg.sender;
165   }
166 
167   /**
168    * @dev Throws if called by any account other than the owner.
169    */
170   modifier onlyOwner() {
171     require(msg.sender == owner);
172     _;
173   }
174 
175   /**
176    * @dev Allows the current owner to transfer control of the contract to a newOwner.
177    * @param newOwner The address to transfer ownership to.
178    */
179   function transferOwnership(address newOwner) public onlyOwner {
180     require(newOwner != address(0));      
181     owner = newOwner;
182   }
183 
184 }
185 
186 /**
187  * @title Mintable token
188  * @dev Simple ERC20 Token example, with mintable token creation
189  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
190  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
191  */
192 
193 contract MintableToken is StandardToken, Ownable {
194     
195   event Mint(address indexed to, uint256 amount);
196   
197   event MintFinished();
198 
199   bool public mintingFinished = false;
200 
201   modifier canMint() {
202     require(!mintingFinished);
203     _;
204   }
205 
206   /**
207    * @dev Function to mint tokens
208    * @param _to The address that will recieve the minted tokens.
209    * @param _amount The amount of tokens to mint.
210    * @return A boolean that indicates if the operation was successful.
211    */
212   function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
213     totalSupply = totalSupply.add(_amount);
214     balances[_to] = balances[_to].add(_amount);
215     Mint(_to, _amount);
216     return true;
217   }
218 
219   /**
220    * @dev Function to stop minting new tokens.
221    * @return True if the operation was successful.
222    */
223   function finishMinting() onlyOwner public returns (bool) {
224     mintingFinished = true;
225     MintFinished();
226     return true;
227   }
228   
229 }
230 
231 contract TokenTokenCoin is MintableToken {
232     
233     string public constant name = "South Park Token Token";
234     
235     string public constant symbol = "SPTKN";
236     
237     uint32 public constant decimals = 18;
238     
239 }
240 
241 
242 contract Crowdsale is Ownable {
243     
244     using SafeMath for uint;
245     
246     address multisig;
247 
248     uint restrictedPercent;
249 
250     address restricted;
251 
252     TokenTokenCoin public token = new TokenTokenCoin();
253 
254     uint start;
255     
256     uint period;
257 
258     uint hardcap;
259 
260     uint rate;
261 
262     function Crowdsale() public {
263         multisig = 0x270A26Ef971a68B9b77d3104c328932ddBd8366a;
264         restricted = 0x188a11a676B5D3D4f39b865F8D88d27CdFa2Af59;
265         restrictedPercent = 20;
266         rate = 100000000000000000000;
267         start = 1518220800;
268         period = 60;
269         hardcap = 1000000000000000000000000;
270                   
271     }
272 
273     modifier saleIsOn() {
274     	require(now > start && now < start + period * 1 days);
275     	_;
276     }
277 	
278     modifier isUnderHardCap() {
279         require(multisig.balance <= hardcap);
280         _;
281     }
282 
283     function finishMinting() public onlyOwner {
284         uint issuedTokenSupply = token.totalSupply();
285         uint restrictedTokens = issuedTokenSupply.mul(restrictedPercent).div(100 - restrictedPercent);
286         token.mint(restricted, restrictedTokens);
287         token.finishMinting();
288     }
289 
290     function createTokens() public isUnderHardCap saleIsOn payable {
291         multisig.transfer(msg.value);
292         uint tokens = rate.mul(msg.value).div(1 ether);
293         token.mint(msg.sender, tokens);
294     }
295 
296     function() external payable {
297         createTokens();
298     }
299     
300 }