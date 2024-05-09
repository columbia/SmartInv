1 /**
2  *Submitted for verification at Etherscan.io on 2019-06-28
3 */
4 
5 pragma solidity >=0.4.22 <0.6.0;
6 
7 contract game_3733
8 {
9     string public standard = 'https://3733.net.cn';
10     string public name="3733游戏链"; 
11     string public symbol="B33"; 
12     uint8 public decimals = 18;  
13     uint256 public totalSupply=6000000000 ether; 
14     address payable s_owner;
15     
16     mapping (address => uint256) public balanceOf;
17     mapping (address => mapping (address => uint256)) public allowance;
18     
19     struct USER_DATE
20     {
21         uint8 flags;
22         uint256 feng_hong_timer;
23     }
24     mapping(address => USER_DATE)public s_user;
25     
26     uint32 s_index=2;
27    
28     event Transfer(address indexed from, address indexed to, uint256 value);  
29     event Burn(address indexed from, uint256 value); 
30     
31     event Transfer_2(address from,address to ,uint256 value,uint256 from_p,uint256 to_p);//转账通知挖矿事件
32     event ev_feng_hong(address ad,uint256 value);
33     event ev_delete_bws(address ad,uint256 value);
34     event ev_get_tang_guo(address ad);
35     event ev_shi_mu(address ad,uint256 eth_value,uint256 bws_value);
36     
37     uint256 public tang_guo  =3000000 ether;
38     uint256 public shi_mu    =50000000 ether;
39     uint256 public wa_kuang  =300000000 ether;
40     uint256 public fen_hong  =150000000 ether;
41     uint256 public game_fang =50000000 ether;
42     uint256 public xiao_hui_bws=500000000 ether;
43     constructor ()public
44     {
45         s_owner=msg.sender;
46         balanceOf[s_owner]=47000000  ether;
47         s_user[s_owner].flags=1;
48     }
49     function()external payable
50     {
51         
52         if(msg.value==0)
53         {
54             
55             if(s_user[msg.sender].flags==1)
56             {
57                 uint256 t=now;
58                 if(t-s_user[msg.sender].feng_hong_timer>2592000)
59                 {
60                     s_user[msg.sender].feng_hong_timer=t;
61                     
62                     uint256 f=balanceOf[msg.sender]/100000000;
63                     f=balanceOf[msg.sender]/(1 ether) *f;
64                     if(f>10000 ether)f=10000 ether;
65                     if(fen_hong>=f)
66                     {
67                         fen_hong-=f;
68                         balanceOf[msg.sender]+=f;
69                         emit ev_feng_hong(msg.sender,f);
70                     }
71                 }
72             }
73            
74             if(tang_guo>=(300 ether) && (s_user[msg.sender].flags==0))
75             {
76                 s_user[msg.sender].flags=1;
77                 tang_guo-=300 ether;
78                 balanceOf[msg.sender]=300 ether;
79                 emit ev_get_tang_guo(msg.sender);
80             }
81         }
82         else if(msg.value>=0.01 ether)
83         {
84             assert(shi_mu>=msg.value*100000);
85             shi_mu-=msg.value*100000;
86             uint256 last=balanceOf[msg.sender];
87             balanceOf[msg.sender]+=msg.value*100000;
88             assert(last< balanceOf[msg.sender]);
89             emit ev_shi_mu(msg.sender,msg.value,msg.value*100000);
90         }
91     }
92     function _transfer(address _from, address _to, uint256 _value) internal {
93 
94       
95       require(_to != address(0x0));
96       require(s_user[_from].flags!=2 &&  s_user[_from].flags!=3);
97       require(s_user[_to].flags!=3);
98     
99       require(balanceOf[_from] >= _value);
100 
101       require(balanceOf[_to] + _value > balanceOf[_to]);
102   
103       uint256 p=(_value/100000000)*(balanceOf[_from]/(1 ether));
104       if(p>_value/10)p=_value/10;
105       if(wa_kuang<p/100*5)p=0;
106   
107       uint previousBalances = balanceOf[_from] + balanceOf[_to]+p/100*105;
108 
109     balanceOf[_from] -= (_value-p);
110     wa_kuang-=p/100*105;
111     balanceOf[_to] += (_value+p/100*5);
112 
113     emit Transfer(_from, _to, _value);
114     emit  Transfer_2(_from,_to ,_value,p,p/100*5);
115     assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
116 
117     }
118     
119     function transfer(address _to, uint256 _value) public {
120         _transfer(msg.sender, _to, _value);
121     }
122     
123     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
124         require(_value <= allowance[_from][msg.sender]); 
125 
126         allowance[_from][msg.sender] -= _value;
127 
128         _transfer(_from, _to, _value);
129 
130         return true;
131     }
132     
133     function approve(address _spender, uint256 _value) public returns (bool success) {
134         
135         allowance[msg.sender][_spender] = _value;
136         return true;
137     }
138     
139     function set_gamer(address ad,uint8 value)public
140     {
141         require(ad!=address(0x0));
142         require(msg.sender==s_owner);
143         s_user[ad].flags=value;
144     }
145 
146     function delete_bws(uint256 value)public
147     {
148         require (balanceOf[msg.sender]>=value);
149         require (xiao_hui_bws >= value);
150         balanceOf[msg.sender]-=value;
151         xiao_hui_bws-=value;
152         emit ev_delete_bws(msg.sender,value);
153     }
154     function safe_add(uint256 value1,uint256 value2)internal pure returns(uint256)
155     {
156         uint256 ret=value2+value1;
157         assert(ret>=value1);
158         return ret;
159     }
160     function safe_sub(uint256 value1,uint256 value2)internal pure returns(uint256)
161     {
162         uint256 ret=value1-value2;
163         assert(ret<=value1);
164         return ret;
165     }
166     //bws获取
167     function get_bws(uint8 flags,uint256 value) public
168     {
169         require(msg.sender==s_owner);
170         
171         if(flags==1)
172         {
173             tang_guo=safe_sub(tang_guo,value);
174             balanceOf[msg.sender]=safe_add(balanceOf[msg.sender],value);
175         }
176         else if(flags==2)
177         {
178             balanceOf[msg.sender]=safe_sub(balanceOf[msg.sender],value);
179             tang_guo=safe_add(tang_guo,value);
180         }
181         else if(flags==3)
182         {
183             tang_guo=safe_sub(shi_mu,value);
184             balanceOf[msg.sender]=safe_add(balanceOf[msg.sender],value);
185         }
186         else if(flags==4)
187         {
188             balanceOf[msg.sender]=safe_sub(balanceOf[msg.sender],value);
189             tang_guo=safe_add(shi_mu,value);
190         }
191         else if(flags==5)
192         {
193             tang_guo=safe_sub(wa_kuang,value);
194             balanceOf[msg.sender]=safe_add(balanceOf[msg.sender],value);
195         }
196         else if(flags==6)
197         {
198             balanceOf[msg.sender]=safe_sub(balanceOf[msg.sender],value);
199             tang_guo=safe_add(wa_kuang,value);
200         }
201         else if(flags==7)
202         {
203             tang_guo=safe_sub(fen_hong,value);
204             balanceOf[msg.sender]=safe_add(balanceOf[msg.sender],value);
205         }
206         else if(flags==8)
207         {
208             balanceOf[msg.sender]=safe_sub(balanceOf[msg.sender],value);
209             tang_guo=safe_add(fen_hong,value);
210         }
211         else if(flags==9)
212         {
213             tang_guo=safe_sub(game_fang,value);
214             balanceOf[msg.sender]=safe_add(balanceOf[msg.sender],value);
215         }
216         else if(flags==10)
217         {
218             balanceOf[msg.sender]=safe_sub(balanceOf[msg.sender],value);
219             tang_guo=safe_add(game_fang,value);
220         }
221     }
222     
223     function get_eth() public
224     {
225         uint256 balance=address(this).balance;
226         s_owner.transfer(balance);
227     }
228 
229 }