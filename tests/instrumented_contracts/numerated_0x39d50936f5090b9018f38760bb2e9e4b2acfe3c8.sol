1 pragma solidity ^0.4.19;
2 
3 library SafeMath {
4     /**
5     * @dev Multiplies two numbers, throws on overflow.
6     */
7     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
8         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
9         // benefit is lost if 'b' is also tested.
10         // See: https://github.com/OpenZeppelin/openzeppelin- solidity/pull/522
11         if (a == 0) {
12             return 0; 
13         }
14         c = a * b;
15         assert(c / a == b);
16         return c;
17     }
18     /**
19     * @dev Integer division of two numbers, truncating the quotient. 
20     */
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b > 0);
23         // uint256 c = a / b;
24         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25         return a / b; 
26     }
27     /**
28     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29     */
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31            assert(b <= a);
32            return a - b; 
33     }
34     /**
35     * @dev Adds two numbers, throws on overflow.
36     */
37     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
38            c = a + b;
39            assert(c >= a);
40            return c; 
41     }
42 }
43 contract Token {
44 
45     /// @return total amount of tokens
46     function totalSupply() public constant returns (uint supply);
47 
48     /// @param _owner The address from which the balance will be retrieved
49     /// @return The balance
50     function balanceOf(address _owner) public constant returns (uint balance);
51 
52     /// @notice send `_value` token to `_to` from `msg.sender`
53     /// @param _to The address of the recipient
54     /// @param _value The amount of token to be transferred
55     /// @return Whether the transfer was successful or not
56     function transfer(address _to, uint _value) public  returns (bool success);
57 
58     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
59     /// @param _from The address of the sender
60     /// @param _to The address of the recipient
61     /// @param _value The amount of token to be transferred
62     /// @return Whether the transfer was successful or not
63     function transferFrom(address _from, address _to, uint _value)  public  returns (bool success);
64 
65     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
66     /// @param _spender The address of the account able to transfer the tokens
67     /// @param _value The amount of wei to be approved for transfer
68     /// @return Whether the approval was successful or not
69     function approve(address _spender, uint _value) public  returns (bool success);
70 
71     /// @param _owner The address of the account owning tokens
72     /// @param _spender The address of the account able to transfer the tokens
73     /// @return Amount of remaining tokens allowed to spent
74     function allowance(address _owner, address _spender) public  constant returns (uint remaining);
75 
76     event Transfer(address indexed _from, address indexed _to, uint _value);
77     event Approval(address indexed _owner, address indexed _spender, uint _value);
78 }
79 
80 contract RegularToken is Token {
81     
82     using SafeMath for uint256;
83     
84     function transfer(address _to, uint _value)  public   returns (bool) {
85         //Default assumes totalSupply can't be over max (2^256 - 1).
86         require(balances[msg.sender] >= _value);
87         balances[msg.sender] =  balances[msg.sender].sub(_value);
88         balances[_to] = balances[_to].add(_value);
89         Transfer(msg.sender, _to, _value);
90         return true;
91     }
92 
93     function transferFrom(address _from, address _to, uint _value)  public  returns (bool) {
94         require(balances[_from] >= _value);
95         require(allowed[_from][msg.sender] >= _value);
96         
97         balances[_to] = balances[_to].add(_value);
98         balances[_from] = balances[_from].sub(_value);
99         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
100         Transfer(_from, _to, _value);
101         return true;
102     }
103 
104     function balanceOf(address _owner)  public  constant returns (uint) {
105         return balances[_owner];
106     }
107 
108     function approve(address _spender, uint _value) public  returns (bool) {
109         allowed[msg.sender][_spender] = _value;
110         Approval(msg.sender, _spender, _value);
111         return true;
112     }
113 
114     function allowance(address _owner, address _spender) public  constant returns (uint) {
115         return allowed[_owner][_spender];
116     }
117 
118     mapping (address => uint) balances;
119     mapping (address => mapping (address => uint)) allowed;
120     uint public totalSupply;
121 
122     function totalSupply() public constant returns (uint supply) { 
123         return totalSupply;
124     }
125 }
126 
127 contract UnboundedRegularToken is RegularToken {
128 
129     uint constant MAX_UINT = 2**256 - 1;
130     
131     /// @dev ERC20 transferFrom, modified such that an allowance of MAX_UINT represents an unlimited amount.
132     /// @param _from Address to transfer from.
133     /// @param _to Address to transfer to.
134     /// @param _value Amount to transfer.
135     /// @return Success of transfer.
136     function transferFrom(address _from, address _to, uint _value)
137         public
138         returns (bool)
139     {
140         uint allowance = allowed[_from][msg.sender];
141         
142         require(balances[_from] >= _value);
143         require(allowance >= _value);
144         
145         balances[_to] = balances[_to].add(_value);
146         balances[_from] = balances[_from].sub(_value);
147         if (allowance < MAX_UINT) {
148             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
149         }
150         Transfer(_from, _to, _value);
151         return true;
152     }
153 }
154 
155 contract Lend0xDefiToken is UnboundedRegularToken {
156     
157     uint8 constant public decimals = 18;
158     string constant public name = "Lend0xDefiToken";
159     string constant public symbol = "LDF";
160 
161     function Lend0xDefiToken() public  {
162         totalSupply = 40*10**26;
163         balances[msg.sender] = totalSupply;
164         Transfer(address(0), msg.sender, totalSupply);
165     }
166 }