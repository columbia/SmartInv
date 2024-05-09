1 pragma solidity ^0.4.13;
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
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39   address public owner;
40 
41 
42   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44 
45   /**
46    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47    * account.
48    */
49   function Ownable() {
50     owner = msg.sender;
51   }
52 
53 
54   /**
55    * @dev Throws if called by any account other than the owner.
56    */
57   modifier onlyOwner() {
58     require(msg.sender == owner);
59     _;
60   }
61 
62 
63   /**
64    * @dev Allows the current owner to transfer control of the contract to a newOwner.
65    * @param newOwner The address to transfer ownership to.
66    */
67   function transferOwnership(address newOwner) onlyOwner {
68     require(newOwner != address(0));      
69     OwnershipTransferred(owner, newOwner);
70     owner = newOwner;
71   }
72 
73 }
74 
75 /**
76  * @title ERC20Basic
77  * @dev Simpler version of ERC20 interface
78  * @dev see https://github.com/ethereum/EIPs/issues/179
79  */
80 contract ERC20Basic {
81   uint256 public totalSupply;
82   function balanceOf(address who) constant returns (uint256);
83   function transfer(address to, uint256 value) returns (bool);
84   event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
87 
88 /**
89  * @title Basic token
90  * @dev Basic version of StandardToken, with no allowances. 
91  */
92 contract BasicToken is ERC20Basic {
93   using SafeMath for uint256;
94 
95   mapping(address => uint256) balances;
96 
97   /**
98   * @dev transfer token for a specified address
99   * @param _to The address to transfer to.
100   * @param _value The amount to be transferred.
101   */
102   function transfer(address _to, uint256 _value) returns (bool) {
103     require(_to != address(0));
104 
105     // SafeMath.sub will throw if there is not enough balance.
106     balances[msg.sender] = balances[msg.sender].sub(_value);
107     balances[_to] = balances[_to].add(_value);
108     Transfer(msg.sender, _to, _value);
109     return true;
110   }
111 
112   /**
113   * @dev Gets the balance of the specified address.
114   * @param _owner The address to query the the balance of. 
115   * @return An uint256 representing the amount owned by the passed address.
116   */
117   function balanceOf(address _owner) constant returns (uint256 balance) {
118     return balances[_owner];
119   }
120 
121 }
122 
123 /**
124  * @title ERC20 interface
125  * @dev see https://github.com/ethereum/EIPs/issues/20
126  */
127 contract ERC20 is ERC20Basic {
128   function allowance(address owner, address spender) constant returns (uint256);
129   function transferFrom(address from, address to, uint256 value) returns (bool);
130   function approve(address spender, uint256 value) returns (bool);
131   event Approval(address indexed owner, address indexed spender, uint256 value);
132 }
133 
134 /**
135  * @title Standard ERC20 token
136  *
137  * @dev Implementation of the basic standard token.
138  * @dev https://github.com/ethereum/EIPs/issues/20
139  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
140  */
141 contract StandardToken is ERC20, BasicToken {
142 
143   mapping (address => mapping (address => uint256)) allowed;
144 
145 
146   /**
147    * @dev Transfer tokens from one address to another
148    * @param _from address The address which you want to send tokens from
149    * @param _to address The address which you want to transfer to
150    * @param _value uint256 the amount of tokens to be transferred
151    */
152   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
153     require(_to != address(0));
154 
155     var _allowance = allowed[_from][msg.sender];
156 
157     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
158     // require (_value <= _allowance);
159 
160     balances[_from] = balances[_from].sub(_value);
161     balances[_to] = balances[_to].add(_value);
162     allowed[_from][msg.sender] = _allowance.sub(_value);
163     Transfer(_from, _to, _value);
164     return true;
165   }
166 
167   /**
168    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
169    * @param _spender The address which will spend the funds.
170    * @param _value The amount of tokens to be spent.
171    */
172   function approve(address _spender, uint256 _value) returns (bool) {
173 
174     // To change the approve amount you first have to reduce the addresses`
175     //  allowance to zero by calling `approve(_spender, 0)` if it is not
176     //  already 0 to mitigate the race condition described here:
177     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
178     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
179 
180     allowed[msg.sender][_spender] = _value;
181     Approval(msg.sender, _spender, _value);
182     return true;
183   }
184 
185   /**
186    * @dev Function to check the amount of tokens that an owner allowed to a spender.
187    * @param _owner address The address which owns the funds.
188    * @param _spender address The address which will spend the funds.
189    * @return A uint256 specifying the amount of tokens still available for the spender.
190    */
191   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
192     return allowed[_owner][_spender];
193   }
194   
195   /**
196    * approve should be called when allowed[_spender] == 0. To increment
197    * allowed value is better to use this function to avoid 2 calls (and wait until 
198    * the first transaction is mined)
199    * From MonolithDAO Token.sol
200    */
201   function increaseApproval (address _spender, uint _addedValue) 
202     returns (bool success) {
203     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
204     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
205     return true;
206   }
207 
208   function decreaseApproval (address _spender, uint _subtractedValue) 
209     returns (bool success) {
210     uint oldValue = allowed[msg.sender][_spender];
211     if (_subtractedValue > oldValue) {
212       allowed[msg.sender][_spender] = 0;
213     } else {
214       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
215     }
216     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
217     return true;
218   }
219 
220 }
221 
222 /**
223  * Токен продаж
224  *
225  * ERC-20 токен
226  *
227  */
228 
229 contract SaleToken is StandardToken, Ownable {
230     using SafeMath for uint;
231 
232     /* Описание см. в конструкторе */
233     string public name;
234 
235     string public symbol;
236 
237     uint public decimals;
238 
239     address public mintAgent;
240 
241     /** Событие обновления токена (имя и символ) */
242     event UpdatedTokenInformation(string newName, string newSymbol);
243 
244     /**
245      * Конструктор
246      *
247      * @param _name - имя токена
248      * @param _symbol - символ токена
249      * @param _decimals - кол-во знаков после запятой
250      */
251     function SaleToken(string _name, string _symbol, uint _decimals) {
252         name = _name;
253         symbol = _symbol;
254 
255         decimals = _decimals;
256     }
257 
258     /**
259      * Может вызвать только агент
260      */
261     function mint(uint amount) public onlyMintAgent {
262         balances[mintAgent] = balances[mintAgent].add(amount);
263 
264         totalSupply = balances[mintAgent];
265     }
266 
267     /**
268      * Владелец может обновить инфу по токену
269      */
270     function setTokenInformation(string _name, string _symbol) external onlyOwner {
271         name = _name;
272         symbol = _symbol;
273 
274         // Вызываем событие
275         UpdatedTokenInformation(name, symbol);
276     }
277 
278     /**
279      * Может вызвать только владелец
280      * Установить можно только 1 раз
281      */
282     function setMintAgent(address mintAgentAddress) external emptyMintAgent onlyOwner {
283         mintAgent = mintAgentAddress;
284     }
285 
286     /**
287      * Модификаторы
288      */
289     modifier onlyMintAgent() {
290         require(msg.sender == mintAgent);
291         _;
292     }
293 
294     modifier emptyMintAgent() {
295         require(mintAgent == 0);
296         _;
297     }
298 
299 }