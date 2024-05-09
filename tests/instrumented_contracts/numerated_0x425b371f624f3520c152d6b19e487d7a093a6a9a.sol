1 pragma solidity ^0.4.18;
2 
3 contract owned {
4     address public owner;
5     address public candidate;
6 
7     function owned() payable internal {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner {
12         require(owner == msg.sender);
13         _;
14     }
15 
16     function changeOwner(address _owner) onlyOwner public {
17         candidate = _owner;
18     }
19 
20     function confirmOwner() public {
21         require(candidate != address(0));
22         require(candidate == msg.sender);
23         owner = candidate;
24         delete candidate;
25     }
26 }
27 
28 library SafeMath {
29     function sub(uint256 a, uint256 b) pure internal returns (uint256) {
30         assert(a >= b);
31         return a - b;
32     }
33 
34     function add(uint256 a, uint256 b) pure internal returns (uint256) {
35         uint256 c = a + b;
36         assert(c >= a && c >= b);
37         return c;
38     }
39 }
40 
41 contract ERC20 {
42     uint256 public totalSupply;
43     function balanceOf( address who ) public constant returns (uint256 value);
44     function allowance( address owner, address spender ) public constant returns (uint256 _allowance);
45 
46     function transfer( address to, uint256 value) public returns (bool success);
47     function transferFrom( address from, address to, uint256 value) public returns (bool success);
48     function approve( address spender, uint256 value ) public returns (bool success);
49 
50     event Transfer( address indexed from, address indexed to, uint256 value);
51     event Approval( address indexed owner, address indexed spender, uint256 value);
52 }
53 
54 contract GreenMed  is ERC20, owned {
55     using SafeMath for uint256;
56     string public name = "GreenMed";
57     string public symbol = "GRMD";
58     uint8 public decimals = 18;
59     uint256 public totalSupply;
60 
61     mapping (address => uint256) private balances;
62     mapping (address => mapping (address => uint256)) private allowed;
63     mapping (address => bool) public frozenAccount;
64 
65     event FrozenFunds(address target, bool frozen);
66     event Burn(address indexed from, uint256 value);
67 
68     function balanceOf(address _who) public constant returns (uint256) {
69         return balances[_who];
70     }
71 
72     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
73         return allowed[_owner][_spender];
74     }
75 
76     function GreenMed() public {
77         totalSupply = 100000000 * 1 ether;
78         balances[msg.sender] = totalSupply;
79         Transfer(0, msg.sender, totalSupply);
80     }
81 
82     function _transfer(address _from, address _to, uint256 _value) internal {
83         require(_to != address(0));
84         require(_value <= balances[_from]);
85         require(!frozenAccount[_from] && !frozenAccount[_to]);
86         balances[_from] = balances[_from].sub(_value);
87         balances[_to] = balances[_to].add(_value);
88         Transfer(_from, _to, _value);
89     }
90 
91     function transfer(address _to, uint256 _value) public returns (bool success) {
92         _transfer(msg.sender, _to, _value);
93         return true;
94     }
95 
96     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
97         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
98         balances[_to] = balances[_to].add(_value);
99         balances[_from] = balances[_from].sub(_value);
100         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
101         Transfer(_from, _to, _value);
102         return true;
103     }
104 
105     function approve(address _spender, uint256 _value) public returns (bool success) {
106         require(balances[msg.sender] >= _value);
107         allowed[msg.sender][_spender] = _value;
108         Approval(msg.sender, _spender, _value);
109         return true;
110     }
111 
112     function freezeAccount(address target, bool freeze) onlyOwner public {
113         frozenAccount[target] = freeze;
114         FrozenFunds(target, freeze);
115     }
116 
117     function burn(uint256 _value) onlyOwner public returns (bool success) {
118         balances[this] = balances[this].sub(_value);
119         totalSupply = totalSupply.sub(_value);
120         Burn(this, _value);
121         return true;
122     }
123 }