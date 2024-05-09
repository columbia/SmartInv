1 pragma solidity ^0.4.11;
2 
3 contract AvatarNetworkToken {
4 
5     // Token name
6     string public name = "Avatar_Network_Token";
7     
8     // Token symbol
9     string public constant symbol = "ATT";
10     
11     // Token decimals
12     uint256 public constant decimals = 6;
13     
14     // INIT SUPPLY
15     uint256 public constant INITIAL_SUPPLY = 6000000000 * (10 ** uint256(decimals));
16 
17     mapping (address => uint256) public balanceOf;
18     mapping (address => mapping (address => uint256)) public allowance;
19 
20     // Totle supply of Avatar Network Token
21     uint256 public totalSupply = 0;
22     
23     // Is Running
24     bool public stopped = false;
25 
26     address owner = 0x0;
27 
28     modifier isOwner {
29         assert(owner == msg.sender);
30         _;
31     }
32 
33     modifier isRunning {
34         assert (!stopped);
35         _;
36     }
37 
38     modifier validAddress {
39         assert(0x0 != msg.sender);
40         _;
41     }
42 
43     constructor() public {
44         owner = msg.sender;
45         totalSupply = INITIAL_SUPPLY;
46         balanceOf[msg.sender] = INITIAL_SUPPLY;
47         Transfer(0x0, msg.sender, INITIAL_SUPPLY);
48     }
49 
50     /**
51      * @dev Transfer token for a specified address
52      * @param _to The address to transfer to.
53      * @param _value The amount to be transferred.
54      */
55     function transfer(address _to, uint256 _value) isRunning validAddress public returns (bool success) {
56         // ATT token can't be burned
57         require(_to != address(0));
58         require(balanceOf[msg.sender] >= _value);
59         require(balanceOf[_to] + _value >= balanceOf[_to]);
60         balanceOf[msg.sender] -= _value;
61         balanceOf[_to] += _value;
62         Transfer(msg.sender, _to, _value);
63         return true;
64     }
65 
66     /**
67      * @dev Transfer tokens from one address to another
68      * @param _from address The address which you want to send tokens from
69      * @param _to address The address which you want to transfer to
70      * @param _value uint256 the amount of tokens to be transferred
71      */
72     function transferFrom(address _from, address _to, uint256 _value) isRunning validAddress public returns (bool success) {
73         // ATT token can't be burned
74         require(_to != address(0));
75         require(balanceOf[_from] >= _value);
76         require(balanceOf[_to] + _value >= balanceOf[_to]);
77         require(allowance[_from][msg.sender] >= _value);
78         balanceOf[_to] += _value;
79         balanceOf[_from] -= _value;
80         allowance[_from][msg.sender] -= _value;
81         Transfer(_from, _to, _value);
82         return true;
83     }
84 
85     function approve(address _spender, uint256 _value) isRunning validAddress public returns (bool success) {
86         require(_value == 0 || allowance[msg.sender][_spender] == 0);
87         allowance[msg.sender][_spender] = _value;
88         Approval(msg.sender, _spender, _value);
89         return true;
90     }
91     
92     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
93         return allowance[_owner][_spender];
94     }
95 
96     function stop() isOwner public {
97         stopped = true;
98     }
99 
100     function start() isOwner public {
101         stopped = false;
102     }
103 
104     function setName(string _name) isOwner public {
105         name = _name;
106     }
107 
108     event Transfer(address indexed _from, address indexed _to, uint256 _value);
109     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
110 }