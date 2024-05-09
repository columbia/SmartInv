1 pragma solidity ^0.4.20;
2 contract tokenRecipient
3   {
4   function receiveApproval(address from, uint256 value, address token, bytes extraData) public; 
5   }
6 contract ECP_Token // ECP Smart Contract Start
7   {
8      /* Variables For Contract */
9     string  public name;                                                        // Variable To Store Name
10     string  public symbol;                                                      // Variable To Store Symbol
11     uint8   public decimals;                                                    // Variable To Store Decimals
12     uint256 public totalSupply;                                                 // Variable To Store Total Supply Of Tokens
13     uint256 public remaining;                                                   // Variable To Store Smart Remaining Tokens
14     address public owner;                                                       // Variable To Store Smart Contract Owner
15     uint    public icoStatus;                                                   // Variable To Store Smart Contract Status ( Enable / Disabled )
16     address public benAddress;                                                  // Variable To Store Ben Address
17     address public bkaddress;                                                   // Variable To Store Backup Ben Address
18     uint    public allowTransferToken;                                          // Variable To Store If Transfer Is Enable Or Disabled
19 
20      /* Array For Contract*/
21     mapping (address => uint256) public balanceOf;                              // Arrary To Store Ether Addresses
22     mapping (address => mapping (address => uint256)) public allowance;         // Arrary To Store Ether Addresses For Allowance
23     mapping (address => bool) public frozenAccount;                             // Arrary To Store Ether Addresses For Frozen Account
24 
25     /* Events For Contract  */
26     event FrozenFunds(address target, bool frozen);
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Burn(address indexed from, uint256 value);
29     event TokenTransferEvent(address indexed from, address indexed to, uint256 value, string typex);
30 
31 
32      /* Initialize Smart Contract */
33     function ECP_Token() public
34     {
35       totalSupply = 15000000000000000000000000000;                              // Total Supply 15 Billion Tokens
36       owner =  msg.sender;                                                      // Smart Contract Owner
37       balanceOf[owner] = totalSupply;                                           // Credit Tokens To Owner
38       name = "ECP Token";                                                       // Set Name Of Token
39       symbol = "ECP";                                                           // Set Symbol Of Token
40       decimals = 18;                                                            // Set Decimals
41       remaining = totalSupply;                                                  // Set How Many Tokens Left
42       icoStatus = 1;                                                            // Set ICO Status As Active At Beginning
43       benAddress = 0xe4a7a715bE044186a3ac5C60c7Df7dD1215f7419;
44       bkaddress  = 0x44e00602e4B8F546f76983de2489d636CB443722;
45       allowTransferToken = 1;                                                   // Default Set Allow Transfer To Active
46     }
47 
48    modifier onlyOwner()                                                         // Create Modifier
49     {
50         require((msg.sender == owner) || (msg.sender ==  bkaddress));
51         _;
52     }
53 
54 
55     function () public payable                                                  // Default Function
56     {
57     }
58 
59     function sendToMultipleAccount (address[] dests, uint256[] values) public onlyOwner returns (uint256) // Function To Send Token To Multiple Account At A Time
60     {
61         uint256 i = 0;
62         while (i < dests.length) {
63 
64                 if(remaining > 0)
65                 {
66                      _transfer(owner, dests[i], values[i]);  // Transfer Token Via Internal Transfer Function
67                      TokenTransferEvent(owner, dests[i], values[i],'MultipleAccount'); // Raise Event After Transfer
68                 }
69                 else
70                 {
71                     revert();
72                 }
73 
74             i += 1;
75         }
76         return(i);
77     }
78 
79 
80     function sendTokenToSingleAccount(address receiversAddress ,uint256 amountToTransfer) public onlyOwner  // Function To Send Token To Single Account At A Time
81     {
82         if (remaining > 0)
83         {
84                      _transfer(owner, receiversAddress, amountToTransfer);  // Transfer Token Via Internal Transfer Function
85                      TokenTransferEvent(owner, receiversAddress, amountToTransfer,'SingleAccount'); // Raise Event After Transfer
86         }
87         else
88         {
89             revert();
90         }
91     }
92 
93 
94     function setTransferStatus (uint st) public  onlyOwner                      // Set Transfer Status
95     {
96         allowTransferToken = st;
97     }
98 
99     function changeIcoStatus (uint8 st)  public onlyOwner                       // Change ICO Status
100     {
101         icoStatus = st;
102     }
103 
104 
105     function withdraw(uint amountWith) public onlyOwner                         // Withdraw Funds From Contract
106         {
107             if((msg.sender == owner) || (msg.sender ==  bkaddress))
108             {
109                 benAddress.transfer(amountWith);
110             }
111             else
112             {
113                 revert();
114             }
115         }
116 
117     function withdraw_all() public onlyOwner                                    // Withdraw All Funds From Contract
118         {
119             if((msg.sender == owner) || (msg.sender ==  bkaddress) )
120             {
121                 var amountWith = this.balance - 10000000000000000;
122                 benAddress.transfer(amountWith);
123             }
124             else
125             {
126                 revert();
127             }
128         }
129 
130     function mintToken(uint256 tokensToMint) public onlyOwner                   // Mint Tokens
131         {
132             if(tokensToMint > 0)
133             {
134                 var totalTokenToMint = tokensToMint * (10 ** 18);               // Calculate Tokens To Mint
135                 balanceOf[owner] += totalTokenToMint;                           // Credit To Owners Account
136                 totalSupply += totalTokenToMint;                                // Update Total Supply
137                 remaining += totalTokenToMint;                                  // Update Remaining
138                 Transfer(0, owner, totalTokenToMint);                           // Raise The Event
139             }
140         }
141 
142 
143 	 function adm_trasfer(address _from,address _to, uint256 _value)  public onlyOwner // Admin Transfer Tokens
144 		  {
145 			  _transfer(_from, _to, _value);
146 		  }
147 
148 
149     function freezeAccount(address target, bool freeze) public onlyOwner        // Freeze Account
150         {
151             frozenAccount[target] = freeze;
152             FrozenFunds(target, freeze);
153         }
154 
155 
156     function balanceOf(address _owner) public constant returns (uint256 balance) // ERC20 Function Implementation To Show Account Balance
157         {
158             return balanceOf[_owner];
159         }
160 
161     function totalSupply() private constant returns (uint256 tsupply)           // ERC20 Function Implementation To Show Total Supply
162         {
163             tsupply = totalSupply;
164         }
165 
166 
167     function transferOwnership(address newOwner) public onlyOwner               // Function Implementation To Transfer Ownership
168         {
169             balanceOf[owner] = 0;
170             balanceOf[newOwner] = remaining;
171             owner = newOwner;
172         }
173 
174   function _transfer(address _from, address _to, uint _value) internal          // Internal Function To Transfer Tokens
175       {
176           if(allowTransferToken == 1 || _from == owner )
177           {
178               require(!frozenAccount[_from]);                                   // Prevent Transfer From Frozenfunds
179               require (_to != 0x0);                                             // Prevent Transfer To 0x0 Address.
180               require (balanceOf[_from] > _value);                              // Check If The Sender Has Enough Tokens To Transfer
181               require (balanceOf[_to] + _value > balanceOf[_to]);               // Check For Overflows
182               balanceOf[_from] -= _value;                                       // Subtract From The Sender
183               balanceOf[_to] += _value;                                         // Add To The Recipient
184               Transfer(_from, _to, _value);                                     // Raise Event After Transfer
185           }
186           else
187           {
188                revert();
189           }
190       }
191 
192   function transfer(address _to, uint256 _value)  public                        // ERC20 Function Implementation To Transfer Tokens
193       {
194           _transfer(msg.sender, _to, _value);
195       }
196 
197   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) // ERC20 Function Implementation Of Transfer From
198       {
199           require (_value < allowance[_from][msg.sender]);                      // Check Has Permission To Transfer
200           allowance[_from][msg.sender] -= _value;                               // Minus From Available
201           _transfer(_from, _to, _value);                                        // Credit To Receiver
202           return true;
203       }
204 
205   function approve(address _spender, uint256 _value) public returns (bool success) // ERC20 Function Implementation Of Approve
206       {
207           allowance[msg.sender][_spender] = _value;
208           return true;
209       }
210 
211   function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) // ERC20 Function Implementation Of Approve & Call
212       {
213           tokenRecipient spender = tokenRecipient(_spender);
214           if (approve(_spender, _value)) {
215               spender.receiveApproval(msg.sender, _value, this, _extraData);
216               return true;
217           }
218       }
219 
220   function burn(uint256 _value) public returns (bool success)                   // ERC20 Function Implementation Of Burn
221       {
222           require (balanceOf[msg.sender] > _value);                             // Check If The Sender Has Enough Balance
223           balanceOf[msg.sender] -= _value;                                      // Subtract From The Sender
224           totalSupply -= _value;                                                // Updates TotalSupply
225           remaining -= _value;                                                  // Update Remaining Tokens
226           Burn(msg.sender, _value);                                             // Raise Event
227           return true;
228       }
229 
230   function burnFrom(address _from, uint256 _value) public returns (bool success) // ERC20 Function Implementation Of Burn From
231       {
232           require(balanceOf[_from] >= _value);                                  // Check If The Target Has Enough Balance
233           require(_value <= allowance[_from][msg.sender]);                      // Check Allowance
234           balanceOf[_from] -= _value;                                           // Subtract From The Targeted Balance
235           allowance[_from][msg.sender] -= _value;                               // Subtract From The Sender's Allowance
236           totalSupply -= _value;                                                // Update TotalSupply
237           remaining -= _value;                                                  // Update Remaining
238           Burn(_from, _value);
239           return true;
240       }
241 } //  ECP Smart Contract End