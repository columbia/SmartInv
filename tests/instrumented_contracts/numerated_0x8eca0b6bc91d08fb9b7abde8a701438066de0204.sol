1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9  
10   function div(uint256 a, uint256 b) internal  constant returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14  
15   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19  
20   function add(uint256 a, uint256 b) internal constant returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract owned {
28     address public owner;
29 
30     constructor() public {
31         owner = msg.sender;
32     }
33 
34     modifier onlyOwner {
35         require(msg.sender == owner);
36         _;
37     }
38 
39     function transferOwnership(address newOwner) onlyOwner public {
40         owner = newOwner;
41     }
42 }
43 
44 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
45 
46 contract TokenERC20 {
47     using SafeMath for uint256;
48     
49     string public name;
50     string public symbol;
51     uint8 public decimals = 18;
52     
53     uint256 public totalSupply;
54 
55     
56     mapping (address => uint256) public balanceOf;
57     mapping (address => mapping (address => uint256)) public allowance;
58 
59     
60     event Transfer(address indexed from, address indexed to, uint256 value);
61 
62     
63     event Burn(address indexed from, uint256 value);
64 
65     /**
66      * Constrctor function
67      *
68      * Initializes contract with initial supply tokens to the creator of the contract
69      */
70     constructor() public {
71         totalSupply = 200000000 *10 ** uint256(decimals);  
72         balanceOf[msg.sender] = totalSupply;               
73         name = "Coin Trade Base";                                  
74         symbol = "CTB";                           
75     }
76 
77     /**
78      * Internal transfer, only can be called by this contract
79      */
80        function _transfer(address _from, address _to, uint _value) internal {
81         
82         require(_to != 0x0);
83        
84         require(balanceOf[_from] >= _value);
85        
86         require(balanceOf[_to].add(_value) > balanceOf[_to]);
87         
88         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
89         
90         balanceOf[_from] = balanceOf[_from].sub(_value);
91         
92         balanceOf[_to] = balanceOf[_to].add(_value);
93         emit Transfer(_from, _to, _value);
94         
95         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
96     }
97 
98     /**
99      * Transfer tokens
100      *
101      * Send `_value` tokens to `_to` from your account
102      *
103      * @param _to The address of the recipient
104      * @param _value the amount to send
105      */
106     function transfer(address _to, uint256 _value) public {
107         _transfer(msg.sender, _to, _value);
108     }
109 
110     /**
111      * Transfer tokens from other address
112      *
113      * Send `_value` tokens to `_to` in behalf of `_from`
114      *
115      * @param _from The address of the sender
116      * @param _to The address of the recipient
117      * @param _value the amount to send
118      */
119     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
120         require(_value <= allowance[_from][msg.sender]);     
121         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
122         _transfer(_from, _to, _value);
123         return true;
124     }
125 
126     /**
127      * Set allowance for other address
128      *
129      * Allows `_spender` to spend no more than `_value` tokens in your behalf
130      *
131      * @param _spender The address authorized to spend
132      * @param _value the max amount they can spend
133      */
134     function approve(address _spender, uint256 _value) public
135         returns (bool success) {
136         allowance[msg.sender][_spender] = _value;
137         return true;
138     }
139 
140     /**
141      * Set allowance for other address and notify
142      *
143      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
144      *
145      * @param _spender The address authorized to spend
146      * @param _value the max amount they can spend
147      * @param _extraData some extra information to send to the approved contract
148      */
149     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
150         public
151         returns (bool success) {
152         tokenRecipient spender = tokenRecipient(_spender);
153         if (approve(_spender, _value)) {
154             spender.receiveApproval(msg.sender, _value, this, _extraData);
155             return true;
156         }
157     }
158 
159     /**
160      * Destroy tokens
161      *
162      * Remove `_value` tokens from the system irreversibly
163      *
164      * @param _value the amount of money to burn
165      */
166     function burn(uint256 _value) public returns (bool success) {
167        require(balanceOf[msg.sender] >= _value);   
168         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);           
169         totalSupply = totalSupply.sub(_value);                      
170         emit Burn(msg.sender, _value);
171         return true;
172     }
173 
174     /**
175      * Destroy tokens from other account
176      *
177      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
178      *
179      * @param _from the address of the sender
180      * @param _value the amount of money to burn
181      */
182     function burnFrom(address _from, uint256 _value) public returns (bool success) {
183         require(balanceOf[_from] >= _value);                
184         require(_value <= allowance[_from][msg.sender]);    
185         balanceOf[_from] = balanceOf[_from].sub(_value);                     
186         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);       
187         totalSupply = totalSupply.sub(_value);                        
188         emit Burn(_from, _value);
189         return true;
190     }
191 }
192 
193 /******************************************/
194 /*       ADVANCED TOKEN STARTS HERE       */
195 /******************************************/
196 
197 contract CTBCoin is owned, TokenERC20 {
198 
199     uint256 public sellPrice;
200     uint256 public buyPrice;
201 
202     mapping (address => bool) public frozenAccount;
203 
204     /* This generates a public event on the blockchain that will notify clients */
205     event FrozenFunds(address target, bool frozen);
206 
207     /* Initializes contract with initial supply tokens to the creator of the contract */
208     constructor() TokenERC20() public {}
209 
210     /* Internal transfer, only can be called by this contract */
211     function _transfer(address _from, address _to, uint _value) internal {
212         require (_to != 0x0);                    
213         require (balanceOf[_from] >= _value);             
214         require (balanceOf[_to] + _value >= balanceOf[_to]);
215         require(!frozenAccount[_from]);                     
216         require(!frozenAccount[_to]);                      
217         balanceOf[_from] -= _value;                        
218         balanceOf[_to] += _value;                          
219         emit Transfer(_from, _to, _value);
220     }
221 
222     /// @notice Create `mintedAmount` tokens and send it to `target`
223     /// @param target Address to receive the tokens
224     /// @param mintedAmount the amount of tokens it will receive
225     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
226         balanceOf[target] += mintedAmount;
227         totalSupply += mintedAmount;
228         emit Transfer(0, this, mintedAmount);
229         emit Transfer(this, target, mintedAmount);
230     }
231 
232     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
233     /// @param target Address to be frozen
234     /// @param freeze either to freeze it or not
235     function freezeAccount(address target, bool freeze) onlyOwner public {
236         frozenAccount[target] = freeze;
237         emit FrozenFunds(target, freeze);
238     }
239 
240     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
241     /// @param newSellPrice Price the users can sell to the contract
242     /// @param newBuyPrice Price users can buy from the contract
243     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
244         sellPrice = newSellPrice;
245         buyPrice = newBuyPrice;
246     }
247 
248 }