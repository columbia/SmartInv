1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal returns (uint256) {
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
41     /** 
42      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
43      * account.
44      */
45     function Ownable() {
46         owner = msg.sender;
47     }
48 
49     /**
50     * @dev Throws if called by any account other than the owner. 
51     */
52     modifier onlyOwner() {
53         if (msg.sender != owner) {
54             throw;
55         }
56         _;
57     }
58 
59     /**
60     * @dev Allows the current owner to transfer control of the contract to a newOwner.
61     * @param newOwner The address to transfer ownership to. 
62     */
63     function transferOwnership(address newOwner) onlyOwner {
64         if (newOwner != address(0)) {
65             owner = newOwner;
66         }
67     }
68 }
69 
70 /**
71  * @title ERC20Basic
72  * @dev Simpler version of ERC20 interface
73  * @dev see https://github.com/ethereum/EIPs/issues/20
74  */
75 contract ERC20Basic {
76     uint256 public totalSupply;
77     function balanceOf(address who) constant returns (uint256);
78     function transfer(address to, uint256 value);
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 }
81 
82 /**
83  * @title ERC20 interface
84  * @dev see https://github.com/ethereum/EIPs/issues/20
85  */
86 contract ERC20 is ERC20Basic {
87     function allowance(address owner, address spender) constant returns (uint256);
88     function transferFrom(address from, address to, uint256 value);
89     function approve(address spender, uint256 value);
90     event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 /**
94  * @title Basic token
95  * @dev Basic version of StandardToken, with no allowances. 
96  */
97 contract BasicToken is ERC20Basic, Ownable {
98     using SafeMath for uint256;
99 
100     mapping(address => uint256) balances;
101 
102     /**
103     * @dev transfer token for a specified address
104     * @param _to The address to transfer to.
105     * @param _value The amount to be transferred.
106     */
107     function transfer(address _to, uint256 _value) {
108         balances[msg.sender] = balances[msg.sender].sub(_value);
109         balances[_to] = balances[_to].add(_value);
110         Transfer(msg.sender, _to, _value);
111     }
112 
113     /**
114     * @dev Gets the balance of the specified address.
115     * @param _owner The address to query the the balance of. 
116     * @return An uint256 representing the amount owned by the passed address.
117     */
118     function balanceOf(address _owner) constant returns (uint256 balance) {
119         return balances[_owner];
120     }
121 }
122 
123 /**
124  * @title Standard ERC20 token
125  *
126  * @dev Implementation of the basic standard token.
127  * @dev https://github.com/ethereum/EIPs/issues/20
128  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
129  */
130 contract StandardToken is ERC20, BasicToken {
131     mapping (address => mapping (address => uint256)) allowed;
132 
133     /**
134     * @dev Transfer tokens from one address to another
135     * @param _from address The address which you want to send tokens from
136     * @param _to address The address which you want to transfer to
137     * @param _value uint256 the amout of tokens to be transfered
138     */
139     function transferFrom(address _from, address _to, uint256 _value) {
140         var _allowance = allowed[_from][msg.sender];
141 
142         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
143         // if (_value > _allowance) throw;
144 
145         balances[_to] = balances[_to].add(_value);
146         balances[_from] = balances[_from].sub(_value);
147         allowed[_from][msg.sender] = _allowance.sub(_value);
148         Transfer(_from, _to, _value);
149     }
150 
151     /**
152     * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
153     * @param _spender The address which will spend the funds.
154     * @param _value The amount of tokens to be spent.
155     */
156     function approve(address _spender, uint256 _value) {
157 
158         // To change the approve amount you first have to reduce the addresses`
159         //  allowance to zero by calling `approve(_spender, 0)` if it is not
160         //  already 0 to mitigate the race condition described here:
161         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
162         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
163 
164         allowed[msg.sender][_spender] = _value;
165         Approval(msg.sender, _spender, _value);
166     }
167 
168     /**
169     * @dev Function to check the amount of tokens that an owner allowed to a spender.
170     * @param _owner address The address which owns the funds.
171     * @param _spender address The address which will spend the funds.
172     * @return A uint256 specifing the amount of tokens still avaible for the spender.
173     */
174     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
175         return allowed[_owner][_spender];
176     }
177 
178 }
179 
180 /**
181  * @title TKRPToken
182  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator. 
183  * Note they can later distribute these tokens as they wish using `transfer` and other
184  * `StandardToken` functions.
185  */
186 contract TKRPToken is StandardToken {
187     event Destroy(address indexed _from);
188 
189     string public name = "TKRPToken";
190     string public symbol = "TKRP";
191     uint256 public decimals = 18;
192     uint256 public initialSupply = 500000;
193 
194     /**
195     * @dev Contructor that gives the sender all tokens
196     */
197     function TKRPToken() {
198         totalSupply = initialSupply;
199         balances[msg.sender] = initialSupply;
200     }
201 
202     /**
203     * @dev Destroys tokens from an address, this process is irrecoverable.
204     * @param _from The address to destroy the tokens from.
205     */
206     function destroyFrom(address _from) onlyOwner returns (bool) {
207         uint256 balance = balanceOf(_from);
208         if (balance == 0) throw;
209 
210         balances[_from] = 0;
211         totalSupply = totalSupply.sub(balance);
212 
213         Destroy(_from);
214     }
215 }
216 
217 /**
218  * @title PreCrowdsale
219  * @dev Smart contract which collects ETH and in return transfers the TKRPToken to the contributors
220  * Log events are emitted for each transaction 
221  */
222 contract PreCrowdsale is Ownable {
223     using SafeMath for uint256;
224 
225     /* 
226     * Stores the contribution in wei
227     * Stores the amount received in TKRP
228     */
229     struct Contributor {
230         uint256 contributed;
231         uint256 received;
232     }
233 
234     /* Backers are keyed by their address containing a Contributor struct */
235     mapping(address => Contributor) public contributors;
236 
237     /* Events to emit when a contribution has successfully processed */
238     event TokensSent(address indexed to, uint256 value);
239     event ContributionReceived(address indexed to, uint256 value);
240 
241     /* Constants */
242     uint256 public constant TOKEN_CAP = 500000;
243     uint256 public constant MINIMUM_CONTRIBUTION = 10 finney;
244     uint256 public constant TOKENS_PER_ETHER = 10000;
245     uint256 public constant PRE_CROWDSALE_DURATION = 5 days;
246 
247     /* Public Variables */
248     TKRPToken public token;
249     address public preCrowdsaleOwner;
250     uint256 public etherReceived;
251     uint256 public tokensSent;
252     uint256 public preCrowdsaleStartTime;
253     uint256 public preCrowdsaleEndTime;
254 
255     /* Modifier to check whether the preCrowdsale is running */
256     modifier preCrowdsaleRunning() {
257         if (now > preCrowdsaleEndTime || now < preCrowdsaleStartTime) throw;
258         _;
259     }
260 
261     /**
262     * @dev Fallback function which invokes the processContribution function
263     * @param _tokenAddress TKRP Token address
264     * @param _to preCrowdsale owner address
265     */
266     function PreCrowdsale(address _tokenAddress, address _to) {
267         token = TKRPToken(_tokenAddress);
268         preCrowdsaleOwner = _to;
269     }
270 
271     /**
272     * @dev Fallback function which invokes the processContribution function
273     */
274     function() preCrowdsaleRunning payable {
275         processContribution(msg.sender);
276     }
277 
278     /**
279     * @dev Starts the preCrowdsale
280     */
281     function start() onlyOwner {
282         if (preCrowdsaleStartTime != 0) throw;
283 
284         preCrowdsaleStartTime = now;            
285         preCrowdsaleEndTime = now + PRE_CROWDSALE_DURATION;    
286     }
287 
288     /**
289     * @dev A backup fail-safe drain if required
290     */
291     function drain() onlyOwner {
292         if (!preCrowdsaleOwner.send(this.balance)) throw;
293     }
294 
295     /**
296     * @dev Finalizes the preCrowdsale and sends funds
297     */
298     function finalize() onlyOwner {
299         if ((preCrowdsaleStartTime == 0 || now < preCrowdsaleEndTime) && tokensSent != TOKEN_CAP) {
300             throw;
301         }
302 
303         if (!preCrowdsaleOwner.send(this.balance)) throw;
304     }
305 
306     /**
307     * @dev Processes the contribution given, sends the tokens and emits events
308     * @param sender The address of the contributor
309     */
310     function processContribution(address sender) internal {
311         if (msg.value < MINIMUM_CONTRIBUTION) throw;
312 
313         uint256 contributionInTokens = msg.value.mul(TOKENS_PER_ETHER).div(1 ether);
314         if (contributionInTokens.add(tokensSent) > TOKEN_CAP) throw; 
315 
316         /* Send the tokens */
317         token.transfer(sender, contributionInTokens);
318 
319         /* Create a contributor struct and store the contributed/received values */
320         Contributor contributor = contributors[sender];
321         contributor.received = contributor.received.add(contributionInTokens);
322         contributor.contributed = contributor.contributed.add(msg.value);
323 
324         // /* Update the total amount of tokens sent and ether received */
325         etherReceived = etherReceived.add(msg.value);
326         tokensSent = tokensSent.add(contributionInTokens);
327 
328         // /* Emit log events */
329         TokensSent(sender, contributionInTokens);
330         ContributionReceived(sender, msg.value);
331     }
332 }