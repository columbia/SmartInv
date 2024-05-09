1 pragma solidity ^0.4.25;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a * b;
11         require(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         // require(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // require(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         require(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a);
30         return c;
31     }
32 }
33 
34 
35 /**
36  * @title Ownable
37  * @dev The Ownable contract has an owner address, and provides basic authorization control
38  * functions, this simplifies the implementation of "user permissions".
39  */
40 contract Ownable {
41     address public owner;
42 
43     /**
44      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
45      * account.
46      */
47     constructor() public {
48         owner = msg.sender;
49     }
50 
51     /**
52      * @dev Throws if called by any account other than the owner.
53      */
54     modifier onlyOwner() {
55         require(msg.sender == owner);
56         _;
57     }
58 
59     /**
60      * @dev Allows the current owner to transfer control of the contract to a newOwner.
61      * @param newOwner The address to transfer ownership to.
62      */
63     function transferOwnership(address newOwner) public onlyOwner {
64         if (newOwner != address(0)) {
65             owner = newOwner;
66         }
67     }
68 }
69 
70 
71 /**
72  * @title Haltable
73  *
74  * @dev Abstract contract that allows children to implement an
75  * emergency stop mechanism. Differs from Pausable by requiring a state.
76  *
77  *
78  * Originally envisioned in FirstBlood ICO contract.
79  */
80 contract Haltable is Ownable {
81     bool public halted;
82 
83     modifier inNormalState {
84         require(!halted);
85         _;
86     }
87 
88     modifier inEmergencyState {
89         require(halted);
90         _;
91     }
92 
93     // called by the owner on emergency, triggers stopped state
94     function halt() external onlyOwner inNormalState {
95         halted = true;
96     }
97 
98     // called by the owner on end of emergency, returns to normal state
99     function resume() external onlyOwner inEmergencyState {
100         halted = false;
101     }
102 
103 }
104 
105 
106 /**
107  * @title ERC20Basic
108  * @dev Simpler version of ERC20 interface
109  * @dev see https://github.com/ethereum/EIPs/issues/179
110  */
111 contract ERC20Basic {
112     uint256 public totalSupply;
113 
114     function balanceOf(address who) public view returns (uint256);
115 
116     function transfer(address to, uint256 value) public returns (bool);
117 
118     event Transfer(address indexed from, address indexed to, uint256 value);
119 }
120 
121 
122 /**
123  * @title ERC20 interface
124  * @dev see https://github.com/ethereum/EIPs/issues/20
125  */
126 contract ERC20 is ERC20Basic {
127     function allowance(address owner, address spender) public view returns (uint256);
128 
129     function transferFrom(address from, address to, uint256 value) public returns (bool);
130 
131     function approve(address spender, uint256 value) public returns (bool);
132 
133     event Approval(address indexed owner, address indexed spender, uint256 value);
134 }
135 
136 
137 /**
138  * @title Basic token
139  * @dev Basic version of StandardToken, with no allowances.
140  */
141 contract BasicToken is ERC20Basic {
142     using SafeMath for uint256;
143 
144     mapping(address => uint256) public balances;
145 
146     /* Transfer token for a specified address */
147     function transfer(address _to, uint256 _value) public returns (bool) {
148         balances[msg.sender] = balances[msg.sender].sub(_value);
149         balances[_to] = balances[_to].add(_value);
150         emit Transfer(msg.sender, _to, _value);
151         return true;
152     }
153 
154     /**
155     * @dev Gets the balance of the specified address.
156     * @param _owner The address to query the the balance of.
157     * @return A uint256 representing the amount owned by the passed address.
158     */
159     function balanceOf(address _owner) public view returns (uint256 balance) {
160         return balances[_owner];
161     }
162 
163 }
164 
165 
166 /**
167  * @title Standard ERC20 token
168  *
169  * @dev Implementation of the basic standard token.
170  * @dev https://github.com/ethereum/EIPs/issues/20
171  * @dev Based on FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
172  */
173 contract StandardToken is ERC20, BasicToken {
174 
175     mapping(address => mapping(address => uint256)) public allowed;
176 
177     /**
178      * @dev Transfer tokens from one address to another
179      * @param _from address The address which you want to send tokens from
180      * @param _to address The address which you want to transfer to
181      * @param _value uint256 the amount of tokens to be transferred
182      */
183     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
184         uint256 _allowance;
185         _allowance = allowed[_from][msg.sender];
186 
187         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
188         // require (_value <= _allowance);
189 
190         balances[_to] = balances[_to].add(_value);
191         balances[_from] = balances[_from].sub(_value);
192         allowed[_from][msg.sender] = _allowance.sub(_value);
193         emit Transfer(_from, _to, _value);
194         return true;
195     }
196 
197     /**
198      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
199      * @param _spender The address which will spend the funds.
200      * @param _value The amount of tokens to be spent.
201      */
202     function approve(address _spender, uint256 _value) public returns (bool) {
203 
204         // To change the approve amount you first have to reduce the addresses`
205         //  allowance to zero by calling `approve(_spender, 0)` if it is not
206         //  already 0 to mitigate the race condition described here:
207         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
208         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
209 
210         allowed[msg.sender][_spender] = _value;
211         emit Approval(msg.sender, _spender, _value);
212         return true;
213     }
214 
215     /**
216      * @dev Function to check the amount of tokens that an owner allowed to a spender.
217      * @param _owner address The address which owns the funds.
218      * @param _spender address The address which will spend the funds.
219      * @return A uint256 specifing the amount of tokens still available for the spender.
220      */
221     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
222         return allowed[_owner][_spender];
223     }
224 
225 }
226 
227 
228 /**
229  * @title Burnable
230  *
231  * @dev Standard ERC20 token
232  */
233 contract Burnable is StandardToken {
234     using SafeMath for uint;
235 
236     /* This notifies clients about the amount burnt */
237     event Burn(address indexed from, uint256 value);
238 
239     function burn(uint256 _value) public returns (bool success) {
240         require(balances[msg.sender] >= _value);
241         // Check if the sender has enough
242         balances[msg.sender] = balances[msg.sender].sub(_value);
243         // Subtract from the sender
244         totalSupply = totalSupply.sub(_value);
245         // Updates totalSupply
246         emit Burn(msg.sender, _value);
247         emit Transfer(msg.sender, address(0), _value);
248         return true;
249     }
250 
251     function burnFrom(address _from, uint256 _value) public returns (bool success) {
252         require(balances[_from] >= _value);
253         // Check if the sender has enough
254         require(_value <= allowed[_from][msg.sender]);
255         // Check allowance
256         balances[_from] = balances[_from].sub(_value);
257         // Subtract from the sender
258         totalSupply = totalSupply.sub(_value);
259         // Updates totalSupply
260         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
261         emit Burn(_from, _value);
262         emit Transfer(_from, address(0), _value);
263         return true;
264     }
265 
266     function transfer(address _to, uint _value) public returns (bool success) {
267         require(_to != 0x0);
268         //use burn
269 
270         return super.transfer(_to, _value);
271     }
272 
273     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
274         require(_to != 0x0);
275         //use burn
276 
277         return super.transferFrom(_from, _to, _value);
278     }
279 }
280 
281 
282 /**
283  * @title Centive Token
284  *
285  * @dev Burnable Ownable ERC20 token
286  */
287 contract Centive is Burnable, Ownable {
288 
289     string public name;
290     string public symbol;
291     uint8 public decimals = 18;
292 
293     /* The finalizer contract that removes the transfer restrictions imposed by the lockout period */
294     address public releaseAgent;
295 
296     /** A crowdsale contract can release us to the wild if ICO success.
297     * If false we are are in transfer lock up period.
298     *
299     */
300     bool public released = false;
301 
302     /** Map of agents that are allowed to transfer tokens regardless of the lock down period.
303     * These are crowdsale contracts and possible the team multisig itself.
304     *
305     */
306     mapping(address => bool) public transferAgents;
307 
308     /**
309      * Limit token transfer until the crowdsale is over.
310      *
311      */
312     modifier canTransfer(address _sender) {
313         require(transferAgents[_sender] || released);
314         _;
315     }
316 
317     /** The function can be called only before or after the tokens have been releasesd */
318     modifier inReleaseState(bool releaseState) {
319         require(releaseState == released);
320         _;
321     }
322 
323     /** The function can be called only by a whitelisted release agent. */
324     modifier onlyReleaseAgent() {
325         require(msg.sender == releaseAgent);
326         _;
327     }
328 
329     /** @dev Constructor that gives msg.sender all of existing tokens. */
330     constructor(uint256 initialSupply, string tokenName, string tokenSymbol) public {
331         totalSupply = initialSupply * 10 ** uint256(decimals);
332         // Update total supply with the decimal amount
333         balances[msg.sender] = totalSupply;
334         // Give the creator all initial tokens
335         name = tokenName;
336         // Set the name for display purposes
337         symbol = tokenSymbol;
338         // Set the symbol for display purposes
339     }
340 
341     /**
342      * Set the contract that can call release and make the token transferable.
343      *
344      * Design choice. Allow reset the release agent to fix fat finger mistakes.
345      */
346     function setReleaseAgent(address addr) external onlyOwner inReleaseState(false) {
347 
348         // We don't do interface check here as we might want to a normal wallet address to act as a release agent
349         releaseAgent = addr;
350     }
351 
352     function release() external onlyReleaseAgent inReleaseState(false) {
353         released = true;
354     }
355 
356     /**
357      * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
358      */
359     function setTransferAgent(address addr, bool state) external onlyOwner inReleaseState(false) {
360         transferAgents[addr] = state;
361     }
362 
363     function transfer(address _to, uint _value) public canTransfer(msg.sender) returns (bool success) {
364         // Call Burnable.transfer()
365         return super.transfer(_to, _value);
366     }
367 
368     function transferFrom(address _from, address _to, uint _value) public canTransfer(_from) returns (bool success) {
369         // Call Burnable.transferForm()
370         return super.transferFrom(_from, _to, _value);
371     }
372 
373     function burn(uint256 _value) public onlyOwner returns (bool success) {
374         return super.burn(_value);
375     }
376 
377     function burnFrom(address _from, uint256 _value) public onlyOwner returns (bool success) {
378         return super.burnFrom(_from, _value);
379     }
380 }