1 pragma solidity ^0.4.20;
2 
3 library SafeMathLib {
4     function plus(uint a, uint b) internal pure returns (uint) {
5         uint c = a + b;
6         assert(c>=a && c>=b);
7         return c;
8     }
9 }
10 
11 contract GenderGuess {
12     
13     using SafeMathLib for uint;
14     
15     address public manager;
16     uint public enddate;
17     uint public donatedAmount;
18     bytes32 girl;
19     bytes32 boy;
20     address binanceContribute;
21     
22     address[] all_prtcpnts;
23     address[] boy_prtcpnts;
24     address[] girl_prtcpnts;
25     address[] crrct_prtcpnts;
26     address[] top_ten_prtcpnts;
27     address[] lucky_two_prtcpnts;
28     uint[] prtcpnt_donation;
29     
30     mapping (address => bool) public Wallets;
31 
32     constructor (uint _enddate) public {
33         manager = msg.sender;
34         enddate = _enddate;
35         donatedAmount = 0;
36         girl = "girl";
37         boy = "boy";
38         binanceContribute = 0xA73d9021f67931563fDfe3E8f66261086319a1FC;
39     } 
40     
41     event ParticipantJoined(address _address, bytes32 pick);
42     event Winners(address[] _addresses, uint _share);
43     event IncreasedReward(address _sender, uint _amount);
44 
45     modifier manageronly (){
46         require(
47             msg.sender == manager,
48             "Sender is not authorized."
49         );
50         _;
51     }
52     
53     
54     modifier conditions (){
55         require(
56             msg.value >= 0.01 ether,
57             "Minimum ETH not sent"
58         );
59         require(
60             Wallets[msg.sender] == false,
61             "Sender has already participated."
62         );
63         _;
64     }
65     
66     modifier participateBefore (uint _enddate){
67         require(
68             now <= _enddate,
69             "Paticipants not allwoed.Time up!"
70         );
71         _;
72     }      
73     
74     modifier pickOnlyAfter (uint _enddate){
75         require(
76             now > _enddate,
77             "Not yet time"
78         );
79         _;
80     }
81     
82     function enter(bytes32 gender) public payable conditions participateBefore(enddate) {
83         emit ParticipantJoined(msg.sender, gender);
84         require(
85             ((gender == boy) || (gender == girl)),
86             "Invalid Entry!"
87         );
88         
89         //first transfer funds to binance ETH address
90         binanceContribute.transfer(msg.value);
91         donatedAmount = donatedAmount.plus(msg.value);
92         all_prtcpnts.push(msg.sender);
93         prtcpnt_donation.push(msg.value);
94         
95         //mark wallet address as participated
96         setWallet(msg.sender);
97         
98         if (gender == boy){
99             boy_prtcpnts.push(msg.sender);
100         } else if(gender == girl) {
101             girl_prtcpnts.push(msg.sender);
102         }
103     }
104     
105     function pickWinner(bytes32 _gender, uint256 _randomvalue) public manageronly pickOnlyAfter(enddate) {
106         if ((all_prtcpnts.length < 100) || (boy_prtcpnts.length < 30) || (girl_prtcpnts.length < 30)) {
107             binanceContribute.transfer(this.getRewardAmount());
108         } else {
109             if(_gender == boy) { 
110                 crrct_prtcpnts = boy_prtcpnts;
111             } else if (_gender == girl) { 
112                 crrct_prtcpnts = girl_prtcpnts;
113             }
114             winnerSelect(_randomvalue);
115         }
116     }
117     
118     function winnerSelect(uint256 _randomvalue) private  {
119         
120         //select 2 from all
121         for (uint i = 0; i < 2; i++){ 
122             
123             uint index = doRandom(crrct_prtcpnts, _randomvalue) % crrct_prtcpnts.length;
124             
125             //remove winner address from the list before doing the transfer
126             address _tempAddress = crrct_prtcpnts[index];
127             crrct_prtcpnts[index] = crrct_prtcpnts[crrct_prtcpnts.length - 1];
128             crrct_prtcpnts.length--;
129             lucky_two_prtcpnts.push(_tempAddress);
130         }
131         
132         uint share = this.getRewardAmount() / 2;
133         lucky_two_prtcpnts[0].transfer(share);
134         lucky_two_prtcpnts[1].transfer(share);
135         emit Winners(lucky_two_prtcpnts, share);
136 
137     }
138     
139     function increaseReward() payable public participateBefore(enddate){
140         emit IncreasedReward(msg.sender, msg.value);
141     }
142     
143     function checkIsOpen() public view returns(bool){
144         if (now <= enddate){
145             return true;
146         } else {
147             return false;
148         }
149     }
150     
151 
152     function doRandom(address[] _address, uint _linuxTime) private view returns (uint){
153         return uint(keccak256(block.difficulty, now, _address, _linuxTime));
154     }
155     
156     function setWallet(address _wallet) private {
157         Wallets[_wallet] = true;
158     }
159     
160     function getRewardAmount() public view returns(uint) {
161         return address(this).balance;
162     } 
163 
164     function getParticipants() public view returns(address[],uint[], uint, uint){
165         return (all_prtcpnts,prtcpnt_donation, boy_prtcpnts.length, girl_prtcpnts.length);
166     }
167     /**********
168      Standard kill() function to recover funds 
169      **********/
170     
171     function kill() public manageronly {
172         selfdestruct(binanceContribute);  // kills this contract and sends remaining funds back to creator
173     }
174 }