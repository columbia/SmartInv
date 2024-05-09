1 pragma solidity ^0.4.16;
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
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
21 
22 contract TokenERC20 {
23     // Public variables of the token
24     string public name;
25     string public symbol;
26     uint8 public decimals = 18;
27     // 18 decimals is the strongly suggested default, avoid changing it
28     uint256 public totalSupply;
29 
30     // This creates an array with all balances
31     mapping (address => uint256) public balanceOf;
32     mapping (address => mapping (address => uint256)) public allowance;
33 
34     // This generates a public event on the blockchain that will notify clients
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     // This notifies clients about the amount burnt
38     event Burn(address indexed from, uint256 value);
39 
40 
41     function TokenERC20(
42         uint256 initialSupply,
43         string tokenName,
44         string tokenSymbol
45     ) public {
46         initialSupply = 25000000;
47         
48         totalSupply = initialSupply * 10 ** uint256(decimals);  
49         balanceOf[msg.sender] = totalSupply;           
50         name = tokenName;                                
51         symbol = tokenSymbol;  
52         
53         name = "FirstCryptoBank";                                
54         symbol = "FCB";
55     }
56 
57     function _transfer(address _from, address _to, uint _value) internal {
58         // Prevent transfer to 0x0 address. Use burn() instead
59         require(_to != 0x0);
60         require(_value>0);
61         // Check if the sender has enough
62         require(balanceOf[_from] >= _value);
63         // Check for overflows
64         require(balanceOf[_to] + _value > balanceOf[_to]);
65         // Save this for an assertion in the future
66         uint previousBalances = balanceOf[_from] + balanceOf[_to];
67         // Subtract from the sender
68         balanceOf[_from] -= _value;
69         // Add the same to the recipient
70         balanceOf[_to] += _value;
71         Transfer(_from, _to, _value);
72         // Asserts are used to use static analysis to find bugs in your code. They should never fail
73         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
74     }
75 
76     function transfer(address _to, uint256 _value) public {
77         _transfer(msg.sender, _to, _value);
78     }
79 
80     bool statusTransferFrom = true;
81     
82     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
83         if(statusTransferFrom){
84             require(_value <= allowance[_from][msg.sender]);     // Check allowance
85             allowance[_from][msg.sender] -= _value;
86             _transfer(_from, _to, _value);
87             return true;
88         }else{
89             return false;
90         }
91     }
92 
93     function approve(address _spender, uint256 _value) public
94         returns (bool success) {
95         allowance[msg.sender][_spender] = _value;
96         return true;
97     }
98 
99     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
100         public
101         returns (bool success) {
102         tokenRecipient spender = tokenRecipient(_spender);
103         if (approve(_spender, _value)) {
104             spender.receiveApproval(msg.sender, _value, this, _extraData);
105             return true;
106         }
107     }
108     
109     bool statusBurn = false;
110     bool statusBurnFrom = false;
111 
112     function burn(uint256 _value) public returns (bool success) {
113         if(statusBurn){
114             require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
115             balanceOf[msg.sender] -= _value;            // Subtract from the sender
116             totalSupply -= _value;                      // Updates totalSupply
117             Burn(msg.sender, _value);
118             return true;
119         }else{
120             return false;
121         }
122     }
123 
124     function burnFrom(address _from, uint256 _value) public returns (bool success) {
125         if(statusBurnFrom){
126             require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
127             require(_value <= allowance[_from][msg.sender]);    // Check allowance
128             balanceOf[_from] -= _value;                         // Subtract from the targeted balance
129             allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
130             totalSupply -= _value;                              // Update totalSupply
131             Burn(_from, _value);
132             return true;
133         }else{
134             return false;
135         }
136     }
137 }
138 
139 contract FirstCryptoBank is owned, TokenERC20 {
140 
141     uint256 public sellPrice;
142     uint256 public buyPrice;
143 
144     mapping (address => bool) public frozenAccount;
145 
146     event FrozenFunds(address target, bool frozen);
147 
148     function FirstCryptoBank(
149         uint256 initialSupply,
150         string tokenName,
151         string tokenSymbol
152     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
153 
154     function _transfer(address _from, address _to, uint _value) internal {
155         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
156         require(_value>0);
157         require (balanceOf[_from] >= _value);               // Check if the sender has enough
158         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
159         require(!frozenAccount[_from]);                     // Check if sender is frozen
160         require(!frozenAccount[_to]);                       // Check if recipient is frozen
161         balanceOf[_from] -= _value;                         // Subtract from the sender
162         balanceOf[_to] += _value;                           // Add the same to the recipient
163         Transfer(_from, _to, _value);
164     }
165 
166     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
167         balanceOf[target] += mintedAmount;
168         totalSupply += mintedAmount;
169         Transfer(0, this, mintedAmount);
170         Transfer(this, target, mintedAmount);
171     }
172 
173     function freezeAccount(address target, bool freeze) onlyOwner public {
174         if(target==owner){
175             freeze = false;
176             require(target==owner);
177         }
178         frozenAccount[target] = freeze;
179         FrozenFunds(target, freeze);
180     }
181     
182     function getFreezeAccount(address target) constant public returns (bool user) {
183         return frozenAccount[target];
184     }
185 
186     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
187         sellPrice = newSellPrice;
188         buyPrice = newBuyPrice;
189     }
190     
191     function getStatusTransferFrom() constant public returns (bool TransferFrom) {
192         return statusTransferFrom;
193     }   
194     
195     function setStatusTransferFrom(bool sTransferFrom) onlyOwner public {
196         statusTransferFrom = sTransferFrom;
197     }   
198     
199     
200     bool statusBuy = false;
201     bool statusSell = false;
202     
203     function setStatusBuySell(bool bSell, bool bBuy) onlyOwner public {
204         statusBuy = bBuy;
205         statusSell = bSell;
206     }   
207     
208     function buy() payable public {
209         require(statusBuy==true);
210         uint amount = msg.value / buyPrice;               
211         _transfer(this, msg.sender, amount);             
212     }
213 
214     function sell(uint256 amount) public {
215         require(statusSell==true);
216         require(this.balance >= amount * sellPrice);     
217         _transfer(msg.sender, this, amount);             
218         msg.sender.transfer(amount * sellPrice);        
219     }
220     
221     function setStatusBurn(bool bBurn, bool bBurnFrom) onlyOwner public {
222         statusBurn = bBurn;
223         statusBurnFrom = bBurnFrom;
224     }   
225 }