1 pragma solidity ^0.5.16;
2 
3 /**
4  * Math operations with safety checks
5  */
6 library SafeMath {
7 
8     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a + b;
10         require(c >= a, "SafeMath: addition overflow");
11 
12         return c;
13     }
14 
15     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
16         require(b <= a, "SafeMath: subtraction overflow");
17         uint256 c = a - b;
18 
19         return c;
20     }
21 
22     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
23         if (a == 0) {
24             return 0;
25         }
26 
27         uint256 c = a * b;
28         require(c / a == b, "SafeMath: multiplication overflow");
29 
30         return c;
31     }
32 
33     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
34         require(b > 0, "SafeMath: division by zero");
35         uint256 c = a / b;
36 
37         return c;
38     }
39 
40     function safeMod(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b != 0, "SafeMath: modulo by zero");
42         return a % b;
43     }
44 }
45 
46 /**
47  * cUSD Contract
48  */
49 contract cUSD {
50     using SafeMath for uint256;
51     string public name;
52     string public symbol;
53     uint8 public decimals;
54     uint256 public totalSupply;
55     address public owner;
56 
57     mapping (address => uint256) public balanceOf;
58     mapping (address => mapping (address => uint256)) public allowance;
59 
60     event Transfer(address indexed from, address indexed to, uint256 value);
61     event Approval(address indexed owner, address indexed spender, uint256 value);
62     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63     event Mint(address indexed to, uint256 amount);
64     event MintingFinished();
65     event Burn(uint256 amount);
66 
67     constructor(
68         uint256 initialSupply,
69         string memory tokenName,
70         uint8 decimalUnits,
71         string memory tokenSymbol
72         ) public {
73             balanceOf[msg.sender] = initialSupply;
74             totalSupply = initialSupply;
75             name = tokenName;
76             symbol = tokenSymbol;
77             decimals = decimalUnits;
78             owner = msg.sender;
79         }
80 
81     /**
82      * Transfer functions
83      */
84     function transfer(address _to, uint256 _value) public {
85         require(_to != address(this));
86         require(_to != address(0), "Cannot use zero address");
87         require(_value > 0, "Cannot use zero value");
88 
89         require (balanceOf[msg.sender] >= _value, "Balance not enough");         // Check if the sender has enough
90         require (balanceOf[_to] + _value >= balanceOf[_to], "Overflow" );        // Check for overflows
91         
92         uint previousBalances = balanceOf[msg.sender] + balanceOf[_to];          
93         
94         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value); // Subtract from the sender
95         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);               // Add the same to the recipient
96         
97         emit Transfer(msg.sender, _to, _value);                                  // Notify anyone listening that this transfer took place
98         
99         assert(balanceOf[msg.sender] + balanceOf[_to] == previousBalances);
100     }
101 
102     function approve(address _spender, uint256 _value) public returns (bool success) {
103         require (_value > 0, "Cannot use zero");
104         
105         allowance[msg.sender][_spender] = _value;
106         
107         emit Approval(msg.sender, _spender, _value);
108         
109         return true;
110     }
111 
112     function multiTransfer(address[] memory _receivers, uint256[] memory _values) public returns (bool success) {
113         require(_receivers.length <= 200, "Too many recipients");
114 
115         for(uint256 i = 0; i < _receivers.length; i++) {
116             transfer(_receivers[i], _values[i]);
117         }
118 
119         return true;
120     }
121 
122     function multiTransferSingleValue(address[] memory _receivers, uint256 _value) public returns (bool success) {
123         uint256 toSend = _value * 10**6;
124 
125         require(_receivers.length <= 200, "Too many recipients");
126 
127         for(uint256 i = 0; i < _receivers.length; i++) {
128             transfer(_receivers[i], toSend);
129         }
130 
131         return true;
132     }
133 
134     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
135         require(_to != address(0), "Cannot use zero address");
136         require(_value > 0, "Cannot use zero value");
137         
138         require( balanceOf[_from] >= _value, "Balance not enough" );
139         require( balanceOf[_to] + _value > balanceOf[_to], "Cannot overflow" );
140         
141         require( _value <= allowance[_from][msg.sender], "Cannot over allowance" );
142         
143         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);
144         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
145         
146         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
147         
148         emit Transfer(_from, _to, _value);
149         
150         return true;
151     }
152 
153     /**
154      * Ownership functions
155      */
156     modifier onlyOwner() {
157         require(msg.sender == owner);
158         _;
159     }
160 
161     function transferOwnership(address newOwner) public {
162         require(newOwner != address(0));
163         emit OwnershipTransferred(owner, newOwner);
164         owner = newOwner;
165     }
166 
167     /**
168      * Minting functions
169      */
170     bool public mintingFinished = false;
171 
172     address public creator;
173     address public destroyer;
174 
175     modifier canMint() {
176         require(!mintingFinished);
177         _;
178     }
179 
180     modifier whenMintingFinished() {
181         require(mintingFinished);
182         _;
183     }
184 
185     modifier onlyCreator() {
186         require(msg.sender == creator);
187         _;
188     }
189 
190     function setCreator(address _creator) external onlyOwner {
191         require(_creator != address(0), "Cannot use zero address");
192         creator = _creator;
193     }
194 
195     function mint(address _to, uint256 _amount) external onlyCreator canMint returns (bool) {
196         require(_to != address(0), "Cannot use zero address");
197         require(balanceOf[_to] + _amount > balanceOf[_to]);
198         require(totalSupply + _amount > totalSupply);
199 
200         totalSupply = SafeMath.safeAdd(totalSupply, _amount);
201         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _amount);
202 
203         emit Mint(_to, _amount);
204 
205         return true;
206     }
207 
208     function finishMinting() external onlyCreator returns (bool) {
209         mintingFinished = true;
210         emit MintingFinished();
211 
212         return true;
213     }
214 
215     /**
216      * Burning functions
217      */
218 
219     modifier onlyDestroyer() {
220         require(msg.sender == destroyer);
221         _;
222     }
223 
224     function setDestroyer(address _destroyer) external onlyOwner {
225         require(_destroyer != address(0), "Cannot use zero address");
226         destroyer = _destroyer;
227     }
228 
229     function burn(uint256 _amount) external onlyDestroyer {
230         require(balanceOf[destroyer] >= _amount && _amount > 0);
231 
232         balanceOf[destroyer] = SafeMath.safeSub(balanceOf[destroyer], _amount);
233         totalSupply = SafeMath.safeSub(totalSupply, _amount);
234         
235         emit Burn(_amount);
236     }
237 }