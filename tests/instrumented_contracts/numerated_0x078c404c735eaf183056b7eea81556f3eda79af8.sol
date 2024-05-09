1 /**
2  *Submitted for verification at Etherscan.io on 2019-09-09
3  * BEB dapp for www.betbeb.com www.bitbeb.com
4 */
5 pragma solidity^0.4.20;  
6 //实例化代币
7 interface tokenTransfer {
8     function transfer(address receiver, uint amount);
9     function transferFrom(address _from, address _to, uint256 _value);
10     function balanceOf(address receiver) returns(uint256);
11 }
12 
13 contract Ownable {
14   address public owner;
15   bool lock = false;
16  
17  
18     /**
19      * 初台化构造函数
20      */
21     function Ownable () public {
22         owner = msg.sender;
23     }
24  
25     /**
26      * 判断当前合约调用者是否是合约的所有者
27      */
28     modifier onlyOwner {
29         require (msg.sender == owner);
30         _;
31     }
32  
33     /**
34      * 合约的所有者指派一个新的管理员
35      * @param  newOwner address 新的管理员帐户地址
36      */
37     function transferOwnership(address newOwner) onlyOwner public {
38         if (newOwner != address(0)) {
39         owner = newOwner;
40       }
41     }
42 }
43 
44 contract BebPos is Ownable{
45 
46     //会员数据结构
47    struct BebUser {
48         address customerAddr;//会员address
49         uint256 amount; //存款金额 
50         uint256 bebtime;//存款时间
51         //uint256 interest;//利息
52     }
53     uint256 Bebamount;//BEB未发行数量
54     uint256 bebTotalAmount;//BEB总量
55     uint256 sumAmount = 0;//会员的总量 
56     uint256 OneMinuteBEB;//初始化1分钟产生BEB数量
57     tokenTransfer public bebTokenTransfer; //代币 
58     uint8 decimals = 18;
59     uint256 OneMinute=1 minutes; //1分钟
60     //会员 结构 
61     mapping(address=>BebUser)public BebUsers;
62     address[] BebUserArray;//存款的地址数组
63     //事件
64     event messageBetsGame(address sender,bool isScuccess,string message);
65     //BEB的合约地址 
66     function BebPos(address _tokenAddress,uint256 _Bebamount,uint256 _bebTotalAmount,uint256 _OneMinuteBEB){
67          bebTokenTransfer = tokenTransfer(_tokenAddress);
68          Bebamount=_Bebamount*10**18;//初始设定为发行数量
69          bebTotalAmount=_bebTotalAmount*10**18;//初始设定BEB总量
70          OneMinuteBEB=_OneMinuteBEB*10**18;//初始化1分钟产生BEB数量 
71          BebUserArray.push(_tokenAddress);
72      }
73          //存入 BEB
74     function BebDeposit(address _addr,uint256 _value) public{
75         //判断会员存款金额是否等于0
76        if(BebUsers[msg.sender].amount == 0){
77            //判断未发行数量是否大于20个BEB
78            if(Bebamount > OneMinuteBEB){
79            bebTokenTransfer.transferFrom(_addr,address(address(this)),_value);//存入BEB
80            BebUsers[_addr].customerAddr=_addr;
81            BebUsers[_addr].amount=_value;
82            BebUsers[_addr].bebtime=now;
83            sumAmount+=_value;//总存款增加
84            //加入存款数组地址
85            //addToAddress(msg.sender);//加入存款数组地址
86            messageBetsGame(msg.sender, true,"转入成功");
87             return;   
88            }
89            else{
90             messageBetsGame(msg.sender, true,"转入失败,BEB总量已经全部发行完毕");
91             return;   
92            }
93        }else{
94             messageBetsGame(msg.sender, true,"转入失败,请先取出合约中的余额");
95             return;
96        }
97     }
98 
99     //取款
100     function redemption() public {
101         address _address = msg.sender;
102         BebUser storage user = BebUsers[_address];
103         require(user.amount > 0);
104         //
105         uint256 _time=user.bebtime;//存款时间
106         uint256 _amuont=user.amount;//个人存款金额
107            uint256 AA=(now-_time)/OneMinute*OneMinuteBEB;//现在时间-存款时间/60秒*每分钟生产20BEB
108            uint256 BB=bebTotalAmount-Bebamount;//计算出已流通数量
109            uint256 CC=_amuont*AA/BB;//存款*AA/已流通数量
110            //判断未发行数量是否大于20BEB
111            if(Bebamount > OneMinuteBEB){
112               Bebamount-=CC; 
113              //user.interest+=CC;//向账户增加利息
114              user.bebtime=now;//重置存款时间为现在
115            }
116         //判断未发行数量是否大于20个BEB
117         if(Bebamount > OneMinuteBEB){
118             Bebamount-=CC;//从发行总量当中减少
119             sumAmount-=_amuont;
120             bebTokenTransfer.transfer(msg.sender,CC+user.amount);//转账给会员 + 会员本金+当前利息 
121            //更新数据 
122             BebUsers[_address].amount=0;//会员存款0
123             BebUsers[_address].bebtime=0;//会员存款时间0
124             //BebUsers[_address].interest=0;//利息归0
125             messageBetsGame(_address, true,"本金和利息成功取款");
126             return;
127         }
128         else{
129             Bebamount-=CC;//从发行总量当中减少
130             sumAmount-=_amuont;
131             bebTokenTransfer.transfer(msg.sender,_amuont);//转账给会员 + 会员本金 
132            //更新数据 
133             BebUsers[_address].amount=0;//会员存款0
134             BebUsers[_address].bebtime=0;//会员存款时间0
135             //BebUsers[_address].interest=0;//利息归0
136             messageBetsGame(_address, true,"BEB总量已经发行完毕，取回本金");
137             return;  
138         }
139     }
140     function getTokenBalance() public view returns(uint256){
141          return bebTokenTransfer.balanceOf(address(this));
142     }
143     function getSumAmount() public view returns(uint256){
144         return sumAmount;
145     }
146     function getBebAmount() public view returns(uint256){
147         return Bebamount;
148     }
149     function getBebAmountzl() public view returns(uint256){
150         uint256 _sumAmount=bebTotalAmount-Bebamount;
151         return _sumAmount;
152     }
153 
154     function getLength() public view returns(uint256){
155         return (BebUserArray.length);
156     }
157      function getUserProfit(address _form) public view returns(address,uint256,uint256,uint256){
158        address _address = _form;
159        BebUser storage user = BebUsers[_address];
160        assert(user.amount > 0);
161        uint256 A=(now-user.bebtime)/OneMinute*OneMinuteBEB;
162        uint256 B=bebTotalAmount-Bebamount;
163        uint256 C=user.amount*A/B;
164         return (_address,user.bebtime,user.amount,C);
165     }
166     function()payable{
167         
168     }
169 }