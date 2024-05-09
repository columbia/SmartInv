1 /**
2  *Submitted for verification at Etherscan.io on 2019-09-09
3  * BEB dapp for www.betbeb.com
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
34 contract LUCKER is Ownable{
35 tokenTransfer public bebTokenTransfer; //代币 
36     uint8 decimals = 18;
37     uint256 opentime=now+3600;//开放时间
38     uint256 opensome;//设定次数
39     uint256 _opensome;//已经空投次数
40     uint256 BEBMAX;
41     uint256 BEBtime;
42     uint256 Numberofairdrops;
43     address ownersto;
44     //address owners;
45     struct luckuser{
46         uint256 _time;
47         uint256 _eth;
48         uint256 _beb;
49         uint256 _bz;
50         uint256 _romd;//随机数
51         uint256 Bond;
52         uint256 sumeth;
53         uint256 sumbeb;
54     }
55     mapping(address=>luckuser)public luckusers;
56     function LUCKER(address _tokenAddress,address _addr){
57          bebTokenTransfer = tokenTransfer(_tokenAddress);
58          ownersto=_addr;
59      }
60      function present()public{
61          require(tx.origin == msg.sender);
62          luckuser storage _user=luckusers[msg.sender];
63          require(_user.Bond>0,"Please air drop authorization");
64          if(_opensome>=opensome){
65              _opensome=0;
66          }
67          uint256 _times=now;
68          uint256 _usertime=now-_user._time;
69          require(_usertime>BEBtime || _user._time==0,"You can't air drop again, please wait 24 hours");
70          //生成随机数1~100
71          uint256 random2 = random(block.difficulty+_usertime+_times);
72          if(random2==88){
73                   _user._time=now;
74                   _user._eth=1 ether;
75                   _user._bz=1;
76                   _user._beb=0;
77                   _user._romd=random2;
78                   _opensome+=1;
79                   _user.sumbeb+=100*10**18;
80                   _user.sumeth+=1 ether;
81                   _user.Bond-=1;
82                   require(this.balance>=1 ether,"Insufficient contract balance");
83                   msg.sender.transfer(1 ether);
84                   bebTokenTransfer.transfer(msg.sender,100*10**18);
85          }else{
86              if(random2==55){
87                 _user._time=now;
88                   _user._eth=100000000000000000;
89                   _user._bz=1;
90                   _user._beb=0;
91                   _user._romd=random2;
92                   _opensome+=1;
93                   _user.sumbeb+=88*10**18;
94                   _user.sumeth+=100000000000000000;
95                   _user.Bond-=1;
96                   require(this.balance>=100000000000000000,"Insufficient contract balance");
97                   msg.sender.transfer(100000000000000000);
98                   bebTokenTransfer.transfer(msg.sender,88*10**18); 
99              }else{
100                  if(random2==22){
101                     _user._time=now;
102                   _user._eth=80000000000000000;
103                   _user._bz=1;
104                   _user._beb=0;
105                   _user._romd=random2;
106                   _opensome+=1;
107                   _user.sumbeb+=58*10**18;
108                   _user.sumeth+=80000000000000000;
109                   _user.Bond-=1;
110                   require(this.balance>=80000000000000000,"Insufficient contract balance");
111                   msg.sender.transfer(80000000000000000);
112                   bebTokenTransfer.transfer(msg.sender,58*10**18);  
113                  }else{
114                     _user._time=now;
115                   //uint256 ssll=random2-50;
116                   uint256 sstt=random2* 10 ** 18;
117                   uint256 rrr=sstt/2000;
118                  _user._eth=rrr;
119                  uint256 beb=random2* 10 ** 18;
120                  _user._beb=beb;
121                  _user._romd=random2;
122                   _user._bz=1;
123                   _opensome+=1;
124                   _user.sumbeb+=beb;
125                   _user.sumeth+=rrr;
126                   _user.Bond-=1;
127                   require(this.balance>=rrr,"Insufficient contract balance");
128                   msg.sender.transfer(rrr);
129                  bebTokenTransfer.transfer(msg.sender,beb);  
130                  }
131              }
132          }
133      }
134 
135      function getLUCK()public view returns(uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256){
136          luckuser storage _user=luckusers[msg.sender];
137          return (_user._time,_user._eth,_user._beb,_user._bz,_user._romd,opentime,_user.Bond,_user.sumeth,_user.sumbeb);
138      }
139     //buyBeb-eth
140     function getTokenBalance() public view returns(uint256){
141          return bebTokenTransfer.balanceOf(address(this));
142     }
143     function getTokenBalanceUser(address _addr) public view returns(uint256){
144          return bebTokenTransfer.balanceOf(address(_addr));
145     }
146     function gettime() public view returns(uint256,uint256,uint256,uint256){
147          return (opentime,Numberofairdrops,opensome,_opensome);
148     }
149     function querBalance()public view returns(uint256){
150          return this.balance;
151      }
152      function ETHwithdrawal(uint256 amount) payable  onlyOwner {
153        //uint256 _amount=amount* 10 ** 18;
154        require(this.balance>=amount,"Insufficient contract balance");
155        owner.transfer(amount);
156     }
157     function BEBwithdrawal(uint256 amount)onlyOwner {
158        uint256 _amount=amount* 10 ** 18;
159        bebTokenTransfer.transfer(owner,_amount);
160     }
161     function setLUCK(uint256 _opensome_,uint256 _time)onlyOwner{
162         opensome=_opensome_;
163         BEBtime=_time;
164         
165     }
166     function setAirdrop(address _addr,uint256 _opensome_)onlyOwner{
167         luckuser storage _user=luckusers[_addr];
168         _user.Bond-=_opensome_;
169         
170     }
171     function AirdropAuthorization(address _addr,uint256 _value)public{
172         require(tx.origin == msg.sender);
173         require(ownersto==msg.sender);
174         luckuser storage _user=luckusers[_addr];
175         _user.Bond+=_value;
176     }
177     //生成随机数
178      function random(uint256 randomyType)  internal returns(uint256 num){
179         uint256 random = uint256(keccak256(randomyType,now));
180          uint256 randomNum = random%101;
181          if(randomNum<1){
182              randomNum=1;
183          }
184          if(randomNum>100){
185             randomNum=100; 
186          }
187          
188          return randomNum;
189     }
190     function eth()payable{
191     }
192     function ()payable{
193     }
194 }