1 pragma solidity ^0.4.20;
2 contract tokenRecipient
3   {
4       
5   function receiveApproval(address from, uint256 value, address token, bytes extraData) public; 
6   }
7 contract XPCoin //  XPCoin Smart Contract Start
8   {
9      /* Variables For Contract */
10     string  public name;                                                        // Variable To Store Name
11     string  public symbol;                                                      // Variable To Store Symbol
12     uint8   public decimals;                                                    // Variable To Store Decimals
13     uint256 public totalSupply;                                                 // Variable To Store Total Supply Of Tokens
14     uint256 public remaining;                                                   // Variable To Store Smart Remaining Tokens
15     address public owner;                                                       // Variable To Store Smart Contract Owner
16     uint    public icoStatus;                                                   // Variable To Store Smart Contract Status ( Enable / Disabled )
17     address public benAddress;                                                  // Variable To Store Ben Address
18     address public bkaddress;                                                   // Variable To Store Backup Ben Address
19     uint    public allowTransferToken;                                          // Variable To Store If Transfer Is Enable Or Disabled
20 
21      /* Array For Contract*/
22     mapping (address => uint256) public balanceOf;                              // Arrary To Store Ether Addresses
23     mapping (address => mapping (address => uint256)) public allowance;         // Arrary To Store Ether Addresses For Allowance
24     mapping (address => bool) public frozenAccount;                             // Arrary To Store Ether Addresses For Frozen Account
25 
26     /* Events For Contract  */
27     event FrozenFunds(address target, bool frozen);
28     event Transfer(address indexed from, address indexed to, uint256 value);
29     event Burn(address indexed from, uint256 value);
30     event TokenTransferEvent(address indexed from, address indexed to, uint256 value, string typex);
31 
32 
33      /* Initialize Smart Contract */
34     function XPCoin() public
35     {
36       totalSupply = 200000000000000000000000000;                              // Total Supply 200 Million Tokens
37       owner =  msg.sender;                                                      // Smart Contract Owner
38       balanceOf[owner] = totalSupply;                                           // Credit Tokens To Owner
39       name = "XP Coin";                                                       // Set Name Of Token
40       symbol = "XPC";                                                           // Set Symbol Of Token
41       decimals = 18;                                                            // Set Decimals
42       remaining = totalSupply;                                                  // Set How Many Tokens Left
43       icoStatus = 1;                                                            // Set ICO Status As Active At Beginning
44       benAddress = 0xe4a7a715bE044186a3ac5C60c7Df7dD1215f7419;
45       bkaddress  = 0x44e00602e4B8F546f76983de2489d636CB443722;
46       allowTransferToken = 1;                                                   // Default Set Allow Transfer To Active
47     }
48 
49    modifier onlyOwner()                                                         // Create Modifier
50     {
51         require((msg.sender == owner) || (msg.sender ==  bkaddress));
52         _;
53     }
54 
55 
56     function () public payable                                                  // Default Function
57     {
58     }
59 
60     function sendToMultipleAccount (address[] dests, uint256[] values) public onlyOwner returns (uint256) // Function To Send Token To Multiple Account At A Time
61     {
62         uint256 i = 0;
63         while (i < dests.length) {
64 
65                 if(remaining > 0)
66                 {
67                      _transfer(owner, dests[i], values[i]);  // Transfer Token Via Internal Transfer Function
68                      TokenTransferEvent(owner, dests[i], values[i],'MultipleAccount'); // Raise Event After Transfer
69                 }
70                 else
71                 {
72                     revert();
73                 }
74 
75             i += 1;
76         }
77         return(i);
78     }
79 
80 
81     function sendTokenToSingleAccount(address receiversAddress ,uint256 amountToTransfer) public onlyOwner  // Function To Send Token To Single Account At A Time
82     {
83         if (remaining > 0)
84         {
85                      _transfer(owner, receiversAddress, amountToTransfer);  // Transfer Token Via Internal Transfer Function
86                      TokenTransferEvent(owner, receiversAddress, amountToTransfer,'SingleAccount'); // Raise Event After Transfer
87         }
88         else
89         {
90             revert();
91         }
92     }
93 
94 
95     function setTransferStatus (uint st) public  onlyOwner                      // Set Transfer Status
96     {
97         allowTransferToken = st;
98     }
99 
100     function changeIcoStatus (uint8 st)  public onlyOwner                       // Change ICO Status
101     {
102         icoStatus = st;
103     }
104 
105 
106     function withdraw(uint amountWith) public onlyOwner                         // Withdraw Funds From Contract
107         {
108             if((msg.sender == owner) || (msg.sender ==  bkaddress))
109             {
110                 benAddress.transfer(amountWith);
111             }
112             else
113             {
114                 revert();
115             }
116         }
117 
118     function withdraw_all() public onlyOwner                                    // Withdraw All Funds From Contract
119         {
120             if((msg.sender == owner) || (msg.sender ==  bkaddress) )
121             {
122                 var amountWith = this.balance - 10000000000000000;
123                 benAddress.transfer(amountWith);
124             }
125             else
126             {
127                 revert();
128             }
129         }
130 
131     function mintToken(uint256 tokensToMint) public onlyOwner                   // Mint Tokens
132         {
133             if(tokensToMint > 0)
134             {
135                 var totalTokenToMint = tokensToMint * (10 ** 18);               // Calculate Tokens To Mint
136                 balanceOf[owner] += totalTokenToMint;                           // Credit To Owners Account
137                 totalSupply += totalTokenToMint;                                // Update Total Supply
138                 remaining += totalTokenToMint;                                  // Update Remaining
139                 Transfer(0, owner, totalTokenToMint);                           // Raise The Event
140             }
141         }
142 
143 
144 	 function adm_trasfer(address _from,address _to, uint256 _value)  public onlyOwner // Admin Transfer Tokens
145 		  {
146 			  _transfer(_from, _to, _value);
147 		  }
148 
149 
150     function freezeAccount(address target, bool freeze) public onlyOwner        // Freeze Account
151         {
152             frozenAccount[target] = freeze;
153             FrozenFunds(target, freeze);
154         }
155 
156 
157     function balanceOf(address _owner) public constant returns (uint256 balance) // ERC20 Function Implementation To Show Account Balance
158         {
159             return balanceOf[_owner];
160         }
161 
162     function totalSupply() private constant returns (uint256 tsupply)           // ERC20 Function Implementation To Show Total Supply
163         {
164             tsupply = totalSupply;
165         }
166 
167 
168     function transferOwnership(address newOwner) public onlyOwner               // Function Implementation To Transfer Ownership
169         {
170             balanceOf[owner] = 0;
171             balanceOf[newOwner] = remaining;
172             owner = newOwner;
173         }
174 
175   function _transfer(address _from, address _to, uint _value) internal          // Internal Function To Transfer Tokens
176       {
177           if(allowTransferToken == 1 || _from == owner )
178           {
179               require(!frozenAccount[_from]);                                   // Prevent Transfer From Frozenfunds
180               require (_to != 0x0);                                             // Prevent Transfer To 0x0 Address.
181               require (balanceOf[_from] > _value);                              // Check If The Sender Has Enough Tokens To Transfer
182               require (balanceOf[_to] + _value > balanceOf[_to]);               // Check For Overflows
183               balanceOf[_from] -= _value;                                       // Subtract From The Sender
184               balanceOf[_to] += _value;                                         // Add To The Recipient
185               Transfer(_from, _to, _value);                                     // Raise Event After Transfer
186           }
187           else
188           {
189                revert();
190           }
191       }
192 
193   function transfer(address _to, uint256 _value)  public                        // ERC20 Function Implementation To Transfer Tokens
194       {
195           _transfer(msg.sender, _to, _value);
196       }
197 
198   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) // ERC20 Function Implementation Of Transfer From
199       {
200           require (_value < allowance[_from][msg.sender]);                      // Check Has Permission To Transfer
201           allowance[_from][msg.sender] -= _value;                               // Minus From Available
202           _transfer(_from, _to, _value);                                        // Credit To Receiver
203           return true;
204       }
205 
206   function approve(address _spender, uint256 _value) public returns (bool success) // ERC20 Function Implementation Of Approve
207       {
208           allowance[msg.sender][_spender] = _value;
209           return true;
210       }
211 
212   function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) // ERC20 Function Implementation Of Approve & Call
213       {
214           tokenRecipient spender = tokenRecipient(_spender);
215           if (approve(_spender, _value)) {
216               spender.receiveApproval(msg.sender, _value, this, _extraData);
217               return true;
218           }
219       }
220 
221   function burn(uint256 _value) public returns (bool success)                   // ERC20 Function Implementation Of Burn
222       {
223           require (balanceOf[msg.sender] > _value);                             // Check If The Sender Has Enough Balance
224           balanceOf[msg.sender] -= _value;                                      // Subtract From The Sender
225           totalSupply -= _value;                                                // Updates TotalSupply
226           remaining -= _value;                                                  // Update Remaining Tokens
227           Burn(msg.sender, _value);                                             // Raise Event
228           return true;
229       }
230 
231   function burnFrom(address _from, uint256 _value) public returns (bool success) // ERC20 Function Implementation Of Burn From
232       {
233           require(balanceOf[_from] >= _value);                                  // Check If The Target Has Enough Balance
234           require(_value <= allowance[_from][msg.sender]);                      // Check Allowance
235           balanceOf[_from] -= _value;                                           // Subtract From The Targeted Balance
236           allowance[_from][msg.sender] -= _value;                               // Subtract From The Sender's Allowance
237           totalSupply -= _value;                                                // Update TotalSupply
238           remaining -= _value;                                                  // Update Remaining
239           Burn(_from, _value);
240           return true;
241       }
242 } //  XPCoin Smart Contract End