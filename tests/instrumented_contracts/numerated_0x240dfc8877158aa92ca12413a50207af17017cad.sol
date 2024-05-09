1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         if (a == 0) {
11             return 0;
12         }
13         uint256 c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17 
18     function div(uint256 a, uint256 b) internal pure returns (uint256) {
19         // assert(b > 0); // Solidity automatically throws when dividing by 0
20         uint256 c = a / b;
21         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22         return c;
23     }
24 
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         assert(b <= a);
27         return a - b;
28     }
29 
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         assert(c >= a);
33         return c;
34     }
35 }
36 
37 contract Ownable {
38     address public owner;
39 
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43 
44     /**
45      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46      * account.
47      */
48     function Ownable() public {
49         owner = msg.sender;
50     }
51 
52 
53     /**
54      * @dev Throws if called by any account other than the owner.
55      */
56     modifier onlyOwner() {
57         require(msg.sender == owner);
58         _;
59     }
60 
61 
62     /**
63      * @dev Allows the current owner to transfer control of the contract to a newOwner.
64      * @param newOwner The address to transfer ownership to.
65      */
66     function transferOwnership(address newOwner) public onlyOwner {
67         require(newOwner != address(0));
68         OwnershipTransferred(owner, newOwner);
69         owner = newOwner;
70     }
71 
72 }
73 
74 /**
75  * @title Pausable
76  * @dev Base contract which allows children to implement an emergency stop mechanism.
77  */
78 contract Pausable is Ownable {
79     event Pause();
80     event Unpause();
81 
82     bool public paused = false;
83 
84 
85     /**
86      * @dev Modifier to make a function callable only when the contract is not paused.
87      */
88     modifier whenNotPaused() {
89         require(!paused);
90         _;
91     }
92 
93     /**
94      * @dev Modifier to make a function callable only when the contract is paused.
95      */
96     modifier whenPaused() {
97         require(paused);
98         _;
99     }
100 
101     /**
102      * @dev called by the owner to pause, triggers stopped state
103      */
104     function pause() onlyOwner whenNotPaused public {
105         paused = true;
106         Pause();
107     }
108 
109     /**
110      * @dev called by the owner to unpause, returns to normal state
111      */
112     function unpause() onlyOwner whenPaused public {
113         paused = false;
114         Unpause();
115     }
116 }
117 
118 contract ERC20Basic {
119     uint256 public totalSupply;
120     function balanceOf(address who) public view returns (uint256);
121     function transfer(address to, uint256 value) public returns (bool);
122     event Transfer(address indexed from, address indexed to, uint256 value);
123 }
124 
125 
126 contract ERC20 is ERC20Basic {
127     function allowance(address owner, address spender) public view returns (uint256);
128     function transferFrom(address from, address to, uint256 value) public returns (bool);
129     function approve(address spender, uint256 value) public returns (bool);
130     event Approval(address indexed owner, address indexed spender, uint256 value);
131 }
132 
133 contract BasicToken is ERC20Basic {
134     using SafeMath for uint256;
135 
136     mapping(address => uint256) balances;
137 
138     /**
139     * @dev transfer token for a specified address
140     * @param _to The address to transfer to.
141     * @param _value The amount to be transferred.
142     */
143     function transfer(address _to, uint256 _value) public returns (bool) {
144         require(_to != address(0));
145         require(_value <= balances[msg.sender]);
146 
147         // SafeMath.sub will throw if there is not enough balance.
148         balances[msg.sender] = balances[msg.sender].sub(_value);
149         balances[_to] = balances[_to].add(_value);
150         Transfer(msg.sender, _to, _value);
151         return true;
152     }
153 
154     /**
155     * @dev Gets the balance of the specified address.
156     * @param _owner The address to query the the balance of.
157     * @return An uint256 representing the amount owned by the passed address.
158     */
159     function balanceOf(address _owner) public view returns (uint256 balance) {
160         return balances[_owner];
161     }
162 
163 }
164 
165 contract StandardToken is ERC20, BasicToken {
166 
167     mapping (address => mapping (address => uint256)) internal allowed;
168 
169 
170     /**
171      * @dev Transfer tokens from one address to another
172      * @param _from address The address which you want to send tokens from
173      * @param _to address The address which you want to transfer to
174      * @param _value uint256 the amount of tokens to be transferred
175      */
176     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
177         require(_to != address(0));
178         require(_value <= balances[_from]);
179         require(_value <= allowed[_from][msg.sender]);
180 
181         balances[_from] = balances[_from].sub(_value);
182         balances[_to] = balances[_to].add(_value);
183         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
184         Transfer(_from, _to, _value);
185         return true;
186     }
187 
188     /**
189      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
190      *
191      * Beware that changing an allowance with this method brings the risk that someone may use both the old
192      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
193      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
194      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
195      * @param _spender The address which will spend the funds.
196      * @param _value The amount of tokens to be spent.
197      */
198     function approve(address _spender, uint256 _value) public returns (bool) {
199         allowed[msg.sender][_spender] = _value;
200         Approval(msg.sender, _spender, _value);
201         return true;
202     }
203 
204     /**
205      * @dev Function to check the amount of tokens that an owner allowed to a spender.
206      * @param _owner address The address which owns the funds.
207      * @param _spender address The address which will spend the funds.
208      * @return A uint256 specifying the amount of tokens still available for the spender.
209      */
210     function allowance(address _owner, address _spender) public view returns (uint256) {
211         return allowed[_owner][_spender];
212     }
213 
214     /**
215      * approve should be called when allowed[_spender] == 0. To increment
216      * allowed value is better to use this function to avoid 2 calls (and wait until
217      * the first transaction is mined)
218      * From MonolithDAO Token.sol
219      */
220     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
221         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
222         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
223         return true;
224     }
225 
226     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
227         uint oldValue = allowed[msg.sender][_spender];
228         if (_subtractedValue > oldValue) {
229             allowed[msg.sender][_spender] = 0;
230         } else {
231             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
232         }
233         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
234         return true;
235     }
236 
237 }
238 
239 contract PausableToken is StandardToken, Pausable {
240 
241     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
242         return super.transfer(_to, _value);
243     }
244 
245     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
246         return super.transferFrom(_from, _to, _value);
247     }
248 
249     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
250         return super.approve(_spender, _value);
251     }
252 
253     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
254         return super.increaseApproval(_spender, _addedValue);
255     }
256 
257     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
258         return super.decreaseApproval(_spender, _subtractedValue);
259     }
260 }
261 
262 contract MintableToken is PausableToken {
263     event Mint(address indexed to, uint256 amount);
264     event MintFinished();
265 
266     bool public mintingFinished = false;
267 
268 
269     modifier canMint() {
270         require(!mintingFinished);
271         _;
272     }
273 
274     /**
275      * @dev Function to mint tokens
276      * @param _to The address that will receive the minted tokens.
277      * @param _amount The amount of tokens to mint.
278      * @return A boolean that indicates if the operation was successful.
279      */
280     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
281         totalSupply = totalSupply.add(_amount);
282         balances[_to] = balances[_to].add(_amount);
283         Mint(_to, _amount);
284         Transfer(address(0), _to, _amount);
285         return true;
286     }
287 
288     /**
289      * @dev Function to stop minting new tokens.
290      * @return True if the operation was successful.
291      */
292     function finishMinting() onlyOwner canMint public returns (bool) {
293         mintingFinished = true;
294         MintFinished();
295         return true;
296     }
297 }
298 
299 contract MXToken is MintableToken {
300     using SafeMath for uint256;
301 
302     string public name = "PRE";
303     string public symbol = "PRE";
304     uint8 public decimals = 5;
305 
306     uint256 public cap = 100000000000000; // 1 000 000 000 00000
307     uint256 private tokenOfOwner = 50000000000000; // 500 000 000 00000
308 
309     uint256 public rate = 10000000; // 200 00000 , 200 token per eth
310 
311     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
312 
313     function MXToken() public {
314         balances[owner] = tokenOfOwner;
315         totalSupply = tokenOfOwner;
316 
317     }
318 
319     // fallback function can be used to buy tokens
320     function() external payable {
321         buyTokens(msg.sender);
322     }
323 
324     // low level token purchase function
325     function buyTokens(address beneficiary) whenNotPaused public payable {
326         require(beneficiary != address(0));
327 
328         uint256 weiAmount = msg.value;
329 
330         // calculate token amount to be created
331         uint256 tokens = weiAmount.mul(rate) / (1 ether);
332 
333         require(totalSupply.add(tokens) <= cap);
334 
335         // update state
336         totalSupply = totalSupply.add(tokens);
337         balances[msg.sender] = balances[msg.sender].add(tokens);
338 
339         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
340 
341         forwardFunds();
342     }
343 
344     // send ether to the fund collection wallet
345     // override to create custom fund forwarding mechanisms
346     function forwardFunds() internal {
347         owner.transfer(msg.value);
348     }
349 
350     function newName(string _name, string _symbol) onlyOwner public {
351         name = _name;
352         symbol = _symbol;
353     }
354     /**
355      * @dev Function to mint tokens
356      * @param _to The address that will receive the minted tokens.
357      * @param _amount The amount of tokens to mint.
358      * @return A boolean that indicates if the operation was successful.
359      */
360     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
361         require(totalSupply.add(_amount) <= cap);
362 
363         return super.mint(_to, _amount);
364     }
365 
366 }