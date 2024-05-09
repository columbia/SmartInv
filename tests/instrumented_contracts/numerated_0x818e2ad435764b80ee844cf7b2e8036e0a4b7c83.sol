1 pragma solidity ^0.4.16;
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
41 
42     /**
43      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
44      * account.
45      */
46     function Ownable() {
47         owner = msg.sender;
48     }
49 
50 
51     /**
52      * @dev Throws if called by any account other than the owner.
53      */
54     modifier onlyOwner() {
55         require(msg.sender == owner);
56         _;
57     }
58 
59 
60     /**
61      * @dev Allows the current owner to transfer control of the contract to a newOwner.
62      * @param newOwner The address to transfer ownership to.
63      */
64     function transferOwnership(address newOwner) onlyOwner {
65         if (newOwner != address(0)) {
66             owner = newOwner;
67         }
68     }
69 
70 }
71 
72 /**
73  * @title Pausable
74  * @dev Base contract which allows children to implement an emergency stop mechanism.
75  */
76 contract Pausable is Ownable {
77     event Pause();
78     event Unpause();
79 
80     bool public paused = false;
81 
82 
83     /**
84      * @dev modifier to allow actions only when the contract IS paused
85      */
86     modifier whenNotPaused() {
87         require(!paused);
88         _;
89     }
90 
91     /**
92      * @dev modifier to allow actions only when the contract IS NOT paused
93      */
94     modifier whenPaused {
95         require(paused);
96         _;
97     }
98 
99     /**
100      * @dev called by the owner to pause, triggers stopped state
101      */
102     function pause() onlyOwner whenNotPaused returns (bool) {
103         paused = true;
104         Pause();
105         return true;
106     }
107 
108     /**
109      * @dev called by the owner to unpause, returns to normal state
110      */
111     function unpause() onlyOwner whenPaused returns (bool) {
112         paused = false;
113         Unpause();
114         return true;
115     }
116 }
117 
118 /**
119  * @title ERC20Basic
120  * @dev Simpler version of ERC20 interface
121  * @dev see https://github.com/ethereum/EIPs/issues/179
122  */
123 contract ERC20Basic {
124     uint256 public totalSupply;
125     function balanceOf(address who) constant returns (uint256);
126     function transfer(address to, uint256 value) returns (bool);
127     event Transfer(address indexed from, address indexed to, uint256 value);
128 }
129 
130 /**
131  * @title Basic token
132  * @dev Basic version of StandardToken, with no allowances.
133  */
134 contract BasicToken is ERC20Basic {
135     using SafeMath for uint256;
136 
137     mapping(address => uint256) balances;
138 
139     /**
140     * @dev transfer token for a specified address
141     * @param _to The address to transfer to.
142     * @param _value The amount to be transferred.
143     */
144     function transfer(address _to, uint256 _value) returns (bool) {
145         balances[msg.sender] = balances[msg.sender].sub(_value);
146         balances[_to] = balances[_to].add(_value);
147         Transfer(msg.sender, _to, _value);
148         return true;
149     }
150 
151     /**
152     * @dev Gets the balance of the specified address.
153     * @param _owner The address to query the the balance of.
154     * @return An uint256 representing the amount owned by the passed address.
155     */
156     function balanceOf(address _owner) constant returns (uint256 balance) {
157         return balances[_owner];
158     }
159 
160 }
161 
162 /**
163  * @title ERC20 interface
164  * @dev see https://github.com/ethereum/EIPs/issues/20
165  */
166 contract ERC20 is ERC20Basic {
167     function allowance(address owner, address spender) constant returns (uint256);
168     function transferFrom(address from, address to, uint256 value) returns (bool);
169     function approve(address spender, uint256 value) returns (bool);
170     event Approval(address indexed owner, address indexed spender, uint256 value);
171 }
172 
173 /**
174  * @title Standard ERC20 token
175  *
176  * @dev Implementation of the basic standard token.
177  * @dev https://github.com/ethereum/EIPs/issues/20
178  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
179  */
180 contract StandardToken is ERC20, BasicToken {
181 
182     mapping (address => mapping (address => uint256)) allowed;
183 
184 
185     /**
186      * @dev Transfer tokens from one address to another
187      * @param _from address The address which you want to send tokens from
188      * @param _to address The address which you want to transfer to
189      * @param _value uint256 the amout of tokens to be transfered
190      */
191     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
192         var _allowance = allowed[_from][msg.sender];
193 
194         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
195         // require (_value <= _allowance);
196 
197         balances[_to] = balances[_to].add(_value);
198         balances[_from] = balances[_from].sub(_value);
199         allowed[_from][msg.sender] = _allowance.sub(_value);
200         Transfer(_from, _to, _value);
201         return true;
202     }
203 
204     /**
205      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
206      * @param _spender The address which will spend the funds.
207      * @param _value The amount of tokens to be spent.
208      */
209     function approve(address _spender, uint256 _value) returns (bool) {
210 
211         // To change the approve amount you first have to reduce the addresses`
212         //  allowance to zero by calling `approve(_spender, 0)` if it is not
213         //  already 0 to mitigate the race condition described here:
214         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
215         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
216 
217         allowed[msg.sender][_spender] = _value;
218         Approval(msg.sender, _spender, _value);
219         return true;
220     }
221 
222     /**
223      * @dev Function to check the amount of tokens that an owner allowed to a spender.
224      * @param _owner address The address which owns the funds.
225      * @param _spender address The address which will spend the funds.
226      * @return A uint256 specifing the amount of tokens still avaible for the spender.
227      */
228     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
229         return allowed[_owner][_spender];
230     }
231 
232 }
233 
234 /**
235  * @title HoQuToken
236  * @dev HoQu.io token contract.
237  */
238 contract HoQuToken is StandardToken, Pausable {
239 
240     string public constant name = "HOQU Token";
241     string public constant symbol = "HQX";
242     uint32 public constant decimals = 18;
243 
244     /**
245      * @dev Give all tokens to msg.sender.
246      */
247     function HoQuToken(uint _totalSupply) {
248         require (_totalSupply > 0);
249         totalSupply = balances[msg.sender] = _totalSupply;
250     }
251 
252     function transfer(address _to, uint _value) whenNotPaused returns (bool) {
253         return super.transfer(_to, _value);
254     }
255 
256     function transferFrom(address _from, address _to, uint _value) whenNotPaused returns (bool) {
257         return super.transferFrom(_from, _to, _value);
258     }
259 }
260 
261 /**
262  * @title HoQuBurner
263  * @title HoQu.io contract to burn HQX.
264  */
265 contract HoQuBurner is Ownable {
266     using SafeMath for uint256;
267 
268     // token instance
269     HoQuToken public token;
270 
271     mapping(address => uint256) public burned;
272     mapping(uint32 => address) public transactionAddresses;
273     mapping(uint32 => uint256) public transactionAmounts;
274     uint32 public transactionsCount;
275 
276     /**
277     * Events for token burning
278     */
279     event TokenBurned(address indexed _sender, uint256 _tokens);
280 
281     /**
282     * @param _tokenAddress address of a HQX token contract
283     */
284     function HoQuBurner(address _tokenAddress) {
285         token = HoQuToken(_tokenAddress);
286     }
287 
288     /**
289      * Burn particular HQX amount already sent to this contract
290      *
291      * Should be executed by contract owner (for security reasons).
292      * Sender should just send HQX tokens to contract address
293      */
294     function burnFrom(address _sender, uint256 _tokens) onlyOwner {
295         require(_tokens > 0);
296 
297         token.transfer(address(0), _tokens);
298 
299         transactionAddresses[transactionsCount] = _sender;
300         transactionAmounts[transactionsCount] = _tokens;
301         transactionsCount++;
302 
303         burned[_sender] = burned[_sender].add(_tokens);
304 
305         TokenBurned(_sender, _tokens);
306     }
307 
308     /**
309      * Burn particular HQX amount using token allowance
310      *
311      * Should be executed by sender.
312      * Sender should give allowance for specified amount in advance (see approve method of HOQU token contract)
313      */
314     function burn(uint256 _tokens) {
315         token.transferFrom(msg.sender, this, _tokens);
316         burnFrom(msg.sender, _tokens);
317     }
318 }