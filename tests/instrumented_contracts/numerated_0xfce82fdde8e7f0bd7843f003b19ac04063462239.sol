1 pragma solidity ^0.4.20;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (_a == 0) {
19       return 0;
20     }
21 
22     c = _a * _b;
23     assert(c / _a == _b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
31     // assert(_b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = _a / _b;
33     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
34     return _a / _b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     assert(_b <= _a);
42     return _a - _b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
49     c = _a + _b;
50     assert(c >= _a);
51     return c;
52   }
53 }
54 
55 contract TokenERC20 {
56     address public owner;
57     // Public variables of the token
58     string public name;
59     string public symbol;
60     uint8 public decimals = 8;
61     using SafeMath for uint256;
62     // 18 decimals is the strongly suggested default, avoid changing it
63     uint256 public totalSupply;
64 
65     // This creates an array with all balances
66     mapping (address => uint256) public balanceOf;
67     mapping (address => mapping (address => uint256)) public allowance;
68 
69     // This generates a public event on the blockchain that will notify clients
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     // This notifies clients about the amount burnt
73     event Burn(address indexed from, uint256 value);
74 
75     mapping (address => bool) public frozenAccount;
76     event FrozenFunds(address target, bool frozen);
77 
78     /**
79      * Constrctor function
80      *
81      * Initializes contract with initial supply tokens to the creator of the contract
82      */
83     function TokenERC20(
84         uint256 initialSupply,
85         string tokenName,
86         string tokenSymbol
87     ) public {
88         owner = msg.sender;
89         
90         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
91         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
92         name = tokenName;                                   // Set the name for display purposes
93         symbol = tokenSymbol;                               // Set the symbol for display purposes
94     }
95 
96     modifier onlyOwner {
97         require(msg.sender == owner);
98         _;
99     }
100     
101     /**
102      * Internal transfer, only can be called by this contract
103      */
104     function _transfer(address _from, address _to, uint _value) internal {
105         // Prevent transfer to 0x0 address. Use burn() instead
106         require(_to != 0x0);
107         // Check if the sender has enough
108         require(balanceOf[_from] >= _value);
109         // Check for overflows
110         require(balanceOf[_to].add(_value) > balanceOf[_to]);
111         // Save this for an assertion in the future
112         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
113         // Subtract from the sender
114         balanceOf[_from] = balanceOf[_from].sub(_value);
115         // Add the same to the recipient
116         balanceOf[_to] = balanceOf[_to].add(_value);
117         Transfer(_from, _to, _value);
118         // Asserts are used to use static analysis to find bugs in your code. They should never fail
119         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
120     }
121     
122     function transfer(address _to, uint256 _value) public {
123         require(!frozenAccount[msg.sender]);
124         _transfer(msg.sender, _to, _value);
125     }
126 
127     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
128         require(!frozenAccount[msg.sender]);
129         require(_value <= allowance[_from][msg.sender]);     // Check allowance
130         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
131         _transfer(_from, _to, _value);
132         return true;
133     }
134 
135     function approve(address _spender, uint256 _value) public
136         returns (bool success) {
137         allowance[msg.sender][_spender] = _value;
138         return true;
139     }
140 
141     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
142         public
143         returns (bool success) {
144         tokenRecipient spender = tokenRecipient(_spender);
145         if (approve(_spender, _value)) {
146             spender.receiveApproval(msg.sender, _value, this, _extraData);
147             return true;
148         }
149     }
150 
151     function burn(uint256 _value) onlyOwner public returns (bool success) {
152         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
153         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
154         totalSupply =totalSupply.sub(_value);                      // Updates totalSupply
155         Burn(msg.sender, _value);
156         return true;
157     }
158 
159 
160     function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {
161         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
162         require(_value <= allowance[_from][msg.sender]);    // Check allowance
163         balanceOf[_from] =balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
164         allowance[_from][msg.sender] =allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
165         totalSupply =totalSupply.sub(_value);                              // Update totalSupply
166         Burn(_from, _value);
167         return true;
168     }
169 
170 
171   function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
172     require(_to != address(this));
173     transfer(_to, _value);
174     require(_to.call(_data));
175     return true;
176   }
177 
178   function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
179     require(_to != address(this));
180 
181     transferFrom(_from, _to, _value);
182 
183     require(_to.call(_data));
184     return true;
185   }
186 
187   function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {
188     require(_spender != address(this));
189 
190     approve(_spender, _value);
191 
192     require(_spender.call(_data));
193 
194     return true;
195   }
196 
197     
198     function transferOwnership(address _owner) onlyOwner public {
199         owner = _owner;
200     }
201     function mintToken(address target, uint256 mintedAmount) public onlyOwner {
202         balanceOf[target] =balanceOf[target].add(mintedAmount);
203         totalSupply =totalSupply.add(mintedAmount);
204         Transfer(0, owner, mintedAmount);
205         Transfer(owner, target, mintedAmount);
206     }
207 
208     function freezeAccount(address target, bool freeze) public onlyOwner {
209         frozenAccount[target] = freeze;
210         FrozenFunds(target, freeze);
211     }
212 }