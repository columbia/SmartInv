1 pragma solidity ^0.4.23;
2 
3 contract Win20ETH {
4 
5 
6     struct Comissions{
7         uint total;
8         uint referal;
9         uint nextJackpot;
10     }
11 
12     uint adminComission;
13 
14     Comissions comission;
15 
16     uint ticketPrice;
17     uint blockOffset;
18     uint jackpot;
19 
20     address owner;
21     mapping(address => uint) referalProfits;
22     address[] referals;
23 
24     mapping(uint => Game) games;
25 
26 	event PurchaseError(address oldOwner, uint amount);
27 
28 	struct Game{
29 	    uint blockId;
30 	    address[] gamers;
31 	    mapping(address=>bool) pays;
32 	}
33 
34 	modifier onlyOwner() {
35 		require(msg.sender == owner);
36 		_;
37 	}
38 
39 	/**
40 	 * @dev Sets owner and default lottery params
41 	 */
42 	constructor() public {
43 		owner = msg.sender;
44 		updateParams(0.005 ether, 1, 10, 5, 1);
45 		adminComission =0;
46 
47 	}
48 	function withdrawAdmin() public onlyOwner{
49 	    require(adminComission>0);
50 	    uint t = adminComission;
51 	    adminComission = 0;
52 	    owner.transfer(t);
53 
54 
55 	}
56 	function updateParams(
57 		uint _ticketPrice,
58 		uint _blockOffset,
59 		uint _total,
60 		uint _refPercent,
61 		uint _nextJackpotPercent
62 
63 	) public onlyOwner {
64 		ticketPrice = _ticketPrice;
65 		comission.total = _total;
66 		comission.referal = _refPercent;
67 		comission.nextJackpot =  _nextJackpotPercent;
68 		blockOffset = _blockOffset;
69 
70 	}
71 
72 
73 
74     function buyTicketWithRef(address _ref) public payable{
75        require(msg.value == ticketPrice);
76        bool found = false;
77        for(uint i=0; i< games[block.number+blockOffset].gamers.length;i++){
78         	      if( msg.sender == games[block.number+blockOffset].gamers[i]){
79         	        found = true;
80         	        break;
81         	      }
82         	    }
83         	    require(found == false);
84 	    jackpot+=msg.value;
85 	    games[block.number+blockOffset].gamers.push(msg.sender);
86 	    games[block.number+blockOffset].pays[msg.sender] = false;
87 	    if( _ref != address(0) && comission.referal>0){
88 	        referalProfits[_ref]+= msg.value*comission.referal/100;
89 	        bool _found = false;
90 	        for(i = 0;i<referals.length;i++){
91 	            if( referals[i] == _ref){
92 	                _found=true;
93 	                break;
94 	            }
95 	        }
96 	        if(!_found){
97 	            referals.push(_ref);
98 	        }
99 	    }
100     }
101 	function buyTicket() public payable {
102 
103 	    require(msg.value == ticketPrice);
104 	    bool found = false;
105 	    for(uint i=0; i< games[block.number+blockOffset].gamers.length;i++){
106 	      if( msg.sender == games[block.number+blockOffset].gamers[i]){
107 	        found = true;
108 	        break;
109 	      }
110 	    }
111 	    require(found == false);
112 	    jackpot+=msg.value;
113 	    games[block.number+blockOffset].gamers.push(msg.sender);
114 	    games[block.number+blockOffset].pays[msg.sender] = false;
115 
116 
117 	}
118 
119 
120 	function getLotteryAtIndex(uint _index) public view returns(
121 		address[] _gamers,
122 		uint _jackpot
123 	) {
124         _gamers = games[_index].gamers;
125         _jackpot = jackpot;
126 	}
127     function _checkWin( uint _blockIndex, address candidate) internal view returns(uint) {
128             uint32 blockHash = uint32(blockhash(_blockIndex));
129             uint32 hit = blockHash ^ uint32(candidate);
130             bool hit1 = (hit & 0xF == 0)?true:false;
131             bool hit2 = (hit1 && ((hit & 0xF0)==0))?true:false;
132             bool hit3 = (hit2 && ((hit & 0xF00)==0))?true:false;
133             bool _found  = false;
134 
135             for(uint i=0;i<games[_blockIndex].gamers.length;i++){
136                 if(games[_blockIndex].gamers[i] == candidate) {
137                     _found = true;
138                 }
139             }
140             if(!_found) return 0;
141             uint amount = 0;
142             if ( hit1 ) amount = 2*ticketPrice;
143             if ( hit2 ) amount = 4*ticketPrice;
144             if ( hit3 ) amount = jackpot;
145             return amount;
146 
147 
148     }
149     function checkWin( uint _blockIndex, address candidate) public view returns(
150         uint amount
151         ){
152             amount = _checkWin(_blockIndex, candidate);
153         }
154 
155 
156 
157 
158 	function withdrawForWinner(uint _blockIndex) public {
159 	    require((block.number - 100) < _blockIndex );
160 		require(games[_blockIndex].gamers.length > 0);
161 		require(games[_blockIndex].pays[msg.sender]==false);
162 
163 		uint amount =  _checkWin(_blockIndex, msg.sender) ;
164 		require(amount>0);
165 
166 		address winner = msg.sender;
167 		if( amount > jackpot) amount=jackpot;
168 		if( amount == jackpot) amount = amount*99/100;
169 		
170 		games[_blockIndex].pays[msg.sender] = true;
171 
172 		uint winnerSum = amount*(100-comission.total)/100;
173 		uint techSum = amount-winnerSum;
174 
175 		winner.transfer( winnerSum );
176 		for(uint i=0;i<referals.length;i++){
177 		    if( referalProfits[referals[i]]>0 && referalProfits[referals[i]]<techSum){
178 		        referals[i].transfer( referalProfits[referals[i]]);
179 		        techSum -= referalProfits[referals[i]];
180 		        referalProfits[referals[i]] = 0;
181 		 }
182 		}
183 		if( techSum > 0){
184 		  owner.transfer(techSum);
185 		}
186 		jackpot = jackpot-amount;
187 
188 
189 
190 
191 	}
192 	function getJackpot() public view returns(uint){
193 	    return jackpot;
194 	}
195 	function getAdminComission() public view returns(uint){
196 	    return adminComission;
197 	}
198 
199     function balanceOf(address _user) public view returns(uint) {
200 		return referalProfits[_user];
201     }
202 
203 	/**
204 	 * @dev Disallow users to send ether directly to the contract
205 	 */
206 	function() public payable {
207 	    if( msg.sender != owner){
208 	        revert();
209 	    }
210 	    jackpot += msg.value;
211 	}
212 
213 
214 }