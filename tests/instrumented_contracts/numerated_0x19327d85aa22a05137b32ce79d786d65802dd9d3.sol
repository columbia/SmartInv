1 pragma solidity ^0.4.16;
2 //
3 // FogLink Token
4 // Author: FNK
5 // Contact: support@foglink.io
6 //
7 contract owned {
8     address public owner;
9 
10     function owned() public {
11         owner = msg.sender;
12     }
13 
14     modifier onlyOwner {
15         require(msg.sender == owner);
16         _;
17     }
18 
19     function transferOwnership(address newOwner) onlyOwner public {
20         owner = newOwner;
21     }
22 }
23 
24 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
25 
26 contract TokenERC20 {
27     string public name;
28     string public symbol;
29     uint8 public decimals = 18;
30     uint256 public totalSupply;
31 
32     mapping (address => uint256) public balanceOf;
33     mapping (address => mapping (address => uint256)) public allowance;
34 
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     event Burn(address indexed from, uint256 value);
38 
39     /**
40      * Constrctor function
41      *
42      * Initializes contract with initial supply tokens to the creator of the contract
43      */
44     function TokenERC20(
45         uint256 initialSupply,
46         string tokenName,
47         string tokenSymbol
48     ) public {
49         totalSupply = initialSupply * 10 ** uint256(decimals);
50         balanceOf[msg.sender] = totalSupply;
51         name = tokenName;
52         symbol = tokenSymbol;
53     }
54 
55     /**
56      * Internal transfer, only can be called by this contract
57      */
58     function _transfer(address _from, address _to, uint _value) internal {
59         require(_to != 0x0);
60         require(balanceOf[_from] >= _value);
61         require(balanceOf[_to] + _value > balanceOf[_to]);
62         uint previousBalances = balanceOf[_from] + balanceOf[_to];
63         balanceOf[_from] -= _value;
64         balanceOf[_to] += _value;
65         Transfer(_from, _to, _value);
66         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
67     }
68 
69     /**
70      * Transfer tokens
71      *
72      * Send `_value` tokens to `_to` from your account
73      *
74      * @param _to The address of the recipient
75      * @param _value the amount to send
76      */
77     function transfer(address _to, uint256 _value) public {
78         _transfer(msg.sender, _to, _value);
79     }
80 
81     /**
82      * Transfer tokens from other address
83      *
84      * Send `_value` tokens to `_to` in behalf of `_from`
85      *
86      * @param _from The address of the sender
87      * @param _to The address of the recipient
88      * @param _value the amount to send
89      */
90     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
91         require(_value <= allowance[_from][msg.sender]);
92         allowance[_from][msg.sender] -= _value;
93         _transfer(_from, _to, _value);
94         return true;
95     }
96 
97     /**
98      * Set allowance for other address
99      *
100      * Allows `_spender` to spend no more than `_value` tokens in your behalf
101      *
102      * @param _spender The address authorized to spend
103      * @param _value the max amount they can spend
104      */
105     function approve(address _spender, uint256 _value) public
106         returns (bool success) {
107         allowance[msg.sender][_spender] = _value;
108         return true;
109     }
110 
111     /**
112      * Set allowance for other address and notify
113      *
114      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
115      *
116      * @param _spender The address authorized to spend
117      * @param _value the max amount they can spend
118      * @param _extraData some extra information to send to the approved contract
119      */
120     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
121         public
122         returns (bool success) {
123         tokenRecipient spender = tokenRecipient(_spender);
124         if (approve(_spender, _value)) {
125             spender.receiveApproval(msg.sender, _value, this, _extraData);
126             return true;
127         }
128     }
129 
130     /**
131      * Destroy tokens
132      *
133      * Remove `_value` tokens from the system irreversibly
134      *
135      * @param _value the amount of money to burn
136      */
137     function burn(uint256 _value) public returns (bool success) {
138         require(balanceOf[msg.sender] >= _value);
139         balanceOf[msg.sender] -= _value;
140         totalSupply -= _value;
141         Burn(msg.sender, _value);
142         return true;
143     }
144 
145     /**
146      * Destroy tokens from other account
147      *
148      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
149      *
150      * @param _from the address of the sender
151      * @param _value the amount of money to burn
152      */
153     function burnFrom(address _from, uint256 _value) public returns (bool success) {
154         require(balanceOf[_from] >= _value);
155         require(_value <= allowance[_from][msg.sender]);
156         balanceOf[_from] -= _value;
157         allowance[_from][msg.sender] -= _value;
158         totalSupply -= _value;
159         Burn(_from, _value);
160         return true;
161     }
162 }
163 
164 /******************************************/
165 /*       FNKToken                         */
166 /******************************************/
167 
168 contract FNKToken is owned, TokenERC20 {
169 
170     uint256 public sellPrice;
171     uint256 public buyPrice;
172 
173     mapping (address => bool) public frozenAccount;
174 
175     /* This generates a public event on the blockchain that will notify clients */
176     event FrozenFunds(address target, bool frozen);
177 
178     /* Initializes contract with initial supply tokens to the creator of the contract */
179     function FNKToken(
180         uint256 initialSupply,
181         string tokenName,
182         string tokenSymbol
183     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
184 
185     /* Internal transfer, only can be called by this contract */
186     function _transfer(address _from, address _to, uint _value) internal {
187         require (_to != 0x0);
188         require (balanceOf[_from] >= _value);
189         require (balanceOf[_to] + _value > balanceOf[_to]);
190         require(!frozenAccount[_from]);
191         require(!frozenAccount[_to]);
192         balanceOf[_from] -= _value;
193         balanceOf[_to] += _value;
194         Transfer(_from, _to, _value);
195     }
196 
197     /// @notice Create `mintedAmount` tokens and send it to `target`
198     /// @param target Address to receive the tokens
199     /// @param mintedAmount the amount of tokens it will receive
200     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
201         balanceOf[target] += mintedAmount;
202         totalSupply += mintedAmount;
203         Transfer(0, this, mintedAmount);
204         Transfer(this, target, mintedAmount);
205     }
206 
207     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
208     /// @param target Address to be frozen
209     /// @param freeze either to freeze it or not
210     function freezeAccount(address target, bool freeze) onlyOwner public {
211         frozenAccount[target] = freeze;
212         FrozenFunds(target, freeze);
213     }
214 
215     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
216     /// @param newSellPrice Price the users can sell to the contract
217     /// @param newBuyPrice Price users can buy from the contract
218     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
219         sellPrice = newSellPrice;
220         buyPrice = newBuyPrice;
221     }
222 
223     /// @notice Buy tokens from contract by sending ether
224     function buy() payable public {
225         uint amount = msg.value / buyPrice;
226         _transfer(this, msg.sender, amount);
227     }
228 
229     /// @notice Sell `amount` tokens to contract
230     /// @param amount amount of tokens to be sold
231     function sell(uint256 amount) public {
232         require(this.balance >= amount * sellPrice);
233         _transfer(msg.sender, this, amount); 
234         msg.sender.transfer(amount * sellPrice);
235     }
236 }