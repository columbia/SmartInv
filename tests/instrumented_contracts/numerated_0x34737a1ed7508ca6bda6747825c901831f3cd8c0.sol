1 pragma solidity ^0.4.18;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract Weko {
6     string public name;
7     string public symbol;
8     uint8 public decimals;
9     uint256 public totalSupply;
10     uint256 public funds;
11     address public director;
12     bool public saleClosed;
13     bool public directorLock;
14     uint256 public claimAmount;
15     uint256 public payAmount;
16     uint256 public feeAmount;
17     uint256 public epoch;
18     uint256 public retentionMax;
19 
20     mapping (address => uint256) public balances;
21     mapping (address => mapping (address => uint256)) public allowance;
22     mapping (address => bool) public buried;
23     mapping (address => uint256) public claimed;
24 
25 
26     event Transfer(address indexed _from, address indexed _to, uint256 _value);
27 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
28 	event Burn(address indexed _from, uint256 _value);
29 	event Bury(address indexed _target, uint256 _value);
30 	event Claim(address indexed _target, address indexed _payout, address indexed _fee);
31 
32      function Weko() public {
33         director = msg.sender;
34         name = "Weko";
35         symbol = "WEKO";
36         decimals = 8;
37         saleClosed = true;
38         directorLock = false;
39         funds = 0;
40         totalSupply = 0;
41         
42         totalSupply += 20000000 * 10 ** uint256(decimals);
43 		balances[director] = totalSupply;
44         claimAmount = 20 * 10 ** (uint256(decimals) - 1);
45         payAmount = 10 * 10 ** (uint256(decimals) - 1);
46         feeAmount = 10 * 10 ** (uint256(decimals) - 1);
47         epoch = 31536000;
48         retentionMax = 40 * 10 ** uint256(decimals);
49     }
50     
51     function balanceOf(address _owner) public constant returns (uint256 balance) {
52         return balances[_owner];
53     }
54     
55     modifier onlyDirector {
56         require(!directorLock);
57         
58         require(msg.sender == director);
59         _;
60     }
61     
62     modifier onlyDirectorForce {
63         require(msg.sender == director);
64         _;
65     }
66     
67     function transferDirector(address newDirector) public onlyDirectorForce {
68         director = newDirector;
69     }
70     
71     function withdrawFunds() public onlyDirectorForce {
72         director.transfer(this.balance);
73     }
74     
75     function selfLock() public payable onlyDirector {
76         require(saleClosed);
77         
78         require(msg.value == 10 ether);
79         
80         directorLock = true;
81     }
82     
83     function amendClaim(uint8 claimAmountSet, uint8 payAmountSet, uint8 feeAmountSet, uint8 accuracy) public onlyDirector returns (bool success) {
84         require(claimAmountSet == (payAmountSet + feeAmountSet));
85         
86         claimAmount = claimAmountSet * 10 ** (uint256(decimals) - accuracy);
87         payAmount = payAmountSet * 10 ** (uint256(decimals) - accuracy);
88         feeAmount = feeAmountSet * 10 ** (uint256(decimals) - accuracy);
89         return true;
90     }
91     
92     function amendEpoch(uint256 epochSet) public onlyDirector returns (bool success) {
93         epoch = epochSet;
94         return true;
95     }
96     
97     function amendRetention(uint8 retentionSet, uint8 accuracy) public onlyDirector returns (bool success) {
98         retentionMax = retentionSet * 10 ** (uint256(decimals) - accuracy);
99         return true;
100     }
101     
102     function closeSale() public onlyDirector returns (bool success) {
103         require(!saleClosed);
104         
105         saleClosed = true;
106         return true;
107     }
108 
109     function openSale() public onlyDirector returns (bool success) {
110         require(saleClosed);
111         
112         saleClosed = false;
113         return true;
114     }
115     
116     function bury() public returns (bool success) {
117         require(!buried[msg.sender]);
118         require(balances[msg.sender] >= claimAmount);
119         require(balances[msg.sender] <= retentionMax);
120         buried[msg.sender] = true;
121         claimed[msg.sender] = 1;
122         Bury(msg.sender, balances[msg.sender]);
123         return true;
124     }
125     
126     function claim(address _payout, address _fee) public returns (bool success) {
127         require(buried[msg.sender]);
128         require(_payout != _fee);
129         require(msg.sender != _payout);
130         require(msg.sender != _fee);
131         require(claimed[msg.sender] == 1 || (block.timestamp - claimed[msg.sender]) >= epoch);
132         require(balances[msg.sender] >= claimAmount);
133         claimed[msg.sender] = block.timestamp;
134         uint256 previousBalances = balances[msg.sender] + balances[_payout] + balances[_fee];
135         balances[msg.sender] -= claimAmount;
136         balances[_payout] += payAmount;
137         balances[_fee] += feeAmount;
138         Claim(msg.sender, _payout, _fee);
139         Transfer(msg.sender, _payout, payAmount);
140         Transfer(msg.sender, _fee, feeAmount);
141         assert(balances[msg.sender] + balances[_payout] + balances[_fee] == previousBalances);
142         return true;
143     }
144     
145     function () public payable {
146         require(!saleClosed);
147         require(msg.value >= 1 finney);
148         uint256 amount = msg.value * 20000;
149         require(totalSupply + amount <= (20000000 * 10 ** uint256(decimals)));
150         totalSupply += amount;
151         balances[msg.sender] += amount;
152         funds += msg.value;
153         Transfer(this, msg.sender, amount);
154     }
155 
156     function _transfer(address _from, address _to, uint _value) internal {
157         require(!buried[_from]);
158         if (buried[_to]) {
159             require(balances[_to] + _value <= retentionMax);
160         }
161         require(_to != 0x0);
162         require(balances[_from] >= _value);
163         require(balances[_to] + _value > balances[_to]);
164         uint256 previousBalances = balances[_from] + balances[_to];
165         balances[_from] -= _value;
166         balances[_to] += _value;
167         Transfer(_from, _to, _value);
168         assert(balances[_from] + balances[_to] == previousBalances);
169     }
170 
171     function transfer(address _to, uint256 _value) public {
172         _transfer(msg.sender, _to, _value);
173     }
174 
175     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
176         require(_value <= allowance[_from][msg.sender]);
177         allowance[_from][msg.sender] -= _value;
178         _transfer(_from, _to, _value);
179         return true;
180     }
181 
182     function approve(address _spender, uint256 _value) public returns (bool success) {
183         require(!buried[msg.sender]);
184         allowance[msg.sender][_spender] = _value;
185         Approval(msg.sender, _spender, _value);
186         return true;
187     }
188 
189     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
190         tokenRecipient spender = tokenRecipient(_spender);
191         if (approve(_spender, _value)) {
192             spender.receiveApproval(msg.sender, _value, this, _extraData);
193             return true;
194         }
195     }
196 
197     function burn(uint256 _value) public returns (bool success) {
198         require(!buried[msg.sender]);
199         require(balances[msg.sender] >= _value);
200         balances[msg.sender] -= _value;
201         totalSupply -= _value;
202         Burn(msg.sender, _value);
203         return true;
204     }
205 
206     function burnFrom(address _from, uint256 _value) public returns (bool success) {
207         require(!buried[_from]);
208         require(balances[_from] >= _value);
209         require(_value <= allowance[_from][msg.sender]);
210         balances[_from] -= _value;
211         allowance[_from][msg.sender] -= _value;
212         totalSupply -= _value;
213         Burn(_from, _value);
214         return true;
215     }
216 }