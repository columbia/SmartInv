1 pragma solidity ^0.5.3;
2 
3 contract Ownable 
4 {
5     address private owner;
6     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8     constructor() public 
9     {
10         owner = msg.sender;
11     }
12 
13     modifier onlyOwner() 
14     {
15         require(msg.sender == owner, "Only owner can call this function.");
16         _;
17     }
18 
19     function isOwner() public view returns(bool) 
20     {
21         return msg.sender == owner;
22     }
23 
24     function transferOwnership(address newOwner) public onlyOwner 
25     {
26         require(newOwner != address(0));
27         emit OwnershipTransferred(owner, newOwner);
28         owner = newOwner;
29     }
30 }
31 
32 contract IERC20
33 {
34     uint256 public tokenTotalSupply;
35     string private tokenName;
36     string private tokenSymbol;
37     
38     function balanceOf(address who) external view returns (uint256);
39     function allowance(address owner, address spender) external view returns (uint256);
40     function transfer(address to, uint256 value) external returns (bool);
41     function approve(address spender, uint256 value) external returns (bool);
42     function transferFrom(address from, address to, uint256 value) external returns (bool);
43 
44     function name() external view returns (string memory);
45     function symbol() external view returns (string memory);
46     function totalSupply() external view returns (uint256);
47 
48     event Transfer(address indexed from, address indexed to, uint256 value);
49     event Approval(address indexed owner, address indexed spender, uint256 value);
50 
51     function burnOwnTokens(uint256 amountToBurn) external;
52     function setCrowdsale(address crowdsaleAddress, uint256 crowdsaleAmount) external;
53 }
54 
55 contract IERC223 is IERC20
56 {
57     function transfer(address to, uint value, bytes memory data) public returns (bool);
58     function transferFrom(address from, address to, uint value, bytes memory data) public returns (bool);
59     event Transfer(address indexed from, address indexed to, uint value, bytes data);
60 }
61 
62 contract IERC223Receiver 
63 { 
64     function tokenFallback(address from, address sender, uint value, bytes memory data) public returns (bool);
65 }
66 
67 contract IMigrationAgent
68 {
69     function finalizeMigration() external;
70     function migrateTokens(address owner, uint256 tokens) public;
71 }
72 
73 contract IMigrationSource
74 {
75     address private migrationAgentAddress;
76     IMigrationAgent private migrationAgentContract;
77     bool private isMigrated;
78 
79     event MigratedFrom(address indexed owner, uint256 tokens);
80 
81     function setMigrationAgent(address agent) external;
82     function migrate() external;
83     function finalizeMigration() external;
84 }
85 
86 library SafeMath 
87 {
88     function mul(uint256 a, uint256 b) internal pure returns (uint256) 
89     {
90         if (a == 0) 
91         {
92             return 0;
93         }
94 
95         uint256 c = a * b;
96         require(c / a == b, "Multiplying error.");
97         return c;
98     }
99 
100     function div(uint256 a, uint256 b) internal pure returns (uint256) 
101     {
102         require(b > 0, "Division error.");
103         uint256 c = a / b;
104         return c;
105     }
106 
107     function sub(uint256 a, uint256 b) internal pure returns (uint256) 
108     {
109         require(b <= a, "Subtraction error.");
110         uint256 c = a - b;
111         return c;
112     }
113 
114     function add(uint256 a, uint256 b) internal pure returns (uint256) 
115     {
116         uint256 c = a + b;
117         require(c >= a, "Adding error.");
118         return c;
119     }
120 
121     function mod(uint256 a, uint256 b) internal pure returns (uint256) 
122     {
123         require(b != 0, "Mod error.");
124         return a % b;
125     }
126 }
127 
128 contract EggToken is IERC223, Ownable, IMigrationSource
129 {
130     using SafeMath for uint256;
131 
132     uint256 private tokenTotalSupply;
133     string private tokenName;
134     string private tokenSymbol;
135     uint8 private tokenDecimals;
136 
137     mapping (address => uint256) private balances;
138     mapping (address => mapping (address => uint256)) private allowances;
139 
140     address private migrationAgentAddress;
141     IMigrationAgent private migrationAgentContract;
142     bool private isMigrated;
143     bool private isCrowdsaleSet;
144     
145     address private owner;
146     
147     constructor(string memory name, 
148                 string memory symbol, 
149                 uint256 totalSupply, 
150                 address developmentTeamAddress, 
151                 uint256 developmentTeamBalance, 
152                 address marketingTeamAddress, 
153                 uint256 marketingTeamBalance, 
154                 address productTeamAddress, 
155                 uint256 productTeamBalance, 
156                 address airdropAddress,
157                 uint256 airdropBalance) public 
158     {
159         tokenName = name;
160         tokenSymbol = symbol;
161         tokenDecimals = 18;
162 
163         tokenTotalSupply = totalSupply;
164         
165         balances[developmentTeamAddress] = developmentTeamBalance;
166         balances[marketingTeamAddress] = marketingTeamBalance;
167         balances[productTeamAddress] = productTeamBalance;
168         balances[airdropAddress] = airdropBalance;
169     }
170 
171     function setCrowdsale(address crowdsaleAddress, uint256 crowdsaleBalance) onlyOwner validAddress(crowdsaleAddress) external
172     {
173         require(!isCrowdsaleSet, "Crowdsale address was already set.");
174         isCrowdsaleSet = true;
175         tokenTotalSupply = tokenTotalSupply.add(crowdsaleBalance);
176         balances[crowdsaleAddress] = crowdsaleBalance;
177     }
178     
179     function approve(address spender, uint256 value) validAddress(spender) external returns (bool) 
180     {
181         allowances[msg.sender][spender] = value;
182         emit Approval(msg.sender, spender, value);
183         return true;
184     }
185     
186     function transfer(address to, uint256 value) external returns (bool) 
187     {
188         return transfer(to, value, new bytes(0));
189     }
190     
191     function transferFrom(address from, address to, uint256 value) external returns (bool)
192     {
193         return transferFrom(from, to, value, new bytes(0));
194     }
195     
196     function transferBatch(address[] calldata to, uint256 value) external returns (bool) 
197     {
198         return transferBatch(to, value, new bytes(0));
199     }
200 
201     function transfer(address to, uint256 value, bytes memory data) validAddress(to) enoughBalance(msg.sender, value) public returns (bool)
202     {
203         balances[msg.sender] = balances[msg.sender].sub(value);
204         balances[to] = balances[to].add(value);
205         if (isContract(to))
206         {
207             contractFallback(msg.sender, to, value, data);
208         }
209         emit Transfer(msg.sender, to, value, data);
210         return true;
211     }
212 
213     function transferFrom(address from, address to, uint256 value, bytes memory data) validAddress(to) enoughBalance(from, value) public returns (bool)
214     {
215         require(value <= allowances[from][msg.sender], "Transfer value exceeds the allowance.");
216 
217         balances[from] = balances[from].sub(value);
218         balances[to] = balances[to].add(value);
219         allowances[from][msg.sender] = allowances[from][msg.sender].sub(value);
220         if (isContract(to))
221         {
222             contractFallback(from, to, value, data);
223         }
224         emit Transfer(from, to, value, data);
225         return true;
226     }
227 
228     function transferBatch(address[] memory to, uint256 value, bytes memory data) public returns (bool)
229     {
230         uint256 totalValue = value.mul(to.length);
231         checkBalance(msg.sender, totalValue);
232         balances[msg.sender] = balances[msg.sender].sub(totalValue);
233 
234         uint256 i = 0;
235         while (i < to.length) 
236         {
237             checkAddressValidity(to[i]);
238             balances[to[i]] = balances[to[i]].add(value);
239             if (isContract(to[i]))
240             {
241                 contractFallback(msg.sender, to[i], value, data);
242             }
243             emit Transfer(msg.sender, to[i], value, data);
244             i++;
245         }
246 
247         return true;
248     }
249 
250     function contractFallback(address sender, address to, uint256 value, bytes memory data) private returns (bool) 
251     {
252         IERC223Receiver reciever = IERC223Receiver(to);
253         return reciever.tokenFallback(msg.sender, sender, value, data);
254     }
255 
256     function isContract(address to) internal view returns (bool) 
257     {
258         uint length;
259         assembly { length := extcodesize(to) }
260         return length > 0;
261     }
262     
263     function increaseAllowance(address spender, uint256 addedValue) validAddress(spender) external returns (bool)
264     {
265         allowances[msg.sender][spender] = allowances[msg.sender][spender].add(addedValue);
266         emit Approval(msg.sender, spender, allowances[msg.sender][spender]);
267         return true;
268     }
269     
270     function decreaseAllowance(address spender, uint256 subtractedValue) validAddress(spender) external returns (bool)
271     {
272         allowances[msg.sender][spender] = allowances[msg.sender][spender].sub(subtractedValue);
273         emit Approval(msg.sender, spender, allowances[msg.sender][spender]);
274         return true;
275     }
276 
277     function burnOwnTokens(uint256 amountToBurn) enoughBalance(msg.sender, amountToBurn) external 
278     {
279         require(balances[msg.sender] >= amountToBurn, "Can't burn more tokens than you own.");
280         tokenTotalSupply = tokenTotalSupply.sub(amountToBurn);
281         balances[msg.sender] = balances[msg.sender].sub(amountToBurn);
282         emit Transfer(msg.sender, address(0), amountToBurn, new bytes(0));
283     }
284 
285     function transferAnyERC20Token(address tokenAddress, uint256 tokens) public onlyOwner returns (bool success) 
286     {
287         return IERC20(tokenAddress).transfer(owner, tokens);
288     }
289 
290     function balanceOf(address balanceOwner) external view returns (uint256) 
291     {
292         return balances[balanceOwner];
293     }
294     
295     function allowance(address balanceOwner, address spender) external view returns (uint256)
296     {
297         return allowances[balanceOwner][spender];
298     }
299 
300     function name() external view returns(string memory) {
301         return tokenName;
302     }
303 
304     function symbol() external view returns(string memory) {
305         return tokenSymbol;
306     }
307 
308     function decimals() external view returns(uint8) {
309         return tokenDecimals;
310     }
311 
312     function totalSupply() external view returns (uint256) 
313     {
314         return tokenTotalSupply;
315     }
316 
317     modifier validAddress(address _address) 
318     {
319         checkAddressValidity(_address);
320         _;
321     }
322 
323     modifier enoughBalance(address from, uint256 value) 
324     {
325         checkBalance(from, value);
326         _;
327     }
328 
329     function checkAddressValidity(address _address) internal view
330     {
331         require(_address != address(0), "The address can't be blank.");
332         require(_address != address(this), "The address can't point to Egg smart contract.");
333     }
334 
335     function checkBalance(address from, uint256 value) internal view
336     {
337         require(value <= balances[from], "Specified address has less tokens than required for this operation.");
338     }
339     
340     function setMigrationAgent(address agent) onlyOwner validAddress(agent) external
341     {
342         require(migrationAgentAddress == address(0), "Migration Agent was specified already.");
343         require(!isMigrated, 'Contract was already migrated.');
344         migrationAgentAddress = agent;
345         migrationAgentContract = IMigrationAgent(agent);
346     }
347 
348     function migrate() external
349     {
350         require(migrationAgentAddress != address(0), "Migration is closed or haven't started.");
351 
352         uint256 migratedAmount = balances[msg.sender];
353         require(migratedAmount > 0, "No tokens to migrate.");
354 
355         balances[msg.sender] = 0;
356         emit MigratedFrom(msg.sender, migratedAmount);
357         migrationAgentContract.migrateTokens(msg.sender, migratedAmount);
358     }
359 
360     function finalizeMigration() external
361     {
362         require(msg.sender == migrationAgentAddress, "Only Migration Agent can finalize the migration.");
363         migrationAgentAddress = address(0);
364         isMigrated = true;
365     }
366 }