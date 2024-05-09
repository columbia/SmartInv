1 /**
2  *Submitted for verification at Etherscan.io on 2020-07-30
3 */
4 
5 pragma solidity 0.6.12;
6 
7 library SafeMath {
8     function add(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a + b;
10         require(c >= a, "SafeMath: addition overflow");
11 
12         return c;
13     }
14 
15     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16         return sub(a, b, "SafeMath: subtraction overflow");
17     }
18 
19     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
20         require(b <= a, errorMessage);
21         uint256 c = a - b;
22 
23         return c;
24     }
25 
26     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27         if (a == 0) {
28             return 0;
29         }
30 
31         uint256 c = a * b;
32         require(c / a == b, "SafeMath: multiplication overflow");
33 
34         return c;
35     }
36 
37     function div(uint256 a, uint256 b) internal pure returns (uint256) {
38         return div(a, b, "SafeMath: division by zero");
39     }
40 
41     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
42         require(b > 0, errorMessage);
43         uint256 c = a / b;
44 
45         return c;
46     }
47 
48     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
49         return mod(a, b, "SafeMath: modulo by zero");
50     }
51 
52     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
53         require(b != 0, errorMessage);
54         return a % b;
55     }
56 }
57 
58 contract Ownable {
59     address public _owner;
60 
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63     constructor () public {
64         _owner = msg.sender;
65         emit OwnershipTransferred(address(0), msg.sender);
66     }
67 
68     function owner() public view returns (address) {
69         return _owner;
70     }
71 
72     modifier onlyOwner() {
73         require(_owner == msg.sender, "Ownable: caller is not the owner");
74         _;
75     }
76 
77     function renounceOwnership() public virtual onlyOwner {
78         emit OwnershipTransferred(_owner, address(0));
79         _owner = address(0);
80     }
81 
82     function transferOwnership(address newOwner) public virtual onlyOwner {
83         require(newOwner != address(0), "Ownable: new owner is the zero address");
84         emit OwnershipTransferred(_owner, newOwner);
85         _owner = newOwner;
86     }
87 }
88 
89 
90 contract BOA is Ownable{
91     using SafeMath for uint256;
92     mapping (address => uint256) public balanceOf;
93     mapping (address => bool) public whitelist;
94 
95     string public name = "Boa";
96     string public symbol = "BOA";
97     uint8 public decimals = 18;
98     uint256 public totalSupply = 100 * (uint256(10) ** decimals);
99     uint256 public totalPooled;
100 
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 
103     constructor() public {
104         totalPooled = 50 * (uint256(10) ** decimals);
105         
106         // Initially assign all non-pooled tokens to the contract's creator.
107         balanceOf[msg.sender] = totalSupply.sub(totalPooled);
108         
109         emit Transfer(address(0), msg.sender, totalSupply.sub(totalPooled));
110     }
111     
112     // Ensure a redemption is profitable before allowing a redeem()
113     modifier profitable() {
114         require(is_profitable(), "Redeeming is not yet profitable.");
115         _;
116     } 
117     
118     // VIEWS 
119     
120     // Get the number of tokens to be redeemed from the pool
121     function numberRedeemed(uint256 amount) 
122         public 
123         view 
124         returns (uint256 profit) {
125         uint256 numerator = amount.mul(totalPooled);  
126         uint256 denominator = totalSupply.sub(totalPooled);  
127         return numerator.div(denominator);
128     }
129     
130     // Check if more than 50% of the token is pooled
131     function is_profitable() 
132         public 
133         view 
134         returns (bool _profitable) {
135         return totalPooled > totalSupply.sub(totalPooled);
136     }
137 
138 
139     // SETTERS
140 
141     function addToWhitelist(address _addr) 
142         public 
143         onlyOwner {
144         whitelist[_addr] = true;
145     }
146     
147     function removeFromWhitelist(address _addr) 
148         public 
149         onlyOwner {
150         whitelist[_addr] = false;
151     }
152     
153     // TRANSFER FUNCTIONS 
154     
155     // BOA-TOKEN <- Sell taxed
156     // TOKEN-BOA <- Buy (not taxed)
157     
158     function transfer(address to, uint256 value) 
159         public 
160         returns (bool success) {
161         require(balanceOf[msg.sender] >= value);
162         
163         if(whitelist[msg.sender]) return regular_transfer(to, value);
164         else return burn_transfer(to, value);
165     }
166     
167     function burn_transfer(address to, uint256 value) 
168         private 
169         returns (bool success) {
170         // send 1% to the pooled ledger
171         uint256 burned_amount = value.div(100);
172         
173         // withdraw from the user's balance
174         balanceOf[msg.sender] = balanceOf[msg.sender].sub(burned_amount);
175         // increment the total pooled amount
176         totalPooled = totalPooled.add(burned_amount);
177         
178         value = value.sub(burned_amount);
179         
180         // perform a normal transfer on the remaining 99%
181         return regular_transfer(to, value);
182     }
183 
184     function regular_transfer(address to, uint256 value) 
185         private 
186         returns (bool success) {
187         // perform a normal transfer 
188         balanceOf[msg.sender] = balanceOf[msg.sender].sub(value);  
189         balanceOf[to] = balanceOf[to].add(value);                   
190         emit Transfer(msg.sender, to, value);
191         return true;
192     }
193     
194     function transferFrom(address from, address to, uint256 value)
195         public
196         returns (bool success)
197     {
198         require(value <= balanceOf[from]);
199         require(value <= allowance[from][msg.sender]);
200 
201         // allow feeless for the RED-BLUE uniswap pool
202         if(whitelist[msg.sender]) return regular_transferFrom(from, to, value);
203         else return burn_transferFrom(from, to, value); 
204 
205     }
206     
207     function burn_transferFrom(address from, address to, uint256 value) 
208         private 
209         returns (bool success) {
210         // send 1% to the pooled ledger
211         uint256 burned_amount = value.div(100);
212         
213         // remove from the spender's balance
214         balanceOf[from] = balanceOf[from].sub(burned_amount);
215         // increment the total pooled amount
216         totalPooled = totalPooled.add(burned_amount);
217         
218         // burn allowance (for approved spenders)
219         allowance[from][msg.sender] = allowance[from][msg.sender].sub(burned_amount);
220         
221         value = value.sub(burned_amount);
222         
223         // perform a normal transfer on the 99%
224         return regular_transferFrom(from, to, value);
225     }
226     
227     function regular_transferFrom(address from, address to, uint256 value) 
228         private
229         returns (bool success) {
230         // transfer without adding to a pool
231         balanceOf[from] = balanceOf[from].sub(value);
232         balanceOf[to] = balanceOf[to].add(value);
233         
234         // remove allowance (for approved spenders)
235         allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
236         emit Transfer(from, to, value);
237         return true;
238     }
239     
240     // REDEEM AND BURN FUNCTIONS
241     
242     // amount = number of tokens to burn
243     function redeem(uint256 amount) 
244         public 
245         profitable 
246         returns (bool success) {
247         // the amount must be less than the total amount pooled
248         require(amount <= balanceOf[msg.sender]);
249         require(totalPooled >= amount); 
250     	uint256 num_redeemed = numberRedeemed(amount);
251         
252         // make sure the number available to be redeemed is smaller than the available pool
253 	    require(num_redeemed < totalPooled);
254         balanceOf[msg.sender] = balanceOf[msg.sender].add(num_redeemed);
255         
256         emit Transfer(_owner, msg.sender, num_redeemed);
257         totalPooled = totalPooled.sub(num_redeemed);
258         
259         // burn the amount sent
260         return burn(amount);
261     }
262     
263     function burn(uint256 value) 
264         private 
265         returns (bool success) {
266         // burn from the user's ledger, transfer to 0x0
267         balanceOf[msg.sender] = balanceOf[msg.sender].sub(value);  
268         balanceOf[address(0)] = balanceOf[address(0)].add(value);
269         emit Transfer(msg.sender, address(0), value);
270         
271         // remove the burned amount from the total supply
272         totalSupply = totalSupply.sub(value);
273         return true;
274     }
275     
276     // APPROVAL FUNCTIONS
277     
278     event Approval(address indexed owner, address indexed spender, uint256 value);
279 
280     mapping(address => mapping(address => uint256)) public allowance;
281 
282     function approve(address spender, uint256 value)
283         public
284         returns (bool success)
285     {
286         allowance[msg.sender][spender] = value;
287         emit Approval(msg.sender, spender, value);
288         return true;
289     }
290 
291 }