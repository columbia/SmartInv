1 pragma solidity 0.5.8;
2 /**
3  * @title SafeMath
4  * @dev Unsigned math operations with safety checks that revert on error.
5  */
6 library SafeMath {
7     /**
8      * @dev Returns the addition of two unsigned integers, reverting on
9      * overflow.
10      */
11     function add(uint256 a, uint256 b) internal pure returns(uint256) {
12         uint256 c = a + b;
13         require(c >= a, "SafeMath: addition overflow");
14         return c;
15     }
16 
17     /**
18      * @dev Returns the subtraction of two unsigned integers, reverting on
19      * overflow (when the result is negative).
20      */
21     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
22         require(b <= a, "SafeMath: subtraction overflow");
23         uint256 c = a - b;
24         return c;
25     }
26 }
27 
28 /**
29  * @title Owner parameters
30  * @dev Define ownership parameters for this contract
31  */
32 contract Owned { //This token contract is owned
33     address public owner; //Owner address is public
34     bool public lockSupply; //Supply Lock flag
35 
36     /**
37      * @dev Contract constructor, define initial administrator
38      */
39     constructor() internal {
40         owner = 0xA0c6f96035d0FA5F44D781060F84A0Bc6B8D87Ee; //Set initial owner to contract creator
41         emit TransferOwnership(owner);
42     }
43 
44     modifier onlyOwner() { //A modifier to define owner-only functions
45         require(msg.sender == owner, "Not Allowed");
46         _;
47     }
48 
49     modifier supplyLock() { //A modifier to lock supply-change transactions
50         require(lockSupply == false, "Supply is locked");
51         _;
52     }
53 
54     /**
55      * @dev Function to set new owner address
56      * @param _newOwner The address to transfer administration to
57      */
58     function transferAdminship(address _newOwner) public onlyOwner { //Owner can be transfered
59         require(_newOwner != address(0), "Not allowed");
60         owner = _newOwner;
61         emit TransferOwnership(owner);
62     }
63 
64     /**
65      * @dev Function to set supply locks
66      * @param _set boolean flag (true | false)
67      */
68     function setSupplyLock(bool _set) public onlyOwner { //Only the owner can set a lock on supply
69         lockSupply = _set;
70         emit SetSupplyLock(lockSupply);
71     }
72 
73     //All owner actions have a log for public review
74     event SetSupplyLock(bool _set);
75     event TransferOwnership(address indexed newAdminister);
76 }
77 
78 /**
79  * Token contract interface
80  */
81 contract ERC20TokenInterface {
82     function balanceOf(address _owner) public view returns(uint256 value);
83     function transfer(address _to, uint256 _value) public returns(bool success);
84     function transferFrom(address _from, address _to, uint256 _value) public returns(bool success);
85     function approve(address _spender, uint256 _value) public returns(bool success);
86     function allowance(address _owner, address _spender) public view returns(uint256 remaining);
87 }
88 
89 /**
90  * @title Token definition
91  * @dev Define token parameters, including ERC20 ones
92  */
93 contract ERC20Token is Owned, ERC20TokenInterface {
94     using SafeMath for uint256;
95     uint256 public totalSupply;
96     mapping(address => uint256) balances; //A mapping of all balances per address
97     mapping(address => mapping(address => uint256)) allowed; //A mapping of all allowances
98 
99     /**
100      * @dev Get the balance of an specified address.
101      * @param _owner The address to be query.
102      */
103     function balanceOf(address _owner) public view returns(uint256 value) {
104         return balances[_owner];
105     }
106 
107     /**
108      * @dev transfer token to a specified address
109      * @param _to The address to transfer to.
110      * @param _value The amount to be transferred.
111      */
112     function transfer(address _to, uint256 _value) public returns(bool success) {
113         balances[msg.sender] = balances[msg.sender].sub(_value);
114         balances[_to] = balances[_to].add(_value);
115         emit Transfer(msg.sender, _to, _value);
116         return true;
117     }
118 
119     /**
120      * @dev transfer token from an address to another specified address using allowance
121      * @param _from The address where token comes.
122      * @param _to The address to transfer to.
123      * @param _value The amount to be transferred.
124      */
125     function transferFrom(address _from, address _to, uint256 _value) public returns(bool success) {
126         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
127         balances[_from] = balances[_from].sub(_value);
128         balances[_to] = balances[_to].add(_value);
129         emit Transfer(_from, _to, _value);
130         return true;
131     }
132 
133     /**
134      * @dev Assign allowance to an specified address to use the owner balance
135      * @param _spender The address to be allowed to spend.
136      * @param _value The amount to be allowed.
137      */
138     function approve(address _spender, uint256 _value) public returns(bool success) {
139         allowed[msg.sender][_spender] = _value;
140         emit Approval(msg.sender, _spender, _value);
141         return true;
142     }
143 
144     /**
145      * @dev Get the allowance of an specified address to use another address balance.
146      * @param _owner The address of the owner of the tokens.
147      * @param _spender The address of the allowed spender.
148      */
149     function allowance(address _owner, address _spender) public view returns(uint256 remaining) {
150         return allowed[_owner][_spender];
151     }
152 
153     /**
154      * @dev Burn token of an specified address.
155      * @param _value amount to burn.
156      */
157     function burnTokens(uint256 _value) public onlyOwner {
158         balances[msg.sender] = balances[msg.sender].sub(_value);
159         totalSupply = totalSupply.sub(_value);
160 
161         emit Transfer(msg.sender, address(0), _value);
162         emit Burned(msg.sender, _value);
163     }
164 
165     /**
166      * @dev Log Events
167      */
168     event Transfer(address indexed _from, address indexed _to, uint256 _value);
169     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
170     event Burned(address indexed _target, uint256 _value);
171 }
172 
173 /**
174  * @title Asset
175  * @dev Initial supply creation
176  */
177 contract Asset is ERC20Token {
178     string public name = 'Orionix';
179     uint8 public decimals = 18;
180     string public symbol = 'ORX';
181     string public version = '2';
182 
183     constructor() public {
184         totalSupply = 600000000 * (10 ** uint256(decimals)); //initial token creation
185         balances[0xA0c6f96035d0FA5F44D781060F84A0Bc6B8D87Ee] = totalSupply;
186         emit Transfer(
187             address(0),
188             0xA0c6f96035d0FA5F44D781060F84A0Bc6B8D87Ee,
189             balances[0xA0c6f96035d0FA5F44D781060F84A0Bc6B8D87Ee]);
190     }
191 
192     /**
193      *@dev Function to handle callback calls
194      */
195     function () external {
196         revert("This contract cannot receive direct payments or fallback calls");
197     }
198 
199 }