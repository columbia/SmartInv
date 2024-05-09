1 pragma solidity 0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37   contract ERC20 {
38   function totalSupply()public view returns (uint total_Supply);
39   function balanceOf(address _owner)public view returns (uint256 balance);
40   function allowance(address _owner, address _spender)public view returns (uint remaining);
41   function transferFrom(address _from, address _to, uint _amount)public returns (bool ok);
42   function approve(address _spender, uint _amount)public returns (bool ok);
43   function transfer(address _to, uint _amount)public returns (bool ok);
44   event Transfer(address indexed _from, address indexed _to, uint _amount);
45   event Approval(address indexed _owner, address indexed _spender, uint _amount);
46 }
47 
48 contract GOLDBITSCOIN is ERC20
49 {
50     using SafeMath for uint256;
51     string public constant symbol = "GBC";
52     string public constant name = "Gold Bits Coin";
53     uint8 public constant decimals = 10;
54     // 100 million total supply // muliplies dues to decimal precision
55     uint256 public _totalSupply = 1000000000 * 10 **10;     // 1 billion supply           
56     // Balances for each account
57     mapping(address => uint256) balances;   
58     // Owner of this contract
59     address public owner;
60     
61     uint public perTokenPrice;
62     address public central_account;
63     bool stopped = true;
64     bool ICO_PRE_ICO_STAGE = false;
65     uint256 public stage = 0;
66     uint256 public one_ether_usd_price = 0;
67     
68     mapping (address => mapping (address => uint)) allowed;
69     
70     // ico startdate
71     uint256 startdate;
72 
73     // for maintaining prices with days
74     uint256 first_ten_days;
75     uint256 second_ten_days;
76     uint256 third_ten_days;
77     
78     uint256 public supply_increased;
79     bool PreICOended = false;
80     
81     event Transfer(address indexed _from, address indexed _to, uint _value);
82     event Approval(address indexed _owner, address indexed _spender, uint _value);
83 
84     event LOG(string e,uint256 value);
85     //ico enddate;
86     uint256 enddate;
87     
88     modifier onlyOwner() {
89       if (msg.sender != owner) {
90             revert();
91         }
92         _;
93         }
94         
95     modifier onlycentralAccount {
96         require(msg.sender == central_account);
97         _;
98     }
99     
100     function GOLDBITSCOIN() public
101     {
102         owner = msg.sender;
103         balances[owner] = 200000000 * 10 **10; // 200 million token with company/owner , multiplied due to decimal precision
104     
105         supply_increased += balances[owner];
106     }
107     
108     function setCentralAccount(address central_address) public onlyOwner
109     {
110         central_account = central_address;
111     }
112     // to be called by owner on 15th jan to start PreICO till 31st january
113     function StatPreICO() external onlyOwner
114     {
115         stage = 1;
116         ICO_PRE_ICO_STAGE = true;
117         balances[address(this)] = 100000000 * 10 **10; // 100 million token with contract , multiplied due to decimal precision
118         startdate = now;
119         enddate = now.add(17 days);
120         supply_increased += balances[address(this)];
121         perTokenPrice = 24; // 24 cents
122    
123     }
124     // to be called by owner on 1st feb to start ICO till 1st march
125     function StartICO() external onlyOwner
126     {
127         require(PreICOended);    
128         balances[address(this)] = 100000000 * 10 **10; // 100 million token with contract , multiplied due to decimal precision
129         stage = 2;
130         ICO_PRE_ICO_STAGE = true;
131         stopped = false;
132         startdate = now;
133         first_ten_days = now.add(10 days);
134         second_ten_days = first_ten_days.add(10 days);
135         third_ten_days = second_ten_days.add(10 days);
136         enddate = now.add(30 days);
137         supply_increased += balances[address(this)];
138         perTokenPrice = 30; // 30 cents
139     }
140     // to be called by owner at end of preICO and ICO
141     function end_ICO_PreICO() external onlyOwner
142     {
143         PreICOended = true;
144         stage = 0;
145         ICO_PRE_ICO_STAGE = false;
146         supply_increased -= balances[address(this)];
147         balances[address(this)] =0;
148     }
149     
150     
151     function getTokenPriceforDapp() public view returns (uint256)
152     {
153         return perTokenPrice;
154     }
155     
156     function getEtherPriceforDapp() public view returns (uint256)
157     {
158         return one_ether_usd_price;
159     }
160     
161     function () public payable 
162     {
163         require(ICO_PRE_ICO_STAGE);
164         require(stage > 0);
165         require(now <= enddate);
166         distributeToken(msg.value,msg.sender);   
167     }
168     
169      
170     function distributeToken(uint val, address user_address ) private {
171         
172         uint tokens = ((one_ether_usd_price * val) )  / (perTokenPrice * 10**14); 
173 
174         require(balances[address(this)] >= tokens);
175         
176         balances[address(this)] = balances[address(this)].sub(tokens);
177         balances[user_address] = balances[user_address].add(tokens);
178         Transfer(address(this), user_address, tokens);
179        
180       
181         
182     }
183     
184     // need to be called before the ICO to set ether price give to 8 decimal places
185     function setconfigurationEtherPrice(uint etherPrice) public onlyOwner
186     {
187         one_ether_usd_price = etherPrice;
188        
189         
190     }
191     // **** need to be called to set  token Price, to be called during ICO to change price every 10 days
192     function setconfigurationTokenPrice(uint TokenPrice) public onlyOwner
193     {
194       
195         perTokenPrice = TokenPrice;
196         
197     }
198     
199         // **** need to be called to set  token Price, to be called during ICO to change price every 10 days
200     function setStage(uint status) public onlyOwner
201     {
202       
203         stage = status;
204         
205     }
206     
207     //used by wallet during token buying procedure 
208     function transferby(address _from,address _to,uint256 _amount) public onlycentralAccount returns(bool success) {
209         if (balances[_from] >= _amount &&
210             _amount > 0 &&
211             balances[_to] + _amount > balances[_to]) {
212                  
213             balances[_from] -= _amount;
214             balances[_to] += _amount;
215             Transfer(_from, _to, _amount);
216             return true;
217         } else {
218             return false;
219         }
220     }
221     
222     // to be called by owner after an year review
223     function mineToken(uint256 supply_to_increase) public onlyOwner
224     {
225         require((supply_increased + supply_to_increase) <= _totalSupply);
226         supply_increased += supply_to_increase;
227         
228         balances[owner] += supply_to_increase;
229         Transfer(0, owner, supply_to_increase);
230     }
231     
232     
233     // total supply of the tokens
234     function totalSupply() public view returns (uint256 total_Supply) {
235          total_Supply = _totalSupply;
236      }
237   
238      //  balance of a particular account
239      function balanceOf(address _owner)public view returns (uint256 balance) {
240          return balances[_owner];
241      }
242   
243      // Transfer the balance from owner's account to another account
244      function transfer(address _to, uint256 _amount)public returns (bool success) {
245          require( _to != 0x0);
246          require(balances[msg.sender] >= _amount 
247              && _amount >= 0
248              && balances[_to] + _amount >= balances[_to]);
249              balances[msg.sender] = balances[msg.sender].sub(_amount);
250              balances[_to] = balances[_to].add(_amount);
251              Transfer(msg.sender, _to, _amount);
252              return true;
253      }
254   
255      // Send _value amount of tokens from address _from to address _to
256      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
257      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
258      // fees in sub-currencies; the command should fail unless the _from account has
259      // deliberately authorized the sender of the message via some mechanism; we propose
260      // these standardized APIs for approval:
261      function transferFrom(
262          address _from,
263          address _to,
264          uint256 _amount
265      )public returns (bool success) {
266         require(_to != 0x0); 
267          require(balances[_from] >= _amount
268              && allowed[_from][msg.sender] >= _amount
269              && _amount >= 0
270              && balances[_to] + _amount >= balances[_to]);
271              balances[_from] = balances[_from].sub(_amount);
272              allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
273              balances[_to] = balances[_to].add(_amount);
274              Transfer(_from, _to, _amount);
275              return true;
276              }
277  
278      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
279      // If this function is called again it overwrites the current allowance with _value.
280      function approve(address _spender, uint256 _amount)public returns (bool success) {
281          allowed[msg.sender][_spender] = _amount;
282          Approval(msg.sender, _spender, _amount);
283          return true;
284      }
285   
286      function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
287          return allowed[_owner][_spender];
288    }
289    
290    	//In case the ownership needs to be transferred
291 	function transferOwnership(address newOwner)public onlyOwner
292 	{
293 	    require( newOwner != 0x0);
294 	    balances[newOwner] = balances[newOwner].add(balances[owner]);
295 	    balances[owner] = 0;
296 	    owner = newOwner;
297 	}
298 	
299 	// drain ether called by only owner
300 	function drain() external onlyOwner {
301         owner.transfer(this.balance);
302     }
303     
304     //Below function will convert string to integer removing decimal
305 	function stringToUint(string s) private returns (uint) 
306 	  {
307         bytes memory b = bytes(s);
308         uint i;
309         uint result1 = 0;
310         for (i = 0; i < b.length; i++) {
311             uint c = uint(b[i]);
312             if(c == 46)
313             {
314                 // Do nothing --this will skip the decimal
315             }
316           else if (c >= 48 && c <= 57) {
317                 result1 = result1 * 10 + (c - 48);
318               // usd_price=result;
319                 
320             }
321         }
322             return result1;
323       }
324     
325 }