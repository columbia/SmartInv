1 pragma solidity ^0.4.18;
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
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() public {
35     owner = msg.sender;
36   }
37 
38   /**
39    * @dev Throws if called by any account other than the owner.
40    */
41   modifier onlyOwner() {
42     require(msg.sender == owner);
43     _;
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address newOwner) public onlyOwner {
51     require(newOwner != address(0));
52     OwnershipTransferred(owner, newOwner);
53     owner = newOwner;
54   }
55 
56 }
57 
58 
59 
60 
61 
62 
63 
64 
65 
66 
67 
68 
69 
70 /**
71  * @title SafeMath
72  * @dev Math operations with safety checks that throw on error
73  */
74 library SafeMath {
75 
76   /**
77   * @dev Multiplies two numbers, throws on overflow.
78   */
79   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80     if (a == 0) {
81       return 0;
82     }
83     uint256 c = a * b;
84     assert(c / a == b);
85     return c;
86   }
87 
88   /**
89   * @dev Integer division of two numbers, truncating the quotient.
90   */
91   function div(uint256 a, uint256 b) internal pure returns (uint256) {
92     // assert(b > 0); // Solidity automatically throws when dividing by 0
93     uint256 c = a / b;
94     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
95     return c;
96   }
97 
98   /**
99   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
100   */
101   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
102     assert(b <= a);
103     return a - b;
104   }
105 
106   /**
107   * @dev Adds two numbers, throws on overflow.
108   */
109   function add(uint256 a, uint256 b) internal pure returns (uint256) {
110     uint256 c = a + b;
111     assert(c >= a);
112     return c;
113   }
114 }
115 
116 
117 
118 
119 /**
120  * @title Basic token
121  * @dev Basic version of StandardToken, with no allowances.
122  */
123 contract BasicToken is ERC20Basic, Ownable {
124   using SafeMath for uint256;
125 
126   mapping(address => uint256) balances;
127 
128   uint256 totalSupply_;
129 
130   /**
131   * @dev total number of tokens in existence
132   */
133   function totalSupply() public view returns (uint256) {
134     return totalSupply_;
135   }
136 
137   /**
138   * @dev transfer token for a specified address
139   * @param _to The address to transfer to.
140   * @param _value The amount to be transferred.
141   */
142   function transfer(address _to, uint256 _value) public returns (bool) {
143     require(_to != address(0));
144     require(_value <= balances[msg.sender]);
145 
146     // SafeMath.sub will throw if there is not enough balance.
147     balances[msg.sender] = balances[msg.sender].sub(_value);
148     balances[_to] = balances[_to].add(_value);
149     Transfer(msg.sender, _to, _value);
150     return true;
151   }
152 
153   /**
154   * @dev Gets the balance of the specified address.
155   * @param _owner The address to query the the balance of.
156   * @return An uint256 representing the amount owned by the passed address.
157   */
158   function balanceOf(address _owner) public view returns (uint256 balance) {
159     return balances[_owner];
160   }
161   
162   event Burn(address indexed burner, uint256 value);
163 
164   /**
165    * @dev Burns a specific amount of tokens.
166    * @param _value The amount of token to be burned.
167    */
168   function burn(uint256 _value) public onlyOwner {
169     require(_value <= balances[msg.sender]);
170     // no need to require value <= totalSupply, since that would imply the
171     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
172     uint256 tokensToBurn = SafeMath.mul(_value,1000000000000000000);
173     address burner = msg.sender;
174     balances[burner] = balances[burner].sub(tokensToBurn);
175     totalSupply_ = totalSupply_.sub(tokensToBurn);
176     Burn(burner, tokensToBurn);
177   }
178 
179 }
180 
181 
182 
183 
184 
185 
186 /**
187  * @title ERC20 interface
188  * @dev see https://github.com/ethereum/EIPs/issues/20
189  */
190 contract ERC20 is ERC20Basic {
191   function allowance(address owner, address spender) public view returns (uint256);
192   function transferFrom(address from, address to, uint256 value) public returns (bool);
193   function approve(address spender, uint256 value) public returns (bool);
194   event Approval(address indexed owner, address indexed spender, uint256 value);
195 }
196 
197 
198 
199 /**
200  * @title Standard ERC20 token
201  *
202  * @dev Implementation of the basic standard token.
203  * @dev https://github.com/ethereum/EIPs/issues/20
204  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
205  */
206 contract StandardToken is ERC20, BasicToken {
207 
208   mapping (address => mapping (address => uint256)) internal allowed;
209 
210 
211   /**
212    * @dev Transfer tokens from one address to another
213    * @param _from address The address which you want to send tokens from
214    * @param _to address The address which you want to transfer to
215    * @param _value uint256 the amount of tokens to be transferred
216    */
217   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
218     require(_to != address(0));
219     require(_value <= balances[_from]);
220     require(_value <= allowed[_from][msg.sender]);
221 
222     balances[_from] = balances[_from].sub(_value);
223     balances[_to] = balances[_to].add(_value);
224     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
225     Transfer(_from, _to, _value);
226     return true;
227   }
228 
229   /**
230    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
231    *
232    * Beware that changing an allowance with this method brings the risk that someone may use both the old
233    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
234    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
235    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
236    * @param _spender The address which will spend the funds.
237    * @param _value The amount of tokens to be spent.
238    */
239   function approve(address _spender, uint256 _value) public returns (bool) {
240     allowed[msg.sender][_spender] = _value;
241     Approval(msg.sender, _spender, _value);
242     return true;
243   }
244 
245   /**
246    * @dev Function to check the amount of tokens that an owner allowed to a spender.
247    * @param _owner address The address which owns the funds.
248    * @param _spender address The address which will spend the funds.
249    * @return A uint256 specifying the amount of tokens still available for the spender.
250    */
251   function allowance(address _owner, address _spender) public view returns (uint256) {
252     return allowed[_owner][_spender];
253   }
254 
255   /**
256    * @dev Increase the amount of tokens that an owner allowed to a spender.
257    *
258    * approve should be called when allowed[_spender] == 0. To increment
259    * allowed value is better to use this function to avoid 2 calls (and wait until
260    * the first transaction is mined)
261    * From MonolithDAO Token.sol
262    * @param _spender The address which will spend the funds.
263    * @param _addedValue The amount of tokens to increase the allowance by.
264    */
265   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
266     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
267     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
268     return true;
269   }
270 
271   /**
272    * @dev Decrease the amount of tokens that an owner allowed to a spender.
273    *
274    * approve should be called when allowed[_spender] == 0. To decrement
275    * allowed value is better to use this function to avoid 2 calls (and wait until
276    * the first transaction is mined)
277    * From MonolithDAO Token.sol
278    * @param _spender The address which will spend the funds.
279    * @param _subtractedValue The amount of tokens to decrease the allowance by.
280    */
281   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
282     uint oldValue = allowed[msg.sender][_spender];
283     if (_subtractedValue > oldValue) {
284       allowed[msg.sender][_spender] = 0;
285     } else {
286       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
287     }
288     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
289     return true;
290   }
291 
292 }
293 
294 
295 
296 /**
297  * @title Mintable token
298  * @dev Simple ERC20 Token example, with mintable token creation
299  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
300  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
301  */
302 contract MintableToken is StandardToken {
303   event Mint(address indexed to, uint256 amount);
304   event MintFinished();
305 
306   bool public mintingFinished = false;
307   
308   uint256 public cap = 30000000000000000000000000; //30M token cap
309 
310 
311   modifier canMint() {
312     require(!mintingFinished);
313     _;
314   }
315 
316   /**
317    * @dev Function to mint tokens
318    * @param _to The address that will receive the minted tokens.
319    * @param _amount The amount of tokens to mint.
320    * @return A boolean that indicates if the operation was successful.
321    */
322   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
323     require(totalSupply_.add(_amount) <= cap);
324     totalSupply_ = totalSupply_.add(_amount);
325     balances[_to] = balances[_to].add(_amount);
326     Mint(_to, _amount);
327     Transfer(address(0), _to, _amount);
328     return true;
329   }
330 
331   /**
332    * @dev Function to stop minting new tokens.
333    * @return True if the operation was successful.
334    */
335   function finishMinting() onlyOwner canMint public returns (bool) {
336     mintingFinished = true;
337     MintFinished();
338     return true;
339   }
340 }
341 
342 
343 
344 
345 contract EtceteraToken is MintableToken {
346 
347   string public constant name = "Etcetera"; 
348   string public constant symbol = "ERA"; 
349   uint8 public constant decimals = 18;
350   
351   uint256 private constant founderTokens = 3000000000000000000000000; //3M tokens
352 
353     function EtceteraToken() public {
354     totalSupply_ = founderTokens;
355     balances[msg.sender] = founderTokens;
356     Transfer(0x0, msg.sender, founderTokens);
357     }
358 
359 }