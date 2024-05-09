1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6         if (a == 0) {
7             return 0;
8         }
9         c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         return a / b;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
24         c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 contract EnterpriseCerditPass {
31     
32     using SafeMath for uint256;
33     
34     address public owner;
35     string public name;
36     string public symbol;
37     uint public decimals;
38     uint256 public totalSupply;
39     
40     mapping (address => uint256) internal balances;
41     mapping (address => mapping (address => uint256)) internal allowed;
42 
43     event Transfer(address indexed from, address indexed to, uint256 value);
44     event Approval(address indexed owner, address indexed spender, uint256 value);
45     event Burn(address indexed from, uint256 value);
46     
47     mapping (address => bool) public frozenAccount;
48     event FrozenFunds(address indexed target, bool frozen);
49 
50     constructor(
51         uint256 initialSupply,
52         string tokenName,
53         string tokenSymbol,
54         uint decimalUnits
55     ) public {
56         owner = msg.sender;
57         name = tokenName;
58         symbol = tokenSymbol; 
59         decimals = decimalUnits;
60         totalSupply = initialSupply * 10 ** uint256(decimals);
61         balances[msg.sender] = totalSupply;
62     }
63 
64     modifier onlyOwner {
65         require(msg.sender == owner);
66         _;
67     }
68 
69     function transferOwnership(address _newOwner) onlyOwner public {
70         if (_newOwner != address(0)) {
71             owner = _newOwner;
72         }
73     }
74     function balanceOf(address _address) view public returns (uint256 balance) {
75         return balances[_address];
76     }
77     
78     /* Internal transfer, only can be called by this contract */
79     function _transfer(address _from, address _to, uint256 _value) internal {
80         require (_to != address(0));                        // Prevent transfer to 0x0 address. Use burn() instead
81         require (balances[_from] >= _value);                // Check if the sender has enough
82         require (balances[_to] + _value > balances[_to]);   // Check for overflows
83         require(!frozenAccount[_from]);                     // Check if sender is frozen
84         require(!frozenAccount[_to]);                       // Check if recipient is frozen
85         balances[_from] = balances[_from].sub(_value);      // Subtract from the sender
86         balances[_to] = balances[_to].add(_value);          // Add the same to the recipient
87         emit Transfer(_from, _to, _value);
88     }
89 
90     function transfer(address _to, uint256 _value) public returns (bool success) {
91         _transfer(msg.sender, _to, _value);
92         return true;
93     }
94 
95     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
96         require(_value <= balances[_from]);
97         require(_value <= allowed[_from][msg.sender]);     // Check allowance
98         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
99         _transfer(_from, _to, _value);
100         return true;
101     }
102 
103     function approve(address _spender, uint256 _value) public returns (bool success) {
104         allowed[msg.sender][_spender] = _value;
105         emit Approval(msg.sender, _spender, _value);
106         return true;
107     }
108     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
109         return allowed[_owner][_spender];
110     }
111 
112     function freezeAccount(address target, bool freeze) onlyOwner public {
113         frozenAccount[target] = freeze;
114         emit FrozenFunds(target, freeze);
115     }
116 
117     function transferBatch(address[] _to, uint256 _value) public returns (bool success) {
118         for (uint i=0; i<_to.length; i++) {
119             _transfer(msg.sender, _to[i], _value);
120         }
121         return true;
122     }
123 }