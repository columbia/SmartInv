1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 
45 
46 /**
47  * @title ERC20Basic
48  * @dev Simpler version of ERC20 interface
49  * @dev see https://github.com/ethereum/EIPs/issues/179
50  */
51 contract ERC20Basic {
52   function totalSupply() public view returns (uint256);
53   function balanceOf(address who) public view returns (uint256);
54   function transfer(address to, uint256 value) public returns (bool);
55   event Transfer(address indexed from, address indexed to, uint256 value);
56 }
57 
58 
59 
60 
61 
62 
63 
64 /**
65  * @title ERC20 interface
66  * @dev see https://github.com/ethereum/EIPs/issues/20
67  */
68 contract ERC20 is ERC20Basic {
69   function allowance(address owner, address spender) public view returns (uint256);
70   function transferFrom(address from, address to, uint256 value) public returns (bool);
71   function approve(address spender, uint256 value) public returns (bool);
72   event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 
76 
77 
78 
79 
80 
81 
82 
83 
84 
85 
86 /**
87  * @title SafeMath
88  * @dev Math operations with safety checks that throw on error
89  */
90 library SafeMath {
91 
92   /**
93   * @dev Multiplies two numbers, throws on overflow.
94   */
95   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
96     if (a == 0) {
97       return 0;
98     }
99     uint256 c = a * b;
100     assert(c / a == b);
101     return c;
102   }
103 
104   /**
105   * @dev Integer division of two numbers, truncating the quotient.
106   */
107   function div(uint256 a, uint256 b) internal pure returns (uint256) {
108     // assert(b > 0); // Solidity automatically throws when dividing by 0
109     uint256 c = a / b;
110     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
111     return c;
112   }
113 
114   /**
115   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
116   */
117   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118     assert(b <= a);
119     return a - b;
120   }
121 
122   /**
123   * @dev Adds two numbers, throws on overflow.
124   */
125   function add(uint256 a, uint256 b) internal pure returns (uint256) {
126     uint256 c = a + b;
127     assert(c >= a);
128     return c;
129   }
130 }
131 
132 
133 
134 /**
135  * @title Basic token
136  * @dev Basic version of StandardToken, with no allowances.
137  */
138 contract BasicToken is ERC20Basic {
139   using SafeMath for uint256;
140 
141   mapping(address => uint256) balances;
142 
143   uint256 totalSupply_;
144 
145   /**
146   * @dev total number of tokens in existence
147   */
148   function totalSupply() public view returns (uint256) {
149     return totalSupply_;
150   }
151 
152   /**
153   * @dev transfer token for a specified address
154   * @param _to The address to transfer to.
155   * @param _value The amount to be transferred.
156   */
157   function transfer(address _to, uint256 _value) public returns (bool) {
158     require(_to != address(0));
159     require(_value <= balances[msg.sender]);
160 
161     // SafeMath.sub will throw if there is not enough balance.
162     balances[msg.sender] = balances[msg.sender].sub(_value);
163     balances[_to] = balances[_to].add(_value);
164     Transfer(msg.sender, _to, _value);
165     return true;
166   }
167 
168   /**
169   * @dev Gets the balance of the specified address.
170   * @param _owner The address to query the the balance of.
171   * @return An uint256 representing the amount owned by the passed address.
172   */
173   function balanceOf(address _owner) public view returns (uint256 balance) {
174     return balances[_owner];
175   }
176 
177 }
178 
179 
180 
181 
182 /**
183  * @title Standard ERC20 token
184  *
185  * @dev Implementation of the basic standard token.
186  * @dev https://github.com/ethereum/EIPs/issues/20
187  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
188  */
189 contract StandardToken is ERC20, BasicToken {
190 
191   mapping (address => mapping (address => uint256)) internal allowed;
192 
193 
194   /**
195    * @dev Transfer tokens from one address to another
196    * @param _from address The address which you want to send tokens from
197    * @param _to address The address which you want to transfer to
198    * @param _value uint256 the amount of tokens to be transferred
199    */
200   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
201     require(_to != address(0));
202     require(_value <= balances[_from]);
203     require(_value <= allowed[_from][msg.sender]);
204 
205     balances[_from] = balances[_from].sub(_value);
206     balances[_to] = balances[_to].add(_value);
207     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
208     Transfer(_from, _to, _value);
209     return true;
210   }
211 
212   /**
213    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
214    *
215    * Beware that changing an allowance with this method brings the risk that someone may use both the old
216    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
217    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
218    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
219    * @param _spender The address which will spend the funds.
220    * @param _value The amount of tokens to be spent.
221    */
222   function approve(address _spender, uint256 _value) public returns (bool) {
223     allowed[msg.sender][_spender] = _value;
224     Approval(msg.sender, _spender, _value);
225     return true;
226   }
227 
228   /**
229    * @dev Function to check the amount of tokens that an owner allowed to a spender.
230    * @param _owner address The address which owns the funds.
231    * @param _spender address The address which will spend the funds.
232    * @return A uint256 specifying the amount of tokens still available for the spender.
233    */
234   function allowance(address _owner, address _spender) public view returns (uint256) {
235     return allowed[_owner][_spender];
236   }
237 
238   /**
239    * @dev Increase the amount of tokens that an owner allowed to a spender.
240    *
241    * approve should be called when allowed[_spender] == 0. To increment
242    * allowed value is better to use this function to avoid 2 calls (and wait until
243    * the first transaction is mined)
244    * From MonolithDAO Token.sol
245    * @param _spender The address which will spend the funds.
246    * @param _addedValue The amount of tokens to increase the allowance by.
247    */
248   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
249     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
250     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251     return true;
252   }
253 
254   /**
255    * @dev Decrease the amount of tokens that an owner allowed to a spender.
256    *
257    * approve should be called when allowed[_spender] == 0. To decrement
258    * allowed value is better to use this function to avoid 2 calls (and wait until
259    * the first transaction is mined)
260    * From MonolithDAO Token.sol
261    * @param _spender The address which will spend the funds.
262    * @param _subtractedValue The amount of tokens to decrease the allowance by.
263    */
264   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
265     uint oldValue = allowed[msg.sender][_spender];
266     if (_subtractedValue > oldValue) {
267       allowed[msg.sender][_spender] = 0;
268     } else {
269       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
270     }
271     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
272     return true;
273   }
274 
275 }
276 
277 
278 
279 
280 /**
281  * @title Mintable token
282  * @dev Simple ERC20 Token example, with mintable token creation
283  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
284  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
285  */
286 contract MintableToken is StandardToken, Ownable {
287   event Mint(address indexed to, uint256 amount);
288   event MintFinished();
289 
290   bool public mintingFinished = false;
291 
292 
293   modifier canMint() {
294     require(!mintingFinished);
295     _;
296   }
297 
298   /**
299    * @dev Function to mint tokens
300    * @param _to The address that will receive the minted tokens.
301    * @param _amount The amount of tokens to mint.
302    * @return A boolean that indicates if the operation was successful.
303    */
304   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
305     totalSupply_ = totalSupply_.add(_amount);
306     balances[_to] = balances[_to].add(_amount);
307     Mint(_to, _amount);
308     Transfer(address(0), _to, _amount);
309     return true;
310   }
311 
312   /**
313    * @dev Function to stop minting new tokens.
314    * @return True if the operation was successful.
315    */
316   function finishMinting() onlyOwner canMint public returns (bool) {
317     mintingFinished = true;
318     MintFinished();
319     return true;
320   }
321 }
322 
323 
324 contract NamaheToken is MintableToken {
325     string public name = "Namahe Ethical Value Chain Token";
326     string public symbol = "NMH";
327     uint8 public decimals = 18;
328 }