1 pragma solidity ^0.4.18;
2 
3 contract Owned {
4 
5     address public owner;
6 
7     function Owned() {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner() {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     function setOwner(address _newOwner) onlyOwner {
17         owner = _newOwner;
18     }
19 }
20 contract Pausable is Owned {
21   event Pause();
22   event Unpause();
23 
24   bool public paused = false;
25 
26 
27   /**
28    * @dev Modifier to make a function callable only when the contract is not paused.
29    */
30   modifier whenNotPaused() {
31     require(!paused);
32     _;
33   }
34 
35   /**
36    * @dev Modifier to make a function callable only when the contract is paused.
37    */
38   modifier whenPaused() {
39     require(paused);
40     _;
41   }
42 
43   /**
44    * @dev called by the owner to pause, triggers stopped state
45    */
46   function pause() onlyOwner whenNotPaused public {
47     paused = true;
48     Pause();
49   }
50 
51   /**
52    * @dev called by the owner to unpause, returns to normal state
53    */
54   function unpause() onlyOwner whenPaused public {
55     paused = false;
56     Unpause();
57   }
58 }
59 contract EIP20Interface {
60     /* This is a slight change to the ERC20 base standard.
61     function totalSupply() constant returns (uint256 supply);
62     is replaced with:
63     uint256 public totalSupply;
64     This automatically creates a getter function for the totalSupply.
65     This is moved to the base contract since public getter functions are not
66     currently recognised as an implementation of the matching abstract
67     function by the compiler.
68     */
69     /// total amount of tokens
70     uint256 public totalSupply;
71 
72     /// @param _owner The address from which the balance will be retrieved
73     /// @return The balance
74     function balanceOf(address _owner) public view returns (uint256 balance);
75 
76     /// @notice send `_value` token to `_to` from `msg.sender`
77     /// @param _to The address of the recipient
78     /// @param _value The amount of token to be transferred
79     /// @return Whether the transfer was successful or not
80     function transfer(address _to, uint256 _value) public returns (bool success);
81 
82     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
83     /// @param _from The address of the sender
84     /// @param _to The address of the recipient
85     /// @param _value The amount of token to be transferred
86     /// @return Whether the transfer was successful or not
87     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
88 
89     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
90     /// @param _spender The address of the account able to transfer the tokens
91     /// @param _value The amount of tokens to be approved for transfer
92     /// @return Whether the approval was successful or not
93     function approve(address _spender, uint256 _value) public returns (bool success);
94 
95     /// @param _owner The address of the account owning tokens
96     /// @param _spender The address of the account able to transfer the tokens
97     /// @return Amount of remaining tokens allowed to spent
98     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
99 
100     // solhint-disable-next-line no-simple-event-func-name  
101     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
102     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
103 }
104 
105 
106 contract FIND is EIP20Interface, Pausable {
107 
108     uint256 constant private MAX_UINT256 = 2**256 - 1;
109     mapping (address => uint256) public balances;
110     mapping (address => mapping (address => uint256)) public allowed;
111     /*
112     NOTE:
113     The following variables are OPTIONAL vanities. One does not have to include them.
114     They allow one to customise the token contract & in no way influences the core functionality.
115     Some wallets/interfaces might not even bother to look at this information.
116     */
117     string public name;                   //fancy name: eg Simon Bucks
118     uint8 public decimals;                //How many decimals to show.
119     string public symbol;                 //An identifier: eg SBX
120 
121     function FIND() public {
122         totalSupply = (10 ** 8 * 1000) * (10 ** 18);                        // Update total supply
123         balances[msg.sender] = (10 ** 8 * 1000) * (10 ** 18);               // Give the creator all initial tokens
124         name = 'FIND Token';                                            // Set the name for display purposes
125         decimals = 18;                                                   // Amount of decimals for display purposes
126         symbol = 'FIND';                                                  // Set the symbol for display purposes
127     }
128 
129     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool success) {
130         require(balances[msg.sender] >= _value);
131         require(balances[_to] + _value >= balances[_to]);
132         balances[msg.sender] -= _value;
133         balances[_to] += _value;
134         Transfer(msg.sender, _to, _value);
135         return true;
136     }
137 
138     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool success) {
139         uint256 allowance = allowed[_from][msg.sender];
140         require(balances[_from] >= _value && allowance >= _value);
141         require(balances[_to] + _value >= balances[_to]);
142         balances[_to] += _value;
143         balances[_from] -= _value;
144         if (allowance < MAX_UINT256) {
145             allowed[_from][msg.sender] -= _value;
146         }
147         Transfer(_from, _to, _value);
148         return true;
149     }
150 
151     function balanceOf(address _owner) public view returns (uint256 balance) {
152         return balances[_owner];
153     }
154 
155     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool success) {
156         allowed[msg.sender][_spender] = _value;
157         Approval(msg.sender, _spender, _value);
158         return true;
159     }
160 
161     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
162         return allowed[_owner][_spender];
163     }   
164 }