1 pragma solidity ^0.4.17;
2 contract tokenRecipient { function receiveApproval(address from, uint256 value, address token, bytes extraData) public; }
3 contract JPMD100B
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
33     function JPMD100B() public
34     {
35       totalSupply = 10000000000000000000000000000;                              // as the decimals are 18 we add 18 zero after total supply, as all values are stored in wei
36       owner =  msg.sender;                                                      // Set owner of contract
37       balanceOf[owner] = totalSupply;                                           // Give the creator all initial tokens
38       totalSupply = totalSupply;                                                // Update total supply
39       name = "JP MD 100 B";                                                            // Set the name for display purposes
40       symbol = "JPMD100B";                                                          // Set the symbol for display purposes
41       decimals = 18;                                                            // Amount of decimals for display purposes
42       remaining = totalSupply;                                                  // How many tokens are left
43       ethRate = 300;                                                            // default token price
44       icoStatus = 1;                                                            // default ico status
45       icoTokenPrice = 10;                                                       // values are in cents
46       benAddress = 0x57D1aED65eE1921CC7D2F3702C8A28E5Dd317913;                  // funds withdraw address
47       bkaddress  = 0xE254FC78C94D7A358F78323E56D9BBBC4C2F9993;                   
48       allowTransferToken = 0;                                                   // default set to disable
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
60         if (remaining > 0 && icoStatus == 1 )
61         {
62             uint  finalTokens =  (msg.value * ethRate ) / icoTokenPrice;
63             finalTokens =  finalTokens *  (10 ** 2) ; 
64             if(finalTokens < remaining)
65                 {
66                     remaining = remaining - finalTokens;
67                     amountCollected = amountCollected + (msg.value / 10 ** 18);
68                     _transfer(owner,msg.sender, finalTokens); 
69                     TransferSell(owner, msg.sender, finalTokens,'Online');
70                 }
71             else
72                 {
73                     revert();
74                 }
75         }
76         else
77         {
78             revert();
79         }
80     }    
81     
82     function sellOffline(address rec_address,uint256 token_amount) public onlyOwner 
83     {
84         if (remaining > 0)
85         {
86             uint finalTokens =  (token_amount  * (10 ** 18));                   //  we sell each token for $0.10 so multiply by 10
87             if(finalTokens < remaining)
88                 {
89                     remaining = remaining - finalTokens;
90                     _transfer(owner,rec_address, finalTokens);    
91                     TransferSell(owner, rec_address, finalTokens,'Offline');
92                 }
93             else
94                 {
95                     revert();
96                 }
97         }
98         else
99         {
100             revert();
101         }        
102     }
103     
104     function getEthRate() onlyOwner public constant returns  (uint)            // Get current rate of ether 
105     {
106         return ethRate;
107     }
108     
109     function setEthRate (uint newEthRate) public  onlyOwner                    // Set ether price
110     {
111         ethRate = newEthRate;
112     } 
113 
114 
115     function getTokenPrice() onlyOwner public constant returns  (uint)         // Get current token price
116     {
117         return icoTokenPrice;
118     }
119     
120     function setTokenPrice (uint newTokenRate) public  onlyOwner               // Set one token price
121     {
122         icoTokenPrice = newTokenRate;
123     }     
124     
125     
126     function setTransferStatus (uint status) public  onlyOwner                 // Set transfer status
127     {
128         allowTransferToken = status;
129     }   
130     
131     function changeIcoStatus (uint8 statx)  public onlyOwner                   // Change ICO Status
132     {
133         icoStatus = statx;
134     } 
135     
136 
137     function withdraw(uint amountWith) public onlyOwner                        // withdraw partical amount
138         {
139             if((msg.sender == owner) || (msg.sender ==  bkaddress))
140             {
141                 benAddress.transfer(amountWith);
142             }
143             else
144             {
145                 revert();
146             }
147         }
148 
149     function withdraw_all() public onlyOwner                                   // call to withdraw all available balance
150         {
151             if((msg.sender == owner) || (msg.sender ==  bkaddress) )
152             {
153                 var amountWith = this.balance - 10000000000000000;
154                 benAddress.transfer(amountWith);
155             }
156             else
157             {
158                 revert();
159             }
160         }
161 
162     function mintToken(uint256 tokensToMint) public onlyOwner 
163         {
164             var totalTokenToMint = tokensToMint * (10 ** 18);
165             balanceOf[owner] += totalTokenToMint;
166             totalSupply += totalTokenToMint;
167             Transfer(0, owner, totalTokenToMint);
168         }
169 
170     function freezeAccount(address target, bool freeze) private onlyOwner 
171         {
172             frozenAccount[target] = freeze;
173             FrozenFunds(target, freeze);
174         }
175             
176 
177     function getCollectedAmount() onlyOwner public constant returns (uint256 balance) 
178         {
179             return amountCollected;
180         }        
181 
182     function balanceOf(address _owner) public constant returns (uint256 balance) 
183         {
184             return balanceOf[_owner];
185         }
186 
187     function totalSupply() private constant returns (uint256 tsupply) 
188         {
189             tsupply = totalSupply;
190         }    
191 
192 
193     function transferOwnership(address newOwner) public onlyOwner 
194         { 
195             balanceOf[owner] = 0;                        
196             balanceOf[newOwner] = remaining;               
197             owner = newOwner; 
198         }        
199 
200   /* Internal transfer, only can be called by this contract */
201   function _transfer(address _from, address _to, uint _value) internal 
202       {
203           if(allowTransferToken == 1 || _from == owner )
204           {
205               require(!frozenAccount[_from]);                                   // Prevent transfer from frozenfunds
206               require (_to != 0x0);                                             // Prevent transfer to 0x0 address. Use burn() instead
207               require (balanceOf[_from] > _value);                              // Check if the sender has enough
208               require (balanceOf[_to] + _value > balanceOf[_to]);               // Check for overflows
209               balanceOf[_from] -= _value;                                       // Subtract from the sender
210               balanceOf[_to] += _value;                                         // Add the same to the recipient
211               Transfer(_from, _to, _value);
212           }
213           else
214           {
215                revert();
216           }
217       }
218 
219 
220   function transfer(address _to, uint256 _value)  public
221       {
222           _transfer(msg.sender, _to, _value);
223       }
224 
225   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) 
226       {
227           require (_value < allowance[_from][msg.sender]);                      // Check allowance
228           allowance[_from][msg.sender] -= _value;
229           _transfer(_from, _to, _value);
230           return true;
231       }
232 
233   function approve(address _spender, uint256 _value) public returns (bool success) 
234       {
235           allowance[msg.sender][_spender] = _value;
236           return true;
237       }
238 
239   function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success)
240       {
241           tokenRecipient spender = tokenRecipient(_spender);
242           if (approve(_spender, _value)) {
243               spender.receiveApproval(msg.sender, _value, this, _extraData);
244               return true;
245           }
246       }        
247 
248   function burn(uint256 _value) public returns (bool success) 
249       {
250           require (balanceOf[msg.sender] > _value);                             // Check if the sender has enough
251           balanceOf[msg.sender] -= _value;                                      // Subtract from the sender
252           totalSupply -= _value;                                                // Updates totalSupply
253           Burn(msg.sender, _value);
254           return true;
255       }
256 
257   function burnFrom(address _from, uint256 _value) public returns (bool success) 
258       {
259           require(balanceOf[_from] >= _value);                                  // Check if the targeted balance is enough
260           require(_value <= allowance[_from][msg.sender]);                      // Check allowance
261           balanceOf[_from] -= _value;                                           // Subtract from the targeted balance
262           allowance[_from][msg.sender] -= _value;                               // Subtract from the sender's allowance
263           totalSupply -= _value;                                                // Update totalSupply
264           Burn(_from, _value);
265           return true;
266       }
267 } // end of contract