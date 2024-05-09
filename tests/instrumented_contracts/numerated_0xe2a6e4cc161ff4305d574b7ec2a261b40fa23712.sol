1 pragma solidity ^0.4.17;
2 
3 // ----------------------------------------------------------------------------
4 // CSE ICO contract
5 // ----------------------------------------------------------------------------
6 
7 
8 // ----------------------------------------------------------------------------
9 // Safe math
10 // ----------------------------------------------------------------------------
11 library SafeMath {
12     function add(uint a, uint b) internal pure returns (uint c) {
13         c = a + b;
14         require(c >= a);
15     }
16     function sub(uint a, uint b) internal pure returns (uint c) {
17         require(b <= a);
18         c = a - b;
19     }
20     function mul(uint a, uint b) internal pure returns (uint c) {
21         c = a * b;
22         require(a == 0 || c / a == b);
23     }
24     function div(uint a, uint b) internal pure returns (uint c) {
25         require(b > 0);
26         c = a / b;
27     }
28 }
29 
30 
31 // ----------------------------------------------------------------------------
32 // Ownership contract
33 // _newOwner is address of new owner
34 // ----------------------------------------------------------------------------
35 contract Owned {
36     
37     address public owner;
38 
39     event OwnershipTransferred(address indexed _from, address indexed _to);
40 
41     function Owned() public {
42         owner = msg.sender;
43     }
44 
45     modifier onlyOwner {
46         require(msg.sender == owner);
47         _;
48     }
49 
50     // transfer Ownership to other address
51     function transferOwnership(address _newOwner) public onlyOwner {
52         require(_newOwner != address(0x0));
53         emit OwnershipTransferred(owner,_newOwner);
54         owner = _newOwner;
55     }
56     
57 }
58 
59 
60 // ----------------------------------------------------------------------------
61 // CesaireToken interface
62 // ----------------------------------------------------------------------------
63 contract CesaireToken {
64     
65     function balanceOf(address _owner) public constant returns (uint256 balance);
66     function transfer(address _to, uint256 _value) public returns (bool success);
67     
68 }
69 
70 
71 // ----------------------------------------------------------------------------
72 // CesaireICO smart contract
73 // ----------------------------------------------------------------------------
74 contract CesaireICO is Owned {
75 
76     using SafeMath for uint256;
77     
78     enum State {
79         PrivatePreSale,
80         PreICO,
81         ICORound1,
82         ICORound2,
83         ICORound3,
84         ICORound4,
85         ICORound5,
86         Successful
87     }
88     
89     //public variables
90     State public state; //Set initial stage
91     uint256 public totalRaised; //eth in wei
92     uint256 public totalDistributed; //tokens distributed
93     CesaireToken public CSE; // CSE token address
94     
95     mapping(address => bool) whitelist; // whitelisting for KYC verified users
96 
97     // events for log
98     event LogWhiteListed(address _addr);
99     event LogBlackListed(address _addr);
100     event LogFundingReceived(address _addr, uint _amount, uint _currentTotal);
101     event LogBeneficiaryPaid(address _beneficiaryAddress);
102     event LogFundingSuccessful(uint _totalRaised);
103     event LogFunderInitialized(address _creator);
104     event LogContributorsPayout(address _addr, uint _amount);
105     
106     // To determine whether the ICO is running or stopped
107     modifier onlyIfNotFinished {
108         require(state != State.Successful);
109         _;
110     }
111     
112     // To determine whether the user is whitelisted 
113     modifier onlyIfWhiteListedOnPreSale {
114         if(state == State.PrivatePreSale) {
115           require(whitelist[msg.sender]);
116         } 
117         _;
118     }
119     
120     // ----------------------------------------------------------------------------
121     // CesaireICO constructor
122     // _addressOfToken is the token totalDistributed
123     // ----------------------------------------------------------------------------
124     function CesaireICO (CesaireToken _addressOfToken) public {
125         require(_addressOfToken != address(0)); // should have valid address
126         CSE = CesaireToken(_addressOfToken);
127         state = State.PrivatePreSale;
128         emit LogFunderInitialized(owner);
129     }
130     
131     
132     // ----------------------------------------------------------------------------
133     // Function to handle eth transfers
134     // It invokes when someone sends ETH to this contract address.
135     // Requires enough gas for the execution otherwise it'll throw out of gas error.
136     // tokens are transferred to user
137     // ETH are transferred to current owner
138     // minimum 1 ETH investment
139     // maxiumum 10 ETH investment
140     // ----------------------------------------------------------------------------
141     function() public payable {
142         contribute();
143     }
144 
145 
146     // ----------------------------------------------------------------------------
147     // Acceptes ETH and send equivalent CSE with bonus if any.
148     // NOTE: Add user to whitelist by invoking addToWhiteList() function.
149     // Only whitelisted users can buy tokens.
150     // For Non-whitelisted/Blacklisted users transaction will be reverted. 
151     // ----------------------------------------------------------------------------
152     function contribute() onlyIfNotFinished onlyIfWhiteListedOnPreSale public payable {
153         
154         uint256 tokenBought; // Variable to store amount of tokens bought
155         uint256 bonus; // Variable to store bonus if any
156         uint256 tokenPrice;
157         
158         //Token allocation calculation
159         if (state == State.PrivatePreSale){
160             require(msg.value >= 2 ether); // min 2 ETH investment
161             tokenPrice = 160000;
162             tokenBought = msg.value.mul(tokenPrice);
163             bonus = tokenBought; // 100 % bonus
164         } 
165         else if (state == State.PreICO){
166             require(msg.value >= 1 ether); // min 1 ETH investment
167             tokenPrice = 160000;
168             tokenBought = msg.value.mul(tokenPrice);
169             bonus = tokenBought.mul(50).div(100); // 50 % bonus
170         } 
171         else if (state == State.ICORound1){
172             require(msg.value >= 0.7 ether); // min 0.7 ETH investment
173             tokenPrice = 140000;
174             tokenBought = msg.value.mul(tokenPrice);
175             bonus = tokenBought.mul(40).div(100); // 40 % bonus
176         } 
177         else if (state == State.ICORound2){
178             require(msg.value >= 0.5 ether); // min 0.5 ETH investment
179             tokenPrice = 120000;
180             tokenBought = msg.value.mul(tokenPrice);
181             bonus = tokenBought.mul(30).div(100); // 30 % bonus
182         } 
183         else if (state == State.ICORound3){
184             require(msg.value >= 0.3 ether); // min 0.3 ETH investment
185             tokenPrice = 100000;
186             tokenBought = msg.value.mul(tokenPrice);
187             bonus = tokenBought.mul(20).div(100); // 20 % bonus
188         } 
189         else if (state == State.ICORound4){
190             require(msg.value >= 0.2 ether); // min 0.2 ETH investment
191             tokenPrice = 80000;
192             tokenBought = msg.value.mul(tokenPrice);
193             bonus = tokenBought.mul(10).div(100); // 10 % bonus
194         } 
195         else if (state == State.ICORound5){
196             require(msg.value >= 0.1 ether); // min 0.1 ETH investment
197             tokenPrice = 60000;
198             tokenBought = msg.value.mul(tokenPrice);
199             bonus = 0; // 0 % bonus
200         } 
201 
202         tokenBought = tokenBought.add(bonus); // add bonus to the tokenBought
203         
204         // this smart contract should have enough tokens to distribute
205         require(CSE.balanceOf(this) >= tokenBought);
206         
207         totalRaised = totalRaised.add(msg.value); // Save the total eth totalRaised (in wei)
208         totalDistributed = totalDistributed.add(tokenBought); //Save to total tokens distributed
209         
210         CSE.transfer(msg.sender,tokenBought); //Send Tokens to user
211         owner.transfer(msg.value); // Send ETH to owner
212         
213         //LOGS
214         emit LogContributorsPayout(msg.sender,tokenBought); // Log investor paid event
215         emit LogBeneficiaryPaid(owner); // Log owner paid event
216         emit LogFundingReceived(msg.sender, msg.value, totalRaised); // Log funding event
217     }
218     
219     
220     function finished() onlyOwner public { 
221         
222         uint256 remainder = CSE.balanceOf(this); //Remaining tokens on contract
223         
224         //Funds send to creator if any
225         if(address(this).balance > 0) {
226             owner.transfer(address(this).balance);
227             emit LogBeneficiaryPaid(owner);
228         }
229  
230         CSE.transfer(owner,remainder); //remainder tokens send to creator
231         emit LogContributorsPayout(owner, remainder);
232         
233         state = State.Successful; // updating the state
234     }
235     
236     
237     function nextState() onlyOwner public {
238         require(state != State.ICORound5);
239         state = State(uint(state) + 1);
240     }
241     
242     
243     function previousState() onlyOwner public {
244         require(state != State.PrivatePreSale);
245         state = State(uint(state) - 1);
246     }
247 
248 
249     // ----------------------------------------------------------------------------
250     // function to whitelist user if KYC verified
251     // returns true if whitelisting is successful else returns false
252     // ----------------------------------------------------------------------------
253     function addToWhiteList(address _userAddress) onlyOwner public returns(bool) {
254         require(_userAddress != address(0)); // user address must be valid
255         // if not already in the whitelist
256         if (!whitelist[_userAddress]) {
257             whitelist[_userAddress] = true;
258             emit LogWhiteListed(_userAddress); // Log whitelist event
259             return true;
260         } else {
261             return false;
262         }
263     }
264     
265     
266     // ----------------------------------------------------------------------------
267     // function to remove user from whitelist
268     // ----------------------------------------------------------------------------
269     function removeFromWhiteList(address _userAddress) onlyOwner public returns(bool) {
270         require(_userAddress != address(0)); // user address must be valid
271         // if in the whitelist
272         if(whitelist[_userAddress]) {
273            whitelist[_userAddress] = false; 
274            emit LogBlackListed(_userAddress); // Log blacklist event
275            return true;
276         } else {
277             return false;
278         }
279         
280     }
281     
282     
283     // ----------------------------------------------------------------------------
284     // function to check if user is whitelisted
285     // ----------------------------------------------------------------------------
286     function checkIfWhiteListed(address _userAddress) view public returns(bool) {
287         return whitelist[_userAddress];
288     }
289     
290 
291     // ----------------------------------------------------------------------------
292     // Function to claim any token stuck on contract
293     // ----------------------------------------------------------------------------
294     function claimTokens() onlyOwner public {
295         uint256 remainder = CSE.balanceOf(this); //Check remainder tokens
296         CSE.transfer(owner,remainder); //Transfer tokens to owner
297     }
298     
299 }