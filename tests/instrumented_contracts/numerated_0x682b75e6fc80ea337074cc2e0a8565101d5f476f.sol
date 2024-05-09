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
50 contract Lockable is Ownable {
51     bool public contractLocked = false;
52 
53     modifier notLocked() {
54         require(!contractLocked);
55         _;
56     }
57 
58     function lockContract() public onlyOwner {
59         contractLocked = true;
60     }
61 
62     function unlockContract() public onlyOwner {
63         contractLocked = false;
64     }
65 }
66 
67 contract FeeCalculator is Ownable, SafeMath {
68 
69     uint public feeNumerator = 0;
70 
71     uint public feeDenominator = 0;
72 
73     uint public minFee = 0;
74 
75     uint public maxFee = 0;
76 
77     function setFee(uint _feeNumerator, uint _feeDenominator, uint _minFee, uint _maxFee) public onlyOwner {
78         feeNumerator = _feeNumerator;
79         feeDenominator = _feeDenominator;
80         minFee = _minFee;
81         maxFee = _maxFee;
82     }
83 
84     function calculateFee(uint value) public view returns (uint requiredFee) {
85         if (feeNumerator == 0 || feeDenominator == 0) return 0;
86 
87         uint fee = safeDiv(safeMul(value, feeNumerator), feeDenominator);
88 
89         if (fee < minFee) return minFee;
90 
91         if (fee > maxFee) return maxFee;
92 
93         return fee;
94     }
95 
96     function subtractFee(uint value) internal returns (uint newValue);
97 }
98 
99 contract EIP20Interface {
100     uint256 public totalSupply;
101 
102     function balanceOf(address owner) public view returns (uint256 balance);
103 
104     function transfer(address to, uint256 value) public returns (bool success);
105 
106     function transferFrom(address from, address to, uint256 value) public returns (bool success);
107 
108     function approve(address spender, uint256 value) public returns (bool success);
109 
110     function allowance(address owner, address spender) public view returns (uint256 remaining);
111 
112     event Transfer(address indexed from, address indexed to, uint256 value);
113 
114     event Approval(address indexed owner, address indexed spender, uint256 value);
115 }
116 
117 contract Mintable is Ownable {
118     mapping(address => bool) public minters;
119 
120     modifier onlyMinter {
121         require(minters[msg.sender] == true);
122         _;
123     }
124 
125     function Mintable() public {
126         adjustMinter(msg.sender, true);
127     }
128 
129     function adjustMinter(address minter, bool canMint) public onlyOwner {
130         minters[minter] = canMint;
131     }
132 
133     function mint(address to, uint256 value) public;
134 
135 }
136 
137 contract Token is EIP20Interface, Ownable, SafeMath, Mintable, Lockable, FeeCalculator {
138 
139     mapping(address => uint256) public balances;
140 
141     mapping(address => mapping(address => uint256)) public allowed;
142 
143     mapping(address => bool) frozenAddresses;
144 
145     string public name;
146 
147     uint8 public decimals;
148 
149     string public symbol;
150 
151     bool public isBurnable;
152 
153     bool public canAnyoneBurn;
154 
155     modifier notFrozen(address target) {
156         require(!frozenAddresses[target]);
157         _;
158     }
159 
160     event AddressFroze(address target, bool isFrozen);
161 
162     function Token(string _name, uint8 _decimals, string _symbol) public {
163         name = _name;
164         decimals = _decimals;
165         symbol = _symbol;
166     }
167 
168     function transfer(address to, uint256 value) notLocked notFrozen(msg.sender) public returns (bool success) {
169         return transfer(msg.sender, to, value);
170     }
171 
172     function transfer(address from, address to, uint256 value) internal returns (bool success) {
173         balances[from] = safeSub(balances[from], value);
174         value = subtractFee(value);
175         balances[to] = safeAdd(balances[to], value);
176 
177         emit Transfer(from, to, value);
178         return true;
179     }
180 
181     function transferFrom(address from, address to, uint256 value) notLocked notFrozen(from) public returns (bool success) {
182         uint256 allowance = allowed[from][msg.sender];
183         balances[from] = safeSub(balances[from], value);
184         allowed[from][msg.sender] = safeSub(allowance, value);
185         value = subtractFee(value);
186         balances[to] = safeAdd(balances[to], value);
187 
188         emit Transfer(from, to, value);
189         return true;
190     }
191 
192     function balanceOf(address owner) public view returns (uint256 balance) {
193         return balances[owner];
194     }
195 
196     function approve(address spender, uint256 value) notLocked public returns (bool success) {
197         allowed[msg.sender][spender] = value;
198         emit Approval(msg.sender, spender, value);
199         return true;
200     }
201 
202     function allowance(address owner, address spender) public view returns (uint256 remaining) {
203         return allowed[owner][spender];
204     }
205 
206     function freezeAddress(address target, bool freeze) onlyOwner public {
207         if (freeze) {
208             frozenAddresses[target] = true;
209         } else {
210             delete frozenAddresses[target];
211         }
212         emit AddressFroze(target, freeze);
213     }
214 
215     function isAddressFrozen(address target) public view returns (bool frozen){
216         return frozenAddresses[target];
217     }
218 
219     function mint(address to, uint256 value) public onlyMinter {
220         totalSupply = safeAdd(totalSupply, value);
221         balances[to] = safeAdd(balances[to], value);
222         emit Transfer(0x0, to, value);
223     }
224 
225     function subtractFee(uint value) internal returns (uint newValue) {
226         uint feeToTake = calculateFee(value);
227 
228         if (feeToTake == 0) return value;
229 
230         balances[this] = safeAdd(balances[this], feeToTake);
231 
232         return value - feeToTake;
233     }
234 
235     function withdrawFees(address to) onlyOwner public returns (bool success) {
236         return transfer(this, to, balances[this]);
237     }
238 
239     function setBurnPolicy(bool _isBurnable, bool _canAnyoneBurn) public {
240         isBurnable = _isBurnable;
241         canAnyoneBurn = _canAnyoneBurn;
242     }
243 
244     function burn(uint256 value) public returns (bool success) {
245         require(isBurnable);
246 
247         if (!canAnyoneBurn && msg.sender != owner) {
248             return false;
249         }
250 
251         balances[msg.sender] = safeSub(balances[msg.sender], value);
252         totalSupply = totalSupply - value;
253         return true;
254     }
255 }