1 pragma solidity ^0.4.16;
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
34 /**
35  * @title ERC20Basic
36  * @dev Simpler version of ERC20 interface
37  * @dev see https://github.com/ethereum/EIPs/issues/179
38  */
39 contract ERC20Basic {
40     uint256 public totalSupply;
41     function balanceOf(address who) public constant returns (uint256);
42     function transfer(address to, uint256 value) public returns (bool);
43     event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 /**
47  * @title Basic token
48  * @dev Basic version of StandardToken, with no allowances.
49  */
50 contract BasicToken is ERC20Basic {
51     using SafeMath for uint256;
52 
53     mapping(address => uint256) balances;
54 
55     /**
56     * @dev transfer token for a specified address
57     * @param _to The address to transfer to.
58     * @param _value The amount to be transferred.
59     */
60     function transfer(address _to, uint256 _value) public returns (bool) {
61         require(_to != address(0));
62         require(_value <= balances[msg.sender]);
63 
64         // SafeMath.sub will throw if there is not enough balance.
65         balances[msg.sender] = balances[msg.sender].sub(_value);
66         balances[_to] = balances[_to].add(_value);
67         Transfer(msg.sender, _to, _value);
68         return true;
69     }
70 
71     /**
72     * @dev Gets the balance of the specified address.
73     * @param _owner The address to query the the balance of.
74     * @return An uint256 representing the amount owned by the passed address.
75     */
76     function balanceOf(address _owner) public constant returns (uint256 balance) {
77         return balances[_owner];
78     }
79 
80 }
81 
82 /**
83  * @title ERC20 interface
84  * @dev see https://github.com/ethereum/EIPs/issues/20
85  */
86 contract ERC20 is ERC20Basic {
87     function allowance(address owner, address spender) public constant returns (uint256);
88     function transferFrom(address from, address to, uint256 value) public returns (bool);
89     function approve(address spender, uint256 value) public returns (bool);
90     event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 /**
94  * @title Standard ERC20 token
95  *
96  * @dev Implementation of the basic standard token.
97  * @dev https://github.com/ethereum/EIPs/issues/20
98  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
99  */
100 contract StandardToken is ERC20, BasicToken {
101 
102     mapping (address => mapping (address => uint256)) internal allowed;
103 
104 
105     /**
106      * @dev Transfer tokens from one address to another
107      * @param _from address The address which you want to send tokens from
108      * @param _to address The address which you want to transfer to
109      * @param _value uint256 the amount of tokens to be transferred
110      */
111     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
112         require(_to != address(0));
113         require(_value <= balances[_from]);
114         require(_value <= allowed[_from][msg.sender]);
115 
116         balances[_from] = balances[_from].sub(_value);
117         balances[_to] = balances[_to].add(_value);
118         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
119         Transfer(_from, _to, _value);
120         return true;
121     }
122 
123     /**
124      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
125      *
126      * Beware that changing an allowance with this method brings the risk that someone may use both the old
127      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
128      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
129      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
130      * @param _spender The address which will spend the funds.
131      * @param _value The amount of tokens to be spent.
132      */
133     function approve(address _spender, uint256 _value) public returns (bool) {
134         allowed[msg.sender][_spender] = _value;
135         Approval(msg.sender, _spender, _value);
136         return true;
137     }
138 
139     /**
140      * @dev Function to check the amount of tokens that an owner allowed to a spender.
141      * @param _owner address The address which owns the funds.
142      * @param _spender address The address which will spend the funds.
143      * @return A uint256 specifying the amount of tokens still available for the spender.
144      */
145     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
146         return allowed[_owner][_spender];
147     }
148 
149     /**
150      * approve should be called when allowed[_spender] == 0. To increment
151      * allowed value is better to use this function to avoid 2 calls (and wait until
152      * the first transaction is mined)
153      * From MonolithDAO Token.sol
154      */
155     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
156         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
157         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
158         return true;
159     }
160 
161     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
162         uint oldValue = allowed[msg.sender][_spender];
163         if (_subtractedValue > oldValue) {
164             allowed[msg.sender][_spender] = 0;
165         } else {
166             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
167         }
168         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
169         return true;
170     }
171 
172 }
173 
174 /**
175  * @title SafeERC20
176  * @dev Wrappers around ERC20 operations that throw on failure.
177  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
178  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
179  */
180 library SafeERC20 {
181     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
182         assert(token.transfer(to, value));
183     }
184 
185     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
186         assert(token.transferFrom(from, to, value));
187     }
188 
189     function safeApprove(ERC20 token, address spender, uint256 value) internal {
190         assert(token.approve(spender, value));
191     }
192 }
193 
194 contract TokenTimelock {
195     using SafeERC20 for ERC20Basic;
196 
197     // ERC20 basic token contract being held
198     ERC20Basic public token;
199 
200     // beneficiary of tokens after they are released
201     address public beneficiary;
202 
203     // timestamp when token release is enabled
204     uint64 public releaseTime;
205 
206     function TokenTimelock(ERC20Basic _token, address _beneficiary, uint64 _releaseTime) public {
207         require(_releaseTime > now);
208         token = _token;
209         beneficiary = _beneficiary;
210         releaseTime = _releaseTime;
211     }
212 
213     /**
214      * @notice Transfers tokens held by timelock to beneficiary.
215      */
216     function release() public {
217         require(now >= releaseTime);
218 
219         uint256 amount = token.balanceOf(this);
220         require(amount > 0);
221 
222         token.safeTransfer(beneficiary, amount);
223     }
224 }
225 
226 contract EchoLinkToken is StandardToken {
227     string public constant name = "EchoLink";
228     string public constant symbol = "EKO";
229     uint256 public constant decimals = 18;
230 
231     /// The owner of this address manages the token sale process.
232     address public owner;
233 
234     /// The owner of this address will manage the sale process.
235     address public saleTeamAddress;
236 
237     // this is the address of the timelock contract for the team tokens
238     address public timelockContractAddress;
239 
240     uint64 contractCreatedDatetime;
241 
242     bool public tokenSaleClosed = false;
243 
244     /// Minimum amount of tokens to be sold for the sale to succeed.
245     uint256 public constant GOAL = 5000 * 5000 * 10**decimals;
246 
247     /// Maximum tokens to be allocated.
248     uint256 public constant TOKENS_HARD_CAP = 2 * 50000 * 5000 * 10**decimals;
249 
250     /// Maximum tokens to be allocated.
251     uint256 public constant TOKENS_SALE_HARD_CAP = 50000 * 5000 * 10**decimals;
252 
253     /// Issue event index starting from 0.
254     uint256 public issueIndex = 0;
255 
256     /// Emitted for each sucuessful token purchase.
257     event Issue(uint _issueIndex, address addr, uint tokenAmount);
258 
259     event SaleSucceeded();
260 
261     event SaleFailed();
262 
263     modifier onlyOwner {
264         assert(msg.sender == owner);
265         _;
266     }
267 
268     modifier onlyTeam {
269         assert(msg.sender == saleTeamAddress || msg.sender == owner);
270         _;
271     }
272 
273     modifier inProgress {
274         assert(!saleHardCapReached() && !tokenSaleClosed);
275         _;
276     }
277 
278     modifier beforeEnd {
279         assert(!tokenSaleClosed);
280         _;
281     }
282 
283     function EchoLinkToken(address _saleTeamAddress) public {
284         require(_saleTeamAddress != address(0));
285         owner = msg.sender;
286         saleTeamAddress = _saleTeamAddress;
287         contractCreatedDatetime = uint64(block.timestamp);
288     }
289 
290     function close(uint256 _echoTeamTokens) public onlyOwner beforeEnd {
291         if (totalSupply < GOAL) {
292             SaleFailed();
293         } else {
294             SaleSucceeded();
295         }
296 
297         // compute without actually increasing it
298         uint256 increasedTotalSupply = totalSupply.add(_echoTeamTokens);
299         // roll back if hard cap reached
300         if(increasedTotalSupply > TOKENS_HARD_CAP) {
301             revert();
302         }
303 
304         // increase token total supply
305         totalSupply = increasedTotalSupply;
306 
307         // locked for 100 days after the contract creation
308         TokenTimelock lockedTeamTokens = new TokenTimelock(this, owner, contractCreatedDatetime + (60 * 60 * 24 * 100));
309         // or 100 days from this moment of the close() call
310         // TokenTimelock lockedTeamTokens = new TokenTimelock(this, owner, now + (60 * 60 * 24 * 100));
311 
312         timelockContractAddress = address(lockedTeamTokens);
313 
314         //update the investors balance to number of tokens sent
315         balances[timelockContractAddress] = balances[timelockContractAddress].add(_echoTeamTokens);
316 
317         //event is fired when tokens issued
318         Issue(
319         issueIndex++,
320         timelockContractAddress,
321         _echoTeamTokens
322         );
323 
324         tokenSaleClosed = true;
325     }
326 
327     function issueTokens(address _investor, uint256 _tokensAmount) public onlyTeam inProgress {
328         require(_investor != address(0));
329 
330         // compute without actually increasing it
331         uint256 increasedTotalSupply = totalSupply.add(_tokensAmount);
332         // roll back if hard cap reached
333         if(increasedTotalSupply > TOKENS_SALE_HARD_CAP) {
334             revert();
335         }
336 
337         //increase token total supply
338         totalSupply = increasedTotalSupply;
339         //update the investors balance to number of tokens sent
340         balances[_investor] = balances[_investor].add(_tokensAmount);
341         //event is fired when tokens issued
342         Issue(
343         issueIndex++,
344         _investor,
345         _tokensAmount
346         );
347     }
348 
349     function balanceOf(address _owner) public view returns (uint256 balance) {
350         return balances[_owner];
351     }
352 
353     /// @return true if the hard cap is reached.
354     function saleHardCapReached() public view returns (bool) {
355         return totalSupply >= TOKENS_SALE_HARD_CAP;
356     }
357 }