1 pragma solidity ^0.4.21;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     if (a == 0) {
16       return 0;
17     }
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64 
65   /**
66    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
67    * account.
68    */
69   function Ownable() public {
70     owner = msg.sender;
71   }
72 
73   /**
74    * @dev Throws if called by any account other than the owner.
75    */
76   modifier onlyOwner() {
77     require(msg.sender == owner);
78     _;
79   }
80 
81   /**
82    * @dev Allows the current owner to transfer control of the contract to a newOwner.
83    * @param newOwner The address to transfer ownership to.
84    */
85   function transferOwnership(address newOwner) public onlyOwner {
86     require(newOwner != address(0));
87     emit OwnershipTransferred(owner, newOwner);
88     owner = newOwner;
89   }
90 
91 }
92 
93 // File: contracts/InstantListingV2.sol
94 
95 contract InstantListingV2 is Ownable {
96     using SafeMath for uint256;
97 
98     struct Proposal {
99         address tokenAddress;
100         string projectName;
101         string websiteUrl;
102         string logoUrl;
103         string whitepaperUrl;
104         string legalDocumentUrl;
105         uint256 icoStartDate;
106         uint256 icoEndDate;
107         uint256 icoRate; // If 4000 COB = 1 ETH, then icoRate = 4000.
108         uint256 totalRaised;
109     }
110 
111     struct ProposalInfo {
112         uint256 totalContributions;
113         address sender;
114         uint256 round;
115     }
116 
117     // Round number
118     uint256 public round;
119 
120     // The address of beneficiary.
121     address public beneficiary;
122 
123     // Proposals.
124     mapping(uint256 => mapping(address => Proposal)) public proposals;
125 
126     // Mapping of tokenAddress to ProposalInfo
127     mapping(address => ProposalInfo) public proposalInfos;
128 
129     // Contribution of each round.
130     mapping(uint256 => uint256) public roundContribution;
131 
132     // A mapping from token contract address to the last refundable unix
133     // timestamp, 0 means not refundable.
134     mapping(address => uint256) public refundable;
135 
136     // Configs.
137     uint256 public startTime;
138     uint256 public hardCap;
139     uint256 public duration;
140 
141     // Events.
142     event TokenListed(uint256 indexed _round, address _tokenAddress);
143     event TokenListingCancelled(address _tokenAddress);
144     event RoundFinalized(uint256 _round);
145 
146     constructor() public {
147     }
148 
149     function getCurrentTimestamp() internal view returns (uint256) {
150         return now;
151     }
152 
153     function initialize(address _beneficiary) onlyOwner public {
154         beneficiary = _beneficiary;
155     }
156 
157     function reset(
158         uint256 _startTime,
159         uint256 _duration,
160         uint256 _hardCap)
161         onlyOwner public {
162         require(getCurrentTimestamp() >= startTime + duration);
163 
164         // Transfer all balance except for latest round,
165         // which is reserved for refund.
166         if (round > 0) {
167             beneficiary.transfer(address(this).balance - roundContribution[round]);
168         }
169 
170         startTime = _startTime;
171         duration = _duration;
172         hardCap = _hardCap;
173 
174         emit RoundFinalized(round);
175         round += 1;
176     }
177 
178     function propose(
179         address _tokenAddress,
180         string _projectName,
181         string _websiteUrl,
182         string _logoUrl,
183         string _whitepaperUrl,
184         string _legalDocumentUrl,
185         uint256 _icoStartDate,
186         uint256 _icoEndDate,
187         uint256 _icoRate,
188         uint256 _totalRaised) public payable {
189 
190         require(proposalInfos[_tokenAddress].totalContributions == 0);
191         require(getCurrentTimestamp() < startTime + duration);
192         require(msg.value >= hardCap);
193 
194         proposals[round][_tokenAddress] = Proposal({
195             tokenAddress: _tokenAddress,
196             projectName: _projectName,
197             websiteUrl: _websiteUrl,
198             logoUrl: _logoUrl,
199             whitepaperUrl: _whitepaperUrl,
200             legalDocumentUrl: _legalDocumentUrl,
201             icoStartDate: _icoStartDate,
202             icoEndDate: _icoEndDate,
203             icoRate: _icoRate,
204             totalRaised: _totalRaised
205         });
206 
207         proposalInfos[_tokenAddress] = ProposalInfo({
208             totalContributions: msg.value,
209             sender: msg.sender,
210             round: round
211         });
212 
213         roundContribution[round] = roundContribution[round].add(msg.value);
214         emit TokenListed(round, _tokenAddress);
215     }
216 
217     function setRefundable(address _tokenAddress, uint256 endTime)
218         onlyOwner public {
219         refundable[_tokenAddress] = endTime;
220     }
221 
222     function refund(address _tokenAddress) public {
223         require(refundable[_tokenAddress] > 0 &&
224                 getCurrentTimestamp() < refundable[_tokenAddress]);
225 
226         uint256 value = proposalInfos[_tokenAddress].totalContributions;
227         proposalInfos[_tokenAddress].totalContributions = 0;
228         roundContribution[proposalInfos[_tokenAddress].round] =
229             roundContribution[proposalInfos[_tokenAddress].round].sub(value);
230         proposalInfos[_tokenAddress].sender.transfer(value);
231 
232         emit TokenListingCancelled(_tokenAddress);
233     }
234 
235     function getContributions(address _tokenAddress)
236         view public returns (uint256) {
237         return proposalInfos[_tokenAddress].totalContributions;
238     }
239 
240     function kill() public onlyOwner {
241         selfdestruct(beneficiary);
242     }
243 
244     function () public payable {
245         revert();
246     }
247 }