1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
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
34 
35 /**
36  * @title Ownable
37  * @dev The Ownable contract has an owner address, and provides basic authorization control
38  * functions, this simplifies the implementation of "user permissions".
39  */
40 contract Ownable {
41   address public owner;
42 
43 
44   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46 
47   /**
48    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49    * account.
50    */
51   function Ownable() public {
52     owner = msg.sender;
53   }
54 
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyOwner() {
60     require(msg.sender == owner);
61     _;
62   }
63 
64 
65   /**
66    * @dev Allows the current owner to transfer control of the contract to a newOwner.
67    * @param newOwner The address to transfer ownership to.
68    */
69   function transferOwnership(address newOwner) public onlyOwner {
70     require(newOwner != address(0));
71     OwnershipTransferred(owner, newOwner);
72     owner = newOwner;
73   }
74 
75 }
76 
77 
78 
79 
80 /**
81  * @title Claimable
82  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
83  * This allows the new owner to accept the transfer.
84  */
85 contract Claimable is Ownable {
86     address public pendingOwner;
87 
88     /**
89      * @dev Modifier throws if called by any account other than the pendingOwner.
90      */
91     modifier onlyPendingOwner() {
92         require(msg.sender == pendingOwner);
93         _;
94     }
95 
96     /**
97      * @dev Allows the current owner to set the pendingOwner address.
98      * @param newOwner The address to transfer ownership to.
99      */
100     function transferOwnership(address newOwner) onlyOwner public {
101         pendingOwner = newOwner;
102     }
103 
104     /**
105      * @dev Allows the pendingOwner address to finalize the transfer.
106      */
107     function claimOwnership() onlyPendingOwner public {
108         OwnershipTransferred(owner, pendingOwner);
109         owner = pendingOwner;
110         pendingOwner = address(0);
111     }
112 }
113 
114 /*
115     ERC20 Standard Token interface
116 */
117 contract IERC20Token {
118     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
119     function name() public constant returns (string) {}
120     function symbol() public constant returns (string) {}
121     function decimals() public constant returns (uint8) {}
122     function totalSupply() public constant returns (uint256) {}
123     function balanceOf(address _owner) public constant returns (uint256) { _owner; }
124     function allowance(address _owner, address _spender) public constant returns (uint256) { _owner; _spender; }
125 
126     function transfer(address _to, uint256 _value) public returns (bool success);
127     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
128     function approve(address _spender, uint256 _value) public returns (bool success);
129 }
130 
131 /*
132     Token Holder interface
133 */
134 contract ITokenHolder is Ownable {
135     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
136 }
137 
138 /*
139     We consider every contract to be a 'token holder' since it's currently not possible
140     for a contract to deny receiving tokens.
141 
142     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
143     the owner to send tokens that were sent to the contract by mistake back to their sender.
144 */
145 contract TokenHolder is ITokenHolder {
146     /**
147         @dev constructor
148     */
149     function TokenHolder() {
150     }
151 
152     /**
153         @dev withdraws tokens held by the contract and sends them to an account
154         can only be called by the owner
155 
156         @param _token   ERC20 token contract address
157         @param _to      account to receive the new amount
158         @param _amount  amount to withdraw
159     */
160     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
161     public
162     onlyOwner
163     {
164         require(_token != address(0x0));
165         require(_to != address(0x0));
166         require(_to != address(this));
167         assert(_token.transfer(_to, _amount));
168     }
169 }
170 
171 
172 
173 contract CrowdFunding is Claimable, TokenHolder {
174     using SafeMath for uint256;
175 
176     // =================================================================================================================
177     //                                      Members
178     // =================================================================================================================
179 
180     // the wallet of the beneficiary
181     address public walletBeneficiary;
182 
183     // amount of raised money in wei
184     uint256 public weiRaised;
185 
186     // indicate if the crowd funding is ended
187     bool public isFinalized = false;
188 
189     // =================================================================================================================
190     //                                      Modifiers
191     // =================================================================================================================
192 
193     modifier isNotFinalized() {
194         require(!isFinalized);
195         _;
196     }
197 
198     // =================================================================================================================
199     //                                      Events
200     // =================================================================================================================
201 
202     event DonateAdded(address indexed _from, address indexed _to,uint256 _amount);
203 
204     event DonationMatched(address indexed _from, address indexed _to,uint256 _amount);
205 
206     event Finalized();
207 
208     event ClaimBalance(address indexed _grantee, uint256 _amount);
209 
210     // =================================================================================================================
211     //                                      Constructors
212     // =================================================================================================================
213 
214     function CrowdFunding(address _walletBeneficiary) public {
215         require(_walletBeneficiary != address(0));
216         walletBeneficiary = _walletBeneficiary;
217     }
218 
219     // =================================================================================================================
220     //                                      Public Methods
221     // =================================================================================================================
222 
223     function deposit() onlyOwner isNotFinalized external payable {
224     }
225 
226     function() isNotFinalized external payable {
227         donate();
228     }
229 
230     function donate() isNotFinalized public payable {
231         require(msg.value > 0);
232 
233         uint256 weiAmount = msg.value;
234         
235         // transfering the donator funds to the beneficiary
236         weiRaised = weiRaised.add(weiAmount);
237         walletBeneficiary.transfer(weiAmount);
238         DonateAdded(msg.sender, walletBeneficiary, weiAmount);
239 
240         // transfering the owner funds to the beneficiary with the same amount of the donator
241         if(this.balance >= weiAmount) {
242             weiRaised = weiRaised.add(weiAmount);
243             walletBeneficiary.transfer(weiAmount);
244             DonationMatched(address(this), walletBeneficiary, weiAmount);
245         } else {
246 
247             weiRaised = weiRaised.add(this.balance);
248             // if not enough funds in the owner contract - transfer the remaining balance
249             walletBeneficiary.transfer(this.balance);
250             DonationMatched(address(this), walletBeneficiary, this.balance);
251         }
252     }
253 
254     function finalizeDonation(address beneficiary) onlyOwner isNotFinalized public {
255         require(beneficiary != address(0));
256 
257         uint256 weiAmount = this.balance;
258         beneficiary.transfer(weiAmount);
259 
260         ClaimBalance(beneficiary, weiAmount);
261 
262         isFinalized = true;
263 
264         Finalized();
265     }
266 }