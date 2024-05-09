1 pragma solidity ^0.4.18;
2 
3 /// candy.claims
4 
5 contract CandyClaim {
6   /*** CONSTANTS ***/
7   uint256 private fiveHoursInSeconds = 3600; // 18000;
8   string public constant NAME = "CandyClaims";
9   string public constant SYMBOL = "CandyClaim";
10 
11   /*** STORAGE ***/
12   mapping (address => uint256) private ownerCount;
13 
14   address public ceoAddress;
15   address public cooAddress;
16 
17   struct Candy {
18     address owner;
19     uint256 price;
20     uint256 last_transaction;
21     address approve_transfer_to;
22   }
23   uint candy_count;
24   mapping (string => Candy) candies;
25 
26   /*** ACCESS MODIFIERS ***/
27   modifier onlyCEO() { require(msg.sender == ceoAddress); _; }
28   modifier onlyCOO() { require(msg.sender == cooAddress); _; }
29   modifier onlyCXX() { require(msg.sender == ceoAddress || msg.sender == cooAddress); _; }
30 
31   /*** ACCESS MODIFIES ***/
32   function setCEO(address _newCEO) public onlyCEO {
33     require(_newCEO != address(0));
34     ceoAddress = _newCEO;
35   }
36   function setCOO(address _newCOO) public onlyCEO {
37     require(_newCOO != address(0));
38     cooAddress = _newCOO;
39   }
40 
41   /*** DEFAULT METHODS ***/
42   function symbol() public pure returns (string) { return SYMBOL; }
43   function name() public pure returns (string) { return NAME; }
44   function implementsERC721() public pure returns (bool) { return true; }
45 
46   /*** CONSTRUCTOR ***/
47   function CandyClaim() public {
48     ceoAddress = msg.sender;
49     cooAddress = msg.sender;
50   }
51 
52   /*** INTERFACE METHODS ***/
53   function createCandy(string _candy_id, uint256 _price) public onlyCXX {
54     require(msg.sender != address(0));
55     _create_candy(_candy_id, address(this), _price);
56   }
57 
58   function totalSupply() public view returns (uint256 total) {
59     return candy_count;
60   }
61 
62   function balanceOf(address _owner) public view returns (uint256 balance) {
63     return ownerCount[_owner];
64   }
65   function priceOf(string _candy_id) public view returns (uint256 price) {
66     return candies[_candy_id].price;
67   }
68 
69   function getCandy(string _candy_id) public view returns (
70     string id,
71     address owner,
72     uint256 price,
73     uint256 last_transaction
74   ) {
75     id = _candy_id;
76     owner = candies[_candy_id].owner;
77     price = candies[_candy_id].price;
78     last_transaction = candies[_candy_id].last_transaction;
79   }
80 
81   function purchase(string _candy_id) public payable {
82     Candy storage candy = candies[_candy_id];
83 
84     require(candy.owner != msg.sender);
85     require(msg.sender != address(0));
86 
87     uint256 time_diff = (block.timestamp - candy.last_transaction);
88     while(time_diff >= fiveHoursInSeconds){
89         time_diff = (time_diff - fiveHoursInSeconds);
90         candy.price = SafeMath.mul(SafeMath.div(candy.price, 100), 90);
91     }
92     if(candy.price < 1000000000000000){ candy.price = 1000000000000000; }
93     require(msg.value >= candy.price);
94 
95     uint256 excess = SafeMath.sub(msg.value, candy.price);
96 
97     if(candy.owner == address(this)){
98       ceoAddress.transfer(candy.price);
99     } else {
100       ceoAddress.transfer(uint256(SafeMath.mul(SafeMath.div(candy.price, 100), 10)));
101       candy.owner.transfer(uint256(SafeMath.mul(SafeMath.div(candy.price, 100), 90)));
102     }
103 
104     candy.price = SafeMath.mul(SafeMath.div(candy.price, 100), 160);
105     candy.owner = msg.sender;
106     candy.last_transaction = block.timestamp;
107 
108     msg.sender.transfer(excess);
109   }
110 
111   function payout() public onlyCEO {
112     ceoAddress.transfer(this.balance);
113   }
114 
115   /*** PRIVATE METHODS ***/
116 
117   function _create_candy(string _candy_id, address _owner, uint256 _price) private {
118     candy_count++;
119     candies[_candy_id] = Candy({
120       owner: _owner,
121       price: _price,
122       last_transaction: block.timestamp,
123       approve_transfer_to: address(0)
124     });
125   }
126 
127   function _transfer(address _from, address _to, string _candy_id) private {
128     candies[_candy_id].owner = _to;
129     candies[_candy_id].approve_transfer_to = address(0);
130     ownerCount[_from] -= 1;
131     ownerCount[_to] += 1;
132   }
133 }
134 
135 library SafeMath {
136   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
137     if (a == 0) {
138       return 0;
139     }
140     uint256 c = a * b;
141     assert(c / a == b);
142     return c;
143   }
144   function div(uint256 a, uint256 b) internal pure returns (uint256) {
145     uint256 c = a / b;
146     return c;
147   }
148   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
149     assert(b <= a);
150     return a - b;
151   }
152   function add(uint256 a, uint256 b) internal pure returns (uint256) {
153     uint256 c = a + b;
154     assert(c >= a);
155     return c;
156   }
157 }