1 pragma solidity ^0.4.23;
2 
3 contract Ownable {
4   address public owner;
5 
6   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8   constructor() public {
9     owner = msg.sender;
10   }
11   modifier onlyOwner() {
12     require(msg.sender == owner);
13     _;
14   }
15   function transferOwnership(address newOwner) public onlyOwner {
16     require(newOwner != address(0));
17     emit OwnershipTransferred(owner, newOwner);
18     owner = newOwner;
19   }
20 
21 }
22 
23 contract Token is Ownable {
24 
25   /// @return total amount of tokens
26   function totalSupply() view public returns (uint256 supply) {}
27 
28   /// @param _owner The address from which the balance will be retrieved
29   /// @return The balance
30   function balanceOf(address _owner) public view returns (uint256 balance) {}
31 
32   /// @notice send `_value` token to `_to` from `msg.sender`
33   /// @param _to The address of the recipient
34   /// @param _value The amount of token to be transferred
35   /// @return Whether the transfer was successful or not
36   function transfer(address _to, uint256 _value) public returns (bool success) {}
37 
38   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
39   /// @param _from The address of the sender
40   /// @param _to The address of the recipient
41   /// @param _value The amount of token to be transferred
42   /// @return Whether the transfer was successful or not
43   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {}
44 
45   /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
46   /// @param _spender The address of the account able to transfer the tokens
47   /// @param _value The amount of wei to be approved for transfer
48   /// @return Whether the approval was successful or not
49   function approve(address _spender, uint256 _value) public returns (bool success) {}
50 
51   /// @param _owner The address of the account owning tokens
52   /// @param _spender The address of the account able to transfer the tokens
53   /// @return Amount of remaining tokens allowed to spent
54   function allowance(address _owner, address _spender) view public returns (uint256 remaining) {}
55 
56   event Transfer(address indexed _from, address indexed _to, uint256 _value);
57   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
58 
59 }
60 
61 contract StandardToken is Token {
62 
63   function transfer(address _to, uint256 _value) public returns (bool success) {
64       //Default assumes totalSupply can't be over max (2^256 - 1).
65       //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
66       //Replace the if with this one instead.
67       //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
68     if (balances[msg.sender] >= _value && _value > 0) {
69       balances[msg.sender] -= _value;
70       balances[_to] += _value;
71       emit Transfer(msg.sender, _to, _value);
72       return true;
73     } else {
74       return false;
75       }
76   }
77 
78   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
79       //same as above. Replace this line with the following if you want to protect against wrapping uints.
80       //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
81     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
82       balances[_to] += _value;
83       balances[_from] -= _value;
84       allowed[_from][msg.sender] -= _value;
85       emit Transfer(_from, _to, _value);
86       return true;
87     } else { 
88       return false;
89       }
90   }
91 
92   function balanceOf(address _owner) public view returns (uint256 balance) {
93     return balances[_owner];
94   }
95 
96   function approve(address _spender, uint256 _value) public returns (bool success) {
97     allowed[msg.sender][_spender] = _value;
98     emit Approval(msg.sender, _spender, _value);
99     return true;
100   }
101 
102   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
103     return allowed[_owner][_spender];
104   }
105 
106   mapping (address => uint256) balances;
107   mapping (address => mapping (address => uint256)) allowed;
108   uint256 public totalSupply;
109 }
110 
111 contract Bitotal is StandardToken { 
112 
113   /* Public variables of the token */
114 
115   /*
116   NOTE:
117   The following variables are OPTIONAL vanities. One does not have to include them.
118   They allow one to customise the token contract & in no way influences the core functionality.
119   Some wallets/interfaces might not even bother to look at this information.
120   */
121   string public name;                   // Token Name
122   uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
123   string public symbol;                 // An identifier: eg SBX, XPR etc..
124   string public version = "1.0"; 
125   uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
126   uint256 public totalEthInWei;         // WEI is the smallest unit of ETH 
127   address public fundsWallet;           // Where should the raised ETH go?
128   uint256 public maxSupply;
129   uint256 public maxTransferPerTimeframe;
130   uint256 public timeFrame;
131   bool public paused;
132   bool public restrictTransfers;
133   mapping (address => uint256) public lastTransfer;
134   mapping (address => uint256) public transfered;
135 
136   modifier NotPaused() {
137     require(!paused);
138     _;
139   }
140 
141   // This is a constructor function 
142   // which means the following function name has to match the contract name declared above
143   constructor() public {
144     fundsWallet = msg.sender; 
145     balances[fundsWallet] = 100000000;               
146     totalSupply = 100000000;    
147     maxSupply = 500000000;                    
148     name = "Bitotal";                                   
149     decimals = 2;                                               
150     symbol = "TFUND";                                             
151     unitsOneEthCanBuy = 15;                                       
152     timeFrame = 86399;      
153     maxTransferPerTimeframe = 300;                            
154   }
155 
156   function() payable public {
157     require(msg.value > 1 finney);
158     totalEthInWei = totalEthInWei + msg.value;
159     uint256 amount = msg.value * unitsOneEthCanBuy;
160     amount = (amount * 100) / 1 ether;
161     mintTokens(msg.sender, amount);
162     fundsWallet.transfer(msg.value);                               
163   }
164 
165   function mintTokens(address _to, uint256 _amount) private {
166     require((totalSupply + _amount) <= maxSupply);
167     balances[_to] += _amount;
168     totalSupply += _amount;
169     emit Transfer(0x0, _to, _amount);
170   }
171 
172   function setWalletAddress(address _newWallet) onlyOwner public {
173     require(_newWallet != address(0x0));
174     fundsWallet = _newWallet;
175   }
176 
177   function pause(bool _paused) onlyOwner public {
178     paused = _paused;
179   }
180 
181   function setTimeFrame(uint256 _time) onlyOwner public {
182     timeFrame = _time;
183   }
184 
185   function restrict(bool _restricted) onlyOwner public {
186     restrictTransfers = _restricted;
187   }
188 
189   function maxTransferAmount(uint256 _amount) onlyOwner public {
190     maxTransferPerTimeframe = _amount;
191   }
192 
193   function transfer(address _to, uint256 _value) NotPaused public returns (bool success) {
194     uint256 _lastTransfer;
195 
196     _lastTransfer = lastTransfer[msg.sender] + timeFrame;
197 
198     if ( _lastTransfer < now) {
199         
200       transfered[msg.sender] = 0;
201       lastTransfer[msg.sender] = now;
202     }
203      
204     if ((_value <= (maxTransferPerTimeframe - transfered[msg.sender])) || !restrictTransfers) {
205       
206       if (restrictTransfers) {
207         transfered[msg.sender] += _value;
208       }
209       super.transfer(_to, _value);
210       return true;
211     } else {
212       return false;
213     }
214   }
215 
216   function transferFrom(address _from, address _to, uint256 _value) NotPaused public returns (bool success) {
217     uint256 _lastTransfer;
218 
219     _lastTransfer = lastTransfer[_from] + timeFrame;
220     if ( _lastTransfer < now) {
221       transfered[_from] = 0;
222       lastTransfer[_from] = now;
223     }
224     if ((_value <= (maxTransferPerTimeframe - transfered[_from])) || !restrictTransfers) {
225       if (restrictTransfers) {
226         transfered[_from] += _value;
227       }
228       super.transferFrom(_from, _to, _value);
229       return true;
230     } else {
231       return false;
232     }
233   }
234 
235 }