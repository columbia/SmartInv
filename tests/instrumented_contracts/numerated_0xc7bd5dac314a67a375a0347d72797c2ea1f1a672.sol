1 pragma solidity ^0.4.17;
2 //Zep
3 interface IERC20 {
4     /**
5      * @dev Returns the amount of tokens in existence.
6      */
7     function totalSupply() external view returns (uint256);
8 
9     /**
10      * @dev Returns the amount of tokens owned by `account`.
11      */
12     function balanceOf(address account) external view returns (uint256);
13 
14     /**
15      * @dev Moves `amount` tokens from the caller's account to `recipient`.
16      *
17      * Returns a boolean value indicating whether the operation succeeded.
18      *
19      * Emits a {Transfer} event.
20      */
21     function transfer(address recipient, uint256 amount) external returns (bool);
22 
23     /**
24      * @dev Returns the remaining number of tokens that `spender` will be
25      * allowed to spend on behalf of `owner` through {transferFrom}. This is
26      * zero by default.
27      *
28      * This value changes when {approve} or {transferFrom} are called.
29      */
30     function allowance(address owner, address spender) external view returns (uint256);
31 
32     /**
33      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
34      *
35      * Returns a boolean value indicating whether the operation succeeded.
36      *
37      * IMPORTANT: Beware that changing an allowance with this method brings the risk
38      * that someone may use both the old and the new allowance by unfortunate
39      * transaction ordering. One possible solution to mitigate this race
40      * condition is to first reduce the spender's allowance to 0 and set the
41      * desired value afterwards:
42      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
43      *
44      * Emits an {Approval} event.
45      */
46     function approve(address spender, uint256 amount) external returns (bool);
47 
48     /**
49      * @dev Moves `amount` tokens from `sender` to `recipient` using the
50      * allowance mechanism. `amount` is then deducted from the caller's
51      * allowance.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * Emits a {Transfer} event.
56      */
57     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Emitted when `value` tokens are moved from one account (`from`) to
61      * another (`to`).
62      *
63      * Note that `value` may be zero.
64      */
65     event Transfer(address indexed from, address indexed to, uint256 value);
66 
67     /**
68      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
69      * a call to {approve}. `value` is the new allowance.
70      */
71     event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 
75 
76 
77 contract KlownGasDrop {
78 
79 
80 //receivers
81     mapping(address => bool) public receivers;
82 // token balances
83     mapping ( address => uint256 ) public balances;
84 	//amount per receiver (with decimals)
85 	uint256 amountToClaim = 50000000;
86 	uint256 public totalSent = 0;
87 	
88 	address  _owner;
89 	address  whoSent;
90 	uint256 dappBalance;
91 
92 //debugging breakpoints, quick and easy 
93     uint public brpt = 0;
94     uint public brpt1 = 0;
95 
96     IERC20 currentToken ;
97 
98 
99 //modifiers	
100 	modifier onlyOwner() {
101       require(msg.sender == _owner);
102       _;
103   }
104     /// Create new - constructor
105      function  KlownGasDrop() public {
106 		_owner = msg.sender;
107 		dappBalance = 0;
108     }
109 
110 //address of token contract, not token sender!    
111 	address currentTokenAddress = 0xc97a5cdf41bafd51c8dbe82270097e704d748b92;
112 
113 
114     //deposit
115       function deposit(uint tokens) public onlyOwner {
116 
117 
118     // add the deposited tokens into existing balance 
119     balances[msg.sender]+= tokens;
120 
121     // transfer the tokens from the sender to this contract
122     IERC20(currentTokenAddress).transferFrom(msg.sender, address(this), tokens);
123     whoSent = msg.sender;
124     
125   }
126 
127 function hasReceived(address received)  internal  view returns(bool)
128 {
129     bool result = false;
130     if(receivers[received] == true)
131         result = true;
132     
133     return result;
134 }
135 
136 uint256 temp = 0;
137  /// claim gas drop amount (only once per address)
138     function claimGasDrop() public returns(bool) {
139 
140 
141 
142 		//have they already receivered?
143         if(receivers[msg.sender] != true)
144 	    {
145 
146     	    //brpt = 1;
147     		if(amountToClaim <= balances[whoSent])
148     		{
149     		    //brpt = 2; 
150     		    balances[whoSent] -= amountToClaim;
151     			//brpt = 3;
152     			IERC20(currentTokenAddress).transfer(msg.sender, amountToClaim);
153     			
154     			receivers[msg.sender] = true;
155     			totalSent += amountToClaim;
156     			
157     			//brpt = 4;
158     			
159     			
160     		}
161 
162 	    }
163 		
164 
165 	   
166     }
167 
168 
169  //which currentToken is used here?
170   function setCurrentToken(address currentTokenContract) external onlyOwner {
171         currentTokenAddress = currentTokenContract;
172         currentToken = IERC20(currentTokenContract);
173         dappBalance = currentToken.balanceOf(address(this));
174       
175   }
176 
177 
178 
179  //set amount per gas claim (amount each address will receive)
180   function setGasClaim(uint256 amount) external onlyOwner {
181     
182       amountToClaim = amount;
183       
184   }
185 //get amount per gas claim (amount each address will receive)
186   function getGasClaimAmount()  public view returns (uint256)  {
187     
188       return amountToClaim;
189       
190   }
191   
192   
193 
194 
195 }