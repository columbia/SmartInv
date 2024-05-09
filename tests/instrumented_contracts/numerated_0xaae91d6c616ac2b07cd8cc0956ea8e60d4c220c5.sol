1 pragma solidity ^0.4.18;
2 
3 // BOMBS!
4 
5 contract Bombs {
6   struct Bomb {
7     address owner;
8     uint8 bumps;
9     
10     uint8 chance;
11     uint8 increase;
12     
13     uint256 price;
14     uint256 last_price;
15     uint256 base_price;
16     uint256 pot;
17     
18     uint256 last_pot;
19     address last_winner;
20     uint8 last_bumps;
21     address made_explode;
22   }
23   mapping (uint8 => Bomb) public bombs;
24   uint256 start_price = 1000000000000000;
25 
26   address public ceoAddress;
27   modifier onlyCEO() { require(msg.sender == ceoAddress); _; }
28 
29   function Bombs() public {
30     ceoAddress = msg.sender;
31     bombs[0] = Bomb(msg.sender, 0, 3, 110, start_price, 0, start_price, 0, 0, address(0), 0, address(0));
32     bombs[1] = Bomb(msg.sender, 0, 80, 111, start_price, 0, start_price, 0, 0, address(0), 0, address(0));
33     bombs[2] = Bomb(msg.sender, 0, 50, 122, start_price, 0, start_price, 0, 0, address(0), 0, address(0));
34     bombs[3] = Bomb(msg.sender, 0, 25, 133, start_price, 0, start_price, 0, 0, address(0), 0, address(0));
35   }
36   
37   function getBomb(uint8 _id) public view returns (
38     uint8 id,
39     address owner,
40     uint8 bumps,
41     uint8 chance,
42     uint8 increase,
43     uint256 price,
44     uint256 last_price,
45     uint256 base_price,
46     uint256 pot,
47     uint256 last_pot,
48     address last_winner,
49     uint8 last_bumps,
50     address made_explode
51   ) {
52     id = _id;
53     owner = bombs[_id].owner;
54     bumps = bombs[_id].bumps;
55     chance = bombs[_id].chance;
56     increase = bombs[_id].increase;
57     price = bombs[_id].price;
58     last_price = bombs[_id].last_price;
59     base_price = bombs[_id].base_price;
60     pot = bombs[_id].pot;
61     last_pot = bombs[_id].last_pot;
62     last_winner = bombs[_id].last_winner;
63     last_bumps = bombs[_id].last_bumps;
64     made_explode = bombs[_id].made_explode;
65   }
66 
67   function getRandom(uint _max) public view returns (uint random){
68     random = uint(keccak256(block.blockhash(block.number-1),msg.gas,tx.gasprice,block.timestamp))%_max + 1;
69   }
70 
71   function buy(uint8 _bomb) public payable {
72     require(msg.sender != address(0));
73     Bomb storage bomb = bombs[_bomb];
74     require(msg.value >= bomb.price);
75 
76     uint256 excess = SafeMath.sub(msg.value, bomb.price);
77     uint256 diff = SafeMath.sub(bomb.price, bomb.last_price);
78     
79     uint _random = uint(keccak256(block.blockhash(block.number-1),msg.gas,tx.gasprice,block.timestamp))%bomb.chance + 1;
80     
81     if(_random == 1){
82       bomb.owner.transfer(SafeMath.add(bomb.last_price, SafeMath.add(bomb.pot, SafeMath.mul(SafeMath.div(diff, 100), 50))));
83       ceoAddress.transfer(SafeMath.mul(SafeMath.div(diff, 100), 50));
84 
85       bomb.last_winner = bomb.owner;
86       bomb.last_pot = bomb.pot;
87       bomb.last_bumps = bomb.bumps;
88       bomb.made_explode = msg.sender;
89       
90       bomb.price = bomb.base_price;
91       bomb.owner = ceoAddress;
92       bomb.pot = 0;
93       bomb.bumps = 0;
94       
95     } else {
96       bomb.owner.transfer(SafeMath.mul(SafeMath.div(diff, 100), 20));
97       bomb.owner.transfer(bomb.last_price);
98       if(bomb.made_explode == address(0)){
99         ceoAddress.transfer(SafeMath.mul(SafeMath.div(diff, 100), 30)); 
100       } else {
101         ceoAddress.transfer(SafeMath.mul(SafeMath.div(diff, 100), 25));
102         bomb.made_explode.transfer(SafeMath.mul(SafeMath.div(diff, 100), 5));
103       }
104       bomb.pot += SafeMath.mul(SafeMath.div(diff, 100), 50);
105       bomb.owner = msg.sender;
106     
107       bomb.last_price = bomb.price;
108       bomb.price = SafeMath.mul(SafeMath.div(bomb.price, 100), bomb.increase);
109       bomb.bumps += 1;
110 
111       msg.sender.transfer(excess);
112     }
113   }
114   
115   function addBomb(uint8 __id, uint256 __price, uint8 __chance, uint8 __increase) public onlyCEO {
116     bombs[__id] = Bomb(msg.sender, 0, __chance, __increase, __price, 0, __price, 0, 0, address(0), 0, address(0));
117   }
118 
119   function payout() public onlyCEO {
120     ceoAddress.transfer(this.balance);
121   }
122 }
123 
124 library SafeMath {
125   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
126     if (a == 0) {
127       return 0;
128     }
129     uint256 c = a * b;
130     assert(c / a == b);
131     return c;
132   }
133   function div(uint256 a, uint256 b) internal pure returns (uint256) {
134     uint256 c = a / b;
135     return c;
136   }
137   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
138     assert(b <= a);
139     return a - b;
140   }
141   function add(uint256 a, uint256 b) internal pure returns (uint256) {
142     uint256 c = a + b;
143     assert(c >= a);
144     return c;
145   }
146 }