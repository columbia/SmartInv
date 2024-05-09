1 pragma solidity ^0.4.24;  
2 
3 
4 library SafeMath {
5 	function mul(uint a, uint b) internal pure returns(uint) {  
6 		uint c = a * b;
7 		assert(a == 0 || c / a == b);
8 		return c;
9 	}
10 
11 	function div(uint a, uint b) internal pure returns(uint) { 
12 		uint c = a / b;
13 		return c; 
14 	}
15 
16 	function sub(uint a, uint b) internal pure returns(uint) {  
17 		assert(b <= a);
18 		return a - b;
19 	}
20 
21 	function add(uint a, uint b) internal pure returns(uint) {  
22 		uint c = a + b;
23 		assert(c >= a);
24 		return c;
25 	}
26 	function max64(uint64 a, uint64 b) internal pure  returns(uint64) { 
27 		return a >= b ? a : b;
28 	}
29 
30 	function min64(uint64 a, uint64 b) internal pure  returns(uint64) { 
31 		return a < b ? a : b;
32 	}
33 
34 	function max256(uint256 a, uint256 b) internal pure returns(uint256) { 
35 		return a >= b ? a : b;
36 	}
37 
38 	function min256(uint256 a, uint256 b) internal pure returns(uint256) {  
39 		return a < b ? a : b;
40 	}
41  
42 }
43 
44 contract ERC20Basic {
45 	uint public totalSupply;
46 	function balanceOf(address who) public constant returns(uint);  
47 	function transfer(address to, uint value) public;  
48 	event Transfer(address indexed from, address indexed to, uint value);
49 }
50 
51 
52 contract ERC20 is ERC20Basic {
53 	function allowance(address owner, address spender) public constant returns(uint);  
54 	function transferFrom(address from, address to, uint value) public;  
55 	function approve(address spender, uint value) public;  
56 	event Approval(address indexed owner, address indexed spender, uint value);
57 }
58 
59 /**
60  * @title TokenVesting
61  * @dev A contract can unlock token at designated time.
62  */
63 contract VT201811002  {
64   using SafeMath for uint256;
65   event Released(uint256 amounts);
66 event InvalidCaller(address caller);
67 
68    address public owner;
69 
70   address[] private _beneficiary ;
71   uint256 private _locktime;  
72   uint256 private _unlocktime;  
73   uint256[] private _amount;
74 
75   constructor() public
76   {
77     owner = msg.sender;
78      _unlocktime =0;
79   }
80   
81   
82    /*
83      * MODIFIERS
84      */
85 
86    modifier onlyOwner() {
87     require(msg.sender == owner);
88     _;
89   }
90 
91   /**
92    * @return the beneficiary of the tokens.
93    */
94   function beneficiary() public view returns(address[]) {
95     return _beneficiary;
96   }
97 
98   /**
99    * @return the unlocktime time of the token vesting.
100    */
101   function unlocktime() public view returns(uint256) {
102     return _unlocktime;
103   }
104     /**
105    * @return the locktime time of the token vesting.
106    */
107   function locktime() public view returns(uint256) {
108     return _locktime;
109   }
110   
111    /**
112    * @return the amount of the tokens.
113    */
114   function amount() public view returns(uint256[]) {
115     return _amount;
116   }
117   /**
118    * @notice Setting lock time.
119    */
120     function setLockTime(uint256  locktimeParam,uint256  unlocktimeParam) public onlyOwner{
121 	         _unlocktime = unlocktimeParam;
122 	        _locktime = locktimeParam;
123     } 
124  /**
125    * @notice Setting UserInfo.
126    */
127     function setUserInfo(address[] beneficiaryParam,uint256[]  amountParam) public onlyOwner{
128         if( block.timestamp <=_locktime){
129              _beneficiary = beneficiaryParam;
130 	         _amount = amountParam;
131         }
132     } 
133  
134 
135   /**
136    * @notice Transfers vested tokens to beneficiary.
137    * @param token ERC20 token which is being vested
138    */
139   function release(ERC20 token) public {
140        for(uint i = 0; i < _beneficiary.length; i++) {
141             if(block.timestamp >= _unlocktime ){
142                    token.transfer(_beneficiary[i], _amount[i].mul(10**18));
143                     emit Released( _amount[i]);
144                     _amount[i]=0;
145             }
146        }
147   } 
148   
149   
150   
151 
152   /**
153    * @notice Release the unexpected token.
154    * @param token ERC20 token which is being vested
155    */
156   
157     function checkRelease(ERC20 token) public {
158        uint _unRelease = 0;
159        
160         for(uint i = 0; i < _amount.length; i++) {
161             _unRelease = _unRelease.add(_amount[i]); 
162         }
163         if(_unRelease==0 && block.timestamp >= _unlocktime ){
164              token.transfer(owner,token.balanceOf(this));
165         }
166         
167   }
168 
169 }