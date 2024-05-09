1 pragma solidity ^0.5.3;
2 
3 // ----------------------------------------------------------------------------
4 // Owned contract
5 // ----------------------------------------------------------------------------
6 contract Owned {
7     address public owner;
8     address public newOwner;
9 
10     event OwnershipTransferred(address indexed _from, address indexed _to);
11 
12     modifier onlyOwner {
13         require(msg.sender == owner);
14         _;
15     }
16 
17     function transferOwnership(address _newOwner) public onlyOwner {
18         newOwner = _newOwner;
19     }
20     function acceptOwnership() public {
21         require(msg.sender == newOwner);
22         emit OwnershipTransferred(owner, newOwner);
23         owner = newOwner;
24         newOwner = address(0);
25     }
26 }
27 
28 // ----------------------------------------------------------------------------
29 // Safe maths
30 // ----------------------------------------------------------------------------
31 library SafeMath {
32     function add(uint a, uint b) internal pure returns (uint c) {
33         c = a + b;
34         require(c >= a);
35     }
36     function sub(uint a, uint b) internal pure returns (uint c) {
37         require(b <= a);
38         c = a - b;
39     }
40     function mul(uint a, uint b) internal pure returns (uint c) {
41         c = a * b;
42         require(a == 0 || c / a == b);
43     }
44     function div(uint a, uint b) internal pure returns (uint c) {
45         require(b > 0);
46         c = a / b;
47     }
48 }
49 
50 // ----------------------------------------------------------------------------
51 // ERC Token Standard #20 Interface
52 // ----------------------------------------------------------------------------
53 contract ERC20Interface {
54     function totalSupply() public view returns (uint);
55     function balanceOf(address tokenOwner) public view returns (uint balance);
56     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
57     function transfer(address to, uint tokens) public returns (bool success);
58     function approve(address spender, uint tokens) public returns (bool success);
59     function transferFrom(address from, address to, uint tokens) public returns (bool success);
60 
61     event Transfer(address indexed from, address indexed to, uint tokens);
62     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
63 }
64 
65 // ----------------------------------------------------------------------------
66 // MPAY Token Contract
67 // ----------------------------------------------------------------------------
68 contract MPAY is ERC20Interface, Owned{
69     using SafeMath for uint;
70     
71     string public symbol;
72     string public name;
73     uint8 public decimals;
74     uint _totalSupply;
75     mapping(address => uint) balances;
76     mapping(address => mapping(address => uint)) allowed;
77     mapping(address => uint) unLockedCoins; // this will keep number of unLockedCoins per address
78     struct PC {
79     uint256 lockingPeriod;
80     uint256 coins;
81     bool added;
82     }
83     mapping(address => PC[]) record; // this will keep record of Locking periods and coins per address
84 
85     // ------------------------------------------------------------------------
86     // Constructor
87     // ------------------------------------------------------------------------
88     constructor(address _owner) public{
89         symbol = "MPAY";
90         name = "MPAY";
91         decimals = 18;
92         owner = _owner;
93         _totalSupply = 4e8; //400,000,000
94         balances[owner] = totalSupply();
95         emit Transfer(address(0),owner,totalSupply());
96     }
97 
98     function totalSupply() public view returns (uint){
99        return _totalSupply * 10**uint(decimals);
100     }
101 
102     // ------------------------------------------------------------------------
103     // Get the token balance for account `tokenOwner`
104     // ------------------------------------------------------------------------
105     function balanceOf(address tokenOwner) public view returns (uint balance) {
106         return balances[tokenOwner];
107     }
108 
109     // ------------------------------------------------------------------------
110     // Transfer the balance from token owner's account to `to` account
111     // - Owner's account must have sufficient balance to transfer
112     // - 0 value transfers are allowed
113     // ------------------------------------------------------------------------
114     function transfer(address to, uint tokens) public returns (bool success) {
115         if(msg.sender != owner){
116             _updateUnLockedCoins(msg.sender, tokens);
117             unLockedCoins[msg.sender] = unLockedCoins[msg.sender].sub(tokens);
118         }
119         // prevent transfer to 0x0, use burn instead
120         require(to != address(0));
121         require(to != address(this));
122         balances[msg.sender] = balances[msg.sender].sub(tokens);
123         balances[to] = balances[to].add(tokens);
124         emit Transfer(msg.sender,to,tokens);
125         return true;
126     }
127     
128     // ------------------------------------------------------------------------
129     // Token owner can approve for `spender` to transferFrom(...) `tokens`
130     // from the token owner's account
131     // ------------------------------------------------------------------------
132     function approve(address spender, uint tokens) public returns (bool success){
133         allowed[msg.sender][spender] = tokens;
134         emit Approval(msg.sender,spender,tokens);
135         return true;
136     }
137 
138     // ------------------------------------------------------------------------
139     // Transfer `tokens` from the `from` account to the `to` account
140     // 
141     // The calling account must already have sufficient tokens approve(...)
142     // for spending from the `from` account and
143     // - From account must have sufficient balance to transfer
144     // - Spender must have sufficient allowance to transfer
145     // - 0 value transfers are allowed
146     // ------------------------------------------------------------------------
147     function transferFrom(address from, address to, uint tokens) public returns (bool success){
148         if(msg.sender != owner){
149             _updateUnLockedCoins(from, tokens);
150             unLockedCoins[from] = unLockedCoins[from].sub(tokens);
151         }
152         require(to != address(0));
153         require(tokens <= allowed[from][msg.sender]); //check allowance
154         balances[from] = balances[from].sub(tokens);
155         balances[to] = balances[to].add(tokens);
156         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
157         emit Transfer(from,to,tokens);
158         return true;
159     }
160     // ------------------------------------------------------------------------
161     // Returns the amount of tokens approved by the owner that can be
162     // transferred to the spender's account
163     // ------------------------------------------------------------------------
164     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
165         return allowed[tokenOwner][spender];
166     }
167     
168     // ------------------------------------------------------------------------
169     // Transfer the balance from token owner's account to `to` account
170     // - Owner's account must have sufficient balance to transfer
171     // - 0 value transfers are allowed
172     // - takes in locking Period to lock the tokens to be used
173     // - if want to transfer without locking enter 0 in lockingPeriod argument 
174     // ------------------------------------------------------------------------
175     function distributeTokens(address to, uint tokens, uint256 lockingPeriod) onlyOwner public returns (bool success) {
176         // transfer tokens to the "to" address
177         transfer(to, tokens);
178         // if there is no lockingPeriod, add coins to unLockedCoins per address
179         if(lockingPeriod == 0)
180             unLockedCoins[to] = unLockedCoins[to].add(tokens);
181         // if there is a lockingPeriod, add coins to record mapping
182         else
183             _addRecord(to, tokens, lockingPeriod);
184         return true;
185     }
186     
187     // ------------------------------------------------------------------------
188     // Adds record of addresses with locking period and coins to lock
189     // ------------------------------------------------------------------------
190     function _addRecord(address to, uint tokens, uint256 lockingPeriod) private {
191             record[to].push(PC(lockingPeriod,tokens, false));
192     }
193     
194     // ------------------------------------------------------------------------
195     // Checks if there is any uunLockedCoins available
196     // ------------------------------------------------------------------------
197     function _updateUnLockedCoins(address _from, uint tokens) private returns (bool success) {
198         // if unLockedCoins are greater than "tokens" of "to", initiate transfer
199         if(unLockedCoins[_from] >= tokens){
200             return true;
201         }
202         // if unLockedCoins are less than "tokens" of "to", update unLockedCoins by checking record with "now" time
203         else{
204             _updateRecord(_from);
205             // check if unLockedCoins are greater than "token" of "to", initiate transfer
206             if(unLockedCoins[_from] >= tokens){
207                 return true;
208             }
209             // otherwise revert
210             else{
211                 revert();
212             }
213         }
214     }
215     
216     // ------------------------------------------------------------------------
217     // Unlock the coins if lockingPeriod is expired
218     // ------------------------------------------------------------------------
219     function _updateRecord(address _address) private returns (bool success){
220         PC[] memory tempArray = record[_address];
221         uint tempCount = 0;
222         for(uint i=0; i < tempArray.length; i++){
223             if(tempArray[i].lockingPeriod < now && tempArray[i].added == false){
224                 tempCount = tempCount.add(tempArray[i].coins);
225                 tempArray[i].added = true;
226                 record[_address][i] = PC(tempArray[i].lockingPeriod, tempArray[i].coins, tempArray[i].added);
227             }
228         }
229         unLockedCoins[_address] = unLockedCoins[_address].add(tempCount);
230         return true;
231     }
232     
233 }