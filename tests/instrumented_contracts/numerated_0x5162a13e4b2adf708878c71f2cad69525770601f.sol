1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------------------------
4 // Acute Angle Coin by Triangle Technology Co., Ltd. Limited.
5 // An ERC20 standard
6 //
7 // author: AAC Team
8 
9 contract ERC20Interface {
10     function totalSupply() public constant returns (uint256 _totalSupply);
11     function balanceOf(address _owner) public constant returns (uint256 balance);
12     function transfer(address _to, uint256 _value) public returns (bool success);
13     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
14     function approve(address _spender, uint256 _value) public returns (bool success);
15     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
16     event Transfer(address indexed _from, address indexed _to, uint256 _value);
17     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
18 }
19  
20 contract AcuteAngleCoin is ERC20Interface {
21     uint256 public constant decimals = 5;
22 
23     string public constant symbol = "AAC";
24     string public constant name = "AcuteAngleCoin";
25 
26     bool public _selling = true;//initial selling
27     uint256 public _totalSupply = 10 ** 14; // total supply is 10^14 unit, equivalent to 10^9 AAC
28     uint256 public _originalBuyPrice = 39 * 10**7; // original buy 1ETH = 3900 AAC = 39 * 10**7 unit
29 
30     // Owner of this contract
31     address public owner;
32  
33     // Balances AAC for each AACount
34     mapping(address => uint256) private balances;
35     
36     // Owner of AACount approves the transfer of an amount to another AACount
37     mapping(address => mapping (address => uint256)) private allowed;
38 
39     // List of approved investors
40     mapping(address => bool) private approvedInvestorList;
41     
42     // deposit
43     mapping(address => uint256) private deposit;
44        
45 
46     // totalTokenSold
47     uint256 public totalTokenSold = 0;
48     
49     // tradable
50     bool public tradable = false;
51     
52     /**
53      * Functions with this modifier can only be executed by the owner
54      */
55     modifier onlyOwner() {
56         require(msg.sender == owner);
57         _;
58     }
59 
60     /**
61      * Functions with this modifier check on sale status
62      * Only allow sale if _selling is on
63      */
64     modifier onSale() {
65         require(_selling);
66         _;
67     }
68     
69     /**
70      * Functions with this modifier check the validity of address is investor
71      */
72     modifier validInvestor() {
73         require(approvedInvestorList[msg.sender]);
74         _;
75     }
76     
77 
78     
79     /**
80      * 
81      */
82     modifier isTradable(){
83         require(tradable == true || msg.sender == owner);
84         _;
85     }
86 
87     /// @dev Fallback function allows to buy ether.
88     function()
89         public
90         payable {
91         buyAAC();
92     }
93     
94     /// @dev buy function allows to buy ether. for using optional data
95     function buyAAC()
96         public
97         payable
98         onSale
99         validInvestor {
100         uint256 requestedUnits = (msg.value * _originalBuyPrice) / 10**18;
101         require(balances[owner] >= requestedUnits);
102         // prepare transfer data
103         balances[owner] -= requestedUnits;
104         balances[msg.sender] += requestedUnits;
105         
106         // increase total deposit amount
107         deposit[msg.sender] += msg.value;
108         
109         // check total and auto turnOffSale
110         totalTokenSold += requestedUnits;
111         
112         // submit transfer
113         Transfer(owner, msg.sender, requestedUnits);
114         owner.transfer(msg.value);
115     }
116 
117     /// @dev Constructor
118     function AAC() 
119         public {
120         owner = msg.sender;
121         balances[owner] = _totalSupply;
122         Transfer(0x0, owner, _totalSupply);
123     }
124     
125     /// @dev Gets totalSupply
126     /// @return Total supply
127     function totalSupply()
128         public 
129         constant 
130         returns (uint256) {
131         return _totalSupply;
132     }
133     
134     /// @dev Enables sale 
135     function turnOnSale() onlyOwner 
136         public {
137         _selling = true;
138     }
139 
140     /// @dev Disables sale
141     function turnOffSale() onlyOwner 
142         public {
143         _selling = false;
144     }
145     
146     function turnOnTradable() 
147         public
148         onlyOwner{
149         tradable = true;
150     }
151         
152     /// @dev Gets AACount's balance
153     /// @param _addr Address of the AACount
154     /// @return AACount balance
155     function balanceOf(address _addr) 
156         public
157         constant 
158         returns (uint256) {
159         return balances[_addr];
160     }
161     
162     /// @dev check address is approved investor
163     /// @param _addr address
164     function isApprovedInvestor(address _addr)
165         public
166         constant
167         returns (bool) {
168         return approvedInvestorList[_addr];
169     }
170     
171     /// @dev get ETH deposit
172     /// @param _addr address get deposit
173     /// @return amount deposit of an buyer
174     function getDeposit(address _addr)
175         public
176         constant
177         returns(uint256){
178         return deposit[_addr];
179 }
180     
181     /// @dev Adds list of new investors to the investors list and approve all
182     /// @param newInvestorList Array of new investors addresses to be added
183     function addInvestorList(address[] newInvestorList)
184         onlyOwner
185         public {
186         for (uint256 i = 0; i < newInvestorList.length; i++){
187             approvedInvestorList[newInvestorList[i]] = true;
188         }
189     }
190 
191     /// @dev Removes list of investors from list
192     /// @param investorList Array of addresses of investors to be removed
193     function removeInvestorList(address[] investorList)
194         onlyOwner
195         public {
196         for (uint256 i = 0; i < investorList.length; i++){
197             approvedInvestorList[investorList[i]] = false;
198         }
199     }
200  
201     /// @dev Transfers the balance from msg.sender to an AACount
202     /// @param _to Recipient address
203     /// @param _amount Transfered amount in unit
204     /// @return Transfer status
205     function transfer(address _to, uint256 _amount)
206         public 
207         isTradable
208         returns (bool) {
209         // if sender's balance has enough unit and amount >= 0, 
210         //      and the sum is not overflow,
211         // then do transfer 
212         if ( (balances[msg.sender] >= _amount) &&
213              (_amount >= 0) && 
214              (balances[_to] + _amount > balances[_to]) ) {  
215 
216             balances[msg.sender] -= _amount;
217             balances[_to] += _amount;
218             Transfer(msg.sender, _to, _amount);
219             return true;
220         } else {
221             return false;
222         }
223     }
224      
225     // Send _value amount of tokens from address _from to address _to
226     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
227     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
228     // fees in sub-currencies; the command should fail unless the _from AACount has
229     // deliberately authorized the sender of the message via some mechanism; we propose
230     // these standardized APIs for approval:
231     function transferFrom(
232         address _from,
233         address _to,
234         uint256 _amount
235     )
236     public
237     isTradable
238     returns (bool success) {
239         if (balances[_from] >= _amount
240             && allowed[_from][msg.sender] >= _amount
241             && _amount > 0
242             && balances[_to] + _amount > balances[_to]) {
243             balances[_from] -= _amount;
244             allowed[_from][msg.sender] -= _amount;
245             balances[_to] += _amount;
246             Transfer(_from, _to, _amount);
247             return true;
248         } else {
249             return false;
250         }
251     }
252     
253     // Allow _spender to withdraw from your AACount, multiple times, up to the _value amount.
254     // If this function is called again it overwrites the current allowance with _value.
255     function approve(address _spender, uint256 _amount) 
256         public
257         isTradable
258         returns (bool success) {
259         allowed[msg.sender][_spender] = _amount;
260         Approval(msg.sender, _spender, _amount);
261         return true;
262     }
263     
264     // get allowance
265     function allowance(address _owner, address _spender) 
266         public
267         constant 
268         returns (uint256 remaining) {
269         return allowed[_owner][_spender];
270     }
271     
272     /// @dev Withdraws Ether in contract (Owner only)
273     /// @return Status of withdrawal
274     function withdraw() onlyOwner 
275         public 
276         returns (bool) {
277         return owner.send(this.balance);
278     }
279 }