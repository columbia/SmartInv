1 pragma solidity ^0.4.11;
2 library SafeMath {
3   function mul(uint a, uint b) internal returns (uint) {
4     uint c = a * b;
5     assert(a == 0 || c / a == b);
6     return c;
7   }
8   function div(uint a, uint b) internal returns (uint) {
9     assert(b > 0);
10     uint c = a / b;
11     assert(a == b * c + a % b);
12     return c;
13   }
14   function sub(uint a, uint b) internal returns (uint) {
15     assert(b <= a);
16     return a - b;
17   }
18   function add(uint a, uint b) internal returns (uint) {
19     uint c = a + b;
20     assert(c >= a);
21     return c;
22   }
23   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
24     return a >= b ? a : b;
25   }
26   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
27     return a < b ? a : b;
28   }
29   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
30     return a >= b ? a : b;
31   }
32   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
33     return a < b ? a : b;
34   }
35   function assert(bool assertion) internal {
36     if (!assertion) {
37       throw;
38     }
39   }
40 }
41 contract Ownable {
42     address public owner;
43     function Ownable() {
44         owner = msg.sender;
45     }
46     modifier onlyOwner {
47         if (msg.sender != owner) throw;
48         _;
49     }
50     function transferOwnership(address newOwner) onlyOwner {
51         if (newOwner != address(0)) {
52             owner = newOwner;
53         }
54     }
55 }
56 /*
57  * Pausable
58  * Abstract contract that allows children to implement an
59  * emergency stop mechanism.
60  */
61 contract Pausable is Ownable {
62   bool public stopped;
63   modifier stopInEmergency {
64     if (stopped) {
65       throw;
66     }
67     _;
68   }
69   
70   modifier onlyInEmergency {
71     if (!stopped) {
72       throw;
73     }
74     _;
75   }
76   // called by the owner on emergency, triggers stopped state
77   function emergencyStop() external onlyOwner {
78     stopped = true;
79   }
80   // called by the owner on end of emergency, returns to normal state
81   function release() external onlyOwner onlyInEmergency {
82     stopped = false;
83   }
84 }
85 contract ERC20Basic {
86   uint public totalSupply;
87   function balanceOf(address who) constant returns (uint);
88   function transfer(address to, uint value);
89   event Transfer(address indexed from, address indexed to, uint value);
90 }
91 contract ERC20 is ERC20Basic {
92   function allowance(address owner, address spender) constant returns (uint);
93   function transferFrom(address from, address to, uint value);
94   function approve(address spender, uint value);
95   event Approval(address indexed owner, address indexed spender, uint value);
96 }
97 /*
98  * PullPayment
99  * Base contract supporting async send for pull payments.
100  * Inherit from this contract and use asyncSend instead of send.
101  */
102 contract PullPayment {
103   using SafeMath for uint;
104   
105   mapping(address => uint) public payments;
106   event LogRefundETH(address to, uint value);
107   /**
108   *  Store sent amount as credit to be pulled, called by payer 
109   **/
110   function asyncSend(address dest, uint amount) internal {
111     payments[dest] = payments[dest].add(amount);
112   }
113   // withdraw accumulated balance, called by payee
114   function withdrawPayments() {
115     address payee = msg.sender;
116     uint payment = payments[payee];
117     
118     if (payment == 0) {
119       throw;
120     }
121     if (this.balance < payment) {
122       throw;
123     }
124     payments[payee] = 0;
125     if (!payee.send(payment)) {
126       throw;
127     }
128     LogRefundETH(payee,payment);
129   }
130 }
131 contract BasicToken is ERC20Basic {
132   
133   using SafeMath for uint;
134   
135   mapping(address => uint) balances;
136   address[] public customerAddress;
137   
138   function size() public returns (uint) {
139     return customerAddress.length;
140   }
141   
142   /*
143    * Fix for the ERC20 short address attack  
144   */
145   modifier onlyPayloadSize(uint size) {
146      if(msg.data.length < size + 4) {
147        throw;
148      }
149      _;
150   }
151   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
152     if(balances[_to] == 0){
153         customerAddress.push(_to); 
154     }
155     balances[msg.sender] = balances[msg.sender].sub(_value);
156     balances[_to] = balances[_to].add(_value);
157     Transfer(msg.sender, _to, _value);
158   }
159   function balanceOf(address _owner) constant returns (uint balance) {
160     return balances[_owner];
161   }
162 }
163 contract StandardToken is BasicToken, ERC20 {
164   mapping (address => mapping (address => uint)) allowed;
165   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
166     if(balances[_to] == 0){
167         customerAddress.push(_to); 
168     }
169     var _allowance = allowed[_from][msg.sender];
170     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
171     // if (_value > _allowance) throw;
172     balances[_to] = balances[_to].add(_value);
173     balances[_from] = balances[_from].sub(_value);
174     allowed[_from][msg.sender] = _allowance.sub(_value);
175     Transfer(_from, _to, _value);
176   }
177   function approve(address _spender, uint _value) {
178     // To change the approve amount you first have to reduce the addresses`
179     //  allowance to zero by calling `approve(_spender, 0)` if it is not
180     //  already 0 to mitigate the race condition described here:
181     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
182     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
183     allowed[msg.sender][_spender] = _value;
184     Approval(msg.sender, _spender, _value);
185   }
186   function allowance(address _owner, address _spender) constant returns (uint remaining) {
187     return allowed[_owner][_spender];
188   }
189 }
190 /**
191  *  AntCoin token contract. Implements
192  */
193 contract AntCoin is StandardToken, Ownable {
194   string public constant name = "AntCoin";
195   string public constant symbol = "ANTC";
196   uint public constant decimals = 18;
197   
198   // Constructor
199   function AntCoin() {
200       totalSupply = 10000000000000000000000000000; // 10,000,000,000 coins in total 
201       balances[msg.sender] = totalSupply; // Send all tokens to owner
202   }
203   /**
204    *  Burn away the specified amount of Ant Coins
205    */
206   function burn(uint _value) onlyOwner returns (bool) {
207     balances[msg.sender] = balances[msg.sender].sub(_value);
208     totalSupply = totalSupply.sub(_value);
209     Transfer(msg.sender, 0x0, _value);
210     return true;
211   }
212 
213   function withdraw() onlyOwner payable {
214     owner.send(this.balance);
215   }
216 }