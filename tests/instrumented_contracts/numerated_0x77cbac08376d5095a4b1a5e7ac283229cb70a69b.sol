1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 contract EIP20Interface {
53     
54     /* This is a slight change to the ERC20 base standard.
55     function totalSupply() constant returns (uint256 supply);
56     is replaced with:
57     uint256 public totalSupply;
58     This automatically creates a getter function for the totalSupply.
59     This is moved to the base contract since public getter functions are not
60     currently recognised as an implementation of the matching abstract
61     function by the compiler.
62     */
63     /// total amount of tokens
64     uint256 public totalSupply;
65 
66     /// @param _owner The address from which the balance will be retrieved
67     /// @return The balance
68     function balanceOf(address _owner) public view returns (uint256 balance);
69 
70     /// @notice send `_value` token to `_to` from `msg.sender`
71     /// @param _to The address of the recipient
72     /// @param _value The amount of token to be transferred
73     /// @return Whether the transfer was successful or not
74     function transfer(address _to, uint256 _value) public returns (bool success);
75 
76     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
77     /// @param _from The address of the sender
78     /// @param _to The address of the recipient
79     /// @param _value The amount of token to be transferred
80     /// @return Whether the transfer was successful or not
81     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
82 
83     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
84     /// @param _spender The address of the account able to transfer the tokens
85     /// @param _value The amount of tokens to be approved for transfer
86     /// @return Whether the approval was successful or not
87     function approve(address _spender, uint256 _value) public returns (bool success);
88 
89     /// @param _owner The address of the account owning tokens
90     /// @param _spender The address of the account able to transfer the tokens
91     /// @return Amount of remaining tokens allowed to spent
92     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
93 
94     // solhint-disable-next-line no-simple-event-func-name
95     event Transfer(address indexed _from, address indexed _to, uint256 _value);
96     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
97 }
98 contract EIP20 is EIP20Interface {
99     using SafeMath for uint256;		
100  
101     mapping (address => uint256) public balances;
102     mapping (address => mapping (address => uint256)) public allowed;
103     /*
104     NOTE:
105     The following variables are OPTIONAL vanities. One does not have to include them.
106     They allow one to customise the token contract & in no way influences the core functionality.
107     Some wallets/interfaces might not even bother to look at this information.
108     */
109     string public name;                   //fancy name: eg Simon Bucks
110     uint8 public decimals;                //How many decimals to show.
111     string public symbol;                 //An identifier: eg SBX
112 
113      
114 
115     function transfer(address _to, uint256 _value) public returns (bool success) {
116         require(_to != address(0));
117         require(_value <= balances[msg.sender]);
118 
119         balances[msg.sender] = balances[msg.sender].sub(_value);
120         balances[_to] = balances[_to].add(_value);
121         emit Transfer(msg.sender, _to, _value);
122         return true;
123     }
124 
125     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
126         require(_to != address(0));
127         require(_value <= balances[_from]);
128         require(_value <= allowed[_from][msg.sender]);
129 
130         balances[_from] = balances[_from].sub(_value);
131         balances[_to] = balances[_to].add(_value);
132         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
133         emit Transfer(_from, _to, _value);
134         return true;
135     }
136 
137     function balanceOf(address _owner) public view returns (uint256 balance) {
138         return balances[_owner];
139     }
140 
141     function approve(address _spender, uint256 _value) public returns (bool success) {
142         allowed[msg.sender][_spender] = _value;
143         emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
144         return true;
145     }
146 
147     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
148         return allowed[_owner][_spender];
149     }
150 }
151 
152 contract BCBToken is EIP20 {
153 	constructor() public {
154 	    totalSupply = 100000000000* 10**18;               // Update total supply
155 	    balances[msg.sender] = totalSupply;               // Give the creator all initial tokens
156       name = "Gambling Coin";                           // Set the name for display purposes
157       decimals = 18;                                    // Amount of decimals for display purposes
158       symbol = "BCB";                                   // Set the symbol for display purposes	
159 	}
160 }