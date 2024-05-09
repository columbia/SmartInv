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
37     uint256 opentime;//开放时间
38     uint256 opensome;//设定次数
39     uint256 _opensome;//已经空投次数
40     address owners;
41     struct luckuser{
42         uint256 _time;
43         uint256 _eth;
44         uint256 _beb;
45         uint256 _bz;
46         uint256 _romd;//随机数
47     }
48     mapping(address=>luckuser)public luckusers;
49     function LUCK(address _tokenAddress,address _owners){
50          bebTokenTransfer = tokenTransfer(_tokenAddress);
51          owners=_owners;
52      }
53      function present(uint256 _value,uint256 _aumont)public{
54          luckuser storage _users=luckusers[owners];
55          require(_users._bz==_value,"Airdrop password error");
56          require(now>opentime,"Airdrop not open");
57          require(_opensome<=opensome,"The airdrop is full");
58          luckuser storage _user=luckusers[msg.sender];
59          uint256 _usertime=now-_user._time;
60          require(_usertime>86400 || _user._time==0,"You can't air drop again, please wait 24 hours");
61          //生成随机数1~100
62          uint256 random2 = random(block.difficulty+_usertime+_aumont);
63          if(random2>50){
64              if(random2==88){
65                   _user._time=now;
66                   _user._eth=1 ether;
67                   _user._bz=1;
68                   _user._beb=0;
69                   _user._romd=random2;
70                   _opensome+=1;
71                   msg.sender.transfer(1 ether);
72              }else{
73                   _user._time=now;
74                   uint256 ssll=random2-50;
75                   uint256 sstt=ssll* 10 ** 18;
76                   uint256 rrr=sstt/1000;
77                  _user._eth=rrr;
78                  uint256 beb=random2* 10 ** 18;
79                  _user._beb=beb;
80                  _user._romd=random2;
81                   _user._bz=1;
82                   _opensome+=1;
83                   msg.sender.transfer(rrr);
84                  bebTokenTransfer.transfer(msg.sender,beb);
85              }
86          }else{
87               _user._bz=0;
88               _user._time=0;
89               _user._eth=0;
90               _user._beb=0;
91               _user._romd=random2;
92          }
93          
94      }
95      
96      function getLUCK()public view returns(uint256,uint256,uint256,uint256,uint256,uint256){
97          luckuser storage _user=luckusers[msg.sender];
98          return (_user._time,_user._eth,_user._beb,_user._bz,_user._romd,opentime);
99      }
100     //buyBeb-eth
101     function getTokenBalance() public view returns(uint256){
102          return bebTokenTransfer.balanceOf(address(this));
103     }
104     function gettime() public view returns(uint256){
105          return opentime;
106     }
107     function querBalance()public view returns(uint256){
108          return this.balance;
109      }
110     function ETHwithdrawal(uint256 amount) payable  onlyOwner {
111        //uint256 _amount=amount* 10 ** 18;
112        require(this.balance>=amount,"Insufficient contract balance");
113        owner.transfer(amount);
114     }
115     function BEBwithdrawal(uint256 amount) payable  onlyOwner {
116        uint256 _amount=amount* 10 ** 18;
117        bebTokenTransfer.transfer(owner,_amount);
118     }
119     function setLUCK(uint256 _opentime,uint256 _opensome_,uint256 _mima)onlyOwner{
120         luckuser storage _users=luckusers[owners];
121         opentime=now+_opentime;
122         opensome=_opensome_;
123         _users._bz=_mima;
124         _opensome=0;
125         
126     }
127     //生成随机数
128      function random(uint256 randomyType)  internal returns(uint256 num){
129         uint256 random = uint256(keccak256(randomyType,now));
130          uint256 randomNum = random%101;
131          if(randomNum<1){
132              randomNum=1;
133          }
134          if(randomNum>100){
135             randomNum=100; 
136          }
137          
138          return randomNum;
139     }
140     function ETH()payable public{
141         
142     }
143     function ()payable{
144         
145     }
146 }