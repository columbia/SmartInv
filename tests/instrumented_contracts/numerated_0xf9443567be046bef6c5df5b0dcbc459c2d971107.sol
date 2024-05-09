1 pragma solidity 0.4.25;
2 contract SafeMath {
3     uint256 constant public MAX_UINT256 =
4     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
5     /*
6     *  Adds two numbers, throws on overflow.
7     */
8     function safeAdd(uint256 x, uint256 y) pure  internal returns (uint256 z) {
9         if (x > MAX_UINT256 - y) revert();
10         return x + y;
11     }
12     /*
13      *  Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
14      */
15     function safeSub(uint256 x, uint256 y) pure internal returns (uint256 z) {
16         if (x < y)  revert();
17         return x - y;
18     }
19 }
20 contract ERC223 {
21   uint public totalSupply;
22   function balanceOf(address who) public constant returns (uint);
23   function totalSupply()public constant returns (uint256 _supply);
24   function name() public constant returns (string _name);
25   function symbol()public constant returns (string _symbol);
26 }
27 contract WCG is SafeMath{
28     address owner;
29     //The token holds to the message
30    struct userToken{
31         address buyer;
32         uint currentPrice;
33         uint _token;
34         uint totalToKenPrice;
35         uint charge;
36         uint totalBuyPrice;
37     }
38     userToken[] _userTokenInfo;
39     mapping(address => userToken[]) private userTokenInfos; 
40     mapping(address => uint256) private balances;
41     //Bonus pools
42     mapping(address => uint256) private bonusPools;
43     //capital pool 
44     mapping(address => uint256) private capitalPool;
45     string public name = "wcg";
46     string public symbol = "WCG";
47     uint256 public totalSupply = 0;
48     
49     uint constant initPrice = 0.01 ether;
50     uint private presellUpToTime;
51     uint  private presellToKenAmount;
52     event transfer(address addr,address contractAddr,uint token,uint totalSupply);
53   modifier onlyOwner(){
54        require(msg.sender == owner);
55         _;
56   }
57   modifier upToTime(){
58       require(now < presellUpToTime);
59       _;
60   }
61   function getUserTokenInfosLength()public view returns(uint length){
62       length = _userTokenInfo.length;
63   }
64   
65   function getUserTokenInfos(address contractAddr,uint index)public view returns(address buyer,uint currentPrice,uint _token,uint totalToKenPrice,uint charge,uint totalBuyPrice){
66      userToken storage _userToKen = userTokenInfos[contractAddr][index];
67      buyer = _userToKen.buyer;
68      currentPrice = _userToKen.currentPrice;
69      _token = _userToKen._token;
70      totalToKenPrice = _userToKen.totalToKenPrice;
71      charge = _userToKen.charge;
72      totalBuyPrice = _userToKen.totalBuyPrice;
73   }
74   constructor(uint _presellToKen,uint _presellUpToTime)public{
75       presellUpToTime = now + (_presellUpToTime * 1 days);
76       owner = msg.sender;
77       presellToKenAmount = EthTurnWCG(_presellToKen);
78   }
79   //Buy WCG
80   function buyToKen(uint _token)public payable upToTime{
81       uint totalToKenPrice = buyPrice(_token);
82       uint charge = computingCharge(totalToKenPrice);
83       if( msg.value < totalToKenPrice+charge)revert();
84       bonusPools[this] = safeAdd(bonusPools[this],charge);
85       capitalPool[this] = safeAdd(capitalPool[this],totalToKenPrice);
86       address(this).transfer(msg.value);
87       balances[this] = safeAdd(balances[this],msg.value);
88       _userTokenInfo.push(userToken(msg.sender,currentPrice(),_token,totalToKenPrice,charge,totalToKenPrice+charge));
89       totalSupply =  safeAdd(totalSupply,_token);
90       balances[msg.sender] = safeAdd(balances[msg.sender],_token);
91       userTokenInfos[this] = _userTokenInfo;
92       emit transfer(msg.sender,address(this),_token,totalSupply);
93   }
94   
95   function()public payable{}
96   function EthTurnWCG(uint eth)public pure returns(uint){
97       return eth * 1e18 / initPrice;
98   }
99   function currentPrice()public pure returns(uint){
100       return initPrice;
101   }
102   function buyPrice(uint _token)public pure returns(uint){
103       return  _token * currentPrice();
104   }
105   function computingCharge(uint price)public pure returns(uint){
106       return price / 10;
107   }
108   function getPresellToKenAmount()public view returns(uint){
109       return presellToKenAmount;
110   }
111   function getPresellUpToTime()public constant returns(uint){
112       return presellUpToTime;
113   }
114   function capitalPoolOf(address who) public constant returns (uint){
115       return capitalPool[who];
116   }
117   function bonusPoolsOf(address who) public constant returns (uint){
118       return bonusPools[who];
119   }
120   function balanceOf(address who) public constant returns (uint){
121       return balances[who];
122   }
123   function totalSupply()public constant returns (uint256 _supply){
124       return totalSupply;
125   }
126 
127   function destroy()public onlyOwner {
128       selfdestruct(owner);
129   }
130 
131 }