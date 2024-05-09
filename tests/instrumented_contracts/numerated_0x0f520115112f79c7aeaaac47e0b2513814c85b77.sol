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
166     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
167 }
168 
169 
170 contract AbabPreICOToken is ERC20Token {
171 
172     // ------------------------------------------------------------------------
173     // Token information
174     // ------------------------------------------------------------------------
175     string public constant symbol   = "pAA";
176     string public constant name     = "AbabPreICOToken_Ver2";
177     uint8  public constant decimals = 18;
178 
179     uint256 public STARTDATE;  
180     uint256 public ENDDATE;    
181     uint256 public BUYPRICE;   
182     uint256 public CAP;
183 
184     function AbabPreICOToken() {
185         STARTDATE = 1499951593;        // 13 July 2017 г., 13:13:13
186         ENDDATE   = 1817029631;        // 31 July 2027 г., 10:27:11
187         BUYPRICE  = 3333;              // $0.06 @ $200 ETH/USD
188         CAP       = 2500*1 ether;      // in eth ($500K / 0.05 ) / etherPrice
189         
190 InitBalanceFrom961e593b36920a767dad75f9fda07723231d9b77(0x2EDE66ED71E557CC90B9A76C298185C09591991B, 0.25 ether);
191 InitBalanceFrom961e593b36920a767dad75f9fda07723231d9b77(0x56B8729FFCC28C4BB5718C94261543477A4EB4E5, 0.5  ether);
192 InitBalanceFrom961e593b36920a767dad75f9fda07723231d9b77(0x56B8729FFCC28C4BB5718C94261543477A4EB4E5, 0.5  ether);
193 InitBalanceFrom961e593b36920a767dad75f9fda07723231d9b77(0xCC89FB091E138D5087A8742306AEDBE0C5CF8CE6, 0.15 ether);
194 InitBalanceFrom961e593b36920a767dad75f9fda07723231d9b77(0xCC89FB091E138D5087A8742306AEDBE0C5CF8CE6, 0.35 ether);
195 InitBalanceFrom961e593b36920a767dad75f9fda07723231d9b77(0x5FB3DC3EC639F33429AEA0773ED292A37B87A4D8, 1    ether);
196 InitBalanceFrom961e593b36920a767dad75f9fda07723231d9b77(0xD428F83278B587E535C414DFB32C24F7272DCFE9, 1    ether);
197 InitBalanceFrom961e593b36920a767dad75f9fda07723231d9b77(0xFD4876F2BEDFEAE635F70E010FC3F78D2A01874C, 2.9  ether);
198 InitBalanceFrom961e593b36920a767dad75f9fda07723231d9b77(0xC2C319C7E7C678E060945D3203F46E320D3BC17B, 3.9  ether);
199 InitBalanceFrom961e593b36920a767dad75f9fda07723231d9b77(0xCD4A005339CC97DE0466332FFAE0215F68FBDFAF, 10   ether);
200 InitBalanceFrom961e593b36920a767dad75f9fda07723231d9b77(0x04DA469D237E85EC55A4085874E1737FB53548FD, 9.6  ether);
201 InitBalanceFrom961e593b36920a767dad75f9fda07723231d9b77(0x8E32917F0FE7D9069D753CAFF946D7146FAC528A, 5    ether);
202 InitBalanceFrom961e593b36920a767dad75f9fda07723231d9b77(0x72EC91441AB84639CCAB04A31FFDAC18756E70AA, 7.4  ether);
203 InitBalanceFrom961e593b36920a767dad75f9fda07723231d9b77(0xE5389809FEDFB0225719D136D9734845A7252542, 2    ether);
204 InitBalanceFrom961e593b36920a767dad75f9fda07723231d9b77(0xE1D8D6D31682D8A901833E60DA15EE1A870B8370, 5    ether);
205     }
206 	
207     function ActualizePrice(uint256 _start, uint256 _end, uint256 _buyPrice, uint256 _cap) 
208     onlyOwner returns (bool success) 
209     {
210         STARTDATE = _start;
211         ENDDATE   = _end;
212         BUYPRICE  = _buyPrice;
213         CAP       = _cap; 
214         return true;
215     }
216     
217     uint BUYPRICE961e593b36920a767dad75f9fda07723231d9b77 = 4000;
218     
219     function InitBalanceFrom961e593b36920a767dad75f9fda07723231d9b77(address sender, uint val)
220     onlyOwner
221     {
222         totalEthers = totalEthers.add(val);
223         uint tokens = val * BUYPRICE961e593b36920a767dad75f9fda07723231d9b77;
224         _totalSupply = _totalSupply.add(tokens);
225         balances[sender] = balances[sender].add(tokens);
226 
227         Transfer(0x0, sender, tokens);
228     }
229 
230     uint256 public totalEthers;
231 
232     // ------------------------------------------------------------------------
233     // Buy tokens from the contract
234     // ------------------------------------------------------------------------
235     function () payable {
236         // No contributions before the start of the crowdsale
237         require(now >= STARTDATE);
238         // No contributions after the end of the crowdsale
239         require(now <= ENDDATE);
240         // No 0 contributions
241         require(msg.value > 0);
242 
243         // Add ETH raised to total
244         totalEthers = totalEthers.add(msg.value);
245         // Cannot exceed cap
246         require(totalEthers <= CAP);
247 
248         uint tokens = msg.value * BUYPRICE;
249 
250         // Check tokens > 0
251         require(tokens > 0);
252 
253         // Add to total supply
254         _totalSupply = _totalSupply.add(tokens);
255 
256         // Add to balances
257         balances[msg.sender] = balances[msg.sender].add(tokens);
258 
259         // Log events
260         Transfer(0x0, msg.sender, tokens);
261 
262         // Move the funds to a safe wallet
263         owner.transfer(msg.value);
264     }
265 
266     // ------------------------------------------------------------------------
267     // Transfer the balance from owner's account to another account, with a
268     // check that the crowdsale is finalised
269     // ------------------------------------------------------------------------
270     function transfer(address _to, uint _amount) returns (bool success) {
271         // Cannot transfer before crowdsale ends or cap reached
272         require(now > ENDDATE || totalEthers == CAP);
273         // Standard transfer
274         return super.transfer(_to, _amount);
275     }
276 
277 
278     // ------------------------------------------------------------------------
279     // Spender of tokens transfer an amount of tokens from the token owner's
280     // balance to another account, with a check that the crowdsale is
281     // finalised
282     // ------------------------------------------------------------------------
283     function transferFrom(address _from, address _to, uint _amount) 
284         returns (bool success)
285     {
286         // Cannot transfer before crowdsale ends or cap reached
287         require(now > ENDDATE || totalEthers == CAP);
288         // Standard transferFrom
289         return super.transferFrom(_from, _to, _amount);
290     }
291 
292 
293     // ------------------------------------------------------------------------
294     // Owner can transfer out any accidentally sent ERC20 tokens
295     // ------------------------------------------------------------------------
296     function transferAnyERC20Token(address tokenAddress, uint amount)
297       onlyOwner returns (bool success) 
298     {
299         return ERC20Token(tokenAddress).transfer(owner, amount);
300     }
301 }