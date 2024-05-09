1 pragma solidity 0.5.11;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         // assert(b > 0); // Solidity automatically throws when dividing by 0
15         uint256 c = a / b;
16         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 /**
33  * @title Ownable
34  * @dev The Ownable contract has an owner address, and provides basic authorization control
35  * functions, this simplifies the implementation of "user permissions".
36  */
37 contract Ownable {
38     address public owner;
39 
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43 
44     /**
45     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46     * account.
47     */
48     constructor() public {
49         owner = msg.sender;
50     }
51 
52     /**
53     * @dev Throws if called by any account other than the owner.
54     */
55     modifier onlyOwner() {
56         require(msg.sender == owner);
57         _;
58     }
59 
60     /**
61     * @dev Allows the current owner to transfer control of the contract to a newOwner.
62     * @param newOwner The address to transfer ownership to.
63     */
64     function transferOwnership(address newOwner) public onlyOwner {
65         require(newOwner != address(0));
66         emit OwnershipTransferred(owner, newOwner);
67         owner = newOwner;
68     }
69 }
70 
71 /**
72  * @title ERC20Basic
73  */
74 contract ERC20Basic {
75     uint256 public totalSupply;
76     function balanceOf(address who) public view returns (uint256);
77     function transfer(address to, uint256 value) public returns (bool);
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 }
80 
81 /**
82  * @title ERC20 interface
83  */
84 contract ERC20 is ERC20Basic {
85     function allowance(address owner, address spender) public view returns (uint256);
86     function transferFrom(address from, address to, uint256 value) public returns (bool);
87     function approve(address spender, uint256 value) public returns (bool);
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 /**
92  * @title Basic token
93  * @dev Basic version of StandardToken, with no allowances. 
94  */
95 contract BasicToken is ERC20Basic, Ownable {
96 
97     using SafeMath for uint256;
98 
99     mapping(address => uint256) balances;
100 
101     /**
102     * @dev transfer token for a specified address
103     * @param _to The address to transfer to.
104     * @param _value The amount to be transferred.
105     */
106     function transfer(address _to, uint256 _value) public returns (bool) {
107         require(_to != address(0));
108         require(_value <= balanceOf(msg.sender));
109 
110         // SafeMath.sub will throw if there is not enough balance.
111         balances[msg.sender] = balances[msg.sender].sub(_value);
112         balances[_to] = balances[_to].add(_value);
113         emit Transfer(msg.sender, _to, _value);
114         return true;
115     }
116 
117     /**
118     * @dev Gets the balance of the specified address.
119     * @param _owner The address to query the the balance of. 
120     * @return An uint256 representing the amount owned by the passed address.
121     */
122     function balanceOf(address _owner) public view returns (uint256 balance) {
123         return balances[_owner];
124     }
125     
126 }
127 
128 
129 /**
130  * @title Standard ERC20 token
131  *
132  * @dev Implementation of the basic standard token.
133  */
134 contract StandardToken is ERC20, BasicToken {
135 
136     mapping (address => mapping (address => uint256)) allowed;
137 
138     /**
139     * @dev Transfer tokens from one address to another
140     * @param _from address The address which you want to send tokens from
141     * @param _to address The address which you want to transfer to
142     * @param _value uint256 the amount of tokens to be transferred
143     */
144     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
145         require(_to != address(0));
146         require(allowed[_from][msg.sender] >= _value);
147         require(balanceOf(_from) >= _value);
148         require(balances[_to].add(_value) > balances[_to]); // Check for overflows
149         balances[_from] = balances[_from].sub(_value);
150         balances[_to] = balances[_to].add(_value);
151         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
152         emit Transfer(_from, _to, _value);
153         return true;
154     }
155 
156     /**
157     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
158     * @param _spender The address which will spend the funds.
159     * @param _value The amount of tokens to be spent.
160     */
161     function approve(address _spender, uint256 _value) public returns (bool) {
162         // To change the approve amount you first have to reduce the addresses`
163         //  allowance to zero by calling `approve(_spender, 0)` if it is not
164         //  already 0 to mitigate the race condition described here:
165         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
166         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
167         allowed[msg.sender][_spender] = _value;
168         emit Approval(msg.sender, _spender, _value);
169         return true;
170     }
171 
172     /**
173     * @dev Function to check the amount of tokens that an owner allowed to a spender.
174     * @param _owner address The address which owns the funds.
175     * @param _spender address The address which will spend the funds.
176     * @return A uint256 specifying the amount of tokens still available for the spender.
177     */
178     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
179         return allowed[_owner][_spender];
180     }
181 
182     /**
183     * approve should be called when allowed[_spender] == 0. To increment
184     * allowed value is better to use this function to avoid 2 calls (and wait until 
185     * the first transaction is mined)
186     * From MonolithDAO Token.sol
187     */
188     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
189         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
190         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
191         return true;
192     }
193 
194     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
195         uint oldValue = allowed[msg.sender][_spender];
196         if (_subtractedValue > oldValue) {
197             allowed[msg.sender][_spender] = 0;
198         } else {
199             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
200         }
201         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
202         return true;
203     }
204 }
205 
206 
207 /**
208  * @title Pausable
209  * @dev Base contract which allows children to implement an emergency stop mechanism.
210  */
211 contract Pausable is StandardToken {
212     event Pause();
213     event Unpause();
214 
215     bool public paused = false;
216 
217     address public founder;
218     
219     /**
220     * @dev modifier to allow actions only when the contract IS paused
221     */
222     modifier whenNotPaused() {
223         require(!paused || msg.sender == founder);
224         _;
225     }
226 
227     /**
228     * @dev modifier to allow actions only when the contract IS NOT paused
229     */
230     modifier whenPaused() {
231         require(paused);
232         _;
233     }
234 
235     /**
236     * @dev called by the owner to pause, triggers stopped state
237     */
238     function pause() public onlyOwner whenNotPaused {
239         paused = true;
240         emit Pause();
241     }
242 
243     /**
244     * @dev called by the owner to unpause, returns to normal state
245     */
246     function unpause() public onlyOwner whenPaused {
247         paused = false;
248         emit Unpause();
249     }
250 }
251 
252 
253 contract PausableToken is Pausable {
254 
255     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
256         return super.transfer(_to, _value);
257     }
258 
259     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
260         return super.transferFrom(_from, _to, _value);
261     }
262 
263     //The functions below surve no real purpose. Even if one were to approve another to spend
264     //tokens on their behalf, those tokens will still only be transferable when the token contract
265     //is not paused.
266 
267     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
268         return super.approve(_spender, _value);
269     }
270 
271     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
272         return super.increaseApproval(_spender, _addedValue);
273     }
274 
275     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
276         return super.decreaseApproval(_spender, _subtractedValue);
277     }
278 }
279 
280 contract YearnSharkFinance is PausableToken {
281 
282     string public name;
283     string public symbol;
284     uint8 public decimals;
285 
286     /**
287     * @dev Constructor that gives the founder all of the existing tokens.
288     */
289     constructor() public {
290         name = "Yearn Shark Finance";
291         symbol = "YSKF";
292         decimals = 18;
293         totalSupply = 15000e18;
294         
295         founder = msg.sender;
296 
297         balances[msg.sender] = totalSupply;
298         emit Transfer(address(0), msg.sender, totalSupply);
299     }
300     
301     /** @dev Fires on every freeze of tokens
302      *  @param _owner address The owner address of frozen tokens.
303      *  @param amount uint256 The amount of tokens frozen
304      */
305     event TokenFreezeEvent(address indexed _owner, uint256 amount);
306 
307     /** @dev Fires on every unfreeze of tokens
308      *  @param _owner address The owner address of unfrozen tokens.
309      *  @param amount uint256 The amount of tokens unfrozen
310      */
311     event TokenUnfreezeEvent(address indexed _owner, uint256 amount);
312     event TokensBurned(address indexed _owner, uint256 _tokens);
313 
314     
315     mapping(address => uint256) internal frozenTokenBalances;
316 
317     function freezeTokens(address _owner, uint256 _value) public onlyOwner {
318         require(_value <= balanceOf(_owner));
319         uint256 oldFrozenBalance = getFrozenBalance(_owner);
320         uint256 newFrozenBalance = oldFrozenBalance.add(_value);
321         setFrozenBalance(_owner,newFrozenBalance);
322         emit TokenFreezeEvent(_owner,_value);
323     }
324     
325     function unfreezeTokens(address _owner, uint256 _value) public onlyOwner {
326         require(_value <= getFrozenBalance(_owner));
327         uint256 oldFrozenBalance = getFrozenBalance(_owner);
328         uint256 newFrozenBalance = oldFrozenBalance.sub(_value);
329         setFrozenBalance(_owner,newFrozenBalance);
330         emit TokenUnfreezeEvent(_owner,_value);
331     }
332     
333     
334     function setFrozenBalance(address _owner, uint256 _newValue) internal {
335         frozenTokenBalances[_owner]=_newValue;
336     }
337 
338     function balanceOf(address _owner) view public returns(uint256)
339     {
340         return getTotalBalance(_owner).sub(getFrozenBalance(_owner));
341     }
342 
343     function getTotalBalance(address _owner) view public returns(uint256)
344     {
345         return balances[_owner];   
346     }
347 /**
348      * @dev Gets the amount of tokens which belong to the specified address BUT are frozen now.
349      * @param _owner The address to query the the balance of.
350      * @return An uint256 representing the amount of frozen tokens owned by the passed address.
351     */
352 
353     function getFrozenBalance(address _owner) view public returns(uint256)
354     {
355         return frozenTokenBalances[_owner];   
356     }
357     
358         /*
359     * @dev Token burn function
360     * @param _tokens uint256 amount of tokens to burn
361     */
362     function burnTokens(uint256 _tokens) public onlyOwner {
363         require(balanceOf(msg.sender) >= _tokens);
364         balances[msg.sender] = balances[msg.sender].sub(_tokens);
365         totalSupply = totalSupply.sub(_tokens);
366         emit TokensBurned(msg.sender, _tokens);
367     }
368 }