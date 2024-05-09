1 pragma solidity ^0.4.19;
2 
3 
4 /**
5  * Math operations with safety checks
6  */
7 library SafeMath {
8   function mul(uint a, uint b) internal returns (uint) {
9     uint c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13   function div(uint a, uint b) internal returns (uint) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint a, uint b) internal returns (uint) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint a, uint b) internal returns (uint) {
26     uint c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 
31   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
32     return a >= b ? a : b;
33   }
34 
35   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
36     return a < b ? a : b;
37   }
38 
39   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
40     return a >= b ? a : b;
41   }
42 
43   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
44     return a < b ? a : b;
45   }
46 
47   function assert(bool assertion) internal {
48     if (!assertion) {
49       throw;
50     }
51   }
52 }
53 
54 
55 /**
56  * @title ERC20Basic
57  * @dev Simpler version of ERC20 interface
58  * @dev see https://github.com/ethereum/EIPs/issues/20
59  */
60 contract ERC20Basic {
61   uint public totalSupply;
62   function balanceOf(address who) constant returns (uint);
63   function transfer(address to, uint value);
64   event Transfer(address indexed from, address indexed to, uint value);
65 }
66 
67 
68 /**
69  * @title Basic token
70  * @dev Basic version of StandardToken, with no allowances.
71  */
72 contract BasicToken is ERC20Basic {
73   using SafeMath for uint;
74 
75   mapping(address => uint) balances;
76 
77   /**
78    * @dev Fix for the ERC20 short address attack.
79    */
80   modifier onlyPayloadSize(uint size) {
81      if(msg.data.length < size + 4) {
82        throw;
83      }
84      _;
85   }
86 
87   /**
88   * @dev transfer token for a specified address
89   * @param _to The address to transfer to.
90   * @param _value The amount to be transferred.
91   */
92   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
93     balances[msg.sender] = balances[msg.sender].sub(_value);
94     balances[_to] = balances[_to].add(_value);
95     Transfer(msg.sender, _to, _value);
96   }
97 
98   /**
99   * @dev Gets the balance of the specified address.
100   * @param _owner The address to query the the balance of.
101   * @return An uint representing the amount owned by the passed address.
102   */
103   function balanceOf(address _owner) constant returns (uint balance) {
104     return balances[_owner];
105   }
106 }
107 
108 
109 /**
110  * @title ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/20
112  */
113 contract ERC20 is ERC20Basic {
114   function allowance(address owner, address spender) constant returns (uint);
115   function transferFrom(address from, address to, uint value);
116   function approve(address spender, uint value);
117   event Approval(address indexed owner, address indexed spender, uint value);
118 }
119 
120 
121 /**
122  * @title Standard ERC20 token
123  *
124  * @dev Implemantation of the basic standart token.
125  * @dev https://github.com/ethereum/EIPs/issues/20
126  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
127  */
128 contract StandardToken is BasicToken, ERC20 {
129 
130   mapping (address => mapping (address => uint)) allowed;
131 
132   /**
133    * @dev Transfer tokens from one address to another
134    * @param _from address The address which you want to send tokens from
135    * @param _to address The address which you want to transfer to
136    * @param _value uint the amout of tokens to be transfered
137    */
138   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
139     var _allowance = allowed[_from][msg.sender];
140 
141     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
142     // if (_value > _allowance) throw;
143 
144     balances[_to] = balances[_to].add(_value);
145     balances[_from] = balances[_from].sub(_value);
146     allowed[_from][msg.sender] = _allowance.sub(_value);
147     Transfer(_from, _to, _value);
148   }
149 
150   /**
151    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
152    * @param _spender The address which will spend the funds.
153    * @param _value The amount of tokens to be spent.
154    */
155   function approve(address _spender, uint _value) {
156 
157     // To change the approve amount you first have to reduce the addresses`
158     //  allowance to zero by calling `approve(_spender, 0)` if it is not
159     //  already 0 to mitigate the race condition described here:
160     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
161     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
162 
163     allowed[msg.sender][_spender] = _value;
164     Approval(msg.sender, _spender, _value);
165   }
166 
167   /**
168    * @dev Function to check the amount of tokens than an owner allowed to a spender.
169    * @param _owner address The address which owns the funds.
170    * @param _spender address The address which will spend the funds.
171    * @return A uint specifing the amount of tokens still avaible for the spender.
172    */
173   function allowance(address _owner, address _spender) constant returns (uint remaining) {
174     return allowed[_owner][_spender];
175   }
176 }
177 
178 contract LULUToken is StandardToken {
179   using SafeMath for uint256;
180 
181   string public name = "LULU Token";
182   string public symbol = "LULU";
183   string public releaseArr = '0000000000000000000';
184  
185   uint public decimals = 18;
186   
187   function LULUToken() {
188     totalSupply = 100000000000 * 1000000000000000000;
189     balances[msg.sender] = totalSupply / 5;
190   }
191 
192   function tokenRelease() public returns (string) {
193      
194     uint256 y2019 = 1557936000;
195     uint256 y2020 = 1589558400;
196     uint256 y2021 = 1621094400;
197     uint256 y2022 = 1652630400;
198     uint256 y2023 = 1684166400;
199 
200     if (now > y2019 && now <= 1573833600 && bytes(releaseArr)[0] == '0') {
201         bytes(releaseArr)[0] = '1';
202         balances[msg.sender] = balances[msg.sender] + totalSupply / 10;
203         return releaseArr;
204     } else if (now > 1573833600 && now <= y2020 && bytes(releaseArr)[1] == '0') {
205         bytes(releaseArr)[1] = '1';
206         balances[msg.sender] = balances[msg.sender] + totalSupply / 10;
207         return releaseArr;
208     }
209     
210     if (now > y2020 && now <= 1605456000 && bytes(releaseArr)[2] == '0') {
211         bytes(releaseArr)[2] = '1';
212         balances[msg.sender] = balances[msg.sender] + totalSupply / 10;
213         return releaseArr;
214     } else if (now > 1605456000 && now <= y2021  && bytes(releaseArr)[3] == '0') {
215         bytes(releaseArr)[3] = '1';
216         balances[msg.sender] = balances[msg.sender] + totalSupply / 10;
217         return releaseArr;
218     }
219     
220     if (now > y2021 && now <= 1636992000 && bytes(releaseArr)[4] == '0') {
221         bytes(releaseArr)[4] = '1';
222         balances[msg.sender] = balances[msg.sender] + totalSupply / 10;
223         return releaseArr;
224     } else if (now > 1636992000 && now <= y2022 && bytes(releaseArr)[5] == '0') {
225         bytes(releaseArr)[5] = '1';
226         balances[msg.sender] = balances[msg.sender] + totalSupply / 10;
227         return releaseArr;
228     }
229     
230     if (now > y2022 && now <= 1668528000 && bytes(releaseArr)[6] == '0') {
231         bytes(releaseArr)[6] = '1';
232         balances[msg.sender] = balances[msg.sender] + totalSupply / 10;
233         return releaseArr;
234     }else if (now > 1668528000  && now <= y2023 && bytes(releaseArr)[7] == '0') {
235         bytes(releaseArr)[7] = '1';
236         balances[msg.sender] = balances[msg.sender] + totalSupply / 10;
237         return releaseArr;
238     }
239 
240     return releaseArr;
241   }
242 }