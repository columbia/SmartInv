1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract ERC20Basic {
46   function totalSupply() public view returns (uint256);
47   function balanceOf(address who) public view returns (uint256);
48   function transfer(address to, uint256 value) public returns (bool);
49   event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 
52 contract ERC20 is ERC20Basic {
53   function allowance(address owner, address spender) public view returns (uint256);
54   function transferFrom(address from, address to, uint256 value) public returns (bool);
55   function approve(address spender, uint256 value) public returns (bool);
56   event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 contract Ownable {
60   address public owner;
61 
62 
63   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
64 
65 
66   /**
67    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
68    * account.
69    */
70   function Ownable() public {
71     owner = msg.sender;
72   }
73 
74   /**
75    * @dev Throws if called by any account other than the owner.
76    */
77   modifier onlyOwner() {
78     require(msg.sender == owner);
79     _;
80   }
81 
82   /**
83    * @dev Allows the current owner to transfer control of the contract to a newOwner.
84    * @param newOwner The address to transfer ownership to.
85    */
86   function transferOwnership(address newOwner) public onlyOwner {
87     require(newOwner != address(0));
88     OwnershipTransferred(owner, newOwner);
89     owner = newOwner;
90   }
91 
92 }
93 
94 contract BasicToken is ERC20Basic {
95   using SafeMath for uint256;
96 
97   mapping(address => uint256) balances;
98 
99   uint256 totalSupply_;
100 
101   /**
102   * @dev total number of tokens in existence
103   */
104   function totalSupply() public view returns (uint256) {
105     return totalSupply_;
106   }
107 
108   /**
109   * @dev transfer token for a specified address
110   * @param _to The address to transfer to.
111   * @param _value The amount to be transferred.
112   */
113   function transfer(address _to, uint256 _value) public returns (bool) {
114     require(_to != address(0));
115     require(_value <= balances[msg.sender]);
116 
117     // SafeMath.sub will throw if there is not enough balance.
118     balances[msg.sender] = balances[msg.sender].sub(_value);
119     balances[_to] = balances[_to].add(_value);
120     Transfer(msg.sender, _to, _value);
121     return true;
122   }
123 
124   /**
125   * @dev Gets the balance of the specified address.
126   * @param _owner The address to query the the balance of.
127   * @return An uint256 representing the amount owned by the passed address.
128   */
129   function balanceOf(address _owner) public view returns (uint256 balance) {
130     return balances[_owner];
131   }
132 
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
223 contract ThemisToken is Ownable, StandardToken {
224 
225   string public constant name = "Themis Token";
226   string public constant symbol = "THM";
227   uint8 public constant decimals = 18;
228 
229   uint256 public angelSupply;                            // Angels sale supply
230   uint256 public earlyBirdsSupply;                       // Early birds supply
231   uint256 public foundationSupply;                       // Foundation/Community supply
232   uint256 public teamSupply;                             // Team supply
233   uint256 public marketingSupply;                        // Marketing & strategic supply
234   uint256 public optionSupply;                           // Option supply
235 
236   address public angelAddress;                           // Angel address
237   address public earlyBirdsAddress;                      // Early Birds address
238   address public teamAddress;                            // Team address
239   address public foundationAddress;                      // Foundation address
240   address public marketingAddress;                       // Marketing address
241   address public optionAddress;                          // Option address
242 
243   /**
244    * @dev Constructor that gives msg.sender all of existing tokens.
245    */
246   function ThemisToken() public {
247     totalSupply_        =  3000000000 * 1e18;
248     angelSupply         =   300000000 * 1e18;             //  10% -  for private angels sale
249     earlyBirdsSupply    =   600000000 * 1e18;             //  20% -  for early-bird sale
250     teamSupply          =   450000000 * 1e18;             //  15% -  for team
251     foundationSupply    =   750000000 * 1e18;             //  25% -  for foundation/incentivising efforts
252     marketingSupply     =   600000000 * 1e18;             //  20% -  for covering marketing and strategic expenses
253     optionSupply        =   300000000 * 1e18;             //  10% -  for option
254 
255     angelAddress         = 0xD58aE13Eb1e8CDb92088709A6868d32C993FAd74;  // Angel address
256     earlyBirdsAddress    = 0xac9EaB9C4c403441fb8592529A3cE534E68246ED;  // Early Birds address
257     teamAddress          = 0x4d06220df2BC77C3E47b72611AA79915611Ed23B;  // Team address
258     foundationAddress    = 0xDa2AB3712A490cC6Df661E3ae398BeA24434349F;  // Foundation/Community address
259     marketingAddress     = 0x9f160Ed0F3B8d5180Eb5cC97c43CF7Fe1efFE02C;  // Marketing/Strategic address
260     optionAddress        = 0x47343c223F3605aC541a8eC61e5Fd41EBDdEc9d1;  // Option address
261 
262     releaseAngelTokens();
263     releaseEarlyBirdsTokens();
264     releaseFoundationTokens();
265     releaseTeamTokens();
266     releaseMarketingTokens();
267     releaseOptionTokens();
268 
269     //balances[msg.sender] = totalSupply_;
270     //Transfer(0x0, msg.sender, totalSupply_);
271   }
272 
273   // -------------------------------------------------
274   // Releases angel supply
275   // -------------------------------------------------
276   function releaseAngelTokens() internal returns(bool success) {
277       require(angelSupply > 0);
278       balances[angelAddress] = angelSupply;
279       Transfer(0x0, angelAddress, angelSupply);
280       angelSupply = 0;
281       return true;
282   }
283 
284   // -------------------------------------------------
285   // Releases earlybirds supply
286   // -------------------------------------------------
287   function releaseEarlyBirdsTokens() internal returns(bool success) {
288       require(earlyBirdsSupply > 0);
289       balances[earlyBirdsAddress] = earlyBirdsSupply;
290       Transfer(0x0, earlyBirdsAddress, earlyBirdsSupply);
291       earlyBirdsSupply = 0;
292       return true;
293   }
294 
295   // -------------------------------------------------
296   // Releases team supply
297   // -------------------------------------------------
298   function releaseTeamTokens() internal returns(bool success) {
299     require(teamSupply > 0);
300     balances[teamAddress] = teamSupply;
301     Transfer(0x0, teamAddress, teamSupply);
302     teamSupply = 0;
303     return true;
304   }
305 
306   // -------------------------------------------------
307   // Releases foundation supply
308   // -------------------------------------------------
309   function releaseFoundationTokens() internal returns(bool success) {
310     require(foundationSupply > 0);
311     balances[foundationAddress] = foundationSupply;
312     Transfer(0x0, foundationAddress, foundationSupply);
313     foundationSupply = 0;
314     return true;
315   }
316 
317   // -------------------------------------------------
318   // Releases Marketing supply
319   // -------------------------------------------------
320   function releaseMarketingTokens() internal returns(bool success) {
321     require(marketingSupply > 0);
322     balances[marketingAddress] = marketingSupply;
323     Transfer(0x0, marketingAddress, marketingSupply);
324     marketingSupply = 0;
325     return true;
326   }
327 
328   // -------------------------------------------------
329   // Releases Option supply
330   // -------------------------------------------------
331   function releaseOptionTokens() internal returns(bool success) {
332       require(optionSupply > 0);
333       balances[optionAddress] = optionSupply;
334       Transfer(0x0, optionAddress, optionSupply);
335       optionSupply = 0;
336       return true;
337   }
338 
339 }