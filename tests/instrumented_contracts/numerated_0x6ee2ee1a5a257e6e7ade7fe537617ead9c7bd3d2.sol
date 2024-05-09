1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55   address public owner;
56 
57   event OwnershipRenounced(address indexed previousOwner);
58   event OwnershipTransferred(
59     address indexed previousOwner,
60     address indexed newOwner
61   );
62 
63   /**
64    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65    * account.
66    */
67   function Ownable() public {
68     owner = msg.sender;
69   }
70 
71   /**
72    * @dev Throws if called by any account other than the owner.
73    */
74   modifier onlyOwner() {
75     require(msg.sender == owner);
76     _;
77   }
78 
79   /**
80    * @dev Allows the current owner to transfer control of the contract to a newOwner.
81    * @param newOwner The address to transfer ownership to.
82    */
83   function transferOwnership(address newOwner) public onlyOwner {
84     require(newOwner != address(0));
85     emit OwnershipTransferred(owner, newOwner);
86     owner = newOwner;
87   }
88 
89   /**
90    * @dev Allows the current owner to relinquish control of the contract.
91    */
92   function renounceOwnership() public onlyOwner {
93     emit OwnershipRenounced(owner);
94     owner = address(0);
95   }
96 }
97 
98 /**
99  * @title Pausable
100  * @dev Base contract which allows children to implement an emergency stop mechanism.
101  */
102 contract Pausable is Ownable {
103   event Pause();
104   event Unpause();
105 
106   bool public paused = false;
107 
108 
109   /**
110    * @dev Modifier to make a function callable only when the contract is not paused.
111    */
112   modifier whenNotPaused() {
113     require(!paused);
114     _;
115   }
116 
117   /**
118    * @dev Modifier to make a function callable only when the contract is paused.
119    */
120   modifier whenPaused() {
121     require(paused);
122     _;
123   }
124 
125   /**
126    * @dev called by the owner to pause, triggers stopped state
127    */
128   function pause() onlyOwner whenNotPaused public {
129     paused = true;
130     emit Pause();
131   }
132 
133   /**
134    * @dev called by the owner to unpause, returns to normal state
135    */
136   function unpause() onlyOwner whenPaused public {
137     paused = false;
138     emit Unpause();
139   }
140 }
141 
142 contract ERC20Basic {
143   function totalSupply() public view returns (uint256);
144   function balanceOf(address who) public view returns (uint256);
145   function transfer(address to, uint256 value) public returns (bool);
146   event Transfer(address indexed from, address indexed to, uint256 value);
147 }
148 
149 contract BasicToken is ERC20Basic {
150   using SafeMath for uint256;
151     
152   mapping (address => uint256) balances;
153   uint256 totalSupply_;
154   
155   function totalSupply() public view returns (uint256) {
156     return totalSupply_;
157   }
158   
159     /**
160   * @dev transfer token for a specified address
161   * @param _to The address to transfer to.
162   * @param _value The amount to be transferred.
163   */
164   
165   function transfer(address _to, uint256 _value) public returns (bool) {
166     require(_to != address(0));
167     require(_value <= balances[msg.sender]);
168 
169     balances[msg.sender] = balances[msg.sender].sub(_value);
170     balances[_to] = balances[_to].add(_value);
171     emit Transfer(msg.sender, _to, _value);
172     return true;
173   }
174 
175   /**
176   * @dev Gets the balance of the specified address.
177   * @param _owner The address to query the the balance of. 
178   * @return An uint256 representing the amount owned by the passed address.
179   */
180   function balanceOf(address _owner) public view returns (uint256 balance) {
181     return balances[_owner];
182   }
183 }
184 
185 contract ERC20 is ERC20Basic {
186   function allowance(address owner, address spender) public view returns (uint256);
187   function transferFrom(address from, address to, uint256 value) public returns (bool);
188   function approve(address spender, uint256 value) public returns (bool);
189 }
190 
191 contract BurnableToken is BasicToken {
192 
193   event Burn(address indexed burner, uint256 value);
194 
195   /**
196    * @dev Burns a specific amount of tokens.
197    * @param _value The amount of token to be burned.
198    */
199   function burn(uint256 _value) public {
200     require(_value <= balances[msg.sender]);
201     // no need to require value <= totalSupply, since that would imply the
202     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
203 
204     address burner = msg.sender;
205     balances[burner] = balances[burner].sub(_value);
206     totalSupply_ = totalSupply_.sub(_value);
207     emit Burn(burner, _value);
208     emit Transfer(burner, address(0), _value);
209   }
210 }
211 
212 contract StandardToken is ERC20, BurnableToken {
213 
214   mapping (address => mapping (address => uint256)) allowed;
215 
216   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
217     
218     require(_to != address(0));
219     require(_value <= balances[_from]);
220     require(_value <= allowed[_from][msg.sender]);
221 
222     balances[_to] = balances[_to].add(_value);
223     balances[_from] = balances[_from].sub(_value);
224     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
225 
226     emit Transfer(_from, _to, _value);
227     return true;
228   }
229 
230   /**
231    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
232    * @param _spender The address which will spend the funds.
233    * @param _value The amount of tokens to be spent.
234    */
235   function approve(address _spender, uint256 _value) public returns (bool) {
236     allowed[msg.sender][_spender] = _value;
237     return true;
238   }
239 
240   /**
241    * @dev Function to check the amount of tokens that an owner allowed to a spender.
242    * @param _owner address The address which owns the funds.
243    * @param _spender address The address which will spend the funds.
244    * @return A uint256 specifing the amount of tokens still avaible for the spender.
245    */
246   function allowance(address _owner, address _spender) public view returns (uint256) {
247     return allowed[_owner][_spender];
248   }
249   
250 }
251 
252 contract BittechToken is StandardToken {
253 
254   string constant public name = "Bittech Token";
255   string constant public symbol = "BTECH";
256   uint256 constant public decimals = 18;
257 
258   address constant public bountyWallet = 0x8E8d4cdADbc027b192DfF91c77382521B419E5A2;
259   uint256 public bountyPart = uint256(5000000).mul(10 ** decimals); 
260   address constant public adviserWallet = 0x1B9D19Af310E8cB35D0d3B8977b65bD79C5bB299;
261   uint256 public adviserPart = uint256(1000000).mul(10 ** decimals);
262   address constant public reserveWallet = 0xa323DA182fDfC10861609C2c98894D9745ABAB91;
263   uint256 public reservePart = uint256(20000000).mul(10 ** decimals);
264   address constant public ICOWallet = 0x1ba99f4F5Aa56684423a122D72990A7851AaFD9e;
265   uint256 public ICOPart = uint256(60000000).mul(10 ** decimals);
266   uint256 public PreICOPart = uint256(5000000).mul(10 ** decimals);
267   address constant public teamWallet = 0x69548B7740EAf1200312d803f8bDd04F77523e09;
268   uint256 public teamPart = uint256(9000000).mul(10 ** decimals);
269 
270   uint256 constant public yearSeconds = 31536000; // 60*60*24*365 = 31536000
271   uint256 constant public secsPerBlock = 15; // 1 block per 15 seconds
272   uint256 public INITIAL_SUPPLY = uint256(100000000).mul(10 ** decimals); // 100 000 000 tokens
273 
274   uint256 public withdrawTokens = 0;
275   uint256 public startTime;
276 
277   function BittechToken() public {
278     totalSupply_ = INITIAL_SUPPLY;
279 
280     balances[bountyWallet] = bountyPart;
281     emit Transfer(this, bountyWallet, bountyPart);
282 
283     balances[adviserWallet] = adviserPart;
284     emit Transfer(this, adviserWallet, adviserPart);
285 
286     balances[reserveWallet] = reservePart;
287     emit Transfer(this, reserveWallet, reservePart);
288 
289     balances[ICOWallet] = ICOPart;
290     emit Transfer(this, ICOWallet, ICOPart);
291 
292     balances[msg.sender] = PreICOPart;
293     emit Transfer(this, msg.sender, PreICOPart);
294 
295     balances[this] = teamPart;
296     emit Transfer(this, this, teamPart); 
297 
298     startTime = block.number;
299   }
300 
301   modifier onlyTeam() {
302     require(msg.sender == teamWallet);
303     _;
304   }
305 
306   function viewTeamTokens() public view returns (uint256) {
307 
308     if (block.number >= startTime.add(yearSeconds.div(secsPerBlock))) {
309       return 3000000;
310     }
311 
312     if (block.number >= startTime.add(yearSeconds.div(secsPerBlock).mul(2))) {
313       return 6000000;
314     }
315 
316     if (block.number >= startTime.add(yearSeconds.div(secsPerBlock).mul(3))) {
317       return 9000000;
318     }
319 
320   }
321 
322   function getTeamTokens(uint256 _tokens) public onlyTeam {
323     uint256 tokens = _tokens.mul(10 ** decimals);
324     require(withdrawTokens.add(tokens) <= viewTeamTokens().mul(10 ** decimals));
325     transfer(teamWallet, tokens);
326     emit Transfer(this, teamWallet, tokens);
327     withdrawTokens = withdrawTokens.add(tokens);
328   }
329   
330 }