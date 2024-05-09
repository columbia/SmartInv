1 pragma solidity ^0.4.24;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipRenounced(address indexed previousOwner);
8   event OwnershipTransferred(
9     address indexed previousOwner,
10     address indexed newOwner
11   );
12 
13 
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   constructor() public {
19     owner = msg.sender;
20   }
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30   /**
31    * @dev Allows the current owner to relinquish control of the contract.
32    */
33   function renounceOwnership() public onlyOwner {
34     emit OwnershipRenounced(owner);
35     owner = address(0);
36   }
37 
38   /**
39    * @dev Allows the current owner to transfer control of the contract to a newOwner.
40    * @param _newOwner The address to transfer ownership to.
41    */
42   function transferOwnership(address _newOwner) public onlyOwner {
43     _transferOwnership(_newOwner);
44   }
45 
46   /**
47    * @dev Transfers control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function _transferOwnership(address _newOwner) internal {
51     require(_newOwner != address(0));
52     emit OwnershipTransferred(owner, _newOwner);
53     owner = _newOwner;
54   }
55 }
56 
57 contract Tokenlock is Ownable {
58     using SafeERC20 for ERC20;
59 
60     event LockStarted(uint256 now, uint256 interval);
61     event TokenLocked(address indexed buyer, uint256 amount);
62     event TokenReleased(address indexed buyer, uint256 amount);
63 
64     mapping (address => uint256) public buyers;
65 
66     address public locker;
67     address public distributor;
68 
69     ERC20 public Token;
70 
71     bool public started = false;
72 
73     uint256 public interval;
74     uint256 public releaseTime;
75 
76     constructor(address token, uint256 time) public {
77         require(token != address(0));
78         Token = ERC20(token);
79         interval = time;
80 
81         locker = owner;
82         distributor = owner;
83     }
84 
85     function setLocker(address addr)
86         external
87         onlyOwner
88     {
89         require(addr != address(0));
90         locker = addr;
91     }
92 
93     function setDistributor(address addr)
94         external
95         onlyOwner
96     {
97         require(addr != address(0));
98         distributor = addr;
99     }
100 
101     // lock tokens
102     function lock(address beneficiary, uint256 amount)
103         external
104     {
105         require(msg.sender == locker);
106         require(beneficiary != address(0));
107         buyers[beneficiary] += amount;
108         emit TokenLocked(beneficiary, buyers[beneficiary]);
109     }
110 
111     // start timer
112     function start()
113         external
114         onlyOwner
115     {
116         require(!started);
117         started = true;
118         releaseTime = block.timestamp + interval;
119         emit LockStarted(block.timestamp, interval);
120     }
121 
122     // release locked tokens
123     function release(address beneficiary)
124         external
125     {
126         require(msg.sender == distributor);
127         require(started);
128         require(block.timestamp >= releaseTime);
129 
130         // prevent reentrancy
131         uint256 amount = buyers[beneficiary];
132         buyers[beneficiary] = 0;
133 
134         Token.safeTransfer(beneficiary, amount);
135         emit TokenReleased(beneficiary, amount);
136     }
137 
138     function withdraw() public onlyOwner {
139         require(block.timestamp >= releaseTime);
140         Token.safeTransfer(owner, Token.balanceOf(address(this)));
141     }
142 
143     function close() external onlyOwner {
144         withdraw();
145         selfdestruct(owner);
146     }
147 }
148 
149 contract ERC20Basic {
150   function totalSupply() public view returns (uint256);
151   function balanceOf(address who) public view returns (uint256);
152   function transfer(address to, uint256 value) public returns (bool);
153   event Transfer(address indexed from, address indexed to, uint256 value);
154 }
155 
156 contract ERC20 is ERC20Basic {
157   function allowance(address owner, address spender)
158     public view returns (uint256);
159 
160   function transferFrom(address from, address to, uint256 value)
161     public returns (bool);
162 
163   function approve(address spender, uint256 value) public returns (bool);
164   event Approval(
165     address indexed owner,
166     address indexed spender,
167     uint256 value
168   );
169 }
170 
171 library SafeERC20 {
172   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
173     require(token.transfer(to, value));
174   }
175 
176   function safeTransferFrom(
177     ERC20 token,
178     address from,
179     address to,
180     uint256 value
181   )
182     internal
183   {
184     require(token.transferFrom(from, to, value));
185   }
186 
187   function safeApprove(ERC20 token, address spender, uint256 value) internal {
188     require(token.approve(spender, value));
189   }
190 }