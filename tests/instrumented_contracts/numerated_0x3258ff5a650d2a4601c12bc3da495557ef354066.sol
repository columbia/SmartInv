1 pragma solidity ^0.4.24;
2 
3 /*
4 You should inherit from TokenBase. This implements ONLY the standard functions obeys ERC20,
5 and NOTHING else. If you deploy this, you won't have anything useful.
6 
7 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
8 .*/
9 
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     uint256 c = a * b;
13     assert(a == 0 || c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 contract ERC20 {
37 
38     /// total amount of tokens
39     uint256 public totalSupply;
40 
41     /// @param _owner The address from which the balance will be retrieved
42     /// @return The balance
43     function balanceOf(address _owner) constant public returns (uint256 balance);
44 
45     /// @notice send `_value` token to `_to` from `msg.sender`
46     /// @param _to The address of the recipient
47     /// @param _value The amount of token to be transferred
48     /// @return Whether the transfer was successful or not
49     function transfer(address _to, uint256 _value) public returns (bool success);
50 
51     event Transfer(address indexed _from, address indexed _to, uint256 _value);
52 }
53 
54 contract BasicToken is ERC20 {
55     using SafeMath for uint;
56 
57     mapping (address => uint256) balances; /// balance amount of tokens for address
58 
59     function transfer(address _to, uint256 _value) public returns (bool success) {
60         // Prevent transfer to 0x0 address.
61         require(_to != 0x0);
62         // Check if the sender has enough
63         require(balances[msg.sender] >= _value);
64         // Check for overflows
65         require(balances[_to].add(_value) > balances[_to]);
66 
67         uint previousBalances = balances[msg.sender].add(balances[_to]);
68         balances[msg.sender] = balances[msg.sender].sub(_value);
69         balances[_to] = balances[_to].add(_value);
70 
71         emit Transfer(msg.sender, _to, _value);
72 
73         // Asserts are used to use static analysis to find bugs in your code. They should never fail
74         assert(balances[msg.sender].add(balances[_to]) == previousBalances);
75 
76         return true;
77     }
78 
79     function balanceOf(address _owner) constant public returns (uint256 balance) {
80         return balances[_owner];
81     }
82 }
83 
84 contract BAIC is BasicToken {
85 
86     function () payable public {
87         //if ether is sent to this address, send it back.
88         //throw;
89         require(false);
90     }
91 
92     string public constant name = "BAIC";
93     string public constant symbol = "BAIC";
94     uint256 private constant _INITIAL_SUPPLY = 21000000000;
95     uint8 public decimals = 18;
96     uint256 public totalSupply;
97     string public version = "BAIC 1.0";
98 
99     constructor() public {
100         // init
101         totalSupply = _INITIAL_SUPPLY * 10 ** 18;
102         balances[msg.sender] = totalSupply;
103     }
104 }