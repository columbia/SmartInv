1 pragma solidity 0.4.23;
2 
3 // Implements the ERC20 standard contract
4 contract ERC20Standard 
5 {
6     // #region Fields
7     
8     // The total token supply
9     uint256 internal totalSupply_;
10     
11     // This creates a dictionary with all the balances
12     mapping (address => uint256) internal balances;
13     
14     // This creates a dictionary with allowances
15     mapping (address => mapping (address => uint256)) internal allowed;
16     
17     // #endregion
18     
19     // #region Events
20     
21     // Public events on the blockchain that will notify clients
22     event Transfer(address indexed _from, address indexed _to, uint256 _value);
23     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
24     
25     // #endregion
26     
27     // #region Public methods
28     
29     /// @return Total number of tokens in existence
30     function totalSupply() public view returns (uint256) 
31     {
32         return totalSupply_;
33     }
34     
35     /// @dev Gets the balance of the specified address
36     /// @param _owner The address from which the balance will be retrieved
37     /// @return The balance of the account with address _owner
38     function balanceOf(address _owner) public view returns (uint256) 
39     {
40         return balances[_owner];
41     }
42 
43     /// @dev Transfers _value amount of tokens to address _to
44     /// @param _to The address of the recipient
45     /// @param _value The amount of tokens to be transferred
46     /// @return Whether the transfer was successful or not
47     function transfer(address _to, uint256 _value) public returns (bool) 
48     {
49         require(msg.data.length >= 68);                   // Guard against short address
50         require(_to != 0x0);                              // Prevent transfer to 0x0 address
51         require(balances[msg.sender] >= _value);          // Check if the sender has enough tokens
52         require(balances[_to] + _value >= balances[_to]); // Check for overflows
53         
54         // Update balance
55         balances[msg.sender] -= _value;
56         balances[_to] += _value;
57         
58         // Raise the event
59         emit Transfer(msg.sender, _to, _value);
60         
61         return true;
62     }
63 
64     /// @dev Transfers _value amount of tokens from address _from to address _to
65     /// @param _from The address of the sender
66     /// @param _to The address of the recipient
67     /// @param _value The amount of tokens to be transferred
68     /// @return Whether the transfer was successful or not
69     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
70     {
71         require(msg.data.length >= 68);                   // Guard against short address
72         require(_to != 0x0);                              // Prevent transfer to 0x0 address
73         require(balances[_from] >= _value);               // Check if the sender has enough tokens
74         require(balances[_to] + _value >= balances[_to]); // Check for overflows
75         require(allowed[_from][msg.sender] >= _value);    // Check allowance
76         
77         // Update balance
78         balances[_from] -= _value;
79         balances[_to] += _value;
80         allowed[_from][msg.sender] -= _value;
81         
82         // Raise the event
83         emit Transfer(_from, _to, _value);
84         
85         return true;
86     }
87 
88     /// Sets allowance for another address, i.e. allows _spender to spend _value tokens on behalf of msg.sender.
89     /// ERC20 standard at https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md recommends not implementing 
90     /// checks for the approval double-spend attack, as this should be implemented in user interfaces.
91     /// @param _spender The address of the account able to transfer the tokens
92     /// @param _value The amount of wei to be approved for transfer
93     /// @return Whether the approval was successful or not
94     function approve(address _spender, uint256 _value) public returns (bool) 
95     {
96         allowed[msg.sender][_spender] = _value;
97         
98         // Raise the event
99         emit Approval(msg.sender, _spender, _value);
100         
101         return true;
102     }
103 
104     /// @dev Returns the amount which _spender is still allowed to withdraw from _owner
105     /// @param _owner The address of the account owning tokens
106     /// @param _spender The address of the account able to transfer the tokens
107     /// @return Amount of remaining tokens allowed to spend
108     function allowance(address _owner, address _spender) public view returns (uint256) 
109     {
110         return allowed[_owner][_spender];
111     }
112     
113     // #endregion
114 }
115 
116 // Token that is ERC20 compliant
117 contract BinvToken is ERC20Standard 
118 {
119     // #region Constants
120     
121     string public constant name = "BINV";              
122     string public constant symbol = "BINV";            
123     uint256 public constant initialSupply = 100000000;
124     uint8 public constant decimals = 18;               
125     
126     // #endregion
127     
128     // #region Getters
129     
130     address public owner;                     
131     address public contractAddress;            
132     bool public payableEnabled = false;        
133     uint256 public payableWeiReceived = 0;    
134     uint256 public payableFinneyReceived = 0;  
135     uint256 public payableEtherReceived = 0;       
136     uint256 public milliTokensPaid = 0;        
137     uint256 public milliTokensSent = 0;        
138     
139     uint256 public tokensPerEther = 10000;     
140     uint256 public hardCapInEther = 7000;      
141     uint256 public maxPaymentInEther = 50; 
142     
143     // #endregion
144     
145     // #region Constructors
146     
147     /// @dev Constructor
148     constructor() public
149     {
150         totalSupply_ = initialSupply * (10 ** uint256(decimals));  
151         balances[msg.sender] = totalSupply_;                      
152         
153         owner = msg.sender;              
154         contractAddress = address(this); 
155     }
156     
157     // #endregion
158     
159     // #region Public methods
160     
161     /// @dev payable
162     function() payable public
163     {
164         require(payableEnabled);
165         require(msg.sender != 0x0);
166      
167         require(maxPaymentInEther > uint256(msg.value / (10 ** 18)));
168         require(hardCapInEther > payableEtherReceived);
169         
170         uint256 actualTokensPerEther = getActualTokensPerEther();
171         uint256 tokensAmount = msg.value * actualTokensPerEther;
172         
173         require(balances[owner] >= tokensAmount);
174         
175         balances[owner] -= tokensAmount;
176         balances[msg.sender] += tokensAmount;
177 
178         payableWeiReceived += msg.value;  
179         payableFinneyReceived = uint256(payableWeiReceived / (10 ** 15));
180         payableEtherReceived = uint256(payableWeiReceived / (10 ** 18));
181         milliTokensPaid += uint256(tokensAmount / (10 ** uint256(decimals - 3)));
182 
183         emit Transfer(owner, msg.sender, tokensAmount); 
184                
185         owner.transfer(msg.value); 
186     }
187     
188     /// @dev getOwnerBalance
189     function getOwnerBalance() public view returns (uint256)
190     {
191         return balances[owner];
192     }
193     
194     /// @dev getOwnerBalanceInMilliTokens
195     function getOwnerBalanceInMilliTokens() public view returns (uint256)
196     {
197         return uint256(balances[owner] / (10 ** uint256(decimals - 3)));
198     }
199         
200     /// @dev getActualTokensPerEther
201     function getActualTokensPerEther() public view returns (uint256)
202     {
203        uint256 etherReceived = payableEtherReceived;
204        
205        uint256 bonusPercent = 0;
206        if(etherReceived < 1000)
207            bonusPercent = 16;
208        else if(etherReceived < 2200)
209            bonusPercent = 12; 
210        else if(etherReceived < 3600)
211            bonusPercent = 8; 
212        else if(etherReceived < 5200)
213            bonusPercent = 4; 
214        
215        uint256 actualTokensPerEther = tokensPerEther * (100 + bonusPercent) / 100;
216        return actualTokensPerEther;
217     }
218     
219     /// @dev setTokensPerEther
220     function setTokensPerEther(uint256 amount) public returns (bool)
221     {
222        require(msg.sender == owner); 
223        require(amount > 0);
224        tokensPerEther = amount;
225        
226        return true;
227     }
228     
229     /// @dev setHardCapInEther
230     function setHardCapInEther(uint256 amount) public returns (bool)
231     {
232        require(msg.sender == owner); 
233        require(amount > 0);
234        hardCapInEther = amount;
235        
236        return true;
237     }
238     
239     /// @dev setMaxPaymentInEther
240     function setMaxPaymentInEther(uint256 amount) public returns (bool)
241     {
242        require(msg.sender == owner); 
243        require(amount > 0);
244        maxPaymentInEther = amount;
245        
246        return true;
247     }
248     
249     /// @dev enablePayable
250     function enablePayable() public returns (bool)
251     {
252        require(msg.sender == owner); 
253        payableEnabled = true;
254        
255        return true;
256     }
257     
258     /// @dev disablePayable
259     function disablePayable() public returns (bool)
260     {
261        require(msg.sender == owner); 
262        payableEnabled = false;
263        
264        return true;
265     }
266     
267     /// @dev sendTokens
268     function sendTokens(uint256 milliTokensAmount, address destination) public returns (bool) 
269     {
270         require(msg.sender == owner); 
271         
272         uint256 tokensAmount = milliTokensAmount * (10 ** uint256(decimals - 3));
273         
274         require(balances[owner] >= tokensAmount);
275 
276         balances[owner] -= tokensAmount;
277         balances[destination] += tokensAmount;
278         
279         milliTokensSent += milliTokensAmount;
280 
281         emit Transfer(owner, destination, tokensAmount);
282         
283         return true;
284     }
285     
286     // #endregion
287 }