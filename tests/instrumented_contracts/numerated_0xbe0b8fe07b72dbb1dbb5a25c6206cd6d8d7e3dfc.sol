1 pragma solidity ^0.4.18;
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
41 contract BCBcyCoin is ERC20 {
42     
43     using SafeMath for uint256;
44     address owner = msg.sender;
45 
46     mapping (address => uint256) balances;
47     mapping (address => mapping (address => uint256)) allowed;
48 
49     string public constant name = "BCB Candy";
50     string public constant symbol = "BCBcy";
51     uint public constant decimals = 8;
52     uint256 public totalSupply = 1700000000e8;
53 
54     event Transfer(address indexed _from, address indexed _to, uint256 _value);
55     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
56     event Burn(address indexed burner, uint256 value);
57 
58     modifier onlyOwner() {
59         require(msg.sender == owner);
60         _;
61     }
62 
63     function BCBcyCoin () public {
64         owner = msg.sender;
65 		balances[msg.sender] = totalSupply;
66     }
67     
68     function transferOwnership(address newOwner) onlyOwner public {
69         if (newOwner != address(0)) {
70             owner = newOwner;
71         }
72     }
73 
74     function balanceOf(address _owner) constant public returns (uint256) {
75 	    return balances[_owner];
76     }
77 
78     // mitigates the ERC20 short address attack
79     modifier onlyPayloadSize(uint size) {
80         assert(msg.data.length >= size + 4);
81         _;
82     }
83     
84     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
85 
86         require(_to != address(0));
87         require(_amount <= balances[msg.sender]);
88         
89         balances[msg.sender] = balances[msg.sender].sub(_amount);
90         balances[_to] = balances[_to].add(_amount);
91         Transfer(msg.sender, _to, _amount);
92         return true;
93     }
94     
95     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
96 
97         require(_to != address(0));
98         require(_amount <= balances[_from]);
99         require(_amount <= allowed[_from][msg.sender]);
100         
101         balances[_from] = balances[_from].sub(_amount);
102         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
103         balances[_to] = balances[_to].add(_amount);
104         Transfer(_from, _to, _amount);
105         return true;
106     }
107     
108     function approve(address _spender, uint256 _value) public returns (bool success) {
109         allowed[msg.sender][_spender] = _value;
110         Approval(msg.sender, _spender, _value);
111         return true;
112     }
113     
114     function allowance(address _owner, address _spender) constant public returns (uint256) {
115         return allowed[_owner][_spender];
116     }
117     
118     function withdraw() onlyOwner public {
119         uint256 etherBalance = this.balance;
120         owner.transfer(etherBalance);
121     }
122     
123     function burn(uint256 _value) onlyOwner public {
124         require(_value <= balances[msg.sender]);
125 
126         address burner = msg.sender;
127         balances[burner] = balances[burner].sub(_value);
128         totalSupply = totalSupply.sub(_value);
129         Burn(burner, _value);
130     }
131     
132     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
133         allowed[msg.sender][_spender] = _value;
134         Approval(msg.sender, _spender, _value);
135         
136         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
137         return true;
138     }
139 }