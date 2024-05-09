1 pragma solidity 0.5.8;
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
45 contract Ownable {
46   address payable public owner;
47 
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   constructor () public {
57     owner = msg.sender;
58   }
59 
60   /**
61    * @dev Throws if called by any account other than the owner.
62    */
63   modifier onlyOwner() {
64     require(msg.sender == owner);
65     _;
66   }
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address payable newOwner) public onlyOwner {
73     require(newOwner != address(0));
74     emit OwnershipTransferred(owner, newOwner);
75     owner = newOwner;
76   }
77 
78 }
79 
80 contract ERC20Basic {
81   function totalSupply() public view returns (uint256);
82   function balanceOf(address who) public view returns (uint256);
83   function transfer(address to, uint256 value) public returns (bool);
84   event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
87 contract BasicToken is ERC20Basic {
88   using SafeMath for uint256;
89 
90   mapping(address => uint256) balances;
91 
92   uint256 totalTokenSupply;
93 
94   /**
95   * @dev total number of tokens in existence
96   */
97   function totalSupply() public view returns (uint256) {
98     return totalTokenSupply;
99   }
100 
101   /**
102   * @dev transfer token for a specified address
103   * @param _to The address to transfer to.
104   * @param _value The amount to be transferred.
105   */
106   function transfer(address _to, uint256 _value) public returns (bool) {
107     require(_to != address(0));
108     require(_value <= balances[msg.sender]);
109 
110     // SafeMath.sub will throw if there is not enough balance.
111     balances[msg.sender] = balances[msg.sender].sub(_value);
112     balances[_to] = balances[_to].add(_value);
113     emit Transfer(msg.sender, _to, _value);
114     return true;
115   }
116 
117   /**
118   * @dev Gets the balance of the specified address.
119   * @param _owner The address to query the the balance of.
120   * @return An uint256 representing the amount owned by the passed address.
121   */
122   function balanceOf(address _owner) public view returns (uint256) {
123     return balances[_owner];
124   }
125 
126 }
127 
128 contract BurnableToken is BasicToken {
129 
130   event Burn(address indexed burner, uint256 value, string reason);
131 
132   /**
133    * @dev Burns a specific amount of tokens.
134    * @param _value The amount of token to be burned.
135    * @param _reason The reason why tokens are burned.
136    */
137   function burn(uint256 _value, string memory _reason) public {
138     require(_value <= balances[msg.sender]);
139 	   
140     address burner = msg.sender;
141     balances[burner] = balances[burner].sub(_value);
142     totalTokenSupply = totalTokenSupply.sub(_value);
143     emit Burn(burner, _value, _reason);
144   }
145 }
146 
147 contract ERC20 is ERC20Basic {
148   function allowance(address owner, address spender) public view returns (uint256);
149   function transferFrom(address from, address to, uint256 value) public returns (bool);
150   function approve(address spender, uint256 value) public returns (bool);
151   event Approval(address indexed owner, address indexed spender, uint256 value);
152 }
153 
154 contract StandardToken is ERC20, BasicToken {
155 
156   mapping (address => mapping (address => uint256)) allowed;
157 
158 
159   /**
160    * @dev Transfer tokens from one address to another
161    * @param _from address The address which you want to send tokens from
162    * @param _to address The address which you want to transfer to
163    * @param _value uint256 the amount of tokens to be transferred
164    */
165   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
166     require(_from != address(0));
167     require(_to != address(0));
168     require(_value <= balances[_from]);
169     require(_value <= allowed[_from][msg.sender]);
170 
171     balances[_from] = balances[_from].sub(_value);
172     balances[_to] = balances[_to].add(_value);
173     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
174     emit Transfer(_from, _to, _value);
175     return true;
176   }
177 
178   /**
179    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
180    *
181    * Beware that changing an allowance with this method brings the risk that someone may use both the old
182    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
183    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
184    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
185    * @param _spender The address which will spend the funds.
186    * @param _value The amount of tokens to be spent.
187    */
188   function approve(address _spender, uint256 _value) public returns (bool) {
189     require(_spender != address(0));
190 
191 	allowed[msg.sender][_spender] = _value;
192     emit Approval(msg.sender, _spender, _value);
193     return true;
194   }
195 
196   /**
197    * @dev Function to check the amount of tokens that an owner allowed to a spender.
198    * @param _owner address The address which owns the funds.
199    * @param _spender address The address which will spend the funds.
200    * @return A uint256 specifying the amount of tokens still available for the spender.
201    */
202   function allowance(address _owner, address _spender) public view returns (uint256) {
203     return allowed[_owner][_spender];
204   }
205 
206   /**
207    * @dev Increase the amount of tokens that an owner allowed to a spender.
208    *
209    * approve should be called when allowed[_spender] == 0. To increment
210    * allowed value is better to use this function to avoid 2 calls (and wait until
211    * the first transaction is mined)
212    * From MonolithDAO Token.sol
213    * @param _spender The address which will spend the funds.
214    * @param _addedValue The amount of tokens to increase the allowance by.
215    */
216   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
217     require(_spender != address(0));
218 
219     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
220     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
221     return true;
222   }
223 
224   /**
225    * @dev Decrease the amount of tokens that an owner allowed to a spender.
226    *
227    * approve should be called when allowed[_spender] == 0. To decrement
228    * allowed value is better to use this function to avoid 2 calls (and wait until
229    * the first transaction is mined)
230    * From MonolithDAO Token.sol
231    * @param _spender The address which will spend the funds.
232    * @param _subtractedValue The amount of tokens to decrease the allowance by.
233    */
234   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
235     uint oldValue = allowed[msg.sender][_spender];
236     
237     //Reseting allowed amount when the _subtractedValue is greater than allowed is on purpose
238     if (_subtractedValue > oldValue) {
239       allowed[msg.sender][_spender] = 0;
240     } else {
241       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
242     }
243     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
244     return true;
245   }
246 
247 }
248 
249 contract DACXToken is StandardToken, BurnableToken, Ownable {
250     using SafeMath for uint;
251 
252     string constant public symbol = "DACX";
253     string constant public name = "DACX Token";
254 
255     uint8 constant public decimals = 18;
256 
257     // First date locked team token transfers are allowed
258     uint constant unlockTime = 1593561600; // Wednesday, July 1, 2020 12:00:00 AM UTC
259 
260     // Below listed are the Master Wallets to be used, for complete transparency purposes
261     
262     // Company Wallet: Will be used to collect fees, all Company Side Burning will commence using this wallet
263     address company = 0x12Fc4aD0532Ef06006C6b85be4D377dD1287a991;
264     
265     // Angel Wallet: Initial distribution to Angel Investors will be made through this wallet 
266     address angel = 0xfd961aDDEb5198B2a7d9DEfabC405f2FBa38E88b;
267     
268     // Team Wallet: Initial distribution to Team Members will be made through this wallet 
269     address team = 0xd3544D8569EFc16cAA1EF22D77B37d3fe98CA617;
270 
271     // Locked Wallet: All remaining team funds will be locked for at least 1 year
272     address locked = 0x612D44Aea422093aEB56049eDb53a213a3F4689F;
273 
274     // Crowdsale Wallet: All token sales (Private/Pre/Public) will be made through this wallet
275     address crowdsale = 0x939276d1dA91B9327a3BA4E896Fb624C97Eedf4E;
276     
277     // Bounty Wallet: Holds the tokens reserved for our initial and future bounty campaigns
278     address bounty = 0x40e70bD19b1b1d792E4f850ea78691Ccd42B84Ea;
279 
280 
281     // INITIAL_TOTAL_SUPPLY = 786786786e18;
282     uint constant lockedTokens     = 1966966964e17; // 196,696,696.40
283     uint constant angelTokens      =  393393393e17; //  39,339,339.30
284     uint constant teamTokens       = 1180180180e17; // 118,018,018.00
285     uint constant crowdsaleTokens  = 3933933930e17; // 393,393,393.00 
286     uint constant bountyTokens     =  393393393e17; //  39,339,339.30
287 
288 
289     constructor () public {
290 
291         totalTokenSupply = 0;
292 
293         // InitialDistribution
294         setInitialTokens(locked, lockedTokens);
295         setInitialTokens(angel, angelTokens);
296         setInitialTokens(team, teamTokens);
297         setInitialTokens(crowdsale, crowdsaleTokens);
298         setInitialTokens(bounty, bountyTokens);
299 
300     }
301 
302     function setInitialTokens(address _address, uint _amount) internal {
303         totalTokenSupply = totalTokenSupply.add(_amount);
304         balances[_address] = _amount;
305         emit Transfer(address(0x0), _address, _amount);
306     }
307 
308     function checkPermissions(address _from) internal view returns (bool) {
309 
310         if (_from == locked && now < unlockTime) {
311             return false;
312         } else {
313             return true;
314         }
315 
316     }
317 
318     function transfer(address _to, uint256 _value) public returns (bool) {
319 
320         require(checkPermissions(msg.sender));
321         bool ret = super.transfer(_to, _value);
322         return ret;
323     }
324 
325     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
326 
327         require(checkPermissions(_from));
328         bool ret = super.transferFrom(_from, _to, _value);
329         return ret;
330     }
331 
332     function () external payable {
333 	    require(msg.data.length == 0);
334         require(msg.value >= 1e16);
335         owner.transfer(msg.value);
336     }
337 
338 }