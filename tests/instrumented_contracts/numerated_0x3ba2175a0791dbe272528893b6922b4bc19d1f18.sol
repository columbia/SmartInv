1 pragma solidity ^0.4.18;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) public {
16         if (msg.sender != owner) return;
17         owner = newOwner;
18     }
19 }
20 
21 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
22 
23 contract Dudecoin is owned {
24     // Public variables of the token
25     string public name;
26     string public symbol;
27     uint8 public decimals = 18;
28     // 18 decimals is the strongly suggested default, avoid changing it
29     uint256 public totalSupply;
30 
31     uint256 public buyPrice;
32     uint public amountRaised;
33 
34     // deadline
35     uint public deadline;
36     uint duration;
37 
38 
39     bool closed = false;
40 
41     uint256 initialSupply = 10000000000;
42     string tokenName = "Dudecoin";
43     string tokenSymbol = "DUDE";
44     uint256 initBuyPrice_inWei = 1000000000000;
45     uint durationInMinutes = 259200;
46 
47     // This creates an array with all balances
48     mapping (address => uint256) public balanceOf;
49     mapping (address => mapping (address => uint256)) public allowance;
50 
51     // This generates a public event on the blockchain that will notify clients
52     event Transfer(address indexed from, address indexed to, uint256 value);
53     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
54 
55     // This notifies clients about the amount burnt
56     event Burn(address indexed from, uint256 value);
57 
58     /**
59      * Constructor function
60      *
61      * Initializes contract with initial supply tokens to the creator of the contract
62      */
63     function Dudecoin() public {
64         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
65         balanceOf[this] = initialSupply * 8 * (10 ** uint256(decimals - 1));  // Give the contract 80% of initial tokens
66         balanceOf[msg.sender] = initialSupply * 2 * (10 ** uint256(decimals - 1)); // Give owners 20% of tokens
67         name = tokenName;                                   // Set the name for display purposes
68         symbol = tokenSymbol;                               // Set the symbol for display purposes
69         buyPrice = initBuyPrice_inWei;
70         amountRaised = 0;
71 
72         duration = durationInMinutes;
73         deadline = now + duration * 1 minutes;
74     }
75 
76     modifier afterDeadline() { if (now >= deadline) _; }
77 
78     function postDeadline()
79         public
80         afterDeadline
81     {
82         owner.transfer(amountRaised);
83         amountRaised = 0;
84         closed = true;
85     }
86 
87 
88     /**
89      * Internal transfer, only can be called by this contract
90      */
91     function _transfer(address _from, address _to, uint _value) internal {
92         // Prevent transfer to 0x0 address. Use burn() instead
93         require(_to != 0x0);
94         // Check if the sender has enough
95         require(balanceOf[_from] >= _value);
96         // Check for overflows
97         require(balanceOf[_to] + _value > balanceOf[_to]);
98         // Save this for an assertion in the future
99         uint previousBalances = balanceOf[_from] + balanceOf[_to];
100         // Subtract from the sender
101         balanceOf[_from] -= _value;
102         // Add the same to the recipient
103         balanceOf[_to] += _value;
104         Transfer(_from, _to, _value);
105         // Asserts are used to use static analysis to find bugs in your code. They should never fail
106         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
107     }
108 
109     /**
110      * Transfer tokens
111      *
112      * Send `_value` tokens to `_to` from your account
113      *
114      * @param _to The address of the recipient
115      * @param _value the amount to send
116      */
117     function transfer(address _to, uint256 _value) public {
118         _transfer(msg.sender, _to, _value);
119     }
120 
121     /**
122      * Transfer tokens from other address
123      *
124      * Send `_value` tokens to `_to` in behalf of `_from`
125      *
126      * @param _from The address of the sender
127      * @param _to The address of the recipient
128      * @param _value the amount to send
129      */
130     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
131         require(_value <= allowance[_from][msg.sender]);     // Check allowance
132         allowance[_from][msg.sender] -= _value;
133         _transfer(_from, _to, _value);
134         return true;
135     }
136 
137     /**
138      * Set allowance for other address
139      *
140      * Allows `_spender` to spend no more than `_value` tokens in your behalf
141      *
142      * @param _spender The address authorized to spend
143      * @param _value the max amount they can spend
144      */
145     function approve(address _spender, uint256 _value) public
146         returns (bool success) {
147         allowance[msg.sender][_spender] = _value;
148         Approval(msg.sender, _spender, _value);
149         return true;
150     }
151 
152     /**
153      * Set allowance for other address and notify
154      *
155      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
156      *
157      * @param _spender The address authorized to spend
158      * @param _value the max amount they can spend
159      * @param _extraData some extra information to send to the approved contract
160      */
161     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
162         public
163         returns (bool success) {
164         tokenRecipient spender = tokenRecipient(_spender);
165         if (approve(_spender, _value)) {
166             spender.receiveApproval(msg.sender, _value, this, _extraData);
167             return true;
168         }
169     }
170 
171     /**
172      * Destroy tokens
173      *
174      * Remove `_value` tokens from the system irreversibly
175      *
176      * @param _value the amount of money to burn
177      */
178     function burn(uint256 _value) public returns (bool success) {
179         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
180         balanceOf[msg.sender] -= _value;            // Subtract from the sender
181         totalSupply -= _value;                      // Updates totalSupply
182         Burn(msg.sender, _value);
183         return true;
184     }
185 
186     /**
187      * Destroy tokens from other account
188      *
189      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
190      *
191      * @param _from the address of the sender
192      * @param _value the amount of money to burn
193      */
194     function burnFrom(address _from, uint256 _value) public returns (bool success) {
195         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
196         require(_value <= allowance[_from][msg.sender]);    // Check allowance
197         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
198         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
199         totalSupply -= _value;                              // Update totalSupply
200         Burn(_from, _value);
201         return true;
202     }
203 
204 
205     function setPrices(uint256 newBuyPrice)
206         public
207         onlyOwner
208     {
209         if (msg.sender != owner) return;
210         buyPrice = newBuyPrice;
211     }
212 
213     function () payable public {
214         require(!closed);
215         uint256 amount = (msg.value * 1 ether) / buyPrice;                    // calculates the amount
216         require(balanceOf[this] >= amount);               // checks if it has enough to sell
217         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
218         balanceOf[this] -= amount;                        // subtracts amount from seller's balance
219         Transfer(this, msg.sender, amount);               // execute an event reflecting the change
220         amountRaised += msg.value;
221 
222         if (amountRaised >= 0.5 * 1 ether) {
223             owner.transfer(amountRaised);
224             amountRaised = 0;
225         }
226     }
227 
228 
229     function totalSupply() public constant returns (uint256)
230     {
231         return totalSupply;
232     }
233 
234     function balanceOf(address tokenOwner) public constant returns (uint balance)
235     {
236         return balanceOf[tokenOwner];
237     }
238 
239     function allowance(address tokenOwner, address spender) public constant returns (uint remaining)
240     {
241         return allowance[tokenOwner][spender];
242     }
243 }