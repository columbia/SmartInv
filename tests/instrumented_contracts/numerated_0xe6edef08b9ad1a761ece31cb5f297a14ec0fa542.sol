1 pragma solidity ^0.4.20;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract ERC20Basic {
28     uint256 public totalSupply;
29     function balanceOf(address who) public constant returns (uint256);
30     function transfer(address to, uint256 value) public returns (bool);
31     event Transfer(address indexed from, address indexed to, uint256 value);
32 }
33 
34 contract ERC20 is ERC20Basic {
35     function allowance(address owner, address spender) public constant returns (uint256);
36     function transferFrom(address from, address to, uint256 value) public returns (bool);
37     function approve(address spender, uint256 value) public returns (bool);
38     event Approval(address indexed owner, address indexed spender, uint256 value);
39 }
40 
41 contract CTPCash is ERC20 {
42     
43     using SafeMath for uint256; 
44     address owner = msg.sender; 
45 
46     mapping (address => uint256) balances; 
47     mapping (address => mapping (address => uint256)) allowed;
48     mapping (address => bool) public frozenAccount;
49 
50     string public constant name = "CTPCash";
51     string public constant symbol = "cc";
52     uint public constant decimals = 2;
53     
54     uint256 public totalSupply = 1000000000000000e2;
55 
56     event Transfer(address indexed _from, address indexed _to, uint256 _value);
57     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
58     event FrozenFunds(address target, bool frozen);
59 
60     modifier onlyOwner() {
61         require(msg.sender == owner);
62         _;
63     }
64 
65     modifier onlyPayloadSize(uint size) {
66         assert(msg.data.length >= size + 4);
67         _;
68     }
69 
70      function CTPCash() public {
71         owner = msg.sender;
72         balances[msg.sender] = totalSupply;
73     }
74 
75     function transferOwnership(address newOwner) onlyOwner public {
76         if (newOwner != address(0) && newOwner != owner) {
77              owner = newOwner;   
78         }
79     }
80 
81     function freeze(address[] addresses,bool locked) onlyOwner public {
82         
83         require(addresses.length <= 255);
84         
85         for (uint i = 0; i < addresses.length; i++) {
86             freezeAccount(addresses[i], locked);
87         }
88     }
89     
90     function freezeAccount(address target, bool B) private {
91         frozenAccount[target] = B;
92         FrozenFunds(target, B);
93     }
94 
95     function balanceOf(address _owner) constant public returns (uint256) {
96 	    return balances[_owner];
97     }
98 
99     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
100 
101         require(_to != address(0));
102         require(_amount <= balances[msg.sender]);
103         require(!frozenAccount[msg.sender]);                     
104         require(!frozenAccount[_to]);                      
105         balances[msg.sender] = balances[msg.sender].sub(_amount);
106         balances[_to] = balances[_to].add(_amount);
107         Transfer(msg.sender, _to, _amount);
108         return true;
109     }
110   
111     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
112 
113         require(_to != address(0));
114         require(_amount <= balances[_from]);
115         require(_amount <= allowed[_from][msg.sender]);
116         require(!frozenAccount[_from]);                     
117         require(!frozenAccount[_to]);      
118         balances[_from] = balances[_from].sub(_amount);
119         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
120         balances[_to] = balances[_to].add(_amount);
121         Transfer(_from, _to, _amount);
122         return true;
123     }
124 
125     function approve(address _spender, uint256 _value) public returns (bool success) {
126         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
127         allowed[msg.sender][_spender] = _value;
128         Approval(msg.sender, _spender, _value);
129         return true;
130     }
131 
132     function allowance(address _owner, address _spender) constant public returns (uint256) {
133         return allowed[_owner][_spender];
134     }
135 
136     function withdraw() onlyOwner public {
137         uint256 etherBalance = this.balance;
138         address owner = msg.sender;
139         owner.transfer(etherBalance);
140     }
141 }