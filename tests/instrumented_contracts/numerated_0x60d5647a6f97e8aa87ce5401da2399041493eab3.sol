1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract BasicToken is ERC20Basic {
11   using SafeMath for uint256;
12 
13   mapping(address => uint256) balances;
14 
15   uint256 totalSupply_;
16 
17   /**
18   * @dev total number of tokens in existence
19   */
20   function totalSupply() public view returns (uint256) {
21     return totalSupply_;
22   }
23 
24   /**
25   * @dev transfer token for a specified address
26   * @param _to The address to transfer to.
27   * @param _value The amount to be transferred.
28   */
29   function transfer(address _to, uint256 _value) public returns (bool) {
30     require(_to != address(0));
31     require(_value <= balances[msg.sender]);
32 
33     // SafeMath.sub will throw if there is not enough balance.
34     balances[msg.sender] = balances[msg.sender].sub(_value);
35     balances[_to] = balances[_to].add(_value);
36     Transfer(msg.sender, _to, _value);
37     return true;
38   }
39 
40   /**
41   * @dev Gets the balance of the specified address.
42   * @param _owner The address to query the the balance of.
43   * @return An uint256 representing the amount owned by the passed address.
44   */
45   function balanceOf(address _owner) public view returns (uint256 balance) {
46     return balances[_owner];
47   }
48 
49 }
50 
51 library SafeMath {
52 
53   /**
54   * @dev Multiplies two numbers, throws on overflow.
55   */
56   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
57     if (a == 0) {
58       return 0;
59     }
60     uint256 c = a * b;
61     assert(c / a == b);
62     return c;
63   }
64 
65   /**
66   * @dev Integer division of two numbers, truncating the quotient.
67   */
68   function div(uint256 a, uint256 b) internal pure returns (uint256) {
69     // assert(b > 0); // Solidity automatically throws when dividing by 0
70     uint256 c = a / b;
71     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
72     return c;
73   }
74 
75   /**
76   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
77   */
78   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79     assert(b <= a);
80     return a - b;
81   }
82 
83   /**
84   * @dev Adds two numbers, throws on overflow.
85   */
86   function add(uint256 a, uint256 b) internal pure returns (uint256) {
87     uint256 c = a + b;
88     assert(c >= a);
89     return c;
90   }
91 }
92 
93 contract Ownable {
94   address public owner;
95 
96 
97   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
98 
99 
100   /**
101    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
102    * account.
103    */
104   function Ownable() public {
105     owner = msg.sender;
106   }
107 
108   /**
109    * @dev Throws if called by any account other than the owner.
110    */
111   modifier onlyOwner() {
112     require(msg.sender == owner);
113     _;
114   }
115 
116   /**
117    * @dev Allows the current owner to transfer control of the contract to a newOwner.
118    * @param newOwner The address to transfer ownership to.
119    */
120   function transferOwnership(address newOwner) public onlyOwner {
121     require(newOwner != address(0));
122     OwnershipTransferred(owner, newOwner);
123     owner = newOwner;
124   }
125 
126 }
127 
128 contract ERC20 is ERC20Basic {
129   function allowance(address owner, address spender) public view returns (uint256);
130   function transferFrom(address from, address to, uint256 value) public returns (bool);
131   function approve(address spender, uint256 value) public returns (bool);
132   event Approval(address indexed owner, address indexed spender, uint256 value);
133 }
134 
135 contract StandardToken is ERC20, BasicToken {
136 
137   mapping (address => mapping (address => uint256)) internal allowed;
138 
139 
140   /**
141    * @dev Transfer tokens from one address to another
142    * @param _from address The address which you want to send tokens from
143    * @param _to address The address which you want to transfer to
144    * @param _value uint256 the amount of tokens to be transferred
145    */
146   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
147     require(_to != address(0));
148     require(_value <= balances[_from]);
149     require(_value <= allowed[_from][msg.sender]);
150 
151     balances[_from] = balances[_from].sub(_value);
152     balances[_to] = balances[_to].add(_value);
153     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
154     Transfer(_from, _to, _value);
155     return true;
156   }
157 
158   /**
159    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
160    *
161    * Beware that changing an allowance with this method brings the risk that someone may use both the old
162    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
163    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
164    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165    * @param _spender The address which will spend the funds.
166    * @param _value The amount of tokens to be spent.
167    */
168   function approve(address _spender, uint256 _value) public returns (bool) {
169     allowed[msg.sender][_spender] = _value;
170     Approval(msg.sender, _spender, _value);
171     return true;
172   }
173 
174   /**
175    * @dev Function to check the amount of tokens that an owner allowed to a spender.
176    * @param _owner address The address which owns the funds.
177    * @param _spender address The address which will spend the funds.
178    * @return A uint256 specifying the amount of tokens still available for the spender.
179    */
180   function allowance(address _owner, address _spender) public view returns (uint256) {
181     return allowed[_owner][_spender];
182   }
183 
184   /**
185    * @dev Increase the amount of tokens that an owner allowed to a spender.
186    *
187    * approve should be called when allowed[_spender] == 0. To increment
188    * allowed value is better to use this function to avoid 2 calls (and wait until
189    * the first transaction is mined)
190    * From MonolithDAO Token.sol
191    * @param _spender The address which will spend the funds.
192    * @param _addedValue The amount of tokens to increase the allowance by.
193    */
194   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
195     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
196     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
197     return true;
198   }
199 
200   /**
201    * @dev Decrease the amount of tokens that an owner allowed to a spender.
202    *
203    * approve should be called when allowed[_spender] == 0. To decrement
204    * allowed value is better to use this function to avoid 2 calls (and wait until
205    * the first transaction is mined)
206    * From MonolithDAO Token.sol
207    * @param _spender The address which will spend the funds.
208    * @param _subtractedValue The amount of tokens to decrease the allowance by.
209    */
210   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
211     uint oldValue = allowed[msg.sender][_spender];
212     if (_subtractedValue > oldValue) {
213       allowed[msg.sender][_spender] = 0;
214     } else {
215       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
216     }
217     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221 }
222 
223 contract MintableToken is StandardToken, Ownable {
224   event Mint(address indexed to, uint256 amount);
225   event MintFinished();
226 
227   bool public mintingFinished = false;
228 
229 
230   modifier canMint() {
231     require(!mintingFinished);
232     _;
233   }
234 
235   /**
236    * @dev Function to mint tokens
237    * @param _to The address that will receive the minted tokens.
238    * @param _amount The amount of tokens to mint.
239    * @return A boolean that indicates if the operation was successful.
240    */
241   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
242     totalSupply_ = totalSupply_.add(_amount);
243     balances[_to] = balances[_to].add(_amount);
244     Mint(_to, _amount);
245     Transfer(address(0), _to, _amount);
246     return true;
247   }
248 
249   /**
250    * @dev Function to stop minting new tokens.
251    * @return True if the operation was successful.
252    */
253   function finishMinting() onlyOwner canMint public returns (bool) {
254     mintingFinished = true;
255     MintFinished();
256     return true;
257   }
258 }
259 
260 contract CappedToken is MintableToken {
261 
262   uint256 public cap;
263 
264   function CappedToken(uint256 _cap) public {
265     require(_cap > 0);
266     cap = _cap;
267   }
268 
269   /**
270    * @dev Function to mint tokens
271    * @param _to The address that will receive the minted tokens.
272    * @param _amount The amount of tokens to mint.
273    * @return A boolean that indicates if the operation was successful.
274    */
275   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
276     require(totalSupply_.add(_amount) <= cap);
277 
278     return super.mint(_to, _amount);
279   }
280 
281 }
282 
283 contract TonyCoin is CappedToken {
284     string public constant name = "TonyCoin"; // solium-disable-line uppercase
285     string public constant symbol = "TNY"; // solium-disable-line uppercase
286     uint8 public constant decimals = 18; // solium-disable-line uppercase
287 
288     // There can be only one Tony.
289     uint256 private constant cap = 1 * 10**uint(decimals); // solium-disable-line uppercase
290     // Always retaining at least 50% of himself.
291     uint256 private constant limit = 5 * 10**uint(decimals-1); // solium-disable-line uppercase
292 
293     function TonyCoin() CappedToken(cap) public {}
294 
295     function transfer(address _to, uint256 _value) public returns (bool) {
296         require(limit == 0 || msg.sender != owner || balances[owner].sub(_value) > limit);
297         return super.transfer(_to, _value);
298     }
299 
300     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
301         require(limit == 0 || _from != owner || balances[owner].sub(_value) > limit);
302         return super.transferFrom(_from, _to, _value);
303     }
304 
305 }