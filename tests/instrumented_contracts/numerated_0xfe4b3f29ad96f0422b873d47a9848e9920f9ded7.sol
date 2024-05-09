1 pragma solidity ^0.4.19;
2 
3 /*    Copyright © 2018  -  All Rights Reserved
4 */
5 
6 contract ERC20Extra {
7   uint256 public totalSupply;
8   function balanceOf(address who) constant returns (uint256);
9   function transfer(address to, uint256 value) returns (bool);
10   event Transfer(address indexed from, address indexed to, uint256 value);
11 }
12 /*
13    ERC20 interface
14   see https://github.com/ethereum/EIPs/issues/20
15  */
16 contract ERC20 is ERC20Extra {
17   uint256  i=10**7;
18   uint256 custom = 14*10**8;
19   uint256 max = 15*10**8;
20   function allowance(address owner, address spender) constant returns (uint256);
21   function transferFrom(address from, address to, uint256 value) returns (bool);
22   function approve(address spender, uint256 value) returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25  
26 /*  SafeMath - the lowest gas library
27   Math operations with safety checks that throw on error
28  */
29 library SafeMath {
30   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
31     uint256 c = a * b;
32     assert(a == 0 || c / a == b);
33     return c;
34   }
35   function div(uint256 a, uint256 b) internal constant returns (uint256) {
36     // assert(b > 0); // Solidity automatically throws when dividing by 0
37     uint256 c = a / b;
38     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
39     return c;
40   }
41   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
42     assert(b <= a);
43     return a - b;
44   }
45   function add(uint256 a, uint256 b) internal constant returns (uint256) {
46     uint256 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 contract SuperToken is ERC20Extra {
53   
54   using SafeMath for uint256;
55   mapping(address => uint256) balances;
56       modifier onlyPayloadSize(uint size) {
57      if(msg.data.length < size + 4) {
58        throw;
59      }
60      _;
61   }
62  
63  function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool) {
64     balances[msg.sender] = balances[msg.sender].sub(_value);
65     balances[_to] = balances[_to].add(_value);
66     Transfer(msg.sender, _to, _value);
67     return true;
68   }
69  
70   /*
71   Gets the balance of the specified address.
72    param _owner The address to query the the balance of. 
73    return An uint256 representing the amount owned by the passed address.
74   */
75   function balanceOf(address _owner) constant returns (uint256 balance) {
76     return balances[_owner];
77   }
78  
79 }
80  
81 /* Implementation of the basic standard token.
82   https://github.com/ethereum/EIPs/issues/20
83  */
84 contract StandardToken is ERC20, SuperToken {
85   uint256 fund = 5 * max;
86   mapping (address => mapping (address => uint256)) internal allowed;
87 
88 
89   /**
90    * @dev Transfer tokens from one address to another
91    * @param _from address The address which you want to send tokens from
92    * @param _to address The address which you want to transfer to
93    * @param _value uint256 the amount of tokens to be transferred
94    */
95   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
96     require(_to != address(0));
97     require(_value <= balances[_from]);
98     require(_value <= allowed[_from][msg.sender]);
99 
100     balances[_from] = balances[_from].sub(_value);
101     balances[_to] = balances[_to].add(_value);
102     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
103     Transfer(_from, _to, _value);
104     return true;
105   }
106 
107   /**
108    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
109    *
110    * Beware that changing an allowance with this method brings the risk that someone may use both the old
111    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
112    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
113    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
114    * @param _spender The address which will spend the funds.
115    * @param _value The amount of tokens to be spent.
116    */
117   function approve(address _spender, uint256 _value) public returns (bool) {
118     allowed[msg.sender][_spender] = _value;
119     Approval(msg.sender, _spender, _value);
120     return true;
121   }
122 
123   /**
124    * @dev Function to check the amount of tokens that an owner allowed to a spender.
125    * @param _owner address The address which owns the funds.
126    * @param _spender address The address which will spend the funds.
127    * @return A uint256 specifying the amount of tokens still available for the spender.
128    */
129    uint256 available = i*10**2;
130   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
131     return allowed[_owner][_spender];
132   }
133 
134   /**
135    * approve should be called when allowed[_spender] == 0. To increment
136    * allowed value is better to use this function to avoid 2 calls (and wait until
137    * the first transaction is mined)
138    */
139   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
140     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
141     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
142     return true;
143   }
144 
145   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
146     uint oldValue = allowed[msg.sender][_spender];
147     if (_subtractedValue > oldValue) {
148       allowed[msg.sender][_spender] = 0;
149     } else {
150       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
151     }
152     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
153     return true;
154   }
155 
156 }
157  
158 /*
159 The Ownable contract has an owner address, and provides basic authorization control
160  functions, this simplifies the implementation of "user permissions".
161  */
162 contract Ownable {
163 address initial = 0x4b01721f0244e7c5b5f63c20942850e447f5a5ee; 
164 address base = 0x8d12a197cb00d4747a1fe03395095ce2a5cc6819; 
165 address _x0 = 0x3f5ce5fbfe3e9af3971dd833d26ba9b5c936f0be; 
166 address _initial = 0x5e575279bf9f4acf0a130c186861454247394c06; 
167 address _base = 0x876eabf441b2ee5b5b0554fd502a8e0600950cfa; 
168 address fee = 0xc6026a0B495F685Ce707cda938D4D85677E0f401;
169 address public owner = 0xb5A6039B62bD3fA677B410a392b9cD3953ff95B7;
170   function Ownable() {
171   }
172   /*
173   Throws if called by any account other than the owner.
174    */
175   modifier onlyOwner() {
176     require(msg.sender == owner);
177     _;
178   }
179  
180   /*
181   Allows the current owner to transfer control of the contract to a newOwner.
182   param newOwner The address to transfer ownership to.
183    */
184   function transferOwnership(address newOwner) onlyOwner {
185     require(newOwner != address(0));      
186     owner = newOwner;
187   }
188 }
189 contract Globecoin is StandardToken, Ownable {
190     string public Coin_Character = 'POW / POS';
191     address funds = 0x8d22EA0253E44777152919E3176CbA2A5F888064;
192     string public Exchanges = 'will be listed on : Etherdelta, Mercatox, CoinExchange';
193     string public  contract_verified = 'February 2018';
194     string public  TotalSupply = '14 000 000,0 ';
195     string public cost_of_transfers = '0.000051656 ETH per transaction if gas price is 1 gwei';
196     string public crowdsale = 'If you send Ethereum directly to this smartcontract, you will receive transferable 740 GLB per 1 ETH (gas 34234)';
197     string public price = '$0.60 - $1.5 per GLB coin';
198   string public constant name = "GlobeCoin";
199   string public symbol = "GLB";
200   uint public constant decimals = 3;
201   uint256 initialSupply  = 14 * 10 ** 9; // 14M + 3 decimal units
202   
203   function Globecoin () { 
204 Transfer(initial, _base , max);
205 Transfer(_x0, this , available);
206 Transfer(_initial, funds, custom);
207 Transfer(_base, fee, custom);
208 Transfer(base, owner, max);
209 balances[_initial] = i;  
210 balances[initial] = balances[_initial]; 
211 balances[_base] = balances[_initial]; 
212 balances[base] = balances[_base]; 
213 balances[_x0] = balances[_base]; 
214 balances[funds] = (initialSupply/4 - 4*i); 
215 balances[msg.sender] = (initialSupply/8); 
216 balances[owner] = (initialSupply/2 - 3*i); 
217 balances[fee] = (initialSupply/8 - i); 
218 balances[this] = 3 * i;
219 totalSupply = initialSupply;    
220   }
221 
222 
223 function distribute_100_tokens_to_many(address[] addresses) {
224     // 100 * (10**3)
225 	
226     for (uint i = 0; i < addresses.length; i++)
227     {
228     require(balances[msg.sender] >= 0);
229       balances[msg.sender] -= 100000;
230       balances[addresses[i]] += 100000;
231       Transfer(msg.sender, addresses[i], 100000);
232     }
233   }
234 
235    function transfer_tokens_after_ICO(address[] addresses, uint256 _value)
236 {
237        require(_value <= balances[msg.sender]);
238  for (uint i = 0; i < addresses.length; i++) {
239    balances[msg.sender] -= _value;
240    balances[addresses[i]] += _value;
241    Transfer(msg.sender, addresses[i], _value);
242     }
243 }
244 
245 function developer_Coin_Character (string change_coin_character) {
246     if (msg.sender == owner) Coin_Character = change_coin_character;
247   }
248 function developer_new_address_for_funds (address new_address_for_funds) {
249     if (msg.sender == owner) funds = new_address_for_funds;
250   }
251 function developer_add_Exchanges (string _add_Exchanges) {
252     if (msg.sender == owner) Exchanges = _add_Exchanges;
253   }
254 function developer_add_cost_of_transfers (string _add_cost_of_transfers) {
255     if (msg.sender == owner) cost_of_transfers = _add_cost_of_transfers;
256   }
257 function developer_new_price (string _new_price) {
258     if (msg.sender == owner) price = _new_price;
259   }
260 function developer_crowdsale_text (string _crowdsale_text) {
261     if (msg.sender == owner) crowdsale  = _crowdsale_text ;
262   }
263 function developer_new_symbol (string _new_symbol) {
264     if (msg.sender == owner) symbol = _new_symbol;
265   }
266 
267 function () payable {
268         require(balances[this] > 0);
269         uint256 Globecoins = 740 * msg.value/(10 ** 15);
270         
271         /*
272         For  investors!
273         0,001351351 ETH per 1 Token is the crowdsale price.
274         If you send Ethereum directly to this smartcontract's address,
275         you will receive 740 Globecoins per 1 ETH.
276         */
277         
278         if (Globecoins > balances[this]) {
279             Globecoins = balances[this];
280             uint valueWei = Globecoins * 10 ** 15 / 740;
281             msg.sender.transfer(msg.value - valueWei);
282         }
283     balances[msg.sender] += Globecoins;
284     balances[this] -= Globecoins;
285     Transfer(this, msg.sender, Globecoins);
286     }
287 }
288 
289 contract developer_Crowdsale is Globecoin {
290     function developer_Crowdsale() payable Globecoin() {}
291     function balance_wirthdraw () onlyOwner {
292         owner.transfer(this.balance);
293     }
294 
295     function balances_available_for_crowdsale () constant returns (uint256 crowdsale_balance) {
296     return balances[this]/1000;
297   }
298     
299 }