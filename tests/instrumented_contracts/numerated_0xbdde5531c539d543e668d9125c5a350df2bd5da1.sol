1 pragma solidity ^0.4.25;
2 
3 contract wcgData{
4     function getUserWCG(address userAddr)public view returns(uint256);
5     function getLevel(uint256 series)external view returns(uint256);
6     function getT()external view returns(uint);
7     function getTotalWcg()external view returns(uint256);
8     function wcgTrunEth(uint wcg)external view returns(uint256);
9     function ethTrunWcg(uint256 price)external view returns(uint256);
10     function serviceCharge(uint256 eth)external pure returns(uint256,uint256);
11     function computingCharge(uint _eth)external pure returns(uint256);
12     function currentPrice()public view returns(uint256);
13     function getVoteBonusPool()external view returns(uint256);
14     function getWcgBonusPool()external view returns(uint256);
15     function indexIncrement()external returns(uint256);
16     function getAllOrdersLength()external view returns(uint);
17     function allOrders(uint256 index)external view returns(uint256);
18     function getUserOrders(uint256 _orderId)external view returns(address,uint256,uint256,uint256,uint256,uint256,uint256);
19     function getUserVips(address addr,uint index)external view returns(uint256,uint256,uint,uint256);
20     function getUserVipsLength(address addr)external view returns(uint256);
21     function wcgInfosOf(uint index)external view returns(address,uint256,uint256,uint8);
22     function getWcgInfosLength()external view returns(uint);
23 }
24 contract voteBonusSystem{
25     function drawProposalBouns(address addr)external returns(uint256);
26     function vote(address addr,uint index,uint wcg)external returns(bool);
27 }
28 contract everydayBonusSystem{
29     function bonusSystem(address addr) external returns(address,uint,uint256);
30 }
31 contract VIPSystem{
32     function paymentVipOfEth(address addr,uint256 series,uint256 value)external returns(address,uint256,uint256,uint256,uint,uint256);
33     function paymentVipOfWcg(address addr,uint256 series)external returns(address,uint256,uint256,uint256,uint,uint256);
34     function putaway(address addr,uint256 _vipId,uint256 price)external returns(uint256,uint,uint256,uint256);
35     function recall(uint256 orderId)external returns(bool);
36     function sellVip(address userAddr,uint256 orderId,uint256 value)external returns(uint256,address);
37 }
38 contract WCGSystem{
39     function buyWCG(address addr,uint256 _price)external returns(address,uint256,uint256,uint256);
40     function sellWCG(address addr,uint256 wcg) external returns(uint256,address,uint256,uint256,uint256);
41 }
42 contract WcgAsia{
43     address public owner;
44     wcgData data;
45     voteBonusSystem voteBonus;
46     everydayBonusSystem everydayBonus;
47     VIPSystem vip;
48     WCGSystem wcg;
49     event buyEvent(address addr,uint eth,uint wcg,uint256 __index);
50     event sellEvent(address addr,uint eth,uint wcg,uint256 __index);
51     event bonusEvent(address addr,uint bonus,uint256 __index);
52     event paymentVipEvent(address addr,uint256 series,uint256 createId,uint256 index,uint price,uint256 __index);
53     event orderEvent(address addr,uint256 series,uint price,uint256 orderId,uint256 __index,uint256 charge);
54     event recallEvent(uint256 __index);
55     event sellVipEvent(uint256 __index);
56     constructor(address wcgDataContract)public{
57       data = wcgData(wcgDataContract);
58       owner = msg.sender;
59     }
60    function setVoteBonusContract(address voteBonusAddr)public onlyOwner{
61        voteBonus = voteBonusSystem(voteBonusAddr);
62    }
63    function setEverydayBonusContract(address everydayBonusAddr)public onlyOwner{
64        everydayBonus = everydayBonusSystem(everydayBonusAddr);
65    }
66    function setVIPSystemContract(address vipAddr)public onlyOwner{
67        vip = VIPSystem(vipAddr);
68    }
69    function setWCGSystemContract(address wcgSystemAddr)public onlyOwner{
70        wcg = WCGSystem(wcgSystemAddr);
71    }
72    function ethbuyToKen(uint256 _price)public payable{
73        require(msg.value == _price);
74        (address _addr,uint _eth,uint _wcg,uint256 _index) = wcg.buyWCG(msg.sender,msg.value);
75        address(this).transfer(msg.value);
76        emit buyEvent(_addr,_eth,_wcg,_index);
77    }
78    function sell(uint256 _wcg)public{
79        (uint256 price,address _addr,uint256 _eth,uint256 __wcg,uint256 _index) = wcg.sellWCG(msg.sender,_wcg);
80        require(price != 0);
81        msg.sender.transfer(price);
82        emit sellEvent(_addr,_eth,__wcg,_index);
83    }
84    function totalSupply()public view returns(uint256){
85        return data.getTotalWcg();
86    }
87    function sellToken(uint _wcg)public view returns(uint256){
88        return data.wcgTrunEth(_wcg);
89    }
90    function ethTrunWcg(uint256 price)public view returns(uint256){
91        return data.ethTrunWcg(price);
92    }
93    function computingCharge(uint _eth)public view returns(uint256){
94        return data.computingCharge(_eth);
95    }
96    function currentPrice()public view returns(uint256){
97        return data.currentPrice();
98    }
99    function balanceOf(address who)public view returns(uint256){
100        return data.getUserWCG(who);
101    }
102    function wcgTrunEth(uint256 _wcg)public view returns(uint256){
103        return data.wcgTrunEth(_wcg);
104    }
105    function wcgInfosOf(uint index)public view returns(address,uint256,uint256,uint8){
106        return data.wcgInfosOf(index);
107    }
108    function getWcgInfosLength()public view returns(uint){
109         return data.getWcgInfosLength();
110    }
111   function bonusSystem() public{
112      (address _addr,uint256 _userBonus,uint256 _index)= everydayBonus.bonusSystem(msg.sender);
113      require(_userBonus != 0 );
114      msg.sender.transfer(_userBonus);
115      emit bonusEvent(_addr,_userBonus,_index);
116   }
117   function wcgBonusPool()public view returns(uint256){
118      return data.getWcgBonusPool();
119   }
120   function drawProposalBouns()public{
121       uint256 userBonus = voteBonus.drawProposalBouns(msg.sender);
122       require(userBonus != 0 );
123       msg.sender.transfer(userBonus);
124   }
125   function voteBonusPool()public view returns(uint256){
126       return data.getVoteBonusPool();
127   }
128   function vote(uint256 index,uint256 _wcg)public{
129       require(voteBonus.vote(msg.sender,index,_wcg));
130   }
131   function paymentVipOfEth(uint256 series)public payable{
132       if(data.getLevel(series)==0)revert();
133       if(msg.value < series*0.02 ether)revert();
134       (address addr,uint256 _series,uint256 createId,uint256 index,uint price,uint256 __index) = vip.paymentVipOfEth(msg.sender,series,msg.value);
135       address(this).transfer(msg.value);
136       emit paymentVipEvent(addr,_series,createId,index,price,__index);
137   }    
138   function paymentVipOfWcg(uint256 series)public{
139       if(data.getLevel(series)==0)revert();
140       if(data.getUserWCG(msg.sender) / data.getT() < series * 1)revert();
141       (address addr,uint256 _series,uint256 createId,uint256 index,uint price,uint256 __index) = vip.paymentVipOfWcg(msg.sender,series);
142       emit paymentVipEvent(addr,_series,createId,index,price,__index);
143   }
144   function putaway(uint256 _vipId,uint256 price)public{
145       (uint256 series,uint pc,uint256 _orderId,uint256 c) = vip.putaway(msg.sender,_vipId,price);
146       emit orderEvent(msg.sender,series,pc,_orderId,data.indexIncrement(),c);
147   }
148   function recall(uint256 orderId)public{
149       require(vip.recall(orderId));
150       emit recallEvent(data.indexIncrement());
151   }
152   function sellVip(uint256 orderId)public payable{
153       (uint256 price,address addr) = vip.sellVip(msg.sender,orderId,msg.value);
154       require(price != 0 && addr != 0x0);
155       address(addr).transfer(price);
156       emit sellVipEvent(data.indexIncrement());
157   }
158   function serviceCharge(uint256 eth)public view returns(uint256,uint256){
159       (uint256 price1,uint256 price2) = data.serviceCharge(eth);
160       return (price1,price2);
161   }
162   function getAllOrdersLength()public view returns(uint){
163       return data.getAllOrdersLength();
164   }
165   function allOrders(uint256 index)public view returns(uint256){
166       return data.allOrders(index);
167   }
168   
169   function userOrders(uint256 _orderId)public view returns(address,uint256,uint256,uint256,uint256,uint256,uint256){
170       return data.getUserOrders(_orderId);
171   }
172   function userVipsOf(address addr,uint index)public view returns(uint256,uint256,uint,uint256){
173       return data.getUserVips(addr,index);
174   }
175   function getUserVipsLength()public view returns(uint256){
176       return data.getUserVipsLength(msg.sender);
177   }
178   function level(uint256 series)public view returns(uint256){
179       return data.getLevel(series);
180   }
181   
182   function()public payable{}
183   function destroy()public onlyOwner {
184       selfdestruct(owner);
185   }
186   function withdraw()public onlyOwner{
187       owner.transfer(address(this).balance);
188   }
189   function recharge()public payable onlyOwner{
190       address(this).transfer(msg.value);
191   }
192   function getBalance()public view returns(uint){
193       return address(this).balance;
194   }
195    modifier onlyOwner(){
196       require(msg.sender == owner);
197       _;
198    }
199 }