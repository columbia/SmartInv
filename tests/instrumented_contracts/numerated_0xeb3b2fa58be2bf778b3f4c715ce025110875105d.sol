1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     address public owner;
11 
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13     /**
14      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15      * account.
16      */
17     function Ownable() {
18         owner = msg.sender;
19     }
20 
21     /**
22      * @dev Throws if called by any account other than the owner.
23      */
24     modifier onlyOwner() {
25         require(msg.sender == owner);
26         _;
27     }
28 
29     /**
30      * @dev Allows the current owner to transfer control of the contract to a newOwner.
31      * @param newOwner The address to transfer ownership to.
32      */
33     function transferOwnership(address newOwner) onlyOwner public {
34         require(newOwner != address(0));
35         OwnershipTransferred(owner, newOwner);
36         owner = newOwner;
37     }
38 
39 }
40 
41 
42 
43 /**
44  * @title ERC20Basic
45  * @dev Simpler version of ERC20 interface
46  * @dev see https://github.com/ethereum/EIPs/issues/179
47  */
48 contract ERC20Basic {
49     uint256 public totalSupply;
50 
51     function balanceOf(address who) public constant returns (uint256);
52 
53     function transfer(address to, uint256 value) public returns (bool);
54 
55     event Transfer(address indexed from, address indexed to, uint256 value);
56 }
57 
58 
59 
60 
61 
62 
63 
64 
65 /**
66  * @title ERC20 interface
67  * @dev see https://github.com/ethereum/EIPs/issues/20
68  */
69 contract ERC20 is ERC20Basic {
70     function allowance(address owner, address spender) public constant returns (uint256);
71 
72     function transferFrom(address from, address to, uint256 value) public returns (bool);
73 
74     function approve(address spender, uint256 value) public returns (bool);
75 
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 
80 
81 
82 
83 
84 
85 
86 
87 /**
88  * @title Basic token
89  * @dev Basic version of StandardToken, with no allowances.
90  */
91 contract BasicToken is ERC20Basic {
92     using SafeMath for uint256;
93 
94     mapping (address => uint256) balances;
95 
96     /**
97     * @dev transfer token for a specified address
98     * @param _to The address to transfer to.
99     * @param _value The amount to be transferred.
100     */
101     function transfer(address _to, uint256 _value) public returns (bool) {
102         require(_to != address(0));
103 
104         // SafeMath.sub will throw if there is not enough balance.
105         balances[msg.sender] = balances[msg.sender].sub(_value);
106         balances[_to] = balances[_to].add(_value);
107         Transfer(msg.sender, _to, _value);
108         return true;
109     }
110 
111     /**
112     * @dev Gets the balance of the specified address.
113     * @param _owner The address to query the the balance of.
114     * @return An uint256 representing the amount owned by the passed address.
115     */
116     function balanceOf(address _owner) public constant returns (uint256 balance) {
117         return balances[_owner];
118     }
119 
120 }
121 
122 
123 
124 
125 
126 
127 
128 
129 /**
130  * @title Standard ERC20 token
131  *
132  * @dev Implementation of the basic standard token.
133  * @dev https://github.com/ethereum/EIPs/issues/20
134  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
135  */
136 contract StandardToken is ERC20, BasicToken {
137 
138     mapping (address => mapping (address => uint256)) allowed;
139 
140 
141     /**
142      * @dev Transfer tokens from one address to another
143      * @param _from address The address which you want to send tokens from
144      * @param _to address The address which you want to transfer to
145      * @param _value uint256 the amount of tokens to be transferred
146      */
147     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
148         require(_to != address(0));
149 
150         uint256 _allowance = allowed[_from][msg.sender];
151 
152         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
153         // require (_value <= _allowance);
154 
155         balances[_from] = balances[_from].sub(_value);
156         balances[_to] = balances[_to].add(_value);
157         allowed[_from][msg.sender] = _allowance.sub(_value);
158         Transfer(_from, _to, _value);
159         return true;
160     }
161 
162     /**
163      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
164      *
165      * Beware that changing an allowance with this method brings the risk that someone may use both the old
166      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
167      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
168      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169      * @param _spender The address which will spend the funds.
170      * @param _value The amount of tokens to be spent.
171      */
172     function approve(address _spender, uint256 _value) public returns (bool) {
173         allowed[msg.sender][_spender] = _value;
174         Approval(msg.sender, _spender, _value);
175         return true;
176     }
177 
178     /**
179      * @dev Function to check the amount of tokens that an owner allowed to a spender.
180      * @param _owner address The address which owns the funds.
181      * @param _spender address The address which will spend the funds.
182      * @return A uint256 specifying the amount of tokens still available for the spender.
183      */
184     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
185         return allowed[_owner][_spender];
186     }
187 
188     /**
189      * approve should be called when allowed[_spender] == 0. To increment
190      * allowed value is better to use this function to avoid 2 calls (and wait until
191      * the first transaction is mined)
192      * From MonolithDAO Token.sol
193      */
194     function increaseApproval(address _spender, uint _addedValue)
195     returns (bool success) {
196         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
197         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
198         return true;
199     }
200 
201     function decreaseApproval(address _spender, uint _subtractedValue)
202     returns (bool success) {
203         uint oldValue = allowed[msg.sender][_spender];
204         if (_subtractedValue > oldValue) {
205             allowed[msg.sender][_spender] = 0;
206         }
207         else {
208             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
209         }
210         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
211         return true;
212     }
213 
214 }
215 
216 
217 
218 
219 
220 /**
221  * @title SafeMath
222  * @dev Math operations with safety checks that throw on error
223  */
224 library SafeMath {
225     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
226         uint256 c = a * b;
227         if (a != 0 && c / a != b) revert();
228         return c;
229     }
230 
231     function div(uint256 a, uint256 b) internal constant returns (uint256) {
232         // assert(b > 0); // Solidity automatically throws when dividing by 0
233         uint256 c = a / b;
234         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
235         return c;
236     }
237 
238     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
239         if (b > a) revert();
240         return a - b;
241     }
242 
243     function add(uint256 a, uint256 b) internal constant returns (uint256) {
244         uint256 c = a + b;
245         if (c < a) revert();
246         return c;
247     }
248 }
249 
250 
251 /**
252  * @title VLBTokens
253  * @dev VLB Token contract based on Zeppelin StandardToken contract
254  */
255 contract VLBToken is StandardToken, Ownable {
256     using SafeMath for uint256;
257 
258     /**
259      * @dev ERC20 descriptor variables
260      */
261     string public constant name = "VLB Tokens";
262     string public constant symbol = "VLB";
263     uint8 public decimals = 18;
264 
265     /**
266      * @dev 220 millions is the initial Tokensale supply
267      */
268     uint256 public constant publicTokens = 220 * 10 ** 24;
269 
270     /**
271      * @dev 20 millions for the team
272      */
273     uint256 public constant teamTokens = 20 * 10 ** 24;
274 
275     /**
276      * @dev 10 millions as a bounty reward
277      */
278     uint256 public constant bountyTokens = 10 * 10 ** 24;
279 
280     /**
281      * @dev 2.5 millions as an initial wings.ai reward reserv
282      */
283     uint256 public constant wingsTokensReserv = 25 * 10 ** 23;
284     
285     /**
286      * @dev wings.ai reward calculated on tokensale finalization
287      */
288     uint256 public wingsTokensReward = 0;
289 
290     // TODO: TestRPC addresses, replace to real
291     address public constant teamTokensWallet = 0x6a6AcA744caDB8C56aEC51A8ce86EFCaD59989CF;
292     address public constant bountyTokensWallet = 0x91A7DE4ce8e8da6889d790B7911246B71B4c82ca;
293     address public constant crowdsaleTokensWallet = 0x5e671ceD703f3dDcE79B13F82Eb73F25bad9340e;
294     
295     /**
296      * @dev wings.ai wallet for reward collecting
297      */
298     address public constant wingsWallet = 0xcbF567D39A737653C569A8B7dFAb617E327a7aBD;
299 
300 
301     /**
302      * @dev Address of Crowdsale contract which will be compared
303      *       against in the appropriate modifier check
304      */
305     address public crowdsaleContractAddress;
306 
307     /**
308      * @dev variable that holds flag of ended tokensake 
309      */
310     bool isFinished = false;
311 
312     /**
313      * @dev Modifier that allow only the Crowdsale contract to be sender
314      */
315     modifier onlyCrowdsaleContract() {
316         require(msg.sender == crowdsaleContractAddress);
317         _;
318     }
319 
320     /**
321      * @dev event for the burnt tokens after crowdsale logging
322      * @param tokens amount of tokens available for crowdsale
323      */
324     event TokensBurnt(uint256 tokens);
325 
326     /**
327      * @dev event for the tokens contract move to the active state logging
328      * @param supply amount of tokens left after all the unsold was burned
329      */
330     event Live(uint256 supply);
331 
332     /**
333      * @dev event for bounty tone transfer logging
334      * @param from the address of bounty tokens wallet
335      * @param to the address of beneficiary tokens wallet
336      * @param value amount of tokens
337      */
338     event BountyTransfer(address indexed from, address indexed to, uint256 value);
339 
340     /**
341      * @dev Contract constructor
342      */
343     function VLBToken() {
344         // Issue team tokens
345         balances[teamTokensWallet] = balanceOf(teamTokensWallet).add(teamTokens);
346         Transfer(address(0), teamTokensWallet, teamTokens);
347 
348         // Issue bounty tokens
349         balances[bountyTokensWallet] = balanceOf(bountyTokensWallet).add(bountyTokens);
350         Transfer(address(0), bountyTokensWallet, bountyTokens);
351 
352         // Issue crowdsale tokens minus initial wings reward.
353         // see endTokensale for more details about final wings.ai reward
354         uint256 crowdsaleTokens = publicTokens.sub(wingsTokensReserv);
355         balances[crowdsaleTokensWallet] = balanceOf(crowdsaleTokensWallet).add(crowdsaleTokens);
356         Transfer(address(0), crowdsaleTokensWallet, crowdsaleTokens);
357 
358         // 250 millions tokens overall
359         totalSupply = publicTokens.add(bountyTokens).add(teamTokens);
360     }
361 
362     /**
363      * @dev back link VLBToken contract with VLBCrowdsale one
364      * @param _crowdsaleAddress non zero address of VLBCrowdsale contract
365      */
366     function setCrowdsaleAddress(address _crowdsaleAddress) onlyOwner external {
367         require(_crowdsaleAddress != address(0));
368         crowdsaleContractAddress = _crowdsaleAddress;
369 
370         // Allow crowdsale contract 
371         uint256 balance = balanceOf(crowdsaleTokensWallet);
372         allowed[crowdsaleTokensWallet][crowdsaleContractAddress] = balance;
373         Approval(crowdsaleTokensWallet, crowdsaleContractAddress, balance);
374     }
375 
376     /**
377      * @dev called only by linked VLBCrowdsale contract to end crowdsale.
378      *      all the unsold tokens will be burned and totalSupply updated
379      *      but wings.ai reward will be secured in advance
380      */
381     function endTokensale() onlyCrowdsaleContract external {
382         require(!isFinished);
383         uint256 crowdsaleLeftovers = balanceOf(crowdsaleTokensWallet);
384         
385         if (crowdsaleLeftovers > 0) {
386             totalSupply = totalSupply.sub(crowdsaleLeftovers).sub(wingsTokensReserv);
387             wingsTokensReward = totalSupply.div(100);
388             totalSupply = totalSupply.add(wingsTokensReward);
389 
390             balances[crowdsaleTokensWallet] = 0;
391             Transfer(crowdsaleTokensWallet, address(0), crowdsaleLeftovers);
392             TokensBurnt(crowdsaleLeftovers);
393         } else {
394             wingsTokensReward = wingsTokensReserv;
395         }
396         
397         balances[wingsWallet] = balanceOf(wingsWallet).add(wingsTokensReward);
398         Transfer(crowdsaleTokensWallet, wingsWallet, wingsTokensReward);
399 
400         isFinished = true;
401 
402         Live(totalSupply);
403     }
404 }