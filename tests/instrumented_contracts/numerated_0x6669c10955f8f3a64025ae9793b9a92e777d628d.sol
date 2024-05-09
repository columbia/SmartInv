1 pragma solidity ^0.4.16;
2 /**
3  * @title xBounty Pre-seed token sale ICO Smart Contract.
4  * @author jitendra@chittoda.com
5  */
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
12         uint256 c = a * b;
13         assert(a == 0 || c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal constant returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal constant returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 
37 /**
38  * @title ERC20Basic
39  * @dev Simpler version of ERC20 interface
40  * @dev see https://github.com/ethereum/EIPs/issues/179
41  */
42 contract ERC20Basic {
43     uint256 public totalSupply;
44     mapping(address => uint256) balances;
45     function balanceOf(address _owner) public constant returns (uint256) { return balances[_owner]; }
46     //Transfer is disabled
47     //function transfer(address to, uint256 value) public returns (bool);
48     event Transfer(address indexed from, address indexed to, uint256 value);
49 }
50 
51 
52 /**
53  * @title Ownable
54  * @dev The Ownable contract has an owner address, and provides basic authorization control
55  * functions, this simplifies the implementation of "user permissions".
56  */
57 contract Ownable {
58     address public owner;
59 
60     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62     /**
63      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64      * account.
65      */
66     function Ownable() {
67         owner = msg.sender;
68     }
69 
70     /**
71      * @dev Throws if called by any account other than the owner.
72      */
73     modifier onlyOwner() {
74         require(msg.sender == owner);
75         _;
76     }
77 
78     /**
79      * @dev Allows the current owner to transfer control of the contract to a newOwner.
80      * @param newOwner The address to transfer ownership to.
81      */
82     function transferOwnership(address newOwner) onlyOwner public {
83         require(newOwner != address(0));
84         OwnershipTransferred(owner, newOwner);
85         owner = newOwner;
86     }
87 
88 }
89 
90 
91 /**
92  * @title Pausable
93  * @dev Base contract which allows children to implement an emergency stop mechanism.
94  */
95 contract Pausable is Ownable {
96     event Pause();
97     event Unpause();
98 
99     bool public paused = false;
100 
101 
102     /**
103      * @dev Modifier to make a function callable only when the contract is not paused.
104      */
105     modifier whenNotPaused() {
106         require(!paused);
107         _;
108     }
109 
110     /**
111      * @dev Modifier to make a function callable only when the contract is paused.
112      */
113     modifier whenPaused() {
114         require(paused);
115         _;
116     }
117 
118     /**
119      * @dev called by the owner to pause, triggers stopped state
120      */
121     function pause() onlyOwner whenNotPaused public {
122         paused = true;
123         Pause();
124     }
125 
126     /**
127      * @dev called by the owner to unpause, returns to normal state
128      */
129     function unpause() onlyOwner whenPaused public {
130         paused = false;
131         Unpause();
132     }
133 }
134 
135 
136 contract XBTokenSale is ERC20Basic, Pausable {
137 
138     using SafeMath for uint256;
139     string public constant name = "XB Token";
140     string public constant symbol = "XB";
141     uint256 public constant decimals = 18;
142 
143     // address where funds are collected
144     address public wallet;
145 
146     // Total XB tokens for PreSale
147     uint256 public constant TOTAL_XB_TOKEN_FOR_PRE_SALE = 2640000 * (10**decimals); //2,640,000 * 10^decimals
148 
149     // how many token units a buyer gets per ETH
150     uint256 public rate = 1250; //1250 XB tokens per ETH, including 25% discount
151 
152     // How many sold in PreSale
153     uint256 public presaleSoldTokens = 0;
154 
155     // amount of raised money in wei
156     uint256 public weiRaised;
157 
158     /**
159      * event for token purchase logging
160      * @param purchaser who paid for the tokens
161      * @param beneficiary who got the tokens
162      * @param value weis paid for purchase
163      * @param amount amount of tokens purchased
164      */
165     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
166     event Mint(address indexed to, uint256 amount);
167 
168     function XBTokenSale(address _wallet) public {
169         require(_wallet != 0x0);
170         wallet = _wallet;
171     }
172 
173 
174     // fallback function can be used to buy tokens
175     function () whenNotPaused public payable {
176         buyTokens(msg.sender);
177     }
178 
179     // low level token purchase function
180     //Only when the PreSale is running
181     function buyTokens(address beneficiary) whenNotPaused public payable {
182         require(beneficiary != 0x0);
183 
184         uint256 weiAmount = msg.value;
185 
186         // calculate token amount to be created
187         uint256 tokens = weiAmount.mul(rate);
188 
189         require(presaleSoldTokens + tokens <= TOTAL_XB_TOKEN_FOR_PRE_SALE);
190         presaleSoldTokens = presaleSoldTokens.add(tokens);
191 
192         // update state
193         weiRaised = weiRaised.add(weiAmount);
194 
195         mint(beneficiary, tokens);
196         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
197 
198         forwardFunds();
199     }
200 
201 
202     /**
203       * @dev Function to mint tokens
204       * @param _to The address that will receive the minted tokens.
205       * @param _amount The amount of tokens to mint.
206       * @return A boolean that indicates if the operation was successful.
207       */
208     function mint(address _to, uint256 _amount) internal returns (bool) {
209         totalSupply = totalSupply.add(_amount);
210         balances[_to] = balances[_to].add(_amount);
211         Mint(_to, _amount);
212         Transfer(0x0, _to, _amount);
213         return true;
214     }
215 
216 
217     // send ether to the fund collection wallet
218     // override to create custom fund forwarding mechanisms
219     function forwardFunds() internal {
220         wallet.transfer(msg.value);
221     }
222 
223 }