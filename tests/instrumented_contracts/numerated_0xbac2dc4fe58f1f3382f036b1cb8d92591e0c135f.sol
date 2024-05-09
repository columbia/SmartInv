1 pragma solidity ^0.4.16;
2 
3 // The following is the Ethereum Mining Manager Contract, Version Two.
4 
5 // It assumes that each graphics card draws 80 watts (75 watts for gtx 1050 ti and 5 watts for 1/13 of the rig, an underestimate)
6 // It also assumes that the cost of electricity is .20$/KWh
7 // Tokens can only be tranferred by their owners.
8 
9 // Tokens(Graphics Cards) can be created to and destroyed from anyone if done by the Contract creator.
10 
11 
12 contract owned {
13     address public owner;
14 
15     function owned() public {
16         owner = msg.sender;
17     }
18 
19     modifier onlyOwner {
20         require(msg.sender == owner);
21         _;
22     }
23 
24     function transferOwnership(address newOwner) onlyOwner public {
25         owner = newOwner;
26     }
27 }
28 
29 contract TokenERC20 {
30     // Public variables of the token
31     string public name;
32     string public symbol;
33     uint8 public decimals = 18;
34     // 18 decimals is the strongly suggested default, avoid changing it
35     uint256 public totalSupply;
36 
37     // This creates an array with all balances
38     mapping (address => uint256) public balanceOf;
39     //mapping (address => mapping (address => uint256)) public allowance;
40 
41     // This generates a public event on the blockchain that will notify clients
42     event Transfer(address indexed from, address indexed to, uint256 value);
43 
44     // This notifies clients about the amount burnt
45     event Burn(address indexed from, uint256 value);
46 
47     /**
48      * Constrctor function
49      *
50      * Initializes contract with initial supply tokens to the creator of the contract
51      */
52     function TokenERC20(
53         uint256 initialSupply,
54         string tokenName,
55         string tokenSymbol
56     ) public {
57         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
58         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
59         name = tokenName;                                   // Set the name for display purposes
60         symbol = tokenSymbol;                               // Set the symbol for display purposes
61     }
62 
63     /**
64      * Internal transfer, only can be called by this contract
65      */
66     function _transfer(address _from, address _to, uint _value) internal {
67         // Prevent transfer to 0x0 address. Use burn() instead
68         require(_to != 0x0);
69         // Check if the sender has enough
70         require(balanceOf[_from] >= _value);
71         // Check for overflows
72         require(balanceOf[_to] + _value > balanceOf[_to]);
73         // Save this for an assertion in the future
74         uint previousBalances = balanceOf[_from] + balanceOf[_to];
75         // Subtract from the sender
76         balanceOf[_from] -= _value;
77         // Add the same to the recipient
78         balanceOf[_to] += _value;
79         Transfer(_from, _to, _value);
80         // Asserts are used to use static analysis to find bugs in your code. They should never fail
81         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
82     }
83 
84     /**
85      * Transfer tokens
86      *
87      * Send `_value` tokens to `_to` from your account
88      *
89      * @param _to The address of the recipient
90      * @param _value the amount to send
91      */
92     function transfer(address _to, uint256 _value) public {
93         _transfer(msg.sender, _to, _value);
94     }
95 
96 
97     /**
98      * Destroy tokens
99      *
100      * Remove `_value` tokens from the system irreversibly
101      *
102      * @param _value the amount of money to burn
103      */
104     function burn(uint256 _value) public returns (bool success) {
105         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
106         balanceOf[msg.sender] -= _value;            // Subtract from the sender
107         totalSupply -= _value;                      // Updates totalSupply
108         Burn(msg.sender, _value);
109         return true;
110     }
111 
112     /**
113      * Destroy tokens from other account
114      *
115      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
116      *
117      * @param _from the address of the sender
118      * @param _value the amount of money to burn
119      */
120     function burnFrom(address _from, uint256 _value) public returns (bool success) {
121         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
122         //require(_value <= allowance[_from][msg.sender]);    // Check allowance
123         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
124         //allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
125         totalSupply -= _value;                              // Update totalSupply
126         Burn(_from, _value);
127         return true;
128     }
129 }
130 
131 /******************************************/
132 /*       MINING CONTRACT MAIN CODE        */
133 /******************************************/
134 
135 contract MiningToken is owned, TokenERC20 {
136     uint256 public supplyReady;  // How many are in stock to be bought (set to zero to disable the buying of cards)
137     uint256 public min4payout;   // Minimum ether in contract for payout to be allowed
138     uint256 public centsPerMonth;// Cost to run a card
139     mapping(uint256 => address) public holders;    // Contract's list of people who own graphics cards
140     mapping(address => uint256) public indexes;
141     uint256 public num_holders=1;
142     /* Initializes contract with initial supply tokens to the creator of the contract */
143     function MiningToken(
144         string tokenName,
145         string tokenSymbol
146     ) TokenERC20(0, tokenName, tokenSymbol) public {
147         centsPerMonth=0;
148         decimals=0;
149         setMinimum(0);
150         holders[num_holders++]=(msg.sender);
151     }
152 
153     /* Internal transfer, only can be called by this contract */
154     function _transfer(address _from, address _to, uint _value) internal {
155         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
156         require (balanceOf[_from] >= _value);               // Check if the sender has enough
157         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
158         balanceOf[_from] -= _value;                         // Subtract from the sender
159         balanceOf[_to] += _value;                           // Add the same to the recipient
160         if(indexes[_to]==0||holders[indexes[_to]]==0){
161             indexes[_to]=num_holders;
162             holders[num_holders++]=_to;
163         }
164         Transfer(_from, _to, _value);
165     }
166 	
167 	// Set minimum payout
168     function setMinimum(uint256 d) onlyOwner public{
169         min4payout=d*1 ether / 1000;
170     }
171 	
172 	// set card $/watt/month
173     function setCentsPerMonth(uint256 amount) onlyOwner public {
174         centsPerMonth=amount;
175     }
176 	
177 	// get mining payout and send to everyone
178 	// Requires price of ethereum to deduct electricity cost
179     function getPayout(uint etherPrice) onlyOwner public {
180         require(this.balance>min4payout);
181         uint256 perToken=this.balance/totalSupply;
182         for (uint i = 1; i < num_holders; i++) {
183             address d=holders[i];
184             if(d!=0){
185                 uint bal=balanceOf[d];
186                 if(bal==0){
187                     holders[i]=0;
188                 }else{
189                     uint powercost=((bal*centsPerMonth)/100) *( 1 ether/etherPrice);
190                     holders[i].transfer((bal * perToken)-powercost);
191                 }
192             }
193         }
194         owner.transfer(((totalSupply*centsPerMonth)/100) *( 1 ether/etherPrice)); // transfer elecricity cost to contract owner
195     }
196 	
197 	// add graphics card for owner of contract
198     function mint(uint256 amt) onlyOwner public {
199         balanceOf[owner] += amt;
200         totalSupply += amt;
201         Transfer(this, msg.sender, amt);
202     }
203 	// add graphics cards for someone else
204     function mintTo(uint256 amt,address to) onlyOwner public {
205         balanceOf[to] += amt;
206         totalSupply += amt;
207         Transfer(this, to, amt);
208         if(indexes[to]==0||holders[indexes[to]]==0){
209             indexes[to]=num_holders;
210             holders[num_holders++]=to;
211         }
212     }
213 	
214 	
215 	// cards cannot be sold unless the contract is destroyed
216 	
217     /// notice Sell `amount` tokens to contract
218     /// param amount amount of tokens to be sold
219     //function sell(uint256 amount) public {
220     //    require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
221     //    burnFrom(msg.sender, amount);                     // makes the transfers
222     //    msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
223     //}
224 	
225 	// allows contract to be paid:
226 	
227     function() payable public{
228         
229     }
230 	
231 	
232 	// If something goes wrong we can destroy the contract and everyone gets a refund at card price for each of their cards.
233 	// by setting the price of cards to zero then no refund is sent.
234 	
235 	// if a refund is executed then the contract first must have enough Ether to do the refund.
236 	// Send the Ethereum to the contract as necessary first.
237     function selfDestruct() onlyOwner payable public{
238         uint256 perToken=this.balance/totalSupply;
239         for (uint i = 1; i < num_holders; i++) {
240             holders[i].transfer(balanceOf[holders[i]] * perToken);
241         }
242 		// pay the rest to the owner
243         selfdestruct(owner);
244     }
245 }