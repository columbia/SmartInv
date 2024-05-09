1 pragma solidity ^0.4.18;
2 
3 /*
4   Ⓒ  oceansafe.io
5    OceanSafe Coin
6    2017
7 */
8 
9 contract ERC20Basic {
10   uint public totalSupply;
11   function balanceOf(address who) constant returns (uint);
12   function transfer(address to, uint value);
13   event Transfer(address indexed from, address indexed to, uint value);
14 }
15 contract ERC20 is ERC20Basic {
16   function allowance(address owner, address spender) constant returns (uint);
17   function transferFrom(address from, address to, uint value);
18   function approve(address spender, uint value);
19   event Approval(address indexed owner, address indexed spender, uint value);
20 }
21 
22 library SafeMath {
23   function mul(uint a, uint b) internal returns (uint) {
24     uint c = a * b;
25     assert(a == 0 || c / a == b);
26     return c;
27   }
28   function div(uint a, uint b) internal returns (uint) {
29     assert(b > 0);
30     uint c = a / b;
31     assert(a == b * c + a % b);
32     return c;
33   }
34   function sub(uint a, uint b) internal returns (uint) {
35     assert(b <= a);
36     return a - b;
37   }
38   function add(uint a, uint b) internal returns (uint) {
39     uint c = a + b;
40     assert(c >= a);
41     return c;
42   }
43   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
44     return a >= b ? a : b;
45   }
46   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
47     return a < b ? a : b;
48   }
49   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
50     return a >= b ? a : b;
51   }
52   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
53     return a < b ? a : b;
54   }
55   function assert(bool assertion) internal {
56     if (!assertion) {
57       throw;
58     }
59   }
60 }
61 
62 contract ecoToken is ERC20Basic {
63   using SafeMath for uint;
64   mapping(address => uint) balances;
65   modifier onlyPayloadSize(uint size) {
66      if(msg.data.length < size + 4) {
67        throw;
68      }
69      _;
70   }
71   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
72     balances[msg.sender] = balances[msg.sender].sub(_value);
73     balances[_to] = balances[_to].add(_value);
74     Transfer(msg.sender, _to, _value);
75   }
76   function balanceOf(address _owner) constant returns (uint balance) {
77     return balances[_owner];
78   }
79 }
80 
81 contract OSC is ecoToken, ERC20 {
82   mapping (address => mapping (address => uint)) allowed;
83   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
84     var _allowance = allowed[_from][msg.sender];
85     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
86     // if (_value > _allowance) throw;
87     balances[_to] = balances[_to].add(_value);
88     balances[_from] = balances[_from].sub(_value);
89     allowed[_from][msg.sender] = _allowance.sub(_value);
90     Transfer(_from, _to, _value);
91   }
92   function approve(address _spender, uint _value) {
93     // To change the approve amount you first have to reduce the addresses`
94     //  allowance to zero by calling approve(_spender, 0) if it is not
95     //  already 0 to mitigate the race condition described here:
96     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
97     allowed[msg.sender][_spender] = _value;
98     Approval(msg.sender, _spender, _value);
99   }
100   function allowance(address _owner, address _spender) constant returns (uint remaining) {
101     return allowed[_owner][_spender];
102   }
103 }
104 
105 contract OceanSafeToken is OSC {
106   string public constant name = "OceanSafe Coin";
107   string public constant symbol = "OSC";
108   uint public constant decimals = 9;
109   uint256 public initialSupply;
110     
111   function OceanSafeToken () { 
112      totalSupply = 25000000 * 10 ** decimals;
113       balances[0x28440d33e64Cd71b72e48E93656C7384D61b51A3] = totalSupply;
114       initialSupply = totalSupply; 
115         Transfer(0, this, totalSupply);
116         Transfer(this, 0x28440d33e64Cd71b72e48E93656C7384D61b51A3, totalSupply);
117   }
118 }
119 
120 /*
121  Ⓒ  oceansafe.io
122    OceanSafe Coin
123    2017
124 */