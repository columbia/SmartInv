1 pragma solidity ^0.4.11;
2 
3 /**
4  *================ 
5  * Avalon tokens =
6  *================
7  *
8  * Please be careful before trusting a contract. Counter-ways may exist. To ensure that the contract is genuine, 
9  * check that the address of the contract is the one that these authors have made public. 
10  * Please refer only to the websites you trust. It can be:
11  * - https://avalon.nu/CertificateOfAuthenticitity
12  * - https://www.facebook.com/avalonplatform/
13  * - https://github.com/AvalonPlatform/AvalonToken
14  * - Use the token search engine of etherscan.io and make sure you have the green check mark (token verified)
15  */
16 
17 /**
18  * @title SafeMath
19  * @dev Math operations with safety checks that throw on error
20  */
21 library SafeMath {
22   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a * b;
24     assert(a == 0 || c / a == b);
25     return c;
26   }
27 
28   function div(uint256 a, uint256 b) internal constant returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return c;
33   }
34 
35   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function add(uint256 a, uint256 b) internal constant returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 
48 /**
49  * @title ERC20Basic
50  * @dev Simpler version of ERC20 interface
51  * @dev see https://github.com/ethereum/EIPs/issues/179
52  */
53 contract ERC20Basic {
54 
55   uint256 public totalSupply;
56 
57   function balanceOf(address who) constant returns (uint256);
58   function transfer(address to, uint256 value) returns (bool);
59   event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 
63 
64 /**
65  * @title Basic token
66  * @dev Basic version of StandardToken, with no allowances. 
67  */
68 contract BasicToken is ERC20Basic {
69   using SafeMath for uint256;
70 
71   mapping(address => uint256) balances;
72 
73   /**
74   * @dev transfer token for a specified address
75   * @param _to The address to transfer to.
76   * @param _value The amount to be transferred.
77   */
78   function transfer(address _to, uint256 _value) returns (bool) {
79     balances[msg.sender] = balances[msg.sender].sub(_value);
80     balances[_to] = balances[_to].add(_value);
81     Transfer(msg.sender, _to, _value);
82     return true;
83   }
84 
85   /**
86   * @dev Gets the balance of the specified address.
87   * @param _owner The address to query the the balance of. 
88   * @return An uint256 representing the amount owned by the passed address.
89   */
90   function balanceOf(address _owner) constant returns (uint256 balance) {
91     return balances[_owner];
92   }
93 
94 }
95 
96 
97 
98 /**
99  * @title ERC20 interface
100  * @dev see https://github.com/ethereum/EIPs/issues/20
101  */
102 contract ERC20 is ERC20Basic {
103   function allowance(address owner, address spender) constant returns (uint256);
104   function transferFrom(address from, address to, uint256 value) returns (bool);
105   function approve(address spender, uint256 value) returns (bool);
106   event Approval(address indexed owner, address indexed spender, uint256 value);
107 }
108 
109 
110 /**
111  * @title Standard ERC20 token
112  *
113  * @dev Implementation of the basic standard token.
114  * @dev https://github.com/ethereum/EIPs/issues/20
115  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
116  */
117 contract StandardToken is ERC20, BasicToken {
118 
119   mapping (address => mapping (address => uint256)) allowed;
120 
121 
122   /**
123    * @dev Transfer tokens from one address to another
124    * @param _from address The address which you want to send tokens from
125    * @param _to address The address which you want to transfer to
126    * @param _value uint256 the amout of tokens to be transfered
127    */
128   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
129     var _allowance = allowed[_from][msg.sender];
130 
131     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
132     // require (_value <= _allowance);
133 
134     balances[_to] = balances[_to].add(_value);
135     balances[_from] = balances[_from].sub(_value);
136     allowed[_from][msg.sender] = _allowance.sub(_value);
137     Transfer(_from, _to, _value);
138     return true;
139   }
140 
141   /**
142    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
143    * @param _spender The address which will spend the funds.
144    * @param _value The amount of tokens to be spent.
145    */
146   function approve(address _spender, uint256 _value) returns (bool) {
147 
148     // To change the approve amount you first have to reduce the addresses`
149     //  allowance to zero by calling `approve(_spender, 0)` if it is not
150     //  already 0 to mitigate the race condition described here:
151     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
152     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
153 
154     allowed[msg.sender][_spender] = _value;
155     Approval(msg.sender, _spender, _value);
156     return true;
157   }
158 
159   /**
160    * @dev Function to check the amount of tokens that an owner allowed to a spender.
161    * @param _owner address The address which owns the funds.
162    * @param _spender address The address which will spend the funds.
163    * @return A uint256 specifing the amount of tokens still available for the spender.
164    */
165   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
166     return allowed[_owner][_spender];
167   }
168 
169 }
170 
171 
172 /**
173  * @title Ownable
174  * @dev The Ownable contract has an owner address, and provides basic authorization control
175  * functions, this simplifies the implementation of "user permissions".
176  */
177 contract Ownable {
178   address public owner;
179 
180 
181   /**
182    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
183    * account.
184    */
185   function Ownable() {
186     owner = msg.sender;
187   }
188 
189 
190   /**
191    * @dev Throws if called by any account other than the owner.
192    */
193   modifier onlyOwner() {
194     require(msg.sender == owner);
195     _;
196   }
197 
198 
199   /**
200    * @dev Allows the current owner to transfer control of the contract to a newOwner.
201    * @param newOwner The address to transfer ownership to.
202    */
203   function transferOwnership(address newOwner) onlyOwner {
204     require(newOwner != address(0));      
205     owner = newOwner;
206   }
207 
208 }
209 
210 
211 
212 
213 /**
214  * @title Mintable token
215  * @dev Simple ERC20 Token example, with mintable token creation
216  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
217  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
218  */
219 
220 contract MintableToken is StandardToken, Ownable {
221   event Mint(address indexed to, uint256 amount);
222   event MintFinished();
223 
224   bool public mintingFinished = false;
225   uint256 public tokenCapped = 0;  //Limit number of tokens created
226 
227 
228   modifier canMint() {
229     require(!mintingFinished);
230     _;
231   }
232 
233   /**
234    * @dev Function to mint tokens
235    * @param _to The address that will recieve the minted tokens.
236    * @param _amount The amount of tokens to mint.
237    * @return A boolean that indicates if the operation was successful.
238    */
239  
240   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
241     require(totalSupply.add(_amount) <= tokenCapped);
242     totalSupply = totalSupply.add(_amount);
243     balances[_to] = balances[_to].add(_amount);
244     Mint(_to, _amount);
245     return true;
246   }
247 
248   /**
249    * @dev Function to stop minting new tokens.
250    * @return True if the operation was successful.
251    */
252   function finishMinting() onlyOwner returns (bool) {
253     mintingFinished = true;
254     MintFinished();
255     return true;
256   }
257 }
258 
259 
260 /**
261  * Avalon tokens
262  */
263 contract AvalonToken is MintableToken {
264   string public constant name = "Avalon";
265   string public constant symbol = "AVA";
266   uint public constant decimals = 4;
267  
268   function AvalonToken() {
269      tokenCapped = 100000000000; // Capped to 10 million of tokens 
270 
271      // The minting is entirely carried out in this constructor function.
272 
273      // 8,700,000 AVA are sent to TokenLot for distribution
274      mint(0x993ca291697eb994e17a1f0dbe9053d57b8aec8e,87000000000);
275 
276      // 1,300,000 AVA are kept by Avalon (= 65,000 * 20)
277      mint(0x94325b00aeebdac34373ee7e15f899d51a17af42,650000000);
278      mint(0x6720919702089684870d4afd0f5175c77f82c051,650000000);
279      mint(0x77c3ff7ee29896943fd99d0339a67bae5762234c,650000000);
280      mint(0x66585aafe1dcf5c4a382f55551a8efbb93b023b3,650000000);
281      mint(0x13adbcbaf8da7f85fc3c7fd2e4e08bc6afcb59f3,650000000);
282      mint(0x2f7444f6bdbc5ff4adc310e08ed8e2d288cbf81f,650000000);
283      mint(0xb88f5ae2d3afcc057359a678d745fb6e7d9d4567,650000000);
284      mint(0x21df7143f56e71c2c49c7ecc585fa88d70bd3d11,650000000);
285      mint(0xb4e3603b879f152766e8f58829dae173a048f6da,650000000);
286      mint(0xf58184d03575d5f8be93839adca9e0ed5280d4a8,650000000);
287      mint(0x313d17995920f4d1349c1c6aaeacc6b5002cc4c2,650000000);
288      mint(0xdbf062603dd285ec3e4b4fab97ecde7238bd3ee4,650000000);
289      mint(0x6047c67e3c7bcbb8e909f4d8ae03631ec9b94dab,650000000);
290      mint(0x0871ea40312df5e72bb6bde14973deddab17cf15,650000000);
291      mint(0xc321024cfb029bcde6d6a541553e1b262e95f834,650000000);
292      mint(0x1247e829e74ad09b0bb1a95830efacebfa7f472b,650000000);
293      mint(0x04ff81425d96f12eaae5f320e2bd4e0c5d2d575a,650000000);
294      mint(0xbc1425541f61958954cfd31843bd9f6c15319c66,650000000);
295      mint(0xd890ab57fbd2724ae28a02108c29c191590e1045,650000000);
296      mint(0xf741f6a1d992cd8cc9cbec871c7dc4ed4d683376,650000000);
297 
298      finishMinting(); // Double security to prevent the minting of new tokens later
299   } 
300 }