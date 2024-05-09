1 /**
2  * Source Code first verified at https://etherscan.io on Monday, June 3, 2019
3  (UTC) */
4 
5 pragma solidity ^0.4.21;
6 
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a / b;
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 contract ERC20Basic {
32     uint256 public totalSupply;
33     function balanceOf(address who) public constant returns (uint256);
34     function transfer(address to, uint256 value) public returns (bool);
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 }
37 
38 contract ERC20 is ERC20Basic {
39     function allowance(address owner, address spender) public constant returns (uint256);
40     function transferFrom(address from, address to, uint256 value) public returns (bool);
41     function approve(address spender, uint256 value) public returns (bool);
42     event Approval(address indexed owner, address indexed spender, uint256 value);
43 }
44 
45 contract FXBSCoin is ERC20 {
46     
47     using SafeMath for uint256;
48     address public owner = msg.sender;
49 
50     mapping (address => uint256) balances;
51     mapping (address => mapping (address => uint256)) allowed;
52 
53     string public constant name = "FXB";
54     string public constant symbol = "FXB";
55     uint public constant decimals = 8;
56     uint256 public totalSupply = 10000000000e8;
57 
58     event Transfer(address indexed _from, address indexed _to, uint256 _value);
59     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
60     event Burn(address indexed burner, uint256 value);
61 
62     modifier onlyOwner() {
63         require(msg.sender == owner);
64         _;
65     }
66 
67     function FXBSCoin () public {
68         owner = msg.sender;
69         balances[msg.sender] = totalSupply;
70     }
71     
72     function transferOwnership(address newOwner) onlyOwner public {
73         if (newOwner != address(0)) {
74             owner = newOwner;
75         }
76     }
77 
78     function balanceOf(address _owner) constant public returns (uint256) {
79 	    return balances[_owner];
80     }
81 
82     // mitigates the ERC20 short address attack
83     modifier onlyPayloadSize(uint size) {
84         assert(msg.data.length >= size + 4);
85         _;
86     }
87     
88     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
89 
90         require(_to != address(0));
91         require(_amount <= balances[msg.sender]);
92         
93         balances[msg.sender] = balances[msg.sender].sub(_amount);
94         balances[_to] = balances[_to].add(_amount);
95         emit Transfer(msg.sender, _to, _amount);
96         return true;
97     }
98     
99     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
100 
101         require(_to != address(0));
102         require(_amount <= balances[_from]);
103         require(_amount <= allowed[_from][msg.sender]);
104         
105         balances[_from] = balances[_from].sub(_amount);
106         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
107         balances[_to] = balances[_to].add(_amount);
108         emit Transfer(_from, _to, _amount);
109         return true;
110     }
111     
112     function approve(address _spender, uint256 _value) public returns (bool success) {
113         allowed[msg.sender][_spender] = _value;
114         emit Approval(msg.sender, _spender, _value);
115         return true;
116     }
117     
118     function allowance(address _owner, address _spender) constant public returns (uint256) {
119         return allowed[_owner][_spender];
120     }
121     
122     function burn(uint256 _value) onlyOwner public {
123         require(_value <= balances[msg.sender]);
124 
125         address burner = msg.sender;
126         balances[burner] = balances[burner].sub(_value);
127         totalSupply = totalSupply.sub(_value);
128         emit Burn(burner, _value);
129     }
130     
131     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
132         allowed[msg.sender][_spender] = _value;
133         emit Approval(msg.sender, _spender, _value);
134         
135         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
136         return true;
137     }
138 }