1 pragma solidity >=0.4.22 <0.7.0;
2 
3 interface tokenRecipient {
4     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external;
5 }
6 
7 contract GTX {
8 
9     // Public variables of the token
10     string public name;
11     string public symbol;
12     uint8 public decimals = 18;
13     // 18 decimals is the strongly suggested default, avoid changing it
14     uint256 public totalSupply;
15     address public owner;
16 
17     // This creates an array with all balances
18     mapping(address => uint256) public balanceOf;
19     mapping(address => mapping(address => uint256)) public allowance;
20     mapping(address => uint256) public freezeOf;
21 
22     // This generates a public event on the blockchain that will notify clients
23     event Transfer(address indexed from, address indexed to, uint256 value);
24 
25     // This generates a public event on the blockchain that will notify clients
26     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
27 
28     // This notifies clients about the amount burnt
29     event Burn(address indexed from, uint256 value);
30 
31     /* This notifies clients about the amount frozen */
32     event Freeze(address indexed from, uint256 value);
33 
34     /* This notifies clients about the amount unfrozen */
35     event Unfreeze(address indexed from, uint256 value);
36 
37     event Mint(uint256 _value);
38 
39     /**
40      * Constructor function
41      *
42      * Initializes contract with initial supply tokens to the creator of the contract
43      */
44     constructor(
45         uint256 initialSupply,
46         string memory tokenName,
47         string memory tokenSymbol
48     ) public {
49         totalSupply = initialSupply * 10 ** uint256(decimals);
50         // Update total supply with the decimal amount
51         balanceOf[msg.sender] = totalSupply;
52         // Give the creator all initial tokens
53         name = tokenName;
54         // Set the name for display purposes
55         symbol = tokenSymbol;
56         // Set the symbol for display purposes
57         owner = msg.sender;
58     }
59 
60     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
61         uint256 c = a * b;
62         assert(a == 0 || c / a == b);
63         return c;
64     }
65 
66     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
67         assert(b > 0);
68         uint256 c = a / b;
69         assert(a == b * c + a % b);
70         return c;
71     }
72 
73     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
74         assert(b <= a);
75         return a - b;
76     }
77 
78     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         assert(c >= a && c >= b);
81         return c;
82     }
83 
84     /**
85      * Internal transfer, only can be called by this contract
86      */
87     function _transfer(address _from, address _to, uint _value) internal {
88         // Prevent transfer to 0x0 address. Use burn() instead
89         require(_to != address(0x0));
90         // Check if the sender has enough
91         require(balanceOf[_from] >= _value);
92         // Check for overflows
93         require(balanceOf[_to] + _value >= balanceOf[_to]);
94         // Save this for an assertion in the future
95         uint previousBalances = balanceOf[_from] + balanceOf[_to];
96         // Subtract from the sender
97         balanceOf[_from] -= _value;
98         // Add the same to the recipient
99         balanceOf[_to] += _value;
100         emit Transfer(_from, _to, _value);
101         // Asserts are used to use static analysis to find bugs in your code. They should never fail
102         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
103     }
104 
105     /**
106      * Transfer tokens
107      *
108      * Send `_value` tokens to `_to` from your account
109      *
110      * @param _to The address of the recipient
111      * @param _value the amount to send
112      */
113     function transfer(address _to, uint256 _value) public returns (bool success) {
114         _transfer(msg.sender, _to, _value);
115         return true;
116     }
117 
118     /**
119      * Transfer tokens from other address
120      *
121      * Send `_value` tokens to `_to` on behalf of `_from`
122      *
123      * @param _from The address of the sender
124      * @param _to The address of the recipient
125      * @param _value the amount to send
126      */
127     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
128         require(_value <= allowance[_from][msg.sender]);
129         // Check allowance
130         allowance[_from][msg.sender] -= _value;
131         _transfer(_from, _to, _value);
132         return true;
133     }
134 
135     /**
136      * Set allowance for other address
137      *
138      * Allows `_spender` to spend no more than `_value` tokens on your behalf
139      *
140      * @param _spender The address authorized to spend
141      * @param _value the max amount they can spend
142      */
143     function approve(address _spender, uint256 _value) public
144     returns (bool success) {
145         allowance[msg.sender][_spender] = _value;
146         emit Approval(msg.sender, _spender, _value);
147         return true;
148     }
149 
150     /**
151      * Set allowance for other address and notify
152      *
153      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
154      *
155      * @param _spender The address authorized to spend
156      * @param _value the max amount they can spend
157      * @param _extraData some extra information to send to the approved contract
158      */
159     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
160     public
161     returns (bool success) {
162         tokenRecipient spender = tokenRecipient(_spender);
163         if (approve(_spender, _value)) {
164             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
165             return true;
166         }
167     }
168 
169     /**
170      * Destroy tokens
171      *
172      * Remove `_value` tokens from the system irreversibly
173      *
174      * @param _value the amount of money to burn
175      */
176     function burn(uint256 _value) public returns (bool success) {
177         require(balanceOf[msg.sender] >= _value);
178         // Check if the sender has enough
179         balanceOf[msg.sender] -= _value;
180         // Subtract from the sender
181         totalSupply -= _value;
182         // Updates totalSupply
183         emit Burn(msg.sender, _value);
184         return true;
185     }
186 
187     /**
188      * mint tokens
189      *
190      * add `_value` tokens from the system irreversibly
191      *
192      * @param _value the amount of money to mint
193      */
194     function mint(uint256 _value) public returns (bool success) {
195         require((msg.sender == owner));
196         // Only the owner can do this
197         balanceOf[msg.sender] += _value;
198         // add coin for sender
199         totalSupply += _value;
200         // Updates totalSupply
201         emit Mint(_value);
202         return true;
203     }
204 
205     /**
206      * Destroy tokens from other account
207      *
208      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
209      *
210      * @param _from the address of the sender
211      * @param _value the amount of money to burn
212      */
213     function burnFrom(address _from, uint256 _value) public returns (bool success) {
214         require(balanceOf[_from] >= _value);
215         // Check if the targeted balance is enough
216         require(_value <= allowance[_from][msg.sender]);
217         // Check allowance
218         balanceOf[_from] -= _value;
219         // Subtract from the targeted balance
220         allowance[_from][msg.sender] -= _value;
221         // Subtract from the sender's allowance
222         totalSupply -= _value;
223         // Update totalSupply
224         emit Burn(_from, _value);
225         return true;
226     }
227 
228     function freeze(uint256 _value) public returns (bool success) {
229         require(balanceOf[msg.sender] >= _value);
230         // Check if the sender has enough
231         require(_value > 0);
232         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
233         // Subtract from the sender
234         freezeOf[msg.sender] = safeAdd(freezeOf[msg.sender], _value);
235         // Updates totalSupply
236         emit Freeze(msg.sender, _value);
237         return true;
238     }
239 
240     function unfreeze(uint256 _value) public returns (bool success) {
241         require(freezeOf[msg.sender] >= _value);
242         // Check if the sender has enough
243         require(_value > 0);
244         freezeOf[msg.sender] = safeSub(freezeOf[msg.sender], _value);
245         // Subtract from the sender
246         balanceOf[msg.sender] = safeAdd(balanceOf[msg.sender], _value);
247         emit Unfreeze(msg.sender, _value);
248         return true;
249     }
250 
251     //Transfer of ownership,only owner can call this function
252     function transferOwnership(address _address) public returns (bool success){
253         require((msg.sender == owner));
254         _transfer(owner, _address, balanceOf[owner]);
255         owner = _address;
256         return true;
257     }
258 
259 }