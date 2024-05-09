1 pragma solidity ^0.4.15;
2 
3 
4 contract Token {
5     uint256 public totalSupply;
6 
7     function balanceOf(address who) constant returns (uint256);
8 
9     function transferFrom(address _from, address _to, uint256 _value) returns (bool);
10 
11     event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
21         uint256 c = a * b;
22         assert(a == 0 || c / a == b);
23         return c;
24     }
25 
26     function div(uint256 a, uint256 b) internal constant returns (uint256) {
27         // assert(b > 0); // Solidity automatically throws when dividing by 0
28         uint256 c = a / b;
29         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30         return c;
31     }
32 
33     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37 
38     function add(uint256 a, uint256 b) internal constant returns (uint256) {
39         uint256 c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 }
44 
45 
46 /**
47  * @title Ownable
48  * @dev The Ownable contract has an owner address, and provides basic authorization control
49  * functions, this simplifies the implementation of "user permissions".
50  */
51 contract Ownable {
52     address public owner;
53 
54 
55     /**
56      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
57      * account.
58      */
59     function Ownable() {
60         owner = msg.sender;
61     }
62 
63 
64     /**
65      * @dev Throws if called by any account other than the owner.
66      */
67     modifier onlyOwner() {
68         require(msg.sender == owner);
69         _;
70     }
71 
72 
73     /**
74      * @dev Allows the current owner to transfer control of the contract to a newOwner.
75      * @param newOwner The address to transfer ownership to.
76      */
77     function transferOwnership(address newOwner) onlyOwner {
78         require(newOwner != address(0));
79         owner = newOwner;
80     }
81 
82 }
83 
84 
85 /**
86  * @title Pausable
87  * @dev Base contract which allows children to implement an emergency stop mechanism.
88  */
89 contract Pausable is Ownable {
90     event Pause();
91 
92     event Unpause();
93 
94     bool public paused = false;
95 
96 
97     /**
98      * @dev modifier to allow actions only when the contract IS paused
99      */
100     modifier whenNotPaused() {
101         require(!paused);
102         _;
103     }
104 
105     /**
106      * @dev modifier to allow actions only when the contract IS NOT paused
107      */
108     modifier whenPaused() {
109         require(paused);
110         _;
111     }
112 
113     /**
114      * @dev called by the owner to pause, triggers stopped state
115      */
116     function pause() onlyOwner whenNotPaused {
117         paused = true;
118         Pause();
119     }
120 
121     /**
122      * @dev called by the owner to unpause, returns to normal state
123      */
124     function unpause() onlyOwner whenPaused {
125         paused = false;
126         Unpause();
127     }
128 }
129 
130 
131 contract CashPokerProPreICO is Ownable, Pausable {
132     using SafeMath for uint;
133 
134     /* The party who holds the full token pool and has approve()'ed tokens for this crowdsale */
135     address public tokenWallet = 0x774d91ac35f4e2f94f0e821a03c6eaff8ad4c138;
136 	
137     uint public tokensSold;
138 
139     uint public weiRaised;
140 
141     mapping (address => uint256) public purchasedTokens;
142      
143     uint public investorCount;
144 
145     Token public token = Token(0xA8F93FAee440644F89059a2c88bdC9BF3Be5e2ea);
146 
147     uint public constant minInvest = 0.01 ether;
148 
149     uint public constant tokensLimit = 8000000 * 1 ether;
150 
151     // start and end timestamps where investments are allowed (both inclusive)
152     uint256 public startTime = 1503770400; // 26 August 2017
153     
154     uint256 public endTime = 1504893600; // 8 September 2017
155 
156     uint public price = 0.00017 * 1 ether;
157 
158     /**
159      * event for token purchase logging
160      * @param purchaser who paid for the tokens
161      * @param beneficiary who got the tokens
162      * @param value weis paid for purchase
163      * @param amount amount of tokens purchased
164      */
165     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
166 
167     // fallback function can be used to buy tokens
168     function() payable {
169         buyTokens(msg.sender);
170     }
171 
172     // low level token purchase function
173     function buyTokens(address beneficiary) whenNotPaused payable {
174         require(startTime <= now && now <= endTime);
175 
176         uint weiAmount = msg.value;
177 
178         require(weiAmount >= minInvest);
179 
180         uint tokenAmountEnable = tokensLimit.sub(tokensSold);
181 
182         require(tokenAmountEnable > 0);
183 
184         uint tokenAmount = weiAmount / price * 1 ether;
185 
186         if (tokenAmount > tokenAmountEnable) {
187             tokenAmount = tokenAmountEnable;
188             weiAmount = tokenAmount * price / 1 ether;
189             msg.sender.transfer(msg.value - weiAmount);
190         }
191 
192         if (purchasedTokens[beneficiary] == 0) investorCount++;
193         
194         purchasedTokens[beneficiary] = purchasedTokens[beneficiary].add(tokenAmount);
195 
196         weiRaised = weiRaised.add(weiAmount);
197 
198         require(token.transferFrom(tokenWallet, beneficiary, tokenAmount));
199 
200         tokensSold = tokensSold.add(tokenAmount);
201 
202         TokenPurchase(msg.sender, beneficiary, weiAmount, tokenAmount);
203     }
204 
205     function withdrawal(address to) onlyOwner {
206         to.transfer(this.balance);
207     }
208 
209     function transfer(address to, uint amount) onlyOwner {
210         uint tokenAmountEnable = tokensLimit.sub(tokensSold);
211 
212         if (amount > tokenAmountEnable) amount = tokenAmountEnable;
213 
214         require(token.transferFrom(tokenWallet, to, amount));
215 
216         tokensSold = tokensSold.add(amount);
217     }
218 }