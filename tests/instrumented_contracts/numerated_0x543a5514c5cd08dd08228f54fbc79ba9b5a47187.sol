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
111 
112     /**
113     * Modifier avoids short address attacks.
114     * For more info check: https://ericrafaloff.com/analyzing-the-erc20-short-address-attack/
115     */
116     modifier onlyPayloadSize(uint size) {
117         if (msg.data.length < size + 4) {
118             revert();
119         }
120         _;
121     }
122 
123     /**
124     * @dev transfer token for a specified address
125     * @param _to The address to transfer to.
126     * @param _value The amount to be transferred.
127     */
128     function transfer(address _to, uint256 _value) public onlyPayloadSize(2 * 32) returns (bool) {
129         require(_to != address(0));
130         require(_value <= balances[msg.sender]);
131 
132         require(!frozenAccount[msg.sender]);    // Check if sender is frozen
133         require(!frozenAccount[_to]);           // Check if recipient is frozen
134 
135         // SafeMath.sub will throw if there is not enough balance.
136         balances[msg.sender] = balances[msg.sender].sub(_value);
137         balances[_to] = balances[_to].add(_value);
138         emit Transfer(msg.sender, _to, _value);
139         return true;
140     }
141 
142     /**
143     * @dev Gets the balance of the specified address.
144     * @param _owner The address to query the the balance of. 
145     * @return An uint256 representing the amount owned by the passed address.
146     */
147     function balanceOf(address _owner) public view returns (uint256 balance) {
148         return balances[_owner];
149     }
150     
151     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
152     /// @param target Address to be frozen
153     /// @param freeze either to freeze it or not
154     function freezeAccount(address target, bool freeze) onlyOwner public {
155         frozenAccount[target] = freeze;
156         emit FrozenFunds(target, freeze);
157     }
158 }
159 
160 
161 /**
162  * @title Standard ERC20 token
163  *
164  * @dev Implementation of the basic standard token.
165  * @dev https://github.com/ethereum/EIPs/issues/20
166  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
167  */
168 contract StandardToken is ERC20, BasicToken {
169 
170     mapping (address => mapping (address => uint256)) allowed;
171 
172     /**
173     * @dev Transfer tokens from one address to another
174     * @param _from address The address which you want to send tokens from
175     * @param _to address The address which you want to transfer to
176     * @param _value uint256 the amount of tokens to be transferred
177     */
178     function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3 * 32) returns (bool) {
179         require(_to != address(0));
180         require(allowed[_from][msg.sender] >= _value);
181         require(balances[_from] >= _value);
182         require(balances[_to].add(_value) > balances[_to]); // Check for overflows
183         balances[_from] = balances[_from].sub(_value);
184         balances[_to] = balances[_to].add(_value);
185         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
186         emit Transfer(_from, _to, _value);
187         return true;
188     }
189 
190     /**
191     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
192     * @param _spender The address which will spend the funds.
193     * @param _value The amount of tokens to be spent.
194     */
195     function approve(address _spender, uint256 _value) public returns (bool) {
196         // To change the approve amount you first have to reduce the addresses`
197         //  allowance to zero by calling `approve(_spender, 0)` if it is not
198         //  already 0 to mitigate the race condition described here:
199         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
200         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
201         allowed[msg.sender][_spender] = _value;
202         emit Approval(msg.sender, _spender, _value);
203         return true;
204     }
205 
206     /**
207     * @dev Function to check the amount of tokens that an owner allowed to a spender.
208     * @param _owner address The address which owns the funds.
209     * @param _spender address The address which will spend the funds.
210     * @return A uint256 specifying the amount of tokens still available for the spender.
211     */
212     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
213         return allowed[_owner][_spender];
214     }
215 
216     /**
217     * approve should be called when allowed[_spender] == 0. To increment
218     * allowed value is better to use this function to avoid 2 calls (and wait until 
219     * the first transaction is mined)
220     * From MonolithDAO Token.sol
221     */
222     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
223         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
224         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225         return true;
226     }
227 
228     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
229         uint oldValue = allowed[msg.sender][_spender];
230         if (_subtractedValue > oldValue) {
231             allowed[msg.sender][_spender] = 0;
232         } else {
233             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
234         }
235         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
236         return true;
237     }
238 }
239 
240 
241 /**
242  * @title Pausable
243  * @dev Base contract which allows children to implement an emergency stop mechanism.
244  */
245 contract Pausable is StandardToken {
246     event Pause();
247     event Unpause();
248 
249     bool public paused = false;
250 
251     address public founder;
252     
253     /**
254     * @dev modifier to allow actions only when the contract IS paused
255     */
256     modifier whenNotPaused() {
257         require(!paused || msg.sender == founder);
258         _;
259     }
260 
261     /**
262     * @dev modifier to allow actions only when the contract IS NOT paused
263     */
264     modifier whenPaused() {
265         require(paused);
266         _;
267     }
268 
269     /**
270     * @dev called by the owner to pause, triggers stopped state
271     */
272     function pause() public onlyOwner whenNotPaused {
273         paused = true;
274         emit Pause();
275     }
276     
277 
278     /**
279     * @dev called by the owner to unpause, returns to normal state
280     */
281     function unpause() public onlyOwner whenPaused {
282         paused = false;
283         emit Unpause();
284     }
285 }
286 
287 
288 contract PausableToken is Pausable {
289 
290     function transfer(address _to, uint256 _value) public whenNotPaused onlyPayloadSize(2 * 32) returns (bool) {
291         return super.transfer(_to, _value);
292     }
293 
294     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused onlyPayloadSize(3 * 32) returns (bool) {
295         return super.transferFrom(_from, _to, _value);
296     }
297 
298     //The functions below surve no real purpose. Even if one were to approve another to spend
299     //tokens on their behalf, those tokens will still only be transferable when the token contract
300     //is not paused.
301 
302     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
303         return super.approve(_spender, _value);
304     }
305 
306     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
307         return super.increaseApproval(_spender, _addedValue);
308     }
309 
310     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
311         return super.decreaseApproval(_spender, _subtractedValue);
312     }
313 }
314 
315 
316 contract MintableToken is PausableToken {
317     event Mint(address indexed to, uint256 amount);
318     event MintFinished();
319 
320     bool public mintingFinished = false;
321 
322 
323     modifier canMint() {
324         require(!mintingFinished);
325         _;
326     }
327 
328     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
329         totalSupply = totalSupply.add(_amount);
330         balances[_to] = balances[_to].add(_amount);
331         emit Mint(_to, _amount);
332         emit Transfer(address(0), _to, _amount);
333         return true;
334     }
335 
336     function finishMinting() public onlyOwner canMint returns (bool) {
337         mintingFinished = true;
338         emit MintFinished();
339         return true;
340     }
341 }
342 
343 contract MyAdvancedToken is MintableToken {
344 
345     string public name;
346     string public symbol;
347     uint8 public decimals;
348 
349     event TokensBurned(address initiatior, address indexed _partner, uint256 _tokens);
350 
351 
352     /**
353     * @dev Constructor that gives the founder all of the existing tokens.
354     */
355     constructor() public {
356         name = "Electronic Energy Coin";
357         symbol = "E2C";
358         decimals = 18;
359         totalSupply = 1000000000e18;
360 
361         address beneficial = 0x6784520Ac7fbfad578ABb5575d333A3f8739A5af;
362         uint256 beneficialAmt = 1000000e18; //1 million at beneficial
363         uint256 founderAmt = totalSupply.sub(1000000e18);
364 
365         balances[msg.sender] = founderAmt;
366         balances[beneficial] = beneficialAmt;
367         emit Transfer(0x0, msg.sender, founderAmt);
368         emit Transfer(0x0, beneficial, beneficialAmt);
369         //pause();
370     }
371 
372     modifier onlyFounder {
373         require(msg.sender == founder);
374         _;
375     }
376 
377     event NewFounderAddress(address indexed from, address indexed to);
378 
379     function changeFounderAddress(address _newFounder) public onlyFounder {
380         require(_newFounder != 0x0);
381         emit NewFounderAddress(founder, _newFounder);
382         founder = _newFounder;
383     }
384 
385     /*
386     * @dev Token burn function to be called at the time of token swap
387     * @param _partner address to use for token balance buring
388     * @param _tokens uint256 amount of tokens to burn
389     */
390     function burnTokens(address _partner, uint256 _tokens) public onlyFounder {
391         require(balances[_partner] >= _tokens);
392         balances[_partner] = balances[_partner].sub(_tokens);
393         totalSupply = totalSupply.sub(_tokens);
394         emit TokensBurned(msg.sender, _partner, _tokens);
395     }
396 }