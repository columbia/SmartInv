1 //////////////////////////////////////////////////////////////////////////////////////////
2 //																						//
3 //	Title: 						Clipper Coin Creation Contract							//
4 //	Author: 					Marko Valentin Micic									//
5 //                              rev by David Dai, Will Wang                             //
6 //	Version: 					v0.2													//
7 //	Date of current version:	2018/01/17												//
8 //                                                                                      //
9 //////////////////////////////////////////////////////////////////////////////////////////
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
52     // assert(b > 0); // Solidity automatically throws when dividing by 0
53     uint c = a / b;
54     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
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
66     uint8 public decimals = 18;
67     // 18 decimals is the strongly suggested default, avoid changing it
68     uint256 public totalSupply;
69 
70     // This creates an array with all balances
71     mapping (address => uint256) public balanceOf;
72     mapping (address => mapping (address => uint256)) public allowance;
73 
74     // This generates a public event on the blockchain that will notify clients
75     event Transfer(address indexed from, address indexed to, uint256 value);
76 
77     // This notifies clients about the amount burnt
78     event Burn(address indexed from, uint256 value);
79 
80     /**
81      * Constrctor function
82      *
83      * Initializes contract with initial supply tokens to the creator of the contract
84      */
85     function TokenERC20(
86         uint256 initialSupply,
87         string tokenName,
88         string tokenSymbol
89     ) public {
90         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
91         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
92         name = tokenName;                                   // Set the name for display purposes
93         symbol = tokenSymbol;                               // Set the symbol for display purposes
94     }
95 
96     /**
97      * Internal transfer, only can be called by this contract
98      */
99     function _transfer(address _from, address _to, uint _value) internal {
100         // Prevent transfer to 0x0 address. Use burn() instead
101         require(_to != 0x0);
102         // Check if the sender has enough
103         require(balanceOf[_from] >= _value);
104         // Check for overflows
105         require(balanceOf[_to].add(_value) > balanceOf[_to]);
106         // Save this for an assertion in the future
107         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
108         // Subtract from the sender
109         balanceOf[_from] = balanceOf[_from].sub(_value);
110         // Add the same to the recipient
111         balanceOf[_to] =balanceOf[_to].add(_value);
112         Transfer(_from, _to, _value);
113         // Asserts are used to use static analysis to find bugs in your code. They should never fail
114         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
115     }
116 
117     /**
118      * Transfer tokens
119      *
120      * Send `_value` tokens to `_to` from your account
121      *
122      * @param _to The address of the recipient
123      * @param _value the amount to send
124      */
125     function transfer(address _to, uint256 _value) public {
126         _transfer(msg.sender, _to, _value);
127     }
128 
129     /**
130      * Transfer tokens from other address
131      *
132      * Send `_value` tokens to `_to` in behalf of `_from`
133      *
134      * @param _from The address of the sender
135      * @param _to The address of the recipient
136      * @param _value the amount to send
137      */
138     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
139         require(_value <= allowance[_from][msg.sender]);     // Check allowance
140         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
141         _transfer(_from, _to, _value);
142         return true;
143     }
144 
145     /**
146      * Set allowance for other address
147      *
148      * Allows `_spender` to spend no more than `_value` tokens in your behalf
149      *
150      * @param _spender The address authorized to spend
151      * @param _value the max amount they can spend
152      */
153     function approve(address _spender, uint256 _value) public
154         returns (bool success) {
155         allowance[msg.sender][_spender] = _value;
156         return true;
157     }
158 
159     /**
160      * Set allowance for other address and notify
161      *
162      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
163      *
164      * @param _spender The address authorized to spend
165      * @param _value the max amount they can spend
166      * @param _extraData some extra information to send to the approved contract
167      */
168     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
169         public
170         returns (bool success) {
171         tokenRecipient spender = tokenRecipient(_spender);
172         if (approve(_spender, _value)) {
173             spender.receiveApproval(msg.sender, _value, this, _extraData);
174             return true;
175         }
176     }
177 
178     /**
179      * Destroy tokens
180      *
181      * Remove `_value` tokens from the system irreversibly
182      *
183      * @param _value the amount of money to burn
184      */
185     function burn(uint256 _value) public returns (bool success) {
186         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
187         balanceOf[msg.sender] -= _value;            // Subtract from the sender
188         totalSupply -= _value;                      // Updates totalSupply
189         Burn(msg.sender, _value);
190         return true;
191     }
192 
193     /**
194      * Destroy tokens from other account
195      *
196      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
197      *
198      * @param _from the address of the sender
199      * @param _value the amount of money to burn
200      */
201     function burnFrom(address _from, uint256 _value) public returns (bool success) {
202         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
203         require(_value <= allowance[_from][msg.sender]);    // Check allowance
204         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
205         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
206         totalSupply -= _value;                              // Update totalSupply
207         Burn(_from, _value);
208         return true;
209     }
210 }
211 
212 /******************************************/
213 /*       ADVANCED TOKEN STARTS HERE       */
214 /******************************************/
215 
216 contract ClipperCoin is owned, TokenERC20 {
217     using SafeMath for uint256;
218 
219     mapping (address => bool) public frozenAccount;
220 
221     /* This generates a public event on the blockchain that will notify clients */
222     event FrozenFunds(address target, bool frozen);
223 
224     /* Initializes contract with initial supply tokens to the creator of the contract */
225     function ClipperCoin(
226         uint256 initialSupply,
227         string tokenName,
228         string tokenSymbol
229     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
230 
231     /* Internal transfer, only can be called by this contract */
232     function _transfer(address _from, address _to, uint _value) internal {
233         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
234         require (balanceOf[_from] >= _value);               // Check if the sender has enough
235         require (balanceOf[_to].add(_value) > balanceOf[_to]); // Check for overflows
236         require(!frozenAccount[_from]);                     // Check if sender is frozen
237         require(!frozenAccount[_to]);                       // Check if recipient is frozen
238         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the sender
239         balanceOf[_to] = balanceOf[_to].add(_value);                           // Add the same to the recipient
240         Transfer(_from, _to, _value);
241     }
242 
243     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
244     /// @param target Address to be frozen
245     /// @param freeze either to freeze it or not
246     function freezeAccount(address target, bool freeze) onlyOwner public {
247         frozenAccount[target] = freeze;
248         FrozenFunds(target, freeze);
249     }
250 
251 }