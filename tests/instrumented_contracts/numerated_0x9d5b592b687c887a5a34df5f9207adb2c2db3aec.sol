1 pragma solidity ^0.4.18;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract EthereumBlack {
6     // Public variables of ETBT
7     string public name;
8     string public symbol;
9     uint8 public decimals;
10     uint256 public totalSupply;
11     uint256 public funds;
12     address public director;
13     bool public saleClosed;
14     bool public directorLock;
15     uint256 public claimAmount;
16     uint256 public payAmount;
17     uint256 public feeAmount;
18     uint256 public epoch;
19     uint256 public retentionMax;
20 
21     mapping (address => uint256) public balances;
22     mapping (address => mapping (address => uint256)) public allowance;
23     mapping (address => bool) public buried;
24     mapping (address => uint256) public claimed;
25 
26     event Transfer(address indexed _from, address indexed _to, uint256 _value);
27     
28     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
29 
30     event Burn(address indexed _from, uint256 _value);
31     
32     event Bury(address indexed _target, uint256 _value);
33     
34     event Claim(address indexed _target, address indexed _payout, address indexed _fee);
35 
36     function EthereumBlack() public {
37         director = msg.sender;
38         name = "Ethereum Black Token";
39         symbol = "ETBT";
40         decimals = 18;
41         saleClosed = false;
42         directorLock = false;
43         funds = 0;
44         totalSupply = 0;
45         
46         // Token Sale: (50%)
47         totalSupply += 1750000 * 10 ** uint256(decimals);
48         
49         // Reserves: (37%)
50         totalSupply += 1295000 * 10 ** uint256(decimals);
51         
52         // Marketing & Community outreach: (8%)
53         totalSupply += 280000 * 10 ** uint256(decimals);
54 		
55         // Team: (5%)
56         totalSupply += 175000 * 10 ** uint256(decimals);
57 
58 		// 500000 ETBT Reserved for donate
59         
60         // Assign reserved ETBT supply to the director
61         balances[director] = totalSupply;
62         
63         // Define default values for EtherBlack functions
64         claimAmount = 5 * 10 ** (uint256(decimals) - 1);
65         payAmount = 4 * 10 ** (uint256(decimals) - 1);
66         feeAmount = 1 * 10 ** (uint256(decimals) - 1);
67         
68         // Seconds in a year
69         epoch = 31536000;
70         
71         retentionMax = 40 * 10 ** uint256(decimals);
72     }
73     
74     function balanceOf(address _owner) public constant returns (uint256 balance) {
75         return balances[_owner];
76     }
77     
78     modifier onlyDirector {
79         // Director can lock themselves out to complete decentralization of EtherBlack network
80         // An alternative is that another smart contract could become the decentralized director
81         require(!directorLock);
82         
83         // Only the director is permitted
84         require(msg.sender == director);
85         _;
86     }
87     
88     modifier onlyDirectorForce {
89         // Only the director is permitted
90         require(msg.sender == director);
91         _;
92     }
93     
94 
95     function transferDirector(address newDirector) public onlyDirectorForce {
96         director = newDirector;
97     }
98     
99 
100     function withdrawFunds() public onlyDirectorForce {
101         director.transfer(this.balance);
102     }
103 
104 	
105     function selfLock() public payable onlyDirector {
106         // The sale must be closed before the director gets locked out
107         require(saleClosed);
108         
109         // Prevents accidental lockout
110         require(msg.value == 10 ether);
111         
112         // Permanently lock out the director
113         directorLock = true;
114     }
115     
116     function amendClaim(uint8 claimAmountSet, uint8 payAmountSet, uint8 feeAmountSet, uint8 accuracy) public onlyDirector returns (bool success) {
117         require(claimAmountSet == (payAmountSet + feeAmountSet));
118         
119         claimAmount = claimAmountSet * 10 ** (uint256(decimals) - accuracy);
120         payAmount = payAmountSet * 10 ** (uint256(decimals) - accuracy);
121         feeAmount = feeAmountSet * 10 ** (uint256(decimals) - accuracy);
122         return true;
123     }
124     
125 
126     function amendEpoch(uint256 epochSet) public onlyDirector returns (bool success) {
127         // Set the epoch
128         epoch = epochSet;
129         return true;
130     }
131     
132 
133     function amendRetention(uint8 retentionSet, uint8 accuracy) public onlyDirector returns (bool success) {
134         // Set retentionMax
135         retentionMax = retentionSet * 10 ** (uint256(decimals) - accuracy);
136         return true;
137     }
138     
139 
140     function closeSale() public onlyDirector returns (bool success) {
141         // The sale must be currently open
142         require(!saleClosed);
143         
144         // Lock the crowdsale
145         saleClosed = true;
146         return true;
147     }
148 
149 
150     function openSale() public onlyDirector returns (bool success) {
151         // The sale must be currently closed
152         require(saleClosed);
153         
154         // Unlock the crowdsale
155         saleClosed = false;
156         return true;
157     }
158     
159 
160     function bury() public returns (bool success) {
161         // The address must be previously unburied
162         require(!buried[msg.sender]);
163         
164         // An address must have at least claimAmount to be buried
165         require(balances[msg.sender] >= claimAmount);
166         
167         // Prevent addresses with large balances from getting buried
168         require(balances[msg.sender] <= retentionMax);
169         
170         // Set buried state to true
171         buried[msg.sender] = true;
172         
173         // Set the initial claim clock to 1
174         claimed[msg.sender] = 1;
175         
176         // Execute an event reflecting the change
177         Bury(msg.sender, balances[msg.sender]);
178         return true;
179     }
180     
181 
182     function claim(address _payout, address _fee) public returns (bool success) {
183         // The claimed address must have already been buried
184         require(buried[msg.sender]);
185         
186         // The payout and fee addresses must be different
187         require(_payout != _fee);
188         
189         // The claimed address cannot pay itself
190         require(msg.sender != _payout);
191         
192         // The claimed address cannot pay itself
193         require(msg.sender != _fee);
194         
195         // It must be either the first time this address is being claimed or atleast epoch in time has passed
196         require(claimed[msg.sender] == 1 || (block.timestamp - claimed[msg.sender]) >= epoch);
197         
198         // Check if the buried address has enough
199         require(balances[msg.sender] >= claimAmount);
200         
201         // Reset the claim clock to the current block time
202         claimed[msg.sender] = block.timestamp;
203         
204         // Save this for an assertion in the future
205         uint256 previousBalances = balances[msg.sender] + balances[_payout] + balances[_fee];
206         
207         // Remove claimAmount from the buried address
208         balances[msg.sender] -= claimAmount;
209         
210         // Pay the website owner that invoked the web node that found the ETBT seed key
211         balances[_payout] += payAmount;
212         
213         // Pay the broker node that unlocked the ETBT
214         balances[_fee] += feeAmount;
215         
216         // Execute events to reflect the changes
217         Claim(msg.sender, _payout, _fee);
218         Transfer(msg.sender, _payout, payAmount);
219         Transfer(msg.sender, _fee, feeAmount);
220         
221         // Failsafe logic that should never be false
222         assert(balances[msg.sender] + balances[_payout] + balances[_fee] == previousBalances);
223         return true;
224     }
225     
226     /**
227      * Crowdsale function
228      */
229     function () public payable {
230         // Check if crowdsale is still active
231         require(!saleClosed);
232         
233         // Minimum amount is 1 finney
234         require(msg.value >= 1 finney);
235         
236         // Price is 1 ETH = 10000 ETBT
237         uint256 amount = msg.value * 10000;
238         
239         // totalSupply limit is 4 million ETBT
240         require(totalSupply + amount <= (4000000 * 10 ** uint256(decimals)));
241         
242         // Increases the total supply
243         totalSupply += amount;
244         
245         // Adds the amount to the balance
246         balances[msg.sender] += amount;
247         
248         // Track ETH amount raised
249         funds += msg.value;
250         
251         // Execute an event reflecting the change
252         Transfer(this, msg.sender, amount);
253     }
254 
255     function _transfer(address _from, address _to, uint _value) internal {
256         // Sending addresses cannot be buried
257         require(!buried[_from]);
258         
259         // If the receiving address is buried, it cannot exceed retentionMax
260         if (buried[_to]) {
261             require(balances[_to] + _value <= retentionMax);
262         }
263         
264         require(_to != 0x0);
265         
266         require(balances[_from] >= _value);
267         
268         require(balances[_to] + _value > balances[_to]);
269         
270         uint256 previousBalances = balances[_from] + balances[_to];
271         
272         balances[_from] -= _value;
273         
274         balances[_to] += _value;
275         Transfer(_from, _to, _value);
276         
277         assert(balances[_from] + balances[_to] == previousBalances);
278     }
279 
280 
281     function transfer(address _to, uint256 _value) public {
282         _transfer(msg.sender, _to, _value);
283     }
284 
285 
286     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
287         // Check allowance
288         require(_value <= allowance[_from][msg.sender]);
289         allowance[_from][msg.sender] -= _value;
290         _transfer(_from, _to, _value);
291         return true;
292     }
293 
294 
295     function approve(address _spender, uint256 _value) public returns (bool success) {
296         // Buried addresses cannot be approved
297         require(!buried[msg.sender]);
298         
299         allowance[msg.sender][_spender] = _value;
300         Approval(msg.sender, _spender, _value);
301         return true;
302     }
303 
304 
305     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
306         tokenRecipient spender = tokenRecipient(_spender);
307         if (approve(_spender, _value)) {
308             spender.receiveApproval(msg.sender, _value, this, _extraData);
309             return true;
310         }
311     }
312 
313 
314     function burn(uint256 _value) public returns (bool success) {
315         // Buried addresses cannot be burnt
316         require(!buried[msg.sender]);
317         
318         // Check if the sender has enough
319         require(balances[msg.sender] >= _value);
320         
321         // Subtract from the sender
322         balances[msg.sender] -= _value;
323         
324         // Updates totalSupply
325         totalSupply -= _value;
326         Burn(msg.sender, _value);
327         return true;
328     }
329 
330 
331     function burnFrom(address _from, uint256 _value) public returns (bool success) {
332         // Buried addresses cannot be burnt
333         require(!buried[_from]);
334         
335         // Check if the targeted balance is enough
336         require(balances[_from] >= _value);
337         
338         // Check allowance
339         require(_value <= allowance[_from][msg.sender]);
340         
341         // Subtract from the targeted balance
342         balances[_from] -= _value;
343         
344         // Subtract from the sender's allowance
345         allowance[_from][msg.sender] -= _value;
346         
347         // Update totalSupply
348         totalSupply -= _value;
349         Burn(_from, _value);
350         return true;
351     }
352 }