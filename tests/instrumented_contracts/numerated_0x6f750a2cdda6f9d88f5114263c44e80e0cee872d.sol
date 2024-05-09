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
76     string public standard = 'COSS_DEMO';
77     string public name = 'COSS_DEMO';
78     string public symbol = 'COSS_DEMO';
79     uint8 public decimals = 18;
80     uint256 public totalSupply = 200000;
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
92     address public revenueShareOwnerAddress;
93 
94     /**
95         @dev constructor
96     */
97     function COSSToken() {
98         balanceOf[msg.sender] = totalSupply * decimals;
99         revenueShareOwnerAddress = msg.sender;
100     }
101 
102     // validates an address - currently only checks that it isn't null
103     modifier validAddress(address _address) {
104         require(_address != 0x0);
105         _;
106     }
107 
108     function activateRevenueShareReference(uint256 _revenueShareItem) {
109         revenueShareList[msg.sender] = _revenueShareItem;
110     }
111 
112     function addRevenueShareCurrency(address _currencyAddress,string _currencyName) {
113         if (msg.sender == revenueShareOwnerAddress) {
114             revenueShareCurrency[_currencyAddress] = _currencyName;
115             revenueShareDistribution[_currencyAddress] = 0;
116         }
117     }
118 
119     function saveRevenueShareDistribution(address _currencyAddress, uint256 _value) {
120         if (msg.sender == revenueShareOwnerAddress) {
121             revenueShareDistribution[_currencyAddress] = safeAdd(revenueShareDistribution[_currencyAddress], _value);
122         }
123     }
124 
125     /**
126         @dev send coins
127         throws on any error rather then return a false flag to minimize user errors
128 
129         @param _to      target address
130         @param _value   transfer amount
131 
132         @return true if the transfer was successful, false if it wasn't
133     */
134     function transfer(address _to, uint256 _value)
135         public
136         validAddress(_to)
137         returns (bool success)
138     {
139         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
140         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
141         Transfer(msg.sender, _to, _value);
142         return true;
143     }
144 
145     /**
146         @dev an account/contract attempts to get the coins
147         throws on any error rather then return a false flag to minimize user errors
148 
149         @param _from    source address
150         @param _to      target address
151         @param _value   transfer amount
152 
153         @return true if the transfer was successful, false if it wasn't
154     */
155     function transferFrom(address _from, address _to, uint256 _value)
156         public
157         validAddress(_from)
158         validAddress(_to)
159         returns (bool success)
160     {
161         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
162         balanceOf[_from] = safeSub(balanceOf[_from], _value);
163         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
164         Transfer(_from, _to, _value);
165         return true;
166     }
167 
168     /**
169         @dev allow another account/contract to spend some tokens on your behalf
170         throws on any error rather then return a false flag to minimize user errors
171 
172         also, to minimize the risk of the approve/transferFrom attack vector
173         (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice
174         in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value
175 
176         @param _spender approved address
177         @param _value   allowance amount
178 
179         @return true if the approval was successful, false if it wasn't
180     */
181     function approve(address _spender, uint256 _value)
182         public
183         validAddress(_spender)
184         returns (bool success)
185     {
186         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
187         require(_value == 0 || allowance[msg.sender][_spender] == 0);
188 
189         allowance[msg.sender][_spender] = _value;
190         Approval(msg.sender, _spender, _value);
191         return true;
192     }
193 }