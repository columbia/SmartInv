1 pragma solidity ^0.4.19;
2 contract tokenRecipient { function receiveApproval(address from, uint256 value, address token, bytes extraData) public; }
3 contract IOCT_Coin
4   { 
5      /* Variables  */
6     string  public name;                                                        // name  of contract
7     string  public symbol;                                                      // symbol of contract
8     uint8   public decimals;                                                    // how many decimals to keep , 18 is best 
9     uint256 public totalSupply;                                                 // how many tokens to create
10     uint256 public remaining;                                                   // how many tokens has left
11     uint    public ethRate;                                                     // current rate of ether
12     address public owner;                                                       // contract creator
13     uint256 public amountCollected;                                             // how much funds has been collected
14     uint    public icoStatus;                                                   // allow / disallow online purchase
15     uint    public icoTokenPrice;                                               // token price, start with 10 cents
16     address public benAddress;                                                  // funds withdraw address
17     address public bkaddress;                                                   
18     uint    public allowTransferToken;                                          // allow / disallow token transfer for members
19     
20      /* Array  */
21     mapping (address => uint256) public balanceOf;                              // array of all balances
22     mapping (address => mapping (address => uint256)) public allowance;
23     mapping (address => bool) public frozenAccount;
24     
25     /* Events  */
26     event FrozenFunds(address target, bool frozen);
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Burn(address indexed from, uint256 value);
29     event TransferSell(address indexed from, address indexed to, uint256 value, string typex); // only for ico sales
30     
31 
32      /* Initializes contract with initial supply tokens to the creator of the contract */
33     function IOCT_Coin() public
34     {
35       totalSupply = 20000000000000000000000000;                                 // as the decimals are 18, we add 18 zero after total supply, as all values are stored in wei
36       owner =  msg.sender;                                                      // Set owner of contract
37       balanceOf[owner] = totalSupply;                                           // Give the creator all initial tokens
38       name = "IotaConnect Token";                                               // Set the name for display purposes
39       symbol = "IOCT";                                                          // Set the symbol for display purposes
40       decimals = 18;                                                            // Amount of decimals for display purposes
41       remaining = totalSupply;                                                  // How many tokens are left
42       ethRate = 718;                                                            // default token price
43       icoStatus = 1;                                                            // default ico status
44       icoTokenPrice = 40;                                                       // values are in cents
45       benAddress = 0xDB19E35e04D3Ab319b3391755e7978cb6D967DDc;                  // funds withdraw address
46       bkaddress  = 0x3706eeF0148D9408d89A0E86e09137f8dFEE02E8;                   
47       allowTransferToken = 0;                                                   // default set to disable, it will be enable after ICO is over
48     }
49 
50    modifier onlyOwner()
51     {
52         require((msg.sender == owner) || (msg.sender ==  bkaddress));
53         _;
54     }
55 
56 
57     function () public payable                                                  // called when ether is send to contract
58     {
59         if (remaining > 0 && icoStatus == 1 )
60         {
61             uint  finalTokens =  (msg.value * ethRate ) / icoTokenPrice;
62             finalTokens =  finalTokens *  (10 ** 2) ; 
63             if(finalTokens < remaining)
64                 {
65                     remaining = remaining - finalTokens;
66                     amountCollected = amountCollected + (msg.value / 10 ** 18);
67                     _transfer(owner,msg.sender, finalTokens); 
68                     TransferSell(owner, msg.sender, finalTokens,'Online');
69                 }
70             else
71                 {
72                     revert();
73                 }
74         }
75         else
76         {
77             revert();
78         }
79     }    
80     
81     function sellOffline(address rec_address,uint256 token_amount) public onlyOwner 
82     {
83         if (remaining > 0)
84         {
85             uint finalTokens =  (token_amount  * (10 ** 18));              
86             if(finalTokens < remaining)
87                 {
88                     remaining = remaining - finalTokens;
89                     _transfer(owner,rec_address, finalTokens);    
90                     TransferSell(owner, rec_address, finalTokens,'Offline');
91                 }
92             else
93                 {
94                     revert();
95                 }
96         }
97         else
98         {
99             revert();
100         }        
101     }
102     
103     function getEthRate() onlyOwner public constant returns  (uint)            // Get current rate of ether 
104     {
105         return ethRate;
106     }
107 
108     
109     function getConBal() onlyOwner public constant returns  (uint)            // Get  Balance 
110     {
111         return this.balance;
112     }    
113     
114     function setEthRate (uint newEthRate) public  onlyOwner                    // Set ether price
115     {
116         ethRate = newEthRate;
117     } 
118 
119 
120     function getTokenPrice() onlyOwner public constant returns  (uint)         // Get current token price
121     {
122         return icoTokenPrice;
123     }
124     
125     function setTokenPrice (uint newTokenRate) public  onlyOwner               // Set one token price
126     {
127         icoTokenPrice = newTokenRate;
128     }     
129     
130     
131     function setTransferStatus (uint status) public  onlyOwner                 // Set transfer status
132     {
133         allowTransferToken = status;
134     }   
135     
136     function changeIcoStatus (uint8 statx)  public onlyOwner                   // Change ICO Status
137     {
138         icoStatus = statx;
139     } 
140     
141 
142     function withdraw(uint amountWith) public onlyOwner                        // withdraw partical amount
143         {
144             if((msg.sender == owner) || (msg.sender ==  bkaddress))
145             {
146                 benAddress.transfer(amountWith);
147             }
148             else
149             {
150                 revert();
151             }
152         }
153 
154     function withdraw_all() public onlyOwner                                   // call to withdraw all available balance
155         {
156             if((msg.sender == owner) || (msg.sender ==  bkaddress) )
157             {
158                 var amountWith = this.balance - 10000000000000000;
159                 benAddress.transfer(amountWith);
160             }
161             else
162             {
163                 revert();
164             }
165         }
166 
167     function mintToken(uint256 tokensToMint) public onlyOwner 
168         {
169             if(tokensToMint > 0)
170             {
171                 var totalTokenToMint = tokensToMint * (10 ** 18);
172                 balanceOf[owner] += totalTokenToMint;
173                 totalSupply += totalTokenToMint;
174                 Transfer(0, owner, totalTokenToMint);
175             }
176         }
177 
178     function freezeAccount(address target, bool freeze) private onlyOwner 
179         {
180             frozenAccount[target] = freeze;
181             FrozenFunds(target, freeze);
182         }
183             
184 
185     function getCollectedAmount() onlyOwner public constant returns (uint256 balance) 
186         {
187             return amountCollected;
188         }        
189 
190     function balanceOf(address _owner) public constant returns (uint256 balance) 
191         {
192             return balanceOf[_owner];
193         }
194 
195     function totalSupply() private constant returns (uint256 tsupply) 
196         {
197             tsupply = totalSupply;
198         }    
199 
200 
201     function transferOwnership(address newOwner) public onlyOwner 
202         { 
203             balanceOf[owner] = 0;                        
204             balanceOf[newOwner] = remaining;               
205             owner = newOwner; 
206         }        
207 
208   /* Internal transfer, only can be called by this contract */
209   function _transfer(address _from, address _to, uint _value) internal 
210       {
211           if(allowTransferToken == 1 || _from == owner )
212           {
213               require(!frozenAccount[_from]);                                   // Prevent transfer from frozenfunds
214               require (_to != 0x0);                                             // Prevent transfer to 0x0 address. Use burn() instead
215               require (balanceOf[_from] > _value);                              // Check if the sender has enough
216               require (balanceOf[_to] + _value > balanceOf[_to]);               // Check for overflows
217               balanceOf[_from] -= _value;                                       // Subtract from the sender
218               balanceOf[_to] += _value;                                         // Add to the recipient
219               Transfer(_from, _to, _value);                                     // raise event
220           }
221           else
222           {
223                revert();
224           }
225       }
226 
227   function transfer(address _to, uint256 _value)  public
228       {
229           _transfer(msg.sender, _to, _value);
230       }
231 
232   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) 
233       {
234           require (_value < allowance[_from][msg.sender]);                      // Check allowance
235           allowance[_from][msg.sender] -= _value;
236           _transfer(_from, _to, _value);
237           return true;
238       }
239 
240   function approve(address _spender, uint256 _value) public returns (bool success) 
241       {
242           allowance[msg.sender][_spender] = _value;
243           return true;
244       }
245 
246   function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success)
247       {
248           tokenRecipient spender = tokenRecipient(_spender);
249           if (approve(_spender, _value)) {
250               spender.receiveApproval(msg.sender, _value, this, _extraData);
251               return true;
252           }
253       }        
254 
255   function burn(uint256 _value) public returns (bool success) 
256       {
257           require (balanceOf[msg.sender] > _value);                             // Check if the sender has enough
258           balanceOf[msg.sender] -= _value;                                      // Subtract from the sender
259           totalSupply -= _value;                                                // Updates totalSupply
260           Burn(msg.sender, _value);
261           return true;
262       }
263 
264   function burnFrom(address _from, uint256 _value) public returns (bool success) 
265       {
266           require(balanceOf[_from] >= _value);                                  // Check if the targeted balance is enough
267           require(_value <= allowance[_from][msg.sender]);                      // Check allowance
268           balanceOf[_from] -= _value;                                           // Subtract from the targeted balance
269           allowance[_from][msg.sender] -= _value;                               // Subtract from the sender's allowance
270           totalSupply -= _value;                                                // Update totalSupply
271           Burn(_from, _value);
272           return true;
273       }
274 } // end of contract