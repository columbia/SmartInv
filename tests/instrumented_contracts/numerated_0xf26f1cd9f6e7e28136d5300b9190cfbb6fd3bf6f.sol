1 pragma solidity ^0.4.22;
2 
3 contract MintableTokenFactory {
4     address[] public contracts;
5     address public lastContractAddress;
6     
7     event newMintableTokenContract (
8        address contractAddress
9     );
10 
11     constructor()
12         public
13     {
14 
15     }
16 
17     function getContractCount()
18         public
19         constant
20         returns(uint contractCount)
21     {
22         return contracts.length;
23     }
24 
25     function newMintableToken(string symbol, string name, address _owner)
26         public
27         returns(address newContract)
28     {
29         MintableToken c = new MintableToken(symbol, name, _owner);
30         contracts.push(c);
31         lastContractAddress = address(c);
32         emit newMintableTokenContract(c);
33         return c;
34     }
35 
36     function seeMintableToken(uint pos)
37         public
38         constant
39         returns(address contractAddress)
40     {
41         return address(contracts[pos]);
42     }
43 }
44 
45 /**
46  * @title ERC20Basic
47  * @dev Simpler version of ERC20 interface
48  * @dev see https://github.com/ethereum/EIPs/issues/179
49  */
50 contract ERC20Basic {
51   uint256 public totalSupply;
52   function balanceOf(address who) public constant returns (uint256);
53   function transfer(address to, uint256 value) public returns (bool);
54   event Transfer(address indexed from, address indexed to, uint256 value);
55 }
56 
57 /**
58  * @title ERC20 interface
59  * @dev see https://github.com/ethereum/EIPs/issues/20
60  */
61 contract ERC20 is ERC20Basic {
62   function allowance(address owner, address spender) public constant returns (uint256);
63   function transferFrom(address from, address to, uint256 value) public returns (bool);
64   function approve(address spender, uint256 value) public returns (bool);
65   event Approval(address indexed owner, address indexed spender, uint256 value);
66 }
67 
68 /**
69  * @title SafeMath
70  * @dev Math operations with safety checks that throw an error.
71  * Based off of https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol.
72  */
73 library SafeMath {
74     /*
75      * Internal functions
76      */
77 
78     function mul(uint256 a, uint256 b)
79         internal
80         pure
81         returns (uint256)
82     {
83         if (a == 0) {
84             return 0;
85         }
86         uint256 c = a * b;
87         assert(c / a == b);
88         return c;
89     }
90 
91     function div(uint256 a, uint256 b)
92         internal
93         pure
94         returns (uint256)
95     {
96         uint256 c = a / b;
97         return c;
98     }
99 
100     function sub(uint256 a, uint256 b)
101         internal
102         pure
103         returns (uint256) 
104     {
105         assert(b <= a);
106         return a - b;
107     }
108 
109     function add(uint256 a, uint256 b)
110         internal
111         pure
112         returns (uint256) 
113     {
114         uint256 c = a + b;
115         assert(c >= a);
116         return c;
117     }
118 }
119   /**
120  * @title Ownable
121  * @dev The Ownable contract has an owner address, and provides basic authorization control
122  * functions, this simplifies the implementation of "user permissions".
123  */
124 contract Ownable {
125   address public owner;
126 
127 
128   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
129 
130 
131   /**
132    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
133    * account.
134    */
135   function Ownable() public {
136     owner = 0x077086E2bc65a728E2aE0d7E22e4A767cE7802b3;
137   }
138 
139 
140   /**
141    * @dev Throws if called by any account other than the owner.
142    */
143   modifier onlyOwner() {
144     require(msg.sender == owner);
145     _;
146   }
147 
148 
149   /**
150    * @dev Allows the current owner to transfer control of the contract to a newOwner.
151    * @param newOwner The address to transfer ownership to.
152    */
153   function transferOwnership(address newOwner) public onlyOwner {
154     require(newOwner != address(0));
155     OwnershipTransferred(owner, newOwner);
156     owner = newOwner;
157 }
158 }
159 
160 /**
161  * @title Standard ERC20 token
162  *
163  * @dev Implementation of the basic standard token.
164  * @dev https://github.com/ethereum/EIPs/issues/20
165  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
166 */
167 contract StandardToken is ERC20, Ownable {
168     using SafeMath for uint256;
169 
170   mapping(address => uint256) balances;
171 
172   /**
173   * @dev transfer token for a specified address
174   * @param _to The address to transfer to.
175   * @param _value The amount to be transferred.
176   */
177   function transfer(address _to, uint256 _value) public returns (bool) {
178     require(_to != address(0));
179     require(_value <= balances[msg.sender]);
180 
181     // SafeMath.sub will throw if there is not enough balance.
182     balances[msg.sender] = balances[msg.sender].sub(_value);
183     balances[_to] = balances[_to].add(_value);
184     Transfer(msg.sender, _to, _value);
185     return true;
186   }
187 
188   /**
189   * @dev Gets the balance of the specified address.
190   * @param _owner The address to query the the balance of.
191   * @return An uint256 representing the amount owned by the passed address.
192   */
193   function balanceOf(address _owner) public constant returns (uint256 balance) {
194     return balances[_owner];
195   }
196 
197   mapping (address => mapping (address => uint256)) internal allowed;
198 
199 
200   /**
201    * @dev Transfer tokens from one address to another
202    * @param _from address The address which you want to send tokens from
203    * @param _to address The address which you want to transfer to
204    * @param _value uint256 the amount of tokens to be transferred
205    */
206   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
207     require(_to != address(0));
208     require(_value <= balances[_from]);
209     require(_value <= allowed[_from][msg.sender]);
210 
211     balances[_from] = balances[_from].sub(_value);
212     balances[_to] = balances[_to].add(_value);
213     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
214     Transfer(_from, _to, _value);
215     return true;
216   }
217 
218   /**
219    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
220    *
221    * Beware that changing an allowance with this method brings the risk that someone may use both the old
222    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
223    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
224    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
225    * @param _spender The address which will spend the funds.
226    * @param _value The amount of tokens to be spent.
227    */
228   function approve(address _spender, uint256 _value) public returns (bool) {
229     allowed[msg.sender][_spender] = _value;
230     Approval(msg.sender, _spender, _value);
231     return true;
232   }
233 
234   /**
235    * @dev Function to check the amount of tokens that an owner allowed to a spender.
236    * @param _owner address The address which owns the funds.
237    * @param _spender address The address which will spend the funds.
238    * @return A uint256 specifying the amount of tokens still available for the spender.
239    */
240   function allowance(address _owner, address _spender) public constant returns (uint256) {
241     return allowed[_owner][_spender];
242   }
243 
244   /**
245    * approve should be called when allowed[_spender] == 0. To increment
246    * allowed value is better to use this function to avoid 2 calls (and wait until
247    * the first transaction is mined)
248    * From MonolithDAO Token.sol
249    */
250   function increaseApproval (address _spender, uint _addedValue) public returns (bool) {
251     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
252     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
253     return true;
254   }
255 
256   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool) {
257     uint oldValue = allowed[msg.sender][_spender];
258     if (_subtractedValue > oldValue) {
259       allowed[msg.sender][_spender] = 0;
260     } else {
261       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
262     }
263     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
264     return true;
265   }
266 }
267  
268  /**
269  * @title Mintable token
270  * @dev Simple ERC20 Token example, with mintable token creation
271  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
272  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
273  */
274 contract MintableToken is StandardToken {
275   event Mint(address indexed to, uint256 amount);
276   event MintFinished();
277   string public symbol;
278   string public name;
279   uint8 public decimals = 18;
280   uint public _totalSupply;
281   address public _owner;
282 
283   bool public mintingFinished = false;
284 
285 constructor(string _symbol, string _name, address _owner) public {
286     	symbol = _symbol;
287     	name = _name;
288     	decimals = 18;
289     	totalSupply = _totalSupply;
290     	balances[_owner] = _totalSupply;
291     	emit Transfer(address(0), _owner, _totalSupply);
292 }
293 
294 
295   modifier canMint() {
296     require(!mintingFinished);
297     _;
298   }
299   
300 
301   /**
302    * @dev Function to mint tokens
303    * @param _to The address that will receive the minted tokens.
304    * @param _amount The amount of tokens to mint.
305    * @return A boolean that indicates if the operation was successful.
306    */
307   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
308     totalSupply = totalSupply.add(_amount);
309     balances[_to] = balances[_to].add(_amount);
310     Mint(_to, _amount);
311     Transfer(address(0), _to, _amount);
312     return true;
313   }
314 
315   /**
316    * @dev Function to stop minting new tokens.
317    * @return True if the operation was successful.
318    */
319   function finishMinting() onlyOwner canMint public returns (bool) {
320     mintingFinished = true;
321     MintFinished();
322     return true;
323   }
324 }