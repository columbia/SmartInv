1 pragma solidity >=0.4.22 <0.6.0;
2 
3 contract owned {
4     address public owner;
5     address public manager;
6     address public operation;
7     address public miner;
8 
9     constructor() public {
10         owner = msg.sender;
11     }
12 
13     modifier onlyOwner {
14         require(msg.sender == owner);
15         _;
16     }
17     
18     modifier onlyManager {
19         require(msg.sender == manager);
20         _;
21     }
22     
23     modifier onlyOperation {
24         require(msg.sender == operation || msg.sender == manager);
25         _;
26     }
27     
28     modifier onlyMiner {
29         require(msg.sender == miner);
30         _;
31     }
32     
33     modifier onlyOwnerAndManager {
34         require(msg.sender == owner || msg.sender == manager);
35         _;
36     }
37     
38     modifier onlyManagerAndOperation {
39         require(msg.sender == operation || msg.sender == manager);
40         _;
41     }
42 
43     function transferOwnership(address newOwner) onlyOwner public {
44         owner = newOwner;
45     }
46     
47     function setManager(address newManager) onlyOwnerAndManager public {
48         manager = newManager;
49     }
50     
51     function setOperation(address newOperation) onlyOwnerAndManager public {
52         operation = newOperation;
53     }
54     
55     function setMiner(address newMiner) onlyOwnerAndManager public {
56         miner = newMiner;
57     }
58 }
59 
60 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }
61 
62 contract TokenERC20 {
63 
64     string public name;
65     string public symbol;
66     uint8 public decimals = 18;
67     uint256 public totalSupply;
68     uint256 public supplyLimit;
69 
70     mapping (address => uint256) public balanceOf;
71     mapping (address => mapping (address => uint256)) public allowance;
72 
73     event Mint(address indexed from, address indexed to, uint256 value);
74     event Transfer(address indexed from, address indexed to, uint256 value);
75     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
76     event Burn(address indexed from, uint256 value);
77 
78     constructor() public {
79         totalSupply = 0;
80         supplyLimit = 0;
81         name = 'Bitkub Token';
82         symbol = 'KUB';
83     }
84 
85     function _transfer(address _from, address _to, uint _value) internal {
86         require(_to != address(0x0));
87         require(balanceOf[_from] >= _value);
88         require(balanceOf[_to] + _value > balanceOf[_to]);
89         uint previousBalances = balanceOf[_from] + balanceOf[_to];
90         balanceOf[_from] -= _value;
91         balanceOf[_to] += _value;
92         emit Transfer(_from, _to, _value);
93         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
94     }
95 
96     function transfer(address _to, uint256 _value) public returns (bool success) {
97         _transfer(msg.sender, _to, _value);
98         return true;
99     }
100 
101     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
102         require(_value <= allowance[_from][msg.sender]);
103         allowance[_from][msg.sender] -= _value;
104         _transfer(_from, _to, _value);
105         return true;
106     }
107 
108     function approve(address _spender, uint256 _value) public
109         returns (bool success) {
110         allowance[msg.sender][_spender] = _value;
111         emit Approval(msg.sender, _spender, _value);
112         return true;
113     }
114 
115     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
116         public
117         returns (bool success) {
118         tokenRecipient spender = tokenRecipient(_spender);
119         if (approve(_spender, _value)) {
120             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
121             return true;
122         }
123     }
124 
125     function burn(uint256 _value) public returns (bool success) {
126         require(balanceOf[msg.sender] >= _value);
127         balanceOf[msg.sender] -= _value;
128         totalSupply -= _value;
129         emit Burn(msg.sender, _value);
130         return true;
131     }
132 
133     function burnFrom(address _from, uint256 _value) public returns (bool success) {
134         require(balanceOf[_from] >= _value);
135         require(_value <= allowance[_from][msg.sender]);
136         balanceOf[_from] -= _value;
137         allowance[_from][msg.sender] -= _value;
138         totalSupply -= _value;
139         emit Burn(_from, _value);
140         return true;
141     }
142 }
143 
144 
145 contract Token is owned, TokenERC20 {
146     string public detail;
147     string public website;
148     address public dapp;
149 
150     mapping (address => bool) public frozenAccount;
151 
152     event FrozenFunds(address target, bool frozen);
153     event SetSupply(uint256 value, string note);
154     event BurnDirect(address indexed from, uint256 value, string note);
155 
156     constructor() TokenERC20() public {}
157 
158     function setDetail(string memory newDetail, string memory newWebsite) onlyOwnerAndManager public {
159         detail = newDetail;
160         website = newWebsite;
161     }
162     
163     function setSupply(uint _value,string memory _note) onlyOwnerAndManager public {
164         require (totalSupply <= _value);
165         supplyLimit = _value;
166         emit SetSupply(_value, _note);
167     }
168     
169     function setDapp(address _address) onlyOwnerAndManager public {
170         dapp = _address;
171     }
172     
173     function _transfer(address _from, address _to, uint _value) internal {
174         require (_to != address(0x0));
175         require (balanceOf[_from] >= _value);
176         require (balanceOf[_to] + _value >= balanceOf[_to]);
177         require(!frozenAccount[_from]);
178         require(!frozenAccount[_to]);
179         balanceOf[_from] -= _value;
180         balanceOf[_to] += _value;
181         emit Transfer(_from, _to, _value);
182     }
183 
184     function transfer(address _to, uint256 _value) public returns (bool success) {
185         _transfer(msg.sender, _to, _value);
186         return true;
187     }
188 
189     function freezeAccount(address _target, bool _freeze) onlyManagerAndOperation public {
190         frozenAccount[_target] = _freeze;
191         emit FrozenFunds(_target, _freeze);
192     }
193 
194     function mintToken(address _target, uint _value) onlyMiner public {
195         require (_target != address(0x0));
196         require (totalSupply <= supplyLimit);
197         balanceOf[_target] += _value;
198         totalSupply += _value;
199         emit Transfer(address(0), address(this), _value);
200         emit Transfer(address(this), _target, _value);
201     }
202 
203     function directBurn(address _from, uint _value,string memory _note) onlyMiner public{
204         require (_from != address(0x0));
205         require(balanceOf[_from] >= _value );
206         balanceOf[_from] -= _value;
207         totalSupply -= _value;
208         emit BurnDirect(_from, _value, _note);
209     }
210 
211 }