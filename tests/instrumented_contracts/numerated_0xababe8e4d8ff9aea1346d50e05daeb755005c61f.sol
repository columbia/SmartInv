1 pragma solidity 0.4.22;
2 
3 contract EIP20Interface {
4     /* This is a slight change to the ERC20 base standard.
5     function totalSupply() constant returns (uint256 supply);
6     is replaced with:
7     uint256 public totalSupply;
8     This automatically creates a getter function for the totalSupply.
9     This is moved to the base contract since public getter functions are not
10     currently recognised as an implementation of the matching abstract
11     function by the compiler.
12     */
13     /// total amount of tokens
14     uint256 public totalSupply;
15 
16     /// @param _owner The address from which the balance will be retrieved
17     /// @return The balance
18     function balanceOf(address _owner) public view returns (uint256 balance);
19 
20     /// @notice send `_value` token to `_to` from `msg.sender`
21     /// @param _to The address of the recipient
22     /// @param _value The amount of token to be transferred
23     /// @return Whether the transfer was successful or not
24     function transfer(address _to, uint256 _value) public returns (bool success);
25 
26     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
27     /// @param _from The address of the sender
28     /// @param _to The address of the recipient
29     /// @param _value The amount of token to be transferred
30     /// @return Whether the transfer was successful or not
31     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
32 
33     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
34     /// @param _spender The address of the account able to transfer the tokens
35     /// @param _value The amount of tokens to be approved for transfer
36     /// @return Whether the approval was successful or not
37     function approve(address _spender, uint256 _value) public returns (bool success);
38 
39     /// @param _owner The address of the account owning tokens
40     /// @param _spender The address of the account able to transfer the tokens
41     /// @return Amount of remaining tokens allowed to spent
42     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
43 
44     // solhint-disable-next-line no-simple-event-func-name
45     event Transfer(address indexed _from, address indexed _to, uint256 _value);
46     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
47 }
48 
49 contract EIP20 is EIP20Interface {
50 
51     uint256 constant internal MAX_UINT256 = 2**256 - 1;
52     mapping (address => uint256) public balances;
53     mapping (address => mapping (address => uint256)) public allowed;
54     /*
55     NOTE:
56     The following variables are OPTIONAL vanities. One does not have to include them.
57     They allow one to customise the token contract & in no way influences the core functionality.
58     Some wallets/interfaces might not even bother to look at this information.
59     */
60     string public name;                   //fancy name: eg Simon Bucks
61     uint8  public decimals;               //How many decimals to show.
62     string public symbol;                 //An identifier: eg SBX
63 
64     function transfer(address _to, uint256 _value) public returns (bool success) {
65         require(balances[msg.sender] >= _value);
66         balances[msg.sender] -= _value;
67         balances[_to] += _value;
68         emit Transfer(msg.sender, _to, _value);
69         return true;
70     }
71 
72     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
73         uint256 allowance = allowed[_from][msg.sender];
74         require(balances[_from] >= _value && allowance >= _value);
75         balances[_to] += _value;
76         balances[_from] -= _value;
77         if (allowance < MAX_UINT256) {
78             allowed[_from][msg.sender] -= _value;
79         }
80         emit Transfer(_from, _to, _value);
81         return true;
82     }
83 
84     function balanceOf(address _owner) public view returns (uint256 balance) {
85         return balances[_owner];
86     }
87     
88     function approve(address _spender, uint256 _value) public returns (bool success) {
89         allowed[msg.sender][_spender] = _value;
90         emit Approval(msg.sender, _spender, _value);
91         return true;
92     }
93     
94     /**
95      * @dev Increase the amount of tokens that an owner allowed to a spender.
96      * approve should be called when allowed[_spender] == 0. To increment
97      * allowed value is better to use this function to avoid 2 calls (and wait until
98      * the first transaction is mined)
99      * From MonolithDAO Token.sol
100      * @param _spender The address which will spend the funds.
101      * @param _addedValue The amount of tokens to increase the allowance by.
102      */
103     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) {
104         require(allowed[msg.sender][_spender] + _addedValue > allowed[msg.sender][_spender]);
105         allowed[msg.sender][_spender] += _addedValue;
106         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
107         return true;
108     }
109   
110     /**
111      * @dev Decrease the amount of tokens that an owner allowed to a spender.
112      * approve should be called when allowed[_spender] == 0. To decrement
113      * allowed value is better to use this function to avoid 2 calls (and wait until
114      * the first transaction is mined)
115      * From MonolithDAO Token.sol
116      * @param _spender The address which will spend the funds.
117      * @param _subtractedValue The amount of tokens to decrease the allowance by.
118      */
119     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) {
120         if (_subtractedValue > allowed[msg.sender][_spender]) {
121             allowed[msg.sender][_spender] = 0;
122         } else {
123             allowed[msg.sender][_spender] -= _subtractedValue;
124         }
125         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
126         return true;
127     }
128   
129     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
130         return allowed[_owner][_spender];
131     }
132 }
133 
134 contract Owned {
135     address internal owner;
136     modifier onlyOwner() {
137         require(msg.sender == owner);
138         _;
139     }
140 
141     function changeOwner(address newOwner) public onlyOwner {
142         owner = newOwner;
143     }
144 }
145 
146 contract Proof is Owned {
147     string public proofAddr;
148     function setProofAddr(string proofaddr) public onlyOwner {
149         proofAddr = proofaddr;
150     }
151 }
152 
153 contract Stoppable is Owned {
154     bool public stopped = false;
155 
156     modifier isRunning() {
157         require(!stopped);
158         _;
159     }
160 
161     function stop() public onlyOwner isRunning {
162         stopped = true;
163     }
164 }
165 
166 contract SECT is EIP20, Owned, Proof, Stoppable {
167     string public coinbase = "Ampil landed  and EIP999 is still in the eye of typhoon";
168     constructor () public {
169         name = "SECBIT";                                  // Set the name for display purposes
170         symbol = "SECT";                                  // Set the symbol for display purposes
171         decimals = 18;                                    // Amount of decimals for display purposes
172         totalSupply = (10**9) * (10**uint256(decimals));  // Update total supply
173         balances[msg.sender] = totalSupply;               // Give the creator all initial tokens
174         owner = msg.sender;
175     }
176 
177     function transfer(address _to, uint256 _value) public isRunning returns (bool success) {
178         return super.transfer(_to, _value);
179     }
180     
181     function transferFrom(address _from, address _to, uint256 _value) public isRunning returns (bool success) {
182         return super.transferFrom(_from, _to, _value);
183     }
184     
185     function approve(address _spender, uint256 _value) public isRunning returns (bool success) {
186         return super.approve(_spender, _value);
187     }
188 
189     function increaseApproval(address _spender, uint256 _addedValue) public isRunning returns (bool success) {
190         return super.increaseApproval(_spender, _addedValue);
191     }
192     
193     function decreaseApproval(address _spender, uint256 _subtractedValue) public isRunning returns (bool success) {
194         return super.decreaseApproval(_spender, _subtractedValue);
195     }
196     
197     function setProofAddr(string proofaddr) public isRunning {
198         super.setProofAddr(proofaddr);
199     }
200 
201 }