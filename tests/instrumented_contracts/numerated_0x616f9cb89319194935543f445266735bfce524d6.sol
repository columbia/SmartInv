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
87         uint256 _amount = (_value.mul(_percentage)).div(100);
88         uint256 _remaining = _value.sub(_amount);
89         uint256 _cycle_amount = _remaining.div(_cycle);
90         
91         lm.amount = _remaining;
92         lm.duration = _duration * _lockupBaseTime;
93         lm.cycle_amount = _cycle_amount;
94         lm.cycle = _cycle;
95         lm.active = true;
96         lm.last_withdraw = now;
97         lm.time = now;
98         
99         totalAddress++;
100         totalSupply = totalSupply.add(_value);
101         totalAvailable = totalAvailable.add(_amount);
102         balanceOf[_address] = balanceOf[_address].add(_amount);
103         
104         success = true;
105     }
106     
107     function unlockTokens() public returns (bool success) {
108         lockupMeta storage lm = lockups[msg.sender];
109         require(
110             lm.active 
111             && !lm.claimed
112         );
113         
114         uint _curTime = now;
115         uint _diffTime = _curTime.sub(lm.last_withdraw);
116         uint _cycles = (_diffTime.div(_lockupBaseTime));
117         
118         if(_cycles >= 1){
119             uint remaining_cycle = lm.cycle.sub(lm.claimed_cycle);
120             uint256 _amount = 0;
121             if(_cycles > remaining_cycle){
122                 _amount = lm.cycle_amount * remaining_cycle;
123                 lm.claimed_cycle = lm.cycle;
124                 lm.last_withdraw = _curTime;
125             } else {
126                 _amount = lm.cycle_amount * _cycles;
127                 lm.claimed_cycle = lm.claimed_cycle.add(_cycles);
128                 lm.last_withdraw = lm.last_withdraw.add(_cycles.mul(lm.duration));
129             }
130             
131             if(lm.claimed_cycle == lm.cycle){
132                 lm.claimed = true;
133             }
134             
135             totalAvailable = totalAvailable.add(_amount);
136             balanceOf[msg.sender] = balanceOf[msg.sender].add(_amount);
137             
138             success = true;
139             
140         } else {
141             success = false;
142         }
143     }
144     
145     function availableTokens(address _address) public view returns (uint256 _amount) {
146         lockupMeta storage lm = lockups[_address];
147         
148         _amount = 0;
149         
150         if(lm.active && !lm.claimed){
151             uint _curTime = now;
152             uint _diffTime = _curTime.sub(lm.last_withdraw);
153             uint _cycles = (_diffTime.div(_lockupBaseTime));
154             
155             if(_cycles >= 1){
156                 uint remaining_cycle = lm.cycle.sub(lm.claimed_cycle);
157                 
158                 if(_cycles > remaining_cycle){
159                     _amount = lm.cycle_amount * remaining_cycle;
160                 } else {
161                     _amount = lm.cycle_amount * _cycles;
162                 }
163                 
164             }
165         }
166     }
167     
168     function transfer(address _to, uint256 _value) public returns (bool success) {
169         require(
170             _value > 0
171             && balanceOf[msg.sender] >= _value
172         );
173         
174         totalSupply = totalSupply.sub(_value);
175         totalAvailable = totalAvailable.sub(_value);
176         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
177         ERC20(tokenAddress).transfer(_to, _value);
178         
179         return true;
180     }
181 }