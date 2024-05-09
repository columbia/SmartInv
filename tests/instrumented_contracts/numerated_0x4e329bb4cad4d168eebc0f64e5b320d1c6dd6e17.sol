1 pragma solidity ^0.4.18;
2 
3 /// @title SafeMath
4 /// @dev Math operations with safety checks that throw on error
5 library SafeMath {
6     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7         uint256 c = a * b;
8         assert(a == 0 || c / a == b);
9         return c;
10     }
11 
12     function div(uint256 a, uint256 b) internal pure returns (uint256) {
13         uint256 c = a / b;
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 /// @title ERC20 Standard Token interface
30 contract IERC20Token {
31     uint256 public totalSupply;
32     function balanceOf(address _owner) public constant returns (uint256 balance);
33     function transfer(address _to, uint256 _value) public returns (bool success);
34     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
35     function approve(address _spender, uint256 _value) public returns (bool success);
36     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
37 
38     event Transfer(address indexed _from, address indexed _to, uint256 _value);
39     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
40     event Burn(address indexed from, uint256 value);
41 }
42 
43 /// @title ERC20 Standard Token implementation
44 contract ERC20Token is IERC20Token {
45 
46     using SafeMath for uint256;
47 
48     mapping (address => uint256) internal balances;
49     mapping (address => mapping (address => uint256)) internal allowed;
50 
51     modifier validAddress(address _address) {
52         require(_address != 0x0);
53         require(_address != address(this));
54         _;
55     }
56 
57     function _transfer(address _from, address _to, uint _value) internal validAddress(_to) {
58         balances[_from] = balances[_from].sub(_value);
59         balances[_to] = balances[_to].add(_value);
60 
61         Transfer(_from, _to, _value);
62     }
63 
64     function transfer(address _to, uint256 _value) public returns (bool success) {
65         _transfer(msg.sender, _to, _value);
66 
67         return true;
68     }
69 
70     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
71         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
72 
73         _transfer(_from, _to, _value);
74 
75         return true;
76     }
77 
78     function approve(address _spender, uint256 _value) public validAddress(_spender) returns (bool success) {
79         require(_value == 0 || allowed[msg.sender][_spender] == 0);
80 
81         allowed[msg.sender][_spender] = _value;
82 
83         Approval(msg.sender, _spender, _value);
84 
85         return true;
86     }
87 
88     function balanceOf(address _owner) public constant returns (uint256 balance) {
89         return balances[_owner];
90     }
91 
92     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
93         return allowed[_owner][_spender];
94     }
95 }
96 
97 contract Owned {
98 
99     address public owner;
100 
101     function Owned() public {
102         owner = msg.sender;
103     }
104 
105     modifier validAddress(address _address) {
106         require(_address != 0x0);
107         require(_address != address(this));
108         _;
109     }
110 
111     modifier onlyOwner {
112         assert(msg.sender == owner);
113         _;
114     }
115 
116     function transferOwnership(address _newOwner) public validAddress(_newOwner) onlyOwner {
117         require(_newOwner != owner);
118 
119         owner = _newOwner;
120     }
121 }
122 
123 /// @title Genexi contract - crowdfunding code for Genexi Project
124 contract GenexiToken is ERC20Token, Owned {
125 
126     using SafeMath for uint256;
127 
128     string public constant name = "GEN";
129     string public constant symbol = "GEN";
130     uint32 public constant decimals = 18;
131 
132     // SET current initial token supply
133     uint256 public initialSupply = 888888888;
134     // 
135     bool public fundingEnabled = true;
136     // The maximum tokens available for sale
137     uint256 public maxSaleToken;
138     // Total number of tokens sold
139     uint256 public totalSoldTokens;
140     // Total number of tokens for Genexi Project
141     uint256 public totalProjectToken;
142     // Funding wallets, which allowed the transaction during the crowdfunding
143     address[] private wallets;
144     // The flag indicates if the Genexi contract is in enable / disable transfers
145     bool public transfersEnabled = true; 
146 
147     // List wallets to allow transactions tokens
148     uint[256] private nWallets;
149     // Index on the list of wallets to allow reverse lookup
150     mapping(uint => uint) private iWallets;
151 
152     // Date end of lock Project Token 
153     uint256 public endOfLockProjectToken;
154     // Lock token on account Genexi Project 
155     mapping (address => uint256) private lock;
156 
157     event Finalize();
158     event DisableTransfers();
159 
160     /// @notice Genexi Project
161     /// @dev Constructor
162     function GenexiToken() public {
163 
164         initialSupply = initialSupply * 10 ** uint256(decimals);
165 
166         totalSupply = initialSupply;
167         // Initializing 55% of tokens for sale
168         // maxSaleToken = initialSupply * 55 / 100 (55% this is maxSaleToken & 100% this is initialSupply)
169         // totalProjectToken will be calculated in function finalize()
170         // 
171         // |---------maxSaleToken---------totalProjectToken|
172         // |=============55%==========|=========45%========|
173         // |------------------totalSupply------------------|
174         maxSaleToken = totalSupply.mul(55).div(100);
175         // Give all the tokens to a COLD wallet
176         balances[msg.sender] = maxSaleToken;
177         // SET HOT wallets to allow transactions tokens
178         wallets = [
179                 0x34f75A5215bb06fE7F65014252233ed2A876Eb8a, // HOT #1
180                 0x84E1d9DB4Aa98672286FA619b6b102DCfC9EF629, // HOT #2
181                 0x459B06b6b526193fFbEf93700B8fe6AF45b374D5, // HOT #3
182                 0xfb430a30F739Edb98E5FBCcD12DB1088e6fc44a2 // HOT #4
183             ];
184         // Add COLD wallet (owner) to allow transactions tokens
185         nWallets[1] = uint(msg.sender);
186         iWallets[uint(msg.sender)] = 1;
187 
188         for (uint index = 0; index < wallets.length; index++) {
189             nWallets[2 + index] = uint(wallets[index]);
190             iWallets[uint(wallets[index])] = index + 2;
191         }
192     }
193 
194     modifier validAddress(address _address) {
195         require(_address != 0x0);
196         require(_address != address(this));
197         _;
198     }
199 
200     modifier transfersAllowed(address _address) {
201         if (fundingEnabled) {
202             uint index = iWallets[uint(_address)];
203             assert(index > 0);
204         }
205 
206         require(transfersEnabled);
207         _;
208     }
209 
210     function transfer(address _to, uint256 _value) public transfersAllowed(msg.sender) returns (bool success) {
211         return super.transfer(_to, _value);
212     }
213 
214     function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed(_from) returns (bool success) {
215         return super.transferFrom(_from, _to, _value);
216     }
217 
218     function lockOf(address _account) public constant returns (uint256 balance) {
219         return lock[_account];
220     }
221 
222     function _lockProjectToken() private {
223 
224         endOfLockProjectToken = now + 6 * 30 days;
225 
226         // SET distribution of tokens for Genexi
227         // 20% of totalSupply transfer to Company
228         lock[0xa04768C11576F84712e27a76B4700992d6645180] = totalSupply.mul(20).div(100);
229         // 20% of totalSupply transfer to Team
230         lock[0x7D082cE8F5FA1e7D6D39336ECFCd8Ae419ea9777] = totalSupply.mul(20).div(100);
231         // 5% of totalSupply transfer to Advisors
232         lock[0x353DeCDd78a923c4BA2eB455B644a44110BbA65e] = totalSupply.mul(5).div(100);
233     }
234 
235     function unlockProjectToken() external {
236         require(lock[msg.sender] > 0);
237         require(now > endOfLockProjectToken);
238 
239         balances[msg.sender] = balances[msg.sender].add(lock[msg.sender]);
240 
241         lock[msg.sender] = 0;
242 
243         Transfer(0, msg.sender, lock[msg.sender]);
244     }
245 
246     function finalize() external onlyOwner {
247         require(fundingEnabled);
248 
249         uint256 soldTokens = maxSaleToken;
250 
251         for (uint index = 1; index < nWallets.length; index++) {
252             if (balances[address(nWallets[index])] > 0) {
253                 // Get total sold tokens on the funding wallets
254                 // totalSoldTokens is 55% of the total number of tokens
255                 soldTokens = soldTokens.sub(balances[address(nWallets[index])]);
256 
257                 Burn(address(nWallets[index]), balances[address(nWallets[index])]);
258                 // Burning tokens on funding wallet
259                 balances[address(nWallets[index])] = 0;
260             }
261         }
262 
263         totalSoldTokens = soldTokens;
264 
265         // totalProjectToken = totalSoldTokens * 45 / 55 (45% this is Genexi Project & 55% this is totalSoldTokens)
266         //
267         // |-------totalSoldTokens--------totalProjectToken|
268         // |=============55%==========|=========45%========|
269         // |totalSupply=(totalSoldTokens+totalProjectToken)|
270         totalProjectToken = totalSoldTokens.mul(45).div(55);
271 
272         totalSupply = totalSoldTokens.add(totalProjectToken);
273         
274         _lockProjectToken();
275 
276         fundingEnabled = false;
277 
278         Finalize();
279     }
280 
281     function disableTransfers() external onlyOwner {
282         require(transfersEnabled);
283 
284         transfersEnabled = false;
285 
286         DisableTransfers();
287     }
288 }