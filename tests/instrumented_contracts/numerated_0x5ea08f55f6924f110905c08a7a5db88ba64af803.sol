1 pragma solidity ^0.4.23;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
8     if (a == 0) {
9       return 0;
10     }
11     uint256 c = a * b;
12     assert(c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal constant returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal constant returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 
36 contract owned {
37     address public owner;
38     
39     constructor () public {
40       owner = msg.sender;
41     }
42 
43     modifier onlyOwner {
44         require(msg.sender == owner);
45         _;
46     }
47 
48     function transferOwnership(address newOwner) onlyOwner public {
49         require(newOwner != 0x0);
50         require(newOwner != owner);
51         owner = newOwner;
52     }
53     
54    
55 }
56 
57 
58 contract TokenERC20 {
59     
60     using SafeMath for uint256;
61     
62     // Public variables of the token
63     string public name;
64     string public symbol;
65     uint8 public decimals;
66     uint256 public totalSupply;
67 
68     // This creates an array with all balances
69     mapping (address => uint256) public balanceOf;
70     mapping (address => mapping (address => uint256)) public allowance;
71 
72     // This generates a public event on the blockchain that will notify clients
73     event Transfer(address indexed from, address indexed to, uint256 value);
74 
75 
76     /**
77      * Constrctor function
78      *
79      * Initializes contract with initial supply tokens to the creator of the contract
80      */
81     constructor () public {}
82 
83     /**
84      * Internal transfer, only can be called by this contract
85      */
86     function _transfer(address _from, address _to, uint _value) internal {
87         // Prevent transfer to 0x0 address. Use burn() instead
88         require(_to != 0x0);
89         // Check if the sender has enough
90         require(balanceOf[_from] >= _value);
91         // Check for overflows
92         require(balanceOf[_to].add(_value) > balanceOf[_to]);
93         // Save this for an assertion in the future
94         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
95         // Subtract from the sender
96         balanceOf[_from] = balanceOf[_from].sub(_value);
97         // Add the same to the recipient
98         balanceOf[_to] = balanceOf[_to].add(_value);
99         emit Transfer(_from, _to, _value);
100         // Asserts are used to use static analysis to find bugs in your code. They should never fail
101         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
102     }
103 
104     /**
105      * Transfer tokens
106      *
107      * Send `_value` tokens to `_to` from your account
108      *
109      * @param _to The address of the recipient
110      * @param _value the amount to send
111      */
112     function transfer(address _to, uint256 _value) public {
113         _transfer(msg.sender, _to, _value);
114     }
115 
116     /**
117      * Transfer tokens from other address
118      *
119      * Send `_value` tokens to `_to` in behalf of `_from`
120      *
121      * @param _from The address of the sender
122      * @param _to The address of the recipient
123      * @param _value the amount to send
124      */
125     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
126         require(_value <= allowance[_from][msg.sender]);     // Check allowanc
127         allowance[_from][msg.sender] =allowance[_from][msg.sender].sub(_value);
128         _transfer(_from, _to, _value);
129         return true;
130     }
131 
132     /**
133      * Set allowance for other address
134      *
135      * Allows `_spender` to spend no more than `_value` tokens in your behalf
136      *
137      * @param _spender The address authorized to spend
138      * @param _value the max amount they can spend
139      */
140     function approve(address _spender, uint256 _value) public
141         returns (bool success) {
142         require(_spender != 0x0);    
143         allowance[msg.sender][_spender] = _value;
144         return true;
145     }
146 
147    
148 }
149 
150 /******************************************/
151 /*       INV TOKEN STARTS HERE       */
152 /******************************************/
153 
154 contract INVToken is owned,TokenERC20 {
155 
156     string public name = "INVESTACOIN";
157     string public symbol = "INV";
158     uint8 public decimals = 18;
159     address private paymentAddress = 0x75B42A1AB0e23e24284c8E0E8B724472CF8623Cd;
160     
161     
162     uint256 public buyPrice;
163     uint256 public totalSupply = 50000000e18;  
164     
165     
166     mapping (address => bool) public frozenAccount;
167 
168     /* This generates a public event on the blockchain that will notify clients */
169     event FrozenFunds(address target, bool frozen);
170 
171     /* Initializes contract with initial supply tokens to the creator of the contract */
172    constructor () public owned() TokenERC20()  {
173         balanceOf[msg.sender] = totalSupply;
174         
175     }
176     
177     
178     function () payable {
179         buy();
180     }
181     
182     /**
183    * Transfer given number of tokens from given owner to given recipient.
184    *
185    * @param _from address to transfer tokens from the owner of
186    * @param _to address to transfer tokens to the owner of
187    * @param _value number of tokens to transfer from given owner to given
188    *        recipient
189    * @return true if tokens were transferred successfully, false otherwise
190    */
191   function transferFrom(address _from, address _to, uint256 _value)
192     returns (bool success) {
193 	require(!frozenAccount[_from]);
194     return TokenERC20.transferFrom(_from, _to, _value);
195   }
196   
197   /**
198    * Transfer given number of tokens from message sender to given recipient.
199    * @param _to address to transfer tokens to the owner of
200    * @param _value number of tokens to transfer to the owner of given address
201    * @return true if tokens were transferred successfully, false otherwise
202    */
203   function transfer(address _to, uint256 _value) public {
204     require(!frozenAccount[msg.sender]);
205     return TokenERC20.transfer(_to, _value);
206   }
207 
208 
209     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
210     /// @param target Address to be frozen
211     /// @param freeze either to freeze it or not
212     
213     function freezeAccount(address target, bool freeze) onlyOwner public {
214         frozenAccount[target] = freeze;
215         emit FrozenFunds(target, freeze);
216     }
217 
218     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
219     /// @param newBuyPrice Price users can buy from the contract
220     function setbuyPrice( uint256 newBuyPrice) onlyOwner public {
221         require(newBuyPrice > 0);
222         buyPrice = newBuyPrice;
223     }
224     
225     function transferPaymentAddress(address newPaymentAddress) onlyOwner public {
226         require(newPaymentAddress != 0x0);
227         require(newPaymentAddress != paymentAddress);
228         paymentAddress = newPaymentAddress;
229     }
230     
231 	
232     /// @notice Buy tokens from contract by sending ether
233     function buy() payable public {
234         require(msg.value > 0);
235         require(buyPrice > 0);
236         paymentAddress.transfer(msg.value);     // withdraw the ether to payment address
237      
238     }
239 
240 
241 }