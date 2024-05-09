1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10     function totalSupply() public view returns (uint256);
11     function balanceOf(address _who) public view returns (uint256);
12     function transfer(address _to, uint256 _value) public returns (bool);
13     event Transfer(address indexed _from, address indexed _to, uint256 _value);
14 }
15 
16 
17 /**
18  * @title ERC20 interface
19  * @dev see https://github.com/ethereum/EIPs/issues/20
20  */
21 contract ERC20 is ERC20Basic {
22     function allowance(address _owner, address _spender) public view returns (uint256);
23     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
24     function approve(address _spender, uint256 _value) public returns (bool);
25     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
26 }
27 
28 
29 /**
30  * @title Ownable
31  * @dev The Ownable contract has an owner address, and provides basic authorization control
32  * functions, this simplifies the implementation of "user permissions".
33  */
34 contract Ownable {
35     address public owner;
36 
37 
38     event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
39 
40 
41     /**
42      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
43      * account.
44      */
45     constructor() public {
46         owner = msg.sender;
47     }
48 
49     /**
50      * @dev Throws if called by any account other than the owner.
51      */
52     modifier onlyOwner() {
53         require(msg.sender == owner);
54         _;
55     }
56 
57     /**
58      * @dev Allows the current owner to transfer control of the contract to a newOwner.
59      * @param _newOwner The address to transfer ownership to.
60      */
61     function transferOwnership(address _newOwner) public onlyOwner {
62         require(_newOwner != address(0));
63         emit OwnershipTransferred(owner, _newOwner);
64         owner = _newOwner;
65     }
66 
67     /**
68      * @dev Rescue compatible ERC20Basic Token
69      *
70      * @param _token ERC20Basic The address of the token contract
71      */
72     function rescueTokens(ERC20Basic _token) external onlyOwner {
73         uint256 balance = _token.balanceOf(this);
74         assert(_token.transfer(owner, balance));
75     }
76 
77     /**
78      * @dev Withdraw Ether
79      */
80     function withdrawEther() external onlyOwner {
81         owner.transfer(address(this).balance);
82     }
83 }
84 
85 
86 /**
87  * @title SafeMath
88  * @dev Math operations with safety checks that throw on error
89  */
90 library SafeMath {
91 
92     /**
93      * @dev Multiplies two numbers, throws on overflow.
94      */
95     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
96         if (a == 0) {
97             return 0;
98         }
99         c = a * b;
100         assert(c / a == b);
101         return c;
102     }
103 
104     /**
105      * @dev Integer division of two numbers, truncating the quotient.
106      */
107     function div(uint256 a, uint256 b) internal pure returns (uint256) {
108         // assert(b > 0); // Solidity automatically throws when dividing by 0
109         // uint256 c = a / b;
110         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
111         return a / b;
112     }
113 
114     /**
115      * @dev Adds two numbers, throws on overflow.
116      */
117     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
118         c = a + b;
119         assert(c >= a);
120         return c;
121     }
122 
123     /**
124      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
125      */
126     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
127         assert(b <= a);
128         return a - b;
129     }
130 }
131 
132 
133 /**
134  * @title Basic token, Lockable
135  * @dev Basic version of StandardToken, with no allowances.
136  */
137 contract BasicToken is ERC20Basic {
138     using SafeMath for uint256;
139 
140     uint256 totalSupply_;
141 
142     mapping(address => uint256) balances;
143     mapping(address => uint256) lockedBalanceMap;    // locked balance: address => amount
144     mapping(address => uint256) releaseTimeMap;      // release time: address => timestamp
145 
146     event BalanceLocked(address indexed _addr, uint256 _amount);
147 
148 
149     /**
150     * @dev total number of tokens in existence
151     */
152     function totalSupply() public view returns (uint256) {
153         return totalSupply_;
154     }
155 
156     /**
157      * @dev function to make sure the balance is not locked
158      * @param _addr address
159      * @param _value uint256
160      */
161     function checkNotLocked(address _addr, uint256 _value) internal view returns (bool) {
162         uint256 balance = balances[_addr].sub(_value);
163         if (releaseTimeMap[_addr] > block.timestamp && balance < lockedBalanceMap[_addr]) {
164             revert();
165         }
166         return true;
167     }
168 
169     /**
170      * @dev transfer token for a specified address
171      * @param _to The address to transfer to.
172      * @param _value The amount to be transferred.
173      */
174     function transfer(address _to, uint256 _value) public returns (bool) {
175         require(_to != address(0));
176         require(_value <= balances[msg.sender]);
177 
178         checkNotLocked(msg.sender, _value);
179 
180         balances[msg.sender] = balances[msg.sender].sub(_value);
181         balances[_to] = balances[_to].add(_value);
182         emit Transfer(msg.sender, _to, _value);
183         return true;
184     }
185 
186     /**
187      * @dev Gets the balance of the specified address.
188      * @param _owner The address to query the the balance of.
189      * @return Amount.
190      */
191     function balanceOf(address _owner) public view returns (uint256) {
192         return balances[_owner];
193     }
194 
195     /**
196      * @dev Gets the locked balance of the specified address.
197      * @param _owner The address to query.
198      * @return Amount.
199      */
200     function lockedBalanceOf(address _owner) public view returns (uint256) {
201         return lockedBalanceMap[_owner];
202     }
203 
204     /**
205      * @dev Gets the release timestamp of the specified address if it has a locked balance.
206      * @param _owner The address to query.
207      * @return Timestamp.
208      */
209     function releaseTimeOf(address _owner) public view returns (uint256) {
210         return releaseTimeMap[_owner];
211     }
212 }
213 
214 
215 /**
216  * @title Standard ERC20 token
217  *
218  * @dev Implementation of the basic standard token.
219  * @dev https://github.com/ethereum/EIPs/issues/20
220  */
221 contract StandardToken is ERC20, BasicToken {
222     mapping (address => mapping (address => uint256)) internal allowed;
223 
224 
225     /**
226      * @dev Transfer tokens from one address to another
227      * @param _from address The address which you want to send tokens from
228      * @param _to address The address which you want to transfer to
229      * @param _value uint256 the amount of tokens to be transferred
230      */
231     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
232         require(_to != address(0));
233         require(_value <= balances[_from]);
234         require(_value <= allowed[_from][msg.sender]);
235 
236         checkNotLocked(_from, _value);
237 
238         balances[_from] = balances[_from].sub(_value);
239         balances[_to] = balances[_to].add(_value);
240         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
241         emit Transfer(_from, _to, _value);
242         return true;
243     }
244 
245     /**
246      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
247      *
248      * Beware that changing an allowance with this method brings the risk that someone may use both the old
249      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
250      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
251      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
252      * @param _spender The address which will spend the funds.
253      * @param _value The amount of tokens to be spent.
254      */
255     function approve(address _spender, uint256 _value) public returns (bool) {
256         allowed[msg.sender][_spender] = _value;
257         emit Approval(msg.sender, _spender, _value);
258         return true;
259     }
260 
261     /**
262      * @dev Function to check the amount of tokens that an owner allowed to a spender.
263      * @param _owner address The address which owns the funds.
264      * @param _spender address The address which will spend the funds.
265      * @return A uint256 specifying the amount of tokens still available for the spender.
266      */
267     function allowance(address _owner, address _spender) public view returns (uint256) {
268         return allowed[_owner][_spender];
269     }
270 
271     /**
272      * @dev Increase the amount of tokens that an owner allowed to a spender.
273      *
274      * approve should be called when allowed[_spender] == 0. To increment
275      * allowed value is better to use this function to avoid 2 calls (and wait until
276      * the first transaction is mined)
277      * From MonolithDAO Token.sol
278      * @param _spender The address which will spend the funds.
279      * @param _addedValue The amount of tokens to increase the allowance by.
280      */
281     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
282         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
283         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
284         return true;
285     }
286 
287     /**
288      * @dev Decrease the amount of tokens that an owner allowed to a spender.
289      *
290      * approve should be called when allowed[_spender] == 0. To decrement
291      * allowed value is better to use this function to avoid 2 calls (and wait until
292      * the first transaction is mined)
293      * From MonolithDAO Token.sol
294      * @param _spender The address which will spend the funds.
295      * @param _subtractedValue The amount of tokens to decrease the allowance by.
296      */
297     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
298         uint oldValue = allowed[msg.sender][_spender];
299         if (_subtractedValue > oldValue) {
300             allowed[msg.sender][_spender] = 0;
301         } else {
302             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
303         }
304         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
305         return true;
306     }
307 }
308 
309 
310 /**
311  * @title Abstract Standard ERC20 token
312  */
313 contract AbstractToken is Ownable, StandardToken {
314     string public name;
315     string public symbol;
316     uint256 public decimals;
317 
318     string public value;        // Stable Value
319     string public description;  // Description
320     string public website;      // Website
321     string public email;        // Email
322     string public news;         // Latest News
323     uint256 public cap;         // Cap Limit
324 
325 
326     mapping (address => bool) public mintAgents;  // Mint Agents
327 
328     event Mint(address indexed _to, uint256 _amount);
329     event MintAgentChanged(address _addr, bool _state);
330     event NewsPublished(string _news);
331 
332 
333     /**
334      * @dev Set Info
335      * 
336      * @param _description string
337      * @param _website string
338      * @param _email string
339      */
340     function setInfo(string _description, string _website, string _email) external onlyOwner returns (bool) {
341         description = _description;
342         website = _website;
343         email = _email;
344         return true;
345     }
346 
347     /**
348      * @dev Set News
349      * 
350      * @param _news string
351      */
352     function setNews(string _news) external onlyOwner returns (bool) {
353         news = _news;
354         emit NewsPublished(_news);
355         return true;
356     }
357 
358     /**
359      * @dev Set a mint agent address
360      * 
361      * @param _addr  address  The address that will receive the minted tokens.
362      * @param _state bool     The amount of tokens to mint.
363      * @return A boolean that indicates if the operation was successful.
364      */
365     function setMintAgent(address _addr, bool _state) onlyOwner public returns (bool) {
366         mintAgents[_addr] = _state;
367         emit MintAgentChanged(_addr, _state);
368         return true;
369     }
370 
371     /**
372      * @dev Constructor
373      */
374     constructor() public {
375         setMintAgent(msg.sender, true);
376     }
377 }
378 
379 
380 /**
381  * @dev VNET Token for Vision Network Project
382  */
383 contract VNETToken is Ownable, AbstractToken {
384     event Donate(address indexed _from, uint256 _amount);
385 
386 
387     /**
388      * @dev Constructor
389      */
390     constructor() public {
391         name = "VNET Token";
392         symbol = "VNET";
393         decimals = 6;
394         value = "1 Token = 100 GByte client newtwork traffic flow";
395 
396         // 35 Billion Total
397         cap = 35000000000 * (10 ** decimals);
398     }
399 
400     /**
401      * @dev Sending eth to this contract will be considered as a donation
402      */
403     function () public payable {
404         emit Donate(msg.sender, msg.value);
405     }
406 
407     /**
408      * @dev Function to mint tokens
409      * @param _to The address that will receive the minted tokens.
410      * @param _amount The amount of tokens to mint.
411      * @return A boolean that indicates if the operation was successful.
412      */
413     function mint(address _to, uint256 _amount) external returns (bool) {
414         require(mintAgents[msg.sender] && totalSupply_.add(_amount) <= cap);
415 
416         totalSupply_ = totalSupply_.add(_amount);
417         balances[_to] = balances[_to].add(_amount);
418         emit Mint(_to, _amount);
419         emit Transfer(address(0), _to, _amount);
420         return true;
421     }
422 
423     /**
424      * @dev Function to mint tokens, and lock some of them with a release time
425      * @param _to The address that will receive the minted tokens.
426      * @param _amount The amount of tokens to mint.
427      * @param _lockedAmount The amount of tokens to be locked.
428      * @param _releaseTime The timestamp about to release, which could be set just once.
429      * @return A boolean that indicates if the operation was successful.
430      */
431     function mintWithLock(address _to, uint256 _amount, uint256 _lockedAmount, uint256 _releaseTime) external returns (bool) {
432         require(mintAgents[msg.sender] && totalSupply_.add(_amount) <= cap);
433         require(_amount >= _lockedAmount);
434 
435         totalSupply_ = totalSupply_.add(_amount);
436         balances[_to] = balances[_to].add(_amount);
437         lockedBalanceMap[_to] = lockedBalanceMap[_to] > 0 ? lockedBalanceMap[_to].add(_lockedAmount) : _lockedAmount;
438         releaseTimeMap[_to] = releaseTimeMap[_to] > 0 ? releaseTimeMap[_to] : _releaseTime;
439         emit Mint(_to, _amount);
440         emit Transfer(address(0), _to, _amount);
441         emit BalanceLocked(_to, _lockedAmount);
442         return true;
443     }
444 }