1 pragma solidity ^0.4.14;
2 
3 /* © 2017
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
103     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
104     // if (_value > _allowance) throw;
105     balances[_to] = balances[_to].add(_value);
106     balances[_from] = balances[_from].sub(_value);
107     allowed[_from][msg.sender] = _allowance.sub(_value);
108     Transfer(_from, _to, _value);
109   }
110   function approve(address _spender, uint _value) {
111     // To change the approve amount you first have to reduce the addresses`
112     //  allowance to zero by calling approve(_spender, 0) if it is not
113     //  already 0 to mitigate the race condition described here:
114     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
115     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
116     allowed[msg.sender][_spender] = _value;
117     Approval(msg.sender, _spender, _value);
118   }
119   function allowance(address _owner, address _spender) constant returns (uint remaining) {
120     return allowed[_owner][_spender];
121   }
122 }
123 
124 contract Protean is StandardToken, Ownable {
125   string public constant name = "Protean";
126   string public constant symbol = "PRN";
127   uint public constant decimals = 18;
128   uint256 public initialSupply;
129     
130   // Constructor
131   function Protean () { 
132      totalSupply = 5000000000 * 10 ** decimals;
133       balances[msg.sender] = totalSupply;
134       initialSupply = totalSupply; 
135         Transfer(0, this, totalSupply);
136         Transfer(this, msg.sender, totalSupply);
137   }
138 }