1 pragma solidity ^0.4.24;
2 
3 /******************************************/
4 /*       Netkiller ADVANCED TOKEN         */
5 /******************************************/
6 /* Author netkiller <netkiller@msn.com>   */
7 /* Home http://www.netkiller.cn           */
8 /* Version 2018-06-13 - SafeMatch         */
9 /******************************************/
10 library SafeMath {
11 
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         if (a == 0) {
14             return 0;
15         }
16         c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         return a / b;
23     }
24 
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         assert(b <= a);
27         return a - b;
28     }
29 
30     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
31         c = a + b;
32         assert(c >= a);
33         return c;
34     }
35 }
36 
37 contract NetkillerAdvancedToken {
38     
39     using SafeMath for uint256;
40     
41     address public owner;
42     string public name;
43     string public symbol;
44     uint public decimals;
45     uint256 public totalSupply;
46     
47     mapping (address => uint256) internal balances;
48     mapping (address => mapping (address => uint256)) internal allowed;
49 
50     event Transfer(address indexed from, address indexed to, uint256 value);
51     event Approval(address indexed owner, address indexed spender, uint256 value);
52     event Burn(address indexed from, uint256 value);
53     
54     mapping (address => bool) public frozenAccount;
55     event FrozenFunds(address indexed target, bool frozen);
56 
57     constructor(
58         uint256 initialSupply,
59         string tokenName,
60         string tokenSymbol,
61         uint decimalUnits
62     ) public {
63         owner = msg.sender;
64         name = tokenName;
65         symbol = tokenSymbol; 
66         decimals = decimalUnits;
67         totalSupply = initialSupply * 10 ** uint256(decimals);
68         balances[msg.sender] = totalSupply;
69     }
70 
71     modifier onlyOwner {
72         require(msg.sender == owner);
73         _;
74     }
75 
76     function transferOwnership(address _newOwner) onlyOwner public {
77         if (_newOwner != address(0)) {
78             owner = _newOwner;
79         }
80     }
81     function balanceOf(address _address) view public returns (uint256 balance) {
82         return balances[_address];
83     }
84     
85     /* Internal transfer, only can be called by this contract */
86     function _transfer(address _from, address _to, uint256 _value) internal {
87         require (_to != address(0));                        // Prevent transfer to 0x0 address. Use burn() instead
88         require (balances[_from] >= _value);                // Check if the sender has enough
89         require (balances[_to] + _value > balances[_to]);   // Check for overflows
90         require(!frozenAccount[_from]);                     // Check if sender is frozen
91         require(!frozenAccount[_to]);                       // Check if recipient is frozen
92         balances[_from] = balances[_from].sub(_value);      // Subtract from the sender
93         balances[_to] = balances[_to].add(_value);          // Add the same to the recipient
94         emit Transfer(_from, _to, _value);
95     }
96 
97     function transfer(address _to, uint256 _value) public returns (bool success) {
98         _transfer(msg.sender, _to, _value);
99         return true;
100     }
101 
102     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
103         require(_value <= balances[_from]);
104         require(_value <= allowed[_from][msg.sender]);     // Check allowance
105         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
106         _transfer(_from, _to, _value);
107         return true;
108     }
109 
110     function approve(address _spender, uint256 _value) public returns (bool success) {
111         allowed[msg.sender][_spender] = _value;
112         emit Approval(msg.sender, _spender, _value);
113         return true;
114     }
115     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
116         return allowed[_owner][_spender];
117     }
118 
119     function freezeAccount(address target, bool freeze) onlyOwner public {
120         frozenAccount[target] = freeze;
121         emit FrozenFunds(target, freeze);
122     }
123 
124     function transferBatch(address[] _to, uint256 _value) public returns (bool success) {
125         for (uint i=0; i<_to.length; i++) {
126             _transfer(msg.sender, _to[i], _value);
127         }
128         return true;
129     }
130 }