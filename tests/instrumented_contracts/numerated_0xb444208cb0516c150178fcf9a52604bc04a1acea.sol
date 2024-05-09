1 pragma solidity ^0.4.18;
2 
3 
4 contract owned {
5     address public owner;
6     address public candidate;
7 
8     function owned() payable internal {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner {
13         require(owner == msg.sender);
14         _;
15     }
16 
17     function changeOwner(address _owner) onlyOwner public {
18         candidate = _owner;
19     }
20 
21     function confirmOwner() public {
22         require(candidate != address(0));
23         require(candidate == msg.sender);
24         owner = candidate;
25         delete candidate;
26     }
27 }
28 
29 
30 library SafeMath {
31     function sub(uint256 a, uint256 b) pure internal returns (uint256) {
32         assert(a >= b);
33         return a - b;
34     }
35 
36     function add(uint256 a, uint256 b) pure internal returns (uint256) {
37         uint256 c = a + b;
38         assert(c >= a && c >= b);
39         return c;
40     }
41 }
42 
43 
44 contract ERC20 {
45     uint256 public totalSupply;
46     function balanceOf(address who) public constant returns (uint256 value);
47     function allowance(address owner, address spender) public constant returns (uint256 _allowance);
48     function transfer(address to, uint256 value) public returns (bool success);
49     function transferFrom(address from, address to, uint256 value) public returns (bool success);
50     function approve(address spender, uint256 value) public returns (bool success);
51 
52     event Transfer(address indexed from, address indexed to, uint256 value);
53     event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 
57 contract GreenMed is ERC20, owned {
58     using SafeMath for uint256;
59     string public name = "GreenMed";
60     string public symbol = "GRMD";
61     uint8 public decimals = 18;
62     uint256 public totalSupply;
63 
64     mapping (address => uint256) private balances;
65     mapping (address => mapping (address => uint256)) private allowed;
66     mapping (address => bool) public frozenAccount;
67 
68     event FrozenFunds(address target, bool frozen);
69     event Burn(address indexed from, uint256 value);
70 
71     function balanceOf(address _who) public constant returns (uint256) {
72         return balances[_who];
73     }
74 
75     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
76         return allowed[_owner][_spender];
77     }
78 
79     function GreenMed() public {
80         totalSupply = 100000000 * 1 ether;
81         balances[msg.sender] = totalSupply;
82         Transfer(0, msg.sender, totalSupply);
83     }
84 
85     function transfer(address _to, uint256 _value) public returns (bool success) {
86         require(_to != address(0));
87         require(balances[msg.sender] >= _value);
88         require(!frozenAccount[msg.sender] && !frozenAccount[_to]);
89         balances[msg.sender] = balances[msg.sender].sub(_value);
90         balances[_to] = balances[_to].add(_value);
91         Transfer(msg.sender, _to, _value);
92         return true;
93     }
94 
95     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
96         require(_to != address(0));
97         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
98         require(!frozenAccount[_from] && !frozenAccount[_to]);
99         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
100         balances[_from] = balances[_from].sub(_value);
101         balances[_to] = balances[_to].add(_value);
102         Transfer(_from, _to, _value);
103         return true;
104     }
105 
106     function approve(address _spender, uint256 _value) public returns (bool success) {
107         require(_spender != address(0));
108         require(balances[msg.sender] >= _value);
109         require(!frozenAccount[_spender] && !frozenAccount[msg.sender]);
110         allowed[msg.sender][_spender] = _value;
111         Approval(msg.sender, _spender, _value);
112         return true;
113     }
114 
115     function freezeAccount(address target, bool freeze) onlyOwner public {
116         frozenAccount[target] = freeze;
117         FrozenFunds(target, freeze);
118     }
119 
120     function burn(uint256 _value) onlyOwner public returns (bool success) {
121         balances[this] = balances[this].sub(_value);
122         totalSupply = totalSupply.sub(_value);
123         Burn(this, _value);
124         return true;
125     }
126 }