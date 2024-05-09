1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39   address public owner;
40 
41 
42   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44 
45   /**
46    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47    * account.
48    */
49   function Ownable() {
50     owner = msg.sender;
51   }
52 
53 
54   /**
55    * @dev Throws if called by any account other than the owner.
56    */
57   modifier onlyOwner() {
58     require(msg.sender == owner);
59     _;
60   }
61 
62 
63   /**
64    * @dev Allows the current owner to transfer control of the contract to a newOwner.
65    * @param newOwner The address to transfer ownership to.
66    */
67   function transferOwnership(address newOwner) onlyOwner public {
68     require(newOwner != address(0));
69     OwnershipTransferred(owner, newOwner);
70     owner = newOwner;
71   }
72 
73 }
74 
75 contract AbstractStarbaseToken {
76     function isFundraiser(address fundraiserAddress) public returns (bool);
77     function company() public returns (address);
78     function allocateToCrowdsalePurchaser(address to, uint256 value) public returns (bool);
79     function allocateToMarketingSupporter(address to, uint256 value) public returns (bool);
80 }
81 
82 /**
83  * @title Crowdsale contract - Starbase marketing campaign contract to reward supportors
84  * @author Starbase PTE. LTD. - <info@starbase.co>
85  */
86 contract StarbaseMarketingCampaign is Ownable {
87     /*
88      *  Events
89      */
90     event NewContributor (address indexed contributorAddress, uint256 tokenCount);
91     event WithdrawContributorsToken(address indexed contributorAddress, uint256 tokenWithdrawn);
92 
93     /**
94      *  External contracts
95      */
96     AbstractStarbaseToken public starbaseToken;
97 
98     /**
99      * Types
100      */
101     struct Contributor {
102         uint256 rewardedTokens;
103         mapping (bytes32 => bool) contributions;  // example: keccak256(bcm-xda98sdf) => true
104         bool isContributor;
105     }
106 
107     /**
108      *  Storage
109      */
110     address[] public contributors;
111     mapping (address => Contributor) public contributor;
112 
113     /**
114      *  Functions
115      */
116 
117     /**
118      * @dev Contract constructor sets owner address.
119      */
120     function StarbaseMarketingCampaign() {
121         owner = msg.sender;
122     }
123 
124     /*
125      *  External Functions
126      */
127 
128     /**
129      * @dev Setup function sets external contracts' addresses.
130      * @param starbaseTokenAddress Token address.
131      */
132     function setup(address starbaseTokenAddress)
133         external
134         onlyOwner
135         returns (bool)
136     {
137         assert(address(starbaseToken) == 0);
138         starbaseToken = AbstractStarbaseToken(starbaseTokenAddress);
139         return true;
140     }
141 
142     /**
143      * @dev Allows for marketing contributor's reward adding and withdrawl
144      * @param contributorAddress The address of the contributor
145      * @param tokenCount Token number to awarded and to be withdrawn
146      * @param contributionId Id of contribution from bounty app db
147      */
148     function deliverRewardedTokens(
149         address contributorAddress,
150         uint256 tokenCount,
151         string contributionId
152     )
153         external
154         onlyOwner
155         returns(bool)
156     {
157 
158         bytes32 id = keccak256(contributionId);
159 
160         assert(!contributor[contributorAddress].contributions[id]);
161         contributor[contributorAddress].contributions[id] = true;
162 
163         contributor[contributorAddress].rewardedTokens = SafeMath.add(contributor[contributorAddress].rewardedTokens, tokenCount);
164 
165         if (!contributor[contributorAddress].isContributor) {
166             contributor[contributorAddress].isContributor = true;
167             contributors.push(contributorAddress);
168             NewContributor(contributorAddress, tokenCount);
169         }
170 
171         starbaseToken.allocateToMarketingSupporter(contributorAddress, tokenCount);
172         WithdrawContributorsToken(contributorAddress, tokenCount);
173 
174         return true;
175     }
176 
177 
178     /**
179      *  Public Functions
180      */
181 
182     /**
183      * @dev Informs about contributors rewardedTokens and transferredRewardTokens status
184      * @param contributorAddress A contributor's address
185      * @param contributionId Id of contribution from bounty app db
186      */
187     function getContributorInfo(address contributorAddress, string contributionId)
188         constant
189         public
190         returns (uint256, bool, bool)
191     {
192         bytes32 id = keccak256(contributionId);
193 
194         return(
195           contributor[contributorAddress].rewardedTokens,
196           contributor[contributorAddress].contributions[id],
197           contributor[contributorAddress].isContributor
198         );
199     }
200 
201     /**
202      * @dev Returns number of contributors.
203      */
204     function numberOfContributors()
205         constant
206         public
207         returns (uint256)
208     {
209         return contributors.length;
210     }
211 }