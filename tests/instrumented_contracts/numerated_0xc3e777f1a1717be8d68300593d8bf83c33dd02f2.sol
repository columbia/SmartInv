1 pragma solidity >=0.5.0 <0.6.0;
2 
3 /* HEY WELCOME TO MyEther.DATE's OFFICIAL SMART CONTRACT!
4 
5     My name is Tay Tay and I will help you digest the material of this contract, 
6     all in layman's terms. 
7      
8 
9 */
10 
11 contract myEtherDate {
12     
13     struct Player {
14         uint commitBlock;
15         uint stake;
16     }
17     
18     mapping(address => Player) public player;
19     uint public maxStake;
20     address public owner;
21     
22     modifier onlyOwner() {
23         require(msg.sender == owner);
24         _;
25     }
26     
27     constructor() public {
28         owner = msg.sender;
29     }
30     
31     /* Here is where the fun begins. When you materialize your 4 dates, all
32     * the contract really cares is WHEN you did it and how big was your stake.
33     * so yeah, sorry to burst the bubble but the matchmaking has nothing to do
34     * with the outcome of your bet. 
35     */ 
36     function set() 
37         public
38         payable
39         returns (bool success)
40     {
41         // this is to make sure our bankroll can cover the maximum payout 
42         // for your stake and also to make sure your stake is greater than zero. 
43         require(msg.value > 0 && msg.value <= maxStake);
44         
45         // Since future hashes are quite hard to predict, 
46         // your random seed will be the hash of the next block
47         player[msg.sender].commitBlock = block.number + 1;
48         player[msg.sender].stake = msg.value;
49         
50         return true;
51     }  
52     
53     /* RANDOM NUMBER GENERATION function 
54     *
55     *  This is pretty much a copy-paste of cryptokitties gene science algorithm but
56     *  tailored to our specific purposes.
57     *
58     *  This function is public (gas-free) so it is called by MyEther.DATE's interface on behalf 
59     *  of the user, automatically, as soon as random numbers are available.
60     *
61     *  The interface will then interpret these random numbers and tell the player if he won or not.
62     *  If he won, it is up to him to call the "claim" function. 
63     *
64     */
65     function getRand() 
66         view
67         public
68         returns (uint[4] memory) 
69     {
70         // convert our "pseudo-random" hash to human-redeable integers
71         uint256 randomN = uint256(blockhash(player[msg.sender].commitBlock));
72       
73         // this function will not work if it is called to soon 
74         // (like right after the bet was placed, because the hash for the next block is not yet available), 
75         // or too late (256+ blocks after the bet was placed, because the etheruem blockchain 
76         // only stores the most recent 256 block hashes) 
77         require(randomN != 0);
78 
79         uint256 offset;
80         uint[4] memory randNums;
81         
82         // this loop will slice our random number into 4 smaller numbers,
83         // each one from 0 to 65535
84         for(uint i = 0; i < 4; i++){
85             randNums[i] = _sliceNumber(randomN, 16, offset);  
86             offset += 32;    
87         }
88         
89         // return our 4 random numbers
90         return randNums;
91     }
92     
93     /*  CLAIM function
94     *   
95     *   This function can be evoked by anybody, but it will only payout ether to actual
96     *   winners. 
97     *
98     */
99     function claim()
100         public
101         payable
102         returns (bool success)
103     {
104         uint[4] memory rand = getRand();
105         player[msg.sender].commitBlock = 0;
106         uint256 stake = player[msg.sender].stake;
107         player[msg.sender].stake = 0;
108         
109         uint256 successfulDate;
110         
111         // you get 4 random numbers for 4 date outcomes..
112         // To get a successful date, any of your random numbers must be less than 8110
113         // and since they range from 0 to 65536, you have a winning probability 
114         // of 0.12375 on each date
115         for (uint i = 0; i < 4; i++) {
116             if (rand[i] < 8110) 
117                 successfulDate++;
118         }
119         
120         if (successfulDate != 0) {
121             // for each successful date, we double your stake, 
122             // this equals a 1% edge...
123             uint256 payout = SafeMath.mul(stake, 2);
124             payout = SafeMath.mul(payout, successfulDate);
125             msg.sender.transfer(payout);
126             updateMaxStake();
127         }
128 
129         return true;
130     }
131     
132     /// @dev given a number get a slice of any bits, at certain offset
133     /// @param _n a number to be sliced
134     /// @param _nbits how many bits long is the new number
135     /// @param _offset how many bits to skip
136     function _sliceNumber(uint256 _n, uint256 _nbits, uint256 _offset) 
137         private 
138         pure 
139         returns (uint256) 
140     {
141         // mask is made by shifting left an offset number of times
142         uint256 mask = uint256((2**_nbits) - 1) << _offset;
143         // AND n with mask, and trim to max of _nbits bits
144         return uint256((_n & mask) >> _offset);
145     }
146     
147     function fundBankroll()
148         public
149         payable
150         returns(bool success)
151     {
152         updateMaxStake();
153         return true;
154     }
155     
156     function updateMaxStake()
157         public
158         returns (bool success)
159     {
160         uint256 newMax = SafeMath.div(address(this).balance, 8);
161         maxStake = newMax;
162         return true;
163     }
164         
165     function collect(uint256 ammount)
166         public
167         onlyOwner
168         returns (bool success)
169     {
170         msg.sender.transfer(ammount);
171         updateMaxStake();
172         return true;
173     }
174     
175     function transferOwnership(address newOwner) 
176         public
177         onlyOwner
178     {
179         if (newOwner != address(0)) {
180             owner = newOwner;
181         }
182     }
183     
184 }
185 
186     /**
187  * @title SafeMath
188  * @dev Unsigned math operations with safety checks that revert on error
189  */
190 library SafeMath {
191     /**
192      * @dev Multiplies two unsigned integers, reverts on overflow.
193      */
194     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
195         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
196         // benefit is lost if 'b' is also tested.
197         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
198         if (a == 0) {
199             return 0;
200         }
201 
202         uint256 c = a * b;
203         require(c / a == b);
204 
205         return c;
206     }
207 
208     /**
209      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
210      */
211     function div(uint256 a, uint256 b) internal pure returns (uint256) {
212         // Solidity only automatically asserts when dividing by 0
213         require(b > 0);
214         uint256 c = a / b;
215         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
216 
217         return c;
218     }
219 
220     /**
221      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
222      */
223     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
224         require(b <= a);
225         uint256 c = a - b;
226 
227         return c;
228     }
229 
230     /**
231      * @dev Adds two unsigned integers, reverts on overflow.
232      */
233     function add(uint256 a, uint256 b) internal pure returns (uint256) {
234         uint256 c = a + b;
235         require(c >= a);
236 
237         return c;
238     }
239 
240     /**
241      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
242      * reverts when dividing by zero.
243      */
244     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
245         require(b != 0);
246         return a % b;
247     }
248 }