1 pragma solidity ^0.4.16;
2 
3  // ---------------------------------------------------------------------------------------------
4  // ERC Token Standard #20 Interface
5  // https://github.com/ethereum/EIPs/issues/20
6  // ---------------------------------------------------------------------------------------------
7   
8 /**
9  * @title owned
10  * @dev The owned contract has an owner address
11  */
12 contract owned {
13     address public owner;
14 
15     function owned() public {
16         owner = msg.sender;
17     }
18 
19     modifier onlyOwner {
20         require(msg.sender == owner);
21         _;
22     }
23 
24     function transferOwnership(address newOwner) onlyOwner public {
25         owner = newOwner;
26     }
27 }
28 
29 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
30 
31 /**
32  * @title SafeMath
33  * @dev Math operations with safety checks that throw on error
34  */
35 library SafeMath {
36   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
37     uint256 c = a * b;
38     assert(a == 0 || c / a == b);
39     return c;
40   }
41 
42   function div(uint256 a, uint256 b) internal constant returns (uint256) {
43     // assert(b > 0); // Solidity automatically throws when dividing by 0
44     uint256 c = a / b;
45     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46     return c;
47   }
48 
49   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
50     assert(b <= a);
51     return a - b;
52   }
53 
54   function add(uint256 a, uint256 b) internal constant returns (uint256) {
55     uint256 c = a + b;
56     assert(c >= a);
57     return c;
58   }
59 }
60 
61 /**
62  * @title Standard ERC20 token
63  *
64  * @dev Implementation of the basic standard token.
65  * @dev https://github.com/ethereum/EIPs/issues/20
66  */
67 
68 contract Rotharium is owned{
69     using SafeMath for uint256;
70 
71     // Public variables of the token
72     string public name;
73     string public symbol;
74     uint8 public decimals = 18;
75     uint256 public totalSupply;
76 
77     // This creates an array with all balances
78     mapping (address => uint256) public balanceOf;
79     mapping (address => mapping (address => uint256)) public allowance;
80 
81     // This generates a public event on the blockchain that will notify clients
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 
84     // This notifies clients about the amount burnt
85     event Burn(address indexed from, uint256 value);
86     
87     // This notifies clients about the approval
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89 
90 
91     /**
92      * Constrctor function
93      * Initializes contract with initial supply tokens to the creator of the contract
94      */
95     function Rotharium(
96         uint256 initialSupply,
97         string tokenName,
98         string tokenSymbol
99     ) public {
100         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
101         balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
102         name = tokenName;                                       // Set the name for display purposes
103         symbol = tokenSymbol;                                   // Set the symbol for display purposes
104     }
105 
106     /** 
107     * @dev Gets the balance of the specified address. 
108     * @param _owner The address to query the the balance of. 
109     * @return An uint256 representing the amount owned by the passed address. 
110     */ 
111     function balanceOf(address _owner) public constant returns (uint256 balance) { 
112         return balanceOf[_owner]; 
113     } 
114 
115     /**
116      * Internal transfer, only can be called by this contract
117      */
118     function _transfer(address _from, address _to, uint _value) internal {
119         // Prevent transfer to 0x0 address. Use burn() instead
120         require(_to != 0x0);
121         // Check if the sender has enough
122         require(balanceOf[_from] >= _value);
123         // Check for overflows
124         require(balanceOf[_to] + _value > balanceOf[_to]);
125         // Save this for an assertion in the future
126         uint previousBalances = balanceOf[_from] + balanceOf[_to];
127         // Subtract from the sender
128         balanceOf[_from] -= _value;
129         // Add the same to the recipient
130         balanceOf[_to] += _value;
131         Transfer(_from, _to, _value);
132         // Asserts are used to use static analysis to find bugs in your code. They should never fail
133         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
134     }
135 
136     /**
137      * Transfer tokens
138      *
139      * Send `_value` tokens to `_to` from your account
140      *
141      * @param _to The address of the recipient
142      * @param _value the amount to send
143      */
144     function transfer(address _to, uint256 _value) public {
145         _transfer(msg.sender, _to, _value);
146     }
147 
148     /**
149      * Transfer tokens from other address
150      *
151      * Send `_value` tokens to `_to` in behalf of `_from`
152      *
153      * @param _from The address of the sender
154      * @param _to The address of the recipient
155      * @param _value the amount to send
156      */
157     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
158         require(_value <= allowance[_from][msg.sender]);     // Check allowance
159         allowance[_from][msg.sender] -= _value;
160         _transfer(_from, _to, _value);
161         return true;
162     }
163 
164     /**
165      * Set allowance for other address
166      *
167      * Allows `_spender` to spend no more than `_value` tokens in your behalf
168      *
169      * @param _spender The address authorized to spend
170      * @param _value the max amount they can spend
171      */
172     function approve(address _spender, uint256 _value) public
173         returns (bool success) {
174         allowance[msg.sender][_spender] = _value;
175         return true;
176      }
177 
178     /**
179      * Set allowance for other address and notify
180      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
181      * @param _spender The address authorized to spend
182      * @param _value the max amount they can spend
183      * @param _extraData some extra information to send to the approved contract
184      */
185     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
186         public
187         returns (bool success) {
188         tokenRecipient spender = tokenRecipient(_spender);
189         if (approve(_spender, _value)) {
190             spender.receiveApproval(msg.sender, _value, this, _extraData);
191             return true;
192         }
193     }
194 
195     /**
196      * Burn tokens
197      * Remove `_value` tokens from the system
198      * @param _value the amount of money to burn
199      */
200     function burn(uint256 _value) public returns (bool success) {
201         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
202         balanceOf[msg.sender] -= _value;            // Subtract from the sender
203         totalSupply -= _value;                      // Updates totalSupply
204         Burn(msg.sender, _value);
205         return true;
206     }
207 
208    /** 
209     * @dev Function to check the amount of tokens that an owner allowed to a spender. 
210     * @param _owner address The address which owns the funds. 
211     * @param _spender address The address which will spend the funds. 
212     * @return A uint256 specifying the amount of tokens still available for the spender. 
213     */ 
214    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { 
215      return allowance[_owner][_spender];      
216    } 
217 }