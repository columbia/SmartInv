1 pragma solidity >=0.4.22 <0.6.0;
2 
3 contract ThreeLeeks {
4     struct STR_NODE
5         {
6             address payable addr;
7             uint32 ID;
8             uint32 faNode;//Parent node
9             uint32 brNode;//Brother Node
10             uint32 chNode;//Subnode
11             uint256 Income;//Income earned
12             uint32 Subordinate;//Total lower series
13         }
14     struct PRIZE_RECORD
15     {
16         address addr;//Award-winning user address　
17         uint32 NodeNumber;//Node Number of Award-winning User Address
18         uint256 EthGained;//The amount of bonus awarded
19     }
20     //Someone joins the referee who created the event / the number of the person who joined / the time of joining
21     event HaveAdd(uint32 Recommender,uint32 Number,uint64 Add_Time);
22     //Execution Award Winner Number/Award Amount/Award Number
23     event OnReward(uint32 Awardee,uint256 PrizeMoney,uint32 PrizeNumber);
24     
25     mapping (uint32 => STR_NODE) private Node;//
26     mapping (uint32 => PRIZE_RECORD)private PrizeRecord;
27     
28     uint32 NodeIndex;//Current node
29     uint64 NodeAddTime;//Last time to join
30     
31     address  ContractAddress;
32     uint160 Random;
33     uint64 PrizeTime1;
34     uint64 PrizeTime2;
35    //////////////////////////////////////////////////////////////
36     /* Initializes contract with initial supply tokens to the creator of the contract */
37     constructor  (address first_addr) public {
38         NodeIndex=0;
39 
40         Node[0]=STR_NODE(msg.sender,0,0,0,0,0,0);
41         Node[1]=STR_NODE(address(uint160(first_addr)),0,0,0,0,0,0);
42         
43         Random=uint160(Node[0].addr);
44         NodeIndex=100;
45         ContractAddress=address(uint160(address(this)));
46     }
47     //The top 100 leeks are sales teams. This function is called by contract deployer to increase or decrease sales staff.
48     function SetFreeRender(address addr,uint32 Number)public
49     {
50         require(msg.sender==Node[0].addr,"Can only be invoked by the deployer");
51         require(Number>1 && Number <=100,"Even in deployment, only the top 100 data can be modified. The top 100 are sales teams, real players from 101, and the data can not be modified.");
52         if(Node[Number].addr==address(0))
53             {
54                 Node[Number].addr=address(uint160(addr));
55             }
56         else
57             {
58                 Node[Number]=STR_NODE(address(uint160(addr)),0,0,0,0,0,0);
59             }
60         Node[Number].addr=address(uint160(addr));
61         
62     }
63     /*  This function injects capital. Recommender is the recommender number of the investor.*/
64     function CapitalInjection(uint32 Recommender_Number)public payable
65     {
66         uint32 index;
67         uint32 Recommender=unEncryption(Recommender_Number);
68         require(Recommender>=0 && Recommender<=NodeIndex,"Recommenders do not exist");
69         if(msg.value!=0.999 ether)
70         {
71             msg.sender.transfer(msg.value);
72             emit HaveAdd(0,0,uint64(now));
73             return ;
74         }
75         NodeAddTime=uint64(now);
76         NodeIndex+=1;
77 
78         //Setting Recommenders Up to the Line of Current Investors
79         Node[NodeIndex]=STR_NODE(msg.sender,NodeIndex,Recommender,0,0,0,0);
80             
81         if(Node[Recommender].chNode<=0)//If the referee is not offline
82         {//Offline current investors as referees
83             Node[Recommender].chNode=NodeIndex;
84         }
85         else//If the referee has already been offline
86         {
87             index=Node[Recommender].chNode;
88             while (Node[index].brNode>0)//Lookup until the recommender's child nodes have no siblings
89             {
90                 index=Node[index].brNode;
91             }
92             Node[index].brNode=NodeIndex;//Brothers who set current investors as referees
93         }
94 
95         //Up to this point, the connection between the node and the downline has been realized and the transfer has started.
96         index=Node[NodeIndex].faNode;
97         if(index<=1)
98         {
99             Node[0].addr.transfer(0.44955 ether);
100             Node[0].Subordinate+=1;
101             Node[0].Income+=0.44955 ether;
102             Node[1].addr.transfer(0.44955 ether);
103             Node[1].Income+=0.44955 ether;
104             Node[1].Subordinate+=1;
105         }
106         else
107         {
108             Node[index].addr.transfer(0.34965 ether);//Direct superior extraction 0.999*35%
109             Node[index].Income+=0.34965 ether;
110             Node[index].Subordinate+=1;
111             index=Node[index].faNode;
112             for (uint8 i=0;i<10;i++)
113             {
114                 if(index<=1)
115                 {
116                     Node[0].addr.transfer((10-i)*0.0495 ether/2);
117                     Node[0].Subordinate+=1;
118                     Node[0].Income+=(10-i)*0.0495 ether/2;
119                     Node[1].addr.transfer((10-i)*0.0495 ether/2);
120                     Node[1].Subordinate+=1;
121                     Node[1].Income+=(10-i)*0.0495 ether/2;
122                     break;
123                 }
124                 else
125                 {
126                     Node[index].addr.transfer(0.04995 ether);//Indirect superior extraction 0.999*5%
127                     Node[index].Income+=0.04995 ether;
128                     Node[index].Subordinate+=1;
129                     index=Node[index].faNode;//Index points to the parent node
130                 }
131             }
132             Node[0].addr.transfer(0.024975 ether);
133             Node[1].addr.transfer(0.024975 ether);
134         }
135         
136         //Incidents involving people
137         emit HaveAdd(Recommender_Number,NodeIndex,NodeAddTime);
138         
139         //Generating the cardinality of random numbers
140         Random=Random/2+uint160(msg.sender)/2;
141         
142         //Every two hundred people will be awarded a prize, with 9999 Finney as the prize and one first prize.
143         //4995 Finney, 2 first prize, 2997 Finney, 4 third prize, each 1998 Finney
144         if(NodeIndex > 1 && NodeIndex % 200 ==0)
145         {
146             PrizeTime1=uint64(now);
147             SendPrize(NodeIndex-uint32(Random % 200),4.995 ether,0);
148             SendPrize(NodeIndex-uint32(Random/3 % 200),1.4985 ether,1);
149             SendPrize(NodeIndex-uint32(Random/5 % 200),1.4985 ether,2);
150             SendPrize(NodeIndex-uint32(Random/7 % 200),0.4995 ether,3);
151             SendPrize(NodeIndex-uint32(Random/11 % 200),0.4995 ether,4);
152             SendPrize(NodeIndex-uint32(Random/13 % 200),0.4995 ether,5);
153             SendPrize(NodeIndex-uint32(Random/17 % 200),0.4995 ether,6);
154             
155         }
156         if(NodeIndex>1 && NodeIndex % 20000 ==0)  
157         {
158             uint256 mon=ContractAddress.balance;
159             
160             SendPrize(NodeIndex-uint32(Random/19 % 20000),mon/1000*250,7);
161             SendPrize(NodeIndex-uint32(Random/23 % 20000),mon/1000*75,8);
162             SendPrize(NodeIndex-uint32(Random/29 % 20000),mon/1000*75,9);
163             SendPrize(NodeIndex-uint32(Random/31 % 20000),mon/1000*25,10);
164             SendPrize(NodeIndex-uint32(Random/37 % 20000),mon/1000*25,11);
165             SendPrize(NodeIndex-uint32(Random/41 % 20000),mon/1000*25 ,12);
166             SendPrize(NodeIndex-uint32(Random/43 % 20000),mon/1000*25 ,13);
167             
168         }
169     }
170     //This function is responsible for awarding prizes.
171     function SendPrize(uint32 index,uint256 money,uint32 prize_index) private 
172     {
173         require(index>=0 && index<=NodeIndex);
174         require(money>0 && money<ContractAddress.balance);
175         require(prize_index>=0 && prize_index<=13);
176         
177         Node[index].addr.transfer(money);
178         
179         PrizeRecord[prize_index].addr=Node[index].addr;
180         PrizeRecord[prize_index].NodeNumber=index;
181         PrizeRecord[prize_index].EthGained=money;
182 
183     }
184     
185     //This function returns the total amount of money in the prize pool
186     function GetPoolOfFunds()public view returns(uint256)
187     {
188         return ContractAddress.balance;
189     }
190     //This function returns its recommended address
191     function GetMyIndex(address my_addr) public view returns(uint32)
192     {
193         for(uint32 i=0 ;i<=NodeIndex;i++)
194         {    if(my_addr==Node[i].addr)
195             {
196                 return Encryption(i);
197             }
198         }
199         return 0;
200     }
201     //Return my total income
202     function GetMyIncome(uint32 my_num) public view returns(uint256)
203     {
204         uint32 index=unEncryption(my_num);
205         require(index>=0 && index<NodeIndex,"Incorrect recommended address entered");
206         return Node[index].Income;
207     }
208     //Return to my referee
209     function GetMyRecommend(uint32 my_num) public view returns(uint32)
210     {
211         uint32 index=unEncryption(my_num);
212         require(index>=0 && index<NodeIndex);
213         return Encryption(Node[index].faNode);
214     }
215     //Return to the total number of my subordinates
216     function GetMySubordinateNumber(uint32 my_num)public view returns(uint32)
217     {
218         uint32 index=unEncryption(my_num);
219         require(index>=0 && index<NodeIndex);
220         return Node[index].Subordinate;
221     }
222     //Return direct lower series
223     function GetMyRecommendNumber(uint32 my_number)public view returns(uint32)
224     {
225         uint32 index;
226         uint32 my_num=unEncryption(my_number);
227         require(my_num>=0 && my_num<NodeIndex);
228         index=my_num;
229         uint32 Number;
230         if(Node[index].chNode>0)
231         {
232             Number=1;
233             index=Node[index].chNode;
234             while (Node[index].brNode>0)
235             {
236                 Number++;
237                 index=Node[index].brNode;
238             }
239         }
240     return Number;
241     }
242     //Return the total number of players
243     function GetAllPeopleNumber()public view returns(uint32)
244     {
245         return NodeIndex;
246     }
247     //Deployers can choose to destroy contracts, and eth in all pools of funds is evenly allocated to all players after the contract is destroyed.
248     function DeleteContract() public 
249     {
250         require(msg.sender==Node[0].addr,"This function can only be called by the deployer");
251         uint256 AverageMoney=ContractAddress.balance/NodeIndex;
252         for (uint32 i=0;i<NodeIndex;i++)
253         {
254             Node[i].addr.transfer(AverageMoney);
255         }
256         selfdestruct(Node[0].addr);
257         
258     }
259     //Return to the last person joining time
260     function GetLastAddTime()public view returns(uint64)
261     {
262         return NodeAddTime;
263     }
264     
265     function GetPrizeTime()public view returns(uint64,uint64)
266     {
267         return(PrizeTime1,PrizeTime2);
268     }
269     //This function returns the winning information
270     function GetPrizeText(uint8 prize_index)public view returns(
271             address addr0,
272             uint32 ID0,
273             uint256 money0
274             )
275     {
276         return (
277                 
278                 PrizeRecord[prize_index].addr,
279                 Encryption(PrizeRecord[prize_index].NodeNumber),
280                 PrizeRecord[prize_index].EthGained
281             );
282 
283     }
284     ///////////////////////////////////////////////////////////
285 //Coded as recommended address
286     function Encryption(uint32 num) private pure returns(uint32 com_num)
287    {
288        require(num<=8388607,"Maximum ID should not exceed 8388607");
289        uint32 flags;
290        uint32 p=num;
291        uint32 ret;
292        if(num<4)
293         {
294             flags=2;
295         }
296        else
297        {
298           if(num<=15)flags=7;
299           else if(num<=255)flags=6;
300           else if(num<=4095)flags=5;
301           else if(num<=65535)flags=4;
302           else if(num<=1048575)flags=3;
303           else flags=2;
304        }
305        ret=flags<<23;
306        if(flags==2)
307         {
308             p=num; 
309         }
310         else
311         {
312             p=num<<((flags-2)*4-1);
313         }
314         ret=ret | p;
315         return (ret);
316    }
317 //Decode to ID
318    function unEncryption(uint32 num)private pure returns(uint32 number)
319    {
320        uint32 p;
321        uint32 flags;
322        flags=num>>23;
323        p=num<<9;
324        if(flags==2)
325        {
326            if(num==16777216)return(0);
327            else if(num==16777217)return(1);
328            else if(num==16777218)return(2);
329            else if(num==16777219)return(3);
330            else 
331             {
332                 require(num>= 25690112 && num<66584576 ,"Illegal parameter, parameter position must be greater than 10 bits");
333                 p=p>>9;
334             }
335        }
336        else 
337        {
338             p=p>>(9+(flags-2)*4-1);
339        }
340      return (p);
341    }
342 }