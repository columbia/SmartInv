1 pragma solidity ^0.4.18;
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
39     address public owner;
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
70     mapping (address => uint256) public balanceOf;
71     mapping (address => mapping (address => uint256)) public allowance;
72 
73     // This generates a public event on the blockchain that will notify clients
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     // This notifies clients about the amount burnt
77     event Burn(address indexed from, uint256 value);
78 
79     /**
80      * Constructor function
81      *
82      * Initializes contract with initial supply tokens to the creator of the contract
83      */
84     function TokenERC20(
85         uint256 initialSupply,
86         string tokenName,
87         string tokenSymbol) public {
88         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
89         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
90         name = tokenName;                                   // Set the name for display purposes
91         symbol = tokenSymbol;                               // Set the symbol for display purposes
92         }
93 
94     /**
95      * Internal transfer, only can be called by this contract
96      */
97     function _transfer(address _from, address _to, uint256 _value) internal {
98         // Prevent transfer to 0x0 address. Use burn() instead
99         require(_to != 0x0);
100         // Check if the sender has enough
101         require(balanceOf[_from] >= _value);
102         // Check for overflows
103         require(balanceOf[_to] + _value > balanceOf[_to]);
104         // Save this for an assertion in the future
105         uint previousBalances = balanceOf[_from] + balanceOf[_to];
106         // Subtract from the sender
107         balanceOf[_from] -= _value;
108         // Add the same to the recipient
109         balanceOf[_to] += _value;
110         Transfer(_from, _to, _value);
111         // Asserts are used to use static analysis to find bugs in your code. They should never fail
112         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
113     }
114 
115     /**
116      * Transfer tokens
117      *
118      * Send `_value` tokens to `_to` from your account
119      *
120      * @param _to The address of the recipient
121      * @param _value the amount to send
122      */
123     function transfer(address _to, uint256 _value) public {
124         _transfer(msg.sender, _to, _value);
125     }
126 
127     /**
128      * Transfer tokens from other address
129      *
130      * Send `_value` tokens to `_to` in behalf of `_from`
131      *
132      * @param _from The address of the sender
133      * @param _to The address of the recipient
134      * @param _value the amount to send
135      */
136     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
137         require(_value <= allowance[_from][msg.sender]);     // Check allowance
138         allowance[_from][msg.sender] -= _value;
139         _transfer(_from, _to, _value);
140         return true;
141     }
142 
143     /**
144      * Set allowance for other address
145      *
146      * Allows `_spender` to spend no more than `_value` tokens in your behalf
147      *
148      * @param _spender The address authorized to spend
149      * @param _value the max amount they can spend
150      */
151     function approve(address _spender, uint256 _value) public
152         returns (bool success) 
153         {
154         allowance[msg.sender][_spender] = _value;
155         return true;
156     }
157 
158     /**
159      * Set allowance for other address and notify
160      *
161      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
162      *
163      * @param _spender The address authorized to spend
164      * @param _value the max amount they can spend
165      * @param _extraData some extra information to send to the approved contract
166      */
167     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
168         public
169         returns (bool success) 
170         {
171         tokenRecipient spender = tokenRecipient(_spender);
172         if (approve(_spender, _value)) {
173             spender.receiveApproval(msg.sender, _value, this, _extraData);
174             return true;
175         }
176     }
177 
178 }
179 
180 
181 /******************************************/
182 /*       GENE PROMO TOKEN STARTS HERE       */
183 /******************************************/
184 
185 contract GENEPromoToken is Owned,TokenERC20 {
186     function airDrop(address[] _addresses,uint256 _amount) public {
187         for (uint i = 0; i < _addresses.length; i++) {
188             _transfer(msg.sender,_addresses[i],_amount);
189         }
190     }
191 
192 
193     function GENEPromoToken() TokenERC20(1000000000000000, "GENE Promo Token", "GENEP") public {
194         }
195 
196   /**
197    * Kill this smart contract.
198    */
199   function kill() onlyOwner public {
200     selfdestruct (owner);
201   }
202 
203 
204 }