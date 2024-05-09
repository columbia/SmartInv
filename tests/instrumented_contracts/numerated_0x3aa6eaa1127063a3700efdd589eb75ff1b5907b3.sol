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
84 
85 /**
86  * @title ERC20Basic
87  * @dev Simpler version of ERC20 interface
88  * @dev see https://github.com/ethereum/EIPs/issues/20
89  */
90 contract ERC20Basic {
91   uint public totalSupply;
92   function balanceOf(address who) constant returns (uint);
93   function transfer(address to, uint value);
94   event Transfer(address indexed from, address indexed to, uint value);
95 }
96 
97 
98 /**
99  * @title ERC20 interface
100  * @dev see https://github.com/ethereum/EIPs/issues/20
101  */
102 contract ERC20 is ERC20Basic {
103   function allowance(address owner, address spender) constant returns (uint);
104   function transferFrom(address from, address to, uint value);
105   function approve(address spender, uint value);
106   event Approval(address indexed owner, address indexed spender, uint value);
107 }
108 
109 
110 /**
111  * @title Basic token
112  * @dev Basic version of StandardToken, with no allowances. 
113  */
114 contract BasicToken is ERC20Basic {
115   using SafeMath for uint;
116 
117   mapping(address => uint) balances;
118 
119   /**
120    * @dev Fix for the ERC20 short address attack.
121    */
122   modifier onlyPayloadSize(uint size) {
123      require(msg.data.length >= size + 4);
124      _;
125   }
126 
127   /**
128   * @dev transfer token for a specified address
129   * @param _to The address to transfer to.
130   * @param _value The amount to be transferred.
131   */
132   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
133     balances[msg.sender] = balances[msg.sender].sub(_value);
134     balances[_to] = balances[_to].add(_value);
135     Transfer(msg.sender, _to, _value);
136   }
137 
138   /**
139   * @dev Gets the balance of the specified address.
140   * @param _owner The address to query the the balance of. 
141   * @return An uint representing the amount owned by the passed address.
142   */
143   function balanceOf(address _owner) constant returns (uint balance) {
144     return balances[_owner];
145   }
146 
147 }
148 
149 
150 /**
151  * @title Standard ERC20 token
152  *
153  * @dev Implemantation of the basic standart token.
154  * @dev https://github.com/ethereum/EIPs/issues/20
155  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
156  */
157 contract StandardToken is BasicToken, ERC20 {
158 
159   mapping (address => mapping (address => uint)) allowed;
160 
161 
162   /**
163    * @dev Transfer tokens from one address to another
164    * @param _from address The address which you want to send tokens from
165    * @param _to address The address which you want to transfer to
166    * @param _value uint the amout of tokens to be transfered
167    */
168   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
169     var _allowance = allowed[_from][msg.sender];
170 
171     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
172     // if (_value > _allowance) throw;
173 
174     balances[_to] = balances[_to].add(_value);
175     balances[_from] = balances[_from].sub(_value);
176     allowed[_from][msg.sender] = _allowance.sub(_value);
177     Transfer(_from, _to, _value);
178   }
179 
180   /**
181    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
182    * @param _spender The address which will spend the funds.
183    * @param _value The amount of tokens to be spent.
184    */
185   function approve(address _spender, uint _value) {
186 
187     //  To change the approve amount you first have to reduce the addresses`
188     //  allowance to zero by calling `approve(_spender, 0)` if it is not
189     //  already 0 to mitigate the race condition described here:
190     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
191     require(_value == 0);
192     require(allowed[msg.sender][_spender] == 0);
193 
194     allowed[msg.sender][_spender] = _value;
195     Approval(msg.sender, _spender, _value);
196   }
197 
198   /**
199    * @dev Function to check the amount of tokens than an owner allowed to a spender.
200    * @param _owner address The address which owns the funds.
201    * @param _spender address The address which will spend the funds.
202    * @return A uint specifing the amount of tokens still avaible for the spender.
203    */
204   function allowance(address _owner, address _spender) constant returns (uint remaining) {
205     return allowed[_owner][_spender];
206   }
207 
208 }
209 
210 
211 /**
212  * @title Mintable token
213  * @dev Simple ERC20 Token example, with mintable token creation
214  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
215  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
216  */
217 
218 contract MintableToken is StandardToken, Ownable {
219   event Mint(address indexed to, uint value);
220   event MintFinished();
221 
222   bool public mintingFinished = false;
223   uint public totalSupply = 0;
224 
225 
226   modifier canMint() {
227     require(!mintingFinished);
228     _;
229   }
230 
231   /**
232    * @dev Function to mint tokens
233    * @param _to The address that will recieve the minted tokens.
234    * @param _amount The amount of tokens to mint.
235    * @return A boolean that indicates if the operation was successful.
236    */
237   function mint(address _to, uint _amount) onlyOwner canMint returns (bool) {
238     totalSupply = totalSupply.add(_amount);
239     balances[_to] = balances[_to].add(_amount);
240     Mint(_to, _amount);
241     return true;
242   }
243 
244   /**
245    * @dev Function to stop minting new tokens.
246    * @return True if the operation was successful.
247    */
248   function finishMinting() onlyOwner returns (bool) {
249     mintingFinished = true;
250     MintFinished();
251     return true;
252   }
253 
254 }
255 
256 
257 /**
258  * @title AbleTokoen
259  * @dev The main ABLE token contract
260  * 
261  * ABI 
262  * [{"constant": true,"inputs": [],"name": "mintingFinished","outputs": [{"name": "","type": "bool"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": true,"inputs": [],"name": "name","outputs": [{"name": "","type": "string"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": false,"inputs": [{"name": "_spender","type": "address"},{"name": "_value","type": "uint256"}],"name": "approve","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": true,"inputs": [],"name": "totalSupply","outputs": [{"name": "","type": "uint256"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": false,"inputs": [{"name": "_from","type": "address"},{"name": "_to","type": "address"},{"name": "_value","type": "uint256"}],"name": "transferFrom","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": false,"inputs": [],"name": "startTrading","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": true,"inputs": [],"name": "decimals","outputs": [{"name": "","type": "uint256"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": false,"inputs": [{"name": "_to","type": "address"},{"name": "_amount","type": "uint256"}],"name": "mint","outputs": [{"name": "","type": "bool"}],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": true,"inputs": [],"name": "tradingStarted","outputs": [{"name": "","type": "bool"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": true,"inputs": [{"name": "_owner","type": "address"}],"name": "balanceOf","outputs": [{"name": "balance","type": "uint256"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": false,"inputs": [],"name": "stopTrading","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": false,"inputs": [],"name": "finishMinting","outputs": [{"name": "","type": "bool"}],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": true,"inputs": [],"name": "owner","outputs": [{"name": "","type": "address"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": true,"inputs": [],"name": "symbol","outputs": [{"name": "","type": "string"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": false,"inputs": [{"name": "_to","type": "address"},{"name": "_value","type": "uint256"}],"name": "transfer","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": true,"inputs": [{"name": "_owner","type": "address"},{"name": "_spender","type": "address"}],"name": "allowance","outputs": [{"name": "remaining","type": "uint256"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": false,"inputs": [{"name": "newOwner","type": "address"}],"name": "transferOwnership","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"anonymous": false,"inputs": [{"indexed": true,"name": "to","type": "address"},{"indexed": false,"name": "value","type": "uint256"}],"name": "Mint","type": "event"},{"anonymous": false,"inputs": [],"name": "MintFinished","type": "event"},{"anonymous": false,"inputs": [{"indexed": true,"name": "owner","type": "address"},{"indexed": true,"name": "spender","type": "address"},{"indexed": false,"name": "value","type": "uint256"}],"name": "Approval","type": "event"},{"anonymous": false,"inputs": [{"indexed": true,"name": "from","type": "address"},{"indexed": true,"name": "to","type": "address"},{"indexed": false,"name": "value","type": "uint256"}],"name": "Transfer","type": "event"}]
263  */
264 contract AbleToken is MintableToken {
265 
266   string public name = "ABLE Token";
267   string public symbol = "ABLE";
268   uint public decimals = 18;
269 
270   bool public tradingStarted = false;
271 
272   /**
273    * @dev modifier that throws if trading has not started yet
274    */
275   modifier hasStartedTrading() {
276     require(tradingStarted);
277     _;
278   }
279 
280   /**
281    * @dev Allows the owner to enable the trading.
282    */
283   function startTrading() onlyOwner {
284     tradingStarted = true;
285   }
286   
287   /**
288    * @dev Allows the owner to disable the trading.
289    */
290   function stopTrading() onlyOwner {
291     tradingStarted = false;
292   }
293 
294   /**
295    * @dev Allows anyone to transfer the ABLE tokens once trading has started
296    * @param _to the recipient address of the tokens. 
297    * @param _value number of tokens to be transfered. 
298    */
299   function transfer(address _to, uint _value) hasStartedTrading {
300     super.transfer(_to, _value);
301   }
302 
303    /**
304    * @dev Allows anyone to transfer the ABLE tokens once trading has started
305    * @param _from address The address which you want to send tokens from
306    * @param _to address The address which you want to transfer to
307    * @param _value uint the amout of tokens to be transfered
308    */
309   function transferFrom(address _from, address _to, uint _value) hasStartedTrading {
310     super.transferFrom(_from, _to, _value);
311   }
312 
313 }