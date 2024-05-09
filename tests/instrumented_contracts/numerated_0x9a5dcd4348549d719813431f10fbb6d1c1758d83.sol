1 pragma solidity ^0.4.24;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5    防止整数溢出问题
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13  
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20  
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25  
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract StandardToken {
34 	//使用SafeMath
35     using SafeMath for uint256;
36    
37     //代币名称
38     string public name;
39     //代币缩写
40     string public symbol;
41 	//代币小数位数(一个代币可以分为多少份)
42     uint8 public  decimals;
43 	//代币总数
44 	uint256 public totalSupply;
45    
46 	//交易的发起方(谁调用这个方法，谁就是交易的发起方)把_value数量的代币发送到_to账户
47     function transfer(address _to, uint256 _value) public returns (bool success);
48 
49     //从_from账户里转出_value数量的代币到_to账户
50     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
51 
52 	//交易的发起方把_value数量的代币的使用权交给_spender，然后_spender才能调用transferFrom方法把我账户里的钱转给另外一个人
53     function approve(address _spender, uint256 _value) public returns (bool success);
54 
55 	//查询_spender目前还有多少_owner账户代币的使用权
56     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
57 
58 	//转账成功的事件
59     event Transfer(address indexed _from, address indexed _to, uint256 _value);
60 	//使用权委托成功的事件
61     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
62 }
63 
64 //设置代币控制合约的管理员
65 contract Owned {
66 
67     // modifier(条件)，表示必须是权力所有者才能do something，类似administrator的意思
68     modifier onlyOwner() {
69         require(msg.sender == owner);
70         _;//do something 
71     }
72 
73 	//权力所有者
74     address public owner;
75 
76 	//合约创建的时候执行，执行合约的人是第一个owner
77     constructor() public {
78         owner = msg.sender;
79     }
80 	//新的owner,初始为空地址，类似null
81     address newOwner=0x0;
82 
83 	//更换owner成功的事件
84     event OwnerUpdate(address _prevOwner, address _newOwner);
85 
86     //现任owner把所有权交给新的owner(需要新的owner调用acceptOwnership方法才会生效)
87     function changeOwner(address _newOwner) public onlyOwner {
88         require(_newOwner != owner);
89         newOwner = _newOwner;
90     }
91 
92     //新的owner接受所有权,权力交替正式生效
93     function acceptOwnership() public{
94         require(msg.sender == newOwner);
95         emit OwnerUpdate(owner, newOwner);
96         owner = newOwner;
97         newOwner = 0x0;
98     }
99 }
100 
101 //代币的控制合约
102 contract Controlled is Owned{
103 
104 	//创世vip
105     constructor() public {
106        setExclude(msg.sender,true);
107     }
108 
109     // 控制代币是否可以交易，true代表可以(exclude里的账户不受此限制，具体实现在下面的transferAllowed里)
110     bool public transferEnabled = true;
111 
112     // 是否启用账户锁定功能，true代表启用
113     bool lockFlag=true;
114 	// 锁定的账户集合，address账户，bool是否被锁，true:被锁定，当lockFlag=true时，恭喜，你转不了账了，哈哈
115     mapping(address => bool) locked;
116 	// 拥有特权用户，不受transferEnabled和lockFlag的限制，vip啊，bool为true代表vip有效
117     mapping(address => bool) exclude;
118 
119 	//设置transferEnabled值
120     function enableTransfer(bool _enable) public onlyOwner returns (bool success){
121         transferEnabled=_enable;
122 		return true;
123     }
124 
125 	//设置lockFlag值
126     function disableLock(bool _enable) public onlyOwner returns (bool success){
127         lockFlag=_enable;
128         return true;
129     }
130 
131 	// 把_addr加到锁定账户里，拉黑名单。。。
132     function addLock(address _addr) public onlyOwner returns (bool success){
133         require(_addr!=msg.sender);
134         locked[_addr]=true;
135         return true;
136     }
137 
138 	//设置vip用户
139     function setExclude(address _addr,bool _enable) public onlyOwner returns (bool success){
140         exclude[_addr]=_enable;
141         return true;
142     }
143 
144 	//解锁_addr用户
145     function removeLock(address _addr) public onlyOwner returns (bool success){
146         locked[_addr]=false;
147         return true;
148     }
149 	//控制合约 核心实现
150     modifier transferAllowed(address _addr) {
151         if (!exclude[_addr]) {
152             require(transferEnabled,"transfer is not enabeled now!");
153             if(lockFlag){
154                 require(!locked[_addr],"you are locked!");
155             }
156         }
157         _;
158     }
159 
160 }
161 
162 //端午节，代币离骚
163 contract LiSaoToken is StandardToken,Controlled {
164 
165 	//账户集合
166 	mapping (address => uint256) public balanceOf;
167 	mapping (address => mapping (address => uint256)) internal allowed;
168 	
169 	constructor() public {
170         totalSupply = 1000000000;//10亿
171         name = "LiSao Token";
172         symbol = "LS";
173         decimals = 0;
174         balanceOf[msg.sender] = totalSupply;
175     }
176 
177     function transfer(address _to, uint256 _value) public transferAllowed(msg.sender) returns (bool success) {
178 		require(_to != address(0));
179 		require(_value <= balanceOf[msg.sender]);
180 
181         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
182         balanceOf[_to] = balanceOf[_to].add(_value);
183         emit Transfer(msg.sender, _to, _value);
184         return true;
185     }
186 
187     function transferFrom(address _from, address _to, uint256 _value) public transferAllowed(_from) returns (bool success) {
188 		require(_to != address(0));
189         require(_value <= balanceOf[_from]);
190         require(_value <= allowed[_from][msg.sender]);
191 
192         balanceOf[_from] = balanceOf[_from].sub(_value);
193         balanceOf[_to] = balanceOf[_to].add(_value);
194         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
195         emit Transfer(_from, _to, _value);
196         return true;
197     }
198 
199     function approve(address _spender, uint256 _value) public returns (bool success) {
200         allowed[msg.sender][_spender] = _value;
201         emit Approval(msg.sender, _spender, _value);
202         return true;
203     }
204 
205     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
206       return allowed[_owner][_spender];
207     }
208 
209 }