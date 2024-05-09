1 /**
2  *Submitted for verification at Etherscan.io on 2019-09-09
3  * BEB dapp for www.betbeb.com www.bitbeb.com
4 */
5 pragma solidity^0.4.24;  
6 interface tokenTransfer {
7     function transfer(address receiver, uint amount);
8     function transferFrom(address _from, address _to, uint256 _value);
9     function balanceOf(address receiver) returns(uint256);
10 }
11 
12 contract Ownable {
13   address public owner;
14  
15     function Ownable () public {
16         owner = msg.sender;
17     }
18  
19     modifier onlyOwner {
20         require (msg.sender == owner);
21         _;
22     }
23  
24     /**
25      * @param  newOwner address
26      */
27     function transferOwnership(address newOwner) onlyOwner public {
28         if (newOwner != address(0)) {
29         owner = newOwner;
30       }
31     }
32 }
33 
34 contract BEBmining is Ownable{
35 tokenTransfer public bebTokenTransfer; //代币 
36     uint8 decimals = 18;
37    struct BebUser {
38         address customerAddr;
39         uint256 amount; 
40         uint256 bebtime;
41         uint256 interest;
42     }
43     //ETH miner
44     struct miner{
45         uint256 mining;
46         //uint256 _mining;
47         uint256 lastDate;
48         uint256 ethbomus;
49         uint256 amountTotal;
50     }
51     mapping(address=>miner)public miners;
52     address[]public minersArray;
53     uint256 ethExchuangeRate=210;//eth-usd
54     uint256 bebethexchuang=105000;//beb-eth
55     uint256 bebethex=100000;//eth-beb
56     uint256 bounstotal;
57     uint256 TotalInvestment;
58     uint256 sumethbos;
59     uint256 depreciationTime=86400;
60     uint256 SellBeb;//SellBeb MAX 10000BEB
61     uint256 BuyBeb;//BuyBeb MAX 100000BEB
62     uint256 IncomePeriod=730;//Income period
63     event bomus(address to,uint256 amountBouns,string lx);
64     function BEBmining(address _tokenAddress){
65          bebTokenTransfer = tokenTransfer(_tokenAddress);
66      }
67     //BUY minter
68     function BebTomining(uint256 _value,address _addr)public{
69         uint256 usdt=_value*ethExchuangeRate/bebethexchuang;
70         uint256 _udst=usdt* 10 ** 18;
71         miner storage user=miners[_addr];
72         require(usdt>50);
73         if(usdt>4900){
74            usdt=_value*ethExchuangeRate/bebethexchuang*150/100;
75            _udst=usdt* 10 ** 18;
76         }else{
77             if (usdt > 900){
78                     usdt = _value * ethExchuangeRate / bebethexchuang * 130 / 100;
79                     _udst=usdt* 10 ** 18;
80                 }
81                 else{
82                     if (usdt > 450){
83                         usdt = _value * ethExchuangeRate / bebethexchuang * 120 / 100;
84                          _udst=usdt* 10 ** 18;
85                     }
86                     else{
87                         if (usdt > 270){
88                             usdt = _value * ethExchuangeRate / bebethexchuang * 110 / 100;
89                              _udst=usdt* 10 ** 18;
90                         }
91                     }
92                 }
93             }
94         bebTokenTransfer.transferFrom(_addr,address(this),_value * 10 ** 18);
95         TotalInvestment+=_udst;
96         user.mining+=_udst;
97         //user._mining+=_udst;
98         user.lastDate=now;
99         bomus(_addr,_udst,"Purchase success!");
100     }
101     function freeSettlement()public{
102         miner storage user=miners[msg.sender];
103         uint256 amuont=user.mining;
104         //uint256 _amuontmin=user.mining;
105         require(amuont>0,"You don't have a mining machine");
106         uint256 _ethbomus=user.ethbomus;
107         uint256 _lastDate=user.lastDate;
108         //uint256 _ethbos=0;
109         uint256 _amountTotal=user.amountTotal;
110         uint256 sumincome=_amountTotal*100/amuont;
111         uint256 depreciation=(now-_lastDate)/depreciationTime;
112         require(depreciation>0,"Less than 1 day of earnings");
113         //The expiration of the income period, the mining machine scrapped
114         uint256 Bebday=amuont*depreciation/100;
115         uint256 profit=Bebday/ethExchuangeRate;
116         require(profit>0,"Mining amount 0");
117         if(sumincome>IncomePeriod){
118            //Mining machine scrap
119            user.mining=0;
120            user.lastDate=0;
121            user.ethbomus=0;
122            sumethbos=0;
123            user.amountTotal=0;
124         }else{
125             require(this.balance>profit,"Insufficient contract balance");
126             user.lastDate=now;
127             user.ethbomus+=Bebday;
128             user.amountTotal+=Bebday;
129             bounstotal+=profit;
130             user.ethbomus=0;
131             sumethbos=0;
132            msg.sender.transfer(profit);  
133         }
134         
135     }
136      function querBalance()public view returns(uint256){
137          return this.balance;
138      }
139     function querYrevenue()public view returns(uint256,uint256,uint256,uint256,uint256){
140         miner storage user=miners[msg.sender];
141         uint256 _amuont=user.mining;
142         uint256 _amountTotal=user.amountTotal;
143         if(_amuont==0){
144             percentage=0;
145         }else{
146         uint256 percentage=100-(_amountTotal*100/_amuont*100/730);    
147         }
148         uint256 _lastDate=user.lastDate;
149         uint256 dayzmount=_amuont/100;
150         uint256 depreciation=(now-_lastDate)/depreciationTime;
151         //require(depreciation>0,"Less than 1 day of earnings");
152         uint256  Bebday=_amuont*depreciation/100;
153                  sumethbos=Bebday;
154 
155         uint256 profit=sumethbos/ethExchuangeRate;
156         return (percentage,dayzmount/ethExchuangeRate,profit,user.amountTotal/ethExchuangeRate,user.lastDate);
157     }
158     function ModifyexchangeRate(uint256 sellbeb,uint256 buybeb,uint256 _ethExchuangeRate,uint256 maxsell,uint256 maxbuy) onlyOwner{
159         ethExchuangeRate=_ethExchuangeRate;
160         bebethexchuang=sellbeb;
161         bebethex=buybeb;
162         SellBeb=maxsell* 10 ** 18;
163         BuyBeb=maxbuy* 10 ** 18;
164         
165     }
166     // sellbeb-eth
167     function sellBeb(uint256 _sellbeb)public {
168         uint256 _sellbebt=_sellbeb* 10 ** 18;
169          require(_sellbeb>0,"The exchange amount must be greater than 0");
170          require(_sellbeb<SellBeb,"More than the daily redemption limit");
171          uint256 bebex=_sellbebt/bebethexchuang;
172          require(this.balance>bebex,"Insufficient contract balance");
173          bebTokenTransfer.transferFrom(msg.sender,address(this),_sellbebt);
174          msg.sender.transfer(bebex);
175     }
176     //buyBeb-eth
177     function buyBeb() payable public {
178         uint256 amount = msg.value;
179         uint256 bebamountub=amount*bebethex;
180         require(getTokenBalance()>bebamountub);
181         bebTokenTransfer.transfer(msg.sender,bebamountub);  
182     }
183     function queryRate() public view returns(uint256,uint256,uint256,uint256,uint256){
184         return (ethExchuangeRate,bebethexchuang,bebethex,SellBeb,BuyBeb);
185     }
186     function TotalRevenue()public view returns(uint256,uint256) {
187      return (bounstotal,TotalInvestment/ethExchuangeRate);
188     }
189     function setioc(uint256 _value)onlyOwner{
190         IncomePeriod=_value;
191     }
192     event messageBetsGame(address sender,bool isScuccess,string message);
193     function getTokenBalance() public view returns(uint256){
194          return bebTokenTransfer.balanceOf(address(this));
195     }
196     function withdrawAmount(uint256 amount) onlyOwner {
197         uint256 _amountbeb=amount* 10 ** 18;
198         require(getTokenBalance()>_amountbeb,"Insufficient contract balance");
199        bebTokenTransfer.transfer(owner,_amountbeb);
200     } 
201     function ETHwithdrawal(uint256 amount) payable  onlyOwner {
202        uint256 _amount=amount* 10 ** 18;
203        require(this.balance>_amount,"Insufficient contract balance");
204       owner.transfer(_amount);
205     }
206     function ()payable{
207         
208     }
209 }