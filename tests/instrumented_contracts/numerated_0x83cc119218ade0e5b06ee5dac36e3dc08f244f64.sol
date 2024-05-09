1 pragma solidity ^0.4.21;
2 
3 contract Erc20Token {
4 	uint256 public totalSupply; //Total amount of Erc20Token
5 	
6 	//Check balances
7     function balanceOf(address _owner) public constant returns (uint256 balance);
8     
9 	/**
10      * Transfer tokens
11      *
12      * Send `_value` tokens to `_to` from your account
13      *
14      * @param _to The address of the recipient
15      * @param _value the amount to send
16      */
17     function transfer(address _to, uint256 _value) public returns (bool success);
18     
19     /**
20      * Transfer tokens from other address
21      *
22      * Send `_value` tokens to `_to` on behalf of `_from`
23      *
24      * @param _from The address of the sender
25      * @param _to The address of the recipient
26      * @param _value the amount to send
27      */
28     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
29 
30     /**
31      * Set allowance for other address
32      *
33      * Allows `_spender` to spend no more than `_value` tokens on your behalf
34      *
35      * @param _spender The address authorized to spend
36      * @param _value the max amount they can spend
37      */
38     function approve(address _spender, uint256 _value) public returns (bool success);
39 	
40     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
41 
42 
43     event Transfer(address indexed _from, address indexed _to, uint256 _value);
44 
45     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46 }
47 
48 //Contract manager
49 contract ownerYHT {
50     address public owner;
51 
52     function ownerYHT() public{
53         owner = msg.sender;
54     }
55 
56     modifier onlyOwner {
57         require (msg.sender == owner);
58         _;
59     }
60 	
61     function transferOwner(address newOwner) onlyOwner public {
62         owner = newOwner;
63     }
64 }
65 
66 //knifeOption
67 contract KEO is ownerYHT,Erc20Token {
68     string public name= 'KEO'; 
69     string public symbol = 'KEO'; 
70     uint8 public decimals = 0;
71 	
72 	uint256 public moneyTotal = 60000000;//Total amount of Erc20Token
73 	uint256 public moneyFreeze = 20000000; 
74 	
75 	mapping (address => uint256) balances;
76     mapping (address => mapping (address => uint256)) allowed;
77 	
78 	/**
79      * Constructor function
80      *
81      * Initializes contract with initial supply tokens to the creator of the contract
82      */
83     function KEO() public {
84         totalSupply = (moneyTotal - moneyFreeze) * 10 ** uint256(decimals);
85 
86         balances[msg.sender] = totalSupply;
87     }
88 	
89 	
90     function transfer(address _to, uint256 _value) public returns (bool success){
91         _transfer(msg.sender, _to, _value);
92 		return true;
93     }
94 	
95 	/**
96 	 * Send tokens to another account from a specified account
97      * The calling process will check the set maximum allowable transaction amount
98 	 * 
99 	 */
100     function transferFrom(address _from, address _to, uint256 _value)  public returns (bool success){
101         
102         require(_value <= allowed[_from][msg.sender]);   // Check allowed
103         allowed[_from][msg.sender] -= _value;
104         _transfer(_from, _to, _value);
105         return true;
106     }
107 	
108 	function balanceOf(address _owner) public constant returns (uint256) {
109         return balances[_owner];
110     }
111 	
112 	//Set the maximum amount allowed for the account
113     function approve(address _spender, uint256 _value) public returns (bool) {
114         allowed[msg.sender][_spender] = _value;
115         return true;
116     }
117 	
118 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
119         return allowed[_owner][_spender];
120     }
121 
122     //private
123     function _transfer(address _from, address _to, uint256 _value) internal {
124 
125 		require(_to != 0x0);
126 
127 		require(balances[_from] >= _value);
128 
129 		require(balances[_to] + _value > balances[_to]);
130 
131 		uint previousBalances = balances[_from] + balances[_to];
132 
133 		balances[_from] -= _value;
134 
135 		balances[_to] += _value;
136 
137 		emit Transfer(_from, _to, _value);
138 
139 		assert(balances[_from] + balances[_to] == previousBalances);
140 
141     }
142     
143 	/**
144 	 *Thawing frozen money
145 	 *Note: The value unit here is the unit before the 18th power 
146 	 *that hasn't been multiplied by 10, that is, the same unit as 
147 	 * the money whose initial definition was frozen.
148 	 */
149 	event EventUnLockFreeze(address indexed from,uint256 value);
150     function unLockFreeze(uint256 _value) onlyOwner public {
151         require(_value <= moneyFreeze);
152         
153 		moneyFreeze -= _value;
154 		
155 		balances[msg.sender] += _value * 10 ** uint256(decimals);
156 		
157 		emit EventUnLockFreeze(msg.sender,_value);
158     }
159 }