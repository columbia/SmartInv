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
85     uint256 private keyprice = 30; // 0.03 ether
86     uint256 public totalSupply = 1000000000*10**18;
87     uint8 constant public decimals = 18;
88     string constant public name = "5D Bid Coins";
89     string constant public symbol = "5D";
90     mapping (address => uint) allowedContract;
91     address public owner;
92     address public communityWallet;
93     
94     function A5DToken()  public {
95         communityWallet = 0x03706722CA31e7d4Ba29F5cB5887E27710Fa013C;
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
117     
118     function transferCommunityWallet(address newCommunityWallet)
119         public  
120         {
121         require (msg.sender == communityWallet);
122         communityWallet = newCommunityWallet;
123     }
124     /// @dev ERC20 transferFrom, modified such that an allowance of MAX_UINT represents an unlimited amount.
125     /// @param _from Address to transfer from.
126     /// @param _to Address to transfer to.
127     /// @param _value Amount to transfer.
128     /// @return Success of transfer.
129     
130     
131     function transferFrom(address _from, address _to, uint _value)
132         public
133         returns (bool)
134     {
135         uint allowance = allowed[_from][msg.sender];
136         if (balances[_from] >= _value
137             && allowance >= _value
138             && balances[_to] + _value >= balances[_to]
139         ) {
140             balances[_to] += _value;
141             balances[_from] -= _value;
142             if (allowance < MAX_UINT) {
143                 allowed[_from][msg.sender] -= _value;
144             }
145             Transfer(_from, _to, _value);
146             return true;
147         } else {
148             return false;
149         }
150     }
151     
152     function unlockBalance(address _owner, uint256 _value)
153         public
154         onlyOwner()
155         returns (bool)
156         {
157         uint256 shouldUnlockedBalance = 0;
158         shouldUnlockedBalance = _value;
159         if(shouldUnlockedBalance > lockedBalances[_owner]){
160             shouldUnlockedBalance = lockedBalances[_owner];
161         }
162         balances[_owner] += shouldUnlockedBalance;
163         lockedBalances[_owner] -= shouldUnlockedBalance;
164         UnlockBalance(_owner, shouldUnlockedBalance);
165         return true;
166     }
167     
168     function withdrawAmount()
169         public  
170         {
171         require (msg.sender == communityWallet);
172         communityWallet.transfer(this.balance);
173     }
174     
175     function updateKeyPrice(uint256 updatePrice)
176         onlyOwner()
177         public  {
178         keyprice = updatePrice;
179     }
180     
181     function lockedBalanceOf(address _owner)
182         constant
183         public
184         returns (uint256 balance) {
185         return lockedBalances[_owner];
186     }
187     function UnlockedBalanceOf(address _owner) constant public returns (uint256 balance) {
188         return balances[_owner];
189     }
190     /// @dev for gaming only
191     function freeGameLockedToken(address _to, uint256 _value)
192     onlyOwner()
193     public
194     {
195         //Default assumes totalSupply can't be over max (2^256 - 1).
196         if (balances[msg.sender] >= _value  && lockedBalances[_to] + _value >= lockedBalances[_to]) {
197             balances[msg.sender] -= _value;
198             lockedBalances[_to] += _value;
199             FreeLockedBalance(msg.sender, _to, _value);
200 
201         }
202     }
203     
204     function getConsideration(uint256 keyquantity) view public returns(uint256){
205         uint256 consideration = keyprice * keyquantity /1000;
206         return consideration;
207     }
208     
209     function sellGameLockedToken(uint256 keyquantity)
210     public
211     payable
212     returns (bool) 
213     {
214         uint256 amount = msg.value;
215         uint256 consideration = keyprice * keyquantity /1000;
216         require(amount >= consideration);
217         uint256 _value = keyquantity;
218         //Default assumes totalSupply can't be over max (2^256 - 1).
219         if (balances[owner] >= _value  && lockedBalances[msg.sender] + _value >= lockedBalances[msg.sender]) {
220             balances[owner] -= _value;
221             lockedBalances[msg.sender] += _value;
222             SellLockedBalance(msg.sender, _value);
223             return true;
224         } else { return false; }
225     }
226     
227     function approveContractReceiveGameLockedToken(address _from)
228     onlyOwner()
229     public
230     returns (bool)
231     {
232         allowedContract[_from] = 1;
233         return true;
234     }
235     
236     function spendGameLockedToken(address _from, uint256 _value)
237     public
238     onlyAllowedContract()
239     returns (bool) {
240         
241         //Default assumes totalSupply can't be over max (2^256 - 1).
242         if (lockedBalances[_from] >= _value  && balances[owner] + _value >= balances[owner]) {
243             lockedBalances[_from] -= _value;
244             balances[owner] += _value;
245             SpendLockedBalance(owner, _from, _value);
246             return true;
247         } else { return false; }
248     }
249     
250     function jackPotGameLockedToken(address _to, uint256 _value)
251     onlyAllowedContract()
252     public
253     {
254         //Default assumes totalSupply can't be over max (2^256 - 1).
255         if (balances[owner] >= _value  && lockedBalances[_to] + _value >= lockedBalances[_to]) {
256             balances[owner] -= _value;
257             lockedBalances[_to] += _value;
258             }
259     }
260 }