1 pragma solidity ^0.4.16;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal constant returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract ERC20 {
28 
29     uint256 public totalSupply;
30 
31     function balanceOf(address _owner) constant returns (uint256 balance);
32 
33     function transfer(address _to, uint256 _value) returns (bool success);
34 
35     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
36 
37     function approve(address _spender, uint256 _value) returns (bool success);
38 
39     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
40 
41     event Transfer(address indexed _from, address indexed _to, uint256 _value);
42 
43     event Approval(address indexed _owner, address indexed _spender, uint256  _value);
44 }
45 
46 
47 contract TPOMZ is ERC20 {
48 
49 	using SafeMath for uint256;                                        // Use safe math library
50 
51     mapping (address => uint256) balances;                             // Balances table
52     mapping (address => mapping (address => uint256)) allowed;         // Allowance table
53 
54     uint public constant decimals = 8;                                 // Decimals count
55     uint256 public totalSupply = 5000000000 * 10 ** decimals;          // Total supply
56 	string public constant name = "TPOMZ";                             // Coin name
57     string public constant symbol = "TPOMZ";                           // Coin symbol
58 
59 	function TPOMZ() {                                                 // Constructor
60 		balances[msg.sender] = totalSupply;                            // Give the creator all initial tokens
61 	}
62 
63     function balanceOf(address _owner) constant public returns (uint256) {
64 	    return balances[_owner];                                        // Return tokens count from balance table by address
65     }
66 
67     function transfer(address _to, uint256 _value) returns (bool success) {
68         if (balances[msg.sender] >= _value && _value > 0) {             // Check if the sender has enough
69             balances[msg.sender] = balances[msg.sender].sub(_value);    // Safe decrease sender balance
70             balances[_to] = balances[_to].add(_value);                  // Safe increase recipient balance
71             Transfer(msg.sender, _to, _value);                          // Emit transfer event
72             return true;
73         } else {
74             return false;
75          }
76     }
77 
78     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
79         if (balances[_from] >= _value &&                                // Check if the from has enough
80             allowed[_from][msg.sender] >= _value && _value > 0) {       // Check allowance table row
81 			balances[_from] = balances[_from].sub(_value);              // Safe decrease from balance
82 			allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); // Safe decrease allowance
83 			balances[_to] = balances[_to].add(_value);                  // Safe increase recipient balance
84             Transfer(_from, _to, _value);                               // Emit transfer event
85             return true;
86         } else { return false; }
87     }
88 
89     function approve(address _spender, uint256 _value) returns (bool success) {
90         allowed[msg.sender][_spender] = _value;                         // Update allowed
91         Approval(msg.sender, _spender, _value);                         // Emit approval event
92         return true;
93     }
94 
95     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
96       return allowed[_owner][_spender];                                 // Check allowed
97     }
98 
99 	function () {
100         revert();                                                       // If ether is sent to this address, send it back.
101     }
102 
103 }