1 pragma solidity ^0.5.4;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract ERC20 {
30 
31     /// total amount of tokens
32     uint256 public totalSupply;
33 
34     /// @param _owner The address from which the balance will be retrieved
35     /// @return The balance
36     function balanceOf(address _owner) view public returns (uint256 balance);
37 
38     /// @notice send `_value` token to `_to` from `msg.sender`
39     /// @param _to The address of the recipient
40     /// @param _value The amount of token to be transferred
41     /// @return Whether the transfer was successful or not
42     function transfer(address _to, uint256 _value) public returns (bool success);
43 
44     event Transfer(address indexed _from, address indexed _to, uint256 _value);
45 }
46 
47 contract BasicToken is ERC20 {
48     using SafeMath for uint;
49 
50     mapping (address => uint256) balances; /// balance amount of tokens for address
51 
52     function transfer(address _to, uint256 _value) public returns (bool success) {
53         // Prevent transfer to 0x0 address.
54         require(_to != address(0x0));
55         // Check if the sender has enough
56         require(balances[msg.sender] >= _value);
57         // Check for overflows
58         require(balances[_to].add(_value) > balances[_to]);
59 
60         uint previousBalances = balances[msg.sender].add(balances[_to]);
61         balances[msg.sender] = balances[msg.sender].sub(_value);
62         balances[_to] = balances[_to].add(_value);
63 
64         emit Transfer(msg.sender, _to, _value);
65 
66         // Asserts are used to use static analysis to find bugs in your code. They should never fail
67         assert(balances[msg.sender].add(balances[_to]) == previousBalances);
68 
69         return true;
70     }
71 
72     function balanceOf(address _owner) view public returns (uint256 balance) {
73         return balances[_owner];
74     }
75 }
76 
77 contract WEED is BasicToken {
78 
79     function () external payable {
80         //if ether is sent to this address, send it back.
81         //throw;
82         require(false);
83     }
84 
85     string public constant name = "WEED";
86     string public constant symbol = "WEED";
87     uint256 private constant _INITIAL_SUPPLY = 400000000;
88     uint8 public decimals = 9;
89     uint256 public totalSupply;
90     string public version = "WEED 1.0";
91 
92     string public agreement = "https://www.tenjove.com/weed/subscriptionagreement.txt";
93     string public disclaimer = "https://etherscan.io/tx/0xa35e89443df2abbe4f62dfc213b7cd98d5d5922c24a581a339857cf6255356dd";
94 
95     constructor() public {
96         // init
97         totalSupply = _INITIAL_SUPPLY * 10 ** uint256(decimals);
98         balances[msg.sender] = totalSupply;
99     }
100 }