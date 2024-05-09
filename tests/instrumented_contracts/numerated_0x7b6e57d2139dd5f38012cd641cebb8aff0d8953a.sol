1 pragma solidity ^0.4.6;
2 
3 library SafeMath {
4   function mul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint a, uint b) internal returns (uint) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint a, uint b) internal returns (uint) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint a, uint b) internal returns (uint) {
23     uint c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 
28   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
29     return a >= b ? a : b;
30   }
31 
32   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a < b ? a : b;
34   }
35 
36   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
37     return a >= b ? a : b;
38   }
39 
40   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a < b ? a : b;
42   }
43 
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
57 
58 contract ERC20 is ERC20Basic {
59   function allowance(address owner, address spender) constant returns (uint);
60   function transferFrom(address from, address to, uint value);
61   function approve(address spender, uint value);
62   event Approval(address indexed owner, address indexed spender, uint value);
63 }
64 
65 contract BasicToken is ERC20Basic {
66   using SafeMath for uint;
67 
68   mapping(address => uint) balances;
69 
70   modifier onlyPayloadSize(uint size) {
71      if(msg.data.length < size + 4) {
72        throw;
73      }
74      _;
75   }
76 
77   /**
78   * @dev transfer token for a specified address
79   * @param _to The address to transfer to.
80   * @param _value The amount to be transferred.
81   */
82   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
83     balances[msg.sender] = balances[msg.sender].sub(_value);
84     balances[_to] = balances[_to].add(_value);
85     Transfer(msg.sender, _to, _value);
86   }
87 
88   /**
89   * @dev Gets the balance of the specified address.
90   * @param _owner The address to query the the balance of. 
91   * @return An uint representing the amount owned by the passed address.
92   */
93   function balanceOf(address _owner) constant returns (uint balance) {
94     return balances[_owner];
95   }
96 
97 }
98 
99 contract NewToken is BasicToken, ERC20 {
100 
101   mapping (address => mapping (address => uint)) allowed;
102 
103 
104   /**
105    * @dev Transfer tokens from one address to another
106    * @param _from address The address which you want to send tokens from
107    * @param _to address The address which you want to transfer to
108    * @param _value uint the amout of tokens to be transfered
109    */
110   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
111     var _allowance = allowed[_from][msg.sender];
112 
113     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
114     // if (_value > _allowance) throw;
115 
116     balances[_to] = balances[_to].add(_value);
117     balances[_from] = balances[_from].sub(_value);
118     allowed[_from][msg.sender] = _allowance.sub(_value);
119     Transfer(_from, _to, _value);
120   }
121 
122   /**
123    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
124    * @param _spender The address which will spend the funds.
125    * @param _value The amount of tokens to be spent.
126    */
127   function approve(address _spender, uint _value) {
128 
129     // To change the approve amount you first have to reduce the addresses`
130     //  allowance to zero by calling `approve(_spender, 0)` if it is not
131     //  already 0 to mitigate the race condition described here:
132     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
133     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
134 
135     allowed[msg.sender][_spender] = _value;
136     Approval(msg.sender, _spender, _value);
137   }
138 
139   /**
140    * @dev Function to check the amount of tokens than an owner allowed to a spender.
141    * @param _owner address The address which owns the funds.
142    * @param _spender address The address which will spend the funds.
143    * @return A uint specifing the amount of tokens still avaible for the spender.
144    */
145   function allowance(address _owner, address _spender) constant returns (uint remaining) {
146     return allowed[_owner][_spender];
147   }
148 
149 }
150 
151 contract SimpleToken is NewToken {
152 
153   string public name = "Token of Digital Money";
154   string public symbol = "TDM";
155   uint public decimals = 8;
156   uint public INITIAL_SUPPLY = 1000000000000000;
157 
158   function SimpleToken () {
159     totalSupply = INITIAL_SUPPLY;
160     balances[msg.sender] = INITIAL_SUPPLY;
161   }
162 
163 }