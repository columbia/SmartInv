1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
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
27 /**
28  * @title Basic token
29  * @dev Basic version of StandardToken, with no allowances.
30  */
31 contract BasicToken is ERC20Basic {
32   using SafeMath for uint256;
33 
34   mapping(address => uint256) balances;
35 
36   /**
37   * @dev transfer token for a specified address
38   * @param _to The address to transfer to.
39   * @param _value The amount to be transferred.
40   */
41   function transfer(address _to, uint256 _value) public returns (bool) {
42     require(_to != address(0));
43     require(_value <= balances[msg.sender]);
44 
45     // SafeMath.sub will throw if there is not enough balance.
46     balances[msg.sender] = balances[msg.sender].sub(_value);
47     balances[_to] = balances[_to].add(_value);
48     emit Transfer(msg.sender, _to, _value);
49     return true;
50   }
51 
52   /**
53   * @dev Gets the balance of the specified address.
54   * @param _owner The address to query the the balance of.
55   * @return An uint256 representing the amount owned by the passed address.
56   */
57   function balanceOf(address _owner) public view returns (uint256 balance) {
58     return balances[_owner];
59   }
60 
61 }
62 
63 /**
64  * @title Ownable
65  * @dev The Ownable contract has an owner address, and provides basic authorization control
66  * functions, this simplifies the implementation of "user permissions".
67  */
68 contract Ownable {
69   address public owner;
70 
71 
72   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
73 
74 
75   /**
76    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
77    * account.
78    */
79   function Ownable() public {
80     owner = msg.sender;
81   }
82 
83   /**
84    * @dev Throws if called by any account other than the owner.
85    */
86   modifier onlyOwner() {
87     require(msg.sender == owner);
88     _;
89   }
90 
91   /**
92    * @dev Allows the current owner to transfer control of the contract to a newOwner.
93    * @param newOwner The address to transfer ownership to.
94    */
95   function transferOwnership(address newOwner) public onlyOwner {
96     require(newOwner != address(0));
97     owner = newOwner;
98     emit OwnershipTransferred(owner, newOwner);
99   }
100 }
101 
102 /**
103  * @title Standard ERC20 token
104  *
105  * @dev Implementation of the basic standard token.
106  * @dev https://github.com/ethereum/EIPs/issues/20
107  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
108  */
109 contract StandardToken is ERC20, BasicToken {
110 
111   mapping (address => mapping (address => uint256)) internal allowed;
112 
113   /**
114    * @dev Transfer tokens from one address to another
115    * @param _from address The address which you want to send tokens from
116    * @param _to address The address which you want to transfer to
117    * @param _value uint256 the amount of tokens to be transferred
118    */
119   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
120     require(_to != address(0));
121     require(_value <= balances[_from]);
122     require(_value <= allowed[_from][msg.sender]);
123 
124     balances[_from] = balances[_from].sub(_value);
125     balances[_to] = balances[_to].add(_value);
126     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
127     emit Transfer(_from, _to, _value);
128     return true;
129   }
130 
131   /**
132    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
133    *
134    * Beware that changing an allowance with this method brings the risk that someone may use both the old
135    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
136    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
137    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
138    * @param _spender The address which will spend the funds.
139    * @param _value The amount of tokens to be spent.
140    */
141   function approve(address _spender, uint256 _value) public returns (bool) {
142     allowed[msg.sender][_spender] = _value;
143     emit Approval(msg.sender, _spender, _value);
144     return true;
145   }
146 
147   /**
148    * @dev Function to check the amount of tokens that an owner allowed to a spender.
149    * @param _owner address The address which owns the funds.
150    * @param _spender address The address which will spend the funds.
151    * @return A uint256 specifying the amount of tokens still available for the spender.
152    */
153   function allowance(address _owner, address _spender) public view returns (uint256) {
154     return allowed[_owner][_spender];
155   }
156 
157   /**
158    * @dev Increase the amount of tokens that an owner allowed to a spender.
159    *
160    * approve should be called when allowed[_spender] == 0. To increment
161    * allowed value is better to use this function to avoid 2 calls (and wait until
162    * the first transaction is mined)
163    * From MonolithDAO Token.sol
164    * @param _spender The address which will spend the funds.
165    * @param _addedValue The amount of tokens to increase the allowance by.
166    */
167   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
168     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
169     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
170     return true;
171   }
172 
173   /**
174    * @dev Decrease the amount of tokens that an owner allowed to a spender.
175    *
176    * approve should be called when allowed[_spender] == 0. To decrement
177    * allowed value is better to use this function to avoid 2 calls (and wait until
178    * the first transaction is mined)
179    * From MonolithDAO Token.sol
180    * @param _spender The address which will spend the funds.
181    * @param _subtractedValue The amount of tokens to decrease the allowance by.
182    */
183   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
184     uint oldValue = allowed[msg.sender][_spender];
185     if (_subtractedValue > oldValue) {
186       allowed[msg.sender][_spender] = 0;
187     } else {
188       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
189     }
190     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
191     return true;
192   }
193 
194 }
195 
196 /**
197  * @title SafeMath
198  * @dev Math operations with safety checks that throw on error
199  */
200 library SafeMath {
201   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
202     if (a == 0) {
203       return 0;
204     }
205     uint256 c = a * b;
206     assert(c / a == b);
207     return c;
208   }
209 
210   function div(uint256 a, uint256 b) internal pure returns (uint256) {
211     // assert(b > 0); // Solidity automatically throws when dividing by 0
212     uint256 c = a / b;
213     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
214     return c;
215   }
216 
217   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
218     assert(b <= a);
219     return a - b;
220   }
221 
222   function add(uint256 a, uint256 b) internal pure returns (uint256) {
223     uint256 c = a + b;
224     assert(c >= a);
225     return c;
226   }
227 }
228 
229 
230 /**
231  * @title Destructible
232  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
233  */
234 contract Destructible is Ownable {
235 
236     function Destructible() public payable { }
237 
238     /**
239      * @dev Transfers the current balance to the owner and terminates the contract.
240      */
241     function destroy() onlyOwner public {
242         selfdestruct(owner);
243     }
244 
245     function destroyAndSend(address _recipient) onlyOwner public {
246         selfdestruct(_recipient);
247     }
248 }
249 
250 
251 /**
252  * @title Pausable
253  * @dev Base contract which allows children to implement an emergency stop mechanism.
254  */
255 contract Pausable is Ownable {
256     event Pause();
257     event Unpause();
258 
259     bool public paused = false;
260 
261 
262     /**
263      * @dev Modifier to make a function callable only when the contract is not paused.
264      */
265     modifier whenNotPaused() {
266         require(!paused);
267         _;
268     }
269 
270     /**
271      * @dev Modifier to make a function callable only when the contract is paused.
272      */
273     modifier whenPaused() {
274         require(paused);
275         _;
276     }
277 
278     /**
279      * @dev called by the owner to pause, triggers stopped state
280      */
281     function pause() onlyOwner whenNotPaused public {
282         paused = true;
283         emit Pause();
284     }
285 
286     /**
287      * @dev called by the owner to unpause, returns to normal state
288      */
289     function unpause() onlyOwner whenPaused public {
290         paused = false;
291         emit Unpause();
292     }
293 }
294 
295 contract CheckTokenAssign is Ownable
296 {
297     event InitAssignTokenOK();
298     bool public IsInitAssign = false;
299     
300     modifier checkInitAssignState() {
301         require(IsInitAssign == false);
302         _;
303     }
304     
305     function InitAssignOK() onlyOwner public {
306         IsInitAssign = true;
307         emit InitAssignTokenOK();
308     }
309 }
310 
311 //CTCToken
312 contract CTCToken is StandardToken, Ownable, Pausable, Destructible, CheckTokenAssign
313 {
314     using SafeMath for uint;
315     string public constant name = "New Culture Travel";
316     string public constant symbol = "CTC";
317     uint public constant decimals = 18;
318     uint constant million = 1000000e18;
319     uint constant totalToken = 10000*million; 
320     
321     //Token Amount
322     uint constant nThirdPartyPlatform       = 1000*million;
323     uint constant nPlatformAutonomy         = 5100*million;
324     uint constant nResearchGroup            = 500*million;
325     uint constant nMarketing                = 1000*million;
326     uint constant nInvEnterprise            = 1000*million;
327     uint constant nAngelInvestment          = 900*million;
328     uint constant nCultureTravelFoundation  = 500*million;
329     
330     //Token address
331     address  public constant ThirdPartyPlatformAddr      = 0x211064a12ceeecb88fe2e757234e8c88795ed5cd;
332     address  public constant PlatformAutonomyAddr        = 0xe2db2aDE7F9dB41bfcd01364b0adD9445F343d74;
333     address  public constant ResearchGroupAddr           = 0xe4b74b0b84d4b5e7a15401c0b5c8acdd9ecb9df6;
334     address  public constant MarketingAddr               = 0xE8052a396d66B2c1D619b235076128dA9c4C114f;
335     address  public constant InvEnterpriseAddr           = 0x11d774dc8bba7ee455c02ed455f96af693a8d7a8;
336     address  public constant AngelInvestmentAddr         = 0xfBee428Ea0da7c5b3A85468bd98E42e9af0D4623;
337     address  public constant CultureTravelFoundationAddr = 0x17e552663cd183408ec5132b0ba8f75b87e11f5e;
338     
339     function CTCToken() public 
340     {
341         totalSupply = totalToken;
342         balances[msg.sender] = 0;
343         IsInitAssign = false;
344     }
345     
346     function InitAssignCTC() onlyOwner checkInitAssignState public 
347     {
348         balances[ThirdPartyPlatformAddr]      = nThirdPartyPlatform;
349         balances[PlatformAutonomyAddr]        = nPlatformAutonomy;
350         balances[ResearchGroupAddr]           = nResearchGroup;
351         balances[MarketingAddr]               = nMarketing;
352         balances[InvEnterpriseAddr]           = nInvEnterprise;
353         balances[AngelInvestmentAddr]         = nAngelInvestment;
354         balances[CultureTravelFoundationAddr] = nCultureTravelFoundation;
355         InitAssignOK();
356     }
357 }