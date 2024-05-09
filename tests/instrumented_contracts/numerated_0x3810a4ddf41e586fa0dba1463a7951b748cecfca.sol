1 /**
2  * Source Code first verified at https://etherscan.io on Friday, March 15, 2019
3  (UTC) */
4 
5 pragma solidity ^0.5.3;
6 
7     // ----------------------------------------------------------------------------
8     // Owned contract
9     // ----------------------------------------------------------------------------
10     contract Owned {
11         address public owner;
12         address public newOwner;
13 
14         event OwnershipTransferred(address indexed _from, address indexed _to);
15 
16         modifier onlyOwner {
17             require(msg.sender == owner);
18             _;
19         }
20 
21         function transferOwnership(address _newOwner) public onlyOwner {
22             newOwner = _newOwner;
23         }
24         function acceptOwnership() public {
25             require(msg.sender == newOwner);
26             emit OwnershipTransferred(owner, newOwner);
27             owner = newOwner;
28             newOwner = address(0);
29         }
30     }
31 
32     // ----------------------------------------------------------------------------
33     // Safe maths
34     // ----------------------------------------------------------------------------
35     library SafeMath {
36         function add(uint a, uint b) internal pure returns (uint c) {
37             c = a + b;
38             require(c >= a);
39         }
40         function sub(uint a, uint b) internal pure returns (uint c) {
41             require(b <= a);
42             c = a - b;
43         }
44         function mul(uint a, uint b) internal pure returns (uint c) {
45             c = a * b;
46             require(a == 0 || c / a == b);
47         }
48         function div(uint a, uint b) internal pure returns (uint c) {
49             require(b > 0);
50             c = a / b;
51         }
52     }
53 
54     // ----------------------------------------------------------------------------
55     // ERC Token Standard #20 Interface
56     // ----------------------------------------------------------------------------
57     contract ERC20Interface {
58         function totalSupply() public view returns (uint);
59         function balanceOf(address tokenOwner) public view returns (uint balance);
60         function allowance(address tokenOwner, address spender) public view returns (uint remaining);
61         function transfer(address to, uint tokens) public returns (bool success);
62         function approve(address spender, uint tokens) public returns (bool success);
63         function transferFrom(address from, address to, uint tokens) public returns (bool success);
64 
65         event Transfer(address indexed from, address indexed to, uint tokens);
66         event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
67     }
68 
69     // ----------------------------------------------------------------------------
70     // MPAY Token Contract
71     // ----------------------------------------------------------------------------
72     contract MPAY is ERC20Interface, Owned{
73         using SafeMath for uint;
74         
75         string public symbol;
76         string public name;
77         uint8 public decimals;
78         uint _totalSupply;
79         mapping(address => uint) balances;
80         mapping(address => mapping(address => uint)) allowed;
81         mapping(address => uint) unLockedCoins; // this will keep number of unLockedCoins per address
82         struct PC {
83         uint256 lockingPeriod;
84         uint256 coins;
85         bool added;
86         }
87         mapping(address => PC[]) record; // this will keep record of Locking periods and coins per address
88 
89         // ------------------------------------------------------------------------
90         // Constructor
91         // ------------------------------------------------------------------------
92         constructor(address _owner) public{
93             symbol = "MPAY";
94             name = "MPAY";
95             decimals = 18;
96             owner = _owner;
97             _totalSupply = 4e8; //400,000,000
98             balances[owner] = totalSupply();
99             emit Transfer(address(0),owner,totalSupply());
100         }
101 
102         function totalSupply() public view returns (uint){
103         return _totalSupply * 10**uint(decimals);
104         }
105 
106         // ------------------------------------------------------------------------
107         // Get the token balance for account `tokenOwner`
108         // ------------------------------------------------------------------------
109         function balanceOf(address tokenOwner) public view returns (uint balance) {
110             return balances[tokenOwner];
111         }
112 
113         // ------------------------------------------------------------------------
114         // Transfer the balance from token owner's account to `to` account
115         // - Owner's account must have sufficient balance to transfer
116         // - 0 value transfers are allowed
117         // ------------------------------------------------------------------------
118         function transfer(address to, uint tokens) public returns (bool success) {
119             // will update unLockedCoins based on time
120             if(msg.sender != owner){
121                 _updateUnLockedCoins(msg.sender, tokens);
122                 unLockedCoins[msg.sender] = unLockedCoins[msg.sender].sub(tokens);
123                 unLockedCoins[to] = unLockedCoins[to].add(tokens);
124             }
125             // prevent transfer to 0x0, use burn instead
126             require(to != address(0));
127             require(balances[msg.sender] >= tokens );
128             require(balances[to] + tokens >= balances[to]);
129             balances[msg.sender] = balances[msg.sender].sub(tokens);
130             balances[to] = balances[to].add(tokens);
131             emit Transfer(msg.sender,to,tokens);
132             return true;
133         }
134         
135         // ------------------------------------------------------------------------
136         // Token owner can approve for `spender` to transferFrom(...) `tokens`
137         // from the token owner's account
138         // ------------------------------------------------------------------------
139         function approve(address spender, uint tokens) public returns (bool success){
140             allowed[msg.sender][spender] = tokens;
141             emit Approval(msg.sender,spender,tokens);
142             return true;
143         }
144 
145         // ------------------------------------------------------------------------
146         // Transfer `tokens` from the `from` account to the `to` account
147         // 
148         // The calling account must already have sufficient tokens approve(...)
149         // for spending from the `from` account and
150         // - From account must have sufficient balance to transfer
151         // - Spender must have sufficient allowance to transfer
152         // - 0 value transfers are allowed
153         // ------------------------------------------------------------------------
154         function transferFrom(address from, address to, uint tokens) public returns (bool success){
155             // will update unLockedCoins based on time
156             if(msg.sender != owner){
157                 _updateUnLockedCoins(from, tokens);
158                 unLockedCoins[from] = unLockedCoins[from].sub(tokens);
159                 unLockedCoins[to] = unLockedCoins[to].add(tokens);
160             }
161             require(tokens <= allowed[from][msg.sender]); //check allowance
162             require(balances[from] >= tokens);
163             balances[from] = balances[from].sub(tokens);
164             balances[to] = balances[to].add(tokens);
165             allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
166             emit Transfer(from,to,tokens);
167             return true;
168         }
169         // ------------------------------------------------------------------------
170         // Returns the amount of tokens approved by the owner that can be
171         // transferred to the spender's account
172         // ------------------------------------------------------------------------
173         function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
174             return allowed[tokenOwner][spender];
175         }
176         
177         // ------------------------------------------------------------------------
178         // Transfer the balance from token owner's account to `to` account
179         // - Owner's account must have sufficient balance to transfer
180         // - 0 value transfers are allowed
181         // - takes in locking Period to lock the tokens to be used
182         // - if want to transfer without locking enter 0 in lockingPeriod argument 
183         // ------------------------------------------------------------------------
184         function distributeTokens(address to, uint tokens, uint256 lockingPeriod) onlyOwner public returns (bool success) {
185             // transfer tokens to the "to" address
186             transfer(to, tokens);
187             // if there is no lockingPeriod, add coins to unLockedCoins per address
188             if(lockingPeriod == 0)
189                 unLockedCoins[to] = unLockedCoins[to].add(tokens);
190             // if there is a lockingPeriod, add coins to record mapping
191             else
192                 _addRecord(to, tokens, lockingPeriod);
193             return true;
194         }
195         
196         // ------------------------------------------------------------------------
197         // Adds record of addresses with locking period and coins to lock
198         // ------------------------------------------------------------------------
199         function _addRecord(address to, uint tokens, uint256 lockingPeriod) private {
200                 record[to].push(PC(lockingPeriod,tokens, false));
201         }
202         
203         // ------------------------------------------------------------------------
204         // Checks if there is any uunLockedCoins available
205         // ------------------------------------------------------------------------
206         function _updateUnLockedCoins(address _from, uint tokens) private returns (bool success) {
207             // if unLockedCoins are greater than "tokens" of "to", initiate transfer
208             if(unLockedCoins[_from] >= tokens){
209                 return true;
210             }
211             // if unLockedCoins are less than "tokens" of "to", update unLockedCoins by checking record with "now" time
212             else{
213                 _updateRecord(_from);
214                 // check if unLockedCoins are greater than "token" of "to", initiate transfer
215                 if(unLockedCoins[_from] >= tokens){
216                     return true;
217                 }
218                 // otherwise revert
219                 else{
220                     revert();
221                 }
222             }
223         }
224         
225         // ------------------------------------------------------------------------
226         // Unlock the coins if lockingPeriod is expired
227         // ------------------------------------------------------------------------
228         function _updateRecord(address _address) private returns (bool success){
229             PC[] memory tempArray = record[_address];
230             uint tempCount = 0;
231             for(uint i=0; i < tempArray.length; i++){
232                 if(tempArray[i].lockingPeriod < now && tempArray[i].added == false){
233                     tempCount = tempCount.add(tempArray[i].coins);
234                     tempArray[i].added = true;
235                     record[_address][i] = PC(tempArray[i].lockingPeriod, tempArray[i].coins, tempArray[i].added);
236                 }
237             }
238             unLockedCoins[_address] = unLockedCoins[_address].add(tempCount);
239             return true;
240         }
241         
242     }