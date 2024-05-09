1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() public {
15     owner = msg.sender;
16   }
17 
18   /**
19    * @dev Throws if called by any account other than the owner.
20    */
21   modifier onlyOwner() {
22     require(msg.sender == owner);
23     _;
24   }
25 
26   /**
27    * @dev Allows the current owner to transfer control of the contract to a newOwner.
28    * @param newOwner The address to transfer ownership to.
29    */
30   function transferOwnership(address newOwner) public onlyOwner {
31     require(newOwner != address(0));
32     emit OwnershipTransferred(owner, newOwner);
33     owner = newOwner;
34   }
35 
36 }
37 
38 library SafeMath {
39 
40   /**
41   * @dev Multiplies two numbers, throws on overflow.
42   */
43   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
44     if (a == 0) {
45       return 0;
46     }
47     uint256 c = a * b;
48     assert(c / a == b);
49     return c;
50   }
51 
52   /**
53   * @dev Integer division of two numbers, truncating the quotient.
54   */
55   function div(uint256 a, uint256 b) internal pure returns (uint256) {
56     // assert(b > 0); // Solidity automatically throws when dividing by 0
57     uint256 c = a / b;
58     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59     return c;
60   }
61 
62   /**
63   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
64   */
65   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66     assert(b <= a);
67     return a - b;
68   }
69 
70   /**
71   * @dev Adds two numbers, throws on overflow.
72   */
73   function add(uint256 a, uint256 b) internal pure returns (uint256) {
74     uint256 c = a + b;
75     assert(c >= a);
76     return c;
77   }
78 }
79 
80 contract Distribution is Ownable {
81     using SafeMath for uint256;
82 
83     struct Recipient {
84         address addr;
85         uint256 share;
86         uint256 balance;
87         uint256 received;
88     }
89 
90     uint256 sharesSum;
91     uint8 constant maxRecsAmount = 12;
92     mapping(address => Recipient) public recs;
93     address[maxRecsAmount] public recsLookUpTable; //to iterate
94 
95     event Payment(address indexed to, uint256 value);
96     event AddShare(address to, uint256 value);
97     event ChangeShare(address to, uint256 value);
98     event DeleteShare(address to);
99     event ChangeAddessShare(address newAddress);
100     event FoundsReceived(uint256 value);
101 
102     function Distribution() public {
103         sharesSum = 0;
104     }
105 
106     function receiveFunds() public payable {
107         emit FoundsReceived(msg.value);
108         for (uint8 i = 0; i < maxRecsAmount; i++) {
109             Recipient storage rec = recs[recsLookUpTable[i]];
110             uint ethAmount = (rec.share.mul(msg.value)).div(sharesSum);
111             rec.balance = rec.balance + ethAmount;
112         }
113     }
114 
115     modifier onlyMembers(){
116         require(recs[msg.sender].addr != address(0));
117         _;
118     }
119 
120     function doPayments() public {
121         Recipient storage rec = recs[msg.sender];
122         require(rec.balance >= 1e12);
123         rec.addr.transfer(rec.balance);
124         emit Payment(rec.addr, rec.balance);
125         rec.received = (rec.received).add(rec.balance);
126         rec.balance = 0;
127     }
128 
129     function addShare(address _rec, uint256 share) public onlyOwner {
130         require(_rec != address(0));
131         require(share > 0);
132         require(recs[_rec].addr == address(0));
133         recs[_rec].addr = _rec;
134         recs[_rec].share = share;
135         recs[_rec].received = 0;
136         for(uint8 i = 0; i < maxRecsAmount; i++ ) {
137             if (recsLookUpTable[i] == address(0)) {
138                 recsLookUpTable[i] = _rec;
139                 break;
140             }
141         }
142         sharesSum = sharesSum.add(share);
143         emit AddShare(_rec, share);
144     }
145 
146     function changeShare(address _rec, uint share) public onlyOwner {
147         require(_rec != address(0));
148         require(share > 0);
149         require(recs[_rec].addr != address(0));
150         Recipient storage rec = recs[_rec];
151         sharesSum = sharesSum.sub(rec.share).add(share);
152         rec.share = share;
153         emit ChangeShare(_rec, share);
154     }
155 
156     function deleteShare(address _rec) public onlyOwner {
157         require(_rec != address(0));
158         require(recs[_rec].addr != address(0));
159         sharesSum = sharesSum.sub(recs[_rec].share);
160         for(uint8 i = 0; i < maxRecsAmount; i++ ) {
161             if (recsLookUpTable[i] == recs[_rec].addr) {
162                 recsLookUpTable[i] = address(0);
163                 break;
164             }
165         }
166         delete recs[_rec];
167         emit DeleteShare(msg.sender);
168     }
169 
170     function changeRecipientAddress(address _newRec) public {
171         require(msg.sender != address(0));
172         require(_newRec != address(0));
173         require(recs[msg.sender].addr != address(0));
174         require(recs[_newRec].addr == address(0));
175         require(recs[msg.sender].addr != _newRec);
176 
177         Recipient storage rec = recs[msg.sender];
178         uint256 prevBalance = rec.balance;
179         addShare(_newRec, rec.share);
180         emit ChangeAddessShare(_newRec);
181         deleteShare(msg.sender);
182         recs[_newRec].balance = prevBalance;
183         emit DeleteShare(msg.sender);
184 
185     }
186 
187     function getMyBalance() public view returns(uint256) {
188         return recs[msg.sender].balance;
189     }
190 }