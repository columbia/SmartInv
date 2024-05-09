1 /**
2  *Submitted for verification at Etherscan.io on 2020-11-05
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.7.4;
8 
9 library SafeMath {
10 
11     function add(uint256 a, uint256 b) internal pure returns (uint256) {
12         uint256 c = a + b;
13         require(c >= a, "SafeMath: addition overflow");
14 
15         return c;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         return sub(a, b, "SafeMath: subtraction overflow");
20     }
21 
22     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
23         require(b <= a, errorMessage);
24         uint256 c = a - b;
25 
26         return c;
27     }
28 
29 }
30 
31 interface ItokenRecipient { 
32     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external returns (bool); 
33 }
34 
35 interface IstakeContract { 
36     function createStake(address _wallet, uint8 _timeFrame, uint256 _value) external returns (bool); 
37 }
38 
39 interface IERC20Token {
40     function totalSupply() external view returns (uint256 supply);
41     function transfer(address _to, uint256 _value) external  returns (bool success);
42     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
43     function balanceOf(address _owner) external view returns (uint256 balance);
44     function approve(address _spender, uint256 _value) external returns (bool success);
45     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
46 }
47 
48 contract Ownable {
49 
50     address private owner;
51     address private priceManager;
52     
53     event OwnerSet(address indexed oldOwner, address indexed newOwner);
54     
55     modifier onlyOwner() {
56         require(msg.sender == owner, "Caller is not owner");
57         _;
58     }
59     
60     modifier onlyPriceManager() {
61         require(msg.sender == priceManager, "Caller is not priceManager");
62         _;
63     }
64     
65     
66 
67     constructor() {
68         owner = msg.sender; 
69         emit OwnerSet(address(0), owner);
70     }
71 
72 
73     function changeOwner(address newOwner) public onlyOwner {
74         emit OwnerSet(owner, newOwner);
75         owner = newOwner;
76     }
77     
78     function setPriceManager (address newPriceManager) public onlyOwner {
79         priceManager = newPriceManager;
80     }
81 
82     function getOwner() external view returns (address) {
83         return owner;
84     }
85 }
86 
87 contract StandardToken is IERC20Token {
88     
89     using SafeMath for uint256;
90     mapping (address => uint256) balances;
91     mapping (address => mapping (address => uint256)) allowed;
92     uint256 public _totalSupply;
93     
94     event Transfer(address indexed _from, address indexed _to, uint256 _value);
95     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
96     
97     function totalSupply() override public view returns (uint256 supply) {
98         return _totalSupply;
99     }
100 
101     function transfer(address _to, uint256 _value) override virtual public returns (bool success) {
102         require(_to != address(0x0), "Use burn function instead");                               // Prevent transfer to 0x0 address. Use burn() instead
103 		require(_value >= 0, "Invalid amount"); 
104 		require(balances[msg.sender] >= _value, "Not enough balance");
105 		balances[msg.sender] = balances[msg.sender].sub(_value);
106 		balances[_to] = balances[_to].add(_value);
107 		emit Transfer(msg.sender, _to, _value);
108         return true;
109     }
110 
111     function transferFrom(address _from, address _to, uint256 _value) override virtual public returns (bool success) {
112         require(_to != address(0x0), "Use burn function instead");                               // Prevent transfer to 0x0 address. Use burn() instead
113 		require(_value >= 0, "Invalid amount"); 
114 		require(balances[_from] >= _value, "Not enough balance");
115 		require(allowed[_from][msg.sender] >= _value, "You need to increase allowance");
116 		balances[_from] = balances[_from].sub(_value);
117 		balances[_to] = balances[_to].add(_value);
118 		emit Transfer(_from, _to, _value);
119         return true;
120     }
121 
122     function balanceOf(address _owner) override public view returns (uint256 balance) {
123         return balances[_owner];
124     }
125 
126     function approve(address _spender, uint256 _value) override public returns (bool success) {
127         allowed[msg.sender][_spender] = _value;
128         emit Approval(msg.sender, _spender, _value);
129         return true;
130     }
131 
132     function allowance(address _owner, address _spender) override public view returns (uint256 remaining) {
133         return allowed[_owner][_spender];
134     }
135     
136 }
137 
138 contract UTRINToken is Ownable, StandardToken {
139 
140     using SafeMath for uint256;
141     string public name;
142     uint8 public decimals;
143     string public symbol;
144     uint256 public subscriptionPrice;
145     address public stakeContract;
146     address public crowdSaleContract;
147     address public preSaleContract;
148     address public dividendPool;
149     uint256 public soldTokensUnlockTime;
150     mapping (address => uint256) frozenBalances;
151     mapping (address => uint256) timelock;
152     
153     event Burn(address indexed from, uint256 value);
154     event StakeContractSet(address indexed contractAddress);
155 
156     
157     constructor() {
158         name = "Universal Trade Interface";
159         decimals = 18;
160         symbol = "UTRIN";
161         
162         address teamWallet = 0x41dA08f916Fc534C25FB3B388a0859b9e4A42ADa;
163         address legalAndLiquidity = 0x298843E6C4Cedd1Eae5327A39847F0A170D32D26;
164         address developmentFund = 0x0e70bB808E549147E3073937f13eCdc08E5d5775; 
165         dividendPool = 0xd1c16226FF031Fcd961221aD25c6a43B4FB96d7E;
166         
167         balances[teamWallet] = 1500000 ether;                                           
168         emit Transfer(address(0x0), teamWallet, (1500000 ether));                       
169         
170         balances[legalAndLiquidity] = 1000000 ether;                                           
171         emit Transfer(address(0x0), legalAndLiquidity, (1000000 ether));
172         
173         balances[developmentFund] = 1500000 ether;                                    
174         emit Transfer(address(0x0), developmentFund, (1500000 ether));     
175         
176 
177         _totalSupply = 4000000 ether;
178 
179     }
180     
181     function frozenBalanceOf(address _owner) public view returns (uint256 balance) {
182         return frozenBalances[_owner];
183     }
184 
185     function unlockTimeOf(address _owner) public view returns (uint256 time) {
186         return timelock[_owner];
187     }
188     
189     function transfer(address _to, uint256 _value) override public  returns (bool success) {
190         require(txAllowed(msg.sender, _value), "Tokens are still frozen");
191         return super.transfer(_to, _value);
192     }
193     
194     function transferFrom(address _from, address _to, uint256 _value) override public returns (bool success) { ///??
195         require(txAllowed(msg.sender, _value), "Crowdsale tokens are still frozen");
196         return super.transferFrom(_from, _to, _value);
197     }
198     
199     function setStakeContract(address _contractAddress) onlyOwner public {
200         stakeContract = _contractAddress;
201         emit StakeContractSet(_contractAddress);
202     }
203     
204     function setDividenPool(address _DividenPool) onlyOwner public {
205         dividendPool = _DividenPool;
206     }
207     
208         // Tokens sold by crowdsale contract will be frozen ultil crowdsale ends
209     function txAllowed(address sender, uint256 amount) private returns (bool isAllowed) {
210         if (timelock[sender] > block.timestamp) {
211             return isBalanceFree(sender, amount);
212         } else {
213             if (frozenBalances[sender] > 0) frozenBalances[sender] = 0;
214             return true;
215         }
216         
217     }
218     
219     function isBalanceFree(address sender, uint256 amount) private view returns (bool isfree) {
220         if (amount <= (balances[sender] - frozenBalances[sender])) {
221             return true;
222         } else {
223             return false;
224         }
225     }
226     
227     function burn(uint256 _value) public onlyOwner returns (bool success) {
228         require(balances[msg.sender] >= _value, "Not enough balance");
229 		require(_value >= 0, "Invalid amount"); 
230         balances[msg.sender] = balances[msg.sender].sub(_value);
231         _totalSupply = _totalSupply.sub(_value);
232         emit Burn(msg.sender, _value);
233         return true;
234     }
235 
236     function approveStake(uint8 _timeFrame, uint256 _value) public returns (bool success) {
237         require(stakeContract != address(0x0));
238         allowed[msg.sender][stakeContract] = _value;
239         emit Approval(msg.sender, stakeContract, _value);
240         IstakeContract recipient = IstakeContract(stakeContract);
241         require(recipient.createStake(msg.sender, _timeFrame, _value));
242         return true;
243     }
244     
245     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
246         allowed[msg.sender][_spender] = _value;
247         emit Approval(msg.sender, _spender, _value);
248         ItokenRecipient recipient = ItokenRecipient(_spender);
249         require(recipient.receiveApproval(msg.sender, _value, address(this), _extraData));
250         return true;
251     }
252    
253     function tokensSoldCrowdSale(address buyer, uint256 amount) public returns (bool success) {
254         require(msg.sender == crowdSaleContract, "Error with tokensSoldCrowdSale function.");
255         frozenBalances[buyer] += amount;
256         if (timelock[buyer] == 0 ) timelock[buyer] = soldTokensUnlockTime;
257         return super.transfer(buyer, amount);
258     }
259     
260     function tokensSoldPreSale(address buyer, uint256 amount) public returns (bool success) {
261         require(msg.sender == preSaleContract, "Error with tokensSoldPreSale function.");
262         frozenBalances[buyer] += amount;
263         if (timelock[buyer] == 0 ) timelock[buyer] = soldTokensUnlockTime;
264         return super.transfer(buyer, amount);
265     }
266     
267 	function setPrice(uint256 newPrice) public onlyPriceManager {
268 		subscriptionPrice = newPrice;
269 	}
270 
271 	function redeemTokens(uint256 amount) public{
272 	    require(amount > subscriptionPrice, "Insufficient Utrin tokens sent to cover your fee!");
273 		    address account = msg.sender;        	
274 
275         	balances[account] = balances[account].sub(amount);
276         	emit Transfer(account, dividendPool, amount);
277 	}
278 	
279 	
280 
281 
282     
283 
284 }