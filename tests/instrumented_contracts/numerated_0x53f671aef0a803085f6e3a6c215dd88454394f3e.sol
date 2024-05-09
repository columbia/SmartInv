1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5         if (a == 0) {
6             return 0;
7         }
8         c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         return a / b;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
23         c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 contract WorldCupWinner {
30     using SafeMath for uint256;
31 
32     /*****------ EVENTS -----*****/
33   event BuyWinner(address indexed buyer, uint256 indexed traddingTime, uint256 first, uint256 second, uint256 three, uint256 gameid, uint256 buyType, uint buyTotal,uint256 buyPrice);
34   event BuyWinnerList(uint256 indexed first, uint256 indexed second, uint256  indexed third,address  buyer, uint256  traddingTime, uint256 gameid, uint256 buyType, uint buyTotal,uint256 buyPrice);
35   event BuyWinnerTwo(address indexed buyer, uint256 indexed first, uint256 indexed gameid,uint256 traddingTime, uint256 buyType,uint256 buyPrice,uint buyTotal);
36   event ShareBonus(address indexed buyer, uint256 indexed traddingTime, uint256 indexed buyerType, uint256 gameID, uint256 remainingAmount);
37 
38   address public owner;
39 
40 	uint[] _teamIDs;
41 
42     struct Game{
43       uint256 _bouns;
44 	    uint[] _teams;
45 	    uint256[] _teamPrice;
46 	    uint _playType;
47 	    bool _stop;
48 		  uint256 _beginTime;
49     }
50     Game[] public games;
51 
52     constructor() public {
53 	    owner = msg.sender;
54     }
55 
56     modifier onlyOwner() {
57         require(msg.sender == owner);
58         _;
59     }
60 
61     function createGame(uint[] _teams, uint256[] _tPrice, uint _gameType,uint256 _beginTime) public onlyOwner {
62 		Game memory _game = Game({
63         _bouns: 0,
64 		    _teams: _teams,
65 		    _teamPrice: _tPrice,
66         _playType: _gameType,
67 		    _stop: true,
68 			_beginTime:_beginTime
69         });
70         games.push(_game);
71     }
72 
73     function setTeamPrice(uint[] _teams, uint256[] _tPrice, uint gameID) public onlyOwner {
74         games[gameID]._teams = _teams;
75 		    games[gameID]._teamPrice = _tPrice;
76     }
77 
78 	  function setTeamStatus(bool bstop, uint gameID) public onlyOwner {
79         games[gameID]._stop = bstop;
80     }
81 
82     function destroy() public onlyOwner {
83 	    selfdestruct(owner);
84     }
85 
86     function shareAmount(address winner, uint256 amount, uint256 _buyerType, uint _gameID) public onlyOwner {
87 	    require(address(this).balance>=amount);
88 	    winner.transfer(amount);
89 	    emit ShareBonus(winner, uint256(now), _buyerType, _gameID, amount);
90     }
91     function batchShareAmount(address[] winner, uint256[] amount, uint256 _gameID,uint256 _buyerType,uint256 amount_total) public onlyOwner {
92      require(address(this).balance>=amount_total);
93      for(uint i=0; i<winner.length; i++){
94       winner[i].transfer(amount[i]);
95          emit ShareBonus(winner[i], uint256(now), _buyerType, _gameID, amount[i]);
96          }
97     }
98 
99 	function getListTeamByPlayType(uint _gameType) public view returns (uint[] teamIDss){
100 		_teamIDs = [0];
101 		for(uint i=0; i<games.length; i++)
102 	    {
103 		    if(games[i]._playType == _gameType){
104 		        _teamIDs.push(i);
105 		    }
106 	    }
107 		teamIDss = _teamIDs;
108     }
109 
110     function getListTeam(uint _gameID) public view returns (uint256 _bouns,
111 	    uint[] _teams,
112 	    uint256[] _teamPrice,
113 
114 	    uint _playType,
115 	    bool _stop,
116 		uint256 _beginTime){
117 		_bouns = games[_gameID]._bouns;
118 		_teams = games[_gameID]._teams;
119 		_teamPrice = games[_gameID]._teamPrice;
120 		_playType = games[_gameID]._playType;
121 		_stop = games[_gameID]._stop;
122 		_beginTime = games[_gameID]._beginTime;
123     }
124 
125 	function getPool(uint _gameID) public view returns (uint256 bounsp){
126 	    return games[_gameID]._bouns;
127     }
128 
129     function buy(uint256 _gameID, uint256 _one, uint256 _two, uint256 _three, uint256 _buyCount,uint256 buyPrice) payable public{
130 	    //require(games[_gameID]._stop);
131       uint256 totalPrice = (games[_gameID]._teamPrice[_one.sub(100)].add(games[_gameID]._teamPrice[_two.sub(100)]).add(games[_gameID]._teamPrice[_three.sub(100)])).mul(_buyCount);
132       totalPrice = totalPrice.add(totalPrice.div(20)) ;
133 	    require(msg.value >= totalPrice);
134 
135 	    emit BuyWinner(msg.sender, uint256(now),_one, _two, _three, _gameID, games[_gameID]._playType, _buyCount, buyPrice);
136       emit BuyWinnerList(_one, _two, _three,msg.sender, uint256(now), _gameID, games[_gameID]._playType, _buyCount, buyPrice);
137 	    owner.transfer(msg.value.div(20));
138 	    games[_gameID]._bouns = games[_gameID]._bouns.add(msg.value);
139     }
140 
141 	function buyTwo(uint256 _one, uint256 _gameID, uint256 _buyCount,uint256 _buyPrice) payable public{
142 	    //require(games[_gameID]._stop);
143 	    require(msg.value >= ((games[_gameID]._teamPrice[_one].mul(_buyCount)).add(games[_gameID]._teamPrice[_one]).mul(_buyCount).div(20)));
144       owner.transfer(msg.value.div(20));
145 		  emit BuyWinnerTwo(msg.sender, games[_gameID]._teams[_one], _gameID,uint256(now), games[_gameID]._playType,_buyPrice, _buyCount);
146 	    games[_gameID]._bouns = games[_gameID]._bouns.add(msg.value);
147     }
148 
149     function getBonusPoolTotal() public view returns (uint256) {
150         return this.balance;
151  }
152 }