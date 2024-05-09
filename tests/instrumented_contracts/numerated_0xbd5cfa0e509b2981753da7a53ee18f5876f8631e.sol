1 pragma solidity ^0.4.18;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract EthereumUltimate {
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
35     function EthereumUltimate() public {
36         director = msg.sender;
37         name = "Ethereum Ultimate";
38         symbol = "ETHUT";
39         decimals = 18;
40         saleClosed = false;
41         directorLock = false;
42         funds = 0;
43         totalSupply = 0;
44         
45         totalSupply += 1000000 * 10 ** uint256(decimals);
46         
47         // Assign reserved ETHUT supply to the director
48         balances[director] = totalSupply;
49         
50         // Define default values for Ethereum Ultimate functions
51         claimAmount = 5 * 10 ** (uint256(decimals) - 1);
52         payAmount = 4 * 10 ** (uint256(decimals) - 1);
53         feeAmount = 1 * 10 ** (uint256(decimals) - 1);
54         
55         // Seconds in a year
56         epoch = 31536000;
57         
58         retentionMax = 40 * 10 ** uint256(decimals);
59     }
60     
61     function balanceOf(address _owner) public constant returns (uint256 balance) {
62         return balances[_owner];
63     }
64     
65     modifier onlyDirector {
66         require(!directorLock);
67         
68         require(msg.sender == director);
69         _;
70     }
71     
72     modifier onlyDirectorForce {
73         require(msg.sender == director);
74         _;
75     }
76     
77 
78     function transferDirector(address newDirector) public onlyDirectorForce {
79         director = newDirector;
80     }
81     
82 
83     function withdrawFunds() public onlyDirectorForce {
84         director.transfer(this.balance);
85     }
86 
87 	
88     function selfLock() public payable onlyDirector {
89         require(saleClosed);
90         
91         require(msg.value == 10 ether);
92         
93         directorLock = true;
94     }
95     
96     function amendClaim(uint8 claimAmountSet, uint8 payAmountSet, uint8 feeAmountSet, uint8 accuracy) public onlyDirector returns (bool success) {
97         require(claimAmountSet == (payAmountSet + feeAmountSet));
98         
99         claimAmount = claimAmountSet * 10 ** (uint256(decimals) - accuracy);
100         payAmount = payAmountSet * 10 ** (uint256(decimals) - accuracy);
101         feeAmount = feeAmountSet * 10 ** (uint256(decimals) - accuracy);
102         return true;
103     }
104     
105 
106     function amendEpoch(uint256 epochSet) public onlyDirector returns (bool success) {
107         // Set the epoch
108         epoch = epochSet;
109         return true;
110     }
111     
112 
113     function amendRetention(uint8 retentionSet, uint8 accuracy) public onlyDirector returns (bool success) {
114         // Set retentionMax
115         retentionMax = retentionSet * 10 ** (uint256(decimals) - accuracy);
116         return true;
117     }
118     
119 
120     function closeSale() public onlyDirector returns (bool success) {
121         // The sale must be currently open
122         require(!saleClosed);
123         
124         // Lock the crowdsale
125         saleClosed = true;
126         return true;
127     }
128 
129 
130     function openSale() public onlyDirector returns (bool success) {
131         // The sale must be currently closed
132         require(saleClosed);
133         
134         // Unlock the crowdsale
135         saleClosed = false;
136         return true;
137     }
138     
139 
140     function bury() public returns (bool success) {
141         // The address must be previously unburied
142         require(!buried[msg.sender]);
143         
144         // An address must have at least claimAmount to be buried
145         require(balances[msg.sender] >= claimAmount);
146         
147         // Prevent addresses with large balances from getting buried
148         require(balances[msg.sender] <= retentionMax);
149         
150         // Set buried state to true
151         buried[msg.sender] = true;
152         
153         // Set the initial claim clock to 1
154         claimed[msg.sender] = 1;
155         
156         // Execute an event reflecting the change
157         Bury(msg.sender, balances[msg.sender]);
158         return true;
159     }
160     
161 
162     function claim(address _payout, address _fee) public returns (bool success) {
163         // The claimed address must have already been buried
164         require(buried[msg.sender]);
165         
166         // The payout and fee addresses must be different
167         require(_payout != _fee);
168         
169         // The claimed address cannot pay itself
170         require(msg.sender != _payout);
171         
172         // The claimed address cannot pay itself
173         require(msg.sender != _fee);
174         
175         // It must be either the first time this address is being claimed or atleast epoch in time has passed
176         require(claimed[msg.sender] == 1 || (block.timestamp - claimed[msg.sender]) >= epoch);
177         
178         // Check if the buried address has enough
179         require(balances[msg.sender] >= claimAmount);
180         
181         // Reset the claim clock to the current block time
182         claimed[msg.sender] = block.timestamp;
183         
184         // Save this for an assertion in the future
185         uint256 previousBalances = balances[msg.sender] + balances[_payout] + balances[_fee];
186         
187         // Remove claimAmount from the buried address
188         balances[msg.sender] -= claimAmount;
189         
190         // Pay the website owner that invoked the web node that found the ETHT seed key
191         balances[_payout] += payAmount;
192         
193         // Pay the broker node that unlocked the ETHUT
194         balances[_fee] += feeAmount;
195         
196         // Execute events to reflect the changes
197         Claim(msg.sender, _payout, _fee);
198         Transfer(msg.sender, _payout, payAmount);
199         Transfer(msg.sender, _fee, feeAmount);
200         
201         // Failsafe logic that should never be false
202         assert(balances[msg.sender] + balances[_payout] + balances[_fee] == previousBalances);
203         return true;
204     }
205     
206     /**
207      * Crowdsale function
208      */
209     function () public payable {
210         require(!saleClosed);
211         
212         // Minimum amount is 1 finney
213         require(msg.value >= 1 finney);
214         
215         // Price is 1 ETH = 10000 ETHT
216         uint256 amount = msg.value * 30000;
217         
218         // Supply cap may increase
219         require(totalSupply + amount <= (10000000 * 10 ** uint256(decimals)));
220         
221         // Increases the total supply
222         totalSupply += amount;
223         
224         // Adds the amount to the balance
225         balances[msg.sender] += amount;
226         
227         // Track ETH amount raised
228         funds += msg.value;
229         
230         // Execute an event reflecting the change
231         Transfer(this, msg.sender, amount);
232     }
233 
234     function _transfer(address _from, address _to, uint _value) internal {
235         // Sending addresses cannot be buried
236         require(!buried[_from]);
237         
238         // If the receiving address is buried, it cannot exceed retentionMax
239         if (buried[_to]) {
240             require(balances[_to] + _value <= retentionMax);
241         }
242         
243         require(_to != 0x0);
244         
245         require(balances[_from] >= _value);
246         
247         require(balances[_to] + _value > balances[_to]);
248         
249         uint256 previousBalances = balances[_from] + balances[_to];
250         
251         balances[_from] -= _value;
252         
253         balances[_to] += _value;
254         Transfer(_from, _to, _value);
255         
256         assert(balances[_from] + balances[_to] == previousBalances);
257     }
258 
259 
260     function transfer(address _to, uint256 _value) public {
261         _transfer(msg.sender, _to, _value);
262     }
263 
264 
265     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
266         // Check allowance
267         require(_value <= allowance[_from][msg.sender]);
268         allowance[_from][msg.sender] -= _value;
269         _transfer(_from, _to, _value);
270         return true;
271     }
272 
273 
274     function approve(address _spender, uint256 _value) public returns (bool success) {
275         // Buried addresses cannot be approved
276         require(!buried[msg.sender]);
277         
278         allowance[msg.sender][_spender] = _value;
279         Approval(msg.sender, _spender, _value);
280         return true;
281     }
282 
283 
284     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
285         tokenRecipient spender = tokenRecipient(_spender);
286         if (approve(_spender, _value)) {
287             spender.receiveApproval(msg.sender, _value, this, _extraData);
288             return true;
289         }
290     }
291 
292 
293     function burn(uint256 _value) public returns (bool success) {
294         // Buried addresses cannot be burnt
295         require(!buried[msg.sender]);
296         
297         // Check if the sender has enough
298         require(balances[msg.sender] >= _value);
299         
300         // Subtract from the sender
301         balances[msg.sender] -= _value;
302         
303         // Updates totalSupply
304         totalSupply -= _value;
305         Burn(msg.sender, _value);
306         return true;
307     }
308 
309 
310     function burnFrom(address _from, uint256 _value) public returns (bool success) {
311         // Buried addresses cannot be burnt
312         require(!buried[_from]);
313         
314         // Check if the targeted balance is enough
315         require(balances[_from] >= _value);
316         
317         // Check allowance
318         require(_value <= allowance[_from][msg.sender]);
319         
320         // Subtract from the targeted balance
321         balances[_from] -= _value;
322         
323         // Subtract from the sender's allowance
324         allowance[_from][msg.sender] -= _value;
325         
326         // Update totalSupply
327         totalSupply -= _value;
328         Burn(_from, _value);
329         return true;
330     }
331 }