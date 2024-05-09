1 pragma solidity ^0.4.13;
2 
3 // ©COALCOIN TOKEN
4 
5 library SafeMath {
6   function mul(uint a, uint b) internal returns (uint) {
7     uint c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11   function div(uint a, uint b) internal returns (uint) {
12     assert(b > 0);
13     uint c = a / b;
14     assert(a == b * c + a % b);
15     return c;
16   }
17   function sub(uint a, uint b) internal returns (uint) {
18     assert(b <= a);
19     return a - b;
20   }
21   function add(uint a, uint b) internal returns (uint) {
22     uint c = a + b;
23     assert(c >= a);
24     return c;
25   }
26   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
27     return a >= b ? a : b;
28   }
29   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
30     return a < b ? a : b;
31   }
32   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
33     return a >= b ? a : b;
34   }
35   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
36     return a < b ? a : b;
37   }
38   function assert(bool assertion) internal {
39     if (!assertion) {
40       throw;
41     }
42   }
43 }
44 
45 contract Ownable {
46     address public owner;
47     function Ownable() {
48         owner = msg.sender;
49     }
50     modifier onlyOwner {
51         if (msg.sender != owner) throw;
52         _;
53     }
54     function transferOwnership(address newOwner) onlyOwner {
55         if (newOwner != address(0)) {
56             owner = newOwner;
57         }
58     }
59 }
60 
61 /* ©Total supply ‎10000000000 COALCOIN TOKENS (CIC)
62   @notice see https://github.com/ethereum/EIPs/issues/20
63  */
64 
65 contract ERC20Basic {
66   uint public totalSupply;
67   function balanceOf(address who) constant returns (uint);
68   function transfer(address to, uint value);
69   event Transfer(address indexed from, address indexed to, uint value);
70 }
71 contract ERC20 is ERC20Basic {
72   function allowance(address owner, address spender) constant returns (uint);
73   function transferFrom(address from, address to, uint value);
74   function approve(address spender, uint value);
75   event Approval(address indexed owner, address indexed spender, uint value);
76 }
77 
78 contract COALCOIN is ERC20Basic {
79  
80   using SafeMath for uint;
81  
82   mapping(address => uint) balances;
83  
84 
85   modifier onlyPayloadSize(uint size) {
86      if(msg.data.length < size + 4) {
87        throw;
88      }
89      _;
90   }
91   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
92     balances[msg.sender] = balances[msg.sender].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     Transfer(msg.sender, _to, _value);
95   }
96   function balanceOf(address _owner) constant returns (uint balance) {
97     return balances[_owner];
98   }
99 }
100 contract StandardToken is COALCOIN, ERC20 {
101   mapping (address => mapping (address => uint)) allowed;
102   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
103     var _allowance = allowed[_from][msg.sender];
104     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
105     // if (_value > _allowance) throw;
106     balances[_to] = balances[_to].add(_value);
107     balances[_from] = balances[_from].sub(_value);
108     allowed[_from][msg.sender] = _allowance.sub(_value);
109     Transfer(_from, _to, _value);
110   }
111   function approve(address _spender, uint _value) {
112     // To change the approve amount you first have to reduce the addresses`
113     //  allowance to zero by calling `approve(_spender, 0)` if it is not
114     //  already 0 to mitigate the race condition described here:
115     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
116     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
117     allowed[msg.sender][_spender] = _value;
118     Approval(msg.sender, _spender, _value);
119   }
120   function allowance(address _owner, address _spender) constant returns (uint remaining) {
121     return allowed[_owner][_spender];
122   }
123 }
124 
125 contract CIC is StandardToken, Ownable {
126   string public constant name = "COALCOIN";
127   string public constant symbol = "CIC";
128   uint public constant decimals = 10;
129   // Constructor
130   function CIC() {
131       totalSupply = 10000000000 * 10 ** decimals;
132       balances[msg.sender] = totalSupply;
133   }
134 }