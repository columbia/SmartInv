1 pragma solidity ^0.4.18;
2 /**
3 *   Crowdsale contracts edited from original contract code at https://www.ethereum.org/crowdsale#crowdfund-your-idea
4 *   Additional crowdsale contracts, functions, libraries from OpenZeppelin
5 *       at https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts/token
6 *   Token contract edited from original contract code at https://www.ethereum.org/token
7 *   ERC20 interface and certain token functions adapted from https://github.com/ConsenSys/Tokens
8 **/
9 contract ERC20 {
10 
11     event Approval(address indexed _owner, address indexed _spender, uint _value);
12     event Transfer(address indexed _from, address indexed _to, uint _value);
13     function allowance(address _owner, address _spender) public constant returns (uint remaining);
14     function approve(address _spender, uint _value) public returns (bool success);
15     function balanceOf(address _owner) public constant returns (uint balance);
16     function transfer(address _to, uint _value) public returns (bool success);
17     function transferFrom(address _from, address _to, uint _value) returns (bool success);
18 }
19 
20 contract Owned {
21 
22     address public owner;
23 
24     function Owned() {
25         owner = msg.sender;
26     }
27 
28     modifier onlyOwner {
29         require(msg.sender == owner);
30         _;
31     }
32 
33     function transferOwnership(address newOwner) onlyOwner {
34         owner = newOwner;
35     }
36 }
37 library SafeMath {
38     function add(uint256 a, uint256 b) internal returns (uint256) {
39         uint256 c = a + b;
40         assert(c >= a);
41         return c;
42     }
43     function div(uint256 a, uint256 b) internal returns (uint256) {
44         uint256 c = a / b;
45         return c;
46     }
47     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
48         return a >= b ? a : b;
49     }
50     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
51         return a >= b ? a : b;
52     }
53     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
54         return a < b ? a : b;
55     }
56     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
57         return a < b ? a : b;
58     }
59     function mul(uint256 a, uint256 b) internal returns (uint256) {
60         uint256 c = a * b;
61         assert(a == 0 || c / a == b);
62         return c;
63     }
64     function sub(uint256 a, uint256 b) internal returns (uint256) {
65         assert(b <= a);
66         return a - b;
67     }
68 }
69 contract Scrinium is ERC20, Owned {
70 
71     using SafeMath for uint256;
72 
73     string public name = "Scrinium";
74     string public symbol = "SCR";
75     uint256 public decimals = 8;
76     uint256 multiplier = 100000000;
77 
78     uint256 public totalSupply;
79     uint256 public hardcap = 180000000;
80 
81     uint256 public constant startTime = 1514678400;//5.12.2017
82     uint256 public constant stopTime = 1521590400; //21.03.2018
83 
84     mapping (address => uint256) balance;
85     mapping (address => mapping (address => uint256)) allowed;
86 
87     function Scrinium() {
88         hardcap = 180000000;
89         hardcap = hardcap.mul(multiplier);
90     }
91 
92     modifier onlyPayloadSize(uint size) {
93         if(msg.data.length < size + 4) revert();
94         _;
95     }
96 
97     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
98       return allowed[_owner][_spender];
99     }
100 
101     function approve(address _spender, uint256 _value) returns (bool success) {
102         allowed[msg.sender][_spender] = _value;
103         Approval(msg.sender, _spender, _value);
104         return true;
105     }
106 
107     function balanceOf(address _owner) constant returns (uint256 remainingBalance) {
108         return balance[_owner];
109     }
110 
111     function mintToken(address target, uint256 mintedAmount) onlyOwner returns (bool success) {
112         require(mintedAmount > 0
113             && (now < stopTime)
114             && (totalSupply.add(mintedAmount) <= hardcap));
115 
116         uint256 addTokens = mintedAmount;
117         balance[target] += addTokens;
118         totalSupply += addTokens;
119         Transfer(0, target, addTokens);
120         return true;
121     }
122 
123     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool success) {
124         if ((balance[msg.sender] >= _value) && (balance[_to] + _value > balance[_to])) {
125             balance[msg.sender] -= _value;
126             balance[_to] += _value;
127             Transfer(msg.sender, _to, _value);
128             return true;
129         } else {
130             return false;
131         }
132     }
133 
134     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) returns (bool success) {
135         if ((balance[_from] >= _value) && (allowed[_from][msg.sender] >= _value) && (balance[_to] + _value > balance[_to])) {
136             balance[_to] += _value;
137             balance[_from] -= _value;
138             allowed[_from][msg.sender] -= _value;
139             Transfer(_from, _to, _value);
140             return true;
141         } else {
142             return false;
143         }
144     }
145 }