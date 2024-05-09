1 pragma solidity ^0.4.18;
2 
3 //import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
4 //import 'zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol';
5 
6 
7 contract Ownable {
8     address public owner;
9 
10     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
11 
12     function Ownable() public {
13         owner = msg.sender;
14     }
15 
16     modifier onlyOwner() {
17         require(msg.sender == owner);
18         _;
19     }
20 
21     function transferOwnership(address newOwner) public onlyOwner {
22         require(newOwner != address(0));
23         OwnershipTransferred(owner, newOwner);
24         owner = newOwner;
25     }
26 }
27 
28 contract ERC20Basic {
29   function totalSupply() public view returns (uint256);
30   function balanceOf(address who) public view returns (uint256);
31   function transfer(address to, uint256 value) public returns (bool);
32   event Transfer(address indexed from, address indexed to, uint256 value);
33 }
34 
35 contract MyEtherHODL is Ownable {
36 
37     event Hodl(address indexed hodler, uint indexed amount, uint untilTime, uint duration);
38     event Party(address indexed hodler, uint indexed amount, uint duration);
39     event Fee(address indexed hodler, uint indexed amount, uint elapsed);
40 
41     address[] public hodlers;
42     mapping(address => uint) public indexOfHodler; // Starts from 1
43     mapping (address => uint) public balanceOf;
44     mapping (address => uint) public lockedUntil;
45     mapping (address => uint) public lockedFor;
46 
47     function get1(uint index) public constant 
48         returns(address hodler1, uint balance1, uint lockedUntil1, uint lockedFor1)
49     {
50         hodler1 = hodlers[index];
51         balance1 = balanceOf[hodler1];
52         lockedUntil1 = lockedUntil[hodler1];
53         lockedFor1 = lockedFor[hodler1];
54     }
55 
56     function get2(uint index) public constant 
57         returns(address hodler1, uint balance1, uint lockedUntil1, uint lockedFor1,
58                 address hodler2, uint balance2, uint lockedUntil2, uint lockedFor2)
59     {
60         hodler1 = hodlers[index];
61         balance1 = balanceOf[hodler1];
62         lockedUntil1 = lockedUntil[hodler1];
63         lockedFor1 = lockedFor[hodler1];
64 
65         hodler2 = hodlers[index + 1];
66         balance2 = balanceOf[hodler2];
67         lockedUntil2 = lockedUntil[hodler2];
68         lockedFor2 = lockedFor[hodler2];
69     }
70 
71     function get3(uint index) public constant 
72         returns(address hodler1, uint balance1, uint lockedUntil1, uint lockedFor1,
73                 address hodler2, uint balance2, uint lockedUntil2, uint lockedFor2,
74                 address hodler3, uint balance3, uint lockedUntil3, uint lockedFor3)
75     {
76         hodler1 = hodlers[index];
77         balance1 = balanceOf[hodler1];
78         lockedUntil1 = lockedUntil[hodler1];
79         lockedFor1 = lockedFor[hodler1];
80 
81         hodler2 = hodlers[index + 1];
82         balance2 = balanceOf[hodler2];
83         lockedUntil2 = lockedUntil[hodler2];
84         lockedFor2 = lockedFor[hodler2];
85 
86         hodler3 = hodlers[index + 2];
87         balance3 = balanceOf[hodler3];
88         lockedUntil3 = lockedUntil[hodler3];
89         lockedFor3 = lockedFor[hodler3];
90     }
91     
92     function hodlersCount() public constant returns(uint) {
93         return hodlers.length;
94     }
95 
96     function() public payable {
97         if (balanceOf[msg.sender] > 0) {
98             hodlFor(0); // Do not extend time-lock
99         } else {
100             hodlFor(1 years);
101         }
102     }
103 
104     function hodlFor1y() public payable {
105         hodlFor(1 years);
106     }
107 
108     function hodlFor2y() public payable {
109         hodlFor(2 years);
110     }
111 
112     function hodlFor3y() public payable {
113         hodlFor(3 years);
114     }
115 
116     function hodlFor(uint duration) internal {
117         if (indexOfHodler[msg.sender] == 0) {
118             hodlers.push(msg.sender);
119             indexOfHodler[msg.sender] = hodlers.length; // Store incremented value
120         }
121         balanceOf[msg.sender] += msg.value;
122         if (duration > 0) { // Extend time-lock if needed only
123             require(lockedUntil[msg.sender] < now + duration);
124             lockedUntil[msg.sender] = now + duration;
125             lockedFor[msg.sender] = duration;
126         }
127         Hodl(msg.sender, msg.value, lockedUntil[msg.sender], lockedFor[msg.sender]);
128     }
129 
130     function party() public {
131         partyTo(msg.sender);
132     }
133 
134     function partyTo(address hodler) public {
135         uint value = balanceOf[hodler];
136         require(value > 0);
137         balanceOf[hodler] = 0;
138 
139         if (now < lockedUntil[hodler]) {
140             require(msg.sender == hodler);
141             uint fee = value * 5 / 100;
142             owner.transfer(fee);
143             value -= fee;
144             Fee(hodler, fee, lockedUntil[hodler] - now);
145         }
146         
147         hodler.transfer(value);
148         Party(hodler, value, lockedFor[hodler]);
149 
150         uint index = indexOfHodler[hodler];
151         require(index > 0);
152         if (hodlers.length > 1) {
153             hodlers[index - 1] = hodlers[hodlers.length - 1];
154             indexOfHodler[hodlers[index - 1]] = index;
155         }
156         hodlers.length--;
157 
158         delete balanceOf[hodler];
159         delete lockedUntil[hodler];
160         delete lockedFor[hodler];
161         delete indexOfHodler[hodler];
162     }
163 
164     // From zeppelin-solidity CanReclaimToken.sol
165     function reclaimToken(ERC20Basic token) external onlyOwner {
166         uint256 balance = token.balanceOf(this);
167         token.transfer(owner, balance);
168     }
169 
170 }