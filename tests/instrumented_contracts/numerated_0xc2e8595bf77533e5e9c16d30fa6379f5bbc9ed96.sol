1 pragma solidity ^0.4.13;
2 
3 // The IPOcoinHotelShares contract
4 // +35799057557
5 // ©IT Consulting Group Ltd
6 // There is no law stronger than the code
7 
8 library SafeMath {
9   function mul(uint a, uint b) internal returns (uint) {
10     uint c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14   function div(uint a, uint b) internal returns (uint) {
15     assert(b > 0);
16     uint c = a / b;
17     assert(a == b * c + a % b);
18     return c;
19   }
20   function sub(uint a, uint b) internal returns (uint) {
21     assert(b <= a);
22     return a - b;
23   }
24   function add(uint a, uint b) internal returns (uint) {
25     uint c = a + b;
26     assert(c >= a);
27     return c;
28   }
29   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
30     return a >= b ? a : b;
31   }
32   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a < b ? a : b;
34   }
35   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
36     return a >= b ? a : b;
37   }
38   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
39     return a < b ? a : b;
40   }
41   function assert(bool assertion) internal {
42     if (!assertion) {
43       throw;
44     }
45   }
46 }
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
76 contract SharesContract is ERC20Basic {
77   
78   using SafeMath for uint;
79   
80   mapping(address => uint) balances;
81   
82   /*
83    * Fix for the ERC20 short address attack  
84   */
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
100 contract StandardToken is SharesContract, ERC20 {
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
125 /* ©IT Consulting Group Ltd
126   Oversees projects for investment
127   The company owns factories, hotels, land for construction in England, France, Cyprus, and Ukraine.
128   Clients are offered the opportunity to participate in projects both at the initial stages of construction and to buy out ready-made projects that are fully profitable.
129   The company has a registration in Cyprus. 
130   Based on legal contracts, the company's activities are carried out. 
131   We cooperate with real estate management companies around the world, so our clients never have any problems with real estate management.
132   IPOcoinHotelShares contract. Implements
133   @notice See https://github.com/ethereum/EIPs/issues/20
134  */
135  
136 contract IPOcoinHotelShares is StandardToken, Ownable {
137   string public constant name = "IPOcoinHotelShares";
138   string public constant symbol = "HotelShares";
139   uint public constant decimals = 6;
140   // Constructor
141   function IPOcoinHotelShares() {
142       totalSupply = 210 * 10 ** decimals; //  amount of shares offered to the public
143       balances[msg.sender] = totalSupply; //there are only 210 shares
144   }
145 }