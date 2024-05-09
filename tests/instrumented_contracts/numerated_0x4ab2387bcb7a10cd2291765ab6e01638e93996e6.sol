1 pragma solidity ^0.4.0;
2 
3 contract TycoonPresale {
4     event HHH(address bidder, uint amount); // Event
5 
6     address public owner; // Minor management of game
7     bool public isPresaleEnd;
8     uint256 private constant price = 0.0666 ether;
9     uint8 private constant maxNumbersPerPlayer = 10;
10     mapping (address => mapping (uint8 => bool)) private doihave;
11     mapping (address => uint8[]) private last; // [choumode][idx1][idx2][...]
12     uint256 private constant FACTOR = 1157920892373161954235709850086879078532699846656405640394575840079131296399;
13     uint256 private constant MAGICNUMBER = 6666666666666666666666666666666666666666666666666666666666666666666666666666;
14     struct Level {
15         uint8[] GaoIdx;
16         uint8 passProb;
17     }
18     Level[] private levels;
19     /*** CONSTRUCTOR ***/
20     constructor() public {
21         owner = msg.sender;
22         Level memory _level;
23         _level.GaoIdx = new uint8[](5);
24         _level.GaoIdx[0] = 2;
25         _level.GaoIdx[1] = 3;
26         _level.GaoIdx[2] = 5;
27         _level.GaoIdx[3] = 6;
28         _level.GaoIdx[4] = 7;
29         _level.passProb = 55;
30         levels.push(_level);
31         _level.GaoIdx = new uint8[](4);
32         _level.GaoIdx[0] = 9;
33         _level.GaoIdx[1] = 10;
34         _level.GaoIdx[2] = 12;
35         _level.GaoIdx[3] = 13;
36         _level.passProb = 65;
37         levels.push(_level);
38         //
39         _level.GaoIdx = new uint8[](11);
40         _level.GaoIdx[0] = 16;
41         _level.GaoIdx[1] = 18;
42         _level.GaoIdx[2] = 19;
43         _level.GaoIdx[3] = 20;
44         _level.GaoIdx[4] = 21;
45         _level.GaoIdx[5] = 23;
46         _level.GaoIdx[6] = 24;
47         _level.GaoIdx[7] = 25;
48         _level.GaoIdx[8] = 26;
49         _level.GaoIdx[9] = 28;
50         _level.GaoIdx[10] = 29;
51         _level.passProb = 0;
52         levels.push(_level);
53     }
54     function MyGaoguans() public view returns (uint8[]){
55         return last[msg.sender];
56     }
57     function Chou(uint8 seChou) public payable {
58         require(!isPresaleEnd);
59         require(_goodAddress(msg.sender));
60         require(seChou > 0 && seChou < 6);
61         uint8 owndCount = 0;
62         if (last[msg.sender].length != 0){
63             owndCount = last[msg.sender][0];
64         }
65         require(owndCount + seChou <= maxNumbersPerPlayer);
66         require(msg.value >= (price * seChou));
67 
68         if (last[msg.sender].length < 2){
69             last[msg.sender].push(seChou);
70             last[msg.sender].push(seChou);
71         }else{
72             last[msg.sender][0] += seChou;
73             last[msg.sender][1] = seChou;
74         }
75 
76         uint256 zhaoling = msg.value - (price * seChou);
77         assert(zhaoling <= msg.value); // safe math
78         // multi-chou
79         for (uint _seChouidx = 0; _seChouidx != seChou; _seChouidx++){
80             uint randN = _rand(_seChouidx + MAGICNUMBER); // only generate once for saving gas
81             for (uint idx = 0; idx != levels.length; idx++) {
82                 bool levelPass = true;
83                 uint8 chosenIdx;
84                 for (uint jdx = 0; jdx != levels[idx].GaoIdx.length; jdx++) {
85                     if (!_Doihave(levels[idx].GaoIdx[(jdx+randN)%levels[idx].GaoIdx.length])){
86                         levelPass = false;
87                         chosenIdx = levels[idx].GaoIdx[(jdx+randN)%levels[idx].GaoIdx.length];
88                         break;
89                     }
90                 }
91                 if (!levelPass){
92                     if (randN % 100 >= levels[idx].passProb) { // this level right, and the last chosenIdx is chosenIdx
93                         _own(chosenIdx);
94                         break;
95                     }
96                     randN = randN + MAGICNUMBER;
97                 }
98             }
99         }
100         msg.sender.transfer(zhaoling);
101     }
102     
103     // private
104     function _Doihave(uint8 gaoIdx) private view returns (bool) {
105         return doihave[msg.sender][gaoIdx];
106     }
107     function _own(uint8 gaoIdx) private {
108         last[msg.sender].push(gaoIdx);
109         doihave[msg.sender][gaoIdx] = true;
110     }
111     function _rand(uint exNumber) private constant returns (uint){
112         uint lastBlockNumber = block.number - 1;
113         uint hashVal = uint256(blockhash(lastBlockNumber));
114         uint result = uint(keccak256(exNumber, msg.sender, hashVal));
115         return result;
116     }
117     function _goodAddress(address add) private pure returns (bool) {
118         return add != address(0);
119     }
120     function _payout(address _to) private {
121         if (_to == address(0)) {
122             owner.transfer(address(this).balance);
123         } else {
124             _to.transfer(address(this).balance);
125         }
126     }
127     // business use only for owner
128     modifier ensureOwner() {
129         require(
130             msg.sender == owner
131         );
132         _;
133     }
134     function payout() external ensureOwner {
135         _payout(address(0));
136     }
137     function B() external ensureOwner constant returns (uint256){
138         return address(this).balance;
139     }
140     // presale control
141     function End() external ensureOwner {
142          require(!isPresaleEnd);
143          isPresaleEnd = true;
144     }
145     function Gaoguans(address player) public ensureOwner view returns (uint8[]){
146         return last[player];
147     }
148 }