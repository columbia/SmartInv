1 /**
2  * @title Ownable
3  * @dev The Ownable contract has an owner address, and provides basic authorization control 
4  * functions, this simplifies the implementation of "user permissions". 
5  */
6 contract Ownable {
7   address public owner;
8 
9   /** 
10    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
11    * account.
12    */
13   function Ownable() {
14     owner = msg.sender;
15   }
16 
17   /**
18    * @dev Throws if called by any account other than the owner. 
19    */
20   modifier onlyOwner() {
21     require(msg.sender == owner);
22     _;
23   }
24 
25   /**
26    * @dev Allows the current owner to transfer control of the contract to a newOwner.
27    * @param newOwner The address to transfer ownership to. 
28    */
29   function transferOwnership(address newOwner) onlyOwner public {
30     if (newOwner != address(0)) {
31       owner = newOwner;
32     }
33   }
34 
35 }
36 
37 
38 /**
39  * Math operations with safety checks
40  */
41 library SafeMath {
42   function mul(uint a, uint b) internal returns (uint) {
43     uint c = a * b;
44     assert(a == 0 || c / a == b);
45     return c;
46   }
47 
48   function div(uint a, uint b) internal returns (uint) {
49     // assert(b > 0); // Solidity automatically throws when dividing by 0
50     uint c = a / b;
51     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52     return c;
53   }
54 
55   function sub(uint a, uint b) internal returns (uint) {
56     assert(b <= a);
57     return a - b;
58   }
59 
60   function add(uint a, uint b) internal returns (uint) {
61     uint c = a + b;
62     assert(c >= a);
63     return c;
64   }
65 
66   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
67     return a >= b ? a : b;
68   }
69 
70   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
71     return a < b ? a : b;
72   }
73 
74   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
75     return a >= b ? a : b;
76   }
77 
78   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
79     return a < b ? a : b;
80   }
81 
82 }
83 
84 /**
85  * @title ERC20Basic
86  * @dev Simpler version of ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/20
88  */
89 contract ERC20Basic {
90   uint public totalSupply;
91   function balanceOf(address who) constant returns (uint);
92   function transfer(address to, uint value);
93   event Transfer(address indexed from, address indexed to, uint value);
94 }
95 
96 
97 /**
98  * @title ERC20 interface
99  * @dev see https://github.com/ethereum/EIPs/issues/20
100  */
101 contract ERC20 is ERC20Basic {
102   function allowance(address owner, address spender) constant returns (uint);
103   function transferFrom(address from, address to, uint value);
104   function approve(address spender, uint value);
105   event Approval(address indexed owner, address indexed spender, uint value);
106 }
107 
108 
109 /**
110  * @title Basic token
111  * @dev Basic version of StandardToken, with no allowances. 
112  */
113 contract BasicToken is ERC20Basic {
114   using SafeMath for uint;
115 
116   mapping(address => uint) balances;
117 
118   /**
119    * @dev Fix for the ERC20 short address attack.
120    */
121   modifier onlyPayloadSize(uint size) {
122      require(msg.data.length >= size + 4);
123      _;
124   }
125 
126   /**
127   * @dev transfer token for a specified address
128   * @param _to The address to transfer to.
129   * @param _value The amount to be transferred.
130   */
131   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
132     balances[msg.sender] = balances[msg.sender].sub(_value);
133     balances[_to] = balances[_to].add(_value);
134     Transfer(msg.sender, _to, _value);
135   }
136 
137   /**
138   * @dev Gets the balance of the specified address.
139   * @param _owner The address to query the the balance of. 
140   * @return An uint representing the amount owned by the passed address.
141   */
142   function balanceOf(address _owner) constant returns (uint balance) {
143     return balances[_owner];
144   }
145 
146 }
147 
148 
149 /**
150  * @title Standard ERC20 token
151  *
152  * @dev Implemantation of the basic standart token.
153  * @dev https://github.com/ethereum/EIPs/issues/20
154  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
155  */
156 contract StandardToken is BasicToken, ERC20 {
157 
158   mapping (address => mapping (address => uint)) allowed;
159 
160 
161   /**
162    * @dev Transfer tokens from one address to another
163    * @param _from address The address which you want to send tokens from
164    * @param _to address The address which you want to transfer to
165    * @param _value uint the amout of tokens to be transfered
166    */
167   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
168     var _allowance = allowed[_from][msg.sender];
169 
170     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
171     // if (_value > _allowance) throw;
172 
173     balances[_to] = balances[_to].add(_value);
174     balances[_from] = balances[_from].sub(_value);
175     allowed[_from][msg.sender] = _allowance.sub(_value);
176     Transfer(_from, _to, _value);
177   }
178 
179   /**
180    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
181    * @param _spender The address which will spend the funds.
182    * @param _value The amount of tokens to be spent.
183    */
184   function approve(address _spender, uint _value) {
185 
186     //  To change the approve amount you first have to reduce the addresses`
187     //  allowance to zero by calling `approve(_spender, 0)` if it is not
188     //  already 0 to mitigate the race condition described here:
189     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
190     require(_value == 0);
191     require(allowed[msg.sender][_spender] == 0);
192 
193     allowed[msg.sender][_spender] = _value;
194     Approval(msg.sender, _spender, _value);
195   }
196 
197   /**
198    * @dev Function to check the amount of tokens than an owner allowed to a spender.
199    * @param _owner address The address which owns the funds.
200    * @param _spender address The address which will spend the funds.
201    * @return A uint specifing the amount of tokens still avaible for the spender.
202    */
203   function allowance(address _owner, address _spender) constant returns (uint remaining) {
204     return allowed[_owner][_spender];
205   }
206 
207 }
208 
209 
210 /**
211  * @title Mintable token
212  * @dev Simple ERC20 Token example, with mintable token creation
213  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
214  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
215  */
216 
217 contract MintableToken is StandardToken, Ownable {
218   event Mint(address indexed to, uint value);
219   event MintFinished();
220 
221   bool public mintingFinished = false;
222   uint public totalSupply = 0;
223 
224 
225   modifier canMint() {
226     require(!mintingFinished);
227     _;
228   }
229 
230   /**
231    * @dev Function to mint tokens
232    * @param _to The address that will recieve the minted tokens.
233    * @param _amount The amount of tokens to mint.
234    * @return A boolean that indicates if the operation was successful.
235    */
236   function mint(address _to, uint _amount) onlyOwner canMint returns (bool) {
237     totalSupply = totalSupply.add(_amount);
238     balances[_to] = balances[_to].add(_amount);
239     Mint(_to, _amount);
240     return true;
241   }
242 
243   /**
244    * @dev Function to stop minting new tokens.
245    * @return True if the operation was successful.
246    */
247   function finishMinting() onlyOwner returns (bool) {
248     mintingFinished = true;
249     MintFinished();
250     return true;
251   }
252 
253 }
254 
255 
256 /**
257  * @title AbleTokoen
258  * @dev The main ABLE token contract
259  * 
260  * ABI 
261  * [{"constant": true,"inputs": [],"name": "mintingFinished","outputs": [{"name": "","type": "bool"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": true,"inputs": [],"name": "name","outputs": [{"name": "","type": "string"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": false,"inputs": [{"name": "_spender","type": "address"},{"name": "_value","type": "uint256"}],"name": "approve","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": true,"inputs": [],"name": "totalSupply","outputs": [{"name": "","type": "uint256"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": false,"inputs": [{"name": "_from","type": "address"},{"name": "_to","type": "address"},{"name": "_value","type": "uint256"}],"name": "transferFrom","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": false,"inputs": [],"name": "startTrading","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": true,"inputs": [],"name": "decimals","outputs": [{"name": "","type": "uint256"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": false,"inputs": [{"name": "_to","type": "address"},{"name": "_amount","type": "uint256"}],"name": "mint","outputs": [{"name": "","type": "bool"}],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": true,"inputs": [],"name": "tradingStarted","outputs": [{"name": "","type": "bool"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": true,"inputs": [{"name": "_owner","type": "address"}],"name": "balanceOf","outputs": [{"name": "balance","type": "uint256"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": false,"inputs": [],"name": "stopTrading","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": false,"inputs": [],"name": "finishMinting","outputs": [{"name": "","type": "bool"}],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": true,"inputs": [],"name": "owner","outputs": [{"name": "","type": "address"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": true,"inputs": [],"name": "symbol","outputs": [{"name": "","type": "string"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": false,"inputs": [{"name": "_to","type": "address"},{"name": "_value","type": "uint256"}],"name": "transfer","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": true,"inputs": [{"name": "_owner","type": "address"},{"name": "_spender","type": "address"}],"name": "allowance","outputs": [{"name": "remaining","type": "uint256"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": false,"inputs": [{"name": "newOwner","type": "address"}],"name": "transferOwnership","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"anonymous": false,"inputs": [{"indexed": true,"name": "to","type": "address"},{"indexed": false,"name": "value","type": "uint256"}],"name": "Mint","type": "event"},{"anonymous": false,"inputs": [],"name": "MintFinished","type": "event"},{"anonymous": false,"inputs": [{"indexed": true,"name": "owner","type": "address"},{"indexed": true,"name": "spender","type": "address"},{"indexed": false,"name": "value","type": "uint256"}],"name": "Approval","type": "event"},{"anonymous": false,"inputs": [{"indexed": true,"name": "from","type": "address"},{"indexed": true,"name": "to","type": "address"},{"indexed": false,"name": "value","type": "uint256"}],"name": "Transfer","type": "event"}]
262  */
263 contract AbleDollarToken is MintableToken {
264 
265   string public name = "ABLE Dollar Token";
266   string public symbol = "ABLD";
267   uint public decimals = 18;
268 
269   bool public tradingStarted = false;
270 
271   /**
272    * @dev modifier that throws if trading has not started yet
273    */
274   modifier hasStartedTrading() {
275     require(tradingStarted);
276     _;
277   }
278 
279   /**
280    * @dev Allows the owner to enable the trading.
281    */
282   function startTrading() onlyOwner {
283     tradingStarted = true;
284   }
285   
286   /**
287    * @dev Allows the owner to disable the trading.
288    */
289   function stopTrading() onlyOwner {
290     tradingStarted = false;
291   }
292 
293   /**
294    * @dev Allows anyone to transfer the ABLE tokens once trading has started
295    * @param _to the recipient address of the tokens. 
296    * @param _value number of tokens to be transfered. 
297    */
298   function transfer(address _to, uint _value) hasStartedTrading {
299     super.transfer(_to, _value);
300   }
301 
302    /**
303    * @dev Allows anyone to transfer the ABLE tokens once trading has started
304    * @param _from address The address which you want to send tokens from
305    * @param _to address The address which you want to transfer to
306    * @param _value uint the amout of tokens to be transfered
307    */
308   function transferFrom(address _from, address _to, uint _value) hasStartedTrading {
309     super.transferFrom(_from, _to, _value);
310   }
311 
312 }