1 pragma solidity ^0.4.25;
2 library SafeMath {
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
24 }
25 contract WCG{
26     using SafeMath for uint256;
27     address owner;
28     //The token holds to the message
29    struct userToken{
30         address buyer;
31         uint currentPrice;
32         uint _token;
33         uint totalToKenPrice;
34         uint charge;
35         uint totalBuyPrice;
36     }
37     userToken[] _userTokenInfo;
38     mapping(address => uint256) private balances;
39     //Bonus pools
40     mapping(address => uint256) private bonusPools;
41     //capital pool 
42     mapping(address => uint256) private capitalPool;
43     string public name = "wcg";
44     string public symbol = "WCG";
45     uint256 public totalSupply = 0;
46     
47     uint constant initPrice = 0.01 ether;
48     uint private presellUpToTime;
49     uint  private presellToKenAmount;
50     event transfer(address addr,address contractAddr,uint token,uint totalSupply);
51   modifier onlyOwner(){
52        require(msg.sender == owner);
53         _;
54   }
55   modifier upToTimeOrTotalSupply(){
56       require(now < presellUpToTime || totalSupply < presellToKenAmount);
57       _;
58   }
59   function getUserTokenInfosLength()public view returns(uint length){
60       length = _userTokenInfo.length;
61   }
62   
63   function getUserTokenInfos(uint index)public view returns(address buyer,uint currentPrice,uint _token,uint totalToKenPrice,uint charge,uint totalBuyPrice){
64      userToken storage _userToKen = _userTokenInfo[index];
65      buyer = _userToKen.buyer;
66      currentPrice = _userToKen.currentPrice;
67      _token = _userToKen._token;
68      totalToKenPrice = _userToKen.totalToKenPrice;
69      charge = _userToKen.charge;
70      totalBuyPrice = _userToKen.totalBuyPrice;
71   }
72   constructor(uint _presellToKen,uint _presellUpToTime)public{
73       presellUpToTime = now + (_presellUpToTime * 1 days);
74       owner = msg.sender;
75       presellToKenAmount = _presellToKen* 1e18 / initPrice;
76   }
77   //Buy WCG
78   function buyToKen(uint _token)public payable upToTimeOrTotalSupply{
79       uint totalToKenPrice = buyPrice(_token);
80       uint charge = computingCharge(totalToKenPrice);
81       if( msg.value < totalToKenPrice+charge)revert();
82       bonusPools[this] = SafeMath.safeAdd(bonusPools[this],charge);
83       capitalPool[this] = SafeMath.safeAdd(capitalPool[this],totalToKenPrice);
84       address(this).transfer(msg.value);
85       balances[this] = SafeMath.safeAdd(balances[this],msg.value);
86       _userTokenInfo.push(userToken(msg.sender,currentPrice(),_token,totalToKenPrice,charge,totalToKenPrice+charge));
87       totalSupply =  SafeMath.safeAdd(totalSupply,_token);
88       balances[msg.sender] = SafeMath.safeAdd(balances[msg.sender],_token);
89       emit transfer(msg.sender,address(this),_token,totalSupply);
90   }
91   
92   function()public payable{}
93   function EthTurnWCG(uint eth)public pure returns(uint){
94       return eth * 1e18 / (initPrice+initPrice/10);
95   }
96   function currentPrice()public pure returns(uint){
97       return initPrice;
98   }
99   function buyPrice(uint _token)public pure returns(uint){
100       return  _token * currentPrice();
101   }
102   function computingCharge(uint price)public pure returns(uint){
103       return price / 10;
104   }
105   function getPresellToKenAmount()public view returns(uint){
106       return presellToKenAmount;
107   }
108   function getPresellUpToTime()public constant returns(uint){
109       return presellUpToTime;
110   }
111   function capitalPoolOf(address who) public constant returns (uint){
112       return capitalPool[who];
113   }
114   function bonusPoolsOf(address who) public constant returns (uint){
115       return bonusPools[who];
116   }
117   function balanceOf(address who) public constant returns (uint){
118       return balances[who];
119   }
120   function totalSupply()public constant returns (uint256 _supply){
121       return totalSupply;
122   }
123   function setPresellUpToTime(uint time)public onlyOwner{
124       presellUpToTime = now + (time * 1 days);
125   }
126 
127   function destroy()public onlyOwner {
128       selfdestruct(owner);
129   }
130 
131 }