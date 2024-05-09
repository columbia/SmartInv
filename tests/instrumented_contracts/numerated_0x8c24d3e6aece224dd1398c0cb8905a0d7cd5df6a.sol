1 pragma solidity 0.4.21;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() public {
18     owner = msg.sender;
19   }
20 
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     emit OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 /*
44 
45    ____      _             _  __                                                    
46   / ___|___ (_)_ __  ___  | |/ /__ _ _ __ _ __ ___   __ _        ___ ___  _ __ ___  
47  | |   / _ \| | '_ \/ __| | ' // _` | '__| '_ ` _ \ / _` |      / __/ _ \| '_ ` _ \ 
48  | |__| (_) | | | | \__ \ | . \ (_| | |  | | | | | | (_| |  _  | (_| (_) | | | | | |
49   \____\___/|_|_| |_|___/ |_|\_\__,_|_|  |_| |_| |_|\__,_| (_)  \___\___/|_| |_| |_|
50                                                                                     
51 
52 */
53 
54 contract CoinsKarmaFactory is Ownable {
55 
56     event NewCoinsKarma(uint coinsKarmaId, string name, string symbol, uint totalKarmaUp, uint totalKarmaDown, bool exists);
57     event NewKarmaVoter(uint karmaVoteId, uint coinsKarmaId, address voterAddress, uint up, uint down, uint voteTime, bool exists);
58 
59     struct CoinsKarma {
60         string name;
61         string symbol;
62         uint totalKarmaUp;
63         uint totalKarmaDown;
64         bool exists;
65     }
66 
67     struct KarmaVotes {
68         uint coinsKarmaId;
69         address voterAddress;
70         uint up;
71         uint down;
72         uint voteTime;
73         bool exists;
74     }
75 
76     CoinsKarma[] public coinkarma;
77     mapping(string => uint) coinsKarmaCreated;
78     mapping(string => uint) coinsKarmaMap;
79 
80     KarmaVotes[] public karmavoters;
81     mapping(address => mapping(uint => uint)) karmaVoterCreated;
82     mapping(address => mapping(uint => uint)) karmaVoterMap;
83 
84     uint giveKarmaFee = 1800000000000000; // CoinsKarma tries to keep this around $1 and checks regularly to make sure of that. CoinsKarma can change this fee with the alterGiveKarmaFee funciton.
85 
86     /********************************* */
87     // karma functions
88 
89     function viewCoinsKarma(uint _coinsKarmaId) view public returns (uint, string, string, uint, uint, bool) {
90         CoinsKarma storage coinskarma = coinkarma[_coinsKarmaId];
91         return (_coinsKarmaId, coinskarma.name, coinskarma.symbol, coinskarma.totalKarmaUp, coinskarma.totalKarmaDown, coinskarma.exists);
92     }
93 
94     function viewCoinsKarmaBySymbol(string _coinSymbol) view public returns (uint, string, string, uint, uint, bool) {
95         CoinsKarma storage coinskarma = coinkarma[coinsKarmaMap[_coinSymbol]];
96         if (coinskarma.exists == true) {
97             return (coinsKarmaMap[_coinSymbol], coinskarma.name, coinskarma.symbol, coinskarma.totalKarmaUp, coinskarma.totalKarmaDown, coinskarma.exists);
98         } else {
99             return (0, "", "", 0, 0, false);
100         }
101     }
102 
103     function viewKarmaVotes(uint _karmaVoteId) view public returns (uint, uint, address, uint, uint, uint, bool) {
104         KarmaVotes storage karmavotes = karmavoters[_karmaVoteId];
105         return (_karmaVoteId, karmavotes.coinsKarmaId, karmavotes.voterAddress, karmavotes.up, karmavotes.down, karmavotes.voteTime, karmavotes.exists);
106     }
107 
108     function viewKarmaVotesBySymbol(string _coinSymbol, address _userAddress) view public returns (uint, address, uint, uint, uint, string) {
109         uint getCoinsId = coinsKarmaMap[_coinSymbol];
110         if (karmavoters[karmaVoterMap[_userAddress][getCoinsId]].exists == true) {
111             return (karmavoters[karmaVoterMap[_userAddress][getCoinsId]].coinsKarmaId, karmavoters[karmaVoterMap[_userAddress][getCoinsId]].voterAddress, karmavoters[karmaVoterMap[_userAddress][getCoinsId]].up, karmavoters[karmaVoterMap[_userAddress][getCoinsId]].down, karmavoters[karmaVoterMap[_userAddress][getCoinsId]].voteTime, _coinSymbol);
112         } else {
113             return (0, 0x0, 0, 0, 0, "");
114         }
115     }
116 
117     function giveKarma(uint _upOrDown, string _coinName, string _coinSymbol) payable public {
118         require(msg.value >= giveKarmaFee);
119 
120         uint upVote = 0;
121         uint downVote = 0;
122         if(_upOrDown == 1){
123             downVote = 1;
124         } else if (_upOrDown == 2){
125             upVote = 1;
126         }
127 
128         uint id;
129 
130         // see if coinName is already created, if not, then create it
131         if (coinsKarmaCreated[_coinSymbol] == 0) {
132             // create it
133             id = coinkarma.push(CoinsKarma(_coinName, _coinSymbol, 0, 0, true)) - 1;
134             emit NewCoinsKarma(id, _coinName, _coinSymbol, 0, 0, true);
135 
136             coinsKarmaMap[_coinSymbol] = id;
137             coinsKarmaCreated[_coinSymbol] = 1;
138 
139         } else {
140             id = coinsKarmaMap[_coinSymbol];
141 
142         }
143 
144         // see if this user has already given karma for this coin
145         if (karmaVoterCreated[msg.sender][id] == 0) {
146             // hasent, create new KarmaVote
147             uint idd = karmavoters.push(KarmaVotes(id, msg.sender, upVote, downVote, now, true)) - 1;
148             emit NewKarmaVoter(idd, id, msg.sender, upVote, downVote, now, true);
149 
150             karmaVoterCreated[msg.sender][id] = 1;
151             karmaVoterMap[msg.sender][id] = idd;
152 
153             coinkarma[coinsKarmaMap[_coinSymbol]].totalKarmaUp = coinkarma[coinsKarmaMap[_coinSymbol]].totalKarmaUp + upVote;
154             coinkarma[coinsKarmaMap[_coinSymbol]].totalKarmaDown = coinkarma[coinsKarmaMap[_coinSymbol]].totalKarmaDown + downVote;
155 
156         }else{
157             // has, update KarmaVote
158             if (karmavoters[karmaVoterMap[msg.sender][id]].up > 0){
159                 coinkarma[coinsKarmaMap[_coinSymbol]].totalKarmaUp = coinkarma[coinsKarmaMap[_coinSymbol]].totalKarmaUp - 1;
160             } else if(karmavoters[karmaVoterMap[msg.sender][id]].down > 0) { 
161                 coinkarma[coinsKarmaMap[_coinSymbol]].totalKarmaDown = coinkarma[coinsKarmaMap[_coinSymbol]].totalKarmaDown - 1;
162             }
163             
164             karmavoters[karmaVoterMap[msg.sender][id]].up = upVote;
165             karmavoters[karmaVoterMap[msg.sender][id]].down = downVote;
166             karmavoters[karmaVoterMap[msg.sender][id]].voteTime = now;
167 
168             coinkarma[coinsKarmaMap[_coinSymbol]].totalKarmaUp = coinkarma[coinsKarmaMap[_coinSymbol]].totalKarmaUp + upVote;
169             coinkarma[coinsKarmaMap[_coinSymbol]].totalKarmaDown = coinkarma[coinsKarmaMap[_coinSymbol]].totalKarmaDown + downVote;
170 
171         }
172 
173     }
174 
175     /********************************* */
176     // admin functions
177 
178     function viewGiveKarmaFee() public view returns(uint) {
179         return giveKarmaFee;
180     }
181 
182     function alterGiveKarmaFee (uint _giveKarmaFee) public onlyOwner() {
183         giveKarmaFee = _giveKarmaFee;
184     }
185 
186     function withdrawFromContract(address _to, uint _amount) payable external onlyOwner() {
187         _to.transfer(_amount);
188 
189     }
190 
191 }