1 //////////////////////////////////////////////////////////////////////////////////////////
2 //											//
3 //	Title: 						JiJieHao Creation Contract	//
4 //	Author: 					Owen Pang                       //
5 //	Version: 					v1.0				//
6 //	Date of current version:	2018/08/24					//
7 //                                                                                      //
8 //////////////////////////////////////////////////////////////////////////////////////////
9 
10 pragma solidity ^0.4.18;
11 
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
29 library SafeMath {
30    function mul(uint a, uint b) internal pure returns (uint) {
31      if (a == 0) {
32         return 0;
33       }
34 
35       uint c = a * b;
36       assert(c / a == b);
37       return c;
38    }
39 
40    function sub(uint a, uint b) internal pure returns (uint) {
41       assert(b <= a);
42       return a - b;
43    }
44 
45    function add(uint a, uint b) internal pure returns (uint) {
46       uint c = a + b;
47       assert(c >= a);
48       return c;
49    }
50 
51   function div(uint a, uint b) internal pure returns (uint256) {
52     assert(b > 0); // Solidity automatically throws when dividing by 0
53     uint c = a / b;
54     assert(a == b * c + a % b); // There is no case in which this doesn't hold
55     return c;
56   }
57 }
58 
59 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
60 
61 contract TokenERC20 {
62     using SafeMath for uint256;
63     // Public variables of the token
64     string public name;
65     string public symbol;
66     uint8 public decimals;
67     // 18 decimals is the strongly suggested default, avoid changing it
68     uint256 public totalSupply;
69 
70     string public version = 'J1.0';
71 
72     // This creates an array with all balances
73     mapping (address => uint256) public balanceOf;
74     mapping (address => mapping (address => uint256)) public allowance;
75 
76     // This generates a public event on the blockchain that will notify clients
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     // This notifies clients about the amount burnt
80     event Burn(address indexed from, uint256 value);
81 
82     /**
83      * Constrctor function
84      *
85      * Initializes contract with initial supply tokens to the creator of the contract
86      */
87     function TokenERC20(
88         uint256 initialSupply,
89 	uint8 _decimalUnits,
90         string tokenName,
91         string tokenSymbol
92     ) public {
93         totalSupply = initialSupply;  // Update total supply with the decimal amount
94         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
95 	decimals = _decimalUnits;                            // Amount of decimals for display purposes
96         name = tokenName;                                   // Set the name for display purposes
97         symbol = tokenSymbol;                               // Set the symbol for display purposes
98     }
99 
100     /**
101      * Internal transfer, only can be called by this contract
102      */
103     function _transfer(address _from, address _to, uint _value) internal {
104         // Prevent transfer to 0x0 address. Use burn() instead
105         require(_to != 0x0);
106         // Check if the sender has enough
107         require(balanceOf[_from] >= _value);
108         // Check for overflows
109         require(balanceOf[_to].add(_value) > balanceOf[_to]);
110         // Save this for an assertion in the future
111         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
112         // Subtract from the sender
113         balanceOf[_from] = balanceOf[_from].sub(_value);
114         // Add the same to the recipient
115         balanceOf[_to] =balanceOf[_to].add(_value);
116         Transfer(_from, _to, _value);
117         // Asserts are used to use static analysis to find bugs in your code. They should never fail
118         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
119     }
120 
121     /**
122      * Transfer tokens
123      *
124      * Send `_value` tokens to `_to` from your account
125      *
126      * @param _to The address of the recipient
127      * @param _value the amount to send
128      */
129     function transfer(address _to, uint256 _value) public {
130         _transfer(msg.sender, _to, _value);
131     }
132 
133     /**
134      * Transfer tokens from other address
135      *
136      * Send `_value` tokens to `_to` in behalf of `_from`
137      *
138      * @param _from The address of the sender
139      * @param _to The address of the recipient
140      * @param _value the amount to send
141      */
142     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
143         require(_value <= allowance[_from][msg.sender]);     // Check allowance
144         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
145         _transfer(_from, _to, _value);
146         return true;
147     }
148 
149     /**
150      * Set allowance for other address
151      *
152      * Allows `_spender` to spend no more than `_value` tokens in your behalf
153      *
154      * @param _spender The address authorized to spend
155      * @param _value the max amount they can spend
156      */
157     function approve(address _spender, uint256 _value) public
158         returns (bool success) {
159         allowance[msg.sender][_spender] = _value;
160         return true;
161     }
162 
163     /**
164      * Set allowance for other address and notify
165      *
166      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
167      *
168      * @param _spender The address authorized to spend
169      * @param _value the max amount they can spend
170      * @param _extraData some extra information to send to the approved contract
171      */
172     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
173         public
174         returns (bool success) {
175         tokenRecipient spender = tokenRecipient(_spender);
176         if (approve(_spender, _value)) {
177             spender.receiveApproval(msg.sender, _value, this, _extraData);
178             return true;
179         }
180     }
181 
182     /**
183      * Destroy tokens
184      *
185      * Remove `_value` tokens from the system irreversibly
186      *
187      * @param _value the amount of money to burn
188      */
189     function burn(uint256 _value) public returns (bool success) {
190         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
191         balanceOf[msg.sender] -= _value;            // Subtract from the sender
192         totalSupply -= _value;                      // Updates totalSupply
193         Burn(msg.sender, _value);
194         return true;
195     }
196 
197     /**
198      * Destroy tokens from other account
199      *
200      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
201      *
202      * @param _from the address of the sender
203      * @param _value the amount of money to burn
204      */
205     function burnFrom(address _from, uint256 _value) public returns (bool success) {
206         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
207         require(_value <= allowance[_from][msg.sender]);    // Check allowance
208         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
209         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
210         totalSupply -= _value;                              // Update totalSupply
211         Burn(_from, _value);
212         return true;
213     }
214 }
215 
216 
217 
218 contract JiJieHao is owned, TokenERC20 {
219     using SafeMath for uint256;
220 
221     mapping (address => bool) public frozenAccount;
222 
223     /* This generates a public event on the blockchain that will notify clients */
224     event FrozenFunds(address target, bool frozen);
225 
226     /* Initializes contract with initial supply tokens to the creator of the contract */
227     function JiJieHao(
228 	uint256 initialSupply,
229 	uint8 decimalUnits,
230         string tokenName,
231         string tokenSymbol
232 
233     ) TokenERC20(initialSupply, decimalUnits,tokenName, tokenSymbol) public {}
234 
235     /* Internal transfer, only can be called by this contract */
236     function _transfer(address _from, address _to, uint _value) internal {
237         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
238         require (balanceOf[_from] >= _value);               // Check if the sender has enough
239         require (balanceOf[_to].add(_value) > balanceOf[_to]); // Check for overflows
240         require(!frozenAccount[_from]);                     // Check if sender is frozen
241         require(!frozenAccount[_to]);                       // Check if recipient is frozen
242         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the sender
243         balanceOf[_to] = balanceOf[_to].add(_value);                           // Add the same to the recipient
244         Transfer(_from, _to, _value);
245     }
246 
247     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
248     /// @param target Address to be frozen
249     /// @param freeze either to freeze it or not
250     function freezeAccount(address target, bool freeze) onlyOwner public {
251         frozenAccount[target] = freeze;
252         FrozenFunds(target, freeze);
253     }
254 
255 }