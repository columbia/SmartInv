1 pragma solidity ^0.4.16;
2 //Fixed Base EAC0 supply token contract
3 // (c) 7/7/2017. EACOINS;
4 // Define standard fields for ERC20 contract
5 contract ERC20 {
6    // uint public total a getter function instead
7    // NOTE from Jalmost every token contract uses public uint variable. Total supply of t I think. 
8     string public standard = 'ERC20';
9     function balanceOf(address who) constant returns (uint);
10     function allowance(address owner, address spender) constant returns (uint);
11     function transfer(address to, uint value) returns (bool ok);
12     function transferFrom(address from, address to, uint value) returns (bool ok);
13     function approve(address spender, uint value) returns (bool ok); 
14     event Transfer(address indexed from, address indexed to, uint value);
15     event Approval(address indexed owner, address indexed spender, uint value);
16 }
17 
18 // needed to add restrictions who could execute commands (in this case owner - person who deployed the contract)
19 
20 contract Ownable {
21     address public owner;
22     function Ownable() {
23         owner = msg.sender;
24     }
25   
26         modifier onlyOwner {
27         assert(msg.sender == owner);
28         _;
29     }
30 
31     function transferOwnership(address newOwner) onlyOwner {
32         if (newOwner != address(0)) owner = newOwner;
33     }
34 }
35 
36 // best practice to use safe mathematic operations to avoid major problems
37 library SafeMath { 
38     function safeMul(uint a, uint b) internal returns (uint) {
39         uint c = a * b;
40         assert(a == 0 || c / a == b);
41         return c;
42     }
43 
44     function safeDiv(uint a, uint b) internal returns (uint) {
45         // assert(b > 0); // NOTE (ihen): solidity will automatically throw when divided by 0
46         uint c = a / b;
47         return c;
48     }
49 
50     function safeSub(uint a, uint b) internal returns (uint) {
51         assert(b <= a);
52         return a - b;
53     }
54 
55     function safeAdd(uint a, uint b) internal returns (uint) {
56         uint c = a + b;
57         assert(c >= a); // a + b can't be larger than or equal to a when overflowed
58         return c;
59     }
60 
61     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
62         return a >= b ? a : b;
63     }
64 
65     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
66         return a < b ? a : b;
67     }
68 
69     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
70         return a >= b ? a : b;
71     }
72 
73     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
74         return a < b ? a : b;
75                      
76             
77     }
78   }
79 
80 contract TokenSpender {
81     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
82 }
83 
84 contract EACOIN is ERC20, Ownable {
85     using SafeMath for uint256;
86     /* Public variables of the token */
87     string public name;
88     string public symbol;
89     uint8 public decimals;
90     string public version = 'v1.0';
91   // uint public initialSupply;
92     uint public totalSupply;
93     mapping (address => uint) public balances; // NOTE(hen): those should be public
94     mapping (address => mapping (address => uint)) public allowed;
95 
96     function EACOIN() {
97         totalSupply = 100000000000000000000000000;
98         balances[msg.sender] = 100000000000000000000000000;
99         name = 'EACOIN';
100         symbol = 'EACO';
101         decimals = 18;
102     }
103 
104     function balanceOf(address who) constant returns (uint256) {
105         return balances[who];
106     }
107     function transfer(address _to, uint _value) returns (bool) {
108         if (balances[msg.sender] >= _value &&
109             _value > 0 /* zero transfer is not allowed */ &&
110             balances[_to] + _value > balances[_to] /* check overflow */) {
111                                       
112                 
113              balances[msg.sender] = balances[msg.sender] - _value;
114             balances[_to] = balances[_to] + _value;
115             Transfer(msg.sender, _to, _value);
116             return true;
117         } else {
118             return false;
119         }
120     }
121 
122     function approve(address spender, uint256 value) returns (bool) {
123         require(value > 0 && spender != 0x0);
124         allowed[msg.sender][spender] = value;
125         return true;
126     }
127 
128     function transferFrom(address _from, address _to, uint _value) returns (bool) {
129         if (balances[_from] >= _value &&
130             allowed[_from][msg.sender] >= _value &&
131             _value > 0 &&
132             balances[_to] + _value > balances[_to]) {
133              balances[_from] -= _value;
134              allowed[_from][msg.sender] -= _value;
135              balances[_to] += _value;
136              return true;
137           } else {
138              return false;
139          }
140     }
141     
142      /* Approve and then comunicate the approved contract in a single tx */
143         function approveAndCall(address _spender, uint256 _value, bytes _extraData) {
144          TokenSpender spender = TokenSpender(_spender);
145          if (approve(_spender, _value)) {
146              spender.receiveApproval(msg.sender, _value, this, _extraData);
147          }
148     }
149     function allowance(address _owner, address _spender) constant returns (uint remaining) {
150     return allowed[_owner][_spender];
151   }
152 }