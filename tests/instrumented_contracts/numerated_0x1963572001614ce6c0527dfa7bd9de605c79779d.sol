1 pragma solidity ^0.4.19;
2 contract Ownable {
3   address public owner;
4 
5   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
6 
7   /**
8    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
9    * account.
10    */
11   constructor() public {
12     owner = msg.sender;
13   }
14 
15 
16   /**
17    * @dev Throws if called by any account other than the owner.
18    */
19   modifier onlyOwner() {
20     require(msg.sender == owner);
21     _;
22   }
23 
24 
25   /**
26    * @dev Allows the current owner to transfer control of the contract to a newOwner.
27    * @param newOwner The address to transfer ownership to.
28    */
29   function transferOwnership(address newOwner) public onlyOwner {
30     require(newOwner != address(0));
31     emit OwnershipTransferred(owner, newOwner);
32     owner = newOwner;
33   }
34 
35 }
36 /**
37  * @title SafeMath
38  * @dev Math operations with safety checks that throw on error
39  */
40 library SafeMath {
41 
42   /**
43   * @dev Multiplies two numbers, throws on overflow.
44   */
45   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46     if (a == 0) {
47       return 0;
48     }
49     uint256 c = a * b;
50     assert(c / a == b);
51     return c;
52   }
53 
54   /**
55   * @dev Integer division of two numbers, truncating the quotient.
56   */
57   function div(uint256 a, uint256 b) internal pure returns (uint256) {
58     // assert(b > 0); // Solidity automatically throws when dividing by 0
59     uint256 c = a / b;
60     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61     return c;
62   }
63 
64   /**
65   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
66   */
67   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68     assert(b <= a);
69     return a - b;
70   }
71 
72   /**
73   * @dev Adds two numbers, throws on overflow.
74   */
75   function add(uint256 a, uint256 b) internal pure returns (uint256) {
76     uint256 c = a + b;
77     assert(c >= a);
78     return c;
79   }
80 }
81 
82 /**
83  * @title SafeMath32
84  * @dev SafeMath library implemented for uint32
85  */
86 library SafeMath32 {
87 
88   function mul(uint32 a, uint32 b) internal pure returns (uint32) {
89     if (a == 0) {
90       return 0;
91     }
92     uint32 c = a * b;
93     assert(c / a == b);
94     return c;
95   }
96 
97   function div(uint32 a, uint32 b) internal pure returns (uint32) {
98     // assert(b > 0); // Solidity automatically throws when dividing by 0
99     uint32 c = a / b;
100     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
101     return c;
102   }
103 
104   function sub(uint32 a, uint32 b) internal pure returns (uint32) {
105     assert(b <= a);
106     return a - b;
107   }
108 
109   function add(uint32 a, uint32 b) internal pure returns (uint32) {
110     uint32 c = a + b;
111     assert(c >= a);
112     return c;
113   }
114 }
115 
116 /**
117  * @title SafeMath16
118  * @dev SafeMath library implemented for uint16
119  */
120 library SafeMath16 {
121 
122   function mul(uint16 a, uint16 b) internal pure returns (uint16) {
123     if (a == 0) {
124       return 0;
125     }
126     uint16 c = a * b;
127     assert(c / a == b);
128     return c;
129   }
130 
131   function div(uint16 a, uint16 b) internal pure returns (uint16) {
132     // assert(b > 0); // Solidity automatically throws when dividing by 0
133     uint16 c = a / b;
134     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
135     return c;
136   }
137 
138   function sub(uint16 a, uint16 b) internal pure returns (uint16) {
139     assert(b <= a);
140     return a - b;
141   }
142 
143   function add(uint16 a, uint16 b) internal pure returns (uint16) {
144     uint16 c = a + b;
145     assert(c >= a);
146     return c;
147   }
148 }
149 
150 contract ERC721 {
151   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
152   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
153 
154   function balanceOf(address _owner) public view returns (uint256 _balance);
155   function ownerOf(uint256 _tokenId) public view returns (address _owner);
156   function transfer(address _to, uint256 _tokenId) public;
157   function approve(address _to, uint256 _tokenId) public;
158   function takeOwnership(uint256 _tokenId) public;
159 }
160 contract PreSell is Ownable,ERC721{
161     using SafeMath for uint256;
162     struct Coach{
163         uint256 drawPrice;
164         uint256 emoteRate;
165         uint256 sellPrice;
166         uint8   isSell;
167         uint8   category;
168     }
169     event initialcoach(uint _id);
170     event drawcoach(uint _id,address _owner);
171     event purChase(uint _id, address _newowner, address _oldowner);
172     event inviteCoachBack(address _from,address _to, uint _fee);
173     Coach[] public originCoach;
174     Coach[] public coaches; 
175     mapping(uint=>address) coachToOwner;
176     mapping(uint=>uint) public coachAllnums;
177     mapping(address=>uint) ownerCoachCount;
178     mapping (uint => address) coachApprovals;
179     //modifier
180     modifier onlyOwnerOf(uint _id) {
181         require(msg.sender == coachToOwner[_id]);
182         _;
183     }
184     //owner draw _money
185     function withdraw() external onlyOwner {
186         owner.transfer(address(this).balance);
187     }
188     //initial coach and coach nums;
189     function initialCoach(uint _price,uint _emoterate,uint8 _category,uint _num) public onlyOwner{ 
190       uint id = originCoach.push(Coach(_price,_emoterate,0,0,_category)) - 1;
191       coachAllnums[id] = _num;
192       emit initialcoach(id);
193     }
194     function drawCoach(uint _id,address _address) public payable{ 
195         require(msg.value == originCoach[_id].drawPrice && coachAllnums[_id] > 0 );
196         uint id = coaches.push(originCoach[_id]) -1;
197         coachToOwner[id] = msg.sender;
198         ownerCoachCount[msg.sender] = ownerCoachCount[msg.sender].add(1);
199         coachAllnums[_id]  = coachAllnums[_id].sub(1);
200         if(_address != 0){ 
201                  uint inviteFee = msg.value * 5 / 100;
202                  _address.transfer(inviteFee);
203                  emit inviteCoachBack(msg.sender,_address,inviteFee);
204         }
205         emit drawcoach(_id,msg.sender);
206     }
207      //ERC721 functions;
208     function balanceOf(address _owner) public view returns (uint256 _balance) {
209         return ownerCoachCount[_owner];
210     }
211 
212     function ownerOf(uint256 _tokenId) public view returns (address _owner) {
213         return coachToOwner[_tokenId];
214     }
215     function _transfer(address _from, address _to, uint256 _tokenId) private {
216         require(_to != _from);
217         ownerCoachCount[_to] = ownerCoachCount[_to].add(1) ;
218         ownerCoachCount[_from] = ownerCoachCount[_from].sub(1);
219         coachToOwner[_tokenId] = _to;
220         emit Transfer(_from, _to, _tokenId);
221     }
222     function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
223         _transfer(msg.sender, _to, _tokenId);
224     }
225 
226     function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
227         coachApprovals[_tokenId] = _to;
228         emit Approval(msg.sender, _to, _tokenId);
229     }
230     function takeOwnership(uint256 _tokenId) public {
231         require(coachApprovals[_tokenId] == msg.sender && coachToOwner[_tokenId] != msg.sender);
232         address owner = ownerOf(_tokenId);
233         _transfer(owner, msg.sender, _tokenId);
234     }
235     //market functions
236         //market functions
237     function setCoachPrice(uint _id,uint _price) public onlyOwnerOf(_id){ 
238         coaches[_id].isSell = 1;
239         coaches[_id].sellPrice = _price;
240     }
241     function coachTakeOff(uint _id) public onlyOwnerOf(_id){
242         coaches[_id].isSell = 0;
243     }
244     function purchase(uint _id) public payable{
245         require(coaches[_id].isSell == 1 && msg.value == coaches[_id].sellPrice && msg.sender != coachToOwner[_id]);
246         address owner = coachToOwner[_id];
247         ownerCoachCount[owner] = ownerCoachCount[owner].sub(1) ;
248         ownerCoachCount[msg.sender] = ownerCoachCount[msg.sender].add(1);
249         coachToOwner[_id] = msg.sender;
250         owner.transfer(msg.value);
251         emit purChase(_id,msg.sender,owner);
252     }
253     
254 }