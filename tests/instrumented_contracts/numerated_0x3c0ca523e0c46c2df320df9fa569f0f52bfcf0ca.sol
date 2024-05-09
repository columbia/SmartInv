1 // loosely based on Bryn Bellomy code
2 // https://medium.com/@bryn.bellomy/solidity-tutorial-building-a-simple-auction-contract-fcc918b0878a
3 //
4 // updated to 0.4.25 standard, replaced blocks with time, converted to hot potato style by Chibi Fighters
5 // you are free to use the code but please give Chibi Fighters credits
6 // https://chibifighters.io
7 //
8 
9 pragma solidity ^0.4.25;
10 
11 /**
12 * @title SafeMath
13 * @dev Math operations with safety checks that throw on error
14 */
15 library SafeMath {
16 
17     /**
18     * @dev Multiplies two numbers, throws on overflow.
19     */
20     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21         if (a == 0) {
22             return 0;
23         }
24         uint256 c = a * b;
25         assert(c / a == b);
26         return c;
27     }
28 
29     /**
30     * @dev Integer division of two numbers, truncating the quotient.
31     */
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         // assert(b > 0); // Solidity automatically throws when dividing by 0
34         uint256 c = a / b;
35         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36         return c;
37     }
38 
39     /**
40     * @dev Substracts two numbers, returns 0 if it would go into minus range.
41     */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         if (b >= a) {
44             return 0;
45         }
46         return a - b;
47     }
48 
49     /**
50     * @dev Adds two numbers, throws on overflow.
51     */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         assert(c >= a);
55         return c;
56     }
57 }
58 
59 contract AuctionPotato {
60     using SafeMath for uint256; 
61     // static
62     address public owner;
63     uint public startTime;
64     uint public endTime;
65     string name;
66     
67     // pototo
68     uint public potato;
69     uint oldPotato;
70     uint oldHighestBindingBid;
71     
72     // state
73     bool public canceled;
74     
75     uint public highestBindingBid;
76     address public highestBidder;
77     
78     // used to immidiately block placeBids
79     bool blockerPay;
80     bool blockerWithdraw;
81     
82     mapping(address => uint256) public fundsByBidder;
83     bool ownerHasWithdrawn;
84 
85     event LogBid(address bidder, address highestBidder, uint oldHighestBindingBid, uint highestBindingBid);
86     event LogWithdrawal(address withdrawer, address withdrawalAccount, uint amount);
87     event LogCanceled();
88     
89     
90     // initial settings on contract creation
91     constructor() public {
92         
93         blockerWithdraw = false;
94         blockerPay = false;
95         
96         owner = msg.sender;
97 
98         // 0.003 ETH
99         highestBindingBid = 3000000000000000;
100         potato = 0;
101         
102         // 2018-10-30 18:00:00
103         startTime = 1540922400;
104         endTime = startTime + 3 hours;
105 
106         name = "Pumpkinhead 3";
107 
108     }
109     
110     function setStartTime(uint _time) onlyOwner public 
111     {
112         require(now < startTime);
113         startTime = _time;
114         endTime = startTime + 3 hours;
115     }
116 
117 
118     // calculates the next bid amount to you can have a oneclick buy button
119     function nextBid() public view returns (uint _nextBid) {
120         return highestBindingBid.add(potato);
121     }
122     
123     
124     // calculates the bid after the current bid so nifty hackers can skip the queue
125     // this is not in our frontend and no one knows if it actually works
126     function nextNextBid() public view returns (uint _nextBid) {
127         return highestBindingBid.add(potato).add((highestBindingBid.add(potato)).mul(4).div(9));
128     }
129     
130     
131     function queryAuction() public view returns (string, uint, address, uint, uint, uint)
132     {
133         
134         return (name, nextBid(), highestBidder, highestBindingBid, startTime, endTime);
135         
136     }
137 
138 
139     function placeBid() public
140         payable
141         onlyAfterStart
142         onlyBeforeEnd
143         onlyNotCanceled
144         onlyNotOwner
145         returns (bool success)
146     {   
147         // we are only allowing to increase in bidIncrements to make for true hot potato style
148         require(msg.value == highestBindingBid.add(potato));
149         require(msg.sender != highestBidder);
150         require(now > startTime);
151         require(blockerPay == false);
152         blockerPay = true;
153         
154         // calculate the user's total bid based on the current amount they've sent to the contract
155         // plus whatever has been sent with this transaction
156 
157         fundsByBidder[msg.sender] = fundsByBidder[msg.sender].add(highestBindingBid);
158         fundsByBidder[highestBidder] = fundsByBidder[highestBidder].add(potato);
159 
160         highestBidder.transfer(fundsByBidder[highestBidder]);
161         fundsByBidder[highestBidder] = 0;
162         
163         oldHighestBindingBid = highestBindingBid;
164         
165         // set new highest bidder
166         highestBidder = msg.sender;
167         highestBindingBid = highestBindingBid.add(potato);
168 
169         oldPotato = potato;
170         potato = highestBindingBid.mul(4).div(9);
171         
172         emit LogBid(msg.sender, highestBidder, oldHighestBindingBid, highestBindingBid);
173         blockerPay = false;
174         return true;
175     }
176 
177     function cancelAuction() public
178         onlyOwner
179         onlyBeforeEnd
180         onlyNotCanceled
181         returns (bool success)
182     {
183         canceled = true;
184         emit LogCanceled();
185         return true;
186     }
187 
188     function withdraw() public onlyOwner returns (bool success) 
189     {
190         require(now > endTime);
191         
192         msg.sender.transfer(address(this).balance);
193         
194         return true;
195     }
196     
197     
198     function balance() public view returns (uint _balance) {
199         return address(this).balance;
200     }
201 
202     modifier onlyOwner {
203         require(msg.sender == owner);
204         _;
205     }
206 
207     modifier onlyNotOwner {
208         require(msg.sender != owner);
209         _;
210     }
211 
212     modifier onlyAfterStart {
213         if (now < startTime) revert();
214         _;
215     }
216 
217     modifier onlyBeforeEnd {
218         if (now > endTime) revert();
219         _;
220     }
221 
222     modifier onlyNotCanceled {
223         if (canceled) revert();
224         _;
225     }
226     
227 }