1 pragma solidity ^0.4.18;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract TestToken {
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
25     event Transfer(address indexed _from, address indexed _to, uint256 _value);
26     
27     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
28 
29     event Burn(address indexed _from, uint256 _value);
30     
31     event Bury(address indexed _target, uint256 _value);
32     
33     event Claim(address indexed _target, address indexed _payout, address indexed _fee);
34 
35     function TestToken() public {
36         director = msg.sender;
37         name = "test token";
38         symbol = "TTT";
39         decimals = 8;
40         saleClosed = false;
41         directorLock = false;
42         funds = 0;
43         totalSupply = 0;
44         
45         // Token Supply: 4.000.000 TTT
46         totalSupply += 4000000 * 10 ** uint256(decimals);
47         
48 		// 1.000.000 TTT Reserved for donate
49         
50         balances[director] = totalSupply;
51         
52         claimAmount = 5 * 10 ** (uint256(decimals) - 1);
53         payAmount = 4 * 10 ** (uint256(decimals) - 1);
54         feeAmount = 1 * 10 ** (uint256(decimals) - 1);
55         epoch = 31536000;
56         
57         retentionMax = 40 * 10 ** uint256(decimals);
58     }
59     
60     function balanceOf(address _owner) public constant returns (uint256 balance) {
61         return balances[_owner];
62     }
63     
64     modifier onlyDirector {
65         require(!directorLock);
66         
67         require(msg.sender == director);
68         _;
69     }
70     
71     modifier onlyDirectorForce {
72         require(msg.sender == director);
73         _;
74     }
75     
76 
77     function transferDirector(address newDirector) public onlyDirectorForce {
78         director = newDirector;
79     }
80     
81 
82     function withdrawFunds() public onlyDirectorForce {
83         director.transfer(this.balance);
84     }
85 
86 	
87     function selfLock() public payable onlyDirector {
88         require(saleClosed);
89         
90         require(msg.value == 10 ether);
91         
92         directorLock = true;
93     }
94     
95     function amendClaim(uint8 claimAmountSet, uint8 payAmountSet, uint8 feeAmountSet, uint8 accuracy) public onlyDirector returns (bool success) {
96         require(claimAmountSet == (payAmountSet + feeAmountSet));
97         
98         claimAmount = claimAmountSet * 10 ** (uint256(decimals) - accuracy);
99         payAmount = payAmountSet * 10 ** (uint256(decimals) - accuracy);
100         feeAmount = feeAmountSet * 10 ** (uint256(decimals) - accuracy);
101         return true;
102     }
103     
104 
105     function amendEpoch(uint256 epochSet) public onlyDirector returns (bool success) {
106         epoch = epochSet;
107         return true;
108     }
109     
110 
111     function amendRetention(uint8 retentionSet, uint8 accuracy) public onlyDirector returns (bool success) {
112         retentionMax = retentionSet * 10 ** (uint256(decimals) - accuracy);
113         return true;
114     }
115     
116 
117     function closeSale() public onlyDirector returns (bool success) {
118         require(!saleClosed);
119         
120 		
121         saleClosed = true;
122         return true;
123     }
124 
125 
126     function openSale() public onlyDirector returns (bool success) {
127         require(saleClosed);
128         
129         saleClosed = false;
130         return true;
131     }
132     
133 
134     function bury() public returns (bool success) {
135         require(!buried[msg.sender]);
136         
137         require(balances[msg.sender] >= claimAmount);
138         
139         require(balances[msg.sender] <= retentionMax);
140         
141         buried[msg.sender] = true;
142         
143         claimed[msg.sender] = 1;
144         
145         Bury(msg.sender, balances[msg.sender]);
146         return true;
147     }
148     
149 
150     function claim(address _payout, address _fee) public returns (bool success) {
151         require(buried[msg.sender]);
152         
153         require(_payout != _fee);
154         
155         require(msg.sender != _payout);
156         
157         require(msg.sender != _fee);
158         
159         require(claimed[msg.sender] == 1 || (block.timestamp - claimed[msg.sender]) >= epoch);
160         
161         require(balances[msg.sender] >= claimAmount);
162         
163         claimed[msg.sender] = block.timestamp;
164         
165         uint256 previousBalances = balances[msg.sender] + balances[_payout] + balances[_fee];
166         
167         balances[msg.sender] -= claimAmount;
168         
169         balances[_payout] += payAmount;
170         
171         balances[_fee] += feeAmount;
172         
173         Claim(msg.sender, _payout, _fee);
174         Transfer(msg.sender, _payout, payAmount);
175         Transfer(msg.sender, _fee, feeAmount);
176         
177         assert(balances[msg.sender] + balances[_payout] + balances[_fee] == previousBalances);
178         return true;
179     }
180     
181     function () public payable {
182         require(!saleClosed);
183         
184         require(msg.value >= 1 finney);
185         
186         // Price is 1 ETH = 50000 TTT
187         uint256 amount = msg.value * 50000;
188         
189         // totalSupply limit is 5 million TTT
190         require(totalSupply + amount <= (5000000 * 10 ** uint256(decimals)));
191         
192         totalSupply += amount;
193         
194         balances[msg.sender] += amount;
195         
196         funds += msg.value;
197         
198         Transfer(this, msg.sender, amount);
199     }
200 
201     function _transfer(address _from, address _to, uint _value) internal {
202         require(!buried[_from]);
203         
204         if (buried[_to]) {
205             require(balances[_to] + _value <= retentionMax);
206         }
207         
208         require(_to != 0x0);
209         
210         require(balances[_from] >= _value);
211         
212         require(balances[_to] + _value > balances[_to]);
213         
214         uint256 previousBalances = balances[_from] + balances[_to];
215         
216         balances[_from] -= _value;
217         
218         balances[_to] += _value;
219         Transfer(_from, _to, _value);
220         
221         assert(balances[_from] + balances[_to] == previousBalances);
222     }
223 
224 
225     function transfer(address _to, uint256 _value) public {
226         _transfer(msg.sender, _to, _value);
227     }
228 
229 
230     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
231         require(_value <= allowance[_from][msg.sender]);
232         allowance[_from][msg.sender] -= _value;
233         _transfer(_from, _to, _value);
234         return true;
235     }
236 
237 
238     function approve(address _spender, uint256 _value) public returns (bool success) {
239         require(!buried[msg.sender]);
240         
241         allowance[msg.sender][_spender] = _value;
242         Approval(msg.sender, _spender, _value);
243         return true;
244     }
245 
246 
247     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
248         tokenRecipient spender = tokenRecipient(_spender);
249         if (approve(_spender, _value)) {
250             spender.receiveApproval(msg.sender, _value, this, _extraData);
251             return true;
252         }
253     }
254 
255 
256     function burn(uint256 _value) public returns (bool success) {
257         require(!buried[msg.sender]);
258         
259         require(balances[msg.sender] >= _value);
260         
261         balances[msg.sender] -= _value;
262         
263         totalSupply -= _value;
264         Burn(msg.sender, _value);
265         return true;
266     }
267 
268 
269     function burnFrom(address _from, uint256 _value) public returns (bool success) {
270         require(!buried[_from]);
271         
272         require(balances[_from] >= _value);
273         
274         require(_value <= allowance[_from][msg.sender]);
275         
276         balances[_from] -= _value;
277         
278         allowance[_from][msg.sender] -= _value;
279         
280         totalSupply -= _value;
281         Burn(_from, _value);
282         return true;
283     }
284 }