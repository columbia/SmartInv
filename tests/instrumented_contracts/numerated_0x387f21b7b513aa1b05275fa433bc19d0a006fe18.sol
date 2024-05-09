1 pragma solidity ^0.4.16;
2 
3 
4 interface Presale {
5     function tokenAddress() constant returns (address);
6 }
7 
8 
9 interface Crowdsale {
10     function tokenAddress() constant returns (address);
11 }
12 
13 
14 contract Admins {
15     address public admin1;
16 
17     address public admin2;
18 
19     address public admin3;
20 
21     function Admins(address a1, address a2, address a3) public {
22         admin1 = a1;
23         admin2 = a2;
24         admin3 = a3;
25     }
26 
27     modifier onlyAdmins {
28         require(msg.sender == admin1 || msg.sender == admin2 || msg.sender == admin3);
29         _;
30     }
31 
32     function setAdmin(address _adminAddress) onlyAdmins public {
33 
34         require(_adminAddress != admin1);
35         require(_adminAddress != admin2);
36         require(_adminAddress != admin3);
37 
38         if (admin1 == msg.sender) {
39             admin1 = _adminAddress;
40         }
41         else
42         if (admin2 == msg.sender) {
43             admin2 = _adminAddress;
44         }
45         else
46         if (admin3 == msg.sender) {
47             admin3 = _adminAddress;
48         }
49     }
50 
51 }
52 
53 
54 contract TokenERC20 {
55     // Public variables of the token
56     string public name;
57 
58     string public symbol;
59 
60     uint8 public decimals = 18;
61 
62     uint256 public totalSupply;
63 
64     // This creates an array with all balances
65     mapping (address => uint256) public balanceOf;
66 
67     mapping (address => mapping (address => uint256)) public allowance;
68 
69     // This generates a public event on the blockchain that will notify clients
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     // This notifies clients about the amount burnt
73     event Burn(address indexed from, uint256 value);
74 
75     /**
76      * Constrctor function
77      *
78      * Initializes contract with initial supply tokens to the creator of the contract
79      */
80     function TokenERC20(
81     uint256 initialSupply,
82     string tokenName,
83     string tokenSymbol
84     ) public {
85         totalSupply = initialSupply * 10 ** uint256(decimals);
86         // Update total supply with the decimal amount
87         balanceOf[this] = totalSupply;
88         // Give the creator all initial tokens
89         name = tokenName;
90         // Set the name for display purposes
91         symbol = tokenSymbol;
92         // Set the symbol for display purposes
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
104         require(balanceOf[_to] + _value > balanceOf[_to]);
105         // Save this for an assertion in the future
106         uint previousBalances = balanceOf[_from] + balanceOf[_to];
107         // Subtract from the sender
108         balanceOf[_from] -= _value;
109         // Add the same to the recipient
110         balanceOf[_to] += _value;
111         Transfer(_from, _to, _value);
112         // Asserts are used to use static analysis to find bugs in your code. They should never fail
113         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
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
138         require(_value <= allowance[_from][msg.sender]);
139         // Check allowance
140         allowance[_from][msg.sender] -= _value;
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
154     returns (bool success) {
155         allowance[msg.sender][_spender] = _value;
156         return true;
157     }
158 
159 
160     /**
161      * Destroy tokens
162      *
163      * Remove `_value` tokens from the system irreversibly
164      *
165      * @param _value the amount of money to burn
166      */
167     function burn(uint256 _value) public returns (bool success) {
168         require(balanceOf[msg.sender] >= _value);
169         // Check if the sender has enough
170         balanceOf[msg.sender] -= _value;
171         // Subtract from the sender
172         totalSupply -= _value;
173         // Updates totalSupply
174         Burn(msg.sender, _value);
175         return true;
176     }
177 
178     /**
179      * Destroy tokens from other account
180      *
181      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
182      *
183      * @param _from the address of the sender
184      * @param _value the amount of money to burn
185      */
186     function burnFrom(address _from, uint256 _value) public returns (bool success) {
187         require(balanceOf[_from] >= _value);
188         // Check if the targeted balance is enough
189         require(_value <= allowance[_from][msg.sender]);
190         // Check allowance
191         balanceOf[_from] -= _value;
192         // Subtract from the targeted balance
193         allowance[_from][msg.sender] -= _value;
194         // Subtract from the sender's allowance
195         totalSupply -= _value;
196         // Update totalSupply
197         Burn(_from, _value);
198         return true;
199     }
200 }
201 
202 
203 contract TrimpoToken is Admins, TokenERC20 {
204 
205     uint public transferredManually = 0;
206 
207     uint public transferredPresale = 0;
208 
209     uint public transferredCrowdsale = 0;
210 
211     address public presaleAddr;
212 
213     address public crowdsaleAddr;
214 
215     modifier onlyPresale {
216         require(msg.sender == presaleAddr);
217         _;
218     }
219 
220     modifier onlyCrowdsale {
221         require(msg.sender == crowdsaleAddr);
222         _;
223     }
224 
225 
226     function TrimpoToken(
227     uint256 initialSupply,
228     string tokenName,
229     string tokenSymbol,
230     address a1,
231     address a2,
232     address a3
233     ) TokenERC20(initialSupply, tokenName, tokenSymbol) Admins(a1, a2, a3) public {}
234 
235 
236     function transferManual(address _to, uint _value) onlyAdmins public {
237         _transfer(this, _to, _value);
238         transferredManually += _value;
239     }
240 
241     function setPresale(address _presale) onlyAdmins public {
242         require(_presale != 0x0);
243         bool allow = false;
244         Presale newPresale = Presale(_presale);
245 
246         if (newPresale.tokenAddress() == address(this)) {
247             presaleAddr = _presale;
248         }
249         else {
250             revert();
251         }
252 
253     }
254 
255     function setCrowdsale(address _crowdsale) onlyAdmins public {
256         require(_crowdsale != 0x0);
257         Crowdsale newCrowdsale = Crowdsale(_crowdsale);
258 
259         if (newCrowdsale.tokenAddress() == address(this)) {
260 
261             crowdsaleAddr = _crowdsale;
262         }
263         else {
264             revert();
265         }
266 
267     }
268 
269     function transferPresale(address _to, uint _value) onlyPresale public {
270         _transfer(this, _to, _value);
271         transferredPresale += _value;
272     }
273 
274     function transferCrowdsale(address _to, uint _value) onlyCrowdsale public {
275         _transfer(this, _to, _value);
276         transferredCrowdsale += _value;
277     }
278 
279 }