1 pragma solidity ^0.4.18;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that revert on error
5  */
6 library SafeMath {
7 
8   /**
9   * @dev Multiplies two numbers, reverts on overflow.
10   */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13     // benefit is lost if 'b' is also tested.
14     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15     if (a == 0) {
16       return 0;
17     }
18 
19     uint256 c = a * b;
20     require(c / a == b);
21 
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     require(b > 0); // Solidity only automatically asserts when dividing by 0
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32 
33     return c;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     require(b <= a);
41     uint256 c = a - b;
42 
43     return c;
44   }
45 
46   /**
47   * @dev Adds two numbers, reverts on overflow.
48   */
49   function add(uint256 a, uint256 b) internal pure returns (uint256) {
50     uint256 c = a + b;
51     require(c >= a);
52 
53     return c;
54   }
55 
56   /**
57   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
58   * reverts when dividing by zero.
59   */
60   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
61     require(b != 0);
62     return a % b;
63   }
64 }
65 
66 /**
67  * Token
68  *
69  * @title A fixed supply ERC-20 token.
70  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
71  */
72 contract Token {
73     using SafeMath for uint;
74     event Transfer(
75         address indexed _from,
76         address indexed _to,
77         uint256 _value
78     );
79     event Approval(
80         address indexed _owner,
81         address indexed _spender,
82         uint256 _value
83     );
84     string public symbol;
85     string public name;
86     uint8 public decimals;
87     uint public totalSupply;
88     mapping(address => uint) balances;
89     mapping(address => mapping(address => uint)) allowed;
90     /**
91      * Constructs the Token contract and gives all of the supply to the address
92      *     that deployed it. The fixed supply is 1 billion tokens with up to 18
93      *     decimal places.
94      */
95     function Token() public {
96         symbol = 'SET1';
97         name = 'SAVE ENVIRONMENT TOKEN1';
98         decimals = 18;
99         totalSupply = 55000000000000000000000000;
100         balances[msg.sender] = totalSupply;
101         Transfer(address(0), msg.sender, totalSupply);
102     }
103     /**
104      * @dev Fallback function
105      */
106     function() public payable { revert(); }
107     /**
108      * Gets the token balance of any wallet.
109      * @param _owner Wallet address of the returned token balance.
110      * @return The balance of tokens in the wallet.
111      */
112     function balanceOf(address _owner)
113         public
114         constant
115         returns (uint balance)
116     {
117         return balances[_owner];
118     }
119     /**
120      * Transfers tokens from the sender's wallet to the specified `_to` wallet.
121      * @param _to Address of the transfer's recipient.
122      * @param _value Number of tokens to transfer.
123      * @return True if the transfer succeeded.
124      */
125     function transfer(address _to, uint _value) public returns (bool success) {
126         balances[msg.sender] = balances[msg.sender].sub(_value);
127         balances[_to] = balances[_to].add(_value);
128         Transfer(msg.sender, _to, _value);
129         return true;
130     }
131     /**
132      * Transfer tokens from any wallet to the `_to` wallet. This only works if
133      *     the `_from` wallet has already allocated tokens for the caller wallet
134      *     using `approve`. The from wallet must have sufficient balance to
135      *     transfer. The caller must have sufficient allowance to transfer.
136      * @param _from Wallet address that tokens are withdrawn from.
137      * @param _to Wallet address that tokens are deposited to.
138      * @param _value Number of tokens transacted.
139      * @return True if the transfer succeeded.
140      */
141     function transferFrom(address _from, address _to, uint _value)
142         public
143         returns (bool success)
144     {
145         balances[_from] = balances[_from].sub(_value);
146         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
147         balances[_to] = balances[_to].add(_value);
148         Transfer(_from, _to, _value);
149         return true;
150     }
151     /**
152      * Sender allows another wallet to `transferFrom` tokens from their wallet.
153      * @param _spender Address of `transferFrom` recipient.
154      * @param _value Number of tokens to `transferFrom`.
155      * @return True if the approval succeeded.
156      */
157     function approve(address _spender, uint _value)
158         public
159         returns (bool success)
160     {
161         allowed[msg.sender][_spender] = _value;
162         Approval(msg.sender, _spender, _value);
163         return true;
164     }
165     /**
166      * Gets the number of tokens that an `_owner` has approved for a _spender
167      *     to `transferFrom`.
168      * @param _owner Wallet address that tokens can be withdrawn from.
169      * @param _spender Wallet address that tokens can be deposited to.
170      * @return The number of tokens allowed to be transferred.
171      */
172     function allowance(address _owner, address _spender)
173         public
174         constant
175         returns (uint remaining)
176     {
177         return allowed[_owner][_spender];
178     }
179 }