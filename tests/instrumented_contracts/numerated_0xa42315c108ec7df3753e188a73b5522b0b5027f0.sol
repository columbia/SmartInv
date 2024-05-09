1 pragma solidity ^0.4.20;
2 
3 contract OptionToken {
4 
5     address public owner;
6 // 以下是基于ERC20生成代币逻辑
7     string public name;
8     string public symbol;
9     uint8 public decimals;
10     uint public totalSupply;
11     
12     mapping (address => uint) public balanceOf;
13     mapping (address => mapping (address => uint)) public allowance;
14     
15     event Transfer(address indexed from, address indexed to, uint value);
16     
17     event Burn(address indexed from, uint value);
18     
19     constructor (
20         uint initialSupply,
21         string tokenName,
22         string tokenSymbol,
23         uint8 tokenDecimals
24     ) public {
25         totalSupply = initialSupply * 10 ** uint(tokenDecimals);
26         balanceOf[msg.sender] = totalSupply;
27         name = tokenName;
28         symbol = tokenSymbol;
29         owner = msg.sender;
30         decimals = tokenDecimals;
31     }
32 
33     function _transfer(address _from, address _to, uint _value) internal returns (bool) {
34         require(_to != 0x0);
35         require(balanceOf[_from] >= _value);
36         require(add(balanceOf[_to],_value) >= balanceOf[_to]);
37         uint previousBalances = add(balanceOf[_from],balanceOf[_to]);
38         balanceOf[_from] = sub(balanceOf[_from],_value);
39         balanceOf[_to] = add(balanceOf[_to],_value);
40         emit Transfer(_from, _to, _value);
41         assert(add(balanceOf[_from],balanceOf[_to]) == previousBalances);
42         return true;
43     }
44 
45     function transfer(address _to, uint _value) public {
46         _transfer(msg.sender, _to, _value);
47     }
48 
49     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
50         require(_value <= allowance[_from][msg.sender]);     // Check allowance
51         allowance[_from][msg.sender] = sub(allowance[_from][msg.sender],_value);
52         _transfer(_from, _to, _value);
53         return true;
54     }
55 
56     function burn(uint _value) public returns (bool success) {
57         require(balanceOf[msg.sender] >= _value);
58         balanceOf[msg.sender] = sub(balanceOf[msg.sender],_value);
59         totalSupply = sub(totalSupply,_value);
60         emit Burn(msg.sender, _value);
61         return true;
62     }
63 
64     function burnFrom(address _from, uint _value) public returns (bool success) {
65         require(balanceOf[_from] >= _value);
66         require(_value <= allowance[_from][msg.sender]);
67         balanceOf[_from] = sub(balanceOf[_from],_value);
68         allowance[_from][msg.sender] = sub(allowance[_from][msg.sender],_value);
69         totalSupply = sub(totalSupply,_value);
70         emit Burn(_from, _value);
71         return true;
72     }
73 
74 // 以上是基于ERC20生成代币逻辑
75 
76 
77 // 以下是公共判断及基本方法
78     // 判断是否为owner地址
79     modifier onlyOwner() {
80         require(msg.sender == owner);
81         _;
82     }
83     // 更改owner地址
84     function transferOwnership(address newOwner) external onlyOwner {
85         if (newOwner != address(0))
86             owner = newOwner;
87     }
88     // 摧毁该智能合约
89     function selfdestruct() external onlyOwner {
90         selfdestruct(owner);
91     }
92 
93     bool public status = true;// 判断该合约状态
94 
95     modifier checkStatus() {
96         require(status == true);
97         _;
98     }
99 
100     function unlockContract() external onlyOwner {
101         require(!status);
102         status = true;
103     }
104 
105     function lockContract() external onlyOwner {
106         require(status);
107         status = false;
108     }
109 
110     mapping (address => uint) whitelist;// 白名单列表
111 
112     function addWhiteList (address _user, uint _amount) public onlyOwner checkStatus {
113         whitelist[_user] = _amount;
114     }
115 
116     function removeWhiteList (address _user) public onlyOwner checkStatus {
117         delete whitelist[_user];
118     }
119 
120     function isAllowTransfer(address _user) public view returns (bool) {
121         return whitelist[_user] == 0 ? false : true;
122     }
123 
124     function getAllowAmount(address _user) public view returns (uint) {
125         return whitelist[_user];
126     }
127 
128     function mul(uint a, uint b) internal pure returns (uint c) {
129         if (a == 0) {
130             return 0;
131         }
132 
133         c = a * b;
134         assert(c / a == b);
135         return c;
136     }
137 
138     function div(uint a, uint b) internal pure returns (uint) {
139         return a / b;
140     }
141 
142     function sub(uint a, uint b) internal pure returns (uint) {
143         assert(b <= a);
144         return a - b;
145     }
146 
147     function add(uint a, uint b) internal pure returns (uint c) {
148         c = a + b;
149         assert(c >= a);
150         return c;
151     }
152 
153 // 以上是公共判断及基本方法
154 
155 // 以下是授予公共模块
156 
157     event issueEvent(bytes32 issueKey);
158 
159     struct IssueStruct {
160         // 授予数量
161         uint issueAmount;
162         // 授予日期
163         uint32 issueDate;
164         // 成熟起算日
165         uint32 vestingStartDate;
166     }
167     
168     mapping (address => mapping (bytes32 => IssueStruct)) public issueList;
169 
170 
171     // 授予
172     function issue ( 
173         address _issueAddress, uint _issueAmount,
174         uint32 _issueDate,uint32 _vestingStartDate 
175     ) 
176         external 
177         checkStatus 
178         onlyOwner 
179         returns (bool)
180     {
181         require(_issueAddress != 0x0);
182         require(_issueDate != 0);
183         require(_vestingStartDate != 0);
184         
185         uint nowTime = block.timestamp;
186         bytes32 issueKey = sha256(_issueAddress, _issueAmount, _issueDate, _vestingStartDate, nowTime);
187         // 授予
188         issueList[_issueAddress][issueKey] = IssueStruct({
189             issueAmount: _issueAmount,
190             issueDate: _issueDate,
191             vestingStartDate: _vestingStartDate
192         });
193 
194         emit issueEvent(issueKey);
195         return true;
196     }
197 
198     // 根据address、key 查看授予详情
199     function showIssueDetail ( address _issueAddress, bytes32 _issueKey ) 
200         public 
201         view 
202         returns ( uint, uint32, uint32 ) 
203     {
204         require(hasIssue(_issueAddress, _issueKey));
205         IssueStruct storage issueDetail = issueList[_issueAddress][_issueKey];
206         return ( 
207             issueDetail.issueAmount, issueDetail.issueDate, 
208             issueDetail.vestingStartDate
209         );
210     }
211 
212     // 通过address 和 key 判断是否有该授予纪录
213     function hasIssue ( address _issueAddress, bytes32 _issueKey )
214         internal 
215         view 
216         returns (bool)
217     {
218         if (issueList[_issueAddress][_issueKey].issueAmount != 0) {
219             return true;
220         } else {
221             return false;
222         }
223     }
224 
225 // 以上是授予模块
226 
227 // 以下是成熟列表展示模块
228     function reveiveToken ( address _issueAddress, uint amount ) 
229         external
230         onlyOwner
231         checkStatus
232     {
233         _transfer(owner, _issueAddress, amount);
234     }
235 // 以上是成熟列表展示模块
236 }