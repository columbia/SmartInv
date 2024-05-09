1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title SafeMath
5  */
6 library SafeMath {
7     /**
8     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
9     */
10     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
11         require(b <= a);
12         uint256 c = a - b;
13 
14         return c;
15     }
16 
17     /**
18     * @dev Adds two numbers, reverts on overflow.
19     */
20     function add(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a + b;
22         require(c >= a);
23 
24         return c;
25     }
26 }
27 
28 interface tokenRecipient {function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;}
29 
30 contract TokenERC20 {
31     using SafeMath for uint256;
32     // Public variables of the token
33     string public name;
34     string public symbol;
35     uint8 public decimals = 18;
36     // 18 decimals is the strongly suggested default, avoid changing it
37     uint256 public totalSupply;
38     // the owner of this contract
39     address public owner;
40 
41     // block list
42     mapping(address => bool)   public  frozenAccount;
43     // This creates an array with all balances
44     mapping(address => uint256) public balanceOf;
45     mapping(address => mapping(address => uint256)) public allowance;
46 
47     // This generates a public event on the blockchain that will notify clients
48     event Transfer(address indexed from, address indexed to, uint256 value);
49 
50     // This generates a public event on the blockchain that will notify clients
51     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
52 
53     // This notifies clients about the amount burnt
54     event Burn(address indexed from, uint256 value);
55 
56     // This notifies contract owner has changed
57     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59     ///@notice check if the msgSender is owner
60     modifier onlyOwner{
61         require(msg.sender == owner);
62         _;
63     }
64     /**
65         reset owner
66     **/
67     function transferOwnership(address newOwner) public onlyOwner {
68     require(newOwner != address(0));
69     emit OwnershipTransferred(owner, newOwner);
70     owner = newOwner;
71     }
72 
73     /**
74      * Constructor function
75      *
76      * Initializes contract with initial supply tokens to the creator of the contract
77      */
78     function TokenERC20(
79         uint256 initialSupply,
80         string tokenName,
81         string tokenSymbol,
82         address tokenOwner
83     ) public {
84         totalSupply = initialSupply * 10 ** uint256(decimals);
85         // Update total supply with the decimal amount
86         balanceOf[msg.sender] = totalSupply;
87         // Give the creator all initial tokens
88         name = tokenName;
89         // Set the name for display purposes
90         symbol = tokenSymbol;
91         // Set the symbol for display purposes
92         require(tokenOwner != address(0));
93         owner = tokenOwner;
94     }
95 
96 
97 
98 
99     /**
100         batch transfer , can only call by owner
101     **/
102     function batchTransfer(address[] destinations, uint256[] amounts) public returns (bool success){
103         require(destinations.length == amounts.length);
104         for (uint256 index = 0; index < destinations.length; index++) {
105             _transfer(msg.sender, destinations[index], amounts[index]);
106         }
107         return true;
108     }
109     /**
110      * Internal transfer, only can be called by this contract
111      */
112     function _transfer(address _from, address _to, uint _value) internal {
113         require(_to != address(0x0));
114         require(!frozenAccount[_from]);
115         require(!frozenAccount[_to]);
116         balanceOf[_from] = balanceOf[_from].sub(_value);
117         balanceOf[_to] = balanceOf[_to].add(_value);
118         emit Transfer(_from, _to, _value);
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
129     function transfer(address _to, uint256 _value) public returns (bool success) {
130         _transfer(msg.sender, _to, _value);
131         return true;
132     }
133 
134     /**
135      * Transfer tokens from other address
136      *
137      * Send `_value` tokens to `_to` on behalf of `_from`
138      *
139      * @param _from The address of the sender
140      * @param _to The address of the recipient
141      * @param _value the amount to send
142      */
143     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
144         require(_value <= allowance[_from][msg.sender]);
145         // Check allowance
146         allowance[_from][msg.sender].sub(_value);
147         _transfer(_from, _to, _value);
148         return true;
149     }
150 
151     /**
152      * Set allowance for other address
153      *
154      * Allows `_spender` to spend no more than `_value` tokens on your behalf
155      *
156      * @param _spender The address authorized to spend
157      * @param _value the max amount they can spend
158      */
159     function approve(address _spender, uint256 _value) public
160     returns (bool success) {
161         require(_value == 0 || allowance[msg.sender][_spender] == 0);
162         allowance[msg.sender][_spender] = _value;
163         emit Approval(msg.sender, _spender, _value);
164         return true;
165     }
166 
167     /**
168         freeze account
169      **/
170     function freezeAccount(address target, bool freeze) onlyOwner public {
171         frozenAccount[target] = freeze;
172     }
173 
174 
175     /**
176      * Set allowance for other address and notify
177      *
178      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
179      *
180      * @param _spender The address authorized to spend
181      * @param _value the max amount they can spend
182      * @param _extraData some extra information to send to the approved contract
183      */
184     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
185         tokenRecipient spender = tokenRecipient(_spender);
186         if (approve(_spender, _value)) {
187             spender.receiveApproval(msg.sender, _value, this, _extraData);
188             return true;
189         }
190     }
191 
192     /**
193      * Destroy tokens
194      *
195      * Remove `_value` tokens from the system irreversibly
196      *
197      * @param _value the amount of money to burn
198      */
199     function burn(uint256 _value) public returns (bool success) {
200         require(balanceOf[msg.sender] >= _value);
201         // Check if the sender has enough
202         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
203         // Subtract from the sender
204         totalSupply = totalSupply.sub(_value);
205         // Updates totalSupply
206         emit Burn(msg.sender, _value);
207         return true;
208     }
209 
210     /**
211      * Destroy tokens from other account
212      *
213      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
214      *
215      * @param _from the address of the sender
216      * @param _value the amount of money to burn
217      */
218     function burnFrom(address _from, uint256 _value) public returns (bool success) {
219         require(balanceOf[_from] >= _value);
220         // Check if the targeted balance is enough
221         require(_value <= allowance[_from][msg.sender]);
222         // Check allowance
223         balanceOf[_from] = balanceOf[_from].sub(_value);
224         // Subtract from the targeted balance
225         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
226         // Subtract from the sender's allowance
227         totalSupply = totalSupply.sub(_value);
228         // Update totalSupply
229         emit Burn(_from, _value);
230         return true;
231     }
232 }