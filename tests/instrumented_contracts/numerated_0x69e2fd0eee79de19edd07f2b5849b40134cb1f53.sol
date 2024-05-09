1 pragma solidity ^0.4.24;
2 
3 // File: browser/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 // File: browser/jimbolia.sol
56 
57 /**
58  * Jimbolia
59  *
60  * @title A fixed supply ERC-20 token.
61  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
62  */
63 contract JimboliaT {
64     using SafeMath for uint;
65     event Transfer(
66         address indexed _from,
67         address indexed _to,
68         uint256 _value
69     );
70     event Approval(
71         address indexed _owner,
72         address indexed _spender,
73         uint256 _value
74     );
75     string public symbol;
76     string public name;
77     uint8 public decimals;
78     uint public totalSupply;
79     mapping(address => uint) balances;
80     mapping(address => mapping(address => uint)) allowed;
81     /**
82      * Constructs the Token contract and gives all of the supply to the address
83      *     that deployed it. The fixed supply is 1 billion tokens with up to 18
84      *     decimal places.
85      */
86     function Token() public {
87         symbol = 'JIT';
88         name = 'Jimbolia Token';
89         decimals = 18;
90         totalSupply = 20000 * 10**uint(decimals);
91         balances[msg.sender] = totalSupply;
92         Transfer(address(0), msg.sender, totalSupply);
93     }
94     /**
95      * @dev Fallback function
96      */
97     function() public payable { revert(); }
98     /**
99      * Gets the token balance of any wallet.
100      * @param _owner Wallet address of the returned token balance.
101      * @return The balance of tokens in the wallet.
102      */
103     function balanceOf(address _owner)
104         public
105         constant
106         returns (uint balance)
107     {
108         return balances[_owner];
109     }
110     /**
111      * Transfers tokens from the sender's wallet to the specified `_to` wallet.
112      * @param _to Address of the transfer's recipient.
113      * @param _value Number of tokens to transfer.
114      * @return True if the transfer succeeded.
115      */
116     function transfer(address _to, uint _value) public returns (bool success) {
117         balances[msg.sender] = balances[msg.sender].sub(_value);
118         balances[_to] = balances[_to].add(_value);
119         Transfer(msg.sender, _to, _value);
120         return true;
121     }
122     /**
123      * Transfer tokens from any wallet to the `_to` wallet. This only works if
124      *     the `_from` wallet has already allocated tokens for the caller wallet
125      *     using `approve`. The from wallet must have sufficient balance to
126      *     transfer. The caller must have sufficient allowance to transfer.
127      * @param _from Wallet address that tokens are withdrawn from.
128      * @param _to Wallet address that tokens are deposited to.
129      * @param _value Number of tokens transacted.
130      * @return True if the transfer succeeded.
131      */
132     function transferFrom(address _from, address _to, uint _value)
133         public
134         returns (bool success)
135     {
136         balances[_from] = balances[_from].sub(_value);
137         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
138         balances[_to] = balances[_to].add(_value);
139         Transfer(_from, _to, _value);
140         return true;
141     }
142     /**
143      * Sender allows another wallet to `transferFrom` tokens from their wallet.
144      * @param _spender Address of `transferFrom` recipient.
145      * @param _value Number of tokens to `transferFrom`.
146      * @return True if the approval succeeded.
147      */
148     function approve(address _spender, uint _value)
149         public
150         returns (bool success)
151     {
152         allowed[msg.sender][_spender] = _value;
153         Approval(msg.sender, _spender, _value);
154         return true;
155     }
156     /**
157      * Gets the number of tokens that an `_owner` has approved for a _spender
158      *     to `transferFrom`.
159      * @param _owner Wallet address that tokens can be withdrawn from.
160      * @param _spender Wallet address that tokens can be deposited to.
161      * @return The number of tokens allowed to be transferred.
162      */
163     function allowance(address _owner, address _spender)
164         public
165         constant
166         returns (uint remaining)
167     {
168         return allowed[_owner][_spender];
169     }
170 }