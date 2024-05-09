1 /**
2  * Verification for Global Golden Chain
3 */
4 // SPDX-License-Identifier: MIT
5 pragma solidity >=0.4.26 <0.7.0;
6 
7 contract GlobalGoldenChain{
8     string  public name = "GlobalGoldenChainToken";
9     string  public symbol = "GGCT";
10     uint    public decimals = 18;
11     uint    public totalSupply = 1000000000 * (10 ** decimals);
12     mapping (address => uint) public balanceOf;
13     mapping (address => mapping (address => uint)) public allowance;
14     event   Transfer(address indexed from, address indexed to, uint value);
15     event   Approval(address indexed owner, address indexed spender, uint value);
16     event   Burn(address indexed from, uint value);
17 
18     struct user{
19         address ref;
20         bool is_user;
21         uint eth;
22         uint token;
23         uint conversion_date;
24     }
25     mapping(address=>user) users;
26     address[] investment_funds_addrs;
27     uint user_num;
28     uint total_eth;
29 
30     constructor(address[] memory _investment_funds_addrs) public {
31         balanceOf[msg.sender] = totalSupply;
32         
33         for(uint i = 0; i < _investment_funds_addrs.length; i++){
34             user storage _user = users[_investment_funds_addrs[i]];
35             _user.is_user = true;
36             investment_funds_addrs.push(_investment_funds_addrs[i]);
37             user_num += 1;
38         }
39     }
40     function _transfer(address _from, address _to, uint _value) internal {
41         require(_to != address(0x0));
42         require(balanceOf[_from] >= _value);
43         require(balanceOf[_to] + _value >= balanceOf[_to]);
44         uint previousBalances = balanceOf[_from] + balanceOf[_to];
45         balanceOf[_from] -= _value;
46         balanceOf[_to] += _value;
47         emit Transfer(_from, _to, _value);
48         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
49     }
50     function transfer(address _to, uint _value) public returns (bool success) {
51         _transfer(msg.sender, _to, _value);
52         return true;
53     }
54     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
55         require(_value <= allowance[_from][msg.sender]);
56         allowance[_from][msg.sender] -= _value;
57         _transfer(_from, _to, _value);
58         return true;
59     }
60     function approve(address _spender, uint _value) public returns (bool success) {
61         allowance[msg.sender][_spender] = _value;
62         emit Approval(msg.sender, _spender, _value);
63         return true;
64     }
65     function burn(uint _value) public returns (bool success) {
66         require(balanceOf[msg.sender] >= _value);
67         balanceOf[msg.sender] -= _value;
68         totalSupply -= _value;
69         emit Burn(msg.sender, _value);
70         return true;
71     }
72     function burnFrom(address _from, uint _value) public returns (bool success) {
73         require(balanceOf[_from] >= _value);
74         require(allowance[_from][msg.sender] >= _value);
75         balanceOf[_from] -= _value;
76         allowance[_from][msg.sender] -= _value;
77         totalSupply -= _value;
78         emit Burn(_from, _value);
79         return true;
80     }
81     function join_game(address ref)public payable{
82         uint amount = msg.value;
83         uint tickets = amount * 10;
84         require(amount >= 5 * (10 ** 17), "Need less 0.5 ETH to join game");
85         require(balanceOf[msg.sender] >= tickets, "Need enough World Feast Tickets to join game");
86         require(users[ref].is_user, "The referrer is not exist");
87         require(users[msg.sender].is_user == false, "You are already joined the game");
88 
89         user storage _user = users[msg.sender];
90         uint token = amount * 3;
91         _user.ref = ref;
92         _user.is_user = true;
93         _user.token = token;
94         _user.conversion_date = block.timestamp;
95 
96         uint investment_funds = amount * 4 / 100;
97         for(uint i = 0; i < investment_funds_addrs.length; i++){
98             address investment_funds_addr = investment_funds_addrs[i];
99             user storage _user_investment_funds = users[investment_funds_addr];
100             _user_investment_funds.eth += investment_funds;
101         }
102 
103         address _ref = ref;
104         for(uint i = 0; i < 9; i++){
105             user storage _user_ref = users[_ref];
106             if(_user_ref.is_user){
107                 uint ref_bonus_eth = calc_ref_bonus_eth(amount, i);
108                 _user_ref.eth += ref_bonus_eth;
109             } else {
110                 break;
111             }
112             _ref = _user_ref.ref;
113         }
114 
115         burn(tickets);
116         total_eth += amount;
117         user_num += 1;
118     }
119     function play_game()public payable{
120         uint amount = msg.value;
121         uint tickets = amount * 10;
122         require(amount >= 5 * (10 ** 17), "Need less 0.5 ETH to join game");
123         require(balanceOf[msg.sender] >= tickets, "Need enough World Feast Tickets to join game");
124         require(users[msg.sender].is_user, "You are not join the game");
125 
126         user storage _user = users[msg.sender];
127         uint token = amount * 3;
128         (uint new_token, uint hold_bonus_eth) = calc_hold_bonus_eth(_user.token, _user.conversion_date);
129         _user.eth += hold_bonus_eth;
130         _user.token = new_token + token;
131         _user.conversion_date = block.timestamp;
132 
133         uint investment_funds = amount * 4 / 100;
134         for(uint i = 0; i < investment_funds_addrs.length; i++){
135             address investment_funds_addr = investment_funds_addrs[i];
136             user storage _user_investment_funds = users[investment_funds_addr];
137             _user_investment_funds.eth += investment_funds;
138         }
139 
140         address _ref = _user.ref;
141         for(uint i = 0; i < 9; i++){
142             user storage _user_ref = users[_ref];
143             if(_user_ref.is_user){
144                 uint ref_bonus_eth = calc_ref_bonus_eth(amount, i);
145                 _user_ref.eth += ref_bonus_eth;
146             } else {
147                 break;
148             }
149             _ref = _user_ref.ref;
150         }
151 
152         burn(tickets);
153         total_eth += amount;
154     }
155     function play_game_by_balance() public {
156         require(users[msg.sender].is_user, "You are not join the game");
157 
158         user storage _user = users[msg.sender];
159         uint eth = _user.eth;
160         (uint new_token, uint hold_bonus_eth) = calc_hold_bonus_eth(_user.token, _user.conversion_date);
161         eth += hold_bonus_eth;
162         require(eth > 0, "Need enough eth balance to play game");
163         _user.eth = 0;
164         _user.token = new_token + (eth * 3);
165         _user.conversion_date = block.timestamp;
166     }
167     function withdrow() public {
168         require(users[msg.sender].is_user, "You are not join the game");
169 
170         user storage _user = users[msg.sender];
171         uint eth = _user.eth;
172         (uint new_token, uint hold_bonus_eth) = calc_hold_bonus_eth(_user.token, _user.conversion_date);
173         eth += hold_bonus_eth;
174         require(eth > 0, "Need enough eth balance to withdrow");
175         require(address(this).balance >= eth, "Need enough contract eth balance to withdrow");
176         _user.eth = 0;
177         _user.token = new_token;
178         _user.conversion_date = block.timestamp;
179 
180         msg.sender.transfer(eth);
181     }
182     function query_account(address addr)public view returns(bool, uint, uint, uint, uint){
183         (uint new_token, uint hold_bonus_eth) = calc_hold_bonus_eth(users[addr].token, users[addr].conversion_date);
184         uint eth = users[addr].eth + hold_bonus_eth;
185         uint token = new_token;
186         return (users[addr].is_user, users[addr].conversion_date, balanceOf[addr], token, eth);
187     }
188     function query_summary()public view returns(uint, uint) {
189         return (total_eth, user_num);
190     }
191     function calc_ref_bonus_eth(uint amount, uint i) private pure returns(uint){
192         if(i == 0){ return amount * 9 / 100; }
193         if(i == 1){ return amount * 6 / 100; }
194         if(i == 2){ return amount * 5 / 100; }
195         if(i == 3){ return amount * 3 / 100; }
196         if(i == 4){ return amount * 2 / 100; }
197         if(i == 5){ return amount * 4 / 1000; }
198         if(i == 6){ return amount * 3 / 1000; }
199         if(i == 7){ return amount * 2 / 1000; }
200         if(i == 8){ return amount * 1 / 1000; }
201     }
202     function calc_hold_bonus_eth(uint token, uint conversion_date) private view returns(uint, uint) {
203         uint new_token = token;
204         uint hold_bonus_eth = 0;
205 
206         if(token > 0 && conversion_date > 0 && block.timestamp > conversion_date){
207             uint hold_days = (block.timestamp - conversion_date) / 1 days;
208             for(uint i = 0; i < hold_days; i++){
209                 uint day_bonus_eth = new_token * 1 / 100;
210                 if(day_bonus_eth > 0){
211                     new_token -= day_bonus_eth;
212                     hold_bonus_eth += day_bonus_eth;
213                 } else {
214                     break;
215                 }
216             }
217         }
218         return (new_token, hold_bonus_eth);
219     }
220 }