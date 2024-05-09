1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         require(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         require(b > 0);
16         uint256 c = a / b;
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         require(b <= a);
22         uint256 c = a - b;
23         return c;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a);
29         return c;
30     }
31 
32     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
33         require(b != 0);
34         return a % b;
35     }
36 }
37 
38 contract Ownable {
39     address public owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     modifier onlyOwner() {
44         require(msg.sender == owner);
45         _;
46     }
47 
48     function transferOwnership(address newOwner) public onlyOwner {
49         require(newOwner != address(0));
50         emit OwnershipTransferred(owner, newOwner);
51         owner = newOwner;
52     }
53 
54     function renounceOwnership() public onlyOwner {
55         emit OwnershipTransferred(owner, address(0));
56         owner = address(0);
57     }
58 }
59 
60 contract BaseToken is Ownable {
61     using SafeMath for uint256;
62 
63     string public name;
64     string public symbol;
65     uint8 public decimals;
66     uint256 public totalSupply;
67     uint256 public _totalLimit;
68 
69     mapping (address => uint256) public balanceOf;
70     mapping (address => mapping (address => uint256)) public allowance;
71 
72     event Transfer(address indexed from, address indexed to, uint256 value);
73     event Approval(address indexed owner, address indexed spender, uint256 value);
74 
75     function _transfer(address from, address to, uint value) internal {
76         require(to != address(0));
77         balanceOf[from] = balanceOf[from].sub(value);
78         balanceOf[to] = balanceOf[to].add(value);
79         emit Transfer(from, to, value);
80     }
81 
82     function _mint(address account, uint256 value) internal {
83         require(account != address(0));
84         totalSupply = totalSupply.add(value);
85         require(_totalLimit >= totalSupply);
86         balanceOf[account] = balanceOf[account].add(value);
87         emit Transfer(address(0), account, value);
88     }
89 
90     function transfer(address to, uint256 value) public returns (bool) {
91         _transfer(msg.sender, to, value);
92         return true;
93     }
94 
95     function transferFrom(address from, address to, uint256 value) public returns (bool) {
96         allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
97         _transfer(from, to, value);
98         return true;
99     }
100 
101     function approve(address spender, uint256 value) public returns (bool) {
102         require(spender != address(0));
103         allowance[msg.sender][spender] = value;
104         emit Approval(msg.sender, spender, value);
105         return true;
106     }
107 
108     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
109         require(spender != address(0));
110         allowance[msg.sender][spender] = allowance[msg.sender][spender].add(addedValue);
111         emit Approval(msg.sender, spender, allowance[msg.sender][spender]);
112         return true;
113     }
114 
115     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
116         require(spender != address(0));
117         allowance[msg.sender][spender] = allowance[msg.sender][spender].sub(subtractedValue);
118         emit Approval(msg.sender, spender, allowance[msg.sender][spender]);
119         return true;
120     }
121 }
122 
123 contract AirdropToken is BaseToken {
124     uint256 public airMax;
125     uint256 public airTotal;
126     uint256 public airBegintime;
127     uint256 public airEndtime;
128     uint256 public airOnce;
129     uint256 public airLimitCount;
130 
131     mapping (address => uint256) public airCountOf;
132 
133     event Airdrop(address indexed from, uint256 indexed count, uint256 tokenValue);
134     event AirdropSetting(uint256 airBegintime, uint256 airEndtime, uint256 airOnce, uint256 airLimitCount);
135 
136     function airdrop() public payable {
137         require(block.timestamp >= airBegintime && block.timestamp <= airEndtime);
138         require(msg.value == 0);
139         require(airOnce > 0);
140         airTotal = airTotal.add(airOnce);
141         if (airMax > 0 && airTotal > airMax) {
142             revert();
143         }
144         if (airLimitCount > 0 && airCountOf[msg.sender] >= airLimitCount) {
145             revert();
146         }
147         _mint(msg.sender, airOnce);
148         airCountOf[msg.sender] = airCountOf[msg.sender].add(1);
149         emit Airdrop(msg.sender, airCountOf[msg.sender], airOnce);
150     }
151 
152     function changeAirdropSetting(uint256 newAirBegintime, uint256 newAirEndtime, uint256 newAirOnce, uint256 newAirLimitCount) public onlyOwner {
153         airBegintime = newAirBegintime;
154         airEndtime = newAirEndtime;
155         airOnce = newAirOnce;
156         airLimitCount = newAirLimitCount;
157         emit AirdropSetting(newAirBegintime, newAirEndtime, newAirOnce, newAirLimitCount);
158     }
159 
160 }
161 
162 contract InvestToken is BaseToken {
163     uint256 public investMax;
164     uint256 public investTotal;
165     uint256 public investEther;
166     uint256 public investMin;
167     uint256 public investRatio;
168     uint256 public investBegintime;
169     uint256 public investEndtime;
170     address public investHolder;
171 
172     event Invest(address indexed from, uint256 indexed ratio, uint256 value, uint256 tokenValue);
173     event Withdraw(address indexed from, address indexed holder, uint256 value);
174     event InvestSetting(uint256 investMin, uint256 investRatio, uint256 investBegintime, uint256 investEndtime, address investHolder);
175 
176     function invest() public payable {
177         require(block.timestamp >= investBegintime && block.timestamp <= investEndtime);
178         require(msg.value >= investMin);
179         uint256 tokenValue = (msg.value * investRatio * 10 ** uint256(decimals)) / (1 ether / 1 wei);
180         require(tokenValue > 0);
181         investTotal = investTotal.add(tokenValue);
182         if (investMax > 0 && investTotal > investMax) {
183             revert();
184         }
185         investEther = investEther.add(msg.value);
186         _mint(msg.sender, tokenValue);
187         emit Invest(msg.sender, investRatio, msg.value, tokenValue);
188     }
189 
190     function withdraw() public {
191         uint256 balance = address(this).balance;
192         investHolder.transfer(balance);
193         emit Withdraw(msg.sender, investHolder, balance);
194     }
195 
196     function changeInvestSetting(uint256 newInvestMin, uint256 newInvestRatio, uint256 newInvestBegintime, uint256 newInvestEndtime, address newInvestHolder) public onlyOwner {
197         require(newInvestRatio <= 999999999);
198         investMin = newInvestMin;
199         investRatio = newInvestRatio;
200         investBegintime = newInvestBegintime;
201         investEndtime = newInvestEndtime;
202         investHolder = newInvestHolder;
203         emit InvestSetting(newInvestMin, newInvestRatio, newInvestBegintime, newInvestEndtime, newInvestHolder);
204     }
205 }
206 
207 contract CustomToken is BaseToken, AirdropToken, InvestToken {
208     constructor() public {
209         name = 'Revolution Tesla Company';
210         symbol = 'RTC';
211         decimals = 18;
212         totalSupply = 3000000000000000000000000;
213         _totalLimit = 100000000000000000000000000000000;
214         balanceOf[0x3eD0DF84E5BCF1AF44d05438133265c0d6035FeE] = totalSupply;
215         emit Transfer(address(0), 0x3eD0DF84E5BCF1AF44d05438133265c0d6035FeE, totalSupply);
216 
217         owner = 0x3eD0DF84E5BCF1AF44d05438133265c0d6035FeE;
218 
219         airMax = 300000000000000000000000;
220         airBegintime = 1551413086;
221         airEndtime = 1554005086;
222         airOnce = 300000000000000000000;
223         airLimitCount = 1;
224 
225         investMax = 2000000000000000000000000;
226         investMin = 500000000000000000;
227         investRatio = 1500;
228         investBegintime = 1546315486;
229         investEndtime = 1548907486;
230         investHolder = 0x077EB386Ab262535f80dA2249aDa77Cd7000eAE6;
231     }
232 
233     function() public payable {
234         if (msg.value == 0) {
235             airdrop();
236         } else {
237             invest();
238         }
239     }
240 }