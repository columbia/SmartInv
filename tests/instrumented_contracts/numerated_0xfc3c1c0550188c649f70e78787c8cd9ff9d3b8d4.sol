1 pragma solidity ^0.4.11;
2 
3 /**
4                 +----+
5                /    /|
6    by cubic   +----+ |
7    2017       |    | +
8               |    |/
9               +----+
10 */
11 
12 contract Cubic {
13 
14     uint public creationTime = now;
15     address public owner = msg.sender;
16     uint256 public totalEthHandled = 0; 
17     uint public rate = 0; 
18     Cube[] public Cubes;
19 
20     /*
21     Events
22     */
23 
24     event Freeze(address indexed from, address indexed cubeAddress, uint amount, uint unlockedAfter, string api);
25     event Deliver(address indexed cube, address indexed destination, uint amount);
26 
27     /*
28     Public/External functions
29     */
30 
31     function() payable { }
32 
33     function getCubeCount() external constant returns(uint) {
34         return Cubes.length;
35     }
36 
37     function freeze(uint blocks) external payable {
38         secure(blocks, 'cubic');
39     }
40 
41     function freezeAPI(uint blocks, string api) external payable {
42         secure(blocks, api);
43     }
44 
45     function forgetCube(Cube iceCube) external {
46 
47         uint id = iceCube.id();
48         require(msg.sender == address(Cubes[id]));
49 
50         if (id != Cubes.length - 1) {
51             Cubes[id] = Cubes[Cubes.length - 1];
52             Cubes[id].setId(id);
53         }
54         Cubes.length--;        
55 
56         Deliver(address(iceCube), iceCube.destination(), iceCube.balance);
57     }
58 
59     /*
60     Only Owner
61     */
62 
63     function withdraw() external {
64         require(msg.sender == owner);        
65         owner.transfer(this.balance);
66     }
67 
68     function transferOwnership(address newOwner) external {
69         require(msg.sender == owner);        
70         owner = newOwner;
71     }
72 
73     /*
74     Private
75     */
76 
77 	function secure(uint blocks, string api) private {
78 
79         require(msg.value > 0);
80         uint amountToFreeze = msg.value; 
81         totalEthHandled = add(totalEthHandled, amountToFreeze);
82           
83         /* 
84          The rate starts at zero, over time as this 
85          contract is trusted the higher the fee 
86          becomes with an upward limit of half of one
87          percent (.50%). The owner of the contract CAN NOT 
88          adjust this. 
89         */
90         if (rate != 200 ) {
91 
92             if (totalEthHandled > 5000 ether) {
93                 setRate(200);  //.50 of one percent
94             } else if (totalEthHandled > 1000 ether) { 
95                 setRate(500);  //.20 of one percent
96             } else if (totalEthHandled > 100 ether) { 
97                 setRate(1000); //.10 of one percent
98             }
99         }
100 
101         if (rate > 0) {
102             uint fee = div(amountToFreeze, rate);
103             amountToFreeze = sub(amountToFreeze, fee);
104         }
105 
106         Cube newCube = (new Cube).value(amountToFreeze)(msg.sender, add(block.number, blocks), this);
107         newCube.setId(Cubes.push(newCube) - 1);
108         Freeze(msg.sender, address(newCube), amountToFreeze, add(block.number, blocks), api);
109 	}
110 
111     function setRate(uint _newRate) private {
112         rate = _newRate; 
113     }
114 
115     function add(uint a, uint b) private returns (uint) {
116         uint c = a + b;
117         assert(c >= a);
118         return c;
119     }
120 
121     function div(uint a, uint b) private returns (uint) {
122         assert(b > 0);
123         uint c = a / b;
124         assert(a == b * c + a % b);
125         return c;
126     }
127 
128     function sub(uint a, uint b) private returns (uint) {
129         assert(b <= a);
130         return a - b;
131     }
132 
133 }
134 
135 contract Cube {
136 
137     address public destination;
138     Cubic public cubicContract;    
139     uint public unlockedAfter;
140     uint public id;
141     
142 	function Cube(address _destination, uint _unlockedAfter, Cubic _cubicContract) payable {
143 		destination = _destination;
144 		unlockedAfter = _unlockedAfter;
145         cubicContract = _cubicContract;       
146 	}
147 
148     function() payable {
149         require(msg.value == 0);
150     }
151 
152     function setId(uint _id) external {
153         require(msg.sender == address(cubicContract));
154         id = _id; 
155     }
156 
157     function deliver() external {
158         assert(block.number > unlockedAfter); 
159         cubicContract.forgetCube(this);
160 		selfdestruct(destination);		
161 	}
162 }