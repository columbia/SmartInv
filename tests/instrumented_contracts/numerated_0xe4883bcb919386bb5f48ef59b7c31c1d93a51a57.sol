1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-26
3 */
4 
5 pragma solidity ^0.4.24;
6 
7 library SafeMath {
8     function add(uint a, uint b) internal pure returns (uint c) {
9         c = a + b;
10         require(c >= a);
11     }
12     function sub(uint a, uint b) internal pure returns (uint c) {
13         require(b <= a);
14         c = a - b;
15     }
16     function mul(uint a, uint b) internal pure returns (uint c) {
17         c = a * b;
18         require(a == 0 || c / a == b);
19     }
20     function div(uint a, uint b) internal pure returns (uint c) {
21         require(b > 0);
22         c = a / b;
23     }
24 }
25 
26 
27 // ----------------------------------------------------------------------------
28 // Ownership contract
29 // _newOwner is address of new owner
30 // ----------------------------------------------------------------------------
31 contract Owned {
32     
33     address public owner;
34     address public SPYdeployerOwner;
35 
36 
37     event OwnershipTransferred(address indexed _from, address indexed _to);
38 
39     constructor() public {
40         owner = 0x6968a3cDc11f71a85CDd13BB2792899E5D215DbB;
41         SPYdeployerOwner = 0xe5b5CECDdB34A42A8A0eFC876C56306DBDD5d8Fc;
42       
43 
44     }
45 
46     modifier onlyOwner {
47         require(msg.sender == owner);
48         _;
49     }
50 
51     // transfer Ownership to other address
52     function transferOwnership(address _newOwner) public onlyOwner {
53         require(_newOwner != address(0x0));
54         emit OwnershipTransferred(owner,_newOwner);
55         owner = _newOwner;
56     }
57     
58 }
59 
60 
61 // ----------------------------------------------------------------------------
62 // ERC Token Standard #20 Interface
63 // ----------------------------------------------------------------------------
64 contract ERC20Interface {
65     function totalSupply() public constant returns (uint);
66     function balanceOf(address tokenOwner) public constant returns (uint balance);
67     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
68     function transfer(address to, uint tokens) public returns (bool success);
69     function approve(address spender, uint tokens) public returns (bool success);
70     function transferFrom(address from, address to, uint tokens) public returns (bool success);
71 
72     event Transfer(address indexed from, address indexed to, uint tokens);
73     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
74 }
75 
76 // ----------------------------------------------------------------------------
77 // ERC20 Token, with the addition of symbol, name and decimals and an
78 // initial fixed supply
79 
80 
81 
82 // ----------------------------------------------------------------------------
83 contract SPY is ERC20Interface, Owned {
84     
85     using SafeMath for uint;
86 
87     string public symbol;
88     string public  name;
89     uint8 public decimals;
90     uint public _totalSupply;
91     uint public tokenSupply;
92 	uint public SPYdeployerSupply;
93 
94 
95 
96     mapping(address => uint) balances;
97     mapping(address => mapping(address => uint)) allowed;
98     
99    
100     
101 
102 
103     // ------------------------------------------------------------------------
104     // Constructor
105     // ------------------------------------------------------------------------
106     constructor() public {
107         symbol = "SPY";
108         name = "SATOPAY YIELD";
109         decimals = 18;
110         _totalSupply = 780000 * 10**uint(decimals);
111         tokenSupply = 380000 * 10**uint(decimals);
112 		SPYdeployerSupply = 400000 * 10**uint(decimals);
113      
114 
115         
116         balances[owner] = tokenSupply;
117         balances[SPYdeployerOwner] = SPYdeployerSupply;
118     
119 
120       
121     
122         
123         emit Transfer(address(0), owner, tokenSupply);
124         emit Transfer(address(0), SPYdeployerOwner, SPYdeployerSupply);
125       
126 
127     }
128     
129 
130     
131   
132     
133     // ------------------------------------------------------------------------
134     // Total supply
135     // ------------------------------------------------------------------------
136     function totalSupply() public view returns (uint) {
137         return _totalSupply;
138     }
139 
140 
141     // ------------------------------------------------------------------------
142     // Get the token balance for account `tokenOwner`
143     // ------------------------------------------------------------------------
144     function balanceOf(address tokenOwner) public view returns (uint balance) {
145         return balances[tokenOwner];
146     }
147 
148 
149     // ------------------------------------------------------------------------
150     // Transfer the balance from token owner's account to `to` account
151     // - Owner's account must have sufficient balance to transfer
152     // - 0 value transfers are allowed
153     // ------------------------------------------------------------------------
154     function transfer(address to, uint tokens) public returns (bool success) {
155         require(to != address(0));
156         require(tokens > 0);
157         require(balances[msg.sender] >= tokens);
158         
159         balances[msg.sender] = balances[msg.sender].sub(tokens);
160         balances[to] = balances[to].add(tokens);
161         emit Transfer(msg.sender, to, tokens);
162         return true;
163     }
164 
165 
166     // ------------------------------------------------------------------------
167     // Token owner can approve for `spender` to transferFrom(...) `tokens`
168     // from the token owner's account
169     //
170     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
171     // recommends that there are no checks for the approval double-spend attack
172     // as this should be implemented in user interfaces 
173     // ------------------------------------------------------------------------
174     function approve(address spender, uint tokens) public returns (bool success) {
175         require(spender != address(0));
176         require(tokens > 0);
177         
178         allowed[msg.sender][spender] = tokens;
179         emit Approval(msg.sender, spender, tokens);
180         return true;
181     }
182 
183 
184     // ------------------------------------------------------------------------
185     // Transfer `tokens` from the `from` account to the `to` account
186     // 
187     // The calling account must already have sufficient tokens approve(...)-d
188     // for spending from the `from` account and
189     // - From account must have sufficient balance to transfer
190     // - Spender must have sufficient allowance to transfer
191     // ------------------------------------------------------------------------
192     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
193         require(from != address(0));
194         require(to != address(0));
195         require(tokens > 0);
196         require(balances[from] >= tokens);
197         require(allowed[from][msg.sender] >= tokens);
198         
199         balances[from] = balances[from].sub(tokens);
200         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
201         balances[to] = balances[to].add(tokens);
202         emit Transfer(from, to, tokens);
203         return true;
204     }
205 
206 
207     // ------------------------------------------------------------------------
208     // Returns the amount of tokens approved by the owner that can be
209     // transferred to the spender's account
210     // ------------------------------------------------------------------------
211     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
212         return allowed[tokenOwner][spender];
213     }
214     
215     
216     // ------------------------------------------------------------------------
217     // Increase the amount of tokens that an owner allowed to a spender.
218     //
219     // approve should be called when allowed[_spender] == 0. To increment
220     // allowed value is better to use this function to avoid 2 calls (and wait until
221     // the first transaction is mined)
222     // _spender The address which will spend the funds.
223     // _addedValue The amount of tokens to increase the allowance by.
224     // ------------------------------------------------------------------------
225     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
226         require(_spender != address(0));
227         
228         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
229         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
230         return true;
231     }
232     
233     
234     // ------------------------------------------------------------------------
235     // Decrease the amount of tokens that an owner allowed to a spender.
236     //
237     // approve should be called when allowed[_spender] == 0. To decrement
238     // allowed value is better to use this function to avoid 2 calls (and wait until
239     // the first transaction is mined)
240     // _spender The address which will spend the funds.
241     // _subtractedValue The amount of tokens to decrease the allowance by.
242     // ------------------------------------------------------------------------
243     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
244         require(_spender != address(0));
245         
246         uint oldValue = allowed[msg.sender][_spender];
247         if (_subtractedValue > oldValue) {
248             allowed[msg.sender][_spender] = 0;
249         } else {
250             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
251         }
252         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
253         return true;
254     }
255     
256    
257 
258 }