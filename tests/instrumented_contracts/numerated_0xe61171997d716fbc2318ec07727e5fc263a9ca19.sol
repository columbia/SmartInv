1 pragma solidity >=0.4.22 <0.6.0;
2 contract Anow_TokenERC20 {
3     string public name = 'Anow';
4     string public symbol = 'Anow';
5     uint8 public decimals = 18;
6     uint256 public totalSupply=3000000 ether;
7     mapping (address => uint256) public balanceOf; 
8     mapping (address => mapping (address => uint256)) public allowance;
9     event Transfer(address indexed from, address indexed to, uint256 value);
10     function _transfer(address _from, address _to, uint _value) internal {
11         require(sys_info.start_time > 0);
12         require(_to !=address(0x0));
13         require(balanceOf[_from] >= _value);
14         require(balanceOf[_to] + _value > balanceOf[_to]);
15 
16         uint previousBalances = balanceOf[_from] + balanceOf[_to]; 
17         balanceOf[_from] -= _value;
18         balanceOf[_to] += _value;
19         emit Transfer(_from, _to, _value); 
20         require(balanceOf[_from] + balanceOf[_to] == previousBalances);  
21     }
22 
23     function transfer(address _to, uint256 _value) public {
24         _transfer(msg.sender, _to, _value); 
25     }
26 
27     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
28         require(_value <= allowance[_from][msg.sender]); 
29         allowance[_from][msg.sender] -= _value;
30         _transfer(_from, _to, _value);
31         return true;
32     }
33 
34     function approve(address _spender, uint256 _value) public
35         returns (bool success) {
36         allowance[msg.sender][_spender] = _value; 
37         return true;
38     }
39     function safe_add(uint256 a,uint256 b)private pure returns(uint256)
40     {
41         uint256 c = a + b;
42         require(c >= a && c >= b);
43         return c;
44         
45     }
46     function safe_sub(uint256 a,uint256 b)private pure returns(uint256)
47     {
48         require(b <= a);
49         return a - b;
50         
51     }
52     function safe_mul(uint256 a, uint256 b) internal pure returns (uint256) {
53         if (a == 0) {
54             return 0;
55         }
56         uint256 c = a * b;
57         require(c / a == b);
58         return c;
59     }
60     function safe_div(uint256 a, uint256 b) internal pure returns (uint256) {
61         require(b > 0);
62         uint256 c = a / b; 
63         require(a == b * c + a % b);
64         return c;
65     }
66     struct SYSTEM_INFO{
67         uint32 start_time;
68         uint32 count;
69         uint256 total_power;
70         uint256 total_lock;
71         mapping(uint32 =>uint256) day_power;
72     }
73     struct USER_INFO{
74         uint32 index;
75         uint32 flags;
76         uint32 father_index;
77         uint256 lock_Anow;
78         uint32 lock_time;
79         uint256 power;
80         uint256 fa_power;
81         uint256 last_Income;
82         uint256 total_Income;
83         uint32 team_pople;
84         uint32 lower_level_pople;
85         uint256 team_mining;
86         uint256 lower_level_mining;
87     }
88     SYSTEM_INFO public sys_info;
89     address admin;
90     address owner1;
91     address owner2;
92     address owner3;
93     uint32 private team_time;
94     uint256 private team_number=3000000 ether;
95     mapping(address =>bool) public votes;
96     mapping(address => USER_INFO) public user_info;
97     mapping(uint32 => address) public user_addr;    
98     constructor () public {
99         admin == msg.sender;
100         owner1=address(0x166451fFd5F53d2691e0734bEF2f3503747380B9);
101         owner2=address(0xBfd86108B9ee107912BDa9689D15A39A8b6F0E0b);
102         owner3=address(0x45104F63D25198358E2c0efbAE57a96E2A44771F);
103         balanceOf[msg.sender]=10000 ether;
104         balanceOf[owner1] = 10000 ether;
105         balanceOf[owner2]=2970000 ether;
106         balanceOf[owner3]=10000 ether;
107         sys_info.count=1;
108         user_info[msg.sender].index = sys_info.count;
109         uint32 n=uint32(msg.sender);
110         uint32 n1=n % 26+65;
111         uint32 n2=(n>>10) %26+65;
112         uint32 n3 =(n >> 20) % 26 +65;
113         user_info[msg.sender].flags =(n1<<16) +(n2<<8) +n3;
114         user_info[msg.sender].lock_time=uint32(now/86400);
115         user_addr[sys_info.count]=msg.sender; 
116         create_user(owner1,1,user_info[msg.sender].flags);
117         create_user(owner2,1,user_info[msg.sender].flags);
118         create_user(owner3,1,user_info[msg.sender].flags);
119     }
120 
121     function get_father_flags(address ad)public view returns(uint32 father_flags)
122     {
123         USER_INFO storage fa_u=user_info[user_addr[user_info[ad].father_index]];
124         return fa_u.flags;
125     }
126     function get_5day_power(uint32 first_day)public view returns(
127         uint256 power1,uint256 power2,uint256 power3,uint256 power4,uint256 power5)
128     {
129         return(sys_info.day_power[first_day],
130                sys_info.day_power[first_day+1],
131                sys_info.day_power[first_day+2],
132                sys_info.day_power[first_day+3],
133                sys_info.day_power[first_day+4]
134             );
135     }
136     //记录当天算力
137     function set_power()public
138     {
139         uint32 cur_day=uint32(now/86400);
140         sys_info.day_power[cur_day]=sys_info.total_power;
141     }
142     
143     //------------------------------------------------------------------
144     function create_user(address my_ad,uint32 fa_index,uint32 fa_flags)internal returns(uint32 index,uint32 father)
145     {
146         if(user_info[my_ad].index>0){
147             return(user_info[my_ad].index,user_info[my_ad].father_index);
148         }
149         require(fa_index !=0 && fa_flags !=0);
150         address ad=user_addr[fa_index];
151         require(ad!=address(0x0));
152         require(user_info[ad].flags == fa_flags);
153         sys_info.count++;
154         user_info[my_ad].index = sys_info.count;
155         uint32 n=uint32(my_ad);
156         uint32 n1=n % 26+65;
157         uint32 n2=(n>>10) %26+65;
158         uint32 n3 =(n >> 20) % 26 +65;
159         user_info[my_ad].flags =(n1<<16) +(n2<<8) +n3;
160         user_info[my_ad].father_index = fa_index;
161         user_addr[sys_info.count]=my_ad;
162         USER_INFO storage fu=user_info[user_addr[fa_index]];
163         fu.lower_level_pople+=1;
164         for(uint32 i=0;i<4;i++)
165         {
166             if(fu.father_index == 0)break;
167             fu=user_info[user_addr[fu.father_index]];
168             fu.team_pople+=1;
169         }
170         return(user_info[my_ad].index,user_info[my_ad].father_index);
171     }
172     function deposits(uint32 father_index,uint32 father_flags, uint256 balance)public
173     {
174         require(balance <= balanceOf[msg.sender]);
175         USER_INFO storage user=user_info[msg.sender];
176         require(user.lock_Anow == 0);
177         require(balance >100);
178         uint32 my_index;
179         uint32 fa_index;
180         (my_index,fa_index)=create_user(msg.sender,father_index,father_flags);
181         require(my_index > 0 && (fa_index >0 || my_index ==1));
182         balanceOf[msg.sender]-=balance;
183         totalSupply=safe_sub(totalSupply,balance);
184         user.lock_Anow=balance;
185         user.power=safe_add(user.power,balance);
186         sys_info.total_lock=safe_add(sys_info.total_lock,balance);
187         uint256 total_power=balance;
188         user.lock_time=uint32(now/86400);
189         uint256 pow;
190         USER_INFO storage fu=user;
191         for(uint32 i=0;i<5;i++)
192         {
193             if(fu.father_index==0)break;
194             fu=user_info[user_addr[fu.father_index]];
195             if(i==0)
196             {
197                 pow=balance / 5;
198                 if(pow > fu.lock_Anow )pow=fu.lock_Anow;
199                 user.fa_power=pow;
200             }
201             else if(i==1)pow=balance/10;
202             else if(i==2)pow=balance/20;
203             else if(i==3)pow=balance/50;
204             else if(i==4)pow=balance/100;
205             fu.power=safe_add(fu.power,pow);
206             total_power=safe_add(total_power,pow);
207         }
208         sys_info.total_power=safe_add(sys_info.total_power,total_power);
209     }
210     function undeposits()public
211     {
212         USER_INFO storage user=user_info[msg.sender];
213         uint32 first_day=user.lock_time>sys_info.start_time?user.lock_time:sys_info.start_time;
214         uint32 cur_day= uint32(now/86400);
215         require(user.lock_Anow >= 100 ether);
216         require(user.lock_time>0 && sys_info.start_time > 0);
217         require(first_day + 5 <= cur_day);
218         uint256 income;
219         uint256 temp;
220         for(uint32 i=0;i<5;i++)
221         {
222             if(sys_info.day_power[first_day+i] == 0)sys_info.day_power[first_day+i]=sys_info.day_power[first_day+i-1];
223             require(sys_info.day_power[first_day+i] > 0);
224             temp=8800 ether *1 ether;
225             temp=safe_div(temp,sys_info.day_power[first_day+i]);
226             temp=safe_mul(temp,user.power);
227             temp=temp / (1 ether);
228             income=safe_add(income,temp);
229         }
230         USER_INFO storage fu=user;
231         uint256 pow;
232         uint256 total_power;
233         for(uint32 i=0;i<5;i++)
234         {
235             if(fu.father_index ==0)break;
236             fu=user_info[user_addr[fu.father_index]];
237             if(i==0)
238             {
239                 pow=user.fa_power;
240             }
241             else if(i==1)pow=user.lock_Anow/10;
242             else if(i==2)pow=user.lock_Anow/20;
243             else if(i==3)pow=user.lock_Anow/50;
244             else if(i==4)pow=user.lock_Anow/100;
245             fu.power=safe_sub(fu.power,pow);
246             total_power=safe_add(total_power,pow);
247             if(i==0)
248                 fu.lower_level_mining=safe_add(fu.lower_level_mining,income);
249             else
250                 fu.team_mining=safe_add(fu.team_mining,income);
251         }
252         sys_info.total_power=safe_sub(sys_info.total_power,total_power+user.lock_Anow);
253         user.last_Income=income;
254         user.total_Income=safe_add(user.total_Income,income);
255         user.lock_time=0;
256         income=safe_add(user.lock_Anow,income);
257         balanceOf[msg.sender]=safe_add(balanceOf[msg.sender],income);
258         totalSupply=safe_add(totalSupply,income);
259         sys_info.total_lock=safe_sub(sys_info.total_lock,user.lock_Anow);
260         user.power=safe_sub(user.power,user.lock_Anow);
261         user.lock_Anow=0;
262     }
263     function set_node(address ad,uint256 balance)public
264     {
265         require(balance <= balanceOf[msg.sender]);
266         USER_INFO storage user=user_info[msg.sender];
267         USER_INFO storage chid=user_info[ad];
268         require(user.index > 0);
269         require(chid.father_index == 0 || chid.father_index == user.index);
270         create_user(ad,user.index,user.flags);
271         balanceOf[msg.sender]=safe_sub(balanceOf[msg.sender],balance);
272         balanceOf[ad]=safe_add(balanceOf[ad],balance);
273     }
274     function set_node_balance(uint32 node,uint256 retain)public
275     {
276         require(sys_info.start_time == 0);
277         require(msg.sender == admin);
278         require(node>0 && node <=sys_info.count);
279         address ad=user_addr[node];
280         if(user_info[ad].lock_Anow > 0)
281             sys_info.total_lock=safe_sub(sys_info.total_lock,user_info[ad].lock_Anow);
282         user_info[ad].lock_Anow=0;
283         uint256 total_balan=totalSupply;
284         if(balanceOf[ad]>0)
285         {
286             total_balan=safe_add(total_balan,retain);
287             total_balan=safe_sub(total_balan,balanceOf[ad]);
288             totalSupply=total_balan;
289         }
290         balanceOf[ad]=retain;
291     }
292     function start()public
293     {
294         require(sys_info.start_time==0);
295         sys_info.start_time=uint32(now/86400);
296         team_time=sys_info.start_time;
297     }
298     function team_mining()public
299     {
300         require(msg.sender==admin);
301         require(sys_info.start_time > 0);
302         uint32 cur_time=uint32(now / 86400);
303         require(cur_time - team_time >=30);
304         require(cur_time - sys_info.start_time < 900);
305         team_time+=30;
306         totalSupply=safe_add(totalSupply,100000 ether);
307         balanceOf[owner2]=safe_add(balanceOf[owner2],100000 ether);
308     }
309 
310     function team_mining1(uint256 value)public
311     {
312         require(msg.sender==admin);
313         require(value <= team_number);
314         team_number=safe_sub(team_number,value);
315         balanceOf[admin]=safe_add(balanceOf[admin],value);
316         totalSupply=safe_add(totalSupply,value);
317     }
318     
319     function owner_vote()public
320     {
321         require(msg.sender == admin || msg.sender == owner1 || msg.sender==owner2 || msg.sender == owner3);
322         votes[msg.sender]=true;
323     }
324     function get_team_mining()public
325     {
326         require((votes[admin] == true && votes[owner1]==true) ||
327             (votes[owner1]==true && votes[owner2]==true && votes[owner3]==true));
328         uint256 temp = safe_sub(team_time,sys_info.start_time) /30;
329         require (temp < 30);
330         temp = 30- temp;
331         temp =temp *100000 ether;
332         totalSupply = safe_add(totalSupply,temp);
333         balanceOf[owner1]=safe_add(balanceOf[owner1],temp);
334         team_time += 10000;
335     }
336 }