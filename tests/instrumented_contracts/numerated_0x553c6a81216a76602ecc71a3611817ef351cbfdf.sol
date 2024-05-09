1 pragma solidity >=0.4.22 <0.6.0;
2 
3 contract YFIE
4 {
5     string public standard = 'http://www.yfie.cc/';
6     string public name="YFIE"; 
7     string public symbol="YFIE";
8     uint8 public decimals = 18; 
9     uint256 public totalSupply=83000 ether; 
10     
11     address st_owner;
12     mapping (address => uint256) public balanceOf;
13     mapping (address => mapping (address => uint256)) public allowance;
14     function transfer(address _to, uint256 _value) public ;
15     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
16     function approve(address _spender, uint256 _value) public returns (bool success) ;
17 }
18 
19 contract YFIE_MINER{
20 
21     string public standard = 'http://yfie.cc/';
22     string public name="ETHE"; 
23     string public symbol="ETHE";
24     uint8 public decimals = 18; 
25     uint256 public totalSupply=0;
26 
27     mapping (address => uint256) public balanceOf;
28     mapping (address => mapping (address => uint256)) public allowance;
29     event Transfer(address indexed from, address indexed to, uint256 value);
30     event Burn(address indexed from, uint256 value);
31 
32     function _transfer(address _from, address _to, uint256 _value) internal {
33       require(_to != address(0x0));
34       require(balanceOf[_from] >= _value);
35       require(balanceOf[_to] + _value > balanceOf[_to]);
36       uint previousBalances = balanceOf[_from] + balanceOf[_to];
37       balanceOf[_from] -= _value;
38       balanceOf[_to] += _value;
39       emit Transfer(_from, _to, _value);
40       assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
41     }
42     
43     function transfer(address _to, uint256 _value) public {
44         _transfer(msg.sender, _to, _value);
45     }
46     
47     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
48         require(_value <= allowance[_from][msg.sender]);   // Check allowance
49         allowance[_from][msg.sender] -= _value;
50         _transfer(_from, _to, _value);
51         return true;
52     }
53     
54     function approve(address _spender, uint256 _value) public returns (bool success) {
55         allowance[msg.sender][_spender] = _value;
56         return true;
57     }
58     
59 
60     YFIE public token;
61     struct OWNER{
62         address owner;
63         bool agreest;
64         bool exit;
65     }
66     struct VOTE{
67         address put_eth_addr;
68         address sponsor;
69         uint put_eth_value;
70         OWNER[3] owner;
71     }
72 
73     SYSTEM public sys;
74     address admin;
75     VOTE public owner;
76     event input_eth(address indexed addr,uint value);
77     
78     constructor () public{
79         
80         token = YFIE(0xA1B3E61c15b97E85febA33b8F15485389d7836Db);
81         
82         admin = msg.sender;
83         sys.stop_mine_time -=1;
84         sys.eth_to_yfie = 10000;
85         sys.out_eth_rate = 30;
86         
87         owner.owner[0].owner = 0xA1B3E61c15b97E85febA33b8F15485389d7836Db;
88         owner.owner[1].owner = 0x3cB77a6b17631385b6332B3f168174B12981a8a5;
89         owner.owner[2].owner = 0x90420e8F26c58721bF8f4281653AC8d5DE20b94a;
90     }
91     function ()external payable{
92         emit input_eth(msg.sender,msg.value);
93     }
94     modifier onlyOwner(){
95         require(msg.sender == owner.owner[0].owner || msg.sender == owner.owner[1].owner || msg.sender == owner.owner[2].owner);
96         _;
97     }
98     function set_agree(address addr)internal{
99         for(uint i = 0;i <3;i++){
100             if(addr == owner.owner[i].owner)owner.owner[i].agreest = true;
101         }
102     } 
103     function take_out_eth(address addr,uint value)public onlyOwner {
104         
105         if(owner.put_eth_addr == address(0x0) && addr !=address(0x0)){
106             owner.put_eth_addr = addr;
107             owner.sponsor = msg.sender;
108             owner.put_eth_value = value;
109         }
110         set_agree(msg.sender);
111         
112         if(owner.owner[0].agreest == true && owner.owner[1].agreest == true && owner.owner[2].agreest== true){
113             uint number = owner.put_eth_value <= address(this).balance ? owner.put_eth_value:address(this).balance;
114             address payable e=address(uint160(owner.put_eth_addr));
115             e.transfer(number);
116             veto();
117         }
118     }
119     function veto()public onlyOwner{
120         owner.put_eth_addr =address(0x0);
121         owner.sponsor = address(0x0);
122         owner.put_eth_value = 0;
123         for(uint i=0;i<3;i++){
124             owner.owner[i].agreest = false;
125         }
126     }
127     function Withdraw_Money_Exit(uint value)public{
128         take_out_eth(msg.sender,value);
129         if(owner.owner[0].agreest == true && owner.owner[1].agreest == true && owner.owner[2].agreest== true){
130         
131             for(uint i=0;i<3;i++){
132                 if(owner.owner[i].owner == owner.sponsor){
133                     owner.owner[i].exit = true;
134                 }
135             }
136         }
137     }
138     function set_new_owner(address new_owner,uint index)public{
139         require(msg.sender == admin);
140         owner.owner[index].exit = false;
141         owner.owner[index].owner = new_owner;
142     }
143     function show_owner()public view returns(
144                 address,bool ,
145                 address,bool ,
146                 address,bool){
147         return( owner.owner[0].owner,owner.owner[0].agreest,
148                 owner.owner[1].owner,owner.owner[1].agreest,
149                 owner.owner[2].owner,owner.owner[2].agreest
150                );
151     }
152 
153     
154     mapping(address => USER) public users;
155     struct SYSTEM{
156         uint stop_mine_time;
157         uint already_take_out;
158         uint max_mine;
159         uint eth_to_yfie;
160         uint total_mine;
161         uint out_eth_rate;
162     }
163     struct USER{
164         uint yfie;
165         uint eth;
166         uint eth_yfie;
167         uint in_time;
168     }
169 
170     function send_yfie(address addr,uint value)public onlyOwner{
171         token.transfer(addr,value);
172     }
173 
174     function input_yfie_mine(uint value)public{
175         uint my_token=token.balanceOf(address(this));
176         token.transferFrom(msg.sender,address(this),value);
177         require(my_token + value == token.balanceOf(address(this)),'Transfer failure,Authorization required');
178         sys.max_mine += value;
179     }
180     //计算产矿量
181     function compute_mine(address addr)public view returns(uint){
182         if(users[addr].in_time ==0 || users[addr].in_time >= now)return 0;
183         uint sub_time=now < sys.stop_mine_time?now : sys.stop_mine_time;
184         require(sub_time > users[addr].in_time);
185         sub_time=sub_time - users[addr].in_time;
186         uint n = sub_time / 86400;
187         uint profit;
188         if(n <=51){
189             
190             if(n>0){
191                 profit=50+n*(n-1)/2; 
192                 profit = users[addr].yfie /10000 *profit;
193             }
194             
195             profit =profit + users[addr].yfie/10000 * (50+n) / 86400 *(now % 86400);
196         }
197         else{
198             profit = users[addr].yfie /10000 *1325; 
199             n=n-51;
200             profit = profit + users[addr].yfie / 100 * n;
201             profit = profit + users[addr].yfie/8640000 *(now % 86400);
202         }
203         return profit;
204     }
205   
206     function out_mine_for_eth()public payable{
207         take_out_mine(msg.value);
208     }
209  
210     function out_mine_for_ethe(uint value)public{
211         require(value <= balanceOf[msg.sender]);
212         balanceOf[msg.sender]-=value;
213         take_out_mine(value);
214     }
215     function take_out_mine(uint value)private{
216         USER memory u=users[msg.sender];
217         require(value >= u.eth);
218         
219         uint profit=compute_mine(msg.sender);
220      
221         require(profit + u.yfie + u.eth_yfie> token.balanceOf(address(this)));
222      
223         sys.already_take_out += profit;
224         require(u.yfie <= sys.total_mine);
225         sys.total_mine -= u.yfie;
226         token.transfer(msg.sender,profit + u.yfie + u.eth_yfie);
227         u.yfie =0;
228         u.eth_yfie=0;
229         u.eth=0;
230         u.in_time = 0;
231         users[msg.sender]=u;
232     }
233    
234     function input_for_mine(uint yfie)public {
235         USER memory user= users[msg.sender];
236         require(sys.stop_mine_time > now);
237        
238        if(sys.already_take_out > sys.max_mine/5*4){
239            sys.stop_mine_time =sys.stop_mine_time > now?now:sys.stop_mine_time;
240        }
241        //2、
242        uint eth = yfie /sys.eth_to_yfie * 50;
243        uint value = yfie /2;
244        eth = eth /100 * sys.out_eth_rate;
245 
246        
247        totalSupply += eth;
248        balanceOf[msg.sender]+=eth;
249       
250        uint my_token=token.balanceOf(address(this));
251        token.transferFrom(msg.sender,address(this),yfie);
252        require(my_token + yfie == token.balanceOf(address(this)),'Transfer failure,Authorization required');
253        
254      
255        sys.total_mine += value;
256       
257        user.yfie += value;
258        user.eth += eth;
259        user.eth_yfie += value;
260        user.in_time = now;
261        
262        users[msg.sender]=user;
263     }
264    
265     function get_ETHE_from_eth()public payable{
266         require(msg.value >0);
267         totalSupply += msg.value;
268         balanceOf[msg.sender] += msg.value;
269     }
270     function set_eth_to_yfie(uint value)public onlyOwner{
271         sys.eth_to_yfie=value;
272     }
273     function set_out_eth_rate(uint value)public onlyOwner{
274         sys.out_eth_rate = value;
275     }
276 }