1 pragma solidity ^0.4.15;
2 
3 contract Utils {
4     /**
5         constructor
6     */
7     function Utils() internal {
8     }
9 
10     modifier validAddress(address _address) {
11         require(_address != 0x0);
12         _;
13     }
14 
15     modifier notThis(address _address) {
16         require(_address != address(this));
17         _;
18     }
19 
20 
21     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
22         uint256 z = _x + _y;
23         assert(z >= _x);
24         return z;
25     }
26 
27 
28     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
29         assert(_x >= _y);
30         return _x - _y;
31     }
32 
33 
34     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
35         uint256 z = _x * _y;
36         assert(_x == 0 || z / _x == _y);
37         return z;
38     }
39 }
40 
41 
42 contract IERC20Token {
43     function name() public constant returns (string) { name; }
44     function symbol() public constant returns (string) { symbol; }
45     function decimals() public constant returns (uint8) { decimals; }
46     function totalSupply() public constant returns (uint256) { totalSupply; }
47     function balanceOf(address _owner) public constant returns (uint256 balance);
48     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
49 
50     function transfer(address _to, uint256 _value) public returns (bool success);
51     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
52     function approve(address _spender, uint256 _value) public returns (bool success);
53 }
54 
55 
56 
57 contract StandardERC20Token is IERC20Token, Utils {
58     string public name = "";
59     string public symbol = "";
60     uint8 public decimals = 0;
61     uint256 public totalSupply = 0;
62     mapping (address => uint256) public balanceOf;
63     mapping (address => mapping (address => uint256)) public allowance;
64 
65     event Transfer(address indexed _from, address indexed _to, uint256 _value);
66     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
67     
68 
69 
70     function StandardERC20Token(string _name, string _symbol, uint8 _decimals) public{
71         require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input
72 
73         name = _name;
74         symbol = _symbol;
75         decimals = _decimals;
76     }
77 
78      function balanceOf(address _owner) constant returns (uint256) {
79         return balanceOf[_owner];
80     }
81     function allowance(address _owner, address _spender) constant returns (uint256) {
82         return allowance[_owner][_spender];
83     }
84 
85     function transfer(address _to, uint256 _value)
86         public
87         validAddress(_to)
88         returns (bool success)
89     {
90         require(balanceOf[msg.sender] >= _value && _value > 0);
91         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
92         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
93         Transfer(msg.sender, _to, _value);
94         return true;
95     }
96 
97 
98     function transferFrom(address _from, address _to, uint256 _value)
99         public
100         validAddress(_from)
101         validAddress(_to)
102         returns (bool success)
103     {
104         require(balanceOf[_from] >= _value && _value > 0);
105         require(allowance[_from][msg.sender] >= _value);
106         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
107         balanceOf[_from] = safeSub(balanceOf[_from], _value);
108         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
109         Transfer(_from, _to, _value);
110         return true;
111     }
112 
113 
114     function approve(address _spender, uint256 _value)
115         public
116         validAddress(_spender)
117         returns (bool success)
118     {
119         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
120         require(_value == 0 || allowance[msg.sender][_spender] == 0);
121 
122         allowance[msg.sender][_spender] = _value;
123         Approval(msg.sender, _spender, _value);
124         return true;
125     }
126 }
127 
128 
129 contract IOwned {
130     // this function isn't abstract since the compiler emits automatically generated getter functions as external
131     function owner() public constant returns (address) { owner; }
132 
133     function transferOwnership(address _newOwner) public;
134     function acceptOwnership() public;
135 }
136 
137 
138 contract Owned is IOwned {
139     address public owner;
140     address public newOwner;
141 
142     event OwnerUpdate(address _prevOwner, address _newOwner);
143 
144  
145     function Owned() public {
146         owner = msg.sender;
147     }
148 
149     modifier ownerOnly {
150         assert(msg.sender == owner);
151         _;
152     }
153 
154 
155     function transferOwnership(address _newOwner) public ownerOnly {
156         require(_newOwner != owner);
157         newOwner = _newOwner;
158     }
159 
160 
161     function acceptOwnership() public {
162         require(msg.sender == newOwner);
163         OwnerUpdate(owner, newOwner);
164         owner = newOwner;
165         newOwner = 0x0;
166     }
167 }
168 
169 contract GoolaStop is Owned{
170 
171     bool public stopped = false;
172 
173     modifier stoppable {
174         assert (!stopped);
175         _;
176     }
177     function stop() public ownerOnly{
178         stopped = true;
179     }
180     function start() public ownerOnly{
181         stopped = false;
182     }
183 
184 }
185 
186 
187 contract GoolaToken is StandardERC20Token, Owned,GoolaStop {
188 
189 
190 
191     uint256 constant public GOOLA_UNIT = 10 ** 18;
192     uint256 public totalSupply = 100 * (10**8) * GOOLA_UNIT;
193 
194     uint256 constant public airdropSupply = 60 * 10**8 * GOOLA_UNIT;           
195     uint256 constant public earlyInitProjectSupply = 10 * 10**8 * GOOLA_UNIT;  
196     uint256 constant public teamSupply = 15 * 10**8 * GOOLA_UNIT;         
197     uint256 constant public ecosystemSupply = 15 * 10**8 * GOOLA_UNIT;   
198     
199     uint256  public tokensReleasedToTeam = 0;
200     uint256  public tokensReleasedToEcosystem = 0; 
201     uint256  public currentSupply = 0;  
202     
203     address public goolaTeamAddress;     
204     address public ecosystemAddress;
205     address public backupAddress;
206 
207     uint256 internal createTime = 1527730299;             
208     uint256 internal hasAirdrop = 0;
209     uint256 internal hasReleaseForEarlyInit = 0;
210     uint256 internal teamTranchesReleased = 0; 
211     uint256 internal ecosystemTranchesReleased = 0;  
212     uint256 internal maxTranches = 16;       
213 
214     function GoolaToken( address _ecosystemAddress, address _backupAddress, address _goolaTeamAddress)
215     StandardERC20Token("Goola token", "GOOLA", 18) public
216      {
217         goolaTeamAddress = _goolaTeamAddress;
218         ecosystemAddress = _ecosystemAddress;
219         backupAddress = _backupAddress;
220         createTime = now;
221     }
222 
223     function transfer(address _to, uint256 _value) public stoppable returns (bool success) {
224         return super.transfer(_to, _value);
225     }
226 
227 
228     function transferFrom(address _from, address _to, uint256 _value) public stoppable returns (bool success) {
229             return super.transferFrom(_from, _to, _value);
230     }
231     
232     function withdrawERC20TokenTo(IERC20Token _token, address _to, uint256 _amount)
233         public
234         ownerOnly
235         validAddress(_token)
236         validAddress(_to)
237         notThis(_to)
238     {
239         assert(_token.transfer(_to, _amount));
240 
241     }
242     
243         
244     function airdropBatchTransfer(address[] _to,uint256 _amountOfEach) public ownerOnly {
245         require(_to.length > 0 && _amountOfEach > 0 && _to.length * _amountOfEach <=  (airdropSupply - hasAirdrop) && (currentSupply + (_to.length * _amountOfEach)) <= totalSupply && _to.length < 100000);
246         for(uint16 i = 0; i < _to.length ;i++){
247          balanceOf[_to[i]] = safeAdd(balanceOf[_to[i]], _amountOfEach);
248           Transfer(0x0, _to[i], _amountOfEach);
249         }
250             currentSupply += (_to.length * _amountOfEach);
251             hasAirdrop = safeAdd(hasAirdrop, _to.length * _amountOfEach);
252     }
253     
254   function releaseForEarlyInit(address[] _to,uint256 _amountOfEach) public ownerOnly {
255         require(_to.length > 0 && _amountOfEach > 0 && _to.length * _amountOfEach <=  (earlyInitProjectSupply - hasReleaseForEarlyInit) && (currentSupply + (_to.length * _amountOfEach)) <= totalSupply && _to.length < 100000);
256         for(uint16 i = 0; i < _to.length ;i++){
257           balanceOf[_to[i]] = safeAdd(balanceOf[_to[i]], _amountOfEach);
258           Transfer(0x0, _to[i], _amountOfEach);
259         }
260             currentSupply += (_to.length * _amountOfEach);
261             hasReleaseForEarlyInit = safeAdd(hasReleaseForEarlyInit, _to.length * _amountOfEach);
262     }
263 
264 
265     /**
266         @dev Release one  tranche of the ecosystemSupply allocation to Goola ecosystem,6.25% every tranche.About 4 years ecosystemSupply release over.
267        
268         @return true if successful, throws if not
269     */
270     function releaseForEcosystem()   public ownerOnly  returns(bool success) {
271         require(now >= createTime + 12 weeks);
272         require(tokensReleasedToEcosystem < ecosystemSupply);
273 
274         uint256 temp = ecosystemSupply / 10000;
275         uint256 allocAmount = safeMul(temp, 625);
276         uint256 currentTranche = uint256(now - createTime) /  12 weeks;
277 
278         if(ecosystemTranchesReleased < maxTranches && currentTranche > ecosystemTranchesReleased && (currentSupply + allocAmount) <= totalSupply) {
279             ecosystemTranchesReleased++;
280             balanceOf[ecosystemAddress] = safeAdd(balanceOf[ecosystemAddress], allocAmount);
281             currentSupply += allocAmount;
282             tokensReleasedToEcosystem = safeAdd(tokensReleasedToEcosystem, allocAmount);
283             Transfer(0x0, ecosystemAddress, allocAmount);
284             return true;
285         }
286         revert();
287     }
288     
289        /**
290         @dev Release one  tranche of the teamSupply allocation to Goola team,6.25% every tranche.About 4 years Goola team will get teamSupply Tokens.
291        
292         @return true if successful, throws if not
293     */
294     function releaseForGoolaTeam()   public ownerOnly  returns(bool success) {
295         require(now >= createTime + 12 weeks);
296         require(tokensReleasedToTeam < teamSupply);
297 
298         uint256 temp = teamSupply / 10000;
299         uint256 allocAmount = safeMul(temp, 625);
300         uint256 currentTranche = uint256(now - createTime) / 12 weeks;
301 
302         if(teamTranchesReleased < maxTranches && currentTranche > teamTranchesReleased && (currentSupply + allocAmount) <= totalSupply) {
303             teamTranchesReleased++;
304             balanceOf[goolaTeamAddress] = safeAdd(balanceOf[goolaTeamAddress], allocAmount);
305             currentSupply += allocAmount;
306             tokensReleasedToTeam = safeAdd(tokensReleasedToTeam, allocAmount);
307             Transfer(0x0, goolaTeamAddress, allocAmount);
308             return true;
309         }
310         revert();
311     }
312     
313     function processWhenStop() public  ownerOnly   returns(bool success) {
314         require(currentSupply <=  totalSupply && stopped);
315         balanceOf[backupAddress] += (totalSupply - currentSupply);
316         currentSupply = totalSupply;
317        Transfer(0x0, backupAddress, (totalSupply - currentSupply));
318         return true;
319     }
320     
321 
322 }