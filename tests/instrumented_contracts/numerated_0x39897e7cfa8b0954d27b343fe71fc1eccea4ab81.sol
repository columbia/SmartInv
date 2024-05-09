1 pragma solidity ^0.4.18;
2 
3 /*
4  * ERC223 interface
5  * see https://github.com/ethereum/EIPs/issues/20
6  * see https://github.com/ethereum/EIPs/issues/223
7  */
8 contract ERC223 {
9     function totalSupply() constant public returns (uint256 outTotalSupply);
10     function balanceOf( address _owner) constant public returns (uint256 balance);
11     function transfer( address _to, uint256 _value) public returns (bool success);
12     function transfer( address _to, uint256 _value, bytes _data) public returns (bool success);
13     function transferFrom( address _from, address _to, uint256 _value) public returns (bool success);
14     function approve( address _spender, uint256 _value) public returns (bool success);
15     function allowance( address _owner, address _spender) constant public returns (uint256 remaining);
16     event Transfer( address indexed _from, address indexed _to, uint _value, bytes _data);
17     event Approval( address indexed _owner, address indexed _spender, uint256 _value);
18 }
19 
20 
21 contract ERC223Receiver { 
22     /**
23      * @dev Standard ERC223 function that will handle incoming token transfers.
24      *
25      * @param _from  Token sender address.
26      * @param _value Amount of tokens.
27      * @param _data  Transaction metadata.
28      */
29     function tokenFallback(address _from, uint _value, bytes _data) public;
30 }
31 
32 
33 
34 
35 /// @title A base contract to control ownership
36 /// @author cuilichen
37 contract OwnerBase {
38 
39     // The addresses of the accounts that can execute actions within each roles.
40     address public ceoAddress;
41     address public cfoAddress;
42     address public cooAddress;
43 
44     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
45     bool public paused = false;
46     
47     /// constructor
48     function OwnerBase() public {
49        ceoAddress = msg.sender;
50        cfoAddress = msg.sender;
51        cooAddress = msg.sender;
52     }
53 
54     /// @dev Access modifier for CEO-only functionality
55     modifier onlyCEO() {
56         require(msg.sender == ceoAddress);
57         _;
58     }
59 
60     /// @dev Access modifier for CFO-only functionality
61     modifier onlyCFO() {
62         require(msg.sender == cfoAddress);
63         _;
64     }
65     
66     /// @dev Access modifier for COO-only functionality
67     modifier onlyCOO() {
68         require(msg.sender == cooAddress);
69         _;
70     }
71 
72     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
73     /// @param _newCEO The address of the new CEO
74     function setCEO(address _newCEO) external onlyCEO {
75         require(_newCEO != address(0));
76 
77         ceoAddress = _newCEO;
78     }
79 
80 
81     /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
82     /// @param _newCFO The address of the new COO
83     function setCFO(address _newCFO) external onlyCEO {
84         require(_newCFO != address(0));
85 
86         cfoAddress = _newCFO;
87     }
88     
89     /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
90     /// @param _newCOO The address of the new COO
91     function setCOO(address _newCOO) external onlyCEO {
92         require(_newCOO != address(0));
93 
94         cooAddress = _newCOO;
95     }
96 
97     /// @dev Modifier to allow actions only when the contract IS NOT paused
98     modifier whenNotPaused() {
99         require(!paused);
100         _;
101     }
102 
103     /// @dev Modifier to allow actions only when the contract IS paused
104     modifier whenPaused {
105         require(paused);
106         _;
107     }
108 
109     /// @dev Called by any "C-level" role to pause the contract. Used only when
110     ///  a bug or exploit is detected and we need to limit damage.
111     function pause() external onlyCOO whenNotPaused {
112         paused = true;
113     }
114 
115     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
116     ///  one reason we may pause the contract is when CFO or COO accounts are
117     ///  compromised.
118     /// @notice This is public rather than external so it can be called by
119     ///  derived contracts.
120     function unpause() public onlyCOO whenPaused {
121         // can't unpause if contract was upgraded
122         paused = false;
123     }
124 }
125 
126 
127 
128 /**
129  * Standard ERC223 receiver
130  */
131 contract RechargeMain is ERC223Receiver, OwnerBase {
132 
133 	event EvtCoinSetted(address coinContract);
134     
135 	event EvtRecharge(address customer, uint amount);
136 
137 	
138 	ERC223 public coinContract;
139 	
140 	
141     function RechargeMain(address coin) public {
142 		// the creator of the contract is the initial CEO
143         ceoAddress = msg.sender;
144         cooAddress = msg.sender;
145         cfoAddress = msg.sender;
146 		
147 		coinContract = ERC223(coin);
148     }
149 
150     /**
151      * Owner can update base information here.
152      */
153     function setCoinInfo(address coin) public {
154         require(msg.sender == ceoAddress || msg.sender == cooAddress);
155 		
156 		coinContract = ERC223(coin);
157 		
158         emit EvtCoinSetted(coinContract);
159     }
160 	
161 	/// @dev receive token from coinContract
162 	function tokenFallback(address _from, uint _value, bytes ) public {
163 		require(msg.sender == address(coinContract));
164 		emit EvtRecharge(_from, _value);
165 	}
166     
167 	
168     function () public payable {
169         //fallback
170     }
171     
172     
173     /// transfer dead tokens to contract master
174     function withdrawTokens() external {
175 		address myself = address(this);
176         uint256 fundNow = coinContract.balanceOf(myself);
177         coinContract.transfer(cfoAddress, fundNow);//token
178         
179         uint256 balance = myself.balance;
180         cfoAddress.transfer(balance);//eth
181     }
182     
183 
184 }