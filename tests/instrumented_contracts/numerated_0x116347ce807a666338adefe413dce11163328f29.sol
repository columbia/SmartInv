1 pragma solidity ^0.4.11;
2 /*
3 PAXCHANGE TOKEN
4 
5 ERC-20 Token Standar Compliant - ConsenSys
6 
7 Contract developer: Fares A. Akel C.
8 f.antonio.akel@gmail.com
9 MIT PGP KEY ID: 078E41CB
10 */
11 
12 /**
13  * @title SafeMath by OpenZeppelin
14  * @dev Math operations with safety checks that throw on error
15  */
16 library SafeMath {
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 
29 }
30 
31 contract ERC20Token { //Standar definition of a ERC20Token
32     using SafeMath for uint256;
33     mapping (address => uint256) balances; //A mapping of all balances per address
34     mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances
35 
36     /**
37     * @dev Get the balance of an specified address.
38     * @param _owner The address to be query.
39     */
40     function balanceOf(address _owner) public constant returns (uint256 balance) {
41       return balances[_owner];
42     }
43 
44     /**
45     * @dev transfer token to a specified address
46     * @param _to The address to transfer to.
47     * @param _value The amount to be transferred.
48     */
49     function transfer(address _to, uint256 _value) public returns (bool success) {
50         require(_to != address(0)); //If you dont want that people destroy token
51         require(balances[msg.sender] >= _value);
52         balances[msg.sender] = balances[msg.sender].sub(_value);
53         balances[_to] = balances[_to].add(_value);
54         Transfer(msg.sender, _to, _value);
55         return true;
56     }
57     /**
58     * @dev transfer token from an address to another specified address using allowance
59     * @param _from The address where token comes.
60     * @param _to The address to transfer to.
61     * @param _value The amount to be transferred.
62     */
63     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
64         require(_to != address(0)); //If you dont want that people destroy token
65         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
66         balances[_to] = balances[_to].add(_value);
67         balances[_from] = balances[_from].sub(_value);
68         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
69         Transfer(_from, _to, _value);
70         return true;
71     }
72     /**
73     * @dev Assign allowance to an specified address to use the owner balance
74     * @param _spender The address to be allowed to spend.
75     * @param _value The amount to be allowed.
76     */
77     function approve(address _spender, uint256 _value) public returns (bool success) {
78       allowed[msg.sender][_spender] = _value;
79         Approval(msg.sender, _spender, _value);
80         return true;
81     }
82     /**
83     * @dev Get the allowance of an specified address to use another address balance.
84     * @param _owner The address of the owner of the tokens.
85     * @param _spender The address of the allowed spender.
86     */
87     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
88     return allowed[_owner][_spender];
89     }
90     /**
91     *Log Events
92     */
93     event Transfer(address indexed _from, address indexed _to, uint256 _value);
94     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
95 }
96 
97 contract AssetPAXCHANGE is ERC20Token {
98     string public name = 'PAXCHANGE TOKEN';
99     uint8 public decimals = 18;
100     string public symbol = 'PAXCHANGE';
101     string public version = '0.1';
102     uint256 public totalSupply = 50000000 * (10**uint256(decimals));
103 
104     function AssetPAXCHANGE() public {
105         balances[0xFAB6368b0F7be60c573a6562d82469B5ED9e7eE6] = 50000 * (10**uint256(decimals)); //Fixed 0.1% for contract writer
106         balances[this] = 49950000 * (10**uint256(decimals)); //Remaining keep on contract
107         allowed[this][msg.sender] = 49950000 * (10**uint256(decimals)); //Creator has allowance of the rest on the contract
108         /**
109         *Log Events
110         */
111         Transfer(0, this, totalSupply);
112         Transfer(this, 0xFAB6368b0F7be60c573a6562d82469B5ED9e7eE6, 50000 * (10**uint256(decimals)));
113         Approval(this, msg.sender, 49950000 * (10**uint256(decimals)));
114 
115     }
116     /**
117     *@dev Function to handle callback calls
118     */
119     function() public {
120         revert();
121     }
122 
123 }