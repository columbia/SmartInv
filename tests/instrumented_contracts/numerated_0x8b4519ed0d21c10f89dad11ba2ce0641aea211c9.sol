1 pragma solidity ^0.4.24;
2 
3 
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function div(uint256 a, uint256 b) internal pure returns (uint256) {
12         // assert(b > 0); // Solidity automatically throws when dividing by 0
13         uint256 c = a / b;
14         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15         return c;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 
31 contract ERC20Basic {
32     uint256 public totalSupply;
33 
34     bool public transfersEnabled;
35 
36     function balanceOf(address who) public view returns (uint256);
37 
38     function transfer(address to, uint256 value) public returns (bool);
39 
40     event Transfer(address indexed from, address indexed to, uint256 value);
41 }
42 
43 
44 contract ERC20 {
45     uint256 public totalSupply;
46 
47     bool public transfersEnabled;
48 
49     function balanceOf(address _owner) public constant returns (uint256 balance);
50 
51     function transfer(address _to, uint256 _value) public returns (bool success);
52 
53     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
54 
55     function approve(address _spender, uint256 _value) public returns (bool success);
56 
57     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
58 
59     event Transfer(address indexed _from, address indexed _to, uint256 _value);
60 
61     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
62 }
63 
64 
65 contract BasicToken is ERC20Basic {
66     using SafeMath for uint256;
67 
68     mapping (address => uint256) balances;
69 
70     address public addressFundTeam = 0x0DA34504b759071605f89BE43b2804b1869404f2;
71     uint256 public fundTeam = 1125 * 10**4 * (10 ** 18);
72     uint256 endTimeIco = 1551535200; //Saturday, 2. March 2019 14:00:00
73 
74     /**
75     * Protection against short address attack
76     */
77     modifier onlyPayloadSize(uint numwords) {
78         assert(msg.data.length == numwords * 32 + 4);
79         _;
80     }
81 
82     /**
83     * @dev transfer token for a specified address
84     * @param _to The address to transfer to.
85     * @param _value The amount to be transferred.
86     */
87     function transfer(address _to, uint256 _value) public onlyPayloadSize(2) returns (bool) {
88         require(_to != address(0));
89         require(_value <= balances[msg.sender]);
90         require(transfersEnabled);
91         if (msg.sender == addressFundTeam) {
92             require(checkVesting(_value, now) > 0);
93         }
94 
95         // SafeMath.sub will throw if there is not enough balance.
96         balances[msg.sender] = balances[msg.sender].sub(_value);
97         balances[_to] = balances[_to].add(_value);
98         emit Transfer(msg.sender, _to, _value);
99         return true;
100     }
101 
102     /**
103     * @dev Gets the balance of the specified address.
104     * @param _owner The address to query the the balance of.
105     * @return An uint256 representing the amount owned by the passed address.
106     */
107     function balanceOf(address _owner) public constant returns (uint256 balance) {
108         return balances[_owner];
109     }
110 
111     function checkVesting(uint256 _value, uint256 _currentTime) public view returns(uint8 period) {
112         period = 0;
113         require(endTimeIco <= _currentTime);
114         if (endTimeIco + 26 weeks <= _currentTime && _currentTime < endTimeIco + 52 weeks) {
115             period = 1;
116             require(balances[addressFundTeam].sub(_value) >= fundTeam.mul(95).div(100));
117         }
118         if (endTimeIco + 52 weeks <= _currentTime && _currentTime < endTimeIco + 78 weeks) {
119             period = 2;
120             require(balances[addressFundTeam].sub(_value) >= fundTeam.mul(85).div(100));
121         }
122         if (endTimeIco + 78 weeks <= _currentTime && _currentTime < endTimeIco + 104 weeks) {
123             period = 3;
124             require(balances[addressFundTeam].sub(_value) >= fundTeam.mul(65).div(100));
125         }
126         if (endTimeIco + 104 weeks <= _currentTime && _currentTime < endTimeIco + 130 weeks) {
127             period = 4;
128             require(balances[addressFundTeam].sub(_value) >= fundTeam.mul(35).div(100));
129         }
130         if (endTimeIco + 130 weeks <= _currentTime) {
131             period = 5;
132             require(balances[addressFundTeam].sub(_value) >= 0);
133         }
134     }
135 }
136 
137 
138 contract StandardToken is ERC20, BasicToken {
139 
140     mapping (address => mapping (address => uint256)) internal allowed;
141 
142     /**
143      * @dev Transfer tokens from one address to another
144      * @param _from address The address which you want to send tokens from
145      * @param _to address The address which you want to transfer to
146      * @param _value uint256 the amount of tokens to be transferred
147      */
148     function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3) returns (bool) {
149         require(_to != address(0));
150         require(_value <= balances[_from]);
151         require(_value <= allowed[_from][msg.sender]);
152         require(transfersEnabled);
153 
154         balances[_from] = balances[_from].sub(_value);
155         balances[_to] = balances[_to].add(_value);
156         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
157         emit Transfer(_from, _to, _value);
158         return true;
159     }
160 
161     /**
162      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
163      *
164      * Beware that changing an allowance with this method brings the risk that someone may use both the old
165      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
166      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
167      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
168      * @param _spender The address which will spend the funds.
169      * @param _value The amount of tokens to be spent.
170      */
171     function approve(address _spender, uint256 _value) public returns (bool) {
172         allowed[msg.sender][_spender] = _value;
173         emit Approval(msg.sender, _spender, _value);
174         return true;
175     }
176 
177     /**
178      * @dev Function to check the amount of tokens that an owner allowed to a spender.
179      * @param _owner address The address which owns the funds.
180      * @param _spender address The address which will spend the funds.
181      * @return A uint256 specifying the amount of tokens still available for the spender.
182      */
183     function allowance(address _owner, address _spender) public onlyPayloadSize(2) constant returns (uint256 remaining) {
184         return allowed[_owner][_spender];
185     }
186 
187     /**
188      * approve should be called when allowed[_spender] == 0. To increment
189      * allowed value is better to use this function to avoid 2 calls (and wait until
190      * the first transaction is mined)
191      * From MonolithDAO Token.sol
192      */
193     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
194         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
195         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
196         return true;
197     }
198 
199     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
200         uint oldValue = allowed[msg.sender][_spender];
201         if (_subtractedValue > oldValue) {
202             allowed[msg.sender][_spender] = 0;
203         }
204         else {
205             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
206         }
207         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
208         return true;
209     }
210 
211 }
212 
213 
214 /**
215  * @title Ownable
216  * @dev The Ownable contract has an owner address, and provides basic authorization control
217  * functions, this simplifies the implementation of "user permissions".
218  */
219 contract Ownable {
220     address public owner;
221     event OwnerChanged(address indexed previousOwner, address indexed newOwner);
222 
223     /**
224      * @dev Throws if called by any account other than the owner.
225      */
226     modifier onlyOwner() {
227         require(msg.sender == owner);
228         _;
229     }
230 }
231 
232 
233 /**
234  * @title Mintable token
235  * @dev Simple ERC20 Token example, with mintable token creation
236  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
237  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
238  */
239 
240 contract CryptoCasherToken is StandardToken, Ownable {
241     string public constant name = "CryptoCasher";
242     string public constant symbol = "CRR";
243     uint8 public constant decimals = 18;
244     uint256 public constant INITIAL_SUPPLY = 75 * 10**6 * (10 ** uint256(decimals));
245 
246     uint256 fundForSale = 525 * 10**5 * (10 ** uint256(decimals));
247 
248     address addressFundAdvisors = 0xee3b4F0A6EA27cCDA45f2F58982EA54c5d7E8570;
249     uint256 fundAdvisors = 6 * 10**6 * (10 ** uint256(decimals));
250 
251     address addressFundBounty = 0x97133480b61377A93dF382BebDFC3025D56bA2C6;
252     uint256 fundBounty = 375 * 10**4 * (10 ** uint256(decimals));
253 
254     address addressFundBlchainReferal = 0x2F9092Fe1dACafF1165b080BfF3afFa6165e339a;
255     uint256 fundBlchainReferal = 75 * 10**4 * (10 ** uint256(decimals));
256 
257     address addressFundWebSiteReferal = 0x45E2203eD8bD3888D052F4CF37ac91CF6563789D;
258     uint256 fundWebSiteReferal = 75 * 10**4 * (10 ** uint256(decimals));
259 
260     address addressContract;
261 
262     event Mint(address indexed to, uint256 amount);
263     event Burn(address indexed burner, uint256 value);
264     event AddressContractChanged(address indexed addressContract, address indexed sender);
265 
266 
267 constructor (address _owner) public
268     {
269         require(_owner != address(0));
270         owner = _owner;
271         //owner = msg.sender; //for test's
272         transfersEnabled = true;
273         distribToken(owner);
274         totalSupply = INITIAL_SUPPLY;
275     }
276 
277     /**
278     * @dev Add an contract admin
279     */
280     function setContractAddress(address _contract) public onlyOwner {
281         require(_contract != address(0));
282         addressContract = _contract;
283         emit AddressContractChanged(_contract, msg.sender);
284     }
285 
286     modifier onlyContract() {
287         require(msg.sender == addressContract);
288         _;
289     }
290     /**
291      * @dev Function to mint tokens
292      * @param _to The address that will receive the minted tokens.
293      * @param _amount The amount of tokens to mint.
294      * @return A boolean that indicates if the operation was successful.
295      */
296     function mint(address _to, uint256 _amount, address _owner) external onlyContract returns (bool) {
297         require(_to != address(0) && _owner != address(0));
298         require(_amount <= balances[_owner]);
299         require(transfersEnabled);
300 
301         balances[_to] = balances[_to].add(_amount);
302         balances[_owner] = balances[_owner].sub(_amount);
303         emit Mint(_to, _amount);
304         emit Transfer(_owner, _to, _amount);
305         return true;
306     }
307 
308     /**
309      * Peterson's Law Protection
310      * Claim tokens
311      */
312     function claimTokens(address _token) public onlyOwner {
313         if (_token == 0x0) {
314             owner.transfer(address(this).balance);
315             return;
316         }
317 
318         CryptoCasherToken token = CryptoCasherToken(_token);
319         uint256 balance = token.balanceOf(this);
320         token.transfer(owner, balance);
321 
322         emit Transfer(_token, owner, balance);
323     }
324 
325     function distribToken(address _wallet) internal {
326         require(_wallet != address(0));
327 
328         balances[addressFundAdvisors] = balances[addressFundAdvisors].add(fundAdvisors);
329 
330         balances[addressFundTeam] = balances[addressFundTeam].add(fundTeam);
331 
332         balances[addressFundBounty] = balances[addressFundBounty].add(fundBounty);
333         balances[addressFundBlchainReferal] = balances[addressFundBlchainReferal].add(fundBlchainReferal);
334         balances[addressFundWebSiteReferal] = balances[addressFundWebSiteReferal].add(fundWebSiteReferal);
335 
336         balances[_wallet] = balances[_wallet].add(fundForSale);
337     }
338 
339     /**
340     * @dev owner burn Token.
341     * @param _value amount of burnt tokens
342     */
343     function ownerBurnToken(uint _value) public onlyOwner {
344         require(_value > 0);
345         require(_value <= balances[owner]);
346         require(_value <= totalSupply);
347         require(_value <= fundForSale);
348 
349         balances[owner] = balances[owner].sub(_value);
350         totalSupply = totalSupply.sub(_value);
351         emit Burn(msg.sender, _value);
352     }
353 }