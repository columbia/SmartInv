1 pragma solidity 0.5.0; /*
2 
3 ___________________________________________________________________
4   _      _                                        ______           
5   |  |  /          /                                /              
6 --|-/|-/-----__---/----__----__---_--_----__-------/-------__------
7   |/ |/    /___) /   /   ' /   ) / /  ) /___)     /      /   )     
8 __/__|____(___ _/___(___ _(___/_/_/__/_(___ _____/______(___/__o_o_
9 
10                                                            
11                                                            
12 DDDDDDDDDDDDD                            AAA               
13 D::::::::::::DDD                        A:::A              
14 D:::::::::::::::DD                     A:::::A             
15 DDD:::::DDDDD:::::D                   A:::::::A            
16   D:::::D    D:::::D                 A:::::::::A           
17   D:::::D     D:::::D               A:::::A:::::A          
18   D:::::D     D:::::D              A:::::A A:::::A         
19   D:::::D     D:::::D             A:::::A   A:::::A        
20   D:::::D     D:::::D            A:::::A     A:::::A       
21   D:::::D     D:::::D           A:::::AAAAAAAAA:::::A      
22   D:::::D     D:::::D          A:::::::::::::::::::::A     
23   D:::::D    D:::::D          A:::::AAAAAAAAAAAAA:::::A    
24 DDD:::::DDDDD:::::D          A:::::A             A:::::A   
25 D:::::::::::::::DD          A:::::A               A:::::A  
26 D::::::::::::DDD           A:::::A                 A:::::A 
27 DDDDDDDDDDDDD             AAAAAAA                   AAAAAAA
28                                                            
29                                                            
30                                                            
31 // ----------------------------------------------------------------------------
32 // 'Deposit Asset' Token contract with following functionalities:
33 //      => Higher control of owner
34 //      => SafeMath implementation 
35 //
36 // Name             : Deposit Asset
37 // Symbol           : DA
38 // Decimals         : 15
39 //
40 // Copyright (c) 2018 FIRST DECENTRALIZED DEPOSIT PLATFORM ( https://fddp.io )
41 // Contract designed by: EtherAuthority ( https://EtherAuthority.io ) 
42 // ----------------------------------------------------------------------------
43 */ 
44 
45 
46 /**
47  * @title ERC20Basic
48  * @dev Simpler version of ERC20 interface
49  * @dev see https://github.com/ethereum/EIPs/issues/179
50  */
51 contract ERC20Basic {
52   function balanceOf(address who) public view returns (uint256);
53   function transfer(address to, uint256 value) public returns (bool);
54   event Transfer(address indexed from, address indexed to, uint256 value);
55 }
56 /**
57  * @title ERC20 interface
58  * @dev see https://github.com/ethereum/EIPs/issues/20
59  */
60 contract ERC20 is ERC20Basic {
61   function allowance(address owner, address spender) public view returns (uint256);
62   function transferFrom(address from, address to, uint256 value) public returns (bool);
63   function approve(address spender, uint256 value) public returns (bool);
64   event Approval(address indexed owner, address indexed spender, uint256 value);
65 }
66 /**
67  * @title Basic token
68  * @dev Basic version of StandardToken, with no allowances. 
69  */
70 contract BasicToken is ERC20Basic {
71     
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) internal balances;  
75   mapping(address => uint256) public holdersWithdrows;
76   
77   /**
78   * @dev transfer token for a specified address
79   * @param _to The address to transfer to.
80   * @param _value The amount to be transferred.
81   */
82   function transfer(address _to, uint256 _value) public returns (bool) {
83     uint256 _buffer = holdersWithdrows[msg.sender].mul(_value).div(balances[msg.sender]);
84     holdersWithdrows[_to] += _buffer;
85     holdersWithdrows[msg.sender] -= _buffer;
86     
87     balances[msg.sender] = balances[msg.sender].sub(_value);
88     balances[_to] = balances[_to].add(_value);
89 
90     emit Transfer(msg.sender, _to, _value);
91     return true;
92   }
93   /**
94   * @dev Gets the balance of the specified address.
95   * @param _owner The address to query the the balance of. 
96   * @return An uint256 representing the amount owned by the passed address.
97   */
98   function balanceOf(address _owner) public view returns (uint256 balance) {
99     return balances[_owner];
100   }
101 
102 }
103 /**
104  * @title Standard ERC20 token
105  *
106  * @dev Implementation of the basic standard token.
107  * @dev https://github.com/ethereum/EIPs/issues/20
108  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
109  */
110 contract StandardToken is ERC20, BasicToken {
111 
112   mapping (address => mapping (address => uint256)) internal allowed;
113 
114   /**
115    * @dev Transfer tokens from one address to another
116    * @param _from address The address which you want to send tokens from
117    * @param _to address The address which you want to transfer to
118    * @param _value uint256 the amout of tokens to be transfered
119    */
120    
121   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
122     uint256 _allowance = allowed[_from][msg.sender];
123 
124     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
125     // require (_value <= _allowance);
126     require(_value != 0);
127     uint256 _buffer = holdersWithdrows[msg.sender].mul(_value).div(balances[msg.sender]);
128     holdersWithdrows[_to] += _buffer;
129     holdersWithdrows[msg.sender] -= _buffer;
130 
131     balances[_to] = balances[_to].add(_value);
132     balances[_from] = balances[_from].sub(_value);
133     allowed[_from][msg.sender] = _allowance.sub(_value);
134     emit Transfer(_from, _to, _value);
135     return true;
136   }
137 
138   /**
139    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
140    * @param _spender The address which will spend the funds.
141    * @param _value The amount of tokens to be spent.
142    */
143   function approve(address _spender, uint256 _value) public returns (bool) {
144 
145     // To change the approve amount you first have to reduce the addresses`
146     //  allowance to zero by calling `approve(_spender, 0)` if it is not
147     //  already 0 to mitigate the race condition described here:
148     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
149     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
150 
151     allowed[msg.sender][_spender] = _value;
152     emit Approval(msg.sender, _spender, _value);
153     return true;
154   }
155 
156   /**
157    * @dev Function to check the amount of tokens that an owner allowed to a spender.
158    * @param _owner address The address which owns the funds.
159    * @param _spender address The address which will spend the funds.
160    * @return A uint256 specifing the amount of tokens still available for the spender.
161    */
162   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
163     return allowed[_owner][_spender];
164   }
165 
166 }
167 
168 /**
169  * @title SafeMath
170  * @dev Math operations with safety checks that throw on error
171  */
172 library SafeMath {
173     
174   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
175     uint256 c = a * b;
176     assert(a == 0 || c / a == b);
177     return c;
178   }
179 
180   function div(uint256 a, uint256 b) internal pure returns (uint256) {
181     // assert(b > 0); // Solidity automatically throws when dividing by 0
182     uint256 c = a / b;
183     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
184     return c;
185   }
186 
187   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
188     assert(b <= a);
189     return a - b;
190   }
191 
192   function add(uint256 a, uint256 b) internal pure returns (uint256) {
193     uint256 c = a + b;
194     assert(c >= a);
195     return c;
196   }
197   
198 }
199 /**
200  * TheStocksTokens
201  * 
202  */
203 contract DepositAsset is StandardToken {
204     
205     using SafeMath for uint256;
206     
207     string public constant name = "Deposit Asset";
208   
209     string public constant symbol = "DA";
210   
211     uint32 public constant decimals = 6;
212 
213     uint256 private _totalSupply = 200000000000000; // stocks
214     
215     uint public _totalWithdrow  = 0;
216     
217     uint public total_withdrows  = 0;
218     
219     constructor () public {
220         balances[msg.sender] = _totalSupply;
221         emit Transfer(address(0x0), msg.sender, _totalSupply);
222     }
223 
224 	function totalSupply() public view returns(uint256 total) {
225         return _totalSupply;
226     }
227     
228     // get any ethers to contract
229     function () external payable {
230         if (msg.value == 1 wei) {
231             require(balances[msg.sender] > 0);
232         
233             uint256 _totalDevidends = devidendsOf(msg.sender);
234             holdersWithdrows[msg.sender] += _totalDevidends;
235             _totalWithdrow += _totalDevidends;
236             
237             msg.sender.transfer(_totalDevidends);
238         }
239     }
240     
241     /* TEST / function holdersWithdrowsOf(address _owner) public constant returns(uint256 hw) {
242         return holdersWithdrows[_owner];
243     }//*/
244     function getDevidends() public returns (bool success){
245         require(balances[msg.sender] > 0);
246         
247         uint256 _totalDevidends = devidendsOf(msg.sender);
248         holdersWithdrows[msg.sender] += _totalDevidends;
249         _totalWithdrow += _totalDevidends;
250         
251         msg.sender.transfer(_totalDevidends);
252         
253         return true;
254     }
255     function devidendsOf(address _owner) public view returns (uint256 devidends) {
256         address self = address(this);
257         // определить сумму всех начисленых средств, определить долю и отминусовать ранее снятые дивиденды
258         return self.balance
259             .add(_totalWithdrow)
260             .mul(balances[_owner])
261             .div(_totalSupply)
262             .sub(holdersWithdrows[_owner]);
263     }
264    
265     function fund() public payable returns(bool success) {
266         success = true;
267     }
268 }