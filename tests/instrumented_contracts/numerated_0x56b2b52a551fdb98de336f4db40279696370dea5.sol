1 pragma solidity ^0.4.6;
2 
3 
4 library SafeMath {
5   function mul(uint a, uint b) internal returns (uint) {
6     uint c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function div(uint a, uint b) internal returns (uint) {
12     // assert(b > 0); // Solidity automatically throws when dividing by 0
13     uint c = a / b;
14     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15     return c;
16   }
17 
18   function sub(uint a, uint b) internal returns (uint) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint a, uint b) internal returns (uint) {
24     uint c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 
29   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
30     return a >= b ? a : b;
31   }
32 
33   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
34     return a < b ? a : b;
35   }
36 
37   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
38     return a >= b ? a : b;
39   }
40 
41   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
42     return a < b ? a : b;
43   }
44 
45   function assert(bool assertion) internal {
46     if (!assertion) {
47       throw;
48     }
49   }
50 }
51 
52 contract ERC20Basic {
53   uint public totalSupply;
54   function balanceOf(address who) constant returns (uint);
55   function transfer(address to, uint value);
56   event Transfer(address indexed from, address indexed to, uint value);
57 }
58 
59 contract ERC20 is ERC20Basic {
60   function allowance(address owner, address spender) constant returns (uint);
61   function transferFrom(address from, address to, uint value);
62   function approve(address spender, uint value);
63   event Approval(address indexed owner, address indexed spender, uint value);
64 }
65 
66 contract BasicToken is ERC20Basic {
67   using SafeMath for uint;
68 
69   mapping(address => uint) balances;
70 
71   modifier onlyPayloadSize(uint size) {
72      if(msg.data.length < size + 4) {
73        throw;
74      }
75      _;
76   }
77 
78   /**
79   * @dev transfer token for a specified address
80   * @param _to The address to transfer to.
81   * @param _value The amount to be transferred.
82   */
83   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
84     balances[msg.sender] = balances[msg.sender].sub(_value);
85     balances[_to] = balances[_to].add(_value);
86     Transfer(msg.sender, _to, _value);
87   }
88 
89   /**
90   * @dev Gets the balance of the specified address.
91   * @param _owner The address to query the the balance of. 
92   * @return An uint representing the amount owned by the passed address.
93   */
94   function balanceOf(address _owner) constant returns (uint balance) {
95     return balances[_owner];
96   }
97 
98 }
99 
100 contract NewToken is BasicToken, ERC20 {
101 
102   mapping (address => mapping (address => uint)) allowed;
103 
104 
105   /**
106    * @dev Transfer tokens from one address to another
107    * @param _from address The address which you want to send tokens from
108    * @param _to address The address which you want to transfer to
109    * @param _value uint the amout of tokens to be transfered
110    */
111   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
112     var _allowance = allowed[_from][msg.sender];
113 
114     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
115     // if (_value > _allowance) throw;
116 
117     balances[_to] = balances[_to].add(_value);
118     balances[_from] = balances[_from].sub(_value);
119     allowed[_from][msg.sender] = _allowance.sub(_value);
120     Transfer(_from, _to, _value);
121   }
122 
123   /**
124    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
125    * @param _spender The address which will spend the funds.
126    * @param _value The amount of tokens to be spent.
127    */
128   function approve(address _spender, uint _value) {
129 
130     // To change the approve amount you first have to reduce the addresses`
131     //  allowance to zero by calling `approve(_spender, 0)` if it is not
132     //  already 0 to mitigate the race condition described here:
133     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
134     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
135 
136     allowed[msg.sender][_spender] = _value;
137     Approval(msg.sender, _spender, _value);
138   }
139 
140   /**
141    * @dev Function to check the amount of tokens than an owner allowed to a spender.
142    * @param _owner address The address which owns the funds.
143    * @param _spender address The address which will spend the funds.
144    * @return A uint specifing the amount of tokens still avaible for the spender.
145    */
146   function allowance(address _owner, address _spender) constant returns (uint remaining) {
147     return allowed[_owner][_spender];
148   }
149 
150 }
151 
152 contract THETOKEN is NewToken {
153 
154   string public name = "EDOLLAR";
155   string public symbol = "DLR";
156   uint public decimals = 8;
157   uint public INITIAL_SUPPLY = 100000000000000000000000;
158 
159   function THETOKEN () {
160     totalSupply = INITIAL_SUPPLY;
161     balances[msg.sender] = INITIAL_SUPPLY;
162   }
163 
164 }