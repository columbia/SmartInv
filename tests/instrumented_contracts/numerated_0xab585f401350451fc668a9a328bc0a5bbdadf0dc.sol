1 pragma solidity ^0.4.15;
2 contract SafeMath {
3   //internals
4 
5   function safeMul(uint a, uint b) internal pure returns (uint) {
6     uint c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function safeSub(uint a, uint b) internal pure returns (uint) {
12     assert(b <= a);
13     return a - b;
14   }
15 
16   function safeAdd(uint a, uint b) internal pure returns (uint) {
17     uint c = a + b;
18     assert(c>=a && c>=b);
19     return c;
20   }
21 }
22 
23 /**
24  * 
25  * ERC 20 token
26  *
27  */
28 contract Token {
29 
30     uint256 public totalSupply;
31 
32     function balanceOf(address _owner) public view returns (uint256 balance);
33 
34     function transfer(address _to, uint256 _value) public returns (bool success);
35 
36     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
37 
38     function approve(address _spender, uint256 _value) public returns (bool success);
39 
40     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
41 
42     event Transfer(address indexed _from, address indexed _to, uint256 _value);
43     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
44 }
45 
46 /**
47  * ERC 20 token
48  *
49  * https://github.com/ethereum/EIPs/issues/20
50  */
51 contract StandardToken is Token {
52 
53     function transfer(address _to, uint256 _value) public returns (bool success) {
54         //Default assumes totalSupply can't be over max (2^256 - 1).
55         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
56         //Replace the if with this one instead.
57         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
58         //if (balances[msg.sender] >= _value && _value > 0) {
59             balances[msg.sender] -= _value;
60             balances[_to] += _value;
61             Transfer(msg.sender, _to, _value);
62             return true;
63         } else { return false; }
64     }
65 
66     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
67         //same as above. Replace this line with the following if you want to protect against wrapping uints.
68         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
69         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
70             balances[_to] += _value;
71             balances[_from] -= _value;
72             allowed[_from][msg.sender] -= _value;
73             Transfer(_from, _to, _value);
74             return true;
75         } else { return false; }
76     }
77 
78     function balanceOf(address _owner) view public returns (uint256 balance) {
79         return balances[_owner];
80     }
81 
82     function approve(address _spender, uint256 _value) public returns (bool success) {
83         allowed[msg.sender][_spender] = _value;
84         Approval(msg.sender, _spender, _value);
85         return true;
86     }
87 
88     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
89       return allowed[_owner][_spender];
90     }
91 
92     mapping(address => uint256) balances;
93 
94     mapping (address => mapping (address => uint256)) allowed;
95 
96     uint256 public totalSupply;
97 
98 }
99 
100 contract DogecoinAlphaToken is StandardToken, SafeMath {
101 
102     string public name = "Dogecoin Alpha Token";
103     string public symbol = "DCA";
104     uint public decimals = 18;
105     
106     address public team = 0x0;
107     address public airdrop = 0x0;
108 
109     function DogecoinAlphaToken(address teamAddress, address airDropAddress) public {
110         team = teamAddress;
111         airdrop = airDropAddress;
112         uint totalSupplyQuarter = 5 * (10 ** 23);
113         totalSupply = totalSupplyQuarter + totalSupplyQuarter + totalSupplyQuarter + totalSupplyQuarter;
114         balances[team] = totalSupplyQuarter;
115         balances[airdrop] = totalSupplyQuarter + totalSupplyQuarter + totalSupplyQuarter;
116     }
117 
118 }