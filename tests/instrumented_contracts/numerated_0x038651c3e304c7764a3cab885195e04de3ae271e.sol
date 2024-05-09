1 pragma solidity 0.4.24;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal constant returns (uint256) {
11         uint256 c = a / b;
12         return c;
13     }
14 
15     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
16         assert(b <= a);
17         return a - b;
18     }
19 
20     function add(uint256 a, uint256 b) internal constant returns (uint256) {
21         uint256 c = a + b;
22         assert(c >= a);
23         return c;
24     }
25 }
26 
27 contract Ownable {
28     address public owner;
29     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
30 
31     function Ownable() public {
32         owner = msg.sender;
33     }
34 
35     modifier onlyOwner() {
36         require(msg.sender == owner);
37         _;
38     }
39 
40     function transferOwnership(address newOwner) onlyOwner public {
41         require(newOwner != address(0));
42         OwnershipTransferred(owner, newOwner);
43         owner = newOwner;
44     }
45 }
46 
47 contract ERC20 {
48     uint256 public totalSupply;
49     function balanceOf(address who) public constant returns (uint256);
50     function transfer(address to, uint256 value) public returns (bool);
51     event Transfer(address indexed from, address indexed to, uint256 value);
52 
53     function allowance(address owner, address spender) public constant returns (uint256);
54     function transferFrom(address from, address to, uint256 value) public returns (bool);
55     function approve(address spender, uint256 value) public returns (bool);
56     event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 contract StandardToken is ERC20 {
60     using SafeMath for uint256;
61 
62     mapping (address => uint256) balances;
63     mapping (address => mapping (address => uint256)) allowed;
64 
65     function transfer(address _to, uint256 _value) public returns (bool) {
66         require(_to != address(0));
67         require(_value > 0);
68 
69         balances[msg.sender] = balances[msg.sender].sub(_value);
70         balances[_to] = balances[_to].add(_value);
71         Transfer(msg.sender, _to, _value);
72         return true;
73     }
74 
75     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
76         require(_from != address(0));
77         require(_to != address(0));
78 
79         uint256 _allowance = allowed[_from][msg.sender];
80 
81         balances[_from] = balances[_from].sub(_value);
82         balances[_to] = balances[_to].add(_value);
83         allowed[_from][msg.sender] = _allowance.sub(_value);
84         Transfer(_from, _to, _value);
85         return true;
86     }
87 
88     function balanceOf(address _owner) public constant returns (uint256 balance) {
89         return balances[_owner];
90     }
91 
92     function approve(address _spender, uint256 _value) public returns (bool) {
93         allowed[msg.sender][_spender] = _value;
94         Approval(msg.sender, _spender, _value);
95         return true;
96     }
97 
98     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
99         return allowed[_owner][_spender];
100     }
101 }
102 
103 contract CreditAsiaCoin is StandardToken, Ownable {
104 
105     string public name = "CreditAsia Coin";
106     string public symbol = "CAC";
107     uint public decimals = 18;
108 
109     // The token allocation
110     uint public constant TOTAL_SUPPLY       = 10000000000e18;
111     uint public constant ALLOC_FOUNDER    =  10000000000e18; // 100%
112     
113 
114     // wallets
115     address public constant WALLET_FOUNDER    = 0xbb90E8310a78f99aB776985A9B7ecDf39ace98e9; 
116     
117     
118     // 2 groups of lockup
119     mapping(address => uint256) public contributors_locked; 
120     mapping(address => uint256) public investors_locked;
121 
122     // 2 types of releasing
123     mapping(address => uint256) public contributors_countdownDate;
124     mapping(address => uint256) public investors_deliveryDate;
125 
126     // MODIFIER
127 
128     // checks if the address can transfer certain amount of tokens
129     modifier canTransfer(address _sender, uint256 _value) {
130         require(_sender != address(0));
131 
132         uint256 remaining = balances[_sender].sub(_value);
133         uint256 totalLockAmt = 0;
134 
135         if (contributors_locked[_sender] > 0) {
136             totalLockAmt = totalLockAmt.add(getLockedAmount_contributors(_sender));
137         }
138 
139         if (investors_locked[_sender] > 0) {
140             totalLockAmt = totalLockAmt.add(getLockedAmount_investors(_sender));
141         }
142 
143         require(remaining >= totalLockAmt);
144 
145         _;
146     }
147 
148     // EVENTS
149     event UpdatedLockingState(string whom, address indexed to, uint256 value, uint256 date);
150 
151     // FUNCTIONS
152 
153     function CreditAsiaCoin() public {
154         balances[msg.sender] = TOTAL_SUPPLY;
155         totalSupply = TOTAL_SUPPLY;
156 
157         // do the distribution of the token, in token transfer
158         transfer(WALLET_FOUNDER, ALLOC_FOUNDER);
159         
160     }
161 	
162     // get contributors' locked amount of token
163     // this lockup will be released in 8 batches which take place every 180 days
164     function getLockedAmount_contributors(address _contributor) 
165         public
166 		constant
167 		returns (uint256)
168 	{
169         uint256 countdownDate = contributors_countdownDate[_contributor];
170         uint256 lockedAmt = contributors_locked[_contributor];
171 
172         if (now <= countdownDate +  (90 * 1 days )) {return lockedAmt;}
173        
174 	
175         return 0;
176     }
177 
178     // get investors' locked amount of token
179     // this lockup will be released in 3 batches: 
180     // 1. on delievery date
181     // 2. three months after the delivery date
182     // 3. six months after the delivery date
183     function getLockedAmount_investors(address _investor)
184         public
185 		constant
186 		returns (uint256)
187 	{
188         uint256 delieveryDate = investors_deliveryDate[_investor];
189         uint256 lockedAmt = investors_locked[_investor];
190 
191         if (now <= delieveryDate) {return lockedAmt;}
192         if (now <= delieveryDate + 90 days) {return lockedAmt;}
193         
194 	
195         return 0;
196     }
197 
198     // set lockup for contributors 
199     function setLockup_contributors(address _contributor, uint256 _value, uint256 _countdownDate)
200         public
201         onlyOwner
202     {
203         require(_contributor != address(0));
204 
205         contributors_locked[_contributor] = _value;
206         contributors_countdownDate[_contributor] = _countdownDate;
207         UpdatedLockingState("contributor", _contributor, _value, _countdownDate);
208     }
209 
210     // set lockup for strategic investor
211     function setLockup_investors(address _investor, uint256 _value, uint256 _delieveryDate)
212         public
213         onlyOwner
214     {
215         require(_investor != address(0));
216 
217         investors_locked[_investor] = _value;
218         investors_deliveryDate[_investor] = _delieveryDate;
219         UpdatedLockingState("investor", _investor, _value, _delieveryDate);
220     }
221 
222 	// Transfer amount of tokens from sender account to recipient.
223     function transfer(address _to, uint _value)
224         public
225         canTransfer(msg.sender, _value)
226 		returns (bool success)
227 	{
228         return super.transfer(_to, _value);
229     }
230 
231 	// Transfer amount of tokens from a specified address to a recipient.
232     function transferFrom(address _from, address _to, uint _value)
233         public
234         canTransfer(_from, _value)
235 		returns (bool success)
236 	{
237         return super.transferFrom(_from, _to, _value);
238     }
239 }