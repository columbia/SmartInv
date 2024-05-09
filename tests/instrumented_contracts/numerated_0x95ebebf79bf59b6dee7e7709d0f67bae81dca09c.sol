1 pragma solidity >=0.4.22 <0.6.0;
2 
3 contract BWSERC20
4 {
5     string public standard = 'https://leeks.cc';
6     string public name="Bretton Woods system"; //代币名称
7     string public symbol="BWS"; //代币符号
8     uint8 public decimals = 18;  //代币单位，展示的小数点后面多少个0,和以太币一样后面是是18个0
9     uint256 public totalSupply=100000000 ether; //代币总量
10     
11     address st_owner;
12     address st_owner1;
13 
14     uint256 public st_bws_pool;//币仓
15     uint256 public st_ready_for_listing;//准备上市　
16     bool st_unlock_owner=false;
17     bool st_unlock_owner1=false;
18     address st_unlock_to;
19     address st_unlock_to1;
20     
21     mapping (address => uint256) public balanceOf;
22     mapping (address => mapping (address => uint256)) public allowance;
23     mapping (address => uint32) public CredibleContract;//可信任的智能合约，主要是后期的游戏之类的
24     /* 在区块链上创建一个事件，用以通知客户端*/
25     event Transfer(address indexed from, address indexed to, uint256 value);  //转帐通知事件
26     event Burn(address indexed from, uint256 value);  //减去用户余额事件
27     
28     
29     constructor (address owner1)public
30     {
31         st_owner=msg.sender;
32         st_owner1=owner1;
33         
34         st_bws_pool = 70000000 ether;
35         st_ready_for_listing = 14000000 ether;
36         
37         balanceOf[st_owner]=8000000 ether;
38         balanceOf[st_owner1]=8000000 ether;
39     }
40     
41     function _transfer(address _from, address _to, uint256 _value) internal {
42 
43       //避免转帐的地址是0x0
44       require(_to != address(0x0));
45       //检查发送者是否拥有足够余额
46       require(balanceOf[_from] >= _value);
47       //检查是否溢出
48       require(balanceOf[_to] + _value > balanceOf[_to]);
49       //保存数据用于后面的判断
50       uint previousBalances = balanceOf[_from] + balanceOf[_to];
51       //从发送者减掉发送额
52       balanceOf[_from] -= _value;
53       //给接收者加上相同的量
54       balanceOf[_to] += _value;
55       //通知任何监听该交易的客户端
56       emit Transfer(_from, _to, _value);
57       //判断买、卖双方的数据是否和转换前一致
58       assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
59     }
60     
61     function transfer(address _to, uint256 _value) public {
62         _transfer(msg.sender, _to, _value);
63     }
64     
65     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
66         //检查发送者是否拥有足够余额
67         require(_value <= allowance[_from][msg.sender]);   // Check allowance
68 
69         allowance[_from][msg.sender] -= _value;
70 
71         _transfer(_from, _to, _value);
72 
73         return true;
74     }
75     
76     function approve(address _spender, uint256 _value) public returns (bool success) {
77         
78         allowance[msg.sender][_spender] = _value;
79         return true;
80     }
81     
82     //管理员可以解锁1400万币到指定地址
83     function unlock_listing(address _to) public
84     {
85         require(_to != address(0x0),"参数中传入了空地址");
86         //解锁1400万，需要两个管理员同时解锁才行
87         if(msg.sender==st_owner)
88         {
89             st_unlock_owner=true;
90             st_unlock_to=_to;
91         }
92         else if(msg.sender==st_owner1)
93         {
94             st_unlock_owner1=true;
95             st_unlock_to1=_to;
96         }
97         
98         if(st_unlock_owner =true && st_unlock_owner1==true && st_unlock_to !=address(0x0) && st_unlock_to==st_unlock_to1)
99         {
100             //满足了解锁条件
101             if(st_ready_for_listing==14000000 ether)
102                 {
103                     st_ready_for_listing=0;
104                     balanceOf[_to]+=14000000 ether;
105                 }
106             
107         }
108     }
109     //管理员指定可信的合约地址，这些地址可以进行一些敏感操作，比如从币仓取走股币发放给指定玩家
110     function set_CredibleContract(address tract_address) public
111     {
112         require(tract_address != address(0x0),"参数中传入了空地址");
113         //需要两个管理员同时设置才行
114         if(msg.sender==st_owner)
115         {
116             if(CredibleContract[tract_address]==0)CredibleContract[tract_address]=2;
117             else if(CredibleContract[tract_address]==3)CredibleContract[tract_address]=1;
118         }
119         if(msg.sender==st_owner1 )
120         {
121             if(CredibleContract[tract_address]==0)CredibleContract[tract_address]=3;
122             else if(CredibleContract[tract_address]==2)CredibleContract[tract_address]=1;
123         }
124     }
125     
126     //从币仓取出指定量的bws给指定玩家
127     function TransferFromPool(address _to ,uint256 _value)public
128     {
129         require(CredibleContract[msg.sender]==1,"非法的调用");
130         require(_value<=st_bws_pool,"要取出的股币数量太多");
131         
132         st_bws_pool-=_value;
133         balanceOf[_to] +=_value;
134         emit Transfer(address(this), _to, _value);
135     }
136 }