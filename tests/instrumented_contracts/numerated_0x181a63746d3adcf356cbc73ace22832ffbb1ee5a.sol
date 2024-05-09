1 pragma solidity ^0.4.16;
2 
3 
4 
5   // TOKEN INFO SITE
6   // https://alaricoin.org/
7 
8   // CONTRACT REPOSITORY
9   // https://github.com/marcuzzu/Alaricoin/blob/master/token/Alaricoin.sol
10 
11 
12 
13 
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
21     uint256 c = a * b;
22     assert(a == 0 || c / a == b);
23     return c;
24   }
25 
26   function div(uint256 a, uint256 b) internal constant returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   function add(uint256 a, uint256 b) internal constant returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 
46 contract ERC20 {
47   uint256 public constant totalSupply=100000000000000;
48   function balanceOf(address who) public constant returns (uint256);
49   function transfer(address to, uint256 value) public returns (bool);
50   function allowance(address owner, address spender) public constant returns (uint256);
51   function transferFrom(address from, address to, uint256 value) public returns (bool);
52   function approve(address spender, uint256 value) public returns (bool);
53   event Transfer(address indexed from, address indexed to, uint256 value);
54   event Approval(address indexed owner, address indexed spender, uint256 value);
55 }
56 
57 
58 
59 contract Alaricoin is ERC20 {
60   using SafeMath for uint256;
61 
62   mapping(address => uint256) balances;
63   mapping (address => mapping (address => uint256)) internal allowed;
64 
65     // Public variables of the token
66   string public constant name= "Alaricoin";
67   string public constant symbol= "ALCO";
68   string public constant image="https://alaricoin.org/wp-content/alco.png";
69   string public constant x="MzksMjkyMjAyLzE2LDI1OTE3Mw==";
70   uint8 public constant decimals = 8;
71 
72   function Alaricoin() {
73 
74       // cultural project account
75       balances[0x5932cbb7Cc02cf0D811a33dAa8d818f0441b8457]=100000 * 10 ** 8;
76       
77       //developers accounts
78       balances[0x45d9927B6938b193B9E733F021DeCdaE8b582Ac4]=7000 * 10 ** 8;
79       balances[0x7195794b15747dD589747C6200194be6B56c1BF3]=6000 * 10 ** 8;
80       balances[0x59bdeAf328FBF3aeD6f6c3c874a32D6a46a1ACcf]=6000 * 10 ** 8;
81       balances[0x85afD9d575dB33F5C16E10c0eAd2519f4215ed95]=6000 * 10 ** 8;
82       balances[0x2E429e4Ddd2D494fA2708e6611429DE589303510]=5000 * 10 ** 8;
83       balances[0x17074c2480882Ad1AD53614Ab3907789108d919E]=5000 * 10 ** 8;
84       balances[0x4c6e580B8366180D3D2Ed6E338eDBB50d10edF82]=3000 * 10 ** 8;
85       balances[0x839Ab10cE6Efbaa4F38d25c913Af6C438CD2b1B9]=3000 * 10 ** 8;
86       balances[0x4C3C0053B9947d3005E31eAd0042Ab3a7C6e3Ef3]=3000 * 10 ** 8;
87       balances[0xACf858ec7301024C37C2bAaCabF1cdD691AF99e1]=3000 * 10 ** 8;
88       balances[0xb37FA525222180654DAe96ca1Ad15ECeB3595cF7]=3000 * 10 ** 8;
89 
90 
91       //airdrops accounts
92       balances[0x09Ad487Ba5Be982d64097faf19583Ad8DeaA016e]=85000 * 10 ** 8;
93       balances[0xBFc59C104bD16E84d016eFA4B34Ea47ee216C982]=85000 * 10 ** 8;
94       balances[0x6e542BA667A8feD6e6d1e2cd741F7a8a156b07D3]=85000 * 10 ** 8;
95       balances[0x5E1A8Ab18BC7D28da9e13491585DF8b0160F99cC]=85000 * 10 ** 8;
96       balances[0x793064E86b4b274BdbEF672e8EaAeB87517FfDeC]=85000 * 10 ** 8;
97       balances[0x1Fd7772Fb2Bf826fAc26566efE2624aAd664C8e9]=85000 * 10 ** 8;
98       balances[0x57f7D077ff04cA5A6e65948c938657D0Ed57603A]=85000 * 10 ** 8;
99       balances[0xA5C54614198063eD9807BB4802d70108402CeDa1]=85000 * 10 ** 8;
100       balances[0x7bbFF0b5F17d1eC947070AE104eecD56396bb4D4]=85000 * 10 ** 8;
101       balances[0x690bB68fFF6938Da706A240320Fba0933C5864B5]=85000 * 10 ** 8;
102     
103   }
104 
105 
106   /**
107   * @dev transfer token for a specified address
108   * @param _to The address to transfer to.
109   * @param _value The amount to be transferred.
110   */
111   function transfer(address _to, uint256 _value) public returns (bool) {
112     require(_to != address(0));
113     require(_value <= balances[msg.sender]);
114 
115     // SafeMath.sub will throw if there is not enough balance.
116     balances[msg.sender] = balances[msg.sender].sub(_value);
117     balances[_to] = balances[_to].add(_value);
118     Transfer(msg.sender, _to, _value);
119     return true;
120   }
121 
122   /**
123   * @dev Gets the balance of the specified address.
124   * @param _owner The address to query the the balance of.
125   * @return An uint256 representing the amount owned by the passed address.
126   */
127   function balanceOf(address _owner) public constant returns (uint256 balance) {
128     return balances[_owner];
129   }
130 
131     /**
132    * @dev Transfer tokens from one address to another
133    * @param _from address The address which you want to send tokens from
134    * @param _to address The address which you want to transfer to
135    * @param _value uint256 the amount of tokens to be transferred
136    */
137   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
138     require(_to != address(0));
139     require(_value <= balances[_from]);
140     require(_value <= allowed[_from][msg.sender]);
141 
142     balances[_from] = balances[_from].sub(_value);
143     balances[_to] = balances[_to].add(_value);
144     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
145     Transfer(_from, _to, _value);
146     return true;
147   }
148 
149   /**
150    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
151    *
152    * Beware that changing an allowance with this method brings the risk that someone may use both the old
153    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
154    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
155    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156    * @param _spender The address which will spend the funds.
157    * @param _value The amount of tokens to be spent.
158    */
159   function approve(address _spender, uint256 _value) public returns (bool) {
160     allowed[msg.sender][_spender] = _value;
161     Approval(msg.sender, _spender, _value);
162     return true;
163   }
164 
165   /**
166    * @dev Function to check the amount of tokens that an owner allowed to a spender.
167    * @param _owner address The address which owns the funds.
168    * @param _spender address The address which will spend the funds.
169    * @return A uint256 specifying the amount of tokens still available for the spender.
170    */
171   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
172     return allowed[_owner][_spender];
173   }
174 
175 }