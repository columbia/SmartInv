1 pragma solidity >=0.4.18;
2 
3 contract Token {
4 
5     /// @return total amount of tokens
6     function totalSupply() public constant returns (uint supply) {}
7 
8     /// @param _owner The address from which the balance will be retrieved
9     /// @return The balance
10     function balanceOf(address _owner) public constant returns (uint balance) {}
11 
12     /// @notice send `_value` token to `_to` from `msg.sender`
13     /// @param _to The address of the recipient
14     /// @param _value The amount of token to be transferred
15     /// @return Whether the transfer was successful or not
16     function transfer(address _to, uint _value) public returns (bool success) {}
17 
18     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
19     /// @param _from The address of the sender
20     /// @param _to The address of the recipient
21     /// @param _value The amount of token to be transferred
22     /// @return Whether the transfer was successful or not
23     function transferFrom(address _from, address _to, uint _value)  public returns (bool success) {}
24 
25     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
26     /// @param _spender The address of the account able to transfer the tokens
27     /// @param _value The amount of wei to be approved for transfer
28     /// @return Whether the approval was successful or not
29     function approve(address _spender, uint _value) public returns (bool success) {}
30 
31     /// @param _owner The address of the account owning tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @return Amount of remaining tokens allowed to spent
34     function allowance(address _owner, address _spender) public constant returns (uint remaining) {}
35 
36     event Transfer(address indexed _from, address indexed _to, uint _value);
37     event Approval(address indexed _owner, address indexed _spender, uint _value);
38 }
39 
40 contract RegularToken is Token {
41     mapping (address => uint256) balances;
42     //gaming locked balance
43     mapping (address => uint256) lockedBalances;
44     mapping (address => mapping (address => uint)) allowed;
45     uint public totalSupply;
46     /// @dev only transfer unlockedbalance
47     function transfer(address _to, uint _value)  public returns (bool) {
48         //Default assumes totalSupply can't be over max (2^256 - 1).
49         if (balances[msg.sender] >= _value  && balances[_to] + _value >= balances[_to]) {
50             balances[msg.sender] -= _value;
51             balances[_to] += _value;
52             Transfer(msg.sender, _to, _value);
53             return true;
54         } else { return false; }
55     }
56     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
57         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
58             balances[_to] += _value;
59             balances[_from] -= _value;
60             allowed[_from][msg.sender] -= _value;
61             Transfer(_from, _to, _value);
62             return true;
63         } else { return false; }
64     }
65 
66     function balanceOf(address _owner)  public constant returns (uint) {
67         return balances[_owner] + lockedBalances[_owner];
68     }
69 
70     function approve(address _spender, uint _value) public returns (bool) {
71         allowed[msg.sender][_spender] = _value;
72         Approval(msg.sender, _spender, _value);
73         return true;
74     }
75 
76     function allowance(address _owner, address _spender)  public constant returns (uint) {
77         return allowed[_owner][_spender];
78     }
79 
80 
81 }
82 
83 
84 contract A5DToken is RegularToken {
85     uint256 private keyprice = 3;
86     uint256 public totalSupply = 100000000*10**18;
87     uint8 constant public decimals = 18;
88     string constant public name = "5D Bid Tokens";
89     string constant public symbol = "5D";
90     mapping (address => uint) allowedContract;
91     address public owner;
92     address public communityWallet;
93     
94     function A5DToken()  public {
95         communityWallet = 0x44729e029f9c63798805e6142bc696bdbc69f70d;
96         owner = msg.sender;
97         balances[msg.sender] = totalSupply;
98         Transfer(address(0), msg.sender, totalSupply);
99     }
100     //events
101     event SellLockedBalance(address indexed _owner, uint256 _amount);
102     event FreeLockedBalance(address indexed _owner, address _to,uint256 _amount);
103     event UnlockBalance(address indexed _owner, uint256 _amount);
104     event SpendLockedBalance(address indexed _owner,address indexed spender, uint256 _amount);
105 
106     uint constant MAX_UINT = 2**256 - 1;
107     
108     modifier onlyOwner {
109         require (msg.sender == owner);
110         _;
111     }
112     modifier onlyAllowedContract {
113         require (allowedContract[msg.sender] == 1 || msg.sender == owner);
114         _;
115     }
116     
117     // function getallowedContracts(uint contractAddress) returns (uint){
118     //     return allowedContract[contractAddress];
119     // }
120     /// @dev ERC20 transferFrom, modified such that an allowance of MAX_UINT represents an unlimited amount.
121     /// @param _from Address to transfer from.
122     /// @param _to Address to transfer to.
123     /// @param _value Amount to transfer.
124     /// @return Success of transfer.
125     
126     function transferFrom(address _from, address _to, uint _value)
127         public
128         returns (bool)
129     {
130         uint allowance = allowed[_from][msg.sender];
131         if (balances[_from] >= _value
132             && allowance >= _value
133             && balances[_to] + _value >= balances[_to]
134         ) {
135             balances[_to] += _value;
136             balances[_from] -= _value;
137             if (allowance < MAX_UINT) {
138                 allowed[_from][msg.sender] -= _value;
139             }
140             Transfer(_from, _to, _value);
141             return true;
142         } else {
143             return false;
144         }
145     }
146     
147     function unlockBalance(address _owner, uint256 _value)
148         public
149         onlyOwner()
150         returns (bool)
151         {
152         uint256 shouldUnlockedBalance = 0;
153         shouldUnlockedBalance = _value;
154         if(shouldUnlockedBalance > lockedBalances[_owner]){
155             shouldUnlockedBalance = lockedBalances[_owner];
156         }
157         balances[_owner] += shouldUnlockedBalance;
158         lockedBalances[_owner] -= shouldUnlockedBalance;
159         UnlockBalance(_owner, shouldUnlockedBalance);
160         return true;
161     }
162     
163     function withdrawAmount()
164         public  
165         {
166         require (msg.sender == communityWallet);
167         communityWallet.transfer(this.balance);
168     }
169     
170     function updateKeyPrice(uint256 updatePrice)
171         onlyOwner()
172         public  {
173         keyprice = updatePrice;
174     }
175     
176     function lockedBalanceOf(address _owner)
177         constant
178         public
179         returns (uint256 balance) {
180         return lockedBalances[_owner];
181     }
182     function UnlockedBalanceOf(address _owner) constant public returns (uint256 balance) {
183         return balances[_owner];
184     }
185     /// @dev for gaming only
186     function freeGameLockedToken(address _to, uint256 _value)
187     onlyOwner()
188     public
189     {
190         //Default assumes totalSupply can't be over max (2^256 - 1).
191         if (balances[msg.sender] >= _value  && lockedBalances[_to] + _value >= lockedBalances[_to]) {
192             balances[msg.sender] -= _value;
193             lockedBalances[_to] += _value;
194             FreeLockedBalance(msg.sender, _to, _value);
195 
196         }
197     }
198     
199     function getConsideration(uint256 keyquantity) view public returns(uint256){
200         uint256 consideration = keyprice * keyquantity /100;
201         return consideration;
202     }
203     
204     function sellGameLockedToken(uint256 keyquantity)
205     public
206     payable
207     returns (bool) 
208     {
209         uint256 amount = msg.value;
210         uint256 consideration = keyprice * keyquantity /100;
211         require(amount >= consideration);
212         uint256 _value = keyquantity;
213         //Default assumes totalSupply can't be over max (2^256 - 1).
214         if (balances[owner] >= _value  && lockedBalances[msg.sender] + _value >= lockedBalances[msg.sender]) {
215             balances[owner] -= _value;
216             lockedBalances[msg.sender] += _value;
217             SellLockedBalance(msg.sender, _value);
218             return true;
219         } else { return false; }
220     }
221     
222     function approveContractReceiveGameLockedToken(address _from)
223     onlyOwner()
224     public
225     returns (bool)
226     {
227         allowedContract[_from] = 1;
228         return true;
229     }
230     
231     function spendGameLockedToken(address _from, uint256 _value)
232     public
233     onlyAllowedContract()
234     returns (bool) {
235         
236         //Default assumes totalSupply can't be over max (2^256 - 1).
237         if (lockedBalances[_from] >= _value  && balances[owner] + _value >= balances[owner]) {
238             lockedBalances[_from] -= _value;
239             balances[owner] += _value;
240             SpendLockedBalance(owner, _from, _value);
241             return true;
242         } else { return false; }
243     }
244     
245     function jackPotGameLockedToken(address _to, uint256 _value)
246     onlyAllowedContract()
247     public
248     {
249         //Default assumes totalSupply can't be over max (2^256 - 1).
250         if (balances[owner] >= _value  && lockedBalances[_to] + _value >= lockedBalances[_to]) {
251             balances[owner] -= _value;
252             lockedBalances[_to] += _value;
253             }
254     }
255 }