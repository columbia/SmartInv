1 pragma solidity ^0.4.0;
2 
3 contract ForeignToken {
4     function balanceOf(address _owner) public constant returns (uint256);
5     function transfer(address _to, uint256 _value) public returns (bool);
6 }
7 
8 contract ERC20Basic {
9  
10   uint256 public totalSupply;
11   function balanceOf(address who) public constant returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 
15 }
16 
17 
18 //assigning token to ERC20
19 contract ERC20 is ERC20Basic {
20 
21   function allowance(address owner, address spender) public constant returns (uint256);
22   function transferFrom(address from, address to, uint256 value) public returns (bool);
23   function approve(address spender, uint256 value) public returns (bool);
24   event Approval(address indexed owner, address indexed spender, uint256 value);
25 
26 }
27 
28 library SaferMath {
29   function mulX(uint256 a, uint256 b) internal constant returns (uint256) {
30     uint256 c = a * b;
31     assert(a == 0 || c / a == b);
32     return c;
33   }
34 
35   function divX(uint256 a, uint256 b) internal constant returns (uint256) {
36     // assert(b > 0); // Solidity automatically throws when dividing by 0
37     uint256 c = a / b;
38     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
39     return c;
40   }
41 
42   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
43     assert(b <= a);
44     return a - b;
45   }
46 
47   function add(uint256 a, uint256 b) internal constant returns (uint256) {
48     uint256 c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 
55 
56 contract MERCULET is ERC20 {
57     
58     address owner = msg.sender;
59 
60     mapping (address => uint256) balances;
61     mapping (address => mapping (address => uint256)) allowed;
62     
63     uint256 public totalSupply = 1000000000 * 10**8;
64 
65     function name() public constant returns (string) { return "MERCULET"; }
66     function symbol() public constant returns (string) { return "MVP"; }
67     function decimals() public constant returns (uint8) { return 8; }
68 
69     event Transfer(address indexed _from, address indexed _to, uint256 _value);
70     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
71 
72 
73     function MERCULET() public {
74         owner = msg.sender;
75         balances[msg.sender] = totalSupply;
76     }
77 
78     modifier onlyOwner { 
79         require(msg.sender == owner);
80         _;
81     }
82 
83     function transferOwnership(address newOwner) onlyOwner public {
84         owner = newOwner;
85     }
86 
87     function getEthBalance(address _addr) constant public returns(uint) {
88     return _addr.balance;
89     }
90 
91     function airdropMVP(address[] addresses, uint256 _value) onlyOwner public {
92          for (uint i = 0; i < addresses.length; i++) {
93              balances[owner] -= _value;
94              balances[addresses[i]] += _value;
95              emit Transfer(owner, addresses[i], _value);
96          }
97     }
98     
99     
100     function balanceOf(address _owner) constant public returns (uint256) {
101 	 return balances[_owner];
102     }
103 
104     // mitigates the ERC20 short address attack
105     modifier onlyPayloadSize(uint size) {
106         assert(msg.data.length >= size + 4);
107         _;
108     }
109     
110     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
111 
112          if (balances[msg.sender] >= _amount
113              && _amount > 0
114              && balances[_to] + _amount > balances[_to]) {
115              balances[msg.sender] -= _amount;
116              balances[_to] += _amount;
117              Transfer(msg.sender, _to, _amount);
118              return true;
119          } else {
120              return false;
121          }
122     }
123     
124     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
125 
126          if (balances[_from] >= _amount
127              && allowed[_from][msg.sender] >= _amount
128              && _amount > 0
129              && balances[_to] + _amount > balances[_to]) {
130              balances[_from] -= _amount;
131              allowed[_from][msg.sender] -= _amount;
132              balances[_to] += _amount;
133              Transfer(_from, _to, _amount);
134              return true;
135          } else {
136             return false;
137          }
138     }
139     
140     function approve(address _spender, uint256 _value) public returns (bool success) {
141         // mitigates the ERC20 spend/approval race condition
142         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
143         
144         allowed[msg.sender][_spender] = _value;
145         
146         Approval(msg.sender, _spender, _value);
147         return true;
148     }
149     
150     function allowance(address _owner, address _spender) constant public returns (uint256) {
151         return allowed[_owner][_spender];
152     }
153 
154     function withdrawForeignTokens(address _tokenContract) public returns (bool) {
155         require(msg.sender == owner);
156         ForeignToken token = ForeignToken(_tokenContract);
157         uint256 amount = token.balanceOf(address(this));
158         return token.transfer(owner, amount);
159     }
160 
161 
162 }