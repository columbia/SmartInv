1 pragma solidity ^0.4.11;
2 
3 // File: zeppelin/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
11     uint256 c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal constant returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal constant returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 // File: zeppelin/token/ERC20Basic.sol
36 
37 /**
38  * @title ERC20Basic
39  * @dev Simpler version of ERC20 interface
40  * @dev see https://github.com/ethereum/EIPs/issues/179
41  */
42 contract ERC20Basic {
43   uint256 public totalSupply;
44   function balanceOf(address who) public constant returns (uint256);
45   function transfer(address to, uint256 value) public returns (bool);
46   event Transfer(address indexed from, address indexed to, uint256 value);
47 }
48 
49 // File: zeppelin/token/BasicToken.sol
50 
51 /**
52  * @title Basic token
53  * @dev Basic version of StandardToken, with no allowances.
54  */
55 contract BasicToken is ERC20Basic {
56   using SafeMath for uint256;
57 
58   mapping(address => uint256) balances;
59 
60   /**
61   * @dev transfer token for a specified address
62   * @param _to The address to transfer to.
63   * @param _value The amount to be transferred.
64   */
65   function transfer(address _to, uint256 _value) public returns (bool) {
66     require(_to != address(0));
67 
68     // SafeMath.sub will throw if there is not enough balance.
69     balances[msg.sender] = balances[msg.sender].sub(_value);
70     balances[_to] = balances[_to].add(_value);
71     Transfer(msg.sender, _to, _value);
72     return true;
73   }
74 
75   /**
76   * @dev Gets the balance of the specified address.
77   * @param _owner The address to query the the balance of.
78   * @return An uint256 representing the amount owned by the passed address.
79   */
80   function balanceOf(address _owner) public constant returns (uint256 balance) {
81     return balances[_owner];
82   }
83 
84 }
85 
86 // File: zeppelin/token/ERC20.sol
87 
88 /**
89  * @title ERC20 interface
90  * @dev see https://github.com/ethereum/EIPs/issues/20
91  */
92 contract ERC20 is ERC20Basic {
93   function allowance(address owner, address spender) public constant returns (uint256);
94   function transferFrom(address from, address to, uint256 value) public returns (bool);
95   function approve(address spender, uint256 value) public returns (bool);
96   event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 // File: zeppelin/token/StandardToken.sol
100 
101 /**
102  * @title Standard ERC20 token
103  *
104  * @dev Implementation of the basic standard token.
105  * @dev https://github.com/ethereum/EIPs/issues/20
106  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
107  */
108 contract StandardToken is ERC20, BasicToken {
109 
110   mapping (address => mapping (address => uint256)) allowed;
111 
112 
113   /**
114    * @dev Transfer tokens from one address to another
115    * @param _from address The address which you want to send tokens from
116    * @param _to address The address which you want to transfer to
117    * @param _value uint256 the amount of tokens to be transferred
118    */
119   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
120     require(_to != address(0));
121 
122     uint256 _allowance = allowed[_from][msg.sender];
123 
124     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
125     // require (_value <= _allowance);
126 
127     balances[_from] = balances[_from].sub(_value);
128     balances[_to] = balances[_to].add(_value);
129     allowed[_from][msg.sender] = _allowance.sub(_value);
130     Transfer(_from, _to, _value);
131     return true;
132   }
133 
134   /**
135    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
136    *
137    * Beware that changing an allowance with this method brings the risk that someone may use both the old
138    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
139    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
140    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
141    * @param _spender The address which will spend the funds.
142    * @param _value The amount of tokens to be spent.
143    */
144   function approve(address _spender, uint256 _value) public returns (bool) {
145     allowed[msg.sender][_spender] = _value;
146     Approval(msg.sender, _spender, _value);
147     return true;
148   }
149 
150   /**
151    * @dev Function to check the amount of tokens that an owner allowed to a spender.
152    * @param _owner address The address which owns the funds.
153    * @param _spender address The address which will spend the funds.
154    * @return A uint256 specifying the amount of tokens still available for the spender.
155    */
156   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
157     return allowed[_owner][_spender];
158   }
159 
160   /**
161    * approve should be called when allowed[_spender] == 0. To increment
162    * allowed value is better to use this function to avoid 2 calls (and wait until
163    * the first transaction is mined)
164    * From MonolithDAO Token.sol
165    */
166   function increaseApproval (address _spender, uint _addedValue)
167     returns (bool success) {
168     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
169     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
170     return true;
171   }
172 
173   function decreaseApproval (address _spender, uint _subtractedValue)
174     returns (bool success) {
175     uint oldValue = allowed[msg.sender][_spender];
176     if (_subtractedValue > oldValue) {
177       allowed[msg.sender][_spender] = 0;
178     } else {
179       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
180     }
181     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
182     return true;
183   }
184 
185 }
186 
187 // File: contracts/FTV.sol
188 
189 /*
190 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20.
191 */
192 pragma solidity ^0.4.11;
193 
194 
195 contract FTV is StandardToken {
196 
197     // data structures
198     bool public presaleFinished = false;
199 
200     uint256 public soldTokens;
201 
202     string public constant name = "FTV Coin Deluxe";
203 
204     string public constant symbol = "FTV";
205 
206     uint8 public constant decimals = 18;
207 
208     mapping(address => bool) public whitelist;
209 
210     mapping(address => address) public referral;
211 
212     address public reserves;
213 
214     address public stateControl;
215 
216     address public whitelistControl;
217 
218     address public tokenAssignmentControl;
219 
220     uint256 constant pointMultiplier = 1e18; //100% = 1*10^18 points
221 
222     uint256 public constant maxTotalSupply = 100000000 * pointMultiplier; //100M tokens
223 
224     event Mint(address indexed to, uint256 amount);
225     event MintFinished();
226 
227     bool public mintingFinished = false;
228 
229 
230     //this creates the contract and stores the owner. it also passes in 3 addresses to be used later during the lifetime of the contract.
231     function FTV(
232         address _stateControl
233       , address _whitelistControl
234       , address _tokenAssignmentControl
235       , address _reserves
236     ) public
237     {
238         stateControl = _stateControl;
239         whitelistControl = _whitelistControl;
240         tokenAssignmentControl = _tokenAssignmentControl;
241         totalSupply = maxTotalSupply;
242         soldTokens = 0;
243         reserves = _reserves;
244         balances[reserves] = totalSupply;
245         Mint(reserves, totalSupply);
246         Transfer(0x0, reserves, totalSupply);
247         finishMinting();
248     }
249 
250     event Whitelisted(address addr);
251 
252     event Referred(address parent, address child);
253 
254     modifier onlyWhitelist() {
255         require(msg.sender == whitelistControl);
256         _;
257     }
258 
259     modifier onlyStateControl() {
260         require(msg.sender == stateControl);
261         _;
262     }
263 
264     modifier onlyTokenAssignmentControl() {
265         require(msg.sender == tokenAssignmentControl);
266         _;
267     }
268 
269     modifier requirePresale() {
270         require(presaleFinished == false);
271         _;
272     }
273 
274     // Make sure this contract cannot receive ETH.
275     function() payable public
276     {
277         revert();
278     }
279 
280     function issueTokensToUser(address beneficiary, uint256 amount)
281     internal
282     {
283         uint256 soldTokensAfterInvestment = soldTokens.add(amount);
284         require(soldTokensAfterInvestment <= maxTotalSupply);
285 
286         balances[beneficiary] = balances[beneficiary].add(amount);
287         balances[reserves] = balances[reserves].sub(amount);
288         soldTokens = soldTokensAfterInvestment;
289         Transfer(reserves, beneficiary, amount);
290     }
291 
292     function issueTokensWithReferral(address beneficiary, uint256 amount)
293     internal
294     {
295         issueTokensToUser(beneficiary, amount);
296         if (referral[beneficiary] != 0x0) {
297             // Send 5% referral bonus to the "parent".
298             issueTokensToUser(referral[beneficiary], amount.mul(5).div(100));
299         }
300     }
301 
302     function addPresaleAmount(address beneficiary, uint256 amount)
303     public
304     onlyTokenAssignmentControl
305     requirePresale
306     {
307         issueTokensWithReferral(beneficiary, amount);
308     }
309 
310     function finishMinting()
311     internal
312     {
313         mintingFinished = true;
314         MintFinished();
315     }
316 
317     function finishPresale()
318     public
319     onlyStateControl
320     {
321         presaleFinished = true;
322     }
323 
324     function addToWhitelist(address _whitelisted)
325     public
326     onlyWhitelist
327     {
328         whitelist[_whitelisted] = true;
329         Whitelisted(_whitelisted);
330     }
331 
332 
333     function addReferral(address _parent, address _child)
334     public
335     onlyWhitelist
336     {
337         require(_parent != _child);
338         require(whitelist[_parent] == true && whitelist[_child] == true);
339         require(referral[_child] == 0x0);
340         referral[_child] = _parent;
341         Referred(_parent, _child);
342     }
343 
344     //if this contract gets a balance in some other ERC20 contract - or even iself - then we can rescue it.
345     function rescueToken(ERC20Basic _foreignToken, address _to)
346     public
347     onlyTokenAssignmentControl
348     {
349         _foreignToken.transfer(_to, _foreignToken.balanceOf(this));
350     }
351 }