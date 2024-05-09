1 pragma solidity ^0.4.19;
2 
3 contract Token {
4    
5     uint256 public totalSupply;
6 
7     
8     function balanceOf(address _owner) public constant returns (uint256 balance);
9 
10    
11     function transfer(address _to, uint256 _value) public returns (bool success);
12 
13   
14     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
15 
16   
17     function approve(address _spender, uint256 _value) public returns (bool success);
18 
19   
20     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
21 
22     event Transfer(address indexed _from, address indexed _to, uint256 _value);
23     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
24 }
25 library SafeMath 
26 {
27   function mul(uint256 a, uint256 b) internal constant returns (uint256) 
28   {
29     if (a == 0) {
30       return 0;
31     }
32     uint256 c = a * b;
33     assert(c / a == b);
34     return c;
35   }
36 
37   function div(uint256 a, uint256 b) internal constant returns (uint256) {
38     // assert(b > 0); // Solidity automatically throws when dividing by 0
39     uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41     return c;
42   }
43 
44   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
45     assert(b <= a);
46     return a - b;
47   }
48 
49   function add(uint256 a, uint256 b) internal constant returns (uint256) {
50     uint256 c = a + b;
51     assert(c >= a);
52     return c;
53   }
54 }
55 contract StandardToken is Token {
56 using SafeMath for uint256;
57     function transfer(address _to, uint256 _value) public returns (bool success) {
58         
59        require(
60          balances[msg.sender] >= _value
61          && _value > 0
62          );
63           balances[msg.sender]=balances[msg.sender].sub(_value);
64            balances[_to]=balances[_to].add(_value);
65           Transfer(msg.sender,_to,_value);
66           return true;
67       
68     }
69 
70     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
71        
72        require(
73          allowed[_from][msg.sender] >= _value
74          &&  balances[_from]>=_value
75          &&  _value > 0
76          );
77           balances[_from]= balances[_from].sub(_value);
78            balances[_to]=balances[_to].add(_value);
79          allowed[_from][msg.sender] = allowed[_from][msg.sender].sub( _value);
80         Transfer(_from,_to,_value);
81           return true;
82     }
83 
84     function balanceOf(address _owner) public constant returns (uint256 balance) {
85         return balances[_owner];
86     }
87 
88     function approve(address _spender, uint256 _value) public returns (bool success) {
89         allowed[msg.sender][_spender] = _value;
90         Approval(msg.sender, _spender, _value);
91         return true;
92     }
93 
94     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
95       return allowed[_owner][_spender];
96     }
97 
98     mapping (address => uint256) balances;
99     mapping (address => mapping (address => uint256)) allowed;
100 }
101 
102 contract Owned {
103     address public owner;
104 
105     modifier onlyOwner() {
106         require(msg.sender == owner);
107         _;
108     }
109 
110     function Owned() public {
111         owner = msg.sender;
112     }
113 
114     function transferOwnership(address _owner) public onlyOwner {
115         require(_owner != 0x0);
116         owner = _owner;
117     }
118 }
119 
120 contract testTokan3 is StandardToken, Owned {
121     string public name = "testTokan3";
122     uint256 public decimals = 18;
123     string public symbol = "TST3";
124    
125     
126     function testTokan3() public {
127       
128        totalSupply = 10000000e18;
129         balances[msg.sender] = totalSupply;
130     }
131 
132     function() public payable {
133         revert();
134     }
135     
136     /* Approves and then calls the receiving contract */
137     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
138         allowed[msg.sender][_spender] = _value;
139         Approval(msg.sender, _spender, _value);
140 
141         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
142         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
143         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
144         if (!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { 
145             revert(); 
146         }
147         return true;
148     }
149 }