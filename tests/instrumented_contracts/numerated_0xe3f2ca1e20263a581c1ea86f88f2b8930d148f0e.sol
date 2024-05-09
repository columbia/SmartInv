1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 
28   function toUINT112(uint256 a) internal pure returns(uint112) {
29     assert(uint112(a) == a);
30     return uint112(a);
31   }
32 
33   function toUINT120(uint256 a) internal pure returns(uint120) {
34     assert(uint120(a) == a);
35     return uint120(a);
36   }
37 
38   function toUINT128(uint256 a) internal pure returns(uint128) {
39     assert(uint128(a) == a);
40     return uint128(a);
41   }
42 }
43 
44 contract ERC20Basic {
45   uint256 public totalSupply;
46   function balanceOf(address who) public constant returns (uint256);
47   function transfer(address to, uint256 value) public returns (bool);
48   event Transfer(address indexed from, address indexed to, uint256 value);
49 }
50 
51 contract ERC20 is ERC20Basic {
52   function allowance(address owner, address spender) public constant returns (uint256);
53   function transferFrom(address from, address to, uint256 value) public returns (bool);
54   function approve(address spender, uint256 value) public returns (bool);
55   event Approval(address indexed owner, address indexed spender, uint256 value);
56 }
57 
58 contract BasicToken is ERC20Basic {
59   using SafeMath for uint256;
60 
61   mapping(address => uint256) balances;
62   mapping(address => uint256) restricts;
63 
64   /**
65   * @dev transfer token for a specified address
66   * @param _to The address to transfer to.
67   * @param _value The amount to be transferred.
68   */
69   function transfer(address _to, uint256 _value) public returns (bool) {
70     require(_to != address(0));
71     require(_value <= balances[msg.sender]);
72 
73     require(restricts[msg.sender] <= now);
74 
75     // SafeMath.sub will throw if there is not enough balance.
76     balances[msg.sender] = balances[msg.sender].sub(_value);
77     balances[_to] = balances[_to].add(_value);
78     emit Transfer(msg.sender, _to, _value);
79     return true;
80   }
81 
82   /**
83   * @dev Gets the balance of the specified address.
84   * @param _owner The address to query the the balance of.
85   * @return An uint256 representing the amount owned by the passed address.
86   */
87   function balanceOf(address _owner) public constant returns (uint256 balance) {
88     return balances[_owner];
89   }
90 
91 }
92 
93 contract StandardToken is ERC20, BasicToken {
94 
95   mapping (address => mapping (address => uint256)) internal allowed;
96 
97 
98   /**
99    * @dev Transfer tokens from one address to another
100    * @param _from address The address which you want to send tokens from
101    * @param _to address The address which you want to transfer to
102    * @param _value uint256 the amount of tokens to be transferred
103    */
104   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
105     require(_to != address(0));
106     require(_value <= balances[_from]);
107     require(_value <= allowed[_from][msg.sender]);
108 
109     require(restricts[_from] <= now);
110 
111     balances[_from] = balances[_from].sub(_value);
112     balances[_to] = balances[_to].add(_value);
113     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
114     emit Transfer(_from, _to, _value);
115     return true;
116   }
117 
118   /**
119    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
120    *
121    * Beware that changing an allowance with this method brings the risk that someone may use both the old
122    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
123    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
124    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
125    * @param _spender The address which will spend the funds.
126    * @param _value The amount of tokens to be spent.
127    */
128   function approve(address _spender, uint256 _value) public returns (bool) {
129     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
130     require(restricts[msg.sender] <= now);
131     
132     allowed[msg.sender][_spender] = _value;
133     emit Approval(msg.sender, _spender, _value);
134     return true;
135   }
136 
137   /**
138    * @dev Function to check the amount of tokens that an owner allowed to a spender.
139    * @param _owner address The address which owns the funds.
140    * @param _spender address The address which will spend the funds.
141    * @return A uint256 specifying the amount of tokens still available for the spender.
142    */
143   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
144     return allowed[_owner][_spender];
145   }
146 
147 }
148 
149 contract F1ZZToken is StandardToken {
150 
151   string public constant name = "F1ZZToken";
152   string public constant symbol = "FZZ";
153   uint8 public constant decimals = 18;
154 
155 
156   uint256 public constant INITIAL_SUPPLY = 35000000000 * (10 ** uint256(decimals));
157   
158   constructor() public {
159     totalSupply = INITIAL_SUPPLY;
160 
161     balances[0xB5CaD809c5c4A6825249a0b7d6260D3A8144c254] = 875000000 * (10 ** uint256(decimals));
162     emit Transfer(msg.sender, 0xB5CaD809c5c4A6825249a0b7d6260D3A8144c254, 875000000 * (10 ** uint256(decimals)));
163 
164     balances[0x4Ac2410C1Ed6651F44A361EcCc8D8Fd9554F24A3] = 1750000000 * (10 ** uint256(decimals));
165     emit Transfer(msg.sender, 0x4Ac2410C1Ed6651F44A361EcCc8D8Fd9554F24A3, 1750000000 * (10 ** uint256(decimals)));
166 
167     balances[0xa79F051Beb3b9700b3417570D37FC20D540abef8] = 875000000  * (10 ** uint256(decimals));
168     emit Transfer(msg.sender, 0xa79F051Beb3b9700b3417570D37FC20D540abef8, 875000000 * (10 ** uint256(decimals)));
169 
170 
171     balances[0x2b0301De52848E0886521e58250CF887383201f4] = 250000000 * (10 ** uint256(decimals));
172     emit Transfer(msg.sender, 0x2b0301De52848E0886521e58250CF887383201f4, 250000000 * (10 ** uint256(decimals)));
173 
174 
175     balances[0x86453BCA8d8a0a5Ba88ab3700d5CD4545039d5C6] = 875000000  * (10 ** uint256(decimals));
176     emit Transfer(msg.sender, 0x86453BCA8d8a0a5Ba88ab3700d5CD4545039d5C6, 875000000 * (10 ** uint256(decimals)));
177 
178 
179     balances[0x709292Fc5d5a31d9E679bbbd19DE652a8AcB6D29] = 1500000000  * (10 ** uint256(decimals));
180     emit Transfer(msg.sender, 0x709292Fc5d5a31d9E679bbbd19DE652a8AcB6D29, 1500000000 * (10 ** uint256(decimals)));
181 
182     balances[0x4D8c85780e913B551cbA382e191D09456F5A2cb2] = 7000000000 * (10 ** uint256(decimals));
183     emit Transfer(msg.sender, 0x4D8c85780e913B551cbA382e191D09456F5A2cb2, 7000000000 * (10 ** uint256(decimals)));
184 
185     balances[0x035Fef4499d61abcEfEd458B5a9621586349F94e] = 1750000000 * (10 ** uint256(decimals));
186     emit Transfer(msg.sender, 0x035Fef4499d61abcEfEd458B5a9621586349F94e, 1750000000 * (10 ** uint256(decimals)));
187 
188     balances[0x2b5D5A25E88187Ee03174f267395198EDC8fCD3A] = 5250000000 * (10 ** uint256(decimals));
189     emit Transfer(msg.sender, 0x2b5D5A25E88187Ee03174f267395198EDC8fCD3A, 5250000000 * (10 ** uint256(decimals)));
190 
191 
192     balances[0xfA08d0db631dc6c50a51a198e9EE0A7839BBa873] = 3500000000 * (10 ** uint256(decimals));
193     emit Transfer(msg.sender, 0xfA08d0db631dc6c50a51a198e9EE0A7839BBa873, 3500000000 * (10 ** uint256(decimals)));
194 
195 
196     balances[0x6EB8376F0B044Cad3168E189362B9d3484aEd295] = 2625000000 * (10 ** uint256(decimals));
197     emit Transfer(msg.sender, 0x6EB8376F0B044Cad3168E189362B9d3484aEd295, 2625000000 * (10 ** uint256(decimals)));
198 
199     balances[0xba44f101579401d6F80C4C5b04c65fB5447FBDc8] = 5250000000  * (10 ** uint256(decimals));
200     emit Transfer(msg.sender, 0xba44f101579401d6F80C4C5b04c65fB5447FBDc8, 5250000000 * (10 ** uint256(decimals)));
201 
202     balances[0x54A153f12B8701e7A4ee7622747E4efc7f04533c] = 3500000000  * (10 ** uint256(decimals));
203     emit Transfer(msg.sender, 0x54A153f12B8701e7A4ee7622747E4efc7f04533c, 3500000000 * (10 ** uint256(decimals)));
204 
205     /* record the time */
206 
207     restricts[0x2b0301De52848E0886521e58250CF887383201f4] = now + 104 days;
208 
209     restricts[0x86453BCA8d8a0a5Ba88ab3700d5CD4545039d5C6] = now + 134 days;
210     restricts[0x709292Fc5d5a31d9E679bbbd19DE652a8AcB6D29] = now + 134 days;
211     restricts[0x4D8c85780e913B551cbA382e191D09456F5A2cb2] = now + 134 days;
212     restricts[0x035Fef4499d61abcEfEd458B5a9621586349F94e] = now + 134 days;
213     restricts[0x2b5D5A25E88187Ee03174f267395198EDC8fCD3A] = now + 134 days;
214     restricts[0xfA08d0db631dc6c50a51a198e9EE0A7839BBa873] = now + 134 days;
215     restricts[0x6EB8376F0B044Cad3168E189362B9d3484aEd295] = now + 134 days;
216     restricts[0xba44f101579401d6F80C4C5b04c65fB5447FBDc8] = now + 134 days;
217     restricts[0x54A153f12B8701e7A4ee7622747E4efc7f04533c] = now + 134 days;
218   }
219 
220 }