1 pragma solidity ^0.4.11;
2 
3 contract LOTT {
4     string public name = 'LOTT';
5     string public symbol = 'LOTT';
6     uint8 public decimals = 18;
7     uint256 public totalSupply = 1000000000000000000000000;
8     
9     mapping (address => uint256) public balanceOf;
10     mapping (address => mapping (address => uint256)) public allowance;
11     
12     address public owner;
13     uint public price = 10000000000000000000;
14     uint public fee = 256000000000000000000;
15     uint public currentRound = 0;
16     uint8 public placesSold;
17     uint[] public places = [
18         768000000000000000000,
19         614400000000000000000,
20         460800000000000000000,
21         307200000000000000000,
22         153600000000000000000
23     ];
24     uint public rand1;
25     uint8 public rand2;
26     
27     mapping (uint => mapping (uint8 => address)) public map;
28     mapping (address => uint256) public gameBalanceOf;
29     
30     event Transfer(address indexed from, address indexed to, uint256 value);
31     
32     event BalanceChange(address receiver, uint newBalance);
33     event RoundChange(uint newRound);
34     event Place(uint round, uint8 place, address backer);
35     event Finish(uint round, uint8 place1, uint8 place2, uint8 place3, uint8 place4, uint8 place5);
36     
37     function LOTT() public {
38         balanceOf[msg.sender] = totalSupply;
39         
40         owner = msg.sender;
41     }
42 
43     function _transfer(address _from, address _to, uint _value) internal {
44         require(_to != 0x0);
45         require(balanceOf[_from] >= _value);
46         require(balanceOf[_to] + _value > balanceOf[_to]);
47         uint previousBalances = balanceOf[_from] + balanceOf[_to];
48         balanceOf[_from] -= _value;
49         balanceOf[_to] += _value;
50         Transfer(_from, _to, _value);
51         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
52     }
53 
54     function transfer(address _to, uint256 _value) external {
55         _transfer(msg.sender, _to, _value);
56     }
57 
58     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {
59         require(_value <= allowance[_from][msg.sender]);     // Check allowance
60         allowance[_from][msg.sender] -= _value;
61         _transfer(_from, _to, _value);
62         return true;
63     }
64 
65     function approve(address _spender, uint256 _value) external returns (bool success) {
66         allowance[msg.sender][_spender] = _value;
67         return true;
68     }
69     
70     function withdraw() external {
71         require(gameBalanceOf[msg.sender] > 0);
72         
73         _transfer(this, msg.sender, gameBalanceOf[msg.sender]);
74         
75         gameBalanceOf[msg.sender] = 0;
76         BalanceChange(msg.sender, 0);
77     }
78     
79     function place(uint8 cell) external {
80         require(map[currentRound][cell] == 0x0);
81         _transfer(msg.sender, this, price);
82         
83         map[currentRound][cell] = msg.sender;
84         Place(currentRound, cell, msg.sender);
85         rand1 += uint(msg.sender) + block.timestamp;
86         rand2 -= uint8(msg.sender);
87         if (placesSold < 255) {
88             placesSold++;
89         } else {
90             placesSold = 0;
91             bytes32 hashRel = bytes32(uint(block.blockhash(block.number - rand2 - 1)) + block.timestamp + rand1);
92             
93             uint8 place1 = uint8(hashRel[31]);
94             uint8 place2 = uint8(hashRel[30]);
95             uint8 place3 = uint8(hashRel[29]);
96             uint8 place4 = uint8(hashRel[28]);
97             uint8 place5 = uint8(hashRel[27]);
98             
99             if (place2 == place1) {
100                 place2++;
101             }
102             
103             if (place3 == place1) {
104                 place3++;
105             }
106             if (place3 == place2) {
107                 place3++;
108             }
109             
110             if (place4 == place1) {
111                 place4++;
112             }
113             if (place4 == place2) {
114                 place4++;
115             }
116             if (place4 == place3) {
117                 place4++;
118             }
119             
120             if (place5 == place1) {
121                 place5++;
122             }
123             if (place5 == place2) {
124                 place5++;
125             }
126             if (place5 == place3) {
127                 place5++;
128             }
129             if (place5 == place4) {
130                 place5++;
131             }
132             
133             gameBalanceOf[map[currentRound][place1]] += places[0];
134             gameBalanceOf[map[currentRound][place2]] += places[1];
135             gameBalanceOf[map[currentRound][place3]] += places[2];
136             gameBalanceOf[map[currentRound][place4]] += places[3];
137             gameBalanceOf[map[currentRound][place5]] += places[4];
138             gameBalanceOf[owner] += fee;
139             
140             BalanceChange(map[currentRound][place1], gameBalanceOf[map[currentRound][place1]]);
141             BalanceChange(map[currentRound][place2], gameBalanceOf[map[currentRound][place2]]);
142             BalanceChange(map[currentRound][place3], gameBalanceOf[map[currentRound][place3]]);
143             BalanceChange(map[currentRound][place4], gameBalanceOf[map[currentRound][place4]]);
144             BalanceChange(map[currentRound][place5], gameBalanceOf[map[currentRound][place5]]);
145             BalanceChange(owner, gameBalanceOf[owner]);
146             
147             Finish(currentRound, place1, place2, place3, place4, place5);
148             
149             currentRound++;
150             RoundChange(currentRound);
151         }
152     }
153 }