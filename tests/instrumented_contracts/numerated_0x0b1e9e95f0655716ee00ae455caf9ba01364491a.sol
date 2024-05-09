1 pragma solidity ^0.4.21;
2 
3 contract SafeMath {
4 
5     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 contract Ownable {
34     address public owner;
35 
36     function Ownable() public {
37         owner = msg.sender;
38     }
39 
40     modifier onlyOwner {
41         require(msg.sender == owner);
42         _;
43     }
44 
45     function transferOwner(address newOwner) public onlyOwner {
46         owner = newOwner;
47     }
48 }
49 
50 contract EIP20Interface {
51     uint256 public totalSupply;
52 
53     function balanceOf(address _owner) public view returns (uint256 balance);
54 
55     function transfer(address _to, uint256 _value) public returns (bool success);
56 
57     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
58 
59     function approve(address _spender, uint256 _value) public returns (bool success);
60 
61     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
62 
63     event Transfer(address indexed _from, address indexed _to, uint256 _value);
64 
65     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
66 }
67 
68 contract Mintable is Ownable {
69     mapping(address => bool) minters;
70 
71     modifier onlyMinter {
72         require(minters[msg.sender] == true);
73         _;
74     }
75 
76     function Mintable() public {
77         adjustMinter(msg.sender, true);
78     }
79 
80     function adjustMinter(address minter, bool canMint) public onlyOwner {
81         minters[minter] = canMint;
82     }
83 
84     function mint(address _to, uint256 _value) public;
85 
86 }
87 
88 
89 contract AkilosToken is EIP20Interface, Ownable, SafeMath, Mintable {
90 
91     mapping(address => uint256) public balances;
92 
93     mapping(address => mapping(address => uint256)) public allowed;
94 
95     string public name = "Akilos";
96 
97     uint8 public decimals = 18;
98 
99     string public symbol = "ALS";
100 
101     function AkilosToken() public {
102     }
103 
104     function transfer(address _to, uint256 _value) public returns (bool success) {
105         require(balances[msg.sender] >= _value);
106         balances[msg.sender] = safeSub(balances[msg.sender], _value);
107         balances[_to] = safeAdd(balances[_to], _value);
108 
109         emit Transfer(msg.sender, _to, _value);
110         return true;
111     }
112 
113     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
114         uint256 allowance = allowed[_from][msg.sender];
115         require(balances[_from] >= _value && allowance >= _value);
116         balances[_to] = safeAdd(balances[_to], _value);
117         balances[_from] = safeSub(balances[_from], _value);
118         allowed[_from][msg.sender] = safeSub(allowance, _value);
119 
120         emit Transfer(_from, _to, _value);
121         return true;
122     }
123 
124     function balanceOf(address _owner) public view returns (uint256 balance) {
125         return balances[_owner];
126     }
127 
128     function approve(address _spender, uint256 _value) public returns (bool success) {
129         allowed[msg.sender][_spender] = _value;
130         emit Approval(msg.sender, _spender, _value);
131         return true;
132     }
133 
134     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
135         return allowed[_owner][_spender];
136     }
137 
138     function mint(address _to, uint256 _value) public onlyMinter {
139         totalSupply = safeAdd(totalSupply, _value);
140         balances[_to] = safeAdd(balances[_to], _value);
141         emit Transfer(0x0, _to, _value);
142     }
143 }
144 
145 contract AkilosIco is Ownable, SafeMath {
146 
147     uint256 public startBlock;
148 
149     uint256 public endBlock;
150 
151     uint256 public maxGasPrice;
152 
153     uint256 public exchangeRate;
154 
155     uint256 public maxSupply;
156 
157     mapping(address => uint256) public participants;
158 
159     AkilosToken public token;
160 
161     address private wallet;
162 
163     bool private initialised;
164 
165     modifier participationOpen  {
166         require(block.number >= startBlock);
167         require(block.number <= endBlock);
168         _;
169     }
170 
171     function initialise(address _wallet, uint256 _startBlock, uint256 _endBlock, uint256 _maxGasPrice, uint256 _exchangeRate, uint256 _maxSupply) public onlyOwner returns (address tokenAddress) {
172 
173         if (token == address(0x0)) {
174             token = new AkilosToken();
175             token.transferOwner(owner);
176         }
177 
178         wallet = _wallet;
179         startBlock = _startBlock;
180         endBlock = _endBlock;
181         maxGasPrice = _maxGasPrice;
182         exchangeRate = _exchangeRate;
183         maxSupply = _maxSupply;
184         initialised = true;
185 
186         return token;
187     }
188 
189 
190     function() public payable {
191         participate(msg.sender, msg.value);
192     }
193 
194     function participate(address participant, uint256 value) internal participationOpen {
195         require(participant != address(0x0));
196 
197         require(tx.gasprice <= maxGasPrice);
198 
199         require(initialised);
200 
201         uint256 totalSupply = token.totalSupply();
202         require(totalSupply < maxSupply);
203 
204         uint256 tokenCount = safeMul(value, exchangeRate);
205         uint256 remaining = 0;
206 
207         uint256 newTotalSupply = safeAdd(totalSupply, tokenCount);
208         if (newTotalSupply > maxSupply) {
209             uint256 newTokenCount = newTotalSupply - maxSupply;
210 
211             remaining = safeDiv(tokenCount - newTokenCount, exchangeRate);
212             tokenCount = newTokenCount;
213         }
214 
215         if (remaining > 0) {
216             msg.sender.transfer(remaining);
217             value = safeSub(value, remaining);
218         }
219 
220         msg.sender.transfer(value);
221 
222 //        wallet.transfer(value);
223 
224         safeAdd(participants[participant], tokenCount);
225 
226         token.mint(msg.sender, tokenCount);
227     }
228 }