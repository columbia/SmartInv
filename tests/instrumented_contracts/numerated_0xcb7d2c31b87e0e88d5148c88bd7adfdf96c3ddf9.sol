1 pragma solidity ^0.4.23;
2 
3 
4 library Math {
5 
6 
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         
9         if(a == 0) { return 0; }
10         uint256 c = a * b;
11         assert(c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16 
17         uint256 c = a / b;
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22 
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28 
29         uint256 c = a + b;
30         assert(c >= a);
31         return c;
32     }
33 }
34 
35 
36 contract ERC20 {
37 
38 
39     function totalSupply() public view returns (uint256);
40     function balanceOf(address who) public view returns (uint256);
41     function transfer(address to, uint256 value) public returns (bool);
42     event Transfer(address indexed from, address indexed to, uint256 value);
43 
44     function allowance(address owner, address spender) public view returns (uint256);
45     function transferFrom(address from, address to, uint256 value) public returns (bool);
46     function approve(address spender, uint256 value) public returns (bool);
47     event Approval(address indexed owner, address indexed spender, uint256 value);
48 }
49 
50 
51 contract Ownable {
52     
53 
54     address public owner_;
55     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57     constructor() public {
58         
59         owner_ = msg.sender;
60     }
61 
62     modifier onlyOwner() {
63         
64         require(msg.sender == owner_);
65         _;
66     }
67 
68     function transferOwnership(address newOwner) public onlyOwner {
69         
70         require(newOwner != address(0));
71         emit OwnershipTransferred(owner_, newOwner);
72         owner_ = newOwner;
73     }
74 }
75 
76 
77 contract BasicToken is ERC20 {
78     
79 
80     using Math for uint256;
81     
82     uint256 totalSupply_;    
83     mapping(address => uint256) balances_;
84 
85     function totalSupply() public view returns (uint256) {
86         
87         return totalSupply_;
88     }
89 
90     function transfer(address to, uint256 value) public returns (bool) {
91 
92         require(to != address(0));
93         require(value <= balances_[msg.sender]);
94 
95         balances_[msg.sender] = balances_[msg.sender].sub(value);
96         balances_[to] = balances_[to].add(value);
97         emit Transfer(msg.sender, to, value);
98         return true;
99     }
100 
101     function balanceOf(address owner) public view returns (uint256 balance) {
102 
103         return balances_[owner];
104     }
105 }
106 
107 
108 contract StandardToken is BasicToken {
109 
110 
111     event Burn(address indexed burner, uint256 value);
112     mapping (address => mapping (address => uint256)) internal allowed_;
113 
114     function transferFrom(address from, address to, uint256 value) public returns (bool) {
115 
116         require(to != address(0));
117         require(value <= balances_[from]);
118         require(value <= allowed_[from][msg.sender]);
119 
120         balances_[from] = balances_[from].sub(value);
121         balances_[to] = balances_[to].add(value);
122         allowed_[from][msg.sender] = allowed_[from][msg.sender].sub(value);
123         emit Transfer(from, to, value);
124         return true;
125     }
126 
127     function approve(address spender, uint256 value) public returns (bool) {
128         
129         allowed_[msg.sender][spender] = value;
130         emit Approval(msg.sender, spender, value);
131         return true;
132     }
133 
134     function allowance(address owner, address spender) public view returns (uint256) {
135         
136         return allowed_[owner][spender];
137     }
138 
139     function burn(uint256 value) public {
140 
141         require(value <= balances_[msg.sender]);
142         address burner = msg.sender;
143         balances_[burner] = balances_[burner].sub(value);
144         totalSupply_ = totalSupply_.sub(value);
145         emit Burn(burner, value);
146     }
147 }
148 
149 
150 contract UUNIOToken is StandardToken, Ownable {
151 
152     
153     using Math for uint;
154 
155     string constant public name     = "UUNIO Token";
156     string constant public symbol   = "UUNIO";
157     uint8 constant public decimals  = 8;
158     uint256 constant INITIAL_SUPPLY = 900000000e8;
159 
160     // MAINNET
161     address constant team      = 0x9c619FF74015bECc48D429755aA54435ba367e23;
162     address constant advisors  = 0xB4fca416727c92F5dBfC1d3C248F9A50B9f811fE;
163     address constant reserve   = 0x8E2c648f493323623C2a55010953aE2B98ec7675;
164     address constant system1   = 0x91c2ccf957C32A3F37125240942E97C1bD2aC394;
165     address constant system2   = 0xB9E51D549c2c0EE7976E354e8a33CD2F91Ef955C;
166     address constant angel     = 0x3f957Fc80cdf9ad2A9D78C3aFd13a75099A167B3;
167     address constant partners  = 0x8F3e215C76B312Fd28fBAaf16FE98d6e9357b8AB;
168     address constant preSale   = 0x39401cd3f45C682Bbb75eA4D3aDD4E268b19D0Fc;
169     address constant crowdSale = 0xB06DD470C23979f8331e790D47866130001e7492;
170     address constant benefit   = 0x0Ff19B60b84040019EA6B46E6314367484f66F8F;
171     
172     // TESTNET
173     // address constant team        = 0x08cF66b63c2995c7Cc611f58c3Df1305a1E46ba7;
174     // address constant advisors    = 0xCf456ED49752F0376aFd6d8Ed2CC6e959E57C086;
175     // address constant reserve     = 0x9F1046F1e85640256E2303AC807F895C5c0b862b;
176     // address constant system1     = 0xC97eFe0481964b344Df74e8Fa09b194010736A62;
177     // address constant system2     = 0xC97eFe0481964b344Df74e8Fa09b194010736A62;
178     // address constant angel       = 0xd03631463a266A749C666E6066D835bDAD307FB8;
179     // address constant partners    = 0xd03631463a266A749C666E6066D835bDAD307FB8;
180     // address constant preSale     = 0xd03631463a266A749C666E6066D835bDAD307FB8;
181     // address constant crowdSale   = 0xd03631463a266A749C666E6066D835bDAD307FB8;
182     // address constant benefit     = 0x08cF66b63c2995c7Cc611f58c3Df1305a1E46ba7;
183 
184     // 10%
185     uint constant teamTokens      = 90000000e8;
186     // 10%    
187     uint constant advisorsTokens  = 90000000e8;
188     // 30%    
189     uint constant reserveTokens   = 270000000e8;
190     //// total 15.14, 136260000 ///////
191     // 15%
192     uint constant system1Tokens   = 135000000e8;
193     // 0.14%
194     uint constant system2Tokens   = 1260000e8;
195     ////////////////////////
196     // 5.556684%
197     uint constant angelTokens     = 50010156e8;
198     // 2.360022%
199     uint constant partnersTokens  = 21240198e8;
200     // 15.275652%
201     uint constant preSaleTokens   = 137480868e8;
202     // 11.667642%
203     uint constant crowdSaleTokens = 105008778e8;
204 
205     constructor() public {
206 
207         totalSupply_ = INITIAL_SUPPLY;
208 
209         preFixed(team, teamTokens);
210         preFixed(advisors, advisorsTokens);
211         preFixed(reserve, reserveTokens);
212         preFixed(system1, system1Tokens);
213         preFixed(system2, system2Tokens);
214         preFixed(angel, angelTokens);
215         preFixed(partners, partnersTokens);
216         preFixed(preSale, preSaleTokens);
217         preFixed(crowdSale, crowdSaleTokens);
218     }
219 
220     function preFixed(address addr, uint amount) internal returns (bool) {
221         
222         balances_[addr] = amount;
223         emit Transfer(address(0x0), addr, amount);
224         return true;
225     }
226 
227     function transfer(address to, uint256 value) public returns (bool) {
228 
229         return super.transfer(to, value);
230     }
231 
232     function transferFrom(address from, address to, uint256 value) public returns (bool) {
233 
234         return super.transferFrom(from, to, value);
235     }
236 
237     function () public payable {
238 
239         benefit.transfer(msg.value);
240     }
241 }