1 pragma solidity 0.5.11;
2 
3 
4 
5 library SafeMath {
6     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7         if (a == 0) {
8             return 0;
9         }
10         uint256 c = a * b;
11         assert(c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40     address public owner;
41 
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45 
46     /**
47     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48     * account.
49     */
50     constructor() public {
51         owner = msg.sender;
52     }
53 
54     /**
55     * @dev Throws if called by any account other than the owner.
56     */
57     modifier onlyOwner() {
58         require(msg.sender == owner);
59         _;
60     }
61 
62     /**
63     * @dev Allows the current owner to transfer control of the contract to a newOwner.
64     * @param newOwner The address to transfer ownership to.
65     */
66     function transferOwnership(address newOwner) public onlyOwner {
67         require(newOwner != address(0));
68         emit OwnershipTransferred(owner, newOwner);
69         owner = newOwner;
70     }
71 }
72 
73 /**
74  * @title ERC20Basic
75  */
76 contract ERC20Basic {
77     uint256 public totalSupply;
78     function balanceOf(address who) public view returns (uint256);
79     function transfer(address to, uint256 value) public returns (bool);
80     event Transfer(address indexed from, address indexed to, uint256 value);
81 }
82 
83 /**
84  * @title ERC20 interface
85  */
86 contract ERC20 is ERC20Basic {
87     function allowance(address owner, address spender) public view returns (uint256);
88     function transferFrom(address from, address to, uint256 value) public returns (bool);
89     function approve(address spender, uint256 value) public returns (bool);
90     event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 /**
94  * @title Basic token
95  * @dev Basic version of StandardToken, with no allowances. 
96  */
97 contract BasicToken is ERC20Basic, Ownable {
98 
99     using SafeMath for uint256;
100 
101     mapping(address => uint256) balances;
102 
103     /**
104     * @dev transfer token for a specified address
105     * @param _to The address to transfer to.
106     * @param _value The amount to be transferred.
107     */
108     function transfer(address _to, uint256 _value) public returns (bool) {
109         require(_to != address(0));
110         require(_value <= balanceOf(msg.sender));
111 
112         // SafeMath.sub will throw if there is not enough balance.
113         balances[msg.sender] = balances[msg.sender].sub(_value);
114         balances[_to] = balances[_to].add(_value);
115         emit Transfer(msg.sender, _to, _value);
116         return true;
117     }
118 
119     /**
120     * @dev Gets the balance of the specified address.
121     * @param _owner The address to query the the balance of. 
122     * @return An uint256 representing the amount owned by the passed address.
123     */
124     function balanceOf(address _owner) public view returns (uint256 balance) {
125         return balances[_owner];
126     }
127     
128 }
129 
130 
131 /**
132  * @title Standard ERC20 token
133  *
134  * @dev Implementation of the basic standard token.
135  */
136 contract StandardToken is ERC20, BasicToken {
137 
138     mapping (address => mapping (address => uint256)) allowed;
139 
140     /**
141     * @dev Transfer tokens from one address to another
142     * @param _from address The address which you want to send tokens from
143     * @param _to address The address which you want to transfer to
144     * @param _value uint256 the amount of tokens to be transferred
145     */
146     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
147         require(_to != address(0));
148         require(allowed[_from][msg.sender] >= _value);
149         require(balanceOf(_from) >= _value);
150         require(balances[_to].add(_value) > balances[_to]); // Check for overflows
151         balances[_from] = balances[_from].sub(_value);
152         balances[_to] = balances[_to].add(_value);
153         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
154         emit Transfer(_from, _to, _value);
155         return true;
156     }
157 
158     /**
159     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
160     * @param _spender The address which will spend the funds.
161     * @param _value The amount of tokens to be spent.
162     */
163     function approve(address _spender, uint256 _value) public returns (bool) {
164         // To change the approve amount you first have to reduce the addresses`
165         //  allowance to zero by calling `approve(_spender, 0)` if it is not
166         //  already 0 to mitigate the race condition described here:
167         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
168         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
169         allowed[msg.sender][_spender] = _value;
170         emit Approval(msg.sender, _spender, _value);
171         return true;
172     }
173 
174     /**
175     * @dev Function to check the amount of tokens that an owner allowed to a spender.
176     * @param _owner address The address which owns the funds.
177     * @param _spender address The address which will spend the funds.
178     * @return A uint256 specifying the amount of tokens still available for the spender.
179     */
180     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
181         return allowed[_owner][_spender];
182     }
183 
184     /**
185     * approve should be called when allowed[_spender] == 0. To increment
186     * allowed value is better to use this function to avoid 2 calls (and wait until 
187     * the first transaction is mined)
188     * From MonolithDAO Token.sol
189     */
190     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
191         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
192         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
193         return true;
194     }
195 
196     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
197         uint oldValue = allowed[msg.sender][_spender];
198         if (_subtractedValue > oldValue) {
199             allowed[msg.sender][_spender] = 0;
200         } else {
201             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
202         }
203         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
204         return true;
205     }
206 }
207 
208 
209 /**
210  * @title Pausable
211  * @dev Base contract which allows children to implement an emergency stop mechanism.
212  */
213 contract Pausable is StandardToken {
214     event Pause();
215     event Unpause();
216 
217     bool public paused = false;
218 
219     address public founder;
220     
221     /**
222     * @dev modifier to allow actions only when the contract IS paused
223     */
224     modifier whenNotPaused() {
225         require(!paused || msg.sender == founder);
226         _;
227     }
228 
229     /**
230     * @dev modifier to allow actions only when the contract IS NOT paused
231     */
232     modifier whenPaused() {
233         require(paused);
234         _;
235     }
236 
237     /**
238     * @dev called by the owner to pause, triggers stopped state
239     */
240     function pause() public onlyOwner whenNotPaused {
241         paused = true;
242         emit Pause();
243     }
244 
245     /**
246     * @dev called by the owner to unpause, returns to normal state
247     */
248     function unpause() public onlyOwner whenPaused {
249         paused = false;
250         emit Unpause();
251     }
252 }
253 
254 
255 contract PausableToken is Pausable {
256 
257     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
258         return super.transfer(_to, _value);
259     }
260 
261     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
262         return super.transferFrom(_from, _to, _value);
263     }
264 
265     //The functions below surve no real purpose. Even if one were to approve another to spend
266     //tokens on their behalf, those tokens will still only be transferable when the token contract
267     //is not paused.
268 
269     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
270         return super.approve(_spender, _value);
271     }
272 
273     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
274         return super.increaseApproval(_spender, _addedValue);
275     }
276 
277     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
278         return super.decreaseApproval(_spender, _subtractedValue);
279     }
280 }
281 
282 contract Yearn20MoonFinance is PausableToken {
283 
284     string public name;
285     string public symbol;
286     uint8 public decimals;
287 
288     /**
289     * @dev Constructor that gives the founder all of the existing tokens.
290     */
291     constructor() public {
292         name = "Yearn20Moon.Finance";
293         symbol = "YMF20";
294         decimals = 8;
295         totalSupply = 20000*100000000;
296         
297         founder = msg.sender;
298 
299         balances[msg.sender] = totalSupply;
300         emit Transfer(address(0), msg.sender, totalSupply);
301     }
302     
303     /** @dev Fires on every freeze of tokens
304      *  @param _owner address The owner address of frozen tokens.
305      *  @param amount uint256 The amount of tokens frozen
306      */
307     event TokenFreezeEvent(address indexed _owner, uint256 amount);
308 
309     /** @dev Fires on every unfreeze of tokens
310      *  @param _owner address The owner address of unfrozen tokens.
311      *  @param amount uint256 The amount of tokens unfrozen
312      */
313     event TokenUnfreezeEvent(address indexed _owner, uint256 amount);
314     event TokensBurned(address indexed _owner, uint256 _tokens);
315 
316     
317     mapping(address => uint256) internal frozenTokenBalances;
318 
319     function freezeTokens(address _owner, uint256 _value) public onlyOwner {
320         require(_value <= balanceOf(_owner));
321         uint256 oldFrozenBalance = getFrozenBalance(_owner);
322         uint256 newFrozenBalance = oldFrozenBalance.add(_value);
323         setFrozenBalance(_owner,newFrozenBalance);
324         emit TokenFreezeEvent(_owner,_value);
325     }
326     
327     function unfreezeTokens(address _owner, uint256 _value) public onlyOwner {
328         require(_value <= getFrozenBalance(_owner));
329         uint256 oldFrozenBalance = getFrozenBalance(_owner);
330         uint256 newFrozenBalance = oldFrozenBalance.sub(_value);
331         setFrozenBalance(_owner,newFrozenBalance);
332         emit TokenUnfreezeEvent(_owner,_value);
333     }
334     
335     
336     function setFrozenBalance(address _owner, uint256 _newValue) internal {
337         frozenTokenBalances[_owner]=_newValue;
338     }
339 
340     function balanceOf(address _owner) view public returns(uint256)
341     {
342         return getTotalBalance(_owner).sub(getFrozenBalance(_owner));
343     }
344 
345     function getTotalBalance(address _owner) view public returns(uint256)
346     {
347         return balances[_owner];   
348     }
349 /**
350      * @dev Gets the amount of tokens which belong to the specified address BUT are frozen now.
351      * @param _owner The address to query the the balance of.
352      * @return An uint256 representing the amount of frozen tokens owned by the passed address.
353     */
354 
355     function getFrozenBalance(address _owner) view public returns(uint256)
356     {
357         return frozenTokenBalances[_owner];   
358     }
359     
360         /*
361     * @dev Token burn function
362     * @param _tokens uint256 amount of tokens to burn
363     */
364     function burnTokens(uint256 _tokens) public onlyOwner {
365         require(balanceOf(msg.sender) >= _tokens);
366         balances[msg.sender] = balances[msg.sender].sub(_tokens);
367         totalSupply = totalSupply.sub(_tokens);
368         emit TokensBurned(msg.sender, _tokens);
369     }
370 }