1 /**
2  *Submitted for verification at Etherscan.io on 2019-01-08
3 */
4 
5 pragma solidity ^0.5.9;
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         if (a == 0) {
14             return 0;
15         }
16         uint256 c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b > 0);
23         uint256 c = a / b;
24         return c;
25     }
26 
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         assert(b <= a);
29         return a - b;
30     }
31 
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         assert(c >= a);
35         return c;
36     }
37 }
38 
39 /**
40  * @title ERC20 interface
41  * @dev see https://github.com/ethereum/EIPs/issues/20
42  */
43 contract ERC20 {
44     uint256 public totalSupply;
45     function balanceOf(address who) public view returns (uint256);
46     function transfer(address to, uint256 value) public returns (bool);
47     function allowance(address owner, address spender) public view returns (uint256);
48     function transferFrom(address from, address to, uint256 value) public returns (bool);
49     function approve(address spender, uint256 value) public returns (bool);
50 
51     event Transfer(address indexed from, address indexed to, uint256 value);
52     event Approval(address indexed owner, address indexed spender, uint256 value);
53 }
54 
55 contract Owned {
56     address public owner;
57 
58     event OwnershipTransferred(address indexed _from, address indexed _to);
59 
60     constructor() public {
61         owner = msg.sender;
62     }
63 
64     modifier onlyOwner {
65         require(msg.sender == owner);
66         _;
67     }
68 
69     function transferOwnership(address _owner) onlyOwner public {
70         require(_owner != address(0));
71 
72         emit OwnershipTransferred(owner, _owner);
73         owner = _owner;
74     }
75 }
76 
77 contract ERC20Token is ERC20, Owned {
78     using SafeMath for uint256;
79 
80     mapping(address => uint256) balances;
81     mapping(address => mapping (address => uint256)) allowed;
82 
83 
84     // True if transfers are allowed
85     bool public transferable = true;
86 
87     modifier canTransfer() {
88         require(transferable == true);
89         _;
90     }
91 
92     function setTransferable(bool _transferable) onlyOwner public {
93         transferable = _transferable;
94     }
95 
96     /**
97      * @dev transfer token for a specified address
98      * @param _to The address to transfer to.
99      * @param _value The amount to be transferred.
100      */
101     function transfer(address _to, uint256 _value) canTransfer public returns (bool) {
102         require(_to != address(0));
103         require(_value <= balances[msg.sender]);
104 
105         balances[msg.sender] = balances[msg.sender].sub(_value);
106         balances[_to] = balances[_to].add(_value);
107         emit Transfer(msg.sender, _to, _value);
108         return true;
109     }
110 
111     /**
112     * @dev Gets the balance of the specified address.
113     * @param _owner The address to query the the balance of.
114         * @return An uint256 representing the amount owned by the passed address.
115         */
116     function balanceOf(address _owner) public view returns (uint256 balance) {
117         return balances[_owner];
118     }
119 
120     /**
121     * @dev Transfer tokens from one address to another
122     * @param _from address The address which you want to send tokens from
123     * @param _to address The address which you want to transfer to
124     * @param _value uint256 the amount of tokens to be transferred
125     */
126     function transferFrom(address _from, address _to, uint256 _value) canTransfer public returns (bool) {
127         require(_to != address(0));
128         require(_value <= balances[_from]);
129         require(_value <= allowed[_from][msg.sender]);
130 
131         balances[_from] = balances[_from].sub(_value);
132         balances[_to] = balances[_to].add(_value);
133         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
134         emit Transfer(_from, _to, _value);
135         return true;
136     }
137 
138     // Allow `_spender` to withdraw from your account, multiple times.
139     function approve(address _spender, uint _value) public returns (bool success) {
140         // To change the approve amount you first have to reduce the addresses`
141         //  allowance to zero by calling `approve(_spender, 0)` if it is not
142         //  already 0 to mitigate the race condition described here:
143         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
144         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) {
145             revert();
146         }
147         allowed[msg.sender][_spender] = _value;
148         emit Approval(msg.sender, _spender, _value);
149         return true;
150     }
151 
152     /**
153      * @dev Function to check the amount of tokens that an owner allowed to a spender.
154      * @param _owner address The address which owns the funds.
155      * @param _spender address The address which will spend the funds.
156      * @return A uint256 specifying the amount of tokens still available for the spender.
157      */
158     function allowance(address _owner, address _spender) public view returns (uint256) {
159         return allowed[_owner][_spender];
160     }
161 
162     function () external payable {
163         revert();
164     }
165 }
166 
167 contract DRF is ERC20Token {
168     string public name = "DragonFruit";
169     string public symbol = "DRF";
170     uint8 public decimals = 18;
171 
172     uint256 public totalSupplyCap = 91 * (10**6) * (10**uint256(decimals));
173 
174     constructor(address _issuer) public {
175         totalSupply = totalSupplyCap;
176         balances[_issuer] = totalSupplyCap;
177         emit Transfer(address(0), _issuer, totalSupplyCap);
178     }
179 }