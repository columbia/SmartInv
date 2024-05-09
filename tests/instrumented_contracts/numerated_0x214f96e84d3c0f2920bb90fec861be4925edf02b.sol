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
82 contract HorseyToken is ERC20Interface, Owned {
83     using SafeMath for uint;
84 
85     string public symbol;
86     string public  name;
87     uint8 public decimals; 
88     uint public totalSupply;
89 
90     mapping(address => uint) balances;
91     mapping(address => mapping(address => uint)) allowed;
92 
93 
94     // ------------------------------------------------------------------------
95     // Constructor
96     // ------------------------------------------------------------------------
97     constructor(string _symbol, string _name, uint8 _decimals,  uint _totalSupply ) public {
98         symbol = _symbol;
99         name = _name;
100         decimals = _decimals;
101         totalSupply = _totalSupply * 10**uint(_decimals);
102         balances[owner] = totalSupply;
103         emit Transfer(address(0), owner, totalSupply);
104     }
105 
106 
107     // ------------------------------------------------------------------------
108     // Get the token balance for account `tokenOwner`
109     // ------------------------------------------------------------------------
110     function balanceOf(address tokenOwner) public view returns (uint balance) {
111         return balances[tokenOwner];
112     }
113 
114 
115     // ------------------------------------------------------------------------
116     // Transfer the balance from token owner's account to `to` account
117     // - Owner's account must have sufficient balance to transfer
118     // - 0 value transfers are allowed
119     // ------------------------------------------------------------------------
120     function transfer(address to, uint tokens) public returns (bool success) {
121         balances[msg.sender] = balances[msg.sender].sub(tokens);
122         balances[to] = balances[to].add(tokens);
123         emit Transfer(msg.sender, to, tokens);
124         return true;
125     }
126 
127 
128     // ------------------------------------------------------------------------
129     // Token owner can approve for `spender` to transferFrom(...) `tokens`
130     // from the token owner's account
131     //
132     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
133     // recommends that there are no checks for the approval double-spend attack
134     // as this should be implemented in user interfaces 
135     // ------------------------------------------------------------------------
136     function approve(address spender, uint tokens) public returns (bool success) {
137         allowed[msg.sender][spender] = tokens;
138         emit Approval(msg.sender, spender, tokens);
139         return true;
140     }
141 
142 
143     // ------------------------------------------------------------------------
144     // Transfer `tokens` from the `from` account to the `to` account
145     // 
146     // The calling account must already have sufficient tokens approve(...)-d
147     // for spending from the `from` account and
148     // - From account must have sufficient balance to transfer
149     // - Spender must have sufficient allowance to transfer
150     // - 0 value transfers are allowed
151     // ------------------------------------------------------------------------
152     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
153         balances[from] = balances[from].sub(tokens);
154         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
155         balances[to] = balances[to].add(tokens);
156         emit Transfer(from, to, tokens);
157         return true;
158     }
159 
160 
161     // ------------------------------------------------------------------------
162     // Returns the amount of tokens approved by the owner that can be
163     // transferred to the spender's account
164     // ------------------------------------------------------------------------
165     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
166         return allowed[tokenOwner][spender];
167     }
168 
169 
170      
171     /**
172      * Set allowance for other address and notify
173      *
174      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
175      *
176      * @param _spender The address authorized to spend
177      * @param _value the max amount they can spend
178      * @param _extraData some extra information to send to the approved contract
179      */
180     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
181         public
182         returns (bool success) {
183         tokenRecipient spender = tokenRecipient(_spender);
184         if (approve(_spender, _value)) {
185             // So, spender can be another smart contract, that implement receiveApproval function, where he can withdraw the token and do other things
186             spender.receiveApproval(msg.sender, _value, this, _extraData);
187             return true;
188         }
189     }
190 
191     // ------------------------------------------------------------------------
192     // Don't accept ETH- Prevent accidentally send Eth into this contract.
193     // ------------------------------------------------------------------------
194     function () public payable {
195         revert();
196     }
197 
198 
199     // ------------------------------------------------------------------------
200     // Owner can transfer out any accidentally sent ERC20 tokens
201     // ------------------------------------------------------------------------
202     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
203         return ERC20Interface(tokenAddress).transfer(owner, tokens);
204     }
205 
206     /**
207     * approve should be called when allowed[_spender] == 0. To increment
208     * allowed value is better to use this function to avoid 2 calls (and wait until
209     * the first transaction is mined)
210     * From MonolithDAO Token.sol
211     */
212     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
213         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
214         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215         return true;
216     }
217 
218     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
219         uint oldValue = allowed[msg.sender][_spender];
220         if (_subtractedValue > oldValue) {
221             allowed[msg.sender][_spender] = 0;
222         } else {
223             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
224         }
225         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226         return true;
227     }
228 }