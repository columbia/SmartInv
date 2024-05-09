1 pragma solidity ^0.4.18;
2 
3 /*
4      Ⓒ4xcoin.io
5  
6   4xCoin is the new disruptive tokenizing ledger aimed to bridge crypto space and $5 trillion Forex market via decentralized trustless platform.
7 
8       Ⓒ2017 4xCoin
9 */
10 
11 library SafeMath {
12   function mul(uint a, uint b) internal returns (uint) {
13     uint c = a * b;
14     assert(a == 0 || c / a == b);
15     return c;
16   }
17   function div(uint a, uint b) internal returns (uint) {
18     assert(b > 0);
19     uint c = a / b;
20     assert(a == b * c + a % b);
21     return c;
22   }
23   function sub(uint a, uint b) internal returns (uint) {
24     assert(b <= a);
25     return a - b;
26   }
27   function add(uint a, uint b) internal returns (uint) {
28     uint c = a + b;
29     assert(c >= a);
30     return c;
31   }
32   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a >= b ? a : b;
34   }
35   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
36     return a < b ? a : b;
37   }
38   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
39     return a >= b ? a : b;
40   }
41   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
42     return a < b ? a : b;
43   }
44   function assert(bool assertion) internal {
45     if (!assertion) {
46       throw;
47     }
48   }
49 }
50 
51 contract ERC20Basic {
52   uint public totalSupply;
53   function balanceOf(address who) constant returns (uint);
54   function transfer(address to, uint value);
55   event Transfer(address indexed from, address indexed to, uint value);
56 }
57 contract ERC20 is ERC20Basic {
58   function allowance(address owner, address spender) constant returns (uint);
59   function transferFrom(address from, address to, uint value);
60   function approve(address spender, uint value);
61   event Approval(address indexed owner, address indexed spender, uint value);
62 }
63 
64 contract newToken is ERC20Basic {
65   
66   using SafeMath for uint;
67   
68   mapping(address => uint) balances;
69   
70 
71   modifier onlyPayloadSize(uint size) {
72      if(msg.data.length < size + 4) {
73        throw;
74      }
75      _;
76   }
77   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
78     balances[msg.sender] = balances[msg.sender].sub(_value);
79     balances[_to] = balances[_to].add(_value);
80     Transfer(msg.sender, _to, _value);
81   }
82   function balanceOf(address _owner) constant returns (uint balance) {
83     return balances[_owner];
84   }
85 }
86 
87 contract FixedCoin is newToken, ERC20 {
88   mapping (address => mapping (address => uint)) allowed;
89   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
90     var _allowance = allowed[_from][msg.sender];
91     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
92     // if (_value > _allowance) throw;
93     balances[_to] = balances[_to].add(_value);
94     balances[_from] = balances[_from].sub(_value);
95     allowed[_from][msg.sender] = _allowance.sub(_value);
96     Transfer(_from, _to, _value);
97   }
98   function approve(address _spender, uint _value) {
99     // To change the approve amount you first have to reduce the addresses`
100     //  allowance to zero by calling approve(_spender, 0) if it is not
101     //  already 0 to mitigate the race condition described here:
102     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
103     allowed[msg.sender][_spender] = _value;
104     Approval(msg.sender, _spender, _value);
105   }
106   function allowance(address _owner, address _spender) constant returns (uint remaining) {
107     return allowed[_owner][_spender];
108   }
109 }
110 
111 contract Coin is FixedCoin {
112   string public constant name = "4xCoin";
113   string public constant symbol = "4X";
114   uint public constant decimals = 18;
115   uint256 public initialSupply;
116     
117   function Coin () { 
118      totalSupply = 60000000 * 10 ** decimals;
119       balances[msg.sender] = totalSupply; 
120       initialSupply = totalSupply; 
121         Transfer(0, this, totalSupply);
122         Transfer(this, msg.sender, totalSupply);
123   }
124 }
125 
126 /*
127      Ⓒ4xcoin.io
128  
129   4xCoin is the new disruptive tokenizing ledger aimed to bridge crypto space and $5 trillion Forex market via decentralized trustless platform.
130 
131       Ⓒ2017 4xCoin
132 */