1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal constant returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal constant returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39     address public owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     /**
44      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
45      * account.
46      */
47     function Ownable() {
48         owner = msg.sender;
49     }
50 
51 
52     /**
53      * @dev Throws if called by any account other than the owner.
54      */
55     modifier onlyOwner() {
56         require(msg.sender == owner);
57         _;
58     }
59 
60 
61     /**
62      * @dev Allows the current owner to transfer control of the contract to a newOwner.
63      * @param newOwner The address to transfer ownership to.
64      */
65     function transferOwnership(address newOwner) onlyOwner public {
66         require(newOwner != address(0));
67         OwnershipTransferred(owner, newOwner);
68         owner = newOwner;
69     }
70 
71 }
72 
73 /**
74  * @title ERC20Basic
75  * @dev Simpler version of ERC20 interface
76  * @dev see https://github.com/ethereum/EIPs/issues/179
77  */
78 contract ERC20Basic {
79     uint256 public totalSupply;
80     function balanceOf(address who) constant returns (uint256);
81     function transfer(address to, uint256 value) returns (bool);
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 }
84 
85 
86 /**
87  * @title ERC20 interface
88  * @dev see https://github.com/ethereum/EIPs/issues/20
89  */
90 contract ERC20 is ERC20Basic {
91     function allowance(address owner, address spender) constant returns (uint256);
92     function transferFrom(address from, address to, uint256 value) returns (bool);
93     function approve(address spender, uint256 value) returns (bool);
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 
98 /**
99  * @title Basic token
100  * @dev Basic version of StandardToken, with no allowances.
101  */
102 contract BasicToken is ERC20Basic {
103     using SafeMath for uint256;
104 
105     mapping(address => uint256) balances;
106 
107     /**
108     * @dev transfer token for a specified address
109     * @param _to The address to transfer to.
110     * @param _value The amount to be transferred.
111     */
112     function transfer(address _to, uint256 _value) returns (bool) {
113         balances[msg.sender] = balances[msg.sender].sub(_value);
114         balances[_to] = balances[_to].add(_value);
115         Transfer(msg.sender, _to, _value);
116         return true;
117     }
118 
119     /**
120     * @dev Gets the balance of the specified address.
121     * @param _owner The address to query the the balance of.
122     * @return An uint256 representing the amount owned by the passed address.
123     */
124     function balanceOf(address _owner) constant returns (uint256 balance) {
125         return balances[_owner];
126     }
127 
128 }
129 
130 /**
131  * @title Standard ERC20 token
132  *
133  * @dev Implementation of the basic standard token.
134  * @dev https://github.com/ethereum/EIPs/issues/20
135  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
136  */
137 contract StandardToken is ERC20, BasicToken {
138 
139     mapping (address => mapping (address => uint256)) internal allowed;
140 
141 
142     /**
143      * @dev Transfer tokens from one address to another
144      * @param _from address The address which you want to send tokens from
145      * @param _to address The address which you want to transfer to
146      * @param _value uint256 the amount of tokens to be transferred
147      */
148     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
149         require(_to != address(0));
150         require(_value <= balances[_from]);
151         require(_value <= allowed[_from][msg.sender]);
152 
153         balances[_from] = balances[_from].sub(_value);
154         balances[_to] = balances[_to].add(_value);
155         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
156         Transfer(_from, _to, _value);
157         return true;
158     }
159 
160     /**
161      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
162      *
163      * Beware that changing an allowance with this method brings the risk that someone may use both the old
164      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
165      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
166      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
167      * @param _spender The address which will spend the funds.
168      * @param _value The amount of tokens to be spent.
169      */
170     function approve(address _spender, uint256 _value) public returns (bool) {
171         allowed[msg.sender][_spender] = _value;
172         Approval(msg.sender, _spender, _value);
173         return true;
174     }
175 
176     /**
177      * @dev Function to check the amount of tokens that an owner allowed to a spender.
178      * @param _owner address The address which owns the funds.
179      * @param _spender address The address which will spend the funds.
180      * @return A uint256 specifying the amount of tokens still available for the spender.
181      */
182     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
183         return allowed[_owner][_spender];
184     }
185 
186     /**
187      * approve should be called when allowed[_spender] == 0. To increment
188      * allowed value is better to use this function to avoid 2 calls (and wait until
189      * the first transaction is mined)
190      * From MonolithDAO Token.sol
191      */
192     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
193         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
194         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
195         return true;
196     }
197 
198     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
199         uint oldValue = allowed[msg.sender][_spender];
200         if (_subtractedValue > oldValue) {
201             allowed[msg.sender][_spender] = 0;
202         } else {
203             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
204         }
205         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
206         return true;
207     }
208 
209 }
210 
211 /**
212  * @title Pausable
213  * @dev Base contract which allows children to implement an emergency stop mechanism.
214  */
215 contract Pausable is Ownable {
216     event Pause();
217     event Unpause();
218 
219     bool public paused = false;
220 
221 
222     /**
223      * @dev Modifier to make a function callable only when the contract is not paused.
224      */
225     modifier whenNotPaused() {
226         require(!paused);
227         _;
228     }
229 
230     /**
231      * @dev Modifier to make a function callable only when the contract is paused.
232      */
233     modifier whenPaused() {
234         require(paused);
235         _;
236     }
237 
238     /**
239      * @dev called by the owner to pause, triggers stopped state
240      */
241     function pause() onlyOwner whenNotPaused public {
242         paused = true;
243         Pause();
244     }
245 
246     /**
247      * @dev called by the owner to unpause, returns to normal state
248      */
249     function unpause() onlyOwner whenPaused public {
250         paused = false;
251         Unpause();
252     }
253 }
254 
255 /**
256  * @title Pausable token
257  *
258  * @dev StandardToken modified with pausable transfers.
259  **/
260 
261 contract PausableToken is StandardToken, Pausable {
262 
263     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
264         return super.transfer(_to, _value);
265     }
266 
267     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
268         return super.transferFrom(_from, _to, _value);
269     }
270 
271     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
272         return super.approve(_spender, _value);
273     }
274 
275     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
276         return super.increaseApproval(_spender, _addedValue);
277     }
278 
279     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
280         return super.decreaseApproval(_spender, _subtractedValue);
281     }
282 }
283 
284 /**
285  * @title Mintable token
286  * @dev Simple ERC20 Token example, with mintable token creation
287  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
288  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
289  */
290 
291 contract MintableToken is StandardToken, Ownable {
292     event Mint(address indexed to, uint256 amount);
293     event MintFinished();
294 
295     bool public mintingFinished = false;
296 
297 
298     modifier canMint() {
299         require(!mintingFinished);
300         _;
301     }
302 
303     /**
304      * @dev Function to mint tokens
305      * @param _to The address that will receive the minted tokens.
306      * @param _amount The amount of tokens to mint.
307      * @return A boolean that indicates if the operation was successful.
308      */
309     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
310         totalSupply = totalSupply.add(_amount);
311         balances[_to] = balances[_to].add(_amount);
312         Mint(_to, _amount);
313         Transfer(0x0, _to, _amount);
314         return true;
315     }
316 
317     /**
318      * @dev Function to stop minting new tokens.
319      * @return True if the operation was successful.
320      */
321     function finishMinting() onlyOwner public returns (bool) {
322         mintingFinished = true;
323         MintFinished();
324         return true;
325     }
326 }
327 
328 /**
329  * @title Cryptomon token
330  * @dev Mintable token created for Cryptomon.io
331  */
332 contract CryptomonToken is PausableToken, MintableToken {
333 
334     // Standard token variables
335     string public name;    // CryptomonToken
336     string public symbol;  // CMN
337     uint8 public decimals; // 9
338 
339     event TokensBurned(address initiatior, address indexed _partner, uint256 _tokens);
340 
341     /*
342      * Constructor which pauses the token at the time of creation
343      */
344     function CryptomonToken(string tokenName, string tokenSymbol, uint8 decimalUnits) {
345         name = tokenName;          // Set the name for display purposes
346         symbol = tokenSymbol;      // Set the symbol for display purposes
347         decimals = decimalUnits;   // Amount of decimals for display purposes
348 
349         pause();
350     }
351     /*
352     * @dev Token burn function to be called at the time of token swap
353     * @param _partner address to use for token balance buring
354     * @param _tokens uint256 amount of tokens to burn
355     */
356     function burnTokens(address _partner, uint256 _tokens) public onlyOwner {
357         require(balances[_partner] >= _tokens);
358 
359         balances[_partner] -= _tokens;
360         totalSupply -= _tokens;
361         TokensBurned(msg.sender, _partner, _tokens);
362     }
363 }