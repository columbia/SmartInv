1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 /**
37  * @title ERC20Basic
38  * @dev Simpler version of ERC20 interface
39  * @dev see https://github.com/ethereum/EIPs/issues/179
40  */
41 contract ERC20Basic {
42   uint256 public totalSupply;
43   function balanceOf(address who) public view returns (uint256);
44   function transfer(address to, uint256 value) public returns (bool);
45   event Transfer(address indexed from, address indexed to, uint256 value);
46 }
47 
48 /**
49  * @title ERC20 interface
50  * @dev see https://github.com/ethereum/EIPs/issues/20
51  */
52 contract ERC20 is ERC20Basic {
53   function allowance(address owner, address spender) public view returns (uint256);
54   function transferFrom(address from, address to, uint256 value) public returns (bool);
55   function approve(address spender, uint256 value) public returns (bool);
56   event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 /**
60  * @title Basic token
61  * @dev Basic version of StandardToken, with no allowances.
62  */
63 contract BasicToken is ERC20Basic {
64   using SafeMath for uint256;
65 
66   mapping(address => uint256) balances;
67 
68   /**
69   * @dev transfer token for a specified address
70   * @param _to The address to transfer to.
71   * @param _value The amount to be transferred.
72   */
73   function transfer(address _to, uint256 _value) public returns (bool) {
74     require(_to != address(0));
75     require(_value <= balances[msg.sender]);
76 
77     // SafeMath.sub will throw if there is not enough balance.
78     balances[msg.sender] = balances[msg.sender].sub(_value);
79     balances[_to] = balances[_to].add(_value);
80     emit Transfer(msg.sender, _to, _value);
81     return true;
82   }
83 
84   /**
85   * @dev Gets the balance of the specified address.
86   * @param _owner The address to query the the balance of.
87   * @return An uint256 representing the amount owned by the passed address.
88   */
89   function balanceOf(address _owner) public view returns (uint256 balance) {
90     return balances[_owner];
91   }
92 
93 }
94 
95 /**
96  * @title Standard ERC20 token
97  *
98  * @dev Implementation of the basic standard token.
99  * @dev https://github.com/ethereum/EIPs/issues/20
100  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
101  */
102 contract StandardToken is ERC20, BasicToken {
103 
104   mapping (address => mapping (address => uint256)) internal allowed;
105 
106 
107   /**
108    * @dev Transfer tokens from one address to another
109    * @param _from address The address which you want to send tokens from
110    * @param _to address The address which you want to transfer to
111    * @param _value uint256 the amount of tokens to be transferred
112    */
113   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
114     require(_to != address(0));
115     require(_value <= balances[_from]);
116     require(_value <= allowed[_from][msg.sender]);
117 
118     balances[_from] = balances[_from].sub(_value);
119     balances[_to] = balances[_to].add(_value);
120     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
121     emit Transfer(_from, _to, _value);
122     return true;
123   }
124 
125   /**
126    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
127    *
128    * Beware that changing an allowance with this method brings the risk that someone may use both the old
129    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
130    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
131    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132    * @param _spender The address which will spend the funds.
133    * @param _value The amount of tokens to be spent.
134    */
135   function approve(address _spender, uint256 _value) public returns (bool) {
136     allowed[msg.sender][_spender] = _value;
137     emit Approval(msg.sender, _spender, _value);
138     return true;
139   }
140 
141   /**
142    * @dev Function to check the amount of tokens that an owner allowed to a spender.
143    * @param _owner address The address which owns the funds.
144    * @param _spender address The address which will spend the funds.
145    * @return A uint256 specifying the amount of tokens still available for the spender.
146    */
147   function allowance(address _owner, address _spender) public view returns (uint256) {
148     return allowed[_owner][_spender];
149   }
150 
151   /**
152    * approve should be called when allowed[_spender] == 0. To increment
153    * allowed value is better to use this function to avoid 2 calls (and wait until
154    * the first transaction is mined)
155    * From MonolithDAO Token.sol
156    */
157   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
158     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
159     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
160     return true;
161   }
162 
163   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
164     uint oldValue = allowed[msg.sender][_spender];
165     if (_subtractedValue > oldValue) {
166       allowed[msg.sender][_spender] = 0;
167     } else {
168       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
169     }
170     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
171     return true;
172   }
173 
174 }
175 
176 contract DesignerChain is StandardToken {
177     using SafeMath for uint256;
178     string public name = "Designer Chain";
179     string public symbol = "DC";
180     uint public decimals = 6;
181 
182     address public saleAddress = 0x99b3bf93150E05900CF433FD61e932fE025E6869;
183     uint256 public saleAmount = 3000000000 * (10 ** decimals); 
184     address public socialAddress = 0x8897fd8334c4b43307a7D781792EbFC6434E8AB6;
185     uint256 public socialAmount = 2500000000 * (10 ** decimals); 
186     address public operAddress = 0x980D864E9931d6Ee47214522f0a9CFFD100Fc8a0;
187     uint256 public operAmount = 1500000000 * (10 ** decimals); 
188     address public fundAddress = 0x2FA7bE982cee1d8D44b0db1d0AE177C88E545b08;
189     uint256 public fundAmount = 1000000000 * (10 ** decimals); 
190     address public teamAddress1 = 0x3240c16b67CB30f530DC2b0192e7647BE9d7E3fD;
191     uint256 public teamAmount1 = 711000000 * (10 ** decimals); 
192     address public teamAddress2 = 0xB01031F10240D6c98954e187320918230369e5A8;
193     uint256 public teamAmount2 = 333000000 * (10 ** decimals); 
194     address public teamAddress3 = 0xC601493e335BdC36b736D69f7CD0ef9586dD59a0;
195     uint256 public teamAmount3 = 300000000 * (10 ** decimals); 
196     address public teamAddress4 = 0x62C1eC256B7bb10AA53FD4208454E1BFD533b7f0;
197     uint256 public teamAmount4 = 300000000 * (10 ** decimals); 
198     address public teamAddress5 = 0xfE7678004882AD8b00ddBbBA677a16F7361E4c06;
199     uint256 public teamAmount5 = 50000000 * (10 ** decimals); 
200     address public teamAddress6 = 0xB9c514062C41d290b6567fB64895A48472689eEB;
201     uint256 public teamAmount6 = 211000000 * (10 ** decimals);
202     address public teamAddress7 = 0x142758621031aDA83C16F877720Cddc0c4129D99;
203     uint256 public teamAmount7 = 89000000 * (10 ** decimals); 
204     address public teamAddress8 = 0x2036aB5dEBdba6755041316DbF9a3c7852Ed8152;
205     uint256 public teamAmount8 = 1000000 * (10 ** decimals); 
206     address public teamAddress9 = 0x756CB9C1024B783041aBB894c33eD997556575C3;
207     uint256 public teamAmount9 = 1000000 * (10 ** decimals); 
208     address public teamAddress10 = 0xeB3611Ab4280D75f32129Cc79d05fc9C8352593F;
209     uint256 public teamAmount10 = 1000000 * (10 ** decimals); 
210     address public teamAddress11 = 0xd24F5A7dB60DbbE9ca3b48Ed9f337B0C0aD5C589;
211     uint256 public teamAmount11 = 1000000 * (10 ** decimals); 
212     address public teamAddress12 = 0x45f6c4Ee1a045DF316eDc446EE1a10A8820A7554;
213     uint256 public teamAmount12 = 1000000 * (10 ** decimals); 
214     address public teamAddress13 = 0x47Cec1725C5732A37e8809a0ca9F00E04783AB0F;
215     uint256 public teamAmount13 = 1000000 * (10 ** decimals); 
216 
217     function DesignerChain() public {
218         balances[saleAddress] = saleAmount;
219         emit Transfer(address(0), saleAddress, saleAmount);
220 
221         balances[socialAddress] = socialAmount;
222         emit Transfer(address(0), socialAddress, socialAmount);
223 
224         balances[operAddress] = operAmount;
225         emit Transfer(address(0), operAddress, operAmount);
226 
227         balances[fundAddress] = fundAmount;
228         emit Transfer(address(0), fundAddress, fundAmount);
229 
230         balances[teamAddress1] = teamAmount1;
231         emit Transfer(address(0), teamAddress1, teamAmount1); 
232 
233         balances[teamAddress2] = teamAmount2;
234         emit Transfer(address(0), teamAddress2, teamAmount2); 
235 
236         balances[teamAddress3] = teamAmount3;
237         emit Transfer(address(0), teamAddress3, teamAmount3); 
238 
239         balances[teamAddress4] = teamAmount4;
240         emit Transfer(address(0), teamAddress4, teamAmount4); 
241 
242         balances[teamAddress5] = teamAmount5;
243         emit Transfer(address(0), teamAddress5, teamAmount5); 
244 
245         balances[teamAddress6] = teamAmount6;
246         emit Transfer(address(0), teamAddress6, teamAmount6); 
247 
248         balances[teamAddress7] = teamAmount7;
249         emit Transfer(address(0), teamAddress7, teamAmount7); 
250 
251         balances[teamAddress8] = teamAmount8;
252         emit Transfer(address(0), teamAddress8, teamAmount8); 
253 
254         balances[teamAddress9] = teamAmount9;
255         emit Transfer(address(0), teamAddress9, teamAmount9); 
256 
257         balances[teamAddress10] = teamAmount10;
258         emit Transfer(address(0), teamAddress10, teamAmount10); 
259 
260         balances[teamAddress11] = teamAmount11;
261         emit Transfer(address(0), teamAddress11, teamAmount11); 
262 
263         balances[teamAddress12] = teamAmount12;
264         emit Transfer(address(0), teamAddress12, teamAmount12); 
265 
266         balances[teamAddress13] = teamAmount13;
267         emit Transfer(address(0), teamAddress13, teamAmount13); 
268 
269         totalSupply = 10000000000 * (10 ** decimals);  //总共发行100亿
270     }
271 }