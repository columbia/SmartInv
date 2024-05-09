1 pragma solidity ^0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 // input  D:\MDZA-TESTNET1\solidity-flattener\SolidityFlatteryGo\contract\MDZAToken.sol
6 // flattened :  Sunday, 30-Dec-18 09:30:12 UTC
7 contract ApproveAndCallFallBack {
8     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
9 }
10 contract ERCInterface {
11     function totalSupply() public view returns (uint);
12     function balanceOf(address tokenOwner) public view returns (uint balance);
13     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
14     function transfer(address to, uint tokens) public returns (bool success);
15     function approve(address spender, uint tokens) public returns (bool success);
16     function transferFrom(address from, address to, uint tokens) public returns (bool success);
17 
18     event Transfer(address indexed from, address indexed to, uint tokens);
19     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
20     event Burn(address indexed from, uint256 value);
21     event FrozenFunds(address target, bool frozen);
22 }
23 contract Owned {
24     address public owner;
25     address public newOwner;
26 
27     event OwnershipTransferred(address indexed _from, address indexed _to);
28 
29     constructor() public {
30         owner = msg.sender;
31     }
32 
33     modifier onlyOwner {
34         require(msg.sender == owner);
35         _;
36     }
37 
38     function transferOwnership(address _newOwner) public onlyOwner {
39         newOwner = _newOwner;
40     }
41     function acceptOwnership() public {
42         require(msg.sender == newOwner);
43         emit OwnershipTransferred(owner, newOwner);
44         owner = newOwner;
45         newOwner = address(0);
46     }
47 }
48 
49 library SafeMath {
50     function add(uint a, uint b) internal pure returns (uint c) {
51         c = a + b;
52         require(c >= a);
53     }
54     function sub(uint a, uint b) internal pure returns (uint c) {
55         require(b <= a);
56         c = a - b;
57     }
58     function mul(uint a, uint b) internal pure returns (uint c) {
59         c = a * b;
60         require(a == 0 || c / a == b);
61     }
62     function div(uint a, uint b) internal pure returns (uint c) {
63         require(b > 0);
64         c = a / b;
65     }
66 }
67 
68 contract MDZAToken is ERCInterface, Owned {
69     using SafeMath for uint;
70 
71     string public symbol;
72     string public  name;
73     uint8 public decimals;
74     uint _totalSupply;
75     bool transactionLock;
76 
77     // Balances for each account
78     mapping(address => uint) balances;
79 
80     mapping(address => mapping(address => uint)) allowed;
81 
82     mapping (address => bool) public frozenAccount;
83 
84     // Constructor . Please change the values 
85     constructor() public {
86         symbol = "MDZA";
87         name = "MEDOOZA Ecosystem v1.1";
88         decimals = 10;
89         _totalSupply = 1200000000 * 10**uint(decimals);
90         balances[owner] = _totalSupply;
91         transactionLock = false;
92         emit Transfer(address(0), owner, _totalSupply);
93     }
94 
95     // Get total supply
96     function totalSupply() public view returns (uint) {
97         return _totalSupply.sub(balances[address(0)]);
98     }
99 
100     // Get the token balance for specific account
101     function balanceOf(address tokenOwner) public view returns (uint balance) {
102         return balances[tokenOwner];
103     }
104 
105     // Transfer the balance from token owner account to receiver account
106     function transfer(address to, uint tokens) public returns (bool success) {
107         require(to != 0x0); // Prevent transfer to 0x0 address. Use burn() instead
108         require(!transactionLock);  // Check for transaction lock
109         require(!frozenAccount[to]);// Check if recipient is frozen
110         balances[msg.sender] = balances[msg.sender].sub(tokens);
111         balances[to] = balances[to].add(tokens);
112         emit Transfer(msg.sender, to, tokens);
113         return true;
114     }
115 
116     // Token owner can approve for spender to transferFrom(...) tokens from the token owner's account
117     function approve(address spender, uint tokens) public returns (bool success) {
118         allowed[msg.sender][spender] = tokens;
119         emit Approval(msg.sender, spender, tokens);
120         return true;
121     }
122 
123     // Transfer token from spender account to receiver account
124     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
125         require(to != 0x0); // Prevent transfer to 0x0 address. Use burn() instead
126         require(!transactionLock);         // Check for transaction lock
127         require(!frozenAccount[from]);     // Check if sender is frozen
128         require(!frozenAccount[to]);       // Check if recipient is frozen
129         balances[from] = balances[from].sub(tokens);
130         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
131         balances[to] = balances[to].add(tokens);
132         emit Transfer(from, to, tokens);
133         return true;
134     }
135 
136     // Get tokens that are approved by the owner 
137     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
138         return allowed[tokenOwner][spender];
139     }
140 
141     // Token owner can approve for spender to transferFrom(...) tokens
142     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
143         allowed[msg.sender][spender] = tokens;
144         emit Approval(msg.sender, spender, tokens);
145         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
146         return true;
147     }
148 
149     // Don't accept ETH 
150     function () public payable {
151         revert();
152     }
153 
154     // Transfer any ERC Token
155     function transferAnyERCToken(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
156         return ERCInterface(tokenAddress).transfer(owner, tokens);
157     }
158 
159     // Burn specific amount token
160     function burn(uint256 tokens) public returns (bool success) {
161         balances[msg.sender] = balances[msg.sender].sub(tokens);
162         _totalSupply = _totalSupply.sub(tokens);
163         emit Burn(msg.sender, tokens);
164         return true;
165     }
166 
167     // Burn token from specific account and with specific value
168     function burnFrom(address from, uint256 tokens) public  returns (bool success) {
169         balances[from] = balances[from].sub(tokens);
170         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
171         _totalSupply = _totalSupply.sub(tokens);
172         emit Burn(from, tokens);
173         return true;
174     }
175 
176     // Freeze and unFreeze account from sending and receiving tokens
177     function freezeAccount(address target, bool freeze) onlyOwner public {
178         frozenAccount[target] = freeze;
179         emit FrozenFunds(target, freeze);
180     }
181 
182     // Get status of a locked account
183     function freezeAccountStatus(address target) onlyOwner public view returns (bool response){
184         return frozenAccount[target];
185     }
186 
187     // Lock and unLock all transactions
188     function lockTransactions(bool lock) public onlyOwner returns (bool response){
189         transactionLock = lock;
190         return lock;
191     }
192 
193     // Get status of global transaction lock
194     function transactionLockStatus() public onlyOwner view returns (bool response){
195         return transactionLock;
196     }
197 }