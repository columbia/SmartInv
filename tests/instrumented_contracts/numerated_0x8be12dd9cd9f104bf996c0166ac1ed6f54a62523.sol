1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath of GMC
5  */
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     if (a == 0) {
9       return 0;
10     }
11 
12     uint256 c = a * b;
13     require(c / a == b);
14 
15     return c;
16   }
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     require(b > 0); 
19     uint256 c = a / b;
20 
21     return c;
22   }
23   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     require(b <= a);
25     uint256 c = a - b;
26 
27     return c;
28   }
29   
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     require(c >= a);
33 
34     return c;
35   }
36   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
37     require(b != 0);
38     return a % b;
39   }
40 }
41 
42 contract owned {
43     address public owner;
44 
45     constructor() public {
46         owner = msg.sender;
47     }
48 
49     modifier onlyOwner {
50         require(msg.sender == owner);
51         _;
52     }
53 
54     function transferOwnership(address newOwner) onlyOwner public {
55         owner = newOwner;
56     }
57 }
58 
59 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
60 
61 contract TokenERC20 is owned{
62     using SafeMath for uint256;
63 
64     // GMC variables of the token
65     string public name = "Global Management Coin";
66     string public symbol = "GMC";
67     uint8 public decimals = 18;
68     uint256 public totalSupply = 900000000000000000000000000;
69     bool public released = true;
70     mapping (address => uint256) public balanceOf;
71     mapping (address => mapping (address => uint256)) public allowance;
72     event Transfer(address indexed from, address indexed to, uint256 value);
73     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
74     event Burn(address indexed from, uint256 value);
75 
76     
77     constructor(
78         uint256 initialSupply,
79         string tokenName,
80         string tokenSymbol
81     ) public {
82         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
83         balanceOf[msg.sender] = 0;                // Give the creator all initial tokens
84         name = "Global Management Coin";                                   // Set the name for display purposes
85         symbol = "GMC";                               // Set the symbol for display purposes
86     }
87 
88     function release() public onlyOwner{
89       require (owner == msg.sender);
90       released = !released;
91     }
92 
93     modifier onlyReleased() {
94       require(released);
95       _;
96     }
97 
98 
99     /**
100      * Set allowance for other address
101      */
102     function approve(address _spender, uint256 _value) public onlyReleased
103         returns (bool success) {
104         require(_spender != address(0));
105 
106         allowance[msg.sender][_spender] = _value;
107         emit Approval(msg.sender, _spender, _value);
108         return true;
109     }
110     
111     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
112         public onlyReleased
113         returns (bool success) {
114         tokenRecipient spender = tokenRecipient(_spender);
115         if (approve(_spender, _value)) {
116             spender.receiveApproval(msg.sender, _value, this, _extraData);
117             return true;
118         }
119     }
120 
121     function _transfer(address _from, address _to, uint _value) internal onlyReleased {
122         require(_to != 0x0);
123         require(balanceOf[_from] >= _value);
124         require(balanceOf[_to] + _value > balanceOf[_to]);
125         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
126         balanceOf[_from] = balanceOf[_from].sub(_value);
127         balanceOf[_to] = balanceOf[_to].add(_value);
128         emit Transfer(_from, _to, _value);
129         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
130     }
131 
132     /**
133      * Transfer tokens
134      */
135     function transfer(address _to, uint256 _value) public onlyReleased returns (bool success) {
136         _transfer(msg.sender, _to, _value);
137         return true;
138     }
139 
140     /**
141      * Transfer tokens from other address
142      */
143     function transferFrom(address _from, address _to, uint256 _value) public onlyReleased returns (bool success) {
144         require(_value <= allowance[_from][msg.sender]);     // Check allowance
145 
146         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
147         _transfer(_from, _to, _value);
148         return true;
149     }
150 
151     /**
152      * Destroy tokens
153      */
154     function burn(uint256 _value) public onlyReleased returns (bool success) {
155         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
156         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
157         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
158         emit Burn(msg.sender, _value);
159         return true;
160     }
161 
162     /**
163      * Destroy tokens from other account
164      */
165     function burnFrom(address _from, uint256 _value) public onlyReleased returns (bool success) {
166         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
167         require(_value <= allowance[_from][msg.sender]);    // Check allowance
168         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
169         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
170         totalSupply = totalSupply.sub(_value);                              // Update totalSupply
171         emit Burn(_from, _value);
172         return true;
173     }
174 }
175 
176 contract GMC is owned, TokenERC20 {
177 
178     mapping (address => bool) public frozenAccount;
179 
180     /* This generates a public event on the blockchain that will notify clients */
181     event FrozenFunds(address target, bool frozen);
182 
183     /* Initializes contract with initial supply tokens to the creator of the contract */
184     constructor(
185         uint256 initialSupply,
186         string tokenName,
187         string tokenSymbol
188     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {
189     }
190 
191       /* Internal transfer, only can be called by this contract */
192       function _transfer(address _from, address _to, uint _value) internal onlyReleased {
193         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
194         require (balanceOf[_from] >= _value);               // Check if the sender has enough
195         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
196         require(!frozenAccount[_from]);                     // Check if sender is frozen
197         require(!frozenAccount[_to]);                       // Check if recipient is frozen
198         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the sender
199         balanceOf[_to] = balanceOf[_to].add(_value);                           // Add the same to the recipient
200         emit Transfer(_from, _to, _value);
201     }
202 
203     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
204     function freezeAccount(address target, bool freeze) onlyOwner public {
205         frozenAccount[target] = freeze;
206         emit FrozenFunds(target, freeze);
207     }
208 
209     /// @notice Create `mintedAmount` tokens and send it to `target`
210     /// @param target Address to receive the tokens
211     /// @param mintedAmount the amount of tokens it will receive
212     /// mintedAmount 1000000000000000000 = 1.000000000000000000
213     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
214         require (mintedAmount > 0);
215         totalSupply = totalSupply.add(mintedAmount);
216         balanceOf[target] = balanceOf[target].add(mintedAmount);
217         emit Transfer(0, this, mintedAmount);
218         emit Transfer(this, target, mintedAmount);
219     }
220 
221 
222 }