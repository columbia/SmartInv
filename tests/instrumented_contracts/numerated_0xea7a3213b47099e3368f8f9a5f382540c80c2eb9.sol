1 pragma solidity ^0.4.17;
2 contract tokenRecipient { function receiveApproval(address from, uint256 value, address token, bytes extraData); }
3 contract JaxBox
4   { 
5      /* Variables  */
6     string  public name;         // name  of contract
7     string  public symbol;       // symbol of contract
8     uint8   public decimals;     // how many decimals to keep , 18 is best 
9     uint256 public totalSupply; // how many tokens to create
10     uint256 public remaining;   // how many tokens has left
11     uint256 public ethRate;     // current rate of ether
12     address public owner;       // contract creator
13     uint256 public amountCollected; // how much funds has been collected
14     uint8   public icoStatus;
15     uint8   public icoTokenPrice;
16     address public benAddress;
17     
18      /* Array  */
19     mapping (address => uint256) public balanceOf; // array of all balances
20     mapping (address => uint256) public investors;
21     mapping (address => mapping (address => uint256)) public allowance;
22     mapping (address => bool) public frozenAccount;
23     
24     /* Events  */
25     event FrozenFunds(address target, bool frozen);
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     event Burn(address indexed from, uint256 value);
28     event TransferSell(address indexed from, address indexed to, uint256 value, string typex); // only for ico sales
29     
30 
31      /* Initializes contract with initial supply tokens to the creator of the contract */
32     function JaxBox() 
33     {
34       totalSupply = 10000000000000000000000000000; // as the decimals are 18 we add 18 zero after total supply, as all values are stored in wei
35       owner =  msg.sender;                      // Set owner of contract
36       balanceOf[owner] = totalSupply;           // Give the creator all initial tokens
37       totalSupply = totalSupply;                // Update total supply
38       name = "JaxBox";                     // Set the name for display purposes
39       symbol = "JBC";                       // Set the symbol for display purposes
40       decimals = 18;                            // Amount of decimals for display purposes
41       remaining = totalSupply;
42       ethRate = 300;
43       icoStatus = 1;
44       icoTokenPrice = 10; // values are in cents
45       benAddress = 0x57D1aED65eE1921CC7D2F3702C8A28E5Dd317913;
46     }
47 
48    modifier onlyOwner()
49     {
50         require(msg.sender == owner);
51         _;
52     }
53 
54     function ()  payable// called when ether is send
55     {
56         if (remaining > 0 && icoStatus == 1 )
57         {
58             uint  finalTokens =  ((msg.value / 10 ** 16) * ((ethRate * 10 ** 2) / icoTokenPrice)) / 10 ** 2;
59             if(finalTokens < remaining)
60                 {
61                     remaining = remaining - finalTokens;
62                     amountCollected = amountCollected + (msg.value / 10 ** 18);
63                     _transfer(owner,msg.sender, finalTokens); 
64                     TransferSell(owner, msg.sender, finalTokens,'Online');
65                 }
66             else
67                 {
68                     throw;
69                 }
70         }
71         else
72         {
73             throw;
74         }
75     }    
76     
77     function sellOffline(address rec_address,uint256 token_amount) onlyOwner 
78     {
79         if (remaining > 0)
80         {
81             uint finalTokens =  (token_amount  * (10 ** 18)); //  we sell each token for $0.10 so multiply by 10
82             if(finalTokens < remaining)
83                 {
84                     remaining = remaining - finalTokens;
85                     _transfer(owner,rec_address, finalTokens);    
86                     TransferSell(owner, rec_address, finalTokens,'Offline');
87                 }
88             else
89                 {
90                     throw;
91                 }
92         }
93         else
94         {
95             throw;
96         }        
97     }
98     
99     function getEthRate() onlyOwner constant returns  (uint) // Get current rate of ether 
100     {
101         return ethRate;
102     }
103     
104     function setEthRate (uint newEthRate)   onlyOwner // Set ether price
105     {
106         ethRate = newEthRate;
107     } 
108 
109 
110     function getTokenPrice() onlyOwner constant returns  (uint8) // Get current token price
111     {
112         return icoTokenPrice;
113     }
114     
115     function setTokenPrice (uint8 newTokenRate)   onlyOwner // Set one token price
116     {
117         icoTokenPrice = newTokenRate;
118     }     
119     
120     
121 
122     
123     function changeIcoStatus (uint8 statx)   onlyOwner // Change ICO Status
124     {
125         icoStatus = statx;
126     } 
127     
128     
129     function withdraw(uint amountWith) onlyOwner // withdraw partical amount
130         {
131             if(msg.sender == owner)
132             {
133                 if(amountWith > 0)
134                     {
135                         amountWith = (amountWith * 10 ** 18); // as input accept parameter in weis
136                         benAddress.send(amountWith);
137                     }
138             }
139             else
140             {
141                 throw;
142             }
143         }
144 
145     function withdraw_all() onlyOwner // call when ICO is done
146         {
147             if(msg.sender == owner)
148             {
149                 benAddress.send(this.balance);
150                 //suicide(msg.sender);
151             }
152             else
153             {
154                 throw;
155             }
156         }
157 
158     function mintToken(uint256 tokensToMint) onlyOwner 
159         {
160             var totalTokenToMint = tokensToMint * (10 ** 18);
161             balanceOf[owner] += totalTokenToMint;
162             totalSupply += totalTokenToMint;
163             Transfer(0, owner, totalTokenToMint);
164         }
165 
166     function freezeAccount(address target, bool freeze) onlyOwner 
167         {
168             frozenAccount[target] = freeze;
169             FrozenFunds(target, freeze);
170         }
171             
172 
173     function getCollectedAmount() constant returns (uint256 balance) 
174         {
175             return amountCollected;
176         }        
177 
178     function balanceOf(address _owner) constant returns (uint256 balance) 
179         {
180             return balanceOf[_owner];
181         }
182 
183     function totalSupply() constant returns (uint256 tsupply) 
184         {
185             tsupply = totalSupply;
186         }    
187 
188 
189     function transferOwnership(address newOwner) onlyOwner 
190         { 
191             balanceOf[owner] = 0;                        
192             balanceOf[newOwner] = remaining;               
193             owner = newOwner; 
194         }        
195 
196   /* Internal transfer, only can be called by this contract */
197   function _transfer(address _from, address _to, uint _value) internal 
198       {
199           require(!frozenAccount[_from]);                     // Prevent transfer from frozenfunds
200           require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
201           require (balanceOf[_from] > _value);                // Check if the sender has enough
202           require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
203           balanceOf[_from] -= _value;                         // Subtract from the sender
204           balanceOf[_to] += _value;                            // Add the same to the recipient
205           Transfer(_from, _to, _value);
206       }
207 
208 
209   function transfer(address _to, uint256 _value) 
210       {
211           _transfer(msg.sender, _to, _value);
212       }
213 
214   /// @notice Send `_value` tokens to `_to` in behalf of `_from`
215   /// @param _from The address of the sender
216   /// @param _to The address of the recipient
217   /// @param _value the amount to send
218   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) 
219       {
220           require (_value < allowance[_from][msg.sender]);     // Check allowance
221           allowance[_from][msg.sender] -= _value;
222           _transfer(_from, _to, _value);
223           return true;
224       }
225 
226   /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf
227   /// @param _spender The address authorized to spend
228   /// @param _value the max amount they can spend
229   function approve(address _spender, uint256 _value) returns (bool success) 
230       {
231           allowance[msg.sender][_spender] = _value;
232           return true;
233       }
234 
235   /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
236   /// @param _spender The address authorized to spend
237   /// @param _value the max amount they can spend
238   /// @param _extraData some extra information to send to the approved contract
239   function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success)
240       {
241           tokenRecipient spender = tokenRecipient(_spender);
242           if (approve(_spender, _value)) {
243               spender.receiveApproval(msg.sender, _value, this, _extraData);
244               return true;
245           }
246       }        
247 
248   /// @notice Remove `_value` tokens from the system irreversibly
249   /// @param _value the amount of money to burn
250   function burn(uint256 _value) returns (bool success) 
251       {
252           require (balanceOf[msg.sender] > _value);            // Check if the sender has enough
253           balanceOf[msg.sender] -= _value;                      // Subtract from the sender
254           totalSupply -= _value;                                // Updates totalSupply
255           Burn(msg.sender, _value);
256           return true;
257       }
258 
259   function burnFrom(address _from, uint256 _value) returns (bool success) 
260       {
261           require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
262           require(_value <= allowance[_from][msg.sender]);    // Check allowance
263           balanceOf[_from] -= _value;                         // Subtract from the targeted balance
264           allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
265           totalSupply -= _value;                              // Update totalSupply
266           Burn(_from, _value);
267           return true;
268       }
269 } // end of contract