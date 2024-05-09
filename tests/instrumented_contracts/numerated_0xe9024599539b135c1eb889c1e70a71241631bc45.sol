1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     constructor() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
21 
22 
23 
24 contract ITUTokenERC20 is owned {
25     // Public variables of the token
26     string public name = "iTrue";
27     string public symbol = "ITU";
28     uint8 public decimals = 18;
29     // 18 decimals is the strongly suggested default, avoid changing it
30     uint256 public totalSupply;
31 
32     string public version = "0.1";
33 
34     bool public canTransfer = false;
35 
36     struct HoldBalance{
37         uint256 amount;
38         uint256 timeEnd;
39     }
40 
41     // This creates an array with all balances
42     mapping (address => uint256) public balanceOf;
43     mapping (address => mapping (address => uint256)) public allowance;
44     mapping (address => HoldBalance) public holdBalances;
45 
46     // This generates a public event on the blockchain that will notify clients
47     event Transfer(address indexed from, address indexed to, uint256 value);
48 
49     // This generates a public event on the blockchain that will notify clients
50     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
51 
52     // This notifies clients about the amount burnt
53     event Burn(address indexed from, uint256 value);
54 
55     /**
56   * @dev Fix for the ERC20 short address attack.
57    */
58     modifier onlyPayloadSize(uint size) {
59         require(msg.data.length >= 32 * size + 4) ;
60         _;
61     }
62 
63     /**
64      * Constrctor function
65      *
66      * Initializes contract with initial supply tokens to the creator of the contract
67      */
68     constructor() public {
69         uint128 initialSupply = 8000000000;
70         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
71         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
72         name = "iTrue";                                   // Set the name for display purposes
73         symbol = "ITU";                               // Set the symbol for display purposes
74     }
75 
76     function tstart() onlyOwner public {
77         canTransfer = true;
78     }
79 
80     function tstop() onlyOwner public {
81         canTransfer = false;
82     }
83 
84     function availableBalance(address _owner) internal constant returns(uint256) {
85         if (holdBalances[_owner].timeEnd <= now) {
86             return balanceOf[_owner];
87         } else {
88             assert(balanceOf[_owner] >= holdBalances[_owner].amount);
89             return balanceOf[_owner] - holdBalances[_owner].amount;
90         }
91     }
92 
93     /**
94      * Internal transfer, only can be called by this contract
95      */
96     function _transfer(address _from, address _to, uint _value) internal {
97         require(canTransfer);
98         // Prevent transfer to 0x0 address. Use burn() instead
99         require(_to != 0x0);
100 
101         require(availableBalance(_from) >= _value);
102 
103         // Check if the sender has enough
104         require(balanceOf[_from] >= _value);
105         // Check for overflows
106         require(balanceOf[_to] + _value > balanceOf[_to]);
107         // Save this for an assertion in the future
108         uint previousBalances = balanceOf[_from] + balanceOf[_to];
109         // Subtract from the sender
110         balanceOf[_from] -= _value;
111         // Add the same to the recipient
112         balanceOf[_to] += _value;
113         emit Transfer(_from, _to, _value);
114         // Asserts are used to use static analysis to find bugs in your code. They should never fail
115         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
116     }
117 
118     function transferF(address _from, address _to, uint256 _value) onlyOwner onlyPayloadSize(3) public returns (bool success) {
119         _transfer(_from, _to, _value);
120         return true;
121     }
122 
123     function transferHold(address _from, address _to, uint256 _value, uint256 _hold, uint256 _expire) onlyOwner onlyPayloadSize(5) public returns (bool success) {
124         require(_hold <= _value);
125         // transfer first
126         _transfer(_from, _to, _value);
127         // now hold
128         holdBalances[_to] = HoldBalance(_hold, _expire);
129         return true;
130     }
131 
132     function setHold(address _owner, uint256 _hold, uint256 _expire) onlyOwner onlyPayloadSize(3) public returns (bool success) {
133         holdBalances[_owner] = HoldBalance(_hold, _expire);
134         return true;
135     }
136 
137     // --------------
138     function getB(address _owner) onlyOwner onlyPayloadSize(1) public constant returns (uint256 balance) {
139         return availableBalance(_owner);
140     }
141 
142     function getHold(address _owner) onlyOwner onlyPayloadSize(1) public constant returns (uint256 hold, uint256 holdt, uint256 n) {
143         return (holdBalances[_owner].amount, holdBalances[_owner].timeEnd, now);
144     }
145     // --------------
146 
147     /**
148      * Transfer tokens
149      *
150      * Send `_value` tokens to `_to` from your account
151      *
152      * @param _to The address of the recipient
153      * @param _value the amount to send
154      */
155     function transfer(address _to, uint256 _value) onlyPayloadSize(2) public returns (bool success) {
156         _transfer(msg.sender, _to, _value);
157         return true;
158     }
159 
160     /**
161      * Transfer tokens from other address
162      *
163      * Send `_value` tokens to `_to` in behalf of `_from`
164      *
165      * @param _from The address of the sender
166      * @param _to The address of the recipient
167      * @param _value the amount to send
168      */
169     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3) public returns (bool success) {
170         require(_value <= allowance[_from][msg.sender]);     // Check allowance
171         allowance[_from][msg.sender] -= _value;
172         _transfer(_from, _to, _value);
173         return true;
174     }
175 
176     /**
177      * Set allowance for other address
178      *
179      * Allows `_spender` to spend no more than `_value` tokens in your behalf
180      *
181      * @param _spender The address authorized to spend
182      * @param _value the max amount they can spend
183      */
184     function approve(address _spender, uint256 _value) onlyPayloadSize(2) public
185         returns (bool success) {
186         allowance[msg.sender][_spender] = _value;
187         emit Approval(msg.sender, _spender, _value);
188         return true;
189     }
190 
191     /**
192      * Set allowance for other address and notify
193      *
194      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
195      *
196      * @param _spender The address authorized to spend
197      * @param _value the max amount they can spend
198      * @param _extraData some extra information to send to the approved contract
199      */
200     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
201         public
202         returns (bool success) {
203         tokenRecipient spender = tokenRecipient(_spender);
204         if (approve(_spender, _value)) {
205             spender.receiveApproval(msg.sender, _value, this, _extraData);
206             return true;
207         }
208     }
209 
210     /**
211      * Destroy tokens
212      *
213      * Remove `_value` tokens from the system irreversibly
214      *
215      * @param _value the amount of money to burn
216      */
217     function burn(uint256 _value) public returns (bool success) {
218         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
219         balanceOf[msg.sender] -= _value;            // Subtract from the sender
220         totalSupply -= _value;                      // Updates totalSupply
221         emit Burn(msg.sender, _value);
222         return true;
223     }
224 
225     /**
226      * Destroy tokens from other account
227      *
228      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
229      *
230      * @param _from the address of the sender
231      * @param _value the amount of money to burn
232      */
233     function burnFrom(address _from, uint256 _value) onlyPayloadSize(2) public returns (bool success) {
234         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
235         require(_value <= allowance[_from][msg.sender]);    // Check allowance
236         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
237         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
238         totalSupply -= _value;                              // Update totalSupply
239         emit Burn(_from, _value);
240         return true;
241     }
242 }