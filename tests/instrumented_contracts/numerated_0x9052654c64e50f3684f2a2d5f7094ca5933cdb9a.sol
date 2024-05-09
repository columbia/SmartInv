1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4   
5     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6         if (a == 0) {
7             return 0;
8         }
9         c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13     
14  
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16   
17         return a / b;
18     }
19 
20     
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
27         c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 
32     function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
33         uint256 c = add(a,m);
34         uint256 d = sub(c,1);
35         return mul(div(d,m),m);
36   }
37 
38 }
39 
40 contract Ownable {
41     address public owner;
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44    constructor() public {
45       owner = msg.sender;
46     }
47     
48     modifier onlyOwner() {
49       require(msg.sender == owner, "Must be an owner");
50       _;
51     }
52     
53     function transferOwnership(address newOwner) public onlyOwner {
54       require(newOwner != address(0), "New owner must be a non-zero address");
55       emit OwnershipTransferred(owner, newOwner);
56       owner = newOwner;
57     }
58 }
59 
60 contract ERC20Basic {
61     function totalSupply() public view returns (uint256);
62     function balanceOf(address who) public view returns (uint256);
63     function transfer(address to, uint256 value) public returns (bool);
64     event Transfer(address indexed from, address indexed to, uint256 value);
65 }
66 
67 contract ERC20 is ERC20Basic {
68     function allowance(address owner, address spender) public view returns (uint256);
69     function transferFrom(address from, address to, uint256 value) public returns (bool);
70     function approve(address spender, uint256 value) public returns (bool);
71     event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 contract BasicToken is ERC20Basic {
75     using SafeMath for uint256;
76     mapping(address => uint256) balances;
77     mapping(address => uint256) ethBalances;
78     
79     uint256 totalSupply_;
80     
81     function totalSupply() public view returns (uint256) {
82         return totalSupply_;
83     }
84 
85     function balanceOf(address _owner) public view returns (uint256) {
86         return balances[_owner];
87     }
88 
89     function checkInvestedETH(address who) public view returns (uint256) {
90         return ethBalances[who];
91     }
92 
93 }
94 
95 contract StandardToken is ERC20, BasicToken {
96     mapping (address => mapping (address => uint256)) internal allowed;
97     uint256 public basePercent = 100;
98 
99     function findOnePercent(uint256 value) public view returns (uint256)  {
100      uint256 roundValue = value.ceil(basePercent);
101      uint256 onePercent = roundValue.mul(basePercent).div(10000);
102      return onePercent;
103     }
104 
105     function transfer(address to, uint256 value) public returns (bool) {
106         require(value <= balances[msg.sender], "Not enough tokens to transfer");
107         require(to != address(0), "Receiver must be a non-zero address");
108 
109         uint256 tokensToBurn = findOnePercent(value);
110         uint256 tokensToTransfer = value.sub(tokensToBurn);
111 
112         balances[msg.sender] = balances[msg.sender].sub(value);
113         balances[to] = balances[to].add(tokensToTransfer);
114 
115         totalSupply_ = totalSupply_.sub(tokensToBurn);
116 
117         emit Transfer(msg.sender, to, tokensToTransfer);
118         emit Transfer(msg.sender, address(0), tokensToBurn);
119         return true;
120     }
121 
122     function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
123         for (uint256 i = 0; i < receivers.length; i++) {
124         transfer(receivers[i], amounts[i]);
125         }
126     }
127 
128     function transferFrom(address from, address to, uint256 value) public returns (bool) {
129         require(value <= balances[from], "Must have sufficient balance");
130         require(value <= allowed[from][msg.sender], "Spender has sufficient spending balance");
131         require(to != address(0), "Sender must be a non-zero address");
132 
133         balances[from] = balances[from].sub(value);
134 
135         uint256 tokensToBurn = findOnePercent(value);
136         uint256 tokensToTransfer = value.sub(tokensToBurn);
137 
138         balances[to] = balances[to].add(tokensToTransfer);
139         totalSupply_ = totalSupply_.sub(tokensToBurn);
140 
141         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
142 
143         emit Transfer(from, to, tokensToTransfer);
144         emit Transfer(from, address(0), tokensToBurn);
145 
146         return true;
147     } 
148 
149     function approve(address spender, uint256 value) public returns (bool) {
150         require(spender != address(0), "Cannot approve to a zero address");
151         allowed[msg.sender][spender] = value;
152         emit Approval(msg.sender, spender, value);
153         return true;
154     }
155     
156     function allowance(address _owner, address _spender) public view returns (uint256) {
157         return allowed[_owner][_spender];
158     }
159     
160     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
161         require(spender != address(0), "Must be a non zero address");
162         allowed[msg.sender][spender] = (allowed[msg.sender][spender].add(addedValue));
163         emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
164         return true;
165     }
166 
167     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
168         uint oldValue = allowed[msg.sender][spender];
169         if (subtractedValue > oldValue) {
170             allowed[msg.sender][spender] = 0;
171         } else {
172             allowed[msg.sender][spender] = oldValue.sub(subtractedValue);
173         }
174         emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
175         return true;
176     }
177 
178 }
179 
180 contract Configurable {
181     uint256 public constant cap = 9000*10**18; 
182     uint256 public constant basePrice = 180*10**18; 
183     uint256 public tokensSold = 0;
184     
185     uint256 public constant tokenReserve = 15000*10**18;
186     uint256 public remainingTokens = 0;
187 }
188 
189 contract CrowdsaleToken is StandardToken, Configurable, Ownable {
190   
191      enum Stages {
192         none,
193         icoStart, 
194         icoEnd
195     }
196     
197     Stages currentStage;
198 
199     constructor() public {
200         currentStage = Stages.none;
201         balances[owner] = balances[owner].add(tokenReserve);
202         totalSupply_ = totalSupply_.add(tokenReserve);
203         remainingTokens = cap;
204         emit Transfer(address(this), owner, tokenReserve);
205     }
206 
207     function () public payable {
208         require(currentStage == Stages.icoStart, "The coin offering has not started yet");
209         require(msg.value > 0 && msg.value <= 1e18, "You cannot send 0 Ether or more than 1 Ether");
210         require(remainingTokens > 0, "Must be some tokens remaining");
211        
212         address caller = msg.sender;
213         uint256 weiAmount = msg.value;
214         uint256 tokens = weiAmount.mul(basePrice).div(1 ether);
215         uint256 returnWei = 0;
216         
217         ethBalances[caller] = ethBalances[caller].add(weiAmount);
218         ethBalances[address(this)] = ethBalances[address(this)].add(weiAmount);
219        
220         require(ethBalances[caller] <= 1e18);
221         require(ethBalances[address(this)] <= 50e18);
222 
223         if(tokensSold.add(tokens) > cap){
224             uint256 newTokens = cap.sub(tokensSold);
225             uint256 newWei = newTokens.div(basePrice).mul(1 ether);
226             returnWei = weiAmount.sub(newWei);
227             weiAmount = newWei;
228             tokens = newTokens;
229         }
230         
231         tokensSold = tokensSold.add(tokens); 
232         remainingTokens = cap.sub(tokensSold);
233         if(returnWei > 0){
234             msg.sender.transfer(returnWei);
235             emit Transfer(address(this), msg.sender, returnWei);
236         }
237         
238         balances[msg.sender] = balances[msg.sender].add(tokens);
239         emit Transfer(address(this), msg.sender, tokens);
240         totalSupply_ = totalSupply_.add(tokens);
241         owner.transfer(weiAmount);
242     }
243 
244     function startIco() public onlyOwner {
245         require(currentStage != Stages.icoEnd, "The coin offering has ended");
246         currentStage = Stages.icoStart;
247     }
248 
249     function endIco() internal {
250         currentStage = Stages.icoEnd;
251         if(remainingTokens > 0)
252             balances[owner] = balances[owner].add(remainingTokens);
253         owner.transfer(address(this).balance); 
254     }
255 
256     function finalizeIco() public onlyOwner {
257         require(currentStage != Stages.icoEnd, "The coin offering has ended");
258         endIco();
259     }
260     
261 }
262 
263 contract LETSFKNGO is CrowdsaleToken {
264     string public constant name = "LETSFKNGO";
265     string public constant symbol = "LFG";
266     uint32 public constant decimals = 18;
267 }