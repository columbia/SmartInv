1 pragma solidity ^0.4.17;
2 
3 library SafeMath {
4     
5     /**
6      *  Sub function asserts that b is less than or equal to a.
7      * */
8     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
9         assert(b <= a);
10         return a - b;
11     }
12 
13     /**
14     * Add function avoids overflow.
15     * */
16     function add(uint256 a, uint256 b) internal pure returns (uint256) {
17         uint256 c = a + b;
18         assert(c >= a);
19         return c;
20     }
21 }
22 
23 contract ERC20Basic {
24     uint256 public totalSupply;
25     function balanceOf(address who) constant public returns (uint256);
26     function transfer(address to, uint256 value) public returns (bool);
27     event Transfer(address indexed from, address indexed to, uint256 value);
28 }
29 
30 contract ERC20 is ERC20Basic {
31     function allowance(address owner, address spender) constant public returns (uint256);
32     function transferFrom(address from, address to, uint256 value) public  returns (bool);
33     function approve(address spender, uint256 value) public returns (bool);
34     event Approval(address indexed owner, address indexed spender, uint256 value);
35 }
36 
37 contract BasicToken is ERC20Basic {
38 
39     using SafeMath for uint256;
40 
41     //keeps a record of the total balances of each ETH address.
42     mapping (address => uint256) balances;
43 
44     modifier onlyPayloadSize(uint size) {
45         if (msg.data.length < size + 4) {
46         revert();
47         }
48         _;
49     }
50 
51     /**
52      * Transfer function makes it possible for users to transfer their Hire tokens to another
53      * ETH address.
54      * 
55      * @param _to the address of the recipient.
56      * @param _amount the amount of Hire tokens to be sent.
57      * */
58     function transfer(address _to, uint256 _amount) public onlyPayloadSize(2 * 32) returns (bool) {
59         require(balances[msg.sender] >= _amount);
60         balances[msg.sender] = balances[msg.sender].sub(_amount);
61         balances[_to] = balances[_to].add(_amount);
62         Transfer(msg.sender, _to, _amount);
63         return true;
64     }
65 
66     /**
67      * BalanceOf function returns the total balance of the queried address.
68      * 
69      * @param _addr the address which is being queried.
70      * */
71     function balanceOf(address _addr) public constant returns (uint256) {
72         return balances[_addr];
73     }
74 }
75 
76 contract AdvancedToken is BasicToken, ERC20 {
77     
78     //keeps a record of all the allowances from one ETH address to another.
79     mapping (address => mapping (address => uint256)) allowances; 
80     
81     /**
82      * TransferFrom function allows users to spend ETH on another's behalf, given that the _owner
83      * has allowed them to. 
84      * 
85      * @param _from the address of the owner.
86      * @param _to the address of the recipient.
87      * @param _amount the total amount of tokens to be sent. '
88      * */
89     function transferFrom(address _from, address _to, uint256 _amount) public onlyPayloadSize(3 * 32) returns (bool) {
90         require(allowances[_from][msg.sender] >= _amount && balances[_from] >= _amount);
91         allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_amount);
92         balances[_from] = balances[_from].sub(_amount);
93         balances[_to] = balances[_to].add(_amount);
94         Transfer(_from, _to, _amount);
95         return true;
96     }
97 
98     /**
99      * Approve function allows users to allow others to spend a specified amount tokens on
100      * their behalf.
101      * 
102      * @param _spender the address of the spended who is being granted permission to spend tokens.
103      * @param _amount the total amount of tokens the spender is allowed to spend.
104      * */
105     function approve(address _spender, uint256 _amount) public returns (bool) {
106         allowances[msg.sender][_spender] = _amount;
107         Approval(msg.sender, _spender, _amount);
108         return true;
109     }
110 
111     /**
112      * Allowance function returns the total allowance from one address to another.
113      * 
114      * @param _owner the address of the owner of the token.
115      * @param _spender the address of the spender who has or has not been allowed to spend
116      * the owners tokens.
117      * */
118     function allowance(address _owner, address _spender) public constant returns (uint256) {
119         return allowances[_owner][_spender];
120     }
121 
122 }
123 
124 contract Hire is AdvancedToken {
125 
126     uint8 public decimals;
127     string public name;
128     string public symbol;
129     address public owner;
130 
131     /**
132     * Constructor initializes the total supply to 100,000,000, the token name to
133     * Hire, the token symbol to HIRE, sets the decimals to 18 and automatically 
134     * sends all tokens to the owner of the contract upon deployment.
135     * */
136     function Hire() public {
137         totalSupply = 100000000e18;
138         decimals = 18;
139         name = "Hire";
140         symbol = "HIRE";
141         owner = 0xaAa34A22Bd3F496b3A8648367CeeA9c03B130A30;
142         balances[owner] = totalSupply;
143     }
144 }