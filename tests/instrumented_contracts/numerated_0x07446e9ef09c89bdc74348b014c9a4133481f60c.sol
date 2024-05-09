1 pragma solidity ^0.5.3;
2 
3     // ----------------------------------------------------------------------------
4     // Owned contract
5     // ----------------------------------------------------------------------------
6     contract Owned {
7         address public owner;
8         address public newOwner;
9 
10         event OwnershipTransferred(address indexed _from, address indexed _to);
11 
12         modifier onlyOwner {
13             require(msg.sender == owner);
14             _;
15         }
16 
17         function transferOwnership(address _newOwner) public onlyOwner {
18             newOwner = _newOwner;
19         }
20         function acceptOwnership() public {
21             require(msg.sender == newOwner);
22             emit OwnershipTransferred(owner, newOwner);
23             owner = newOwner;
24             newOwner = address(0);
25         }
26     }
27 
28     // ----------------------------------------------------------------------------
29     // Safe maths
30     // ----------------------------------------------------------------------------
31     library SafeMath {
32         function add(uint a, uint b) internal pure returns (uint c) {
33             c = a + b;
34             require(c >= a);
35         }
36         function sub(uint a, uint b) internal pure returns (uint c) {
37             require(b <= a);
38             c = a - b;
39         }
40         function mul(uint a, uint b) internal pure returns (uint c) {
41             c = a * b;
42             require(a == 0 || c / a == b);
43         }
44         function div(uint a, uint b) internal pure returns (uint c) {
45             require(b > 0);
46             c = a / b;
47         }
48     }
49 
50     // ----------------------------------------------------------------------------
51     // ERC Token Standard #20 Interface
52     // ----------------------------------------------------------------------------
53     contract ERC20Interface {
54         function totalSupply() public view returns (uint);
55         function balanceOf(address tokenOwner) public view returns (uint balance);
56         function allowance(address tokenOwner, address spender) public view returns (uint remaining);
57         function transfer(address to, uint tokens) public returns (bool success);
58         function approve(address spender, uint tokens) public returns (bool success);
59         function transferFrom(address from, address to, uint tokens) public returns (bool success);
60 
61         event Transfer(address indexed from, address indexed to, uint tokens);
62         event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
63     }
64 
65     // ----------------------------------------------------------------------------
66     // MPAY Token Contract
67     // ----------------------------------------------------------------------------
68     contract MPAY is ERC20Interface, Owned{
69         using SafeMath for uint;
70         
71         string public symbol;
72         string public name;
73         uint8 public decimals;
74         uint _totalSupply;
75         mapping(address => uint) balances;
76         mapping(address => mapping(address => uint)) allowed;
77         mapping(address => uint) unLockedCoins; // this will keep number of unLockedCoins per address
78         struct PC {
79         uint256 lockingPeriod;
80         uint256 coins;
81         bool added;
82         }
83         mapping(address => PC[]) record; // this will keep record of Locking periods and coins per address
84 
85         // ------------------------------------------------------------------------
86         // Constructor
87         // ------------------------------------------------------------------------
88         constructor(address _owner) public{
89             symbol = "MPAY";
90             name = "MPAY";
91             decimals = 18;
92             owner = _owner;
93             _totalSupply = 4e8; //400,000,000
94             balances[owner] = totalSupply();
95             emit Transfer(address(0),owner,totalSupply());
96         }
97 
98         function totalSupply() public view returns (uint){
99         return _totalSupply * 10**uint(decimals);
100         }
101 
102         // ------------------------------------------------------------------------
103         // Get the token balance for account `tokenOwner`
104         // ------------------------------------------------------------------------
105         function balanceOf(address tokenOwner) public view returns (uint balance) {
106             return balances[tokenOwner];
107         }
108 
109         // ------------------------------------------------------------------------
110         // Transfer the balance from token owner's account to `to` account
111         // - Owner's account must have sufficient balance to transfer
112         // - 0 value transfers are allowed
113         // ------------------------------------------------------------------------
114         function transfer(address to, uint tokens) public returns (bool success) {
115             // will update unLockedCoins based on time
116             if(msg.sender != owner){
117                 _updateUnLockedCoins(msg.sender, tokens);
118                 unLockedCoins[msg.sender] = unLockedCoins[msg.sender].sub(tokens);
119                 unLockedCoins[to] = unLockedCoins[to].add(tokens);
120             }
121             // prevent transfer to 0x0, use burn instead
122             require(to != address(0));
123             require(balances[msg.sender] >= tokens );
124             require(balances[to] + tokens >= balances[to]);
125             balances[msg.sender] = balances[msg.sender].sub(tokens);
126             balances[to] = balances[to].add(tokens);
127             emit Transfer(msg.sender,to,tokens);
128             return true;
129         }
130         
131         // ------------------------------------------------------------------------
132         // Token owner can approve for `spender` to transferFrom(...) `tokens`
133         // from the token owner's account
134         // ------------------------------------------------------------------------
135         function approve(address spender, uint tokens) public returns (bool success){
136             allowed[msg.sender][spender] = tokens;
137             emit Approval(msg.sender,spender,tokens);
138             return true;
139         }
140 
141         // ------------------------------------------------------------------------
142         // Transfer `tokens` from the `from` account to the `to` account
143         // 
144         // The calling account must already have sufficient tokens approve(...)
145         // for spending from the `from` account and
146         // - From account must have sufficient balance to transfer
147         // - Spender must have sufficient allowance to transfer
148         // - 0 value transfers are allowed
149         // ------------------------------------------------------------------------
150         function transferFrom(address from, address to, uint tokens) public returns (bool success){
151             // will update unLockedCoins based on time
152             if(msg.sender != owner){
153                 _updateUnLockedCoins(from, tokens);
154                 unLockedCoins[from] = unLockedCoins[from].sub(tokens);
155                 unLockedCoins[to] = unLockedCoins[to].add(tokens);
156             }
157             require(tokens <= allowed[from][msg.sender]); //check allowance
158             require(balances[from] >= tokens);
159             balances[from] = balances[from].sub(tokens);
160             balances[to] = balances[to].add(tokens);
161             allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
162             emit Transfer(from,to,tokens);
163             return true;
164         }
165         // ------------------------------------------------------------------------
166         // Returns the amount of tokens approved by the owner that can be
167         // transferred to the spender's account
168         // ------------------------------------------------------------------------
169         function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
170             return allowed[tokenOwner][spender];
171         }
172         
173         // ------------------------------------------------------------------------
174         // Transfer the balance from token owner's account to `to` account
175         // - Owner's account must have sufficient balance to transfer
176         // - 0 value transfers are allowed
177         // - takes in locking Period to lock the tokens to be used
178         // - if want to transfer without locking enter 0 in lockingPeriod argument 
179         // ------------------------------------------------------------------------
180         function distributeTokens(address to, uint tokens, uint256 lockingPeriod) onlyOwner public returns (bool success) {
181             // transfer tokens to the "to" address
182             transfer(to, tokens);
183             // if there is no lockingPeriod, add coins to unLockedCoins per address
184             if(lockingPeriod == 0)
185                 unLockedCoins[to] = unLockedCoins[to].add(tokens);
186             // if there is a lockingPeriod, add coins to record mapping
187             else
188                 _addRecord(to, tokens, lockingPeriod);
189             return true;
190         }
191         
192         // ------------------------------------------------------------------------
193         // Adds record of addresses with locking period and coins to lock
194         // ------------------------------------------------------------------------
195         function _addRecord(address to, uint tokens, uint256 lockingPeriod) private {
196                 record[to].push(PC(lockingPeriod,tokens, false));
197         }
198         
199         // ------------------------------------------------------------------------
200         // Checks if there is any uunLockedCoins available
201         // ------------------------------------------------------------------------
202         function _updateUnLockedCoins(address _from, uint tokens) private returns (bool success) {
203             // if unLockedCoins are greater than "tokens" of "to", initiate transfer
204             if(unLockedCoins[_from] >= tokens){
205                 return true;
206             }
207             // if unLockedCoins are less than "tokens" of "to", update unLockedCoins by checking record with "now" time
208             else{
209                 _updateRecord(_from);
210                 // check if unLockedCoins are greater than "token" of "to", initiate transfer
211                 if(unLockedCoins[_from] >= tokens){
212                     return true;
213                 }
214                 // otherwise revert
215                 else{
216                     revert();
217                 }
218             }
219         }
220         
221         // ------------------------------------------------------------------------
222         // Unlock the coins if lockingPeriod is expired
223         // ------------------------------------------------------------------------
224         function _updateRecord(address _address) private returns (bool success){
225             PC[] memory tempArray = record[_address];
226             uint tempCount = 0;
227             for(uint i=0; i < tempArray.length; i++){
228                 if(tempArray[i].lockingPeriod < now && tempArray[i].added == false){
229                     tempCount = tempCount.add(tempArray[i].coins);
230                     tempArray[i].added = true;
231                     record[_address][i] = PC(tempArray[i].lockingPeriod, tempArray[i].coins, tempArray[i].added);
232                 }
233             }
234             unLockedCoins[_address] = unLockedCoins[_address].add(tempCount);
235             return true;
236         }
237         
238     }