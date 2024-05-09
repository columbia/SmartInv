1 pragma solidity ^0.4.11;
2 
3 // ----------------------------------------------------------------------------
4 // Abab.io preICO 
5 // The MIT Licence
6 // ----------------------------------------------------------------------------
7 
8 // ----------------------------------------------------------------------------
9 // Safe maths, borrowed from OpenZeppelin
10 // ----------------------------------------------------------------------------
11 library SafeMath {
12 
13     // ------------------------------------------------------------------------
14     // Add a number to another number, checking for overflows
15     // ------------------------------------------------------------------------
16     function add(uint a, uint b) internal returns (uint) {
17         uint c = a + b;
18         assert(c >= a && c >= b);
19         return c;
20     }
21 
22     // ------------------------------------------------------------------------
23     // Subtract a number from another number, checking for underflows
24     // ------------------------------------------------------------------------
25     function sub(uint a, uint b) internal returns (uint) {
26         assert(b <= a);
27         return a - b;
28     }
29 }
30 
31 
32 // ----------------------------------------------------------------------------
33 // Owned contract
34 // ----------------------------------------------------------------------------
35 contract Owned {
36     address public owner;
37     address public newOwner;
38     event OwnershipTransferred(address indexed _from, address indexed _to);
39 
40     function Owned() {
41         owner = msg.sender;
42     }
43 
44     modifier onlyOwner {
45         if (msg.sender != owner) throw;
46         _;
47     }
48 
49     function transferOwnership(address _newOwner) onlyOwner {
50         newOwner = _newOwner;
51     }
52  
53     function acceptOwnership() {
54         if (msg.sender == newOwner) {
55             OwnershipTransferred(owner, newOwner);
56             owner = newOwner;
57         }
58     }
59 }
60 
61 
62 // ----------------------------------------------------------------------------
63 // ERC20 Token, with the addition of symbol, name and decimals
64 // https://github.com/ethereum/EIPs/issues/20
65 // ----------------------------------------------------------------------------
66 contract ERC20Token is Owned {
67     using SafeMath for uint;
68 
69     // ------------------------------------------------------------------------
70     // Total Supply
71     // ------------------------------------------------------------------------
72     uint256 _totalSupply = 0;
73 
74     // ------------------------------------------------------------------------
75     // Balances for each account
76     // ------------------------------------------------------------------------
77     mapping(address => uint256) balances;
78 
79     // ------------------------------------------------------------------------
80     // Owner of account approves the transfer of an amount to another account
81     // ------------------------------------------------------------------------
82     mapping(address => mapping (address => uint256)) allowed;
83 
84     // ------------------------------------------------------------------------
85     // Get the total token supply
86     // ------------------------------------------------------------------------
87     function totalSupply() constant returns (uint256 totalSupply) {
88         totalSupply = _totalSupply;
89     }
90 
91     // ------------------------------------------------------------------------
92     // Get the account balance of another account with address _owner
93     // ------------------------------------------------------------------------
94     function balanceOf(address _owner) constant returns (uint256 balance) {
95         return balances[_owner];
96     }
97 
98     // ------------------------------------------------------------------------
99     // Transfer the balance from owner's account to another account
100     // ------------------------------------------------------------------------
101     function transfer(address _to, uint256 _amount) returns (bool success) {
102         if (balances[msg.sender] >= _amount                // User has balance
103             && _amount > 0                                 // Non-zero transfer
104             && balances[_to] + _amount > balances[_to]     // Overflow check
105         ) {
106             balances[msg.sender] = balances[msg.sender].sub(_amount);
107             balances[_to] = balances[_to].add(_amount);
108             Transfer(msg.sender, _to, _amount);
109             return true;
110         } else {
111             return false;
112         }
113     }
114 
115     // ------------------------------------------------------------------------
116     // Allow _spender to withdraw from your account, multiple times, up to the
117     // _value amount. If this function is called again it overwrites the
118     // current allowance with _value.
119     // ------------------------------------------------------------------------
120     function approve(
121         address _spender,
122         uint256 _amount
123     ) returns (bool success) {
124         allowed[msg.sender][_spender] = _amount;
125         Approval(msg.sender, _spender, _amount);
126         return true;
127     }
128 
129     // ------------------------------------------------------------------------
130     // Spender of tokens transfer an amount of tokens from the token owner's
131     // balance to the spender's account. The owner of the tokens must already
132     // have approve(...)-d this transfer
133     // ------------------------------------------------------------------------
134     function transferFrom(
135         address _from,
136         address _to,
137         uint256 _amount
138     ) returns (bool success) {
139         if (balances[_from] >= _amount                  // From a/c has balance
140             && allowed[_from][msg.sender] >= _amount    // Transfer approved
141             && _amount > 0                              // Non-zero transfer
142             && balances[_to] + _amount > balances[_to]  // Overflow check
143         ) {
144             balances[_from] = balances[_from].sub(_amount);
145             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
146             balances[_to] = balances[_to].add(_amount);
147             Transfer(_from, _to, _amount);
148             return true;
149         } else {
150             return false;
151         }
152     }
153 
154     // ------------------------------------------------------------------------
155     // Returns the amount of tokens approved by the owner that can be
156     // transferred to the spender's account
157     // ------------------------------------------------------------------------
158     function allowance(
159         address _owner, 
160         address _spender
161     ) constant returns (uint256 remaining) {
162         return allowed[_owner][_spender];
163     }
164 
165     event Transfer(address indexed _from, address indexed _to, uint256 _value);
166     event Approval(address indexed _owner, address indexed _spender,
167         uint256 _value);
168 }
169 
170 
171 contract AbabPreICOToken is ERC20Token {
172 
173     // ------------------------------------------------------------------------
174     // Token information
175     // ------------------------------------------------------------------------
176     string public constant symbol   = "pAA";
177     string public constant name     = "AbabPreICOToken";
178     uint8  public constant decimals = 18;
179 
180     uint256 public STARTDATE;  
181     uint256 public ENDDATE;    
182     uint256 public BUYPRICE;   
183     uint256 public CAP;
184 
185     function AbabPreICOToken() {
186         STARTDATE = 1499951593;        // 2017-07-13T13:13:13UTC to uint256 = 1499951593
187         ENDDATE   = 1500815593;        // 2017-07-23T13:13:13UTC to uint256 = 1500815593
188         BUYPRICE  = 4000;              // in eth will actualize before start. calc $0.05 @ $200 ETH/USD //  4000 pAA per ETH
189         CAP       = 2500*1 ether;      // in eth ($500K / 0.05 ) / etherPrice
190     }
191 	
192     function ActualizePriceBeforeStart(uint256 _start, uint256 _end, uint256 _buyPrice, uint256 _cap) 
193     onlyOwner returns (bool success) 
194     {
195         require(now < STARTDATE);
196         STARTDATE = _start;
197         ENDDATE   = _end;
198         BUYPRICE  = _buyPrice;
199         CAP       = _cap; 
200         return true;
201     }
202 
203     uint256 public totalEthers;
204 
205     // ------------------------------------------------------------------------
206     // Buy tokens from the contract
207     // ------------------------------------------------------------------------
208     function () payable {
209         // No contributions before the start of the crowdsale
210         require(now >= STARTDATE);
211         // No contributions after the end of the crowdsale
212         require(now <= ENDDATE);
213         // No 0 contributions
214         require(msg.value > 0);
215 
216         // Add ETH raised to total
217         totalEthers = totalEthers.add(msg.value);
218         // Cannot exceed cap
219         require(totalEthers <= CAP);
220 
221         uint tokens = msg.value * BUYPRICE;
222 
223         // Check tokens > 0
224         require(tokens > 0);
225 
226         // Add to total supply
227         _totalSupply = _totalSupply.add(tokens);
228 
229         // Add to balances
230         balances[msg.sender] = balances[msg.sender].add(tokens);
231 
232         // Log events
233         Transfer(0x0, msg.sender, tokens);
234 
235         // Move the funds to a safe wallet
236         owner.transfer(msg.value);
237     }
238 
239     // ------------------------------------------------------------------------
240     // Transfer the balance from owner's account to another account, with a
241     // check that the crowdsale is finalised
242     // ------------------------------------------------------------------------
243     function transfer(address _to, uint _amount) returns (bool success) {
244         // Cannot transfer before crowdsale ends or cap reached
245         require(now > ENDDATE || totalEthers == CAP);
246         // Standard transfer
247         return super.transfer(_to, _amount);
248     }
249 
250 
251     // ------------------------------------------------------------------------
252     // Spender of tokens transfer an amount of tokens from the token owner's
253     // balance to another account, with a check that the crowdsale is
254     // finalised
255     // ------------------------------------------------------------------------
256     function transferFrom(address _from, address _to, uint _amount) 
257         returns (bool success)
258     {
259         // Cannot transfer before crowdsale ends or cap reached
260         require(now > ENDDATE || totalEthers == CAP);
261         // Standard transferFrom
262         return super.transferFrom(_from, _to, _amount);
263     }
264 
265 
266     // ------------------------------------------------------------------------
267     // Owner can transfer out any accidentally sent ERC20 tokens
268     // ------------------------------------------------------------------------
269     function transferAnyERC20Token(address tokenAddress, uint amount)
270       onlyOwner returns (bool success) 
271     {
272         return ERC20Token(tokenAddress).transfer(owner, amount);
273     }
274 }