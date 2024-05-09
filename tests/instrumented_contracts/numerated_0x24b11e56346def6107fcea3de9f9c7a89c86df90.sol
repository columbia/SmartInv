1 pragma solidity 0.4.25;
2 
3 library SafeMath {
4     function add(uint a, uint b) internal pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8     function sub(uint a, uint b) internal pure returns (uint c) {
9         require(b <= a);
10         c = a - b;
11     }
12     function mul(uint a, uint b) internal pure returns (uint c) {
13         c = a * b;
14         require(a == 0 || c / a == b);
15     }
16     function div(uint a, uint b) internal pure returns (uint c) {
17         require(b > 0);
18         c = a / b;
19     }
20 }
21 
22 contract ERC20Interface {
23     function totalSupply() public view returns (uint);
24     function balanceOf(address tokenOwner) public view returns (uint balance);
25     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
26     function transfer(address to, uint tokens) public returns (bool success);
27     function approve(address spender, uint tokens) public returns (bool success);
28     function transferFrom(address from, address to, uint tokens) public returns (bool success);
29     event Transfer(address indexed from, address indexed to, uint tokens);
30     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
31     event FrozenFunds(address target, uint tokens);
32     event Buy(address indexed sender, uint eth, uint token);
33 }
34 
35 // Owned contract
36 contract Owned {
37     address public owner;
38     address public newOwner;
39     event OwnershipTransferred(address indexed _from, address indexed _to);
40 
41     constructor() public {
42         owner = msg.sender;
43     }
44     modifier onlyOwner {
45         require(msg.sender == owner);
46         _;
47     }
48 
49     //Transfer owner rights, can use only owner (the best practice of secure for the contracts)
50     function transferOwnership(address _newOwner) public onlyOwner {
51         newOwner = _newOwner;
52     }
53 
54     //Accept tranfer owner rights
55     function acceptOwnership() public onlyOwner {
56         emit OwnershipTransferred(owner, newOwner);
57         owner = newOwner;
58         newOwner = address(0);
59     }
60 }
61 
62 // Pausable Contract
63 contract Pausable is Owned {
64   event Pause();
65   event Unpause();
66 
67   bool public paused = false;
68 
69   //Modifier to make a function callable only when the contract is not paused.
70   modifier whenNotPaused() {
71     require(!paused);
72     _;
73   }
74 
75 
76   //Modifier to make a function callable only when the contract is paused.
77   modifier whenPaused() {
78     require(paused);
79     _;
80   }
81 
82   //called by the owner to pause, triggers stopped state
83   function pause() onlyOwner whenNotPaused public {
84     paused = true;
85     emit Pause();
86   }
87 
88   //called by the owner to unpause, returns to normal state
89   function unpause() onlyOwner whenPaused public {
90     paused = false;
91     emit Unpause();
92   }
93 }
94 
95 contract GTEX is ERC20Interface, Pausable {
96     using SafeMath for uint;
97     string public symbol;
98     string public  name;
99     uint8 public decimals;
100 
101     uint public _totalSupply;
102     mapping(address => uint) public balances;
103     mapping(address => uint) public lockInfo;
104     mapping(address => mapping(address => uint)) internal allowed;
105     mapping (address => bool) public admins;
106     
107     modifier onlyAdmin {
108         require(msg.sender == owner || admins[msg.sender]);
109         _;
110     }
111 
112     function setAdmin(address _admin, bool isAdmin) public onlyOwner {
113         admins[_admin] = isAdmin;
114     }
115 
116     constructor() public{
117         symbol = 'GTEX';
118         name = 'GTEX Token';
119         decimals = 18;
120         _totalSupply = 4000000000*10**uint(decimals);
121         balances[owner] = _totalSupply;
122         emit Transfer(address(0), owner, _totalSupply);
123     }
124 
125     function totalSupply() public view returns (uint) {
126         return _totalSupply;
127     }
128 
129     function balanceOf(address tokenOwner) public view returns (uint balance) {
130         return balances[tokenOwner];
131     }
132 
133     function _transfer(address _from, address _to, uint _value) internal {
134         require(_to != 0x0);                                    // Prevent transfer to 0x0 address. 
135         require(_value != 0);                                   // Prevent transfer 0
136         require(balances[_from] >= _value);                     // Check if the sender has enough
137         require(balances[_from] - _value >= lockInfo[_from]);   // Check after transaction, balance is still more than locked value
138         balances[_from] = balances[_from].sub(_value);          // Substract value from sender
139         balances[_to] = balances[_to].add(_value);              // Add value to recipient
140         emit Transfer(_from, _to, _value);
141     }
142 
143     function transfer(address to, uint tokens) public whenNotPaused returns (bool success) {
144          _transfer(msg.sender, to, tokens);
145          return true;
146     }
147 
148     function approve(address _spender, uint tokens) public whenNotPaused returns (bool success) {
149         allowed[msg.sender][_spender] = tokens;
150         emit Approval(msg.sender, _spender, tokens);
151         return true;
152     }
153 
154     function transferFrom(address from, address to, uint tokens) public whenNotPaused returns (bool success) {
155         require(allowed[from][msg.sender] >= tokens);
156         _transfer(from, to, tokens);
157         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
158         return true;
159     }
160 
161     function allowance(address tokenOwner, address spender) public whenNotPaused view returns (uint remaining) {
162         return allowed[tokenOwner][spender];
163     }
164     
165     //Admin Tool
166     function lockOf(address tokenOwner) public view returns (uint lockedToken) {
167         return lockInfo[tokenOwner];
168     }
169 
170     //lock tokens or lock 0 to release all
171     function lock(address target, uint lockedToken) public whenNotPaused onlyAdmin {
172         lockInfo[target] = lockedToken;
173         emit FrozenFunds(target, lockedToken);
174     }
175     
176     //Batch lock amount with array
177     function batchLockArray(address[] accounts, uint[] lockedToken) public whenNotPaused onlyAdmin {
178       for (uint i = 0; i < accounts.length; i++) {
179            lock(accounts[i], lockedToken[i]);
180         }
181     }
182     
183     //Send token with lock 
184     function sendTokensWithLock (address receiver, uint tokens, bool freeze) public whenNotPaused onlyAdmin {
185         _transfer(msg.sender, receiver, tokens);
186         if(freeze) {
187             uint lockedAmount = lockInfo[receiver] + tokens;
188             lock(receiver, lockedAmount);
189         }
190     }
191 
192     //VIP Batch with lock
193     function batchVipWithLock(address[] receivers, uint[] tokens, bool freeze) public whenNotPaused onlyAdmin {
194       for (uint i = 0; i < receivers.length; i++) {
195            sendTokensWithLock(receivers[i], tokens[i], freeze);
196         }
197     }
198 
199     //Send initial tokens
200     function sendInitialTokens (address user) public onlyOwner {
201         _transfer(msg.sender, user, balanceOf(owner));
202     }
203 }