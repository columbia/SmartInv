1 pragma solidity ^0.5.1;
2 
3 // @title Alluva (ALV) Token Contract
4 // @owner Alluva
5 
6 // @notice Safe Maths Contract to stop over/underflow errors
7 contract SafeMath {
8     // @dev safe addition, reverts if integer overflow
9     function safeAdd(uint a, uint b) public pure returns (uint c) {
10         c = a + b;
11         require(c >= a);
12     }
13     // @dev safe subtraction, reverts if integer underflow
14     function safeSub(uint a, uint b) public pure returns (uint c) {
15         require(b <= a);
16         c = a - b;
17     }
18     // @dev safe multiplication, reverts if integer overflow
19     function safeMul(uint a, uint b) public pure returns (uint c) {
20         c = a * b;
21         require(a == 0 || c / a == b);
22     }
23     // @dev safe division, revert on division by zero
24     function safeDiv(uint a, uint b) public pure returns (uint c) {
25         require(b > 0);
26         c = a / b;
27     }
28 }
29 
30 // @title ERC Token Standard #20 Interface
31 // @notice https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
32 // @dev ERC20 contract framework with default function definitions
33 contract ERC20Interface {
34     uint256 public totalSupply;
35 
36     function balanceOf(address _owner) public view returns (uint256 balance);
37     function transfer(address _to, uint256 _value) public returns (bool success);
38     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
39     function approve(address _spender, uint256 _value) public returns (bool success);
40     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
41 
42     event Transfer(address indexed _from, address indexed _to, uint256 _value);
43     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
44 }
45 
46 // @title Contract ownership functionality
47 // @notice based on OpenZeppelin Ownable.sol
48 contract Owned {
49     address public owner;
50     address public newOwner;
51 
52     event OwnershipTransferred(address indexed _from, address indexed _to);
53 
54     // @dev sets msg.sender to contract owner on initial deployment
55     constructor() public {
56         owner = msg.sender;
57     }
58 
59     // @dev modifier to check ownership before function execution
60     modifier onlyOwner {
61         require(msg.sender == owner);
62         _;
63     }
64 
65     // @notice transfer ownership from one address to another
66     // @param _newOwner The address of the new owner
67     // @dev can only be executed by contract owner
68     function transferOwnership(address _newOwner) public onlyOwner {
69         newOwner = _newOwner;
70     }
71 
72     // @notice function for new owner to accept contract ownership
73     // @dev reverts if called before transferOwnership
74     function acceptOwnership() public {
75         require(msg.sender == newOwner);
76         owner = newOwner;
77         newOwner = address(0);
78         emit OwnershipTransferred(owner, newOwner);
79     }
80 }
81 
82 // @title Alluva ERC20 Token
83 // @notice Inherits default interface, ownership and safe maths.
84 contract AlluvaToken is ERC20Interface, Owned, SafeMath {
85     address public owner = msg.sender;
86     string public symbol;
87     string public name;
88     uint8 public decimals;
89     uint public totalSupply;
90 
91     mapping(address => uint) balances;
92     mapping(address => mapping(address => uint)) allowed;
93 
94     // @dev Constructor function
95     constructor() public {
96         symbol = "ALV";
97         name = "Alluva";
98         decimals = 18;
99         totalSupply = 3000000000000000000000000000;
100         balances[owner] = totalSupply;
101         emit Transfer(address(0), owner, totalSupply);
102     }
103 
104     // @dev Returns the token balance for provided address
105     // @param _owner The address of token owner
106     // @return Balance of requested address
107     function balanceOf(address _owner) public view returns (uint balance) {
108         return balances[_owner];
109     }
110 
111     // @dev Transfer tokens from sender to another address
112     // @param _to Address of recipient
113     // @param _value Number of tokens to transfer (in smallest divisible unit)
114     // @return True if transaction was successful
115     function transfer(address _to, uint256 _value) public returns (bool success) {
116         require(_to != address(0));
117 
118         require(balances[msg.sender] >= _value);
119         balances[msg.sender] = safeSub(balances[msg.sender], _value);
120         balances[_to] = safeAdd(balances[_to], _value);
121         emit Transfer(msg.sender, _to, _value);
122         return true;
123     }
124 
125     // @dev Transfer _value tokens from address _from to address _to. Caller
126     // needs to be approved by _from, using approve method, prior to calling
127     // @param _from Address to transfer tokens from
128     // @param _to Address to transfer tokens to
129     // @param _value Number of tokens to transfer (in smallest divisible unit)
130     // @return True if transaction was successful
131     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
132         require(_to != address(0));
133 
134         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
135         balances[_from] = safeSub(balances[_from], _value);
136         balances[_to] = safeAdd(balances[_to], _value);
137         emit Transfer(_from, _to, _value);
138         return true;
139     }
140 
141     // @dev Approves _spender to transfer _value tokens from message sender address
142     // @notice Frontend/Client should set allowance to 0 prior to updating to
143     // prevent approve/transferFrom attack vector as described here:
144     // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145     // @param _spender Address to allocate spending limit to
146     // @param _value Number of tokens to allow spender (in smallest divisible unit)
147     // @return True if transaction was successful
148     function approve(address _spender, uint256 _value) public returns (bool success) {
149         require(_spender != address(0));
150 
151         allowed[msg.sender][_spender] = _value;
152         emit Approval(msg.sender, _spender, _value);
153         return true;
154     }
155 
156     // @dev Returns the number of tokens that can be transferred from _owner to
157     // _spender, set by approve method
158     // @param _owner Address of token owner
159     // @param _spender Address of approved spender
160     // @return Remaining approved spending
161     function allowance(address _owner, address _spender) public view returns (uint remaining) {
162         return allowed[_owner][_spender];
163     }
164 
165     // @dev Increase the amount of tokens that _spender can transfer from owner
166     // approve should be called when allowed[_spender] == 0. To increment
167     // allowed value use this function to avoid 2 calls (and wait until the
168     // first transaction is mined)
169     // From OpenZeppelin ERC20.sol
170     // Emits an Approval event
171     // @param _spender The address that is allowed to spend funds
172     // @param _addedValue The value to add to allowance
173     function increaseAllowance(address _spender, uint256 _addedValue) public returns (bool) {
174         require(_spender != address(0));
175 
176         allowed[msg.sender][_spender] = safeAdd(allowed[msg.sender][_spender], _addedValue);
177         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
178         return true;
179     }
180 
181     // @dev Decrease the amount of tokens that _spender can transfer from owner
182     // approve should be called when allowed[_spender] == 0. To decrease
183     // allowed value use this function to avoid 2 calls (and wait until the
184     // first transaction is mined)
185     // From OpenZeppelin ERC20.sol
186     // Emits an Approval event
187     // @param _spender The address that is allowed to spend funds
188     // @param _subtractedValue The value to subtract from allowance
189     function decreaseAllowance(address _spender, uint256 _subtractedValue) public returns (bool) {
190         require(_spender != address(0));
191 
192         allowed[msg.sender][_spender] = safeSub(allowed[msg.sender][_spender], _subtractedValue);
193         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
194         return true;
195     }
196 
197 
198     // @dev Fallback function to reject ether sent to contract
199     function () external payable {
200         revert();
201     }
202 
203     // @dev Allow contract owner to transfer other tokens sent to contract
204     // @param _tokenAddress contract address of token to transfer
205     // @param _tokens number of tokens to transfer
206     // @return True if transaction was successful
207     function transferAnyERC20Token(address _tokenAddress, uint _tokens) public onlyOwner returns (bool success) {
208         return ERC20Interface(_tokenAddress).transfer(owner, _tokens);
209     }
210 
211 }