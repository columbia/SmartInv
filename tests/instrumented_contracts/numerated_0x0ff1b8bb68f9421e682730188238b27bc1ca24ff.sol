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
32 
33     function balanceOf(address _owner) public constant returns (uint256 balance);
34 
35     function transfer(address _to, uint256 _value) public returns (bool success);
36     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
37 
38     function approve(address _spender, uint256 _value) public returns (bool success);
39 
40     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
41 
42     event Transfer(address indexed _from, address indexed _to, uint256 _value);
43     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
44     event Burn(address indexed from, uint256 value);
45 }
46 
47 /// @title ERC20 Standard Token implementation
48 contract ERC20Token is IERC20Token {
49 
50     using SafeMath for uint256;
51 
52     mapping (address => uint256) public balances;
53     mapping (address => mapping (address => uint256)) public allowed;
54 
55     modifier validAddress(address _address) {
56         require(_address != 0x0);
57         require(_address != address(this));
58         _;
59     }
60 
61     function _transfer(address _from, address _to, uint _value) internal validAddress(_to) {
62         balances[_from] = balances[_from].sub(_value);
63         balances[_to] = balances[_to].add(_value);
64 
65         Transfer(_from, _to, _value);
66     }
67 
68     function transfer(address _to, uint256 _value) public returns (bool success) {
69         _transfer(msg.sender, _to, _value);
70 
71         return true;
72     }
73 
74     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
75         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
76 
77         _transfer(_from, _to, _value);
78 
79         return true;
80     }
81 
82     function approve(address _spender, uint256 _value) public validAddress(_spender) returns (bool success) {
83         require(_value == 0 || allowed[msg.sender][_spender] == 0);
84 
85         allowed[msg.sender][_spender] = _value;
86 
87         Approval(msg.sender, _spender, _value);
88 
89         return true;
90     }
91 
92     function balanceOf(address _owner) public constant returns (uint256 balance) {
93         return balances[_owner];
94     }
95 
96     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
97         return allowed[_owner][_spender];
98     }
99 }
100 
101 contract Owned {
102 
103     address public owner;
104 
105     function Owned() public {
106         owner = msg.sender;
107     }
108 
109     modifier validAddress(address _address) {
110         require(_address != 0x0);
111         require(_address != address(this));
112         _;
113     }
114 
115     modifier onlyOwner {
116         assert(msg.sender == owner);
117         _;
118     }
119 
120     function transferOwnership(address _newOwner) public validAddress(_newOwner) onlyOwner {
121         require(_newOwner != owner);
122 
123         owner = _newOwner;
124     }
125 }
126 
127 /// @title Vimarket contract - crowdfunding code for Vimarket Project
128 contract ViToken is ERC20Token, Owned {
129 
130     using SafeMath for uint256;
131 
132     string public constant name = "ViToken";
133     string public constant symbol = "VIT";
134     uint32 public constant decimals = 18;
135 
136     // SET current initial token supply
137     uint256 public initialSupply = 250000000;
138     // 
139     bool public fundingEnabled = true;
140     // The maximum tokens available for sale
141     uint256 public maxSaleToken;
142     // Total number of tokens sold
143     uint256 public totalSoldTokens;
144     // Total number of tokens for Vimarket Project
145     uint256 public totalProjectToken;
146     // Funding wallets, which allowed the transaction during the crowdfunding
147     address[] public wallets;
148     // The flag indicates if the Vimarket contract is in enable / disable transfers
149     bool public transfersEnabled = true; 
150 
151     // List wallets to allow transactions tokens
152     uint[256] private nWallets;
153     // Index on the list of wallets to allow reverse lookup
154     mapping(uint => uint) private iWallets;
155 
156     event Finalize();
157     event DisableTransfers();
158 
159     /// @notice Vimarket Project
160     /// @dev Constructor
161     function ViToken() public {
162 
163         initialSupply = initialSupply * 10 ** uint256(decimals);
164 
165         totalSupply = initialSupply;
166         // Initializing 72% of tokens for sale
167         // maxSaleToken = initialSupply * 72 / 100 (72% this is maxSaleToken & 100% this is initialSupply)
168         // totalProjectToken will be calculated in function finalize()
169         // 
170         // |------------maxSaleToken------totalProjectToken|
171         // |================72%================|====28%====|
172         // |------------------totalSupply------------------|
173         maxSaleToken = totalSupply.mul(72).div(100);
174         // Give all the tokens to a COLD wallet
175         balances[msg.sender] = maxSaleToken;
176         // SET HOT wallets to allow transactions tokens
177         wallets = [
178                 0x787C3C7F5Cb7F4cAc0aAD6414F96de1A2ED994B0, // HOT #1
179                 0xa6400BE140da2260db44a12b6c990BD02f08658a, // HOT #2
180                 0xD697B23E5bD7dd817c2EE9DBF7C5cC7dc5354763, // HOT #3
181                 0xA8500dADA9fA278B2F70D09FB8712C5983eD01bD, // HOT #4
182                 0xd6e4CC2e33a0842c5070514C664E366561C23B48  // HOT #5
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
214     function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed(_from) returns (bool) {
215         return super.transferFrom(_from, _to, _value);
216     }
217 
218     function _transferProject(address _to, uint256 _value) private {
219         balances[_to] = balances[_to].add(_value);
220 
221         Transfer(this, _to, _value);
222     }
223 
224     function finalize() external onlyOwner {
225         require(fundingEnabled);
226 
227         uint256 soldTokens = maxSaleToken;
228 
229         for (uint index = 1; index < nWallets.length; index++) {
230             if (balances[address(nWallets[index])] > 0) {
231                 // Get total sold tokens on the funding wallets
232                 // totalSoldTokens is 72% of the total number of tokens
233                 soldTokens = soldTokens.sub(balances[address(nWallets[index])]);
234 
235                 Burn(address(nWallets[index]), balances[address(nWallets[index])]);
236                 // Burning tokens on funding wallet
237                 balances[address(nWallets[index])] = 0;
238             }
239         }
240 
241         totalSoldTokens = soldTokens;
242 
243         // totalProjectToken = totalSoldTokens * 28 / 72 (28% this is Vimarket Project & 72% this is totalSoldTokens)
244         //
245         // |----------totalSoldTokens-----totalProjectToken|
246         // |================72%================|====28%====|
247         // |totalSupply=(totalSoldTokens+totalProjectToken)|
248         totalProjectToken = totalSoldTokens.mul(28).div(72);
249 
250         totalSupply = totalSoldTokens.add(totalProjectToken);
251         // SET distribution of tokens for Vimarket
252         // 16% of totalSupply transfer to Team
253         _transferProject(0xf1f815589e7B1Ba6cBfF04DCc1C2b898ECFfE4cb, totalSupply.mul(16).div(100));
254         // 10% of totalSupply transfer to Advisors
255         _transferProject(0x1c3a5aB190AF3f25aBfd797FDe49A3dB6f209B88, totalSupply.mul(10).div(100));
256         // 2% of totalSupply transfer to Bounties & Rewards
257         _transferProject(0xe098854748CBC70f151fa555399365A42e360269, totalSupply.mul(2).div(100));
258 
259         fundingEnabled = false;
260 
261         Finalize();
262     }
263 
264     function disableTransfers() external onlyOwner {
265         require(transfersEnabled);
266 
267         transfersEnabled = false;
268 
269         DisableTransfers();
270     }
271 }