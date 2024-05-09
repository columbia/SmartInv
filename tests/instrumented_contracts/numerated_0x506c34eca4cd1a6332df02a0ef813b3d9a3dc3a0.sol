1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5     function owned() public {
6         owner = msg.sender;
7     }
8     modifier onlyOwner {
9         require(msg.sender == owner);
10         _;
11     }
12     function transferOwnership(address newOwner) onlyOwner public {
13         owner = newOwner;
14     }
15 }
16 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
17 contract INDTokenERC20 {
18     string public constant _myTokeName = 'IndoToken';
19     string public constant _mySymbol = 'INDT';
20     uint public constant _myinitialSupply = 100000000;
21     uint8 public constant _myDecimal = 0;
22     string public name;
23     string public symbol;
24     uint8 public decimals;
25     uint256 public totalSupply;
26     mapping (address => uint256) public balanceOf;
27     mapping (address => mapping (address => uint256)) public allowance;
28     event Transfer(address indexed from, address indexed to, uint256 value);
29     event Burn(address indexed from, uint256 value);
30     /**
31      * Internal transfer, only can be called by this contract
32      */
33     function _transfer(address _from, address _to, uint _value) internal {
34         require(_to != 0x0);
35         require(balanceOf[_from] >= _value);
36         require(balanceOf[_to] + _value > balanceOf[_to]);
37         uint previousBalances = balanceOf[_from] + balanceOf[_to];
38         balanceOf[_from] -= _value;
39         balanceOf[_to] += _value;
40         Transfer(_from, _to, _value);
41         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
42     }
43 
44     /**
45      * Transfer tokens
46      *
47      * Send `_value` tokens to `_to` from your account
48      *
49      * @param _to The address of the recipient
50      * @param _value the amount to send
51      */
52     function transfer(address _to, uint256 _value) public {
53         _transfer(msg.sender, _to, _value);
54     }
55 
56     /**
57      * Transfer tokens from other address
58      *
59      * Send `_value` tokens to `_to` in behalf of `_from`
60      *
61      * @param _from The address of the sender
62      * @param _to The address of the recipient
63      * @param _value the amount to send
64      */
65     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
66         require(_value <= allowance[_from][msg.sender]);     
67         allowance[_from][msg.sender] -= _value;
68         _transfer(_from, _to, _value);
69         return true;
70     }
71 
72     /**
73      * Set allowance for other address
74      *
75      * Allows `_spender` to spend no more than `_value` tokens in your behalf
76      *
77      * @param _spender The address authorized to spend
78      * @param _value the max amount they can spend
79      */
80     function approve(address _spender, uint256 _value) public
81         returns (bool success) {
82         allowance[msg.sender][_spender] = _value;
83         return true;
84     }
85 
86     /**
87      * Set allowance for other address and notify
88      *
89      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
90      *
91      * @param _spender The address authorized to spend
92      * @param _value the max amount they can spend
93      * @param _extraData some extra information to send to the approved contract
94      */
95     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
96         public
97         returns (bool success) {
98         tokenRecipient spender = tokenRecipient(_spender);
99         if (approve(_spender, _value)) {
100             spender.receiveApproval(msg.sender, _value, this, _extraData);
101             return true;
102         }
103     }
104 
105     /**
106      * Destroy tokens
107      *
108      * Remove `_value` tokens from the system irreversibly
109      *
110      * @param _value the amount of money to burn
111      */
112     function burn(uint256 _value) public returns (bool success) {
113         require(balanceOf[msg.sender] >= _value);   
114         balanceOf[msg.sender] -= _value;            
115         totalSupply -= _value;                      
116         return true;
117     }
118 
119     /**
120      * Destroy tokens from other account
121      *
122      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
123      *
124      * @param _from the address of the sender
125      * @param _value the amount of money to burn
126      */
127     function burnFrom(address _from, uint256 _value) public returns (bool success) {
128         require(balanceOf[_from] >= _value);                
129         require(_value <= allowance[_from][msg.sender]);    
130         balanceOf[_from] -= _value;                         
131         allowance[_from][msg.sender] -= _value;             
132         totalSupply -= _value;                              
133         Burn(_from, _value);
134         return true;
135     }
136 }
137 contract INDT is owned, INDTokenERC20 {
138 
139     uint256 public sellPrice;
140     uint256 public buyPrice;
141 
142     mapping (address => bool) public frozenAccount;
143 
144    
145     event FrozenFunds(address target, bool frozen);
146 
147     
148     function INDT(
149         uint256 initialSupply,
150         string tokenName,
151         string tokenSymbol
152     )INDT(initialSupply, tokenName, tokenSymbol) public {}
153 
154     function _transfer(address _from, address _to, uint _value) internal {
155         require (_to != 0x0);                               
156         require (balanceOf[_from] >= _value);               
157         require (balanceOf[_to] + _value > balanceOf[_to]); 
158         require(!frozenAccount[_from]);                     
159         require(!frozenAccount[_to]);                       
160         balanceOf[_from] -= _value;                         
161         balanceOf[_to] += _value;                           
162         Transfer(_from, _to, _value);
163     }
164 
165     /// @notice Create `mintedAmount` tokens and send it to `target`
166     /// @param target Address to receive the tokens
167     /// @param mintedAmount the amount of tokens it will receive
168     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
169         balanceOf[target] += mintedAmount;
170         totalSupply += mintedAmount;
171         Transfer(0, this, mintedAmount);
172         Transfer(this, target, mintedAmount);
173     }
174 
175     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
176     /// @param target Address to be frozen
177     /// @param freeze either to freeze it or not
178     function freezeAccount(address target, bool freeze) onlyOwner public {
179         frozenAccount[target] = freeze;
180         FrozenFunds(target, freeze);
181     }
182 
183     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
184     /// @param newSellPrice Price the users can sell to the contract
185     /// @param newBuyPrice Price users can buy from the contract
186     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
187         sellPrice = newSellPrice;
188         buyPrice = newBuyPrice;
189     }
190 
191     /// @notice Buy tokens from contract by sending ether
192     function buy() payable public {
193         uint amount = msg.value / buyPrice;              
194         _transfer(this, msg.sender, amount);             
195     }
196 
197     /// @notice Sell `amount` tokens to contract
198     /// @param amount amount of tokens to be sold
199     function sell(uint256 amount) public {
200         require(this.balance >= amount * sellPrice);      
201         _transfer(msg.sender, this, amount);              
202         msg.sender.transfer(amount * sellPrice);          
203     }
204 }