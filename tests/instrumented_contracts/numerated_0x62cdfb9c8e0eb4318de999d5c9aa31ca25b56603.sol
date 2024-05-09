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
127 /// @title BC2B contract - crowdfunding code for BC2B Project
128 contract BC2BToken is ERC20Token, Owned {
129 
130     using SafeMath for uint256;
131 
132     string public constant name = "BC2B";
133     string public constant symbol = "BC2B";
134     uint32 public constant decimals = 18;
135 
136     // SET current initial token supply
137     uint256 public initialSupply = 10000000;
138     // 
139     bool public fundingEnabled = true;
140     // The maximum tokens available for sale
141     uint256 public maxSaleToken;
142     // Total number of tokens sold
143     uint256 public totalSoldTokens;
144     // Total number of tokens for BC2B Project
145     uint256 public totalProjectToken;
146     // Funding wallets, which allowed the transaction during the crowdfunding
147     address[] public wallets;
148     // The flag indicates if the BC2B contract is in enable / disable transfers
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
159     /// @notice BC2B Project
160     /// @dev Constructor
161     function BC2BToken() public {
162 
163         initialSupply = initialSupply * 10 ** uint256(decimals);
164 
165         totalSupply = initialSupply;
166         // Initializing 60% of tokens for sale
167         // maxSaleToken = initialSupply * 60 / 100 (60% this is maxSaleToken & 100% this is initialSupply)
168         // totalProjectToken will be calculated in function finalize()
169         // 
170         // |------------maxSaleToken------totalProjectToken|
171         // |================60%================|====40%====|
172         // |------------------totalSupply------------------|
173         maxSaleToken = totalSupply.mul(60).div(100);
174         // Give all the tokens to a COLD wallet
175         balances[msg.sender] = maxSaleToken;
176         // SET HOT wallets
177         wallets = [
178                 0xbED1c18C16868D7C34CEE770e10ae3175b4809Ce,
179                 0x6F8E76fd90153D4a73491044972a4edE1e216a26,
180                 0xB75D0fa5C82956CBA2724344B74261DC6dc74CDa
181             ];
182         // Add COLD wallet (owner)
183         nWallets[1] = uint(msg.sender);
184         iWallets[uint(msg.sender)] = 1;
185 
186         for (uint index = 0; index < wallets.length; index++) {
187             nWallets[2 + index] = uint(wallets[index]);
188             iWallets[uint(wallets[index])] = index + 2;
189         }
190     }
191 
192     modifier validAddress(address _address) {
193         require(_address != 0x0);
194         require(_address != address(this));
195         _;
196     }
197 
198     modifier transfersAllowed() {
199         require(transfersEnabled);
200         _;
201     }
202 
203     function transfer(address _to, uint256 _value) public transfersAllowed() returns (bool success) {
204         return super.transfer(_to, _value);
205     }
206 
207     function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed() returns (bool) {
208         return super.transferFrom(_from, _to, _value);
209     }
210 
211     function _transferProject(address _to, uint256 _value) private {
212         balances[_to] = balances[_to].add(_value);
213 
214         Transfer(this, _to, _value);
215     }
216 
217     function finalize() external onlyOwner {
218         require(fundingEnabled);
219 
220         uint256 soldTokens = maxSaleToken;
221 
222         for (uint index = 1; index < nWallets.length; index++) {
223             if (balances[address(nWallets[index])] > 0) {
224                 // Get total sold tokens on the funding wallets
225                 // totalSoldTokens is 60% of the total number of tokens
226                 soldTokens = soldTokens.sub(balances[address(nWallets[index])]);
227 
228                 Burn(address(nWallets[index]), balances[address(nWallets[index])]);
229                 // Burning tokens on funding wallet
230                 balances[address(nWallets[index])] = 0;
231             }
232         }
233 
234         totalSoldTokens = soldTokens;
235 
236         // totalProjectToken = totalSoldTokens * 40 / 60 (40% this is BC2B Project & 60% this is totalSoldTokens)
237         //
238         // |----------totalSoldTokens-----totalProjectToken|
239         // |================60%================|====40%====|
240         // |totalSupply=(totalSoldTokens+totalProjectToken)|
241         totalProjectToken = totalSoldTokens.mul(40).div(60);
242 
243         totalSupply = totalSoldTokens.add(totalProjectToken);
244         // SET 40% of totalSupply tokens for BC2B
245         _transferProject(0xB09Df01b913eb1975e16b408eDe9Ecb8360A1627, totalSupply.mul(40).div(100));
246 
247         fundingEnabled = false;
248 
249         Finalize();
250     }
251 
252     function disableTransfers() external onlyOwner {
253         require(transfersEnabled);
254 
255         transfersEnabled = false;
256 
257         DisableTransfers();
258     }
259 }