1 pragma solidity ^0.4.14;
2 
3 /* © Arbitrage Coin 2017
4 There is no law stronger then the code
5 */
6 
7 library SafeMath {
8   function mul(uint a, uint b) internal returns (uint) {
9     uint c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13   function div(uint a, uint b) internal returns (uint) {
14     assert(b > 0);
15     uint c = a / b;
16     assert(a == b * c + a % b);
17     return c;
18   }
19   function sub(uint a, uint b) internal returns (uint) {
20     assert(b <= a);
21     return a - b;
22   }
23   function add(uint a, uint b) internal returns (uint) {
24     uint c = a + b;
25     assert(c >= a);
26     return c;
27   }
28   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
29     return a >= b ? a : b;
30   }
31   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
32     return a < b ? a : b;
33   }
34   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
35     return a >= b ? a : b;
36   }
37   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
38     return a < b ? a : b;
39   }
40   function assert(bool assertion) internal {
41     if (!assertion) {
42       throw;
43     }
44   }
45 }
46 
47 contract Ownable {
48     address public owner;
49     function Ownable() {
50         owner = msg.sender;
51     }
52     modifier onlyOwner {
53         if (msg.sender != owner) throw;
54         _;
55     }
56     function transferOwnership(address newOwner) onlyOwner {
57         if (newOwner != address(0)) {
58             owner = newOwner;
59         }
60     }
61 }
62 
63 contract ERC20Basic {
64   uint public totalSupply;
65   function balanceOf(address who) constant returns (uint);
66   function transfer(address to, uint value);
67   event Transfer(address indexed from, address indexed to, uint value);
68 }
69 contract ERC20 is ERC20Basic {
70   function allowance(address owner, address spender) constant returns (uint);
71   function transferFrom(address from, address to, uint value);
72   function approve(address spender, uint value);
73   event Approval(address indexed owner, address indexed spender, uint value);
74 }
75 
76 contract newToken is ERC20Basic {
77   
78   using SafeMath for uint;
79   
80   mapping(address => uint) balances;
81   
82 
83   modifier onlyPayloadSize(uint size) {
84      if(msg.data.length < size + 4) {
85        throw;
86      }
87      _;
88   }
89   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
90     balances[msg.sender] = balances[msg.sender].sub(_value);
91     balances[_to] = balances[_to].add(_value);
92     Transfer(msg.sender, _to, _value);
93   }
94   function balanceOf(address _owner) constant returns (uint balance) {
95     return balances[_owner];
96   }
97 }
98 
99 contract StandardToken is newToken, ERC20 {
100   mapping (address => mapping (address => uint)) allowed;
101   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
102     var _allowance = allowed[_from][msg.sender];
103     balances[_to] = balances[_to].add(_value);
104     balances[_from] = balances[_from].sub(_value);
105     allowed[_from][msg.sender] = _allowance.sub(_value);
106     Transfer(_from, _to, _value);
107   }
108   function approve(address _spender, uint _value) {
109     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
110     allowed[msg.sender][_spender] = _value;
111     Approval(msg.sender, _spender, _value);
112   }
113   function allowance(address _owner, address _spender) constant returns (uint remaining) {
114     return allowed[_owner][_spender];
115   }
116 }
117 
118 contract Arbitrage is StandardToken, Ownable {
119   string public constant name = "ArbitrageCoin";
120   string public constant symbol = "RBTR";
121   uint public constant decimals = 5;
122   uint256 public initialSupply;
123   
124   function Arbitrage () { 
125      totalSupply = 10000 * 10 ** decimals;
126       balances[msg.sender] = totalSupply;
127       initialSupply = totalSupply; 
128         Transfer(0, this, totalSupply);
129         Transfer(this, msg.sender, totalSupply);
130   }
131 }
132 
133 contract Deploy is Ownable, Arbitrage {
134   function transfer(address _to, uint256 _value) {
135         require(balances[msg.sender] > _value);
136         require(balances[_to] + _value > balances[_to]);
137         balances[msg.sender] -= _value;
138         balances[_to] += _value;
139         Transfer(msg.sender, _to, _value);
140     }
141 
142    function mintToken(address target, uint256 mintedAmount) onlyOwner {
143         balances[target] += mintedAmount;
144         totalSupply += mintedAmount;
145         Transfer(0, this, mintedAmount);
146         Transfer(this, target, mintedAmount);
147     }
148 }