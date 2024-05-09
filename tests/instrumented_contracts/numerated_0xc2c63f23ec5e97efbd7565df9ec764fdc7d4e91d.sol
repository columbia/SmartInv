1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 pragma solidity ^0.4.11;
35 
36 
37 /**
38  * @title Ownable
39  * @dev The Ownable contract has an owner address, and provides basic authorization control 
40  * functions, this simplifies the implementation of "user permissions". 
41  */
42 contract Ownable {
43   address public owner;
44 
45 
46   /** 
47    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50   function Ownable() {
51     owner = msg.sender;
52   }
53 
54 
55   /**
56    * @dev Throws if called by any account other than the owner. 
57    */
58   modifier onlyOwner() {
59     if (msg.sender != owner) {
60       throw;
61     }
62     _;
63   }
64 
65 
66   /**
67    * @dev Allows the current owner to transfer control of the contract to a newOwner.
68    * @param newOwner The address to transfer ownership to. 
69    */
70   function transferOwnership(address newOwner) onlyOwner {
71     if (newOwner != address(0)) {
72       owner = newOwner;
73     }
74   }
75 
76 }
77 
78 pragma solidity ^0.4.11;
79 
80 
81 /**
82  * @title ERC20Basic
83  * @dev Simpler version of ERC20 interface
84  * @dev see https://github.com/ethereum/EIPs/issues/20
85  */
86 contract ERC20Basic {
87   uint256 public totalSupply;
88   function balanceOf(address who) constant returns (uint256);
89   function transfer(address to, uint256 value);
90   event Transfer(address indexed from, address indexed to, uint256 value);
91 }
92 
93 pragma solidity ^0.4.11;
94 
95 
96 
97 
98 /**
99  * @title ERC20 interface
100  * @dev see https://github.com/ethereum/EIPs/issues/20
101  */
102 contract ERC20 is ERC20Basic {
103   function allowance(address owner, address spender) constant returns (uint256);
104   function transferFrom(address from, address to, uint256 value);
105   function approve(address spender, uint256 value);
106   event Approval(address indexed owner, address indexed spender, uint256 value);
107 }
108 
109 pragma solidity ^0.4.11;
110 
111 
112 
113 
114 /**
115  * @title Basic token
116  * @dev Basic version of StandardToken, with no allowances. 
117  */
118 contract BasicToken is ERC20Basic {
119   using SafeMath for uint256;
120 
121   mapping(address => uint256) balances;
122 
123   /**
124   * @dev transfer token for a specified address
125   * @param _to The address to transfer to.
126   * @param _value The amount to be transferred.
127   */
128   function transfer(address _to, uint256 _value) {
129     balances[msg.sender] = balances[msg.sender].sub(_value);
130     balances[_to] = balances[_to].add(_value);
131     Transfer(msg.sender, _to, _value);
132   }
133 
134   /**
135   * @dev Gets the balance of the specified address.
136   * @param _owner The address to query the the balance of. 
137   * @return An uint256 representing the amount owned by the passed address.
138   */
139   function balanceOf(address _owner) constant returns (uint256 balance) {
140     return balances[_owner];
141   }
142 
143 }
144 
145 pragma solidity ^0.4.11;
146 
147 
148 
149 
150 /**
151  * @title Standard ERC20 token
152  *
153  * @dev Implementation of the basic standard token.
154  * @dev https://github.com/ethereum/EIPs/issues/20
155  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
156  */
157 contract StandardToken is ERC20, BasicToken {
158 
159   mapping (address => mapping (address => uint256)) allowed;
160 
161 
162   /**
163    * @dev Transfer tokens from one address to another
164    * @param _from address The address which you want to send tokens from
165    * @param _to address The address which you want to transfer to
166    * @param _value uint256 the amout of tokens to be transfered
167    */
168   function transferFrom(address _from, address _to, uint256 _value) {
169     var _allowance = allowed[_from][msg.sender];
170 
171     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
172     // if (_value > _allowance) throw;
173 
174     balances[_to] = balances[_to].add(_value);
175     balances[_from] = balances[_from].sub(_value);
176     allowed[_from][msg.sender] = _allowance.sub(_value);
177     Transfer(_from, _to, _value);
178   }
179 
180   /**
181    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
182    * @param _spender The address which will spend the funds.
183    * @param _value The amount of tokens to be spent.
184    */
185   function approve(address _spender, uint256 _value) {
186 
187     // To change the approve amount you first have to reduce the addresses`
188     //  allowance to zero by calling `approve(_spender, 0)` if it is not
189     //  already 0 to mitigate the race condition described here:
190     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
191     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
192 
193     allowed[msg.sender][_spender] = _value;
194     Approval(msg.sender, _spender, _value);
195   }
196 
197   /**
198    * @dev Function to check the amount of tokens that an owner allowed to a spender.
199    * @param _owner address The address which owns the funds.
200    * @param _spender address The address which will spend the funds.
201    * @return A uint256 specifing the amount of tokens still avaible for the spender.
202    */
203   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
204     return allowed[_owner][_spender];
205   }
206 
207 }
208 
209 pragma solidity ^0.4.11;
210 
211 
212 
213 
214 
215 /**
216  * @title Mintable token
217  * @dev Simple ERC20 Token example, with mintable token creation
218  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
219  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
220  */
221 
222 contract MintableToken is StandardToken, Ownable {
223   event Mint(address indexed to, uint256 amount);
224   event MintFinished();
225 
226   bool public mintingFinished = false;
227 
228 
229   modifier canMint() {
230     if(mintingFinished) throw;
231     _;
232   }
233 
234   /**
235    * @dev Function to mint tokens
236    * @param _to The address that will recieve the minted tokens.
237    * @param _amount The amount of tokens to mint.
238    * @return A boolean that indicates if the operation was successful.
239    */
240   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
241     totalSupply = totalSupply.add(_amount);
242     balances[_to] = balances[_to].add(_amount);
243     Mint(_to, _amount);
244     return true;
245   }
246 
247   /**
248    * @dev Function to stop minting new tokens.
249    * @return True if the operation was successful.
250    */
251   function finishMinting() onlyOwner returns (bool) {
252     mintingFinished = true;
253     MintFinished();
254     return true;
255   }
256 }
257 
258 pragma solidity ^0.4.11;
259 
260 
261 /*
262     Copyright 2017, Giovanni Zorzato (Boulé Foundation)
263 */
264 
265 contract BouleToken is MintableToken {
266     // BouleToken is an OpenZeppelin Mintable Token
267     string public name = "Boule Token";
268     string public symbol = "BOU";
269     uint public decimals = 18;
270 
271     // do no allow to send ether to this token
272     function () public payable {
273         throw;
274     }
275 
276 }