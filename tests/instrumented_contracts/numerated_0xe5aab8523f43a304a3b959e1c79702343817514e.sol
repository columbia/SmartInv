1 pragma solidity ^0.4.20;
2 
3 contract Token {
4     function totalSupply() public constant returns (uint256 supply) {}
5     function balanceOf(address _owner) public constant returns (uint256 balance) {}
6     function transfer(address _to, uint256 _value) public returns (bool success) {}
7     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {}
8     function approve(address _spender, uint256 _value) public returns (bool success) {}
9     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {}
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 contract StandardToken is Token {
15     function transfer(address _to, uint256 _value) public returns (bool success) {
16         if (balances[msg.sender] >= _value && _value > 0) {
17             balances[msg.sender] -= _value;
18             balances[_to] += _value;
19             Transfer(msg.sender, _to, _value);
20             return true;
21         } else { return false; }
22     }
23 
24     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
25         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
26             balances[_to] += _value;
27             balances[_from] -= _value;
28             allowed[_from][msg.sender] -= _value;
29             Transfer(_from, _to, _value);
30             return true;
31         } else { return false; }
32     }
33 
34     function balanceOf(address _owner) public constant returns (uint256 balance) {
35         return balances[_owner];
36     }
37 
38     function approve(address _spender, uint256 _value) public returns (bool success) {
39         allowed[msg.sender][_spender] = _value;
40         Approval(msg.sender, _spender, _value);
41         return true;
42     }
43 
44     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
45       return allowed[_owner][_spender];
46     }
47 
48     mapping (address => uint256) balances;
49     mapping (address => mapping (address => uint256)) allowed;
50     uint256 public totalSupply;
51 }
52 
53 contract Obredis is StandardToken { 
54     string public name;                   // Token Name
55     uint8 public decimals;                // How many decimals the token has
56     string public symbol;                 // Token identifier
57     address public fundsWallet;           // Wallet which manages the contract
58     uint256 public totalRewards;
59     uint256 public newReward;
60     address[] public addresses;
61     mapping (address => bool) public isAddress;
62     bool public allRewPaid;
63     mapping (address => bool) public awaitingRew;
64     
65     
66     event Minted(uint256 qty,uint256 totalSupply);
67     event Burned(uint256 qty,uint256 totalSupply);
68     event Reward(uint256 qty);
69     
70     function Obredis() public {
71         balances[msg.sender] = 0;
72         totalSupply = 0;
73         name = "Obelisk Reward Token";
74         decimals = 18;
75         symbol = "ORT";
76         allRewPaid = true;
77         awaitingRew[msg.sender] = false;
78         fundsWallet = msg.sender;
79         addresses.push(msg.sender);
80         isAddress[msg.sender] = true;
81     }
82 
83     function() public {
84     }
85 
86     function transfer(address _to, uint256 _value) public canSend returns (bool success) {
87         // Transfer Tokens
88         require(super.transfer(_to,_value));
89         if (!isAddress[_to]){
90             addresses.push(_to);
91             isAddress[_to] = true;
92         }
93         // Return success flag
94         return true;
95     }
96 
97     modifier isOwner {
98         require(msg.sender == fundsWallet);
99         _;
100     }
101     
102     modifier canSend {
103         require(allRewPaid);
104         _;
105     }
106     
107     function forceTransfer(address _who, uint256 _qty) public isOwner returns (bool success) {
108         // owner can transfer qty from a wallet (in case your hopeless mates lose their private keys).
109         if (balances[_who] >= _qty && _qty > 0) {
110             balances[_who] -= _qty;
111             balances[fundsWallet] += _qty;
112             Transfer(_who, fundsWallet, _qty);
113             return true;
114         } else { 
115             return false;
116         }
117     }
118 
119     function payReward() public payable isOwner canSend {
120         require(msg.value > 0);
121         newReward = this.balance; // the only balance will be the scraps after payout
122         totalRewards += msg.value;     // only want to update with new amount
123         Reward(msg.value);
124         allRewPaid = false;
125         uint32 len = uint32(addresses.length);
126         for (uint32 i = 0; i < len ; i++){
127             awaitingRew[addresses[i]] = true;
128         }
129     }
130     
131     function payAllRewards() public isOwner {
132         require(allRewPaid == false);
133         uint32 len = uint32(addresses.length);
134         for (uint32 i = 0; i < len ; i++){
135             if (balances[addresses[i]] == 0){
136                 awaitingRew[addresses[i]] = false;
137             } else if (awaitingRew[addresses[i]]) {
138                 addresses[i].transfer((newReward*balances[addresses[i]])/totalSupply);
139                 awaitingRew[addresses[i]] = false;
140             }
141         }
142         allRewPaid = true;
143     }
144 
145     function paySomeRewards(uint32 _first, uint32 _last) public isOwner {
146         require(_first <= _last);
147         require(_last <= addresses.length);
148         for (uint32 i = _first; i<= _last; i++) {
149             if (balances[addresses[i]] == 0){
150                 awaitingRew[addresses[i]] = false;
151             } else if (awaitingRew[addresses[i]]) {
152                 addresses[i].transfer((newReward*balances[addresses[i]])/totalSupply);
153                 awaitingRew[addresses[i]] = false;
154             }
155         }
156         allRewPaid = checkAllRewPaid(); 
157     }
158     
159     function checkAllRewPaid() public view returns(bool success) {
160         uint32 len = uint32(addresses.length);
161         for (uint32 i = 0; i < len ; i++ ){
162             if (awaitingRew[addresses[i]]){
163                 return false;
164             }
165         }
166         return true;
167     }
168     
169     function updateAllRewPaid() public isOwner {
170         allRewPaid = checkAllRewPaid();
171     }
172 
173     function mint(uint256 _qty) public canSend isOwner {
174         require(totalSupply + _qty > totalSupply); // Prevents overflow
175         totalSupply += _qty;
176         balances[fundsWallet] += _qty;
177         Minted(_qty,totalSupply);
178         Transfer(0x0, fundsWallet, _qty);
179     }
180     
181     function burn(uint256 _qty) public canSend isOwner {
182         require(totalSupply - _qty < totalSupply); // Prevents underflow
183         require(balances[fundsWallet] >= _qty);
184         totalSupply -= _qty;
185         balances[fundsWallet] -= _qty;
186         Burned(_qty,totalSupply);
187         Transfer(fundsWallet, 0x0, _qty);
188     }
189     
190     function collectOwnRew() public {
191         if(awaitingRew[msg.sender]){
192             msg.sender.transfer((newReward*balances[msg.sender])/totalSupply);
193             awaitingRew[msg.sender] = false;
194         }
195         allRewPaid = checkAllRewPaid();
196     }
197     
198     function addressesLength() public view returns(uint32 len){
199         return uint32(addresses.length);
200     }
201     
202     function kill() public isOwner {
203         // Too much money involved to not have a fire exit
204         selfdestruct(fundsWallet);
205     }
206 }