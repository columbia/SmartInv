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
88     mapping (address => uint256) public revenueShareList;
89     mapping (address => string) public revenueShareCurrency;
90     mapping (address => uint256) public revenueShareDistribution;
91 
92     uint256 public decimalMultiplier = 1000000000000000000;
93     uint256 public icoSold = 9359820;
94     address public revenueShareOwnerAddress;
95     address public icoWalletAddress = 0xbf7aa06109ce182203ee3805614736fe18dead43;
96     address public teamWalletAddress = 0x552b3f0c1747cfefc726bc669bd4fde2d20f9cf2;
97     address public affiliateProgramWalletAddress = 0xd30e8e92ee0cc95a7fefb5eafdd0deb678ab41d7;
98     address public shareholdersWalletAddress = 0x56a8330345e75bafbb17443889e19302ba528e7c;
99 
100     /**
101         @dev constructor
102     */
103     function COSSToken() {
104         revenueShareOwnerAddress = msg.sender;
105         balanceOf[icoWalletAddress] = safeMul(icoSold,decimalMultiplier);
106         balanceOf[teamWalletAddress] = safeMul(30000000,decimalMultiplier);
107         balanceOf[affiliateProgramWalletAddress] = safeMul(10000000,decimalMultiplier);
108         balanceOf[shareholdersWalletAddress] = safeMul(5000000,decimalMultiplier);
109     }
110 
111     // validates an address - currently only checks that it isn't null
112     modifier validAddress(address _address) {
113         require(_address != 0x0);
114         _;
115     }
116 
117     function activateRevenueShareReference(uint256 _revenueShareItem) {
118         revenueShareList[msg.sender] = _revenueShareItem;
119     }
120 
121     function addRevenueShareCurrency(address _currencyAddress,string _currencyName) {
122         if (msg.sender == revenueShareOwnerAddress) {
123             revenueShareCurrency[_currencyAddress] = _currencyName;
124             revenueShareDistribution[_currencyAddress] = 0;
125         }
126     }
127 
128     function saveRevenueShareDistribution(address _currencyAddress, uint256 _value) {
129         if (msg.sender == revenueShareOwnerAddress) {
130             revenueShareDistribution[_currencyAddress] = safeAdd(revenueShareDistribution[_currencyAddress], _value);
131         }
132     }
133 
134     /**
135         @dev send coins
136         throws on any error rather then return a false flag to minimize user errors
137 
138         @param _to      target address
139         @param _value   transfer amount
140 
141         @return true if the transfer was successful, false if it wasn't
142     */
143     function transfer(address _to, uint256 _value)
144         public
145         validAddress(_to)
146         returns (bool success)
147     {
148         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
149         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
150         Transfer(msg.sender, _to, _value);
151         return true;
152     }
153 
154     /**
155         @dev an account/contract attempts to get the coins
156         throws on any error rather then return a false flag to minimize user errors
157 
158         @param _from    source address
159         @param _to      target address
160         @param _value   transfer amount
161 
162         @return true if the transfer was successful, false if it wasn't
163     */
164     function transferFrom(address _from, address _to, uint256 _value)
165         public
166         validAddress(_from)
167         validAddress(_to)
168         returns (bool success)
169     {
170         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
171         balanceOf[_from] = safeSub(balanceOf[_from], _value);
172         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
173         Transfer(_from, _to, _value);
174         return true;
175     }
176 
177     /**
178         @dev allow another account/contract to spend some tokens on your behalf
179         throws on any error rather then return a false flag to minimize user errors
180 
181         also, to minimize the risk of the approve/transferFrom attack vector
182         (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice
183         in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value
184 
185         @param _spender approved address
186         @param _value   allowance amount
187 
188         @return true if the approval was successful, false if it wasn't
189     */
190     function approve(address _spender, uint256 _value)
191         public
192         validAddress(_spender)
193         returns (bool success)
194     {
195         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
196         require(_value == 0 || allowance[msg.sender][_spender] == 0);
197 
198         allowance[msg.sender][_spender] = _value;
199         Approval(msg.sender, _spender, _value);
200         return true;
201     }
202 }