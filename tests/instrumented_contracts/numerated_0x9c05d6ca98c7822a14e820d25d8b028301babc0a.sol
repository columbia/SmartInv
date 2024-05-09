1 pragma solidity ^0.4.19;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract mETHNetwork {
6     // Public variables of METH
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
18 
19     // Array definitions
20     mapping (address => uint256) public balances;
21     mapping (address => mapping (address => uint256)) public allowance;
22     mapping (address => bool) public buried;
23     mapping (address => uint256) public claimed;
24 
25     // ERC20 event
26     event Transfer(address indexed _from, address indexed _to, uint256 _value);
27     
28     // ERC20 event
29     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
30 
31     // This notifies clients about the amount burnt
32     event Burn(address indexed _from, uint256 _value);
33     
34     // This notifies clients about a claim being made on a buried address
35     event Claim(address indexed _target, address indexed _payout, address indexed _fee);
36 
37     /**
38      * Constructor function
39      *
40      * Initializes contract
41      */
42     function mETHNetwork() public {
43         director = msg.sender;
44         name = "mETH";
45         symbol = "METH";
46         decimals = 10;
47         saleClosed = true;
48         directorLock = false;
49         funds = 0;
50         totalSupply = 0;
51         
52         }
53     
54     /**
55      * ERC20 balance function
56      */
57     function balanceOf(address _owner) public constant returns (uint256 balance) {
58         return balances[_owner];
59     }
60     
61     modifier onlyDirector {
62         // Director can lock themselves out to complete decentralization of mETH network
63         // An alternative is that another smart contract could become the decentralized director
64         require(!directorLock);
65         
66         // Only the director is permitted
67         require(msg.sender == director);
68         _;
69     }
70     
71     modifier onlyDirectorForce {
72         // Only the director is permitted
73         require(msg.sender == director);
74         _;
75     }
76     
77     /**
78      * Transfers the director to a new address
79      */
80     function transferDirector(address newDirector) public onlyDirectorForce {
81         director = newDirector;
82     }
83     
84     /**
85      * Withdraw funds from the contract
86      */
87     function withdrawFunds() public onlyDirectorForce {
88         director.transfer(this.balance);
89     }
90     
91     /**
92      * Director can close the contribution
93      */
94     function closeSale() public onlyDirector returns (bool success) {
95         // The sale must be currently open
96         require(!saleClosed);
97         
98         // Lock the crowdsale
99         saleClosed = true;
100         return true;
101     }
102 
103     /**
104      * Director can open the contribution
105      */
106     function openSale() public onlyDirector returns (bool success) {
107         // The sale must be currently closed
108         require(saleClosed);
109         
110         // Unlock the contribution
111         saleClosed = false;
112         return true;
113     }
114  
115     /**
116      * contribution function
117      */
118     function () public payable {
119         // Check if contribution is still active
120         require(!saleClosed);
121         
122         // Price is 1 ETH = 100000000 mETH
123         uint256 amount = msg.value * 100000000;
124         
125         // totalSupply limit is 9 billion mETH
126         require(totalSupply + amount <= (9000000000 * 10 ** uint256(decimals)));
127         
128         // Increases the total supply
129         totalSupply += amount;
130         
131         // Adds the amount to the balance
132         balances[msg.sender] += amount;
133         
134         // Track ETH amount raised
135         funds += msg.value;
136         
137         // Execute an event reflecting the change
138         Transfer(this, msg.sender, amount);
139     }
140 
141     /**
142      * Internal transfer, can be called by this contract only
143      */
144     function _transfer(address _from, address _to, uint _value) internal {
145         // Sending addresses cannot be buried
146         require(!buried[_from]);
147         
148 
149         
150         // Prevent transfer to 0x0 address, use burn() instead
151         require(_to != 0x0);
152         
153         // Check if the sender has enough
154         require(balances[_from] >= _value);
155         
156         // Check for overflows
157         require(balances[_to] + _value > balances[_to]);
158         
159         // Save this for an assertion in the future
160         uint256 previousBalances = balances[_from] + balances[_to];
161         
162         // Subtract from the sender
163         balances[_from] -= _value;
164         
165         // Add the same to the recipient
166         balances[_to] += _value;
167         Transfer(_from, _to, _value);
168         
169         // Failsafe logic that should never be false
170         assert(balances[_from] + balances[_to] == previousBalances);
171     }
172 
173     /**
174      * Transfer tokens
175      *
176      * Send `_value` tokens to `_to` from your account
177      *
178      * @param _to the address of the recipient
179      * @param _value the amount to send
180      */
181     function transfer(address _to, uint256 _value) public {
182         _transfer(msg.sender, _to, _value);
183     }
184 
185     /**
186      * Transfer tokens from other address
187      *
188      * Send `_value` tokens to `_to` in behalf of `_from`
189      *
190      * @param _from the address of the sender
191      * @param _to the address of the recipient
192      * @param _value the amount to send
193      */
194     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
195         // Check allowance
196         require(_value <= allowance[_from][msg.sender]);
197         allowance[_from][msg.sender] -= _value;
198         _transfer(_from, _to, _value);
199         return true;
200     }
201 
202     /**
203      * Set allowance for other address
204      *
205      * Allows `_spender` to spend no more than `_value` tokens on your behalf
206      *
207      * @param _spender the address authorized to spend
208      * @param _value the max amount they can spend
209      */
210     function approve(address _spender, uint256 _value) public returns (bool success) {
211         // Buried addresses cannot be approved
212         require(!buried[msg.sender]);
213         
214         allowance[msg.sender][_spender] = _value;
215         Approval(msg.sender, _spender, _value);
216         return true;
217     }
218 
219     /**
220      * Set allowance for other address and notify
221      *
222      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
223      *
224      * @param _spender the address authorized to spend
225      * @param _value the max amount they can spend
226      * @param _extraData some extra information to send to the approved contract
227      */
228     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
229         tokenRecipient spender = tokenRecipient(_spender);
230         if (approve(_spender, _value)) {
231             spender.receiveApproval(msg.sender, _value, this, _extraData);
232             return true;
233         }
234     }
235 
236     /**
237      * Destroy tokens
238      *
239      * Remove `_value` tokens from the system irreversibly
240      *
241      * @param _value the amount of money to burn
242      */
243     function burn(uint256 _value) public returns (bool success) {
244         // Buried addresses cannot be burnt
245         require(!buried[msg.sender]);
246         
247         // Check if the sender has enough
248         require(balances[msg.sender] >= _value);
249         
250         // Subtract from the sender
251         balances[msg.sender] -= _value;
252         
253         // Updates totalSupply
254         totalSupply -= _value;
255         Burn(msg.sender, _value);
256         return true;
257     }
258 
259     /**
260      * @param _from the address of the sender
261      * @param _value the amount of money to burn
262      */
263     function burnFrom(address _from, uint256 _value) public returns (bool success) {
264         // Buried addresses cannot be burnt
265         require(!buried[_from]);
266         
267         // Check if the targeted balance is enough
268         require(balances[_from] >= _value);
269         
270         // Check allowance
271         require(_value <= allowance[_from][msg.sender]);
272         
273         // Subtract from the targeted balance
274         balances[_from] -= _value;
275         
276         // Subtract from the sender's allowance
277         allowance[_from][msg.sender] -= _value;
278         
279         // Update totalSupply
280         totalSupply -= _value;
281         Burn(_from, _value);
282         return true;
283     }
284 }