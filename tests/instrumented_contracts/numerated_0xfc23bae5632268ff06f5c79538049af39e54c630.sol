1 pragma solidity ^0.4.18;
2 
3 contract MPTToken {
4 
5     string   public name ;            //  token name
6     string   public symbol ;          //  token symbol
7     uint256  public decimals ;        //  token digit
8 
9     mapping (address => uint256) public balanceOf;
10     mapping (address => bool) public frozenAccount;
11     mapping (address => uint256) public frozenBalance; 
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14     uint256 public totalSupply = 0;
15     bool public stopped = false;      //  stopflag: true is stoped,false is not stoped
16 
17     uint256 constant valueFounder = 300000000000000000;
18     address owner = 0x0;
19 
20     modifier isOwner {
21         assert(owner == msg.sender);
22         _;
23     }
24 
25     modifier isRunning {
26         assert (!stopped);
27         _;
28     }
29 
30     modifier validAddress {
31         assert(0x0 != msg.sender);
32         _;
33     }
34 
35     function MPTToken(address _addressFounder,uint256 _initialSupply, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) public {
36         owner = msg.sender;
37         if (_addressFounder == 0x0)
38             _addressFounder = msg.sender;
39         if (_initialSupply == 0) 
40             _initialSupply = valueFounder;
41         totalSupply = _initialSupply;   // Set the totalSupply 
42         name = _tokenName;              // Set the name for display 
43         symbol = _tokenSymbol;          // Set the symbol for display 
44         decimals = _decimalUnits;       // Amount of decimals for display purposes
45         balanceOf[_addressFounder] = totalSupply;
46         Transfer(0x0, _addressFounder, totalSupply);
47     }
48     /* stop contract */
49     function stop() public isOwner {
50         stopped = true;
51     }
52     /* start contract */
53     function start() public isOwner {
54         stopped = false;
55     }
56     /* set contract name */
57     function setName(string _name) public isOwner {
58         name = _name;
59     }
60     /* set contract owner */
61     function setOwner(address _owner) public isOwner {
62         owner = _owner;
63     }
64     /* send coins */
65     function transfer(address _to, uint256 _value) public isRunning validAddress returns (bool success) {
66         require(!frozenAccount[msg.sender]);
67         require(balanceOf[msg.sender] - frozenBalance[msg.sender] >= _value);
68         require(balanceOf[_to] + _value >= balanceOf[_to]);
69         balanceOf[msg.sender] -= _value;
70         balanceOf[_to] += _value;
71         Transfer(msg.sender, _to, _value);
72         return true;
73     }
74     /* freeze account of target */
75     function freezeAccount(address _target) public isOwner {
76         frozenAccount[_target] = true;
77         FrozenFunds(_target, true);
78     }
79     /* unfreeze account of target */
80     function unfreezeAccount(address _target) public isOwner {
81         frozenAccount[_target] = false;
82         FrozenFunds(_target, false);
83     }
84     /* freeze Balance of target */
85     function freezeBalance(address _target,uint256 _value) public isOwner {
86         frozenBalance[_target] = _value;
87         FrozenCoins(_target, _value);
88     }
89     /* unfreeze Balance of target */
90     function unfreezeBalance(address _target) public isOwner {
91         frozenBalance[_target] = 0;
92         FrozenCoins(_target, 0);
93     }
94     /* burn coins */
95     function burn(uint256 _value) public {
96         require(balanceOf[msg.sender] >= _value);
97         balanceOf[msg.sender] -= _value;
98         balanceOf[0x0] += _value;
99         Transfer(msg.sender, 0x0, _value);
100     }
101     /* Allow another contract to spend some tokens in your behalf */
102     function approve(address _spender, uint256 _value) public returns (bool success) {
103         allowance[msg.sender][_spender] = _value;
104         Approval(msg.sender, _spender, _value);
105         return true;
106     }
107     /* A contract attempts to get the coins */
108     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
109         require(!frozenAccount[msg.sender]);
110         require(balanceOf[_from] - frozenBalance[_from] >= _value);
111         require(balanceOf[_to] + _value >= balanceOf[_to]);
112         require(allowance[_from][msg.sender] >= _value) ;     // Check allowance
113         balanceOf[_from] -= _value;                           // Subtract from the sender
114         balanceOf[_to] += _value;                             // Add the same to the recipient
115         allowance[_from][msg.sender] -= _value; 
116         Transfer(_from, _to, _value);
117         return true;
118     }
119 
120     event Transfer(address indexed _from, address indexed _to, uint256 _value);
121     event FrozenFunds(address _target, bool _frozen);
122     event FrozenCoins(address _target, uint256 _value); 
123     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
124 }