1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations that are safe for uint256 against overflow and negative values
6  * @dev https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
7  */
8 
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 
39 
40 /**
41  * @title Moderated
42  * @dev restricts execution of 'onlyModerator' modified functions to the contract moderator
43  * @dev restricts execution of 'ifUnrestricted' modified functions to when unrestricted 
44  *      boolean state is true
45  * @dev allows for the extraction of ether or other ERC20 tokens mistakenly sent to this address
46  */
47 contract Moderated {
48     
49     address public moderator;
50     
51     bool public unrestricted;
52     
53     modifier onlyModerator {
54         require(msg.sender == moderator);
55         _;
56     }
57     
58     modifier ifUnrestricted {
59         require(unrestricted);
60         _;
61     }
62     
63     modifier onlyPayloadSize(uint256 numWords) {
64         assert(msg.data.length >= numWords * 32 + 4);
65         _;
66     }    
67     
68     function Moderated() public {
69         moderator = msg.sender;
70         unrestricted = true;
71     }
72     
73     function reassignModerator(address newModerator) public onlyModerator {
74         moderator = newModerator;
75     }
76     
77     function restrict() public onlyModerator {
78         unrestricted = false;
79     }
80     
81     function unrestrict() public onlyModerator {
82         unrestricted = true;
83     }  
84     
85     /// This method can be used to extract tokens mistakenly sent to this contract.
86     /// @param _token The address of the token contract that you want to recover
87     function extract(address _token) public returns (bool) {
88         require(_token != address(0x0));
89         Token token = Token(_token);
90         uint256 balance = token.balanceOf(this);
91         return token.transfer(moderator, balance);
92     }
93     
94     function isContract(address _addr) internal view returns (bool) {
95         uint256 size;
96         assembly { size := extcodesize(_addr) }
97         return (size > 0);
98     }    
99 } 
100 
101 /**
102  * @title ERC20 interface
103  * @dev see https://github.com/ethereum/EIPs/issues/20
104  */
105 contract Token { 
106 
107     function totalSupply() public view returns (uint256);
108     function balanceOf(address who) public view returns (uint256);
109     function transfer(address to, uint256 value) public returns (bool);
110     function transferFrom(address from, address to, uint256 value) public returns (bool);    
111     function approve(address spender, uint256 value) public returns (bool);
112     function allowance(address owner, address spender) public view returns (uint256);    
113     event Transfer(address indexed from, address indexed to, uint256 value);    
114     event Approval(address indexed owner, address indexed spender, uint256 value);    
115 
116 }
117 
118 
119 
120 
121 
122 
123 /**
124  * @title Controlled
125  * @dev Restricts execution of modified functions to the contract controller alone
126  */
127 contract Controlled {
128     address public controller;
129 
130     function Controlled() public {
131         controller = msg.sender;
132     }
133 
134     modifier onlyController {
135         require(msg.sender == controller);
136         _;
137     }
138 
139     function transferControl(address newController) public onlyController{
140         controller = newController;
141     }
142 }
143 
144 /**
145  * @title RefundVault
146  * @dev This contract is used for storing funds while a crowdsale
147  * is in progress. Supports refunding the money if crowdsale fails,
148  * and forwarding it if crowdsale is successful.
149  */
150 contract RefundVault is Controlled {
151     using SafeMath for uint256;
152     
153     enum State { Active, Refunding, Closed }
154     
155     mapping (address => uint256) public deposited;
156     address public wallet;
157     State public state;
158     
159     event Closed();
160     event RefundsEnabled();
161     event Refunded(address indexed beneficiary, uint256 weiAmount);
162     
163     function RefundVault(address _wallet) public {
164         require(_wallet != address(0));
165         wallet = _wallet;        
166         state = State.Active;
167     }
168 
169 	function () external payable {
170 	    revert();
171 	}
172     
173     function deposit(address investor) onlyController public payable {
174         require(state == State.Active);
175         deposited[investor] = deposited[investor].add(msg.value);
176     }
177     
178     function close() onlyController public {
179         require(state == State.Active);
180         state = State.Closed;
181         Closed();
182         wallet.transfer(this.balance);
183     }
184     
185     function enableRefunds() onlyController public {
186         require(state == State.Active);
187         state = State.Refunding;
188         RefundsEnabled();
189     }
190     
191     function refund(address investor) public {
192         require(state == State.Refunding);
193         uint256 depositedValue = deposited[investor];
194         deposited[investor] = 0;
195         investor.transfer(depositedValue);
196         Refunded(investor, depositedValue);
197     }
198 }
199 
200 contract CrowdSale is Moderated {
201 	using SafeMath for uint256;
202 	
203 	// LEON ERC20 smart contract
204 	Token public tokenContract;
205 	
206     // crowdsale starts 1 March 2018, 00h00 PDT
207     uint256 public constant startDate = 1519891200;
208     // crowdsale ends 31 December 2018, 23h59 PDT
209     uint256 public constant endDate = 1546243140;
210     
211     // crowdsale aims to sell at least 100 000 LEONS
212     uint256 public constant crowdsaleTarget = 100000 * 10**18;
213     uint256 public constant margin = 1000 * 10**18;
214     // running total of tokens sold
215     uint256 public tokensSold;
216     
217     // ethereum to US Dollar exchange rate
218     uint256 public etherToUSDRate;
219     
220     // address to receive accumulated ether given a successful crowdsale
221 	address public constant etherVault = 0xD8d97E3B5dB13891e082F00ED3fe9A0BC6B7eA01;    
222 	// vault contract escrows ether and facilitates refunds given unsuccesful crowdsale
223 	RefundVault public refundVault;
224     
225     // minimum of 0.005 ether to participate in crowdsale
226 	uint256 constant purchaseThreshold = 5 finney;
227 
228     // boolean to indicate crowdsale finalized state	
229 	bool public isFinalized = false;
230 	
231 	bool public active = false;
232 	
233 	// finalization event
234 	event Finalized();
235 	
236 	// purchase event
237 	event Purchased(address indexed purchaser, uint256 indexed tokens);
238     
239     // checks that crowd sale is live	
240     modifier onlyWhileActive {
241         require(now >= startDate && now <= endDate && active);
242         _;
243     }	
244 	
245     function CrowdSale(address _tokenAddr, uint256 price) public {
246         // the LEON token contract
247         tokenContract = Token(_tokenAddr);
248         // initiate new refund vault to escrow ether from purchasers
249         refundVault = new RefundVault(etherVault);
250         
251         etherToUSDRate = price;
252     }	
253 	function setRate(uint256 _rate) public onlyModerator returns (bool) {
254 	    etherToUSDRate = _rate;
255 	}
256 	// fallback function invokes buyTokens method
257 	function() external payable {
258 	    buyTokens(msg.sender);
259 	}
260 	
261 	// forwards ether received to refund vault and generates tokens for purchaser
262 	function buyTokens(address _purchaser) public payable ifUnrestricted onlyWhileActive returns (bool) {
263 	    require(!targetReached());
264 	    require(msg.value > purchaseThreshold);
265 	    refundVault.deposit.value(msg.value)(_purchaser);
266 	    // 1 LEON is priced at 1 USD
267 	    // etherToUSDRate is stored in cents, /100 to get USD quantity
268 	    // crowdsale offers 100% bonus, purchaser receives (tokens before bonus) * 2
269 	    // tokens = (ether * etherToUSDRate in cents) * 2 / 100
270 		uint256 _tokens = (msg.value).mul(etherToUSDRate).div(50);		
271 		require(tokenContract.transferFrom(moderator,_purchaser, _tokens));
272         tokensSold = tokensSold.add(_tokens);
273         Purchased(_purchaser, _tokens);
274         return true;
275 	}	
276 	
277 	function initialize() public onlyModerator returns (bool) {
278 	    require(!active && !isFinalized);
279 	    require(tokenContract.allowance(moderator,address(this)) == crowdsaleTarget + margin);
280 	    active = true;
281 	}
282 	
283 	// activates end of crowdsale state
284     function finalize() public onlyModerator {
285         // cannot have been invoked before
286         require(!isFinalized);
287         // can only be invoked after end date or if target has been reached
288         require(hasEnded() || targetReached());
289         
290         // if crowdsale has been successful
291         if(targetReached()) {
292             // close refund vault and forward ether to etherVault
293             refundVault.close();
294 
295         // if the sale was unsuccessful    
296         } else {
297             // activate refund vault
298             refundVault.enableRefunds();
299         }
300         // emit Finalized event
301         Finalized();
302         // set isFinalized boolean to true
303         isFinalized = true;
304         
305         active = false;
306 
307     }
308     
309 	// checks if end date of crowdsale is passed    
310     function hasEnded() internal view returns (bool) {
311         return (now > endDate);
312     }
313     
314     // checks if crowdsale target is reached
315     function targetReached() internal view returns (bool) {
316         return (tokensSold >= crowdsaleTarget);
317     }
318     
319     // refunds ether to investors if crowdsale is unsuccessful 
320     function claimRefund() public {
321         // can only be invoked after sale is finalized
322         require(isFinalized);
323         // can only be invoked if sale target was not reached
324         require(!targetReached());
325         // if msg.sender invested ether during crowdsale - refund them of their contribution
326         refundVault.refund(msg.sender);
327     }
328 }