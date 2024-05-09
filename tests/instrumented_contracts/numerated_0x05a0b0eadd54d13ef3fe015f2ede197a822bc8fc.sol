1 pragma solidity ^0.4.10;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal returns (uint256) {
15         uint256 c = a / b;
16         return c;
17     }
18 
19     function sub(uint256 a, uint256 b) internal returns (uint256) {
20         assert(b <= a);
21         return a - b;
22     }
23 
24     function add(uint256 a, uint256 b) internal returns (uint256) {
25         uint256 c = a + b;
26         assert(c >= a);
27         return c;
28     }
29 }
30 
31 contract Owned {
32     address public owner;
33 
34     event OwnershipTransferred(address indexed _from, address indexed _to);
35 
36     function Owned() {
37         owner = msg.sender;
38     }
39 
40     modifier onlyOwner {
41         assert(msg.sender == owner);
42         _;
43     }
44 
45 
46     function transferOwnership(address newOwner) onlyOwner {
47         OwnershipTransferred(owner, newOwner);
48         owner = newOwner;
49     }
50 }
51 
52 contract ERC20 is Owned {
53 
54     // Get the account balance of another account with address _owner
55     function balanceOf(address _owner) constant returns (uint256 balance);
56 
57     // Send _value amount of tokens to address _to
58     function transfer(address _to, uint256 _value) returns (bool success);
59 
60     // Send _value amount of tokens from address _from to address _to on the condition it is approved by _from
61     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
62 
63     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
64     // If this function is called again it overwrites the current allowance with _value.
65     function approve(address _spender, uint256 _value) returns (bool success);
66 
67     // Returns the amount which _spender is still allowed to withdraw from _owner
68     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
69 
70     // Triggered when tokens are transferred.
71     event Transfer(address indexed _from, address indexed _to, uint256 _value);
72 
73     // Triggered whenever approve(address _spender, uint256 _value) is called.
74     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
75 }
76 
77 contract ThankYouToken is ERC20 {
78     using SafeMath for uint256;
79 
80     // Total amount of token
81     uint256 public totalSupply;
82 
83     // Balances for each account
84     mapping(address => uint256) balances;
85 
86     // Owner of account approves the transfer of an amount to another account
87     mapping (address => mapping (address => uint256)) allowed;
88 
89     //Fix for the ERC20 short address attack
90     modifier onlyPayloadSize(uint256 size) {
91         assert(msg.data.length >= size + 4);
92         _;
93     }
94 
95     function balanceOf(address _owner) constant returns (uint256 balance){
96         return balances[_owner];
97     }
98 
99     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
100         if (balances[_from] >= _value
101         && allowed[_from][msg.sender] >= _value //the transfer is approved
102         && _value > 0
103         && balances[_to] + _value > balances[_to]) {
104 
105             balances[_to]   = balances[_to].add(_value);
106             balances[_from] = balances[_from].sub(_value);
107             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
108 
109             Transfer(_from, _to, _value);
110             return true;
111         } else {
112             return false;
113         }
114     }
115 
116     function approve(address _spender, uint256 _value) onlyPayloadSize(2*32) returns (bool success) {
117         // To change the approve amount you first have to reduce the addresses`
118         //  allowance to zero by calling `approve(_spender, 0)` if it is not
119         //  already 0 to mitigate the race condition described here:
120         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
121         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) {
122             return false;
123         }
124         allowed[msg.sender][_spender] = _value;
125 
126         Approval(msg.sender, _spender, _value);
127         return true;
128     }
129 
130 
131     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
132         return allowed[_owner][_spender];
133     }
134 
135     // Transfer the balance _value from owner's account (msg.sender) to another account (_to)
136     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool success) {
137         if (balances[msg.sender] >= _value && _value > 0 && balances[_to] + _value > balances[_to]) {
138 
139             balances[msg.sender] = balances[msg.sender].sub(_value);
140             balances[_to] = balances[_to].add(_value);
141             Transfer(msg.sender, _to, _value);
142 
143             return true;
144         } else {
145             return false;
146         }
147     }
148 
149 
150     string public thankYou  = "ThankYou!";
151     string public name;
152     string public symbol;
153     uint256 public decimals = 18;
154 
155     function ThankYouToken(uint256 _initialSupply) {
156         name = "ThankYou! Token";
157         symbol = "TYT";
158         totalSupply = _initialSupply;
159         balances[msg.sender] = _initialSupply;
160     }
161     //---------------------------------------------------------------------------------------------------
162 
163     //Number of purchases per address
164     mapping(address => uint256) numPurchasesPerAddress;
165 
166     bool public crowdsaleClosed = true;
167     uint256 bonusMultiplier             = 50 * 10**decimals;
168     uint256 public bonusTokensIssued    = 0;
169     uint256 public freeTokensAvailable  = 10000 * 10**decimals;
170     uint256 public freeTokensIssued     = 0;
171     uint256 freeTokensPerAddress        = 2 * 10**decimals;
172     uint256 public contribution         = 0;
173     uint256 public totalTokensIssued    = 0;
174     // Accounts that have received the 2 TYT for free
175     mapping(address => bool) addressBonusReceived;
176 
177     event BonusTokens(address _from, address _to, uint256 _bonusToken);
178     event FreeTokensIssued(address _from, address _to, uint256 _value);
179     event FreeTokenAdded(address _from, uint256 _value);
180 
181     function openCrowdsale() onlyOwner {
182         crowdsaleClosed = false;
183     }
184 
185     function stopCrowdsale() onlyOwner {
186         crowdsaleClosed = true;
187     }
188 
189 
190     function() payable {
191         if(msg.value == 0){
192             assert(!addressBonusReceived[msg.sender]);
193             assert(freeTokensAvailable >= freeTokensPerAddress);
194             assert(balances[owner] >= freeTokensPerAddress);
195 
196             addressBonusReceived[msg.sender] = true;
197 
198             freeTokensAvailable = freeTokensAvailable.sub(freeTokensPerAddress);
199             freeTokensIssued    = freeTokensIssued.add(freeTokensPerAddress);
200 
201             balances[msg.sender] = balances[msg.sender].add(freeTokensPerAddress);
202             balances[owner] = balances[owner].sub(freeTokensPerAddress);
203 
204             totalTokensIssued = totalTokensIssued.add(freeTokensPerAddress);
205 
206             FreeTokensIssued(owner, msg.sender, freeTokensPerAddress);
207 
208         } else {
209             assert(!crowdsaleClosed);
210 
211             // 1 ETH = 1000 ThankYou tokens
212             uint256 tokensSent = (msg.value * 1000);
213             assert(balances[owner] >= tokensSent);
214 
215             if(msg.value >= 50 finney){
216                 numPurchasesPerAddress[msg.sender] = numPurchasesPerAddress[msg.sender].add(1);
217 
218                 uint256 bonusTokens = numPurchasesPerAddress[msg.sender].mul(bonusMultiplier);
219                 tokensSent = tokensSent.add(bonusTokens);
220                 bonusTokensIssued = bonusTokensIssued.add(bonusTokens);
221 
222                 assert(balances[owner] >= tokensSent);
223                 BonusTokens(owner, msg.sender, bonusTokens);
224             }
225 
226             owner.transfer(msg.value);
227             contribution = contribution.add(msg.value);
228 
229             balances[owner] = balances[owner].sub(tokensSent);
230             totalTokensIssued = totalTokensIssued.add(tokensSent);
231             balances[msg.sender] = balances[msg.sender].add(tokensSent);
232             Transfer(address(this), msg.sender, tokensSent);
233         }
234 
235     }
236 
237 }