1 pragma solidity 0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42     address public owner;
43 
44 
45     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47 
48     /**
49     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50     * account.
51     */
52     constructor() public {
53         owner = msg.sender;
54     }
55 
56     /**
57     * @dev Throws if called by any account other than the owner.
58     */
59     modifier onlyOwner() {
60         require(msg.sender == owner);
61         _;
62     }
63 
64     /**
65     * @dev Allows the current owner to transfer control of the contract to a newOwner.
66     * @param newOwner The address to transfer ownership to.
67     */
68     function transferOwnership(address newOwner) public onlyOwner {
69         require(newOwner != address(0));
70         emit OwnershipTransferred(owner, newOwner);
71         owner = newOwner;
72     }
73 }
74 
75 /**
76  * @title ERC20Basic
77  */
78 contract ERC20Basic {
79     uint256 public totalSupply;
80     function balanceOf(address who) public view returns (uint256);
81     function transfer(address to, uint256 value) public returns (bool);
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 }
84 
85 /**
86  * @title ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/20
88  */
89 contract ERC20 is ERC20Basic {
90     function allowance(address owner, address spender) public view returns (uint256);
91     function transferFrom(address from, address to, uint256 value) public returns (bool);
92     function approve(address spender, uint256 value) public returns (bool);
93     event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 /**
97  * @title Basic token
98  * @dev Basic version of StandardToken, with no allowances. 
99  */
100 contract BasicToken is ERC20Basic, Ownable {
101 
102     using SafeMath for uint256;
103 
104     mapping(address => uint256) balances;
105 
106     mapping (address => bool) public frozenAccount;
107 
108     /* This generates a public event on the blockchain that will notify clients */
109     event FrozenFunds(address target, bool frozen);
110 
111     /**
112     * @dev transfer token for a specified address
113     * @param _to The address to transfer to.
114     * @param _value The amount to be transferred.
115     */
116     function transfer(address _to, uint256 _value) public returns (bool) {
117         require(_to != address(0));
118         require(_value <= balances[msg.sender]);
119 
120         require(!frozenAccount[msg.sender]);    // Check if sender is frozen
121         require(!frozenAccount[_to]);           // Check if recipient is frozen
122 
123         // SafeMath.sub will throw if there is not enough balance.
124         balances[msg.sender] = balances[msg.sender].sub(_value);
125         balances[_to] = balances[_to].add(_value);
126         emit Transfer(msg.sender, _to, _value);
127         return true;
128     }
129 
130     /**
131     * @dev Gets the balance of the specified address.
132     * @param _owner The address to query the the balance of. 
133     * @return An uint256 representing the amount owned by the passed address.
134     */
135     function balanceOf(address _owner) public view returns (uint256 balance) {
136         return balances[_owner];
137     }
138     
139     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
140     /// @param target Address to be frozen
141     /// @param freeze either to freeze it or not
142     function freezeAccount(address target, bool freeze) onlyOwner public {
143         frozenAccount[target] = freeze;
144         emit FrozenFunds(target, freeze);
145     }
146 }
147 
148 
149 /**
150  * @title Standard ERC20 token
151  *
152  * @dev Implementation of the basic standard token.
153  * @dev https://github.com/ethereum/EIPs/issues/20
154  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
155  */
156 contract StandardToken is ERC20, BasicToken {
157 
158     mapping (address => mapping (address => uint256)) allowed;
159 
160     /**
161     * @dev Transfer tokens from one address to another
162     * @param _from address The address which you want to send tokens from
163     * @param _to address The address which you want to transfer to
164     * @param _value uint256 the amount of tokens to be transferred
165     */
166     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
167         require(_to != address(0));
168         require(allowed[_from][msg.sender] >= _value);
169         require(balances[_from] >= _value);
170         require(balances[_to].add(_value) > balances[_to]); // Check for overflows
171         balances[_from] = balances[_from].sub(_value);
172         balances[_to] = balances[_to].add(_value);
173         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
174         emit Transfer(_from, _to, _value);
175         return true;
176     }
177 
178     /**
179     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
180     * @param _spender The address which will spend the funds.
181     * @param _value The amount of tokens to be spent.
182     */
183     function approve(address _spender, uint256 _value) public returns (bool) {
184         // To change the approve amount you first have to reduce the addresses`
185         //  allowance to zero by calling `approve(_spender, 0)` if it is not
186         //  already 0 to mitigate the race condition described here:
187         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
188         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
189         allowed[msg.sender][_spender] = _value;
190         emit Approval(msg.sender, _spender, _value);
191         return true;
192     }
193 
194     /**
195     * @dev Function to check the amount of tokens that an owner allowed to a spender.
196     * @param _owner address The address which owns the funds.
197     * @param _spender address The address which will spend the funds.
198     * @return A uint256 specifying the amount of tokens still available for the spender.
199     */
200     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
201         return allowed[_owner][_spender];
202     }
203 
204     /**
205     * approve should be called when allowed[_spender] == 0. To increment
206     * allowed value is better to use this function to avoid 2 calls (and wait until 
207     * the first transaction is mined)
208     * From MonolithDAO Token.sol
209     */
210     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
211         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
212         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
213         return true;
214     }
215 
216     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
217         uint oldValue = allowed[msg.sender][_spender];
218         if (_subtractedValue > oldValue) {
219             allowed[msg.sender][_spender] = 0;
220         } else {
221             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
222         }
223         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
224         return true;
225     }
226 }
227 
228 
229 /**
230  * @title Pausable
231  * @dev Base contract which allows children to implement an emergency stop mechanism.
232  */
233 contract Pausable is StandardToken {
234     event Pause();
235     event Unpause();
236 
237     bool public paused = false;
238 
239     address public founder;
240     
241     /**
242     * @dev modifier to allow actions only when the contract IS paused
243     */
244     modifier whenNotPaused() {
245         require(!paused || msg.sender == founder);
246         _;
247     }
248 
249     /**
250     * @dev modifier to allow actions only when the contract IS NOT paused
251     */
252     modifier whenPaused() {
253         require(paused);
254         _;
255     }
256 
257     /**
258     * @dev called by the owner to pause, triggers stopped state
259     */
260     function pause() public onlyOwner whenNotPaused {
261         paused = true;
262         emit Pause();
263     }
264     
265 
266     /**
267     * @dev called by the owner to unpause, returns to normal state
268     */
269     function unpause() public onlyOwner whenPaused {
270         paused = false;
271         emit Unpause();
272     }
273 }
274 
275 
276 contract PausableToken is Pausable {
277 
278     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
279         return super.transfer(_to, _value);
280     }
281 
282     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
283         return super.transferFrom(_from, _to, _value);
284     }
285 
286     //The functions below surve no real purpose. Even if one were to approve another to spend
287     //tokens on their behalf, those tokens will still only be transferable when the token contract
288     //is not paused.
289 
290     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
291         return super.approve(_spender, _value);
292     }
293 
294     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
295         return super.increaseApproval(_spender, _addedValue);
296     }
297 
298     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
299         return super.decreaseApproval(_spender, _subtractedValue);
300     }
301 }
302 
303 
304 contract MintableToken is PausableToken {
305     event Mint(address indexed to, uint256 amount);
306     event MintFinished();
307 
308     bool public mintingFinished = false;
309 
310 
311     modifier canMint() {
312         require(!mintingFinished);
313         _;
314     }
315 
316     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
317         totalSupply = totalSupply.add(_amount);
318         balances[_to] = balances[_to].add(_amount);
319         emit Mint(_to, _amount);
320         emit Transfer(address(0), _to, _amount);
321         return true;
322     }
323 
324     function finishMinting() public onlyOwner canMint returns (bool) {
325         mintingFinished = true;
326         emit MintFinished();
327         return true;
328     }
329 }
330 
331 contract MyAdvancedToken is MintableToken {
332 
333     string public name;
334     string public symbol;
335     uint8 public decimals;
336 
337     event TokensBurned(address initiatior, address indexed _partner, uint256 _tokens);
338 
339 
340     /**
341     * @dev Constructor that gives the founder all of the existing tokens.
342     */
343     constructor() public {
344         name = "Electronic Energy Coin";
345         symbol = "E2C";
346         decimals = 18;
347         totalSupply = 113636363e18;
348 
349         founder = 0x6784520Ac7fbfad578ABb5575d333A3f8739A5af;
350 
351         balances[msg.sender] = totalSupply;
352         balances[founder] = 0;
353         emit Transfer(0x0, msg.sender, totalSupply);
354         //pause();
355     }
356 
357     modifier onlyFounder {
358         require(msg.sender == founder);
359         _;
360     }
361 
362     event NewFounderAddress(address indexed from, address indexed to);
363 
364     function changeFounderAddress(address _newFounder) public onlyFounder {
365         require(_newFounder != 0x0);
366         emit NewFounderAddress(founder, _newFounder);
367         founder = _newFounder;
368     }
369 
370     /*
371     * @dev Token burn function to be called at the time of token swap
372     * @param _partner address to use for token balance buring
373     * @param _tokens uint256 amount of tokens to burn
374     */
375     function burnTokens(address _partner, uint256 _tokens) public onlyFounder {
376         require(balances[_partner] >= _tokens);
377         balances[_partner] = balances[_partner].sub(_tokens);
378         totalSupply = totalSupply.sub(_tokens);
379         emit TokensBurned(msg.sender, _partner, _tokens);
380     }
381 }