1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     /**
9     * @dev Multiplies two numbers, throws on overflow.
10     */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12         if (a == 0) {
13             return 0;
14         }
15         c = a * b;
16         assert(c / a == b);
17         return c;
18     }
19 
20     /**
21     * @dev Integer division of two numbers, truncating the quotient.
22     */
23     function div(uint256 a, uint256 b) internal pure returns (uint256) {
24         // assert(b > 0); // Solidity automatically throws when dividing by 0
25         // uint256 c = a / b;
26         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27         return a / b;
28     }
29 
30     /**
31     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32     */
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37 
38     /**
39     * @dev Adds two numbers, throws on overflow.
40     */
41     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
42         c = a + b;
43         assert(c >= a);
44         return c;
45     }
46 }
47 
48 /**
49  * @title Ownable
50  * @dev The Ownable contract has an owner address, and provides basic authorization control
51  * functions, this simplifies the implementation of "user permissions".
52  */
53 contract Ownable {
54     address internal owner;
55 
56     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
57 
58     /**
59      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
60      * account.
61      */
62     constructor() public {
63         owner = msg.sender;
64     }
65 
66     /**
67      * @dev Throws if called by any account other than the owner.
68      */
69     modifier onlyOwner() {
70         require(msg.sender == owner);
71         _;
72     }
73 
74     /**
75      * @dev Allows the current owner to transfer control of the contract to a newOwner.
76      * @param newOwner The address to transfer ownership to.
77      */
78     function transferOwnership(address newOwner) onlyOwner public returns (bool) {
79         require(newOwner != address(0x0));
80         emit OwnershipTransferred(owner, newOwner);
81         owner = newOwner;
82 
83         return true;
84     }
85 }
86 
87 interface MintableToken {
88     function mint(address _to, uint256 _amount) external returns (bool);
89     function transferOwnership(address newOwner) external returns (bool);
90 }
91 
92 interface BitNauticWhitelist {
93     function AMLWhitelisted(address) external returns (bool);
94 }
95 
96 interface BitNauticCrowdsale {
97     function creditOf(address) external returns (uint256);
98 }
99 
100 contract BitNauticCrowdsaleTokenDistributor is Ownable {
101     using SafeMath for uint256;
102 
103     uint256 public constant ICOStartTime = 1531267200; // 11 Jul 2018 00:00 GMT
104     uint256 public constant ICOEndTime = 1536969600; // 15 Sep 2018 00:00 GMT
105 
106     uint256 public teamSupply =     3000000 * 10 ** 18; // 6% of token cap
107     uint256 public bountySupply =   2500000 * 10 ** 18; // 5% of token cap
108     uint256 public reserveSupply =  5000000 * 10 ** 18; // 10% of token cap
109     uint256 public advisorSupply =  2500000 * 10 ** 18; // 5% of token cap
110     uint256 public founderSupply =  2000000 * 10 ** 18; // 4% of token cap
111 
112     MintableToken public token;
113     BitNauticWhitelist public whitelist;
114     BitNauticCrowdsale public crowdsale;
115 
116     mapping (address => bool) public hasClaimedTokens;
117 
118     constructor(MintableToken _token, BitNauticWhitelist _whitelist, BitNauticCrowdsale _crowdsale) public {
119         token = _token;
120         whitelist = _whitelist;
121         crowdsale = _crowdsale;
122     }
123 
124     function privateSale(address beneficiary, uint256 tokenAmount) onlyOwner public {
125         require(beneficiary != 0x0);
126 
127         assert(token.mint(beneficiary, tokenAmount));
128     }
129 
130     // this function can be called by the contributor to claim his BTNT tokens at the end of the ICO
131     function claimBitNauticTokens() public returns (bool) {
132         return grantContributorTokens(msg.sender);
133     }
134 
135     // if the ICO is finished and the goal has been reached, this function will be used to mint and transfer BTNT tokens to each contributor
136     function grantContributorTokens(address contributor) public returns (bool) {
137         require(!hasClaimedTokens[contributor]);
138         require(crowdsale.creditOf(contributor) > 0);
139         require(whitelist.AMLWhitelisted(contributor));
140         require(now > ICOEndTime);
141 
142         assert(token.mint(contributor, crowdsale.creditOf(contributor)));
143         hasClaimedTokens[contributor] = true;
144 
145         return true;
146     }
147 
148     function transferTokenOwnership(address newTokenOwner) onlyOwner public returns (bool) {
149         return token.transferOwnership(newTokenOwner);
150     }
151 
152     function grantBountyTokens(address beneficiary) onlyOwner public {
153         require(bountySupply > 0);
154 
155         token.mint(beneficiary, bountySupply);
156         bountySupply = 0;
157     }
158 
159     function grantReserveTokens(address beneficiary) onlyOwner public {
160         require(reserveSupply > 0);
161 
162         token.mint(beneficiary, reserveSupply);
163         reserveSupply = 0;
164     }
165 
166     function grantAdvisorsTokens(address beneficiary) onlyOwner public {
167         require(advisorSupply > 0);
168 
169         token.mint(beneficiary, advisorSupply);
170         advisorSupply = 0;
171     }
172 
173     function grantFoundersTokens(address beneficiary) onlyOwner public {
174         require(founderSupply > 0);
175 
176         token.mint(beneficiary, founderSupply);
177         founderSupply = 0;
178     }
179 
180     function grantTeamTokens(address beneficiary) onlyOwner public {
181         require(teamSupply > 0);
182 
183         token.mint(beneficiary, teamSupply);
184         teamSupply = 0;
185     }
186 }