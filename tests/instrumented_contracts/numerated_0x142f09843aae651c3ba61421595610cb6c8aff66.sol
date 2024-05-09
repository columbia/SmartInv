1 pragma solidity ^0.4.19;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract W4T {
6     string public name = 'W4T';
7     string public symbol = 'W4T';
8     uint8 public decimals = 18;
9     uint256 public totalSupply = 1000000000000000000000000;
10     uint public miningReward = 1000000000000000000;
11     uint private randomNumber;
12     
13     address public owner;
14     
15     uint public domainPrice = 10000000000000000000; // 10 W4T
16     uint public bytePrice   = 100000000000000;      // 0.0001 W4T
17     uint public premiumDomainK = 10;
18     
19     /* This creates an array with all balances */
20     mapping (address => uint256) public balanceOf;
21     mapping (address => uint256) public successesOf;
22     mapping (address => uint256) public failsOf;
23     mapping (address => mapping (address => uint256)) public allowance;
24     mapping (bytes8 => bool) public zones;
25     mapping (bytes8 => mapping (bytes32 => address)) public domains;
26     mapping (bytes8 => mapping (bytes32 => mapping (bytes32 => string))) public pages;
27     
28     /* This generates a public event on the blockchain that will notify clients */
29     event Transfer(address indexed from, address indexed to, uint256 value);
30 
31     // This notifies clients about the amount burnt
32     event Burn(address indexed from, uint256 value);
33     
34     event ZoneRegister(bytes8 zone);
35     event DomainRegister(bytes8 zone, string domain, address owner);
36     event PageRegister(bytes8 zone, string domain, bytes32 path, string content);
37     event DomainTransfer(bytes8 zone, string domain, address owner);
38     
39     function stringToBytes32(string memory source) internal pure returns (bytes32 result) {
40         assembly {
41             result := mload(add(source, 32))
42         }
43     }
44     
45     /* Initializes contract with initial supply tokens to the creator of the contract */
46     function W4T() public {
47         owner = msg.sender;
48         balanceOf[msg.sender] = totalSupply;
49     }
50 
51     modifier onlyOwner {
52         if (msg.sender != owner) revert();
53         _;
54     }
55     
56     function transferOwnership(address newOwner) external onlyOwner {
57         owner = newOwner;
58     }
59     
60     /* Internal transfer, only can be called by this contract */
61     function _transfer(address _from, address _to, uint _value) internal {
62         require(_to != 0x0);
63         require(balanceOf[_from] >= _value);
64         require(balanceOf[_to] + _value > balanceOf[_to]);
65         uint previousBalances = balanceOf[_from] + balanceOf[_to];
66         balanceOf[_from] -= _value;
67         balanceOf[_to] += _value;
68         Transfer(_from, _to, _value);
69         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
70     }
71     
72     /* Send coins */
73     function transfer(address _to, uint256 _value) external {
74         _transfer(msg.sender, _to, _value);
75     }
76     
77     /* Transfer tokens from other address */
78     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {
79         require(_value <= allowance[_from][msg.sender]);     // Check allowance
80         allowance[_from][msg.sender] -= _value;
81         _transfer(_from, _to, _value);
82         return true;
83     }
84     
85     /* Set allowance for other address */
86     function approve(address _spender, uint256 _value) public returns (bool success) {
87         allowance[msg.sender][_spender] = _value;
88         return true;
89     }
90     
91     /* Set allowance for other address and notify */
92     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
93         tokenRecipient spender = tokenRecipient(_spender);
94         if (approve(_spender, _value)) {
95             spender.receiveApproval(msg.sender, _value, this, _extraData);
96             return true;
97         }
98     }
99     
100     function burn(uint256 _value) internal returns (bool success) {
101         require(balanceOf[msg.sender] >= _value);
102         balanceOf[msg.sender] -= _value;
103         totalSupply -= _value;
104         Burn(msg.sender, _value);
105         return true;
106     }
107     
108     function registerZone(bytes8 zone) external onlyOwner {
109         zones[zone] = true;
110         ZoneRegister(zone);
111     }
112     
113     function registerDomain(bytes8 zone, string domain) external {
114         uint domainLength = bytes(domain).length;
115         require(domainLength >= 2 && domainLength <= 32);
116         bytes32 domainBytes = stringToBytes32(domain);
117         require(zones[zone]);
118         require(domains[zone][domainBytes] == 0x0);
119         
120         uint amount = domainPrice;
121         if (domainLength <= 4) {
122             amount *= premiumDomainK ** (5 - domainLength);
123         }
124         burn(amount);
125         domains[zone][domainBytes] = msg.sender;
126         DomainRegister(zone, domain, msg.sender);
127     }
128     
129     function registerPage(bytes8 zone, string domain, bytes32 path, string content) external {
130         uint domainLength = bytes(domain).length;
131         require(domainLength >= 2 && domainLength <= 32);
132         bytes32 domainBytes = stringToBytes32(domain);
133         require(zones[zone]);
134         require(domains[zone][domainBytes] == msg.sender);
135         
136         burn(bytePrice * bytes(content).length);
137         pages[zone][domainBytes][path] = content;
138         PageRegister(zone, domain, path, content);
139     }
140     
141     function transferDomain(bytes8 zone, string domain, address newOwner) external {
142         uint domainLength = bytes(domain).length;
143         require(domainLength >= 2 && domainLength <= 32);
144         bytes32 domainBytes = stringToBytes32(domain);
145         require(zones[zone]);
146         require(domains[zone][domainBytes] == msg.sender);
147         
148         domains[zone][domainBytes] = newOwner;
149         DomainTransfer(zone, domain, newOwner);
150     }
151     
152     function () external payable {
153         if (msg.value == 0) {
154             randomNumber += block.timestamp + uint(msg.sender);
155             uint minedAtBlock = uint(block.blockhash(block.number - 1));
156             uint minedHashRel = uint(sha256(minedAtBlock + randomNumber + uint(msg.sender))) % 100000;
157             uint balanceRel = balanceOf[msg.sender] * 1000 / totalSupply;
158             if (balanceRel >= 1) {
159                 if (balanceRel > 29) {
160                     balanceRel = 29;
161                 }
162                 balanceRel = 2 ** balanceRel;
163                 balanceRel = 50000 / balanceRel;
164                 balanceRel = 50000 - balanceRel;
165                 if (minedHashRel < balanceRel) {
166                     uint reward = miningReward + minedHashRel * 100000000000000;
167                     balanceOf[msg.sender] += reward;
168                     totalSupply += reward;
169                     Transfer(0, this, reward);
170                     Transfer(this, msg.sender, reward);
171                     successesOf[msg.sender]++;
172                 } else {
173                     Transfer(this, msg.sender, 0);
174                     failsOf[msg.sender]++;
175                 }
176             } else {
177                 revert();
178             }
179         } else {
180             revert();
181         }
182     }
183 }