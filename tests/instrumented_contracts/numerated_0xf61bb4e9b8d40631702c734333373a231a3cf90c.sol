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
34 contract LUCK is Ownable{
35 tokenTransfer public bebTokenTransfer; //代币 
36     uint8 decimals = 18;
37     uint256 opentime=now+3600;//开放时间
38     uint256 opensome;//设定次数
39     uint256 _opensome;//已经空投次数
40     uint256 BEBMAX;
41     uint256 BEBtime;
42     uint256 Numberofairdrops;
43     //address owners;
44     struct luckuser{
45         uint256 _time;
46         uint256 _eth;
47         uint256 _beb;
48         uint256 _bz;
49         uint256 _romd;//随机数
50         uint256 Bond;
51     }
52     mapping(address=>luckuser)public luckusers;
53     function LUCK(address _tokenAddress){
54          bebTokenTransfer = tokenTransfer(_tokenAddress);
55      }
56      function present(uint256 _value)public{
57          require(_value==168168168,"Airdrop password error");
58          require(tx.origin == msg.sender);
59          luckuser storage _user=luckusers[msg.sender];
60          require(_user.Bond==1);
61          //luckuser storage _users=luckusers[owners];
62          require(now>opentime,"Airdrop not open");
63          if(_opensome>=opensome){
64              opentime=now+BEBtime;
65              _opensome=0;
66          }
67          uint256 _times=now;
68          uint256 _usertime=now-_user._time;
69          require(_usertime>86400 || _user._time==0,"You can't air drop again, please wait 24 hours");
70          //生成随机数1~100
71          uint256 random2 = random(block.difficulty+_usertime+_times);
72          if(random2>50){
73              if(random2==88){
74                   _user._time=now;
75                   _user._eth=1 ether;
76                   _user._bz=1;
77                   _user._beb=0;
78                   _user._romd=random2;
79                   _opensome+=1;
80                   require(this.balance>=1 ether,"Insufficient contract balance");
81                   msg.sender.transfer(1 ether);
82              }else{
83                   _user._time=now;
84                   uint256 ssll=random2-50;
85                   uint256 sstt=ssll* 10 ** 18;
86                   uint256 rrr=sstt/1000;
87                  _user._eth=rrr;
88                  uint256 beb=random2* 10 ** 18;
89                  _user._beb=beb;
90                  _user._romd=random2;
91                   _user._bz=1;
92                   _opensome+=1;
93                   require(this.balance>=rrr,"Insufficient contract balance");
94                   msg.sender.transfer(rrr);
95                  bebTokenTransfer.transfer(msg.sender,beb);
96              }
97          }else{
98               _user._bz=0;
99               _user._time=now;
100               _user._eth=0;
101               _user._beb=0;
102               _user._romd=random2;
103          }
104          
105      }
106      function setETH()payable public{
107          require(tx.origin == msg.sender);
108          uint256 _amount=msg.value;
109          require(_amount==100000000000000000);
110          luckuser storage _users=luckusers[msg.sender];
111          require(_users.Bond!=1);
112          _users.Bond=1;
113          Numberofairdrops+=1;
114      }
115      function refundETH()public{
116          require(tx.origin == msg.sender);
117          luckuser storage _users=luckusers[msg.sender];
118          require(_users.Bond==1);
119           uint256 _usertime=now-_users._time;
120          require(_usertime>86400,"Please apply for refund in 24 hours");
121          _users.Bond=0;
122          Numberofairdrops-=1;
123          msg.sender.transfer(100000000000000000);
124      }
125      function getLUCK()public view returns(uint256,uint256,uint256,uint256,uint256,uint256){
126          luckuser storage _user=luckusers[msg.sender];
127          return (_user._time,_user._eth,_user._beb,_user._bz,_user._romd,opentime);
128      }
129     //buyBeb-eth
130     function getTokenBalance() public view returns(uint256){
131          return bebTokenTransfer.balanceOf(address(this));
132     }
133     function getTokenBalanceUser(address _addr) public view returns(uint256){
134          return bebTokenTransfer.balanceOf(address(_addr));
135     }
136     function gettime() public view returns(uint256,uint256){
137          return (opentime,Numberofairdrops);
138     }
139     function querBalance()public view returns(uint256){
140          return this.balance;
141      }
142      function ETHwithdrawal(uint256 amount) payable  onlyOwner {
143        //uint256 _amount=amount* 10 ** 18;
144        require(this.balance>=amount,"Insufficient contract balance");
145        owner.transfer(amount);
146     }
147     function BEBwithdrawal(uint256 amount)onlyOwner {
148        uint256 _amount=amount* 10 ** 18;
149        bebTokenTransfer.transfer(owner,_amount);
150     }
151     function setLUCK(uint256 _opentime,uint256 _opensome_,uint256 _BEBtime)onlyOwner{
152         opentime=now+_opentime;
153         opensome=_opensome_;
154         BEBtime=_BEBtime;
155         
156     }
157     //生成随机数
158      function random(uint256 randomyType)  internal returns(uint256 num){
159         uint256 random = uint256(keccak256(randomyType,now));
160          uint256 randomNum = random%101;
161          if(randomNum<1){
162              randomNum=1;
163          }
164          if(randomNum>100){
165             randomNum=100; 
166          }
167          
168          return randomNum;
169     }
170     function ()payable{
171     }
172 }