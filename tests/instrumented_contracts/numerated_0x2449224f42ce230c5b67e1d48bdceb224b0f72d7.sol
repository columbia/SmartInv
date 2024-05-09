1 pragma solidity ^0.4.16;
2 contract owned {
3     address public owner;
4     function owned() public {
5         owner = msg.sender;
6     }
7     modifier onlyOwner {
8         require(msg.sender == owner);
9         _;
10     }	
11 }
12 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
13 contract TokenERC20 {
14     string public name = "DIVMGroup";
15     string public symbol = "DIVM";
16     uint8 public decimals = 18;
17 	uint256 public initialSupply = 10000;
18     uint256 public totalSupply;
19     mapping (address => uint256) public balanceOf;
20     mapping (address => mapping (address => uint256)) public allowance;
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     event Burn(address indexed from, uint256 value);
23     
24     function TokenERC20() public {
25     totalSupply = initialSupply * 1 ether;
26     balanceOf[msg.sender] = totalSupply;
27   }
28     function _transfer(address _from, address _to, uint _value) internal {
29         require(_to != 0x0);
30         require(balanceOf[_from] >= _value);
31         require(balanceOf[_to] + _value > balanceOf[_to]);  	
32         uint previousBalances = balanceOf[_from] + balanceOf[_to];
33         balanceOf[_from] -= _value;
34         balanceOf[_to] += _value;
35         Transfer(_from, _to, _value);
36         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
37     }
38 
39     /**
40      * Transfer tokens
41      *
42      * Send `_value` tokens to `_to` from your account
43      *
44      * @param _to The address of the recipient
45      * @param _value the amount to send
46      */
47     function transfer(address _to, uint256 _value) public {
48         _transfer(msg.sender, _to, _value);
49     }
50 
51     /**
52      * Transfer tokens from other address
53      *
54      * Send `_value` tokens to `_to` in behalf of `_from`
55      *
56      * @param _from The address of the sender
57      * @param _to The address of the recipient
58      * @param _value the amount to send
59      */
60     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
61         require(_value <= allowance[_from][msg.sender]);    
62         allowance[_from][msg.sender] -= _value;
63         _transfer(_from, _to, _value);
64         return true;
65     }
66 
67     /**
68      * Set allowance for other address
69      *
70      * Allows `_spender` to spend no more than `_value` tokens in your behalf
71      *
72      * @param _spender The address authorized to spend
73      * @param _value the max amount they can spend
74      */
75     function approve(address _spender, uint256 _value) public
76         returns (bool success) {
77         allowance[msg.sender][_spender] = _value;
78         return true;
79     }
80 
81     /**
82      * Set allowance for other address and notify
83      *
84      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
85      *
86      * @param _spender The address authorized to spend
87      * @param _value the max amount they can spend
88      * @param _extraData some extra information to send to the approved contract
89      */
90     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
91         tokenRecipient spender = tokenRecipient(_spender);
92         if (approve(_spender, _value)) {
93             spender.receiveApproval(msg.sender, _value, this, _extraData);
94             return true;
95         }
96     }
97 
98     /**
99      * Destroy tokens
100      *
101      * Remove `_value` tokens from the system irreversibly
102      *
103      * @param _value the amount of money to burn
104      */
105     function burn(uint256 _value) public returns (bool success) {
106         require(balanceOf[msg.sender] >= _value);   
107         balanceOf[msg.sender] -= _value;            
108         totalSupply -= _value;                      
109         Burn(msg.sender, _value);
110         return true;
111     }
112 
113     /**
114      * Destroy tokens from other account
115      *
116      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
117      *
118      * @param _from the address of the sender
119      * @param _value the amount of money to burn
120      */
121     function burnFrom(address _from, uint256 _value) public returns (bool success) {
122         require(balanceOf[_from] >= _value);                
123         require(_value <= allowance[_from][msg.sender]);    
124         balanceOf[_from] -= _value;                         
125         allowance[_from][msg.sender] -= _value;             
126         totalSupply -= _value;                              
127         Burn(_from, _value);
128         return true;
129     }
130 }
131 contract MyAdvancedToken is owned, TokenERC20 {
132 	address public beneficiary;
133 	address public reserveFund;
134 	address public Bounty;
135     uint256 public sellPriceInWei;
136     uint256 public buyPriceInWei;
137 	uint256 public Limit;
138 	uint256 public issueOfTokens;
139     bool    public TokenSaleStop = false;
140     mapping (address => bool) public frozenAccount;
141     event FrozenFunds(address target, bool frozen);
142 	
143     function MyAdvancedToken()  public {
144 	beneficiary = 0xe0C3c3FBA6D9793EDCeA6EA18298Fe22310Ed094;
145 	Bounty = 0xC87bB60EB3f7052f66E60BB5d961Eeffee1A8765;
146 	reserveFund = 0x60ab253bD32429ACD4242f14F54A8e50E233c0C5;
147 	}
148 
149     function _transfer(address _from, address _to, uint _value) internal {
150         require (_to != 0x0);                               
151         require (balanceOf[_from] > _value);               
152         require (balanceOf[_to] + _value > balanceOf[_to]); 
153         require(!frozenAccount[_from]);                    
154         require(!frozenAccount[_to]);                       
155         balanceOf[_from] -= _value;                        
156         balanceOf[_to] += _value;                          
157         Transfer(_from, _to, _value);
158     }
159 	
160     /// @notice Create `mintedAmount` tokens and send it to `target`
161     /// @param target Address to receive the tokens
162     /// @param mintedAmount the amount of tokens it will receive
163     function mintToken(address target, uint256 mintedAmount) onlyOwner  public  {
164 	    require (!TokenSaleStop);
165         require (mintedAmount <= 7000000 * 1 ether - totalSupply);
166         require (totalSupply + mintedAmount <= 7000000 * 1 ether); 
167         balanceOf[target] += mintedAmount;
168         totalSupply += mintedAmount;
169 		issueOfTokens = totalSupply / 1 ether - initialSupply;
170         Transfer(0, this, mintedAmount);
171         Transfer(this, target, mintedAmount);
172     }
173 
174     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
175     /// @param target Address to be frozen
176     /// @param freeze either to freeze it or not
177     function freezeAccount(address target, bool freeze) onlyOwner public {
178         frozenAccount[target] = freeze;
179         FrozenFunds(target, freeze);
180     }
181 
182     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
183     /// @param newSellPrice Price in wei the users can sell to the contract
184     /// @param newBuyPrice Price in wei users can buy from the contract  
185     function setPrices(uint256 newSellPrice, uint256 newBuyPrice, uint256 newLimit) onlyOwner public {
186         sellPriceInWei = newSellPrice;
187         buyPriceInWei = newBuyPrice;
188 		Limit = newLimit;
189     }
190 
191     /// @notice Buy tokens from contract by sending ether  
192     function () payable public {
193 	    require (msg.value * Limit / 1 ether > 1);
194 	    require (!TokenSaleStop);
195         uint amount = msg.value * 1 ether / buyPriceInWei;               
196         _transfer(this, msg.sender, amount);
197         if (this.balance > 2 ether) {
198 		Bounty.transfer(msg.value / 40);}		
199 		if (this.balance > 10 ether) {
200 		reserveFund.transfer(msg.value / 7);}
201     }
202 
203     function forwardFunds(uint256 withdraw) onlyOwner public {
204 	     require (withdraw > 0);
205          beneficiary.transfer(withdraw * 1 ether);  
206   }
207 	
208     /// @notice Sell `amount` tokens to contract
209     /// @param amount  of tokens to be sold
210     function sell(uint256 amount) public {
211 	    require (amount > Limit);
212 	    require (!TokenSaleStop);
213         require(this.balance >= amount * sellPriceInWei);       
214         _transfer(msg.sender, this, amount * 1 ether);              
215         msg.sender.transfer(amount * sellPriceInWei);          
216     }
217     	  
218   function crowdsaleStop(bool Stop) onlyOwner public {
219       TokenSaleStop = Stop;
220   }
221 }