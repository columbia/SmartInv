1 pragma solidity >=0.4.22 < 0.6.0;
2 
3 interface tokenRecipient { 
4     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; 
5 }
6 
7 /**
8  * Math operations with safety checks
9  */
10 contract SafeMath {
11     function safeMul(uint a, uint b)internal pure returns (uint) {
12         uint c = a * b;
13         assert(a == 0 || c / a == b);
14         return c;
15     }
16 
17     function safeDiv(uint a, uint b)internal pure returns (uint) {
18         assert(b > 0);
19         uint c = a / b;
20         assert(a == b * c + a % b);
21         return c;
22     }
23 
24     function safeSub(uint a, uint b)internal pure returns (uint) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function safeAdd(uint a, uint b)internal pure returns (uint) {
30         uint c = a + b;
31         assert(c>=a && c>=b);
32         return c;
33     }
34 }
35 
36 
37 /*
38  * Base Token for ERC20 compatibility
39  * ERC20 interface 
40  * see https://github.com/ethereum/EIPs/issues/20
41  */
42 contract ERC20 {
43     //function totalSupply() public view returns (uint256);
44     function balanceOf(address who) public view returns (uint);
45     function allowance(address owner, address spender) public view returns (uint);
46     function transfer(address to, uint value) public returns (bool ok);
47     function transferFrom(address from, address to, uint value) public returns (bool);
48     function approve(address spender, uint value) public returns (bool);
49     event Transfer(address indexed from, address indexed to, uint value);
50     event Approval(address indexed owner, address indexed spender, uint value);
51 }
52 
53 /*
54  * Ownable
55  *
56  * Base contract with an owner contract.
57  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
58  */
59 contract Ownable {
60     /* Address of the owner */
61     address public owner;
62 
63     constructor() public {
64         owner = msg.sender;
65     }
66 
67     modifier onlyOwner() {
68         require(msg.sender == owner,"Only Token Owner can perform this action");
69         _;
70     }
71 
72     function transferOwnership(address _owner) public onlyOwner{
73         require(_owner != owner,"New Owner is the same as existing Owner");
74         require(_owner != address(0x0), "Empty Address provided");
75         owner = _owner;
76     }
77 }
78 
79 /**
80  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
81  *
82  * Based on code by FirstBlood:
83  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
84  */
85 contract StandardToken is ERC20, SafeMath, Ownable{
86 
87     event Burn(address indexed from, uint value);
88 
89     /* Actual balances of token holders */
90     mapping(address => uint) public balances;
91     uint public totalSupply;
92 
93     /* approve() allowances */
94     mapping (address => mapping (address => uint)) internal allowed;
95     
96     /**
97      *
98      * Fix for the ERC20 short address attack
99      *
100      * http://vessenes.com/the-erc20-short-address-attack-explained/
101      */
102     modifier onlyPayloadSize(uint size) {
103         if(msg.data.length < size + 4) {
104             revert("Payload attack");
105         }
106         _;
107     }
108 
109     /**
110      *
111      * Transfer with ERC20 specification
112      *
113      * @param _to    Receiver address.
114      * @param _value Amount of tokens that will be transferred.
115      * http://vessenes.com/the-erc20-short-address-attack-explained/
116      */
117     function transfer(address _to, uint _value)
118     public
119     onlyPayloadSize(2 * 32)
120     returns (bool)
121     {
122         require(_to != address(0x0), "No address specified");
123         require(balances[msg.sender] >= _value, "Insufficiently fund");
124         uint previousBalances = balances[msg.sender] + balances[_to];
125         
126         balances[msg.sender] = safeSub(balances[msg.sender], _value);
127         balances[_to] = safeAdd(balances[_to], _value);
128         emit Transfer(msg.sender, _to, _value);
129         // Asserts are used to use static analysis to find bugs in your code. They should never fail
130         assert(balances[msg.sender] + balances[_to] == previousBalances);
131         return true;
132     }
133 
134     function transferFrom(address _from, address _to, uint _value)
135     public
136     returns (bool)
137     {
138         require(_to != address(0x0), "Empty address specified as Receiver");
139         require(_from != address(0x0), "Empty Address provided for Sender");
140         require(_value <= balances[_from], "Insufficiently fund");
141         require(_value <= allowed[_from][msg.sender], "You can't spend the speficied amount from this Account");
142         uint _allowance = allowed[_from][msg.sender];
143         balances[_from] = safeSub(balances[_from], _value);
144         allowed[_from][msg.sender] = safeSub(_allowance, _value);
145         balances[_to] = safeAdd(balances[_to], _value);
146         emit Transfer(_from, _to, _value);
147         return true;
148     }
149 
150     function balanceOf(address _owner) public view returns (uint) {
151         return balances[_owner];
152     }
153 
154     function approve(address _spender, uint _value) 
155     public
156     returns (bool)
157     {
158         require(_spender != address(0x0), "Invalid Address");
159 
160         // To change the approve amount you first have to reduce the addresses`
161         //    allowance to zero by calling `approve(_spender, 0)` if it is not
162         //    already 0 to mitigate the race condition described here:
163         //    https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164         //if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
165         require(_value == 0 || allowed[msg.sender][_spender] == 0, "Spender allowance must be zero before approving new allowance");
166         require(_value <= balances[msg.sender],"Insufficient balance in owner's account");
167         require(_value >= 0, "Cannot approve negative amount");
168         allowed[msg.sender][_spender] = _value;
169         emit Approval(msg.sender, _spender, _value);
170         return true;
171     }
172 
173     /**
174      * approve should be called when allowed[_spender] == 0. To increment
175      * allowed value is better to use this function to avoid 2 calls (and wait until
176      * the first transaction is mined)
177      * From MonolithDAO Token.sol
178      */
179     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
180         allowed[msg.sender][_spender] = safeAdd(allowed[msg.sender][_spender], _addedValue);
181         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
182         return true;
183     }
184 
185     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
186         require(_subtractedValue >= 0 && _subtractedValue <= balances[msg.sender], "Invalid Amount");
187         uint oldValue = allowed[msg.sender][_spender];
188         if (_subtractedValue > oldValue) {
189             allowed[msg.sender][_spender] = 0;
190         } else {
191             allowed[msg.sender][_spender] = safeSub(oldValue, _subtractedValue);
192         }
193         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
194         return true;
195     }
196 
197     function allowance(address _owner, address _spender) public view returns (uint) {
198         return allowed[_owner][_spender];
199     }
200 
201     function burn(address from, uint amount) public onlyOwner{
202         require(balances[from] >= amount && amount > 0, "Insufficient amount or invalid amount specified");
203         balances[from] = safeSub(balances[from],amount);
204         totalSupply = safeSub(totalSupply, amount);
205         emit Burn(from, amount);
206     }
207 
208     function burn(uint amount) public{
209         burn(msg.sender, amount);
210     }
211 }
212 
213 contract Irstgold is StandardToken {
214     string public name;
215     uint8 public decimals; 
216     string public symbol;
217 
218     constructor() public{
219         decimals = 18;     // Amount of decimals for display purposes
220         totalSupply = 1000000000 * 1 ether;     // Update total supply
221         balances[msg.sender] = totalSupply;    // Give the creator all initial tokens
222         name = "1irstgold";    // Set the name for display purposes
223         symbol = "1STG";    // Set the symbol for display purposes
224     }
225 
226     /**
227      * Set allowance for other address and notify
228      *
229      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
230      *
231      * @param _spender The address authorized to spend
232      * @param _value the max amount they can spend
233      * @param _extraData some extra information to send to the approved contract
234      */
235     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
236         public
237         returns (bool success) {
238         tokenRecipient spender = tokenRecipient(_spender);
239         if (approve(_spender, _value)) {
240             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
241             return true;
242         }
243     }
244 
245     // can accept ether
246     function() external payable{
247         revert("Token does not accept ETH");
248     }
249 }