1 pragma solidity ^0.5.2;
2 
3 interface ERC223Handler { 
4     function tokenFallback(address _from, uint _value, bytes calldata _data) external;
5 }
6 
7 interface ICOStickers {
8     function giveSticker(address _to, uint256 _property) external;
9 }
10 
11 
12 contract ICOToken{
13     using SafeMath for uint256;
14     using SafeMath for uint;
15     
16 	modifier onlyOwner {
17 		require(msg.sender == owner);
18 		_;
19 	}
20     
21     constructor(address _s) public{
22         stickers = ICOStickers(_s);
23         totalSupply = 0;
24         owner = msg.sender;
25     }
26 	address owner;
27 	address newOwner;
28     
29     uint256 constant internal MAX_UINT256 = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
30     uint256 constant internal TOKEN_PRICE = 0.0001 ether;
31     uint256 constant public fundingCap = 2000 ether;
32 
33     uint256 constant public IcoStartTime = 1546628400; // Jan 04 2019 20:00:00 GMT+0100
34     uint256 constant public IcoEndTime = 1550084400; // Feb 13 2019 20:00:00 GMT+0100
35 
36 
37     ICOStickers internal stickers;
38     mapping(address => uint256) internal beneficiaryWithdrawAmount;
39     mapping(address => uint256) public beneficiaryShares;
40     uint256 public beneficiaryTotalShares;
41     uint256 public beneficiaryPayoutPerShare;
42     uint256 public icoFunding;
43     
44     mapping(address => uint256) public balanceOf;
45     mapping(address => uint256) public etherSpent;
46     mapping(address => mapping (address => uint256)) internal allowances;
47     string constant public name = "0xchan ICO";
48     string constant public symbol = "ZCI";
49     uint8 constant public decimals = 18;
50     uint256 public totalSupply;
51     
52     // --Events
53     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
54     event Transfer(address indexed from, address indexed to, uint value);
55     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
56     
57     event onICOBuy(address indexed from, uint256 tokens, uint256 bonusTokens);
58     // --Events--
59     
60     // --Owner only functions
61     function setNewOwner(address o) public onlyOwner {
62 		newOwner = o;
63 	}
64 
65 	function acceptNewOwner() public {
66 		require(msg.sender == newOwner);
67 		owner = msg.sender;
68 	}
69 	
70     // For the 0xchan ICO, the following beneficieries will be added.
71     // 3 - Aritz
72     // 3 - Sumpunk
73     // 2 - Multisig wallet for bounties/audit payments
74 	function addBeneficiary(address b, uint256 shares) public onlyOwner {
75 	   require(block.timestamp < IcoStartTime, "ICO has started");
76 	   require(beneficiaryWithdrawAmount[b] == 0, "Already a beneficiary");
77 	   beneficiaryWithdrawAmount[b] = MAX_UINT256;
78 	   beneficiaryShares[b] = shares;
79 	   beneficiaryTotalShares += shares;
80 	}
81 	
82 	function removeBeneficiary(address b, uint256 shares) public onlyOwner {
83 	   require(block.timestamp < IcoStartTime, "ICO has started");
84 	   require(beneficiaryWithdrawAmount[b] != 0, "Not a beneficiary");
85 	   delete beneficiaryWithdrawAmount[b];
86 	   delete beneficiaryShares[b];
87 	   beneficiaryTotalShares -= shares;
88 	}
89 	
90 	// --Owner only functions--
91     
92     // --Public write functions
93     function withdrawFunding(uint256 _amount) public {
94         if (icoFunding == 0){
95             require(address(this).balance >= fundingCap || block.timestamp >= IcoEndTime, "ICO hasn't ended");
96             icoFunding = address(this).balance;
97         }
98         require(beneficiaryWithdrawAmount[msg.sender] > 0, "You're not a beneficiary");
99         uint256 stash = beneficiaryStash(msg.sender);
100         if (_amount >= stash){
101             beneficiaryWithdrawAmount[msg.sender] = beneficiaryPayoutPerShare * beneficiaryShares[msg.sender];
102             msg.sender.transfer(stash);
103         }else{
104             if (beneficiaryWithdrawAmount[msg.sender] == MAX_UINT256){
105                 beneficiaryWithdrawAmount[msg.sender] = _amount;
106             }else{
107                 beneficiaryWithdrawAmount[msg.sender] += _amount;
108             }
109             msg.sender.transfer(_amount);
110         }
111     }
112     
113     function() payable external{
114         require(block.timestamp >= IcoStartTime, "ICO hasn't started yet");
115         require(icoFunding == 0 && block.timestamp < IcoEndTime, "ICO has ended");
116         require(msg.value != 0 && ((msg.value % TOKEN_PRICE) == 0), "Must be a multiple of 0.0001 ETH");
117         
118         uint256 thisBalance = address(this).balance; 
119         uint256 msgValue = msg.value;
120         
121         // While the extra ETH is appriciated, we set ourselves a hardcap and we're gonna stick to it!
122         if (thisBalance > fundingCap){
123             msgValue -= (thisBalance - fundingCap);
124             require(msgValue != 0, "Funding cap has been reached");
125             thisBalance = fundingCap;
126         }
127         
128         uint256 oldBalance = thisBalance - msgValue;
129         uint256 tokensToGive = (msgValue / TOKEN_PRICE) * 1e18;
130         uint256 bonusTokens;
131         
132         uint256 difference;
133         
134         while (oldBalance < thisBalance){
135             if (oldBalance < 500 ether){
136                 difference = min(500 ether, thisBalance) - oldBalance;
137                 bonusTokens += ((difference / TOKEN_PRICE) * 1e18) / 2;
138                 oldBalance += difference;
139             }else if(oldBalance < 1250 ether){
140                 difference = min(1250 ether, thisBalance) - oldBalance;
141                 bonusTokens += ((difference / TOKEN_PRICE) * 1e18) / 5;
142                 oldBalance += difference;
143             }else{
144                 difference = thisBalance - oldBalance;
145                 bonusTokens += ((difference / TOKEN_PRICE) * 1e18) / 10;
146                 oldBalance += difference;
147             }
148         }
149         emit onICOBuy(msg.sender, tokensToGive, bonusTokens);
150         
151         tokensToGive += bonusTokens;
152         balanceOf[msg.sender] += tokensToGive;
153         totalSupply += tokensToGive;
154         
155         if (address(stickers) != address(0)){
156             stickers.giveSticker(msg.sender, msgValue);
157         }
158         emit Transfer(address(this), msg.sender, tokensToGive, "");
159         emit Transfer(address(this), msg.sender, tokensToGive);
160         
161         beneficiaryPayoutPerShare = thisBalance / beneficiaryTotalShares;
162         etherSpent[msg.sender] += msgValue;
163         if (msgValue != msg.value){
164             // Finally return any extra ETH sent.
165             msg.sender.transfer(msg.value - msgValue); 
166         }
167     }
168     
169     function transfer(address _to, uint _value, bytes memory _data, string memory _function) public returns(bool ok){
170         actualTransfer(msg.sender, _to, _value, _data, _function, true);
171         return true;
172     }
173     
174     function transfer(address _to, uint _value, bytes memory _data) public returns(bool ok){
175         actualTransfer(msg.sender, _to, _value, _data, "", true);
176         return true;
177     }
178     function transfer(address _to, uint _value) public returns(bool ok){
179         actualTransfer(msg.sender, _to, _value, "", "", true);
180         return true;
181     }
182     
183     function approve(address _spender, uint _value) public returns (bool success) {
184         allowances[msg.sender][_spender] = _value;
185         emit Approval(msg.sender, _spender, _value);
186         return true;
187     }
188     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
189         uint256 _allowance = allowances[_from][msg.sender];
190         require(_allowance > 0, "Not approved");
191         require(_allowance >= _value, "Over spending limit");
192         allowances[_from][msg.sender] = _allowance.sub(_value);
193         actualTransfer(_from, _to, _value, "", "", false);
194         return true;
195     }
196     
197     // --Public write functions--
198      
199     // --Public read-only functions
200     function beneficiaryStash(address b) public view returns (uint256){
201         uint256 withdrawAmount = beneficiaryWithdrawAmount[b];
202         if (withdrawAmount == 0){
203             return 0;
204         }
205         if (withdrawAmount == MAX_UINT256){
206             return beneficiaryPayoutPerShare * beneficiaryShares[b];
207         }
208         return (beneficiaryPayoutPerShare * beneficiaryShares[b]) - withdrawAmount;
209     }
210     
211     function allowance(address _sugardaddy, address _spender) public view returns (uint remaining) {
212         return allowances[_sugardaddy][_spender];
213     }
214     
215     // --Public read-only functions--
216     
217     
218     
219     // Internal functions
220     
221     function actualTransfer (address _from, address _to, uint _value, bytes memory _data, string memory _function, bool _careAboutHumanity) private {
222         // You can only transfer this token after the ICO has ended.
223         require(icoFunding != 0 || address(this).balance >= fundingCap || block.timestamp >= IcoEndTime, "ICO hasn't ended");
224         require(balanceOf[_from] >= _value, "Insufficient balance");
225         require(_to != address(this), "You can't sell back your tokens");
226         
227         // Throwing an exception undos all changes. Otherwise changing the balance now would be a shitshow
228         balanceOf[_from] = balanceOf[_from].sub(_value);
229         balanceOf[_to] = balanceOf[_to].add(_value);
230         
231         if(_careAboutHumanity && isContract(_to)) {
232             if (bytes(_function).length == 0){
233                 ERC223Handler receiver = ERC223Handler(_to);
234                 receiver.tokenFallback(_from, _value, _data);
235             }else{
236                 bool success;
237                 bytes memory returnData;
238                 (success, returnData) = _to.call.value(0)(abi.encodeWithSignature(_function, _from, _value, _data));
239                 assert(success);
240             }
241         }
242         emit Transfer(_from, _to, _value, _data);
243         emit Transfer(_from, _to, _value);
244     }
245     
246     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
247     function isContract(address _addr) private view returns (bool is_contract) {
248         uint length;
249         assembly {
250             //retrieve the size of the code on target address, this needs assembly
251             length := extcodesize(_addr)
252         }
253         return (length>0);
254     }
255     
256     function min(uint256 i1, uint256 i2) private pure returns (uint256) {
257         if (i1 < i2){
258             return i1;
259         }
260         return i2;
261     }
262 }
263 
264 /**
265  * @title SafeMath
266  * @dev Math operations with safety checks that throw on error
267  */
268 library SafeMath {
269     
270     /**
271     * @dev Multiplies two numbers, throws on overflow.
272     */
273     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
274         if (a == 0 || b == 0) {
275            return 0;
276         }
277         c = a * b;
278         assert(c / a == b);
279         return c;
280     }
281     
282     /**
283     * @dev Integer division of two numbers, truncating the quotient.
284     */
285     function div(uint256 a, uint256 b) internal pure returns (uint256) {
286         // assert(b > 0); // Solidity automatically throws when dividing by 0
287         // uint256 c = a / b;
288         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
289         return a / b;
290     }
291     
292     /**
293     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
294     */
295     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
296         assert(b <= a);
297         return a - b;
298     }
299     
300     /**
301     * @dev Adds two numbers, throws on overflow.
302     */
303     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
304         c = a + b;
305         assert(c >= a);
306         return c;
307     }
308 }