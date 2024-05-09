1 pragma solidity ^0.4.17;
2 
3 library SafeMath {
4     function add(uint a, uint b) internal pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8     function sub(uint a, uint b) internal pure returns (uint c) {
9         require(b <= a);
10         c = a - b;
11     }
12     function mul(uint a, uint b) internal pure returns (uint c) {
13         c = a * b;
14         require(a == 0 || c / a == b);
15     }
16     function div(uint a, uint b) internal pure returns (uint c) {
17         require(b > 0);
18         c = a / b;
19     }
20 }
21 
22 contract ERC20 {
23     function totalSupply() public constant returns (uint);
24     function balanceOf(address tokenOwner) public constant returns (uint balance);
25     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
26     function transfer(address to, uint tokens) public returns (bool success);
27     function approve(address spender, uint tokens) public returns (bool success);
28     function transferFrom(address from, address to, uint tokens) public returns (bool success);
29     event Transfer(address indexed from, address indexed to, uint tokens);
30     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
31 }
32 
33 contract owlockups {
34     using SafeMath for uint;
35     
36     string public symbol = "OWTL";
37     uint256 public decimals = 18;
38     uint256 public totalSupply;
39     uint256 public totalAvailable;
40     uint public totalAddress;
41     
42     
43     address public admin;
44     uint public _lockupBaseTime = 1 days;
45     address public tokenAddress;
46     
47     modifier onlyOwner {
48         require(msg.sender == admin);
49         _;
50     }
51     
52     mapping ( address => uint256 ) public balanceOf;
53     mapping ( address => lockupMeta ) public lockups;
54     
55     struct lockupMeta {
56         uint256 amount;
57         uint256 cycle_amount;
58         uint cycle;
59         uint claimed_cycle;
60         uint duration;
61         uint last_withdraw;
62         bool active;
63         bool claimed;
64         uint time;
65     }
66     
67     function owlockups(address _address) public {
68         tokenAddress = _address;
69         admin = msg.sender;
70     }
71     
72     function setAdmin(address _newAdmin) public onlyOwner {
73         admin = _newAdmin;
74     }
75     
76     function lockTokens(
77         address _address, 
78         uint256 _value, 
79         uint _percentage, 
80         uint _duration, 
81         uint _cycle
82     ) public onlyOwner returns (bool success) {
83         _value =  _value * 10**uint(decimals);
84         lockupMeta storage lm = lockups[_address];
85         require(!lm.active);
86         
87         uint256 _remaining = 0;
88         
89         if(_percentage > 0){
90             uint256 _amount = (_value.mul(_percentage)).div(100);
91             _remaining = _value.sub(_amount);
92         } else {
93             _remaining = _value;
94         }
95         uint256 _cycle_amount = _remaining.div(_cycle);
96         
97         lm.amount = _remaining;
98         lm.duration = _duration * _lockupBaseTime;
99         lm.cycle_amount = _cycle_amount;
100         lm.cycle = _cycle;
101         lm.active = true;
102         lm.last_withdraw = now;
103         lm.time = now;
104         
105         totalAddress++;
106         totalSupply = totalSupply.add(_value);
107         totalAvailable = totalAvailable.add(_amount);
108         balanceOf[_address] = balanceOf[_address].add(_amount);
109         
110         success = true;
111     }
112     
113     function unlockTokens() public returns (bool success) {
114         lockupMeta storage lm = lockups[msg.sender];
115         require(
116             lm.active 
117             && !lm.claimed
118         );
119         
120         uint _curTime = now;
121         uint _diffTime = _curTime.sub(lm.last_withdraw);
122         uint _cycles = (_diffTime.div(_lockupBaseTime));
123         
124         if(_cycles >= 1){
125             uint remaining_cycle = lm.cycle.sub(lm.claimed_cycle);
126             uint256 _amount = 0;
127             if(_cycles > remaining_cycle){
128                 _amount = lm.cycle_amount * remaining_cycle;
129                 lm.claimed_cycle = lm.cycle;
130                 lm.last_withdraw = _curTime;
131             } else {
132                 _amount = lm.cycle_amount * _cycles;
133                 lm.claimed_cycle = lm.claimed_cycle.add(_cycles);
134                 lm.last_withdraw = lm.last_withdraw.add(_cycles.mul(lm.duration));
135             }
136             
137             if(lm.claimed_cycle == lm.cycle){
138                 lm.claimed = true;
139             }
140             
141             totalAvailable = totalAvailable.add(_amount);
142             balanceOf[msg.sender] = balanceOf[msg.sender].add(_amount);
143             
144             success = true;
145             
146         } else {
147             success = false;
148         }
149     }
150     
151     function availableTokens(address _address) public view returns (uint256 _amount) {
152         lockupMeta storage lm = lockups[_address];
153         
154         _amount = 0;
155         
156         if(lm.active && !lm.claimed){
157             uint _curTime = now;
158             uint _diffTime = _curTime.sub(lm.last_withdraw);
159             uint _cycles = (_diffTime.div(_lockupBaseTime));
160             
161             if(_cycles >= 1){
162                 uint remaining_cycle = lm.cycle.sub(lm.claimed_cycle);
163                 
164                 if(_cycles > remaining_cycle){
165                     _amount = lm.cycle_amount * remaining_cycle;
166                 } else {
167                     _amount = lm.cycle_amount * _cycles;
168                 }
169                 
170             }
171         }
172     }
173     
174     function transfer(address _to, uint256 _value) public returns (bool success) {
175         require(
176             _value > 0
177             && balanceOf[msg.sender] >= _value
178         );
179         
180         totalSupply = totalSupply.sub(_value);
181         totalAvailable = totalAvailable.sub(_value);
182         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
183         ERC20(tokenAddress).transfer(_to, _value);
184         
185         return true;
186     }
187 }