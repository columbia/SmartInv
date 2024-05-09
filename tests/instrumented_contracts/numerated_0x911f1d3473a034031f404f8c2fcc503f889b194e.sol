1 pragma solidity ^0.4.20;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function div(uint256 a, uint256 b) internal pure returns (uint256) {
12         uint256 c = a / b;
13         return c;
14     }
15 
16     function add(uint256 a, uint256 b) internal pure returns (uint256) {
17         uint256 c = a + b;
18         assert(c >= a);
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 }
27 
28 contract FiatContract {
29     function USD(uint _id) constant public returns (uint256);
30 }
31 
32 contract Owned {
33     address public owner;
34 
35     event OwnershipTransferred(address indexed _from, address indexed _to);
36 
37     constructor() public {
38         owner = 0x338bDCaF7D9b2603f646E6B919F14BBe9e9c046e;
39     }
40 
41     modifier onlyOwner {
42         require(msg.sender == owner);
43         _;
44     }
45 
46     function transferOwnership(address _newOwner) public onlyOwner {
47         require(_newOwner != address(0x0));
48         emit OwnershipTransferred(owner,_newOwner);
49         owner = _newOwner;
50     }
51     
52 }
53 
54 
55 contract ERC20Interface {
56     function totalSupply() public view returns (uint);
57     function balanceOf(address tokenOwner) public view returns (uint balance);
58     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
59     function transfer(address to, uint tokens) public returns (bool success);
60     function approve(address spender, uint tokens) public returns (bool success);
61     function transferFrom(address from, address to, uint tokens) public returns (bool success);
62 
63     event Transfer(address indexed from, address indexed to, uint tokens);
64     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
65 }
66 
67 
68 contract FlixToken is ERC20Interface, Owned {
69     
70     using SafeMath for uint;
71    
72     FiatContract price = FiatContract(0x8055d0504666e2B6942BeB8D6014c964658Ca591); // MAINNET ADDRESS
73     //FiatContract price = FiatContract(0x2CDe56E5c8235D6360CCbb0c57Ce248Ca9C80909); // TESTNET ADDRESS (ROPSTEN)
74 
75     string public symbol;
76     string public  name;
77     uint8 public decimals;
78     uint public _totalSupply;
79   
80     mapping(address => uint) balances;
81     mapping(address => mapping(address => uint)) allowed;
82     
83     event Burn(address indexed burner, uint256 value);
84     
85     // ------------------------------------------------------------------------
86     // Constructor
87     // ------------------------------------------------------------------------
88     constructor() public {
89         symbol = "FLX";
90         name = "FLIX";
91         decimals = 18;
92         _totalSupply = 100000000;
93         _totalSupply = _totalSupply.mul(10 ** uint(decimals));
94         balances[owner] = _totalSupply;
95         emit Transfer(address(0), owner, _totalSupply);
96     }
97     
98     
99     // ------------------------------------------------------------------------
100     // Total supply
101     // ------------------------------------------------------------------------
102     function totalSupply() public view returns (uint) {
103         return _totalSupply;
104     }
105 
106     function() public payable{
107         uint256 OneCentETH = price.USD(0);
108         //uint256 OneCentETH = 47781560080000;
109         uint256 tokenPrice = OneCentETH.mul(50); // 0.50 $
110         uint256 tokenBought = msg.value.mul(10 ** 18).div(tokenPrice);
111         
112         require(tokenBought <= balances[owner]);
113         
114         // Allocate tokens to user
115         balances[msg.sender] = balances[msg.sender].add(tokenBought);
116             
117         // Subtract token from owner
118         balances[owner] = balances[owner].sub(tokenBought);
119         emit Transfer(owner, msg.sender, tokenBought);
120         owner.transfer(msg.value); 
121         
122     }
123 
124     // ------------------------------------------------------------------------
125     // Get the token balance for account `tokenOwner`
126     // ------------------------------------------------------------------------
127     function balanceOf(address tokenOwner) public view returns (uint balance) {
128         return balances[tokenOwner];
129     }
130 
131 
132     // ------------------------------------------------------------------------
133     // Transfer the balance from token owner's account to `to` account
134     // - Owner's account must have sufficient balance to transfer
135     // - 0 value transfers are allowed
136     // ------------------------------------------------------------------------
137     function transfer(address to, uint tokens) public returns (bool success) {
138         require(to != address(0));
139         require(tokens > 0);
140         require(balances[msg.sender] >= tokens);
141         
142         balances[msg.sender] = balances[msg.sender].sub(tokens);
143         balances[to] = balances[to].add(tokens);
144         emit Transfer(msg.sender, to, tokens);
145         return true;
146     }
147 
148 
149     // ------------------------------------------------------------------------
150     // Token owner can approve for `spender` to transferFrom(...) `tokens`
151     // from the token owner's account
152     //
153     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
154     // recommends that there are no checks for the approval double-spend attack
155     // as this should be implemented in user interfaces 
156     // ------------------------------------------------------------------------
157     function approve(address spender, uint tokens) public returns (bool success) {
158         require(spender != address(0));
159         require(tokens > 0);
160         
161         allowed[msg.sender][spender] = tokens;
162         emit Approval(msg.sender, spender, tokens);
163         return true;
164     }
165 
166 
167     // ------------------------------------------------------------------------
168     // Transfer `tokens` from the `from` account to the `to` account
169     // 
170     // The calling account must already have sufficient tokens approve(...)-d
171     // for spending from the `from` account and
172     // - From account must have sufficient balance to transfer
173     // - Spender must have sufficient allowance to transfer
174     // ------------------------------------------------------------------------
175     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
176         require(from != address(0));
177         require(to != address(0));
178         require(tokens > 0);
179         require(balances[from] >= tokens);
180         require(allowed[from][msg.sender] >= tokens);
181         
182         balances[from] = balances[from].sub(tokens);
183         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
184         balances[to] = balances[to].add(tokens);
185         emit Transfer(from, to, tokens);
186         return true;
187     }
188 
189 
190     // ------------------------------------------------------------------------
191     // Returns the amount of tokens approved by the owner that can be
192     // transferred to the spender's account
193     // ------------------------------------------------------------------------
194     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
195         return allowed[tokenOwner][spender];
196     }
197     
198     
199     // ------------------------------------------------------------------------
200     // Increase the amount of tokens that an owner allowed to a spender.
201     //
202     // approve should be called when allowed[_spender] == 0. To increment
203     // allowed value is better to use this function to avoid 2 calls (and wait until
204     // the first transaction is mined)
205     // _spender The address which will spend the funds.
206     // _addedValue The amount of tokens to increase the allowance by.
207     // ------------------------------------------------------------------------
208     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
209         require(_spender != address(0));
210         
211         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
212         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
213         return true;
214     }
215     
216     
217     // ------------------------------------------------------------------------
218     // Decrease the amount of tokens that an owner allowed to a spender.
219     //
220     // approve should be called when allowed[_spender] == 0. To decrement
221     // allowed value is better to use this function to avoid 2 calls (and wait until
222     // the first transaction is mined)
223     // _spender The address which will spend the funds.
224     // _subtractedValue The amount of tokens to decrease the allowance by.
225     // ------------------------------------------------------------------------
226     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
227         require(_spender != address(0));
228         
229         uint oldValue = allowed[msg.sender][_spender];
230         if (_subtractedValue > oldValue) {
231             allowed[msg.sender][_spender] = 0;
232         } else {
233             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
234         }
235         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
236         return true;
237     }
238     
239     
240     // ------------------------------------------------------------------------
241     // Burns a specific amount of tokens.
242     // _value The amount of token to be burned.
243     // ------------------------------------------------------------------------
244     function burn(uint256 _value) onlyOwner public {
245       require(_value > 0);
246       require(_value <= balances[owner]);
247       balances[owner] = balances[owner].sub(_value);
248       _totalSupply = _totalSupply.sub(_value);
249       emit Burn(owner, _value);
250       emit Transfer(owner, address(0), _value);
251     }
252     
253 }