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
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40   address public owner;
41 
42 
43   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45 
46   /**
47    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50   function Ownable() {
51     owner = msg.sender;
52   }
53 
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) onlyOwner public {
69     require(newOwner != address(0));
70     OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 }
74 
75 /**
76  * @title ERC20Basic
77  * @dev Simpler version of ERC20 interface
78  * @dev see https://github.com/ethereum/EIPs/issues/179
79  */
80 contract ERC20Basic {
81   uint256 public totalSupply;
82   function balanceOf(address who) public constant returns (uint256);
83   function transfer(address to, uint256 value) public returns (bool);
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
97   /*************************************************/
98     mapping(address=>uint256) public indexes;
99     mapping(uint256=>address) public addresses;
100     uint256 public lastIndex = 0;
101   /*************************************************/
102 
103   /**
104   * @dev transfer token for a specified address
105   * @param _to The address to transfer to.
106   * @param _value The amount to be transferred.
107   */
108   function transfer(address _to, uint256 _value) public returns (bool) {
109     require(_to != address(0));
110 
111     // SafeMath.sub will throw if there is not enough balance.
112     balances[msg.sender] = balances[msg.sender].sub(_value);
113     balances[_to] = balances[_to].add(_value);
114     Transfer(msg.sender, _to, _value);
115     if(_value > 0){
116         if(balances[msg.sender] == 0){
117             addresses[indexes[msg.sender]] = addresses[lastIndex];
118             indexes[addresses[lastIndex]] = indexes[msg.sender];
119             indexes[msg.sender] = 0;
120             delete addresses[lastIndex];
121             lastIndex--;
122         }
123         if(indexes[_to]==0){
124             lastIndex++;
125             addresses[lastIndex] = _to;
126             indexes[_to] = lastIndex;
127         }
128     }
129     return true;
130   }
131 
132   /**
133   * @dev Gets the balance of the specified address.
134   * @param _owner The address to query the the balance of.
135   * @return An uint256 representing the amount owned by the passed address.
136   */
137   function balanceOf(address _owner) public constant returns (uint256 balance) {
138     return balances[_owner];
139   }
140 }
141 
142 /**
143  * @title ERC20 interface
144  * @dev see https://github.com/ethereum/EIPs/issues/20
145  */
146 contract ERC20 is ERC20Basic {
147   function allowance(address owner, address spender) public constant returns (uint256);
148   function transferFrom(address from, address to, uint256 value) public returns (bool);
149   function approve(address spender, uint256 value) public returns (bool);
150   event Approval(address indexed owner, address indexed spender, uint256 value);
151 }
152 
153 
154 /**
155  * @title Standard ERC20 token
156  *
157  * @dev Implementation of the basic standard token.
158  * @dev https://github.com/ethereum/EIPs/issues/20
159  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
160  */
161 contract StandardToken is ERC20, BasicToken {
162 
163   mapping (address => mapping (address => uint256)) allowed;
164 
165 
166   /**
167    * @dev Transfer tokens from one address to another
168    * @param _from address The address which you want to send tokens from
169    * @param _to address The address which you want to transfer to
170    * @param _value uint256 the amount of tokens to be transferred
171    */
172   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
173     require(_to != address(0));
174 
175     uint256 _allowance = allowed[_from][msg.sender];
176 
177     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
178     // require (_value <= _allowance);
179 
180     balances[_from] = balances[_from].sub(_value);
181     balances[_to] = balances[_to].add(_value);
182     allowed[_from][msg.sender] = _allowance.sub(_value);
183     Transfer(_from, _to, _value);
184     return true;
185   }
186 
187   /**
188    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
189    *
190    * Beware that changing an allowance with this method brings the risk that someone may use both the old
191    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
192    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
193    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
194    * @param _spender The address which will spend the funds.
195    * @param _value The amount of tokens to be spent.
196    */
197   function approve(address _spender, uint256 _value) public returns (bool) {
198     allowed[msg.sender][_spender] = _value;
199     Approval(msg.sender, _spender, _value);
200     return true;
201   }
202 
203   /**
204    * @dev Function to check the amount of tokens that an owner allowed to a spender.
205    * @param _owner address The address which owns the funds.
206    * @param _spender address The address which will spend the funds.
207    * @return A uint256 specifying the amount of tokens still available for the spender.
208    */
209   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
210     return allowed[_owner][_spender];
211   }
212 
213   /**
214    * approve should be called when allowed[_spender] == 0. To increment
215    * allowed value is better to use this function to avoid 2 calls (and wait until
216    * the first transaction is mined)
217    * From MonolithDAO Token.sol
218    */
219   function increaseApproval (address _spender, uint _addedValue)
220     returns (bool success) {
221     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
222     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
223     return true;
224   }
225 
226   function decreaseApproval (address _spender, uint _subtractedValue)
227     returns (bool success) {
228     uint oldValue = allowed[msg.sender][_spender];
229     if (_subtractedValue > oldValue) {
230       allowed[msg.sender][_spender] = 0;
231     } else {
232       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
233     }
234     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
235     return true;
236   }
237 }
238 
239 
240 /**
241  * @title Burnable Token
242  * @dev Token that can be irreversibly burned (destroyed).
243  */
244 contract BurnableToken is StandardToken {
245 
246     event Burn(address indexed burner, uint256 value);
247 
248     /**
249      * @dev Burns a specific amount of tokens.
250      * @param _value The amount of token to be burned.
251      */
252     function burn(uint256 _value) public {
253         require(_value > 0);
254         require(_value <= balances[msg.sender]);
255         // no need to require value <= totalSupply, since that would imply the
256         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
257 
258         address burner = msg.sender;
259         balances[burner] = balances[burner].sub(_value);
260         totalSupply = totalSupply.sub(_value);
261         Burn(burner, _value);
262     }
263 }
264 
265 contract KriosCoin  is BurnableToken, Ownable {
266 
267     string public constant name = "KriosCoin";
268     string public constant symbol = "KRI";
269     uint public constant decimals = 18;
270     uint256 public constant initialSupply = 650000000 * (10 ** uint256(decimals));
271 
272     // Constructor
273     function KriosCoin () {
274         totalSupply = initialSupply;
275         balances[msg.sender] = initialSupply; // Send all tokens to owner
276         /*****************************************/
277         addresses[1] = msg.sender;
278         indexes[msg.sender] = 1;
279         lastIndex = 1;
280         /*****************************************/
281     }
282 
283     function getAddresses() constant returns (address[]){
284         address[] memory addrs = new address[](lastIndex);
285         for(uint i = 0; i < lastIndex; i++){
286             addrs[i] = addresses[i+1];
287         }
288         return addrs;
289     }
290 
291     function distributeTokens(uint _amount, uint startIndex, uint endIndex) onlyOwner returns (uint) {
292         if(balances[owner] < _amount) throw;
293         uint distributed = 0;
294 
295         for(uint i = startIndex; i < endIndex; i++){
296             address holder = addresses[i+1];
297             uint reward = _amount * balances[holder] / totalSupply;
298             balances[holder] += reward;
299             distributed += reward;
300             Transfer(owner, holder, reward);
301         }
302 
303         balances[owner] -= distributed;
304         return distributed;
305     }    
306 }