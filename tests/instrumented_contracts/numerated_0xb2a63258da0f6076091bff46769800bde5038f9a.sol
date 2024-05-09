1 pragma solidity ^0.4.13;
2 library SafeMath {
3   function mul(uint a, uint b) internal returns (uint) {
4     uint c = a * b;
5     assert(a == 0 || c / a == b);
6     return c;
7   }
8   function div(uint a, uint b) internal returns (uint) {
9     assert(b > 0);
10     uint c = a / b;
11     assert(a == b * c + a % b);
12     return c;
13   }
14   function sub(uint a, uint b) internal returns (uint) {
15     assert(b <= a);
16     return a - b;
17   }
18   function add(uint a, uint b) internal returns (uint) {
19     uint c = a + b;
20     assert(c >= a);
21     return c;
22   }
23   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
24     return a >= b ? a : b;
25   }
26   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
27     return a < b ? a : b;
28   }
29   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
30     return a >= b ? a : b;
31   }
32   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
33     return a < b ? a : b;
34   }
35   function assert(bool assertion) internal {
36     if (!assertion) {
37       throw;
38     }
39   }
40 }
41 contract ERC20Basic {
42   uint public totalSupply;
43   function balanceOf(address who) constant returns (uint);
44   function transfer(address to, uint value);
45   event Transfer(address indexed from, address indexed to, uint value);
46 }
47 contract ERC20 is ERC20Basic {
48   function allowance(address owner, address spender) constant returns (uint);
49   function transferFrom(address from, address to, uint value);
50   function approve(address spender, uint value);
51   event Approval(address indexed owner, address indexed spender, uint value);
52 }
53 
54 contract BasicToken is ERC20Basic {
55   
56   using SafeMath for uint;
57   
58   mapping(address => uint) balances;
59   
60   /*
61    * Fix for the ERC20 short address attack  
62   */
63   modifier onlyPayloadSize(uint size) {
64      if(msg.data.length < size + 4) {
65        throw;
66      }
67      _;
68   }
69   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
70     balances[msg.sender] = balances[msg.sender].sub(_value);
71     balances[_to] = balances[_to].add(_value);
72     Transfer(msg.sender, _to, _value);
73   }
74   function balanceOf(address _owner) constant returns (uint balance) {
75     return balances[_owner];
76   }
77 }
78 contract StandardToken is BasicToken, ERC20 {
79   mapping (address => mapping (address => uint)) allowed;
80   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
81     var _allowance = allowed[_from][msg.sender];
82     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
83     // if (_value > _allowance) throw;
84     balances[_to] = balances[_to].add(_value);
85     balances[_from] = balances[_from].sub(_value);
86     allowed[_from][msg.sender] = _allowance.sub(_value);
87     Transfer(_from, _to, _value);
88   }
89   function approve(address _spender, uint _value) {
90     // To change the approve amount you first have to reduce the addresses`
91     //  allowance to zero by calling `approve(_spender, 0)` if it is not
92     //  already 0 to mitigate the race condition described here:
93     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
94     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
95     allowed[msg.sender][_spender] = _value;
96     Approval(msg.sender, _spender, _value);
97   }
98   function allowance(address _owner, address _spender) constant returns (uint remaining) {
99     return allowed[_owner][_spender];
100   }
101 }
102 /**
103  *  VenusCoin token contract. Implements
104  */
105 contract VenusCoin is StandardToken {
106   string public constant name = "VenusCoin";
107   string public constant symbol = "Venus";
108   uint public constant decimals = 5;
109   // Constructor
110   function VenusCoin() {
111       totalSupply = 5000000000000000;
112       balances[msg.sender] = totalSupply; // Send all tokens to owner
113   }
114 }
115 /*
116   Tokensale Smart Contract for the VenusCoin project
117   This smart contract collects ETH
118 */
119 contract Tokensale {
120     
121     using SafeMath for uint;
122     struct Beneficiar {
123         uint weiReceived; // Amount of Ether
124         uint coinSent;
125     }
126     
127     /* Number of VenusCoins per Ether */
128     uint public constant COIN_PER_ETHER = 20000; // 20,000 VenusCoins
129     /*
130     * Variables
131     */
132     /* VenusCoin contract reference */
133     VenusCoin public coin;
134     /* Number of Ether received */
135     uint public etherReceived;
136     /* Number of VenusCoins sent to Ether contributors */
137     uint public coinSentToEther;
138     /*  Beneficiar's Ether indexed by Ethereum address */
139     mapping(address => Beneficiar) public beneficiars;
140   
141     /*
142      * Event
143     */
144     event LogReceivedETH(address addr, uint value);
145     event LogCoinsEmited(address indexed from, uint amount);
146     /*
147      * Constructor
148     */
149     function Tokensale(address _venusCoinAddress, address _to) {
150         coin = VenusCoin(_venusCoinAddress);
151     }
152 }