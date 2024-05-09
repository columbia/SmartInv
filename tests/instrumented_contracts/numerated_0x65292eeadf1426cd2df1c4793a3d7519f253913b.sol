1 pragma solidity ^0.4.16;
2 
3 /*
4     Overflow protected math functions
5 */
6 contract SafeMath {
7     /**
8         constructor
9     */
10     function SafeMath() {
11     }
12 
13     /**
14         @dev returns the sum of _x and _y, asserts if the calculation overflows
15 
16         @param _x   value 1
17         @param _y   value 2
18 
19         @return sum
20     */
21     function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {
22         uint256 z = _x + _y;
23         assert(z >= _x);
24         return z;
25     }
26 
27     /**
28         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
29 
30         @param _x   minuend
31         @param _y   subtrahend
32 
33         @return difference
34     */
35     function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {
36         assert(_x >= _y);
37         return _x - _y;
38     }
39 
40     /**
41         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
42 
43         @param _x   factor 1
44         @param _y   factor 2
45 
46         @return product
47     */
48     function safeMul(uint256 _x, uint256 _y) internal returns (uint256) {
49         uint256 z = _x * _y;
50         assert(_x == 0 || z / _x == _y);
51         return z;
52     }
53 }
54 
55 /*
56     ERC20 Standard Token interface
57 */
58 contract IERC20Token {
59     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
60     function name() public constant returns (string name) { name; }
61     function symbol() public constant returns (string symbol) { symbol; }
62     function decimals() public constant returns (uint8 decimals) { decimals; }
63     function totalSupply() public constant returns (uint256 totalSupply) { totalSupply; }
64     function balanceOf(address _owner) public constant returns (uint256 balance) { _owner; balance; }
65     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { _owner; _spender; remaining; }
66 
67     function transfer(address _to, uint256 _value) public returns (bool success);
68     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
69     function approve(address _spender, uint256 _value) public returns (bool success);
70 }
71 
72 /**
73     COSS Token implementation
74 */
75 contract COSSToken is IERC20Token, SafeMath {
76     string public standard = 'COSS';
77     string public name = 'COSS';
78     string public symbol = 'COSS';
79     uint8 public decimals = 18;
80     uint256 public totalSupply = 54359820;
81     mapping (address => uint256) public balanceOf;
82     mapping (address => mapping (address => uint256)) public allowance;
83 
84 
85     event Transfer(address indexed _from, address indexed _to, uint256 _value);
86     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
87 
88     mapping (address => string) public revenueShareIdentifierList;
89     mapping (address => string) public revenueShareCurrency;
90     mapping (address => uint256) public revenueShareDistribution;
91 
92     uint256 public decimalMultiplier = 1000000000000000000;
93     address public revenueShareOwnerAddress;
94     address public icoWalletAddress = 0x0d6b5a54f940bf3d52e438cab785981aaefdf40c;
95     address public futureFundingWalletAddress = 0x1e1f9b4dae157282b6be74d0e9d48cd8298ed1a8;
96     address public charityWalletAddress = 0x7dbb1f2114d1bedca41f32bb43df938bcfb13e5c;
97     address public capWalletAddress = 0x49a72a02c7f1e36523b74259178eadd5c3c27173;
98     address public shareholdersWalletAddress = 0xda3705a572ceb85e05b29a0dc89082f1d8ab717d;
99     address public investorWalletAddress = 0xa08e7f6028e7d2d83a156d7da5db6ce0615493b9;
100 
101     /**
102         @dev constructor
103     */
104     function COSSToken() {
105         revenueShareOwnerAddress = msg.sender;
106         balanceOf[icoWalletAddress] = safeMul(80000000,decimalMultiplier);
107         balanceOf[futureFundingWalletAddress] = safeMul(50000000,decimalMultiplier);
108         balanceOf[charityWalletAddress] = safeMul(10000000,decimalMultiplier);
109         balanceOf[capWalletAddress] = safeMul(20000000,decimalMultiplier);
110         balanceOf[shareholdersWalletAddress] = safeMul(30000000,decimalMultiplier);
111         balanceOf[investorWalletAddress] = safeMul(10000000,decimalMultiplier);
112     }
113 
114     // validates an address - currently only checks that it isn't null
115     modifier validAddress(address _address) {
116         require(_address != 0x0);
117         _;
118     }
119 
120     function activateRevenueShareIdentifier(string _revenueShareIdentifier) {
121         revenueShareIdentifierList[msg.sender] = _revenueShareIdentifier;
122     }
123 
124     function addRevenueShareCurrency(address _currencyAddress,string _currencyName) {
125         if (msg.sender == revenueShareOwnerAddress) {
126             revenueShareCurrency[_currencyAddress] = _currencyName;
127             revenueShareDistribution[_currencyAddress] = 0;
128         }
129     }
130 
131     function saveRevenueShareDistribution(address _currencyAddress, uint256 _value) {
132         if (msg.sender == revenueShareOwnerAddress) {
133             revenueShareDistribution[_currencyAddress] = safeAdd(revenueShareDistribution[_currencyAddress], _value);
134         }
135     }
136 
137     /**
138         @dev send tokens
139         throws on any error rather then return a false flag to minimize user errors
140 
141         @param _to      target address
142         @param _value   transfer amount
143 
144         @return true if the transfer was successful, false if it wasn't
145     */
146     function transfer(address _to, uint256 _value)
147         public
148         validAddress(_to)
149         returns (bool success)
150     {
151         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
152         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
153         Transfer(msg.sender, _to, _value);
154         return true;
155     }
156 
157     /**
158         @dev an account/contract attempts to get the coins
159         throws on any error rather then return a false flag to minimize user errors
160 
161         @param _from    source address
162         @param _to      target address
163         @param _value   transfer amount
164 
165         @return true if the transfer was successful, false if it wasn't
166     */
167     function transferFrom(address _from, address _to, uint256 _value)
168         public
169         validAddress(_from)
170         validAddress(_to)
171         returns (bool success)
172     {
173         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
174         balanceOf[_from] = safeSub(balanceOf[_from], _value);
175         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
176         Transfer(_from, _to, _value);
177         return true;
178     }
179 
180     /**
181         @dev allow another account/contract to spend some tokens on your behalf
182         throws on any error rather then return a false flag to minimize user errors
183 
184         also, to minimize the risk of the approve/transferFrom attack vector
185         (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice
186         in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value
187 
188         @param _spender approved address
189         @param _value   allowance amount
190 
191         @return true if the approval was successful, false if it wasn't
192     */
193     function approve(address _spender, uint256 _value)
194         public
195         validAddress(_spender)
196         returns (bool success)
197     {
198         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
199         require(_value == 0 || allowance[msg.sender][_spender] == 0);
200 
201         allowance[msg.sender][_spender] = _value;
202         Approval(msg.sender, _spender, _value);
203         return true;
204     }
205 }