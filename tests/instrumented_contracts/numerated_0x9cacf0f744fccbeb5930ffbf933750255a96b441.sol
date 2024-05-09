1 pragma solidity ^0.4.18;
2 
3 
4 
5 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
6 
7 contract Lottery {
8     // Public variables of the token
9     address public owner;
10     string public name;
11     string public symbol;
12     uint8 public decimals = 0;
13     uint256 public totalSupply;
14 
15 
16     // This creates an array with all balances
17     mapping (address => uint256) public balanceOf;
18     mapping (address => mapping (address => uint256)) public allowance;
19 
20 
21     // This generates a public event on the blockchain that will notify clients
22     event Transfer(address indexed from, address indexed to, uint256 value);
23     event Tickets(address indexed from, uint tickets);
24     event SelectWinner50(address indexed winner50);
25     event SelectWinner20(address indexed winner20);
26     event SelectWinner30(address indexed winner30);
27     event FullPool(uint amount);
28     
29 
30     /**
31      * Constrctor function
32      *
33      * Initializes contract with initial supply tokens to the creator of the contract
34      */
35     function Lottery(
36     uint256 initialSupply,
37     string tokenName,
38     string tokenSymbol
39     ) public {
40         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
41         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
42         name = tokenName;                                   // Set the name for display purposes
43         symbol = tokenSymbol;                               // Set the symbol for display purposes
44         owner = msg.sender;
45     }
46 
47 
48     modifier onlyOwner {
49         require(msg.sender == owner);
50         _;
51     }
52 
53 
54     function transferOwnership(address newOwner) onlyOwner public {
55         owner = newOwner;
56     }
57 
58     /**
59      * Internal transfer, only can be called by this contract
60      */
61     function _transfer(address _from, address _to, uint _value) internal {
62         // Prevent transfer to 0x0 address. Use burn() instead
63         require(_to != 0x0);
64         // Check if the sender has enough
65         require(balanceOf[_from] >= _value);
66         // Check for overflows
67         require(balanceOf[_to] + _value > balanceOf[_to]);
68         // Subtract from the sender
69         balanceOf[_from] -= _value;
70         // Add the same to the recipient
71         balanceOf[_to] += _value;
72         Transfer(_from, _to, _value);
73 
74     }
75 
76     /**
77      * Transfer tokens
78      *
79      * Send `_value` tokens to `_to` from your account
80      *
81      * @param _to The address of the recipient
82      * @param _value the amount to send
83      */
84     function transfer(address _to, uint256 _value) public {
85         _transfer(msg.sender, _to, _value);
86     }
87 
88     function transferToWinner(address _to, uint256 _value) internal {
89         _transfer(this, _to, _value);
90     }
91 
92     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
93         require(_value <= allowance[_from][msg.sender]);     // Check allowance
94         allowance[_from][msg.sender] -= _value;
95         _transfer(_from, _to, _value);
96         return true;
97     }
98 
99     /**
100      * Set allowance for other address
101      *
102      * Allows `_spender` to spend no more than `_value` tokens in your behalf
103      *
104      * @param _spender The address authorized to spend
105      * @param _value the max amount they can spend
106      */
107     function approve(address _spender, uint256 _value) public
108     returns (bool success) {
109         allowance[msg.sender][_spender] = _value;
110         return true;
111     }
112 
113     /**
114      * Set allowance for other address and notify
115      *
116      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
117      *
118      * @param _spender The address authorized to spend
119      * @param _value the max amount they can spend
120      * @param _extraData some extra information to send to the approved contract
121      */
122     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
123     public
124     returns (bool success) {
125         tokenRecipient spender = tokenRecipient(_spender);
126         if (approve(_spender, _value)) {
127             spender.receiveApproval(msg.sender, _value, this, _extraData);
128             return true;
129         }
130     }
131 
132     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
133         balanceOf[target] += mintedAmount;
134         totalSupply += mintedAmount;
135         Transfer(0, this, mintedAmount);
136         Transfer(this, target, mintedAmount);
137     }
138 
139 
140 
141     address[] pust;
142     address[] internal  pool;
143     uint internal ticketPrice;
144     uint internal seed;
145     uint internal stopFlag;
146     uint internal total;
147     uint internal ticketMax;
148     
149     
150     function setTicketMax (uint amount) public onlyOwner {
151         ticketMax = amount;
152     }
153 
154 
155     function setTicketPrice (uint amount) public onlyOwner {
156         ticketPrice = amount;
157     }
158     
159     
160     
161     function getPoolSize() public constant returns (uint amount) {
162         amount = pool.length;
163         return amount;
164     }
165     
166     
167 
168     function takeAndPush(uint ticketsAmount) internal {
169         transfer(this, ticketPrice * ticketsAmount);
170         uint i = 0;
171         while(i < ticketsAmount) {
172             pool.push(msg.sender);
173             i++;
174         }
175 
176 
177     }
178 
179     function random50(uint upper) internal returns (uint) {
180         seed = uint(keccak256(keccak256(pool[pool.length -1], seed), now));
181         return seed % upper;
182     }
183 
184     function random30(uint upper) internal returns (uint) {
185         seed = uint(keccak256(keccak256(pool[pool.length -2], seed), now));
186         return seed % upper;
187     }
188 
189     function random20(uint upper) internal returns (uint) {
190         seed = uint(keccak256(keccak256(pool[pool.length -3], seed), now));
191         return seed % upper;
192     }
193 
194     function selectWinner50() public onlyOwner  {
195         total = balanceOf[this];
196         address winner50 = pool[random50(pool.length)];
197         transferToWinner(winner50, (total / 2));
198         SelectWinner50(winner50);
199     }
200     
201     
202    
203         function selectWinner20() public onlyOwner  {
204         address winner20 = pool[random20(pool.length)];
205         transferToWinner(winner20, (total / 5));
206         SelectWinner20(winner20);
207     }
208     
209     
210     
211         function selectWinner30() public onlyOwner  {
212         address winner30 = pool[random30(pool.length)];
213         transferToWinner(winner30, (total) - (total / 2) - (total / 5));
214         pool = pust;
215         SelectWinner30(winner30);
216     }
217     
218     
219     function buyTickets(uint ticketsAmount) public  {
220         require(balanceOf[msg.sender] >= ticketPrice * ticketsAmount);
221         require(balanceOf[this] + (ticketPrice * ticketsAmount) >= balanceOf[this]);
222         require(stopFlag != 1);
223         require((ticketsAmount + pool.length) <= ticketMax);
224 
225         takeAndPush(ticketsAmount);
226         
227         if((pool.length + ticketsAmount) >= ticketMax) {
228             FullPool(ticketMax);
229         }
230 
231         Tickets(msg.sender, ticketsAmount);
232     }
233 
234     function stopFlagOn() public onlyOwner {
235         stopFlag = 1;
236     }
237 
238     function stopFlagOff() public onlyOwner {
239         stopFlag = 0;
240         total = 0;
241     }
242 
243 
244 }