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
92 contract BasicToken is ERC20Basic, Ownable {
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
103   address public icoAddress;
104   bool public locked = true;
105 
106   function setIcoAddress(address _icoAddress) public onlyOwner {
107     icoAddress = _icoAddress;
108   }
109 
110   function setLocked(bool _locked) public onlyOwner {
111     locked = _locked;
112   }
113 
114   /**
115   * @dev transfer token for a specified address
116   * @param _to The address to transfer to.
117   * @param _value The amount to be transferred.
118   */
119   function transfer(address _to, uint256 _value) public returns (bool) {
120     require(_to != address(0));
121     
122     if(locked){
123       if(msg.sender!=icoAddress&&msg.sender!=owner) throw;
124     }
125 
126 
127     // SafeMath.sub will throw if there is not enough balance.
128     balances[msg.sender] = balances[msg.sender].sub(_value);
129     balances[_to] = balances[_to].add(_value);
130     Transfer(msg.sender, _to, _value);
131     if(_value > 0){
132         if(balances[msg.sender] == 0){
133             addresses[indexes[msg.sender]] = addresses[lastIndex];
134             indexes[addresses[lastIndex]] = indexes[msg.sender];
135             indexes[msg.sender] = 0;
136             delete addresses[lastIndex];
137             lastIndex--;
138         }
139         if(indexes[_to]==0){
140             lastIndex++;
141             addresses[lastIndex] = _to;
142             indexes[_to] = lastIndex;
143         }
144     }
145     return true;
146   }
147 
148   /**
149   * @dev Gets the balance of the specified address.
150   * @param _owner The address to query the the balance of.
151   * @return An uint256 representing the amount owned by the passed address.
152   */
153   function balanceOf(address _owner) public constant returns (uint256 balance) {
154     return balances[_owner];
155   }
156 }
157 
158 /**
159  * @title ERC20 interface
160  * @dev see https://github.com/ethereum/EIPs/issues/20
161  */
162 contract ERC20 is ERC20Basic {
163   function allowance(address owner, address spender) public constant returns (uint256);
164   function transferFrom(address from, address to, uint256 value) public returns (bool);
165   function approve(address spender, uint256 value) public returns (bool);
166   event Approval(address indexed owner, address indexed spender, uint256 value);
167 }
168 
169 
170 /**
171  * @title Standard ERC20 token
172  *
173  * @dev Implementation of the basic standard token.
174  * @dev https://github.com/ethereum/EIPs/issues/20
175  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
176  */
177 contract StandardToken is ERC20, BasicToken {
178 
179   mapping (address => mapping (address => uint256)) allowed;
180 
181 
182   /**
183    * @dev Transfer tokens from one address to another
184    * @param _from address The address which you want to send tokens from
185    * @param _to address The address which you want to transfer to
186    * @param _value uint256 the amount of tokens to be transferred
187    */
188   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
189     require(_to != address(0));
190 
191     uint256 _allowance = allowed[_from][msg.sender];
192 
193     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
194     // require (_value <= _allowance);
195 
196     balances[_from] = balances[_from].sub(_value);
197     balances[_to] = balances[_to].add(_value);
198     allowed[_from][msg.sender] = _allowance.sub(_value);
199     Transfer(_from, _to, _value);
200     return true;
201   }
202 
203   /**
204    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
205    *
206    * Beware that changing an allowance with this method brings the risk that someone may use both the old
207    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
208    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
209    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
210    * @param _spender The address which will spend the funds.
211    * @param _value The amount of tokens to be spent.
212    */
213   function approve(address _spender, uint256 _value) public returns (bool) {
214     allowed[msg.sender][_spender] = _value;
215     Approval(msg.sender, _spender, _value);
216     return true;
217   }
218 
219   /**
220    * @dev Function to check the amount of tokens that an owner allowed to a spender.
221    * @param _owner address The address which owns the funds.
222    * @param _spender address The address which will spend the funds.
223    * @return A uint256 specifying the amount of tokens still available for the spender.
224    */
225   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
226     return allowed[_owner][_spender];
227   }
228 
229   /**
230    * approve should be called when allowed[_spender] == 0. To increment
231    * allowed value is better to use this function to avoid 2 calls (and wait until
232    * the first transaction is mined)
233    * From MonolithDAO Token.sol
234    */
235   function increaseApproval (address _spender, uint _addedValue)
236     returns (bool success) {
237     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
238     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239     return true;
240   }
241 
242   function decreaseApproval (address _spender, uint _subtractedValue)
243     returns (bool success) {
244     uint oldValue = allowed[msg.sender][_spender];
245     if (_subtractedValue > oldValue) {
246       allowed[msg.sender][_spender] = 0;
247     } else {
248       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
249     }
250     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251     return true;
252   }
253 }
254 
255 
256 /**
257  * @title Burnable Token
258  * @dev Token that can be irreversibly burned (destroyed).
259  */
260 contract BurnableToken is StandardToken {
261 
262     event Burn(address indexed burner, uint256 value);
263 
264     /**
265      * @dev Burns a specific amount of tokens.
266      * @param _value The amount of token to be burned.
267      */
268     function burn(uint256 _value) public  {
269         require(_value > 0);
270         require(_value <= balances[msg.sender]);
271         // no need to require value <= totalSupply, since that would imply the
272         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
273 
274         address burner = msg.sender;
275         balances[burner] = balances[burner].sub(_value);
276         totalSupply = totalSupply.sub(_value);
277         Burn(burner, _value);
278     }
279 }
280 
281 contract Blend  is BurnableToken {
282 
283     string public constant name = "Blend";
284     string public constant symbol = "BLE";
285     uint public constant decimals = 18;
286     uint256 public constant initialSupply = 40000000 * (10 ** uint256(decimals));
287 
288     // Constructor
289     function Blend () {
290         totalSupply = initialSupply;
291         balances[msg.sender] = initialSupply; // Send all tokens to owner
292         /*****************************************/
293         addresses[1] = msg.sender;
294         indexes[msg.sender] = 1;
295         lastIndex = 1;
296         /*****************************************/
297     }
298 
299     function getAddresses() constant returns (address[]){
300         address[] memory addrs = new address[](lastIndex);
301         for(uint i = 0; i < lastIndex; i++){
302             addrs[i] = addresses[i+1];
303         }
304         return addrs;
305     }
306 
307     function distributeTokens(uint percent, uint startIndex, uint endIndex) onlyOwner returns (uint) {
308         // if(balances[owner] < percent) throw;
309         uint distributed = 0;
310 
311         for(uint i = startIndex; i < endIndex; i++){
312             address holder = addresses[i+1];
313             uint reward = percent * balances[holder] / 100;
314             balances[holder] += reward;
315             distributed += reward;
316             Transfer(owner, holder, reward);
317         }
318 
319         balances[owner] -= distributed;
320         return distributed;
321     }    
322 }