1 pragma solidity 0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 contract ERC20 {
37   function totalSupply()public view returns (uint total_Supply);
38   function balanceOf(address who)public view returns (uint256);
39   function allowance(address owner, address spender)public view returns (uint);
40   function transferFrom(address from, address to, uint value)public returns (bool ok);
41   function approve(address spender, uint value)public returns (bool ok);
42   function transfer(address to, uint value)public returns (bool ok);
43   event Transfer(address indexed from, address indexed to, uint value);
44   event Approval(address indexed owner, address indexed spender, uint value);
45 }
46 
47 
48 contract WGP is ERC20
49 { using SafeMath for uint256;
50     // Name of the token
51     string public constant name = "W Green Pay";
52 
53     // Symbol of token
54     string public constant symbol = "WGP";
55     uint8 public constant decimals = 18;
56     uint public _totalsupply; 
57     uint public maxCap_MInt = 60000000 * 10 ** 18; // 60 Million Coins
58     address public ethFundMain = 0x67fd4721d490A5E609cF8e09FCE0a217b91F1546; // address to receive ether from smart contract
59     uint256 public mintedtokens;
60     address public owner;
61     uint256 public _price_tokn;
62     uint256 no_of_tokens;
63     bool stopped = false;
64     uint256 public ico_startdate;
65     uint256 public ico_enddate;
66     uint256 public ETHcollected;
67     bool public lockstatus; 
68     bool public mintingFinished = false;
69     
70     mapping(address => uint) balances;
71     mapping(address => mapping(address => uint)) allowed;
72     event Mint(address indexed from, address indexed to, uint256 amount);
73 
74     
75      enum Stages {
76         NOTSTARTED,
77         ICO,
78         PAUSED,
79         ENDED
80     }
81     Stages public stage;
82     
83      modifier atStage(Stages _stage) {
84         require (stage == _stage);
85          _;
86     }
87     
88      modifier onlyOwner() {
89         require (msg.sender == owner);
90         _;
91     }
92     
93     constructor() public
94     {
95         owner = msg.sender;
96         balances[owner] = 40000000 * 10 **18;  //40 million for the COmpany given to Owner
97         _totalsupply = balances[owner];
98         lockstatus = true;
99         stage = Stages.NOTSTARTED;
100         emit Transfer(0, owner, balances[owner]);
101     }
102   
103     function Manual_Mint(address receiver, uint256 tokenQuantity) external onlyOwner {
104       
105             require(!mintingFinished);
106              require(mintedtokens + tokenQuantity <= maxCap_MInt && tokenQuantity > 0);
107               mintedtokens = mintedtokens.add(tokenQuantity);
108              _totalsupply = _totalsupply.add(tokenQuantity);
109              balances[receiver] = balances[receiver].add(tokenQuantity);
110              emit Mint(owner, receiver, tokenQuantity);
111              emit Transfer(0, receiver, tokenQuantity);
112     }
113 
114     function mintContract(address receiver, uint256 tokenQuantity) private {
115             
116              require(mintedtokens + tokenQuantity <= maxCap_MInt && tokenQuantity > 0);
117               mintedtokens = mintedtokens.add(tokenQuantity);
118              _totalsupply = _totalsupply.add(tokenQuantity);
119              balances[receiver] = balances[receiver].add(tokenQuantity);
120               emit Mint(address(this), receiver, tokenQuantity);
121              emit Transfer(0, receiver, tokenQuantity);
122     }
123     
124     function () public payable atStage(Stages.ICO)
125     {
126         require(!stopped && msg.sender != owner);
127         require (now <= ico_enddate);
128         _price_tokn = calcprice();
129         no_of_tokens =((msg.value).mul(_price_tokn)).div(1000);
130         ETHcollected = ETHcollected.add(msg.value);
131         mintContract(msg.sender, no_of_tokens);
132        
133     }
134     
135     
136     function calcprice() view private returns (uint){
137          uint price_tokn;
138          
139         if(ETHcollected <= 246153 ether){
140             price_tokn = 40625;   // 1 ETH = 40.625 tokens
141         }
142         else  if(ETHcollected > 246153 ether){
143             price_tokn = 30111;   // 1 ETH = 30.111 tokens
144         }
145       
146         return price_tokn;
147     }
148     
149     
150     
151      function start_ICO() public onlyOwner atStage(Stages.NOTSTARTED)
152       {
153          
154           stage = Stages.ICO;
155           stopped = false;
156           ico_startdate = now;
157           ico_enddate = now + 35 days;
158          
159       }
160     
161     
162       //called by Owner to increase end date of ICO 
163     function CrowdSale_ModifyEndDate(uint256 addICODays) external onlyOwner atStage(Stages.ICO)
164     {
165         
166         ico_enddate = ico_enddate.add(addICODays.mul(86400));
167 
168     }
169     
170     // called by the owner, pause ICO
171     function CrowdSale_Halt() external onlyOwner atStage(Stages.ICO) {
172         stopped = true;
173         stage = Stages.PAUSED;
174     }
175 
176     // called by the owner , resumes ICO
177     function CrowdSale_Resume() external onlyOwner atStage(Stages.PAUSED)
178     {
179         stopped = false;
180         stage = Stages.ICO;
181     }
182     
183      function CrowdSale_Finalize() external onlyOwner atStage(Stages.ICO)
184      {
185          require(now > ico_enddate);
186          stage = Stages.ENDED;
187          lockstatus = false;
188          mintingFinished = true;
189      }
190      
191    function CrowdSale_Change_ReceiveWallet(address New_Wallet_Address) external onlyOwner
192     {
193         require(New_Wallet_Address != 0x0);
194         ethFundMain = New_Wallet_Address;
195     }
196 
197     // what is the total supply of the ech tokens
198      function totalSupply() public view returns (uint256 total_Supply) {
199          total_Supply = _totalsupply;
200      }
201     
202     // What is the balance of a particular account?
203      function balanceOf(address _owner)public view returns (uint256 balance) {
204          return balances[_owner];
205      }
206     
207     // Send _value amount of tokens from address _from to address _to
208      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
209      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
210      // fees in sub-currencies; the command should fail unless the _from account has
211      // deliberately authorized the sender of the message via some mechanism; we propose
212      // these standardized APIs for approval:
213      function transferFrom( address _from, address _to, uint256 _amount )public returns (bool success) {
214      require( _to != 0x0);
215      require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);
216      balances[_from] = (balances[_from]).sub(_amount);
217      allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
218      balances[_to] = (balances[_to]).add(_amount);
219     emit Transfer(_from, _to, _amount);
220      return true;
221          }
222     
223    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
224      // If this function is called again it overwrites the current allowance with _value.
225      function approve(address _spender, uint256 _amount)public returns (bool success) {
226          require(!lockstatus);
227          require( _spender != 0x0);
228          allowed[msg.sender][_spender] = _amount;
229         emit Approval(msg.sender, _spender, _amount);
230          return true;
231      }
232   
233      function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
234          require( _owner != 0x0 && _spender !=0x0);
235          return allowed[_owner][_spender];
236    }
237 
238      // Transfer the balance from owner's account to another account
239      function transfer(address _to, uint256 _amount)public returns (bool success) {
240          require(!lockstatus);
241         require( _to != 0x0);
242         require(balances[msg.sender] >= _amount && _amount >= 0);
243         balances[msg.sender] = (balances[msg.sender]).sub(_amount);
244         balances[_to] = (balances[_to]).add(_amount);
245         emit Transfer(msg.sender, _to, _amount);
246         return true;
247          }
248     
249    
250   
251     //In case the ownership needs to be transferred
252 	function CrowdSale_AssignOwnership(address newOwner)public onlyOwner
253 	{
254 	    require( newOwner != 0x0);
255 	    balances[newOwner] = (balances[newOwner]).add(balances[owner]);
256 	    balances[owner] = 0;
257 	    owner = newOwner;
258 	    emit Transfer(msg.sender, newOwner, balances[newOwner]);
259 	}
260 
261     
262     function forwardFunds() external onlyOwner {
263        
264           address myAddress = this;
265         ethFundMain.transfer(myAddress.balance);
266     }
267     
268    function  forwardSomeFunds(uint256 ETHQuantity) external onlyOwner {
269        uint256 fund = ETHQuantity * 10 ** 18;
270        ethFundMain.transfer(fund);
271     }
272     
273 }