1 pragma solidity ^0.4.23;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 library SafeMath {
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     if (a == 0) {
8       return 0;
9     }
10     uint256 c = a * b;
11     assert(c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 contract ERC20 {
35   function totalSupply()public view returns (uint256 total_Supply);
36   function balanceOf(address _owner)public view returns (uint256 balance);
37   function allowance(address _owner, address _spender)public view returns (uint256 remaining);
38   function transferFrom(address _from, address _to, uint256 _amount)public returns (bool ok);
39   function approve(address _spender, uint256 _amount)public returns (bool ok);
40   function transfer(address _to, uint256 _amount)public returns (bool ok);
41   event Transfer(address indexed _from, address indexed _to, uint256 _amount);
42   event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
43 }
44 
45 contract ROC2 is ERC20
46 {
47     using SafeMath for uint256;
48     string public constant symbol = "ROC2";
49     string public constant name = "Rasputin Party Mansion";
50     uint8 public constant decimals = 10;
51     uint256 public _totalSupply = 27000000 * 10 ** 10;     // 27 milion supply           
52     // Balances for each account
53     mapping(address => uint256) balances;  
54     mapping (address => mapping (address => uint)) allowed;
55     // Owner of this contract
56     address public owner;
57     
58     uint public perTokenPrice = 0;
59     uint256 public owner_balance = 12000000 * 10 **10;
60     uint256 public one_ether_usd_price = 0;
61     uint256 public bonus_percentage = 0;
62 
63     event Transfer(address indexed _from, address indexed _to, uint _value);
64     event Approval(address indexed _owner, address indexed _spender, uint _value);
65     
66     bool public ICO_state = false;
67     
68     modifier onlyOwner() {
69       if (msg.sender != owner) {
70             revert();
71         }
72         _;
73         }
74     
75     constructor () public
76     {
77         owner = msg.sender;
78         balances[owner] = owner_balance; // 12 million with owner
79         balances[this] = 15000000 * 10**10; // 15 million with contract address
80         perTokenPrice = 275;
81         bonus_percentage= 30;
82         
83         emit Transfer(0x00, owner, owner_balance);
84         emit Transfer(0x00, this, balances[this]);
85     }
86     
87     function () public payable 
88     {
89         require(ICO_state && msg.value > 0);
90         distributeToken(msg.value,msg.sender);
91     }
92     
93      function distributeToken(uint val, address user_address ) private {
94          
95         require(one_ether_usd_price > 0);
96         uint256 tokens = ((one_ether_usd_price * val) )  / (perTokenPrice * 10**14); 
97         require(balances[address(this)] >= tokens);
98          
99         if(bonus_percentage >0)
100         {
101             tokens = tokens.add(bonus_percentage.mul(tokens)/100); 
102         }
103         
104             balances[address(this)] = balances[address(this)].sub(tokens);
105             balances[user_address] = balances[user_address].add(tokens);
106             emit Transfer(address(this), user_address, tokens);
107     }
108     
109     
110      // total supply of the tokens
111     function totalSupply() public view returns (uint256 total_Supply) {
112          total_Supply = _totalSupply;
113      }
114   
115      //  balance of a particular account
116      function balanceOf(address _owner)public view returns (uint256 balance) {
117          return balances[_owner];
118      }
119   
120      // Transfer the balance from owner's account to another account
121      function transfer(address _to, uint256 _amount)public returns (bool success) {
122          require( _to != 0x0);
123          require(balances[msg.sender] >= _amount 
124              && _amount >= 0
125              && balances[_to] + _amount >= balances[_to]);
126              balances[msg.sender] = balances[msg.sender].sub(_amount);
127              balances[_to] = balances[_to].add(_amount);
128              emit Transfer(msg.sender, _to, _amount);
129              return true;
130      }
131   
132      // Send _value amount of tokens from address _from to address _to
133      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
134      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
135      // fees in sub-currencies; the command should fail unless the _from account has
136      // deliberately authorized the sender of the message via some mechanism; we propose
137      // these standardized APIs for approval:
138      function transferFrom(
139          address _from,
140          address _to,
141          uint256 _amount
142      )public returns (bool success) {
143         require(_to != 0x0); 
144          require(balances[_from] >= _amount
145              && allowed[_from][msg.sender] >= _amount
146              && _amount >= 0
147              && balances[_to] + _amount >= balances[_to]);
148              balances[_from] = balances[_from].sub(_amount);
149              allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
150              balances[_to] = balances[_to].add(_amount);
151              emit Transfer(_from, _to, _amount);
152              return true;
153              }
154  
155      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
156      // If this function is called again it overwrites the current allowance with _value.
157      function approve(address _spender, uint256 _amount)public returns (bool success) {
158          allowed[msg.sender][_spender] = _amount;
159          emit Approval(msg.sender, _spender, _amount);
160          return true;
161      }
162   
163      function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
164          return allowed[_owner][_spender];
165    }
166    
167    	//In case the ownership needs to be transferred
168 	function transferOwnership(address newOwner)public onlyOwner
169 	{
170 	    require( newOwner != 0x0);
171 	    balances[newOwner] = balances[newOwner].add(balances[owner]);
172 	    balances[owner] = 0;
173 	    address oldOwner = owner;
174 	    owner = newOwner;
175 	    
176 	    emit Transfer(oldOwner, owner, balances[newOwner]);
177 	}
178 	
179 	 //Burning tokens should be called after ICo ends
180     function burntokens(uint256 burn_amount) external onlyOwner {
181         require(burn_amount >0 && burn_amount <= balances[address(this)]);
182          _totalSupply = (_totalSupply).sub(burn_amount);
183          balances[address(this)] = (balances[address(this)].sub(burn_amount));
184           emit Transfer(address(this), 0x00, burn_amount);
185      }
186 	
187 	// drain ether called by only owner
188 	function drain() public onlyOwner {
189         owner.transfer(address(this).balance);
190     }
191     
192     function setbonusprcentage(uint256 percent) public onlyOwner{ // percent to be 30,20,10
193         
194         bonus_percentage = percent;
195     }
196     
197     //price should be in cents
198     function setTokenPrice(uint _price) public onlyOwner{
199         
200         perTokenPrice = _price;
201     }
202     
203     // need to be called before the ICO to set ether price in USD upto 8 decimals. 
204     function setEtherPrice(uint etherPrice) public onlyOwner
205     {
206         one_ether_usd_price = etherPrice;
207     }
208     
209     function startICO() public onlyOwner{
210         
211         ICO_state = true;
212     }
213     
214     function StopICO() public onlyOwner{
215         ICO_state = false;
216     }
217     
218     // used to send tokens to other contract and notify
219     
220         function approveAndCall(address _spender, uint256 _value, bytes _extraData)
221         public
222         returns (bool success) {
223         tokenRecipient spender = tokenRecipient(_spender);
224         if (approve(_spender, _value)) {
225             spender.receiveApproval(msg.sender, _value, this, _extraData);
226             return true;
227         }
228     }
229 }