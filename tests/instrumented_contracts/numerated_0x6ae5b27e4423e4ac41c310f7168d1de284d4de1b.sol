1 pragma solidity ^0.4.21;
2 
3 // Contract for Auction of the starship Astra Kal
4 library SafeMath {
5 
6   /**
7   * @dev Multiplies two numbers, throws on overflow.
8   */
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   /**
19   * @dev Integer division of two numbers, truncating the quotient.
20   */
21   function div(uint256 a, uint256 b) internal pure returns (uint256) {
22     // assert(b > 0); // Solidity automatically throws when dividing by 0
23     uint256 c = a / b;
24     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25     return c;
26   }
27 
28   /**
29   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
30   */
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   /**
37   * @dev Adds two numbers, throws on overflow.
38   */
39   function add(uint256 a, uint256 b) internal pure returns (uint256) {
40     uint256 c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 }
45 
46 
47 // This is an interface which creates a symbol for the starships ERC721 contracts. 
48 // The ERC721 contracts will be published later, before the auction ends.  
49 
50 contract starShipTokenInterface {
51     string public name;
52     string public symbol;
53     uint256 public ID;
54     address public owner;
55 
56     function transfer(address _to) public returns (bool success);
57     
58     event Transfer(address indexed _from, address indexed _to);
59 }
60 
61 
62 contract starShipToken is starShipTokenInterface {
63     using SafeMath for uint256;
64 
65   
66   constructor(string _name, string _symbol, uint256 _ID) public {
67     name = _name;
68     symbol = _symbol;
69     ID = _ID;
70     owner = msg.sender;
71   }
72 
73   /**
74   * @dev Gets the owner of the token.
75   * @return An uint256 representing the amount owned by the passed address.
76   */
77   function viewOwner() public view returns (address) {
78     return owner;
79   }
80 
81   /**
82   * @dev transfer token for a specified address
83   * @param _to The address to transfer to.
84   */
85   function transfer(address _to) public returns (bool) {
86     require(_to != address(0));
87     require(msg.sender == owner);
88 
89     owner = _to;
90     emit Transfer(msg.sender, _to);
91     return true;
92   }
93 }
94 
95 // contract for implementing the auction in Hot Potato format
96 contract hotPotatoAuction {
97     // The token that is going up for auction
98     starShipToken public token;
99     
100     // The total number of bids on the current starship
101     uint256 public totalBids;
102     
103     // starting bid of the starship
104     uint256 public startingPrice;
105     
106     // current Bid amount
107     uint256 public currentBid;
108     
109     // Minimum amount needed to bid on this item
110     uint256 public currentMinBid;
111     
112     // The time at which the auction will end
113     uint256 public auctionEnd;
114     
115     // Variable to store the hot Potato prize for the loser bid
116     uint256 public hotPotatoPrize;
117     
118     // The seller of the current item
119     address public seller;
120     
121     
122     address public highBidder;
123     address public loser;
124 
125     function hotPotatoAuction(
126         starShipToken _token,
127         uint256 _startingPrice,
128         uint256 _auctionEnd
129     )
130         public
131     {
132         token = _token;
133         startingPrice = _startingPrice;
134         currentMinBid = _startingPrice;
135         totalBids = 0;
136         seller = msg.sender;
137         auctionEnd = _auctionEnd;
138         hotPotatoPrize = _startingPrice;
139         currentBid = 0;
140     }
141     
142     mapping(address => uint256) public balanceOf;
143 
144     /** 
145      *  @dev withdrawBalance from the contract address
146      *  @param amount that you want to withdrawBalance
147      * 
148      */
149      
150     function withdrawBalance(uint256 amount) returns(bool) {
151         require(amount <= address(this).balance);
152         require (msg.sender == seller);
153         seller.transfer(amount);
154         return true;
155     }
156 
157     /** 
158      *  @dev withdraw from the Balance array
159      * 
160      */
161     function withdraw() public returns(bool) {
162         require(msg.sender != highBidder);
163         
164         uint256 amount = balanceOf[loser];
165         balanceOf[loser] = 0;
166         loser.transfer(amount);
167         return true;
168     }
169     
170 
171     event Bid(address highBidder, uint256 highBid);
172 
173     function bid() public payable returns(bool) {
174         require(now < auctionEnd);
175         require(msg.value >= startingPrice);
176         require (msg.value >= currentMinBid);
177         
178         if(totalBids !=0)
179         {
180             loser = highBidder;
181         
182             require(withdraw());
183         }
184         
185         highBidder = msg.sender;
186         
187         currentBid = msg.value;
188         
189         hotPotatoPrize = currentBid/20;
190         
191         balanceOf[msg.sender] = msg.value + hotPotatoPrize;
192         
193         if(currentBid < 1000000000000000000)
194         {
195             currentMinBid = msg.value + currentBid/2;
196             hotPotatoPrize = currentBid/20; 
197         }
198         else
199         {
200             currentMinBid = msg.value + currentBid/5;
201             hotPotatoPrize = currentBid/20;
202         }
203         
204         totalBids = totalBids + 1;
205         
206         return true;
207         emit Bid(highBidder, msg.value);
208     }
209 
210     function resolve() public {
211         require(now >= auctionEnd);
212         require(msg.sender == seller);
213         require (highBidder != 0);
214         
215         require (token.transfer(highBidder));
216 
217         balanceOf[seller] += balanceOf[highBidder];
218         balanceOf[highBidder] = 0;
219         highBidder = 0;
220     }
221     /** 
222      *  @dev view balance of contract
223      */
224      
225     function getBalanceContract() constant returns(uint){
226         return address(this).balance;
227     }
228 }