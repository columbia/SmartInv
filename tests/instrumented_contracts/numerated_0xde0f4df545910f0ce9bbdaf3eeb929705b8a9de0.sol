1 pragma solidity ^0.4.16;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 contract SafeMath {
8     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal constant returns (uint256) {
15         assert(b != 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal constant returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 
32     function mulByFraction(uint256 number, uint256 numerator, uint256 denominator) internal returns (uint256) {
33         return div(mul(number, numerator), denominator);
34     }
35 }
36 
37 contract Owned {
38 
39     address owner;
40 
41     function Owned() public {
42         owner = msg.sender;
43     }
44 
45     modifier onlyOwner {
46         require(msg.sender == owner);
47         _;
48     }
49 
50     function transferOwnership(address newOwner) onlyOwner public {
51         require(newOwner != 0x0);
52         owner = newOwner;
53     }
54 }
55 
56 
57 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
58 
59 contract TokenERC20 is SafeMath {
60     // Public variables of the token
61     string public name;
62     string public symbol;
63     uint8 public decimals = 0;   // 18 decimals is the strongly suggested default, avoid changing it
64     uint256 public totalSupply;
65 
66 
67     
68 
69     // This creates an array with all balances
70     mapping (address => uint256) private addressBalance;
71     mapping (address => mapping (address => uint256)) public allowance;
72 
73     // This generates a public event on the blockchain that will notify clients
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     // This notifies clients about the amount burnt
77     event Burn(address indexed from, uint256 value);
78 
79 
80   /**
81    * Get number of tokens currently belonging to given owner.
82    *
83    * @param _owner address to get number of tokens currently belonging to the
84    *        owner of
85    * @return number of tokens currently belonging to the owner of given address
86    */
87   function balanceOf (address _owner) constant returns (uint256 balance) {
88     return addressBalance[_owner];
89   }
90 
91 
92     /**
93      * Constructor function
94      *
95      * Initializes contract with initial supply tokens to the creator of the contract
96      */
97     function TokenERC20(
98         uint256 initialSupply,
99         string tokenName,
100         string tokenSymbol) public {
101         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
102         addressBalance[msg.sender] = totalSupply;                // Give the creator all initial tokens
103         name = tokenName;                                   // Set the name for display purposes
104         symbol = tokenSymbol;                               // Set the symbol for display purposes
105         }
106 
107     /**
108      * Internal transfer, only can be called by this contract
109      */
110     function _transfer(address _from, address _to, uint256 _value) internal {
111         // Prevent transfer to 0x0 address. Use burn() instead
112         require(_to != 0x0);
113         // Check if the sender has enough
114         require(addressBalance[_from] >= _value);
115         // Check for overflows
116         require(addressBalance[_to] + _value > addressBalance[_to]);
117         // Subtract from the sender
118         addressBalance[_from] -= _value;
119         // Add the same to the recipient
120         addressBalance[_to] += _value;
121         Transfer(_from, _to, _value);
122 
123     }
124 
125     /**
126      * Transfer tokens
127      *
128      * Send `_value` tokens to `_to` from your account
129      *
130      * @param _to The address of the recipient
131      * @param _value the amount to send
132      */
133     function transfer(address _to, uint256 _value) public {
134         _transfer(msg.sender, _to, _value);
135     }
136 
137     /**
138      * Transfer tokens from other address
139      *
140      * Send `_value` tokens to `_to` in behalf of `_from`
141      *
142      * @param _from The address of the sender
143      * @param _to The address of the recipient
144      * @param _value the amount to send
145      */
146     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
147         require(_value <= allowance[_from][msg.sender]);     // Check allowance
148         allowance[_from][msg.sender] -= _value;
149         _transfer(_from, _to, _value);
150         return true;
151     }
152 
153     /**
154      * Set allowance for other address
155      *
156      * Allows `_spender` to spend no more than `_value` tokens in your behalf
157      *
158      * @param _spender The address authorized to spend
159      * @param _value the max amount they can spend
160      */
161     function approve(address _spender, uint256 _value) public
162         returns (bool success) 
163         {
164         allowance[msg.sender][_spender] = _value;
165         return true;
166     }
167 
168     /**
169      * Set allowance for other address and notify
170      *
171      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
172      *
173      * @param _spender The address authorized to spend
174      * @param _value the max amount they can spend
175      * @param _extraData some extra information to send to the approved contract
176      */
177     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
178         public
179         returns (bool success) 
180         {
181         tokenRecipient spender = tokenRecipient(_spender);
182         if (approve(_spender, _value)) {
183             spender.receiveApproval(msg.sender, _value, this, _extraData);
184             return true;
185         }
186     }
187 
188 }
189 
190 
191 /******************************************/
192 /*       GENE PROMO TOKEN STARTS HERE       */
193 /******************************************/
194 contract PARKGENEPromoToken is Owned,TokenERC20 {
195 
196 /**
197 * Airdrop tokens to requested addresses
198 * @param _addresses addresses of the owners to be notified
199 * @param _amount The amount of tokens to be transfered 
200  */
201     function airDrop(address[] _addresses,uint256 _amount) public {
202         for (uint i = 0; i < _addresses.length; i++) {
203             _transfer(msg.sender,_addresses[i],_amount);
204         }
205     }
206 
207 
208     function PARKGENEPromoToken() TokenERC20(1000000000, "PARKGENE Promo Token", "GENEP") public {
209         }
210 
211   /**
212    * Kill this smart contract.
213    */
214   function kill() onlyOwner public {
215     selfdestruct (owner);
216   }
217 
218 
219 }