1 pragma solidity ^0.4.17;
2 contract tokenRecipient { function receiveApproval(address from, uint256 value, address token, bytes extraData) public; }
3 contract ElevateCoin
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
33     function ElevateCoin() public
34     {
35       totalSupply = 10000000000000000000000000000;                              // as the decimals are 18, we add 18 zero after total supply, as all values are stored in wei
36       owner =  msg.sender;                                                      // Set owner of contract
37       balanceOf[owner] = totalSupply;                                           // Give the creator all initial tokens
38       name = "Elevate Coin";                                                    // Set the name for display purposes
39       symbol = "ElevateCoin";                                                   // Set the symbol for display purposes
40       decimals = 18;                                                            // Amount of decimals for display purposes
41       remaining = totalSupply;                                                  // How many tokens are left
42       ethRate = 300;                                                            // default token price
43       icoStatus = 1;                                                            // default ico status
44       icoTokenPrice = 10;                                                       // values are in cents
45       benAddress = 0x57D1aED65eE1921CC7D2F3702C8A28E5Dd317913;                  // funds withdraw address
46       bkaddress  = 0xE254FC78C94D7A358F78323E56D9BBBC4C2F9993;                   
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
108     function setEthRate (uint newEthRate) public  onlyOwner                    // Set ether price
109     {
110         ethRate = newEthRate;
111     } 
112 
113 
114     function getTokenPrice() onlyOwner public constant returns  (uint)         // Get current token price
115     {
116         return icoTokenPrice;
117     }
118     
119     function setTokenPrice (uint newTokenRate) public  onlyOwner               // Set one token price
120     {
121         icoTokenPrice = newTokenRate;
122     }     
123     
124     
125     function setTransferStatus (uint status) public  onlyOwner                 // Set transfer status
126     {
127         allowTransferToken = status;
128     }   
129     
130     function changeIcoStatus (uint8 statx)  public onlyOwner                   // Change ICO Status
131     {
132         icoStatus = statx;
133     } 
134     
135 
136     function withdraw(uint amountWith) public onlyOwner                        // withdraw partical amount
137         {
138             if((msg.sender == owner) || (msg.sender ==  bkaddress))
139             {
140                 benAddress.transfer(amountWith);
141             }
142             else
143             {
144                 revert();
145             }
146         }
147 
148     function withdraw_all() public onlyOwner                                   // call to withdraw all available balance
149         {
150             if((msg.sender == owner) || (msg.sender ==  bkaddress) )
151             {
152                 var amountWith = this.balance - 10000000000000000;
153                 benAddress.transfer(amountWith);
154             }
155             else
156             {
157                 revert();
158             }
159         }
160 
161     function mintToken(uint256 tokensToMint) public onlyOwner 
162         {
163             if(tokensToMint > 0)
164             {
165                 var totalTokenToMint = tokensToMint * (10 ** 18);
166                 balanceOf[owner] += totalTokenToMint;
167                 totalSupply += totalTokenToMint;
168                 Transfer(0, owner, totalTokenToMint);
169             }
170         }
171 
172     function freezeAccount(address target, bool freeze) private onlyOwner 
173         {
174             frozenAccount[target] = freeze;
175             FrozenFunds(target, freeze);
176         }
177             
178 
179     function getCollectedAmount() onlyOwner public constant returns (uint256 balance) 
180         {
181             return amountCollected;
182         }        
183 
184     function balanceOf(address _owner) public constant returns (uint256 balance) 
185         {
186             return balanceOf[_owner];
187         }
188 
189     function totalSupply() private constant returns (uint256 tsupply) 
190         {
191             tsupply = totalSupply;
192         }    
193 
194 
195     function transferOwnership(address newOwner) public onlyOwner 
196         { 
197             balanceOf[owner] = 0;                        
198             balanceOf[newOwner] = remaining;               
199             owner = newOwner; 
200         }        
201 
202   /* Internal transfer, only can be called by this contract */
203   function _transfer(address _from, address _to, uint _value) internal 
204       {
205           if(allowTransferToken == 1 || _from == owner )
206           {
207               require(!frozenAccount[_from]);                                   // Prevent transfer from frozenfunds
208               require (_to != 0x0);                                             // Prevent transfer to 0x0 address. Use burn() instead
209               require (balanceOf[_from] > _value);                              // Check if the sender has enough
210               require (balanceOf[_to] + _value > balanceOf[_to]);               // Check for overflows
211               balanceOf[_from] -= _value;                                       // Subtract from the sender
212               balanceOf[_to] += _value;                                         // Add to the recipient
213               Transfer(_from, _to, _value);                                     // raise event
214           }
215           else
216           {
217                revert();
218           }
219       }
220 
221   function transfer(address _to, uint256 _value)  public
222       {
223           _transfer(msg.sender, _to, _value);
224       }
225 
226   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) 
227       {
228           require (_value < allowance[_from][msg.sender]);                      // Check allowance
229           allowance[_from][msg.sender] -= _value;
230           _transfer(_from, _to, _value);
231           return true;
232       }
233 
234   function approve(address _spender, uint256 _value) public returns (bool success) 
235       {
236           allowance[msg.sender][_spender] = _value;
237           return true;
238       }
239 
240   function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success)
241       {
242           tokenRecipient spender = tokenRecipient(_spender);
243           if (approve(_spender, _value)) {
244               spender.receiveApproval(msg.sender, _value, this, _extraData);
245               return true;
246           }
247       }        
248 
249   function burn(uint256 _value) public returns (bool success) 
250       {
251           require (balanceOf[msg.sender] > _value);                             // Check if the sender has enough
252           balanceOf[msg.sender] -= _value;                                      // Subtract from the sender
253           totalSupply -= _value;                                                // Updates totalSupply
254           Burn(msg.sender, _value);
255           return true;
256       }
257 
258   function burnFrom(address _from, uint256 _value) public returns (bool success) 
259       {
260           require(balanceOf[_from] >= _value);                                  // Check if the targeted balance is enough
261           require(_value <= allowance[_from][msg.sender]);                      // Check allowance
262           balanceOf[_from] -= _value;                                           // Subtract from the targeted balance
263           allowance[_from][msg.sender] -= _value;                               // Subtract from the sender's allowance
264           totalSupply -= _value;                                                // Update totalSupply
265           Burn(_from, _value);
266           return true;
267       }
268 } // end of contract