1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/20
7  */
8 contract ERC20Basic {
9   uint public totalSupply;
10   function balanceOf(address who) constant returns (uint);
11   function transfer(address to, uint value);
12   event Transfer(address indexed from, address indexed to, uint value);
13 }
14 
15 /**
16  * Math operations with safety checks
17  */
18 library SafeMath {
19   function mul(uint a, uint b) internal returns (uint) {
20     uint c = a * b;
21     assert(a == 0 || c / a == b);
22     return c;
23   }
24 
25   function div(uint a, uint b) internal returns (uint) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   function sub(uint a, uint b) internal returns (uint) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   function add(uint a, uint b) internal returns (uint) {
38     uint c = a + b;
39     assert(c >= a);
40     return c;
41   }
42 
43   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
44     return a >= b ? a : b;
45   }
46 
47   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
48     return a < b ? a : b;
49   }
50 
51   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
52     return a >= b ? a : b;
53   }
54 
55   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
56     return a < b ? a : b;
57   }
58 
59   function assert(bool assertion) internal {
60     if (!assertion) {
61       throw;
62     }
63   }
64 }
65 
66 /**
67  * @title Basic token
68  * @dev Basic version of StandardToken, with no allowances. 
69  */
70 contract BasicToken is ERC20Basic {
71   using SafeMath for uint;
72 
73   mapping(address => uint) balances;
74 
75   /**
76    * @dev Fix for the ERC20 short address attack.
77    */
78   modifier onlyPayloadSize(uint size) {
79      if(msg.data.length < size + 4) {
80        throw;
81      }
82      _;
83   }
84 
85   /**
86   * @dev transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
91     balances[msg.sender] = balances[msg.sender].sub(_value);
92     balances[_to] = balances[_to].add(_value);
93     Transfer(msg.sender, _to, _value);
94   }
95 
96   /**
97   * @dev Gets the balance of the specified address.
98   * @param _owner The address to query the the balance of. 
99   * @return An uint representing the amount owned by the passed address.
100   */
101   function balanceOf(address _owner) constant returns (uint balance) {
102     return balances[_owner];
103   }
104 
105 }
106 
107 /**
108  * @title ERC20 interface
109  * @dev see https://github.com/ethereum/EIPs/issues/20
110  */
111 contract ERC20 is ERC20Basic {
112   function allowance(address owner, address spender) constant returns (uint);
113   function transferFrom(address from, address to, uint value);
114   function approve(address spender, uint value);
115   event Approval(address indexed owner, address indexed spender, uint value);
116 }
117 
118 /**
119  * @title Standard ERC20 token
120  *
121  * @dev Implemantation of the basic standart token.
122  * @dev https://github.com/ethereum/EIPs/issues/20
123  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
124  */
125 contract StandardToken is BasicToken, ERC20 {
126 
127   mapping (address => mapping (address => uint)) allowed;
128 
129   /**
130    * @dev Transfer tokens from one address to another
131    * @param _from address The address which you want to send tokens from
132    * @param _to address The address which you want to transfer to
133    * @param _value uint the amout of tokens to be transfered
134    */
135   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
136     var _allowance = allowed[_from][msg.sender];
137 
138     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
139     // if (_value > _allowance) throw;
140 
141     balances[_to] = balances[_to].add(_value);
142     balances[_from] = balances[_from].sub(_value);
143     allowed[_from][msg.sender] = _allowance.sub(_value);
144     Transfer(_from, _to, _value);
145   }
146 
147   /**
148    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
149    * @param _spender The address which will spend the funds.
150    * @param _value The amount of tokens to be spent.
151    */
152   function approve(address _spender, uint _value) {
153 
154     // To change the approve amount you first have to reduce the addresses`
155     //  allowance to zero by calling `approve(_spender, 0)` if it is not
156     //  already 0 to mitigate the race condition described here:
157     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
159 
160     allowed[msg.sender][_spender] = _value;
161     Approval(msg.sender, _spender, _value);
162   }
163 
164   /**
165    * @dev Function to check the amount of tokens than an owner allowed to a spender.
166    * @param _owner address The address which owns the funds.
167    * @param _spender address The address which will spend the funds.
168    * @return A uint specifing the amount of tokens still avaible for the spender.
169    */
170   function allowance(address _owner, address _spender) constant returns (uint remaining) {
171     return allowed[_owner][_spender];
172   }
173 
174 }
175 
176 contract TokBros is StandardToken {
177 
178     function () {
179         //if ether is sent to this address, send it back.
180         throw;
181     }
182 
183     /* Public variables of the token */
184 
185     /*
186     NOTE:
187     The following variables are OPTIONAL vanities. One does not have to include them.
188     They allow one to customise the token contract & in no way influences the core functionality.
189     Some wallets/interfaces might not even bother to look at this information.
190     */
191     string public name;                   //fancy name: eg Simon Bucks
192     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
193     string public symbol;                 //An identifier: eg SBX
194     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
195 
196     function TokBros() {
197         totalSupply = 2000000000;
198         decimals = 18;
199         name = "TokBros";
200         symbol = "TKB";
201         balances[msg.sender] = totalSupply * 10 ** uint256(decimals);
202     }
203 
204     /* Approves and then calls the receiving contract */
205     // function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
206     //     allowed[msg.sender][_spender] = _value;
207     //     Approval(msg.sender, _spender, _value);
208 
209     //     //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
210     //     //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
211     //     //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
212     //     if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
213     //     return true;
214     // }
215 }