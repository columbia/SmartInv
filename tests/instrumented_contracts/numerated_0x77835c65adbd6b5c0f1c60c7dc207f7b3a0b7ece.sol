1 pragma solidity ^0.4.25;
2 
3 
4 contract owned {
5     address public owner;
6 
7     constructor() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     function transferOwnership(address newOwner) onlyOwner public {
17         owner = newOwner;
18     }
19 }
20 
21 
22 contract HiveCapital is owned {
23 
24     string public name = "Hive Capital Token";
25     string public symbol = "HCT";
26     uint8 public decimals = 0;
27     uint256 public totalSupply = 10000000;
28 
29     // This creates an array with all balances
30     mapping (address => uint256) public balanceOf;
31     mapping (address => mapping (address => uint256)) public allowance;
32     mapping (address => bool) public frozenAccount;
33 
34 
35     event Transfer(address indexed from, address indexed to, uint256 value);
36     event Burn(address indexed from, uint256 value);
37     event Mine(address indexed to, uint256 value);
38     event FrozenFunds(address target, bool frozen);
39 
40     constructor() public {
41         balanceOf[msg.sender] = totalSupply;
42     }
43 
44 
45     function _transfer(address _from, address _to, uint _value) internal {
46         require(_to != 0x0);
47         require(balanceOf[_from] >= _value);
48         require(balanceOf[_to] + _value > balanceOf[_to]);
49 
50         require(!frozenAccount[_from]);
51         require(!frozenAccount[_to]);
52 
53         uint previousBalances = balanceOf[_from] + balanceOf[_to];
54         balanceOf[_from] -= _value;
55         balanceOf[_to] += _value;
56         emit Transfer(_from, _to, _value);
57         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
58     }
59 
60     function transfer(address _to, uint256 _value) public {
61         _transfer(msg.sender, _to, _value);
62     }
63 
64 
65     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
66         require(_value <= allowance[_from][msg.sender]);     // Check allowance
67         allowance[_from][msg.sender] -= _value;
68         _transfer(_from, _to, _value);
69         return true;
70     }
71 
72 
73     function approve(address _spender, uint256 _value) public
74         returns (bool success) {
75         allowance[msg.sender][_spender] = _value;
76         return true;
77     }
78 
79     function MineTo(address _to, uint256 _value) onlyOwner public returns (bool success) {
80         require (totalSupply + _value > totalSupply );
81 
82         totalSupply += _value;
83         balanceOf[_to] += _value;
84 
85         emit Mine(_to, _value);
86         emit Transfer(0x0, _to, _value);
87         return true;
88     }
89 
90     function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {
91         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
92         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
93         totalSupply -= _value;                              // Update totalSupply
94         emit Burn(_from, _value);
95         emit Transfer(_from, 0x0, _value);
96 
97         return true;
98     }
99 
100     function freezeAccount(address target, bool freeze) onlyOwner public {
101       frozenAccount[target] = freeze;
102       emit FrozenFunds(target, freeze);
103     }
104 }