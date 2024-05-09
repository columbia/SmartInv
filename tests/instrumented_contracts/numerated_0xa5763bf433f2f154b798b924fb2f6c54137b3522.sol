1 //////////////////////////////////////////////////////////////////////////////////////////
2 //																						//
3 //	Title: 						ASC Creation Contract					        		//
4 //	Author: 					Hashcode                                                   //
5 //	Version: 					v1.0													//
6 //	Date of current version:	2019/01/01												//
7 //                                                                                      //
8 //////////////////////////////////////////////////////////////////////////////////////////
9 pragma solidity ^0.4.18;
10 
11 contract owned {
12     address public owner;
13 
14     function owned() public {
15         owner = msg.sender;
16     }
17 
18     modifier onlyOwner {
19         require(msg.sender == owner);
20         _;
21     }
22 
23     function transferOwnership(address newOwner) onlyOwner public {
24         owner = newOwner;
25     }
26 }
27 
28 library SafeMath {
29    function mul(uint a, uint b) internal pure returns (uint) {
30      if (a == 0) {
31         return 0;
32       }
33 
34       uint c = a * b;
35       assert(c / a == b);
36       return c;
37    }
38 
39    function sub(uint a, uint b) internal pure returns (uint) {
40       assert(b <= a);
41       return a - b;
42    }
43 
44    function add(uint a, uint b) internal pure returns (uint) {
45       uint c = a + b;
46       assert(c >= a);
47       return c;
48    }
49 
50   function div(uint a, uint b) internal pure returns (uint256) {
51     assert(b > 0); // Solidity automatically throws when dividing by 0
52     uint c = a / b;
53     assert(a == b * c + a % b); // There is no case in which this doesn't hold
54     return c;
55   }
56 }
57 
58 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
59 
60 contract TokenERC20 {
61     using SafeMath for uint256;
62     // Public variables of the token
63     string public name;
64     string public symbol;
65     uint8 public decimals = 18;
66     // 18 decimals is the strongly suggested default, avoid changing it
67     uint256 public totalSupply;
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
80      * Constrctor function
81      *
82      * Initializes contract with initial supply tokens to the creator of the contract
83      */
84     function TokenERC20(
85         uint256 initialSupply,
86         string tokenName,
87         string tokenSymbol
88     ) public {
89         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
90         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
91         name = tokenName;                                   // Set the name for display purposes
92         symbol = tokenSymbol;                               // Set the symbol for display purposes
93     }
94 
95     /**
96      * Internal transfer, only can be called by this contract
97      */
98     function _transfer(address _from, address _to, uint _value) internal {
99         // Prevent transfer to 0x0 address. Use burn() instead
100         require(_to != 0x0);
101         // Check if the sender has enough
102         require(balanceOf[_from] >= _value);
103         // Check for overflows
104         require(balanceOf[_to].add(_value) > balanceOf[_to]);
105         // Save this for an assertion in the future
106         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
107         // Subtract from the sender
108         balanceOf[_from] = balanceOf[_from].sub(_value);
109         // Add the same to the recipient
110         balanceOf[_to] =balanceOf[_to].add(_value);
111         Transfer(_from, _to, _value);
112         // Asserts are used to use static analysis to find bugs in your code. They should never fail
113         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
114     }
115 
116     /**
117      * Transfer tokens
118      *
119      * Send `_value` tokens to `_to` from your account
120      *
121      * @param _to The address of the recipient
122      * @param _value the amount to send
123      */
124     function transfer(address _to, uint256 _value) public {
125         _transfer(msg.sender, _to, _value);
126     }
127 
128     /**
129      * Transfer tokens from other address
130      *
131      * Send `_value` tokens to `_to` in behalf of `_from`
132      *
133      * @param _from The address of the sender
134      * @param _to The address of the recipient
135      * @param _value the amount to send
136      */
137     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
138         require(_value <= allowance[_from][msg.sender]);     // Check allowance
139         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
140         _transfer(_from, _to, _value);
141         return true;
142     }
143 
144     /**
145      * Set allowance for other address
146      *
147      * Allows `_spender` to spend no more than `_value` tokens in your behalf
148      *
149      * @param _spender The address authorized to spend
150      * @param _value the max amount they can spend
151      */
152     function approve(address _spender, uint256 _value) public
153         returns (bool success) {
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
169         returns (bool success) {
170         tokenRecipient spender = tokenRecipient(_spender);
171         if (approve(_spender, _value)) {
172             spender.receiveApproval(msg.sender, _value, this, _extraData);
173             return true;
174         }
175     }
176 
177     /**
178      * Destroy tokens
179      *
180      * Remove `_value` tokens from the system irreversibly
181      *
182      * @param _value the amount of money to burn
183      */
184     function burn(uint256 _value) public returns (bool success) {
185         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
186         balanceOf[msg.sender] -= _value;            // Subtract from the sender
187         totalSupply -= _value;                      // Updates totalSupply
188         Burn(msg.sender, _value);
189         return true;
190     }
191 
192     /**
193      * Destroy tokens from other account
194      *
195      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
196      *
197      * @param _from the address of the sender
198      * @param _value the amount of money to burn
199      */
200     function burnFrom(address _from, uint256 _value) public returns (bool success) {
201         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
202         require(_value <= allowance[_from][msg.sender]);    // Check allowance
203         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
204         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
205         totalSupply -= _value;                              // Update totalSupply
206         Burn(_from, _value);
207         return true;
208     }
209 }
210 
211 /******************************************/
212 /*       ADVANCED TOKEN STARTS HERE       */
213 /******************************************/
214 
215 contract ASCToken is owned, TokenERC20 {
216     using SafeMath for uint256;
217 
218     mapping (address => bool) public frozenAccount;
219 
220     /* This generates a public event on the blockchain that will notify clients */
221     event FrozenFunds(address target, bool frozen);
222 
223     /* Initializes contract with initial supply tokens to the creator of the contract */
224     function ASCToken(
225         uint256 initialSupply,
226         string tokenName,
227         string tokenSymbol
228     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
229 
230     /* Internal transfer, only can be called by this contract */
231     function _transfer(address _from, address _to, uint _value) internal {
232         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
233         require (balanceOf[_from] >= _value);               // Check if the sender has enough
234         require (balanceOf[_to].add(_value) > balanceOf[_to]); // Check for overflows
235         require(!frozenAccount[_from]);                     // Check if sender is frozen
236         require(!frozenAccount[_to]);                       // Check if recipient is frozen
237         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the sender
238         balanceOf[_to] = balanceOf[_to].add(_value);                           // Add the same to the recipient
239         Transfer(_from, _to, _value);
240     }
241 
242     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
243     /// @param target Address to be frozen
244     /// @param freeze either to freeze it or not
245     function freezeAccount(address target, bool freeze) onlyOwner public {
246         frozenAccount[target] = freeze;
247         FrozenFunds(target, freeze);
248     }
249 
250 }