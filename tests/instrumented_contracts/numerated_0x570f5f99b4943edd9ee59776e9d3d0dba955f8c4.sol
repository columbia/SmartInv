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
11     uint256 public st_bws_pool;//币仓
12     uint256 public st_ready_for_listing;//准备上市　
13 
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16     mapping (address => uint32) public CredibleContract;//可信任的智能合约，主要是后期的游戏之类的
17     /* 在区块链上创建一个事件，用以通知客户端*/
18     event Transfer(address indexed from, address indexed to, uint256 value);  //转帐通知事件
19     event Burn(address indexed from, uint256 value);  //减去用户余额事件
20     
21     function _transfer(address _from, address _to, uint256 _value) internal;
22     
23     function transfer(address _to, uint256 _value) public ;
24     
25     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
26     
27     function approve(address _spender, uint256 _value) public returns (bool success) ;
28     
29     //管理员可以解锁1400万币到指定地址
30     function unlock_listing(address _to) public;
31     //管理员指定可信的合约地址，这些地址可以进行一些敏感操作，比如从币仓取走股币发放给指定玩家
32     function set_CredibleContract(address tract_address) public;
33     
34     //从币仓取出指定量的bws给指定玩家
35     function TransferFromPool(address _to ,uint256 _value)public;
36 }
37 
38 contract BWS_ICO
39 {
40     //address ad=address();
41     BWSERC20 public st_bws_erc = BWSERC20(0x95eBEBf79Bf59b6DeE7e7709D0F67Bae81DCA09C);//初始化该合约
42     uint160 private st_random;
43     uint32 private st_rnd_index=0;
44     event BackBWSNumber(address add_r,uint32 BWS,uint32 Bei);
45     event BSWtoETH(uint256 eth);
46     address payable st_admin;
47     //
48     constructor()public
49     {
50         st_admin=msg.sender;
51         st_random=uint160(msg.sender);
52     }
53     //随机数
54     function GetRandom(uint32 num)private returns(uint32)
55     {
56         require(num>0);
57         
58         uint32 [50] memory prime=[uint32(1),2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97,101,103,107,109,113,127,131,137,139,149,151,157,163,167,173,179,181,191,193,197,199,211,223,227];
59         uint160 random=st_random/2+uint160(msg.sender);
60         random/=prime[st_rnd_index];
61         st_random=uint160(ripemd160(abi.encode(random)));
62         uint32 ret=uint32(st_random % num);
63         if(++st_rnd_index==50)
64         {
65             st_rnd_index=0;
66         }
67         return ret;
68     }
69     //幸运大转盘
70     function wheel_of_fortune()public payable
71     {
72         require(msg.value>=0.02 ether,"每次游戏必须0.02ETH");
73         uint32 rnd=GetRandom(1000);//0~1000的随机数
74         uint32 multiple=0;
75         if(rnd<=50)multiple=5;
76         else if(rnd<=150)multiple=8;
77         else if(rnd<=650)multiple=10;
78         else if(rnd<=844)multiple=15;
79         else if(rnd<=944)multiple=20;
80         else if(rnd<=994)multiple=30;
81         else if(rnd<=999)multiple=50;
82         else if(rnd==1000)multiple=100;
83         
84         uint256 value=msg.value*10000;
85         require(multiple>=5 && multiple <=100,"随机数不正常");
86         value=value*multiple/10;
87         
88         uint256 this_bws=st_bws_erc.balanceOf(address(this));
89         assert(this_bws>=value);
90         
91         //提取一半资金
92         st_admin.transfer(msg.value/2);
93         
94         st_bws_erc.transfer(msg.sender,value);
95         
96         emit BackBWSNumber(msg.sender,uint32(value/10000000000000000),multiple);
97     }
98     //兑奖
99     function GetETHformBWS(uint256 bws)public
100     {
101         require(bws>0,"bws为0");
102         uint256 my_bws=st_bws_erc.balanceOf(msg.sender);
103         require(bws<=my_bws,"BWS数量不足");
104         address add=address(this);
105         uint256 pool_eth = add.balance;
106         require(pool_eth>=bws/20000,"兑币池资金不足");
107         
108         uint256 allowance=st_bws_erc.allowance(msg.sender,add);
109         require(allowance>=bws,"本合约权限不足，请给本合约授权");
110         
111         st_bws_erc.transferFrom(msg.sender,add,bws);
112         
113         msg.sender.transfer(bws/20000);
114         
115         emit BSWtoETH(bws/20000);
116     }
117     //销毁合约
118     function DeleteContract()public
119     {
120         require(msg.sender==st_admin);
121         st_bws_erc.transfer(st_admin,st_bws_erc.balanceOf(address(this)));
122           
123         selfdestruct(st_admin);
124     }
125 }