1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal constant returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal constant returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
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
47     function Ownable() {
48         owner = msg.sender;
49     }
50 
51     /**
52      * @dev Throws if called by any account other than the owner.
53      */
54     modifier onlyOwner() {
55         assert(msg.sender == owner);
56         _;
57     }
58 
59     /**
60      * @dev Allows the current owner to transfer control of the contract to a newOwner.
61      * @param newOwner The address to transfer ownership to.
62      */
63     function transferOwnership(address newOwner) onlyOwner {
64         assert(newOwner != address(0));
65         owner = newOwner;
66     }
67 }
68 
69 
70 /*
71  * @title Haltable
72  * @dev Abstract contract that allows children to implement an emergency stop mechanism.
73  * @dev Differs from Pausable by causing a throw when in halt mode.
74  */
75 contract Haltable is Ownable {
76     bool public halted;
77 
78     modifier stopInEmergency {
79         assert(!halted);
80         _;
81     }
82 
83     modifier onlyInEmergency {
84         assert(halted);
85         _;
86     }
87 
88     /**
89      * @dev Called by the owner on emergency, triggers stopped state.
90      */
91     function halt() external onlyOwner {
92         halted = true;
93     }
94 
95     /**
96      * @dev Called by the owner on end of emergency, returns to normal state.
97      */
98     function unhalt() external onlyOwner onlyInEmergency {
99         halted = false;
100     }
101 }
102 
103 
104 /**
105  * @title ERC20Basic
106  * @dev Simpler version of ERC20 interface
107  * @dev see https://github.com/ethereum/EIPs/issues/179
108  */
109 contract ERC20Basic {
110     uint256 public totalSupply;
111     function balanceOf(address who) constant returns (uint256);
112     function transfer(address to, uint256 value) returns (bool);
113     event Transfer(address indexed from, address indexed to, uint256 value);
114 }
115 
116 
117 /**
118  * @title Basic token
119  * @dev Basic version of StandardToken, with no allowances.
120  */
121 contract BasicToken is ERC20Basic {
122     using SafeMath for uint256;
123 
124     mapping(address => uint256) balances;
125 
126     /**
127      * @dev transfer token for a specified address
128      * @param _to The address to transfer to.
129      * @param _value The amount to be transferred.
130      */
131     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool) {
132         balances[msg.sender] = balances[msg.sender].sub(_value);
133         balances[_to] = balances[_to].add(_value);
134         Transfer(msg.sender, _to, _value);
135         return true;
136     }
137 
138     /**
139      * @dev Gets the balance of the specified address.
140      * @param _owner The address to query the the balance of.
141      * @return An uint256 representing the amount owned by the passed address.
142      */
143     function balanceOf(address _owner) constant returns (uint256 balance) {
144         return balances[_owner];
145     }
146 
147     /**
148      * @dev Fix for the ERC20 short address attack
149      * @dev see: http://vessenes.com/the-erc20-short-address-attack-explained/
150      * @dev see: https://www.reddit.com/r/ethereum/comments/63s917/worrysome_bug_exploit_with_erc20_token/dfwmhc3/
151      */
152     modifier onlyPayloadSize(uint size) {
153         assert (msg.data.length >= size + 4);
154         _;
155     }
156 }
157 
158 
159 /**
160  * @title ERC20 interface
161  * @dev see https://github.com/ethereum/EIPs/issues/20
162  */
163 contract ERC20 is ERC20Basic {
164     function allowance(address owner, address spender) constant returns (uint256);
165     function transferFrom(address from, address to, uint256 value) returns (bool);
166     function approve(address spender, uint256 value) returns (bool);
167     event Approval(address indexed owner, address indexed spender, uint256 value);
168 }
169 
170 
171 /**
172  * @title Standard ERC20 token
173  *
174  * @dev Implementation of the basic standard token.
175  * @dev https://github.com/ethereum/EIPs/issues/20
176  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
177  */
178 contract StandardToken is ERC20, BasicToken {
179     mapping (address => mapping (address => uint256)) allowed;
180 
181     /**
182      * @dev Transfer tokens from one address to another
183      * @param _from address The address which you want to send tokens from
184      * @param _to address The address which you want to transfer to
185      * @param _value uint256 the amout of tokens to be transfered
186      */
187     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
188         var _allowance = allowed[_from][msg.sender];
189         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
190         // assert (_value <= _allowance);
191         balances[_to] = balances[_to].add(_value);
192         balances[_from] = balances[_from].sub(_value);
193         allowed[_from][msg.sender] = _allowance.sub(_value);
194         Transfer(_from, _to, _value);
195         return true;
196     }
197 
198     /**
199      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
200      * @param _spender The address which will spend the funds.
201      * @param _value The amount of tokens to be spent.
202      */
203     function approve(address _spender, uint256 _value) returns (bool) {
204         // To change the approve amount you first have to reduce the addresses`
205         //  allowance to zero by calling `approve(_spender, 0)` if it is not
206         //  already 0 to mitigate the race condition described here:
207         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
208         assert((_value == 0) || (allowed[msg.sender][_spender] == 0));
209 
210         allowed[msg.sender][_spender] = _value;
211         Approval(msg.sender, _spender, _value);
212         return true;
213     }
214 
215     /**
216      * @dev Function to check the amount of tokens that an owner allowed to a spender.
217      * @param _owner address The address which owns the funds.
218      * @param _spender address The address which will spend the funds.
219      * @return A uint256 specifing the amount of tokens still available for the spender.
220      */
221     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
222         return allowed[_owner][_spender];
223     }
224 }
225 
226 
227 /**
228  * @title MintableToken
229  * @dev Token that can be minted by another contract until the defined cap is reached.
230  * @dev Based on https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
231  */
232 contract MintableToken is StandardToken, Ownable {
233     using SafeMath for uint;
234 
235     uint256 public mintableSupply;
236 
237     /**
238      * @dev List of agents that are allowed to create new tokens
239      */
240     mapping(address => bool) public mintAgents;
241 
242     event MintingAgentChanged(address addr, bool state);
243 
244     /**
245      * @dev Mint token from pool of mintable tokens.
246      * @dev Only callable by the mint-agent.
247      */
248     function mint(address receiver, uint256 amount) onlyPayloadSize(2 * 32) onlyMintAgent canMint public {
249         mintableSupply = mintableSupply.sub(amount);
250         balances[receiver] = balances[receiver].add(amount);
251         // This will make the mint transaction appear in EtherScan.io
252         // We can remove this after there is a standardized minting event
253         Transfer(0, receiver, amount);
254     }
255 
256     /**
257      * @dev Owner can allow a crowdsale contract to mint new tokens.
258      */
259     function setMintAgent(address addr, bool state) onlyOwner canMint public {
260         mintAgents[addr] = state;
261         MintingAgentChanged(addr, state);
262     }
263 
264     modifier onlyMintAgent() {
265         // Only the mint-agent is allowed to mint new tokens
266         assert (mintAgents[msg.sender]);
267         _;
268     }
269 
270     /**
271      * @dev Make sure we are not done yet.
272      */
273     modifier canMint() {
274         assert(mintableSupply > 0);
275         _;
276     }
277 
278     /**
279      * @dev Fix for the ERC20 short address attack
280      * @dev see: http://vessenes.com/the-erc20-short-address-attack-explained/
281      * @dev see: https://www.reddit.com/r/ethereum/comments/63s917/worrysome_bug_exploit_with_erc20_token/dfwmhc3/
282      */
283     modifier onlyPayloadSize(uint size) {
284         assert (msg.data.length >= size + 4);
285         _;
286     }
287 }
288 
289 
290 /*
291  * @title ReleasableToken
292  * @dev Token that may not be transfered until it was released.
293  */
294 contract ReleasableToken is ERC20, Ownable {
295     address public releaseAgent;
296     bool public released = false;
297 
298     /**
299      * @dev One way function to release the tokens to the wild.
300      */
301     function releaseToken() public onlyReleaseAgent {
302         released = true;
303     }
304 
305     /**
306      * @dev Set the contract that may call the release function.
307      */
308     function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
309         releaseAgent = addr;
310     }
311 
312     function transfer(address _to, uint _value) inReleaseState(true) returns (bool) {
313         return super.transfer(_to, _value);
314     }
315 
316     function transferFrom(address _from, address _to, uint _value) inReleaseState(true) returns (bool) {
317         return super.transferFrom(_from, _to, _value);
318     }
319 
320     /**
321      * @dev The function can be called only before or after the tokens have been releasesd
322      */
323     modifier inReleaseState(bool releaseState) {
324         assert(releaseState == released);
325         _;
326     }
327 
328     /**
329      * @dev The function can be called only by a whitelisted release agent.
330      */
331     modifier onlyReleaseAgent() {
332         assert(msg.sender == releaseAgent);
333         _;
334     }
335 }
336 
337 
338 /**
339  * @title EventChain
340  * @dev Contract for the EventChain token.
341  */
342 contract EventChain is ReleasableToken, MintableToken {
343     string public name = "EventChain";
344     string public symbol = "EVC";
345     uint8 public decimals = 18;
346     
347     function EventChain() {
348         // total supply is 84 million tokens
349         totalSupply = 84000000 ether;
350         mintableSupply = totalSupply;
351         // allow deployer to unlock token transfer and mint tokens
352         setReleaseAgent(msg.sender);
353         setMintAgent(msg.sender, true);
354     }
355 }