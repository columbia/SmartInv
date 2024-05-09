1 pragma solidity ^0.4.24;
2 
3 contract Owned {
4     
5     /// 'owner' is the only address that can call a function with 
6     /// this modifier
7     address public initOwner;
8     address[] public owner;
9     address internal newOwner;
10     
11     ///@notice The constructor assigns the message sender to be 'owner'
12     constructor() public {
13         initOwner = msg.sender;
14         owner.push(msg.sender);
15     }
16     
17     modifier onlyInitOwner() {
18         require (msg.sender == initOwner);
19         _;
20     }
21     
22     modifier onlyOwners(address _owner) {
23         bool _isOwner;
24         for (uint i=0; i<owner.length; i++) {
25             if (owner[i] == _owner) {
26                 _isOwner = true;
27                 break;
28             }
29         }
30         require (_isOwner == true);
31         _;
32     }
33     
34     modifier ownerNotAdded(address _newOwner) {
35         bool _added = false;
36         for (uint i=0;i<owner.length;i++) {
37             if (owner[i] == _newOwner) {
38                 _added = true;
39                 break;
40             }
41         }
42         require (_added == false);
43         _;
44     }
45     
46     modifier ownerAdded(address _newOwner) {
47         bool _added = false;
48         for (uint i=0;i<owner.length;i++) {
49             if (owner[i] == _newOwner) _added = true;
50         }
51         require (_added == true);
52         _;
53     }
54     
55     ///change the owner
56     function addOwner(address _newOwner) public onlyInitOwner ownerNotAdded(_newOwner) returns(bool) {
57         owner.push(_newOwner);
58         return true;
59     }
60     
61     function delOwner(address _addedOwner) public onlyInitOwner ownerAdded(_addedOwner) returns(bool) {
62         for (uint i=0;i<owner.length;i++) {
63             if (owner[i] == _addedOwner) {
64                 owner[i] = owner[owner.length - 1];
65                 owner.length -= 1;
66             }
67         }
68         return true;
69     }
70     
71     function changeInitOwner(address _newOwner) public onlyInitOwner {
72         initOwner = _newOwner;
73     }
74 }
75 
76 library SafeMath {
77 
78   /**
79    * @dev Multiplies two numbers, throws on overflow.
80    */
81   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
82     if (a == 0) {
83       return 0;
84     }
85     c = a * b;
86     assert(c / a == b);
87     return c;
88   }
89 
90   /**
91    * @dev Integer division of two numbers, truncating the quotient.
92    */
93   function div(uint256 a, uint256 b) internal pure returns (uint256) {
94     // assert(b > 0); // Solidity automatically throws when dividing by 0
95     // uint256 c = a / b;
96     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
97     return a / b;
98   }
99 
100   /**
101    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
102    */
103   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
104     assert(b <= a);
105     return a - b;
106   }
107 
108   /**
109    * @dev Adds two numbers, throws on overflow.
110    */
111   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
112     c = a + b;
113     assert(c >= a);
114     return c;
115   }
116 }
117 
118 contract ERC20Token {
119     /* This is a slight change to the ERC20 base standard.
120     function totalSupply() constant returns (uint256 supply);
121     is replaced with:
122     uint256 public totalSupply;
123     This automatically creates a getter function for the totalSupply.
124     This is moved to the base contract since public getter functions are not
125     currently recognised as an implementation of the matching abstract
126     function by the compiler.
127     */
128     /// total amount of tokens
129     uint256 public totalSupply;
130     
131     /// user tokens
132     mapping (address => uint256) public balances;
133     
134     /// @param _owner The address from which the balance will be retrieved
135     /// @return The balance
136     function balanceOf(address _owner) constant public returns (uint256 balance);
137 
138     /// @notice send `_value` token to `_to` from `msg.sender`
139     /// @param _to The address of the recipient
140     /// @param _value The amount of token to be transferred
141     /// @return Whether the transfer was successful or not
142     function transfer(address _to, uint256 _value) public returns (bool success);
143     
144     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
145     /// @param _from The address of the sender
146     /// @param _to The address of the recipient
147     /// @param _value The amount of token to be transferred
148     /// @return Whether the transfer was successful or not
149     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
150 
151     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
152     /// @param _spender The address of the account able to transfer the tokens
153     /// @param _value The amount of tokens to be approved for transfer
154     /// @return Whether the approval was successful or not
155     function approve(address _spender, uint256 _value) public returns (bool success);
156 
157     /// @param _owner The address of the account owning tokens
158     /// @param _spender The address of the account able to transfer the tokens
159     /// @return Amount of remaining tokens allowed to spent
160     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
161 
162     event Transfer(address indexed _from, address indexed _to, uint256 _value);
163     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
164 }
165 
166 contract TxProxy is Owned {
167     
168     uint256 decimals = 18;
169     
170     address public USEAddr = 0xd9485499499d66B175Cf5ED54c0a19f1a6Bcb61A;
171     
172     /// @dev token holder
173     address public allocTokenHolder;
174     
175     /// @dev change token holder
176     function changeTokenHolder(address _tokenHolder) public onlyInitOwner {
177         allocTokenHolder = _tokenHolder;
178     }
179     
180     /// @dev This owner allocate token for candy airdrop
181     /// @param _owners The address of the account that owns the token
182     /// @param _values The amount of tokens
183 	function allocateToken(address[] _owners, uint256[] _values) public onlyOwners(msg.sender) {
184 	   require (_owners.length == _values.length);
185        for(uint i = 0; i < _owners.length ; i++){
186            uint256 value = _values[i] * 10 ** decimals;
187            require(ERC20Token(USEAddr).transferFrom(allocTokenHolder, _owners[i], value) == true);
188         }
189     }
190 }