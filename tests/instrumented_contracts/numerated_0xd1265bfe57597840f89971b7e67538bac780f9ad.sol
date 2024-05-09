1 pragma solidity ^0.4.11;
2 
3 /**
4  * Math operations with safety checks
5  */
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 
31 }
32 
33 /**
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/20
37  */
38 contract ERC20Basic {
39   uint256 public totalSupply;
40   function balanceOf(address who) constant returns (uint256);
41   function transfer(address to, uint256 value);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 /**
46  * @title ERC20 interface
47  * @dev see https://github.com/ethereum/EIPs/issues/20
48  */
49 contract ERC20 is ERC20Basic {
50   function allowance(address owner, address spender) constant returns (uint256);
51   function transferFrom(address from, address to, uint256 value);
52   function approve(address spender, uint256 value);
53   event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 
57 /**
58  * @title Basic token
59  * @dev Basic version of StandardToken, with no allowances. 
60  */
61 contract BasicToken is ERC20Basic {
62   using SafeMath for uint256;
63 
64   mapping(address => uint256) balances;
65 
66   /**
67    * @dev Fix for the ERC20 short address attack.
68    */
69   modifier onlyPayloadSize(uint256 size) {
70      require(msg.data.length >= size + 4);
71      _;
72   }
73 
74   /**
75   * @dev transfer token for a specified address
76   * @param _to The address to transfer to.
77   * @param _value The amount to be transferred.
78   */
79   function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) {
80     balances[msg.sender] = balances[msg.sender].sub(_value);
81     balances[_to] = balances[_to].add(_value);
82     Transfer(msg.sender, _to, _value);
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
96 /**
97  * @title Standard ERC20 token
98  *
99  * @dev Implemantation of the basic standart token.
100  * @dev https://github.com/ethereum/EIPs/issues/20
101  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
102  */
103 contract StandardToken is BasicToken, ERC20 {
104 
105   mapping (address => mapping (address => uint256)) allowed;
106 
107 
108   /**
109    * @dev Transfer tokens from one address to another
110    * @param _from address The address which you want to send tokens from
111    * @param _to address The address which you want to transfer to
112    * @param _value uint256 the amout of tokens to be transfered
113    */
114   function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) {
115     var _allowance = allowed[_from][msg.sender];
116 
117     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
118     // if (_value > _allowance) throw;
119 
120     balances[_to] = balances[_to].add(_value);
121     balances[_from] = balances[_from].sub(_value);
122     allowed[_from][msg.sender] = _allowance.sub(_value);
123     Transfer(_from, _to, _value);
124   }
125 
126   /**
127    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
128    * @param _spender The address which will spend the funds.
129    * @param _value The amount of tokens to be spent.
130    */
131   function approve(address _spender, uint256 _value) {
132 
133     // To change the approve amount you first have to reduce the addresses`
134     //  allowance to zero by calling `approve(_spender, 0)` if it is not
135     //  already 0 to mitigate the race condition described here:
136     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
137     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
138 
139     allowed[msg.sender][_spender] = _value;
140     Approval(msg.sender, _spender, _value);
141   }
142 
143   /**
144    * @dev Function to check the amount of tokens that an owner allowed to a spender.
145    * @param _owner address The address which owns the funds.
146    * @param _spender address The address which will spend the funds.
147    * @return A uint256 specifing the amount of tokens still avaible for the spender.
148    */
149   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
150     return allowed[_owner][_spender];
151   }
152 
153 }
154 
155 /**
156  * @title SimpleToken
157  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator. 
158  * Note they can later distribute these tokens as they wish using `transfer` and other
159  * `StandardToken` functions.
160  */
161 contract DesToken is StandardToken {
162 
163   string public name = "DES Token";
164   string public symbol = "DES";
165   uint256 public decimals = 18;
166   uint256 public INITIAL_SUPPLY = 35000000 * 1 ether;
167 
168   /**
169    * @dev Contructor that gives msg.sender all of existing tokens. 
170    */
171   function DesToken() {
172     totalSupply = INITIAL_SUPPLY;
173     balances[msg.sender] = INITIAL_SUPPLY;
174   }
175 
176 }
177 
178 /*
179  * Ownable
180  *
181  * Base contract with an owner.
182  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
183  */
184 contract Ownable {
185   address public owner;
186 
187   function Ownable() {
188     owner = msg.sender;
189   }
190 
191   modifier onlyOwner() {
192     require(msg.sender == owner);
193     _;
194   }
195 
196   function transferOwnership(address newOwner) onlyOwner {
197     if (newOwner != address(0)) {
198       owner = newOwner;
199     }
200   }
201 
202 }
203 
204 /*
205  * Haltable
206  *
207  * Abstract contract that allows children to implement an
208  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
209  *
210  *
211  * Originally envisioned in FirstBlood ICO contract.
212  */
213 contract Haltable is Ownable {
214   bool public halted = false;
215 
216   modifier stopInEmergency {
217     require(!halted);
218     _;
219   }
220 
221   modifier onlyInEmergency {
222     require(halted);
223     _;
224   }
225 
226   // called by the owner on emergency, triggers stopped state
227   function halt() external onlyOwner {
228     halted = true;
229   }
230 
231   // called by the owner on end of emergency, returns to normal state
232   function unhalt() external onlyOwner onlyInEmergency {
233     halted = false;
234   }
235 
236 }
237 
238 contract DesTokenSale is Haltable {
239     using SafeMath for uint;
240 
241     string public name = "3DES Token Sale Contract";
242 
243     DesToken public token;
244     address public beneficiary;
245 
246     uint public tokensSoldTotal = 0; // in wei
247     uint public weiRaisedTotal = 0; // in wei
248     uint public investorCount = 0;
249     uint public tokensSelling = 0; // tokens selling in the current phase
250     uint public tokenPrice = 0; // in wei
251     uint public purchaseLimit = 0; // in tokens wei amount
252 
253     event NewContribution(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
254 
255     function DesTokenSale(
256       address _token,
257       address _beneficiary
258       ) {
259         token = DesToken(_token);
260         beneficiary = _beneficiary;
261     }
262 
263     function startPhase(
264       uint256 _tokens,
265       uint256 _price,
266       uint256 _limit
267       ) onlyOwner {
268         require(tokensSelling == 0);
269         require(_tokens <= token.balanceOf(this));
270         tokensSelling = _tokens * 1 ether;
271         tokenPrice = _price;
272         purchaseLimit = _limit * 1 ether;
273     }
274 
275     // If DES tokens will not be sold in a phase it will be ours.
276     // We belive in success of our project.
277     function finishPhase() onlyOwner {
278         require(tokensSelling != 0);
279         token.transfer(beneficiary, tokensSelling);
280         tokensSelling = 0;
281     }
282 
283     function () payable stopInEmergency {
284         require(tokensSelling != 0);
285         require(msg.value >= 0.01 * 1 ether);
286         
287         // calculate token amount
288         uint tokens = msg.value / tokenPrice * 1 ether;
289         
290         // throw if you trying to buy over the limit
291         require(token.balanceOf(msg.sender).add(tokens) <= purchaseLimit);
292         
293         // recalculate selling tokens
294         // will throw if it is not enough tokens
295         tokensSelling = tokensSelling.sub(tokens);
296         
297         // recalculate counters
298         tokensSoldTotal = tokensSoldTotal.add(tokens);
299         if (token.balanceOf(msg.sender) == 0) investorCount++;
300         weiRaisedTotal = weiRaisedTotal.add(msg.value);
301         
302         // transfer bought tokens to the contributor 
303         token.transfer(msg.sender, tokens);
304 
305         // transfer funds to the beneficiary
306         beneficiary.transfer(msg.value);
307 
308         NewContribution(msg.sender, tokens, msg.value);
309     }
310     
311 }