1 //Fully function ERC 20
2 // 
3 pragma solidity ^0.4.4;
4  
5 library SafeMath {
6     function add(uint a, uint b) internal pure returns (uint c) {
7         c = a + b;
8         require(c >= a);
9     }
10     function sub(uint a, uint b) internal pure returns (uint c) {
11         require(b <= a);
12         c = a - b;
13     }
14     function mul(uint a, uint b) internal pure returns (uint c) {
15         c = a * b;
16         require(a == 0 || c / a == b);
17     }
18     function div(uint a, uint b) internal pure returns (uint c) {
19         require(b > 0);
20         c = a / b;
21     }
22 }
23 
24 
25 // ----------------------------------------------------------------------------
26 // ERC Token Standard #20 Interface
27 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
28 // ----------------------------------------------------------------------------
29 contract ERC20Interface {
30     //function getTotalSupply() public view returns (uint);
31     function balanceOf(address tokenOwner) public view returns (uint balance);
32     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
33     function transfer(address to, uint tokens) public returns (bool success);
34     function approve(address spender, uint tokens) public returns (bool success);
35     function transferFrom(address from, address to, uint tokens) public returns (bool success);
36 
37     event Transfer(address indexed from, address indexed to, uint tokens);
38     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
39 }
40 
41 
42 // ----------------------------------------------------------------------------
43 // Contract function to receive approval and execute function in one call
44 // ----------------------------------------------------------------------------
45 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
46 
47 
48 // ----------------------------------------------------------------------------
49 // Owned contract
50 // ----------------------------------------------------------------------------
51 contract Owned {
52     address public owner;
53     address public newOwner;
54 
55     event OwnershipTransferred(address indexed _from, address indexed _to);
56 
57     constructor() public {
58         owner = msg.sender;
59     }
60 
61     modifier onlyOwner {
62         require(msg.sender == owner);
63         _;
64     }
65 
66     function transferOwnership(address _newOwner) public onlyOwner {
67         newOwner = _newOwner;
68     }
69     function acceptOwnership() public {
70         require(msg.sender == newOwner);
71         emit OwnershipTransferred(owner, newOwner);
72         owner = newOwner;
73         newOwner = address(0);
74     }
75 }
76 
77 
78 // ----------------------------------------------------------------------------
79 // ERC20 Token, with the addition of symbol, name and decimals and a
80 // fixed supply
81 // ----------------------------------------------------------------------------
82 contract BiotheumToken is ERC20Interface, Owned {
83     using SafeMath for uint;
84 
85     string public symbol;
86     string public  name;
87     //uint8 public decimals; change it to 18 as suggested
88     uint public totalSupply;
89 
90     mapping(address => uint) balances;
91     mapping(address => mapping(address => uint)) allowed;
92 
93 
94     // ------------------------------------------------------------------------
95     // Constructor
96     // ------------------------------------------------------------------------
97     constructor(string _symbol, string _name,  uint _totalSupply ) public {
98         symbol = _symbol;
99         name = _name;
100         totalSupply = _totalSupply * 10**uint(18);
101         balances[owner] = _totalSupply;
102         emit Transfer(address(0), owner, totalSupply);
103     }
104 
105 
106     // ------------------------------------------------------------------------
107     // Get the token balance for account `tokenOwner`
108     // ------------------------------------------------------------------------
109     function balanceOf(address tokenOwner) public view returns (uint balance) {
110         return balances[tokenOwner];
111     }
112 
113 
114     // ------------------------------------------------------------------------
115     // Transfer the balance from token owner's account to `to` account
116     // - Owner's account must have sufficient balance to transfer
117     // - 0 value transfers are allowed
118     // ------------------------------------------------------------------------
119     function transfer(address to, uint tokens) public returns (bool success) {
120         balances[msg.sender] = balances[msg.sender].sub(tokens);
121         balances[to] = balances[to].add(tokens);
122         emit Transfer(msg.sender, to, tokens);
123         return true;
124     }
125 
126 
127     // ------------------------------------------------------------------------
128     // Token owner can approve for `spender` to transferFrom(...) `tokens`
129     // from the token owner's account
130     //
131     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
132     // recommends that there are no checks for the approval double-spend attack
133     // as this should be implemented in user interfaces 
134     // ------------------------------------------------------------------------
135     function approve(address spender, uint tokens) public returns (bool success) {
136         allowed[msg.sender][spender] = tokens;
137         emit Approval(msg.sender, spender, tokens);
138         return true;
139     }
140 
141 
142     // ------------------------------------------------------------------------
143     // Transfer `tokens` from the `from` account to the `to` account
144     // 
145     // The calling account must already have sufficient tokens approve(...)-d
146     // for spending from the `from` account and
147     // - From account must have sufficient balance to transfer
148     // - Spender must have sufficient allowance to transfer
149     // - 0 value transfers are allowed
150     // ------------------------------------------------------------------------
151     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
152         balances[from] = balances[from].sub(tokens);
153         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
154         balances[to] = balances[to].add(tokens);
155         emit Transfer(from, to, tokens);
156         return true;
157     }
158 
159 
160     // ------------------------------------------------------------------------
161     // Returns the amount of tokens approved by the owner that can be
162     // transferred to the spender's account
163     // ------------------------------------------------------------------------
164     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
165         return allowed[tokenOwner][spender];
166     }
167 
168 
169      
170     /**
171      * Set allowance for other address and notify
172      *
173      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
174      *
175      * @param _spender The address authorized to spend
176      * @param _value the max amount they can spend
177      * @param _extraData some extra information to send to the approved contract
178      */
179     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
180         public
181         returns (bool success) {
182         tokenRecipient spender = tokenRecipient(_spender);
183         if (approve(_spender, _value)) {
184             // So, spender can be another smart contract, that implement receiveApproval function, where he can withdraw the token and do other things
185             spender.receiveApproval(msg.sender, _value, this, _extraData);
186             return true;
187         }
188     }
189 
190     // ------------------------------------------------------------------------
191     // Don't accept ETH- Prevent accidentally send Eth into this contract.
192     // ------------------------------------------------------------------------
193     function () public payable {
194         revert();
195     }
196 
197 
198     // ------------------------------------------------------------------------
199     // Owner can transfer out any accidentally sent ERC20 tokens
200     // ------------------------------------------------------------------------
201     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
202         return ERC20Interface(tokenAddress).transfer(owner, tokens);
203     }
204 
205     /**
206     * approve should be called when allowed[_spender] == 0. To increment
207     * allowed value is better to use this function to avoid 2 calls (and wait until
208     * the first transaction is mined)
209     * From MonolithDAO Token.sol
210     */
211     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
212         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
213         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214         return true;
215     }
216 
217     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
218         uint oldValue = allowed[msg.sender][_spender];
219         if (_subtractedValue > oldValue) {
220             allowed[msg.sender][_spender] = 0;
221         } else {
222             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
223         }
224         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225         return true;
226     }
227 }