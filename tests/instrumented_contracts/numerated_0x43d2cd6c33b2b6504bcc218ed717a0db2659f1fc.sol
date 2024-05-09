1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9  
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16  
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21  
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract ERC20Interface {
30     
31     using SafeMath for uint256;
32     
33     string public name;
34     string public symbol;
35     uint8 public decimals;
36     uint public totalSupply;
37 
38     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
39     function approve(address spender, uint tokens) public returns (bool success);
40 
41     function transfer(address to, uint tokens) public returns (bool success);
42     function transferFrom(address from, address to, uint tokens) public returns (bool success);
43 
44 
45     event Transfer(address indexed from, address indexed to, uint tokens);
46     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
47 }
48 
49 //设置代币控制合约的管理员
50 contract Owned {
51  
52     // modifier(条件)，表示必须是权力所有者才能do something，类似administrator的意思
53     modifier onlyOwner() {
54         require(msg.sender == owner);
55         _;//do something 
56     }
57  
58 	//权力所有者
59     address public owner;
60  
61 	//合约创建的时候执行，执行合约的人是第一个owner
62     constructor() public {
63         owner = msg.sender;
64     }
65 	//新的owner,初始为空地址，类似null
66     address newOwner=0x0;
67  
68 	//更换owner成功的事件
69     event OwnerUpdate(address _prevOwner, address _newOwner);
70  
71     //现任owner把所有权交给新的owner(需要新的owner调用acceptOwnership方法才会生效)
72     function changeOwner(address _newOwner) public onlyOwner {
73         require(_newOwner != owner);
74         newOwner = _newOwner;
75     }
76  
77     //新的owner接受所有权,权力交替正式生效
78     function acceptOwnership() public{
79         require(msg.sender == newOwner);
80         emit OwnerUpdate(owner, newOwner);
81         owner = newOwner;
82         newOwner = 0x0;
83     }
84 }
85 
86 //代币的控制合约
87 contract Controlled is Owned{
88  
89 	//创世vip
90     constructor() public {
91        setExclude(msg.sender,true);
92     }
93  
94     // 控制代币是否可以交易，true代表可以(exclude里的账户不受此限制，具体实现在下面的transferAllowed里)
95     bool public transferEnabled = true;
96  
97     // 是否启用账户锁定功能，true代表启用
98     bool lockFlag=true;
99 	// 锁定的账户集合，address账户，bool是否被锁，true:被锁定，当lockFlag=true时，恭喜，你转不了账了，哈哈
100     mapping(address => bool) locked;
101 	// 拥有特权用户，不受transferEnabled和lockFlag的限制，vip啊，bool为true代表vip有效
102     mapping(address => bool) exclude;
103  
104 	//设置transferEnabled值
105     function enableTransfer(bool _enable) public onlyOwner returns (bool success){
106         transferEnabled=_enable;
107 		return true;
108     }
109  
110 	//设置lockFlag值
111     function disableLock(bool _enable) public onlyOwner returns (bool success){
112         lockFlag=_enable;
113         return true;
114     }
115  
116 	// 把_addr加到锁定账户里，拉黑名单。。。
117     function addLock(address _addr) public onlyOwner returns (bool success){
118         require(_addr!=msg.sender);
119         locked[_addr]=true;
120         return true;
121     }
122  
123 	//设置vip用户
124     function setExclude(address _addr,bool _enable) public onlyOwner returns (bool success){
125         exclude[_addr]=_enable;
126         return true;
127     }
128  
129 	//解锁_addr用户
130     function removeLock(address _addr) public onlyOwner returns (bool success){
131         locked[_addr]=false;
132         return true;
133     }
134 	//控制合约 核心实现
135     modifier transferAllowed(address _addr) {
136         if (!exclude[_addr]) {
137             require(transferEnabled,"transfer is not enabeled now!");
138             if(lockFlag){
139                 require(!locked[_addr],"you are locked!");
140             }
141         }
142         _;
143     }
144  
145 }
146 
147 contract EpilogueToken is ERC20Interface,Controlled {
148     
149     mapping(address => uint256) public balanceOf;
150     mapping(address => mapping(address => uint256)) allowed;
151     
152     constructor() public {
153         name = 'Epilogue';  //代币名称
154         symbol = 'EP'; //代币符号
155         decimals = 18; //小数点 
156         totalSupply = 100000000 * 10 ** uint256(decimals); //代币发行总量 
157         balanceOf[msg.sender] = totalSupply; //指定发行量
158     }
159     
160     function transfer(address to, uint256 tokens) public returns (bool success) {
161         
162         require(to != address(0));
163         require(balanceOf[msg.sender] >= tokens);
164         require(balanceOf[to] + tokens >= balanceOf[to]);
165         
166         balanceOf[msg.sender] -= tokens;
167         balanceOf[to] += tokens;
168         
169         emit Transfer(msg.sender, to, tokens);
170         
171         return true;
172     }
173     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
174         
175         require(to != address(0));
176         require(allowed[from][msg.sender] >= tokens);
177         require(balanceOf[from] >= tokens);
178         require(balanceOf[to] + tokens >= balanceOf[to]);
179         
180         balanceOf[from] -= tokens;
181         balanceOf[to] += tokens;
182         
183         allowed[from][msg.sender] -= tokens;
184         
185         emit Transfer(from, to, tokens);
186         
187         return true;
188     }
189     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
190         return allowed[tokenOwner][spender];
191     }
192     
193     function approve(address spender, uint tokens) public returns (bool success) {
194         allowed[msg.sender][spender] = tokens;
195         
196         emit Approval(msg.sender, spender, tokens);
197         
198         return true;
199     }
200     
201 }