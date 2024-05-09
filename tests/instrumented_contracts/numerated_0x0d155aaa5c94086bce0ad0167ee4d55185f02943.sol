1 pragma solidity ^0.4.24;
2 
3 
4 /**
5   * @title SafeMath
6   * @dev Math operations with safety checks that throw on error
7   */
8 library SafeMath {
9 /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         if (a == 0) {
14             return 0;
15         }
16         c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return a / b;
29     }
30 
31     /**
32     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43         c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 
50 /**
51 * @title Ownable
52 * @dev The Ownable contract has an owner address, and provides basic authorization control
53 * functions, this simplifies the implementation of "user permissions".
54 */
55 contract Ownable {
56     address public owner;
57     event OwnershipRenounced(address indexed previousOwner);
58     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60     /**
61     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62     * account.
63     */
64     constructor() public {
65         owner = msg.sender;
66     }
67 
68     /**
69     * @dev Throws if called by any account other than the owner.
70     */
71     modifier onlyOwner() {
72         require(msg.sender == owner);
73         _;
74     }
75 
76     /**
77     * @dev Allows the current owner to transfer control of the contract to a newOwner.
78     * @param newOwner The address to transfer ownership to.
79     */
80     function transferOwnership(address newOwner) public onlyOwner {
81         require(newOwner != address(0));
82         emit OwnershipTransferred(owner, newOwner);
83         owner = newOwner;
84     }
85 
86     /**
87     * @dev Allows the current owner to relinquish control of the contract.
88     */
89     function renounceOwnership() public onlyOwner {
90         emit OwnershipRenounced(owner);
91         owner = address(0);
92     }
93 }
94 
95 
96 /**
97  * @title ERC20Basic
98  * @dev Simpler version of ERC20 interface
99  * @dev see https://github.com/ethereum/EIPs/issues/179
100  */
101 contract ERC20Basic {
102     function totalSupply() public view returns (uint256);
103     function balanceOf(address who) public view returns (uint256);
104     function transfer(address to, uint256 value) public returns (bool);
105     event Transfer(address indexed from, address indexed to, uint256 value);
106 }
107 
108 
109 /**
110  * @title ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/20
112  */
113 contract ERC20 is ERC20Basic {
114     function allowance(address owner, address spender) public view returns (uint256);
115     function transferFrom(address from, address to, uint256 value) public returns (bool);
116     function approve(address spender, uint256 value) public returns (bool);
117     event Approval(address indexed owner, address indexed spender, uint256 value);
118 }
119 
120 
121 contract VANMToken is ERC20, Ownable {
122     using SafeMath for uint256;
123 
124     //Variables
125     string public symbol;
126     string public name;
127     uint8 public decimals;
128     uint256 public _totalSupply;
129 
130     mapping(address => uint256) balances;
131     mapping(address => mapping(address => uint256)) internal allowed;
132 
133     uint256 public presaleSupply;
134     address public presaleAddress;
135 
136     uint256 public crowdsaleSupply;
137     address public crowdsaleAddress;
138 
139     uint256 public platformSupply;
140     address public platformAddress;
141 
142     uint256 public incentivisingSupply;
143     address public incentivisingAddress;
144 
145     uint256 public teamSupply;
146     address public teamAddress;
147 
148     uint256 public crowdsaleEndsAt;
149 
150     uint256 public teamVestingPeriod;
151 
152     bool public presaleFinalized = false;
153 
154     bool public crowdsaleFinalized = false;
155 
156     //Modifiers
157     //Only presale contract
158     modifier onlyPresale() {
159         require(msg.sender == presaleAddress);
160         _;
161     }
162 
163     //Only crowdsale contract
164     modifier onlyCrowdsale() {
165         require(msg.sender == crowdsaleAddress);
166         _;
167     }
168 
169     //crowdsale has to be over
170     modifier notBeforeCrowdsaleEnds(){
171         require(block.timestamp >= crowdsaleEndsAt);
172         _;
173     }
174 
175     // Check if vesting period is over
176     modifier checkTeamVestingPeriod() {
177         require(block.timestamp >= teamVestingPeriod);
178         _;
179     }
180 
181     //Events
182     event PresaleFinalized(uint tokensRemaining);
183 
184     event CrowdsaleFinalized(uint tokensRemaining);
185 
186     //Constructor
187     constructor() public {
188 
189         //Basic information
190         symbol = "VANM";
191         name = "VANM";
192         decimals = 18;
193 
194         //Total VANM supply
195         _totalSupply = 240000000 * 10**uint256(decimals);
196 
197         // 10% of total supply for presale
198         presaleSupply = 24000000 * 10**uint256(decimals);
199 
200         // 50% of total supply for crowdsale
201         crowdsaleSupply = 120000000 * 10**uint256(decimals);
202 
203         // 10% of total supply for platform
204         platformSupply = 24000000 * 10**uint256(decimals);
205 
206         // 20% of total supply for incentivising
207         incentivisingSupply = 48000000 * 10**uint256(decimals);
208 
209         // 10% of total supply for team
210         teamSupply = 24000000 * 10**uint256(decimals);
211 
212         platformAddress = 0x6962371D5a9A229C735D936df5CE6C690e66b718;
213 
214         teamAddress = 0xB9e54846da59C27eFFf06C3C08D5d108CF81FEae;
215 
216         // 01.05.2019 00:00:00 UTC
217         crowdsaleEndsAt = 1556668800;
218 
219         // 2 years vesting period
220         teamVestingPeriod = crowdsaleEndsAt.add(2 * 365 * 1 days);
221 
222         balances[platformAddress] = platformSupply;
223         emit Transfer(0x0, platformAddress, platformSupply);
224 
225         balances[incentivisingAddress] = incentivisingSupply;
226     }
227 
228     //External functions
229     //Set Presale Address when it's deployed
230     function setPresaleAddress(address _presaleAddress) external onlyOwner {
231         require(presaleAddress == 0x0);
232         presaleAddress = _presaleAddress;
233         balances[_presaleAddress] = balances[_presaleAddress].add(presaleSupply);
234     }
235 
236     // Finalize presale. Leftover tokens will overflow to crowdsale.
237     function finalizePresale() external onlyPresale {
238         require(presaleFinalized == false);
239         uint256 amount = balanceOf(presaleAddress);
240         if (amount > 0) {
241             balances[presaleAddress] = 0;
242             balances[crowdsaleAddress] = balances[crowdsaleAddress].add(amount);
243         }
244         presaleFinalized = true;
245         emit PresaleFinalized(amount);
246     }
247 
248     //Set Crowdsale Address when it's deployed
249     function setCrowdsaleAddress(address _crowdsaleAddress) external onlyOwner {
250         require(presaleAddress != 0x0);
251         require(crowdsaleAddress == 0x0);
252         crowdsaleAddress = _crowdsaleAddress;
253         balances[_crowdsaleAddress] = balances[_crowdsaleAddress].add(crowdsaleSupply);
254     }
255 
256     // Finalize crowdsale. Leftover tokens will overflow to platform.
257     function finalizeCrowdsale() external onlyCrowdsale {
258         require(presaleFinalized == true && crowdsaleFinalized == false);
259         uint256 amount = balanceOf(crowdsaleAddress);
260         if (amount > 0) {
261             balances[crowdsaleAddress] = 0;
262             balances[platformAddress] = balances[platformAddress].add(amount);
263             emit Transfer(0x0, platformAddress, amount);
264         }
265         crowdsaleFinalized = true;
266         emit CrowdsaleFinalized(amount);
267     }
268 
269     //Public functions
270     //ERC20 functions
271     function totalSupply() public view returns (uint256) {
272         return _totalSupply;
273     }
274 
275     function transfer(address _to, uint256 _value) public
276     notBeforeCrowdsaleEnds
277     returns (bool) {
278         require(_to != address(0));
279         require(_value <= balances[msg.sender]);
280         balances[msg.sender] = balances[msg.sender].sub(_value);
281         balances[_to] = balances[_to].add(_value);
282         emit Transfer(msg.sender, _to, _value);
283         return true;
284     }
285 
286     function balanceOf(address _owner) public view returns (uint256) {
287         return balances[_owner];
288     }
289 
290     function transferFrom(address _from, address _to, uint256 _value) public
291     notBeforeCrowdsaleEnds
292     returns (bool) {
293         require(_to != address(0));
294         require(_value <= balances[_from]);
295         require(_value <= allowed[_from][msg.sender]);
296         balances[_from] = balances[_from].sub(_value);
297         balances[_to] = balances[_to].add(_value);
298         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
299         emit Transfer(_from, _to, _value);
300         return true;
301     }
302 
303     function approve(address _spender, uint256 _value) public returns (bool) {
304         allowed[msg.sender][_spender] = _value;
305         emit Approval(msg.sender, _spender, _value);
306         return true;
307     }
308 
309     function allowance(address _owner, address _spender) public view returns (uint256) {
310         return allowed[_owner][_spender];
311     }
312 
313     //Token functions
314     //Incentivising function to transfer tokens
315     function transferFromIncentivising(address _to, uint256 _value) public
316     onlyOwner
317     returns (bool) {
318     require(_value <= balances[incentivisingAddress]);
319         balances[incentivisingAddress] = balances[incentivisingAddress].sub(_value);
320         balances[_to] = balances[_to].add(_value);
321         emit Transfer(0x0, _to, _value);
322         return true;
323     }
324 
325     //Presalefunction to transfer tokens
326     function transferFromPresale(address _to, uint256 _value) public
327     onlyPresale
328     returns (bool) {
329     require(_value <= balances[presaleAddress]);
330         balances[presaleAddress] = balances[presaleAddress].sub(_value);
331         balances[_to] = balances[_to].add(_value);
332         emit Transfer(0x0, _to, _value);
333         return true;
334     }
335 
336     //Crowdsalefunction to transfer tokens
337     function transferFromCrowdsale(address _to, uint256 _value) public
338     onlyCrowdsale
339     returns (bool) {
340     require(_value <= balances[crowdsaleAddress]);
341         balances[crowdsaleAddress] = balances[crowdsaleAddress].sub(_value);
342         balances[_to] = balances[_to].add(_value);
343         emit Transfer(0x0, _to, _value);
344         return true;
345     }
346 
347     // Release team supply after vesting period is finished.
348     function releaseTeamTokens() public checkTeamVestingPeriod onlyOwner returns(bool) {
349         require(teamSupply > 0);
350         balances[teamAddress] = teamSupply;
351         emit Transfer(0x0, teamAddress, teamSupply);
352         teamSupply = 0;
353         return true;
354     }
355 
356     //Check remaining incentivising tokens
357     function checkIncentivisingBalance() public view returns (uint256) {
358         return balances[incentivisingAddress];
359     }
360 
361     //Check remaining presale tokens after presale contract is deployed
362     function checkPresaleBalance() public view returns (uint256) {
363         return balances[presaleAddress];
364     }
365 
366     //Check remaining crowdsale tokens after crowdsale contract is deployed
367     function checkCrowdsaleBalance() public view returns (uint256) {
368         return balances[crowdsaleAddress];
369     }
370 
371     //Recover ERC20 Tokens
372     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
373         return ERC20(tokenAddress).transfer(owner, tokens);
374     }
375 
376     //Don't accept ETH
377     function () public payable {
378 revert();
379     }
380 }