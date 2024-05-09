1 pragma solidity ^0.4.2;
2 
3 library SafeMath {
4   function mul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9   function div(uint a, uint b) internal returns (uint) {
10     assert(b > 0);
11     uint c = a / b;
12     assert(a == b * c + a % b);
13     return c;
14   }
15   function sub(uint a, uint b) internal returns (uint) {
16     assert(b <= a);
17     return a - b;
18   }
19   function add(uint a, uint b) internal returns (uint) {
20     uint c = a + b;
21     assert(c >= a);
22     return c;
23   }
24   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
25     return a >= b ? a : b;
26   }
27   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
28     return a < b ? a : b;
29   }
30   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
31     return a >= b ? a : b;
32   }
33   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
34     return a < b ? a : b;
35   }
36 }
37 
38 contract ERC20Basic {
39   uint public totalSupply;
40   function balanceOf(address who) constant returns (uint);
41   function transfer(address to, uint value);
42   event Transfer(address indexed from, address indexed to, uint value);
43 }
44 
45 contract ERC20 is ERC20Basic {
46   function allowance(address owner, address spender) constant returns (uint);
47   function transferFrom(address from, address to, uint value);
48   function approve(address spender, uint value);
49   event Approval(address indexed owner, address indexed spender, uint value);
50 }
51 
52 contract BasicToken is ERC20Basic {
53   
54   using SafeMath for uint;
55   
56   mapping(address => uint) balances;
57   
58   /*
59    * Fix for the ERC20 short address attack  
60   */
61   modifier onlyPayloadSize(uint size) {
62      require(msg.data.length >= size + 4);
63      _;
64   }
65 
66   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
67     balances[msg.sender] = balances[msg.sender].sub(_value);
68     balances[_to] = balances[_to].add(_value);
69     Transfer(msg.sender, _to, _value);
70   }
71 
72   function balanceOf(address _owner) constant returns (uint balance) {
73     return balances[_owner];
74   }
75 }
76 
77 contract StandardToken is BasicToken, ERC20 {
78   mapping (address => mapping (address => uint)) allowed;
79 
80   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
81     var _allowance = allowed[_from][msg.sender];
82     // Check is not needed because sub(_allowance, _value) will already revert() if this condition is not met
83     // if (_value > _allowance) revert();
84     balances[_to] = balances[_to].add(_value);
85     balances[_from] = balances[_from].sub(_value);
86     allowed[_from][msg.sender] = _allowance.sub(_value);
87     Transfer(_from, _to, _value);
88   }
89 
90   function approve(address _spender, uint _value) {
91     // To change the approve amount you first have to reduce the addresses`
92     //  allowance to zero by calling `approve(_spender, 0)` if it is not
93     //  already 0 to mitigate the race condition described here:
94     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
95     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
96     allowed[msg.sender][_spender] = _value;
97     Approval(msg.sender, _spender, _value);
98   }
99 
100   function allowance(address _owner, address _spender) constant returns (uint remaining) {
101     return allowed[_owner][_spender];
102   }
103 }
104 
105 contract PullPayment {
106 
107   using SafeMath for uint;
108   
109   mapping(address => uint) public payments;
110 
111   event LogRefundETH(address to, uint value);
112 
113 
114   /**
115   *  Store sent amount as credit to be pulled, called by payer 
116   **/
117   function asyncSend(address dest, uint amount) internal {
118     payments[dest] = payments[dest].add(amount);
119   }
120 
121   // withdraw accumulated balance, called by payee
122   function withdrawPayments() {
123     address payee = msg.sender;
124     uint payment = payments[payee];
125     
126     require (payment > 0);
127     require (this.balance >= payment);
128 
129     payments[payee] = 0;
130 
131     require (payee.send(payment));
132     
133     LogRefundETH(payee,payment);
134   }
135 }
136 
137 contract Ownable {
138     address public owner;
139 
140     function Ownable() {
141         owner = msg.sender;
142     }
143 
144     modifier onlyOwner {
145         require (msg.sender == owner);
146         _;
147     }
148 
149     function transferOwnership(address newOwner) onlyOwner {
150         if (newOwner != address(0)) {
151             owner = newOwner;
152         }
153     }
154 }
155 
156 contract Pausable is Ownable {
157   bool public stopped;
158 
159   modifier stopInEmergency {
160     require(!stopped);
161     _;
162   }
163   
164   modifier onlyInEmergency {
165     require(stopped);
166     _;
167   }
168 
169   // called by the owner on emergency, triggers stopped state
170   function emergencyStop() external onlyOwner {
171     stopped = true;
172   }
173 
174   // called by the owner on end of emergency, returns to normal state
175   function release() external onlyOwner onlyInEmergency {
176     stopped = false;
177   }
178 
179 }
180 
181 /**
182  *  UmbrellaCoin token contract.
183  */
184 contract UmbrellaCoin is StandardToken, Ownable {
185   string public constant name = "UmbrellaCoin";
186   string public constant symbol = "UMC";
187   uint public constant decimals = 6;
188   address public floatHolder;
189 
190   // Constructor
191   function UmbrellaCoin() {
192       totalSupply = 100000000000000;
193       balances[msg.sender] = totalSupply; // Send all tokens to owner
194       floatHolder = msg.sender;
195   }
196 
197 }
198 
199 
200 contract Crowdsale is Ownable{
201     using SafeMath for uint;
202 
203     address public beneficiary;
204     uint public amountRaised; uint public price;
205     UmbrellaCoin public tokenReward;
206 
207     /* data structure to hold information about campaign contributors */
208 
209     /*  at initialization, setup the owner */
210     function Crowdsale() {
211         beneficiary = 0x6c7a8975e67dBb9c0C9664410862C91A01401fE7;
212         price = 1666 szabo;
213         tokenReward = UmbrellaCoin(0x190fB342aa6a15eB82903323ae78066fF8616746);
214     }
215 
216     /* The function without name is the default function that is called whenever anyone sends funds to a contract */
217     function () payable {
218         if (msg.value < 1000 finney || msg.value > 3000 ether) revert();
219         uint amount = msg.value;
220         amountRaised += amount;
221         uint payout = bonus(amount.div(price).mul(1000000));
222         beneficiary.transfer(msg.value);
223         tokenReward.transfer(msg.sender, payout);
224     }
225 
226         /*
227      *Compute the UmbrellaCoin bonus according to the investment period
228      */
229     function bonus(uint amount) internal constant returns (uint) {
230     if (350 ether <= amountRaised) {
231         return amount.mul(4);   // bonus 400%
232     } else if (351 ether >= amountRaised && 1000 ether <= amountRaised) {
233         return amount.mul(3);   // bonus 300%
234     } else if (1001 ether >= amountRaised && 1950 ether <= amountRaised) {
235         return amount.mul(2);   // bonus 200%
236     } else if (1951 ether >= amountRaised && 4000 ether <= amountRaised) {
237         return (amount.mul(15))/10;   // bonus 150%
238     }
239     return amount;
240     }
241 
242         /**
243      * Transfer remains to owner in case if impossible to do min invest
244      */
245     function sendCoinsToBeneficiary() onlyOwner public {
246         tokenReward.transfer(beneficiary, tokenReward.balanceOf(this));
247     }
248 }