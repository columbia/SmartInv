1 pragma solidity ^0.4.18;
2 contract ERC20 {
3   uint public totalSupply;
4   function balanceOf(address who) public constant returns (uint);
5   function allowance(address owner, address spender) public constant returns (uint);
6   function transfer(address to, uint value)  public returns (bool ok);
7   function transferFrom(address from, address to, uint value)  public returns (bool ok);
8   function approve(address spender, uint value)  public returns (bool ok);
9   event Transfer(address indexed from, address indexed to, uint value);
10   event Approval(address indexed owner, address indexed spender, uint value);
11 }
12 pragma solidity ^0.4.18;
13 library SafeMath {
14   function safeMul(uint a, uint b) internal pure returns (uint) {
15     uint c = a * b;
16     assert(a == 0 || c / a == b);
17     return c;
18   }
19   function safeDiv(uint a, uint b) internal pure returns (uint) {
20     assert(b > 0);
21     uint c = a / b;
22     assert(a == b * c + a % b);
23     return c;
24   }
25   function safeSub(uint a, uint b) internal pure returns (uint) {
26     assert(b <= a);
27     return a - b;
28   }
29   function safeAdd(uint a, uint b) internal pure returns (uint) {
30     uint c = a + b;
31     assert(c>=a && c>=b);
32     return c;
33   }
34   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
35     return a >= b ? a : b;
36   }
37   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
38     return a < b ? a : b;
39   }
40   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
41     return a >= b ? a : b;
42   }
43   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
44     return a < b ? a : b;
45   }
46 }
47 pragma solidity ^0.4.18;
48 contract StandardToken is ERC20 {
49   using SafeMath for uint256; 
50   modifier onlyPayloadSize(uint size) {
51      require(msg.data.length >= size + 4);
52      _;
53   }
54   mapping(address => uint) balances;
55   mapping (address => mapping (address => uint)) allowed;
56   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) public returns (bool success){
57     require(_to != address(0));
58     require(_value <= balances[msg.sender]);
59     balances[msg.sender] = balances[msg.sender].safeSub(_value);
60     balances[_to] = balances[_to].safeAdd(_value);
61     Transfer(msg.sender, _to, _value);
62     return true;
63   }
64   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) public returns (bool success) {
65     require(_from != address(0));
66     require(_to != address(0));
67     var _allowance = allowed[_from][msg.sender];
68     balances[_to] = balances[_to].safeAdd(_value);
69     balances[_from] = balances[_from].safeSub(_value);
70     allowed[_from][msg.sender] = _allowance.safeSub(_value);
71     Transfer(_from, _to, _value);
72     return true;
73   }
74   function balanceOf(address _owner) public constant returns (uint balance) {
75     return balances[_owner];
76   }
77   function approve(address _spender, uint _value) public returns (bool success) {
78     require(_spender != address(0));
79     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
80     allowed[msg.sender][_spender] = _value;
81     Approval(msg.sender, _spender, _value);
82     return true;
83   }
84   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
85     require(_owner != address(0));
86     require(_spender != address(0));
87     return allowed[_owner][_spender];
88   }
89   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
90     require(_spender != address(0));
91     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].safeAdd(_addedValue);
92     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
93     return true;
94   }	
95   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
96     require(_spender != address(0));
97     uint oldValue = allowed[msg.sender][_spender];
98     if (_subtractedValue > oldValue) {
99       allowed[msg.sender][_spender] = 0;
100     } else {
101       allowed[msg.sender][_spender] = oldValue.safeSub(_subtractedValue);
102     }
103     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
104     return true;
105   }
106 }
107 pragma solidity ^0.4.18;
108 contract OdinCoin is StandardToken {
109     string public constant name = "ODIN TOKEN";
110     string public constant symbol = "ODIN";
111     uint8 public constant decimals = 0;
112     uint256 public constant totalSupply = 200000000;
113 
114     function OdinCoin(address reserve) public {
115         balances[reserve] = totalSupply;
116     }
117 }