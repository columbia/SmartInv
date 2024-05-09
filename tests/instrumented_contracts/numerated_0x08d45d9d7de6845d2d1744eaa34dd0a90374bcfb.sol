1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 /**
17  * @title ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/20
19  */
20 contract ERC20 is ERC20Basic {
21   function allowance(address owner, address spender) public view returns (uint256);
22   function transferFrom(address from, address to, uint256 value) public returns (bool);
23   function approve(address spender, uint256 value) public returns (bool);
24   event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 
28 /**
29  * @title Basic token
30  * @dev Basic version of StandardToken, with no allowances.
31  */
32 contract BasicToken is ERC20Basic {
33   using SafeMath for uint256;
34 
35   mapping(address => uint256) balances;
36 
37   uint256 totalSupply_;
38 
39   /**
40   * @dev total number of tokens in existence
41   */
42   function totalSupply() public view returns (uint256) {
43     return totalSupply_;
44   }
45 
46   /**
47   * @dev transfer token for a specified address
48   * @param _to The address to transfer to.
49   * @param _value The amount to be transferred.
50   */
51   function transfer(address _to, uint256 _value) public returns (bool) {
52     require(_to != address(0));
53     require(_value <= balances[msg.sender]);
54 
55     // SafeMath.sub will throw if there is not enough balance.
56     balances[msg.sender] = balances[msg.sender].sub(_value);
57     balances[_to] = balances[_to].add(_value);
58     emit Transfer(msg.sender, _to, _value);
59     return true;
60   }
61 
62   /**
63   * @dev Gets the balance of the specified address.
64   * @param _owner The address to query the the balance of.
65   * @return An uint256 representing the amount owned by the passed address.
66   */
67   function balanceOf(address _owner) public view returns (uint256 balance) {
68     return balances[_owner];
69   }
70 
71 }
72 
73 /**
74  * @title Standard ERC20 token
75  *
76  * @dev Implementation of the basic standard token.
77  * @dev https://github.com/ethereum/EIPs/issues/20
78  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
79  */
80 contract StandardToken is ERC20, BasicToken {
81 
82   mapping (address => mapping (address => uint256)) internal allowed;
83 
84 
85   /**
86    * @dev Transfer tokens from one address to another
87    * @param _from address The address which you want to send tokens from
88    * @param _to address The address which you want to transfer to
89    * @param _value uint256 the amount of tokens to be transferred
90    */
91   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
92     require(_to != address(0));
93     require(_value <= balances[_from]);
94     require(_value <= allowed[_from][msg.sender]);
95 
96     balances[_from] = balances[_from].sub(_value);
97     balances[_to] = balances[_to].add(_value);
98     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
99     emit Transfer(_from, _to, _value);
100     return true;
101   }
102 
103   /**
104    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
105    *
106    * Beware that changing an allowance with this method brings the risk that someone may use both the old
107    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
108    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
109    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
110    * @param _spender The address which will spend the funds.
111    * @param _value The amount of tokens to be spent.
112    */
113   function approve(address _spender, uint256 _value) public returns (bool) {
114     allowed[msg.sender][_spender] = _value;
115     emit Approval(msg.sender, _spender, _value);
116     return true;
117   }
118 
119   /**
120    * @dev Function to check the amount of tokens that an owner allowed to a spender.
121    * @param _owner address The address which owns the funds.
122    * @param _spender address The address which will spend the funds.
123    * @return A uint256 specifying the amount of tokens still available for the spender.
124    */
125   function allowance(address _owner, address _spender) public view returns (uint256) {
126     return allowed[_owner][_spender];
127   }
128 
129   /**
130    * @dev Increase the amount of tokens that an owner allowed to a spender.
131    *
132    * approve should be called when allowed[_spender] == 0. To increment
133    * allowed value is better to use this function to avoid 2 calls (and wait until
134    * the first transaction is mined)
135    * From MonolithDAO Token.sol
136    * @param _spender The address which will spend the funds.
137    * @param _addedValue The amount of tokens to increase the allowance by.
138    */
139   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
140     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
141     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
142     return true;
143   }
144 
145   /**
146    * @dev Decrease the amount of tokens that an owner allowed to a spender.
147    *
148    * approve should be called when allowed[_spender] == 0. To decrement
149    * allowed value is better to use this function to avoid 2 calls (and wait until
150    * the first transaction is mined)
151    * From MonolithDAO Token.sol
152    * @param _spender The address which will spend the funds.
153    * @param _subtractedValue The amount of tokens to decrease the allowance by.
154    */
155   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
156     uint oldValue = allowed[msg.sender][_spender];
157     if (_subtractedValue > oldValue) {
158       allowed[msg.sender][_spender] = 0;
159     } else {
160       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
161     }
162     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
163     return true;
164   }
165 
166 }
167 
168 /**
169  * @title SafeMath
170  * @dev Math operations with safety checks that throw on error
171  */
172 library SafeMath {
173 
174   /**
175   * @dev Multiplies two numbers, throws on overflow.
176   */
177   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
178     if (a == 0) {
179       return 0;
180     }
181     uint256 c = a * b;
182     assert(c / a == b);
183     return c;
184   }
185 
186   /**
187   * @dev Integer division of two numbers, truncating the quotient.
188   */
189   function div(uint256 a, uint256 b) internal pure returns (uint256) {
190     // assert(b > 0); // Solidity automatically throws when dividing by 0
191     uint256 c = a / b;
192     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
193     return c;
194   }
195 
196   /**
197   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
198   */
199   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
200     assert(b <= a);
201     return a - b;
202   }
203 
204   /**
205   * @dev Adds two numbers, throws on overflow.
206   */
207   function add(uint256 a, uint256 b) internal pure returns (uint256) {
208     uint256 c = a + b;
209     assert(c >= a);
210     return c;
211   }
212 }
213 
214 /**
215  * @title Ownable
216  * @dev The Ownable contract has an owner address, and provides basic authorization control
217  * functions, this simplifies the implementation of "user permissions".
218  */
219 contract Ownable {
220   address public owner;
221 
222 
223   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
224 
225 
226   /**
227    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
228    * account.
229    */
230   function Ownable() public {
231     owner = msg.sender;
232   }
233 
234   /**
235    * @dev Throws if called by any account other than the owner.
236    */
237   modifier onlyOwner() {
238     require(msg.sender == owner);
239     _;
240   }
241 
242   /**
243    * @dev Allows the current owner to transfer control of the contract to a newOwner.
244    * @param newOwner The address to transfer ownership to.
245    */
246   function transferOwnership(address newOwner) public onlyOwner {
247     require(newOwner != address(0));
248     emit OwnershipTransferred(owner, newOwner);
249     owner = newOwner;
250   }
251 
252 }
253 
254 /**
255  * @title ExchangeRate
256  * @dev Allows updating and retrieveing of Conversion Rates for PAY tokens
257  *
258  * ABI
259  * [{"constant":false,"inputs":[{"name":"_symbol","type":"string"},{"name":"_rate","type":"uint256"}],"name":"updateRate","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"data","type":"uint256[]"}],"name":"updateRates","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_symbol","type":"string"}],"name":"getRate","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"bytes32"}],"name":"rates","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"anonymous":false,"inputs":[{"indexed":false,"name":"timestamp","type":"uint256"},{"indexed":false,"name":"symbol","type":"bytes32"},{"indexed":false,"name":"rate","type":"uint256"}],"name":"RateUpdated","type":"event"}]
260  */
261 contract ExchangeRate is Ownable {
262 
263   event RateUpdated(uint timestamp, bytes32 symbol, uint rate);
264 
265   mapping(bytes32 => uint) public rates;
266 
267   /**
268    * @dev Allows the current owner to update a single rate.
269    * @param _symbol The symbol to be updated. 
270    * @param _rate the rate for the symbol. 
271    */
272   function updateRate(string _symbol, uint _rate) public onlyOwner {
273     rates[keccak256(_symbol)] = _rate;
274     emit RateUpdated(now, keccak256(_symbol), _rate);
275   }
276 
277   /**
278    * @dev Allows the current owner to update multiple rates.
279    * @param data an array that alternates sha3 hashes of the symbol and the corresponding rate . 
280    */
281   function updateRates(uint[] data) public onlyOwner {
282     
283     require(data.length % 2 <= 0);      
284     uint i = 0;
285     while (i < data.length / 2) {
286       bytes32 symbol = bytes32(data[i * 2]);
287       uint rate = data[i * 2 + 1];
288       rates[symbol] = rate;
289       emit RateUpdated(now, symbol, rate);
290       i++;
291     }
292   }
293 
294   /**
295    * @dev Allows the anyone to read the current rate.
296    * @param _symbol the symbol to be retrieved. 
297    */
298   function getRate(string _symbol) public constant returns(uint) {
299     return rates[keccak256(_symbol)];
300   }
301 
302 }