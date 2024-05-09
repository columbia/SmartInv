1 pragma solidity ^0.4.23;
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
47 contract GameCoinToken is ERC20 {
48 	
49 	using SafeMath for uint256;
50 	
51     mapping (address => uint256) balances;
52     mapping (address => mapping (address => uint256)) allowed;
53 	
54     uint256 public totalSupply = 1000000000000;
55 	string public constant name = "GameCoinToken";
56     string public constant symbol = "GACT";
57     uint public constant decimals = 0;
58 	
59 	function GameCoinToken(){
60 		balances[msg.sender] = totalSupply;
61 	}
62 	
63     function balanceOf(address _owner) constant public returns (uint256) {
64 	    return balances[_owner];
65     }
66     
67     function transfer(address _to, uint256 _value) returns (bool success) {
68         if (balances[msg.sender] >= _value && _value > 0) {
69             balances[msg.sender] = balances[msg.sender].sub(_value);
70             balances[_to] = balances[_to].add(_value);
71             Transfer(msg.sender, _to, _value);
72             return true;
73         } else { return false; }
74     }
75     
76     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
77         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
78 			balances[_from] = balances[_from].sub(_value);
79 			allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
80 			balances[_to] = balances[_to].add(_value);
81             Transfer(_from, _to, _value);
82             return true;
83         } else { return false; }
84     }
85     
86     function approve(address _spender, uint256 _value) returns (bool success) {
87         allowed[msg.sender][_spender] = _value;
88         Approval(msg.sender, _spender, _value);
89         return true;
90     }
91 
92     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
93       return allowed[_owner][_spender];
94     }
95 	
96 	function () {
97         //if ether is sent to this address, send it back.
98         throw;
99     }
100     
101 }