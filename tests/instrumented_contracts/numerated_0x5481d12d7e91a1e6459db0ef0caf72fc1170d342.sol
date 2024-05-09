1 pragma solidity ^0.4.8;
2 
3 contract Token {
4 
5   function safeSub(uint a, uint b) internal returns (uint) {
6     assert(b <= a);
7     return a - b;
8   }
9 
10   function safeAdd(uint a, uint b) internal returns (uint) {
11     uint c = a + b;
12     assert(c>=a && c>=b);
13     return c;
14   }
15 
16   function assert(bool assertion) internal {
17     if (!assertion) {
18       throw;
19     }
20   }
21 
22   string public constant symbol = "GNC";
23   string public constant name = "Generic";
24   uint8 public constant decimals = 18;
25   uint256 _totalSupply = 21000000 * 10**18;
26 
27   // Owner of this contract
28 
29   address public owner;
30 
31   mapping(address => uint) balances;
32   mapping (address => mapping (address => uint)) allowed;
33 
34   // Constructor
35   function Token() {
36       owner = msg.sender;
37       balances[owner] = _totalSupply;
38   }
39 
40 
41   function totalSupply() constant returns (uint256 totalSupply) {
42       totalSupply = _totalSupply;
43   }
44 
45   function transfer(address _to, uint _value) returns (bool success) {
46     balances[msg.sender] = safeSub(balances[msg.sender], _value);
47     balances[_to] = safeAdd(balances[_to], _value);
48     Transfer(msg.sender, _to, _value);
49     return true;
50   }
51 
52   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
53     var _allowance = allowed[_from][msg.sender];
54 
55     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
56     // if (_value > _allowance) throw;
57 
58     balances[_to] = safeAdd(balances[_to], _value);
59     balances[_from] = safeSub(balances[_from], _value);
60     allowed[_from][msg.sender] = safeSub(_allowance, _value);
61     Transfer(_from, _to, _value);
62     return true;
63   }
64 
65   function balanceOf(address _owner) constant returns (uint balance) {
66     return balances[_owner];
67   }
68 
69   function approve(address _spender, uint _value) returns (bool success) {
70     allowed[msg.sender][_spender] = _value;
71     Approval(msg.sender, _spender, _value);
72     return true;
73   }
74 
75   function allowance(address _owner, address _spender) constant returns (uint remaining) {
76     return allowed[_owner][_spender];
77   }
78 
79   event Transfer(address indexed from, address indexed to, uint value);
80   event Approval(address indexed owner, address indexed spender, uint value);
81 
82 }