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
41 contract CUNCoin is ERC20 {
42     
43     using SafeMath for uint256;
44     address public owner = msg.sender;
45 
46     mapping (address => uint256) balances;
47     mapping (address => mapping (address => uint256)) allowed;
48 
49     string public constant name = "CUNCoin";
50     string public constant symbol = "CUN";
51     uint public constant decimals = 8;
52     uint256 public totalSupply = 1000000000e8;
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
63     modifier onlyPayloadSize(uint size) {
64         assert(msg.data.length >= size + 4);
65         _;
66     }
67 
68     function CUNCoin () public {
69         owner = msg.sender;
70 		    balances[msg.sender] = totalSupply;
71     }
72     
73     function transferOwnership(address newOwner) onlyOwner public {
74         if (newOwner != address(0)) {
75             owner = newOwner;
76         }
77     }
78 
79     function balanceOf(address _owner) constant public returns (uint256) {
80 	      return balances[_owner];
81     }
82     
83     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
84 
85         require(_to != address(0));
86         require(_amount <= balances[msg.sender]);
87         
88         balances[msg.sender] = balances[msg.sender].sub(_amount);
89         balances[_to] = balances[_to].add(_amount);
90         Transfer(msg.sender, _to, _amount);
91         return true;
92     }
93     
94     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
95 
96         require(_to != address(0));
97         require(_amount <= balances[_from]);
98         require(_amount <= allowed[_from][msg.sender]);
99         
100         balances[_from] = balances[_from].sub(_amount);
101         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
102         balances[_to] = balances[_to].add(_amount);
103         Transfer(_from, _to, _amount);
104         return true;
105     }
106     
107     function approve(address _spender, uint256 _value) public returns (bool success) {
108         allowed[msg.sender][_spender] = _value;
109         Approval(msg.sender, _spender, _value);
110         return true;
111     }
112     
113     function allowance(address _owner, address _spender) constant public returns (uint256) {
114         return allowed[_owner][_spender];
115     }
116     
117     function withdraw() onlyOwner public {
118         uint256 etherBalance = this.balance;
119         owner.transfer(etherBalance);
120     }
121     
122     function burn(uint256 _value) onlyOwner public {
123         require(_value <= balances[msg.sender]);
124 
125         address burner = msg.sender;
126         balances[burner] = balances[burner].sub(_value);
127         totalSupply = totalSupply.sub(_value);
128         Burn(burner, _value);
129     }
130     
131     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
132         allowed[msg.sender][_spender] = _value;
133         Approval(msg.sender, _spender, _value);
134         
135         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
136         return true;
137     }
138 }