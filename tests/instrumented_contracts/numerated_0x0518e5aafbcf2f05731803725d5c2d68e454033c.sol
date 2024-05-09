1 pragma solidity ^0.4.25;
2 
3 contract XIO {
4     uint private k = 1000000000000000000;
5     
6     string public name = 'XIO';
7     string public symbol = 'XIO';
8     uint8 public decimals = 18;
9     uint public totalSupply = 1000000000 * k;
10     uint public createdAt = block.number;
11     uint public lastMiningAt;
12     uint public unconfirmedTxs;
13 
14     address private lastSender;
15     address private lastOrigin;
16     
17     /* This creates an array with all balances */
18     mapping (address => uint256) public balanceOf;
19     mapping (address => uint256) public successesOf;
20     mapping (address => uint256) public failsOf;
21     mapping (address => mapping (address => uint256)) public allowance;
22     
23     /* This generates a public event on the blockchain that will notify clients */
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     
26     // This generates a public event on the blockchain that will notify clients
27     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
28 
29     // This notifies clients about the amount burnt
30     event Burn(address indexed from, uint256 value);
31     
32     event Mine(address indexed from, uint256 value, uint256 number, uint256 rollUnder);
33     event Dice(address indexed from, uint256 bet, uint256 prize, uint256 number, uint256 rollUnder);
34     
35     uint private seed;
36  
37     modifier notContract() {
38         lastSender = msg.sender;
39         lastOrigin = tx.origin;
40         require(lastSender == lastOrigin);
41         _;
42     }
43     
44     // uint256 to bytes32
45     function toBytes(uint256 x) internal pure returns (bytes b) {
46         b = new bytes(32);
47         assembly {
48             mstore(add(b, 32), x)
49         }
50     }
51     
52     // returns a pseudo-random number
53     function random(uint lessThan) internal returns (uint) {
54         seed += block.timestamp + uint(msg.sender);
55         return uint(sha256(toBytes(uint(blockhash(block.number - 1)) + seed))) % lessThan;
56     }
57     
58     /* Initializes contract with initial supply tokens to the creator of the contract */
59     constructor() public {
60         balanceOf[msg.sender] = totalSupply;
61     }
62     
63     /* Internal transfer, only can be called by this contract */
64     function _transfer(address _from, address _to, uint _value) internal {
65         require(_to != 0x0);
66         require(balanceOf[_from] >= _value);
67         require(balanceOf[_to] + _value > balanceOf[_to]);
68         uint previousBalances = balanceOf[_from] + balanceOf[_to];
69         balanceOf[_from] -= _value;
70         balanceOf[_to] += _value;
71         emit Transfer(_from, _to, _value);
72         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
73         
74         unconfirmedTxs++;
75     }
76     
77     /* Send coins */
78     function transfer(address _to, uint256 _value) public returns (bool success) {
79         _transfer(msg.sender, _to, _value);
80         return true;
81     }
82     
83     /* Transfer tokens from other address */
84     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
85         require(_value <= allowance[_from][msg.sender]);     // Check allowance
86         allowance[_from][msg.sender] -= _value;
87         _transfer(_from, _to, _value);
88         return true;
89     }
90     
91     /* Set allowance for other address */
92     function approve(address _spender, uint256 _value) public returns (bool success) {
93         allowance[msg.sender][_spender] = _value;
94         emit Approval(msg.sender, _spender, _value);
95         return true;
96     }
97     
98     /* Burn tokens */
99     function burn(uint256 _value) public returns (bool success) {
100         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
101         balanceOf[msg.sender] -= _value;            // Subtract from the sender
102         totalSupply -= _value;                      // Updates totalSupply
103         emit Burn(msg.sender, _value);
104         return true;
105     }
106     
107     function issue(uint256 _value) internal {
108         balanceOf[msg.sender] += _value;
109         totalSupply += _value;
110         emit Transfer(0, this, _value);
111         emit Transfer(this, msg.sender, _value);
112     }
113     
114     function getReward() public view returns (uint) {
115         uint pow = (block.number - createdAt) / 864000;
116         if (pow > 25) {
117             return 0;
118         }
119         return 50 * k / 2 ** pow;
120     }
121     
122     function canMine(address _user) public view returns (bool) {
123         return balanceOf[_user] * 10000 / totalSupply > 0;
124     }
125     
126     function dice(uint rollUnder, uint amount) public notContract {
127         require(rollUnder >= 2 && rollUnder <= 97);
128         require(balanceOf[msg.sender] >= amount);
129         
130         uint number = random(100);
131         if (number < rollUnder) {
132             uint prize = amount * 98 / rollUnder;
133             issue(prize - amount);
134             emit Dice(msg.sender, amount, prize, number, rollUnder);
135         } else {
136             burn(amount);
137             emit Dice(msg.sender, amount, 0, number, rollUnder);
138         }
139     }
140     
141     function mine() public notContract {
142         uint minedHashRel = random(65536);
143         uint balanceRel = balanceOf[msg.sender] * 10000 / totalSupply;
144         if (balanceRel > 0) {
145             uint rollUnder = (block.number - lastMiningAt) * balanceRel;
146             if (minedHashRel < rollUnder) {
147                 uint reward = getReward() + unconfirmedTxs * k;
148                 issue(reward);
149                 emit Mine(msg.sender, reward, minedHashRel, rollUnder);
150                 successesOf[msg.sender]++;
151                 
152                 lastMiningAt = block.number;
153                 unconfirmedTxs = 0;
154             } else {
155                 emit Transfer(this, msg.sender, 0);
156                 emit Mine(msg.sender, 0, minedHashRel, rollUnder);
157                 failsOf[msg.sender]++;
158             }
159         } else {
160             revert();
161         }
162     }
163 }