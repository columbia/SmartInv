1 pragma solidity >=0.4.22 <0.6.0;
2 
3 contract ThreeLeeks {
4     struct STR_NODE
5         {
6             address payable addr;
7             uint32 ID;
8             uint32 faNode;//父节点
9             uint32 brNode;//兄弟节点
10             uint32 chNode;//子节点
11             uint256 Income;//获得的收入
12             uint32 Subordinate;//总下级数
13         }
14     struct PRIZE_RECORD
15     {
16         address addr;//获得奖地址　
17         uint32 NodeNumber;//获奖的Node编号
18         uint256 EthGained;//获状金额
19     }
20     //有人加入产生事件  推荐人/加入人员的编号/加入时间
21     event HaveAdd(uint32 Recommender,uint32 Number,uint64 Add_Time);
22     //执行奖励 获奖人编号/获奖金额/奖励编号
23     event OnReward(uint32 Awardee,uint256 PrizeMoney,uint32 PrizeNumber);
24     
25     mapping (uint32 => STR_NODE) private Node;//结点映射
26     mapping (uint32 => PRIZE_RECORD)private PrizeRecord;
27     uint32 NodeIndex;//当前映射
28     uint32 PrizeIndex;//当前获奖记录
29     uint64 NodeAddTime;//最后一次加入的时间
30     bool IsDistribution;//奖池计时是否开始
31     address payable ContractAddress;
32     /* Initializes contract with initial supply tokens to the creator of the contract */
33     constructor  () public {//构造方法
34         NodeIndex=0;
35         PrizeIndex=0;
36         Node[0]=STR_NODE(msg.sender,0,0,0,0,0,0);
37         NodeIndex=10;
38         for (uint32 i=1;i<=10;i++)
39         {
40             Node[i]=STR_NODE(msg.sender,i,0,0,0,0,0);
41         }
42         ContractAddress=address(uint160(address(this)));
43     }
44   
45     /*  本函数注入资金,Recommender是投资人的推荐人编号*/
46     function CapitalInjection(uint32 Recommender)public payable
47     {
48         uint32 index;
49         require(Recommender>=0 && Recommender<NodeIndex,"Recommenders do not exist");
50         if(msg.value!=0.99 ether)
51         {
52             msg.sender.transfer(msg.value);
53             emit HaveAdd(0,0,uint64(now));
54             return ;
55         }
56         NodeAddTime=uint64(now);
57         NodeIndex+=1;
58         //奖池计时开始
59         if(IsDistribution==true)IsDistribution=false;
60         //把推荐人设为当前投资者的上线
61         Node[NodeIndex]=STR_NODE(msg.sender,NodeIndex,Recommender,0,0,0,0);
62             
63         if(Node[Recommender].chNode<=0)//如果推荐人还没有下线
64         {//把当前投资者设为推荐人的下线
65             Node[Recommender].chNode=NodeIndex;
66         }
67         else//如果推荐人已经有了下线
68         {
69             index=Node[Recommender].chNode;
70             while (Node[index].brNode>0)//循环查找直到推荐人的子节点没有兄弟节点
71             {
72                 index=Node[index].brNode;
73             }
74             Node[index].brNode=NodeIndex;//把当前投资者设为推荐人的下线的兄弟
75         }
76 
77         //到这里，已实现了节点上下线关系，开始转帐
78         index=Node[NodeIndex].faNode;
79         Node[index].addr.transfer(0.3465 ether);//直接上级提取0.999*35%
80         Node[index].Income+=0.3465 ether;
81         Node[index].Subordinate+=1;
82         index=Node[index].faNode;
83         for (uint32 i=0;i<10;i++)
84         {
85             Node[index].addr.transfer(0.0495 ether);//间接上级提取0.999*5%
86             Node[index].Income+=0.0495 ether;
87             if(index!=0) Node[index].Subordinate+=1;
88             index=Node[index].faNode;//index指向父节点
89         }
90         Node[0].addr.transfer(0.0495 ether);
91         
92         //有人加入产生事件
93         emit HaveAdd(Recommender,NodeIndex,NodeAddTime);
94     }
95     //本函数由部署者调用，用于准许部分人免费加入
96     function FreeAdmission(address addr,uint32 index)public returns (bool)
97     {
98         //只能由部署者执行
99         require (msg.sender==Node[0].addr,"This function can only be called by the deployer");
100         //部署者也只能修改编号为前10的
101         require (index>0 && index<=10,"Users who can only modify the first 10 numbers");
102         //把指定地址设置给某个编号
103         Node[index].addr=address(uint160(addr));
104         return true;
105     }
106     //本函数返回奖池资金总额度
107     function GetPoolOfFunds()public view returns(uint256)
108     {
109         return ContractAddress.balance;
110     }
111     //本函数返回自己的Index
112     function GetMyIndex() public view returns(uint32)
113     {
114         for(uint32 i=0 ;i<=NodeIndex;i++)
115         {    if(msg.sender==Node[i].addr)
116             {
117                 return i;
118             }
119         }
120         return 0;
121     }
122     //返回我的总收入
123     function GetMyIncome() public view returns(uint256)
124     {
125         uint32 ret=GetMyIndex();
126         return Node[ret].Income;
127     }
128     //返回我的推荐人
129     function GetMyRecommend() public view returns(uint32)
130     {
131         uint32 ret=GetMyIndex();
132         return Node[ret].faNode;
133     }
134     //返回我的下级总人数
135     function GetMySubordinateNumber(uint32 ID)public view returns(uint32)
136     {
137         uint32 index;
138         if(ID>0 && ID<=NodeIndex)
139         {
140             index=ID;
141         }
142         else
143             {index=GetMyIndex();}
144         return Node[index].Subordinate;
145     }
146     //返回直接下级数
147     function GetMyRecommendNumber(uint32 ID)public view returns(uint32)
148     {
149         uint32 index;
150         if(ID>0 && ID<=NodeIndex)
151         {
152             index=ID;
153         }
154         else
155             {index=GetMyIndex();}
156         uint32 Number;
157         if(Node[index].chNode>0)
158         {
159             Number=1;
160             index=Node[index].chNode;
161             while (Node[index].brNode>0)
162             {
163                 Number++;
164                 index=Node[index].brNode;
165             }
166         }
167     return Number;
168     }
169     //返回总人数
170     function GetAllPeopleNumber()public view returns(uint32)
171     {
172         return NodeIndex;
173     }
174     //分配资金池50%的资金到最后账户
175     function DistributionMoney() public payable
176     {
177         require(ContractAddress.balance>0,"There is no capital in the pool.");
178         if(IsDistribution==false && now-NodeAddTime>86400)
179         {
180             IsDistribution=true;
181             Node[NodeIndex].addr.transfer((ContractAddress.balance)/2);
182             Node[NodeIndex].Income+=ContractAddress.balance;
183             PrizeRecord[PrizeIndex]=PRIZE_RECORD(Node[NodeIndex].addr,NodeIndex,ContractAddress.balance);
184             emit OnReward(NodeIndex,ContractAddress.balance,PrizeIndex);
185             PrizeIndex++;
186         }
187     }
188     //销毁合约
189     function DeleteContract() public payable
190     {
191         require(msg.sender==Node[0].addr,"This function can only be called by the deployer");
192         uint256 AverageMoney=ContractAddress.balance/NodeIndex;
193         for (uint32 i=0;i<NodeIndex;i++)
194         {
195             Node[i].addr.transfer(AverageMoney);
196         }
197         selfdestruct(Node[0].addr);
198         
199     }
200     //返回最后一个人加入时间
201     function GetLastAddTime()public view returns(uint64)
202     {
203         return NodeAddTime;
204     }
205 
206 }