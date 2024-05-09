1 pragma solidity ^0.4.14;
2 
3 /* ©CoCoCoin 
4 */
5 
6 library SafeMath {
7   function mul(uint a, uint b) internal returns (uint) {
8     uint c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12   function div(uint a, uint b) internal returns (uint) {
13     assert(b > 0);
14     uint c = a / b;
15     assert(a == b * c + a % b);
16     return c;
17   }
18   function sub(uint a, uint b) internal returns (uint) {
19     assert(b <= a);
20     return a - b;
21   }
22   function add(uint a, uint b) internal returns (uint) {
23     uint c = a + b;
24     assert(c >= a);
25     return c;
26   }
27   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
28     return a >= b ? a : b;
29   }
30   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
31     return a < b ? a : b;
32   }
33   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
34     return a >= b ? a : b;
35   }
36   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
37     return a < b ? a : b;
38   }
39   function assert(bool assertion) internal {
40     if (!assertion) {
41       throw;
42     }
43   }
44 }
45 
46 contract Ownable {
47     address public owner;
48     function Ownable() {
49         owner = msg.sender;
50     }
51     modifier onlyOwner {
52         if (msg.sender != owner) throw;
53         _;
54     }
55     function transferOwnership(address newOwner) onlyOwner {
56         if (newOwner != address(0)) {
57             owner = newOwner;
58         }
59     }
60 }
61 
62 contract ERC20Basic {
63   uint public totalSupply;
64   function balanceOf(address who) constant returns (uint);
65   function transfer(address to, uint value);
66   event Transfer(address indexed from, address indexed to, uint value);
67 }
68 contract ERC20 is ERC20Basic {
69   function allowance(address owner, address spender) constant returns (uint);
70   function transferFrom(address from, address to, uint value);
71   function approve(address spender, uint value);
72   event Approval(address indexed owner, address indexed spender, uint value);
73 }
74 
75 contract newToken is ERC20Basic {
76   
77   using SafeMath for uint;
78   
79   mapping(address => uint) balances;
80   
81 
82   modifier onlyPayloadSize(uint size) {
83      if(msg.data.length < size + 4) {
84        throw;
85      }
86      _;
87   }
88   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
89     balances[msg.sender] = balances[msg.sender].sub(_value);
90     balances[_to] = balances[_to].add(_value);
91     Transfer(msg.sender, _to, _value);
92   }
93   function balanceOf(address _owner) constant returns (uint balance) {
94     return balances[_owner];
95   }
96 }
97 
98 contract StandardToken is newToken, ERC20 {
99   mapping (address => mapping (address => uint)) allowed;
100   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
101     var _allowance = allowed[_from][msg.sender];
102     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
103     // if (_value > _allowance) throw;
104     balances[_to] = balances[_to].add(_value);
105     balances[_from] = balances[_from].sub(_value);
106     allowed[_from][msg.sender] = _allowance.sub(_value);
107     Transfer(_from, _to, _value);
108   }
109   function approve(address _spender, uint _value) {
110     // To change the approve amount you first have to reduce the addresses`
111     //  allowance to zero by calling approve(_spender, 0) if it is not
112     //  already 0 to mitigate the race condition described here:
113     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
114     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
115     allowed[msg.sender][_spender] = _value;
116     Approval(msg.sender, _spender, _value);
117   }
118   function allowance(address _owner, address _spender) constant returns (uint remaining) {
119     return allowed[_owner][_spender];
120   }
121 }
122 
123 contract CoCoCoin is StandardToken, Ownable {
124   string public constant name = "Contra Coin";
125   string public constant symbol = "CoCo";
126   uint public constant decimals = 4;
127   uint256 public initialSupply;
128     
129   // Constructor
130   function CoCoCoin () { 
131      totalSupply = 88000000 * 10 ** decimals;
132       balances[msg.sender] = totalSupply;
133       initialSupply = totalSupply; 
134         Transfer(0, this, totalSupply);
135         Transfer(this, msg.sender, totalSupply);
136   }
137 }