1 pragma solidity ^0.4.16;
2 contract owned {
3     address public owner;
4 
5     function owned() public {
6         owner = msg.sender;
7     }
8 
9     modifier onlyOwner {
10         require(msg.sender == owner);
11         _;
12     }
13 
14     function transferOwnership(address newOwner) onlyOwner public {
15         owner = newOwner;
16     }
17 }
18 
19 contract Token {
20 
21     /// @return total amount of tokens
22     function totalSupply() constant public returns (uint256 supply) {}
23 
24     /// @param _owner The address from which the balance will be retrieved
25     /// @return The balance
26     function balanceOf(address _owner) constant public returns (uint256 balance) {}
27 
28     /// @notice send `_value` token to `_to` from `msg.sender`
29     /// @param _to The address of the recipient
30     /// @param _value The amount of token to be transferred
31     /// @return Whether the transfer was successful or not
32     function transfer(address _to, uint256 _value) public returns (bool success) {}
33 
34     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
35     /// @param _from The address of the sender
36     /// @param _to The address of the recipient
37     /// @param _value The amount of token to be transferred
38     /// @return Whether the transfer was successful or not
39     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {}
40 
41     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
42     /// @param _spender The address of the account able to transfer the tokens
43     /// @param _value The amount of wei to be approved for transfer
44     /// @return Whether the approval was successful or not
45     function approve(address _spender, uint256 _value) public returns (bool success) {}
46 
47     /// @param _owner The address of the account owning tokens
48     /// @param _spender The address of the account able to transfer the tokens
49     /// @return Amount of remaining tokens allowed to spent
50     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {}
51 
52     event Transfer(address indexed _from, address indexed _to, uint256 _value);
53     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
54     
55 }
56 
57 
58 
59 contract StandardToken is Token {
60 
61     function transfer(address _to, uint256 _value) public returns (bool success) {
62         //Default assumes totalSupply can't be over max (2^256 - 1).
63         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
64         //Replace the if with this one instead.
65         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
66         if (balances[msg.sender] >= _value && _value > 0) {
67             balances[msg.sender] -= _value;
68             balances[_to] += _value;
69             Transfer(msg.sender, _to, _value);
70             return true;
71         } else { return false; }
72     }
73 
74     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
75         //same as above. Replace this line with the following if you want to protect against wrapping uints.
76         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
77         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
78             balances[_to] += _value;
79             balances[_from] -= _value;
80             allowed[_from][msg.sender] -= _value;
81             Transfer(_from, _to, _value);
82             return true;
83         } else { return false; }
84     }
85 
86     function balanceOf(address _owner) constant public returns (uint256 balance) {
87         return balances[_owner];
88     }
89 
90     function approve(address _spender, uint256 _value) public returns (bool success) {
91         allowed[msg.sender][_spender] = _value;
92         Approval(msg.sender, _spender, _value);
93         return true;
94     }
95 
96     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
97       return allowed[_owner][_spender];
98     }
99 
100     mapping (address => uint256) balances;
101     mapping (address => mapping (address => uint256)) allowed;
102     uint256 public totalSupply;
103 }
104 
105 
106 //name this contract whatever you'd like
107 contract BitProCoinX is StandardToken, owned {
108 
109 
110 
111     /* Public variables of the token */
112 
113     /*
114     NOTE:
115     The following variables are OPTIONAL vanities. One does not have to include them.
116     They allow one to customise the token contract & in no way influences the core functionality.
117     Some wallets/interfaces might not even bother to look at this information.
118     */
119     string public name;                   //fancy name: eg Simon Bucks
120     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
121     string public symbol;                 //An identifier: eg SBX
122     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
123     uint256 public sellPrice; //in wei
124     uint256 public buyPrice;  //in wei
125     uint256 remaining;
126      uint public numInvestors;
127   struct Investor {
128     uint amount;
129     address eth_address;
130     bytes32 Name;
131     bytes32 email;
132     bytes32 message;
133   }
134   mapping(uint => Investor) public investors;
135 
136 //
137 // CHANGE THESE VALUES FOR YOUR TOKEN
138 //
139 
140 //make sure this function name matches the contract name above. So if you're token is called TutorialToken, make sure the //contract name above is also TutorialToken instead of ERC20Token
141 
142     function BitProCoinX(
143         ) public{
144         balances[msg.sender] = 1000000000000;               // Give the creator all initial tokens (100000 for example)
145         totalSupply = 1000000000000;                        // Update total supply (100000 for example)
146         name = "BitProCoinX";                                   // Set the name for display purposes
147         decimals = 4;                            // Amount of decimals for display purposes
148         symbol = "BPCX";                               // Set the symbol for display purposes
149         sellPrice = 7668200000;                         // price of subtoken , i.e. main token price need to be divided by (10 ** uint256(decimals)), here 1000
150         buyPrice =  7668200000;                         // price of subtoken , i.e. main token price need to be divided by (10 ** uint256(decimals)), here 1000
151         remaining = 0;
152         numInvestors;
153     }
154      function() public payable{
155          //if(msg.sender!=owner)
156          require(msg.value > 0);
157         uint  amount = div(msg.value, buyPrice);                    // calculates the amount
158         require(balances[this] >= amount);               // checks if it has enough to sell
159         balances[msg.sender] += amount;                  // adds the amount to buyer's balance
160         balances[this] -= amount;                        // subtracts amount from seller's balance
161         Transfer(this, msg.sender, amount);               // execute an event reflecting the change
162         //investors[numInvestors] = Investor(msg.value, msg.sender);
163         numInvestors++;
164           
165     }
166     /* Approves and then calls the receiving contract */
167     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
168         allowed[msg.sender][_spender] = _value;
169         Approval(msg.sender, _spender, _value);
170 
171         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
172         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
173         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
174         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
175         return true;
176     }
177 
178     function setPrices(uint256 newSellPriceInwei, uint256 newBuyPriceInwei) onlyOwner {
179         sellPrice = div(newSellPriceInwei , (10 ** uint256(decimals)));  
180         buyPrice =  div(newBuyPriceInwei , (10 ** uint256(decimals)));
181     }
182     function buy() payable returns (uint amount){
183         require(msg.value > 0);
184         amount = div(msg.value, buyPrice);                    // calculates the amount
185         require(balances[this] >= amount);               // checks if it has enough to sell
186         balances[msg.sender] += amount;                  // adds the amount to buyer's balance
187         balances[this] -= amount;                        // subtracts amount from seller's balance
188         Transfer(this, msg.sender, amount);               // execute an event reflecting the change
189         //investors[numInvestors] = Investor(msg.value, msg.sender);
190         numInvestors++;
191         return amount;                                    // ends function and returns
192     }
193     function onlyPay() payable onlyOwner{
194         
195         
196     }
197 
198     function sell(uint amount) returns (uint revenue){
199         require(balances[msg.sender] >= amount);         // checks if the sender has enough to sell
200         balances[this] += amount;                        // adds the amount to owner's balance
201         balances[msg.sender] -= amount;                  // subtracts the amount from seller's balance
202         revenue = amount * sellPrice;
203         require(msg.sender.send(revenue));                // sends ether to the seller: it's important to do this last to prevent recursion attacks
204         Transfer(msg.sender, this, amount);               // executes an event reflecting on the change
205         return revenue;                                   // ends function and returns
206     }
207 
208     function withdraw(uint _amountInwei) onlyOwner{
209         require(this.balance > _amountInwei);
210       require(msg.sender == owner);
211       owner.send(_amountInwei);
212      
213     }
214     /* Safe Math Function */
215      function mul(uint256 a, uint256 b) internal pure returns (uint256) {
216     if (a == 0) {
217       return 0;
218     }
219     uint256 c = a * b;
220     assert(c / a == b);
221     return c;
222   }
223 
224   function div(uint256 a, uint256 b) internal pure returns (uint256) {
225     // assert(b > 0); // Solidity automatically throws when dividing by 0
226     uint256 c = a / b;
227     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
228     return c;
229   }
230 
231   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
232     assert(b <= a);
233     return a - b;
234   }
235 
236   function add(uint256 a, uint256 b) internal pure returns (uint256) {
237     uint256 c = a + b;
238     assert(c >= a);
239     return c;
240   }
241     
242 }