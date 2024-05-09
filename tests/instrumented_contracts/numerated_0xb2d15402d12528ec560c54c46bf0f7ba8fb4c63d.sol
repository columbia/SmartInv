1 pragma solidity ^0.4.18;
2 
3 // Math operations with safety checks that throw on error
4 
5 library SafeMath {
6 
7     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
8         uint256 c = a * b;
9         assert(a == 0 || c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal constant returns (uint256) {
14         uint256 c = a / b;
15         return c;
16     }
17 
18     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal constant returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 // Simpler version of ERC20 interface
31 
32 contract ERC20Basic {
33     uint256 _totalSupply;
34     function balanceOf(address who) public constant returns (uint256);
35     function transfer(address to, uint256 value) public returns (bool);
36     event Transfer(address indexed from, address indexed to, uint256 value);
37 }
38 
39 // Basic version of StandardToken, with no allowances
40 
41 contract BasicToken is ERC20Basic {
42 
43     using SafeMath for uint256;
44 
45     mapping(address => uint256) balances;
46 
47     function transfer(address _to, uint256 _value) public returns (bool) {
48         require(_to != address(0));
49         require(_value <= balances[msg.sender]);
50         balances[msg.sender] = balances[msg.sender].sub(_value);
51         balances[_to] = balances[_to].add(_value);
52         Transfer(msg.sender, _to, _value);
53         return true;
54     }
55 
56     function balanceOf(address _owner) public constant returns (uint256 balance) {
57         return balances[_owner];
58     }
59 }
60 
61 // ERC20 interface
62 
63 contract ERC20 is ERC20Basic {
64     function allowance(address owner, address spender) public constant returns (uint256);
65     function transferFrom(address from, address to, uint256 value) public returns (bool);
66     function approve(address spender, uint256 value) public returns (bool);
67     event Approval(address indexed owner, address indexed spender, uint256 value);
68 }
69 
70 // Standard ERC20 token - Implementation of the basic standard token
71 
72 contract StandardToken is ERC20, BasicToken {
73 
74     mapping (address => mapping (address => uint256)) internal allowed;
75 
76     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
77         require(_to != address(0));
78         require(_value <= balances[_from]);
79         require(_value <= allowed[_from][msg.sender]);
80         balances[_from] = balances[_from].sub(_value);
81         balances[_to] = balances[_to].add(_value);
82         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
83         Transfer(_from, _to, _value);
84         return true;
85     }
86 
87     function approve(address _spender, uint256 _value) public returns (bool) {
88         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
89         allowed[msg.sender][_spender] = _value;
90         Approval(msg.sender, _spender, _value);
91         return true;
92     }
93 
94     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
95         return allowed[_owner][_spender];
96     }
97 }
98 
99 // Burnable contract
100 
101 contract Burnable is StandardToken {
102 
103     event Burn(address indexed burner, uint256 value);
104 
105     function burn(uint256 _value) public {
106 
107         require(_value > 0);
108         require(_value <= balances[msg.sender]);
109 
110         address burner = msg.sender;
111 
112         balances[burner] = balances[burner].sub(_value);
113         _totalSupply = _totalSupply.sub(_value);
114 
115         Burn(burner, _value);
116     }
117 }
118 
119 // Ownable contract
120 
121 contract Ownable {
122 
123     address public owner;
124 
125     function Ownable() public {
126         owner = msg.sender;
127     }
128 
129     modifier onlyOwner() {
130         require(msg.sender == owner);
131         _;
132     }
133 
134     function transferOwnership(address newOwner) public onlyOwner {
135         require(newOwner != address(0));
136         owner = newOwner;
137     }
138 }
139 
140 // Carblox Token
141 
142 contract CarbloxToken is StandardToken, Ownable, Burnable {
143 
144     string public constant name = "Carblox Token";
145     string public constant symbol = "CRX";
146     uint256 public constant decimals = 3;
147     uint256 public constant initialSupply = 100000000 * 10**3;
148 
149     function CarbloxToken() public {
150         _totalSupply = initialSupply;
151         balances[msg.sender] = initialSupply;
152     }
153     
154     function totalSupply() public constant returns (uint256) {
155         return _totalSupply;
156     }
157 }
158 
159 
160 // Carblox preICO contract
161 
162 contract CarbloxPreICO is Ownable {
163 
164     using SafeMath for uint256;
165 
166     CarbloxToken token;
167 
168     uint256 public constant RATE = 7500;
169     uint256 public constant START = 1509980400; // Mon, 06 Nov 2017 15:00
170     uint256 public constant DAYS = 30;
171   
172     uint256 public constant initialTokens = 7801500 * 10**3;
173     bool public initialized = false;
174     uint256 public raisedAmount = 0;
175     uint256 public participants = 0;
176 
177     event BoughtTokens(address indexed to, uint256 value);
178 
179     modifier whenSaleIsActive() {
180         assert(isActive());
181         _;
182     }
183 
184     function CarbloxPreICO(address _tokenAddr) public {
185         require(_tokenAddr != 0);
186         token = CarbloxToken(_tokenAddr);
187     }
188 
189     function initialize() public onlyOwner {
190         require(initialized == false);
191         require(tokensAvailable() == initialTokens);
192         initialized = true;
193     }
194 
195     function () public payable {
196         require(msg.value >= 100000000000000000);
197         buyTokens();
198     }
199 
200     function buyTokens() public payable whenSaleIsActive {
201 
202         uint256 finneyAmount =  msg.value.div(1 finney);
203         uint256 tokens = finneyAmount.mul(RATE);
204         uint256 bonus = getBonus(tokens);
205         
206         tokens = tokens.add(bonus);
207 
208         BoughtTokens(msg.sender, tokens);
209         raisedAmount = raisedAmount.add(msg.value);
210         participants = participants.add(1);
211 
212         token.transfer(msg.sender, tokens);
213         owner.transfer(msg.value);
214     }
215 
216     function getBonus(uint256 _tokens) public constant returns (uint256) {
217 
218         require(_tokens > 0);
219         
220         if (START <= now && now < START + 5 days) {
221 
222             return _tokens.mul(30).div(100); // 30% days 1-5
223 
224         } else if (START + 5 days <= now && now < START + 10 days) {
225 
226             return _tokens.div(5); // 20% days 6-10
227 
228         } else if (START + 10 days <= now && now < START + 15 days) {
229 
230             return _tokens.mul(15).div(100); // 15% days 11-15
231 
232         } else if (START + 15 days <= now && now < START + 20 days) {
233 
234             return _tokens.div(10); // 10% days 16-20
235 
236         } else if (START + 20 days <= now && now < START + 25 days) {
237 
238             return _tokens.div(20); // 5% days 21-25
239 
240         } else {
241 
242             return 0;
243 
244         }
245     }
246     
247     function isActive() public constant returns (bool) {
248         return (
249             initialized == true &&
250             now >= START &&
251             now <= START.add(DAYS * 1 days)
252         );
253     }
254 
255     function tokensAvailable() public constant returns (uint256) {
256         return token.balanceOf(this);
257     }
258 
259     function destroy() public onlyOwner {
260         
261         // Unsold tokens are burned
262         
263         uint256 balance = token.balanceOf(this);
264 
265         if (balance > 0) {
266             token.burn(balance);
267         }
268 
269         selfdestruct(owner);
270     }
271 }