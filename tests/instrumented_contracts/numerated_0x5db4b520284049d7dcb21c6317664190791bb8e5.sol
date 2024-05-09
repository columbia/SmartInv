1 pragma solidity ^0.4.20;
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
22 
23 contract ERC20Interface {
24     function totalSupply() public constant returns (uint);
25     function balanceOf(address tokenOwner) public constant returns (uint balance);
26     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
27     function transfer(address to, uint tokens) public returns (bool success);
28     function approve(address spender, uint tokens) public returns (bool success);
29     function transferFrom(address from, address to, uint tokens) public returns (bool success);
30 
31     event Transfer(address indexed from, address indexed to, uint tokens);
32     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
33 }
34 
35 
36 contract ApproveAndCallFallBack {
37     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
38 }
39 
40 
41 contract Owned {
42     address public owner;
43     address public newOwner;
44 
45     event OwnershipTransferred(address indexed _from, address indexed _to);
46 
47     function Owned() public {
48         owner = msg.sender;
49     }
50 
51     modifier onlyOwner {
52         require(msg.sender == owner);
53         _;
54     }
55 
56     function transferOwnership(address _newOwner) public onlyOwner {
57         newOwner = _newOwner;
58     }
59     function acceptOwnership() public {
60         require(msg.sender == newOwner);
61         OwnershipTransferred(owner, newOwner);
62         owner = newOwner;
63         newOwner = address(0);
64     }
65 }
66 
67 
68 contract Tangent is ERC20Interface, Owned {
69     using SafeMath for uint;
70 
71     string public symbol;
72     string public  name;
73     uint8 public decimals;
74     uint public _totalSupply;
75 
76     mapping(address => uint) balances;
77     mapping(address => mapping(address => uint)) allowed;
78 
79     function Tangent() public {
80         symbol = "TAN";
81         name = "Tangent";
82         decimals = 18;
83         _totalSupply = 1000000000 * 10**uint(decimals);
84         balances[owner] = _totalSupply;
85         Transfer(address(0), owner, _totalSupply);
86     }
87 
88     function totalSupply() public constant returns (uint) {
89         return _totalSupply  - balances[address(0)];
90     }
91 
92     function balanceOf(address tokenOwner) public constant returns (uint balance) {
93         return balances[tokenOwner];
94     }
95 
96     function transfer(address to, uint tokens) public returns (bool success) {
97         balances[msg.sender] = balances[msg.sender].sub(tokens);
98         balances[to] = balances[to].add(tokens);
99         Transfer(msg.sender, to, tokens);
100         return true;
101     }
102 
103     function approve(address spender, uint tokens) public returns (bool success) {
104         allowed[msg.sender][spender] = tokens;
105         Approval(msg.sender, spender, tokens);
106         return true;
107     }
108 
109     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
110         balances[from] = balances[from].sub(tokens);
111         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
112         balances[to] = balances[to].add(tokens);
113         Transfer(from, to, tokens);
114         return true;
115     }
116 
117     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
118         return allowed[tokenOwner][spender];
119     }
120 
121     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
122         allowed[msg.sender][spender] = tokens;
123         Approval(msg.sender, spender, tokens);
124         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
125         return true;
126     }
127 
128     function () public payable {
129         revert();
130     }
131 
132     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
133         return ERC20Interface(tokenAddress).transfer(owner, tokens);
134     }
135 }
136 
137 contract TangentStake is Owned {
138     // prevents overflows
139     using SafeMath for uint;
140     
141     // represents a purchase object
142     // addr is the buying address
143     // amount is the number of wei in the purchase
144     // sf is the sum of (purchase amount / sum of previous purchase amounts)
145     struct Purchase {
146         address addr;
147         uint amount;
148         uint sf;
149     }
150     
151     // Purchase object array that holds entire purchase history
152     Purchase[] purchases;
153     
154     // tangents are rewarded along with Ether upon cashing out
155     Tangent tokenContract;
156     
157     // the rate of tangents to ether is multiplier / divisor
158     uint multiplier;
159     uint divisor;
160     
161     // accuracy multiplier
162     uint acm;
163     
164     uint netStakes;
165     
166     // logged when a purchase is made
167     event PurchaseEvent(uint index, address addr, uint eth, uint sf);
168     
169     // logged when a person cashes out or the contract is destroyed
170     event CashOutEvent(uint index, address addr, uint eth, uint tangles);
171     
172     event NetStakesChange(uint netStakes);
173     
174     // logged when the rate of tangents to ether is decreased
175     event Revaluation(uint oldMul, uint oldDiv, uint newMul, uint newDiv);
176     
177     // constructor, sets initial rate to 1000 TAN per 1 Ether
178     function TangentStake(address tokenAddress) public {
179         tokenContract = Tangent(tokenAddress);
180         multiplier = 1000;
181         divisor = 1;
182         acm = 10**18;
183         netStakes = 0;
184     }
185     
186     // decreases the rate of Tangents to Ether, the contract cannot be told
187     // to give out more Tangents per Ether, only fewer.
188     function revalue(uint newMul, uint newDiv) public onlyOwner {
189         require( (newMul.div(newDiv)) <= (multiplier.div(divisor)) );
190         Revaluation(multiplier, divisor, newMul, newDiv);
191         multiplier = newMul;
192         divisor = newDiv;
193         return;
194     }
195     
196     // returns the current amount of wei that will be given for the purchase 
197     // at purchases[index]
198     function getEarnings(uint index) public constant returns (uint earnings, uint amount) {
199         Purchase memory cpurchase;
200         Purchase memory lpurchase;
201         
202         cpurchase = purchases[index];
203         amount = cpurchase.amount;
204         
205         if (cpurchase.addr == address(0)) {
206             return (0, amount);
207         }
208         
209         earnings = (index == 0) ? acm : 0;
210         lpurchase = purchases[purchases.length-1];
211         earnings = earnings.add( lpurchase.sf.sub(cpurchase.sf) );
212         earnings = earnings.mul(amount).div(acm);
213         return (earnings, amount);
214     }
215     
216     // Cash out Ether and Tangent at for the purchase at index "index".
217     // All of the Ether and Tangent associated with with that purchase will
218     // be sent to recipient, and no future withdrawals can be made for the
219     // purchase.
220     function cashOut(uint index) public {
221         require(0 <= index && index < purchases.length);
222         require(purchases[index].addr == msg.sender);
223         
224         uint earnings;
225         uint amount;
226         uint tangles;
227         
228         (earnings, amount) = getEarnings(index);
229         purchases[index].addr = address(0);
230         require(earnings != 0 && amount != 0);
231         netStakes = netStakes.sub(amount);
232         
233         tangles = earnings.mul(multiplier).div(divisor);
234         CashOutEvent(index, msg.sender, earnings, tangles);
235         NetStakesChange(netStakes);
236         
237         tokenContract.transfer(msg.sender, tangles);
238         msg.sender.transfer(earnings);
239         return;
240     }
241     
242     
243     // The fallback function used to purchase stakes
244     // sf is the sum of the proportions of:
245     // (ether of current purchase / sum of ether prior to purchase)
246     // It is used to calculate earnings upon withdrawal.
247     function () public payable {
248         require(msg.value != 0);
249         
250         uint index = purchases.length;
251         uint sf;
252         uint f;
253         
254         if (index == 0) {
255             sf = 0;
256         } else {
257             f = msg.value.mul(acm).div(netStakes);
258             sf = purchases[index-1].sf.add(f);
259         }
260         
261         netStakes = netStakes.add(msg.value);
262         purchases.push(Purchase(msg.sender, msg.value, sf));
263         
264         NetStakesChange(netStakes);
265         PurchaseEvent(index, msg.sender, msg.value, sf);
266         return;
267     }
268 }