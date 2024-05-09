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
103 contract ZYHToken is StandardToken, Ownable {
104 
105     string public name = "ZYH Token";
106     string public symbol = "ZYH";
107     uint public decimals = 18;
108 
109     // The token allocation
110     uint public constant TOTAL_SUPPLY       = 10000000000e18;
111     uint public constant ALLOC_ECOSYSTEM    =  10000000000e18; // 30%
112     //uint public constant ALLOC_FOUNDATION   =  2100000000e18; // 20%
113     //uint public constant ALLOC_TEAM         =  450000000e18; // 15%
114     //uint public constant ALLOC_PARTNER      =  300000000e18; // 10%
115     //uint public constant ALLOC_SALE         =  750000000e18; // 25%
116 
117     // wallets
118     address public constant WALLET_ECOSYSTEM    = 0x47b6358164b81d500fb16c33ae3e91223fae2086; 
119     //address public constant WALLET_FOUNDATION   = 0xbF96a0452A3388488673006bE65bC928BDe780d6;
120     //address public constant WALLET_TEAM         = 0x9f255092008F6163395aEB35c4Dec58a1ecbdFd6;
121     //address public constant WALLET_PARTNER      = 0xD6d64A62A7fF8F55841b0DD2c02d5052457bCA6c;
122     //address public constant WALLET_SALE         = 0x55aaeC60E116086AC3a5e4fDC74b21de9B91CC53;
123     
124     // 2 groups of lockup
125     mapping(address => uint256) public contributors_locked; 
126     mapping(address => uint256) public investors_locked;
127 
128     // 2 types of releasing
129     mapping(address => uint256) public contributors_countdownDate;
130     mapping(address => uint256) public investors_deliveryDate;
131 
132     // MODIFIER
133 
134     // checks if the address can transfer certain amount of tokens
135     modifier canTransfer(address _sender, uint256 _value) {
136         require(_sender != address(0));
137 
138         uint256 remaining = balances[_sender].sub(_value);
139         uint256 totalLockAmt = 0;
140 
141         if (contributors_locked[_sender] > 0) {
142             totalLockAmt = totalLockAmt.add(getLockedAmount_contributors(_sender));
143         }
144 
145         if (investors_locked[_sender] > 0) {
146             totalLockAmt = totalLockAmt.add(getLockedAmount_investors(_sender));
147         }
148 
149         require(remaining >= totalLockAmt);
150 
151         _;
152     }
153 
154     // EVENTS
155     event UpdatedLockingState(string whom, address indexed to, uint256 value, uint256 date);
156 
157     // FUNCTIONS
158 
159     function ZYHToken() public {
160         balances[msg.sender] = TOTAL_SUPPLY;
161         totalSupply = TOTAL_SUPPLY;
162 
163         // do the distribution of the token, in token transfer
164         transfer(WALLET_ECOSYSTEM, ALLOC_ECOSYSTEM);
165         //transfer(WALLET_FOUNDATION, ALLOC_FOUNDATION);
166         //transfer(WALLET_TEAM, ALLOC_TEAM);
167         //transfer(WALLET_PARTNER, ALLOC_PARTNER);
168         //transfer(WALLET_SALE, ALLOC_SALE);
169     }
170 	
171     // get contributors' locked amount of token
172     // this lockup will be released in 8 batches which take place every 180 days
173     function getLockedAmount_contributors(address _contributor) 
174         public
175 		constant
176 		returns (uint256)
177 	{
178         uint256 countdownDate = contributors_countdownDate[_contributor];
179         uint256 lockedAmt = contributors_locked[_contributor];
180 
181         if (now <= countdownDate +  1 hours) {return lockedAmt;}
182         if (now <= countdownDate +  2 hours) {return lockedAmt.mul(7).div(8);}
183         if (now <= countdownDate +  3 hours) {return lockedAmt.mul(6).div(8);}
184         if (now <= countdownDate +  4 hours) {return lockedAmt.mul(5).div(8);}
185         if (now <= countdownDate +  5 hours) {return lockedAmt.mul(4).div(8);}
186         if (now <= countdownDate +  6 hours) {return lockedAmt.mul(3).div(8);}
187         if (now <= countdownDate +  7 hours) {return lockedAmt.mul(2).div(8);}
188         if (now <= countdownDate +  8 hours) {return lockedAmt.mul(1).div(8);}
189 	
190         return 0;
191     }
192 
193     // get investors' locked amount of token
194     // this lockup will be released in 3 batches: 
195     // 1. on delievery date
196     // 2. three months after the delivery date
197     // 3. six months after the delivery date
198     function getLockedAmount_investors(address _investor)
199         public
200 		constant
201 		returns (uint256)
202 	{
203         uint256 delieveryDate = investors_deliveryDate[_investor];
204         uint256 lockedAmt = investors_locked[_investor];
205 
206         if (now <= delieveryDate) {return lockedAmt;}
207         if (now <= delieveryDate + 1 hours) {return lockedAmt.mul(2).div(3);}
208         if (now <= delieveryDate + 2 hours) {return lockedAmt.mul(1).div(3);}
209 	
210         return 0;
211     }
212 
213     // set lockup for contributors 
214     function setLockup_contributors(address _contributor, uint256 _value, uint256 _countdownDate)
215         public
216         onlyOwner
217     {
218         require(_contributor != address(0));
219 
220         contributors_locked[_contributor] = _value;
221         contributors_countdownDate[_contributor] = _countdownDate;
222         UpdatedLockingState("contributor", _contributor, _value, _countdownDate);
223     }
224 
225     // set lockup for strategic investor
226     function setLockup_investors(address _investor, uint256 _value, uint256 _delieveryDate)
227         public
228         onlyOwner
229     {
230         require(_investor != address(0));
231 
232         investors_locked[_investor] = _value;
233         investors_deliveryDate[_investor] = _delieveryDate;
234         UpdatedLockingState("investor", _investor, _value, _delieveryDate);
235     }
236 
237 	// Transfer amount of tokens from sender account to recipient.
238     function transfer(address _to, uint _value)
239         public
240         canTransfer(msg.sender, _value)
241 		returns (bool success)
242 	{
243         return super.transfer(_to, _value);
244     }
245 
246 	// Transfer amount of tokens from a specified address to a recipient.
247     function transferFrom(address _from, address _to, uint _value)
248         public
249         canTransfer(_from, _value)
250 		returns (bool success)
251 	{
252         return super.transferFrom(_from, _to, _value);
253     }
254 }