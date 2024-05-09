1 pragma solidity ^0.4.25;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7     /**
8      * @dev Multiplies two numbers, throws on overflow.
9      **/
10     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
11         if (a == 0) {
12             return 0;
13         }
14         c = a * b;
15         assert(c / a == b);
16         return c;
17     }
18 
19     /**
20      * @dev Integer division of two numbers, truncating the quotient.
21      **/
22     function div(uint256 a, uint256 b) internal pure returns (uint256) {
23         // assert(b > 0); // Solidity automatically throws when dividing by 0
24         // uint256 c = a / b;
25         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26         return a / b;
27     }
28 
29     /**
30      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
31      **/
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         assert(b <= a);
34         return a - b;
35     }
36 
37     /**
38      * @dev Adds two numbers, throws on overflow.
39      **/
40     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
41         c = a + b;
42         assert(c >= a);
43         return c;
44     }
45 }
46 /**
47  * @title Ownable
48  * @dev The Ownable contract has an owner address, and provides basic authorization control
49  * functions, this simplifies the implementation of "user permissions".
50  **/
51 
52 contract Ownable {
53     address public owner;
54     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 /**
56      * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
57      **/
58    constructor() public {
59       owner = msg.sender;
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      **/
65     modifier onlyOwner() {
66       require(msg.sender == owner);
67       _;
68     }
69 
70     /**
71      * @dev Allows the current owner to transfer control of the contract to a newOwner.
72      * @param newOwner The address to transfer ownership to.
73      **/
74     function transferOwnership(address newOwner) public onlyOwner {
75       require(newOwner != address(0));
76       emit OwnershipTransferred(owner, newOwner);
77       owner = newOwner;
78     }
79 }
80 /**
81  * @title ERC20Basic interface
82  * @dev Basic ERC20 interface
83  **/
84 contract ERC20Basic {
85     function totalSupply() public view returns (uint256);
86     function balanceOf(address who) public view returns (uint256);
87     function transfer(address to, uint256 value) public returns (bool);
88     event Transfer(address indexed from, address indexed to, uint256 value);
89 }
90 /**
91  * @title ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/20
93  **/
94 contract ERC20 is ERC20Basic {
95     function allowance(address owner, address spender) public view returns (uint256);
96     function transferFrom(address from, address to, uint256 value) public returns (bool);
97     function approve(address spender, uint256 value) public returns (bool);
98     function mint(address account, uint256 value) public;
99     function burn(address account, uint256 value) public;
100     function burnFrom(address account, uint256 value) public;
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 /**
104  * @title Basic token
105  * @dev Basic version of StandardToken, with no allowances.
106  **/
107 contract BasicToken is ERC20Basic {
108     using SafeMath for uint256;
109     mapping(address => uint256) balances;
110     uint256 totalSupply_;
111 
112     /**
113      * @dev total number of tokens in existence
114      **/
115     function totalSupply() public view returns (uint256) {
116         return totalSupply_;
117     }
118 
119     /**
120      * @dev transfer token for a specified address
121      * @param _to The address to transfer to.
122      * @param _value The amount to be transferred.
123      **/
124     function transfer(address _to, uint256 _value) public returns (bool) {
125         require(_to != address(0));
126         require(_value <= balances[msg.sender]);
127 
128         balances[msg.sender] = balances[msg.sender].sub(_value);
129         balances[_to] = balances[_to].add(_value);
130         emit Transfer(msg.sender, _to, _value);
131         return true;
132     }
133 
134     /**
135      * @dev Gets the balance of the specified address.
136      * @param _owner The address to query the the balance of.
137      * @return An uint256 representing the amount owned by the passed address.
138      **/
139     function balanceOf(address _owner) public view returns (uint256) {
140         return balances[_owner];
141     }
142 }
143 contract StandardToken is ERC20, BasicToken {
144     mapping (address => mapping (address => uint256)) internal allowed;
145     /**
146      * @dev Transfer tokens from one address to another
147      * @param _from address The address which you want to send tokens from
148      * @param _to address The address which you want to transfer to
149      * @param _value uint256 the amount of tokens to be transferred
150      **/
151     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
152         require(_to != address(0));
153         require(_value <= balances[_from]);
154         require(_value <= allowed[_from][msg.sender]);
155 
156         balances[_from] = balances[_from].sub(_value);
157         balances[_to] = balances[_to].add(_value);
158         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
159 
160         emit Transfer(_from, _to, _value);
161         return true;
162     }
163 
164     /**
165      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
166      *
167      * Beware that changing an allowance with this method brings the risk that someone may use both the old
168      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
169      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
170      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171      * @param _spender The address which will spend the funds.
172      * @param _value The amount of tokens to be spent.
173      **/
174     function approve(address _spender, uint256 _value) public returns (bool) {
175         allowed[msg.sender][_spender] = _value;
176         emit Approval(msg.sender, _spender, _value);
177         return true;
178     }
179 
180     /**
181      * @dev Function to check the amount of tokens that an owner allowed to a spender.
182      * @param _owner address The address which owns the funds.
183      * @param _spender address The address which will spend the funds.
184      * @return A uint256 specifying the amount of tokens still available for the spender.
185      **/
186     function allowance(address _owner, address _spender) public view returns (uint256) {
187         return allowed[_owner][_spender];
188     }
189 
190     /**
191      * @dev Increase the amount of tokens that an owner allowed to a spender.
192      *
193      * approve should be called when allowed[_spender] == 0. To increment
194      * allowed value is better to use this function to avoid 2 calls (and wait until
195      * the first transaction is mined)
196      * From MonolithDAO Token.sol
197      * @param _spender The address which will spend the funds.
198      * @param _addedValue The amount of tokens to increase the allowance by.
199      **/
200     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
201         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
202         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
203         return true;
204     }
205 
206     /**
207      * @dev Decrease the amount of tokens that an owner allowed to a spender.
208      *
209      * approve should be called when allowed[_spender] == 0. To decrement
210      * allowed value is better to use this function to avoid 2 calls (and wait until
211      * the first transaction is mined)
212      * From MonolithDAO Token.sol
213      * @param _spender The address which will spend the funds.
214      * @param _subtractedValue The amount of tokens to decrease the allowance by.
215      **/
216     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
217         uint oldValue = allowed[msg.sender][_spender];
218         if (_subtractedValue > oldValue) {
219             allowed[msg.sender][_spender] = 0;
220         } else {
221             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
222         }
223         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
224         return true;
225     }
226 
227   /**
228    * @dev Internal function that mints an amount of the token and assigns it to
229    * an account. This encapsulates the modification of balances such that the
230    * proper events are emitted.
231    * @param account The account that will receive the created tokens.
232    * @param value The amount that will be created.
233    */
234   function mint(address account, uint256 value) public {
235     require(account != 0);
236     totalSupply_ = totalSupply_.add(value);
237     balances[account] = balances[account].add(value);
238     emit Transfer(address(0), account, value);
239   }
240 
241   /**
242    * @dev Internal function that burns an amount of the token of a given
243    * account.
244    * @param account The account whose tokens will be burnt.
245    * @param value The amount that will be burnt.
246    */
247   function burn(address account, uint256 value) public {
248     require(account != 0);
249     require(value <= balances[account]);
250 
251     totalSupply_ = totalSupply_.sub(value);
252     balances[account] = balances[account].sub(value);
253     emit Transfer(account, address(0), value);
254   }
255 
256   /**
257    * @dev Internal function that burns an amount of the token of a given
258    * account, deducting from the sender's allowance for said account. Uses the
259    * internal burn function.
260    * @param account The account whose tokens will be burnt.
261    * @param value The amount that will be burnt.
262    */
263   function burnFrom(address account, uint256 value) public {
264     require(value <= allowed[account][msg.sender]);
265 
266     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
267     // this function needs to emit an event with the updated approval.
268     allowed[account][msg.sender] = allowed[account][msg.sender].sub(
269       value);
270     burn(account, value);
271   }
272 }
273 
274 /**
275  * @title CyBetToken
276  * @dev Contract to create CyBet
277  **/
278 contract CyBetToken is StandardToken, Ownable {
279     string public constant name = "CyBet";
280     string public constant symbol = "CYBT";
281     uint public constant decimals = 18;
282     uint256 public constant tokenReserve = 210000000*10**18;
283 
284     constructor() public {
285       balances[owner] = balances[owner].add(tokenReserve);
286       totalSupply_ = totalSupply_.add(tokenReserve);
287     }
288 }
289 
290 /**
291  * @title Configurable
292  * @dev Configurable varriables of the contract
293  **/
294 contract Configurable {
295     using SafeMath for uint256;
296     uint256 public constant cap = 60000000*10**18;
297     uint256 public constant basePrice = 1000*10**18; // tokens per 1 ether
298     uint256 public tokensSold = 0;
299     uint256 public remainingTokens = 0;
300 }
301 /**
302  * @title Crowdsale
303  * @dev Contract to preform crowd sale with token
304  **/
305 contract Crowdsale is Configurable{
306     /**
307      * @dev enum of current crowd sale state
308      **/
309      address public admin;
310      address private owner;
311      CyBetToken public coinContract;
312      enum Stages {
313         none,
314         icoStart,
315         icoEnd
316     }
317 
318     Stages currentStage;
319 
320     /**
321      * @dev constructor of CrowdsaleToken
322      **/
323     constructor(CyBetToken _coinContract) public {
324         admin = msg.sender;
325         coinContract = _coinContract;
326         owner = coinContract.owner();
327         currentStage = Stages.none;
328         remainingTokens = cap;
329     }
330 
331     //Invest event
332     event Invest(address investor, uint value, uint tokens);
333 
334     /**
335      * @dev fallback function to send ether to for Crowd sale
336      **/
337     function () public payable {
338         require(currentStage == Stages.icoStart);
339         require(msg.value > 0);
340         require(remainingTokens > 0);
341 
342 
343         uint256 weiAmount = msg.value;// Calculate tokens to sell
344         uint256 tokens = weiAmount.mul(basePrice).div(1 ether); // 1 token = 0.1 eth
345 
346         require(remainingTokens >= tokens);
347 
348         tokensSold = tokensSold.add(tokens); // Increment raised amount
349         remainingTokens = cap.sub(tokensSold);
350 
351         coinContract.transfer(msg.sender, tokens);
352         admin.transfer(weiAmount);// Send money to owner
353 
354         emit Invest(msg.sender, msg.value, tokens);
355     }
356     /**
357      * @dev startIco starts the public ICO
358      **/
359     function startIco() external {
360         require(msg.sender == admin);
361         require(currentStage != Stages.icoEnd);
362         currentStage = Stages.icoStart;
363     }
364     /**
365      * @dev endIco closes down the ICO
366      **/
367     function endIco() internal {
368         require(msg.sender == admin);
369         currentStage = Stages.icoEnd;
370         // transfer any remaining CyBet token balance in the contract to the owner
371         coinContract.transfer(coinContract.owner(), coinContract.balanceOf(this));
372     }
373     /**
374      * @dev finalizeIco closes down the ICO and sets needed varriables
375      **/
376     function finalizeIco() external {
377         require(msg.sender == admin);
378         require(currentStage != Stages.icoEnd);
379         endIco();
380     }
381 }