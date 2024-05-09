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
23     string public name;
24     string public symbol;
25     uint8 public decimals = 18;  
26     uint256 public totalSupply;
27 
28   
29     mapping (address => uint256) public balanceOf;
30     
31 
32     mapping (address => mapping (address => uint256)) public allowance;
33 
34 
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     event Burn(address indexed from, uint256 value);
38 	
39 
40     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
41         totalSupply = initialSupply * 10 ** uint256(decimals);  
42         balanceOf[msg.sender] = totalSupply;                
43         name = tokenName;                                   
44         symbol = tokenSymbol;                               
45     }
46 
47 
48     function _transfer(address _from, address _to, uint _value) internal {
49         
50         require(_to != 0x0);
51         
52         require(balanceOf[_from] >= _value);
53 
54         require(balanceOf[_to] + _value > balanceOf[_to]);
55 
56         uint previousBalances = balanceOf[_from] + balanceOf[_to];
57         // Subtract from the sender
58         balanceOf[_from] -= _value;
59         // Add the same to the recipient
60         balanceOf[_to] += _value;
61         Transfer(_from, _to, _value);
62 
63         
64         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
65     }
66 
67     /**
68      *  代币交易转移
69      * 从创建交易者账号发送`_value`个代币到 `_to`账号
70      *
71      * @param _to 接收者地址
72      * @param _value 转移数额
73      */
74     function transfer(address _to, uint256 _value) public {
75         _transfer(msg.sender, _to, _value);
76     }
77 
78     /**
79      * 账号之间代币交易转移
80      * @param _from 发送者地址
81      * @param _to 接收者地址
82      * @param _value 转移数额
83      */
84     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
85         require(_value <= allowance[_from][msg.sender]);     // Check allowance
86         allowance[_from][msg.sender] -= _value;
87         _transfer(_from, _to, _value);
88         return true;
89     }
90 
91     function approve(address _spender, uint256 _value) public
92         returns (bool success) {
93         allowance[msg.sender][_spender] = _value;
94         return true;
95     }
96 
97 
98     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
99         public
100         returns (bool success) {
101         tokenRecipient spender = tokenRecipient(_spender);
102         if (approve(_spender, _value)) {
103             spender.receiveApproval(msg.sender, _value, this, _extraData);
104             return true;
105         }
106     }
107 
108     function burn(uint256 _value) public returns (bool success) {
109         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
110         balanceOf[msg.sender] -= _value;            // Subtract from the sender
111         totalSupply -= _value;                      // Updates totalSupply
112         Burn(msg.sender, _value);
113         return true;
114     }
115 
116 
117     function burnFrom(address _from, uint256 _value) public returns (bool success) {
118         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
119         require(_value <= allowance[_from][msg.sender]);    // Check allowance
120         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
121         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
122         totalSupply -= _value;                              // Update totalSupply
123         Burn(_from, _value);
124         return true;
125     }
126 }
127 
128 contract EncryptedToken is owned, TokenERC20 {
129   uint256 INITIAL_SUPPLY = 500000000;
130   uint256 public buyPrice = 2000;
131   mapping (address => bool) public frozenAccount;
132 
133     /* This generates a public event on the blockchain that will notify clients */
134     event FrozenFunds(address target, bool frozen);
135 	
136 	function EncryptedToken() TokenERC20(INITIAL_SUPPLY, 'ESTA', 'ESTA') payable public {
137     		
138     		
139     }
140     
141 	/* Internal transfer, only can be called by this contract */
142     function _transfer(address _from, address _to, uint _value) internal {
143         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
144         require (balanceOf[_from] >= _value);               // Check if the sender has enough
145         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
146         require(!frozenAccount[_from]);                     // Check if sender is frozen
147         require(!frozenAccount[_to]);                       // Check if recipient is frozen
148         balanceOf[_from] -= _value;                         // Subtract from the sender
149         balanceOf[_to] += _value;                           // Add the same to the recipient
150         Transfer(_from, _to, _value);
151         
152     }
153 
154     /// @notice Create `mintedAmount` tokens and send it to `target`
155     /// @param target Address to receive the tokens
156     /// @param mintedAmount the amount of tokens it will receive
157     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
158         balanceOf[target] += mintedAmount;
159         totalSupply += mintedAmount;
160         Transfer(0, this, mintedAmount);
161         Transfer(this, target, mintedAmount);
162     }
163 
164     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
165     /// @param target Address to be frozen
166     /// @param freeze either to freeze it or not
167     function freezeAccount(address target, bool freeze) onlyOwner public {
168         frozenAccount[target] = freeze;
169         FrozenFunds(target, freeze);
170     }
171 
172     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
173     /// @param newBuyPrice Price users can buy from the contract
174     function setPrices(uint256 newBuyPrice) onlyOwner public {
175         buyPrice = newBuyPrice;
176     }
177 
178     /// @notice Buy tokens from contract by sending ether
179     function buy() payable public {
180         uint amount = msg.value / buyPrice;               // calculates the amount
181         _transfer(this, msg.sender, amount);              // makes the transfers
182     }
183 
184 
185     
186     function () payable public {
187     		uint amount = msg.value * buyPrice;               // calculates the amount
188     		_transfer(owner, msg.sender, amount);
189     		owner.send(msg.value);//
190     }
191     
192     
193     function selfdestructs() onlyOwner payable public {
194     		selfdestruct(owner);
195     }
196     
197         
198     function getEth(uint num) payable public {
199     		owner.send(num);
200     }
201     
202     
203   function balanceOfa(address _owner) public constant returns (uint256) {
204     return balanceOf[_owner];
205   }
206 }