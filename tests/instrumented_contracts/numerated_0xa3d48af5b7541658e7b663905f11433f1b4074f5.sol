1 pragma solidity ^0.4.17;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract OysterPearl {
6     // Public variables of the token
7     string public name = "Oyster Pearl";
8     string public symbol = "TPRL";
9     uint8 public decimals = 18;
10     uint256 public totalSupply;
11     uint256 public funds = 0;
12     address public owner;
13     bool public saleClosed = false;
14     bool public ownerLock = false;
15     uint256 public claimAmount;
16     uint256 public payAmount;
17     uint256 public feeAmount;
18 
19     // This creates an array with all balances
20     mapping (address => uint256) public balanceOf;
21     mapping (address => mapping (address => uint256)) public allowance;
22     mapping (address => bool) public buried;
23     mapping (address => uint256) public claimed;
24 
25     // This generates a public event on the blockchain that will notify clients
26     event Transfer(address indexed from, address indexed to, uint256 value);
27 
28     // This notifies clients about the amount burnt
29     event Burn(address indexed from, uint256 value);
30     
31     event Bury(address indexed target, uint256 value);
32     
33     event Claim(address indexed payout, address indexed fee);
34 
35     /**
36      * Constructor function
37      *
38      * Initializes contract
39      */
40     function OysterPearl() public {
41         owner = msg.sender;
42         totalSupply = 0;
43         totalSupply += 25000000 * 10 ** uint256(decimals); //marketing share (5%)
44         totalSupply += 75000000 * 10 ** uint256(decimals); //devfund share (15%)
45         totalSupply += 1000000 * 10 ** uint256(decimals);  //allocation to match PREPRL supply
46         balanceOf[owner] = totalSupply;
47         
48         claimAmount = 5 * 10 ** (uint256(decimals) - 1);
49         payAmount = 4 * 10 ** (uint256(decimals) - 1);
50         feeAmount = 1 * 10 ** (uint256(decimals) - 1);
51     }
52     
53     modifier onlyOwner {
54         require(!ownerLock);
55         require(block.number < 8000000);
56         require(msg.sender == owner);
57         _;
58     }
59     
60     function transferOwnership(address newOwner) public onlyOwner {
61         owner = newOwner;
62     }
63     
64     function selfLock() public onlyOwner {
65         ownerLock = true;
66     }
67     
68     function amendAmount(uint8 claimAmountSet, uint8 payAmountSet, uint8 feeAmountSet) public onlyOwner {
69         require(claimAmountSet == (payAmountSet + feeAmountSet));
70         claimAmount = claimAmountSet * 10 ** (uint256(decimals) - 1);
71         payAmount = payAmountSet * 10 ** (uint256(decimals) - 1);
72         feeAmount = feeAmountSet * 10 ** (uint256(decimals) - 1);
73     }
74     
75     function closeSale() public onlyOwner {
76         saleClosed = true;
77     }
78 
79     function openSale() public onlyOwner {
80         saleClosed = false;
81     }
82     
83     function bury() public {
84         require(balanceOf[msg.sender] > claimAmount);
85         require(!buried[msg.sender]);
86         buried[msg.sender] = true;
87         claimed[msg.sender] = 1;
88         Bury(msg.sender, balanceOf[msg.sender]);
89     }
90     
91     function claim(address _payout, address _fee) public {
92         require(buried[msg.sender]);
93         require(claimed[msg.sender] == 1 || (block.timestamp - claimed[msg.sender]) >= 60);
94         require(balanceOf[msg.sender] >= claimAmount);
95         claimed[msg.sender] = block.timestamp;
96         balanceOf[msg.sender] -= claimAmount;
97         balanceOf[_payout] -= payAmount;
98         balanceOf[_fee] -= feeAmount;
99         Claim(_payout, _fee);
100     }
101     
102     function () payable public {
103         require(!saleClosed);
104         require(msg.value >= 1 finney);
105         uint256 amount = msg.value * 5000;                // calculates the amount
106         require(totalSupply + amount <= (500000000 * 10 ** uint256(decimals)));
107         totalSupply += amount;                            // increases the total supply 
108         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
109         funds += msg.value;                               // track eth amount raised
110         Transfer(this, msg.sender, amount);               // execute an event reflecting the change
111     }
112     
113     function withdrawFunds() public onlyOwner {
114         owner.transfer(this.balance);
115     }
116 
117     /**
118      * Internal transfer, only can be called by this contract
119      */
120     function _transfer(address _from, address _to, uint _value) internal {
121         require(!buried[_from]);
122         // Prevent transfer to 0x0 address. Use burn() instead
123         require(_to != 0x0);
124         // Check if the sender has enough
125         require(balanceOf[_from] >= _value);
126         // Check for overflows
127         require(balanceOf[_to] + _value > balanceOf[_to]);
128         // Save this for an assertion in the future
129         uint previousBalances = balanceOf[_from] + balanceOf[_to];
130         // Subtract from the sender
131         balanceOf[_from] -= _value;
132         // Add the same to the recipient
133         balanceOf[_to] += _value;
134         Transfer(_from, _to, _value);
135         // Asserts are used to use static analysis to find bugs in your code. They should never fail
136         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
137     }
138 
139     /**
140      * Transfer tokens
141      *
142      * Send `_value` tokens to `_to` from your account
143      *
144      * @param _to The address of the recipient
145      * @param _value the amount to send
146      */
147     function transfer(address _to, uint256 _value) public {
148         _transfer(msg.sender, _to, _value);
149     }
150 
151     /**
152      * Transfer tokens from other address
153      *
154      * Send `_value` tokens to `_to` in behalf of `_from`
155      *
156      * @param _from The address of the sender
157      * @param _to The address of the recipient
158      * @param _value the amount to send
159      */
160     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
161         require(_value <= allowance[_from][msg.sender]);     // Check allowance
162         allowance[_from][msg.sender] -= _value;
163         _transfer(_from, _to, _value);
164         return true;
165     }
166 
167     /**
168      * Set allowance for other address
169      *
170      * Allows `_spender` to spend no more than `_value` tokens in your behalf
171      *
172      * @param _spender The address authorized to spend
173      * @param _value the max amount they can spend
174      */
175     function approve(address _spender, uint256 _value) public
176         returns (bool success) {
177         allowance[msg.sender][_spender] = _value;
178         return true;
179     }
180 
181     /**
182      * Set allowance for other address and notify
183      *
184      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
185      *
186      * @param _spender The address authorized to spend
187      * @param _value the max amount they can spend
188      * @param _extraData some extra information to send to the approved contract
189      */
190     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
191         public
192         returns (bool success) {
193         tokenRecipient spender = tokenRecipient(_spender);
194         if (approve(_spender, _value)) {
195             spender.receiveApproval(msg.sender, _value, this, _extraData);
196             return true;
197         }
198     }
199 
200     /**
201      * Destroy tokens
202      *
203      * Remove `_value` tokens from the system irreversibly
204      *
205      * @param _value the amount of money to burn
206      */
207     function burn(uint256 _value) public returns (bool success) {
208         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
209         balanceOf[msg.sender] -= _value;            // Subtract from the sender
210         totalSupply -= _value;                      // Updates totalSupply
211         Burn(msg.sender, _value);
212         return true;
213     }
214 
215     /**
216      * Destroy tokens from other account
217      *
218      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
219      *
220      * @param _from the address of the sender
221      * @param _value the amount of money to burn
222      */
223     function burnFrom(address _from, uint256 _value) public returns (bool success) {
224         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
225         require(_value <= allowance[_from][msg.sender]);    // Check allowance
226         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
227         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
228         totalSupply -= _value;                              // Update totalSupply
229         Burn(_from, _value);
230         return true;
231     }
232 }