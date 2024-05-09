1 pragma solidity 0.5.4;
2 
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     uint256 c = a * b;
7     require(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function div(uint256 a, uint256 b) internal pure returns (uint256) {
12     require(b > 0);
13     uint256 c = a / b;
14     return c;
15   }
16   
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     require(b <= a);
19     uint256 c = a - b;
20     return c;
21   }
22 
23  
24   function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
26     require(c >= a);
27     return c;
28   }
29 }
30 
31 contract Token {
32     function balanceOf(address _owner) public view returns (uint256 balance);
33     function transfer(address _to, uint256 _value) public returns (bool success);
34 }
35 
36 contract LockTokenContract {
37     using SafeMath for uint;
38  
39     uint256[] public FoundationReleaseStage = [
40         0,
41         0,
42         0,
43         0,
44         0,
45         0,
46         0,
47         0,
48         0,
49         0,
50         0,
51         0,
52         0,
53         0,
54         0,
55         0,
56         0,
57         0,
58         0,
59         0,
60         0,
61         0,
62         0,
63         0,
64         0,
65         0,
66         0,
67         0,
68         0,
69         0,
70         0,
71         0,
72         0,
73         0,
74         0,
75         0,
76         0,
77         283333333,
78         566666666,
79         850000000,
80         1133333333,
81         1416666666,
82         1700000000,
83         1983333333,
84         2266666666,
85         2550000000,
86         2833333333,
87         3116666666,
88         3400000000
89     ];
90     
91     uint256[] public TeamAndAdviserAddreesOneStage = [
92         0,
93         0,
94         0,
95         0,
96         3000000,
97         6000000,
98         9000000,
99         12000000,
100         15000000,
101         18000000,
102         21000000,
103         24000000,
104         27000000,
105         30000000,
106         33000000,
107         36000000,
108         39000000,
109         42000000,
110         45000000,
111         48000000,
112         51000000,
113         54000000,
114         57000000,
115         60000000,
116         63000000,
117         66000000,
118         69000000,
119         72000000,
120         75000000,
121         78000000,
122         81000000,
123         84000000,
124         87000000,
125         90000000,
126         93000000,
127         96000000,
128         300000000
129     ];
130     
131     uint256[] public TeamAndAdviserAddreesTwoStage = [
132         0,
133         0,
134         0,
135         0,
136         7000000,
137         14000000,
138         21000000,
139         28000000,
140         35000000,
141         42000000,
142         49000000,
143         56000000,
144         63000000,
145         70000000,
146         77000000,
147         84000000,
148         91000000,
149         98000000,
150         105000000,
151         112000000,
152         119000000,
153         126000000,
154         133000000,
155         140000000,
156         147000000,
157         154000000,
158         161000000,
159         168000000,
160         175000000,
161         182000000,
162         189000000,
163         196000000,
164         203000000,
165         210000000,
166         217000000,
167         224000000,
168         1300000000
169     ];
170     
171     
172     address public FoundationAddress = address(0x98d7cbfF0E5d6807F00A7047FdcdBDb7B1192f57);
173     address public TeamAndAdviserAddreesOne = address(0xb89b941F7cd9eBCBcAc16cA2F03aace5cf8e2edc);
174     address public TeamAndAdviserAddreesTwo = address(0x5a403e651EC2cD3b6B385dC639f1A90ea01017f7);
175     address public GubiTokenAddress  = address(0x12b2B2331A72d375c453c160B2c8A7010EeA510A);
176     
177     
178     uint public constant StageSection  = 5; // 5s
179     uint public StartTime = now; // 现在
180     
181     mapping(address => uint256) AddressWithdrawals;
182 
183 
184     constructor() public {
185     }
186 
187 
188     function () payable external {
189         require(msg.sender == FoundationAddress || msg.sender == TeamAndAdviserAddreesOne || msg.sender == TeamAndAdviserAddreesTwo );
190         require(msg.value == 0);
191         require(now > StartTime);
192 
193         Token token = Token(GubiTokenAddress);
194         uint balance = token.balanceOf(address(this));
195         require(balance > 0);
196 
197         uint256[] memory stage;
198         if (msg.sender == FoundationAddress) {
199             stage = FoundationReleaseStage;
200         } else if (msg.sender == TeamAndAdviserAddreesOne) {
201             stage = TeamAndAdviserAddreesOneStage;
202         } else if (msg.sender == TeamAndAdviserAddreesTwo) {
203             stage = TeamAndAdviserAddreesTwoStage;
204         }
205         uint amount = calculateUnlockAmount(now, balance, stage);
206         if (amount > 0) {
207             AddressWithdrawals[msg.sender] = AddressWithdrawals[msg.sender].add(amount);
208 
209             require(token.transfer(msg.sender, amount.mul(1e18)));
210         }
211     }
212 
213     function calculateUnlockAmount(uint _now, uint _balance, uint256[] memory stage) internal view returns (uint amount) {
214         uint phase = _now
215             .sub(StartTime)
216             .div(StageSection);
217             
218         if (phase >= stage.length) {
219             phase = stage.length - 1;
220         }
221         
222         uint256 unlockable = stage[phase]
223             .sub(AddressWithdrawals[msg.sender]);
224 
225         if (unlockable == 0) {
226             return 0;
227         }
228 
229         if (unlockable > _balance.div(1e18)) {
230             return _balance.div(1e18);
231         }
232         
233         return unlockable;
234     }
235 }