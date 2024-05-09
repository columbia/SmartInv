1 pragma solidity 0.5.7;
2 /**
3  * Cycle TOKEN Contract
4  * ERC-20 Token Standard Compliant
5  */
6 
7 /**
8  * @title SafeMath by OpenZeppelin
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12 
13     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
14         assert(b <= a);
15         return a - b;
16     }
17 
18     function add(uint256 a, uint256 b) internal pure returns(uint256) {
19         uint256 c = a + b;
20         assert(c >= a);
21         return c;
22     }
23 
24 }
25 
26 /**
27  * @title ERC20 Token minimal interface
28  */
29 contract token {
30 
31     function balanceOf(address _owner) public view returns(uint256 balance);
32     //Since some tokens doesn't return a bool on transfer, this general interface
33     //doesn't include a return on the transfer fucntion to be widely compatible
34     function transfer(address _to, uint256 _value) public;
35 
36 }
37 
38 /**
39  * Token contract interface for external use
40  */
41 contract ERC20TokenInterface {
42 
43     function balanceOf(address _owner) public view returns(uint256 value);
44 
45     function transfer(address _to, uint256 _value) public returns(bool success);
46 
47     function transferFrom(address _from, address _to, uint256 _value) public returns(bool success);
48 
49     function approve(address _spender, uint256 _value) public returns(bool success);
50 
51     function allowance(address _owner, address _spender) public view returns(uint256 remaining);
52 
53 }
54 
55 /**
56  * @title Token definition
57  * @dev Define token paramters including ERC20 ones
58  */
59 contract ERC20Token is ERC20TokenInterface { //Standard definition of a ERC20Token
60 
61     using SafeMath for uint256;
62     uint256 public totalSupply;
63     mapping(address => uint256) balances; //A mapping of all balances per address
64     mapping(address => mapping(address => uint256)) allowed; //A mapping of all allowances
65 
66     /**
67      * @dev Get the balance of an specified address.
68      * @param _owner The address to be query.
69      */
70     function balanceOf(address _owner) public view returns(uint256 value) {
71         return balances[_owner];
72     }
73 
74     /**
75      * @dev transfer token to a specified address
76      * @param _to The address to transfer to.
77      * @param _value The amount to be transferred.
78      */
79     function transfer(address _to, uint256 _value) public returns(bool success) {
80         require(_to != address(0)); //If you dont want that people destroy token
81         balances[msg.sender] = balances[msg.sender].sub(_value);
82         balances[_to] = balances[_to].add(_value);
83         emit Transfer(msg.sender, _to, _value);
84         return true;
85     }
86 
87     /**
88      * @dev transfer token from an address to another specified address using allowance
89      * @param _from The address where token comes.
90      * @param _to The address to transfer to.
91      * @param _value The amount to be transferred.
92      */
93     function transferFrom(address _from, address _to, uint256 _value) public returns(bool success) {
94         require(_to != address(0)); //If you dont want that people destroy token
95         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
96         balances[_from] = balances[_from].sub(_value);
97         balances[_to] = balances[_to].add(_value);
98         emit Transfer(_from, _to, _value);
99         return true;
100     }
101 
102     /**
103      * @dev Assign allowance to an specified address to use the owner balance
104      * @param _spender The address to be allowed to spend.
105      * @param _value The amount to be allowed.
106      */
107     function approve(address _spender, uint256 _value) public returns(bool success) {
108         allowed[msg.sender][_spender] = _value;
109         emit Approval(msg.sender, _spender, _value);
110         return true;
111     }
112 
113     /**
114      * @dev Get the allowance of an specified address to use another address balance.
115      * @param _owner The address of the owner of the tokens.
116      * @param _spender The address of the allowed spender.
117      */
118     function allowance(address _owner, address _spender) public view returns(uint256 remaining) {
119         return allowed[_owner][_spender];
120     }
121 
122 
123 
124     /**
125      * @dev Log Events
126      */
127     event Transfer(address indexed _from, address indexed _to, uint256 _value);
128     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
129 }
130 
131 /**
132  * @title Asset
133  * @dev Initial supply creation
134  */
135 contract Asset is ERC20Token {
136 
137     string public name = 'Cycle';
138     uint8 public decimals = 8;
139     string public symbol = 'CYCLE';
140     string public version = '1';
141     address public owner; //owner address is public
142 
143     constructor(uint initialSupply, address initialOwner) public {
144         owner = initialOwner;
145         totalSupply = initialSupply * (10 ** uint256(decimals)); //initial token creation
146         balances[owner] = totalSupply;
147         emit Transfer(address(0), owner, balances[owner]);
148     }
149 
150     /**
151      * @notice Function to recover ANY token stuck on contract accidentally
152      * In case of recover of stuck tokens please contact contract owners
153      */
154     function recoverTokens(token _address, address _to) public {
155         require(msg.sender == owner);
156         require(_to != address(0));
157         uint256 remainder = _address.balanceOf(address(this)); //Check remainder tokens
158         _address.transfer(_to, remainder); //Transfer tokens to creator
159     }
160 
161     function changeOwner(address newOwner) external {
162         require(msg.sender == owner);
163         require(newOwner != address(0));
164         owner = newOwner;
165     }
166 
167     /**
168      *@dev Function to handle callback calls
169      */
170     function () external {
171         revert();
172     }
173 
174 }