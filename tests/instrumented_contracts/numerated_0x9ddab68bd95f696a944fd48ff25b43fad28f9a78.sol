1 pragma solidity ^0.4.20;
2 
3 interface tokenRecipient { 
4     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; 
5     
6 }
7 
8 contract owned {
9     address public owner;
10    
11     constructor () public{
12         owner = msg.sender;
13     }
14    
15     modifier onlyOwner {
16         require (msg.sender == owner);
17         _;
18     }
19   
20     function transferOwnership(address newOwner) onlyOwner public{
21         owner = newOwner;
22     }
23 }
24 
25 contract token {
26     
27     mapping (address => uint256) public balanceOf;
28     mapping (address => mapping (address => uint256)) public allowance;
29   
30     event Transfer(address indexed from, address indexed to, uint256 value);  //转帐通知事件
31 
32     constructor () public{
33       
34     }
35 
36     function _transfer(address _from, address _to, uint256 _value) internal {
37       //避免转帐的地址是0x0
38       require(_to != 0x0);
39       //检查发送者是否拥有足够余额
40       require(balanceOf[_from] >= _value);
41       //检查是否溢出
42       require(balanceOf[_to] + _value > balanceOf[_to]);
43       //保存数据用于后面的判断
44       uint previousBalances = balanceOf[_from] + balanceOf[_to];
45       //从发送者减掉发送额
46       balanceOf[_from] -= _value;
47       //给接收者加上相同的量
48       balanceOf[_to] += _value;
49       //通知任何监听该交易的客户端
50       emit Transfer(_from, _to, _value);
51       //判断买、卖双方的数据是否和转换前一致
52       assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
53     }
54   
55     function transfer(address _to, uint256 _value) public {
56         _transfer(msg.sender, _to, _value);
57     }
58     
59     function transferFrom(address _from, address _to, uint256 _value)public returns (bool success) {
60         //检查发送者是否拥有足够余额
61         require(_value <= allowance[_from][msg.sender]);   // Check allowance
62         allowance[_from][msg.sender] -= _value;
63         _transfer(_from, _to, _value);
64         return true;
65     }
66   
67     function approve(address _spender, uint256 _value) public returns (bool success) {
68         allowance[msg.sender][_spender] = _value;
69         return true;
70     }
71  
72     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
73         tokenRecipient spender = tokenRecipient(_spender);
74         if (approve(_spender, _value)) {
75             spender.receiveApproval(msg.sender, _value, this, _extraData);
76             return true;
77         }
78     }
79   
80     
81 }
82 
83 contract SKT is owned, token {
84     string public name = 'KOREA TEAM'; //代币名称
85     string public symbol = 'SKT'; //代币符号比如'$'
86     uint8 public decimals = 18;  //代币单位，展示的小数点后面多少个0,和以太币一样后面是是18个0
87     uint256 public totalSupply; //代币总量
88     uint256 initialSupply =1000000;
89   
90     //是否冻结帐户的列表
91     mapping (address => bool) public frozenAccount;
92     //定义一个事件，当有资产被冻结的时候，通知正在监听事件的客户端
93     event FrozenFunds(address target, bool frozen);
94     event Burn(address indexed from, uint256 value);  //减去用户余额事件
95    
96     constructor () token () public {
97         //初始化总量
98         totalSupply = initialSupply * 10 ** uint256(decimals);    //以太币是10^18，后面18个0，所以默认decimals是18
99         //给指定帐户初始化代币总量，初始化用于奖励合约创建者
100         //balanceOf[msg.sender] = totalSupply;
101         balanceOf[this] = totalSupply;
102         //设置合约的管理者
103         //if(centralMinter != 0 ) owner = centralMinter;
104       
105     }
106     
107     function _transfer(address _from, address _to, uint _value) internal {
108         //避免转帐的地址是0x0
109         require (_to != 0x0);
110         //检查发送者是否拥有足够余额
111         require (balanceOf[_from] > _value);
112         //检查是否溢出
113         require (balanceOf[_to] + _value > balanceOf[_to]);
114         //检查 冻结帐户
115         require(!frozenAccount[_from]);
116         require(!frozenAccount[_to]);
117         //从发送者减掉发送额
118         balanceOf[_from] -= _value;
119         //给接收者加上相同的量
120         balanceOf[_to] += _value;
121         //通知任何监听该交易的客户端
122         emit Transfer(_from, _to, _value);
123     }
124     
125     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
126         //给指定地址增加代币，同时总量也相加
127         balanceOf[target] += mintedAmount;
128         totalSupply += mintedAmount;
129         emit Transfer(0, this, mintedAmount);
130         emit Transfer(this, target, mintedAmount);
131     }
132     
133     function freezeAccount(address target, bool freeze) onlyOwner public {
134         frozenAccount[target] = freeze;
135         emit FrozenFunds(target, freeze);
136     }
137     
138     function burn(uint256 _value) public returns (bool success) {
139         //检查帐户余额是否大于要减去的值
140         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
141         //给指定帐户减去余额
142         balanceOf[msg.sender] -= _value;
143         //代币问题做相应扣除
144         totalSupply -= _value;
145         emit Burn(msg.sender, _value);
146         return true;
147     }
148   
149     function burnFrom(address _from, uint256 _value) public returns (bool success) {
150         //检查帐户余额是否大于要减去的值
151         require(balanceOf[_from] >= _value);
152         //检查 其他帐户 的余额是否够使用
153         require(_value <= allowance[_from][msg.sender]);
154         //减掉代币
155         balanceOf[_from] -= _value;
156         allowance[_from][msg.sender] -= _value;
157         //更新总量
158         totalSupply -= _value;
159         emit Burn(_from, _value);
160         return true;
161     }
162     
163    
164 }