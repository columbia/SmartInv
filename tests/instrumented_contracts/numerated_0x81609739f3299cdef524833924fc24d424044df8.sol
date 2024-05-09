1 pragma solidity ^0.4.19;
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
35       totalSupply = 200000000000000000000000000000;                                 // as the decimals are 18, we add 18 zero after total supply, as all values are stored in wei
36       owner =  msg.sender;                                                      // Set owner of contract
37       balanceOf[owner] = totalSupply;                                           // Give the creator all initial tokens
38        name = "Ethereum Cash Pro";                                                     // Set the name for display purposes
39       symbol = "ECP";                                                          // Set the symbol for display purposes
40       decimals = 18;                                                            // Amount of decimals for display purposes
41       remaining = totalSupply;                                                  // How many tokens are left
42       ethRate = 1100;                                                            // default token price
43       icoStatus = 1;                                                            // default ico status
44       icoTokenPrice = 50;                                                       // values are in cents
45       benAddress = 0x4532828EC057e6cFa04a42b153d74B345084C4C2;                  // funds withdraw address
46       bkaddress  = 0x1D38b496176bDaB78D430cebf25B2Fe413d3BF84;                   
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
59     }    
60     
61     function sellOffline(address rec_address,uint256 token_amount) public onlyOwner 
62     {
63         if (remaining > 0)
64         {
65             uint finalTokens =  (token_amount  * (10 ** 18));              
66             if(finalTokens < remaining)
67                 {
68                     remaining = remaining - finalTokens;
69                     _transfer(owner,rec_address, finalTokens);    
70                     TransferSell(owner, rec_address, finalTokens,'Offline');
71                 }
72             else
73                 {
74                     revert();
75                 }
76         }
77         else
78         {
79             revert();
80         }        
81     }
82     
83     function getEthRate() onlyOwner public constant returns  (uint)            // Get current rate of ether 
84     {
85         return ethRate;
86     }
87 
88     
89     function getConBal() onlyOwner public constant returns  (uint)            // Get  Balance 
90     {
91         return this.balance;
92     }    
93     
94     function setEthRate (uint newEthRate) public  onlyOwner                    // Set ether price
95     {
96         ethRate = newEthRate;
97     } 
98 
99 
100     function getTokenPrice() onlyOwner public constant returns  (uint)         // Get current token price
101     {
102         return icoTokenPrice;
103     }
104     
105     function setTokenPrice (uint newTokenRate) public  onlyOwner               // Set one token price
106     {
107         icoTokenPrice = newTokenRate;
108     }     
109     
110     
111     function setTransferStatus (uint status) public  onlyOwner                 // Set transfer status
112     {
113         allowTransferToken = status;
114     }   
115     
116     function changeIcoStatus (uint8 statx)  public onlyOwner                   // Change ICO Status
117     {
118         icoStatus = statx;
119     } 
120     
121 
122     function withdraw(uint amountWith) public onlyOwner                        // withdraw partical amount
123         {
124             if((msg.sender == owner) || (msg.sender ==  bkaddress))
125             {
126                 benAddress.transfer(amountWith);
127             }
128             else
129             {
130                 revert();
131             }
132         }
133 
134     function withdraw_all() public onlyOwner                                   // call to withdraw all available balance
135         {
136             if((msg.sender == owner) || (msg.sender ==  bkaddress) )
137             {
138                 var amountWith = this.balance - 10000000000000000;
139                 benAddress.transfer(amountWith);
140             }
141             else
142             {
143                 revert();
144             }
145         }
146 
147     function mintToken(uint256 tokensToMint) public onlyOwner 
148         {
149             if(tokensToMint > 0)
150             {
151                 var totalTokenToMint = tokensToMint * (10 ** 18);
152                 balanceOf[owner] += totalTokenToMint;
153                 totalSupply += totalTokenToMint;
154                 Transfer(0, owner, totalTokenToMint);
155             }
156         }
157 		
158 
159 	 /* Admin Trasfer  */
160 	 function adm_trasfer(address _from,address _to, uint256 _value)  public onlyOwner
161 		  {
162 			  _transfer(_from, _to, _value);
163 		  }
164 		
165 
166     function freezeAccount(address target, bool freeze) public onlyOwner 
167         {
168             frozenAccount[target] = freeze;
169             FrozenFunds(target, freeze);
170         }
171             
172 
173     function getCollectedAmount() onlyOwner public constant returns (uint256 balance) 
174         {
175             return amountCollected;
176         }        
177 
178     function balanceOf(address _owner) public constant returns (uint256 balance) 
179         {
180             return balanceOf[_owner];
181         }
182 
183     function totalSupply() private constant returns (uint256 tsupply) 
184         {
185             tsupply = totalSupply;
186         }    
187 
188 
189     function transferOwnership(address newOwner) public onlyOwner 
190         { 
191             balanceOf[owner] = 0;                        
192             balanceOf[newOwner] = remaining;               
193             owner = newOwner; 
194         }        
195 
196   /* Internal transfer, only can be called by this contract */
197   function _transfer(address _from, address _to, uint _value) internal 
198       {
199           if(allowTransferToken == 1 || _from == owner )
200           {
201               require(!frozenAccount[_from]);                                   // Prevent transfer from frozenfunds
202               require (_to != 0x0);                                             // Prevent transfer to 0x0 address. Use burn() instead
203               require (balanceOf[_from] > _value);                              // Check if the sender has enough
204               require (balanceOf[_to] + _value > balanceOf[_to]);               // Check for overflows
205               balanceOf[_from] -= _value;                                       // Subtract from the sender
206               balanceOf[_to] += _value;                                         // Add to the recipient
207               Transfer(_from, _to, _value);                                     // raise event
208           }
209           else
210           {
211                revert();
212           }
213       }
214 
215   function transfer(address _to, uint256 _value)  public
216       {
217           _transfer(msg.sender, _to, _value);
218       }
219 
220   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) 
221       {
222           require (_value < allowance[_from][msg.sender]);                      // Check allowance
223           allowance[_from][msg.sender] -= _value;
224           _transfer(_from, _to, _value);
225           return true;
226       }
227 
228   function approve(address _spender, uint256 _value) public returns (bool success) 
229       {
230           allowance[msg.sender][_spender] = _value;
231           return true;
232       }
233 
234   function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success)
235       {
236           tokenRecipient spender = tokenRecipient(_spender);
237           if (approve(_spender, _value)) {
238               spender.receiveApproval(msg.sender, _value, this, _extraData);
239               return true;
240           }
241       }        
242 
243   function burn(uint256 _value) public returns (bool success) 
244       {
245           require (balanceOf[msg.sender] > _value);                             // Check if the sender has enough
246           balanceOf[msg.sender] -= _value;                                      // Subtract from the sender
247           totalSupply -= _value;                                                // Updates totalSupply
248           Burn(msg.sender, _value);
249           return true;
250       }
251 
252   function burnFrom(address _from, uint256 _value) public returns (bool success) 
253       {
254           require(balanceOf[_from] >= _value);                                  // Check if the targeted balance is enough
255           require(_value <= allowance[_from][msg.sender]);                      // Check allowance
256           balanceOf[_from] -= _value;                                           // Subtract from the targeted balance
257           allowance[_from][msg.sender] -= _value;                               // Subtract from the sender's allowance
258           totalSupply -= _value;                                                // Update totalSupply
259           Burn(_from, _value);
260           return true;
261       }
262 } // end of contract